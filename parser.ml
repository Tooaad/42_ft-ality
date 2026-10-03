(* PASO 1: partir un texto en dos por el primer separador y limpiar
   los espacios de cada parte.
   split_once '=' "s = [BP]"  ->  Some ("s", "[BP]")
   split_once '=' "basura"     ->  None
   split_once '=' "s = "       ->  Some ("s", "")    (decidir si es valido no es cosa suya) *)
let split_once (sep : char) (s : string) : (string * string) option =
  match String.index_opt s sep with
  | None -> None
  | Some i ->
    let left = String.sub s 0 i in
    let right = String.sub s (i + 1) (String.length s - i - 1) in
    Some (String.trim left, String.trim right)

(* PASO 2: interpretar una linea de mapeo "tecla = simbolo".
   parse_key "s = [BP]"  ->  Some ("s", "[BP]")
   parse_key "s = "      ->  None   (falta el simbolo)
   parse_key "basura"    ->  None   (no hay '=') *)
let parse_key (line : string) : Grammar.binding option =
  match split_once '=' line with
  | Some (key, symbol) when key <> "" && symbol <> "" -> Some (key, symbol)
  | _ -> None

(* PASO 3: interpretar una linea de movimiento "simbolo, simbolo : nombre".
   parse_move "[BP], [FP] : Combo"  ->  Some (["[BP]"; "[FP]"], "Combo")
   parse_move "[BP] : "             ->  None   (falta el nombre)
   parse_move "[BP], : Combo"       ->  None   (simbolo vacio) *)
let parse_move (line : string) : Grammar.move option =
  match split_once ':' line with
  | None -> None
  | Some (combo, name) ->
    let symbols = List.map String.trim (String.split_on_char ',' combo) in
    if name <> "" && List.for_all (fun s -> s <> "") symbols
    then Some (symbols, name)
    else None

(* PASO 4: decidir que tipo de linea es.
   classify_line "# hola"              ->  Skip
   classify_line "s = [BP]"            ->  Key ("s", "[BP]")
   classify_line "[BP], [FP] : Combo"  ->  Move (["[BP]"; "[FP]"], "Combo")
   classify_line "[BP] : a = b"        ->  Move (["[BP]"], "a = b")   (gana ':')
   classify_line "basura"              ->  Invalid "basura" *)
let classify_line (raw : string) : Grammar.line =
  let line = String.trim raw in
  if line = "" || line.[0] = '#' then Grammar.Skip
  else
    match parse_move line with
    | Some m -> Grammar.Move m
    | None ->
      match parse_key line with
      | Some b -> Grammar.Key b
      | None -> Grammar.Invalid line

(* PASO 5: anadir una linea ya clasificada a la gramatica que llevamos construida.
   Las listas se acumulan al reves (lo ultimo anadido va primero); reverse las endereza.
   add_line g (Key ("s", "[BP]"))  ->  g con ("s", "[BP]") anadido al keymap
   add_line g Skip                 ->  g sin cambios *)
let add_line (g : Grammar.grammar) (line : Grammar.line) : Grammar.grammar =
  match line with
  | Grammar.Key b -> { g with Grammar.keymap = b :: g.Grammar.keymap }
  | Grammar.Move m -> { g with Grammar.moves = m :: g.Grammar.moves }
  | Grammar.Skip | Grammar.Invalid _ -> g

let empty_grammar : Grammar.grammar = { Grammar.keymap = []; moves = [] }

let reverse_grammar (g : Grammar.grammar) : Grammar.grammar =
  { Grammar.keymap = List.rev g.Grammar.keymap; moves = List.rev g.Grammar.moves }

(* PASO 6: leer el fichero linea a linea, construyendo la gramatica a la vez.
   input_line lanza End_of_file al terminar; la excepcion solo protege a input_line,
   asi que la llamada recursiva sigue siendo lo ultimo que se hace (recursion de cola). *)
let rec read_all (ic : in_channel) (g : Grammar.grammar) : Grammar.grammar =
  match input_line ic with
  | l -> read_all ic (add_line g (classify_line l))
  | exception End_of_file -> reverse_grammar g

let read_grammar (path : string) : Grammar.grammar =
  let ic = open_in path in
  let g = read_all ic empty_grammar in
  let () = close_in ic in
  g
