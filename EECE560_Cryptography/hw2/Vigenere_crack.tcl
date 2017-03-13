#!/usr/bin/tclsh

#intialize hastable for alphabetic order: Z 0 A 1 B 2......Y 25
set alphabet [split ZABCDEFGHIJKLMNOPQRSTUVWXY ""]
set arr_index 0
foreach  cname $alphabet { 	
	set arr_alpha($cname) $arr_index 
	set arr_encrypt($arr_index) $cname
	set arr_index [expr {$arr_index+1}]
}

array set LLR { A 0.7289984991999993 B -0.9451325536220769 C -0.18914682319505322 D 0.001165760652163865 E 1.1776853176085393 F -0.39812099385851984 G -0.7685055816996734 H 0.2996684304531686 I 0.6660048570967051 J -3.2615231388710226 K -2.048083916198596 L 0.026853398200253006 M -0.41048591182946964 N 0.63436836022433 O 0.688855901749051 P -0.6245022986047639 Q -3.828416454418433 R 0.48484347914977705 S 0.558280280910101 T 0.8768803994758347 U -0.30035039180610196 V -1.3507136418591092 W -0.8180520039403907 X -2.8781627571241812 Y -0.7914900768660227 Z -4.27862648811911 }

set data [string toupper [split [regsub -all {[^A-Za-z]} [read stdin] ""] ""]]

lassign $argv keylength

set cypher_index 0

#***************group cypher text by key length.**********************
for {set k 0} {$k<$keylength} {incr k} {

	set out_group ""
	set cypher_index 0
	foreach letter $data {
		set temp [expr {$cypher_index%$keylength}]
		if { $temp==$k } {
			append out_group $letter
		}
		set cypher_index [expr {$cypher_index+1}]
	}
	#puts "$out_group\n"
	
	#Caculate LLR for each key.
	set max 0
	set target ""
	for {set i 0} {$i<26} {incr i} {
		#clear output
		set output ""
		foreach letter [split $out_group ""] {
			set encrypt_index [expr {($arr_alpha($letter)-$i)%26}]

			append output $arr_encrypt($encrypt_index)
		}
		#caculate LLR for each try letter
		set sum 0.0
		foreach x [split ABCDEFGHIJKLMNOPQRSTUVWXYZ ""] {
			set count [regexp -all $x $output]
			set sum [expr $sum+$count*$LLR($x)]
		
		}

		if { $sum>$max } {
			set max [expr {$sum}]
			set target [expr {$arr_encrypt($i)}]
		}		


				
	}
	if { $max>0 } {
		puts "group $k : $target \t LLR : $max\n"
	}

}




