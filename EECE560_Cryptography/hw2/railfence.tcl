#!/usr/local/bin/tclsh

#*************simple transposition cryptography*****************

set data [read stdin]
set data [regsub -all {[^A-Za-z]} $data ""]
set data [split $data ""]
puts "Plain: $data"

foreach {X Y} $data {
	append one $X
	append two $Y
	puts "<$X $Y>"
}

puts "Encode: $one$two"
