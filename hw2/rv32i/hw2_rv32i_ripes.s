# RISC-V assembly program to print "Hello World!" to stdout.

# Provide program starting address to linker
.global _start

str1:   .string " "
newline:    .string "\n"

.data
ret_arr: .word 0,0,0,0,0,0,0,0,0,0
print_num: .word 0

.text
# a3 : rowIndex, print_count
# a4 : returnSize
# s2 : a value
# s3 : b value
# s4 : i count
# s5 : id count
# s6 : s0(i)point
# s7 : s0(id)point
# a5 : q (quotient)
# a6 : r (remainder)
# s1 : print_num_addr
# n = (0)s0 value
# ascii, intege->string + 48

_start:
    addi    a3, x0, 0           # a3 = rowIndex
	addi    a4, a3, 1           # a4 = returnSize
	la		s0, ret_arr
	lw      a1, 0(s0)           # a1 used for return print number
    jal     getRow
    addi    t1, x0, 0           # t1 = i
    jal     print_loop

    addi    a3, x0, 3           # a3 = rowIndex
	addi    a4, a3, 1           # a4 = returnSize
	la		s0, ret_arr
	lw      a1, 0(s0)           # a1 used for return print number
    jal     getRow
    addi    t1, x0, 0           # t1 = i
    jal     print_loop

    addi    a3, x0, 5           # a3 = rowIndex
	addi    a4, a3, 1           # a4 = returnSize
	la		s0, ret_arr
	lw      a1, 0(s0)           # a1 used for return print number
    jal     getRow
    addi    t1, x0, 0           # t1 = i
    jal     print_loop

    li      a7, 93              # "exit" syscall
    mv      a0, x0              # Use 0 return code
    ecall                       # invoke syscall to terminate the program

getRow:
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      s0, 4(sp)           # save ret_arr head address in stack
    addi    s4, x0, 0           # i=0
    addi    t0, x0, 1
    sw      t0, 0(s0)           # ret_arr[0]=1
    addi    s0, s0, 4           # next ret_arr
    lw      s6, 4(sp)           # s0(i)point
    blt     s4, a4, for_loop1   # i < returnSize
    jr      ra

for_loop1:
    add     s2, x0, x0          # a=0
    addi    s3, x0, 1           # b=1
    addi    s5, x0, 0           # id=0
    lw      s7, 4(sp)           # s0(id)point
    blt     s5, s4, for_loop2   # id<i

for_loop1_end:
    addi    s4, s4, 1           # i++
    addi    t0, x0, 1           # t0 = 1
    sw      t0, 0(s6)           # ret_arr[i]=1
    addi    s6, s6, 4           # s0(i)point+4
    blt     s4, a4, for_loop1   # i<returnSize (i<=rowIndex+1)
    lw      s0, 4(sp)
    addi    sp,sp,4
    jr      ra

for_loop2:
    add     t0, s2, s3          # t0 = a+b
    sw      t0, 0(s7)           # ret_arr[id]=a+b; ok
    mv      s2, s3              # a=b
    addi    s7, s7, 4           # s0(id)point+4
    lw      t0, 0(s7)
    mv      s3, t0
    addi    s5, s5, 1           # id++
    blt     s5, s4, for_loop2   # id<i
    j       for_loop1_end

print_loop: # to show the result
    bge     t1, a4, print_loop_end
    lw      a1, 0(s0)
    addi    t4, x0, 9           # t4 = 9
    addi    t5, x0, 10          # t5 = 10
    addi    a3, x0, 0           # print_count = 0
    la      s1, print_num

