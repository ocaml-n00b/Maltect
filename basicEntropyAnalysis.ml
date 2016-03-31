(* requires Entropy.ml*)

(* Desc: Print to screen all the stats in a list from the autoChk function *)
let printAll llst = let rec aux = function
  | [] -> ()
  | hd::tl -> List.iter (fun a -> print_bytes ((string_of_float a)^",")) hd;
    print_bytes ";" ; aux tl
  in aux llst;;

(* Desc: Save the list of stats obtained from the autoChk function to a CSV file. *)
let csvStats llst fname = 
  let oc = open_out fname in
  output_bytes oc "File,Max,3Q,Median,Mean,1Q,Min;\n";
  let rec aux acc = function
    | [] -> acc
    | hd::tl -> let row = List.fold_right (fun a b -> ((string_of_float a)^","^b )) hd ";\n" in
      aux (acc^row) tl
    in output_bytes oc (aux "" llst);
  flush oc;
  close_out oc;;

(* Desc: Sort a list of entropy values in ascending order of entrpoy *)
let sortEntropyList entlst = List.sort (fun a b -> int_of_float (1000.*.(a-.b)) ) entlst ;;

(* Desc: Obtain basic statistics on the entropy of a file.
    [("Max"; "3Quartile"; "Median";"Mean"; "1 Quartile"; "Min"; TODO?:"StdDev"]
    Add?: let sd = (List.fold_left (+.) 0. (List.map (fun a -> (a-.mean)**2.) slst)/.n)**(0.5)
 *)
let entropyStat elst = 
  let slst = sortEntropyList elst in
  let n = List.length elst in
  let mean = ((List.fold_left (+.) 0. slst) /. float_of_int n) in
    [(List.nth slst (n-1));(List.nth slst ((3*n)/4));(List.nth slst (n/2));
    mean; (List.nth slst (n/4)); (List.nth slst 0)];;

(* Print entropyStat output in an organized manner *)
let printStat stlst = 
  print_endline "Basic Statistics on File Entropy";
  List.iter2 (fun a b -> print_endline (a^(string_of_float b))) ["Max: "; "3Q: "; "Median: ";"Mean: "; "1Q: "; "Min: "] stlst ;;

(* Desc: Obtain the basic entropy stats of a single file given the name of the file and 
         the block size desired for block analysis. *)
let autoSingleFile fname blockSize =
(* Get file blocks entropy *)
  let stat = 
  let freqLst = blockingByteCount fname blockSize in
  let entLst = mleList freqLst 256 in
  entropyStat entLst in
(* Get File Entropy *)
  let (bcaF, _), n =
  let ic = open_in fname in
  let size = in_channel_length ic in
  (streamByteCount ic (-1)), size in
  let fileEnt = maxLikelihoodEstimator bcaF n in
  fileEnt::stat;;

(* Desc: Get basic entropy stats from a list of files. *)
let autoFileList filst blockSize =
  let rec aux acc = function
    | [] -> List.rev acc
    | hd::tl -> aux ((autoSingleFile hd blockSize)::acc) tl
  in aux [] filst;;

(* Desc: Write a CSV file filled with the name and basic entropy stats of a given list of files. 
   flst: is the list of files to analyse;
   blockSize: The size (amount of bytes) that file is divide for analysis.
   fname: is the output name of the CSV file;
   TODO: Add full File Entropy.
*)
let autoCSVOf flst blockSize fname =
  let hstr = "Name, Max, 3Q, Median, Mean, 1Q, Min;\n"in
  let statLst = autoFileList flst blockSize in
  let statStr = List.map (fun a -> (
    List.fold_right (fun y z -> (string_of_float y)^", "^(z)) a ";\n")
    ) statLst in
  let preCSVLst = List.map2 (fun a b -> a^", "^b) flst statStr in
  let csvStr = List.fold_left (fun a b -> a^b) hstr preCSVLst in
  let oc = open_out fname in
  output_bytes oc csvStr;
  flush oc;
  close_out oc;;



(*
   TODO: add a function to load a list of files from a file.
*)




