%%%-------------------------------------------------------------------
%% @doc retroerl top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(retroerl_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    % one_for_one, one_for_all, rest_for_one, simple_one_for_one; in seconds
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    MainServer= #{
      id      => main_server, % anything but a pid()
      start   => {main_server, start_link, []}
    },

%     The UI display is transient, as a use might want to close the window.
    WxMain = #{
        id      => wxmain, % anything but a pid()
        start   => {wxmain, start_link, []},
        restart => transient,
        significant => false
        },
    {ok, {SupFlags, [WxMain]}}.

%% internal functions
