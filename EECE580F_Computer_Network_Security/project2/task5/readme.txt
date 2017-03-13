Task5: Make dns2proxy print the IP address where DNS name was resolved into 

Src: All required source change in are in ./dns2proxy.py

Code Modification:
	dns2proxy.py:
		---modify datetime format in 'def save_req()':line 89 to ouput mini-second
		---add dns block handle in 'std_AAAA_qry()': line 537~550 
		---mark 'save_req()' in 'requestHandler()': line 355
		---to get resolved IP and append to record, add code in 'requestHandler()': line 374~379 
		
Function: 
1)execute dns2proxy.py and visit target website to generate "dnslog.txt" with resolved IP address 
	a)add some blocked webset to "spoof.cfg"
	b)execute dns2proxy.py and visit target website to generate "dnslog.txt"
	c)check "dnslog.txt", all blocked request will display with fake IP while unblocked ones are resolved into real IP

	
