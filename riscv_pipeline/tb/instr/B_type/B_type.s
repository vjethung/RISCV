  addi, x6, x6, 10
  addi x22, x22,10
  beq   x6, x22, beq_label 
  addi  x27, x0, 1         
beq_label:
  bne   x6, x12, bne_label 
  addi  x27, x0, 2      
  addi x6,x6,1   
bne_label:
  blt   x6, x12, blt_label 
  addi  x27, x0, 3         
blt_label:
  bge   x12, x6, bge_label 
  addi  x27, x0, 4         
bge_label:
  bltu  x6, x12, bltu_label
  addi  x27, x0, 5         
bltu_label:
  bgeu  x12, x6, bgeu_label
  addi  x27, x0, 6         
bgeu_label:
  jal   x28, jal_label     
  addi  x27, x0, 7         
jal_label:
  #jalr  x29, x28, 0        
  addi  x30, x0, 42        
  sw    x30, 100(x0)       
nop     
