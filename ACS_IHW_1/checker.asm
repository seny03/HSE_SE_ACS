.include "lib.asm"
.include "local_lib.asm"

.data
 array_A: .space 40 # allocate memory for 10 ints
 array_B: .space 40 # allocate memory for 10 ints
 array_B_answer: .space 40 # allocate memory for 10 ints

.text
.global checker
checker:
 la s0, array_A
 la s1, array_B
 la s2, array_B_answer
 
 print_stri("Testing...\n\n")

test_case_1:
 li s3, 1 # size of array A in this test case
 
 # setting first element
 li s4, 1
 sw s4, (s0)
 sw s4, (s2)
 
 fill_B (s0, s3, s1) # filling B
 checker (s1, s2, s3, "Size of array A is lower bound and it's elements don't end with 4:", 1) # check if B generated correctly and print the result of this check
 # display A, generated B, and correct B elements
 print_arr("A: ", s0, s3)
 print_arr("Founded B: ", s1, s3)
 print_arr("Real B: ", s1, s3)

test_case_2:
 li s3, 1 # size of array A in this test case
 
 # setting first element
 li s4, 24
 sw s4, (s0)
 li s4, 12
 sw s4, (s2)
 
 fill_B (s0, s3, s1) # filling B
 checker (s1, s2, s3, "\nSize of array A is lower_bound and it's elements end with 4", 2) # check if B generated correctly and print the result of this check
 # display A, generated B, and correct B elements
 print_arr("A: ", s0, s3)
 print_arr("Founded B: ", s1, s3)
 print_arr("Real B: ", s1, s3)

test_case_3:
 li s3, 10 # size of array A in this test case
 
 # setting first element
 li s4, 1
 sw s4, (s0)
 sw s4, (s2)
 
 # setting second element
 li s4, 2
 sw s4, 4(s0)
 sw s4, 4(s2)
 
 # setting third element
 li s4, 3
 sw s4, 8(s0)
 sw s4, 8(s2)
 
 # setting fourth element
 li s4, 4
 sw s4, 12(s0)
 li s4, 2
 sw s4, 12(s2)
 
 # setting fifth element
 li s4, 5
 sw s4, 16(s0)
 sw s4, 16(s2)
 
 # setting sixth element
 li s4, 6
 sw s4, 20(s0)
 sw s4, 20(s2)
 
 # setting seventh element
 li s4, 7
 sw s4, 24(s0)
 sw s4, 24(s2)
 
 # setting eighth element
 li s4, 8
 sw s4, 28(s0)
 sw s4, 28(s2)
 
 # setting nineth element
 li s4, 9
 sw s4, 32(s0)
 sw s4, 32(s2)
 
 # setting tenth element
 li s4, 0
 sw s4, 36(s0)
 sw s4, 36(s2)
 
 fill_B (s0, s3, s1) # filling B
 checker (s1, s2, s3, "\nSize of array A is upper bound:", 3) # check if B generated correctly and print the result of this check
 # display A, generated B, and correct B elements
 print_arr("A: ", s0, s3)
 print_arr("Founded B: ", s1, s3)
 print_arr("Real B: ", s1, s3)

test_case_4: # size of array A in this test case
 li s3, 3
 
 # setting first element
 li s4, 3
 sw s4, (s0)
 sw s4, (s2)
 
 # setting second element
 li s4, 14
 sw s4, 4(s0)
 li s4, 7
 sw s4, 4(s2)
 
 # setting third element
 li s4, 3498924
 sw s4, 8(s0)
 li s4, 1749462
 sw s4, 8(s2)
 
 fill_B (s0, s3, s1) # filling B
 checker (s1, s2, s3,  "\nArray A contains both elements end with 4 or not :", 4) # check if B generated correctly and print the result of this check
 # display A, generated B, and correct B elements
 print_arr("A: ", s0, s3)
 print_arr("Founded B: ", s1, s3)
 print_arr("Real B: ", s1, s3)

test_case_5: # size of array A in this test case
 li s3, 5
 
 # setting first element
 li s4, -1234
 sw s4, (s0)
 li s4, -617
 sw s4, (s2)
 
 # setting second element
 li s4, 2147483644
 sw s4, 4(s0)
 li s4, 1073741822
 sw s4, 4(s2)
 
 # setting third element
 li s4, 444
 sw s4, 8(s0)
 li s4, 222
 sw s4, 8(s2)
 
 # setting fourh element
 li s4, -504
 sw s4, 12(s0)
 li s4, -252
 sw s4, 12(s2)
 
 # setting fifth element
 li s4, -2147483644
 sw s4, 16(s0)
 li s4, -1073741822
 sw s4, 16(s2)
 
 fill_B (s0, s3, s1) # filling B
 checker (s1, s2, s3, "\nAll array elements end with 4 including positive and negative values and min/max elements which end is 4.", 5) # check if B generated correctly and print the result of this check
 # display A, generated B, and correct B elements
 print_arr("A: ", s0, s3)
 print_arr("Founded B: ", s1, s3)
 print_arr("Real B: ", s1, s3)
 
checker_end:
 print_stri("\nEnd of testing;")
 j end
 
  
 
