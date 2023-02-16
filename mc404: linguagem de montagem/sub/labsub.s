.globl _start

.text

charToInt:
    addi t1, zero, '0'
    sub s4, s4, t1              # transforma o char em int
    sub s5, s5, t1
    sub s6, s6, t1
    sub s7, s7, t1

    addi t2, zero, 1000
    addi t3, zero, 100
    addi t4, zero, 10

    mul a1, t2, s4              # juntando cada digito em um numero
    mul t0, t3, s5
    mul t1, t4, s6
    add a1, a1, t0
    add a1, a1, t1
    add a1, a1, s7

    ret

iteration:
    divu t3, s8, s9             # y / k
    add s9, s9, t3              # k + (y / k)
    divu s9, s9, t0             # k = [k + (y / k)] / 2

    ret

squareRoot:
    addi t0, zero, 2

    divu s9, s8, t0             # k = y / 2

    addi t1, zero, 0
    addi t2, zero, 21

    add s11, zero, ra
loop:
    jal iteration
    addi t1, t1, 1
    bltu t1, t2, loop

    add s8, zero, s9
    jalr zero, s11, 0

calculateY:
    addi t0, zero, 2
    addi t1, zero, 3
    addi t2, zero, 10

    mul s8, a4, t1            # y = Ta * 3
    divu s8, s8, t2           # y = Ta * 3 / 10
    mul s8, s8, s8            # y = (Ta * 3 / 10) ^ 2

    mul t3, a2, a2            # Yb ^ 2
    add s8, s8, t3            # y = (Ta * 3 / 10) ^ 2 + Yb ^ 2

    mul t3, a5, t1            # Tb * 3
    divu t3, t3, t2           # Tb * 3 / 10
    mul t3, t3, t3            # (Tb * 3 / 10) ^ 2

    sub s8, s8, t3            # y = (Ta * 3 / 10) ^ 2 + Yb ^ 2 - (Tb * 3 / 10) ^ 2
    div s8, s8, t0            # y = [(Ta * 3 / 10) ^ 2 + Yb ^ 2 - (Tb * 3 / 10) ^ 2] / 2
    div s8, s8, a2            # y = [(Ta * 3 / 10) ^ 2 + Yb ^ 2 - (Tb * 3 / 10) ^ 2] / (2 * Yb)

    ret

calculateX:
    addi t0, zero, -1
    addi t1, zero, 3
    addi t2, zero, 10

    mul s8, s10, s10            # x = y ^ 2
    mul s8, s8, t0              # x = -(y ^ 2)

    mul t3, a4, t1              # Ta * 3
    divu t3, t3, t2             # Ta * 3 / 10
    mul t3, t3, t3              # (Ta * 3 / 10) ^ 2

    add s8, s8, t3              # x = (Ta * 3 / 10) ^ 2 - (y ^ 2)

    add t4, zero, ra
    jal squareRoot              # x = sqrt[(Ta * 3 / 10) ^ 2 - (y ^ 2)]
    jalr zero, t4, 0

intToChar:
    addi t2, zero, 1000
    addi t3, zero, 100
    addi t4, zero, 10

    divu s4, s8, t2             # separa os digitos
    remu t6, s8, t2
    divu s5, t6, t3
    remu t6, t6, t3
    divu s6, t6, t4
    remu s7, t6, t4

    addi t1, zero, '0'
    add s4, s4, t1              # transforma o int em char
    add s5, s5, t1
    add s6, s6, t1
    add s7, s7, t1

    ret

readXY:
    add s11, zero, ra
    jal charToInt

    addi t0, zero, '-'
    bne s3, t0, 1f
    addi t0, zero, -1
    mul a1, a1, t0

1:
    jalr zero, s11, 0

negToChar:
    addi s3, zero, '-'
    addi t2, zero, -1
    mul s8, s8, t2

    jal continua

posToChar:
    addi s3, zero, '+'

    jal continua

