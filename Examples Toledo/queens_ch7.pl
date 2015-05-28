% queens(QueenStruct, Number) :- The array QueenStruct 
%     is a solution to the Number-queens problem.

queens(QueenStruct, Number) :-
    dim(QueenStruct,[Number]),
    ( for(J,1,Number), 
      param(QueenStruct,Number)
    do
      select_val(1, Number, Qj),
      subscript(QueenStruct,[J],Qj),
      ( for(I,1,J-1), 
        param(J,Qj,QueenStruct)
      do
        QueenStruct[I] =\= Qj,
        QueenStruct[I] - Qj =\= I-J,
        QueenStruct[I] - Qj =\= J-I
      )
    ).

% select_val(Min, Max, Val) :- 
%     Min, Max are gaes and Val is an integer 
%     between Min and Max inclusive.


select_val(Min, Max, Val) :- Min =< Max, Val is Min. 
select_val(Min, Max, Val) :- 
    Min < Max, Min1 is Min+1, 
    select_val(Min1, Max, Val).

newqueens(QueenStruct, Number) :-
    dim(QueenStruct,[Number]),
    ( for(J,1,Number), 
      param(QueenStruct,Number)
    do
      select_val(1, Number, Qj),
      subscript(QueenStruct,[I],Qi),
      subscript(QueenStruct,[J],Qj),
      ( for(I,1,J-1), 
        param(J,Qj,QueenStruct)
      do
        Qi =\= Qj,
        Qi - Qj =\= I-J,
        Qi - Qj =\= J-I
      )
    ).