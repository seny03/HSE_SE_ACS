.include "lib.asm"

.global print_arr

# Prints array
# Input:
# a0 - pointer to the start of the array
# a1 - number of elements in the array
print_arr:
 mv t0, a0
 mv t1, a1
 # print the start bracket of the array
 print_stri("[")
 
 # if array is empty print close bracket and return
 blez t1, print_arr_end
 
 # print first array element
 lw t3, (t0)
 print_int(t3)
 
 # go to next array element
 addi t0, t0, 4
 li t2, 1
 
 # if array contains just one element print close breacket and return
 bgeu t2, t1, print_arr_end
 
# print all elements from second to the last
for:
 print_stri(", ")
 
 lw a0, (t0)
 li a7, 1
 ecall
 
 addi t0, t0, 4
 addi t2, t2, 1
 
 bltu t2, t1, for

# print end bracket of array end return
print_arr_end:
 print_stri("]\n")
 ret
 
 
