(* PASO 1: partir un texto en dos por el primer separador.
   split_once '=' "s = [BP]"  ->  Some ("s ", " [BP]")
   split_once '=' "basura"     ->  None *)
let split_once (sep : char) (s : string) : (string * string) option =
  match String.index_opt s sep with
  | None -> None
  | Some i ->
    let left = String.sub s 0 i in
    let right = String.sub s (i + 1) (String.length s - i - 1) in
    Some (left, right)
