-module(wxmain).

-include_lib("wx/include/wx.hrl").

-behaviour(wx_object).

-export([
    start/1, start_link/0, start_link/1, init/1, code_change/3, terminate/2,
    handle_event/2,  handle_call/3, handle_cast/2, handle_info/2, handle_sync_event/3
]).

-define(TITLE,"Canvas Example").
-define(SIZE,  {600, 600}).

-record(state, {frame, panel,
pen,
brush,
font}).

start(Debug) ->
    wx_object:start_link(?MODULE, Debug, []).


start_link() ->
    start_link([]).

start_link(Debug) ->
    Status = wx_object:start_link(?MODULE, Debug, []),
    {ok, wx_object:get_pid(Status)}.

% init(Config) ->
%     wx:batch(fun() -> do_init(Config) end).

init(Config) ->

    Wx = wx:new(Config),

    process_flag(trap_exit, true),

    Frame = wxFrame:new(Wx, ?wxID_ANY, ?TITLE, [{size, ?SIZE }]),

    wxFrame:connect(Frame, size),
    wxFrame:connect(Frame, close_window),

    Panel = wxPanel:new(Frame, []),
    wxPanel:connect(Panel, paint, [callback]),


    wxFrame:show(Frame),

% SEGFAULT ??
%     %% Setup sizers
%     MainSizer = wxBoxSizer:new(?wxVERTICAL),
%     Sizer = wxStaticBoxSizer:new(?wxVERTICAL, Panel,    [{label, "wxGraphicsContext"}]),
%
    Pen = ?wxBLACK_PEN,
    Brush = wxBrush:new({30, 175, 23, 127}),
    Font = ?wxITALIC_FONT,
%
%     %% Add to sizers
%     wxSizer:add(Sizer, Panel, [{flag, ?wxEXPAND},    {proportion, 1}]),
%     wxSizer:add(MainSizer, Sizer, [{flag, ?wxEXPAND},    {proportion, 1}]),
%
%     wxPanel:setSizer(Panel, MainSizer),

{Frame,
#state{frame= Frame, panel = Panel, pen = Pen, brush = Brush, font = Font}}.


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


% handle_sync_event(#wx{ event= #wxPaint{}}, _wxObj, State = #state{panel = Panel}) ->
%     Brush = wxBrush:new(),
%     wxBrush:setColour(Brush, {255, 255, 255, 255}),
%
%     DC = wxPaintDC:new(Panel),
%     wxDC:setBackground(DC, Brush),
%     wxDC:clear(DC),
%     wxPaintDC:destroy(DC),
%     ok.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sync events i.e. from callbacks must return ok, it cannot return a new state.
%% Do the redrawing here.
handle_sync_event(#wx{event = #wxPaint{}},_wxObj, #state{panel=Panel, pen = Pen, brush = Brush, font = Font}) ->
    io:format("Inside Paint handler"),
    %% PaintDC must be created in a callback to work on windows.
    DC = wxPaintDC:new(Panel),
    %% Nothing is drawn until wxPaintDC is destroyed.
    draw(DC, Pen, Brush, Font),
    wxPaintDC:destroy(DC),
    ok;


handle_sync_event(Ev, _From, State) ->
    io:format("~p handle_sync_event callback: ~p~n",[?MODULE, Ev]),
    {noreply,State}.

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

draw(Win, Pen, Brush, Font) ->
    try
        Canvas = wxGraphicsContext:create(Win),
        wxGraphicsContext:setPen(Canvas, Pen),
        wxGraphicsContext:setBrush(Canvas, Brush),
        wxGraphicsContext:setFont(Canvas, Font, {0, 0, 50}),

        wxGraphicsContext:drawRoundedRectangle(Canvas, 35.0,35.0, 100.0, 50.0, 10.0),
        wxGraphicsContext:drawText(Canvas, "This text should be antialised", 60.0, 55.0),
        Path = wxGraphicsContext:createPath(Canvas),
        wxGraphicsPath:addCircle(Path, 0.0, 0.0, 40.0),
        wxGraphicsPath:closeSubpath(Path),
        wxGraphicsContext:translate(Canvas, 100.0, 250.0),

        F = fun(N) ->
            wxGraphicsContext:scale(Canvas, 1.1, 1.1),
            wxGraphicsContext:translate(Canvas, 15.0,-1.0*N),
            wxGraphicsContext:drawPath(Canvas, Path)
            end,
            wx:foreach(F, lists:seq(1,10)),
            wxGraphicsObject:destroy(Path),
            wxGraphicsObject:destroy(Canvas),
            ok
            catch _:{not_supported, _} ->
                Err = "wxGraphicsContext not available in this build of wxwidgets",
                io:format(Err,[])
                end.
