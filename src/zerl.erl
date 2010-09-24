
-module(zerl).

-export([start_link/0, start/0, stop/0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start_link() ->
  lists:foreach(fun application:start/1,
    [crypto, ssl, epgsql, epgsql_pool, zml]),
  lists:foreach(fun zml:template_dir/1,
    default(application:get_env(zml_templates), [""])),
  error_logger:info_report([{Name, {Path, Ts, IsStatic}}
    || {Name, Path, Ts, IsStatic} <- ets:tab2list(zml_templates)]),
  application:start(misultin),
  Options =
    get_fun(handle_http_module, handle_http,    loop) ++
    get_fun(handle_ws_module,   handle_ws,   ws_loop) ++
    application:get_all_env(misultin),
  error_logger:info_report(Options),
  misultin:start_link(Options).

start() -> start_link().

stop() -> misultin:stop().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

default(undefined,  Def) -> Def;
default({ok, Val}, _Def) -> Val.

get_fun(Mod, Fun, Prop) ->
  get_fun_impl(application:get_env(Mod), Fun, Prop).

get_fun_impl(undefined, _Fun, _Prop) -> [];

get_fun_impl({ok, ModName}, Fun, Prop) ->
  {module, Mod} = code:ensure_loaded(ModName),
  true = erlang:function_exported(Mod, Fun, 1),
  [{Prop, fun(Req) -> apply(Mod, Fun, [Req]) end}].

