-module(quick_process).

-compile([export_all]).

execute(Times, ProcCount) ->
  execute(Times, ProcCount, []).

execute(Times, ProcCount, Accum) when Times > 0 ->
  execute(Times - 1, ProcCount, [run(ProcCount) | Accum]);
execute(0, ProcCount, Accum) ->
  Sum = lists:sum(Accum),
  AvgTotalTime = Sum / length(Accum),
  AvgProcTime = Sum / (length(Accum) * ProcCount),
  io:format("Avg Time: ~p~nAvg Proc Time: ~p~n", [AvgTotalTime, AvgProcTime]).

run(ProcCount) ->
  Me = self(),
  ListenerPid = spawn(fun() -> listener(Me, {true, [], ProcCount}) end),
  start_processes(ListenerPid, ProcCount),
  receive
    {result, Time} ->
      Time / 1000
  end.

listener(Owner, {true, [], ProcCount}) ->
  receive
    proc_dead ->
      listener(Owner, {false, now_to_micros(erlang:now()), ProcCount - 1})
  end;
listener(Owner, {false, Start, ProcCount}) when ProcCount > 0 ->
  receive
    proc_dead ->
      listener(Owner, {false, Start, ProcCount - 1})
  end;
listener(Owner, {_, Start, 0}) ->
  End = now_to_micros(erlang:now()),
  Owner ! {result, End - Start}.

start_processes(ListenerPid, ProcCount) when ProcCount > 0 ->
  spawn(fun() ->
            ListenerPid ! proc_dead end),
  start_processes(ListenerPid, ProcCount - 1);
start_processes(_, 0) ->
  ok.


now_to_micros({Mega, Secs, Micro}) ->
  ((Mega * math:pow(1000000, 2)) + (Secs * 1000000) + Micro).
