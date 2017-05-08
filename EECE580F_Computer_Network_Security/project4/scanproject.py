#!/usr/bin/python

'''
Created on April 9, 2017

@author: Xu Ronghua
@Email:  rxu22@binghamton.edu
@TaskDescription: 
1) Extract network monitor data in tcpdump_*.txt.
2) Analyze network flows to Detect if there is some scanning activity on your network
3) Detect scanning data in real time by using "--online" options
'''
import sys
import re
import datetime
import glob, os

'''
Function:read line contents from tcpdump file
@arguments: 
(input)  filepath:   	input file path
(out)    ls_lines:   	return line list object
'''
def ReadLines(filepath):
	#define file handle to open select file
	fname = open(filepath, 'r')    
	#read text by line and saved as array list ls_lines
	ls_lines=fname.readlines()
	#close file
	fname.close()
	return ls_lines
    
'''
Function: split line string and saved record as array list.
@arguments: 
(in)    ls_line:   		input line list to parse need information
(out)   ls_info:   		return split line data
'''
def Parselines(ls_line):
	#Define ls_info[] to save split data	
	ls_info=[]
	
	# 1.split each line racord into ls_info[]
	for tmp_line in ls_line:
		#remove redundent strings		
		tmp_line=tmp_line.replace("\n" , "")			
		#remove empty line
		if(len(tmp_line.split())!=0):
			ls_data=[]
			#ARP flow format
			if ("ARP" in tmp_line):
				ls_info.append(tmp_line.split(','))
				continue
			#IP flow format
			if (("IP" in tmp_line) and ("IP6" not in tmp_line) and (">" in tmp_line)):
				ls_info.append(tmp_line.split('>'))
				continue
	
	# 2.classify record based on type: ARP or IP
	ls_record=[]
	for tmp_record in ls_info:
		ls_data=[]
		
		#-----------------------------ARP--------------------------
		if ("ARP" in tmp_record[0]):
			#print(ARP_Parse(tmp_record))
			ls_record.append(ARP_Parse(tmp_record))
			continue
		#-----------------------------IP----------------------------
		if ("IP" in tmp_record[0]):
			#print(tmp_record)
			#print(IP_Parse(tmp_record))
			#break
			ls_record.append(IP_Parse(tmp_record))
			continue
	
	return ls_record

'''
Function: extract data from ARP record.
@arguments: 
(in)    ls_record:   	input ARP record list to parse need information
(out)   ls_data:   		return parse data list
'''
def ARP_Parse(ls_record):
	#data array list to save result	 
	ls_data=[]
	
	tmp_data=ls_record[0].split()	
	#-----------------Time-----------------
	ls_data.append(tmp_data[0])
	#-----------------Type-----------------
	ls_data.append(tmp_data[1])
	
	tmp_data=ls_record[1].split()
	#---------------Activity---------------
	#Activity: Request or Reply
	ls_data.append(tmp_data[0])
	#Request handler
	if("Request"==tmp_data[0]):
		#who-has IP
		ls_data.append(tmp_data[2])
		#tell
		if("tell"==tmp_data[3]):
			ls_data.append(tmp_data[4])
		else:
			ls_data.append(tmp_data[5])
	#Reply handler
	if("Reply"==tmp_data[0]):
		#reply IP
		ls_data.append(tmp_data[1])
		#is-at MAC
		ls_data.append(tmp_data[3])
			
	tmp_data=ls_record[2].split()
	#-----------------Data------------------
	#data section:length
	#arp_data={}
	#arp_data[tmp_data[0]]=tmp_data[1]
	#ls_data.append(arp_data)
	i=0
	str_data=""
	while(i<len(tmp_data)):
		str_data=str_data+tmp_data[i]+" "
		i+=1
	ls_data.append(str_data[:-1])
	
	return ls_data
 
