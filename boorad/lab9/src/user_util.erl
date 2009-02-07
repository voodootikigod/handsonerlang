-module(user_util).

-export([url_encode/1, url_decode/1]).


url_encode([H|T]) ->
  if
    H >= $a, $z >= H ->
      [H|url_encode(T)];
    H >= $A, $Z >= H ->
      [H|url_encode(T)];
    H >= $0, $9 >= H ->
      [H|url_encode(T)];
    H == $_; H == $.; H == $-; H == $/; H == $: -> % FIXME: more..
      [H|url_encode(T)];
    true ->
      case erlang:integer_to_list(H, 16) of
        [X, Y] ->
          [$%, X, Y | url_encode(T)];
           [X] ->
              [$%, $0, X | url_encode(T)]
       end
  end;
url_encode([]) ->
  [].

url_decode([$+|T]) ->
  [$\s|url_decode(T)];
url_decode([$%, Hi, Lo|T]) ->
  Hex = erlang:list_to_integer([Hi, Lo], 16),
  [Hex|url_decode(T)];
url_decode([H|T]) when is_list(H) ->
  [url_decode(H) | url_decode(T)];
url_decode([H|T]) ->
  [H|url_decode(T)];
url_decode([]) ->
  [].
