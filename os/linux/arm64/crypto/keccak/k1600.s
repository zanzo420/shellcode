


		.arch armv8-a
		.text
		
		.global k1600
		
k1600:
    sub     sp, sp, 8*5
L0:
    str     xzr, [x1, x2, lsl 3]
L1:
	eor     x0, x0, x1
	str     x0, [s + 5*8]