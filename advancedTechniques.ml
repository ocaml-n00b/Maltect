
(* General  *)

(* Desc: Calculate the mean of the values in a float array.
   flaot array -> float -> float *)
let meanArr arr n = (Array.fold_left (+.) 0. arr)/. n;;
(* Desc: Calculate the Standard Deviation of the values in an array.
   float array -> float -> float -> float *)
let sdArr arr mu n = 
  let numa = Array.map (fun xi -> (xi-.mu)**2. ) arr in
  let sum  = Array.fold_left (+.) 0. numa in
  sqrt((sum)/.n);;

(* Desc: The Negative Log Likelihood cost function
    float array -> float -> float -> float -> float
   *)
let negativeLogLikelihood y mu s n =
  let insum = let den = 2.*. s**2. in 
    Array.map (fun yi -> ((yi-.mu)**2.)/.den ) y in
    let suma = Array.fold_left (+.) 0. insum in
    n*.(log10(s) +. 0.3990899342) +. suma;;

(* Desc: Scwartz Information Criterion penalty function. Used to avoid over fitting *)
let sicPenalty p n m =
  p*.log10(float_of_int n)*.(float_of_int m);;

(* Desc: Split an array into a list of array given a list of location to break the array.
   Test: getSegments [| 0;1;2;3;4;5;6;7;8;9|] [3;7] 10
          Result => [[|0;1;2|];[|3;4;5;6|];[|7;8;9|]]
*)
let getSegments arr tau n =
  let rec aux acc pre = function
    | [] -> [arr]
    | hd::[] -> List.rev ((Array.sub arr hd (n-hd))::(Array.sub arr pre (hd-pre))::acc)
    | hd::tl -> aux ((Array.sub arr pre (hd-pre))::acc) hd tl (* should be hd+1;hd+2? *)
  in aux [] 0 tau;; 

(* Desc: Fit the error of a vector using the negative log likelihood. *)
let fitError arr =
    let n= float_of_int(Array.length arr) in
    let mean = meanArr arr n in
    let sd = sdArr arr mean n in
    2.*.( negativeLogLikelihood arr mean sd n );;

(* VERSION 2 - may be faster than v3. TODO: verify perfamace vs v3
   Desc: Fit the error of a list of segements (arrays). Twice the negative log likelihood is
    used as the cost functio and no penalty is used. Must be applied externally.
   float array list -> float
    TODO: abstract the cost function. Optionally add a penalty function as input.
*)
let fitListError lst =
  let rec aux error = function
    | [] -> error
    | hd::tl -> aux (error+.(fitError hd)) tl
  in aux 0. lst;;

(* VERSION 3 - more organized
   Desc: Fit the error of a list of segements (arrays). Twice the negative log likelihood is
    used as the cost functio and no penalty is used. Must be applied externally.
   float array list -> float
    TODO: abstract the cost function. Optionally add a penalty function as input.
*)
let fitListError_v3 lst =
  let fit = List.map (fitError) lst in
  List.fold_left (+.) 0. fit;;

(* VERSION 3 -> Abstracting
  Desc: Use the binary segmentation algorithm to partition a vector and get
         list of tuples with the mean value of the segment and its length.
  Input:
    y:        The time series (An array of floats)
    costFun:  The cost function to be executed, must take an array of floats
    betaFun:  The penalty function, must take an integer (depth of segment)
*)
let binarySegmentation y costFun betaFun =
  let n = Array.length y in 
  let firstChnk = costFun y in

  let rec aux arr n costChnk sB l_i =
    let beta = betaFun(sB) in
    let nf = float_of_int n in
    let rec exhaust i cost_1 i_1 =
      if i >= n then (
        let costL, costR = (costFun (Array.sub arr 0 i_1) ), (costFun (Array.sub arr i_1 (n-i_1)) ) in
        if cost_1 < costChnk then 
          (aux (Array.sub arr 0 i_1) i_1 costL (sB+1) (l_i) )@(
           aux (Array.sub arr i_1 (n-i_1)) (n-i_1) costR (sB+1) (l_i+i_1)) 
        else [(n,meanArr arr nf)]) (* change l_i for n *)
      else 
        let costL, costR = (costFun (Array.sub arr 0 i) ), (costFun (Array.sub arr i (n-i)) ) in
        let cost = costL +. costR +. beta in
        let nCost, ni = (if cost < cost_1 then (cost,i) else (cost_1,i_1)) in
        exhaust (i+1) nCost ni
    in exhaust 1 costChnk 0 
  in aux y n firstChnk 0 0 ;;

(* VERSION 2 -> Refactoring
  Desc: Use the binary segmentation algorithm to partition a vector and get
         list of tuples with the mean value of the segment and its length. *)
