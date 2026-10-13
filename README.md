# ft_ality

Entrenador de combos de juegos de lucha basado en un autómata finito, hecho en OCaml.
Ver `en.subject.pdf` para el enunciado.

## Primeros pasos

### 1. Instalar el entorno OCaml (WSL2 / Ubuntu)

```bash
make -f setup.mk
```

Esto instala `opam`, OCaml y las herramientas de desarrollo (`ocaml-lsp-server`, `utop`). El proyecto solo necesita OCaml y se construye con el `Makefile`.
Pide `sudo` y tarda unos minutos.

Cuando termine, carga el entorno en tu terminal:

```bash
eval $(opam env)
```

Comprueba que funciona:

```bash
ocaml -version
```

> `setup.mk` es solo para preparar la máquina de desarrollo. No es el Makefile del proyecto.

### 2. Instalar la extensión de VS Code

Instala **OCaml Platform** (de OCaml Labs). Da errores en vivo, tipos al pasar el ratón y autocompletado.

### 3. Probar OCaml

Abre el intérprete interactivo:

```bash
utop
```

Escribe una expresión terminada en `;;` (solo en `utop`; en los ficheros del proyecto `;;` está prohibido), por ejemplo `1 + 2;;`. Sal con `Ctrl+D`.

## Reglas del subject a tener presentes

- Lenguaje funcional, sin librerías externas que hagan el trabajo.
- Módulos permitidos: `Pervasives`, `List`, `String`, `Sys`, `Sdl`, `Sdlevent`, `Sdlkey`.
- Prohibidos: la palabra clave `open` y el token `;;` en el código fuente.
- Las teclas se calculan desde la gramática, nunca se hardcodean.
- Hay que entregar un `Makefile` que compile todo el proyecto y nuestros propios ficheros de gramática.

---

## Guía de OCaml y programación funcional


Este documento resume los conceptos básicos necesarios para empezar a programar en **OCaml** y entender el paradigma de **programación funcional**.

---

### 1. ¿Qué es OCaml?

OCaml es un lenguaje de programación **multiparadigma**, aunque destaca especialmente por la programación funcional.

Permite utilizar:

- Programación funcional.
- Programación imperativa.
- Programación orientada a objetos.
- Sistemas de tipos avanzados.
- Pattern matching.
- Módulos.

En programación funcional intentamos pensar un programa como una combinación de **funciones que transforman datos**.

Por ejemplo:

```ocaml
let doble x =
  x * 2
```

Esta función recibe un número y devuelve su doble.

```text
doble 5
→ 10
```

---

### 2. `let`: declarar valores y funciones

En OCaml usamos `let` para definir valores.

```ocaml
let numero = 10
```

También podemos definir strings:

```ocaml
let nombre = "Gonzalo"
```

Y funciones:

```ocaml
let doble x =
  x * 2
```

Podemos utilizarla así:

```ocaml
doble 5
```

Resultado:

```text
10
```

Una función con dos parámetros:

```ocaml
let sumar a b =
  a + b
```

Uso:

```ocaml
sumar 5 3
```

Resultado:

```text
8
```

---

### 3. Tipos

OCaml tiene tipado estático.

Esto significa que comprueba los tipos antes de ejecutar el programa.

Por ejemplo:

```ocaml
let sumar a b =
  a + b
```

OCaml puede deducir automáticamente que la función trabaja con enteros:

```text
val sumar : int -> int -> int
```

Esto significa:

```text
int
 ↓
recibe un entero

int
 ↓
recibe otro entero

int
 ↓
devuelve un entero
```

Por tanto:

```ocaml
sumar 5 10
```

es correcto.

Pero:

```ocaml
sumar 5 "hola"
```

es incorrecto porque `"hola"` es un `string`.

---

### 4. Tipos básicos

Algunos tipos importantes son:

```ocaml
int
float
string
char
bool
```

Ejemplos:

```ocaml
let edad = 20
let altura = 1.80
let nombre = "Juan"
let letra = 'A'
let activo = true
```

Importante: OCaml diferencia entre `int` y `float`.

Para enteros usamos:

```ocaml
1 + 2
```

Para floats:

```ocaml
1.0 +. 2.0
```

Los operadores de los floats llevan `.`:

```text
+.   suma
-.   resta
*.   multiplicación
/.   división
```

---

### 5. `if / else`

OCaml permite utilizar condiciones:

```ocaml
let mayor_de_edad edad =
  if edad >= 18 then
    true
  else
    false
```