'''
Function: extract data from IP record.
@arguments: 
(in)    ls_record:   	input IP record list to parse need information
(out)   ls_data:   		return parse data list
'''
def IP_Parse(ls_record):
	#data array list to save result	 
	ls_data=[]
		
	tmp_data=ls_record[0].split()	
	#-----------------Time-----------------
	ls_data.append(tmp_data[0])
	#-----------------Type-----------------
	ls_data.append(tmp_data[1])

	#------------ source IP----------------
	tmp=tmp_data[2].split(".")
	src_IP=tmp[0]+"."+tmp[1]+"."+tmp[2]+"."+tmp[3]
	ls_data.append(src_IP)
	#------------source Port----------------
	if(len(tmp)>4):
		src_Port=tmp[4]
	else:
		src_Port=""
	ls_data.append(src_Port)
	
	tmp_data=ls_record[1].split(":")
	#------------ destination IP----------------
	tmp=tmp_data[0].split(".")
	des_IP=tmp[0]+"."+tmp[1]+"."+tmp[2]+"."+tmp[3]
	ls_data.append(des_IP[1:])
	#------------destination Port----------------
	if(len(tmp)>4):
		des_Port=tmp[4]
	else:
		des_Port=""
	ls_data.append(des_Port)
	
	tmp_data=ls_record[1].split()
	#-------------------Data---------------------
	i=1
	str_data=""
	while(i<len(tmp_data)):
		str_data=str_data+tmp_data[i]+" "
		i+=1
	ls_data.append(str_data[:-1])
	
	return ls_data
	
'''
Function: extract data based on array list from Parselines()
@arguments: 
(in)    ls_info:   		input line list to parse need information
(out)   ls_result:   	return extracted data list
'''
def HandleInfo(ls_info, ls_netflows):   	
	ls_flows=ls_netflows	
	pretime=0;
	
	#for each flow record in ls_info
	for tmp_record in ls_info:
		#=================================pre-operation to filter unconcerning record==========================
		#only analyze IP flow
		if("IP"!=tmp_record[1]):
			continue
		
		#remove flows whose port is in following filter
		if(("netbios-ns"==tmp_record[3]) or ("domain"==tmp_record[3]) or ("bootpc"==tmp_record[3]) or
			("netbios-ns"==tmp_record[5]) or ("domain"==tmp_record[5]) or("bootpc"==tmp_record[5]) ):
			continue
		
		#check if 'ICMP' appear at the first of data section, then remove ICMP flow
		if("ICMP" in tmp_record[6].split(",")[0]):
			continue	
		
		'''
		IP protocol:check if 'ip-proto' appear at the first of data section. if yes, go ahead to analyze
		UDP:check if 'UDP' appear at the first of data section. if yes, go ahead to analyze
		TCP:check if 'Flags [@]' appear at the first of data section. if yes, go ahead to analyze
			[S]-sS, [F]-sF, [none]-sN, [FPU]-sX
		'''
		if("Flags [S]"!=tmp_record[6].split(",")[0] and 
		"Flags [F]"!=tmp_record[6].split(",")[0] and 
		"Flags [none]"!=tmp_record[6].split(",")[0] and 
		"Flags [FPU]"!=tmp_record[6].split(",")[0] and 
		"UDP"!=tmp_record[6].split(",")[0] and 
		"ip-proto"!=tmp_record[6][0:8]):
			continue
		
		#==================================analyze network flow data=============================================
		#get current request record time 
		#flowtime = tmp_record[0][:-7]
		currtime = datetime.datetime.strptime(tmp_record[0][:-7], "%H:%M:%S")
		flowpath=tmp_record[2]+">"+tmp_record[4]
		if("ip-proto"==tmp_record[6].split()[0][0:8]):
			scantype="IP Protocol"
			#Add scaned IP ptotocol number
			scanport=tmp_record[6].split()[0][9:]
		else:
			scantype="Port"
			#Add scaned port number
			scanport=tmp_record[5]
		
		#clear list
		ls_flowdata=[]
		ls_scanport=[]
		
		isflowexist=0
		#-------------------1)if ls_flows[] is not empty---------------------
		for tmp_flow in ls_flows:			
			#check whether a exist scan flow
			if(flowpath in tmp_flow):
				#get exist flow data to check scan port status
				ls_flowdata=tmp_flow
				
				#get previous scan time to compare with 'currtime'
				pretime=datetime.datetime.strptime(ls_flowdata[3], "%H:%M:%S")
				diff=("%f\n" %((currtime-pretime).total_seconds()))
				
				#if diff between current time and previous time is large than threshold, it could be new scan activity
				if(float(diff) <= 5.0):					
					#set flow exist flag for skiping 2) operation
					isflowexist=1
					break
		
		#if scan flow is existed
		if(isflowexist==1):
			#get scan port data from ls_flowdata
			ls_scanport=ls_flowdata[2]
	
			#check current scan port whether is existed in ls_scanport[]
			if(scanport not in ls_scanport):
				#add new scan port to flow record
				ls_scanport.append(scanport)
			#update scan time history
			ls_flowdata[3]=tmp_record[0][:-7]
			#skip the condition 2)
			continue
		
		#------2)if ls_flows[] is empty, or new flow record appear--------------
		ls_flowdata=[]
		#Add scan activity start time
		ls_flowdata.append(tmp_record[0][:-7])
		#Add scan path: src->des
		ls_flowdata.append(flowpath)
		#Add scan port: des port number-scan count
		ls_scanport.append(scanport)
		ls_flowdata.append(ls_scanport)	
		#Add current scan time
		ls_flowdata.append(tmp_record[0][:-7])
		#Add scan type
		ls_flowdata.append(scantype)
		#add scan type flage
		ls_flowdata.append(tmp_record[6].split(",")[0])
		
		#add scan record to ls_flows[] list
		ls_flows.append(ls_flowdata)
	
	#return statistics result
	return ls_flows;

