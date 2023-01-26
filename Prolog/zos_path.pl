%Volpato Mattia 866316
%Colombo Marco 866431

%zos_path ::= <id44> ['(' <id8> ')']

:- module('zos_path', [zos_path_recognize/2]).

:- use_module(id44).


zos_path_recognize(S, uri([], [], [], [],
                          Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    zos_path_recognize(L, uri([], [], [], [],
                              Path, Query, Fragment)).

zos_path_recognize([S|Ss], uri([], [], [], [],
                               Id44, Query, Fragment)) :-
    id44_recognize([S|Ss], uri([], [], [], [],
                               zos_path(Id44, []),
                               Query, Fragment)), !.

zos_path_recognize([S|Ss], uri([], [], [], [],
                               Path, Query, Fragment)) :-
    id44_recognize([S|Ss],
    uri([], [], [], [],
        zos_path(Id44, Id8), Query, Fragment)),
    append(Id44, ['('], Tmp1), append(Tmp1, Id8, Tmp2),
    append(Tmp2, [')'], Path).


