% search(List) :- 
%     Assign values from the variable domains
%     to all the Var-Domain pairs in List.

search(List) :-
    ( fromto(List, Vars, Rest, [])
    do
      choose_var(Vars, Var-Domain, Rest),
      choose_val(Domain, Val),
      Var = Val
    ).

% choose_var(List, Var, Rest) :- 
%     Var is a member of List and
%     Rest contains all the other members.

choose_var(List, Var, Rest) :- List = [Var | Rest].

% choose_val(Domain, Val) :- Val is a member of Domain.

choose_val(Domain, Val) :- member(Val, Domain).

