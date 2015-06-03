:- module(chr_battleship_solitaire,[]).
:- use_module(library(chr)).

%:- chr_option(optimize,full).

:- chr_type list(T) ---> [] ; [T | list(T)].
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type position ---> (xvalue,yvalue).
:- chr_type listOfPossibilities ---> [natural | list(natural)].
:- chr_type element ---> water ; circle ; left ; right ; top ; bottom ; middle.

:- chr_constraint sElement(+position,+listOfPossibilities).
:- chr_constraint tElement(+position,+listOfPossibilities).
:- chr_constraint rightElement(+position,+natural,+listOfPossibilities).
:- chr_constraint leftElement(+position,+natural,+listOfPossibilities).
:- chr_constraint upElement(+position,+natural,+listOfPossibilities).
:- chr_constraint downElement(+position,+natural,+listOfPossibilities).
:- chr_constraint printBoard(+natural,+natural,+natural).
:- chr_constraint removeElements/0.
:- chr_constraint removeTElement(+natural,+natural).
:- chr_constraint effectsOfHint(+element,+natural,+natural,+listOfPossibilities).

solve(Hints,RowCounter,ColumnCounter,_) :-
        makeBoards(1,1),
        convertHints(Hints),
        initiateRowTally(RowCounter, 1),
        initiateColumnTally(ColumnCounter, 1),
        printBoard(1,1,1),
        removeElements.

makeBoards(13,1).
makeBoards(XValue,12) :-
        sElement((XValue,12),[0,1]),
        tElement((XValue,12),[0,1,2,3,4]),
        makeLadderElements(XValue,12,1),            
        NewXValue is XValue + 1,
        makeBoards(NewXValue,1).    
makeBoards(XValue,YValue) :-
        sElement((XValue,YValue),[0,1]),
        tElement((XValue,YValue),[0,1,2,3,4]), 
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
        removeTElement(NextXValue,NextYValue),
        tElement((NextXValue,NextYValue),TValue),
        sElement((NextXValue,NextYValue),SValue),
        indicesNext(NextXValue,NextYValue,Coor),
        effectsOfHint(Hint,NextXValue,NextYValue,Coor),
        convertHints(RestHints).
        
initiateRowTally([Count], 10) :- rowCount(10, Count).                 
initiateRowTally([Count|Tail], IDX) :-
        rowCount(IDX, Count), 
        NextIDX is IDX + 1,  
        initiateRowTally(Tail, NextIDX).

initiateColumnTally([Count], 10) :- colCount(10, Count).       
initiateColumnTally([Count|Tail], IDX) :-
        colCount(IDX, Count), 
        NextIDX is IDX + 1,  
        initiateColTally(Tail, NextIDX).
        
tElement((X,Y),Value) ==> ourOwnList()

%-------------- Hints Constraints  ---------------------------------

removeTElement(X,Y), tElement((X,Y),_), sElement((X,Y),_) <=> true.

effectsOfHint(water,_,_,_) <=> true.
effectsOfHint(circle,_,_,_) <=> true.
effectsOfHint(left,X,Y,[XTop,XDown,YLeft,YRight]), tElement((XTop,Y),_), tElement((XDown,Y),_), tElement((X,YLeft),_), tElement((X,YRight),_) <=>
                                tElement((XTop,Y),[0]), tElement((XDown,Y),[0]), tElement((X,YLeft),[0]), tElement((X,YRight),[2,3,4]).
effectsOfHint(right,X,Y,[XTop,XDown,YLeft,YRight]), tElement((XTop,Y),_), tElement((XDown,Y),_), tElement((X,YLeft),_), tElement((X,YRight),_) <=>
                                tElement((XTop,Y),[0]), tElement((XDown,Y),[0]), tElement((X,YLeft),[2,3,4]), tElement((X,YRight),[0]).
effectsOfHint(top,X,Y,[XTop,XDown,YLeft,YRight]), tElement((XTop,Y),_), tElement((XDown,Y),_), tElement((X,YLeft),_), tElement((X,YRight),_) <=> 
                                tElement((XTop,Y),[0]), tElement((XDown,Y),[2,3,4]), tElement((X,YLeft),[0]), tElement((X,YRight),[0]).
effectsOfHint(bottom,X,Y,[XTop,XDown,YLeft,YRight]), tElement((XTop,Y),_), tElement((XDown,Y),_), tElement((X,YLeft),_), tElement((X,YRight),_) <=> 
                                tElement((XTop,Y),[2,3,4]), tElement((XDown,Y),[0]), tElement((X,YLeft),[0]), tElement((X,YRight),[0]).
effectsOfHint(middle,X,Y,[XTop,XDown,YLeft,YRight]), tElement((XTop,Y),Pos1), tElement((XDown,Y),Pos1), tElement((X,YLeft),Pos1), tElement((X,YRight),Pos1) <=> 
                                true.

%-------------- Channeling Constraints -----------------------------

