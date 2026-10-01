type symbol = string
type state = int
type transition = state * symbol * state
type final = state * string list
type key = string
type keymap = (key * symbol) list 

type automata = {
  states : state list;           (* Q  *)
  alphabet : symbol list;        (* Sigma *)
  initial : state;               (* Q0 *)
  finals : final list;           (* F  *)
  transitions : transition list; (* delta *)
}
