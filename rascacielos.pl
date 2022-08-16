/*
Trabajo Practico Prolog - Rascacielos
Alumna: Gricelda Valdez 
*/

rascacielos(L):-
    crearTablero(L),
    consultarPistas(),
    cargarTablero(L),
    imprimirTablero(L).


%Prepara el formato que tendra nuestro tablero, cada elemento contiene: casilla(Fila, Columna, Valor)
crearTablero(L):- bagof(casilla(X,Y,_),(between(1,5,X),between(1,5,Y)),L).


%Agrega a nuestra base de conocimientos las pistas del juego
consultarPistas():- consult('pistas.pl').


/*
Carga el tablero con los numeros del 1 al 5, cumpliendo con las reglas del juego.
Va cargando por fila, y a medida que lo hace controla si cumple con las restricciones:
	1. Fila y Columna con valores no repetidos
	2. La cantidad de edificios que se pueden observar debe ser igual a los valores que indican las pistas
*/
cargarTablero(M):-
	write("Inicia la carga del tablero"), nl,

	%carga y verifica restricciones de la fila 1
	cargarFila(1, M),	
	verificarPistasHIzq(1,M),
	verificarPistasHDer(1,M),

	%carga  y verifica restricciones de la fila 2
	cargarFila(2, M),	
	verificarPistasHIzq(2,M),
	verificarPistasHDer(2,M),

	%carga  y verifica restricciones de la fila 3
	cargarFila(3, M),	
	verificarPistasHIzq(3,M),
	verificarPistasHDer(3,M),

	%carga  y verifica restricciones de la fila 4
	cargarFila(4, M),	
	verificarPistasHIzq(4,M),
	verificarPistasHDer(4,M),

	%carga  y verifica restricciones de la fila 5
	cargarFila(5, M),	
	verificarPistasHIzq(5,M),
	verificarPistasHDer(5,M),

	%verifica las restricciones de la columna 1, 2, 3, 4 y 5
	verificarPistasVArr(1,M),
	verificarPistasVArr(2,M),
	verificarPistasVArr(3,M),
	verificarPistasVArr(4,M),
	verificarPistasVArr(5,M),

	verificarPistasVAbj(1,M),
	verificarPistasVAbj(2,M),
	verificarPistasVAbj(3,M),
	verificarPistasVAbj(4,M),
	verificarPistasVAbj(5,M),

	write("Finaliza la carga tablero"), nl.


%Carga los numeros del 1 al 5 por cada fila en el tablero
cargarFila(Fila, Matriz):-
	findall(casilla(Fila,C,_), member(casilla(Fila,C,_), Matriz), Celdas),
	ValoresDisp = [1,2,3,4,5],
	ubicarNumeros(ValoresDisp,Matriz, Celdas).


%Rellena en la matriz los numeros del 1 al 5
ubicarNumeros(_,_,[]).
ubicarNumeros(ValoresDisp, Matriz, [casilla(F,C,_)|T]):-
	select(Valor,ValoresDisp,ValoresRest),
	member(casilla(F,C,Valor),Matriz),
	ubicarNumeros(ValoresRest, Matriz, T).


/*obtenerListaCompleta2(M, R):-
	findall(V, member(casilla(_,_,V),M),R).*/

%Verifica que en una linea no se repitan los numeros
lineaNoRepetida([A,B,C,D,E]):-
	A \= B, A\=C, A\=D, A\=E, B\=C, B\=D, B\=E, C\=D, C\=E, D\=E.


%Dada una Fila y la matriz, coloca en Result todos los valores correspondientes a esa fila, por ej: [casilla(F1, _, V1), ...] -> [V1,...]
obtenerFila(Fila, Matriz, Result):-
	findall(Valor, member(casilla(Fila,_,Valor),Matriz), Result).


%Dada una columna y la matriz, coloca en Result todos los valores correspondientes a esa columna, por ej: [casilla(_, C1, V1), ...] -> [V1,...]
obtenerColumna(Col, Matriz, L):-
	findall(Valor, member(casilla(_,Col,Valor),Matriz),L).


%Extrae el valor de la pista
traerPista(Direccion, NumLinea, Sentido, V):- pista(Direccion,NumLinea,Sentido,V).


%Verifica si cumple con las dos principales condiciones del juego
esValido(Linea, CantEdificios):-
	lineaNoRepetida(Linea),
	acumuladoMaximo(Linea,0,0,CantEdificios).


%HORIZONTAL IZQUIERDA
verificarPistasHIzq(Fila, Matriz):-
	obtenerFila(Fila, Matriz, Lista),
	traerPista(horizontal,Fila,izquierda,CantEdificios),
	esValido(Lista, CantEdificios).


%HORIZONTAL DERECHA
verificarPistasHDer(Fila, Matriz):-
	obtenerFila(Fila, Matriz, Lista),
	traerPista(horizontal,Fila,derecha,CantEdificios),
	reverse(Lista, ListaInvertida),
	esValido(ListaInvertida, CantEdificios).


%VERTICAL ABAJO
verificarPistasVAbj(Col, Matriz):-
    obtenerColumna(Col, Matriz, Lista),
	traerPista(vertical,Col,abajo,CantEdificios),
	reverse(Lista,ListaInvertida),
	esValido(ListaInvertida, CantEdificios).


%VERTICAL ARRIBA
verificarPistasVArr(Col, Matriz):-
	obtenerColumna(Col, Matriz, Lista),
	traerPista(vertical,Col,arriba,CantEdificios),
	esValido(Lista, CantEdificios).



/*Devuelve la cantidad de veces que una linea tiene un nuevo valor mas alto a medida que la itera
Compara con la CantEdificios para corroborar que es valida*/
acumuladoMaximo([H|T],A,N,Num) :-
    H > A,
    acumuladoMaximo(T,H,N,Num1), Num is Num1 + 1.

acumuladoMaximo([H|T],A,N,Num) :-
    H =< A,
    acumuladoMaximo(T,A,N,Num).

acumuladoMaximo([],_,N,N).


%Imprime el tablero con la solucion del juego
imprimirTablero(L):-
	findall(V, member(casilla(1,C,V),L), F1),
	write(F1),nl,
	findall(V, member(casilla(2,C,V),L), F2),
	write(F2),nl,
	findall(V, member(casilla(3,C,V),L), F3),
	write(F3),nl,
	findall(V, member(casilla(4,C,V),L), F4),
	write(F4),nl,
	findall(V, member(casilla(5,C,V),L), F5),
	write(F5).

