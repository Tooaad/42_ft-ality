(* ---------- Training ---------- *)

let rec add_final (state) (move_name) (final_states) =
  match final_states with
  | [] ->
    let new_final_state = (state, [move_name]) :: final_states in new_final_state
  | (final_state, moves) :: rest ->
    if final_state = state then
      let new_moves_from_state = move_name :: moves in
      let reinsert_final_state = (final_state, new_moves_from_state) :: rest in reinsert_final_state
    else
      (final_state, moves) :: add_final state move_name rest

let rec train (state) (word) (move_name) (transitions) (final_states) (next_free_state) =
  match word with
  | [] ->
    let new_final_states = add_final state move_name final_states in
    (transitions, new_final_states, next_free_state) (* Devolvemos la lista en orden de inicio-fin*)
  | symbol :: rest ->
    match Automaton.find_transition (state) (symbol) (transitions) with
    | Some next_state ->
        train (next_state) (rest) (move_name) (transitions) (final_states) (next_free_state) (* Ha habido coincidencia con una transicion existente then pasamos *)
    | None ->
        let next_state = next_free_state in (* Aumentamos contador a donde transiciona el siguiente estado *)
        let new_transition = (state, symbol, next_state) in (* guardamos tupla *)
        let new_transitions = new_transition :: transitions in (* guardamos en la lista *)
        train (next_state) (rest) (move_name) (new_transitions) (final_states) (next_free_state+1) (* llamamos a la funcion de nuevo *)

let rec train_words (words) (transitions) (final_states) (next_free_state)  =
  match words with
  | [] -> (transitions, final_states, next_free_state)
  | (word, move_name) :: rest ->
      let (new_transitions, new_final_states, new_next_free_state) =
        train 0 (word) (move_name) (transitions) (final_states) (next_free_state) in
        train_words (rest) (new_transitions) (new_final_states) (new_next_free_state)

(* Gramatica -> automata *)
let build_automata (grammar) =
  let (transitions, finals, next_free_state) = train_words grammar.Grammar.moves [] [] 1 in
  {
    Types.states = List.init next_free_state (fun i -> i);
    alphabet = List.sort_uniq compare (List.map (fun (_, s, _) -> s) transitions);
    initial = 0;
    finals = List.rev finals;
    transitions = List.rev transitions;
  }