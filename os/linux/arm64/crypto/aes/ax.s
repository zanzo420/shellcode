# 1 "SubByte.s"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 32 "<command-line>" 2
# 1 "SubByte.s"


    .arch armv8-a
    .text
    .global SubByte
# 16 "SubByte.s"
M:

    and w9, w14, 0x80808080

    mov w11, 27
    lsr w12, w9, 7
    mul w12, w12, w11

    eor w9, w14, w9
    eor w9, w12, w9, lsl 1
    ret




SubByte:
    str lr, [sp, -16]!
    uxtb w13, w0
    cbz w13, SB3

    mov w14, 1
    mov w15, 0
    mov w10, 0xFF
# mov w11, 0x1B
SB0:
    cmp w15, 0
    ccmp w14, w13, 0, eq
    bne SB1
    mov w14, 1
    mov w15, 1
SB1:

# lsr w9, w14, 7
# mul w9, w9, w11
 # eor w9, w9, w14, lsl 1
    bl M
    eor w14, w14, w9
    uxtb w14, w14
    subs w10, w10, 1
    bne SB0


    mov w13, w14
    mov w10, 4
SB2:
    lsr w9, w14, 7
    orr w14, w9, w14, lsl 1
    eor w13, w13, w14
    subs w10, w10, 1
    bne SB2
SB3:

    mov w9, 99
    eor w13, w13, w9
    bfxil w0, w13, 0, 8
    ldr lr, [sp], 16
    ret
