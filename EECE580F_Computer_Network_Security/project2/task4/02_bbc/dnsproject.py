#!/usr/bin/python

'''
Created on Feb 28, 2017

@author: Xu Ronghua
@Email:  rxu22@binghamton.edu
@TaskDescription: 
1) Extract information in dnslog.txt and saved as easy reading format dnsreport.txt.

'''

import re
import datetime

'''
Function:read line contents from sample file
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
Function: extract information from line
@arguments: 
(in)    ls_line:   		input line list to parse need information
(out)   ls_info:   		return information list
'''
def Parselines(ls_line):
	#Define regular expressions to parse sentences
	regex="www.google.com"
	#regex = r'([www.google.com])'  
	ls_info=[]
	for tmp_line in ls_line:
		#remove redundent strings
		tmp_line=tmp_line.replace("Client IP:" , "")
		tmp_line=tmp_line.replace("request is" , "")
		tmp_line=tmp_line.replace("\n" , " ")
		ls_info.append(tmp_line.split())
		#check whether target DNS address exist
		'''if(regex in tmp_line):			
			#split information to list 
			ls_info=tmp_line.split()
			print(ls_info)'''
	return ls_info
   
'''
Function: calculate statistic data based on information list
@arguments: 
(in)    ls_info:   		input line list to parse need information
(out)   ls_result:   	return information list
'''
def HandleInfo(ls_info, ls_target):   
	#ls_regex=["www.google.com","www.cnn.com"] 
	ls_regex=[]
	for target in ls_target:
		ls_regex.append(target.replace("\n" , ""))
		
	ls_visited=[]
	ls_result=[]
	#for each visit record in ls_info
	for tmp_info in ls_info:
		'''
		if current record is in regex list which store target visited dns name, and ls_visited[] is not emptythen 
		there are two condition:
		1)visit time is very near current target visited dns,
		  such dns name is seen as a duplicate of current target visited dns, we discard it and skip to next record 
		2)otherwize, it is a new target visited dns
		  we add current target visited dns with subsequent visited list to result list;
		  clear ls_visited and set such new record as target visited dns as ls_visited=[0]
		  skip to next record 
		'''
		#remove '.' at the end of site name
		tmp_info[3]=re.sub('\.$', '', tmp_info[3])
		if(tmp_info[3] in ls_regex):			
			#add previous visit DNS list to result
			if(len(ls_visited)!=0):
				#skip duplicate target record in short time span:day-time 
				#1)compute time difference
				a = datetime.datetime.strptime(ls_visited[0][1][:-4], "%H:%M:%S")
				b = datetime.datetime.strptime(tmp_info[1][:-4], "%H:%M:%S")
				diff=("%f\n" %((b-a).total_seconds()))
				#2)check datetime difference:
				#On same day and time difference is less than 2 second, skip to next record
				if((ls_visited[0][0]==tmp_info[0]) and (float(diff) <= 1.0)):
					continue
				#add previous visit DNS list to result
				ls_result.append(ls_visited)
				#refresh with current target visited DNS
				ls_visited=[]
			visited_site=[tmp_info[0],tmp_info[1],tmp_info[3]]			
			ls_visited.append(visited_site)
			continue
		
		'''
		keep adding visited dns to current target visited site; 
		do not count duplicate record	
		'''
		if ((tmp_info[3] not in ls_visited) and (len(ls_visited)!=0)):
			ls_visited.append(tmp_info[3])
	#save last record to ls_result
	ls_result.append(ls_visited)
	#return statistics result
	return ls_result;

	'''
Function: calculate statistic data based on information list
@arguments: 
(in)    ls_info:   		input line list to parse need information
(out)   ls_result:   	return information list
'''
def ExportResult(ls_record,filename): 
	tmp_file = open(filename, "w") 
	for ls_dns in ls_record:
		i=0
		for dns_site in ls_dns:
			if(i==0):
				#print("%s:%s Time:%s %s" %(dns_site[2],len(ls_dns),dns_site[0],dns_site[1]))
				tmp_file.write("%s:%s Time:%s %s\n" %(dns_site[2],len(ls_dns),dns_site[0],dns_site[1]))
				#print("%s" %(dns_site[2]))
				tmp_file.write("%s\n" %(dns_site[2]))
				i+=1
				continue
			#print("%s" %(dns_site))	
			tmp_file.write("%s\n" %(dns_site))	
		#print("")
		tmp_file.write("\n")
	tmp_file.close() 

'''
Function: used as main for executing function and export test result
@arguments: NULL
'''
def main(): 
    #define filename to load test data
	logname="dnslog.txt"
	targetname="targetdns.txt"
	reportname="dnsreport.txt"
    
    #========================== print words statistics data ==========================================
    #read log file and save data as arraylist ls_line
	ls_line=ReadLines(logname)
	print("Extract DNS information from '%s'." %(logname))
	
	#read target file and save data as arraylist ls_target
	ls_target=ReadLines(targetname)
	print("Load target DNS name from '%s'." %(targetname))
	
	#handle line list data and save result as ls_info	
	ls_info=Parselines(ls_line)
	ls_visiteddns=HandleInfo(ls_info,ls_target)
	
	#Export data and saved as report
	ExportResult(ls_visiteddns,reportname)
	print("Export DNS statistics data to '%s'." %(reportname))
	return 0

  
#Call main function   
if __name__ == "__main__":
    main()

    
    

    