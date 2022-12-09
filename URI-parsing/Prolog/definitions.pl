%Volpato Mattia 866316
%Colombo Marco 866431

:- module('definitions', [fragment/1, identifier/1, digit/1,
                          query/1, host_identifier/1, 
						  alfanum/1, alfa/1]).

fragment(X) :- atom(X), !.

identifier(X) :- atom(X), !, X\='/', X\='?',
    X\='#', X\='@', X\=':'.

digit(X) :- integer(X), !, X>=0, X=<9.
digit(X) :- atom(X), atom_number(X, N), digit(N).

query(X) :- atom(X), X\='#'.

host_identifier(X) :- atom(X), !,
    X\='.', identifier(X).

alfanum(X) :- digit(X), !.
alfanum(X) :- alfa(X).

alfa(X) :- X='a'; X='A'.
alfa(X) :- X='b'; X='B'.
alfa(X) :- X='c'; X='C'.
alfa(X) :- X='d'; X='D'.
alfa(X) :- X='e'; X='E'.
alfa(X) :- X='f'; X='F'.
alfa(X) :- X='g'; X='G'.
alfa(X) :- X='h'; X='H'.
alfa(X) :- X='i'; X='I'.
alfa(X) :- X='j'; X='J'.
alfa(X) :- X='k'; X='K'.
alfa(X) :- X='l'; X='L'.
alfa(X) :- X='m'; X='M'.
alfa(X) :- X='n'; X='N'.
alfa(X) :- X='o'; X='O'.
alfa(X) :- X='p'; X='P'.
alfa(X) :- X='q'; X='Q'.
alfa(X) :- X='r'; X='R'.
alfa(X) :- X='s'; X='S'.
alfa(X) :- X='t'; X='T'.
alfa(X) :- X='u'; X='U'.
alfa(X) :- X='v'; X='V'.
alfa(X) :- X='x'; X='X'.
alfa(X) :- X='y'; X='Y'.
alfa(X) :- X='w'; X='W'.
alfa(X) :- X='z'; X='Z'.








