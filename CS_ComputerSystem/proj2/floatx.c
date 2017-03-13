#include "floatx.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define S_SIGNED 1
#define E_FLOAT 8
#define E_DOUBLE 11
#define M_FLOAT 23
#define M_DOUBLE 52

/* IEEE float format in system
 * float a = -118.625; 
 * Binary: 11000010.11101101.01000000.00000000
 * 1 sign bit | 8 exponent bit | 23 fraction bits
 * double b=-118.625;
 * Binary: 11000000.01011101.10101000.00000000.00000000.00000000.00000000.00000000
 * 1 sign bit | 11 exponent bit | 52 fraction bits
*/

// for each byte data, bit returned at location
char bit_return(char l_dat, char bit_loc)   
{
    char buf = l_dat & (1<<bit_loc);

    if (buf == 0) return 0;
    else return 1; 
}

/**************** convert data to binary string in LillleEndian format **********************/
void DatatoBinaryLittle(void *p_data,char *p_buf) 
{
    
    char *c_byte=(char *)(p_data);
    
    char bytes_size=sizeof(p_data);
    
    //for each byte;
    for(int byte_i=(bytes_size-1);byte_i>=0;byte_i--)
    {
      //for each bit;
      for (int bit_i = 7; bit_i >= 0; bit_i--)
      {
	  //printf("%d",bit_return(*(c_byte+byte_i),bit_i));
	  *(p_buf++)=(bit_return(*(c_byte+byte_i),bit_i)+'0');
      }
      //printf(".");
      //*(p_buf++)='.';
    }    
    *p_buf='\0';
    
    //printf("size:%d\t%s\n",bytes_size,bitbuf);
}

/**********************convert data to binary string in BigEndian format**********************/
void DatatoBinaryBig(void *p_data, char *p_buf) 
{
    
    char *c_byte=(char *)(p_data);

    char bytes_size=sizeof(p_data);
    
    //char *bitbuf=p_buf;
    
    //for each byte;
    for(int byte_i=0;byte_i<bytes_size;byte_i++)
    {
      //for each bit;
      for (int bit_i = 0; bit_i <8; bit_i++)
      {
	  //printf("%d",bit_return(*(c_byte+byte_i),bit_i));
	  *(p_buf++)=(bit_return(*(c_byte+byte_i),bit_i)+'0');
      }
      //printf(".");
      //*(p_buf++)='.';
    }    

    *p_buf='\0';
    
    //printf("size:%d\t%s\n",bytes_size,bitbuf);
}

//get string size by computing char units
int getStringSize(char *str_buf)
{
    int count=0;
    while(('\0'!=str_buf[count]))
      count++;
    return count;
}
/*--------------------------------------------------------------------------------
	Return floatx representation (as defined by *def) which
	best approximates value
-------------------------------------------------------------------------------- */
floatx doubleToFloatx(const floatxDef *def, double value) {
	/* Put your code here */

	int M_size=def->totBits-def->expBits-S_SIGNED;
	int E_size=def->expBits;
	int section_seek=0;
	floatx fx=0;
	int bit_data=0;
	int bit_size=sizeof(floatx)*8;
	int i=0;
	int E_inf=0;
	int E_denorm=1;
	int E_sign=0;
	
	//transfer value to binary format and saved in little_buf
	char little_buf[100];
	DatatoBinaryLittle(&value,little_buf);
	
	//printf("Little:\t%s\n",little_buf);
	
	/************************************set padding and sign flage********************************/
	//add padding bits left P bit in from fx.63 to fx.32 with 0
	for(i=(bit_size-1);i>=(def->totBits);i--) {
	  fx&=~(1<<i);
	}
	/*set P bit from little_buf[0] to fx.31*/
	bit_data=little_buf[0]-'0';
	fx|=(bit_data<<i);
	
	
	/************************************set E section********************************/
	//set E signed bit in fx.30 by copying value from little_buf[1]
	//section seed start from 1
	section_seek=S_SIGNED;
	bit_data=little_buf[section_seek]-'0';
	fx|=(bit_data<<(bit_size/2-1-S_SIGNED));
	E_sign=bit_data;	
	if(1==E_sign) {E_denorm=0;}
	
	//handle bits betwen little_buf[2]~little_buf[4]
	//check whether E is overflow based on setting E bit size
	section_seek=S_SIGNED+1;
	for(i=0;i<(E_DOUBLE-E_size);i++) {
	  bit_data=little_buf[i+section_seek]-'0';
	  //if E signed bit is 1, and any bits in following chech section is 1, then E overflow as positive inf
	  //if E signed bit is 0, and any bits in following chech section is 0, then E overflow as negative inf
	  if(E_sign==bit_data) {
	    E_inf=1;	    
	    break;
	  }
	}

	//section seed start from 1+3
	section_seek=S_SIGNED+E_DOUBLE-E_size;
	//set bits following E sign from fx.29~fx.24
	for(i=1;i<E_size;i++) {
	  if(1!=E_inf) {
	    bit_data=little_buf[i+section_seek]-'0';	    
	  }
	  else {
	    //set all bit as 1 in E section to represent inf
	    bit_data=1;
	  }	  
	  fx|=(bit_data<<(bit_size/2-1-S_SIGNED-i));
	  //check whether all bits in E section are zero or not.
	  if(1==bit_data) {E_denorm=0;}
	}
	
	
	/************************************set M section********************************/
	//section seed start from 12
	section_seek=S_SIGNED+E_DOUBLE;
	//set bits following E sign from fx.23~fx.0
	for(i=0;i<M_size;i++) {	  
	  if(1!=E_inf) {
	    //if E_denorm=1, will represent “denormalized” number by skip 0
	    //else, represent normal number/
	    bit_data=little_buf[i+section_seek+E_denorm]-'0';  
	  }
	  else {
	    //set all bit as 0 in E section to represent inf
	    bit_data=0;
	  }
	  fx|=(bit_data<<(bit_size/2-1-S_SIGNED-E_size-i));
	}

	return fx;
}

