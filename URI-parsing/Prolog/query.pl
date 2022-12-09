%Volpato Mattia 866316
%Colombo Marco 866431

%query ::= <caratteri senza '#'>+

:- module('query', [query_recognize/2]).

:- use_module(definitions).
:- use_module(fragment).


query_recognize(S, uri([], [], [], [],
                       [], Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    query_recognize(L, uri([], [], [], [],
                           [], Query, Fragment)).

query_recognize([S|Ss], uri([], [], [], [],
                            [], Query, Fragment)) :-
    initial(Q), accept([S|Ss], Q, uri([], [], [], [],
                                      [], Query, Fragment)).

accept(['#'|Ss], Q, uri([], [], [], [],
                        [], [], Fragment)) :-
    final(Q), !,
    fragment_recognize(Ss, uri([], [], [], [],
                               [], [], Fragment)).

accept([S|Ss], Q, uri([], [], [], [],
                      [], [S|Query], Fragment)) :-
    delta(Q, S, R), !,
    accept(Ss, R,  uri([], [], [], [],
                       [], Query, Fragment)).

accept([], Q, uri([], [], [], [], [], [], [])) :-
    final(Q).


initial(q0).

final(q1).

delta(q0, X, q1) :- query(X).

delta(q1, X, q1) :- query(X).