compareX:
    addi t0, zero, -1
    addi t1, zero, 3
    addi t2, zero, 10
    add t5, zero, s8            # salva o valor de x

    sub t5, t5, a3
    mul t5, t5, t5

    mul t3, s10, s10            # y ^ 2
    add t5, t5, t3              # (x - Xc) ^ 2 + y ^ 2

    mul t3, a6, t1              # Tc * 3
    divu t3, t3, t2             # Tc * 3 / 10
    mul t3, t3, t3              # (Tc * 3 / 10) ^ 2
    sub t5, t5, t3

    mul t6, s8, t0              # salva o valor de -x

    sub t6, t6, a3
    mul t6, t6, t6

    mul t3, s10, s10            # y ^ 2
    add t6, t6, t3              # (x - Xc) ^ 2 + y ^ 2

    mul t3, a6, t1              # Tc * 3
    divu t3, t3, t2             # Tc * 3 / 10
    mul t3, t3, t3              # (Tc * 3 / 10) ^ 2
    sub t6, t6, t3

    sub t1, t5, zero              # compara x nominal com x+ encontrado da sqrt
    sub t2, t6, zero              # compara x nominal com x- encontrado da sqrt

    mul t1, t1, t1
    mul t2, t2, t2
    bltu t1, t2, ehPos
    addi s3, zero, '-'
    ret
ehPos:
    addi s3, zero, '+'
    ret

_start:
    addi a0, zero, 0            # file descriptor = 0 (stdin)
    la a1, input                # buffer
    addi a2, zero, 0x20         # size
    addi a7, zero, 0x3f         # syscall read (63)
    ecall

    la s1, input
    la s2, output

    lbu s3, (s1)                # lendo Yb
    lbu s4, 1(s1)
    lbu s5, 2(s1)
    lbu s6, 3(s1)
    lbu s7, 4(s1)
    jal readXY
    add a2, zero, a1

    lbu s3, 6(s1)               # lendo Xc
    lbu s4, 7(s1)
    lbu s5, 8(s1)
    lbu s6, 9(s1)
    lbu s7, 10(s1)
    jal readXY
    add a3, zero, a1

    lbu s4, 12(s1)              # lendo Ta
    lbu s5, 13(s1)
    lbu s6, 14(s1)
    lbu s7, 15(s1)
    jal charToInt
    add a4, zero, a1

    lbu s4, 17(s1)              # lendo Tb
    lbu s5, 18(s1)
    lbu s6, 19(s1)
    lbu s7, 20(s1)
    jal charToInt
    add a5, zero, a1

    lbu s4, 22(s1)              # lendo Tc
    lbu s5, 23(s1)
    lbu s6, 24(s1)
    lbu s7, 25(s1)
    jal charToInt
    add a6, zero, a1

    lbu s4, 27(s1)              # lendo Tr
    lbu s5, 28(s1)
    lbu s6, 29(s1)
    lbu s7, 30(s1)
    jal charToInt
    add a7, zero, a1

    sub a4, a7, a4              # deltaT = Tr - T
    sub a5, a7, a5
    sub a6, a7, a6

    jal calculateY              # y =  (dA ^ 2 + Yb ^ 2 - dB ^ 2) / 2Yb
    add s10, zero, s8
    blt s8, zero, negToChar
    bge s8, zero, posToChar
continua:
    jal intToChar
    sb s3, 6(s2)
    sb s4, 7(s2)
    sb s5, 8(s2)
    sb s6, 9(s2)
    sb s7, 10(s2)

    jal calculateX              # x = (+ or -) sqrt(dA ^ 2 - y ^ 2)
    jal intToChar
    jal compareX
    sb s3, (s2)
    sb s4, 1(s2)
    sb s5, 2(s2)
    sb s6, 3(s2)
    sb s7, 4(s2)

    addi t1, zero, ' '
    addi t2, zero, '\n'

    sb t1, 5(s2)
    sb t2, 11(s2)

    addi a0, zero, 1            # file descriptor = 1 (stdout)
    la a1, output               # buffer
    addi a2, zero, 12           # size
    addi a7, zero, 64           # syscall write (64)
    ecall


.data
    input: .skip 34
    output: .skip 12
