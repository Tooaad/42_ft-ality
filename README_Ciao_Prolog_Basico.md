# Guía básica de Ciao/Prolog

Esta guía explica conceptos básicos de Ciao/Prolog con ejemplos sencillos: hechos, reglas, `member/2`, listas con `Head|Tail`, cálculo de longitud y cómo leer la documentación de un módulo.

---

## 1. Hechos, reglas y "funciones"

En Prolog normalmente no se piensa en funciones como en Java, C o Python.

Se trabaja sobre todo con **predicados** que describen relaciones.

### Hechos

Un hecho afirma que algo es cierto:

```prolog
padre(juan, ana).
padre(juan, pedro).
padre(carlos, juan).
```

Esto se puede leer como:

- Juan es padre de Ana.
- Juan es padre de Pedro.
- Carlos es padre de Juan.

Puedes hacer consultas:

```prolog
?- padre(juan, ana).
```

Resultado:

```text
yes
```

También puedes usar variables:

```prolog
?- padre(juan, X).
```

Posibles respuestas:

```text
X = ana ;
X = pedro.
```

La variable `X` significa: "busca qué valores hacen cierta esta relación".

---

## 2. Reglas

Una regla permite definir una relación usando otras relaciones.

Ejemplo:

```prolog
hermanos(X, Y) :-
    padre(P, X),
    padre(P, Y).
```

Se puede leer así:

> X e Y son hermanos si existe un P que es padre de X y también padre de Y.

### Qué significa `:-`

```prolog
A :- B.
```

se lee aproximadamente:

> A es cierto si B es cierto.

Por ejemplo:

```prolog
hermanos(ana, pedro)
```

será cierto si Prolog encuentra un mismo `P` tal que:

```prolog
padre(P, ana)
```

y:

```prolog
padre(P, pedro)
```

Con estos hechos:

```prolog
padre(juan, ana).
padre(juan, pedro).
```

la consulta:

```prolog
?- hermanos(ana, pedro).
```

puede tener éxito porque:

```text
P = juan
```

### Importante: la coma significa "Y"

```prolog
padre(P, X),
padre(P, Y).
```

significa:

```text
padre(P, X) Y padre(P, Y)
```

Las dos condiciones tienen que cumplirse.

### Evitar que alguien sea "hermano de sí mismo"

La regla anterior también permite:

```prolog
?- hermanos(ana, ana).
```

porque Juan es padre de Ana en ambos casos.

Puedes evitarlo así:

```prolog
hermanos(X, Y) :-
    padre(P, X),
    padre(P, Y),
    X \= Y.
```

`X \= Y` significa que X e Y no deben ser iguales.

---

## 3. Predicados frente a funciones

En Python podrías tener:

```python
def suma(a, b):
    return a + b
```

En Prolog normalmente usarías una relación:

```prolog
suma(A, B, Resultado) :-
    Resultado is A + B.
```

Consulta:

```prolog
?- suma(2, 3, X).
```

Resultado:

```text
X = 5
```

El resultado no se devuelve con `return`: se obtiene mediante una variable.

---

## 4. Listas

Una lista se escribe:

```prolog
[a, b, c, d]
```

Una lista tiene dos partes principales:

```prolog
[Head | Tail]
```

- `Head` es el primer elemento.
- `Tail` es la lista restante.

Ejemplo:

```prolog
?- [Head|Tail] = [a,b,c,d].
```

Resultado:

```text
Head = a
Tail = [b,c,d]
```

Otro ejemplo:

```prolog
?- [X|Xs] = [10,20,30].
```

Resultado:

```text
X = 10
Xs = [20,30]
```

---

## 5. El guion bajo `_`

El símbolo:

```prolog
_
```

significa:

> Hay un valor aquí, pero no me interesa cuál es.

Ejemplo:

```prolog
[Head|_]
```

significa:

> Quiero el primer elemento, pero no me importa el resto.

Consulta:

```prolog
?- [Head|_] = [a,b,c].
```

Resultado:

```text
Head = a
```

También:

```prolog
[_|Tail]
```

significa:

> No me importa el primer elemento, quiero el resto.

```prolog
?- [_|Tail] = [a,b,c].
```

Resultado:

```text
Tail = [b,c]
```

Cada aparición de `_` representa una variable anónima nueva.

---

## 6. `member/2`

`member/2` representa la relación:

```prolog
member(Elemento, Lista)
```

y significa:

> Elemento pertenece a Lista.

Ejemplo:

```prolog
?- member(a, [a,b,c]).
```

