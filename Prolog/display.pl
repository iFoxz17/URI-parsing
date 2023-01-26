%Volpato Mattia 866316
%Colombo Marco 866431

:- module(display, [uri_string/2,
                    convert/2,
                    convert/3,
                    uri_text/2]).

convert([], []) :- !.
convert(Atom, R) :-
    atom(Atom), is_list(R), !,
    atom_string(Atom, S1), string_lower(S1, LowS1),
    string_chars(S2, R), string_lower(S2, LowS2),
    LowS1=LowS2.

convert(Atom, [X|Xs]) :-
    var(Atom), !, atom_chars(Atom, [X|Xs]).
convert(Atom, [X|Xs]) :-
    atom(Atom), atom_chars(Atom, [X|Xs]).


convert(80, [], port) :- !.
convert(Port, [D|Ds], port) :-
    var(Port), !, number_chars(Port, [D|Ds]).
convert(Port, [D|Ds], port) :-
    number(Port), number_chars(Port, [D|Ds]).

uri_string(uri(Scheme, [], [], [], [], [], []), S) :- !,
    Scheme\=[], atom_string(Scheme, Sch), string_chars(Sch, Sc),
    append(Sc, [':'], Tmp2), string_chars(S, Tmp2).

uri_string(uri(Scheme, [], [], 80, [], [], []), S) :- !,
    Scheme\=[], atom_string(Scheme, Sch), string_chars(Sch, Sc),
    append(Sc, [':'], Tmp2), string_chars(S, Tmp2).


