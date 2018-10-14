
.arch armv8-a
.include "include.inc"

/**
.altmacro
.macro inet s:req
	local ip
        local octet
	
	ip    = 0
	octet = 0
	
	.irpc x, s
          .ifc x, .
            ip = ip | octet
            ip = ip << 8
            octet = 0 
          .else	
            octet = octet * 10 
	    octet = octet + 'x'
          .endif
	.endr
        ip = swap ip
	movz  w0, ip && 0xFFFF
        movk  w0, ip >> 16 && 0xFFFF, lsl 16
.endm
.noaltmacro
*/

.macro lds Rn, str
    ldr   \Rn, =str\@
.section .rodata
    str\@: .asciz "\str"
.text
.endm

.text
.global _start

_start:
       lds w0, /bin
       eor x0, x0, x0
