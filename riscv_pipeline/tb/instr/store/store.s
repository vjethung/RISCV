# --- Khởi tạo giá trị ---
addi x5, x0, 10
addi x6, x0, 20
addi x7, x0, 30
addi x8, x0, 40
addi x9, x0, 50
addi x10, x0, 60
addi x11, x0, 70
addi x12, x0, 80
addi x13, x0, 90
addi x14, x0, 100
addi x15, x0, 110
addi x16, x0, 120
addi x17, x0, 130
addi x18, x0, 140
addi x19, x0, 150
addi x20, x0, 160
addi x21, x0, 170
addi x22, x0, 180
addi x23, x0, 190
addi x24, x0, 200

# --- STORE instructions (hazard) ---
# sw hazard (ghi liên tiếp cùng base)
sw  x5,  0(x6)
sw  x7,  4(x6)     # hazard: cùng base x6
sw  x8,  8(x6)     # hazard: cùng base x6
sw  x9, 12(x6)

# sb hazard (ghi byte liên tiếp)
sb  x10, 0(x11)
sb  x12, 1(x11)    # hazard: cùng base x11
sb  x13, 2(x11)
sb  x14, 3(x11)
sb  x15, 4(x11)

# # sh hazard (ghi halfword liên tiếp)
# sh  x16, 0(x17)
# sh  x18, 2(x17)    # hazard: cùng base x17
# sh  x19, 4(x17)
# sh  x20, 6(x17)
# sh  x21, 8(x17)

# kết hợp hazard: nhiều kiểu store cùng base
sw  x22, 0(x23)
sh  x23, 0(x23)    # hazard: ghi cùng địa chỉ
sb  x24, 0(x23)    # hazard: tiếp tục ghi chồng địa chỉ
nop
