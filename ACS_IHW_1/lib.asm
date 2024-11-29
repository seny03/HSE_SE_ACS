# Unified macros

# read int with promt message and return it in a0
.macro read_int %string
.data 
 str: .asciz %string
.text
 la a0, str
 li a7, 4
 ecall
 li a7, 5
 ecall
.end_macro 

# print string immediate
.macro print_stri %string
.data
 str: .asciz %string
.text
 la a0, str
 li a7, 4
 ecall
.end_macro

# print int form the register
.macro print_int %register
.text
 mv a0, %register
 li a7, 1
 ecall
.end_macro

# print int immediate
.macro print_inti %integer
.text
 li a0, %integer
 li a7, 1
 ecall
.end_macro 

# checks array on corresponding to correct array with logs like test_name and test_num
.macro checker %array %array_answer %size %test_name %test_num
.text
 mv t0, %array
 mv t1, %array_answer
 li t2, 0
 
 # Print test name and test case
 print_stri(%test_name)
 print_stri("\nTest case ")
 print_inti(%test_num)

# for all elements of given array check if they correspond to correct array
checker_for:
 bge t2, %size, checker_for_end_ok
 lw t3, (t0)
 lw t4, (t1)
 
 addi t0, t0, 4
 addi t1, t1, 4
 addi t2, t2, 1
 
 bne t3, t4, checker_for_end_wa
 j checker_for

# if all elements correspond correct elements print OK message 
checker_for_end_ok:
 print_stri(": [+] OK!\n")
 j checker_end
# if at least one element don't correspond it's correct element print WA message
checker_for_end_wa: 
 print_stri(": [!] WA!\n")
checker_end:
.end_macro


