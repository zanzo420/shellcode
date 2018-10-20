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
    .global E

    # *s, *k and x[8]
# 34 "SubByte.s"
M:

    and w10, w14, 0x80808080

    mov w12, 27
    lsr w8, w10, 7
    mul w8, w8, w12

    eor w10, w14, w10
    eor w10, w8, w10, lsl 1
    ret


SubByte:
    mov x9, lr
    uxtb w7, w13
    cbz w7, SB3

    mov w14, 1
    mov w15, 0
    mov x3, 0xFF
SB0:
    cmp w15, 0
    ccmp w14, w7, 0, eq
    bne SB1
    mov w14, 1
    mov w15, 1
SB1:
    bl M
    eor w14, w14, w10
    uxtb w14, w14
    subs x3, x3, 1
    bne SB0


    mov w7, w14
    mov x3, 4
SB2:
    lsr w10, w14, 7
    orr w14, w10, w14, lsl 1
    eor w7, w7, w14
    subs x3, x3, 1
    bne SB2
SB3:

    mov w10, 99
    eor w7, w7, w10
    bfxil w13, w7, 0, 8
    ret x9

E:
    mov x6, lr
    sub sp, sp, 32
    add x1, sp, 16

    mov w4, 1

    ldp x5, x6, [x0]
    ldp x7, x8, [x0, 16]
    stp x5, x6, [sp]
    stp x7, x8, [sp, 16]
L0:


    mov x2, 0
    ldr w13, [x1, 3*4]
L1:
    bl SubByte
    ror w13, w13, 8
    ldr w10, [sp, x2, lsl 2]
    ldr w11, [x1, x2, lsl 2]
    eor w10, w10, w11
    str w10, [x0, x2, lsl 2]
    add x2, x2, 1
    cmp x2, 4
    bne L1



    eor w13, w4, w13, ror 8
    mov x2, 0
L2:
    ldr w10, [x1, x2, lsl 2]
    eor w13, w13, w10
    str w13, [x1, x2, lsl 2]
    add x2, x2, 1
    bne L2



    cmp w4, 108
    beq L5



    mov w14, w4
    bl M
    mov w4, w10



    mov x2, 0
L3:
    ldrb w13, [x0, x2]
    bl SubByte
    and w10, w2, 3
    lsr w11, w2, 2
    sub w11, w11, w10
    and w11, w11, 3
    add w10, w10, w11, lsl 2
    uxtb w10, w10
    strb w13, [sp, x10]
    add x2, x2, 1
    cmp x2, 16
    bne L3


    cmp w4, 108
    beq L0



    mov x2, 0
L4:
    ldr w13, [sp, x2, lsl 2]
    ror w14, w13, 8
    eor w14, w14, w13
    bl M
    eor w14, w14, w13, ror 8
    eor w14, w14, w13, ror 16
    eor w14, w14, w13, ror 24
    str w14, [sp, x2, lsl 2]
    add x2, x2, 1
    cmp x2, 4
    bne L4
    b L0
L5:
    add sp, sp, 32
    ret x6
