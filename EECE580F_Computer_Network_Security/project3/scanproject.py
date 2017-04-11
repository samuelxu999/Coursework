#!/usr/bin/python

'''
Created on April 9, 2017

@author: Xu Ronghua
@Email:  rxu22@binghamton.edu
@TaskDescription: 
1) Extract network monitor data in tcpdump_*.txt.
2) Analyze network flows to Detect if there is some scanning activity on your network
'''
import sys
import re
import datetime
import time

'''
Function:read line contents from tcpdump file
         create {words:count} dictionary, sum of words
@arguments: 
(input)  filepath:   	test file path
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
	#Define regular expressions to parse sentences	
	#regex = r'([www.google.com])'  
	ls_info=[]
	
	# 1.split each line racord into ls_info[]
	for tmp_line in ls_line:
		#remove redundent strings		
		tmp_line=tmp_line.replace("\n" , "")			
		#remove empty line
		if(len(tmp_line.split())!=0):
			ls_data=[]
			if ("ARP" in tmp_line):
				ls_info.append(tmp_line.split(','))
				continue
			if ("IP" in tmp_line):
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
		#Request handler
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
def HandleInfo(ls_info):   	
	ls_flows=[]	
	pretime=0;
	
	#for each flow record in ls_info
	for tmp_record in ls_info:
		#=================================pre-operation to filter unconcerning record==========================
		#only analyze IP flow
		if("IP"!=tmp_record[1]):
			continue
		
		#remove flows whose Port is netbios-ns or domain
		if(("netbios-ns"==tmp_record[3]) or ("domain"==tmp_record[3]) or 
			(""==tmp_record[3]) or ("bootpc"==tmp_record[3]) or
			("netbios-ns"==tmp_record[5]) or ("domain"==tmp_record[5]) or("bootpc"==tmp_record[5]) 
			):
			continue
		
		#remove UDP flow by ARP, checking if 'UDP' appear at the first of data section 
		if("UDP"==tmp_record[6].split(",")[0]):
			continue
		
		#check if 'Flags=[S]' appear at the first of data section
		if("Flags"!=tmp_record[6].split(",")[0].split()[0] or "[S]"!=tmp_record[6].split(",")[0].split()[1]):
			continue
		
		#==================================analyze network flow data=============================================
		#get current request record time 
		#flowtime = tmp_record[0][:-7]
		currtime = datetime.datetime.strptime(tmp_record[0][:-7], "%H:%M:%S")
		flowpath=tmp_record[2]+">"+tmp_record[4]
		scanport=tmp_record[5]
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
				#print("Curr:%s\tPre:%s\tDiff:%s" %(tmp_record[0][:-7], ls_flowdata[3],diff))
				#if diff between current time and previous time is large than threshold, it could be new scan activity
				if(float(diff) <= 5.0):					
					#set flow exist flag for skiping 2) operation
					isflowexist=1
					break
		
		#if scan flow is existed
		if(isflowexist==1):
			#get scan port data from ls_flowdata
			ls_scanport=ls_flowdata[2]
	
			#print(ls_flows.index(ls_flowdata))
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
		#add scan record to ls_flows[] list
		ls_flows.append(ls_flowdata)
		
		#update previous scan time
		#pretime=currtime
	
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
		if(len(ls_scanport)>5):
			print(len(ls_scanport))
			#add scan activity time
			ls_scandata.append(tmp_record[0])
			#add scan path scr->des
			ls_scandata.append(tmp_record[1])
			#add last scan time
			ls_scandata.append(tmp_record[3])
			
			#add ls_scandata to ls_scanflows[]
			ls_scanflows.append(ls_scandata)
	return ls_scanflows
	
'''
Function: calculate statistic data based on information list
@arguments: 
(in)    ls_record:   	input line list to parse need information
(out)   ls_result:   	return information list
'''
def ExportResult(ls_record,filename): 
	tmp_file = open(filename, "w") 
	for ls_data in ls_record:
		tmp_file.write("%s\n" %(ls_data))
		'''i=0
		for dns_site in ls_dns:
			if(i==0):
				#print("%s:%s Time:%s %s" %(dns_site[2],len(ls_dns),dns_site[0],dns_site[1]))
				tmp_file.write("%s:%s Time:%s %s\n" %(dns_site[2],len(ls_dns)-1,dns_site[0],dns_site[1]))
				#print("%s" %(dns_site[2]))
				#tmp_file.write("%s\n" %(dns_site[2]))
				i+=1
				continue
			#print("%s" %(dns_site))	
			tmp_file.write("%s\n" %(dns_site))	
		#print("")
		tmp_file.write("\n")'''
	tmp_file.close() 

'''
Function: used as main for executing function and export test result
@arguments: NULL
'''
def main(): 
    #define filename to load test data
	logname=sys.argv[1]
	#logname="tcpdump_sample"
	reportname="networkreport.txt"
	portscan="portscanreport.txt"
	detectname="detectreport.txt"
    
    #========================== print words statistics data ==========================================
    #read log file and save data as arraylist ls_line
	ls_line=ReadLines(logname)
	print("Extract network flow from '%s'." %(logname))
	
	#handle line list data and save result as ls_info	
	ls_info=Parselines(ls_line)
	ls_netflows=HandleInfo(ls_info)
	ls_scanflows=ScanDetect(ls_netflows)
	
	print("Export network scan detect data to '%s'." %(detectname))
	ExportResult(ls_scanflows,detectname)
	ExportResult(ls_netflows,portscan)
	#Export data and saved as report
	#ExportResult(ls_info,reportname)
	#print("Export network monitor data to '%s'." %(reportname))
	return 0

  
#Call main function   
if __name__ == "__main__":
    main()
    