Podemos simplificarlo:

```ocaml
let mayor_de_edad edad =
  edad >= 18
```

Ejemplo:

```ocaml
mayor_de_edad 20
```

Resultado:

```text
true
```

---

### 6. Listas

Las listas son una de las estructuras más utilizadas en programación funcional.

Una lista de números:

```ocaml
let numeros = [1; 2; 3; 4; 5]
```

Una lista de strings:

```ocaml
let nombres = ["Ana"; "Juan"; "Pedro"]
```

Una lista debe contener elementos del mismo tipo.

Esto es válido:

```ocaml
[1; 2; 3]
```

Esto no:

```ocaml
[1; "hola"; 3]
```

---

### 7. Lista vacía

Una lista vacía se representa como:

```ocaml
[]
```

Por ejemplo:

```ocaml
let lista = []
```

---

### 8. Cabeza y cola de una lista

Una lista se puede pensar como:

```text
cabeza :: cola
```

Por ejemplo:

```ocaml
[1; 2; 3; 4]
```

puede verse como:

```text
1 :: [2; 3; 4]
```

Por tanto:

```text
cabeza = 1

cola = [2; 3; 4]
```

El operador `::` se utiliza para añadir un elemento al principio de una lista.

```ocaml
1 :: [2; 3; 4]
```

produce:

```ocaml
[1; 2; 3; 4]
```

---

### 9. Pattern Matching

El **pattern matching** permite comprobar la forma que tienen los datos.

Es uno de los conceptos más importantes de OCaml.

Por ejemplo:

```ocaml
let primero lista =
  match lista with
  | [] -> 0
  | cabeza :: cola -> cabeza
```

Tenemos dos posibilidades.

Si la lista está vacía:

```ocaml
[]
```

devuelve:

```text
0
```

Si contiene elementos:

```ocaml
cabeza :: cola
```

devuelve la cabeza.

Ejemplo:

```ocaml
primero [10; 20; 30]
```

Resultado:

```text
10
```

---

### 10. El carácter `_`

Cuando no necesitamos utilizar un valor podemos poner `_`.

Por ejemplo:

```ocaml
let primero lista =
  match lista with
  | [] -> 0
  | cabeza :: _ -> cabeza
```

Aquí solo queremos `cabeza`.

No necesitamos utilizar la cola.

Por eso escribimos:

```ocaml
cabeza :: _
```

---

### 11. Recursividad

En programación funcional la recursividad suele sustituir muchos de los bucles tradicionales.

Una función recursiva es una función que se llama a sí misma.

En OCaml debemos utilizar:

```ocaml
let rec
```

Por ejemplo:

```ocaml
let rec cuenta_atras n =
  if n <= 0 then
    0
  else
    cuenta_atras (n - 1)
```

---

### 12. Recorrer una lista mediante recursividad

Podemos recorrer una lista utilizando pattern matching y recursividad.

Por ejemplo, para sumar todos sus elementos:

```ocaml
let rec suma lista =
  match lista with
  | [] -> 0
  | cabeza :: cola ->
      cabeza + suma cola
```

Supongamos:

```ocaml
suma [1; 2; 3]
```

La ejecución conceptualmente sería:

```text
1 + suma [2; 3]

1 + 2 + suma [3]

1 + 2 + 3 + suma []

1 + 2 + 3 + 0
```

Resultado:

```text
6
```

---

### 13. Calcular la longitud de una lista

También podemos calcular manualmente la longitud:

```ocaml
let rec longitud lista =
  match lista with
  | [] -> 0
  | _ :: cola ->
      1 + longitud cola
```

Ejemplo:

```ocaml
longitud [10; 20; 30]
```

Resultado:

```text
3
```

Observa:

```ocaml
_ :: cola
```

No necesitamos saber el valor de cada elemento.

Solo queremos contar cuántos existen.

---

### 14. Funciones como argumentos

Una característica fundamental de la programación funcional es que una función puede recibir otra función.

Por ejemplo:

```ocaml
let aplicar funcion valor =
  funcion valor
```

Podemos definir:

```ocaml
let doble x =
  x * 2
```

Y hacer:

```ocaml
aplicar doble 5
```

Resultado:

```text
10
```

Las funciones pueden tratarse como cualquier otro valor.

---

### 15. Funciones anónimas

No siempre necesitamos dar nombre a una función.

Podemos escribir:

```ocaml
fun x -> x * 2
```

Esto representa una función que recibe `x` y devuelve:

```ocaml
x * 2
```

