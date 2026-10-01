let find_transition (a : Types.automata) (s : Types.state) (sym : Types.symbol) =
  List.find_opt (fun (from, x, _) -> from = s && x = sym) a.Types.transitions

let transition (a : Types.automata) (s : Types.state) (sym : Types.symbol) : Types.state =
  match find_transition a s sym with
  | Some (_, _, dest) -> dest
  | None ->
    match find_transition a a.Types.initial sym with
    | Some (_, _, dest) -> dest
    | None -> a.Types.initial

let recognized (a : Types.automata) (s : Types.state) : string list =
  match List.assoc_opt s a.Types.finals with
  | Some names -> names
  | None -> []
