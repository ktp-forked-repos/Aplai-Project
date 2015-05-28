%
:- lib(ic).
:- lib(branch_and_bound).


solve(Coins, Min) :-
	init_vars(Values, Coins),  %Coins =[ x1,x2,x5 x10,x20,x50]
	coin_cons(Values, Coins, Pockets),
	Min #= sum(Coins),
	minimize((labeling(Coins), check(Pockets)), Min).

init_vars(Values, Coins) :-
	Values = [1,2,5,10,20,50],
	length(Coins,6),
	Coins :: 0..99.

coin_cons(Values, Coins, Pockets) :-   % complete list
	( for(Price,1,99),
	  foreach(CoinsforPrice, Pockets),   % coins for Price
	  param(Coins,Values)
	do
	  price_cons(Price, Coins, Values, CoinsforPrice)
	).


price_cons(Price, Coins, Values, CoinsforPrice) :-
	( foreach(V, Values),
	  foreach(C, CoinsforPrice),
	  foreach(Coin, Coins),
	  foreach(Prod, ProdList)
	do
	  Prod = V * C,
	  0 #=< C,
	  C #=< Coin
	),
	Price #= sum(ProdList).

check(Pockets) :-
	( foreach(CoinsforPrice, Pockets)
	do
	  once(labeling(CoinsforPrice))
	).