loop_int_to_str:
# divu10 C program # Approximation method will have some errors
#unsigned divu10(unsigned n) {
#    unsigned q, r;
#    q = (n >> 1) + (n >> 2);
#    printf("n >> 1=%d, n >> 2=%d, q= %d,\n",n >> 1, n >> 2, q);
#    q = q + (q >> 4);
#    printf("q >> 4=%d, q + (q >> 4)=%d,\n",q >> 4 ,q + (q >> 4));
#    q = q + (q >> 8);
#    printf("q >> 8=%d, q + (q >> 8)=%d,\n",q >> 8 ,q + (q >> 8));
#    q = q + (q >> 16);
#    printf("q >> 16=%d, q + (q >> 16)=%d,\n",q >> 16 ,q + (q >> 16));
#    q = q >> 3;
#    printf("q >> 3=%d,\n",q >> 3 );
#    r = n - (((q << 2) + q) << 1);
#    printf("q << 2=%d, (q << 2) + q=%d, ((q << 2) + q) << 1=%d, r=%d,\n",q << 2 ,(q << 2) + q,((q << 2) + q) << 1,n - (((q << 2) + q) << 1));
#    printf("q=%d,r > 9=%d,q + (r > 9)=%d.\n",q,r > 9,q + (r > 9) );
#    return q + (r > 9);
#}
    srli    t2, a1, 1           # n>>1
    srli    t3, a1, 2           # n>>2
    add     a5, t2, t3          # q = (n >> 1) + (n >> 2)
    srli    t2, a5, 4           # q>>4
    add     a5, a5, t2          # q = q + (q >> 4)
    srli    t2, a5, 8           # q>>8
    add     a5, a5, t2          # q = q + (q >> 8)
    srli    t2, a5, 16          # q>>16
    add     a5, a5, t2          # q = q + (q >> 16)
    srli    a5, a5, 3           # q>>3
    slli    t2, a5, 2           # q<<2
    add     t2, a5, t2          # (q << 2) + q
    slli    t2, t2, 1           # ((q << 2) + q) << 1
    sub     a6, a1, t2          # r = n - (((q << 2) + q) << 1)
    slt     t2, t4, a6          # 9<r
    add     t6, a5, t2          # q + (r > 9)

    blt     t6, t5, num_str     # quotient<10
    # mul 10 : x*10 = (x<<3) + (x<<1)
    slli    t2, t6, 3           # (t6 << 3)
    slli    t3, t6, 1           # (t6 << 1)
    add     t2, t2, t3          # t6 * 10 = (t6 << 3) + (t6 << 1)
    sub     t2, a1, t2          # t2 = n - t6, last number
    addi    t2, t2, 48          # t2->change to string ascii
    sw      t2, 0(s1)
    addi    s1, s1, 4           # next print_num addr
    addi    a3, a3, 1           # print_count+1
    mv      a1, t6
    j       loop_int_to_str

num_str:
	beq		t6, x0, q_zero      # it only happens when quotient is zero
    addi    t2, t6, 48          #change to string ascii
    sw      t2, 0(s1)
    li      a7, 64              # "write" syscall
    li      a0, 1               # 1 = standard output (stdout)
    mv      a1, s1
    li      a2, 4               # length of string
    ecall
    li      a7, 64              # "write" syscall
    li      a0, 1               # 1 = standard output (stdout)
    blt     a6, t5, lessten     #lessten
    addi    a6, a6, -10

lessten:
    addi    t2, a6, 48
    sw      t2, 0(s1)
    mv      a1, s1
    li      a2, 4               # length of string
    ecall
    blt     x0, a3, num_str_loop
    j       count_end

num_str_loop:
    li      a7, 64              # "write" syscall
    li      a0, 1               # 1 = standard output (stdout)
    mv      a1, s1
    li      a2, 4               # length of string
    ecall

count_end:
    li      a7, 64              # "write" syscall
    li      a0, 1               # 1 = standard output (stdout)
    la      a1, str1            # load address of string
    li      a2, 4               # length of string
    ecall                       # invoke syscall to print the string
    addi    s1, s1, -4          # print_num integer change to string
    addi    a3, a3, -1
    blt     x0, a3, num_str_loop
    addi    t1, t1, 1
    addi    s0, s0, 4           # ret_arr value
	j	print_loop

q_zero:
	addi	t2, a6, 48
	sw      t2, 0(s1)
	j		num_str_loop

print_loop_end:
    li a7, 64     # "write" syscall
    li a0, 1            # 1 = standard output (stdout)
    la a1, newline          # load address of string
    li a2, 4     # length of string
    ecall               # invoke syscall to print the string
    jr ra
