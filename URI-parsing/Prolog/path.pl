%Volpato Mattia 866316
%Colombo Marco 866431

%path ::= <identifier> ('/' <identifier>)*

:- module('path', [path_recognize/2]).

:- use_module(definitions, [identifier/1]).
:- use_module(query).
:- use_module(fragment).


path_recognize(S, uri([], [], [], [],
                      Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    path_recognize(L, uri([], [], [], [],
                          Path, Query, Fragment)).

path_recognize([S|Ss], uri([], [], [], [],
                           Path, Query, Fragment)) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], [], [],
                          Path, Query, Fragment)).

accept(['?'|Ss], Q, uri([], [], [], [],
                        [], Query, Fragment)) :-
    final(Q), !,
    query_recognize(Ss, uri([], [], [], [],
                            [], Query, Fragment)).

accept(['#'|Ss], Q, uri([], [], [], [],
                        [], [], Fragment)) :-
    final(Q), !,
    fragment_recognize(Ss, uri([], [], [], [],
                               [], [], Fragment)).


accept([S|Ss], Q, uri([], [], [], [],
                      [S|Path], Query, Fragment)) :-
    delta(Q, S, R), !,
    accept(Ss, R,  uri([], [], [], [],
                       Path, Query, Fragment)).

accept([], Q, uri([], [], [], [], [], [], [])) :-
    final(Q).


initial(q0).

final(q1).

delta(q0, X, q1) :- identifier(X).

delta(q1, X, q1) :- identifier(X), !.
delta(q1, '/', q2).

delta(q2, X, q1) :- identifier(X).

