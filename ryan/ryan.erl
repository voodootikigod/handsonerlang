-module(ryan).
-compile([export_all]).

map(F, L) -> [F(X) || X <- L].

% Need to accumulate
fb([H|T]) when H rem 15 == 0 -> "fizbuzz", fb(T);
fb([H|T]) when H rem 3 == 0 -> "fiz", fb(T);
fb([H|T]) when H rem 5 == 0 -> "buzz", fb(T);
fb([H|T]) -> H, fb(T);
fb([]) -> ok.