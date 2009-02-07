-module(memcached_web).

-compile(export_all).

-define(HEADER, "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"> <html> <head><title >Memcached</title></head> <body>").
-define(FOOTER, "</body></html>").

start(Port) ->
  memcached:start_link(),
  memcached:add_value("foo", "bar"),
  mochiweb_http:start([{port, Port}, {loop, {?MODULE, mochiweb_request}}]).

mochiweb_request(Request) ->
  [_ | Path] = Request:get(path),
  run(Request, mochiweb_util:path_split(Path)).

format_response(Content) ->
  list_to_binary(io_lib:format("~s~n~s~n~s~n", [?HEADER, Content, ?FOOTER])).

run(Request, {"cached_value", Name}) ->
  case memcached:find_value(Name) of
    {ok, Value} -> Request:ok({"text/html", format_response(Value)});
    _           -> Request:not_found()
  end;

run(Request, _) ->
  Request:not_found().