'''
Function: detect whether scan activity happed based on analyzing ls_flows[] from HandleInfo()
@arguments: 
(in)    ls_netflows:   	input flow data which has been extracted from log files
(out)   ls_scanflows:   	return scan activity flow
'''
def ScanDetect(ls_netflows):   	
	ls_scanflows=[]
	#for each flow record in ls_info
	for tmp_record in ls_netflows:
		#check whether scaned port count is beyong normal network activity
		ls_scanport=tmp_record[2]
		ls_scandata=[]
		#check scaned port number threshold
		if(len(ls_scanport)>8):
			#add scan activity time
			ls_scandata.append(tmp_record[0])
			#add scan path scr->des
			ls_scandata.append(tmp_record[1])
			#add last scan time
			ls_scandata.append(tmp_record[3])
			#add scaned port number
			ls_scandata.append(len(ls_scanport))
			#add scaned port type
			ls_scandata.append(tmp_record[4])
			#add scan type flage
			ls_scandata.append(tmp_record[5])
			
			#=====add ls_scandata to ls_scanflows[]=====
			ls_scanflows.append(ls_scandata)
	return ls_scanflows

	
'''
Function: Save ls_record[] data as report:filename unter current directory
@arguments: 
(in)    ls_record:   	read ls_record[] to parse need information
(in)    filename:   	set report file name
'''
def ExportData(ls_record,filename): 
	tmp_file = open(filename, "w") 
	for tmp_record in ls_record:
		tmp_file.write("%s\n" %(tmp_record))
	tmp_file.close() 

'''
Function: identify namp option based on flag in data section
@arguments: 
(in)    flag_data:   	data section field in scan data list
'''
def getNmapOp(flag_data):
	op_namp=""
	if(flag_data=="Flags [S]"):
		op_namp="-sS"
	if(flag_data=="Flags [F]"):
		op_namp="-sF"
	if(flag_data=="Flags [S.]"):
		op_namp="-sF"
	if(flag_data=="Flags [none]"):
		op_namp="-sN"
	if(flag_data=="Flags [FPU]"):
		op_namp="-sX"
	if(flag_data=="UDP"):
		op_namp="-sU"
	if(flag_data[0:8]=="ip-proto"):
		op_namp="-sO"
	return op_namp
	
