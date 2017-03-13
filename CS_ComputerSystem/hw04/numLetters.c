#include <stdio.h>
#include <string.h>

#define NUMLEN 6
#define LETTERLEN 10
#define STRLEN 100

//Switch number to letter string
char * numToletter(char c_num, int dec_flag) {
	char letternum[LETTERLEN]={0};
	//translate unit digit 1~9
	if(0==dec_flag) {
		switch(c_num){
			case '1' :
				strcpy(letternum,"One");
				break;
			case '2' :
				strcpy(letternum,"Two");
				break;
			case '3' :
				strcpy(letternum,"Three");
				break;
			case '4' :
				strcpy(letternum,"Four");
				break;
			case '5' :
				strcpy(letternum,"Five");
				break;
			case '6' :
				strcpy(letternum,"Six");
				break;
			case '7' :
				strcpy(letternum,"Seven");
				break;
			case '8' :
				strcpy(letternum,"Eight");
				break;
			case '9' :
				strcpy(letternum,"Nine");
				break;
			default:
				strcpy(letternum,"\0");
				break;
		}
	}
	else if(1==dec_flag) {
		//translate tenth digit 11~19
		switch(c_num){
			case '0' :
				strcpy(letternum,"ten");
			case '1' :
				strcpy(letternum,"eleven");
				break;
			case '2' :
				strcpy(letternum,"twelve");
				break;
			case '3' :
				strcpy(letternum,"thirteen");
				break;
			case '4' :
				strcpy(letternum,"Fouteen");
				break;
			case '5' :
				strcpy(letternum,"Fifteen");
				break;
			case '6' :
				strcpy(letternum,"Sixteen");
				break;
			case '7' :
				strcpy(letternum,"Seventeen");
				break;
			case '8' :
				strcpy(letternum,"Eighteen");
				break;
			case '9' :
				strcpy(letternum,"Ninteen");
				break;
			default:
				strcpy(letternum,"\0");
				break;
		}	
	}
	else {
		//translate tenth digit 20~90
		switch(c_num){
			case '2' :
				strcpy(letternum,"Twenty");
				break;
			case '3' :
				strcpy(letternum,"Thirty");
				break;
			case '4' :
				strcpy(letternum,"Fouty");
				break;
			case '5' :
				strcpy(letternum,"Fifty");
				break;
			case '6' :
				strcpy(letternum,"Sixty");
				break;
			case '7' :
				strcpy(letternum,"Seventy");
				break;
			case '8' :
				strcpy(letternum,"Eighty");
				break;
			case '9' :
				strcpy(letternum,"Ninty");
				break;
			default:
				strcpy(letternum,"\0");
				break;
		}	
	}

	return letternum;
}

int main(int argc,char *argv[]) {
	//define char string to save input parameter
	char ch_num[NUMLEN]={0};
	char str_Letter[STRLEN]={0};
	//saved number string to ch_num[]
	strcpy(ch_num,argv[1]);
	
	//used to count digit length
	int digit_len=0;
	//used to save number as integer format
	int i_num=0;
	//transfer string to number and get string digit count
	while (ch_num[digit_len] != '\0') {
		i_num=(i_num+(int)(ch_num[digit_len])-48)*10;
		digit_len++;
	}
	i_num=i_num/10;
	
	//for each char to transfer digit to letter
	int i=0;
	while (ch_num[i] != '\0') {	  
		int f=0;
		//if tenth digit, consider 1X or XX two scenario
		if(digit_len==2) {
			if(ch_num[i]=='1') {
				f=1;
				i++;
				digit_len--;
			}
			else {
				f=2;
			}			  
		}
		strcat(str_Letter,numToletter(ch_num[i],f));
		//if digit is 0, skip to next digit
		if(ch_num[i]!='0'){
			//consider hundred digit
			if(digit_len==3) {
			  strcat(str_Letter,"hundred");
			}
			//consider thousand digit
			if(digit_len==4) {
			  strcat(str_Letter,"thousand");
			}
		}
		i++;
		digit_len--;
	}
	
	// count letter string length
	i=0;
	while (str_Letter[i] != '\0') {
		i++;
	}
	//print out result
	printf("%d takes %d letters, represent:%s\n", i_num, i,str_Letter);
	
	return 0;
}
