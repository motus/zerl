
-module(zml_srv).

-export([start/1, stop/0]).

% start misultin http server
start(Params) ->
  [Dir, Port] = Params,
  Options = [{base_dir, Dir}, {port, list_to_integer(Port)}],
  io:format("- zml_srv:start/1: ~p~n", [Options]),
  zml:start(),
  zml:template_dir("", Options),
  {ok, Pid} = misultin:start_link(
    [{loop, fun(Req) -> handle_http(Req, Options) end} | Options]),
  io:format("- zml_srv:start/1: PID: ~p~n", [Pid]),
  io:format("  ~p~n",
    [[{Name, Path, Ts} ||
      {Name, Path, Ts, _Templ} <- ets:tab2list(zml_templates)]]),
  receive Msg -> Msg end.

% stop misultin
stop() -> misultin:stop().

% callback function called on incoming http request
handle_http(Req, Options) ->
  handle(Req:get(method), Req:resource([lowercase, urldecode]), Req, Options).

% handle a GET on /Page
handle('GET', [], Req, Options) ->
  Req:ok(zml:render("/index.zml", [], Options));

%% % handle a GET on /users/{username}
%% handle('GET', ["users", UserName], Req) ->
%%   Req:ok("This is ~s's page.", [UserName]);

%% % handle a GET on /users/{username}/messages
%% handle('GET', ["users", UserName, "messages"], Req) ->
%%   Req:ok("This is ~s's messages page.", [UserName]);

handle('GET', _, Req, Options) ->
  {abs_path, Path} = Req:get(uri),
  % io:format("= GET: ~s~n", [Path]),
  case string:right(Path, 5) of
    [_|".zml"] -> Req:ok(zml:render(Path, [], Options));
    _ -> BaseDir = proplists:get_value(base_dir, Options, "."),
         Req:file(BaseDir ++ "/" ++ Path)
  end.

