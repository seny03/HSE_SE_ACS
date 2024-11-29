.include "macros.asm"

.global input

.data
 eps_l: .double 1e-8 # tolerance lower bound
 eps_r: .double 1e-3 # tolerance upper bound

# Read tolerance with promt and check if it is correct and process this information
# Output:
# fa0 - tolerance
.text
input:
 read_double("Enter the tolerance, it's value must be in [1e-8, 1e-3]: ")
 
 # check tolerance, if it is out of bounds (< 0,00000001 or > 0,001) jump in incorrect branch
 
 # check if tolerance < eps_l
 la t0, eps_l
 fld ft0, (t0)
 flt.d t0, fa0, ft0
 bnez t0, incorrect
 
 # check if tolerance > eps_r
 la t0, eps_r
 fld ft0, (t0)
 flt.d t0, ft0, fa0
 bnez t0, incorrect
 
 ret

incorrect:
 print_stri("[!] Tolerance is incorrect. It must be in [1e-8, 1e-3].") # Print error message
 j end                         # End program
