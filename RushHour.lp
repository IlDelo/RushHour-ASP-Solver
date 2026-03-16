%time
time(0..steps).

% auto(N, D) posizione(R, C, L)
% N: nome
% D: direzione
% R: riga cella in alto/sinistra
% C: colonna cella in alto/sinistra
% L: lunghezza che si estende nella direzione D

%griglia
riga(0..5).
col(0..5).
cella(R, C) :- riga(R), col(C).

occupata(A, R, C+I, T) :- auto(A, o, L), posizione(A, R, C, T), I = 0..L-1.
occupata(A, R+I, C, T) :- auto(A, v, L), posizione(A, R, C, T), I = 0..L-1.

%mosse
dir(A, (u;d)) :- auto(A, v, L).
dir(A, (l;r)) :- auto(A, o, L).

dist(1..4).

1 { mossa(A, D, N, T) : dir(A, D), dist(N) } 1 :- time(T), T < steps, not fine(T).

posizione(A, R+N, C, T+1) :- mossa(A, d, N, T), posizione(A, R, C, T).
posizione(A, R-N, C, T+1) :- mossa(A, u, N, T), posizione(A, R, C, T).
posizione(A, R, C+N, T+1) :- mossa(A, r, N, T), posizione(A, R, C, T).
posizione(A, R, C-N, T+1) :- mossa(A, l, N, T), posizione(A, R, C, T).
posizione(A, R, C,   T+1) :- not mossa(A, _, _, T), posizione(A, R, C, T), time(T), T < steps.

:- mossa(A, d, N, T), posizione(A, R, C, T), auto(A, v, L), 
    K = 1..N, X = R + L-1 + K, 1 { not cella(X, C); occupata(B, X, C, T) : A != B }.
:- mossa(A, u, N, T), posizione(A, R, C, T), auto(A, v, L),
    K = 1..N, X = R - K, 1 { not cella(X, C); occupata(B, X, C, T) : A != B }.
:- mossa(A, r, N, T), posizione(A, R, C, T), auto(A, o, L),
    K = 1..N, X = C + L-1 + K, 1 { not cella(R, X); occupata(B, R, X, T) : A != B }.
:- mossa(A, l, N, T), posizione(A, R, C, T), auto(A, o, L),
    K = 1..N, X = C - K, 1 { not cella(R, X); occupata(B, R, X, T) : A != B }.

:- occupata(A, R, C, T), occupata(B, R, C, T), A != B.

%goal
fine(T) :- posizione(x, 2, 4, T).
:- not fine(_).

%minimizzazione
#minimize { 1, T : mossa(_,_,_,T) }.

%output
#show mossa/4.