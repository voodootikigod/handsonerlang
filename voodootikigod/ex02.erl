-module(ex02).
-export([pp_start/0, fb_start/0]).

pinger()  ->
  volley().
  
ponger(PingPid)  ->
  PingPid ! {count, self(), 0},
  volley().

volley() ->
  receive
    {count, Pid, 50}  ->
      Pid ! shutdown,
      io:format("50~n");
    {count, Pid, N} ->
      io:format("Sending Message~n"),
      Pid ! {count, self(), (N+1)},
      volley();
    _ ->
      shutdown
  end.
  
  

pp_start() ->
  Pid1 = spawn(fun() -> pinger() end),
  spawn(fun() -> ponger(Pid1) end).


fb_evaluator()  ->
  receive
    {Pid, N} ->
      Fb = fizzbuzz(N),
      Pid ! {value, Fb},
      fb_evaluator();
    _ ->
      shutdown
  end.



fb_runner(Pid, Curr, Max) ->
  case Curr of 
    Max ->
      Pid ! shutdown,
      io:format("shutting down ~n");
    _ ->  
      Pid ! { self(), Curr},
      receive
        {value, Msg} -> 
          io:format("~p~n", [Msg])
      end,
      fb_runner(Pid, Curr+1, Max)
  end.

fb_start()  ->
  Pid1 = spawn(fun() -> fb_evaluator() end),
  spawn(fun() -> fb_runner(Pid1, 0, 100) end).
  
fizzbuzz(N) when N rem 3 == 0, N rem 5 == 0 -> fizzbuzz;
fizzbuzz(N) when N rem 3 == 0 -> fizz;
fizzbuzz(N) when N rem 5 == 0 -> buzz;
fizzbuzz(N) -> N.