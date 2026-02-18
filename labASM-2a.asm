;
; LabASM-2.asm
;
; Created: 15-Feb-26 18:00:07
; Author : Aleksander
;

.equ EOS  = 0
.def tmp = r0
.cseg
ldi zl, low(msg << 1)
ldi zh, high(msg << 1)
ldi xl, low(msg2)
ldi xh, high(msg2)
copy_char:
	lpm tmp, z+
	st x+, tmp
	tst tmp;
	brne copy_char
quit: rjmp quit
msg: .db "Hello, World!", EOS

.dseg
.org SRAM_START
msg2: .byte 14
