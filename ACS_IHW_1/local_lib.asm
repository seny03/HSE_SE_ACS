.macro fill_B %array_A %size %array_B
.text 
 # save return address to stack
 addi sp, sp, -4
 sw ra, (sp)

 mv a0, %array_A
 mv a1, %size
 mv a2, %array_B
 
 jal fill_B # filling B array
 
 # get return address from stack, delete it from stack and return
 lw ra, (sp)
 addi sp, sp, 4
.end_macro

# prints array macro over print_arr subroutine
.macro print_arr %name %array %size
.text
 print_stri(%name)
 mv a0, %array
 mv a1, %size
 jal print_arr
.end_macro 
 