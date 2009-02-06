-module(mochijson2_example).

-compile([export_all]).

-record(user,
        {name,
         followers}).


encode_text() ->
  Text = <<"This is a list-style string">>,
  mochijson2:encode(Text).

encode_integer() ->
  Integer = 123456789,
  mochijson2:encode(Integer).

encode_list() ->
  List = [<<"Hello">>, <<"world">>, 2, 6, 2009],
  mochijson2:encode({array, List}).

encode_struct() ->
  Proplist = [{<<"user">>, <<"kevsmith">>}, {<<"followers">>, <<"149">>}],
  mochijson2:encode({struct, Proplist}).

decode(Value) ->
  mochijson2:decode(Value).

decode_cb(Value, Callback) when is_function(Callback) ->
  Decoder = mochijson2:decoder([{object_hook, Callback}]),
  Decoder(Value).

object_to_record({struct, Object}) ->
  Name = proplists:get_value("user", Object, not_found),
  Followers = proplists:get_value("followers", Object, "0"),
  #user{name=Name, followers=list_to_integer(Followers)}.
