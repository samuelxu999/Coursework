#!/usr/bin/tclsh

#*************simple transposition cryptography:*****************
#*************reverse transposition:*****************

set plain [split ABCDEFGHIJKLMNOPQRSTUVWXYZ ""]

set cipher [lreverse $plain]

foreach x $plain y $cipher { set arr($x) $y } 

set data [string toupper [read stdin]] 

puts [string map [array get arr] $data]
