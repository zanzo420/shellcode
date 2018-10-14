	.arch armv8-a
	.file	"test2.c"
	.text
	.section	.text.startup,"ax",@progbits
	.align	2
	.global	main
	.type	main, %function
main:
.LFB5:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	ldr	x0, [x1, 8]
	str	x19, [sp, 16]
	.cfi_offset 19, -32
	mov	x19, x1
	bl	atoi
	str	w0, [sp, 40]
	ldr	x0, [x19, 16]
	bl	atoi
	strb	w0, [sp, 44]
	add	x0, sp, 40
	bl	test2
	ldr	w1, [sp, 40]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%i"
	.ident	"GCC: (Debian 8.2.0-4) 8.2.0"
	.section	.note.GNU-stack,"",@progbits