Por ejemplo:

```ocaml
List.map (fun x -> x * 2) [1; 2; 3]
```

Resultado:

```ocaml
[2; 4; 6]
```

---

### 16. `List.map`

`List.map` aplica una función a cada elemento de una lista.

Ejemplo:

```ocaml
let doble x =
  x * 2

let numeros = [1; 2; 3; 4]

let resultado =
  List.map doble numeros
```

Resultado:

```ocaml
[2; 4; 6; 8]
```

También podemos escribirlo directamente:

```ocaml
List.map (fun x -> x * 2) [1; 2; 3; 4]
```

Resultado:

```ocaml
[2; 4; 6; 8]
```

Conceptualmente:

```text
[1; 2; 3; 4]

      ↓ función x * 2

[2; 4; 6; 8]
```

---

### 17. `List.filter`

`List.filter` permite conservar únicamente los elementos que cumplen una condición.

Por ejemplo:

```ocaml
let numeros = [1; 2; 3; 4; 5; 6]

let pares =
  List.filter
    (fun x -> x mod 2 = 0)
    numeros
```

Resultado:

```ocaml
[2; 4; 6]
```

La función:

```ocaml
fun x -> x mod 2 = 0
```

devuelve:

```text
true
```

cuando el número es par.

---

### 18. `List.fold_left`

`List.fold_left` permite recorrer una lista acumulando un resultado.

Por ejemplo:

```ocaml
List.fold_left ( + ) 0 [1; 2; 3; 4]
```

Resultado:

```text
10
```

Conceptualmente hace:

```text
0 + 1 = 1

1 + 2 = 3

3 + 3 = 6

6 + 4 = 10
```

La estructura general es:

```ocaml
List.fold_left funcion valor_inicial lista
```

Por ejemplo:

```ocaml
List.fold_left ( + ) 0 numeros
```

---

### 19. `map`, `filter` y `fold`

Estas tres funciones aparecen constantemente en programación funcional.

#### `map`

Transforma elementos.

```text
[1; 2; 3]
    ↓
x * 2
    ↓
[2; 4; 6]
```

```ocaml
List.map (fun x -> x * 2) [1; 2; 3]
```

---

#### `filter`

Selecciona elementos.

```text
[1; 2; 3; 4]
       ↓
   solo pares
       ↓
[2; 4]
```

```ocaml
List.filter (fun x -> x mod 2 = 0) [1; 2; 3; 4]
```

---

#### `fold`

Combina todos los elementos para producir un resultado.

```text
[1; 2; 3; 4]
       ↓
      suma
       ↓
       10
```

```ocaml
List.fold_left ( + ) 0 [1; 2; 3; 4]
```

---

### 20. Inmutabilidad

En programación funcional intentamos evitar modificar valores existentes.

Por ejemplo:

```ocaml
let x = 10
```

No pensamos normalmente en cambiar `x`.

En su lugar creamos un nuevo valor:

```ocaml
let y = x + 1
```

Ahora:

```text
x = 10
y = 11
```

Esto facilita razonar sobre lo que hace un programa.

---

### 21. Transformación de datos

Una forma útil de pensar funcionalmente es:

```text
DATOS
  ↓
FUNCIÓN
  ↓
NUEVOS DATOS
  ↓
FUNCIÓN
  ↓
RESULTADO
```

Por ejemplo:

```ocaml
let numeros = [1; 2; 3; 4; 5; 6]

let dobles =
  List.map (fun x -> x * 2) numeros

let grandes =
  List.filter (fun x -> x > 5) dobles
```

Primero:

```text
[1;2;3;4;5;6]
```

aplicamos:

```text
x * 2
```

y obtenemos:

```text
[2;4;6;8;10;12]
```

Después filtramos los mayores que `5`:

```text
[6;8;10;12]
```

---

### 22. Tipos personalizados

OCaml permite crear nuestros propios tipos.

Por ejemplo:

```ocaml
type color =
  | Rojo
  | Verde
  | Azul
```

Ahora podemos crear:

```ocaml
let color_actual = Rojo
```

Y utilizar pattern matching:

```ocaml
let nombre_color color =
  match color with
  | Rojo -> "rojo"
  | Verde -> "verde"
  | Azul -> "azul"
```

Ejemplo:

```ocaml
nombre_color Verde
```

Resultado:

```text
"verde"
```

---

### 23. Tipos con información

Los tipos también pueden almacenar información.

Por ejemplo:

