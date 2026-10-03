(* PIEZA 1: mostrar lo que reconoce un estado.
   Si el estado tiene movimientos asociados, imprime la secuencia que lleva hasta el
   (Automaton.path_to), los nombres (cada uno con " !!") y una linea en blanco.
   Si no reconoce nada, no imprime nada.
   show_recognized a 1  ->  [BP]
                            Golpe rapido !!
                            (linea en blanco) *)
let show_recognized (a : Types.automata) (state : Types.state) : unit =
  match Automaton.recognized a state with
  | [] -> ()
  | names ->
    let () = print_endline (String.concat ", " (Automaton.path_to a state)) in
    let () = List.iter (fun name -> print_endline (name ^ " !!")) names in
    print_endline ""

(* PIEZA 2: bucle principal. Lee una tecla, la traduce a simbolo con el keymap, avanza el
   automata y muestra lo que reconoce el estado al que llega. Las teclas sin mapear se
   ignoran (el estado no cambia). Termina cuando no quedan teclas (Terminal.next_key
   devuelve None).
   El estado actual viaja como argumento de una vuelta a la siguiente. *)
let rec loop (a : Types.automata) (keymap : Grammar.keymap) (state : Types.state) : unit =
  match Terminal.next_key () with
  | None -> ()
  | Some key ->
    match Keymap.lookup_symbol keymap key with
    | None -> loop a keymap state
    | Some sym ->
      let next = Automaton.transition a state sym in
      let () = show_recognized a next in
      loop a keymap next

(* PROVISIONAL: automata escrito a mano para grammars/test.gmr, para poder probar el programa.
   Es lo unico que hay que sustituir cuando exista el entrenamiento: esta funcion tendra que
   construir el automata a partir de los movimientos de la gramatica (grammar.Grammar.moves). *)
let automaton_of (_ : Grammar.grammar) : Types.automata = {
  Types.states = [0; 1; 2; 3];
  alphabet = ["[BP]"; "[FP]"; "[FK]"];
  initial = 0;
  finals = [(1, ["Golpe rapido"]); (2, ["Combo del puno"]); (3, ["Combo de la patada"])];
  transitions = [(0, "[BP]", 1); (1, "[FP]", 2); (1, "[FK]", 3)];
}

(* PIEZA 3: poner el programa en marcha con un fichero de gramatica.
   Lee la gramatica, construye el automata, muestra el mapeo de teclas, pone el terminal
   en modo crudo y empieza a leer teclas desde el estado inicial. *)
let run (path : string) : unit =
  let grammar = Parser.read_grammar path in
  let a = automaton_of grammar in
  let () = Keymap.print_mappings grammar.Grammar.keymap in
  let () = Terminal.start () in
  loop a grammar.Grammar.keymap a.Types.initial

(* PIEZA 4: punto de entrada. Lee el argumento de la linea de comandos (ruta de la gramatica)
   y pone el programa en marcha. Comprueba aqui los argumentos, que es lo unico que conoce
   la linea de comandos; run solo recibe una ruta. *)
let () =
  match Sys.argv with
  | [| _; path |] when Sys.file_exists path -> run path
  | [| _; path |] -> prerr_endline ("ft_ality: no existe el fichero " ^ path); exit 1
  | _ -> prerr_endline "uso: ./ft_ality fichero_gramatica"; exit 1
