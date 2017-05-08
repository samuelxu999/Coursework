Task1: 
	1) Detect if there is some scanning activity on your network by sequentially reading all capture log files in current directory and analyzing them.
	2) Provide two operation mode: online or offline(default)	
	3) Distinguish unique 6 scan types, they are '-sS','-sU','-sN','-sF','-sX','-sO'
Src: All required source code,configuration and data are in ./

Function: 
	1) Offline: By executing `./scanproject.py ` could read all *.log files, analyze network flows and export detect scan result as "detectreport.txt"
	2) OnlineL By executing `tcpdump –Q in –i any | ./scanproject.py --online` could read network flow records from stdin, then make online analysis, finally pop scanned activity on the screen
	There are three wasys to execute online monitor mode way:
		a) Pipeline directly from tcpdump into your program:
				`tcpdump –Q in –i any | python scanproject.py --online`
		b) Save into log file and pipeline it at the same time:
				`tcpdump –Q in –i any –w tcpdump_qwe.log`
				`tail –f tcpdump_qwe.log | python scanproject.py --online`
		This set of commands saves the output of tcpdump in the file and at the same time feeds it into your pogram in realtime.
		c) Or from previously saved file:
				`cat tcpdump_qwe.log | python scanproject.py --online`

Report sample:
	tcpdump_scan_all.log->
		nmap -sS from 192.168.116.133 to 192.168.116.135, start at:21:32:55, end at:21:32:57, scanned 999 Port
		nmap -sO from 192.168.116.133 to 192.168.116.135, start at:21:43:47, end at:21:48:10, scanned 200 IP Protocol

scan log description:

	--tcpdump_no_scan_1.txt: 	contains normal Internet browsing traffic without any scan activity
	
	--tcpdump_scan_sS.txt: 		contains "nmap -sS" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether Flags=[F], the scan number are much more, usually 999.
								
	--tcpdump_scan_F.txt: 		contains "nmap -F" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether Flags=[S], then scanned Port number should be less than "sS" option
								
	--tcpdump_scan_sF.txt: 		contains "nmap -sF" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether Flags=[F]
								
	--tcpdump_scan_sN.txt: 		contains "nmap -sN" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether Flags=[none]
								
	--tcpdump_scan_sX.txt: 		contains "nmap -sX" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether Flags=[FPU]

	--tcpdump_scan_sT.txt: 		contains "nmap -sT" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether Flags=[S]

	--tcpdump_scan_sV.txt: 		contains "nmap -sV" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether Flags=[S]

	--tcpdump_scan_sU.txt: 		contains "nmap -sU" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether "UDP" appear at the first of data section
								UDP scan is slow so that scan activity will last a long time and scan packet flows are not as smoothy as tcp scan

	--tcpdump_scan_sO.txt: 		contains "nmap -sO" scan activity related flows as well as normal Internet browsing traffic
								detect method: For thoes IP flows, check whether "ip-proto" appear at the beginning of data section.
								sO option will scan IP protocol instead of port number, thus report will record scanned IP protocol count

	--tcpdump_scan_all.txt: 	contains all above scan activity related flows as well as normal Internet browsing traffic
								it test for different scan activity messed with normal Internet browsing traffic 
								

								