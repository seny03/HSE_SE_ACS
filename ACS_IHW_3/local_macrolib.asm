.text

# Reads path to input file
# Return:
# a0 - pointer to string with filename
.macro read_filepath
.text
 push(ra)
 jal read_path
 pop(ra)
.end_macro

# Read text from file
# Input: %file_path - register with filepath
# Return: a0 - register with read data
.macro read_file %file_path
 push(ra)
 mv a0, %file_path
 jal read_file
 pop(ra) 
.end_macro

# Read text from file immediately
# Input: %file_path - file_path string
# Return: a0 - register with read data
.macro read_file_i %file_path
.data
 path: .asciz %file_path
.text
 push(ra)
 la a0, path
 jal read_file
 pop(ra) 
.end_macro

# Counts displayable chars from string
# Input: %register - register with pointer to string (null-terminated) with symbols to count
# Return: a0 - pointer to int array of size 128 whith string chars count
.macro count_displayable_chars %register
.data
 count_arr: .word 128
 arr_end:
.text
 push(ra)
 mv a1, %register
 la a0, count_arr
 jal count_displayable_chars
 la a0, count_arr
 pop(ra)
.text
.end_macro 

# Counts length of uint
# Input: %register - uint value
# Return: a0 - uint value length in string format    
.macro uint_len %register
 push(ra)
 push(t0)
 push(t1)
 
 mv a0, %register
 jal uint_len
 
 pop(t1)
 pop(t0)
 pop(ra)
.end_macro 

# Converts uint to string and writes it as string starting from given pointer
# Input:
# %uint - uint value
# %str_pointer - pointer to the start position for writing 
# Output:
# a0 - pointer to the place, next after the written string
.macro uint2string %uint, %str_pointer
 push(ra)
 push(t0)
 push(t1)
 push(t2)
 
 mv a0, %uint
 mv a1, %str_pointer
 jal uint2string
 
 pop(t2)
 pop(t1)
 pop(t0)
 pop(ra)
.end_macro 


# Converts array with characters count to null-terminated string in format
# <char1>: <count1>\n<char2>: <count2>\n...
# Input:
# %count - pointer to the counts array (128 elements)
# %buffer_ptr - pointer to the start of output buffer
.macro count2string %count %buffer_ptr
 push(ra)

 mv a0, %count
 mv a1, %buffer_ptr
 jal count2string
 
 pop(ra)
.end_macro

# Writes text in file
# Input:
# %filepath - pointer to path to file for writing
# %text - pointer to text to write in file
.macro write_file %filepath, %text
.text
 push(ra)

 mv a0, %filepath
 mv a1, %text
 
 jal write_file
 
 pop(ra)
.end_macro 