/*
 * labASM_4f.asm
 * Running lights
 *
 *  Created: 2026-02-18 21:22:00
 *   Author: aleksander
 */
.include "m328pdef.inc"
.equ EVEN_BITS = 0x55
.equ ODD_BITS = 0xaa
.equ BTN1 = 6
.equ BTN2 = 7
.def tmp = r16
.def rin = r17
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
	clr tmp
	out DDRB, tmp //configure PORTB as input
	ser tmp //tmp = 0xff
	out PORTB, tmp //activate pullup resistors
	out DDRD, tmp //configure PORTD as output
run:
	lsl tmp
	tst tmp
	brne output
	ldi tmp, 0x01
output:
	out PORTD, tmp
	in rin, PINB
	rcall delay
	rjmp run

delay:
	ldi r20, 255
	ldi r21, 64
	mul r21, rin
delay_loop:
	dec r20
	brne delay_loop
	dec r1
	brne delay_loop
	ret