'''
Function: Display detect result on screen or export as report log unter current directory
@arguments: 
(in)    ls_record:   	read ls_record[] to parse need information
(in)    filename:   	set report file name
'''
def ExportResult(ls_record,filename): 
	tmp_file = open(filename, "w") 
	for ls_logdata in ls_record:
		#tmp_file.write("%s\n" %(ls_data))
		print("%s->" %(ls_logdata[0]))	
		tmp_file.write("%s->\n" %(ls_logdata[0]))
		for ls_scan in ls_logdata[1]:
			op_namp=getNmapOp(ls_scan[5])
			print("\tnmap %s from %s to %s, start at:%s, end at:%s, scanned %s %s" 
			%(op_namp,ls_scan[1].split('>')[0],ls_scan[1].split('>')[1],ls_scan[0],ls_scan[2],ls_scan[3],ls_scan[4]))
			tmp_file.write("\tnmap %s from %s to %s, start at:%s, end at:%s, scanned %s %s\n" 
			%(op_namp,ls_scan[1].split('>')[0],ls_scan[1].split('>')[1],ls_scan[0],ls_scan[2],ls_scan[3],ls_scan[4]))
		#print("")
		tmp_file.write("\n")
	tmp_file.close() 

'''
Function: list all tcpdump*.log files in current directory
@arguments: 
(in)    reg_str:   	input regex string to filter files
(out)   ls_logs:   	return scanlog files
'''
def list_scanlog(reg_str):
	#set current path as default directory
	os.chdir("./")
	#reg_str="tcpdump*"
	ls_logs=[]
	for file in glob.glob(reg_str):
		ls_logs.append(file)
		#print(file)
	return ls_logs

'''
Function: print online detect result to screen
@arguments: 
(in)    ls_scan:   	input detect scan list for printing 
(in)   	op_mode:   	operation mode to handle last scan data while inputing through log files
'''
def printOnlineResult(ls_scan,op_mode):
	#print(ls_scan[0])
	op_namp=""
	op_namp=getNmapOp(ls_scan[0][5])
	#print(ls_scan)"ip-proto"
	if(1!=op_mode):	
		while(len(ls_scan)>1):
			print("nmap %s from %s to %s, start at:%s, end at:%s, scanned %s %s" 
				%(op_namp,ls_scan[0][1].split('>')[0],ls_scan[0][1].split('>')[1],ls_scan[0][0],ls_scan[0][2],ls_scan[0][3],ls_scan[0][4]))
			del ls_scan[0]
	else:
		print("nmap %s from %s to %s, start at:%s, end at:%s, scanned %s %s" 
				%(op_namp,ls_scan[0][1].split('>')[0],ls_scan[0][1].split('>')[1],ls_scan[0][0],ls_scan[0][2],ls_scan[0][3],ls_scan[0][4]))
		del ls_scan[0]
	#for tmp_record in ls_record:
		
'''
Function: Working on offline detect mode(default mode)
'''
def offline_handle():
	regex_str="*.log"
	#reportname="networkreport.txt"
	#portscan="portscanreport.txt"
	detectname="detectreport.txt"
	
	ls_scandetect=[]
	#get all scan logs under current directory
	ls_scanlog=[]
	ls_scanlog=list_scanlog(regex_str)

    #========================== analyze flowdata by for each log =================================
	for logname in ls_scanlog:		
		tmp_scandata=[]
		#read log file and save data as arraylist ls_line
		ls_line=ReadLines(logname)
		print("Extract network flow from '%s'." %(logname))	
		#handle line list data and save result as ls_scanflows	
		ls_info=Parselines(ls_line)
		
		ls_netflows=[]
		ls_netflows=HandleInfo(ls_info,ls_netflows)
		
		ls_scanflows=ScanDetect(ls_netflows)
		#add logname and ls_scanflows[] to tmp_scandata
		tmp_scandata.append(logname)
		tmp_scandata.append(ls_scanflows)
		ls_scandetect.append(tmp_scandata)
		
	#========================== report detect result =================================
	print("Export network scan detect data to '%s'." %(detectname))
	ExportResult(ls_scandetect,detectname)
	
	#===========Export data and saved as report===========
	#ExportData(ls_netflows,portscan)

