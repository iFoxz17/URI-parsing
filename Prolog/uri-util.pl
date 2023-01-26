%Volpato Mattia 866316
%Colombo Marco 866431

:- module('uri-util', [uri_build/2,
                       uri_print/1,
                       uri_print/2]).

:- use_module('scheme').
:- use_module('display').


uri_build(S, uri(Scheme, Userinfo, Host, Port,
                 Path, Query, Fragment)) :-
    nonvar(S), !,
    recognize(S, uri(Sc, U, H, Po, Pa, Q, F)),
    convert(Scheme, Sc), convert(Userinfo, U),
    convert(Host, H), convert(Port, Po, port),
    convert(Path, Pa), convert(Query, Q),
    convert(Fragment, F).


uri_build(S, uri(Scheme, Userinfo, Host, Port,
                 Path, Query, Fragment)) :-
    var(S),
    uri_string(uri(Scheme, Userinfo, Host, Port,
                   Path, Query, Fragment), S).


uri_print(uri(Scheme, Userinfo, Host, Port,
              Path, Query, Fragment)) :- !,
    uri_text(uri(Scheme, Userinfo, Host, Port,
                 Path, Query, Fragment), S),
    write(S).

uri_print(S) :- string(S),
    uri_build(S, uri(Scheme, Userinfo, Host, Port,
                     Path, Query, Fragment)),
    uri_print(uri(Scheme, Userinfo, Host, Port,
                    Path, Query, Fragment)).


uri_print(uri(Scheme, Userinfo, Host, Port,
              Path, Query, Fragment), Stream) :-
    is_stream(Stream), !,
    uri_text(uri(Scheme, Userinfo, Host, Port,
                 Path, Query, Fragment), S),
    write(Stream, S).


uri_print(uri(Scheme, Userinfo, Host, Port,
              Path, Query, Fragment), File) :- !,
    open(File, append, OutStream),
    uri_print(uri(Scheme, Userinfo, Host, Port,
                    Path, Query, Fragment), OutStream),
    close(OutStream).


uri_print(S, Out) :- string(S),
     uri_build(S, uri(Scheme, Userinfo, Host, Port,
                      Path, Query, Fragment)),
     uri_print(uri(Scheme, Userinfo, Host, Port,
                     Path, Query, Fragment), Out), !.

