%Volpato Mattia 866316
%Colombo Marco 866431

%scheme-syntax :== userinfo ['@' host]

:- module(mailto, [mailto_recognize/2]).

:- use_module('host').
:- use_module('definitions', [identifier/1]).


mailto_recognize(S,  uri([], Userinfo, Host, [],
                         [], [], [])) :-
    string(S), !,
    string_chars(S, L),
    mailto_recognize(L,  uri([], Userinfo, Host, [],
                             [], [], [])).

mailto_recognize([S|Ss],  uri([], Userinfo, Host,
                              [], [], [], [])) :-
    initial(Q),
    accept([S|Ss], Q, uri([], Userinfo, Host,
                          [], [], [], [])).

accept([S|Ss], Q, uri([], NewUserinfo, NewHost, [],
                      [], [], [])) :-
    delta(Q, S, R, uri([], U, H, [], [], [], [])), !,
    accept(Ss, R, uri([], Userinfo, Host, [],
                      [], [], [])),
    append(U, Userinfo, NewUserinfo),
    append(H, Host, NewHost).

accept([], Q, uri([], [], [], [],
                  [], [], [])) :- final(Q).

accept([S|Ss], q2, uri([], [], Host, [],
                       [], [], [])) :-
    host_recognize([S|Ss], Host).

initial(q0).

final(q1).

delta(q0, X, q1, uri([], [X], [], [], [], [], [])) :-
    identifier(X).

delta(q1, X, q1, uri([], [X], [], [], [], [], [])) :-
    identifier(X).

delta(q1, '@', q2, uri([], [], [], [], [], [], [])).





