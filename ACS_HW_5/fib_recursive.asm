.data
 out_msg: .asciz "Максимальное значение аргумента, факториал которого помещается в 32 бита: "
 ln: .asciz "\n"

.text
 .main
 main:
  li t3, 0
  li a0, 1
  jal s1, search
  mv s3, a0
  
  la a0, out_msg
  li a7, 4
  ecall
  mv a0, s3
  li a7, 1
  ecall
  la a0, ln
  li a7, 4
  ecall
  li a7, 10
  ecall
 
 search:
  addi t3, t3, 1
  mv t1, a0
  mv a0, t3
  jal factorial
  rem t2, a0, t1
  beqz  t2, search
  addi a0, t3, -1
  mv ra, s1
  ret
 
 factorial:
  bgtz a0, factorial_body
  li a0, 1
  ret
 
 factorial_body:
  addi sp, sp, -8
  sw ra, 4(sp)
  sw a0, (sp)
  
  addi a0, a0, -1
  jal factorial
  
  lw t4, (sp)
  lw ra, 4(sp)
  addi sp, sp, 8
  mul a0, a0, t4
  ret