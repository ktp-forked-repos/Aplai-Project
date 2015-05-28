:- use_module(library(chr)).

:- chr_constraint test/2.

test(9,List) <=> List :: 1:9.
test(_,List) <=> List is 1+1.
