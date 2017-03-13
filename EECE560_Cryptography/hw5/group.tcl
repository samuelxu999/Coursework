#!/usr/bin/tclsh

#calculate group (a*b) mod 13
proc group_a*b { ls_count } {
	puts "      calculate group (a*b) mod 13:"
	set title [format %3s "a\\b"]
	append title "|"
	set i 0	
	while {$i<$ls_count} {
		set i [expr $i+1]
		append title [format %3s $i]		
	}
	puts $title
	puts [string repeat "-" [string length $title]]
	set i 0
	while {$i<$ls_count} {
		set out ""
		set i [expr $i+1]
		append out [format %3s $i]
		append out "|"
		set k 0
		while {$k<$ls_count} {
			set k [expr $k+1]
			append out [format %3s [expr {($i*$k)%13}]]			
		}
		puts $out				
	}	
	#set out
	 
}

proc g_a**power { ls_count } {
	puts "      calculate group (a**power) mod 13:"
	set title [format %8s "a\\power"]
	append title "|"
	
	set i 0	
	while {$i<$ls_count} {
		set i [expr $i+1]
		#print power list
		#append title [format %8s [expr int(pow($power, $i))]]	
		#append title [format %3s [expr $i%13]]	
		append title [format %3s $i]
	}
	puts $title
	puts [string repeat "-" [string length $title]]
	set i 0	
	while {$i<$ls_count} { 
		set out ""
		set i [expr $i+1]
		#print a list
		append out [format %8s $i]
		append out "|"
		set k 0
		while {$k<$ls_count} {
			set k [expr $k+1]
			append out [format %3s [expr {int(pow($i, $k))%13}]]			
		}
		puts $out			 
	}
	#set out
	 
}

proc g_a**power_mod { power mod } {
	puts "calculate  (a**$power) mod $mod:"	
	for {set i 1} {$i<=$mod} {incr i} { 
		append out [format %2s $i ] " ---->" [format %3s [expr {($i**$power)%$mod}]] "\n"
	}
	puts $out
}

proc g_a*x+b { a b mod } {
	puts "calculate  ($a*x+$b) mod $mod:"	
	for {set i 0} {$i<$mod} {incr i} { 
		append out [format %2s $i ] " ---->" [format %3s [expr {($a*$i+$b)%$mod}]] "\n"
	}
	puts $out
	 
}

proc group_a*b+a+b { mod } {
	puts "      calculate group (a*b+a+b) mod $mod:"
	set title [format %3s "a\\b"]
	append title "|"	
	set i 0	
	while {$i<$mod} {		
		append title [format %3s $i]	
		set i [expr $i+1]
	}
	puts $title
	puts [string repeat "-" [string length $title]]
	set i 0
	while {$i<$mod} {
		set out ""		
		append out [format %3s $i]
		append out "|"
		set k 0
		while {$k<$mod} {			
			append out [format %3s [expr {($i*$k+$i+$k)%$mod}]]
			set k [expr $k+1]
		}
		set i [expr $i+1]
		puts $out				
	}	
	#set out
	 
}

proc group_a*x+b { a b mod } {
	puts "      calculate group ($a*x+$b) mod $mod:"
	set title [format %3s "x\\y"]
	append title "|"	
	set i 0	
	while {$i<$mod} {		
		append title [format %3s $i]	
		set i [expr $i+1]
	}
	puts $title
	puts [string repeat "-" [string length $title]]
	set i 0
	while {$i<$mod} {
		set out ""		
		append out [format %3s $i]
		append out "|"
		set tmp [expr {($i*$a+$b)%$mod}]
		set k 0
		while {$k<$mod} {						
			append out [format %3s [expr {($tmp*$k+$b)%$mod}]]
			set k [expr $k+1]
		}
		set i [expr $i+1]
		puts $out				
	}	
	#set out
	 
}


#***********************Test sample for procedure***************************
lassign $argv mod a b


set tmp_mod 13
group_a*b $tmp_mod
puts "-----------------------------------------------------------------------"
g_a**power $tmp_mod 
puts "-----------------------------------------------------------------------"
g_a**power_mod $a $mod
puts "-----------------------------------------------------------------------"
group_a*b+a+b  $mod

puts "-----------------------------------------------------------------------"
g_a*x+b $a $b $mod
#group_a*x+b $a $b $mod




