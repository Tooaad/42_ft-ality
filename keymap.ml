(* El keymap traduce las teclas del jugador a simbolos del automata, y se muestra
   en pantalla antes de empezar. Se calcula siempre desde la gramatica. *)

(* lookup_symbol [("s", "[BP]")] "s"  ->  Some "[BP]"
   lookup_symbol [("s", "[BP]")] "k"  ->  None   (tecla sin mapear: se ignora) *)
let lookup_symbol (keymap : Grammar.keymap) (key : string) : Types.symbol option =
  List.assoc_opt key keymap

(* Imprime:
   Key mappings:
   s -> [BP]
   x -> [FP]
   ---------------------- *)
let print_mappings (keymap : Grammar.keymap) : unit =
  let () = print_endline "Key mappings:" in
  let () = List.iter (fun (key, symbol) -> print_endline (key ^ " -> " ^ symbol)) keymap in
  print_endline "----------------------"
