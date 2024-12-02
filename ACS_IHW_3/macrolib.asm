.text

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

# print string from register
.macro print_str %register
.text
 mv a0, %register
 li a7, 4
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

# read double with promt message and return it in fa0
.macro read_double %string
.data
 str: .asciz %string
.text
 la a0, str
 li a7, 4
 ecall
 
 li a7, 7
 ecall
.end_macro 

# print int form the register
.macro print_int %register
.text
 mv a0, %register
 li a7, 1
 ecall
.end_macro

# print double form the register
.macro print_double %register
.text
 fmv.d  fa0, %register
 li a7, 3
 ecall
.end_macro

# print int immediate
.macro print_inti %integer
.text
 li a0, %integer
 li a7, 1
 ecall
.end_macro 

# end of program with exit status 0
.macro exit
 li a7, 10
 ecall
.end_macro 

# show RARS dialog window with message immediately
# Return:
# a0 = Yes (0), No (1), or Cancel (2)
.macro confirm_dialog(%register)
.text
 mv a0, %register
 li a7, 50
 ecall
.end_macro 

# show RARS dialog with error message
.macro error_dialog %error_register
.text
 mv a0, %error_register
 li a1, 0 # for error message
 li a7, 55 # syscall for display message to user
 ecall
.end_macro

# push register on stack
.macro push %register
.text
 addi sp, sp, -4
 sw %register, (sp)
.end_macro 

# pop register from stack
.macro pop %register
.text
 lw %register, (sp)
 addi sp, sp, 4
.end_macro


# calculate length of string before null-terminator
# Input: %string - pointer at the start of string
# Return: a0 - calculated length of string
.macro strlen %string
 push(t0)
 push(t1)
 push(t2)
 
 strlen:
    mv t2, %string
    li      t0 0      # counter
 loop:
    lb      t1 (t2)   # loading char to compare
    beqz    t1 end
    addi    t0 t0 1   # counter = counter + 1
    addi    t2 t2 1   # get next char
    b       loop
 end:
    mv      a0 t0
    
 pop(t2)
 pop(t1)
 pop(t0)
.end_macro



