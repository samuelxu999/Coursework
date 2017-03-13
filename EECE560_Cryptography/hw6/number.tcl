#!/usr/bin/tclsh

#calculate gcd(a, b)
proc gcd_ab { a b } {
	
	set i $a
	set k $b
	set r 0
	set tmp 0
	#puts "$i\t $k\t $r\n"
	while {$k>0} {
		#set i [expr $i+1]
		#append title [format %3s $i]
		set out ""
		append out "$i="
		set r [expr $i%$k]
		set q [expr $i/$k]
		set i $k
		set k $r
		append out "$q*$i+$r"
		puts $out
		if {$k==0} {
			puts "gcb($a,$b)=$i"			
		}
	}
	 
}

proc lcm_ab { a b } {
	
	set i $a
	set k $b
	set r 0
	set tmp 0
	#puts "$i\t $k\t $r\n"
	while {$k>0} {
		#set i [expr $i+1]
		#append title [format %3s $i]
		set out ""
		append out "$i="
		set r [expr $i%$k]
		set q [expr $i/$k]
		set i $k
		set k $r
		append out "$q*$i+$r"
		puts $out
		if {$k==0} {
			set lcm [expr $a*$b/$i]
			puts "lcm($a,$b)=$lcm"			
		}
	}
	 
}

#calculate gcd(a, b) using extend algrithm
proc gcd_ab_ext { a b } {
	
	set i $a
	set k $b
	#r=a-qb
	set r 0
	set q 0
	set tmp_x 0
	set tmp_y 0
	#x1*a+y1*b=i(original: i is a, x1 is 1, y1 is 0)
	set x1 1
	set y1 0
	#x2*a+y2*b=k(original: k is b, x2 is 0, y2 is 1)	
	set x2 0
	set y2 1
	#puts "$i\t $k\t $r\n"
	while {$k>0} {
		#set i [expr $i+1]
		#append title [format %3s $i]
		set out ""
		append out "$i="
		set r [expr $i%$k]
		set q [expr $i/$k]
		set i $k
		set k $r
		set tmp_x $x2
		set tmp_y $y2
		#x1<--x=x1-x2*q, y1<--y1-y2*q
		set x2 [expr $x1-$x2*$q]
		set y2 [expr $y1-$y2*$q]
		#x2<--x1, y2<--y1
		set x1 $tmp_x
		set y1 $tmp_y
		append out "$q*$i+$r"
		puts $out
		if {$k==0} {
			puts "gcb($a,$b)=$i, ($x1)*($a)+($y1)*($b)=$i"			
		}
	}
	 
}


#***********************Test sample for procedure***************************
lassign $argv a b


#puts "-----------------------------------------------------------------------"
#gcd_ab $a $b
#puts "-----------------------------------------------------------------------"
#lcm_ab $a $b
puts "-----------------------------------------------------------------------"
gcd_ab_ext $a $b





