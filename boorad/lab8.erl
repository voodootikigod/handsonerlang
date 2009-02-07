-module(lab8).

-compile(export_all).

dispatch(Req) ->
  "/" ++ Path = Req:get(path),
  Qs = Req:parse_qs(),
  case Path of
    "cached_value" ->
      Req:ok({"text/json", mochijson:encode(get_cached_value(Qs))});
    _ ->
      Req:not_found()
  end.

get_cached_value(Qs) ->
  Key = proplists:get_value("key", Qs),
  lab5:find_value(Key).
