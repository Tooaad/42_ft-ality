let rec find_transition (state) (symbol) (transitions) =
  match transitions with
  | [] -> None
  | (origin, sym, destination) :: rest ->
    if origin = state && sym = symbol then
      Some destination
    else
      find_transition (state) (symbol) (rest)

let transition (a : Types.automata) (s : Types.state) (sym : Types.symbol) : Types.state =
  match find_transition s sym a.Types.transitions with
  | Some dest -> dest
  | None ->
    match find_transition a.Types.initial sym a.Types.transitions with
    | Some dest -> dest
    | None -> a.Types.initial

let recognized (a : Types.automata) (s : Types.state) : string list =
  match List.assoc_opt s a.Types.finals with
  | Some names -> names
  | None -> []

(* Secuencia de simbolos que lleva del estado inicial hasta el estado s.
   El automata es un arbol (los prefijos se comparten), asi que cada estado tiene una
   unica flecha de entrada y el camino es unico.
   path_to a 2  ->  ["[BP]"; "[FP]"]     (0 --[BP]--> 1 --[FP]--> 2)
   path_to a 0  ->  [] *)
let rec path_to (a : Types.automata) (s : Types.state) : Types.symbol list =
  if s = a.Types.initial then []
  else
    match List.find_opt (fun (_, _, dest) -> dest = s) a.Types.transitions with
    | Some (from, sym, _) -> path_to a from @ [sym]
    | None -> []