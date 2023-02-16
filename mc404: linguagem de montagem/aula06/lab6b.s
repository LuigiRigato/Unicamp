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
    li a7, 2200                 # syscall setGSPixel
    li a2, 0x000000FF           # pixel preto

    bne a0, zero, 1f            # borda esquerda preta
    ecall
    ret
1:
    mv t0, s2
    addi t0, t0, -1
    bne a0, t0, 2f              # borda direita preta
    ecall
    ret
2:
    bne a1, zero, 3f            # borda superior preta
    ecall
    ret
3:
    mv t0, s1
    addi t0, t0, -1
    bne a1, t0, 4f              # borda inferior preta
    ecall
    ret
4:
    li t0, 256                  # caso não seja borda
    li t1, 8
    lbu t2, (s0)
    mul t2, t2, t1              # pixel * 8

aplyFilter:
    add t3, s2, 1
    sub t3, s0, t3
    lbu t4, (t3) 
    sub t2, t2, t4              # - diagonal superior esquerda
    addi t3, t3, 1
    lbu t4, (t3)
    sub t2, t2, t4              # - centro superior
    addi t3, t3, 1
    lbu t4, (t3)
    sub t2, t2, t4              # - diagonal superior direita
    addi t3, s0, -1
    lbu t4, (t3)
    sub t2, t2, t4              # - lado esquerdo
    addi t3, s0, 1
    lbu t4, (t3)
    sub t2, t2, t4              # - lado direito
    addi t3, s2, -1
    add t3, s0, t3
    lbu t4, (t3)
    sub t2, t2, t4              # - diagonal inferior esquerda
    addi t3, t3, 1
    lbu t4, (t3)
    sub t2, t2, t4              # - centro inferior
    addi t3, t3, 1
    lbu t4, (t3)
    sub t2, t2, t4              # - diagonal inferior direita

    bge t2, zero, 5f
    li t2, 0
    j 6f
5:
    li t0, 256
    blt t2, t0, 6f
    li t2, 255
6:
    mv a2, t2

    li t0, 256
    mul a2, a2, t0              # shifta o valor do pixel de 8 bits para a esquerda
    add a2, a2, t2              # soma o valor do pixel com o valor do pixel shiftado
    mul a2, a2, t0
    add a2, a2, t2
    mul a2, a2, t0
    addi a2, a2, 0xFF           # adiciona o alpha = 255 no final

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
    jal setPixel
    addi a0, a0, 1
    addi s0, s0, 1
    j forColumn

end:
    li a0, 0
    li a7, 93                   # syscall exit
    ecall