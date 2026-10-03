type symbol = string (* lo que entiende la maquina, ej: "UP", "DOWN" , etc *)
type state = int 
type transition = state * symbol * state
type final = state * string list

type automata = {
  states : state list;           (* Q  *)
  alphabet : symbol list;        (* Sigma *)
  initial : state;               (* Q0 *)
  finals : final list;           (* F  *)
  transitions : transition list; (* delta *)
}
