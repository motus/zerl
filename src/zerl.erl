
-module(zerl).

-export([start_link/0, stop/0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start_link() ->
  zml:start(),
  lists:foreach(fun zml:template_dir/1,
    default(application:get_env(zml_templates), ["."])),
  misultin:start_link(
    get_fun(handle_http_module, handle_http,    loop) ++
    get_fun(handle_ws_module,   handle_ws,   ws_loop) ++
    application:get_all_env(misultin)).

stop() -> misultin:stop().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

default(undefined, Def) -> Def;
default(Val,      _Def) -> Val.

get_fun(Mod, Fun, Prop) ->
  get_fun_impl(application:get_env(Mod), Fun, Prop).

get_fun_impl(undefined, _Fun, _Prop) -> [];

get_fun_impl(ModName, Fun, Prop) ->
  {module, Mod} = code:ensure_loaded(application:get_env(ModName)),
  true = erlang:function_exported(Mod, Fun, 1),
  [{Prop, fun(Req) -> apply(Mod, Fun, [Req]) end}].

