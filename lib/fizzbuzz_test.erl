-module(fizzbuzz_test).

-include_lib("eunit/include/eunit.hrl").

short_test() ->
  [?assertMatch(["1"], fizzbuzz:do_it(1)),
   ?assertMatch(["1", "2", "fizz"], fizzbuzz:do_it(3)),
   ?assertMatch(["1", "2", "fizz", "4", "buzz"], fizzbuzz:do_it(5))].

deferred_test_() ->
  [?_assertMatch(["1"], fizzbuzz:do_it(1))].

generator_test_() ->
  test_generator(500).

%% Helper functions
test_generator(TestCount) ->
  {generator,
   fun() ->
       if
         %% No more tests to generate
         TestCount == 0 ->
           [];
          true ->
            [fun() ->
                verify(fizzbuzz:do_it(TestCount)) end | test_generator(TestCount - 1)]
       end end}.

verify(Results) ->
  verify(Results, 1).
verify([H|T], Position) ->
  if
    Position rem 3 == 0 andalso Position rem 5 == 0 ->
      H = "fizzbuzz";
    Position rem 3 == 0 ->
      H = "fizz";
    Position rem 5 == 0 ->
      H = "buzz";
    true ->
      H = integer_to_list(Position)
  end,
  verify(T, Position + 1);
verify([], _Position) ->
  ok.
