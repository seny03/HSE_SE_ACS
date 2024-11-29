.include "lib.asm"

.text
.global fill_B
# Input:
# a0 - pointer to array A
# a1 - length of array A
# a2 - pointer to array B
fill_B:
 addi sp, sp, -4              # Allocate space on stack for return address
 sw ra, (sp)                  # Save return address on stack
 
 mv t0, a0                    # t0 will point to elements in array A
 mv t1, a1                    # t1 stores the length of array A
 mv t2, a2                    # t2 will point to elements in array B
  
 li t3, 0                     # t3 is used as a loop counter

for_fill_B:
 lw a0, (t0)                  # Load array A element into a0
 jal get_next_B_value         # Call subroutine to calculate the corresponding B element
 sw a0, (t2)                  # Store the resulting B element in array B
 addi t0, t0, 4               # Move to the next element in array A
 addi t2, t2, 4               # Move to the next element in array B
 addi t3, t3, 1               # Increment loop counter
 bleu t3, t1, for_fill_B      # Continue looping while t3 <= t1

fill_B_end:
 lw ra, (sp)                  # Restore return address from stack
 addi sp, sp, 4               # Deallocate space on stack
 ret                          # Return to caller

# Subroutine to calculate the next element of array B from A
# Input:
# a0 - array A element
# Output:
# a0 - array B element (half if ends with 4, unchanged otherwise)
get_next_B_value:
 addi sp, sp, -4              # Allocate space on stack for return address
 sw ra, (sp)                  # Save return address on stack

 mv t4, a0                    # Save original value of a0 in t4 (to restore later)
 jal abs                      # Call abs to get the absolute value of a0 (for checking last digit)

 li t5, 10                    # Load 10 into t5 (for modulus operation)
 rem t6, a0, t5               # Calculate a0 % 10 to get the last digit
 mv a0, t4                    # Restore the original value of a0

 li t5, 4                     # Load 4 into t5 (to compare with the last digit)
 beq t6, t5, ends_with_4      # If the last digit is 4, branch to ends_with_4 to divide value by 2

get_next_value_end:
 lw ra, (sp)                  # Restore return address
 addi sp, sp, 4               # Deallocate space on stack
 ret                          # Return to caller

ends_with_4:
 li t5, 2                     # Load 2 into t5 (for division)
 div a0, a0, t5               # Divide a0 by 2
 j get_next_value_end         # Jump to the end of the subroutine

# Subroutine to calculate the absolute value of a number
# Input:
# a0 - number
# Output:
# a0 - absolute value of the input number
abs:
 bltz a0, change_sign          # If a0 is negative, branch to change_sign
 ret                           # Otherwise, return with a0 unchanged

change_sign:
 neg a0, a0                    # Negate a0 to get its absolute value
 ret                           # Return to caller
