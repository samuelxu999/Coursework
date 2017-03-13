#!/usr/bin/tclsh

#set data [string toupper [read stdin]]
set data [read stdin]

set alphabet [split ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ""]
set asicc_alpha "41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a"

#set keys map struct <alpha, asicc>
foreach index_key $alphabet index_value $asicc_alpha { set arr_keys($index_key) $index_value }

#calculate frequence of letter
foreach letter_asicc $asicc_alpha letter [array names arr_keys] { 
	lappend freqs [set freq_temp [regexp -all $letter_asicc $data]]
	set arr_stat($letter) $freq_temp 
}
 
# get the max count
set sorted [lsort -integer $freqs]
#get the max count to set up bound of bar range.
set max [lindex $sorted end] 

#export statistics data as xml
set output_xml "<root>"

foreach letter [lsort [array names arr_stat]] {
	#puts "<$x $arr_stat($x)>"
	append output_xml "<Data><Alpha>$letter</Alpha><Count>$arr_stat($letter)</Count></Data>"
}
append output_xml "</root>"
puts $output_xml
