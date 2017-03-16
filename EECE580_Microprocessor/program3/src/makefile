F_CPU = 20000000
MCU = atmega328p
CCOPTS= -g -Wall -Os -std=c99

default: compile

all: program
	
motor_driver.o: motor_driver.c motor_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) motor_driver.c -o motor_driver.o

pushbutton_driver.o: pushbutton_driver.c pushbutton_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) pushbutton_driver.c -o pushbutton_driver.o

led_driver.o: led_driver.c led_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) led_driver.c -o led_driver.o

compile: main.c pushbutton_driver.o led_driver.o motor_driver.o
	avr-gcc  $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -o program3 -g main.c pushbutton_driver.o led_driver.o motor_driver.o
	    
hex: compile
	avr-strip program3
	avr-objcopy -R .eeprom -O ihex program3 program3.hex

program: hex
	avrdude -p m328p -c avrisp2 -P /dev/ttyACM0 -U flash:w:program3.hex

clean:
	rm program3 program3.hex pushbutton_driver.o led_driver.o motor_driver.o
