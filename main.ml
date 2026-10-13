let separator : string = "----------------------"

let print_mappings (keymap : Types.keymap) : unit =
  let () = print_endline "Key mappings:" in
  let () = List.iter (fun (key, symbol) -> print_endline (key ^ " -> " ^ symbol)) keymap in
  print_endline separator

(* Mostrar el progreso al pasar del estado `prev` al `next`: la secuencia pulsada y,
   si reconoce movimientos, sus nombres con " !!" y una linea en blanco. Si la secuencia
   reinicia (el intento se abandona o ya habia terminado), antes imprime una linea de guiones. *)
let show_progress (a : Types.automaton) (prev : Types.state) (next : Types.state) : unit =
  let prev_length = List.length (Automaton.path_to a prev) in
  let path = Automaton.path_to a next in
  let () = if prev_length > 0 && List.length path <= prev_length then print_endline separator in
  match path with
  | [] -> ()
  | _ ->
    let () = print_endline (String.concat ", " path) in
    match Automaton.recognized a next with
    | [] -> ()
    | names ->
      let () = List.iter (fun name -> print_endline (name ^ " !!")) names in
      print_endline ""

(* lookup_symbol [("s", "[BP]")] "s"  ->  Some "[BP]"
   lookup_symbol [("s", "[BP]")] "k"  ->  None   (tecla sin mapear) *)
let lookup_symbol (keymap : Types.keymap) (key : string) : Types.symbol option =
  List.assoc_opt key keymap

(* Bucle principal. Lee una tecla, la traduce a simbolo, avanza el automata y muestra
   el progreso. Las teclas sin mapear reinician el automata. El estado viaja como argumento. *)
let rec loop (a : Types.automaton) (keymap : Types.keymap) (state : Types.state) : unit =
  match Terminal.next_key () with
  | None -> ()
  | Some key ->
    let next =
      match lookup_symbol keymap key with
      | None -> a.Types.initial
      | Some sym -> Automaton.transition a state sym in
    let () = show_progress a state next in
    loop a keymap next

(* Poner el programa en marcha con un fichero de gramatica.
   Lee la gramatica, la entrena en un automata, muestra el mapeo de teclas, pone el terminal
   en modo crudo y empieza a leer teclas desde el estado inicial. *)
let run (path : string) : unit =
  match Parser.read_grammar path with
  | exception Sys_error msg -> prerr_endline ("ft_ality: " ^ msg); exit 1
  | grammar ->
    let a = Trainer.build_automata grammar in
    let () = print_mappings grammar.Types.keymap in
    let () = Terminal.start () in
    loop a grammar.Types.keymap a.Types.initial

(* Punto de entrada. Lee el argumento de la linea de comandos (ruta de la gramatica)
   y pone el programa en marcha. Comprueba aqui los argumentos, que es lo unico que conoce
   la linea de comandos; run solo recibe una ruta. *)
let () =
  match Sys.argv with
  | [| _; path |] when Sys.file_exists path -> run path
  | [| _; path |] -> prerr_endline ("ft_ality: no existe el fichero " ^ path); exit 1
  | _ -> prerr_endline "uso: ./ft_ality fichero_gramatica"; exit 1
