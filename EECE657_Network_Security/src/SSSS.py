#!/usr/bin/python

'''
Created on Feb 11, 2017

@author: Xu Ronghua
@Email:  rxu22@binghamton.edu
@TaskDescription: Shamir's Secret Sharing Scheme
Refer to Wiki for algorithm:
https://en.wikipedia.org/wiki/Shamir's_Secret_Sharing
'''

import sys
import math
import random
#import imp
#Prime=imp.load_source('Prime','./prime.py')
import prime
	
'''
Function: Gives the decomposition of the gcd of a and b.   
@arguments: 
(in)   a:  		number a
(in)   b:    	number b 
(out)  list		Returns [x,y,z] such that x = gcd(a,b) and x=y*a + z*b
'''
def gcd(a, b):
	if (b==0):
		return [a, 1, 0]
	else:
		#similiar as : n=a//b
		n=int(math.floor(a*1.0/b))
		c=a%b
		r=gcd(b,c)
		return [r[0], r[2], r[1]-r[2]*n]

'''
Function: Gives the multiplicative inverse of e mod n.  
		  In other words (e * modInverse(e)) % n = 1 for all prime > k >= 1   
@arguments: 
(in)   e:  		number e
(in)   n:    	prime number
(out)  d		Returns reverse d
'''		
def mod_inverse(e, n):
		#d=RSA.Euclid(int(a),int(b))[1]
		d=gcd(e,n)[1]
		return d

'''
Function: Split number into the shares   
@arguments: 
(in)  	keynumber:  		S=prime key
(in)  	available:    		t=maximum available sharing keys for recovery of prime key
(in)  	needed:				k=maximum needed sharing keys for split of prime key
(in)  	prime_num:			N=random prime big number
(out)	coef				return coefficient parameters:a0,a1,a2....a(k-1)
(out)  	shares:				return split sharing keys as list
'''			
def splitSecret(secret=12345, available=6, needed=3, prime_num=99991):
	#set coef[0]=secret
	coef=[secret]
	#For each share that is requested to be available, run through the formula plugging the corresponding coefficient
	for c in range(1,needed):
		coef.append(random.randrange(prime_num-1))
	'''#hardcode for test
	coef=[1234,166,94]
	print(coef)'''
	
	#generate all available secret sharing keys
	shares=[]
	for x in range(1,(available+1)):
		'''
		set a0 in polynomial f(x)=a0+x*a1+x^2*a2+...x^(t)*a(t-1)
		coef = [1234, 166, 94] which is 1234x^0 + 166x^1 + 94x^2
		'''
		accum = coef[0]
		for exp in range(1,needed):
			#f(x)=1234x^0 + 166x^1 + 94x^2 mod p
			accum=(accum+(coef[exp]*((x**exp)%prime_num)%prime_num))%prime_num
		shares.append([x,accum])
	return coef,shares

'''
Function: merge the needed shares list into a prime key   
@arguments: 
(in)  	shares:				needed sharing keys list to recover prime key
(in)  	prime_num:			prime number for module
(out)  	accum_screct:		return accumulated prime secret
'''	
def mergeSecret(shares,prime_num=99991):
	accum_screct=0
	for formula in range(0,len(shares)):
		numerator = denominator = 1
		for count in range(0,len(shares)):
			#Not consider the same value, which means that m<>j
			if(formula == count):
				continue
			#count startposition and nextposition to compute numerator and denominator
			startposition = shares[formula][0]
			nextposition = shares[count][0]
			
			'''
			Multiply the numerator across the top and denominators across the bottom to do Lagrange's interpolation
			@numerator:		II(-X[m])
			@denominator:	II(X[j]-X[m])
			'''
			numerator = (numerator * (-nextposition)) % prime_num
			denominator = (denominator * (startposition - nextposition)) % prime_num
		'''
		Calculate accumulate screct
		@sharingvalue:	f(x[j])
		@accum_screct:  for j=0 to k-1, accum+=f(X[j])*[X[m]/X[m]-X[j]]
		'''
		sharingvalue=shares[formula][1]
		accum_screct=(prime_num + accum_screct + (sharingvalue * numerator * mod_inverse(denominator,prime_num))) % prime_num
	return accum_screct

'''
Function: test Shamir's Secret Sharing Scheme function   
@arguments: 
(in)  	availale_sharesize:		All available sharing secret list size
(in)  	needed_sharesize:		All needed sharing secret list size
'''	
def testSSSS(availale_sharesize,needed_sharesize):
		#generate random big prime for S and N
		secret_key=prime.generateLargePrime(15)
		prime_num=prime.generateLargePrime(16)
		
		#generate split key
		(ls_coef,ls_shares)=splitSecret(secret_key,availale_sharesize,needed_sharesize,prime_num)
		print("Split prime secret into sharing list based on S-%s;N-%s:\n%s\n" 
				%(secret_key,prime_num,ls_shares))
		
		#Random choose sharing keys in available sharing list
		k_index=[]
		while(True):
			tmp=random.randrange(0,availale_sharesize)
			if(k_index.count(tmp) == 1):
				continue
			k_index.append(tmp)
			if(len(k_index)==needed_sharesize):
				break
		#Generate needed sharing key list		
		ls_sk=[]
		for i in range(len(k_index)):
			ls_sk.append(ls_shares[k_index[i]])
		print("Needed sharing key list:\n%s\n" %(ls_sk))
		
		#merge sharing keys to prime key
		print("Merge needed sharing secret list to restore prime secret:\nprime S=%s; recovery S=%s" 
				%(secret_key, mergeSecret(ls_sk,prime_num)))

#Call main function   
if __name__ == "__main__":
	if(len(sys.argv)<3):
		print("Usage: %s key @available @needed" %(sys.argv[0]))
	else:
		#read (n k) from argument
		availale_size=int(sys.argv[1])
		needed_size=int(sys.argv[2])
		testSSSS(availale_size,needed_size)
		
