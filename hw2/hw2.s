#s0-11 :save registers
#a0-7 :argument registers
#t0-6 :temp registers
.data
    str1:       .string " "
    newline:    .string "\n"
.bss
    ret_arr:    .word 0
.text
# a3 : rowIndex
# a4 : returnSize
# s2 : a value
# s3 : b value
# s4 : i count
# s5 : id count
# s6 : s0(i)point
# s7 : s0(id)point

main:
    addi    a3, x0, 0           # a3 = rowIndex
    la      s0, ret_arr         # ret_arr
    la      s1, str1
    jal     ra, getRow
    addi    t1, x0, 0           # t 1 = i
    jal     print_loop
    addi    a3, x0, 10          # a3 = rowIndex
    jal     getRow
    addi    t1, x0, 0           # t1 = i
    jal     print_loop
    addi    a3, x0, 33          # a3 = rowIndex
    la      s0, ret_arr
    la      s1, str1
    jal     getRow
    addi    t1, x0, 0           # t1 = i
    jal     print_loop
    li      a7, 10              # Halts the simulator
    ecall

getRow:
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      s0, 4(sp)           # save ret_arr head address in stack
    addi    a4, a3, 1           # a4 = returnSize; ok
    addi    s4, x0, 0           # i=0; ok
    addi    t0, x0, 1
    sw      t0, 0(s0)           # ret_arr[0]=1; ok
    lw      s6, 4(sp)           # s0(i)point
    blt     s4, a4, for_loop1   # i<returnSize (i<=rowIndex+1)
    jr ra

for_loop1:
    add     s2, x0, x0          # a=0; ok    
    addi    s3, x0, 1           # b=1; ok 
    addi    s5, x0, 0           # id=0; ok
    lw      s7, 4(sp)           # s0(id)point
    blt     s5, s4, for_loop2   # id<i

for_loop1_end:
    addi    s4, s4, 1           # i++
    addi    t0, x0, 1           # t0 = 1
    sw      t0, 0(s6)           # ret_arr[i]=1; ok
    addi    s6, s6, 4           # s0(i)point+4
    blt     s4, a4, for_loop1   # i<returnSize (i<=rowIndex+1)
    lw      s0, 4(sp)
    addi    sp,sp,4
    jr ra

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
    lw      a0, 0(s0)           # a0 used for return print number
    li      a7, 1               # to print int
    ecall
    la      a0, str1
    li      a7, 4               # to print string
    ecall
    addi    t1, t1, 1
    addi    s0, s0, 4
    j       print_loop

print_loop_end:
    la      a0, newline
    li      a7, 4               # to print string
    ecall
    jr ra
