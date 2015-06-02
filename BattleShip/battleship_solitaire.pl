:- module(chr_battleship_solitaire,[]).
:- use_module(library(chr)).

:- chr_option(optimize,full).

:- chr_type list(T) ---> [] ; [T | list(T)].
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type position ---> (xvalue,yvalue).
:- chr_type listOfPossibilities ---> natural ; [natural | list(natural)].

:- chr_constraint sElement(+position,+listOfPossibilities).
:- chr_constraint tElement(+position,+listOfPossibilities).
:- chr_constraint rightElement(+position,+natural,+listOfPossibilities).
:- chr_constraint leftElement(+position,+natural,+listOfPossibilities).
:- chr_constraint upElement(+position,+natural,+listOfPossibilities).
:- chr_constraint downElement(+position,+natural,+listOfPossibilities).
:- chr_constraint printBoard(+natural,+natural,+natural).
:- chr_constraint removeElements/0.

solve(_,_,_,Solution) :-
        makeBoards(1,1),
        %convertHints(Hints),
        printBoard(1,1,1),
        removeElements.

makeBoards(13,1).
makeBoards(XValue,12) :-
        sElement((XValue,12),[0,1]),
        tElement((XValue,12),[0,1,2,4,5]),
        makeLadderElements(XValue,12,1),            
        NewXValue is XValue + 1,
        makeBoards(NewXValue,1).    
makeBoards(XValue,YValue) :-
        sElement((XValue,YValue),[0,1]),
        tElement((XValue,YValue),[0,1,2,4,5]), 
        makeLadderElements(XValue,YValue,1),
        NextYValue is YValue + 1,
        makeBoards(XValue,NextYValue).         

makeLadderElements(_,_,5).
makeLadderElements(XValue,YValue, Counter) :-
        rightElement((XValue,YValue),Counter,[0,1]),
        leftElement((XValue,YValue),Counter,[0,1]),
        upElement((XValue,YValue),Counter,[0,1]),
        downElement((XValue,YValue),Counter,[0,1]),
        NewCounter is Counter + 1,
        makeLadderElements(XValue,YValue,NewCounter).

convertHints([]).
convertHints([(XValue,YValue,Hint)|RestHints]) :-
        NextXValue is XValue + 1,
        NextYValue is YValue + 1,
        hintInfo(Hint,_,TValue,SValue),
        sElement((NextXValue,NextYValue),SValue),
        tElement((NextXValue,NextYValue),TValue),
        %effectsOfHint(Hint,NextXValue,NextYValue),
        convertHints(RestHints).

%effectsOfHint(circle,_,_,_).
%effectsOfHint(water,_,_,_).
%effectsOfHint(left,X,Y,Grid).    
%effectsOfHint(right,X,Y,Grid).
%effectsOfHint(top,X,Y,Grid).
%effectsOfHint(bottom,X,Y,Grid).
%effectsOfHint(middle,X,Y,Grid).

hintInfo(water, '.', 0, 0).
hintInfo(circle, c, 1, 1).
hintInfo(top, t, [2,3,4], 1).
hintInfo(bottom, b, [2,3,4], 1).
hintInfo(left, l, [2,3,4], 1).
hintInfo(right, r, [2,3,4], 1).
hintInfo(middle, m, [3,4], 1).

printBoard(13,1,1) <=> true.
printBoard(K,12,1), sElement((K,12),[Value|_]) <=> write(Value),write('   '), printBoard(K,1,2).
printBoard(K,L,1), sElement((K,L),[Value|_]) <=> write(Value), L1 is L + 1, printBoard(K,L1,1).

printBoard(K,12,2), tElement((K,12),[Value|_]) <=> writeln(Value), K1 is K + 1, printBoard(K1,1,1).
printBoard(K,L,2), tElement((K,L),[Value|_]) <=> write(Value), L1 is L + 1, printBoard(K,L1,2).

removeElements, sElement(_,_) <=> removeElements.
removeElements, tElement(_,_) <=> removeElements.
removeElements, rightElement(_,_,_) <=> removeElements.
removeElements, leftElement(_,_,_) <=> removeElements.
removeElements, upElement(_,_,_) <=> removeElements.
removeElements, downElement(_,_,_) <=> removeElements.
