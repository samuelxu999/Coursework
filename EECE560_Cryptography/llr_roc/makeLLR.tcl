#!/usr/bin/tclsh

set english [string toupper [read [open corpus.txt]]]
set total [regexp -all {[A-Z]} $english]

foreach x [split ABCDEFGHIJKLMNOPQRSTUVWXYZ ""] {
	#calculate each alphabetic letter's count
	set count [ regexp -all $x $english ]
	#calculate LLR['alpha'] for each alphabetic letter
	set LLR [ expr log($count*26.0/$total) ]
	#append to out hashtable
	lappend out $x $LLR
}

puts "array set LLR { [ join $out ] }"
