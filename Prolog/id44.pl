%Volpato Mattia 866316
%Colombo Marco 866431

%id44 ::= (alfanumerical | '.')+

:- module('id44', [id44_recognize/2]).

:- use_module(definitions, [alfa/1, alfanum/1]).

:- use_module(id8).
:- use_module(query).
:- use_module(fragment).

id44_recognize(S, uri([], [], [], [],
                      zos_path(Id44, Id8),
                      Query, Fragment)) :-
    string(S), !, string_chars(S, L),
    id44_recognize(L,  uri([], [], [], [],
                           zos_path(Id44, Id8),
                           Query, Fragment)).

id44_recognize([S|Ss], uri([], [], [], [],
                           zos_path(Id44, Id8),
                           Query, Fragment)) :-
    initial(Q),
    accept([S|Ss], Q,  uri([], [], [], [],
                           zos_path(Id44, Id8),
                           Query, Fragment), 0).

accept(['('|Ss], Q, uri([], [], [], [],
                        zos_path([], Id8),
                        Query, Fragment), Length) :- !,
    final(Q), Length=<44,
    id8_recognize(Ss, uri([], [], [], [],
                          Id8, Query, Fragment)), !.

accept([S|Ss], Q, uri([], [], [], [],
                      zos_path([S|Id44], Id8),
                      Query, Fragment), Length) :-
    delta(Q, S, R), !,
    NewLength is Length+1,
    accept(Ss, R, uri([], [], [], [],
                      zos_path(Id44, Id8),
                      Query, Fragment), NewLength).


accept([], Q, uri([], [], [], [],
                  zos_path([], []), [], []), Length) :-
    final(Q), Length=<44.

accept(['?'|Xs], Q, uri([], [], [], [],
                        zos_path([], []),
                        Query, Fragment), Length) :-
    final(Q), Length=<44,
    query_recognize(Xs, uri([], [], [], [],
                            [], Query, Fragment)), !.

accept(['#'|Xs], Q, uri([], [], [], [],
                        zos_path([], []), [],
                        Fragment), Length) :-
    final(Q), Length=<44,
    fragment_recognize(Xs, uri([], [], [], [],
                               [], [], Fragment)).


initial(q0).

final(q1).

delta(q0, X, q1) :- alfa(X).

delta(q1, X, q1) :- alfanum(X), !.
delta(q1, '.', q2).

delta(q2, X, q1) :- alfanum(X), !.
delta(q2, '.', q2).





