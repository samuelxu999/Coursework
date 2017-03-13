#!/usr/bin/tclsh

#calculate probability distribution for selected letter string
proc cal_prob	alpha_string {
	set data [string toupper [read stdin]]
	set total [regexp -all {[A-Z]} $data]

	foreach x [split $alpha_string ""] {
		#calculate each alphabetic letter's count
		set count [ regexp -all $x $data ]
		#calculate LLR['alpha'] for each alphabetic letter
		set Pr [ expr {$count*1.0/$total} ]
		#append to out hashtable
		lappend out $x $Pr
	}

	puts "array set Pr { [ join $out ] }"
	
}

#calculate probability distribution for all alphabetic letter string
proc cal_prob_Alphabetic infotext {
	set english [string toupper [read stdin]]
	set total [regexp -all {[A-Z]} $english]

	foreach x [split ABCDEFGHIJKLMNOPQRSTUVWXYZ ""] {
		#calculate each alphabetic letter's count
		set count [ regexp -all $x $english ]
		#calculate LLR['alpha'] for each alphabetic letter
		set Pr [ expr {$count*1.0/$total} ]
		#append to out hashtable
		lappend out $x $Pr
	}
	puts "$infotext\t"
	puts "array set Pr { [ join $out ] }"
}

#calculate conditional probability distribution for all alphabetic letter string
proc cal_condition_prob infotext {
	puts "$infotext"
	array set replace_arr {A ALLIGATOR B BUFFALO} 
	foreach x [array names replace_arr] {
		set out ""
		set data [split $replace_arr($x) ""]
		set total [regexp -all {[A-Z]} $data]
		foreach y $data {
			#calculate each alphabetic letter's count
			set count [ regexp -all $y $data ]
			#calculate Pr['alpha'] for each alphabetic letter
			set Pr [ expr {$count*1.0/$total} ]
			#append to out hashtable
			lappend out $y $Pr
		}
		puts "array set Pr_array_$x { [ join $out ] }"
	}	
}

lassign $argv type str_distribute

if { $type=="0" } {
	cal_prob_Alphabetic "Alphabetic distribution of sample files"
} 
if { $type=="1"} { 
	cal_prob $str_distribute 
}
if { $type==""} {
	cal_condition_prob "condition probability for replace A and B with ALLIGATOR BUFFALO"
}


