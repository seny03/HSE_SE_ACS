.include "macrolib.asm"
.include "local_macrolib.asm"

.data
str: .space 1024
inp_path: .asciz "Input path to file for processing: "
out_path: .asciz "Input path to file for saving the result: "
ask_message: .asciz "Print the result on console? (default No)"

.text
main:
 # display promt for read path
 la t0, inp_path
 print_str(t0)
 read_filepath() # read path to test
 
 read_file(a0) # read all text from file (filename in a0) to a0
 
 count_displayable_chars(a0) # count all displayable chars in text
 la s0, str
 count2string(a0, s0) # convert counts array to string
 
 # display promt for write path
 la t0, out_path
 print_str(t0)
 read_filepath() # read path to write result
 mv s1, a0
 
 # ask if also print on console
 la t0, ask_message
 confirm_dialog(t0)
 mv s2, a0
 
 write_file(s1, s0) # write result in file
 
 bnez s2, end # if user said print on console do this
 print_str(s0)

end:
 exit() # end program with exist status code 0
