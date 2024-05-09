cat avalanche.txt|tail -n +2 | gnuplot -p -e "set xdata time; set timefmt '%Y-%m-%d %H:%M:%S'; plot '-' using 2:1 with lines"
