(* Partir un texto por el primer separador, sin espacios: "s = [BP]" -> ("s", "[BP]") *)
let split_once (sep : char) (text : string) : (string * string) option =
  match String.index_opt text sep with
  | None -> None
  | Some position ->
    let left = String.sub text 0 position in
    let right = String.sub text (position + 1) (String.length text - position - 1) in
    Some (String.trim left, String.trim right)

(* Linea "tecla = simbolo", si es valida *)
let parse_binding (line : string) : Types.binding option =
  match split_once '=' line with
  | Some (key, symbol) when key <> "" && symbol <> "" -> Some (key, symbol)
  | _ -> None

(* Linea "simbolo, simbolo : nombre", si es valida *)
let parse_move (line : string) : Types.move option =
  match split_once ':' line with
  | None -> None
  | Some (combo, name) ->
    let symbols = List.map String.trim (String.split_on_char ',' combo) in
    if name <> "" && List.for_all (fun symbol -> symbol <> "") symbols
    then Some (symbols, name)
    else None

(* Parsear una linea de la gramatica (las vacias, los comentarios y las mal formateadas se ignoran).
   Se prueba primero como movimiento: si tiene ':' y '=', es un movimiento. *)
let parse_line (grammar : Types.grammar) (raw : string) : Types.grammar =
  let line = String.trim raw in
  if line = "" || line.[0] = '#' then grammar
  else
    match parse_move line with
    | Some move -> { grammar with Types.moves = move :: grammar.Types.moves }
    | None ->
      match parse_binding line with
      | Some binding -> { grammar with Types.keymap = binding :: grammar.Types.keymap }
      | None -> grammar

(* Leer todas las lineas del fichero *)
let rec add_lines (file : in_channel) (grammar : Types.grammar) : Types.grammar =
  match input_line file with
  | line -> add_lines file (parse_line grammar line)
  | exception End_of_file -> grammar

(* Leer un fichero de gramatica *)
let read_grammar (path : string) : Types.grammar =
  let file = open_in path in
  let grammar = add_lines file { Types.keymap = []; Types.moves = [] } in
  let () = close_in file in
  grammar
