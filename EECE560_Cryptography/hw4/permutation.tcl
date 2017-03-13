#!/usr/bin/tclsh

#compose permutation-g*h
proc compose { g h } {
	foreach a $h { lappend out [lindex $g $a-1] }
	set out
	#puts $out 
}

#permutation power-g**n
proc compose_power { g power} {
	#set element permutation
	set i_length [llength $g]
	for {set i 0} {$i<$i_length} {incr i} {lappend i_list [expr $i+1]} 
	
	#power operation based on $power
	for {set k 0} {$k<$power} {incr k} {		
		set i_list [compose $i_list $g]
		#print out step for power process
		puts $i_list
	}
	set i_list
}

#compose permutation-a*b*c as a(b(c(x))) from string input "abc"
proc compose_product str_prod {
	#break "abc" into {a b c}
	set per_list [split $str_prod ""]	
	#set a as first permutation
	set a [uplevel 1 set [lindex $per_list 0]]
	#compose successive permutation b and c	
	foreach tmp [lrange $per_list 1 end] { 
	
		set a [compose $a [uplevel 1 set $tmp]]		
	}
	set a	
}


#permutation inverse-g
proc compose_inverse { g } {
	#element permutation 
	set i_length [llength $g]
	for {set i 0} {$i<$i_length} {incr i} {append i_string [expr $i+1]} 	
	set g_sorted [split $i_string ""]
	
	#set list_cycles {} 
	#inverse permutation: 
	foreach $g [split $i_string ""] { 
		#F-1(d)=i		
		foreach tmp $g_sorted { lappend output [set $tmp] }
	}
	set output	
}

#list all cycles in permutation-g
proc cycles_permutation { g } {
	set i_length [llength $g]	

	#transfer permutation to string without space, used for set list_remain  
	for {set i 0} {$i<$i_length} {incr i} {append i_string [expr $i+1]}	
	set list_remain [split $i_string ""]
	
	#clear list_search and i_search
	set list_search {}
	set i_search [llength $list_search]

	while {$i_length>$i_search} {
		#set i_start and i_next as first item of remain list
		set i_next [lindex $list_remain 0]
		set i_start [lindex $list_remain 0]
		#clear list_cycles
		set list_cycles {}		
		while {$i_length>$i_search} {			
			#add cycles item to list_cycles for print out
			lappend list_cycles $i_next
			#add visited items to list_search 
			lappend list_search $i_next
			#remove visited item from list_remain
			set list_remain [lremove $list_remain $i_next]
			#get i_next value from permutation:$g
			set i_next [lindex $g $i_next-1]
			#if i_next go back to i_start, find the cycle
			if {$i_start==$i_next} {
				#append to cycle_output for printing out			
				append cycle_output "(" $list_cycles ")"
				break
			}				
		}
		set i_search [llength $list_search]				
	}	
	set cycle_output
}

#remove item form list
proc lremove { listvar str_element } {	
	set out {}	
	foreach item $listvar {
		if {[string equal $item $str_element]} { continue }
 		lappend out $item
	}
	set out
}

#***********************Test sample for procedure***************************
lassign $argv str_permut power

set f {4 7 2 5 8 3 6 1}
set g {1 8 7 6 5 4 3 2}
set k {8 7 6 5 4 3 2 1}

puts "permutation f: {$f}"
puts "permutation g: {$g}"
puts "permutation k: {$k}"
puts "Compose gf: {[compose $g $f]}" 
puts "Compose fg: {[compose $f $g]}"

set tmp_str "ggf"
puts "Compose product of $tmp_str: {[compose_product $tmp_str]}"
puts "Compose inverse of k: {[compose_inverse $k]}"

set tmp_str "kgk"
puts "Compose product of $tmp_str: {[compose_product $tmp_str]}"
puts "Compose power $power of {$f}: {[compose_power $f $power]}"

set permut_list [split $str_permut ""]

puts "Compose power $power of {$permut_list} : {[compose_power $permut_list $power]}"

puts "List all cycles in permutation $permut_list: [cycles_permutation $permut_list]" 













