%
:- lib(ic).
:- lib(branch_and_bound).
design_currency(Values, Coins) :-
	init_vars(Values, Coins),
	coin_cons(Values, Coins, Pockets), clever_cons(Values, Coins),
	Min #= sum(Coins),
%	minimize((labeling(Values), labeling(Coins), check(Pockets)), Min).
	bb_min((labeling(Values), labeling(Coins), check(Pockets)),Min, bb_options{factor:0.666}).

init_vars(Values, Coins) :-
	length(Values, 6), Values :: 1..99, increasing(Values), 
	length(Coins,6), Coins :: 0..99.
increasing(List) :- 
	( fromto(List, [This, Next|Rest], [Next|Rest], [_])
	do
	  This #< Next
	).

% amount of coins for V1 can be kept < V2
clever_cons(Values, Coins) :-
	( fromto(Values,[V1 | NV], NV,[]),
	  fromto(Coins,[N1 | NN], NN,[])
	do
	  ( NV = [ V2 | _] -> N1 * V1 #< V2;  N1 * V1 #< 100)
	).



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

