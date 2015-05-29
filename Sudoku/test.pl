:- module(chr_test,[]).
:- use_module(library(chr)).

% Definitie van het data type lijst.
:- chr_type list(T) ---> [] ; [T | list(T)].
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type position ---> (xvalue,yvalue).
% natural is positieve integer.
% De waarde van een paar (element) kan een natural zijn of een domein(lijst van naturals)
:- chr_type num ---> natural ; [natural | list(natural)].

:- chr_constraint posElement(+position,+num), choiceNumber/0, element(+position,+natural).

makeRowDomain([],_).
makeRowDomain([Element|RestRow],RowJ) :-
        var(Element),
        posElement((1,RowJ), [1,2,3,4,5,6,7,8,9]),
        %choiceNumber,
        RowJ1 is RowJ + 1,
        makeRowDomain(RestRow,RowJ1).

choiceNumber, posElement((X,Y),L) <=> member(N,L), element((X,Y), N).

rowConstraint @ element((1,Y1),A), element((1,Y2),A) <=> Y1 == Y2.
