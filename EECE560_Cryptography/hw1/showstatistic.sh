#!/usr/bin/tclsh

exec od -A n -t x1 < sample.pdf | ./hexdump_plot.tcl

