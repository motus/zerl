
-module(zerl_tests).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").


main_test() -> ?_assert(start() =:= ok).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start() -> application:start(zerl).

% callback function invoked on incoming http request
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
    _ -> {ok, BaseDir} = application:get_env(base_dir),
         % WARNING! Security hole: can serve ANY file!
         Req:file(BaseDir ++ "/" ++ Path)
  end.

