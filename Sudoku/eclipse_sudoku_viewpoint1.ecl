:- lib(ic).

% Standard viewpoint:
% ALL DIFFERENT constraints: every entry in a row has to be different
%                            every entry in a column has to be different
%                            every entry in a block has to be different
% additional: all domain elements have to be present in each of these instances
%  -> size(Domain) == ! i el v instances: size(i)

solve(ListBoard) :-
    doubleListToArray(ListBoard,TempBoard),
    array_list(Board, TempBoard),
    % dim(Board, [N,_]),
    Board[1..9,1..9] :: 1..9,
    (for(I,1,9), param(Board)
    do
      Row is Board[I,1..9],
      Col is Board[1..9,I],
      alldifferent(Row),
      alldifferent(Col)
    ),
    (multifor([I,J],1,9,[3,3]), param(Board)
    do
      K is I,
      L is J,
      Block is Board[K..K+2,L..L+2],
      flatten(Block, Check),
      alldifferent(Check)
    ),
    term_variables(Board, Variables),
    labelingWithCount(Variables).

doubleListToArray([],[]).
doubleListToArray([A|As],[B|Bs]) :-
    array_list(B,A),
    doubleListToArray(As,Bs).

labelingWithCount(AllVars) :-
    init_backtracks,
    ( foreach(Var, AllVars) do
        count_backtracks,       % insert this before choice!
        indomain(Var)
    ),
    get_backtracks(B),
    printf("Solution found after %d backtracks%n", [B]).

:- local variable(backtracks), variable(deep_fail).

init_backtracks :-
        setval(backtracks,0).

get_backtracks(B) :-
        getval(backtracks,B).

count_backtracks :-
        setval(deep_fail,false).
count_backtracks :-
        getval(deep_fail,false),        % may fail
        setval(deep_fail,true),
        incval(backtracks),
        fail.
