.include "lib.asm"

.global input

# Input:
# a0 - pointer to the start of array A
# Output:
# a0 - length of array A
input:
 mv t2, a0                    # t2 will point to elements of array A
 read_int("Enter the number of elements in array A (this number must be in [1; 10]): ") # Prompt for number of elements
 mv t0, a0                    # Move the number of elements into t0
 
 # check number of elements, if it out of bounds (< 1 or > 10) jump in incorrect branch
 blez t0, incorrect
 li t1, 10
 bgt t0, t1, incorrect
 
 li t3, 0                     # t3 will be used as a loop counter

fill:
 read_int("Enter array A element: ") # Prompt for array element
 sw a0, (t2)                  # Store the entered element into array A
 addi t2, t2, 4               # Move to the next element in array A
 addi t3, t3, 1               # Increment loop counter
 blt t3, t0, fill             # Repeat until all elements are entered
 
 mv a0, t0                    # Return the number of elements in a0
 ret                          # Return to caller

incorrect:
 print_stri("[!] Number of elements in array A is incorrect. It must be in [1; 10].") # Print error message
 j end                         # End program
