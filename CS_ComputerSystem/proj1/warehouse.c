#include "slots.h"
#include <stdio.h>
#include <stdlib.h>

/******************define binnode struct*****************/
typedef struct BinNode {
       int i_id;			//indicate bin id
	   int i_weight;		//weight to indicate process time of bin
       struct BinNode *p_next;
} BinNode;

/******************************Function declaration **********************************/
BinNode* createlist();
void addbin(BinNode *p_header,int bin_id);
void listbing(BinNode *p_header);
int checkbin(BinNode *p_header,int i_checkid);
void updatebinByid(BinNode *p_header,int i_id,int i_value);
int getweightByid(BinNode *p_header,int i_id);

void getOrder(BinNode *p_bin,BinNode *p_order);


/*********************create list header***********************/
BinNode* createlist()
{
    BinNode *p_create ;
    p_create = (BinNode *)(malloc(sizeof(BinNode)));
	p_create->i_id = 0;
	p_create->i_weight = 0;
	p_create->p_next = NULL ;
    return p_create;
}

/*********************add new bin node***********************/
void addbin(BinNode *p_header,int bin_id) {
	BinNode *current = NULL;
	current=p_header;
	while(current->p_next!=NULL){
		current=current->p_next;
	}
	if(current->i_id==0) {
		current->i_id=bin_id;
		current->i_weight=1;
	}
	else
	{
		/* add a new node with value */
		current->p_next=(BinNode *)malloc(sizeof(BinNode));
		current->p_next->i_id=bin_id;
		current->p_next->i_weight=1;
		current->p_next->p_next = NULL;
	}
}

/*********************dispaly bin list***********************/
void listbin(BinNode *p_header) {
	BinNode *current=p_header;
	while(current->p_next!=NULL) {
		printf("id:%d\tweight-%d\n",current->i_id,current->i_weight);
		current=current->p_next;
	}
	printf("id:%d\tweight:%d\n",current->i_id,current->i_weight);
}

/*********************check node exist***********************/
int checkbin(BinNode *p_header,int i_checkid) {
	BinNode *current=p_header;
	int isexist=0;
	while(current->p_next!=NULL) {
		if(current->i_id==i_checkid){
			isexist=1;
			break;
		}
		current=current->p_next;
	}
	if(current->i_id==i_checkid){
		isexist=1;
	}
	return isexist;
}

/*********************update weight by node id***********************/
void updatebinByid(BinNode *p_header,int i_id,int i_value) {
	BinNode *current=p_header;
	while(current->p_next!=NULL) {
		if(current->i_id==i_id){
			current->i_weight+=i_value;
		}
		current=current->p_next;
	}
	if(current->i_id==i_id){
		current->i_weight+=i_value;
	}
}

/*********************get weight by node id***********************/
int getweightByid(BinNode *p_header,int i_id) {
	BinNode *current=p_header;
	int weight=0;
	while(current->p_next!=NULL) {
		if(current->i_id==i_id){
			weight=current->i_weight;
		}
		current=current->p_next;
	}
	if(current->i_id==i_id){
		weight=current->i_weight;
	}
	return weight;
}

/********************* load order and save to bin list***********************/
void getOrder(BinNode *p_bin,BinNode *p_order) {
	int bin;
	while(1==scanf("%d",&bin)) {
		if (-1==findSlot(bin)) {
			//add order node
			addbin(p_order,bin);
			
			//add bin node
			if(checkbin(p_bin,bin)==0){
				addbin(p_bin,bin);
			}	
			else
			{
				updatebinByid(p_bin,bin,1);
			}
		}
	}
}

int main(int argc, char ** argv) {
	
	//used to save distinct bin list
	BinNode *p_binlist=NULL;
	p_binlist = createlist();
	
	//used to save order bin list
	BinNode *p_orderlist=NULL;
	p_orderlist = createlist();
	
	//load order information and create bin and order list
	getOrder(p_binlist,p_orderlist);
	
	//display bin list
	listbin(p_binlist);

	
	int bin=0;
	int slot_id=0;
	int slot_status[NUMSLOTS]={0};
	
	BinNode *p_current=NULL;
	p_current=p_orderlist;
	while(p_current->p_next!=NULL) {
		//printf("id:%d\n",p_current->i_id);
		bin=p_current->i_id;
		
		
		//slot is not full, add bin to next empty slot
		if(slot_id<NUMSLOTS) {
			if (-1==findSlot(bin)) {
				getBin(bin,slot_id);
				slot_status[slot_id]=bin;
				slot_id++;
			}
		}
		//slot is full, schedule bin exchange
		else
		{
			//if order is not in slot, switch exchange bin with warehouse side
			if (-1==findSlot(bin)) {
				int t=0;
				int tmp=0;
				int min_id=0;
				int min_weight=32767;
				//find bin with lowest weight in current work station slot list
				for(t=0;t<NUMSLOTS;t++) {
					tmp=getweightByid(p_binlist,slot_status[t]);
					if(min_weight>tmp) {
						min_weight=tmp;
						min_id=t;
					}
				}
				//switch bin with one in slot with minimum weight
				printf("Slot is full, replace slot[%d] to bin-%d\n", min_id,bin);
				getBin(bin,min_id);
				slot_status[min_id]=bin;
			}
			//printf("min id:%d-%d\n",min_id,min_weight);
		}
		getWidget(bin);
		//update p->weight to indicate finish one type of bin
		updatebinByid(p_binlist,bin,-1);
		
		//process next order
		p_current=p_current->p_next;		
	}
	
	/*********************final order**********************/
	bin=p_current->i_id;
	//update p->weight to indicate finish one type of bin
	updatebinByid(p_binlist,bin,-1);
	if (-1==findSlot(bin)) {
		getBin(bin,0);
	}
	getWidget(bin);
	printEarnings();
	
	listbin(p_binlist);		
	
	return 0;
}

