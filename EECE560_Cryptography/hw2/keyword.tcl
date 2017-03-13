#!/usr/local/bin/tclsh

#*************keyword transposition cryptography*****************

set keyword [lindex $argv 0]
#set temp [lindex $argv 1]
#puts "<$keyword , $temp>"

set unsorted [split $keyword ""]
set sorted [lsort $unsorted]
#puts "<$unsorted  |  $sorted>"

set data [regsub -all {[^A-Za-z]} [read stdin] ""]
puts "Plant:$data"

foreach $unsorted [split $data ""] {
	foreach T $unsorted {
		append  tempin [set $T]
	}
	foreach L $sorted {
		append tempout [set $L]
		append output [set $L]
	}
	puts "<$tempin $tempout>"
	set tempin [regsub -all {[A-Za-z]} $tempin ""]
	set tempout [regsub -all {[A-Za-z]} $tempout ""]
}
puts "Encode:$output"
