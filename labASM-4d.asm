/*
 * labASM_4d.asm
 *
 *  Created: 2026-02-17 16:33:19
 *   Author: aleksander
 */
.include "m328pdef.inc"
.def tmp = r16
.def evens = r17
.def odds = r18
.cseg
.org 0
	rjmp init

init:
init_stack_pointer:
	ldi tmp, low(ramend)
	out SPL, tmp
	ldi tmp, high(ramend)
	out SPH, tmp
init_io:
	ldi evens, 0x55 //LEDs 0,2,4,6
	ldi odds, 0xAA //LEDs 1,3,5,7
	ser tmp //temp = 0xff
	out DDRD, tmp //configure PORTD as output
run:
	out PORTD, evens
	rcall delay2
	out PORTD, odds
	rcall delay2
	rjmp run

delay:
	ldi r20, 255
delay_loop:
	dec r20
	brne delay_loop
	ret

delay2:
	ldi r21, 255
delay_loop2:
	rcall delay
	dec r21
	brne delay_loop2
	ret
