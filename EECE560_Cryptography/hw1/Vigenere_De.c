#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char ** argv) {

	int ch, keylen, keypos=0, x, y;
	keylen=strlen(argv[1]);
	while((ch=getchar())!=EOF) {
		if(isalpha(ch)) {
			x=ch&0x1f;
			y=argv[1][keypos] & 0x1f;
			x=(x-y)%26; if( x==0 ) x=26;
			ch= (ch&0xe0) + x;
			keypos=(keypos+1)%keylen;
		}
		putchar(ch);
	}
	return 0;
}