tElement((X,Y),[0]) \ sElement((X,Y),[0,1]) <=> sElement((X,Y),[0]).
tElement((X,Y),[K|_]) \ sElement((X,Y),[0,1]) <=> K \= 0 | sElement((X,Y),[1]).

sElement((X,Y),[0]) \ tElement((X,Y),[0,1,2,3,4]) <=> tElement((X,Y),[0]).
sElement((X,Y),[1]) \ tElement((X,Y),[0,1,2,3,4]) <=> tElement((X,Y),[1,2,3,4]).

%-------------- Occupied Constraints -------------------------------

tElement((X,Y),[K|_]) ==> K \= 0 | indicesCorner(X,Y,[XTop,XDown,YLeft,YRight]), tElement((XTop,YLeft),[0]), tElement((XTop,YRight),[0]), tElement((XDown,YLeft),[0]), tElement((XDown,YRight),[0]).

%-------------- Border Constraints   -------------------------------
tElement((1,2),[0,1,2,3,4]) <=> tElement((1,2),[0]).

tElement((12,Y1),[0]) \ tElement((12,Y2),[0,1,2,3,4]) <=>  Y1 \= Y2 | tElement((12,Y2),[0]).
tElement((12,Y1),[0]) \ tElement((12,Y2),[Value|_]) <=>  Y1 \= Y2, Value \= 0 | tElement((12,Y2),[0]).
tElement((1,Y1),[0]) \ tElement((1,Y2),[0,1,2,3,4]) <=>  Y1 \= Y2 | tElement((1,Y2),[0]).
tElement((1,Y1),[0]) \ tElement((1,Y2),[Value|_]) <=>  Y1 \= Y2, Value \= 0 | tElement((1,Y2),[0]).
tElement((X1,1),[0]) \ tElement((X2,1),[0,1,2,3,4]) <=>  X1 \= X2 | tElement((X2,1),[0]).
tElement((X1,1),[0]) \ tElement((X2,1),[Value|_]) <=>  X1 \= X2, Value \= 0 | tElement((X2,1),[0]).
tElement((X1,12),[0]) \ tElement((X2,12),[0,1,2,3,4]) <=>  X1 \= X2 | tElement((X2,12),[0]).
tElement((X1,12),[0]) \ tElement((X2,12),[Value|_]) <=>  X1 \= X2, Value \= 0 | tElement((X2,12),[0]).

%-------------- Tally Constraints    -------------------------------

%-------------- Cardinality Constraints ----------------------------




%-------------- Info Hints -----------------------------------------

hintInfo(water, '.', [0], [0]).
hintInfo(circle, c, [1], [1]).
hintInfo(top, t, [2,3,4],[1]).
hintInfo(bottom, b, [2,3,4], [1]).
hintInfo(left, l, [2,3,4], [1]).
hintInfo(right, r, [2,3,4], [1]).
hintInfo(middle, m, [3,4], [1]).

%--------------- Indices predicates --------------------------------

indicesNext(X,Y,[XTop,XDown,YLeft,YRight]) :-
        XTop is X - 1,
        XDown is X + 1,
        YLeft is Y - 1,  
        YRight is Y + 1. 

indicesCorner(X,Y,[XTop,XDown,YLeft,YRight]) :-
        XTop is X - 1,
        XDown is X + 1,
        YLeft is Y - 1,  
        YRight is Y + 1.                    

%-------------- PrintBoards  --------------------------------------

printBoard(13,1,1) <=> true.
printBoard(K,12,1), sElement((K,12),[0,1]) <=> write('?'),write('   '), printBoard(K,1,2).
printBoard(K,12,1), sElement((K,12),[Value|_]) <=> write(Value),write('   '), printBoard(K,1,2).
printBoard(K,L,1), sElement((K,L),[0,1]) <=> write('?'), L1 is L + 1, printBoard(K,L1,1).
printBoard(K,L,1), sElement((K,L),[Value|_]) <=> write(Value), L1 is L + 1, printBoard(K,L1,1).

printBoard(K,12,2), tElement((K,12),[0,1,2,3,4]) <=> writeln('?'), K1 is K + 1, printBoard(K1,1,1).
printBoard(K,12,2), tElement((K,12),[Value|_]) <=> writeln(Value), K1 is K + 1, printBoard(K1,1,1).
printBoard(K,L,2), tElement((K,L),[0,1,2,3,4]) <=> write('?'), L1 is L + 1, printBoard(K,L1,2).
printBoard(K,L,2), tElement((K,L),[Value|_]) <=> write(Value), L1 is L + 1, printBoard(K,L1,2).

%-------------- Remove All Elements from Constraint Store ----------

removeElements, sElement(_,_) <=> removeElements.
removeElements, tElement(_,_) <=> removeElements.
removeElements, rightElement(_,_,_) <=> removeElements.
removeElements, leftElement(_,_,_) <=> removeElements.
removeElements, upElement(_,_,_) <=> removeElements.
removeElements, downElement(_,_,_) <=> removeElements.
removeElements <=> true.
