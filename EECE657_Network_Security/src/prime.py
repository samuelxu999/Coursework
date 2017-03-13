#!/usr/bin/python
#coding=utf-8

'''
Created on Feb 9, 2017

@author: Xu Ronghua
@Email:  rxu22@binghamton.edu
@TaskDescription: 
1) Topic 1: Big Prime Number Generator.
'''

import random
import os
import sys

'''
Function:generate big random number 
@arguments: 
(in)   bitlen:    big number length:n-bit
(out)  bignum:    return big number
(out)  bignum:    return big number bit string
'''
def bigRandomNumber(bitlen):
	b_len=int(bitlen)
	bignum=1
	bitstr="1"
	tmp_i=1
	#calcualte big number according to each bit
	while(tmp_i<b_len-1):	
		bignum=bignum*2
		#random number for each bit
		ranbit=random.randrange(2)
		bitstr=bitstr+str(ranbit)
		if(ranbit==1):
			bignum+=1	
		tmp_i+=1
	#output odd number
	bignum=bignum*2+1
	bitstr=bitstr+"1"
	return bignum,bitstr

'''
Function:Find small prime number less than upbound number
@arguments: 
(in)   upbound:   upbouond number for finding small prime
(out)  result:    write to "smallprime.txt"
'''	
def findSmallPrime(upbound=32768):
	numlen=int(upbound)
	i=2
	ls_prime=[]
	ls_prime.append(i)
	while(i<=numlen):
		i+=1
		k=2
		while(k<=i):
			if((i%k)==0):
				break
			k+=1
		if(i==k):
			ls_prime.append(i)
	
	#write result list to file	
	tmp_file = open("smallprime.txt", "w")       
	for value_prime in ls_prime:        
		tmp_file.write("%s " %(value_prime))
	tmp_file.close()	

	
'''
Function:Read small prime number from "smallprime.txt"
@arguments: 
(out)  ls_prime:    return prime number list
'''	
def getSmallPrime():
	#read small prime from "smallprime.txt"
	tmp_file = open("smallprime.txt", "r")  
	tmp_string=tmp_file.read()		
	tmp_file.close()
	ls_prime=tmp_string.split()
	return ls_prime
'''
Function:Basic division verification in small prime list
@arguments: 
(out)  result:    return check result:prime/non-prime/fail
'''
def divisonCheck(test_num,ls_smallprime):
	smallPrimes=ls_smallprime
	if (test_num >= 3):
		#for each prime in list for division check
		for p_num in smallPrimes:
			#prime
			if (test_num==int(p_num)):
				return 0
			#not prime
			if ((test_num%int(p_num))==0):				
				return 1
	#check fail
	return 2
	
'''
Function:Miller–Rabin primality test 
@arguments: 
(in)   test_num:  		input big number for verification
(in)   ls_smallprime:  	input small primes for basic verification
(out)  result:    		return check result
'''
def MillerRabinCheck(test_num):
	#define variable which is used for n-1
	minusOneNum=test_num-1
	
	#define variable s and d which is used for expression "n-1=(2^s)·d", where s and d are positive integers and d is odd
	s=0
	d=minusOneNum
	
	#keep halving until even, count s and d
	while(d%2==0):
		d=(d//2)		
		s+=1
	#try to test 50 times
	for trials in range(50): 
		#generate random number "a" less than "n-1"
		a = random.randrange(2, minusOneNum)
		#calculate mode expression:(a^d)%n
		modexp=pow(a, d, test_num)
		
		#(a^d)%n=1, is prime
		if(modexp==1):
			return True
		i=0
		while(i<s-1):
			i+=1
			modexp=(modexp**2)%test_num
			if(modexp==minusOneNum):
				return True				
	return False

'''
Function:Verify prime process 
@arguments: 
(in)   test_num:  		input big number for verification
(in)   ls_smallprime:  	input small primes for basic verification
(out)  result:    		return check result
'''

def isPrime(test_num,ls_smallprime):	
	#division check process
	if (divisonCheck(test_num,ls_smallprime)==0):
		return True
	if (divisonCheck(test_num,ls_smallprime)==1):
		return False
	
	#rabinMiller test process
	return MillerRabinCheck(test_num)

'''
Function:Generate random big prime 
1. Generate any bit length odd number
2. Verify whether it is a prime
3. If it is, output. If not, change the number
@arguments: 
(in)   keysize:  		input keysize which define the bit length
(out)  result:    		return prime number
'''
def generateLargePrime(keysize=1024):
	ls_smallprime=getSmallPrime()
	# Return a random prime number of keysize bits in size.
	while(True):
		(bignum,bitstring)=bigRandomNumber(keysize)
		ls_smallprime=getSmallPrime()
		if(isPrime(bignum,ls_smallprime)):
			return bignum
	
#verify prime number in testnum.txt 
def testPrime():
#read small prime from "smallprime.txt"
	tmp_file = open("testnum.txt", "r")  
	tmp_string=tmp_file.read()		
	tmp_file.close()
	ls_num=tmp_string.split(",")
	ls_smallprime=getSmallPrime()
	for num in ls_num:
		print("Test number %s is prime:%s" %(num,isPrime(int(num),ls_smallprime)))

'''
Function:Test big prime generator function 
'''
def BigPrimerGenerator():
		#check small prime files existed or not
		if(os.path.isfile("smallprime.txt")!=True):
			#find small primes and saved in "smallprime.txt"
			print("\"smallprime.txt\" is not exist.\nFinding small primes and saved in \"smallprime.txt\"")
			findSmallPrime()	
		
		#test sample number is prime
		testPrime()
		
		#generate big prime
		bitnum=sys.argv[1]		
		print("Generate %s bits prime number:\n%s" %(bitnum, generateLargePrime(bitnum)))
	
#Call main function   
if __name__ == "__main__":
	if(len(sys.argv)<2):
		print("Usage: %s keysize" %(sys.argv[0]))
	else:
		BigPrimerGenerator()
	
