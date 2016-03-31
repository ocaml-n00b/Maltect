
(* 
  Desc: Count the number of occurrences of each byte in a stream up to n bytes or EOF (woth n =-1);
        Gather information for calculating File Entropy.
  (input channel -> int) -> float array
*)
let streamByteCount ic n = 
  let bca = Array.make 256 0. in
  try 
    let rec aux i =
      if i<n || n=(-1) then
        let mi = int_of_char (input_char ic) in
        Array.set bca mi (bca.(mi) +. 1.);
        aux (i+1)
      else
        (bca,false)
    in aux 0 
  with e ->                      (* some unexpected exception occurs *)
    close_in_noerr ic;           (* emergency closing *)
    (bca,true)    ;;

(* 
  Desc: Use the Byte Count Array (bca) to calculate the Maximum Likelihood Estamitor (the "entropy" value) of file with n observations.
        It can use any array of floats that indicate different values of a
        conglomarete to calculate the entropy value.
  float array -> float
*)
let maxLikelihoodEstimator bca n =
  let nN = float_of_int n in
  let elst = Array.map (fun ni -> let fi = ni /. nN in
    if fi>0. then fi *. ((log10 fi) /. ( log10 2. )) *. -1. else 0.) bca in
  (Array.fold_left (+.) 0. elst);;

(* 
  Desc: Count the number of occurrences of each byte in every n bytes blocks of data in a file 
        and return a list of arrays with the number of observation of each byte value and whether
        the EOF was reached.
  string -> int -> ( float array list, bool )
  Note: List is in reverse order of blocks in file
*)
let blockingByteCount file blockSize = 
  let ic = open_in file in
  let rec aux acc =
      match streamByteCount ic blockSize with
      | bca,false -> aux (bca::acc)
      | bca,true  -> (bca::acc)
  in aux [];;

(* Desc: Get Maximum Likelihood Estimator from a float array list and block size used.
         Returns a list of floats equal to the MLE 
   float array list -> int -> float list
*)
let mleList bcaLst blockSize =
   List.map (fun bca -> maxLikelihoodEstimator bca blockSize) bcaLst;;

(* Desc: Write a list of float arrays (llst) to a CSV File of name fname.
         e.g. write the output of blockingByteCount to a CSV file.
   float list -> bytes -> [CSV File]
*)
let csvBCALst llst fname = 
  let oc = open_out fname in
  let rec aux = function
    | [] -> ()
    | hd::tl -> Array.iter (fun a -> output_bytes oc ((string_of_float a)^",")) hd;
      output_bytes oc ";\n" ; aux tl
  in aux llst;
  flush oc;
  close_out oc;;

(* Write a list of floats, llst, to a CSV file of name fname.
    e.g. the output from mleList.
*)
let csvMLELst llst fname = 
  let oc = open_out fname in
  let row = List.fold_right (fun a b -> ((string_of_float a)^","^b )) llst ";\n" in
  output_bytes oc row;
  flush oc;
  close_out oc;;


(*
TODO: blockingByteCount should use input_channel or Stream instead of file name for greater abstraction.
      ??Move csv* functions to basicEntropyAnalysis module??
*)
