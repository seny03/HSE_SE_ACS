.include "macrolib.asm"
.include "local_macrolib.asm"

.data
 processing_msg: .asciz "[...] Processing "
 ln: .asciz "\n"
 inp1: .asciz "data/inp1.txt"
 inp2: .asciz "data/inp2.txt"
 inp3: .asciz "data/inp3.txt"
 inp4: .asciz "data/inp4.txt"
 inp5: .asciz "data/inp5.txt"
 out1: .asciz "data/out1.txt"
 out2: .asciz "data/out2.txt"
 out3: .asciz "data/out3.txt"
 out4: .asciz "data/out4.txt"
 out5: .asciz "data/out5.txt"
 .align 2
 counts: .word 128
 res: .space 1024
 .align 2

.text 
test1:
 la t0, inp1
 la t1, processing_msg
 print_str(t1)
 print_str(t0)
 la t1, ln
 print_str(t1)
 read_file(t0)
 count_displayable_chars(a0) # count all displayable chars in text
 la s0, res
 count2string(a0, s0) # convert counts array to string
 la s1, out1
 write_file(s1, s0) # write result in file

test2:
 la t0, inp2
 la t1, processing_msg
 print_str(t1)
 print_str(t0)
 la t1, ln
 print_str(t1)
 read_file(t0)
 count_displayable_chars(a0) # count all displayable chars in text
 la s0, res
 count2string(a0, s0) # convert counts array to string
 la s1, out2
 write_file(s1, s0) # write result in file

test3:
 la t0, inp3
 la t1, processing_msg
 print_str(t1)
 print_str(t0)
 la t1, ln
 print_str(t1)
 read_file(t0)
 count_displayable_chars(a0) # count all displayable chars in text
 la s0, res
 count2string(a0, s0) # convert counts array to string
 la s1, out3
 write_file(s1, s0) # write result in file

test4:
 la t0, inp4
 la t1, processing_msg
 print_str(t1)
 print_str(t0)
 la t1, ln
 print_str(t1)
 read_file(t0)
 count_displayable_chars(a0) # count all displayable chars in text
 la s0, res
 count2string(a0, s0) # convert counts array to string
 la s1, out4
 write_file(s1, s0) # write result in file

test5:
 la t0, inp5
 la t1, processing_msg
 print_str(t1)
 print_str(t0)
 la t1, ln
 print_str(t1)
 read_file(t0)
 count_displayable_chars(a0) # count all displayable chars in text
 la s0, res
 count2string(a0, s0) # convert counts array to string
 la s1, out5
 write_file(s1, s0) # write result in file

end:
 exit()

 
 
