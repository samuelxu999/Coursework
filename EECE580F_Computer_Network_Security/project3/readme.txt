Task1: detect if there is some scanning activity on your network by sequentially reading all capture log files in current directory and analyzing them.

Src: All required source code,configuration and data are in ./

Function: 
By executing `./scanproject.py "*.log"` could read tcpdump log files, analyze network flows and export detect scan result as "detectreport.txt"

Report sample:
	tcpdump_scan_all.log->
		Scanned from 192.168.116.133 to 192.168.116.135, start at:21:32:55, end at:21:32:57, scanned 999 Port
		Scanned from 192.168.116.133 to 192.168.116.135, start at:21:43:47, end at:21:48:10, scanned 200 IP Protocol

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
								

								