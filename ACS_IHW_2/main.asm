.include "macros.asm"

.global end

main:
 jal input
 fmv.d fs0, fa0
 
 print_stri("Root of f(x), such that x in [1; 3] with specified tolerance: ")
 jal search_x
 print_double(fa0)
 
end:
 li a7, 10
 ecall