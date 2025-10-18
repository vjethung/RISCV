addi x2, x2, 3                      0x00310113
csrrw x0, mtvec, x2                 0x30511073
addi x4, x4, 8                      0x00820213
addi x6, x6, 16                     0x01030313
csrrs x5, mie, x4                   0x304222f3
csrrs x5, mie, x6                   0x304322f3