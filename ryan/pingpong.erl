-module(pingpong).
-export([start/0]).
-export([start_fizbuzz/0]).

fiz_or_buzz() ->
	receive
		{evaluate, Sender, N} when N rem 15 == 0 ->
			Sender ! {result, "fizbuzz"},
			fiz_or_buzz();
		{evaluate, Sender, N} when N rem 3 == 0 ->
			Sender ! {result, "fiz"},
			fiz_or_buzz();
		{evaluate, Sender, N} when N rem 5 == 0 ->
			Sender ! {result, "buzz"},
			fiz_or_buzz();
		{evaluate, Sender, N} ->
			Sender ! {result, N},
			fiz_or_buzz();
		nothing -> ok
	end.

get_fiz_buzz(Fizbuzzer, N) ->
	Fizbuzzer ! {evaluate, self(), N},
	receive
		{result, R} -> R
	end.

start_iterate(Fizbuzzer, Nums) ->
	[get_fiz_buzz(Fizbuzzer, N) || N <- Nums].
	
start_fizbuzz() ->
	Fizbuzzer = spawn(fun() -> fiz_or_buzz() end),
	start_iterate(Fizbuzzer, lists:seq(1, 50)).
		

ping_pong() ->
	receive
		{count, Caller, N} when N < 50 ->
			Caller ! {count, self(), N + 1},
			ping_pong();
		{count, Caller, N} ->
			io:format("Final Num: ~p~n", [N]),
			Caller ! stop;
		step -> ok
	end.

ping(Caller) ->
	Caller ! {count, self(), 1},
	ping_pong().
	
pong() ->
	ping_pong().
			
start() ->
	Pid = spawn(fun() -> pong() end),
	spawn(fun() -> ping(Pid) end),
	ok.