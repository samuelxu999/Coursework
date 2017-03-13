#!/usr/bin/tclsh
set plain [split ZABCDEFGHIJKLMNOPQRSTUVWXY ""]

lassign $argv W X Y Z

#matrix product:
#[C] = [ W X ][ A ] = [ WA+XB ]
#[D] = [ Y Z ][ B ] = [ YA+ZB ]

for {set A 0} {$A<26} {incr A} {
for {set B 0} {$B<26} {incr B} {
	set C [expr {($W*$A+$X*$B)%26}]
	set D [expr {($Y*$A+$Z*$B)%26}]
	set in [lindex $plain $A][lindex $plain $B]
	set out [lindex $plain $C][lindex $plain $D]
	set arr($in) $out
    }
}
set data [string toupper [read stdin]]

append data X

set data [regsub -all {[^A-Z]} $data ""]

puts [string map [array get arr] $data]
