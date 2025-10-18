# --- Cấu hình trap handler ---
la   t0, trap_handler
csrw mtvec, t0          # mtvec = &trap_handler

# --- Bật ngắt timer ---
li   t0, 0x80           # MTIE = 1
csrrs x0, mie, t0
addi x1,x1, 0x8
csrrs x0, mstatus, x1       # MIE = 1

# --- Lập lịch lần ngắt đầu tiên ---
la   t1, mtime
ld   t2, 0(t1)          # t2 = mtime hiện tại
addi t2, t2, 1000    # cộng thêm chu kỳ
la   t1, mtimecmp
sd   t2, 0(t1)

# --- Vòng lặp chính ---
main_loop:
  j main_loop

# --- Trap handler ---
trap_handler:
  csrr t1, mcause
  li   t2, 0x80000007   # Machine Timer Interrupt
  beq  t1, t2, timer_isr

  mret                  # nếu không phải timer thì thoát

timer_isr:
  # cập nhật mtimecmp để ngắt lại sau 1_000_000 tick
  la   t3, mtime
  ld   t4, 0(t3)
  addi t4, t4, 1000
  la   t3, mtimecmp
  sd   t4, 0(t3)

  # chỗ này có thể tăng biến tick counter, gọi scheduler, ...
  mret
