#!/usr/bin/tclsh

set arr_name [split ABCDEFGHIJKLMNOPQRSTUVWXYZ ""]

set data [string toupper [regsub -all {[^A-Za-z]} [read stdin] ""]]

######Initialize array to count the characters in the message 
foreach  cname $arr_name { set arr_stat($cname) 0 }

foreach char_ck [split $data ""] {
	foreach temp_name [array names arr_stat] {

		#compare checked character with alphatic table $arr_name
		set result_comp [string compare $temp_name $char_ck]

		#Add count of target character to statistic array table $arr_name 
		if {$result_comp==0} {
			#puts "<$temp_name $char_ck $result_comp>"
			set arr_stat($temp_name) [expr $arr_stat($temp_name)+1]
		 	break
		}
	}
}

#list statistics data
set output_xml "<root>"
foreach x [lsort [array names arr_stat]] {
	#puts "<$x $arr_stat($x)>"
	append output_xml "<Data><Alpha>$x</Alpha><Count>$arr_stat($x)</Count></Data>"
}
append output_xml "</root>"

puts $output_xml  
