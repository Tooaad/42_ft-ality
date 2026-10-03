(* v2: parser + training en un solo fichero.
   Lee una gramatica y construye el automata (estados, transiciones, finales).
   Los tipos viven en types.ml y grammar.ml. *)

(* ---------- Parser ---------- *)

let split_once (sep : char) (s : string) : (string * string) option =
  match String.index_opt s sep with
  | None -> None
  | Some i ->
    let left = String.sub s 0 i in
    let right = String.sub s (i + 1) (String.length s - i - 1) in
    Some (String.trim left, String.trim right)

let parse_key (line : string) : Grammar.binding option =
  match split_once '=' line with
  | Some (key, symbol) when key <> "" && symbol <> "" -> Some (key, symbol)
  | _ -> None

let parse_move (line : string) : Grammar.move option =
  match split_once ':' line with
  | None -> None
  | Some (combo, name) ->
    let symbols = List.map String.trim (String.split_on_char ',' combo) in
    if name <> "" && List.for_all (fun s -> s <> "") symbols
    then Some (symbols, name)
    else None

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

let add_line (g : Grammar.grammar) (line : Grammar.line) : Grammar.grammar =
  match line with
  | Grammar.Key b -> { g with Grammar.keymap = b :: g.Grammar.keymap }
  | Grammar.Move m -> { g with Grammar.moves = m :: g.Grammar.moves }
  | Grammar.Skip | Grammar.Invalid _ -> g

let empty_grammar : Grammar.grammar = { Grammar.keymap = []; moves = [] }

let reverse_grammar (g : Grammar.grammar) : Grammar.grammar =
  { Grammar.keymap = List.rev g.Grammar.keymap; moves = List.rev g.Grammar.moves }

let rec read_all (ic : in_channel) (g : Grammar.grammar) : Grammar.grammar =
  match input_line ic with
  | l -> read_all ic (add_line g (classify_line l))
  | exception End_of_file -> reverse_grammar g

let read_grammar (path : string) : Grammar.grammar =
  let ic = open_in path in
  let g = read_all ic empty_grammar in
  let () = close_in ic in
  g

(* ---------- Training ---------- *)

let rec train_words (words) (transitions) (final_states) (next_free_state)  =
  match words with
  | [] -> (transitions, final_states, next_free_state)
  | (word, move_name) :: rest ->
      let (new_transitions, new_final_states, new_next_free_state) =
        train 0 (word) (move_name) (transitions) (final_states) (next_free_state) in
        train_words (rest) (new_transitions) (new_final_states) (new_next_free_state)

and train (state) (word) (move_name) (transitions) (final_states) (next_free_state) =
  match word with
  | [] ->
    let new_final_states = add_final state move_name final_states in
    (transitions, new_final_states, next_free_state) (* Devolvemos la lista en orden de inicio-fin*)
  | symbol :: rest ->
    match find_transition (state) (symbol) (transitions) with
    | Some next_state ->
        train (next_state) (rest) (move_name) (transitions) (final_states) (next_free_state) (* Ha habido coincidencia con una transicion existente then pasamos *)
    | None ->
        let next_state = next_free_state in (* Aumentamos contador a donde transiciona el siguiente estado *)
        let new_transition = (state, symbol, next_state) in (* guardamos tupla *)
        let new_transitions = new_transition :: transitions in (* guardamos en la lista *)
        train (next_state) (rest) (move_name) (new_transitions) (final_states) (next_free_state+1) (* llamamos a la funcion de nuevo *)

and find_transition (state) (symbol) (transitions) =
  match transitions with
  | [] -> None
  | (origin, sym, destination) :: rest ->
    if origin = state && sym = symbol then
      Some destination
    else
      find_transition (state) (symbol) (rest)

and add_final (state) (move_name) (final_states) =
  match final_states with
  | [] ->
    let new_final_state = (state, [move_name]) :: final_states in new_final_state
  | (final_state, moves) :: rest ->
    if final_state = state then
      let new_moves_from_state = move_name :: moves in
      let reinsert_final_state = (final_state, new_moves_from_state) :: rest in reinsert_final_state
    else
      (final_state, moves) :: add_final state move_name rest

(* Gramatica -> automata *)
let build_automata (g : Grammar.grammar) : Types.automata =
  let (transitions, finals, next_free_state) = train_words g.Grammar.moves [] [] 1 in
  {
    Types.states = List.init next_free_state (fun i -> i);
    alphabet = List.sort_uniq compare (List.map (fun (_, s, _) -> s) transitions);
    initial = 0;
    finals = List.rev finals;
    transitions = List.rev transitions;
  }

(* ---------- Main ---------- *)

let print_automata (a : Types.automata) : unit =
  let () = Printf.printf "states: %d\n" (List.length a.Types.states) in
  let () = List.iter (fun (f, s, t) -> Printf.printf "  %d --%s--> %d\n" f s t) a.Types.transitions in
  List.iter (fun (s, names) ->
    Printf.printf "  final %d: %s\n" s (String.concat ", " names)) a.Types.finals

let () =
  if Array.length Sys.argv <> 2 then prerr_endline "usage: v2 <grammar file>"
  else print_automata (build_automata (read_grammar Sys.argv.(1)))
