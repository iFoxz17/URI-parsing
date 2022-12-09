%Volpato Mattia 866316
%Colombo Marco 866431

%host ::= <identificatore-host> ['.' <identificatore-host>]*
%| indirizzo-IP

:- module(host, [host_recognize/2,
                 host_recognize/3]).

:- use_module('ipAddress').
:- use_module('optional').
:- use_module('port').
:- use_module('definitions', [host_identifier/1]).


host_recognize(S, Host) :- string(S), !,
    string_chars(S, L),
    host_recognize(L, Host).

host_recognize([S|Ss], L) :-
    ip_recognize([S|Ss], ip(T0, T1, T2, T3)), !,
    ip_display(Host, ip(T0, T1, T2, T3)),
    string_chars(Host, L).

host_recognize([S|Ss], L) :- initial(Q),
    accept([S|Ss], Q, L).

accept([S|Ss], Q, [S|Host]) :- delta(Q, S, R),
       accept(Ss, R, Host).

accept([], Q, []) :- final(Q).




host_recognize(S, uri([], [], Host, Port,
                      Path, Query, Fragment), Mode) :-
    string(S), !,
    string_chars(S, L),
    host_recognize(L, uri([], [], Host, Port,
                          Path, Query, Fragment), Mode).

host_recognize([S|Ss], uri([], [], L, Port,
                           Path, Query, Fragment), Mode) :-
    ip_recognize([S|Ss], uri([], [], ip(T0, T1, T2, T3), Port,
                     Path, Query, Fragment), Mode), !,
    ip_display(Host, ip(T0, T1, T2, T3)),
    string_chars(Host, L).

host_recognize([S|Ss],  uri([], [], Host, Port,
                            Path, Query, Fragment), Mode) :-
    initial(Q),
    accept([S|Ss], Q, uri([], [], Host, Port,
                          Path, Query, Fragment), Mode).

accept([S|Ss], Q, uri([], [], [S|Host], Port,
                      Path, Query, Fragment), Mode) :-
    delta(Q, S, R),
    accept(Ss, R, uri([], [], Host, Port,
                      Path, Query, Fragment), Mode), !.

accept(['/'], Q, uri([], [], [], ['8', '0'],
                     [], [], []), auth) :-
    final(Q), !.

accept([], Q, uri([], [], [], ['8', '0'],
                  [], [], []), auth) :-
    final(Q).

accept([':'|Ss], Q, uri([], [], [], Port,
                        Path, Query, Fragment), auth) :-
    final(Q), !,
    port_recognize(Ss, uri([], [], [], Port,
                           Path, Query, Fragment)).

accept(['/'|Ss], Q, uri([], [], [], ['8', '0'],
                        Path, Query, Fragment), auth) :-
    final(Q),
    optional_recognize(Ss, uri([], [], [], [],
                               Path, Query, Fragment)).

accept([':'|Ss], Q, uri([], [], [], Port,
                        Path, Query, Fragment), zos) :-
    final(Q), !,
    port_recognize(Ss, uri([], [], [], Port,
                           Path, Query, Fragment), zos).

accept(['/'|Ss], Q, uri([], [], [], ['8', '0'],
                        Path, Query, Fragment), zos) :-
    final(Q),
    optional_recognize(Ss, uri([], [], [], [],
                               Path, Query, Fragment), zos).



initial(q0).

final(q1).

delta(q0, X, q1) :- host_identifier(X).

delta(q1, X, q1) :- host_identifier(X), !.
delta(q1, '.', q2).

delta(q2, X, q1) :- host_identifier(X).



















