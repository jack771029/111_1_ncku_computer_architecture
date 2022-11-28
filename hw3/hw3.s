#s0-11	:save registers
#a0-7	:argument registers
#t0-6	:temp registers
.data
	test:		.word	1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
	str1:   	.string	" "
	newline:   	.string	"\n"

# a1: matrixSize
# a2: n
# a3: c
# a4: i
# a5: j
# a6: 4
# s0: matrixSize array
# s1: c * matrixSize +j
# s2: i * matrixSize +c
# s3: n * matrixSize +i
# s4: j * matrixSize +n

.text
main:
	addi	a6, x0, 4
	addi	a1, x0, 5		# matrixSize
	la      s0, test
	jal		ra, rotate

    li		a7, 10			# end the program
    ecall

rotate:
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      s0, 4(sp)
	addi	a2, a1, -1		# n = matrixSize - 1
	addi	a3, x0, 0		# c = 0
	blt		a3, a1, loop1	# c <= n (c < matrixSize)

loop:
	addi	a3, a3, 1
	addi	a2, a2, -1
	blt		a3, a1, loop1	# c <= n (c < matrixSize)
	lw      ra, 0(sp)
	lw      s0, 4(sp)
	addi    sp, sp, 8
	mul		t2, a1, a1
	add		t3, x0, x0
	j		print

loop1:
	add		a4, x0, a3		# i = c
	add		a5, x0, a2		# j = n
	blt		a4, a2, loop2	# i < n
	j		loop

loop2:
	#=========
	# s1: *((int *)matrix + c * matrixSize + j )
	mul		s1, a3, a1
	add		s1, s1, a5
	mul		s1, s1, a6		# *((int *)matrix + c * matrixSize + j )
	# int tmp = *((int *)matrix +c * matrixSize + j );
	lw      s0, 4(sp)
	add		s0, s0, s1
	lw		t0, 0(s0)
	#=========
	# s2: *((int *)matrix + i * matrixSize + c )
	mul		s2, a4, a1
	add		s2, s2, a3
	mul		s2, s2, a6
	lw      s0, 4(sp)
	add		s0, s0, s2
	lw		t1, 0(s0)		# *((int *)matrix + i * matrixSize + c )
	# *((int *)matrix + c * matrixSize + j )= *((int *)matrix + i * matrixSize + c );
	lw      s0, 4(sp)
	add		s0, s0, s1
	sw		t1, 0(s0)
	#=========
	# s3: ((int *)matrix + n * matrixSize + i )
	mul		s3, a2, a1
	add		s3, s3, a4
	mul		s3, s3, a6
	lw      s0, 4(sp)
	add		s0, s0, s3
	lw		t1, 0(s0)		# *((int *)matrix + n * matrixSize + i )
	# *((int *)matrix + i * matrixSize + c )= *((int *)matrix + n * matrixSize + i );
	lw      s0, 4(sp)
	add		s0, s0, s2
	sw		t1, 0(s0)
	#=========
	# s4: *((int *)matrix + j * matrixSize + n )
	mul		s4, a5, a1
	add		s4, s4, a2
	mul		s4, s4, a6
	lw      s0, 4(sp)
	add		s0, s0, s4
	lw		t1, 0(s0)	# *((int *)matrix + j * matrixSize + n )
	# *((int *)matrix + n * matrixSize + i )= *((int *)matrix + j * matrixSize + n );
	lw      s0, 4(sp)
	add		s0, s0, s3
	sw		t1, 0(s0)
	#=========
	# *((int *)matrix + j * matrixSize + n )= tmp;
	lw      s0, 4(sp)
	add		s0, s0, s4
	sw		t0, 0(s0)
	addi	a4, a4, 1
	addi	a5, a5, -1
	blt		a4, a2, loop2	# i < n
	j		loop
	#=========

print:
	lw		a0, 0(s0)
    li      a7, 1 			# to print int
    ecall
    la      a0, str1
    li      a7, 4               # to print string
    ecall
	addi	s0, s0, 4
	addi	t2, t2, -1
	addi	t3, t3, 1
	blt		t3, a1, continue
	add		t3, x0, x0
    la      a0, newline
    li      a7, 4               # to print string
    ecall
continue:
	blt		x0, t2, print
	jr		ra
