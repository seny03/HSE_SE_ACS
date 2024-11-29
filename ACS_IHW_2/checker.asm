.include "macros.asm"

.data
# Number of test cases
num_tests:
 .word 6
    
# Array of test tolerance
test_eps:
 .double 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8

correct_ans:
 .double 1.726330891422258
 
.text
check:
 la s0, test_eps
 la s1, num_tests
 lw s1, (s1)
 la s2, correct_ans
 fld fs0, (s2)

 checker(fs0, s0, s1)

end:
 li a7, 10
 ecall


