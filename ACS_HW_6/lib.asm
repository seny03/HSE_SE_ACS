.text
.macro strncpy(%dest, %src, %count)
 mv a0, %dest
 mv a1, %src
 mv a2, %count
 jal strncpy
.end_macro

.macro print_str(%address)
 mv a0, %address
 li a7, 4
 ecall
.end_macro 

.macro print_stri(%str)
.data 
 str: .asciz %str
.text
 la a0, str
 print_str(a0)
.end_macro 

.macro print_ln()
 print_stri("\n")
.end_macro 

.macro exit()
 li a7, 10
 ecall
.end_macro 

.macro print_inti(%int)
 li a0, %int
 li a7, 1
 ecall
.end_macro 