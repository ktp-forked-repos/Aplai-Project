%
:- lib(ic).
:- lib(branch_and_bound).
cubes(M,Qs) :-
	K is fix(round(sqrt(M))),
	N :: [2..K],
	indomain(N),
	
	length(Qs,N), Qs :: [1..K],
	increasing(Qs),
	( foreach(Q,Qs),
	  foreach(Expr, Exprs)
	do	
	  Expr = Q*Q*Q
	),
	sum(Exprs) #= M,
	labeling(Qs), !.	


increasing(List) :- 
	( fromto(List, [This, Next|Rest], [Next|Rest], [_])
	do
	  This #< Next
	).
