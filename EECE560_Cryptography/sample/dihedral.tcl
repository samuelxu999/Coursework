#!/usr/bin/tclsh
set WIDTH 300

package require Tk
pack [canvas .c -width $WIDTH -height $WIDTH]

proc adjust coordinates {
	foreach {x y} $coordinates {
         lappend output [expr {$::WIDTH*(1+$x*0.9)/2}]
         lappend output [expr {$::WIDTH*(1-$y*0.9)/2}]
	}
     lappend output
}

proc drawpoly permutation {
	set f  [expr 1.0/[llength $permutation]]
	set th [expr 8*atan(1.0)*$f]
	foreach k $permutation {
		set x [expr cos($k*$th)]; set y [expr sin($k*$th)]
		incr k;  incr c
		set z [expr cos($k*$th)]; set q [expr sin($k*$th)]
		set coords [adjust [list 0 0 $x $y $z $q]]
		.c create poly $coords -fill [huefrom [expr $c*$f]]
	}
}

proc huefrom f {
	set q [expr int($f*6)%6];	;# quotient
	set m [expr int($f*6*256)&0xff] ;# remainder
	set c [expr $m^0xff]		;# c = 255-m

	switch $q {
		0 {set r 255; 	set g $m;   set b 0}
		1 {set r $c; 	set g 255;   set b 0}
		2 {set r 0; 	set g 255;   set b $m}
		3 {set r 0; 	set g $c;   set b 255}
		4 {set r $m; 	set g 0;   set b 255}
		5 {set r 255; 	set g 0;   set b $c}
	}
	format #%02x%02x%02x $r $g $b
}


# drawpoly {1 2 3 4 5 6 7}  <--- commented out

lappend argv 7		;# default n if none provided
set n [lindex $argv 0]  ;# number of sides from command line

for {set i 1} {$i<=$n} {incr i} { lappend poly $i }

set initial_permutation $poly

set left  [concat [lrange $poly 1 end] [lrange $poly 0 0]]
set right [concat [lrange $poly end end] [lrange $poly 0 end-1]]
set flip [lreverse $poly]

puts "p = $poly\nl = $left\nr = $right\nf = $flip"

drawpoly $poly

proc compose {g h} {
       foreach a $h { lappend out [lindex $g $a-1] }
       set out
}

proc process key {
	switch $key {
		l {set ::poly [compose $::left $::poly]}
		r {set ::poly [compose $::right $::poly]}
		f {set ::poly [compose $::flip $::poly]}
		Escape {set ::poly $::initial_permutation}
	}
	puts $key
}

bind . <Key> {
	.c delete all
	process %K
	drawpoly $poly
}
