%Volpato Mattia 866316
%Colombo Marco 866431

%Grammar2 :== [/] [path] [? query] [# fragment]

:- module(grammar2, [recognize_2/2,
                     recognize_2/3]).

:- use_module('optional').


recognize_2(S, uri([], [], [], [],
                   Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    recognize_2(L, uri([], [], [], [],
                       Path, Query, Fragment)).

recognize_2([S|Ss], uri([], [], [], [],
                        Path, Query, Fragment)) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], [], [],
                          Path, Query, Fragment)).

recognize_2([], uri([], [], [], [],
                    Path, Query, Fragment)) :-
    initial(Q),
    accept([], Q, uri([], [], [], [],
                      Path, Query, Fragment)).


accept([S|Ss], Q, uri([], [], [], [],
                      Path, Query, Fragment)) :-
    delta(Q, S, R), !,
    accept(Ss, R, uri([], [], [], [],
                      Path, Query, Fragment)).

accept([], Q, uri([], [], [], [], [], [], [])) :-
    final(Q).

accept([S|Ss], Q, uri([], [], [], [],
                      Path, Query, Fragment)) :-
    final(Q),
    optional_recognize([S|Ss], uri([], [], [], [],
                                   Path, Query, Fragment)), !.




recognize_2(S, uri([], [], [], [],
                   Path, Query, Fragment), zos) :-
    string(S), !,
    string_chars(S, L),
    recognize_2(L, uri([], [], [], [],
                       Path, Query, Fragment), zos).

recognize_2([S|Ss], uri([], [], [], [],
                        Path, Query, Fragment), zos) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], [], [],
                          Path, Query, Fragment), zos).

accept([S|Ss], Q, uri([], [], [], [],
                      Path, Query, Fragment), zos) :-
    delta(Q, S, R),
    accept(Ss, R, uri([], [], [], [],
                      Path, Query, Fragment), zos), !.

accept([S|Ss], Q, uri([], [], [], [],
                      Path, Query, Fragment), zos) :-
    final(Q),
    optional_recognize([S|Ss], uri([], [], [], [],
                                   Path, Query, Fragment), zos), !.

%accept([], Q, uri([], [], [], [], [], [], []), zos) :-
%    final(Q).




initial(q0).

final(q1).

delta(q0, '/', q1).


