#!/usr/bin/tclsh

# see enigmaI.tcl for instructions

################################################################################
#  Example permutations
#
set I {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25}
set L {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 0}
set R {25 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24}
set S {1 0 3 2 5 4 7 6 9 8 11 10 13 12 15 14 17 16 19 18 21 20 23 22 25 24}

set A {9 19 10 17 18 24 14 4 7 0 16 6 11 5 2 15 25 3 13 8 1 22 12 23 20 21}
set B {17 11 13 1 25 4 16 21 2 5 6 8 9 10 23 18 14 3 22 24 19 0 7 12 20 15}
set C {3 18 6 17 9 15 12 4 20 25 2 22 10 24 5 21 8 7 0 1 13 19 11 14 16 23}

set P {0 1 2 6 4 5 3 7 8 9 10 11 12 13 14 15 17 16 18 19 20 21 22 23 24 25}

################################################################################
#  Code to manipulate permutations
#
proc inverse {perm} { 
	foreach i $::I { lappend out [lsearch $perm $i] } 
	set out
}
proc compose {pone ptwo} {
	foreach i $ptwo { lappend out [lindex $pone $i] } 
	set out
}
proc element string {
	set out $::I
	while {[regexp {(.*)o(.*)} $string -> string last]} {
		set out [compose [set ::$last] $out]
	}
	compose [set ::$string] $out
}

foreach a {I L R A B C P} {set -$a [inverse [set $a]]}

set 0R $I; set -0R $I; set last $I
for {set i 1} {$i<26} {incr i} {
	set ${i}R [compose $R $last]
	set last [set ${i}R]
	set -${i}R [inverse $last]
}

# try figuring out the order of A, B and C by inspecting them for cycles.

################################################################################
#  Code to draw permutations
#
proc toy i { expr $i*20+10 }
proc coord {i j} { list 0 [toy $i] 5 [toy $i] 75 [toy $j] 80 [toy $j] }
set box { 5 5 75 5 75 515 5 515 5 5 }

proc permbox {name perm color} {
	canvas .$name -height 520 -width 80 -background $color -highlightthickness 0
	foreach i $::I {
		.$name create line [coord $i [lindex $perm $i]] -width 1 -tag L$i
	}
	.$name create line $::box -width 2
	return .$name
}

proc alphabetbox name {
	canvas .$name -height 520 -width 20  
	foreach i $::I {
		.$name create text 10 [toy $i] -text [format %c [expr 65+$i]]
	}
	pack .$name -side left -anchor nw
}

proc highlight {name id color} { .$name itemconfigure L$id -fill $color -width 3 }
proc lowlight name { 
	foreach a $::I {
		.$name itemconfigure L$a -fill black -width 1
	}
}

set block 0

proc add {elt {color white}} {
	set perm [element $elt]
	pack [permbox b[incr ::block] $perm $color] -side left -anchor nw
	set ::perms($::block) $perm
}

proc highlightall n {
	for {set i 1} {$i<=$::block} {incr i} {
		lowlight b$i; 	highlight b$i $n red
		set n [lindex $::perms($i) $n]
	}
	format %c [expr $n+65]
}

package require Tk

proc permredraw {name perm} {
	foreach i $::I { 
		.$name delete L$i 
		.$name create line [coord $i [lindex $perm $i]] -width 1 -tag L$i
	}
}

proc rotate idx {
	set ::X $::perms($idx)
	set ::perms($idx) [element -RoXoR]
	permredraw b$idx $::perms($idx)
}

# add A; add B; add C
alphabetbox foo
add P; 
add A yellow; 
add B aquamarine; 
add C azure; 
add S; 
add -C beige; 
add -B pink; 
add -A yellow; 
add -P
alphabetbox bar
set count 0
proc step {} {
	incr ::count
	rotate 4; rotate 6
	if {($::count%26)==0} {rotate 3; rotate 7}
	if {($::count%676)==0} {rotate 2; rotate 8}
}

set message ""
bind . <Key> {
        set letter %A
        if {%N>=96 && %N<=122} {
                step
                set letter [highlightall [expr %N-97]]
        } elseif {%N>=65 && %N<=90} {
                set letter ""
                highlightall [expr %N-65]
        }
        puts [append ::message $letter]
}

bind . <Return> {
        step
}
