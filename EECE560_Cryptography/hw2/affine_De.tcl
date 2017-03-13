#!/usr/bin/tclsh

set plain [split ZABCDEFGHIJKLMNOPQRSTUVWXY ""]

lappend argv 1
lassign $argv shift mult

for {set P 0} {$P<26} {incr P} {
set C [expr {(($P+$shift)*$mult)%26}]
set arr([lindex $plain $P]) [lindex $plain $C]
}

set data [string toupper [read stdin]] 

puts [string map [array get arr] $data]
