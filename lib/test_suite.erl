-module(test_suite).

-include_lib("eunit/include/eunit.hrl").

all_test_() ->
  [{module, fizzbuzz_test},
   {module, time_server_test}].
