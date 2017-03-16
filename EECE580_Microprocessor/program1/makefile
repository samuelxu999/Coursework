F_CPU = 20000000
MCU = atmega328p
CCOPTS= -g -Wall -Os -std=c99

default: test

all: program
	
test: program1.c	 
	avr-gcc  $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -o program1 -g program1.c
	    
test.hex: test
	avr-strip program1
	avr-objcopy -R .eeprom -O ihex program1 program1.hex

program: test.hex
	avrdude -p m328p -c avrisp2 -P /dev/ttyACM0 -U flash:w:program1.hex

clean:
	rm program1 program1.hex 
