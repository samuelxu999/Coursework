Task3: Block selected DNS request by returning fake IP 

Src: All required source code are in ./dns2proxy.py

Code Modification:
	dns2proxy.py:
		---modify datetime format in 'def save_req()':line 89 to ouput mini-second
		---add dns block handle in 'std_AAAA_qry()': line 537~550
		---mark "std_A_qry()" to disable output blocked site in 'std_A_qry()': line 640 
		---modify export logfile logic which will not print blocked record, in 'requestHandler()': line 355~357
		

Function: 
1)Configure blocked webset by adding @dnsname @fake IP to "spoof.cfg" file
	current, we define two filter profile:"spoof_amazon.cfg" and "spoof_cnn.cfg" for test.
2)Test block function 
	a)add filter profile:"spoof_amazon.cfg" and "spoof_cnn.cfg" to "spoof.cfg"
	b)execute dns2proxy.py and visit target website to generate "dnslog.txt"
	3)check "dnslog_block.txt", all blocked request will not be saved in log

3)Test unblock function 
	a)clear "spoof.cfg" or remove some blocked items
	b)execute dns2proxy.py and visit target website to generate "dnslog.txt"
	3)check "dnslog_unblock.txt", all unblocked request will be saved in log
	
