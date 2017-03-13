#!/usr/bin/tclsh

#Logarithm to any base
proc log {base x} {
    expr {log($x)/log($base)}
} 

#Logarithm to base 2
proc log2 x {
	expr {log($x)/log(2)}
}


proc cal_entropy  infotext {
	array set Pr { A 0.0797309020421182 B 0.01494723282428045 C 0.03183326835988 D 0.038506401554432086 E 0.12487884890667399 F 0.025830029446071778 G 0.01783482772276007 H 0.05190043498828167 I 0.07486328609532145 J 0.00147422967935986 K 0.004960838727670833 L 0.03950835383977701 M 0.02551260972937658 N 0.07253194613726399 O 0.07659368581303362 P 0.02059722673783443 Q 0.0008363085011471795 R 0.06245849274942487 S 0.06721786240933891 T 0.09243809159870135 U 0.028483026519955067 V 0.009963666228545278 W 0.01697270960872627 X 0.002162999647140218 Y 0.017429578278629794 Z 0.0005331418542550421 }

	#set data [string toupper [read stdin]]
	set sum_L 0.0
	set sum_N 0.0

	foreach x [split ABCDEFGHIJKLMNOPQRSTUVWXYZ ""] {
		#set count [regexp -all $x $data]		
		set sum_L [expr $sum_L+$Pr($x)*[log2 [expr 1.0/$Pr($x)] ] ]		
		set sum_N [expr $sum_N+(1.0/26.0)*[log2 26.0] ]
	
	}

	puts "$infotext is: H(L):$sum_L\tH(N):$sum_N"
} 

proc cal_entropy_1  infotext {
	#A-1, B-1
	array set Pr_var { A 0.5 B 0.5 }
	set sum 0
	foreach x [array names Pr_var] {
		#puts "Pr_var($x) is $Pr_var($x)"
		set sum [expr $sum+$Pr_var($x)*[log2 [expr 1.0/$Pr_var($x)] ] ]
	}	
	
	puts "$infotext is: $sum"
}

proc cal_entropy_2  infotext {
	#A-3, B-1
	set data [split AAAB ""]
	set total [regexp -all {[A-Z]} $data]

	foreach x [split AB ""] {
		#calculate each alphabetic letter's count
		set count [ regexp -all $x $data ]
		#calculate Pr['alpha'] for each alphabetic letter
		set Pr [ expr {$count*1.0/$total} ]
		#append to out hashtable
		lappend out $x $Pr
	}

	#puts "array set Pr { [ join $out ] }"
	array set Pr_var { A 0.75 B 0.25 }
	set sum 0
	foreach x [array names Pr_var] {
		#puts "Pr_var($x) is $Pr_var($x)"
		set sum [expr $sum+$Pr_var($x)*[log2 [expr 1.0/$Pr_var($x)] ] ]
	}	
	
	puts "$infotext is: $sum"
}

proc cal_entropy_3_general  infotext {
	
	#A-3, L-3, I-1, G-1, T-1, O-2, R-1, B-1, U-1, F-2  
	set data [split ALLIGATORBUFFALO ""]
	set total [regexp -all {[A-Z]} $data]

	foreach x [split ALIGTORBUF ""] {
		#calculate each alphabetic letter's count
		set count [ regexp -all $x $data ]
		#calculate Pr['alpha'] for each alphabetic letter
		set Pr [ expr {$count*1.0/$total} ]
		#append to out hashtable
		lappend out $x $Pr
	}

	#puts "array set Pr { [ join $out ] }"
	array set Pr_var { A 0.1875 L 0.1875 I 0.0625 G 0.0625 T 0.0625 O 0.125 R 0.0625 B 0.0625 U 0.0625 F 0.125 }
	set sum 0
	foreach x [array names Pr_var] {
		#puts "Pr_var($x) is $Pr_var($x)"
		set sum [expr $sum+$Pr_var($x)*[log2 [expr 1.0/$Pr_var($x)] ] ]
	}	
	
	puts "$infotext is: $sum"
}

proc cal_entropy_3_condition  infotext {	
	#A-3, L-3, I-1, G-1, T-1, O-2, R-1, B-1, U-1, F-2 
	set sum 0
	array set Pr_array_A { A 0.2222222222222222 L 0.2222222222222222 L 0.2222222222222222 I 0.1111111111111111 G 0.1111111111111111 A 0.2222222222222222 T 0.1111111111111111 O 0.1111111111111111 R 0.1111111111111111 }
	array set Pr_array_B { B 0.14285714285714285 U 0.14285714285714285 F 0.2857142857142857 F 0.2857142857142857 A 0.14285714285714285 L 0.14285714285714285 O 0.14285714285714285 }
	
	foreach t [array names Pr_array_A] {		
		set sum [expr $sum+($Pr_array_A($t)/2)*[log2 [expr 1.0/($Pr_array_A($t)*2)] ] ]
	}
	foreach t [array names Pr_array_B] {		
		set sum [expr $sum+($Pr_array_B($t)/2)*[log2 [expr 1.0/($Pr_array_B($t)*2)] ] ]
	}
	
	puts "$infotext is: $sum"
}

cal_entropy "entropy for distributed leters"
cal_entropy_1 "entropy for equal AB"
cal_entropy_2 "entropy for distribute AAAB"
cal_entropy_3_general "entropy for letters after equal replaced A-ALLIGATO B-RBUFFALO"
cal_entropy_3_condition  "entropy for conditional A-ALLIGATO B-RBUFFALO"

#set base 2
#set val 3
#puts "[log $base $val ]"
#puts "[log2 $val]"


