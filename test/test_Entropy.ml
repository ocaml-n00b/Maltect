open "Entropy"
open "Test_Entropy_cases"


(* Test Cases *)

(* TODO: maxLikelihoodEstimator Test  *)
let est = maxLikelihoodEstimator bcaTIn 256 in
assert(est = estT);
let sumA = Array.fold_left (+.) 0. est in
assert(sumA = 256.)

(* streamByteCount test *)
(* Block *)
let bca, error =
let tmpic = open_in "./test.tst" in
streamByteCount tmpic (256) in
assert((Array.fold_left (+.) 0. bca) = 256.);
assert((bca,error) = bca1T);;

(* Bad n values *)
let bca = let tmpic = open_in "./test.tst" in
streamByteCount tmpic (-2) in
assert (bca = bca2T);;

let bca = let tmpic = open_in "./test.tst" in
streamByteCount tmpic (-0) in
assert (bca = bca2T);;

(* Whole file Test *)
let bca =
let tmpic = open_in "./test.tst" in
streamByteCount tmpic (-1) in
assert (bca = bca3T);;

(* blockingByteCount Test *)
let freqLst = blockingByteCount "./test.tst" 256;;
assert(freqLst = freqT);;

(* entropyList and maxLikelihoodEstimator Test *)
let entLst = mleList freqLst 256;;
assert(entLst = entLstT);;




(* TODO: test->

csvBCALst
csvMLELst

*)













