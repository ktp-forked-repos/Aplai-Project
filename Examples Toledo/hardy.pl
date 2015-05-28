%
:- lib(ic).
:- lib(branch_and_bound).
hardy([X1,X2,Y1,Y2], Z) :-
	X1 #> 0, X2 #> 0, Y1 #> 0 , Y2 #> 0,
	X1 #\= Y1, X1 #\= Y2,
	X1 ^3 + X2 ^3 #= Z,  Y1 ^ 3 + Y2 ^ 3 #= Z,
	bb_min(labeling([X1,X2,Y1,Y2]), Z,
	       % bb_options{strategy:restart}).
	        bb_options{strategy:continue}).
