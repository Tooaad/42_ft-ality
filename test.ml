(* Q: conjunto de estados *)
type state = int

(* Σ: alfabeto *)
type symbol =
  | Zero
  | One

(* Q0: estado inicial *)
let initial_state = int

(* F: estados finales *)
let final_states = int list

(* δ: función de transición - a construir en el training*)
(* let transitions = [
  (0, Zero, 0);
  (0, One, 1);
  (1, Zero, 0);
  (1, One, 1);
] *)

(* δ*: aplicar δ a toda la palabra *)
let rec run state word =
  match word with
  | [] -> state
  | symbol :: rest ->
      let next_state = transition state symbol in
      run next_state rest

(* Validación formal *)
let accepts word =
  let ending_state = run initial_state word in
  List.mem ending_state final_states


(* Ejecutable *)
let () =
  let result = accepts [One; Zero; One; One] in
  print_endline (string_of_bool result)


  let rec train_words (words) (transitions) (final_states) (next_free_state)  =
    match words with
    | [] -> (transitions, final_states, next_free_state)
    | (word, move_name) :: rest ->
        let (new_transitions, new_final_states, new_next_free_state) =
          train 0 (word) (move_name) (transitions) (final_states) (next_free_state) in
          train_words (rest) (new_transitions) (new_final_states) (new_next_free_state)

  let rec train (state) (word) (move_name) (transitions) (final_states) (next_free_state) =
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

  let rec find_transition (state) (symbol) (transitions) =
    match transitions with
    | [] -> None
    | (origin, sym, destination) :: rest ->
      if origin = state && sym = symbol then
        Some destination
      else
        find_transition (state) (symbol) (rest)

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
