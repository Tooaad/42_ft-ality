(* Tipos de la gramatica: lo que se lee del fichero, antes de construir el automata *)

type key = string                          (* tecla fisica, ej: "s", "down" *)
type binding = key * Types.symbol          (* una linea "s = [BP]"  ->  ("s", "[BP]") *)
type keymap = binding list                 (* todos los mapeos: [("s", "[BP]"); ("x", "[FP]")] *)
type move = Types.symbol list * string     (* "[BP], [FP] : Combo"  ->  (["[BP]"; "[FP]"], "Combo") *)

(* Una linea de la gramatica, ya interpretada *)
type line =
  | Skip                  (* vacia o comentario: "", "# hola" *)
  | Key of binding        (* "s = [BP]"  ->  Key ("s", "[BP]") *)
  | Move of move          (* "[BP] : Golpe"  ->  Move (["[BP]"], "Golpe") *)
  | Invalid of string     (* no encaja con nada: "basura"  ->  Invalid "basura" *)

(* Lo que se obtiene de leer un fichero de gramatica entero *)
type grammar = {
  keymap : keymap;       (* para el teclado: tecla -> simbolo *)
  moves : move list;     (* para construir el automata *)
}
