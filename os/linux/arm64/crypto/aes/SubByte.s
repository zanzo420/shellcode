

    .arch armv8-a
    .text
    .global SubByte
  
    #define s  w8
    #define t  w9
    #define u w10
    #define v w11
    #define w w12
    #define x w13
    #define y w14
    #define z w15

M:
    // t = y & 0x80808080
    and     t, y, 0x80808080
    // w = (t >> 7) * 27
    mov     v, 27 
    lsr     w, t, 7
    mul     w, w, v
    // t = ((y ^ t) * 2)
    eor     t, y, t
    eor     t, w, t, lsl 1
    ret
 
    // B SubByte(B x);
SubByte:
    str      lr, [sp, -16]!
    uxtb     x, w0             // x = w0 & 0xFF 
    cbz      x, SB3

    mov      y, 1              // y = 1
    mov      z, 0             // z = 0
    mov      u, 0xFF          // u = (0 - 1)
SB0:
    cmp      z, 0              // z == 0 &&
    ccmp     y, x, 0, eq       // y == x
    bne      SB1
    mov      y, 1               // y = 1
    mov      z, 1              // z = 1
SB1:
    bl       M
    eor      y, y, t 
    uxtb     y, y 
    subs     u, u, 1
    bne      SB0                 // for (z=u=0,y=1;--u; y ^= M(y))

    // x=y; F(4) x ^= y = (y<<1)|(y>>7);
    mov      x, y              // x = y
    mov      u, 4              // u = 4
SB2:
    lsr      t, y, 7
    orr      y, t, y, lsl 1
    eor      x, x, y 
    subs     u, u, 1
    bne      SB2
SB3:
    // return x ^ 99
    mov      t, 99
    eor      x, x, t 
    bfxil    w0, x, 0, 8 
    ldr      lr, [sp], 16
    ret

    #define a x19
    #define b x20
    #define c x21
    #define d x22
    #define e x23
    #define f x24
    #define g x25
    #define h x26
    #define i x27
    #define k x28

E:
    stp      x19, x20, [sp, -16]
    stp      x21, x22, [sp, -16]
    stp      x23, x24, [sp, -16]
    stp      x25, x26, [sp, -16]
    stp      x27, x28, [sp, -16]
   
    sub      e, sp, 32
    add      k, e, 16

    mov      c, 1
    
    ldp      a, b, [s]
    ldp      c, d, [s, 16]
    stp      a, b, [e]
    stp      c, d, [e, 16]
L0:
    mov      i, 0
    ldr      a, [k, 3*4]
L1:
    bl       S 
    ror      a, a, 8
    ldr      t, [e, i, lsl 2]
    ldr      u, [k, i, lsl 2]
    eor      t, t, u
    str      t, [s, i, lsl 2]
    add      i, i, 1
    cmp      i, 4
    bne      L1

    ror      a, a, 8
    eor      a, a, c
    mov      i, 0
L2:
    ldr      t, [k, i, lsl 2]
    eor      a, a, t
    str      a, [k, i, lsl 2]
    add      i, i, 1
    bne      L2
    
    cmp      c, 108
    beq      L5

    mov      y, c
    bl       M
    mov      c, t
    
    # SubBytes and ShiftRows
    mov      i, 0
L3:
    ldrb     w0, [s, i]
    bl       S
    and      t, i, 3
    lsr      u, i, 2
    sub      u, u, t
    and      u, u, 3
    add      t, t, u, lsl 2
    strb     w, [x, t uxtw 0]
    add      i, i, 1
    cmp      i, 16
    bne      L3 

    cmp      c, 108
    beq      L0

    # MixColumns
    mov      i, 0    
L4:
    ldr      w, [x, i, lsl 2]
    ror      w, w, 8
    eor      w0, w0, w
    bl       M
    eor      w0, w0, w, ror 8
    eor      w0, w0, w, ror 16
    eor      w0, w0, w, ror 24
    str      w0, [x, i, lsl 2]
    add      i, i, 1
    cmp      i, 4
    bne      L4
    b        L0
L5:
    add      sp, sp, 32
    ldp      x27, x28, [sp], 16
    ldp      x25, x26, [sp], 16
    ldp      x23, x24, [sp], 16
    ldp      x21, x22, [sp], 16
    ldp      x19, x20, [sp], 16
    ret

