F_CPU = 20000000
MCU = atmega328p
CCOPTS= -g -Wall -Os -std=c99

default: compile

all: program

timer_driver.o: timer_driver.c timer_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) timer_driver.c -o timer_driver.o
	
motor_driver.o: motor_driver.c motor_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) motor_driver.c -o motor_driver.o

pushbutton_driver.o: pushbutton_driver.c pushbutton_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) pushbutton_driver.c -o pushbutton_driver.o

led_driver.o: led_driver.c led_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) led_driver.c -o led_driver.o

compile: main.c pushbutton_driver.o led_driver.o motor_driver.o timer_driver.o
	avr-gcc  $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -o program4 -g main.c pushbutton_driver.o led_driver.o motor_driver.o lcd_driver.o timer_driver.o
	    
hex: compile
	avr-strip program4
	avr-objcopy -R .eeprom -O ihex program4 program4.hex

program: hex
	avrdude -p m328p -c avrisp2 -P /dev/ttyACM0 -U flash:w:program4.hex

clean:
	rm program4 program4.hex pushbutton_driver.o led_driver.o motor_driver.o timer_driver.o
