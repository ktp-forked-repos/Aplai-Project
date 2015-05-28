%
:- lib(ic).
:- lib(branch_and_bound).


knapsack(Volumes, Values, Capacity, Xs) :-
	Xs :: [0..1],
	sigma(Volumes, Xs, Volume),
	Volume $=< Capacity,
	sigma(Values, Xs, Value),
	Cost $= -Value,
	minimize(labeling(Xs), Cost).


sigma(L1, L2, Value) :-
	( foreach(V1, L1),
	  foreach(V2, L2),
	  foreach(Prod, ProdList)
	do
	  Prod = V1 * V2
	),
	Value $= sum(ProdList).      % built-in sum/1 

q([X1,X2,X3,X4,X5]) :- knapsack([52,23,35,15,7],[100,60,70,15,15], 60, [X1,X2,X3,X4,X5]).