.global input
.include "macros.asm"

# Reading text from a file in chunks into a large buffer with truncation if needed
.eqv NAME_SIZE 256	  # Size of the buffer for the file name
.eqv SMALL_BUF_SIZE 512 # Size of the small read buffer
.eqv LARGE_BUF_SIZE 10241 # Size of the large buffer (10 KB for text + 1 byte for null terminator)
.data
 prompt: .asciz "Input path to file for processing: "     # Path to the file to be read
 er_name_mes: .asciz "Incorrect path to file.\n"
 er_read_mes: .asciz "Incorrect read operation.\n"

file_name: .space NAME_SIZE   # Name of the file to be read
smallbuf:	.space SMALL_BUF_SIZE # Small buffer for reading chunks
largebuf:   .space LARGE_BUF_SIZE # Large buffer for storing full text (with null terminator)

.text
# Reads path to input file and it's data
# Returns
# a0 - pointer to data read from file
input:
    # Display the prompt
    la a0 prompt
    print_str(a0)
    # Input the file name from the emulator console
    la	a0 file_name
    li  a1 NAME_SIZE
    li  a7 8
    ecall
    # Remove the newline character
    li	t4 '\n'
    la	t5 file_name
loop:
    lb	t6  (t5)
    beq t4 t6 replace
    addi t5 t5 1
    b	loop
replace:
    sb	zero (t5)
    
open_file:
    li   	a7 1024     	# System call to open a file
    la      a0 file_name    # Name of the file to open
    li   	a1 0        	# Open for reading (flag = 0)
    ecall             		# File descriptor in a0 or -1
    li		s1 -1			# Check for successful opening
    beq		a0 s1 er_name	# File open error
    mv   	s0 a0       	# Save the file descriptor

    # Initialize variables for large buffer reading
    la   t0 largebuf        # Address of the large buffer
    li   t1 0               # Offset counter in the large buffer

read_loop:
    # Read a chunk from the file into the small buffer
    li   a7, 63             # System call to read from a file
    mv   a0, s0             # File descriptor
    la   a1, smallbuf       # Address of the small buffer
    li   a2, SMALL_BUF_SIZE # Size of the chunk to read
    ecall                   # Read operation
    # Check if we are done reading
    beqz a0 done_reading    # If no more data is read, exit the loop
    # Check for read errors
    li   t2 -1
    beq  a0 t2 er_read      # Read error

    # Ensure we do not exceed the large buffer size (truncate if needed)
    add  t3 t1 a0           # Calculate new offset
    li   t4 LARGE_BUF_SIZE  # Total buffer size
    addi t4 t4 -1            # Maximum usable buffer space (10240)
    bgt  t3 t4 truncate     # If the new offset exceeds 10240, truncate

    # Copy the read chunk from small buffer to large buffer
    la   t5 smallbuf        # Address of the small buffer
copy_loop:
    lb   t6 (t5)            # Load byte from small buffer
    sb   t6 (t0)            # Store byte in large buffer
    addi t5 t5 1            # Increment small buffer address
    addi t0 t0 1            # Increment large buffer address
    addi t1 t1 1            # Increment large buffer offset
    addi a0 a0 -1           # Decrement remaining bytes to copy
    bnez a0 copy_loop       # Repeat until the chunk is copied

    # Continue reading the next chunk
    b    read_loop

truncate:
    # Truncate any remaining content
    li   t1 LARGE_BUF_SIZE  # Set offset to the maximum buffer size
    addi t1 t1 -1            # Adjust to fit null terminator

done_reading:
    # Add null terminator at the end of the large buffer
    la   t0 largebuf        # Start of the large buffer
    add  t0 t0 t1           # Address of the null terminator
    sb   zero (t0)

    # Close the file
    li   a7, 57             # System call to close a file
    mv   a0, s0             # File descriptor
    ecall                   # Close the file

    # Return the pointer to the large buffer
    la  a0 largebuf
    ret
er_name:
    # Message for invalid file name
    la a0 er_name_mes
    error_dialog(a0)
    # And terminate the program
    exit()
er_read:
    # Message for read error
    la a0 er_read_mes
    error_dialog(a0)
    # And terminate the program
    exit()
