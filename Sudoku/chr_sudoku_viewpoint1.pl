:- module(chr_sudoku_viewpoint1,[solve/1]).
:- use_module(library(chr)).
:- use_module(library(lists)).

:- chr_option(debug,on).

% data types bepalen.

% Definitie van het data type lijst.
:- chr_type list(T) ---> [] ; [T | list(T)].
% natural is positieve integer.
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type position ---> (xvalue,yvalue).
% De waarde van een paar (element) kan een natural zijn of een domein(lijst van naturals)
:- chr_type number ---> natural ; [natural | list(natural)].

% + wil zeggen dat de variabele altijd grounded is. - wil zeggen nooit. ? wil zeggen allebei en kan veranderen over tijd.
:- chr_constraint element(+position,+number),printBoard(+natural,+natural).

solve(SudokuBoard) :- 
        makeDomainBoard(SudokuBoard,1).
        %printBoard(1,1).

makeDomainBoard([],_).
makeDomainBoard([Row|RestBoard],RowI) :-
        makeRowDomain(Row,RowI,1),
        RowI1 is RowI + 1, 
        makeDomainBoard(RestBoard, RowI1).

makeRowDomain([],_,_).
makeRowDomain([Element|RestRow],RowI,RowJ) :-
        nonvar(Element),
        element((RowI,RowJ), [Element]),
        RowJ1 is RowJ + 1,
        makeRowDomain(RestRow,RowI,RowJ1).
makeRowDomain([Element|RestRow],RowI,RowJ) :-
        var(Element),
        element((RowI,RowJ), [1,2,3,4,5,6,7,8,9]),
        RowJ1 is RowJ + 1,
        makeRowDomain(RestRow,RowI,RowJ1).

rowConstraints @ element((X,Y1),[A]), element((X,Y2),[A]) <=> Y1 == Y2, element((X,Y1),[A]).
%printBoard(9,L), element((9,L),[A]) <=> writeln(A).
%printBoard(K,9), element((K,9),[A]) <=> writeln(A), K1 is K + 1, printBoard(K1,1).
%printBoard(K,L), element((K,L),[A]) <=> write(A), Y is L + 1, printBoard(K,Y).





