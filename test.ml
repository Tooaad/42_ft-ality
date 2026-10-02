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

(* [Zero, Zero] *)
  let rec train (state) (word) (transitions) (final_states) (next_free_state) =
    match word with 
    | [] ->
    let new_final_states = state :: final_states in
    (List.rev transitions, new_final_states, next_free_state) (* Devolvemos la lista en orden de inicio-fin*)
    | symbol :: rest ->
      match find_transition state symbol transitions with
      | Some next_state ->
          train (next_state) (rest) (transitions) (next_free_state) (* Ha habido coincidencia con una transicion existente then pasamos *)
          | None ->
            let next_state = next_free_state in (* Aumentamos contador a donde transiciona el siguiente estado *)
            let new_transition = (state, symbol, next_state) in (* guardamos tupla *)
            let new_transitions = new_transition :: transitions in (* guardamos en la lista *)
            train (next_state) (rest) (new_transitions) (next_free_state+1) (* llamamos a la funcion de nuevo *)

  let rec find_transition (state) (symbol) (transitions) =
    match transitions with
    | [] -> None
    | (origin, sym, destination) :: rest ->
      if origin = state && sym = symbol then
        Some destination
      else
        find_transition (state) (symbol) (rest)