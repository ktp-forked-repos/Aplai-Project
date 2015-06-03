#!/bin/bash
divide=1000000

echo verydifficult
start_time=$(python time.py)
swipl -g 'puzzles(P,  verydifficult), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo expert
start_time=$(python time.py)
swipl -g 'puzzles(P,  expert), chr_sudoku_viewpoint1S1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo lambda
start_time=$(python time.py)
swipl -g 'puzzles(P,  lambda), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo hard17
start_time=$(python time.py)
swipl -g 'puzzles(P,  hard17), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo symme
start_time=$(python time.py)
swipl -g 'puzzles(P,  symme), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo eastermonster
start_time=$(python time.py)
swipl -g 'puzzles(P,  eastermonster), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo tarek_052
start_time=$(python time.py)
swipl -g 'puzzles(P,  tarek_052), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo goldennugget
start_time=$(python time.py)
swipl -g 'puzzles(P,  goldennugget), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo coloin
start_time=$(python time.py)
swipl -g 'puzzles(P,  coloin), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra1
start_time=$(python time.py)
swipl -g 'puzzles(P,  extra1), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra2
start_time=$(python time.py)
swipl -g 'puzzles(P,  extra2), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra3
start_time=$(python time.py)
swipl -g 'puzzles(P,  extra3), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra4
start_time=$(python time.py)
swipl -g 'puzzles(P,  extra4), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo inkara2012
start_time=$(python time.py)
swipl -g 'puzzles(P,  inkara2012), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo clue18
start_time=$(python time.py)
swipl -g 'puzzles(P,  clue18), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo clue17
start_time=$(python time.py)
swipl -g 'puzzles(P,  clue17), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo sudowiki_nb28
start_time=$(python time.py)
swipl -g 'puzzles(P,  sudowiki_nb28), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo sudowiki_nb49
start_time=$(python time.py)
swipl -g 'puzzles(P,  sudowiki_nb49), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo veryeasy
start_time=$(python time.py)
swipl -g 'puzzles(P,  veryeasy), chr_sudoku_viewpoint1S1:solve(P),halt' -f 'sudex_toledo.pl' 'CHR_VP1_S1.pl'
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.
