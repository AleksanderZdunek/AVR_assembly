/*
 * labASM_4e.asm
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
init_io:
	clr tmp
	out DDRB, tmp //configure PORTB as input
	ser tmp //tmp = 0xff
	out PORTB, tmp //activate pullup resistors
	out DDRD, tmp //configure PORTD as output

run:
	in rin, PORTB
	clr tmp
	sbrs rin, BTN1
	ori tmp, ODD_BITS
	sbrs rin, BTN2
	ori tmp, EVEN_BITS
	out PORTD, tmp
	rjmp run
