/*
************* timer_driver.c ×××××××××××××××××××××××
     Author: Xu Ronghua 
       mail: rxu22@binghamton.edu
Create date: 2016-11-23
Change date: 2016-11-30
   Function: Implementation of Timer driver
*/

#include "timer_driver.h"

#define MOD_MS	100
#define MOD_SEC	1000
#define MOD_MIN	60

volatile unsigned long tickCount = 0;	// incremented by 200 every T2 OVF (units of 10 us)
volatile unsigned long msCount = 0;	// incremented by 100 every tickCount (units of 1 ms)
volatile unsigned long secCount = 0;	// incremented by 1000 every msCount (units of 1 sec)
volatile unsigned long minCount = 0;	// incremented by 60 every secCount (units of 1 min)

/*timer counter initialize: TCCR setting, generate tick frequence*/
void initialize_timer()
{	
	//TCCR2A |= 0x03;	// fast PWM, TOP = 0xFF (256)
	TCCR2A |= 0x62;	// CTC-10, set on match A-11, ,f=20MHz
	
	TCCR2B |= 0x01;	// timer2 ticks at 100KHz, 10us (prescaler = 1)

	OCR2A=199;	// OCRA = 199 (compare at counting 200)

	TIFR2=0;	//clear flag

	TIMSK2=0;	//clear flag
		
	sei();		// enable global interrupts
}

/*Timer2 OVF vect function: calculate timer tick count*/
ISR(TIMER2_OVF_vect) {
	timer_counting();	
}

/*Timer2 COMA vect function: calculate timer tick count*/
ISR(TIMER2_COMPA_vect) {
	timer_counting();
}

void timer_counting()
{
    	//calculate ms
	tickCount+=1;
	if(MOD_MS==tickCount) 
	{
		msCount++;
		tickCount=0;
	}
	//calculate sec	
	if(MOD_SEC==msCount)
	{		
		secCount++;
		msCount=0;
	}
	//calculate min	
	if(MOD_MIN==secCount)
	{
		minCount++;
		secCount=0;
	}
}

unsigned long get_ticks() { return tickCount; }
unsigned long get_msCount() { return msCount; }
unsigned long get_secCount() { return secCount; }
unsigned long get_minCount() { return minCount; }

void start_timer()
{
	TIFR2 |= (1 << TIMER_EN);	// enable timer2 interrupt
	TIMSK2 |= (1 << TIMER_IS_EN);	// set timer2 interrupt flag		
}

void stop_timer()
{	
	TIFR2 &= ~ (1 << TIMER_EN);	// disable timer2 interrupt
	TIMSK2 &= ~ (1 << TIMER_IS_EN);	// clear timer2 interrupt flag	
}

/*clear tick count*/
void reset_timer()
{
	tickCount=0;
	msCount=0;
	secCount=0;
	minCount=0;
}

