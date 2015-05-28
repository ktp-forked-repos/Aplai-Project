:- lib(suspend).
:- lib(viewable).

% send(List):-  List is a solution to
%     the SEND + MORE = MONEY puzzle.                               

send(List):-                                 
    List = [S,E,N,D,M,O,R,Y],                 
    List :: 0..9,
    viewable_create(sm,List),
    diff_list(List),                     
                 1000*S + 100*E + 10*N + D    
               + 1000*M + 100*O + 10*R + E    
    $= 10000*M + 1000*O + 100*N + 10*E + Y,   
    S $\= 0,                                  
    M $\= 0,                              
   search(List).   

search(List) :- 
    ( foreach(Var,List) do select_val(0, 9, Var) ).

% diff_list(List) :- 
%     List is a list of different variables.

diff_list(List) :-
    ( fromto(List,[X|Tail],Tail,[]) 
    do
      ( foreach(Y, Tail), 
        param(X) 
      do
        X $\= Y
      )
    ).

% select_val(Min, Max, Val) :- 
%     Min, Max are gaes and Val is an integer 
%     between Min and Max inclusive.

select_val(Min, Max, Val) :- Min =< Max, Val is Min. 
select_val(Min, Max, Val) :- 
    Min < Max, Min1 is Min+1, 
    select_val(Min1, Max, Val).
