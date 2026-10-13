(* Terminal en modo normal: espera Enter y muestra lo que se escribe.
   El 2>/dev/null evita avisos de stty cuando la entrada no es un terminal (una pipe). *)
let stop () : unit =
  let _ = Sys.command "stty icanon echo 2>/dev/null" in
  ()

(* Terminal tecla a tecla y sin echo. Se restaura al salir (at_exit).
   Ctrl+C se convierte en un exit normal para que funcione como salir. *)
let start () : unit =
  let _ = Sys.command "stty -icanon -echo 2>/dev/null" in
  let () = at_exit stop in
  Sys.set_signal Sys.sigint (Sys.Signal_handle (fun _ -> exit 130))

(* Siguiente caracter de la entrada, o None si se acaba (EOF) o se pulsa Ctrl+D *)
let read_char () : char option =
  match input_char stdin with
  | '\004' -> None                  (* Ctrl+D *)
  | c -> Some c
  | exception End_of_file -> None

(* Tras un ESC: las flechas llegan como ESC '[' y una letra (A, B, C, D). Si no, "escape". *)
let read_arrow_key () : string =
  let first = read_char () in
  let second = if first = Some '[' then read_char () else None in
  match second with
  | Some 'A' -> "up"
  | Some 'B' -> "down"
  | Some 'C' -> "right"
  | Some 'D' -> "left"
  | _ -> "escape"

(* Nombre de una tecla normal: letras en minuscula, y nombres para espacio, Enter, tab y retroceso *)
let name_of_char (c : char) : string =
  match c with
  | ' ' -> "space"
  | '\n' | '\r' -> "return"        (* Enter *)
  | '\t' -> "tab"                  (* Tab *)
  | '\127' -> "backspace"          (* DEL (127): la tecla de retroceso *)
  | _ -> String.lowercase_ascii (String.make 1 c)

(* Nombre de la siguiente tecla pulsada, o None al acabarse la entrada (o con Ctrl+D) *)
let next_key () : string option =
  match read_char () with
  | None -> None
  | Some '\027' -> Some (read_arrow_key ())     (* ESC (27): podria ser una flecha *)
  | Some c -> Some (name_of_char c)
