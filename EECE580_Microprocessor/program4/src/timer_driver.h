/*
************* timer_driver.h ×××××××××××××××××××××××
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-11-23
   Function: Interface definition for Timer driver
*/

#ifndef TIMER_DRIVER_H
#define TIMER_DRIVER_H

#include <avr/io.h>
#include <avr/interrupt.h>

#define TIMER_EN 	OCIE2A
#define TIMER_IS_EN 	OCF2A
//#define TIMER_EN 	TOIE2
//#define TIMER_IS_EN 	TOV2

/*****declear timer driver interface******/

void initialize_timer();
void timer_counting();
unsigned long get_ticks();
unsigned long get_msCount();
unsigned long get_secCount();
unsigned long get_minCount();

void start_timer();
void stop_timer();
void reset_timer();

#endif
