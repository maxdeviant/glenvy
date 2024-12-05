-module(glenvy_ffi).
-export([get_all_env/0, get_env/1, set_env/2, unset_env/1]).

get_all_env() ->
    BinVars = lists:map(fun(VarString) ->
        [VarName, VarVal] = string:split(VarString, "="),
        {list_to_binary(VarName), list_to_binary(VarVal)}
    end, os:getenv()),
    maps:from_list(BinVars).

get_env(Name) ->
    case os:getenv(binary_to_list(Name)) of
        false -> {error, nil};
        Value -> {ok, list_to_binary(Value)}
    end.

set_env(Name, Value) ->
    os:putenv(binary_to_list(Name), binary_to_list(Value)),
    nil.

unset_env(Name) ->
    os:unsetenv(binary_to_list(Name)),
    nil.
