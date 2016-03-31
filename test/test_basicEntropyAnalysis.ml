open "basicEntropyAnalysis"
(* open: test_Entropy_cases *)


let ordLst = sortEntropyList entLstT in
assert(ordLst = ordLstT);;

let stats = entropyStat entLstT;;
assert(stats = statsT );;

let singFile = autoSingleFile "./test.tst" in
assert(singFile = 3.18172348495571278::statsT)
