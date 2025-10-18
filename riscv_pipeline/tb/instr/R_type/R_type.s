addi x6, x6,5
addi x7,x7, 1
add x5,x6,x7
sub x5, x6,x7
    add   x15,  x6, x7    # x5  = x6 + x7
    sub   x16,  x6, x7    # x6  = x6 - x7
    sll   x17,  x6, x7    # x7  = x6 << (x7[4:0])
    slt   x8,  x6, x7    # x8  = (x6 < x7) ? 1 : 0   (signed)
    sltu  x9,  x6, x7    # x9  = (x6 < x7) ? 1 : 0   (unsigned)
    xor   x10, x6, x7    # x10 = x6 ^ x7
    srl   x11, x6, x7    # x11 = x6 >> (x7[4:0])   (logical)
    sra   x12, x6, x7    # x12 = x6 >> (x7[4:0])   (arithmetic giữ dấu)
    or    x13, x6, x7    # x13 = x6 | x7
    and   x14, x6, x7    # x14 = x6 & x7

nop

