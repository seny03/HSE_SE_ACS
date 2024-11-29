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

# checks that root value founds correctly according to diffirient tolerance values
.macro checker %correct_answer %tolerance_array %size
.text
 mv t3, %tolerance_array
 li t4, 0

# for all tolerance values check if found root correspond them
checker_for:
 bge t4, %size, checker_end
 
 fld ft6, (t3)
 
 addi t3, t3, 8
 addi t4, t4, 1
 
 print_stri("\nTest case ")
 print_int(t4)
 print_stri(", tolerance = ")
 print_double(ft6)
 
 fmv.d fa0, ft6
 jal search_x
 fsub.d ft7, fa0, %correct_answer
 fabs.d ft7, ft7
 
 print_stri("\nDiffirience = ")
 print_double(ft7)
 
 fle.d t5, ft7, ft6
 beqz t5, wa
 print_stri(": [+] OK!\n")
 j checker_for

# if diffirience between found and correct values more that tolerance, print WA message
wa: 
 print_stri(": [!] WA!\n")
 j checker_for
checker_end:
.end_macro

# end of program with exit status 0
.macro exit
 li a7, 10
 ecall
.end_macro 

# show RARS dialog window with message immediately
# Return:
# a0 = Yes (0), No (1), or Cancel (2)
.macro confirm_dialogi %message
.data
 message: .asciz %message
.text
 la a0, message
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


