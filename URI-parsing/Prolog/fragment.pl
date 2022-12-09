%Volpato Mattia 866316
%Colombo Marco 866431

:- module('fragment', [fragment_recognize/2]).

:- use_module(definitions, [fragment/1]).

fragment_recognize(S, uri([], [], [], [],
                          [], [], Fragment)) :-
    string(S), !,
    string_chars(S, L),
    fragment_recognize(L, uri([], [], [], [],
                              [], [], Fragment)).

fragment_recognize([S|Ss], uri([], [], [],
                               [], [], [], Fragment)) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], [], [],
                          [], [], Fragment)).

accept([S|Ss], Q, uri([], [], [], [],
                      [], [], [S|Fragment])) :-
    delta(Q, S, R), !,
    accept(Ss, R,  uri([], [], [], [],
                       [], [], Fragment)).

accept([], Q, uri([], [], [], [],
                  [], [], [])) :-
    final(Q).


initial(q0).

final(q1).

delta(q0, X, q1) :- fragment(X).

delta(q1, X, q1) :- fragment(X).
