#!/bin/bash
divide=1000000

echo verydifficult
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, verydifficult), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo expert
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, expert), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo lambda
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, lambda), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo hard17
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, hard17), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo symme
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, symme), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo eastermonster
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, eastermonster), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo tarek_052
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, tarek_052), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo goldennugget
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, goldennugget), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo coloin
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, coloin), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra1
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, extra1), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra2
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, extra2), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra3
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, extra3), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo extra4
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, extra4), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo inkara2012
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, inkara2012), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo clue18
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, clue18), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo clue17
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, clue17), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo sudowiki_nb28
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, sudowiki_nb28), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo sudowiki_nb49
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, sudowiki_nb49), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.

echo veryeasy
start_time=$(python time.py)
/home/bavo/Downloads/eclipse_basic\ \(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl -b sudex_toledo.pl -e "puzzles(P, veryeasy), solve(P)."
end_time=$(python time.py)
elapsed_time=$(((end_time - start_time)))
echo execution time was $elapsed_time ms.
