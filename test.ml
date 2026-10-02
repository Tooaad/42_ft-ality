(* Q: conjunto de estados *)
type state =
  | Q0
  | Q1

(* Σ: alfabeto *)
type symbol =
  | Zero
  | One

(* Q0: estado inicial *)
let initial_state = Q0

(* F: estados finales *)
let final_states = [Q1]

(* δ: función de transición *)
let transition state symbol =
  match state, symbol with
  | Q0, Zero -> Q0
  | Q0, One  -> Q1
  | Q1, Zero -> Q0
  | Q1, One  -> Q1
  | _ -> None

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