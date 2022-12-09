%Volpato Mattia 866316
%Colombo Marco 866431

%authorithy :== '//' [userinfo @] host [':' port]

:- module(authorithy, [authorithy_recognize/2,
                       authorithy_recognize/3]).

:- use_module(definitions, [identifier/1]).
:- use_module(host).


authorithy_recognize(S, uri([], Userinfo, Host, Port,
                            Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    authorithy_recognize(L, uri([], Userinfo, Host, Port,
                                Path, Query, Fragment), auth).

authorithy_recognize([S|Ss], uri([], Userinfo, Host, Port,
                                 Path, Query, Fragment)) :-
    initial(Q),
    accept([S|Ss], Q, uri([], Userinfo, Host, Port,
                          Path, Query, Fragment), auth).

authorithy_recognize(S, uri([], Userinfo, Host, Port,
                            Path, Query, Fragment), Mode) :-
    string(S), !,
    string_chars(S, L),
    authorithy_recognize(L, uri([], Userinfo, Host, Port,
                                Path, Query, Fragment), Mode).

authorithy_recognize([S|Ss], uri([], Userinfo, Host, Port,
                                 Path, Query, Fragment), Mode) :-
    initial(Q),
    accept([S|Ss], Q, uri([], Userinfo, Host, Port,
                          Path, Query, Fragment), Mode).


accept([S|Ss], Q, uri([], NewUserinfo, Host, Port,
                      Path, Query, Fragment), Mode) :-
    delta(Q, S, R, User),
    accept(Ss, R, uri([], Userinfo, Host, Port,
                      Path, Query, Fragment), Mode), !,
    append(User, Userinfo, NewUserinfo).

accept([S|Ss], q2, uri([], [], Host, Port,
                       Path, Query, Fragment), Mode) :-
    host_recognize([S|Ss], uri([], [], Host, Port,
                               Path, Query, Fragment), Mode).

accept([S|Ss], q4, uri([], [], Host, Port,
                       Path, Query, Fragment), Mode) :-
    host_recognize([S|Ss], uri([], [], Host, Port,
                               Path, Query, Fragment), Mode).



initial(q0).


delta(q0, '/', q1, []).

delta(q1, '/', q2, []).

delta(q2, X, q3, [X]) :- identifier(X).

delta(q3, X, q3, [X]) :- identifier(X).
delta(q3, '@', q4, []).
















