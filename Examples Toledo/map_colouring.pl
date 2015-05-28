no_of_regions(4).

neighbour(1, 2).
neighbour(1, 3).
neighbour(1, 4).
neighbour(2, 3).
neighbour(2, 4).

colour(1). % red
colour(2). % yellow
colour(3). % blue

% colour_map(Regions) :- Regions is a colouring of 
%     the map represented by the neighbour/2 predicate.

colour_map(Regions) :-
    constraints(Regions),
    search(Regions).

constraints(Regions) :-
    no_of_regions(Count),
    dim(Regions,[Count]),
    ( multifor([I,J],1,Count), 
      param(Regions) 
    do
      ( neighbour(I, J) -> 
        Regions[I] $\= Regions[J] 
      ; 
        true 
      )
    ).

search(Regions) :-
    ( foreacharg(R,Regions) do colour(R) ).
