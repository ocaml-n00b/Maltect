let coef = [-1.832496; 0.004345; 0.239225; -0.127015; -0.043437; 0.48902; -0.148374;        -0.021857; 0.102393; 0.046427; -0.153173; -0.046697; 0.005913] ;;

(* Desc: Given the coefficients and variable values of a linear equation
         output a prediction.  *)
let predictLinear coef calc =
   let intercept::coef = coef in
   let prodLst = List.map2 ( *. ) coeff calc in
   List.fold_left (+.) intercept prodLst;;
   
   
(* Move to advancedTechniques.ml
   Desc: 
*)
let singleFileMCPFetures fname blockSize = 
   let entLst = 
   let freqLst = blockingByteCount fname blockSize in
   List.rev (mleList freqLst blockSize) in
   let binSeg =
   let timeSeries = Array.of_list entLst in
   let n = Array.length timeSeries in
   binarySegmentation timeSeries fitError (sicPenalty 1. n) in
   meanChangePoint binSeg;;
   
   
(* Desc: Return a prediction value  *)
let singleFilePredict fname coef blockSize =
   let basic = autoSingleFile fname blockSize in
   let adv = singleFileMCPFetures fname blockSize in
   predictLinear coef (basic@(Array.to_list adv));;
   
   
(* VERSION 2 - Faster (~30% less time) because it opens the file once (instead of 3 times)
   Desc: Return a prediction value *)
let singleFilePredict_v2 fname coef blockSize = 
   let entLst = 
   let freqLst = blockingByteCount fname blockSize in
   List.rev (mleList freqLst blockSize) in
   let binSeg =
   let timeSeries = Array.of_list entLst in
   let n = Array.length timeSeries in
   binarySegmentation timeSeries fitError (sicPenalty 1. n) in
   let basicF = entropyStat entLst in
   
   let fileEnt = List.fold_left (fun a b -> 
   Array.mapi (fun i c -> c +. b.(i)) a) (Array.make 256 0.) freqLst in
   let nf = int_of_float (Array.fold_left (+.) 0. fileEnt) in
   let vars = (maxLikelihoodEstimator fileEnt nf)::(basicF@(Array.to_list (meanChangePoint binSeg))) in
   predictLinear coef vars;;;;
   
(* Desc: Get a Files entropy value using the frequency list *)
let bcaFileEntropy freqLst = 
   let singFreq = List.fold_left (fun a b -> 
   Array.mapi (fun i c -> c +. b.(i)) a) (Array.make 256 0.) freqLst in
   let nf = int_of_float (Array.fold_left (+.) 0. singFreq) in
   (maxLikelihoodEstimator singFreq nf);;
   
(* Desc: Returns the Mean Change Point features from the block entropy
      list of the file *)
let quickMCP entLst =
   let binSeg =
   let timeSeries = Array.of_list entLst in
   let n = Array.length timeSeries in
   binarySegmentation timeSeries fitError (sicPenalty 1. n) in
   Array.to_list (meanChangePoint binSeg);;

(* VERSION 3 - More Orginized (~5% slower than VERSION 2)
   Desc: Return a prediction value *)
let singleFilePredict_v3 fname coef blockSize = 
   let entLst =
   let freqLst = blockingByteCount fname blockSize in
   List.rev (mleList freqLst blockSize) in
   let fileEnt = bcaFileEntropy freqLst in
   let stats = entropyStat entLst in
   let mCP = quickMCP entLst in
   let vars = fileEnt::(stats@mCP) in
   predictLinear coef vars;;
   
   
   
   
