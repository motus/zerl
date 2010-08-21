
-module(zml_srv).
-export([start/2, stop/0]).

% start misultin http server
start(Dir, Port) ->
  zml:start(),
  zml:template_dir(Dir, []),
  misultin:start_link([{port, Port}, {loop, fun handle_http/1}]).

% stop misultin
stop() -> misultin:stop().

% callback function called on incoming http request
handle_http(Req) ->
  % dispatch to rest
  handle(Req:get(method), Req:resource([lowercase, urldecode]), Req).

% handle a GET on /Page
handle('GET', [], Req) -> Req:ok(zml:render(index, [], []));

handle('GET', ["company" ], Req) -> Req:ok(zml:render(company,  [], []));
handle('GET', ["deal"    ], Req) -> Req:ok(zml:render(deal,     [], []));
handle('GET', ["index"   ], Req) -> Req:ok(zml:render(index,    [], []));
handle('GET', ["merchant"], Req) -> Req:ok(zml:render(merchant, [], []));
handle('GET', ["print"   ], Req) -> Req:ok(zml:render(print,    [], []));

%% % handle a GET on /users/{username}
%% handle('GET', ["users", UserName], Req) ->
%%   Req:ok("This is ~s's page.", [UserName]);

%% % handle a GET on /users/{username}/messages
%% handle('GET', ["users", UserName, "messages"], Req) ->
%%   Req:ok("This is ~s's messages page.", [UserName]);

% handle the 404 page not found
handle(_, _, Req) ->
  Req:ok("Page not found.").
