-module(conbuzz).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

start() ->
	Buzzer = spawn(fun() -> buzzer() end),
	fizzer(Buzzer).
	%%spawn(fun() -> fizzer(Buzzer) end).
	
fizzer(Buzzer) ->
	Values = lists:seq(1, 100),
	Result = [fizsend(X, Buzzer) || X <- Values],
	Buzzer ! stop,
	Result.
	
fizsend(N, Buzzer) ->
	Buzzer ! {evaluate, self(), N},
	receive
		{result, R} ->
			R
	end.

buzzer() ->
	receive
		{evaluate, Sender, X} ->
			Sender ! {result, fizzbuzz(X)},
			buzzer();
		stop ->
			ok
	end.

fizzbuzz(X) when X rem 3 == 0, X rem 5 == 0 -> "fizzbuzz";
fizzbuzz(X) when X rem 3 == 0 -> "fizz";
fizzbuzz(X) when X rem 5 == 0 -> "buzz";
fizzbuzz(X) -> X.


			
			
			

