#!/usr/bin/tclsh
#relplace A and B with “ALLIGATOR” and “BUFFALO”
set  noise AB
array set a_noise {A ALLIGATOR B BUFFALO}

lassign $argv length

for {set i 0} {$i<$length} {incr i} {
	append out $a_noise([string index $noise [expr int(rand()*[string length $noise])]])
}

puts $out
