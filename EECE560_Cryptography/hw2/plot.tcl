#!/usr/bin/tclsh

set data [string toupper [read stdin]]

set alphabet [split ABCDEFGHIJKLMNOPQRSTUVWXYZ ""]

foreach letter $alphabet { lappend freqs [regexp -all $letter $data] }

set sorted [lsort -integer $freqs]

set max [lindex $sorted end] 

package require Tk

pack [canvas .c -width 520 -height 200]

set x 0

set dx [expr 520/26] 

foreach num $freqs letter $alphabet {

	set y [expr 200-$num*200/$max]

		.c create rect $x 200 [incr x $dx] $y -fill red

		.c create text $x 200 -text $letter -anchor se

}
