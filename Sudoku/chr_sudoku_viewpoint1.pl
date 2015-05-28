:- module(chr_sudoku_viewpoint1,[solve/1]).
:- use_module(library(chr)).
:- use_module(library(lists)).

:- chr_option(debug,on).

:- chr_type list(T) ---> [] ; [T | list(T)].

:- chr_constraint makeDomainRow(?list(int)).

solve(SudokuBoard) :- 
        makeDomainBoard(SudokuBoard),
        constraintsBoard(SudokuBoard),
        printBoard(SudokuBoard).       

makeDomainBoard([]).
makeDomainBoard([Row|RestBoard]) :-
        makeDomainRow(Row),
        makeDomainBoard(RestBoard).
        
makeDomainRow([]).
makeDomainRow([Element|RestRow]) :-
        generateDomain(1,9,Domain),
        Element in Domain,
        makeDomainRow(RestRow).        

generateDomain(N,N,[N]).
generateDomain(M,N,[M|T]):-
        M < N,
        M1 is M+1,
        generateDomain(M1,N,T).

constraintsBoard(_).

printBoard([]).
printBoard([Row|RestBoard]) :-
        printRow(Row),

        writeln(" "),
        printBoard(RestBoard).

printRow([]).
printRow([X|Rest]) :-
        write(X),
        printRow(Rest).
