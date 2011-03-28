-module(ink_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, _Pid} = ink_sup:start_link(),
    ink_web:start().


stop(_State) ->
    ok.
