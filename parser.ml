let split_once (sep : char) (s : string) : (string * string) option =
  match String.index_opt s sep with
  | None -> None
  | Some i ->
    let left = String.sub s 0 i in
    let right = String.sub s (i + 1) (String.length s - i - 1) in
    Some (String.trim left, String.trim right)

let parse_move (line : string) : (Types.symbol list * string) option =
  match split_once ':' line with
  | None -> None
  | Some (combo, name) ->
    let symbols = List.map String.trim (String.split_on_char ',' combo) in
    if name <> "" && List.for_all (fun s -> s <> "") symbols
    then Some (symbols, name)
    else None

let parse_key (line : string) : (Types.key * Types.symbol) option =
  match split_once '=' line with
  | Some (k, sym) when k <> "" && sym <> "" -> Some (k, sym)
  | _ -> None