Resultado:

```text
yes
```

Ejemplo:

```prolog
?- member(c, [a,b,c]).
```

Resultado:

```text
yes
```

### Buscar elementos usando una variable

```prolog
?- member(X, [a,b,c]).
```

Prolog puede devolver:

```text
X = a ;
X = b ;
X = c.
```

Esto muestra una diferencia importante respecto a una función tradicional: el predicado también puede usarse para **buscar valores**.

---

## 7. ¿Por qué `member(c, X)` parece infinito?

Consulta:

```prolog
?- member(c, X).
```

Aquí `X` no está definida.

Prolog interpreta la consulta como:

> Busca listas X que contengan a `c`.

Hay infinitas listas que contienen `c`.

Por ejemplo:

```text
X = [c]
X = [c, _]
X = [_, c]
X = [c, _, _]
X = [_, c, _]
X = [_, _, c]
...
```

Por eso, si sigues pidiendo más soluciones con `;`, Prolog puede seguir generando respuestas indefinidamente.

No significa necesariamente que la primera respuesta tarde para siempre. El problema es que el **conjunto de soluciones es infinito**.

### Ejemplo conceptual

Una implementación sencilla de `member/2` sería:

```prolog
mi_member(X, [X|_]).

mi_member(X, [_|Tail]) :-
    mi_member(X, Tail).
```

Primera regla:

```prolog
mi_member(X, [X|_]).
```

dice:

> X pertenece a una lista si X es su primer elemento.

Segunda regla:

```prolog
mi_member(X, [_|Tail]) :-
    mi_member(X, Tail).
```

dice:

> X pertenece a una lista si pertenece a su cola.

Con:

```prolog
?- mi_member(c, X).
```

la primera regla ya puede construir:

```text
X = [c|_]
```

y la segunda puede construir listas donde `c` aparezca más adelante.

Por eso hay infinitas posibilidades.

---

## 8. Cómo funciona `member/2` paso a paso

Supón:

```prolog
?- mi_member(c, [a,b,c]).
```

Primera llamada:

```prolog
mi_member(c, [a,b,c])
```

La cabeza es `a`, no `c`, así que usa:

```prolog
mi_member(c, [b,c])
```

Después:

```prolog
mi_member(c, [c])
```

Ahora la primera regla encaja:

```prolog
mi_member(X, [X|_]).
```

con:

```text
X = c
```

y la consulta tiene éxito.

---

## 9. Calcular la longitud de una lista

Una versión recursiva:

```prolog
longitud([], 0).

longitud([_|Tail], N) :-
    longitud(Tail, N0),
    N is N0 + 1.
```

### Caso base

```prolog
longitud([], 0).
```

La lista vacía tiene longitud 0.

### Caso recursivo

```prolog
longitud([_|Tail], N) :-
    longitud(Tail, N0),
    N is N0 + 1.
```

Se puede leer:

> La longitud de una lista es la longitud de su cola más 1.

Consulta:

```prolog
?- longitud([a,b,c], N).
```

Proceso conceptual:

```text
longitud([a,b,c], N)
    -> longitud([b,c], N0)

longitud([b,c], N0)
    -> longitud([c], N1)

longitud([c], N1)
    -> longitud([], N2)

longitud([], 0)

N1 = 0 + 1 = 1
N0 = 1 + 1 = 2
N  = 2 + 1 = 3
```

Resultado:

```text
N = 3
```

---

## 10. `is` no es lo mismo que `=`

Esto es importante.

```prolog
X = 2 + 3.
```

no calcula necesariamente la suma.

Simplemente unifica X con el término:

```text
2 + 3
```

En cambio:

```prolog
X is 2 + 3.
```

evalúa la expresión aritmética.

Resultado:

```text
X = 5
```

Por eso en la longitud usamos:

```prolog
N is N0 + 1.
```

---

## 11. Qué significa `member/2`, `append/3`, etc.

Cuando ves:

```text
member/2
```

significa:

```text
nombre: member
número de argumentos: 2
```

Por eso se usa:

```prolog
member(X, Lista)
```

Cuando ves:

```text
append/3
```

significa que el predicado recibe tres argumentos:

```prolog
append(Lista1, Lista2, Resultado)
```

Ejemplo:

```prolog
?- append([a,b], [c,d], X).
```

Resultado:

```text
X = [a,b,c,d]
```

---

## 12. Qué significa `Usage` en la documentación

En la documentación de un módulo, `Usage` indica **cómo se utiliza un predicado**.

