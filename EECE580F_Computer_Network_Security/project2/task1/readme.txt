Task1: Extract dns visited data from dnslog

Src: All required source code,configuration and data are in ./

Code Modification:
	a) dns2proxy.py:
		modify datetime format in 'def save_req' of line 89 to ouput mini-second

Function: 
1)execute "dns2proxy.py" could save visited record in dnslog.txt as format:
	2016-04-15 17:31:04.031 Client IP: 127.0.0.1 request is www.google.com. IN A
	
2)execute "dnsproject.py" could read data from "dnslog.txt" and transfer to easy readible format in "dnsreport.txt"
		google.com:5 Time:2016-04-25 21:33:45.809
		google.com
		www.google.com
		ssl.gstatic.com
		www.gstatic.com
		apis.google.com