-module(fizzbuzz_conc).

-compile([export_all]).

start() ->
  io:format("start~n"),
  FB = spawn(fun() -> fizzbuzzer() end),
  io:format("fizzbuzzer pid: ~p~n", [FB]),
  Looper = spawn(fun() -> looper(FB) end),
  io:format("looper     pid: ~p~n", [Looper]),
  Looper ! {go, 100}.


fizzbuzzer() ->
  receive
    {evaluate, Sender, Num} ->
      Sender ! {result, fizzbuzz(Num)},
      fizzbuzzer();
    stop ->
      io:format("stopping fizzbuzzer"),
      ok;
    Oops ->
      io:format("wtf? : ~p", [Oops])
  end.

looper(FB) ->
  receive
    {go, Max} ->
      io:format("starting loop"),
      Fun = fun(X) ->
		io:format("evaluating ~p~n", [X]),
		FB ! {evaluate, self(), X},
		receive
		  {result, Num} ->
		    Num
		end
	    end,
      lists:map(Fun, lists:seq(1,Max)),
      FB ! stop;
    _ ->
      ok
  end.


%% internal functions

fizzbuzz(Num) when Num rem 15 == 0 ->
  fizzbuzz;
fizzbuzz(Num) when Num rem 5 == 0 ->
  buzz;
fizzbuzz(Num) when Num rem 3 == 0 ->
  fizz;
fizzbuzz(Num) ->
  Num.
