(* Entrada de teclado por terminal: lee una tecla sin esperar a Enter y devuelve su
   nombre (el mismo que daria SDL), para compararlo con las teclas de la gramatica.
   Solo usa Pervasives, String y Sys. *)
let read_char () : char option =
  try Some (input_char stdin) with End_of_file -> None

(* Terminal en modo crudo: sin esperar Enter (-icanon) y sin repetir lo escrito (-echo).
   2>/dev/null para que no moleste si la entrada no es un terminal (por ejemplo, una tuberia). *)
let stop () : unit =
  let _ = Sys.command "stty icanon echo 2>/dev/null" in
  ()

(* Deja siempre el terminal como estaba al salir, tambien con Ctrl+C *)
let start () : unit =
  let _ = Sys.command "stty -icanon -echo 2>/dev/null" in
  let () = at_exit stop in
  Sys.set_signal Sys.sigint (Sys.Signal_handle (fun _ -> exit 130))

(* Ya leido el ESC: las flechas llegan como tres caracteres, ESC '[' letra.
   Si lo que sigue no es una flecha conocida, se devuelve "escape". *)
let read_escape () : string option =
  let first = read_char () in
  let second = if first = Some '[' then read_char () else None in
  match second with
  | Some 'A' -> Some "up"
  | Some 'B' -> Some "down"
  | Some 'C' -> Some "right"
  | Some 'D' -> Some "left"
  | _ -> Some "escape"

let name_of_char (c : char) : string =
  match c with
  | ' ' -> "space"
  | '\n' | '\r' -> "return"
  | '\t' -> "tab"
  | '\127' -> "backspace"
  | _ -> String.lowercase_ascii (String.make 1 c)

(* Nombre de la siguiente tecla pulsada. None cuando se acaba la entrada o con Ctrl+D. *)
let next_key () : string option =
  match read_char () with
  | None | Some '\004' -> None
  | Some '\027' -> read_escape ()
  | Some c -> Some (name_of_char c)
