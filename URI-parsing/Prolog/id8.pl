%Volpato Mattia 866316
%Colombo Marco 866431

%id44 ::= (alfanumerical)+


:- module('id8', [id8_recognize/2]).

:- use_module(definitions, [alfanum/1, alfa/1]).
:- use_module(query).
:- use_module(fragment).


id8_recognize(S,  uri([], [], [], [],
                      Id8, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    id8_recognize(L, uri([], [], [], [],
                         Id8, Query, Fragment)).

id8_recognize([S|Ss], uri([], [], [], [],
                          Id8, Query, Fragment)) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], [], [],
                          Id8, Query, Fragment), 0).

accept([S|Ss], Q, uri([], [], [], [],
                      [S|Id8], Query, Fragment), Length) :-
    delta(Q, S, R), !,
    NewLength is Length+1,
    accept(Ss, R, uri([], [], [], [],
                      Id8, Query, Fragment), NewLength).


accept([')'], Q, uri([], [], [], [],
                     [], [], []), Length) :- !,
    final(Q), Length=<8.

accept([')', '?'|Ss], Q, uri([], [], [], [],
                             [], Query, Fragment), Length) :-
    !, final(Q), Length=<8,
    query_recognize(Ss, uri([], [], [], [],
                            [], Query, Fragment)).

accept([')', '#'|Ss], Q, uri([], [], [], [],
                             [], [], Fragment), Length) :-
    final(Q), Length=<8,
    fragment_recognize(Ss, uri([], [], [], [],
                               [], [], Fragment)).


initial(q0).

final(q1).

delta(q0, X, q1) :- alfa(X).

delta(q1, X, q1) :- alfanum(X).





