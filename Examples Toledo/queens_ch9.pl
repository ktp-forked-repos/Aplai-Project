:- lib(suspend).
:- lib(viewable).

/* howto start with Viewable stuff

   start eclipse;
   under tools select Visualization client
       make sure that under Options: no auto resume
   start program : queens(B,8).
    than fiddle with View options: fit height and
       select all 8 cells -> right mouse -> hold on updates
   resume
   */


  
% queens(QueenStruct, Number) :- The array QueenStruct 
%     is a solution to the Number-queens problem.

queens(QueenStruct, Number) :-
    dim(QueenStruct,[Number]),
    viewable_create(qu,QueenStruct),
    constraints(QueenStruct, Number),
    search(QueenStruct).

constraints(QueenStruct, Number) :-
    ( for(I,1,Number), 
      param(QueenStruct,Number)
    do
      QueenStruct[I] :: 1..Number, 
      ( for(J,1,I-1), 
        param(I,QueenStruct)
      do
        QueenStruct[I] $\= QueenStruct[J],
        QueenStruct[I]-QueenStruct[J] $\= I-J, 
        QueenStruct[I]-QueenStruct[J] $\= J-I
      )
    ).

search(QueenStruct) :-
    dim(QueenStruct,[N]),
    ( foreacharg(Col,QueenStruct), 
      param(N)
    do 
      select_val(1, N, Col) 
    ).

% select_val(Min, Max, Val) :- 
%     Min, Max are gaes and Val is an integer 
%     between Min and Max inclusive.

select_val(Min, Max, Val) :- Min =< Max, Val is Min. 
select_val(Min, Max, Val) :- 
    Min < Max, Min1 is Min+1, 
    select_val(Min1, Max, Val).


