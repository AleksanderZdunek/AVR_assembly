clr r16
loop:
	inc r16
	rjmp 0
	.db 253, 207
	rjmp loop
