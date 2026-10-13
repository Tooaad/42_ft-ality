type symbol = string (* lo que entiende la maquina, ej: "UP", "DOWN" , etc *)
type state = int 
type transition = state * symbol * state
type final = state * string list

type automaton = {
  states : state list;           (* Q  *)
  alphabet : symbol list;        (* Sigma *)
  initial : state;               (* Q0 *)
  finals : final list;           (* F  *)
  transitions : transition list; (* delta *)
}

type key = string                    (* tecla fisica, ej: "s", "down" *)
type binding = key * symbol          (* una linea "s = [BP]"  ->  ("s", "[BP]") *)
type keymap = binding list           (* todos los mapeos: [("s", "[BP]"); ("x", "[FP]")] *)
type move = symbol list * string     (* "[BP], [FP] : Combo"  ->  (["[BP]"; "[FP]"], "Combo") *)

(* Una linea de la gramatica *)
type line =
  | Skip                  (* vacia o comentario: "", "# hola" *)
  | Key of binding        (* "s = [BP]"  ->  Key ("s", "[BP]") *)
  | Move of move          (* "[BP] : Golpe"  ->  Move (["[BP]"], "Golpe") *)
  | Invalid of string     (* no encaja con nada: "basura"  ->  Invalid "basura" *)

(* Lo que se obtiene de leer un fichero de gramatica entero *)
type grammar = {
  keymap : keymap;
  moves : move list;
}
