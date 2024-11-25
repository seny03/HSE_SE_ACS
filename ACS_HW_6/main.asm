.include "lib.asm"

.data
input_src_prompt: .asciz "Enter the source string (no more than 100 characters): "
input_count_prompt: .asciz "Enter the number of characters to copy: "
result_prompt: .asciz "Result: "
dest_manual: .space 100
src_manual: .space 100
dest_auto_1: .space 20
src_auto_1: .asciz "Test123"
expected_1: .asciz "Test1"
dest_auto_2: .space 20
src_auto_2: .asciz "Short"
expected_2: .asciz "Short"
dest_auto_3: .space 20
src_auto_3: .asciz "some string"
expected_3: .asciz "some string"
dest_auto_4: .space 20
src_auto_4: .asciz ""
expected_4: .asciz ""

.text
.global main

main:
    # Prompt user to select test mode
    print_stri("Select testing mode: 0 - manual, other integer - auto: ")
    li a7, 5 # Read integer syscall
    ecall
    mv t0, a0 # Store user choice in t0

    bnez t0 auto_testing # If non-zero, go to automated testing

manual_testing:
    # Prompt for source string
    la a0, input_src_prompt
    print_str(a0)
    la a0, src_manual
    li a1, 100 # Maximum length of input
    li a7, 8 # Read string syscall
    ecall

    # Prompt for number of characters to copy
    la a0, input_count_prompt
    print_str(a0)
    li a7, 5 # Read integer syscall
    ecall
    mv t1, a0 # Save count in t1

    # Perform strncpy
    la a0, dest_manual
    la a1, src_manual
    mv a2, t1
    strncpy(a0, a1, a2)

    # Display result
    la a0, result_prompt
    print_str(a0)
    la a0, dest_manual
    print_str(a0)
    print_ln()
    exit()

auto_testing:
    print_stri("Start testing...\n")

    # Automated testing: results are validated against expected outcomes
    # Test 1
    print_inti(1)
    la a0, dest_auto_1
    la a1, src_auto_1
    li a2, 5
    strncpy(a0, a1, a2)
    la a0, dest_auto_1
    la a1, expected_1
    jal validate_result
    
    # Test 2
    print_inti(2)
    la a0, dest_auto_2
    la a1, src_auto_2
    li a2, 10
    strncpy(a0, a1, a2)
    la a0, dest_auto_2
    la a1, expected_2
    jal validate_result
    
    # Test 3
    print_inti(3)
    la a0, dest_auto_3
    la a1, src_auto_3
    li a2, -1
    strncpy(a0, a1, a2)
    la a0, dest_auto_3
    la a1, expected_3
    jal validate_result
    
    # Test 4
    print_inti(4)
    la a0, dest_auto_4
    la a1, src_auto_4
    li a2, 1
    strncpy(a0, a1, a2)
    la a0, dest_auto_4
    la a1, expected_4
    jal validate_result

    exit()

# Validation macro: compares two strings and prints success or failure
validate_result:
    mv t0, a0 # Start comparing a0 and a1
validate_loop:
    lb t1, 0(t0)
    lb t2, 0(a1)
    bne t1, t2 validate_fail
    beqz t1 validate_success
    addi t0, t0, 1
    addi a1, a1, 1
    j validate_loop

validate_fail:
    print_stri(": [-] Test Failed")
    print_ln()
    ret

validate_success:
    print_stri(": [+] Test Passed")
    print_ln()
    ret
