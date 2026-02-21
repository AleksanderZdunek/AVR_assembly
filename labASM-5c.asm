;
; LabASM-5c.asm
; Send and receive on serial interface
; UART Universal Asynchronous Receiver Transmitter
;
; Created: 2026-02-21 14:49:44
; Author : aleksander
;
.include "m328pdef.inc"
.equ BTN2 = PINB7
.def tmp = r16

.cseg
.org 0
init:
init_stack_pointer:
	ldi tmp, low(ramend)
	out SPL, tmp
	ldi tmp, high(ramend)
	out SPH, tmp
init_io:
	clr tmp //tmp = 0x00
	out DDRB, tmp //configure PORTB as input
	ser tmp //tmp = 0xff
	out PORTB, tmp //activate pullup resistors
	out DDRC, tmp //configure PORTC as output
	ldi tmp, (1 << PIND6) | (1 << PIND7) //configure PD6 and PD7 as output
	out DDRD, tmp
init_uart:
	clr tmp
	sts UBRR0H, tmp
	ldi tmp, 6 //Baude rate //6 = 9600, 12 = 4800, 25 = 2400
	sts UBRR0L, tmp
	ldi tmp, (1 << TXEN0) | (1 << RXEN0) | (1 << RXCIE0)
	sts UCSR0B, tmp

	rcall salute
main_loop:
	rcall uart_get_char
	sbis PINB, BTN2
	rcall uart_send_str
	rcall delay50ms
	rjmp main_loop

uart_send_str:
	uart_send_str_reset_msg_pointer:
		ldi zl, low(msg << 1)
		ldi zh, high(msg << 1)
	uart_send_str_next_char:
		lpm r19, z+
		tst r19
		breq uart_send_str_return
		rcall uart_send_char
		rjmp uart_send_str_next_char
	uart_send_str_return:
		ret

uart_send_char:
	lds tmp, UCSR0A
	sbrs tmp, UDRE0
	rjmp uart_send_char
	sts UDR0, r19
	ret

uart_get_char:
	lds tmp, UCSR0A
	sbrs tmp, RXC0
	rjmp uart_get_char_ret
	lds r18, UDR0
	rcall led_out
	uart_get_char_ret:
		ret

led_out:
	out PORTC, r18
	out PORTD, r18
	ret

delay50ms:
	/*calibrated experimentally in simulator to waste 50000 clock cycles
	which is 50ms at 1 MHz clock*/
	ldi r20, 236
	ldi r21, 65
	nop
	nop
	delay50_loop:
		dec r20
		brne delay50_loop
		dec r21
		brne delay50_loop
	ret

//flash the output leds on startup
salute:
	ldi r18,  0x80
	salute_loop:
		rcall led_out
		rcall delay50ms
		lsr r18
		brne salute_loop
	rcall led_out
	ret

msg: .db "Hello, World!", '\n' , '\r', 0
