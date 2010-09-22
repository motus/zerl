
-module(zerl_tests).

-export([handle_http/1]).

% callback function called on incoming http request
handle_http(Req) ->
  error_logger:info_report(Req),
  handle(Req:get(method), Req:resource([lowercase, urldecode]), Req).

% handle a GET on /Page
handle('GET', [], Req) ->
  Req:respond(302, [{"Location", "/index.zml"}], []);

handle('GET', _, Req) ->
  {abs_path, Path} = Req:get(uri),
  error_logger:info_msg("= GET: ~s~n", [Path]),
  case string:right(Path, 5) of
    [_|".zml"] -> Req:ok(zml:render(Path));
    _ -> BaseDir = application:get_env(base_dir),
         Req:file(BaseDir ++ "/" ++ Path)
  end.

