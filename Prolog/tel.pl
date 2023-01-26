%Volpato Mattia 866316
%Colombo Marco 866431

%scheme-syntax :== userinfo

:- module(tel, [tel_recognize/2]).

:- use_module('definitions', [identifier/1]).

tel_recognize(S,  uri([], Userinfo, [], [],
                      [], [], [])) :-
    string(S), !,
    string_chars(S, L),
    tel_recognize(L,  uri([], Userinfo, [], [],
                          [], [], [])).

tel_recognize([S|Ss],  uri([], [S|Ss], [], [],
                           [], [], [])) :-
    accept([S|Ss]).

accept([X]) :- identifier(X), !.
accept([S|Ss]) :- identifier(S), accept(Ss).
