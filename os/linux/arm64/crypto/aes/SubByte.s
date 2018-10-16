

    .arch armv8-a
    .text
    .global SubByte
   
    // 112 bytes
    // 
    // B SubByte(B x);
SubByte:
    uxtb     w12, w0             // x = w0 & 0xFF 
    cbz      w12, SB3

    mov      w13, 0              // c = 0
    mov      w11, 1              // y = 1
    mov      w14, 0xFF           // i = (0 - 1)
    mov      w15, 0x1B
SB0:
    cmp      w13, 0              // c == 0 &&
    ccmp     w11, w12, 0, eq     // y == x
    bne      SB1
    mov      w13, 1              // c = 1
    mov      w11, 1              // y = 1
SB1:
    // y ^= (y << 1) ^ ((y >> 7) * 27)
    lsr      w8, w11, 7
    mul      w8, w8, w15
    eor      w9, w8, w11, lsl 1
    eor      w9, w9, w11
    uxtb     w11, w9
    subs     w14, w14, 1
    bne      SB0                 // for (c=i=0,y=1;--i; y ^= M(y))

    // x=y; F(4) x ^= y = (y<<1)|(y>>7);
    mov      w12, w11            // x = y
    mov      w13, 4              // i = 4
SB2:
    lsr      w8, w11, 7
    orr      w11, w8, w11, lsl 1
    eor      w12, w12, w11
    subs     w13, w13, 1
    bne      SB2
SB3:
    // return x ^ 99
    mov      w8, 99
    eor      w0, w12, w8
    ret
