% search(List, Backtracks) :- 
%     Find a solution and count the number of backtracks.

search(List, Backtracks) :-
    init_backtracks,
    ( fromto(List, Vars, Rest,[])
    do
      choose_var(Vars, Var-Domain, Rest),
      choose_val(Domain, Val),
      Var = Val,
      count_backtracks
     ),
     get_backtracks(Backtracks).

init_backtracks :-
    setval(backtracks,0).

get_backtracks(B) :- 
    getval(backtracks,B).

count_backtracks :-
    on_backtracking(incval(backtracks)).

on_backtracking(_).   % Until a failure happens do nothing.
                      % The second clause is entered 
on_backtracking(Q) :- % on backtracking.
    once(Q)           % Query Q is called, but only once.
    fail.             % Backtracking continues afterwards.

% First implementation

count_backtracks :- 
    setval(single_step,true).
count_backtracks :-
    on_backtracking(clever_count).

clever_count :-
    ( getval(single_step,true) -> 
      incval(backtracks) 
    ; 
      true 
    ),
    setval(single_step, false).

/*
% Second implementation

count_backtracks :-
    setval(single_step,true).
count_backtracks :-
    getval(single_step,true),
    incval(backtracks),
    setval(single_step,false).
*/