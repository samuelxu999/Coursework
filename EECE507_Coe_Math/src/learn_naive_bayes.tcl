#!/usr/bin/tclsh

#calculate naive bayes distribution for target sample
proc learn_naive_bayes { volcab_train volcab_target } {
	#set data [string toupper [regsub -all {[^A-Za-z]} [read stdin] ""]]
	set fp [open $volcab_train r]
	set train_data [read $fp]
	close $fp
	set fp [open $volcab_target r]
	set target_data [read $fp]
	close $fp
	
	foreach {text_v count_v sum_v} $train_data {
		set count_k 0
		foreach {text_t count_t sum_t} $target_data {
			if {$text_v==$text_t} {
				set count_k $count_t				
				break
			}
		}		
		append out "$text_v\t[expr {($count_k+1)*1.0/($sum_t+$sum_v)}]\n"		
		#puts "$text_v\t$count_k"
		#puts $text\t$count\t$sum
	}
	set out	
}

lassign $argv volcalbulary target

puts [learn_naive_bayes $volcalbulary $target]





 



