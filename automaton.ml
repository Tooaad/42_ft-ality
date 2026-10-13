(* Destino de la flecha que sale de `state` con `symbol`, si existe *)
let rec find_transition (state : Types.state) (symbol : Types.symbol)
    (transitions : Types.transition list) : Types.state option =
  match transitions with
  | [] -> None
  | (origin, label, destination) :: rest ->
    if origin = state && label = symbol then Some destination
    else find_transition state symbol rest

(* Estado siguiente (funcion delta). Si no hay flecha, se reintenta desde el estado inicial;
   si tampoco, se vuelve al inicial. *)
let transition (automaton : Types.automaton) (state : Types.state) (symbol : Types.symbol)
  : Types.state =
  match find_transition state symbol automaton.Types.transitions with
  | Some destination -> destination
  | None ->
    match find_transition automaton.Types.initial symbol automaton.Types.transitions with
    | Some destination -> destination
    | None -> automaton.Types.initial

(* Nombres de los movimientos que reconoce un estado (vacia si no es final) *)
let recognized (automaton : Types.automaton) (state : Types.state) : string list =
  match List.assoc_opt state automaton.Types.finals with
  | Some names -> names
  | None -> []

(* Flecha que llega a `state`, si existe *)
let incoming_transition (automaton : Types.automaton) (state : Types.state)
  : Types.transition option =
  List.find_opt (fun (_, _, destination) -> destination = state) automaton.Types.transitions

(* Simbolos que llevan del estado inicial hasta `state`: ["[BP]"; "[FP]"].
   Cada estado tiene una sola flecha de entrada, asi que el camino es unico. *)
let rec path_to (automaton : Types.automaton) (state : Types.state) : Types.symbol list =
  if state = automaton.Types.initial then []
  else
    match incoming_transition automaton state with
    | Some (origin, label, _) -> path_to automaton origin @ [label]
    | None -> []
