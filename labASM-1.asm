;
; LabASM-1.asm
;
; Created: 15-Feb-26 15:43:50
; Author : Aleksander
;
.include "m328pdef.inc"
.def temp = r17;

.cseg
.org 0
//	rjmp RESET

RESET:
	ldi xh, high(table)
	ldi xl, low(table)
	clr temp

loop:
	st x+, temp
	inc temp
	cpi temp, 16
	brne loop

	rjmp RESET

//stop:
//	rjmp stop
	
.dseg
.org SRAM_START
table: .byte 16	

