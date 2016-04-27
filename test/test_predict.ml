
let timeSeries = Array.of_list entLstT;;

assert(predictLinear [1.;2.;3.;4.;5.] [1.;2.;3.;4.] = 41. );;

let mCP = singleFileMCPFetures "test.tst" 256 in
assert(mCP = [|1.97793811743307479; 0.125461872879456315; 0.556363636363636394;
               1.93124902035276769; 5.|]);;

assert( singleFilePredict_simple "test.tst" coef 256 = 0.275964274509616914 );;

assert ( bcaFileEntropy freqT = 3.18172348495571278 );;
assert ( quickMCP timeSeries = [-0.125461872879456093; -1.97793811743307524; 
                  0.556363636363636394; 1.93124902035276746; 5.] );;

assert( singleFilePredict "test.tst" coefA 256 = -0.0049575855083678 );;
