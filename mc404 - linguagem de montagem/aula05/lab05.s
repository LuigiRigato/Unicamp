.globl _start

.text

aproximate:
    divu a5, a1, a4             # y / k
    add a4, a4, a5              # k + (y / k)
    divu a4, a4, t5             # k = [k + (y / k)] / 2

    ret

squareRoot:
    addi t1, zero, '0'
    sub s1, s1, t1              # transforma o char em int
    sub s2, s2, t1
    sub s3, s3, t1
    sub s4, s4, t1

    addi t2, zero, 0x3e8        # 1000
    addi t3, zero, 0x64         # 100
    addi t4, zero, 0xa          # 10

    mul a1, t2, s1              # juntando cada digito em um numero
    mul a2, t3, s2
    mul a3, t4, s3
    add a1, a1, a2
    add a1, a1, a3
    add a1, a1, s4

    addi t5, zero, 0x2
    divu a4, a1, t5             # k = y / 2

    add s11, zero, ra           # salva o ra pois a funcao aproxima altera o ra

    addi t6, zero, 0
loop:
    jal aproximate
    addi t6, t6, 1
    bltu t6, t4, loop

intToChar:
    divu s1, a4, t2             # separa os digitos
    remu t6, a4, t2
    divu s2, t6, t3
    remu t6, t6, t3
    divu s3, a4, t4
    remu s4, t6, t4

    add s1, s1, t1              # transforma o int em char
    add s2, s2, t1
    add s3, s3, t1
    add s4, s4, t1

    jalr zero, s11, 0

_start:
    addi a0, zero, 0            # file descriptor = 0 (stdin)
    la a1, input                # buffer
    addi a2, zero, 0x14         # size
    addi a7, zero, 0x3f         # syscall read (63)
    ecall

    la s9, input
    la s10, output

    lbu s1, (s9)                # pega digito a digito para entrar na funcao e depois armazena digito a digito
    lbu s2, 1(s9)
    lbu s3, 2(s9)
    lbu s4, 3(s9)
    jal squareRoot
    sb s1, (s10)
    sb s2, 1(s10)
    sb s3, 2(s10)
    sb s4, 3(s10)

    lbu s1, 5(s9)
    lbu s2, 6(s9)
    lbu s3, 7(s9)
    lbu s4, 8(s9)
    jal squareRoot
    sb s1, 5(s10)
    sb s2, 6(s10)
    sb s3, 7(s10)
    sb s4, 8(s10)

    lbu s1, 10(s9)
    lbu s2, 11(s9)
    lbu s3, 12(s9)
    lbu s4, 13(s9)
    jal squareRoot
    sb s1, 10(s10)
    sb s2, 11(s10)
    sb s3, 12(s10)
    sb s4, 13(s10)

    lbu s1, 15(s9)
    lbu s2, 16(s9)
    lbu s3, 17(s9)
    lbu s4, 18(s9)
    jal squareRoot
    sb s1, 15(s10)
    sb s2, 16(s10)
    sb s3, 17(s10)
    sb s4, 18(s10)

    addi t1, zero, ' '
    addi t2, zero, '\n'

    sb t1, 4(s10)
    sb t1, 9(s10)
    sb t1, 14(s10)
    sb t2, 19(s10)

    addi a0, zero, 1            # file descriptor = 1 (stdout)
    la a1, output               # buffer
    addi a2, zero, 20           # size
    addi a7, zero, 64           # syscall write (64)
    ecall


.data
    input: .skip 0x16
    output: .skip 0x16
