%Volpato Mattia 866316
%Colombo Marco 866431

%optional ::= [path] ['?' query] ['#' fragment]

:- module(optional, [optional_recognize/2,
                     optional_recognize/3]).


:- use_module(zos_path).
:- use_module(path).
:- use_module(query).
:- use_module(fragment).

optional_recognize(S, uri([], [], [], [],
                          Path, Query, Fragment), zos) :-
    string(S), !, string_chars(S, L),
    optional_recognize(L, uri([], [], [], [],
                              Path, Query, Fragment), zos).

optional_recognize([S|Ss], uri([], [], [], [],
                               Path, Query, Fragment), zos) :-
    zos_path_recognize([S|Ss], uri([], [], [], [],
                                   Path, Query, Fragment)).

%optional_recognize(['?'|Ss], uri([], [], [], [],
%                                 [], Query, Fragment), zos) :-
%    query_recognize(Ss, uri([], [], [], [],
%                            [], Query, Fragment)), !.

%optional_recognize(['#'|Ss], uri([], [], [], [],
%                                 [], [], Fragment), zos) :-
%    fragment_recognize(Ss, uri([], [], [], [],
%                               [], [], Fragment)).


optional_recognize(S, uri([], [], [], [],
                          Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    optional_recognize(L, uri([], [], [], [],
                              Path, Query, Fragment)).

optional_recognize([S|Ss], uri([], [], [], [],
                               Path, Query, Fragment)) :-
    path_recognize([S|Ss], uri([], [], [], [],
                               Path, Query, Fragment)), !.

optional_recognize(['?'|Ss], uri([], [], [], [],
                                 [], Query, Fragment)) :-
    query_recognize(Ss, uri([], [], [], [],
                            [], Query, Fragment)), !.

optional_recognize(['#'|Ss], uri([], [], [], [],
                                 [], [], Fragment)) :-
    fragment_recognize(Ss, uri([], [], [], [],
                               [], [], Fragment)).
