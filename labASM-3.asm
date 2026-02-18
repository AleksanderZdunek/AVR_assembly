/*
 * labASM_3.asm
 *
 *  Created: 2026-02-16 13:36:53
 *   Author: aleksander
 */
 .include "m328pdef.inc"
 .equ testvalue = 0b11101001

 .cseg
 .org 0
	rjmp reset
reset:
	//init stack pointer
	ldi r16, low(ramend)
	out spl, r16
	ldi r16, high(ramend)
	out sph, r16

	//do the thing
	ldi r17, testvalue
	rcall count_zero

stop: rjmp stop

count_zero:
	ldi r16, 0 //reset counter
	sbrs r17, 0 //skip if bit in register set
	inc r16 //increment counter
	sbrs r17, 1
	inc r16
	sbrs r17, 2
	inc r16
	sbrs r17, 3
	inc r16
	sbrs r17, 4
	inc r16
	sbrs r17, 5
	inc r16
	sbrs r17, 6
	inc r16
	sbrs r17, 7
	inc r16
	ret
