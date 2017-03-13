#include "arrayList.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
#define INITSIZE 16

bool arrayListEnlarge(arrayList list);

arrayList arrayListCreate() {
	arrayList list = (arrayList)malloc(sizeof(struct arrayListStruct));
	if (list==NULL) return list;
	list->data=(int *)malloc(sizeof(int)*INITSIZE);
	list->numUsed=0;
	list->numAlloc=INITSIZE;
	return list;
}

bool arrayListEnlarge(arrayList list) {
	list->data=(int *)realloc(list->data,sizeof(int) * (2*list->numAlloc));
	if (list->data==NULL) return false;
	list->numAlloc *=2;
	return true;
}

/* Put definitions of the other arrayList methods in arrayList.h here */
bool arrayListAdd(arrayList list, int item)
{
	if(list->numUsed>=list->numAlloc) {
		return false;
	}
	list->data[list->numUsed]=item;
	list->numUsed++;
	return true;
}


char * arrayListToString(arrayList list,char *buffer)
{
	int i=0;
	char tbuf[5]={0};
	buffer[0]='\0';
	strcat(buffer,"[");
	while(i<list->numUsed) {
		//convert int to string
		sprintf(tbuf,"%d",list->data[i]);
		strcat(buffer,tbuf);
		if(i!=list->numUsed-1) {
			strcat(buffer,",");
		}
		i++;	
	}
	strcat(buffer,"]");
	return buffer;
}

bool arrayListContains(arrayList list, int item) {
	int i=0;
	while(i<list->numUsed) {
		if(list->data[i]==item)
			return true;
		i++;
	}
	return false;
}

int arrayListIndexOf(arrayList list, int item) {
	int i=0;
	int i_index=-1;
        while(i<list->numUsed) {
		//find first item of index
                if(list->data[i]==item){
			i_index=i;	
			break;
		}
                i++;
        }
        return i_index;
}

bool arrayListIsEmpty(arrayList list) {
	if(list->numUsed==0){
               return true;
        }
        return false;
}

int arrayListGet(arrayList list,int index) {
        int i_value=-1;
	if((index>=0)&&(index<list->numUsed))
		i_value=list->data[index];
        return i_value;
}

int arrayListSet(arrayList list, int index, int item) {
        if((index<0)&&(index>=list->numUsed))
                return -1;
	list->data[index]=item;
        return 0;
}

int arrayListSize(arrayList list) {
	return list->numUsed;
}

void arrayListClear(arrayList list) {
	list->numUsed=0;
}


void arrayListFree(arrayList list) {
	free(list->data);
	free(list);
}
