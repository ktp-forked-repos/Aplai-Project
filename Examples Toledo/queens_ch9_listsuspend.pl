:- lib(suspend).
:- lib(viewable).



% queens(QueenStruct, Number) :- The array QueenStruct 
%     is a solution to the Number-queens problem.
/* 27/2 : queens(L,8) :- met array 80 s
                         met list  0.08s
			 maar verdomd last gehad met de 2e lus!!!
			 */
			 

queens(Qs,Nb) :-
	genlist(Nb,Qs),
	qsconstraints(Qs,Nb),
	qsgen(Qs,Nb).

genlist(0,[]).
genlist(N,[_|Qs]) :- N > 0, N1 is N- 1, genlist(N1,Qs).

qsconstraints(Qs,Nb):-
	Qs :: 1..Nb,
	viewable_create(qul,Qs),
	(   foreach(Qi,Qs),
	    count(I,1,Nb),
	    param(Qs)
	do
	     write(ikke(Qi,I)),write(' '),
	    ( foreach(Qj,Qs), 
	      count(J,1,_), 
%	      for(J,1,I-1), 
%	      foreach(Qj,Qs),
	      param(I,Qi)
	    do
              write(body(I,J,Qi,Qj)),nl,
		(( J < I) -> 
		Qi $\= Qj,
		Qi - Qj $\= I-J, 
		Qi - Qj $\= J-I
		;
		    true
		)
	
	    )
      
	
	).

qsgen(Qs,N) :-
	( foreach(Q,Qs),
	  param(N)
	do 
	  select_val(1, N, Q) 
	).


% select_val(Min, Max, Val) :- 
%     Min, Max are gaes and Val is an integer 
%     between Min and Max inclusive.

select_val(Min, Max, Val) :- Min =< Max, Val is Min, write(sv(Val)),nl. 
select_val(Min, Max, Val) :- 
    Min < Max, Min1 is Min+1, 
    select_val(Min1, Max, Val).



constraints(QueenStruct, Number) :-
	[X1,X2,X3] :: 1.. Number, X1 $\= X2, X1 $\= X3, X2 $\= X3,
	QueenStruct[1] = X1,QueenStruct[2] = X2, QueenStruct[3] = X3, 
    ( for(I,1,Number), 
      param(QueenStruct,Number)
    do
      QueenStruct[I] :: 1..Number, 
      ( for(J,1,I-1), 
        param(I,QueenStruct)
      do
        QueenStruct[I] $\= QueenStruct[J],
        QueenStruct[I]-QueenStruct[J] $\= I-J, 
        QueenStruct[I]-QueenStruct[J] $\= J-I
      )
    ).
/*
hier vanzodra X1 geunificeerd met Queenstruct[1]
   in constraint store X1 vervangen door array element!!!

   en dus nog genereer en test
   */
