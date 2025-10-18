addi x9,x9 trap_handler
csrrw x0, mtvec, x9
#-------bat ngat timer-----#
addi  x4, x4, 0x80    # mie.mtie = 1
csrrs x0, mie, x4
addi x6,x6, 0x8         # mstatus.mie =1
csrrs x0, mstatus, x6 
addi x8, x8, 0x00000300  #mtime
lw x9, 0(x8)
addi x9 , x9, 20
addi x10, x10, 0x00000301   #mtimecmp
sw x9, 0(x10)
main_loop:
    xor x12, x12,x12
    addi x12, x12,1
    addi x12, x12, 1
    addi x12, x12,1
    addi x12, x12, 1
    addi x12, x12,1
    addi x12, x12, 1
    addi x12, x12,1
    addi x12, x12, 1
    addi x12, x12,1
    addi x12, x12, 1
    j main_loop
    
trap_handler:
addi x5, x5,1000
lw x9, 0(x8)
addi x9, x9, 20
sw x9, 0(x10)
xori x11, x11, 0x00000001
mret

# 00160613
# 00160613
# 00160613
# 00160613
# 00160613
# 00160613
# 00160613
# 00160613
# 00160613