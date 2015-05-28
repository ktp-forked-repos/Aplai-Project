% len(List, N) :- N is the length of the list List.
  
len([], 0).
len([_ | Ts], N) :- len(Ts, M), N is M+1.
