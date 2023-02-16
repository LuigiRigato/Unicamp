.globl puts
.globl gets
.globl atoi
.globl itoa
.globl time
.globl sleep
.globl approx_sqrt
.globl imageFilter
.globl exit

.text

puts:
# a0 = str
    mv a1, a0                   # a0 = ponteiro que anda pela str; a1 = endereço de início
    li t0, 0
    li a2, 0

putsLoop:
    addi a2, a2, 1              # incrementa size
    lbu t1, (a0)
    addi a0, a0, 1              # incrementa ponteiro
    bne t1, t0, putsLoop

putsEnd:
    li t1, '\n'
    addi a2, a2, 1
    sb t1, (a0)
    li a0, 1
    li a7, 64
    ecall                       # a0 = terminal; a1 = str; a2 = size; a7 = syscall number
    ret



gets:
# a0 = buffer
    mv a1, a0                   # a1 = ponteiro que anda pelo buffer
    mv t0, a0                   # t0 = endereço de início imutável
    li a2, 1                    # size = 1 bite por vez
    li a7, 63
    li t1, '\n'

getsLoop:
    li a0, 0
    ecall                       # a0 = terminal; a1 = buffer; a2 = size; a7 = syscall number
    lbu t2, (a1)
    addi a1, a1, 1              # incrementa ponteiro
    beq t2, t1, getsEnd         # se for '\n', termina
    beq a0, zero, getsEnd       # se não leu 0 bytes, EOF, termina
    j getsLoop

getsEnd:
    li t1, 0
    sb t1, -1(a1)               # substitui o '\n' por '\0'
    mv a0, t0                   # retorna ao incício do buffer
    ret



atoi:
# a0 = str
    li t0, 0                    # t0 = '\0'
    li t2, 0                    # t2 = quantidade de dígitos já somados ao int
    li t3, 1
    li t4, 10
    li a1, 0                    # a1 = quantidade de dígitos
    li a2, 0                    # a2 = inteiro sendo formado
    lbu t6, (a0)

    li t1, '-'
    bne t6, t1, atoiPlus        # se for negativo, dígitos negativados devem ser somados
    addi a0, a0, 1
    li t3, -1
    j atoiSize

atoiPlus:
    li t1, '+'
    bne t6, t1, atoiSize        # ignora o sinal de +
    addi a0, a0, 1

atoiSize:
    lbu t6, (a0)
    beq t0, t6, atoiLoop        # se não for o fim da str, aumenta o size e o ponteiro
    addi a0, a0, 1
    addi a1, a1, 1
    j atoiSize

atoiLoop:
    bge t2, a1, atoiEnd
    addi a0, a0, -1             # de trás para frente, do menos significativo pro mais
    lbu t6, (a0)
    addi t2, t2, 1              # incrementa quantidade de dígitos já computados

    addi t6, t6, -'0'           # ascii para int
    mul t6, t6, t3              # multiplica pela casa decimal
    mul t3, t3, t4
    add a2, a2, t6              # soma o dígito ao int
    j atoiLoop

atoiEnd:
    mv a0, a2
    ret



itoa:
# a0 = int; a1 = buffer; a2 = base
    mv a6, a1                   # a6 = endereço de início imutável com ou sem sinal
    mv a5, a1                   # a5 = endereço de início sem sinal
    li t0, 0
    li a3, 0                    # a3 = size
    li t4, 10
    bne a0, t0, itoaNegative    # se não for nulo, verifica se é negativo

itoaZero:
    li t1, '0'
    sb t1, (a1)
    sb t0, 1(a1)
    mv a0, a6
    ret                         # se for nulo, retorna '0'

itoaNegative:
    bge a0, t0, itoaSepDigits   # se for positivo, ou com base diferente de 10, representa unsigned
    li t2, 10
    bne a2, t2, itoaSepDigits

    li t2, '-'
    sb t2, (a1)
    addi a1, a1, 1
    addi a5, a5, 1

itoaSepDigits:
    addi a3, a3, 1
    remu t1, a0, a2
    divu a0, a0, a2
    bge t1, t4, itoaAlpha       # se a0 < 10, é de 0 a 9; se não, é uma letra
    addi t1, t1, '0'
    j itoaSaveDigits

itoaAlpha:
    addi t1, t1, -10
    addi t1, t1, 'a'

itoaSaveDigits:
    sb t1, (a1)
    addi a1, a1, 1
    bne t0, a0, itoaSepDigits   # repete até a0 = 0

itoaFstLst:
    mv a4, a1                   # a4 = antibuffer
    addi a4, a4, -1
    sub a1, a1, a3
    mv a0, a1                   # a0 será retornado como o ponteiro da str

itoaInvert:                     # inverte a str com dois ponteiros, um do começo e outro do fim
    beq a1, a4, itoaEnd
    blt a4, a1, itoaEnd
    lbu t2, (a1)
    lbu t3, (a4)
    sb t3, (a1)
    sb t2, (a4)
    addi a1, a1, 1
    addi a4, a4, -1
    j itoaInvert

itoaEnd:
    li t0, 0
    add a1, a5, a3              # a1 = endereço imutável + size = endereço do final, do \0
    sb t0, (a1)
    mv a0, a6                   # a0 = endereço de início do buffer
    ret



