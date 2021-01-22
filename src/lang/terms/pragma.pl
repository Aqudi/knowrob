:- module(lang_pragma,
    [ match_operator/2
    ]).

:- use_module(library('db/mongo/compiler')).
:- use_module(library('db/mongo/query')).

%% register query commands
:- query_command_add(pragma).

%%
% pragma(Goal) is evaluated compile-time by calling
% the Goal. This is usually done to unify variables
% used in the aggregation pipeline from the call context.
%
query_compiler:step_compile(
		pragma(Goal),
		_Context, []) :-
	call(Goal).

