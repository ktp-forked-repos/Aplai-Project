import subprocess
import timeit

Files = ['clue17', 'clue18', 'coloin', 'eastermonster', 'expert', 'extra1',
'extra2', 'extra3', 'extra4', 'goldennugget', 'hard17', 'inkara2012', 'lambda',
'sudowiki_nb28', 'sudowiki_nb49', 'symme', 'tarek_052', 'verydifficult', 'veryeasy']

f = open('output viewpoint 1.txt', 'w')

for puzzle in Files:
    f.write(puzzle + '\n')
    start = timeit.timeit()
    output = subprocess.Popen("/home/bavo/Downloads/eclipse_basic\ "
    + "\(1\)/bin/x86_64_linux/clpeclipse -b eclipse_sudoku_viewpoint1.ecl "
    + "-b sudex_toledo.pl -e 'puzzles(P, " + puzzle + "), solve(P).'",
    shell=True, stdout=subprocess.PIPE).stdout.read()
    stop = timeit.timeit()
    f.write(output + '\n')
    f.write('elapsed time in ms ' +  str(abs(stop - start)) + '\n \n')
