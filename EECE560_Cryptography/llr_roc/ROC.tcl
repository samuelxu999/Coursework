#!/usr/bin/tclsh

proc curve {what length trials} {
	foreach {e n} [exec ./trials.tcl $what $length $trials] {
		lappend E $e
		lappend N $n
		incr size
	}
	set E [lsort -real $E]
	set N [lsort -real $N]
	
	set pe 0; set pn 0
	
	set out {1.0 1.0}; #threshold below every value:PF=PD=1

	foreach e $E {
		while {$pn<$size && [lindex $N $pn]<$e} {incr pn}
		set Pf [expr 1-$pn*1.0/$size]
		set Pd [expr 1-$pe*1.0/$size]
		lappend out $Pf $Pd
		incr pe
	}
	lappend out 0.0 0.0 ; #high threshold: PF=PD=0
}

package require Tk
pack [canvas .c -width 500 -height 500]

foreach {name length trials color} $argv {
	set L {}
	foreach {x y} [curve $name $length $trials] {
		lappend L [expr int($x*500)] [expr 500-int($y*500)]
	}
	.c create line $L -fill $color
}
