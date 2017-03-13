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
def HandleInfo(ls_info):   
		
	ls_visited=[]
	ls_result=[]
	pretime=0;
	presite=""
	previsit=""
	#for each visit record in ls_info
	for tmp_info in ls_info:
		'''
		1)time difference between consecutive dns requests will be used to identify new dns request. 
		2)the first element in ls_visited[] will registed: time and dns name
		3)the following requests within time threshold append to ls_visited[] as affiated request
		4)prevent duplicate record in ls_visited[]
		'''
		#remove '.' at the end of site name
		tmp_info[3]=re.sub('\.$', '', tmp_info[3])
		
		#get current request record time 
		currtime = datetime.datetime.strptime(tmp_info[1][:-4], "%H:%M:%S")
		
		#add previous visit DNS list to result		
		if(len(ls_visited)!=0):

			diff=("%f\n" %((currtime-pretime).total_seconds()))
			
			'''
			check time difference between consecutive dns requests:
			1) if time difference is great than 60 second, it's a new site request record
			2) if time difference is great than 30 second and current visiting request is same as previous request 
			3) if time difference is great than 15 second and current visiting request is different from previous request 
			'''
			#if(presite!=tmp_info[3]):
			#	print("%s-%s\n" %(presite,tmp_info[3]))
			if((float(diff) >= 60.0) or 
			(presite==tmp_info[3] and float(diff) >= 40.0) or 
			(presite!=tmp_info[3] and float(diff) >= 15.0)):
				#if(float(diff) >= 30.0):					
				#add previous visit DNS list to result
				ls_result.append(ls_visited)				
				#refresh ls_visited=[] for new dns request element
				#print("%s\n" %(ls_visited))
				previsit=ls_visited[0][2]
				ls_visited=[]
		
		'''
		for new visited record element which is an empty list, there are following check condition:
		if current visiting request is same as latest visited request or previous request
		then, skip to next request to check
		'''
		if((presite==tmp_info[3] or previsit==tmp_info[3][4:]) and (len(ls_visited)==0)):
			#print("%s\t%s" %(previsit,tmp_info[3]))
			continue
		'''
		keep adding visited dns to current target visited site; 
		do not count duplicate record	
		'''
		if (tmp_info[3] not in ls_visited):
			if(len(ls_visited)!=0):			
				ls_visited.append(tmp_info[3])
			else:
				visited_site=[tmp_info[0],tmp_info[1],tmp_info[3]]			
				ls_visited.append(visited_site)
		#refresh previous record time
		pretime=currtime
		presite=tmp_info[3]
		
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
				tmp_file.write("%s:%s Time:%s %s\n" %(dns_site[2],len(ls_dns)-1,dns_site[0],dns_site[1]))
				#print("%s" %(dns_site[2]))
				#tmp_file.write("%s\n" %(dns_site[2]))
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
	reportname="dnsreport.txt"
    
    #========================== print words statistics data ==========================================
    #read log file and save data as arraylist ls_line
	ls_line=ReadLines(logname)
	print("Extract DNS information from '%s'." %(logname))
	
	#handle line list data and save result as ls_info	
	ls_info=Parselines(ls_line)
	ls_visiteddns=HandleInfo(ls_info)
	
	#Export data and saved as report
	ExportResult(ls_visiteddns,reportname)
	print("Export DNS statistics data to '%s'." %(reportname))
	return 0

  
#Call main function   
if __name__ == "__main__":
    main()

    
    

    