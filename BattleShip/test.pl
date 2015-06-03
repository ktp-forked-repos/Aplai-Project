:- module(test,[]).
:- use_module(library(chr)).

:- chr_type list(T) ---> [] ; [T | list(T)].
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type position ---> (xvalue,yvalue).
:- chr_type listOfPossibilities ---> [natural | list(natural)].
:- chr_type element ---> water ; circle ; left ; right ; top ; bottom ; middle.

:- chr_constraint updateStore(+any), yoloconstraint/0, store(+any), doShit/0.
:- chr_constraint sElement(+position,+listOfPossibilities).
:- chr_constraint tElement(+position,+listOfPossibilities).

solve(_,_,_,_) :-
        store([]),
        makeBoards(1,1),
        doShit.
        %yoloconstraint.
        
makeBoards(13,Y) :- 
        Y >= 12.
makeBoards(XValue,12) :-
        write('loopin'),
        updateStore([sElement((XValue,12),[1])]),
        NewXValue is XValue + 1,
        makeBoards(NewXValue,1).    
makeBoards(XValue,YValue) :-
        updateStore([sElement((XValue,YValue),[1])]),
        NextYValue is YValue + 1,
        makeBoards(XValue,NextYValue).
               
store(Jos), updateStore(X) <=> append(Jos, X, Result), store(Result).    

store(Jos) \ yoloconstraint <=> write(Jos).

doShit \ store(List) <=> checkHenk(List,0).

checkHenk([],Sum) :- write(Sum).
checkHenk([sElement((_,_),Frits) | Rest],OtherSum) :-
        Sum is Frits + OtherSum,
        write(Sum),
        checkHenk(Rest,Sum).
        
        
        
