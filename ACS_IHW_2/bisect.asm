.global search_x

.data
 initial_l: .double 1.0
 initial_r: .double 3.0
 half: .double 0.5
 fifth: .double 0.2
 four: 4.0
 
.text

# Input:
# ft0 - x
# Output:
# ft0 - f(x), where f(x) = x^3 - 0.5x^2 + 0.2x - 4
f_x:
 fmul.d ft9, fa0, fa0             # ft9 = x^2
 fmul.d ft10, ft9, fa0            # ft10 = x^3
 
 la t0, half
 fld ft11, (t0)
 fmul.d ft9, ft9, ft11            # ft9 = 0.5x^2
 
 
 la t0, fifth
 fld ft11, (t0)
 fmul.d ft11, ft11, fa0           # ft11 = 0.2x
 
 fsub.d fa0, ft10, ft9            # fa0 = x^3 - 0.5x^2
 fadd.d fa0, fa0, ft11            # fa0 = x^3 - 0.5x^2 + 0.2x
 
 la t0, four
 fld ft11, (t0)
 fsub.d fa0, fa0, ft11             # fa0 = x^3 - 0.5x^2 + 0.2x - 4
 
 ret

# Input: 
# ft0 - tolerance value
# Output:
# ft0 - x, such that f(x) = 0 with specified tolerance by x 
search_x:
 addi sp, sp, -4 # allocate space on stack to save return address
 sw ra, (sp) # save return address on stack
 
 fmv.d ft0, fa0 # save tolerance
 # load initial left bound
 la t0, initial_l
 fld ft1, (t0)
 
 # load initial right bound
 la t0, initial_r
 fld ft2, (t0)
 
next_iteration:
 # check if specified tolerance has achieved
 fsub.d ft3, ft2, ft1 # r - l
 # if (r - l < tolerance) end bisect search
 flt.d t0, ft3, ft0 
 bnez t0, search_x_end
 
 # else
 # m (ft3) = (l + r) / 2
 fadd.d ft3, ft1, ft2
 la t0, half
 fld ft4, (t0)
 fmul.d ft3, ft3, ft4
 
 # ft4 = f(l)
 fmv.d fa0, ft1 
 jal f_x
 fmv.d ft4, fa0
 # ft5 = f(m)
 fmv.d fa0, ft3
 jal f_x
 fmv.d ft5, fa0
 
 # ft4 = f(l) * f(m)
 fmul.d ft4, ft4, ft5
 
 fcvt.d.w ft5, zero # ft5 = 0
 # if f(l) * f(m) <= 0 move right bound to m
 fle.d t0, ft4, ft5
 bnez t0, move_right_bound
 
 # else move left bound to m
 fmv.d ft1, ft3
 j next_iteration
 
move_right_bound:
 fmv.d ft2, ft3
 j next_iteration

search_x_end:
 fmv.d fa0, ft1 # load answer to return register
 lw ra, (sp) # restore return address from stack
 addi sp, sp, 4 # deallocate space on stack
 ret # return to caller
