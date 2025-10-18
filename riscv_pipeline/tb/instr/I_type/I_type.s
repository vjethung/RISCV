    # ---- ADDI tests ----
    addi x3, x1, 5       # x3 = x1 + 5
    addi x4, x20, -3      # x4 = x2 - 3
    addi x5, x1, 100     # x5 = x1 + 100
    addi x6, x5, -50     # x6 = x2 - 50

    # ---- XORI tests ----
    xori x7, x1, 0xFF    # x7 = x1 ^ 0xFF
    xori x8, x7, 0x0F    # x8 = x2 ^ 0x0F
    xori x9, x1, -1      # x9 = x1 ^ 0xFFFFFFFF
    xori x10, x5, 0x123  # x10 = x2 ^ 0x123

    # ---- ORI tests ----
    ori  x11, x1, 1      # x11 = x1 | 1
    ori  x12, x14, 0x80   # x12 = x2 | 0x80
    ori  x13, x1, 0x7F   # x13 = x1 | 0x7F
    ori  x14, x16, -16    # x14 = x2 | 0xFFFFFFF0

    # ---- ANDI tests ----
    andi x15, x1, 0xFF   # x15 = x1 & 0xFF
    andi x16, x15, 0x0F   # x16 = x2 & 0x0F
    andi x17, x18, -1     # x17 = x1 & 0xFFFFFFFF
    andi x18, x17, -128   # x18 = x2 & 0xFFFFFF80

    # ---- SLTI tests ----
    slti x19, x1, 0      # x19 = (x1 < 0) ? 1 : 0
    slti x20, x7, 100    # x20 = (x2 < 100) ? 1 : 0
    slti x21, x1, -5     # x21 = (x1 < -5) ? 1 : 0
    slti x22, x21, -128   # x22 = (x2 < -128) ? 1 : 0
    nop
