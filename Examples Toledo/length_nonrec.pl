% len(List, N) :- 
%     N is the length of the list List
%     or List is a list of variables of length N.

len(List, N) :-
    ( foreach(_,List), count(_,1,N) do true ).
