#
#  Copyright © 2018 Odzhan. All Rights Reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are
#  met:
#
#  1. Redistributions of source code must retain the above copyright
#  notice, this list of conditions and the following disclaimer.
#
#  2. Redistributions in binary form must reproduce the above copyright
#  notice, this list of conditions and the following disclaimer in the
#  documentation and/or other materials provided with the distribution.
#
#  3. The name of the author may not be used to endorse or promote products
#  derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
#  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#  SERVICES# LOSS OF USE, DATA, OR PROFITS# OR BUSINESS INTERRUPTION)
#  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
#  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
#  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#
# -----------------------------------------------
# Subtraction of 256-bit integers modulo 2^256-38
#
# size: 54 bytes
#
# -----------------------------------------------
                .arch armv8-a
                .text
                
                .global submod
                
                ; void submod(void *r, void *a, void *b);
submod:
                # load a
                ldp    x3, x4, [x1] 
                ldp    x5, x6, [x1, 16]
                
                # load b
                ldp    x7, x8, [x2]
                ldp    x9, x10, [x2, 16]
                
                # perform subtraction
                subs   x3, x3, x7
                sbcs   x4, x4, x8
                sbcs   x5, x5, x9
                sbcs   x6, x6, x10
                
                # apply reduction
                mov    x7, 38
                csel   x8, x7, xzr, mi
                
                subs   x3, x3, x8
                sbcs   x4, x4, xzr
                sbcs   x5, x5, xzr
                sbcs   x6, x6, xzr
                
                csel   x8, x7, xzr, mi
                sub    x3, x3, x8
                
                str    x3, x4, [x0]
                str    x5, x6, [x0, 16]
                ret
