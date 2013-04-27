-module(n2o_chat_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

-define(APPS, [gproc, sync, crypto, ranch, cowboy, n2o_chat]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

%% to start manually from console with start.sh
start() ->
    [begin application:start(A), io:format("~p~n", [A]) end || A <- ?APPS].

start(_StartType, _StartArgs) ->
    n2o_chat_sup:start_link().

stop(_State) ->
    ok.
