%Volpato Mattia 866316
%Colombo Marco 866431

%scheme-syntax :== host

:- module(news, [news_recognize/2]).

:- use_module('host').

news_recognize(S,  uri([], [], Host, [],
                       [], [], [])) :-
    string(S), !,
    string_chars(S, L),
    news_recognize(L,  uri([], [], Host, [],
                           [], [], [])).

news_recognize([S|Ss],  uri([], [], Host, [],
                            [], [], [])) :-
    host_recognize([S|Ss], Host).

