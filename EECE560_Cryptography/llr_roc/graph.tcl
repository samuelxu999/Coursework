#!/usr/bin/tclsh

set allnumbers [read stdin]
set sorted [lsort -real $allnumbers]
set min [lindex $sorted 0]; set max [lindex $sorted end]

lassign $argv bins

proc bin x { expr int(($x-$::min)*$::bins*.999/($::max-$::min)) }

#read data into histograms
for {set k 0} {$k<$bins} {incr k} {
	set Pe($k) 0
	set Pn($k) 0
}

foreach {E N} $allnumbers {
	incr Pe([bin $E])
	incr Pn([bin $N])
}

#get highest bin value to figure out how to scale graph
for {set hmax 0; set k 0} {$k<$bins} {incr k} {
	set hmax [expr max($hmax, $Pe($k),$Pn($k))]
}

# draw graph
package require Tk
pack [canvas .c -width 800 -height 200]
set dx [expr 400/$bins]
set x 0

for {set k 0} {$k<$bins} {incr k} {
	set Ye [expr {int(200-200.0*$Pe($k)/$hmax)}]
	set Yn [expr {int(200-200.0*$Pn($k)/$hmax)}]

	.c create rect $x 200 [incr x $dx] $Ye -fill red
	.c create rect $x 200 [incr x $dx] $Yn -fill green
}



