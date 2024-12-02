.include "macrolib.asm"
.global read_path, read_file, write_file

# Reading text from a file in chunks into a large buffer with truncation if needed
.eqv NAME_SIZE 256       # Size of the buffer for the file name
.eqv SMALL_BUF_SIZE 512  # Size of the small read buffer
.eqv LARGE_BUF_SIZE 10241 # Size of the large buffer (10 KB for text + 1 byte for null terminator)

.data
output_promt: .asciz "Input path to file for result writing: "
er_name_mes: .asciz "Incorrect path to file.\n"
er_read_mes: .asciz "Incorrect read operation.\n"

file_name: .space NAME_SIZE
smallbuf:  .space SMALL_BUF_SIZE
largebuf:  .space LARGE_BUF_SIZE
.align 2

.text

# Reads path to input file
# Return:
# a0 - pointer to string with filename
read_path:    
    # Input the file name from the emulator console
    la  a0, file_name
    li  a1, NAME_SIZE
    li  a7, 8
    ecall
    
    # Remove the newline character
    li  t0, '\n'
    la  t1, file_name
newline_loop:
    lb  t2, (t1)
    beq t0, t2, newline_replace
    addi t1, t1, 1
    b   newline_loop
newline_replace:
    sb  zero, (t1)
    la a0, file_name
    ret

# Read text from file
# Input: a0 - register with filepath
# Return: a0 - register with read data
read_file:
# Open the file
open_file:
    li   a7, 1024         # Syscall: open
    # File name steal in a0
    li   a1, 0            # Read-only
    ecall
    li   t0, -1
    beq  a0, t0, er_name  # Error if open failed
    
    mv   t3, a0           # Store file descriptor in t3

# Initialize buffer pointers
    la   t0, largebuf     # Start of large buffer
    li   t1, 0            # Offset counter

# Read loop
read_loop:
    li   a7, 63           # Syscall: read
    mv   a0, t3           # File descriptor
    la   a1, smallbuf     # Small buffer address
    li   a2, SMALL_BUF_SIZE # Buffer size
    ecall

    # Check for end of file or errors
    beqz a0, done_reading # No more data
    li   t2, -1
    beq  a0, t2, er_read  # Error during read
    
    # Ensure we do not exceed the large buffer size
    add  t4, t1, a0       # New offset
    li   t5, LARGE_BUF_SIZE
    addi t5, t5, -1       # Max buffer size - 1
    bgt  t4, t5, truncate

    # Copy from small buffer to large buffer
    la   t6, smallbuf
copy_loop:
    lb   t2, (t6)         # Load byte
    sb   t2, (t0)         # Store byte
    addi t6, t6, 1        # Increment small buffer address
    addi t0, t0, 1        # Increment large buffer address
    addi t1, t1, 1        # Increment offset
    addi a0, a0, -1       # Decrement bytes to copy
    bnez a0, copy_loop    # Repeat until done

    # Continue reading
    b    read_loop

truncate:
    li   t1, LARGE_BUF_SIZE
    addi t1, t1, -1       # Set to maximum size - 1

done_reading:
    # Null-terminate large buffer
    la   t0, largebuf
    add  t0, t0, t1
    sb   zero, (t0)

    # Close the file
    li   a7, 57           # Syscall: close
    mv   a0, t3           # File descriptor
    ecall

    # Return pointer to large buffer
    la   a0, largebuf
    ret

# Error handlers
er_name:
    la a0, er_name_mes
    error_dialog(a0)
    exit()

er_read:
    la a0, er_read_mes
    error_dialog(a0)
    exit()


# Subprogram for writing to file
# Input:
# a0 - pointer to filepath to write
# a1 - pointer to string to write in file
write_file:
    mv t0, a1
    # Open (for writing) a file that does not exist
    li   a7, 1024     # system call for open file
    li   a1, 1        # Open for writing (flags are 0: read, 1: write)
    ecall             # open a file (file descriptor returned in a0)
    mv   t1, a0       # save the file descriptor
    
    # Calculate length of buffer to write
    strlen(t0)
    mv t2, a0
    
    # Write to file just opened
    li   a7, 64       # system call for write to file
    mv   a0, t1       # file descriptor
    mv   a1, t0       # address of buffer from which to write
    mv   a2, t2       # calculated buffer length
    ecall             # write to file
    
    # Close the file
    li   a7, 57       # system call for close file
    mv   a0, t1       # file descriptor to close
    ecall             # close file
    ret