time:
    addi sp, sp, -32
    addi a1, sp, 12             # buffer timezone
    mv a0, sp                   # buffer timeval
    li a7, 169                  # syscall gettimeofday
    ecall

    lw t1, (sp)                 # tempo em segundos
    lw t2, 8(sp)                # fração do tempo em microssegundos
    li t3, 1000

    mul t1, t1, t3
    div t2, t2, t3
    add a0, t2, t1
    addi sp, sp, 32
    ret



sleep:
# a0 = tempo em microssegundos
    addi sp, sp, -16
    sw ra, (sp)
    sw s0, 4(sp)
    mv s0, a0

    jal time
    add s0, a0, s0              # Tf = Ti + deltaT

sleepLoop:
    jal time
    blt a0, s0, sleepLoop       # preso no loop até que o horário atual >= Tf calculado

    lw ra, (sp)
    lw s0, 4(sp)
    addi sp, sp, 16
    ret



approx_sqrt:
# a0 = int; a1 = iterations
    mv a2, a0                   # a2 = y = int imutável
    li t1, 2
    divu a0, a2, t1             # k = y / 2
    li t0, 0

sqrtLoop:
    divu t3, a2, a0             # y / k
    add a0, a0, t3              # k + (y / k)
    divu a0, a0, t1             # k = [k + (y / k)] / 2
    addi t0, t0, 1
    bltu t0, a1, sqrtLoop
    ret



imageFilter:
# a0 = image; a1 = width; a2 = height; a3 = filter
    addi sp, sp, -16
    sw ra, (sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    mul t0, a1, a2              # para alocar na pilha um múltiplo de 16; a7 = a1 * a2 + 16 - (a1 * a2) % 16
    li t1, 16
    remu a7, t0, t1
    sub a7, t0, a7
    addi a7, a7, 16
    sub sp, sp, a7              # alocar a7 de espaço para a imagem na pilha

    mv t1, sp
    mv t2, a0
    li t3, 0

storeImage:
    lbu t4, (t2)
    sb t4, (t1)
    addi t1, t1, 1
    addi t3, t3, 1
    addi t2, t2, 1
    bge t3, t0, 1f              # termina quando t3 >= a1 * a2
    j storeImage
1:
    li a4, -1                   # a4 = index linha
    mv s0, sp                   # s0 = endereço de início da imagem na pilha

forLine:
    bge a4, a2, filterEnd
    li a5, 0                    # a5 = index coluna
    addi a4, a4, 1

forColumn:
    bge a5, a1, forLine
    jal setPixel
    addi a5, a5, 1
    addi s0, s0, 1
    j forColumn

filterEnd:
    add sp, sp, a7
    lw ra, (sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 16
    ret

setPixel:
    li s1, 0x000000FF           # pixel preto
    bne a5, zero, 1f            # borda esquerda preta
    j retSetPixel
1:
    mv t0, a1
    addi t0, t0, -1
    bne a5, t0, 2f              # borda direita preta
    j retSetPixel
2:
    bne a4, zero, 3f            # borda superior preta
    j retSetPixel
3:
    mv t0, a2
    addi t0, t0, -1
    bne a4, t0, applyFilter     # borda inferior preta
    j retSetPixel

applyFilter:
# t1 = peso filtro; t2 = valor acumulado; t3 = ponteiro pixel analisado; t4 = valor pixel analisado
    lb t1, 4(a3)
    lbu t2, (s0)
    mul t2, t2, t1              # centro

    add t3, a1, 1
    sub t3, s0, t3
    lbu t4, (t3)
    lb t1, (a3)
    mul t4, t4, t1
    add t2, t2, t4              # diagonal superior esquerda

    addi t3, t3, 1
    lbu t4, (t3)
    lb t1, 1(a3)
    mul t4, t4, t1
    add t2, t2, t4              # centro superior

    addi t3, t3, 1
    lbu t4, (t3)
    lb t1, 2(a3)
    mul t4, t4, t1
    add t2, t2, t4              # diagonal superior direita

    addi t3, s0, -1
    lbu t4, (t3)
    lb t1, 3(a3)
    mul t4, t4, t1
    add t2, t2, t4              # lado esquerdo

    addi t3, s0, 1
    lbu t4, (t3)
    lb t1, 5(a3)
    mul t4, t4, t1
    add t2, t2, t4              # lado direito

    addi t3, a1, -1
    add t3, s0, t3
    lbu t4, (t3)
    lb t1, 6(a3)
    mul t4, t4, t1
    add t2, t2, t4              # diagonal inferior esquerda

    addi t3, t3, 1
    lbu t4, (t3)
    lb t1, 7(a3)
    mul t4, t4, t1
    add t2, t2, t4              # centro inferior

    addi t3, t3, 1
    lbu t4, (t3)
    lb t1, 8(a3)
    mul t4, t4, t1
    add t2, t2, t4              # diagonal inferior direita

    bge t2, zero, 5f
    li t2, 0
    j 6f
5:
    li t0, 256
    blt t2, t0, 6f
    li t2, 255
6:
    mv s1, t2

    li t0, 256
    mul s1, s1, t0              # shifta o valor do pixel de 8 bits para a esquerda
    add s1, s1, t2              # soma o valor do pixel com o valor do pixel shiftado
    mul s1, s1, t0
    add s1, s1, t2
    mul s1, s1, t0
    addi s1, s1, 0xFF           # adiciona o alpha = 255 no final

retSetPixel:
    sb s1, (a0)
    addi a0, a0, 1
    ret



exit:
# a0 = int
    li a7, 93                   # syscall exit
    ecall
