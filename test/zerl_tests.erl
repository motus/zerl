
-module(zerl_tests).

start(Params) ->
  [Dir, Port] = Params,
  Options = [{base_dir, Dir}, {port, list_to_integer(Port)}],
  error_logger:info_msg("- zml_srv:start/1: ~p~n", [Options]),
  error_logger:info_msg("- zml_srv:start/1: PID: ~p~n", [Pid]),
  error_logger:info_report([{Name, {Path, Ts, IsStatic}}
    || {Name, Path, Ts, _Templ, IsStatic} <- ets:tab2list(zml_templates)]).

% stop misultin
stop() -> misultin:stop().

% callback function called on incoming http request
handle_http(Req, Options) ->
  handle(Req:get(method), Req:resource([lowercase, urldecode]), Req, Options).

% handle a GET on /Page
handle('GET', [], Req, _Options) ->
  Req:respond(302, [{"Location", "/index.zml"}], []);

handle('GET', _, Req, Options) ->
  {abs_path, Path} = Req:get(uri),
  error_logger:info_msg("= GET: ~s~n", [Path]),
  case string:right(Path, 5) of
    [_|".zml"] -> Req:ok(zml:render(Path, Options));
    _ -> BaseDir = proplists:get_value(base_dir, Options, "."),
         Req:file(BaseDir ++ "/" ++ Path)
  end.