'''
Function: Working on online detect mode(need option: --online)
'''
def online_handle():
	netflows_buf=[]
	ls_scandetect=[]
	for line in sys.stdin:
		#print(line)
		# A) read line from stdin and save data as arraylist ls_line
		ls_line=[]
		ls_line.append(line)
		# B) parse line to filter as formated ls_info
		ls_info=Parselines(ls_line)
		#remove empty record
		if(len(ls_info)==0):
			continue		
		#get current packet time
		curr_time=datetime.datetime.strptime(ls_info[0][0][:-7], "%H:%M:%S")
		
		# C) time out strategy for detect record, timeout will be set 60s
		if(len(ls_scandetect)==1):
			scan_time=datetime.datetime.strptime(ls_scandetect[0][2], "%H:%M:%S")
			diff_record=("%f\n" %((curr_time-scan_time).total_seconds()))
			if(float(diff_record)>=60.0):
				#Before printout scan record, clear related temp record in netflows_buf
				for tmp_buf in netflows_buf:
					if(ls_scandetect[0][0]==tmp_buf[0]):
						#remove temperary record in netflows_buf
						netflows_buf.remove(tmp_buf)
						break
				# Print out timeout record
				printOnlineResult(ls_scandetect,1)
		
		# D) extract data from ls_info and saved as netflows_buf
		netflows_buf=HandleInfo(ls_info,netflows_buf)
				
		#**************************detect scaned activity*************************
		if(len(netflows_buf)==0):
			continue
		#Check whether detect time span is available
		#get last scanned time for first of record of netflows_buf
		time_head=datetime.datetime.strptime(netflows_buf[0][3], "%H:%M:%S")
		if(len(netflows_buf)>=2):
			#get last scanned time for first of record of netflows_buf
			time_end=datetime.datetime.strptime(netflows_buf[len(netflows_buf)-1][0], "%H:%M:%S")
			diff_record=("%f\n" %((time_end-time_head).total_seconds()))
		else:
			diff_record=("%f\n" %((curr_time-time_head).total_seconds()))
		
		#Here, we set detect frequency
		if(float(diff_record)>=10.0):			
			ls_scanflows=ScanDetect(netflows_buf)
			if(len(ls_scanflows)==0):
				continue
			
			#add to ls_scandetect buffer for print out
			for tmp_scan in ls_scanflows:				
				#1) no scan data, direct add scanflows to ls_scandetect
				if(len(ls_scandetect)==0):
					ls_scandetect.append(tmp_scan)
					continue
				
				#2) exist scan data, check whether current flow scr->des is the same as last flow in ls_scandetect
				if(ls_scandetect[len(ls_scandetect)-1][1]!=tmp_scan[1]):
					ls_scandetect.append(tmp_scan)
					continue
				#2) exist scan data, check time diff between current flow and last flow in ls_scandetect
				pre_time=datetime.datetime.strptime(ls_scandetect[len(ls_scandetect)-1][2], "%H:%M:%S")
				cur_time=datetime.datetime.strptime(tmp_scan[0], "%H:%M:%S")
				diff=("%f\n" %((cur_time-pre_time).total_seconds()))
				# If time diff is within threshold, just update "last time" and "scaned port number" filed
				if(float(diff)<=10.0):
					ls_scandetect[len(ls_scandetect)-1][2]=tmp_scan[0]
					ls_scandetect[len(ls_scandetect)-1][3]=ls_scandetect[len(ls_scandetect)-1][3]+tmp_scan[3]
					continue
				# If time diff is beyond threshold, add flow to ls_scandetect
				ls_scandetect.append(tmp_scan)
			#print out online scan test
			printOnlineResult(ls_scandetect,0)
			#clear network flow buffer
			netflows_buf=[]
	if(len(ls_scandetect)>0):
		#print out last record before close stdin
		printOnlineResult(ls_scandetect,1)

'''
Function: used as main for executing function and export test result
@arguments: NULL
'''
def main(): 
 	#define regex_str to filter scanlog files
	#regex_str=sys.argv[1]	
	
	#Check argument  to 
	if(len(sys.argv)>1):
		if("--online"!=sys.argv[1]):
			print("Usage: %s --online" %(sys.argv[0]))
			return 0
		online_handle()
	if(len(sys.argv)==1):
		offline_handle()
	
	return 0

  
#Call main function   
if __name__ == "__main__":
    main()
    