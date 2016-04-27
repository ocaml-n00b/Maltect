let coef = 
[-1.832496; 0.004345; 0.239225; -0.127015; -0.043437; 0.48902; -0.148374; -0.021857; 0.102393; 0.046427; -0.153173; -0.046697; 0.005913] ;;
let coefA =
[0.429788;0.032918;-0.066847;0.022097;-0.001307;0.050191;-0.072344;0.101327;0.048499;-0.010398;0.013039;-0.012120;0.005003;0.026810;-0.047564;-0.370199;0.504722;0.042583;-0.089875;0.302612;-1.681410;-0.221647;0.477668;-0.036321];;

(* Desc: Given the coefficients and variable values of a linear equation
         output a prediction.  *)
let predictLinear coef calc =
   let intercept::coef = coef in
   let prodLst = List.map2 ( *. ) coef calc in
   List.fold_left (+.) intercept prodLst;;
   
(* Move to advancedTechniques.ml
   Desc: Get the Mean Change Point Fetures of a file.
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
   
   
(* 
   Desc: Return a prediction value *)
let singleFilePredict_simple fname coef blockSize = 
   let freqLst = blockingByteCount fname blockSize in
   let fileEnt = List.fold_left (fun a b -> 
   Array.mapi (fun i c -> c +. b.(i)) a) (Array.make 256 0.) freqLst in
   
   let entLst = List.rev (mleList freqLst blockSize) in
   let binSeg =
   let timeSeries = Array.of_list entLst in
   let n = Array.length timeSeries in
   binarySegmentation timeSeries fitError (sicPenalty 1. n) in
   let basicF = entropyStat entLst in
   
   let nf = int_of_float (Array.fold_left (+.) 0. fileEnt) in
   let vars = (maxLikelihoodEstimator fileEnt nf)::(basicF@(Array.to_list (meanChangePoint binSeg))) in
   predictLinear coef vars;;
   
(* Desc: Get a Files entropy value using the frequency list *)
let bcaFileEntropy freqLst = 
   let singFreq = List.fold_left (fun a b -> 
   Array.mapi (fun i c -> c +. b.(i)) a) (Array.make 256 0.) freqLst in
   let nf = int_of_float (Array.fold_left (+.) 0. singFreq) in
   (maxLikelihoodEstimator singFreq nf);;
   
(* Desc: Returns the Mean Change Point features from the block entropy
      list of the file *)
let quickMCP timeSeries =
   let binSeg =
   let n = Array.length timeSeries in
   binarySegmentation timeSeries fitError (sicPenalty 1. n) in
   Array.to_list (meanChangePoint binSeg);;

(* Desc: Classify a file as a virus or not. Compare to >0.5 for binary response. *)
let singleFilePredict fname coef blockSize = 
   let freqLst = (blockingByteCount fname blockSize) in
   let entLst = List.rev (mleList freqLst blockSize) in
   let fileEnt = bcaFileEntropy freqLst in
   let stats = entropyStat entLst in
   let timeSeries = Array.of_list entLst in
   let mCP = quickMCP timeSeries in
   let vars = fileEnt::(stats@mCP) in
   let alpha = detrendedFluctuationAnalysis timeSeries in
   let fFT = let dFT = discreteFourierTransform timeSeries in
      fourierFeatures dFT 5 in
   predictLinear coef (vars@[alpha]@(Array.to_list fFT));;   
   
   
