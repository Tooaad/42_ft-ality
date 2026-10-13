let separator : string = "----------------------"

(* Mostrar el mapeo de teclas ("tecla -> simbolo") *)
let print_key_mappings (keymap : Types.keymap) : unit =
  let () = print_endline "Key mappings:" in
  let () = List.iter (fun (key, symbol) -> print_endline (key ^ " -> " ^ symbol)) keymap in
  print_endline separator

(* Mostrar el progreso al pasar de `prev` a `next`: la secuencia pulsada y, si reconoce
   movimientos, sus nombres. Si la secuencia vuelve a empezar, se imprime el separador *)
let show_progress (automaton : Types.automaton) (prev : Types.state) (next : Types.state) : unit =
  let prev_length = List.length (Automaton.path_to automaton prev) in
  let sequence = Automaton.path_to automaton next in
  let () = if prev_length > 0 && List.length sequence <= prev_length then print_endline separator in
  match sequence with
  | [] -> ()
  | _ ->
    let () = print_endline (String.concat ", " sequence) in
    match Automaton.recognized automaton next with
    | [] -> ()
    | names ->
      let () = List.iter (fun name -> print_endline (name ^ " !!")) names in
      print_endline ""

(* Bucle principal: tecla -> simbolo -> siguiente estado, y mostrar el progreso.
   Una tecla sin mapear reinicia el automata. *)
let rec loop (automaton : Types.automaton) (keymap : Types.keymap) (state : Types.state) : unit =
  match Terminal.next_key () with
  | None -> ()
  | Some key ->
    let next =
      match List.assoc_opt key keymap with
      | None -> automaton.Types.initial
      | Some symbol -> Automaton.transition automaton state symbol in
    let () = show_progress automaton state next in
    loop automaton keymap next

(* Leer la gramatica, entrenar el automata, mostrar el mapeo y empezar a leer teclas *)
let run (path : string) : unit =
  match Parser.read_grammar path with
  | exception Sys_error message ->
    let () = prerr_endline ("ft_ality: " ^ message) in
    exit 1
  | grammar ->
    let automaton = Trainer.build_automata grammar in
    let () = print_key_mappings grammar.Types.keymap in
    let () = Terminal.start () in
    loop automaton grammar.Types.keymap automaton.Types.initial

(* Punto de entrada: comprobar los argumentos (la ruta de la gramatica) y llamar a run *)
let () =
  match Sys.argv with
  | [| _; path |] -> run path
  | _ ->
    let () = prerr_endline "uso: ./ft_ality fichero_gramatica" in
    exit 1
