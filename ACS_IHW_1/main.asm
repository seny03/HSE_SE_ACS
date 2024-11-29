.include "lib.asm"

.data
 array_A: .space 40 # allocate memory for 10 ints
 array_B: .space 40 # allocate memory for 10 ints
 
.global end # accept end program from other compiled asm files in directory
.text 
main:
 # read number of elemets in array A and array A itself
 la a0, array_A
 jal input
 
 # save number of elements in array A
 mv s0, a0
 
 # prepare to call filling B subroutine
 la a0, array_A
 mv a1, s0
 la a2, array_B
 
 jal fill_B # filling B
 
 # print the resulting array B
 print_stri("Array B: ")
 
 la a0, array_B
 mv a1, s0
 
 jal print_arr 
 

# end the program with return code 0
end:
 li a7, 10
 ecall
