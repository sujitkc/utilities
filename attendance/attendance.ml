exception Attendance_exception of string

let rows_per_page = 25
let num_cols = 10

let (|>) f g x = g(f x)

(* Given a string file_name which is the name of a CSV file f, return a list of (rollNumber, name) extracted from the f. *)
let csv_to_student_list file_name =
  let allrows = Csv.load file_name in
  match allrows with
    [] ->  raise (Attendance_exception "empty input")
  | _ :: rows ->
  List.map
  (
    fun row ->
      match row with
        rn :: _ -> rn
      | _ -> raise (Attendance_exception "Invalid CSV row")
  )
  rows

(* Extract first n elements of a list as a pair of the extracted part (f) and the remaining (s) *)
let rec split_at_n n lst =
  match lst with 
    [] -> [], []
  | h :: t when n <> 0 -> let f, s = (split_at_n (n - 1) t) in h::f, s
  | _ -> [], lst

(* Given list lst, return a list of lists each of which contains at most n elements *)
let rec make_lists_of_n n lst =
  let f, s = split_at_n n lst in
  match s with
    [] -> [f]
  | _  -> f :: make_lists_of_n n s

(* Read the initial common portion of the output latex file from before.tex and return as string *)
let before () =
  let chan = open_in "before.tex" in
  let rec iter lines =
    try
      let line = input_line chan in (iter (line::lines))
    with End_of_file ->
      close_in chan;
      (List.fold_left (fun a b -> (a ^ "\n" ^ b)) "" (List.rev lines))
  in
  iter []

(* Return the last part of the output latex file *)
let after () = "\\end{large}" ^ "\n" ^ "\\end{document}"    

(* Given a lst of roll numbers, generate a latex table for it. *)
let make_table lst =
  let rec n_header_cells = function
    0 -> ""
  | n -> "p{1cm}|" ^ (n_header_cells (n - 1)) in
  let rec n_empty_cells s = function
    1 -> s
  | n -> s ^ "& " ^ (n_empty_cells s (n - 1)) in
  let theader = "\\begin{center} \n \\begin{tabular}{|c|" ^ (n_header_cells (num_cols - 1)) ^ "}" 
              ^ "\n\\hline"
              ^ "{\\cellcolor{red!25}\\textbf{Roll Number}} & " 
              ^ (n_empty_cells "\\cellcolor{red!25}" (num_cols - 1)) ^ " \\\\" ^ "\n\\hline"
  and tfooter = "\\end{tabular} \n \\end{center}" in
  let make_row rn = rn ^ " & " ^ (n_empty_cells "" (num_cols - 1)) ^ "\\\\" ^ "\n\\hline" in
  let rows = List.map make_row lst in
  let tbody   = List.fold_left (fun a b -> a ^ "\n" ^ b) "" rows in
  theader ^ tbody ^ tfooter
 
(* Given a list of attendances attendance_lst, generate a latex string corresponding to it. *)
let attendance_to_tex attendance_lst =
  let tables =
    let table_lst = List.map make_table attendance_lst in
    (List.fold_left (fun a b -> a ^ "\n" ^ b) " " table_lst)
  in
  before() ^ "\n" ^ tables ^ "\n" ^ after()

(* Generate the latex file for the attendance list. *)
let gen_latex_file (latex) =
  let ochan = open_out ("output/" ^ "attendance.tex") in
    output_string ochan latex;
    close_out ochan

let gen_pdf (ifile) =
  (ifile |> csv_to_student_list |> (make_lists_of_n rows_per_page) |> attendance_to_tex |> gen_latex_file)();
  print_string "generating latex file ...";
  let _ = Sys.command ("pdflatex "
          ^ "-output-directory=output output/"
          ^ "attendance.tex  >/dev/null") in ();                    (* latex to pdf id *)
  print_string "generated. \n";
(*  let _ = Sys.command ("rm " ^ "output/" ^ "attendance.tex") in (); (* remove latex file *) *)
  let _ = Sys.command ("rm " ^ "output/" ^ "attendance.aux") in (); (* remove aux file *)
  let _ = Sys.command ("rm " ^ "output/" ^ "attendance.log") in ()  (* remove log file *)

let main () =
  if Array.length Sys.argv <> 2 then
    print_string "Exactly one command-line argument required.\n"
  else
    (gen_pdf (fun () -> Sys.argv.(1)))

let _ = main ()
