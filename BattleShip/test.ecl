
test(Result) :-
  X :: 0..4,
  Y :: 0..5,
  List = [X,Y],
  max(List,Result).