uri_string(uri(Scheme, Userinfo, [], [], [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="TEL", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2),
    convert(Userinfo, User), append(Tmp2, User, L),
    string_chars(S, L).

uri_string(uri(Scheme, Userinfo, [], 80, [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="TEL", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2),
    convert(Userinfo, User), append(Tmp2, User, L),
    string_chars(S, L).

uri_string(uri(Scheme, Userinfo, [], [], [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="FAX", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2), convert(Userinfo, User),
    append(Tmp2, User, L), string_chars(S, L).

uri_string(uri(Scheme, Userinfo, [], 80, [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="FAX", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2),
    convert(Userinfo, User), append(Tmp2, User, L),
    string_chars(S, L).


uri_string(uri(Scheme, [], Host, [], [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="NEWS", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2),
    convert(Host, H), append(Tmp2, H, L),
    string_chars(S, L).

uri_string(uri(Scheme, [], Host, 80, [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="NEWS", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2),
    convert(Host, H), append(Tmp2, H, L),
    string_chars(S, L).

uri_string(uri(Scheme, Userinfo, [], [], [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="MAILTO", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2),
    convert(Userinfo, User), append(Tmp2, User, L),
    string_chars(S, L).

uri_string(uri(Scheme, Userinfo, [], 80, [], [], []), S) :-
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1="MAILTO", !, convert(Scheme, Sc),
    append(Sc, [':'], Tmp2),
    convert(Userinfo, User), append(Tmp2, User, L),
    string_chars(S, L).

uri_string(uri(Scheme, Userinfo, Host, [], [], [], []), S) :-
    atom_string(Scheme, Sch),
    string_upper(Sch, Tmp1),
    Tmp1="MAILTO", !, Userinfo\=[],
    convert(Scheme, Sc), append(Sc, [':'], Tmp2),
    convert(Userinfo, User), append(Tmp2, User, Tmp3),
    convert(Host, H),
    append(Tmp3, ['@'], Tmp4), append(Tmp4, H, L),
    string_chars(S, L).

uri_string(uri(Scheme, Userinfo, Host, 80, [], [], []), S) :-
    atom_string(Scheme, Sch),
    string_upper(Sch, Tmp1),
    Tmp1="MAILTO", !, Userinfo\=[],
    convert(Scheme, Sc), append(Sc, [':'], Tmp2),
    convert(Userinfo, User), append(Tmp2, User, Tmp3),
    convert(Host, H),
    append(Tmp3, ['@'], Tmp4), append(Tmp4, H, L),
    string_chars(S, L).


uri_string(uri(Scheme, Userinfo, Host, Port,
               Path, Query, Fragment), S) :- !,
    atom_string(Scheme, Sch), string_upper(Sch, Tmp1),
    Tmp1\="TEL", Tmp1\="FAX", Tmp1\="MAILTO",
    Tmp1\="NEWS",
    build_scheme(uri(Scheme, Userinfo, Host, Port,
                     Path, Query, Fragment), L),
    string_chars(S, L).

build_scheme(uri(Scheme, [], [], 80, Path, Query, Fragment), L) :-
    Scheme\=[], convert(Scheme, Tmp), append(Tmp, [':'], Sc),
    build_path(uri([], [], [], [], Path, Query, Fragment), R), !,
    append(['/'], R, T), append(Sc, T, L).


build_scheme(uri(Scheme, [], [], [], Path, Query, Fragment), L) :-
    Scheme\=[], convert(Scheme, Tmp), append(Tmp, [':'], Sc),
    build_path(uri([], [], [], [], Path, Query, Fragment), R), !,
    append(['/'], R, T), append(Sc, T, L).


build_scheme(uri(Scheme, Userinfo, Host, Port,
                 Path, Query, Fragment), L) :-
    convert(Scheme, Tmp), append(Tmp, [':'], Sc),
    build_userinfo(uri([], Userinfo, Host, Port,
                       Path, Query, Fragment), R), !,
    append(['/', '/'], R, T), append(Sc, T, L).


build_userinfo(uri([], [], Host, Port, Path, Query, Fragment), L) :-
    build_host(uri([], [], Host, Port, Path, Query, Fragment), L), !.

build_userinfo(uri([], Userinfo, Host, Port,
                   Path, Query, Fragment), L) :-
    convert(Userinfo, User), append(User, ['@'], Tmp1),
    build_host(uri([], [], Host, Port, Path, Query, Fragment), R),
    append(Tmp1, R, L).

build_host(uri([], [], Host, Port, Path, Query, Fragment), L) :-
    Host\=[], convert(Host, H),
    build_port(uri([], [], [], Port, Path, Query, Fragment), R),
    append(H, R, L).

build_port(uri([], [], [], [], Path, Query, Fragment), L) :- !,
    build_path(uri([], [], [], [], Path, Query, Fragment), R),
    append(['/'], R, L).

build_port(uri([], [], [], Port, Path, Query, Fragment), L) :-
    number_chars(Port, Tmp), append([':'], Tmp, R),
    build_path(uri([], [], [], [], Path, Query, Fragment), T),
    append(R, ['/'], R1), append(R1, T, L).

build_path(uri([], [], [], [], [], Query, Fragment), L) :-
    build_query(uri([], [], [], [], [], Query, Fragment), L), !.


build_path(uri([], [], [], [], Path, Query, Fragment), L) :-
    convert(Path, Pa),
    build_query(uri([], [], [], [], [], Query, Fragment), R),
    append(Pa, R, L).

build_query(uri([], [], [], [], [], [], Fragment), L) :-
    build_fragment(uri([], [], [], [], [], [], Fragment), L), !.

build_query(uri([], [], [], [], [], Query, Fragment), L) :-
    convert(Query, Tmp), append(['?'], Tmp, Qu),
    build_fragment(uri([], [], [], [], [], [], Fragment), R),
    append(Qu, R, L).

build_fragment(uri([], [], [], [], [], [], []), []) :- !.

build_fragment(uri([], [], [], [], [], [], Fragment), Frag) :-
    convert(Fragment, Tmp), append(['#'], Tmp, Frag).



text_convert([], ['[', ']']) :- !.
text_convert(Atom, [X|Xs]) :- atom_chars(Atom, [X|Xs]).


uri_text(uri(Scheme, Userinfo, Host, Port,
             Path, Query, Fragment), T) :-
    string_chars("Scheme: ", IntSc),
    text_convert(Scheme, ScL),
    append(IntSc, ScL, Sc),
    append(Sc, ['\n'], Tmp1),
    string_chars("Userinfo: ", IntUs),
    text_convert(Userinfo, UsL),
    append(IntUs, UsL, Us), append(Us, ['\n'], TmpU),
    append(Tmp1, TmpU, Tmp2),
    string_chars("Host: ", IntH),
    text_convert(Host, HL),
    append(IntH, HL, H), append(H, ['\n'], TmpH),
    append(Tmp2, TmpH, Tmp3),
    string_chars("Port: ", IntPo),
    text_convert(Port, PoL),
    append(IntPo, PoL, Po), append(Po, ['\n'], TmpPo),
    append(Tmp3, TmpPo, Tmp4),
    string_chars("Path: ", IntPa), text_convert(Path, PaL),
    append(IntPa, PaL, Pa), append(Pa, ['\n'], TmpPa),
    append(Tmp4, TmpPa, Tmp5),
    string_chars("Query: ", IntQ), text_convert(Query, QL),
    append(IntQ, QL, Qu), append(Qu, ['\n'], TmpQ),
    append(Tmp5, TmpQ, Tmp6),
    string_chars("Fragment: ", IntF),
    text_convert(Fragment, FL),
    append(IntF, FL, F), append(F, ['\n'], TmpF),
    append(Tmp6, TmpF, Tmp),
    string_chars(T, Tmp).











