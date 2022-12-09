%Volpato Mattia 866316
%Colombo Marco 866431

:- use_module('uri-util').

uri_parse(S, uri(Scheme, Userinfo, Host, Port,
                 Path, Query, Fragment)) :-
    uri_build(S, uri(Scheme, Userinfo, Host, Port,
                     Path, Query, Fragment)).

uri_display(S) :- uri_print(S).

uri_display(S, Out) :- uri_print(S, Out).











