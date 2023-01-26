%Volpato Mattia 866316
%Colombo Marco 866431

%port ::= <digit>+

:- module(port, [port_recognize/2,
                 port_recognize/3]).

:- use_module('optional').
:- use_module('definitions', [digit/1]).


port_recognize(S, uri([], [], [], Port,
                      Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    port_recognize(L, uri([], [], [], Port,
                          Path, Query, Fragment)).

port_recognize([S|Ss],  uri([], [], [], Port,
                            Path, Query, Fragment)) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], [], Port,
                          Path, Query, Fragment)).

accept([S|Ss], Q, uri([], [], [], NewPort,
                      Path, Query, Fragment)) :-
    delta(Q, S, R, Po), !,
    accept(Ss, R, uri([], [], [], Port,
                      Path, Query, Fragment)),
    append(Po, Port, NewPort).

accept([], Q, uri([], [], [], [], [], [], [])) :-
    final(Q).

accept([S|Ss], q2, uri([], [], [], [],
                       Path, Query, Fragment)) :-
    optional_recognize([S|Ss], uri([], [], [], [],
                                   Path, Query, Fragment)).




port_recognize(S, uri([], [], [], Port,
                      Path, Query, Fragment), zos) :-
    string(S), !,
    string_chars(S, L),
    port_recognize(L, uri([], [], [], Port,
                          Path, Query, Fragment), zos).

port_recognize([S|Ss],  uri([], [], [], Port,
                            Path, Query, Fragment), zos) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], [], Port,
                          Path, Query, Fragment), zos).

accept([S|Ss], Q, uri([], [], [], NewPort,
                      Path, Query, Fragment), zos) :-
    delta(Q, S, R, Po), !,
    accept(Ss, R, uri([], [], [], Port,
                      Path, Query, Fragment), zos),
    append(Po, Port, NewPort).

%accept([], Q, uri([], [], [], [], [], [], []), zos) :-
%    final(Q).

accept([S|Ss], q2, uri([], [], [], [],
                       Path, Query, Fragment), zos) :-
    optional_recognize([S|Ss], uri([], [], [], [],
                                   Path, Query, Fragment), zos).



initial(q0).

final(q1).
final(q2).

delta(q0, X, q1, [X]) :- digit(X).

delta(q1, X, q1, [X]) :- digit(X), !.
delta(q1, '/', q2, []).


