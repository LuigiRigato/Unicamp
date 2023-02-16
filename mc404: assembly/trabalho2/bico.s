.globl puts
.globl gets
.globl atoi
.globl itoa
.globl sleep
.globl approx_sqrt
.globl set_motor
.globl set_handbreak
.globl read_camera
.globl read_sensor_distance
.globl get_position
.globl get_rotation
.globl get_time
.globl filter_1d_image
.globl display_image

.text
.align 4

set_motor:
# a0 = vertical; a1 = horizontal
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 10
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret
# a0 = status



set_handbreak:
# a0 = ativado
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 11
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret
# a0 = status


read_camera:
# a0 = buffer
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 12
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret



read_sensor_distance:
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 13
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret
# a0 = distancia



get_position:
# a0 = buffer x; a1 = buffer y; a2 = buffer z
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 15
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret



get_rotation:
# a0 = buffer x; a1 = buffer y; a2 = buffer z
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 16
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret



get_time:
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 20
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret
# a0 = tempo (ms)



display_image:
# a0 = buffer
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 19
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret



puts:
# a0 = buffer
    addi sp, sp, -16
    sw ra, (sp)

    mv a1, a0                   # a1 = buffer
    mv t1, a0
    li a2, 0

0:
    lbu t2, (t1)
    addi a2, a2, 1              # itera até o 0, aumentando o size
    addi t1, t1, 1
    bne t2, zero, 0b

    li t0, '\n'                 # deve acrescentar um \n  no final
    addi t1, t1, -1
    sb t0, (t1)

    li a0, 1
    li a7, 18
    ecall                       # a0 = fd; a1 = buffer; a2 = size

    lw ra, (sp)
    addi sp, sp, 16
    ret



gets:
# a0 = buffer
    addi sp, sp, -16
    sw ra, (sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    mv s0, a0                   # salva o buffer
    mv s1, a0                   # andando pelo buffer

0:
    li a0, 0
    mv a1, s1
    li a2, 1
    li a7, 17
    ecall                       # a0 = fd; a1 = buffer; a2 = size

    beq a0, zero, 0b            # se não leu nada e não chegou na entrada
    addi s1, s1, 1              # achou o primeiro caracter, começa a ler

1:
    li a0, 0
    mv a1, s1
    li a2, 1
    li a7, 17
    ecall                       # a0 = fd; a1 = buffer; a2 = size
    addi s1, s1, 1
    bne a0, zero, 1b            # ainda não achou o terminador

    li t1, 0
    sb  t1, -1(s1)              # trocar o \n por \0

    mv a0, s0
    lw ra, (sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 16
    ret
# a0 = buffer


atoi:
# a0 = str
    li t0, 0                    # t0 = '\0'
    li t2, 0                    # t2 = quantidade de dígitos já somados ao int
    li t3, 1
    li t4, 10
    li a1, 0                    # a1 = quantidade de dígitos
    li a2, 0                    # a2 = inteiro sendo formado
    li a3, 1                    # a3 = flag sinal positivo
    lbu t6, (a0)

    li t1, '-'
    bne t6, t1, atoiPlus        # se for negativo, dígitos negativados devem ser somados
    addi a0, a0, 1
    li a3, -1                   # a3 = flag sinal negativo
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
    mul a2, a2, a3              # se for negativo, multiplica por -1
    mv a0, a2
    ret
# a0 = int



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
    li t2, -1
    mul a0, a0, t2              # se for negativo, torna em positivo e salva o sinal

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
# a0 = buffer



sleep:
# a0 = tempo (ms)
    addi sp, sp, -16
    sw ra, (sp)
    sw s0, 4(sp)
    mv s0, a0

    call get_time
    add s0, a0, s0              # Tf = Ti + deltaT

0:
    call get_time
    blt a0, s0, 0b              # preso no loop até que o horário atual >= Tf calculado

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

0:
    divu t3, a2, a0             # y / k
    add a0, a0, t3              # k + (y / k)
    divu a0, a0, t1             # k = [k + (y / k)] / 2

    addi t0, t0, 1
    bltu t0, a1, 0b
    ret
# a0 = sqrt



filter_1d_image:
# a0 = image; a1 = filter
    li t0, 1                    # t0 = acc
    li t1, 255

    lbu a2, (a0)                # a2 = guarda anterior
    sb zero, (a0)               # borda esquerda preta
    addi a0, a0, 1

    lb t2, (a1)                 # t2 = filtro[0]
    lb t3, 1(a1)                # t3 = filtro[1]
    lb t4, 2(a1)                # t4 = filtro[2]

0:
    mul t5, a2, t2              # anterior * filtro[0]
    lbu a2, (a0)                
    
    mul t6, a2, t3              # atual * filtro[1]
    add t5, t5, t6

    lbu t6, 1(a0)
    mul t6, t6, t4              # próximo * filtro[2]
    add t5, t5, t6

    blt t5, zero, 1f
    bge t5, t1, 2f
    j 3f

1:
    li t5, 0
    j 3f

2:
    li t5, 255

3:
    sb t5, (a0)
    addi t0, t0, 1
    addi a0, a0, 1
    blt t0, t1, 0b

    sb zero, (a0)               # borda direita preta
    ret
