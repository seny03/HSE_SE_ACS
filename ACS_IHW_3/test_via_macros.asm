.include "macrolib.asm"
.include "local_macrolib.asm"

.data
 processing_msg: .asciz "\n[...] Processing "
 
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
 

test1:
 test(inp1, out1, processing_msg)
test2:
 test(inp2, out2, processing_msg)
test3:
 test(inp3, out3, processing_msg)
test4:
 test(inp4, out4, processing_msg)
test5:
 test(inp5, out5, processing_msg)

end:
 exit()
 
 
