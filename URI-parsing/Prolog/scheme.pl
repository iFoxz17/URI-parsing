%Volpato Mattia 866316
%Colombo Marco 866431

%scheme ::= scheme ':' grammar

:- module(scheme, [recognize/2]).

:- use_module('definitions', [identifier/1]).

:- use_module('grammar1').
:- use_module('grammar2').
:- use_module('mailto').
:- use_module('news').
:- use_module('tel').


recognize(S, uri(Scheme, Userinfo, Host, Port,
                 Path, Query, Fragment)) :-
    string(S), !,
    string_chars(S, L),
    recognize(L, uri(Scheme, Userinfo, Host, Port,
                     Path, Query, Fragment)).

recognize([S|Ss], uri(Scheme, Userinfo, Host, Port,
                      Path, Query, Fragment)) :-
    initial(Q),
    accept([S|Ss], Q, uri(Scheme, Userinfo, Host, Port,
                          Path, Query, Fragment), []).

accept([S|Ss], Q, uri(NewScheme, Userinfo, Host, Port,
                      Path, Query, Fragment), Acc) :-
    delta(Q, S, R, Sc), !,
    append(Acc, Sc, NewAcc),
    accept(Ss, R, uri(Scheme, Userinfo, Host, Port,
                      Path, Query, Fragment), NewAcc),
    append(Sc, Scheme, NewScheme).

accept([S|Ss], q2, uri([], Userinfo, Host, [],
                       [], [], []), Acc) :-
    string_chars(Sc, Acc), string_upper(Sc, Scheme),
    Scheme="MAILTO", !,
    mailto_recognize([S|Ss], uri([], Userinfo, Host,
                                 [], [], [], [])).

accept([S|Ss], q2, uri([], [], Host, [],
                       [], [], []), Acc) :-
    string_chars(Sc, Acc), string_upper(Sc, Scheme),
    Scheme="NEWS", !,
    news_recognize([S|Ss], uri([], [], Host, [],
                               [], [], [])).

accept([S|Ss], q2, uri([], Userinfo, [], [],
                       [], [], []), Acc) :-
    string_chars(Sc, Acc),
    string_upper(Sc, Scheme), Scheme="TEL", !,
    tel_recognize([S|Ss], uri([], Userinfo, [], [],
                              [], [], [])).

accept([S|Ss], q2, uri([], Userinfo, [], [],
                       [], [], []), Acc) :-
    string_chars(Sc, Acc),
    string_upper(Sc, Scheme), Scheme="FAX", !,
    tel_recognize([S|Ss], uri([], Userinfo, [], [],
                              [], [], [])).

accept([S|Ss], q2, uri([], Userinfo, Host, Port,
                       Path, Query, Fragment), Acc) :-
    string_chars(Sc, Acc),
    string_upper(Sc, Scheme), Scheme="ZOS",
    recognize_1([S|Ss], uri([], Userinfo, Host, Port,
                            Path, Query, Fragment), zos), !.

accept([S|Ss], q2, uri([], [], [], [],
                       Path, Query, Fragment), Acc) :-
    string_chars(Sc, Acc),
    string_upper(Sc, Scheme), Scheme="ZOS", !,
    recognize_2([S|Ss], uri([], [], [], [],
                            Path, Query, Fragment), zos).



accept([S|Ss], q2, uri([], Userinfo, Host, Port,
                       Path, Query, Fragment), _) :-
    recognize_1([S|Ss], uri([], Userinfo, Host, Port,
                            Path, Query, Fragment)), !.

accept([S|Ss], q2, uri([], [], [], [],
                       Path, Query, Fragment), _) :-
    recognize_2([S|Ss], uri([], [], [], [],
                            Path, Query, Fragment)), !.

accept([], q2, uri([], [], [], [],
                   Path, Query, Fragment), _) :-
    recognize_2([], uri([], [], [], [],
                        Path, Query, Fragment)), !.

accept([], Q, uri([], [], [], [], [], [], []), Acc) :-
    final(Q), string_chars(Sc, Acc),
    string_upper(Sc, Scheme), Scheme\="ZOS".



initial(q0).

final(q2).

delta(q0, X, q1, [X]) :- identifier(X).

delta(q1, X, q1, [X]) :- identifier(X).

delta(q1, ':', q2, []).
