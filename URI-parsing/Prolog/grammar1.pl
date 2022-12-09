%Volpato Mattia 866316
%Colombo Marco 866431

%Grammar1 :== authorithy ['/' [path] ['?' query] ['#' fragment]]

:- module(grammar1, [recognize_1/2,
                     recognize_1/3]).

:- use_module('authorithy').


recognize_1(S, uri([], Userinfo, Host, Port,
                   Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    recognize_1(L, uri([], Userinfo, Host, Port,
                       Path, Query, Fragment)).

recognize_1([S|Ss], uri([], Userinfo, Host, Port,
                        Path, Query, Fragment)) :-
    authorithy_recognize([S|Ss], uri([], Userinfo, Host, Port,
                                     Path, Query, Fragment)).

recognize_1(S, uri([], Userinfo, Host, Port,
                   Path, Query, Fragment), zos) :-
    string(S), !,
    string_chars(S, L),
    recognize_1(L, uri([], Userinfo, Host, Port,
                       Path, Query, Fragment), zos).

recognize_1([S|Ss], uri([], Userinfo, Host, Port,
                        Path, Query, Fragment), zos) :-
    authorithy_recognize([S|Ss], uri([], Userinfo, Host, Port,
                                     Path, Query, Fragment), zos).

