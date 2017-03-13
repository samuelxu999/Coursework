#!/usr/bin/python

'''
Created on Feb 10, 2017

@author: Xu Ronghua
@Email:  rxu22@binghamton.edu
@TaskDescription: 
Topic 2: RSA Cryptosystem
'''

import sys
#import imp
#Prime=imp.load_source('Prime','./prime.py')
import prime
	
'''
Function:Calculate GCD{a,n} based on Euclidean algorithm:ax + by = GCD
@arguments: 
(in)   a:  		input encrypy key e
(in)   n:    	input large number &(n)=n-1 
'''
def Euclid(a, n):
	'''
	start of algorithm, initialize setting:
	1*a1+0*b1=n
	0*a2+1*b2=a
	'''
	equation = ['1', '0', n, '0', '1', a]
	
	#used to save remain value
	r=-1
	#calculate GCD until r=0
	while(r):
		#set variable list
		a1=int(equation[0])
		a2=int(equation[1])
		x=int(equation[2])
		b1=int(equation[3])
		b2=int(equation[4])
		y=int(equation[5])
		
		#calculate remain value
		q=x//y
		c1=a1-q*b1
		c2=a2-q*b2
		r=x-q*y
		
		'''
		a1 <-- b1
		a2 <-- b2
		x  <-- y
		b1 <-- c1
		b2 <-- c2
		y  <-- r
		'''
		equation = [b1, b2, y, c1, c2, r]
	
	ls_result=[]
	ls_result.append(equation[0])
	ls_result.append(equation[1])
	ls_result.append(equation[2])
	return ls_result
	'''
	print(a1)
	print(a2)
	print(x)
	print(b1)
	print(b2)
	print(y)
	'''

'''
Function:Generate RSA keys 
1. Calculate publish key n=(p-1)(q-1)
2. Verify whether it is a prime
3. If it is, output. If not, change the number
@arguments: 
(in)   keysize:  		input keysize which define the bit length
(out)  result:    		return prime number
'''
def RSAKeyGenerator(keysize=16):
	#define key_list for return n, e, and d
	key_list=[]
	
	#generate big prime p and q
	p=prime.generateLargePrime(keysize)	
	q=prime.generateLargePrime(keysize)
	
	#calculate n
	n=(p)*(q)	
	#calculate Fer based on Fermat's little theorem:a^p=(mod p)
	Fer=(p-1)*(q-1)
	
	key_list.append(n)
	key_list.append(Fer)
	
	#generate big prime as public key:e
	e=prime.generateLargePrime((int(keysize)*2-1))	
	ls_gcd=[]
	#search public key e which GCD(e,n)=1
	while(True):
		ls_gcd=Euclid(e,Fer)
		gcd=ls_gcd[2]
		if(gcd==1):
			break
		e+=1
	key_list.append(e)
	if(int(ls_gcd[1])<0):
		ls_gcd[1]=ls_gcd[1]+Fer
	key_list.append(ls_gcd[1])	
	#ck=(e*ls_gcd[1])%Fer
	#print(ck)
	return key_list	

'''
Function:Encrypt plaintext vie RSA 
@arguments: 
(in)   m:  		plaintext for encryption
(in)   e:    	public key for encryption
(in)   n:    	public big number n=p*q
(out)  modexp:  return ciphertext
'''
def encryption(m,e,n):
	modexp=pow(m,e,n)
	return modexp

'''
Function:Decrypt ciphertext vie RSA 
@arguments: 
(in)   c:  		ciphertext for decryption
(in)   e:    	private key for decryption
(in)   n:    	public big number n=p*q
(out)  modexp:  return plaintext
'''
def decryption(c,d,n):
	modexp=pow(c,d,n)
	return modexp

#test RSA basic algorithm
def testRSA(keysize):
		'''
		generate RSA key: n=pq; $n=(p-1)(q-1); public key=e; private key=d
		'''
		bitnum=keysize
		RSA_key=RSAKeyGenerator(bitnum)
		print("generate RSA key:\n n=%s;\n $n=%s;\n public key=%s;\n private key=%s;\n" 
		%(RSA_key[0],RSA_key[1],RSA_key[2],RSA_key[3]))
		
		'''
		test encrypy and decript
		'''
		print("Test encrypy and decript:")
		ptext=21337
		print("plaintext is:%s" %(ptext))
		#encrypt
		ctext=encryption(ptext,RSA_key[2],RSA_key[0])		
		print("After encryption, cithertext is:%s" %(ctext))
		#decrypt
		p_text=decryption(ctext,RSA_key[3],RSA_key[0])		
		print("After decryption, original plaintext is:%s\n" %(p_text))
		
		'''
		test signature
		'''
		print("Test signature:")
		sig=12345
		print("original signature is:%s" %(sig))
		#use private key d to generate signature
		csig=encryption(sig,RSA_key[3],RSA_key[0])
		print("After encryption, digital signature is:%s" %(csig))
		#use public key d to verify signature
		dsig=decryption(csig,RSA_key[2],RSA_key[0])
		print("After decryption, check signature is:%s\n" %(dsig))

'''
Function:read line contents from sample file
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

#test RSA decryption 
def testRSADecrypt():
	'''
	ls_line=ReadLines("testRSA.txt")
	n=ls_line[0].replace("\n" , " ")
	e=ls_line[1].replace("\n" , " ")
	d=ls_line[2].replace("\n" , " ")
	ctext=ls_line[3].replace("\n" , " ")
	'''
	
	n=8293301
	nn=8287500
	e=7284899
	d=5442599
	
	print("Free test RSA!")
	ptext=56789
	print("plaintext is:%s" %(ptext))
	ctext=encryption(ptext,int(e),int(n))
	print("After encryption, cithertext is:%s" %(ctext))
	p_text=decryption(int(ctext),int(d),int(n))
	print("After decryption, original plaintext is:%s\n" %(p_text))
	#print("%s\n%s\n%s\n%s" %(n,e,d,ctext))
	#print("%s\t%s" %(ctext,pptext))
		
#Call main function   
if __name__ == "__main__":
	if(len(sys.argv)<2):
		print("Usage: %s keysize" %(sys.argv[0]))
	else:
		testRSA(sys.argv[1])
		testRSADecrypt()