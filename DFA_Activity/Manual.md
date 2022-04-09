# Manual de usuario

Nombres:

Joshua Amaya A01025258

Andrea Yela A01025250

---
## Indice
- [Introducción](#¿Qué-es-un-DFA?)

- [Objetivo](Objetivo-del-programa)

- [Instrucciones de actividad](#Instrucciones-de-actividad])

- [Instrucciones de uso](#Instrucciones-de-uso)
    - [Paso 1](#1.-Definir-la-función-a-usar)
    - [Paso 2](#2.-Compilar-el-código)
    - [Paso 3](#3.-Resultados-y-salida-del-DFA)
    - [Paso 4](#4.-Lectura-de-resultado)

- [Referencias](#Referencias)

---

## ¿Qué es un DFA?

Un Autómata Finito Determinista (DFA por sus siglas en inglés) es una máquina de estados finitos que acepta o rechaza ciertos simbolos (como pueden ser strings) corriéndolos por una secuencia que valida cada estado en el que se encuentra el autómata. Este tipo de métodos se utilizan en videojuegos para el movimiento de cierto personaje o hasta en máquinas dispensadoras que analizan la cantidad de dinero que se ingresa. 

---
## Objetivo del programa

Este DFA se programó con el propósito de poder determinar y separar los elementos que componen una fórmula, desde las variables, los operadores, los tipos de números, exponentes así como los comentarios que pueden llegar a poseer.

Este DFA ha sido programado en Racket, por lo que se recomienda descargar la versión más reciente dentro de la siguiente liga:

https://download.racket-lang.org/

---
## Instrucciones de actividad

Hacer una función que reciba como argumento un string que contenga expresiones aritméticas y comentarios, y nos regrese una lista con cada uno de sus tokens encontrados, en el orden en que fueron encontrados e indicando de qué tipo son.

---

## Instrucciones de uso

Para una mejor experiencia y mejores resultados sobre el uso del DFA presentado en este repositorio, se recomienda seguir las instrucciones siguientes:

### 1. Definir la función a usar:

Para poder usar de forma eficiente este DFA, se debe de definir una función al final del código que se llamará **_arithmetic-lexer_**; junto con la fórmula que se desee separar entre sus componentes.

Como ejemplo, la función puede quedar de la siguiente forma:

```
(arithmetic-lexer "723")
(arithmetic-lexer "345 + 1")
(arithmetic-lexer "56.3 / 2")
(arithmetic-lexer "56.3 / 2 ^ 4")
```

### 2. Compilar el código

Una vez definida la función junto con los elementos a separar, se deberá compilar el código en el ambiente de su preferencia.

### 3. Resultados y salida del DFA

Una vez compilado el código se deberá correr para poder obtener los resultados de la fórmula ingresada.

### 4. Lectura de resultado

El resultado del DFA se mostrará de acuerdo a la fórmula ingresada, mostrando en consola los elementos separados del string. Los resultados en consola pueden mostrarse de la siguiente forma:

```
(arithmetic-lexer "723")
    '(("723" int))

(arithmetic-lexer "345 + 1")
    '(("345" int) ("+" operator) ("1" int))

(arithmetic-lexer "56.3 / 2")
    '(("56.3" float) ("/" operator) ("2" int))

(arithmetic-lexer "56.3 / 2 ^ 4")
    '(("49" int) ("^" operator) ("4" int))
```


---
## Referencias
1. CCori, W. (27 de Agosto 2018) _¿Qué es un autómata?_ [blog] https://medium.com/@maniakhitoccori/qu%C3%A9-es-un-aut%C3%B3mata-fbf309138755

2. Techopedia (sf) _Deterministic Finite Automaton (DFA)_ [pagina web] https://www.techopedia.com/definition/18835/deterministic-finite-automaton-dfa

3. Wikipedia (sf) _Deterministic finite automaton_ [pagina web] https://en.wikipedia.org/wiki/Deterministic_finite_automaton