let binarySegmentation_v2 y =
  let n = Array.length y in 
  let firstChnk = fitError y in
  let betaFun = (sicPenalty 1. n) in

  let rec aux arr n costChnk sB l_i =
    let beta = betaFun(sB) in
    
    let rec exhaust i cost_1 i_1 =
      if i >= n then (
        let costL, costR = (fitError (Array.sub arr 0 i_1) ), (fitError (Array.sub arr i_1 (n-i_1)) ) in
        if cost_1 < costChnk then 
          (aux (Array.sub arr 0 i_1) i_1 costL (sB+1) (l_i) )@(
           aux (Array.sub arr i_1 (n-i_1)) (n-i_1) costR (sB+1) (l_i+i_1)) 
        else [(l_i,meanArr arr (float_of_int n))]) 
      else 
        let costL, costR = (fitError (Array.sub arr 0 i) ), (fitError (Array.sub arr i (n-i)) ) in
        let cost = costL +. costR +. beta in
        let nCost, ni = (if cost < cost_1 then (cost,i) else (cost_1,i_1)) in
        exhaust (i+1) nCost ni
    in exhaust 1 costChnk 0 
  in aux y n firstChnk 0 0 ;;

(* Desc: Calculate the change in magnitude of the values in a list of floats *)
let difList lst =
   let rec aux acc = function  
      | [] -> []
      | hd::[] -> List.rev acc
      | hd1::hd2::tl -> aux ((hd2-.hd1)::acc) (hd2::tl)
   in aux [] lst;;

(* Desc: Get the position of the maximum value in a list.
   Error on empty list. *)
let maxPos lst =
   let head::tail = lst in
   let rec aux max n i = function
      | [] -> n
      | hd::[] -> if hd > max then i else n
      | hd::tl -> if hd > max then aux hd i (i+1) tl else aux max n (i+1) tl
   in aux head 0 1 tail;;
   

(* Desc: Mean Change Point Feature Extraction 
   Result: An array of features => [|maxJumpSize; minJumpSize; maxLongestRunPct; 
            meanRunLength; stableProp; entropyRuns; meanLongestRun; |] *)
let meanChangePoint segLst = 
   let features = Array.make 5 0.0 in
   let (length,localMean) = List.split segLst in
   let dif = difList localMean in
   Array.set features 0 (List.fold_left (max) neg_infinity dif);
   Array.set features 1 (List.fold_left (min) infinity dif);
   let totalLength = List.fold_left (+) 0 length in
   let maxLength = List.fold_left (max) 0 length in
   Array.set features 2 ((float_of_int maxLength)/. (float_of_int totalLength)) ;
   Array.set features 3 (List.nth localMean (maxPos length));
   Array.set features 4 (float_of_int (List.length segLst));
   features;;


(* Desc: Internal Funtion. Calculates the iner sum of the naive DFT *)
let complexInSum n a kf nF=
  let num = {Complex.re=0.; im=(-6.283185307) } in
  let num2 = {Complex.re=((float_of_int n)*.kf); im=0. } in
  let a = {Complex.re=a; im=0. } in
  let nF = {Complex.re=nF; im=0. } in
  Complex.mul a (Complex.exp (Complex.mul (Complex.div num nF) num2) );;

(* Get the normalized Fourier Transform of a time series, array of floats. 
   Test: discreteFourierTransform [|1.;2.;3.;4.|];;
         => [|2.5; 1.41421356243658836; 1.; 1.41421356218261374|]
   Test: discreteFourierTransform [|12.|];;
         => [|12.|]
*)
let discreteFourierTransform timeSeries = 
  let nN = Array.length timeSeries in
  let nF = float_of_int nN in
  let ft = Array.make nN ({Complex.re=0.; im=0.}) in
  for k = 0 to (nN - 1) do
    let xk =
    let kf = float_of_int k in
    let inSum = Array.mapi (fun n a -> complexInSum n a kf nF) timeSeries in
    Array.fold_left (Complex.add) ({Complex.re=0.; im=0.}) inSum in
    Array.set ft k xk
  done;
  let result = Array.map (fun a -> (2.*.(Complex.norm a)/. nF) ) ft in
  Array.set result 0 (result.(0) /. 2.);
  result;;

(* Desc: Extract magnitude and proportion features for up to nH harmonics 
         from an array of floats. 
         Test: fourierFeatures [|2.5; 1.41421356243658836; 1.; 1.41421356218261374|] 4;;
         =>[|2.5; 1.41421356243658836; 1.; 1.41421356218261374; 0.565685424974635365; 0.4;   0.565685424873045517|]
*)
let fourierFeatures arr nH =
   let wArr = Array.sub arr 0 nH in
   let feats = Array.make (nH*2 -1) 0. in
   Array.iteri (fun i a -> Array.set feats i a) wArr;
   let fund = wArr.(0) in
   Array.iteri (fun i a -> if i>0 then Array.set feats (i+nH-1) (a/.fund) ) wArr;
   feats;;
   

(* General TODO:
    Maybe change module name to structureAnalysis
  Mean Change Point Modeling 
TODO: Pruned Exact Linear Time algorithm
      Feature Extraction: 
        meanRunLength
        stableProp
        entropyRuns

*)
