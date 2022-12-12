-module(wxmain).

-include_lib("wx/include/wx.hrl").

-behaviour(wx_object).

-export([
    start/1, start_link/0, start_link/1, init/1, code_change/3, terminate/2,
    handle_event/2,  handle_call/3, handle_cast/2, handle_info/2
]).

-define(TITLE,"Canvas Example").
-define(SIZE,  {600, 600}).

-record(state, {frame, panel}). % button, text}).

start(Debug) ->
    wx_object:start_link(?MODULE, Debug, []).


start_link() ->
    start_link([]).

start_link(Debug) ->
    Status = wx_object:start_link(?MODULE, Debug, []),
    {ok, wx_object:get_pid(Status)}.

init(Config) ->

    Wx = wx:new(Config),

    process_flag(trap_exit, true),

    Frame = wxFrame:new(Wx, ?wxID_ANY, ?TITLE, [{size, ?SIZE }]),

    wxFrame:connect(Frame, size),
    wxFrame:connect(Frame, close_window),

    Panel = wxPanel:new(Frame, []),
%     wxPanel:connect(Panel, paint, [callback]),
%
%     Button_id = erlang:unique_integer([positive, monotonic]),
%     Button = wxButton:new(Panel, Button_id, label: 'hello'),
%     wxButton:connect(Button, :command_button_clicked),
%
%     Text_id = erlang:unique_integer([:positive, :monotonic]),
%     Text = wxTextCtrl:new(panel, text_id, pos: {0, 32}),
%
    wxFrame:show(Frame),
% %
    State = #state{panel= Panel, frame= Frame}, % button= Button, text= Text},
    {Frame, State}.


%% Async Events are handled in handle_event as in handle_info
handle_event(#wx{event = #wxSize{size = {W,H}}}, State = #state{panel= Panel}) ->
    wxPanel:setSize(Panel, {W, H}),
    {noreply, State};

handle_event(#wx{event = #wxClose{type = close_window}}, State = #state{frame=Frame}) ->
    wxFrame:destroy(Frame),
    {stop, normal, State};

handle_event(Ev,State) ->
    io:format("~p handle_event callback ~p~n",[?MODULE, Ev]),
    {noreply, State}.


% handle_event({:wx, _, ref, _, {:wxCommand, :command_button_clicked, _, _, _}}, state) ->
%     % :wxButton.destroy(ref)
%     text_line = wxTextCtrl:getLineText(state.text, 0),
%     wxButton:setLabel(state.button, text_line),
%     {:noreply, state}.
%
%
% handle_sync_event({:wx, _, _, _, {:wxPaint, :paint}}, _, state = #{panel: panel}) ->
%     brush = wxBrush:new()
%     wxBrush:setColour(brush, {255, 255, 255, 255})
%
%     dc = wxPaintDC:new(panel)
%     wxDC:setBackground(dc, brush)
%     wxDC:clear(dc)
%     wxPaintDC:destroy(dc)
%     :ok

%%%%%%%%%%%%
%% Callbacks
%% Handled as in normal gen_server callbacks

handle_info(Msg, State) ->
    io:format("~p handle_info callback:  ~p~n",[?MODULE, Msg]),
    {noreply,State}.

handle_call(Msg, _From, State) ->
    io:format("~p handle_call callback: ~p~n",[?MODULE, Msg]),
    {reply,ok,State}.

handle_cast(Msg, State) ->
    io:format("~p handle_cast callback: ~p~n",[?MODULE, Msg]),
    {noreply,State}.

code_change(_, _, State) ->
    {stop, not_yet_implemented, State}.

terminate(_Reason, _State) ->
    wx:destroy().


%% internal functions
