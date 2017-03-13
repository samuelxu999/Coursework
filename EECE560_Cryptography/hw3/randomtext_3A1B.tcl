#!/usr/bin/tclsh

set noise AAAB

lassign $argv length

for {set i 0} {$i<$length} {incr i} {
	append out [string index $noise [expr int(rand()*[string length $noise])]]
}

puts $out
