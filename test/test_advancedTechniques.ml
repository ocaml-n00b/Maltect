#use test_Entropy_cases.ml;;
let timeSeries = Array.of_list entLstT;; (* timeSeries of test.tst = entLstT *)


let tstArr = [|4.; 6.; 12.; 1.; 3.|];;

let mean = meanArr tstArr 5. ;;
assert(mean = 5.2);;

let sd = sdArr tstArr mean 5. ;;
assert(sd = 3.7629775444453557);;

let nLL = negativeLogLikelihood tstArr mean sd 5. in
assert( nLL = 7.37310780438437519 );;

let sPen = sicPenalty 2. 4 7 in
assert (sPen = 8.42883987859147332);;

let segs = getSegments [| 0;1;2;3;4;5;6;7;8;9|] [3;7] 10 in
assert(segs = [[|0;1;2|];[|3;4;5;6|];[|7;8;9|]]);;

let fErr= fitError tstArr in
assert(fErr = 14.7462156087687504);;

let bSeg = let n = Array.length timeSeries in
   binarySegmentation timeSeries fitError (sicPenalty 1. n);;
assert(bSeg = [(9, 5.1289653638175281); (6, 4.85821775604702122); (21, 4.0346490106652988);
               (86, 2.05671089323222356); (153, 1.93124902035276746)]);;

let (length,localMean) = List.split bSeg in
let dLst = difList localMean in
let mPos = maxPos length in
assert( dLst = [-0.270747607770506882; -0.823568745381722422; 
                -1.97793811743307524; -0.125461872879456093] );
assert( mPos = 4 );;

let mCPF = meanChangePoint bSeg in
assert(mCPF = [|-0.125461872879456093; -1.97793811743307524; 0.556363636363636394; 
                1.93124902035276746; 5.|]);;
   
(* Start of Fourier Feature Testing *)
   
let iCS = complexInSum 2 2. 2. 2. in
assert(iCS = {Complex.re = 2.; im = 7.18345474716185451e-10});;

assert (discreteFourierTransform [|1.;2.;3.;4.|] = [|2.5; 1.41421356243658836; 1.; 1.41421356218261374|]);
assert (discreteFourierTransform [|12.|] = [|12.|]);;

let dFT = discreteFourierTransform timeSeries;;
assert( (Array.fold_left (+.) 0. dFT) = 18.8259079950291373) ;; (* should change for the actual DFT result *)

let tFF = fourierFeatures dFT 5 in
assert ( tFF = [|2.29962131260565661; 0.66846003283942812; 0.534551549975429641;
                 0.451608069825801484; 0.444882749312985937; 0.290682656824922614;             
                 0.232451989832073519; 0.196383668628506952; 0.193459134716792935; 1.|]);;

(* Detrended Analysis Tests *)
let mDyd = makeDyadic timeSeries in
let n , mDy = mDyd in 
assert ( (n, (Array.fold_left (+.) 0. mDy)) = (8. ,597.758332451184287));;

let rSum = getRunSum [|1.;5.;7.;9.;2.|] in
assert(rSum = [|1.; 6.; 13.; 22.; 24.|] );;

let parts = partition [|1;2;3;4;5;6;7;8|] 2 in
assert(parts = [[|1; 2; 3; 4|]; [|5; 6; 7; 8|]]);
assert(partition [|1;2;3;4;5;6;7;8|] 3 = [[|1;2;3;4;5;6;7;8|]]);;

let sLR = simpleLinearRegression [|1.;2.;3.;4.;5.;6.;7.;8.|] [|1.;2.;3.;4.;5.;6.;7.;8.|] in
assert(sLR = (1., 0.));;

let aArr, bArr = [|1.;2.;3.;4.;5.;6.;7.;8.|], [|2.;3.;5.;7.;8.;9.;10.;12.|] in
let model = simpleLinearRegression aArr bArr in
assert(model = (1.40476190476190466, 0.678571428571428825));
let sE = squaredError aArr bArr model in
assert( sE = [|0.00694444444444446921; 0.238236961451247203; 0.011479591836734802;
               0.493339002267573934; 0.0885770975056688337; 0.0114795918367344221;           
               0.26204648526077; 0.00694444444444454294|] );;
               
assert( makeArr 5. = [|0.; 1.; 2.; 3.; 4.|] );
assert( makeArr 0. = [||] );;

assert(detrendedFluctuationAnalysis timeSeries = 1.29749928554645311);;





