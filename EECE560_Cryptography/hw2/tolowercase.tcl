#!/usr/bin/tclsh

set data [string tolower [split [regsub -all {[^A-Za-z]} [read stdin] ""] ""]]

set segment_index 0
set line_index 0 

foreach letter $data {	
	append out_group $letter
	set segment_index [expr {($segment_index+1)%8}]
	if { $segment_index==0 } {
		append out_group " "
		set line_index [expr {($line_index+1)%8}]
		if { $line_index==0 } {append out_group "\n"}		
	}
	
}

puts $out_group
