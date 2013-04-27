-module(n2o_chat_sup).
-behaviour(supervisor).
-include_lib ("n2o/include/wf.hrl").
-define(APP, n2o_chat).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, _} = cowboy:start_http(http, 100,
				[{port, 8000}],
				[{env, [{dispatch, dispatch_rules()}]}]),
    {ok, {{one_for_one, 5, 10}, []}}.

dispatch_rules() ->
    cowboy_router:compile(
      [{'_', [
	      {["/static/[...]"], cowboy_static, [{directory, {priv_dir, ?APP, [<<"static">>]}},
						  {mimetypes, {fun mimetypes:path_to_mimes/2, default}}]},
	      {["/websocket/[...]"], n2o_websocket, []},
	      {'_', n2o_cowboy, []}
	     ]}]).
