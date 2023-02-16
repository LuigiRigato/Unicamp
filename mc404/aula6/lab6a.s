.globl _start

.data
input: .asciz "imagem.pgm"
matriz: .skip 262159

.text
open:
    la a0, input                # endereço do caminho para o arquivo
    li a1, 0                    # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0                    # modo
    li a7, 1024                 # syscall open 
    ecall
    ret

read:
    la a1, matriz               # buffer
    li a2, 262159               # size
    li a7, 63                   # syscall read
    ecall
    ret

findXY:
    li t1, 10
    li s1, 0
readDigit:
    lbu t2, (s0)
    beq a0, t2, 1f
    addi t2, t2, -'0'
    mul s1, s1, t1
    add s1, s1, t2
    addi s0, s0, 1
    j readDigit
1:
    addi s0, s0, 1
    ret

setPixel:
    li t0, 256
    mv t1, a2

    mul a2, a2, t0
    add a2, a2, t1
    mul a2, a2, t0
    add a2, a2, t1
    mul a2, a2, t0
    addi a2, a2, 0xFF

    li a7, 2200                 # syscall setGSPixel
    ecall
    ret

setCanvasSize:
    mv a0, s2
    mv a1, s1
    li a7, 2201                 # syscall setGSCanvasSize
    ecall
    ret

_start:

    jal open
    jal read

    la s0, matriz                # s0 é o apontador do buffer
    addi s0, s0, 3
    li a0, ' '
    jal findXY
    mv s2, s1                   # s2 = x = colunas
    li a0, '\n'
    jal findXY                  # s1 = y = linhas
    addi s0, s0, 4
    jal setCanvasSize

    li a1, -1                   # a1 = index linha
forLine:
    bge a1, s1, end
    li a0, 0                    # a0 = index coluna
    addi a1, a1, 1
forColumn:
    bge a0, s2, forLine
    lbu a2, (s0)
    jal setPixel
    addi a0, a0, 1
    addi s0, s0, 1
    j forColumn

end:
    li a0, 0
    li a7, 93                   # syscall exit
    ecall