%%%-------------------------------------------------------------------
%% @doc retroerl public API
%% @end
%%%-------------------------------------------------------------------

-module(retroerl_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
%     wx:demo(),
    retroerl_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
