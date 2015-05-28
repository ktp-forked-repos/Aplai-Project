% search(N, List) :- 
%     Assign values from the variable domains
%     to all the Var-Domain pairs in List.

search(N, List) :-
    ( fromto(List, Vars, Rest, [])
    do
      choose_var(Vars, Var-Domain, Rest),
      choose_val(N, Domain, Val),
      Var = Val
    ).

choose_var(List, Var, Rest) :- List = [Var | Rest].

% choose_val(N, Domain, Val) :- 
%     Val is one of the N "best" values in Domain.

choose_val(N, Domain, Val) :-
    select_best(N, Domain, BestList),
    member(Val, BestList).

select_best(N, Domain, BestList) :-
    ( N >= length(Domain) ->
      BestList = Domain
    ;
      length(BestList, N),
      append(BestList, _, Domain)
    ).

