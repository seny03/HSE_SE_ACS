# Моделирование функции strncpy
# Input:
# a0 - destination string
# a1 - source string
# a2 - maximum amount of characters to copy
.text
.global strncpy 
strncpy:
	li t0 0 # counter
loop:
	bgeu t0 a2 end # if counter reached the a2 go to end
	lb t1 (a1) # load the current byte
	sb t1 (a0) # save current byte to the end of destination string
	beqz t1 end # if t2 == '\0' go to end
	# increase string pointers and counter
	addi a0 a0 1
	addi a1 a1 1
	addi t0 t0 1
	j loop
end:
	ret