search(List, Credit) :-
    ( fromto(List, Vars, Rest, []),
      fromto(Credit, TCredit, NCredit, _)
    do
      choose_var(Vars, Var-Domain, Rest),
      choose_val(Domain, Val, TCredit, NCredit),
      Var = Val
     ).

choose_var(List, Var, Rest) :- List = [Var | Rest].

choose_val(Domain, Val, TCredit, NCredit) :-
 	write(call_share_credit(Val,Domain,TCredit)),nl,
   share_credit(Domain, TCredit, DomCredList),
    member(Val-NCredit, DomCredList).

% share_credit(DomList,InCredit,DomCredList) :- 
%     Allocate credit by discrepancy.

share_credit(Domain, N, DomCredList) :-
   ( fromto(N, CurrCredit, NewCredit, 0),  % was -1 
     fromto(Domain, [Val|Tail], Tail, _),
     foreach(Val-CurrCredit, DomCredList)
   do
        ( Tail = [] ->
              NewCredit is 0     % was -1
         ;
              NewCredit is CurrCredit -1
         )
    ).


% search([X-[1,2], Y-[1,2],Z-[1,2], U-[1,2], V-[1,2]],2).  % als -1 dan 1 as credit

% 6 solutions 1 1 1 1 1; 1 1 1 1 2; 1 1 1 2 1; 1 1 2 1 1 ; 1 2 1 1 1 ; 2 1 1 1 1