```ocaml
type figura =
  | Circulo of float
  | Rectangulo of float * float
```

Podemos crear:

```ocaml
let figura1 =
  Circulo 5.0

let figura2 =
  Rectangulo (10.0, 5.0)
```

Y calcular su área:

```ocaml
let area figura =
  match figura with
  | Circulo radio ->
      3.14159 *. radio *. radio

  | Rectangulo (ancho, alto) ->
      ancho *. alto
```

---

### 24. Árboles

Los tipos propios permiten representar estructuras más complejas.

Por ejemplo:

```ocaml
type arbol =
  | Hoja of int
  | Nodo of arbol * arbol
```

Podemos crear:

```ocaml
let arbol =
  Nodo (
    Hoja 10,
    Nodo (
      Hoja 20,
      Hoja 30
    )
  )
```

Visualmente:

```text
        Nodo
       /    \
     10     Nodo
           /    \
         20      30
```

Podemos sumar sus valores:

```ocaml
let rec suma_arbol arbol =
  match arbol with
  | Hoja valor ->
      valor

  | Nodo (izquierda, derecha) ->
      suma_arbol izquierda +
      suma_arbol derecha
```

Resultado:

```text
60
```

---

### 25. Tuplas

Una tupla agrupa varios valores.

```ocaml
let persona =
  ("Juan", 25)
```

Su tipo sería aproximadamente:

```text
string * int
```

Podemos extraer sus valores mediante pattern matching:

```ocaml
let mostrar_persona persona =
  match persona with
  | (nombre, edad) ->
      nombre
```

También podemos escribir:

```ocaml
let (nombre, edad) = persona
```

---

### 26. `option`

En muchos lenguajes se utiliza `null` para representar que algo no existe.

OCaml normalmente utiliza:

```ocaml
option
```

Un valor puede ser:

```ocaml
Some valor
```

o:

```ocaml
None
```

Ejemplo:

```ocaml
let buscar_primero lista =
  match lista with
  | [] ->
      None

  | cabeza :: _ ->
      Some cabeza
```

Ejemplo:

```ocaml
buscar_primero [10; 20]
```

Resultado:

```ocaml
Some 10
```

Mientras que:

```ocaml
buscar_primero []
```

produce:

```ocaml
None
```

---

### 27. Módulos

Los módulos permiten organizar el código.

La biblioteca estándar de OCaml tiene módulos como:

```text
List
String
Array
Option
```

Por ejemplo:

```ocaml
List.length [1; 2; 3]
```

Resultado:

```text
3
```

Aquí:

```text
List
```

es el módulo.

Y:

```text
length
```

es una función del módulo.

Otros ejemplos:

```ocaml
List.map
List.filter
List.fold_left
List.length
List.rev
```

---

### 28. Leer documentación de un módulo

Cuando veas algo como:

```ocaml
List.map
```

puedes interpretarlo como:

```text
Módulo.función
```

Es decir:

```text
List.map
│    │
│    └── función map
│
└─────── módulo List
```

En la documentación encontrarás tipos similares a:

```text
map : ('a -> 'b) -> 'a list -> 'b list
```

Al principio parece complicado, pero significa:

```text
('a -> 'b)
```

recibe una función.

Después:

```text
'a list
```

recibe una lista.

Finalmente:

```text
'b list
```

devuelve otra lista.

Por ejemplo:

```ocaml
List.map
  (fun x -> string_of_int x)
  [1; 2; 3]
```

Transforma:

```text
int list
```

en:

```text
string list
```

Resultado:

```ocaml
["1"; "2"; "3"]
```

---

### 29. `'a`, `'b`, etc.

Cuando aparezca:

```text
'a
```

no significa que exista un tipo llamado `a`.

Significa:

```text
cualquier tipo
```

Por ejemplo:

```text
'a list
```

significa:

```text
lista de cualquier tipo
```

Puede ser:

```text
int list
string list
bool list
```

Por ejemplo, la función:

```text
List.length : 'a list -> int
```

significa:

```text
recibe una lista de cualquier tipo
y devuelve un entero
```

Por eso funcionan tanto:

```ocaml
List.length [1; 2; 3]
```

como:

```ocaml
List.length ["a"; "b"; "c"]
```

---

### 30. Programación imperativa frente a funcional

Una suma en estilo imperativo podría pensarse como:

```text
total = 0

para cada número:
    total = total + número
```

Estamos modificando `total`.

En programación funcional podemos escribir:

```ocaml
List.fold_left ( + ) 0 numeros
```

