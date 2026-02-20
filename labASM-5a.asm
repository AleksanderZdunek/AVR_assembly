;
; LabASM-5a.asm
; Send a character over serial interface
; UART Universal Asynchronous Receiver Transmitter
;
; Created: 2026-02-20 13:52:37
; Author : aleksander
;
.include "m328pdef.inc"
.def tmp = r16

init:
init_stack_pointer:
	ldi tmp, low(ramend)
	out SPL, tmp
	ldi tmp, high(ramend)
	out SPH, tmp
init_uart:
	clr tmp
	sts UBRR0H, tmp
	ldi tmp, 6 //Baude rate //6 = 9600, 12 = 4800, 25 = 2400
	sts UBRR0L, tmp
	ldi tmp, (1 << TXEN0) | (1 << RXEN0) | (1 << RXCIE0)
	//ldi tmp, 1 << TXEN0 //just enable serial transmission
	sts UCSR0B, tmp

main_loop:
	ldi r19, 'B'	//load char to send
	rcall uart_send_char
	rcall delay500ms
	rjmp main_loop

uart_send_char:
	lds tmp, UCSR0A
	sbrs tmp, UDRE0
	rjmp uart_send_char
	sts UDR0, r19
	ret

delay500ms:
	//assuming a clockrate 1 MHz
	//there has to be a less dumb way of doing this
	//calling this in the main loop will drift anyway since I don't account for the cycles of the whole loop
	ldi r20, 84
	ldi r21, 138
	ldi r22, 3
	nop
	delay_loop:
		dec r20
		brne delay_loop
		dec r21
		brne delay_loop
		dec r22
		brne delay_loop
	ret

