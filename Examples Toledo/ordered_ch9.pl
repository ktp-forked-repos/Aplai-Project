:- lib(suspend).

% ordered(Xs) :- Xs is an <-ordered list of numbers.

ordered(List) :-
    ( List = [] ->
      true
    ;
     ( fromto(List,[This,Next | Rest],[Next | Rest],[_])
     do
       This $< Next
     )
    ).