/** Return C double with value which best approximates that of floatx fx
 *  (as defined by *def).
 */
double floatxToDouble(const floatxDef *def, floatx fx) {
	/* Put your code here */	
	
	int E_size=def->expBits;
	double df_data=0.0;
	
	//used for bit handle
	unsigned int *pl_data=(unsigned int *)(&df_data);
	
	int section_seek=0;	
	int bit_seek=0;
	int bit_data=0;
	
	int bit_size=8;
	int i=0;
	int E_inf=1;
	int E_denorm=1;
	int E_sign=0;
	
	//transfer value to binary format and saved in little_buf
	char little_buf[100];
	DatatoBinaryLittle(&fx,little_buf);		
	//printf("Little:\t%s\n",little_buf);
	
	/***************************************set sign flage *****************************************/
	//set P bit from little_buf[32] to df_data.63
	section_seek=bit_size*4;	
	bit_data=little_buf[section_seek]-'0';
	bit_seek=sizeof(unsigned int)*bit_size-1;
	*(pl_data+1)|=(bit_data<<bit_seek);
	
	/************************************** set E section ******************************************/
	//set E signed bit from little_buf[33] to df_data.62
	section_seek+=1;
	bit_data=little_buf[section_seek]-'0';
	bit_seek-=1;
	*(pl_data+1)|=(bit_data<<bit_seek);
	E_sign=bit_data;
	
	//if E signed bit is not 0, then not denormination number.
	if(1==E_sign) { 
	  E_denorm=0; 	  
	}
	else
	{
	  E_inf=0;
	}
	
	//check whether infinite or denormination
	for(i=1;i<E_size;i++) {
	  bit_data=little_buf[section_seek+i]-'0';
	  //for each bit of E section, if any bit is 1, then not denormination number.
	  if(1==bit_data){
	    E_denorm=0;
	  }
	  //for each bit of E section, if not all bit is same as E_sign, then not infinite number.
	  if((0==bit_data)&&(1==E_sign)) {
	    E_inf=0;	    
	  }
	}
	//printf("inf-%d\n",E_inf);
	
	/*********set padding between floatx and double E section difference*********/
	bit_seek-=1;
	for(i=0;i<E_DOUBLE-E_size;i++) {
	  //if E singed is 0, extend padding with 1
	  //if infinite number, extend padding with 1
	  if((0==E_sign)||(1==E_inf)) {
	    *(pl_data+1)|=(1<<(bit_seek-i));	    
	  }
	  //if E singed is 1, extend padding with 0
	  else {
	    *(pl_data+1)|=(0<<(bit_seek-i));
	  }	   	    
	}
	
	/**********add E section from little_buf[34] to df_data.59***********/
	section_seek+=1;
	bit_seek-=E_DOUBLE-E_size;
	for(i=0;i<E_size-1;i++) {
	  bit_data=little_buf[section_seek+i]-'0';
	  *(pl_data+1)|=(bit_data<<(bit_seek-i));
	}
	
	/************************************** set M section ******************************************/
	//start from little_buf[41]
	section_seek+=E_size-1;
	//start from pl_data.51
	bit_seek-=E_size-1;	
	
	// if denormination number, add padding 0 to significant bit of M in df_data.51
	if(1==E_denorm){
	  // skip bit by deduce 1 to bit_seek
	  bit_seek-=1;
	}
	//for each bit in little_buf[41~59] to set remain bits in pl_data high 32 bits
	for(i=0;i<bit_seek;i++) {
	  bit_data=little_buf[section_seek+i]-'0';
	  *(pl_data+1)|=(bit_data<<(bit_seek-i));
	}
	
	//modify seek to set pl_data low 32 bits
	//start from little_buf[41+19=60]
	section_seek+=bit_seek;
	//start from pl_data[31]
	bit_seek=sizeof(unsigned int)*bit_size-1;
	
	//for each bit in little_buf[60~63] to set remain bits in pl_data low 32 bits
	for(i=0;i<(bit_size*8-section_seek);i++) {
	  bit_data=little_buf[section_seek+i]-'0';
	  *(pl_data)|=(bit_data<<(bit_seek-i));
	}
	
	
	DatatoBinaryLittle(&df_data,little_buf);		
	//printf("Little:\t%s\n",little_buf);
	
	return df_data;
	//return NAN;
}