

#use "Entropy.ml";;
#use "basicEntropyAnalysis.ml";;
#use "advancedTechniques.ml";;




(* Full File Entropy *)
let (bcaF, error), n =
let tmpic = open_in "./old/Entropy.o" in
let size = in_channel_length tmpic in
(streamByteCount tmpic (-1)), size ;;

let fileEnt = maxLikelihoodEstimator bcaF n;;

(* Entropy of 256 byte blocks *)
let entLst = 
let freqLst = blockingByteCount "./old/Entropy.o" 256 in
List.rev (mleList freqLst 256);;

(* Quick single file basic stats *)
autoSingleFile "./old/Entropy.o" 256;;

(*___________________________________________________*)

(* use Advanced *)
(* Save structue, time series,  to file *)
csvMLELst entLst "timeSeries.csv";;

(* Obtain Mean Change-point Modeling fit *)
let bSegTuple = 
let timeSeries = Array.of_list entLst in
let n = Array.length timeSeries in
binarySegmentation timeSeries fitError (sicPenalty 1. n);;

(* Calculate the mean change point features of a list of files  *)
let autoGetAdv lst =
   let rec aux acc = function
      | [] -> acc
      | hd::tl -> let entLst = 
         let freqLst = blockingByteCount hd 256 in
         List.rev (mleList freqLst 256) in
         let bSegTuple = 
         let timeSeries = Array.of_list entLst in
         let n = Array.length timeSeries in
         binarySegmentation timeSeries fitError (sicPenalty 1. n) in
         aux ((meanChangePoint bSegTuple)::acc) tl
   in aux [] lst;;

(* Write a CSV file of a list of floats *)
let csvAll headers rowNames data fname =
   let csvHead = List.fold_right (fun a b -> a^", "^b) headers ";\n" in
   let csvBody =
   let rec aux acc names = function
      | [] -> acc
      | hd::tl -> let name::nametl = names in
         let strOfFloats = Array.fold_right (fun a b -> (string_of_float a)^", "^b ) hd "\n" in
         let row = name^","^strOfFloats in
         aux (acc^row) nametl tl
   in aux "" rowNames data in
   let csvFile = csvHead^csvBody in
   let oc = open_out fname in
   output_bytes oc csvFile ;
   flush oc;
   close_out oc;;
   

(*var name: cleanStruct *)
(*
TODO: lots of stuff...

TODO:
  

*)
