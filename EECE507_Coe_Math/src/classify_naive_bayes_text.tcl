#!/usr/bin/tclsh

#calculate naive bayes ML(most likelihood) for test sample based on target training distribution
proc classify_naive_bayes_text { target_prob target_sample } {	
	set fp [open $target_prob r]
	set prob_data [string toupper [read $fp]]
	close $fp
	set fp [open $target_sample r]
	set sample_data [string toupper [regsub -all {[^a-z]} [read $fp] " "]]
	#set sample_data [read $fp]
	close $fp
	#puts $sample_data
	set ML 0 
	foreach text_s $sample_data {		
		foreach { text_t prob_t } $prob_data {
			if {$text_s==$text_t} {
				#set ML [expr {$ML*$prob_t*1.0}]
				set ML [expr {$ML+log($prob_t)}]
				#puts "$text_s\t$$prob_t\t$ML"			
				break
			}
		}				
	}
	#set Ph 0.9
	#set ML [expr {$ML+ $Ph}] 
	set out	[expr $ML]
}

lassign $argv volcalbulary target

puts [classify_naive_bayes_text $volcalbulary $target]





 