Aquí describimos una transformación sobre los datos.

Una forma simplificada de diferenciarlos es:

```text
IMPERATIVO

hacer esto
después esto
cambiar esta variable
hacer este bucle
cambiar otra variable
```

frente a:

```text
FUNCIONAL

datos
 ↓
función
 ↓
datos
 ↓
función
 ↓
resultado
```

---

### 31. Orden recomendado para aprender OCaml

Un buen orden para aprenderlo es:

```text
1. let
   ↓
2. funciones
   ↓
3. tipos
   ↓
4. if / else
   ↓
5. listas
   ↓
6. pattern matching
   ↓
7. recursividad
   ↓
8. List.map
   ↓
9. List.filter
   ↓
10. List.fold_left
    ↓
11. funciones anónimas
    ↓
12. funciones de orden superior
    ↓
13. tipos propios
    ↓
14. option
    ↓
15. módulos
```

---

### 32. Ejemplo completo

Supongamos que tenemos:

```ocaml
let numeros =
  [1; 2; 3; 4; 5; 6; 7; 8]
```

Queremos:

1. quedarnos con los números pares;
2. multiplicarlos por dos;
3. sumarlos.

Primero filtramos:

```ocaml
let pares =
  List.filter
    (fun x -> x mod 2 = 0)
    numeros
```

Resultado:

```ocaml
[2; 4; 6; 8]
```

Después multiplicamos:

```ocaml
let dobles =
  List.map
    (fun x -> x * 2)
    pares
```

Resultado:

```ocaml
[4; 8; 12; 16]
```

Finalmente sumamos:

```ocaml
let resultado =
  List.fold_left
    ( + )
    0
    dobles
```

Resultado:

```text
40
```

Todo podría escribirse también como:

```ocaml
let resultado =
  numeros
  |> List.filter (fun x -> x mod 2 = 0)
  |> List.map (fun x -> x * 2)
  |> List.fold_left ( + ) 0
```

---

### 33. Operador `|>`

El operador:

```ocaml
|>
```

se llama **pipeline operator**.

Permite pasar el resultado de una operación a la siguiente.

En vez de:

```ocaml
List.map doble numeros
```

podemos escribir:

```ocaml
numeros
|> List.map doble
```

Esto permite crear cadenas fáciles de leer:

```ocaml
numeros
|> List.filter (fun x -> x mod 2 = 0)
|> List.map (fun x -> x * 2)
|> List.fold_left ( + ) 0
```

Podemos leerlo como:

```text
numeros

↓ filtrar pares

↓ multiplicar cada uno por 2

↓ sumar todos

resultado
```

---

### 34. Conceptos fundamentales que deberías recordar

Si estás empezando, los conceptos más importantes son:

```text
let
```

Define valores o funciones.

```ocaml
let x = 10
```

---

```text
fun
```

Crea una función anónima.

```ocaml
fun x -> x * 2
```

---

```text
match
```

Permite hacer pattern matching.

```ocaml
match lista with
| [] -> ...
| cabeza :: cola -> ...
```

---

```text
rec
```

Permite que una función se llame a sí misma.

```ocaml
let rec funcion x =
  ...
```

---

```text
::
```

Separa o construye cabeza y cola de una lista.

```ocaml
cabeza :: cola
```

---

```text
[]
```

Lista vacía.

---

```text
_
```

Valor que no necesitamos utilizar.

---

```text
List.map
```

Transformar elementos.

---

```text
List.filter
```

Filtrar elementos.

---

```text
List.fold_left
```

Combinar elementos y obtener un resultado.

---

### 35. Resumen

OCaml utiliza mucho:

```text
Funciones
+
Listas
+
Pattern Matching
+
Recursividad
+
Tipos
+
Funciones de orden superior
```

La idea principal de la programación funcional puede resumirse como:

```text
ENTRADA
   ↓
FUNCIÓN
   ↓
SALIDA
```

Y programas más complejos se construyen conectando muchas funciones:

```text
DATOS
  ↓
FUNCIÓN A
  ↓
DATOS
  ↓
FUNCIÓN B
  ↓
DATOS
  ↓
FUNCIÓN C
  ↓
RESULTADO
```

En lugar de empezar pensando:

```text
¿Qué variables tengo que modificar?
```

es útil empezar pensando:

```text
¿Qué datos tengo?

¿Qué resultado quiero?

¿Qué función transforma unos en otros?
```

Ese cambio de mentalidad es una de las partes más importantes de aprender programación funcional.
