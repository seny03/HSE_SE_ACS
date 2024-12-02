.include "macrolib.asm"
.include "local_macrolib.asm"
.global count_displayable_chars, count2string, uint_len, uint2string

.eqv ARRAY_SIZE 128

# Count displayable chars (ASCII codes 32 - 126) in string
# Input:
# a0 - pointer to int array of size 128 to store counts
# a1 - pointer to string (null-terminated) with symbols to count
count_displayable_chars:
    # Clear the count array (set all elements to 0)
    li t0, ARRAY_SIZE        # Number of elements in the array
    mv t1, a0                # Copy the array pointer to t1 for iteration
clear_array:
    sw zero, (t1)            # Store 0 in the current array element
    addi t1, t1, 4           # Move to the next element
    addi t0, t0, -1          # Decrement the counter
    bnez t0, clear_array     # Repeat until the entire array is cleared

# Count the displayable characters
count_loop:
    lb t0, (a1)              # Load the current character from the string
    beqz t0, count_done      # If null terminator is reached, exit the loop
    
    li t1, 32
    blt t0, t1, next_char    # If character is less than 32, skip char
    li t1, 126
    bgt t0, t1, next_char    # If character is greater than 126, skip char
    
    li t1, 4                 # Number of bytes in int
    mul t0, t0, t1           # Count offset
    
    add t1, a0, t0           # Calculate the address of the count array element
    lw t2, (t1)              # Load the current count
    addi t2, t2, 1           # Increment the count
    sw t2, (t1)              # Store the updated count back to the array

next_char:
    addi a1, a1, 1           # Move to the next character in the string
    j count_loop             # Repeat for the next character

count_done:
    ret                      # Return from the subroutine
    
    
# Counts length of uint
# Input: a0 - uint value
# Output: a0 - uint value length in string format    
uint_len:
 mv t0, a0
 li t1, 10
 li a0, 0

uint_len_loop:
 divu t0, t0, t1
 addi a0, a0, 1
 bnez t0, uint_len_loop
 
uint_len_end:
 ret

# Converts uint to string and writes it as string starting from given pointer
# Input:
# a0 - uint value
# a1 - pointer to the start position for writing 
# Output:
# a0 - pointer to the place, next after the written string
uint2string:
 mv t0, a0
 uint_len(t0)
 
 add a1, a1, a0 # pointer to the place, next after the written string
 mv a0, a1
 li t1, 10
 
uint2string_loop:
 remu t2, t0, t1
 divu t0, t0, t1
 addi t2, t2, '0' # calculate ascii value of character
 addi a1, a1, -1
 sb t2, (a1)
 bnez t0, uint2string_loop

uint2string_end:
 ret
 

# Converts array with characters count to null-terminated string in format
# <char1>: <count1>\n<char2>: <count2>\n...
# Input:
# a0 - pointer to the counts array (128 elements)
# a1 - pointer to the start of output buffer
count2string:
    mv t4, a0                  # Copy a0 (count array pointer) to t4
    li t0, ARRAY_SIZE          # Total elements in the count array
    mv t2, a1                  # Pointer to the current position in the output buffer
    li t3, 0                   # First element

format_loop:
    lw t5, (t4)                # Load count of the current character
    beqz t5, skip_char         # Skip characters with count == 0

    # Write the character to the output buffer
    sb t3, (t2)                # Store character
    addi t2, t2, 1             # Move buffer pointer

    # Write ": " to the output buffer
    li t6, ':'                 # ASCII code for ':'
    sb t6, (t2)                # Store ':'
    addi t2, t2, 1
    li t6, ' '                 # ASCII code for space
    sb t6, (t2)                # Store space
    addi t2, t2, 1

    # Convert count to a string using uint2string and write it in buffer
    uint2string(t5, t2)
    mv t2, a0                  # Update buffer pointer to the returned value

    # Write newline character '\n' to the output buffer
    li t6, '\n'                # ASCII code for newline
    sb t6, (t2)                # Store newline
    addi t2, t2, 1             # Move buffer pointer

skip_char:
    addi t4, t4, 4             # Move to the next count in the array
    addi t3, t3, 1             # Increment ASCII character
    addi t0, t0, -1            # Decrement remaining elements count
    bnez t0, format_loop       # Repeat for all characters

count2string_end:
    # Null-terminate the output string
    sb zero, (t2)              # Null terminator for the buffer
    ret                        # Return to caller


