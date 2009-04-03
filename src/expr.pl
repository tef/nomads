:- use_module(nomads).

:- nomad( stack, [push,pop], [] ).

:- nomad_method( push(X), Old, New, New = [X|Old] ).
:- nomad_method( pop(X),  Old, New, Old = [X|New] ).

:- nomad_pred( expression/0,   [stack,dcg] ).
:- nomad_pred( term/0,         [stack,dcg] ).
:- nomad_pred( factor/0,       [stack,dcg] ).

eval(Exp,Result) :--
    ( expression, stack::pop(Result) ) with (dcg(Exp),stack).


expression -->> term, [+], expression,
    stack::pop(X), % The expression.
    stack::pop(Y), % The term.
    Result is X + Y,
    stack::push(Result).

expression -->> term.


term -->> factor, [*], term,
    stack::pop(X), % The term.
    stack::pop(Y), % The factor.
    Result is X * Y,
    stack::push(Result).

term -->> factor.


factor -->> ['('], expression, [')'].
factor -->> [X], number(X), stack::push(X).
