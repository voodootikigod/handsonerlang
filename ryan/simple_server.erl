-module(simple_server).

-record(internals,
        {cb_mod,
         state}).

-export([start/1, call/2]).

call(Server, Message) ->
  Server ! {self(), Message},
  receive
    Reply ->
      Reply
    after 100 ->
      done
  end.

start(CallbackModule) when is_atom(CallbackModule)->
  spawn(fun() -> main(CallbackModule) end).

%% Internal function
main(CallbackModule) ->
  StartingState = init(CallbackModule),
  loop(StartingState),
  CallbackModule:on_terminate().

init(CallbackModule) ->
  case CallbackModule:on_init() of
    {ok, StartingState} ->
      #internals{cb_mod=CallbackModule, state=StartingState};
    {error, Reason} ->
      throw({error, Reason})
  end.

loop(Internals) ->
  #internals{cb_mod=CallbackModule, state=State} = Internals,
  receive
    {From, Message} when is_pid(From) ->
      case CallbackModule:on_message(Message, State) of
        {reply, Reply, NewState} ->
          From ! Reply,
          loop(Internals#internals{state=NewState});
        stop ->
          ok
      end;
    Oops ->
      io:format("Ignoring unknown message: ~p~n", [Oops])
  end.
