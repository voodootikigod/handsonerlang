-module(my_map).

-compile(export_all).

map(F, List) -> [F(X) || X <- List].

map2(F, [H|T]) -> [F(H) | map2(F, T)];
map2(_, []) -> [].
