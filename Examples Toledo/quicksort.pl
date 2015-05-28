% qs(Xs, Ys) :- 
%     Ys is an =<-ordered permutation of the list Xs.

qs([], []).
qs([X | Xs], Ys) :-
    part(X, Xs, Littles, Bigs),
    qs(Littles, Ls),
    qs(Bigs, Bs),
    app(Ls, [X | Bs], Ys).

% part(X, Xs, Ls, Bs) :- 
%     Ls is a list of elements of Xs which are < X, 
%     Bs is a list of elements of Xs which are >= X.

part(_, [], [], []).
part(X, [Y | Xs], [Y | Ls], Bs) :- 
    X > Y, 
    part(X, Xs, Ls, Bs).
part(X, [Y | Xs], Ls, [Y | Bs]) :- 
    X =< Y, 
    part(X, Xs, Ls, Bs).

% app(Xs, Ys, Zs) :- Zs is the result of 
%     concatenating the lists Xs and Ys. 

app([], Ys, Ys).
app([X | Xs], Ys, [X | Zs]) :- app(Xs, Ys, Zs).