Por ejemplo, imagina:

```text
member(?Element, ?List)
```

Esto te está diciendo que existe un predicado llamado:

```prolog
member/2
```

y que se utiliza con dos argumentos:

```prolog
member(Element, List)
```

Por ejemplo:

```prolog
member(c, [a,b,c])
```

o:

```prolog
member(X, [a,b,c])
```

La documentación puede usar símbolos para indicar si un argumento normalmente entra ya conocido o puede ser una variable. La notación exacta puede variar según la documentación y las aserciones de Ciao.

La idea importante es:

```text
Usage
```

no es código que tengas que copiar literalmente.

Es una explicación de **qué forma tienen las llamadas válidas o esperadas al predicado**.

---

## 13. Cómo leer la documentación de un módulo

Supón que estás leyendo la documentación del módulo `List`.

No intentes entender todo el módulo de una vez.

Busca primero los predicados exportados.

Puedes encontrarte algo como:

```text
member/2
append/3
length/2
reverse/2
```

Escoge uno.

### Paso 1: mira su nombre y aridad

```text
member/2
```

Dos argumentos.

### Paso 2: mira Usage

Podría indicar algo parecido a:

```text
member(Element, List)
```

Ya sabes cómo llamarlo.

### Paso 3: mira la descripción

Por ejemplo:

```text
Element is an element of List.
```

Traducido:

> Element es un elemento de List.

### Paso 4: prueba ejemplos

```prolog
?- member(a, [a,b,c]).
```

Después:

```prolog
?- member(X, [a,b,c]).
```

Después:

```prolog
?- member(c, X).
```

Compara qué cambia.

### Paso 5: experimenta con variables

Prolog se entiende mucho mejor experimentando que memorizando predicados.

---

## 14. Ejemplos importantes de `member/2`

### Comprobar si existe

```prolog
?- member(c, [a,b,c]).
```

```text
yes
```

### Buscar todos los elementos

```prolog
?- member(X, [a,b,c]).
```

```text
X = a ;
X = b ;
X = c.
```

### Buscar una lista desconocida

```prolog
?- member(c, X).
```

Puede generar infinitas listas posibles que contengan `c`.

### Repeticiones

```prolog
?- member(X, [a,b,a]).
```

Puede devolver:

```text
X = a ;
X = b ;
X = a.
```

`member/2` recorre posiciones, no elimina duplicados.

---

## 15. Ejemplo completo con padres y hermanos

Antes de hacer consultas sobre los predicados guardados en un archivo, hay que
cargarlo en la sesión de Ciao:

```text
$ ciaosh
?- consult('FormalDef.pl').
yes
?- padre(juan, X).
X = ana ?
X = pedro ?
yes
```

También puedes cargarlo desde el directorio del proyecto con:

```text
?- ['FormalDef'].
```

```prolog
padre(juan, ana).
padre(juan, pedro).
padre(carlos, juan).

hermanos(X, Y) :-
    padre(P, X),
    padre(P, Y),
    X \= Y.
```

Consultas:

```prolog
?- padre(juan, X).
```

```text
X = ana ;
X = pedro.
```

```prolog
?- hermanos(ana, pedro).
```

```text
yes
```

```prolog
?- hermanos(ana, X).
```

Puede obtener:

```text
X = pedro
```

---

## 16. Regla mental para leer Prolog

Cuando veas:

```prolog
resultado(X) :-
    condicion1(X),
    condicion2(X).
```

léelo como:

> `resultado(X)` es cierto SI `condicion1(X)` es cierta Y `condicion2(X)` es cierta.

Ejemplo:

```prolog
puede_conducir(X) :-
    mayor_de_edad(X),
    tiene_carnet(X).
```

Se lee:

> X puede conducir si X es mayor de edad y X tiene carnet.

No pienses todavía en "llamar funciones".

Piensa en:

```text
hechos + relaciones + condiciones
```

---

## 17. Resumen rápido

```text
hecho:
    padre(juan, ana).

regla:
    hermanos(X,Y) :-
        padre(P,X),
        padre(P,Y).

variable:
    X

lista:
    [a,b,c]

cabeza y cola:
    [Head|Tail]

ignorar un valor:
    _

pertenencia:
    member(X, Lista)

predicado de 2 argumentos:
    member/2

condición "Y":
    ,

"es cierto si":
    :-

evaluar una operación matemática:
    is
```

La idea más importante es que Prolog intenta encontrar valores para las variables que hagan verdaderas las relaciones que has escrito.
