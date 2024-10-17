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
  li a0, 1
  li t0, 1
  jal factorial
  rem t2, a0, t1
  beqz  t2, search
  addi a0, t3, -1
  mv ra, s1
  ret
 
 factorial:
  mul a0, a0, t0
  addi t0, t0, 1
  ble  t0, t3, factorial
  ret