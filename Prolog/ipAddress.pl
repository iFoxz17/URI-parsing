%Volpato Mattia 866316
%Colombo Marco 866431

%ipAddress ::= <NNN.NNN.NNN.NNN - con N digit>

:- module(ipAddress, [ip_recognize/3,
                      ip_recognize/2,
                      ip_display/2]).
:- use_module('optional').
:- use_module('port').
:- use_module('definitions', [digit/1]).



ip_display(S, ip(T0, T1, T2, T3)) :-
    var(S), append(T0, ['.'], T00),
    append(T00, T1, T01), append(T01, ['.'], T11),
    append(T11, T2, T12), append(T12, ['.'], T22),
    append(T22, T3, T33), string_chars(S, T33).



ip_recognize(S, ip(T0, T1, T2, T3)) :-
    string(S), !,
    string_chars(S, L),
    ip_recognize(L, ip(T0, T1, T2, T3)).

ip_recognize([S|Ss], ip(T0, T1, T2, T3)) :-
    accept([S|Ss], ip(T0, T1, T2, T3)).

accept([S|SS], ip(T0, T1, T2, T3)) :-
    initial(Q),
    accept([S|SS], Q, ip(T0, T1, T2, T3)),
    number_chars(N0, T0), N0>=0, N0=<255,
    number_chars(N1, T1), N1>=0, N1=<255,
    number_chars(N2, T2), N2>=0, N2=<255,
    number_chars(N3, T3), N3>=0, N3=<255.


accept([S|Ss], Q, ip(NewT0, NewT1, NewT2, NewT3)) :-
    delta(Q, S, R, ip(TT0, TT1, TT2, TT3)),
    accept(Ss, R, ip(T0, T1, T2, T3)),
    append(TT0, T0, NewT0), append(TT1, T1, NewT1),
    append(TT2, T2, NewT2), append(TT3, T3, NewT3).

accept([], Q, ip([], [], [], [])) :- final(Q).





ip_recognize(S, uri([], [], ip(T0, T1, T2, T3), Port,
                    Path, Query, Fragment), Mode) :-
    string(S), !,
    string_chars(S, L),
    ip_recognize(L, uri([], [], ip(T0, T1, T2, T3), Port,
                        Path, Query, Fragment), Mode).

ip_recognize([S|Ss], uri([], [], ip(T0, T1, T2, T3),
                    Port, Path, Query, Fragment), Mode) :-
    accept_check([S|Ss], uri([], [], ip(T0, T1, T2, T3),
                    Port, Path, Query, Fragment), Mode).

accept_check([S|SS], uri([], [], ip(T0, T1, T2, T3),
                    Port, Path, Query, Fragment), Mode) :-
    initial(Q),
    accept([S|SS], Q, uri([], [], ip(T0, T1, T2, T3),
                    Port, Path, Query, Fragment), Mode),
    number_chars(N0, T0), N0>=0, N0=<255,
    number_chars(N1, T1), N1>=0, N1=<255,
    number_chars(N2, T2), N2>=0, N2=<255,
    number_chars(N3, T3), N3>=0, N3=<255.


accept([S|Ss], Q, uri([], [], ip(NewT0, NewT1, NewT2, NewT3),
                      Port, Path, Query, Fragment), Mode) :-
    delta(Q, S, R, ip(TT0, TT1, TT2, TT3)),
    accept(Ss, R, uri([], [], ip(T0, T1, T2, T3),
                    Port, Path, Query, Fragment), Mode), !,
    append(TT0, T0, NewT0), append(TT1, T1, NewT1),
    append(TT2, T2, NewT2), append(TT3, T3, NewT3).

accept([], q17, uri([], [], ip([], [], [], []),
                    ['8', '0'], [], [], []), auth) :- !.

accept([], Q, uri([], [], ip([], [], [], []),
                  ['8', '0'], [], [], []), auth) :-
    final(Q).

accept([S|Ss], q16, uri([], [], ip([], [], [], []), Port,
                        Path, Query, Fragment), auth) :-
    port_recognize([S|Ss], uri([], [], [], Port,
                               Path, Query, Fragment)), !.

accept([S|Ss], q17, uri([], [], ip([], [], [], []), ['8', '0'],
                        Path, Query, Fragment), auth) :-
    optional_recognize([S|Ss], uri([], [], [], [],
                                   Path, Query, Fragment)).

accept([S|Ss], q16, uri([], [], ip([], [], [], []), Port,
                        Path, Query, Fragment), zos) :-
    port_recognize([S|Ss], uri([], [], [], Port,
                               Path, Query, Fragment), zos), !.

accept([S|Ss], q17, uri([], [], ip([], [], [], []), ['8', '0'],
                        Path, Query, Fragment), zos) :-
    optional_recognize([S|Ss], uri([], [], [], [],
                                   Path, Query, Fragment), zos).





initial(q0).

final(q15).

delta(q0, X, q1, ip([X], [], [], [])) :- digit(X).
delta(q1, X, q2, ip([X], [], [], [])) :- digit(X).
delta(q2, X, q3, ip([X], [], [], [])) :- digit(X).
delta(q3, '.', q4, ip([], [], [], [])).

delta(q4, X, q5, ip([], [X], [], [])) :- digit(X).
delta(q5, X, q6, ip([], [X], [], [])):- digit(X).
delta(q6, X, q7, ip([], [X], [], [])) :- digit(X).
delta(q7, '.', q8, ip([], [], [], [])).

delta(q8, X, q9, ip([], [], [X], [])) :- digit(X).
delta(q9, X, q10, ip([], [], [X], [])) :- digit(X).
delta(q10, X, q11, ip([], [], [X], [])) :- digit(X).
delta(q11, '.', q12, ip([], [], [], [])).

delta(q12, X, q13, ip([], [], [], [X])) :- digit(X).
delta(q13, X, q14, ip([], [], [], [X])) :- digit(X).
delta(q14, X, q15, ip([], [], [], [X])) :- digit(X).

delta(q15, ':', q16, ip([], [], [], [])).
delta(q15, '/', q17, ip([], [], [], [])).


