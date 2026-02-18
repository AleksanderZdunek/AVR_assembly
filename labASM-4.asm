;
; LabASM-4.asm
;
; Created: 2026-02-16 15:16:15
; Author : aleksander
;

.include "m328pdef.inc"
.def temp = r16

.cseg
.org 0
	rjmp RESET
RESET:
	ser temp //set all bits in register (temp = 0xff)
	out DDRD, temp //store register to I/O location, DDRD == 0x0a
	ldi temp, 0x80
	out PORTD, temp //PORTD	== 0x0b

stop:
	rjmp stop

