#!/usr/bin/tclsh

#intialize hastable for alphabetic order: Z 0 A 1 B 2......Y 25
set alphabet [split ZABCDEFGHIJKLMNOPQRSTUVWXY ""]
set arr_index 0
foreach  cname $alphabet { 	
	set arr_alpha($cname) $arr_index 
	set arr_encrypt($arr_index) $cname
	set arr_index [expr {$arr_index+1}]
}

#foreach x [lsort [array names arr_alpha]] {	
	#append output "<Alpha>$x</Alpha><Count>$arr_encrypt($x)</Count>\n"
#	append output "<$x> : <$arr_alpha($x)>\n"
#}
#puts $output
#puts [array get arr_encrypt]

set data [string toupper [split [regsub -all {[^A-Za-z]} [read stdin] ""] ""]]

set keywords [string toupper [lindex $argv 0]]
set keylength [string length $keywords]
set key_index 0

#set keywords [split $keywords ""]
foreach letter $data {
	set key [lindex [split $keywords ""] [expr {$key_index % $keylength}]]
	set encrypt_index [expr {($arr_alpha($letter)+$arr_alpha($key))%26}]
	#append outputs $C
	#puts $encrypt_index
	#puts $arr_encrypt($encrypt_index)
	set key_index [expr {$key_index+1}]
	append output $arr_encrypt($encrypt_index)
}
puts $output

