#!/usr/bin/tclsh

#to get multiple data points of LLR
lassign $argv test len trials

for {set i 0} {$i<$trials} {incr i} {
	set E [exec ./randomtext.tcl english $len | ./$test.tcl]
	set N [exec ./randomtext.tcl noise $len | ./$test.tcl]
	puts "$E \t $N"
}
