.globl _start

.text
.set base, 0xFFFF0100

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
# a0 = tempo em ms
    addi sp, sp, -16
    sw ra, (sp)
    sw s0, 4(sp)
    mv s0, a0

    call time
    add s0, a0, s0              # Tf = Ti + deltaT

sleepLoop:
    call time
    blt a0, s0, sleepLoop       # preso no loop até que o horário atual >= Tf calculado

    lw ra, (sp)
    lw s0, 4(sp)
    addi sp, sp, 16
    ret



gps:
    li t0, base
    li t1, 1
    sb t1, (t0)
0:
    lb t2, (t0)
    beq t1, t2, 0b

    lw a0, 0x10(t0)             # a0 = posicao x
    lw a1, 0x18(t0)             # a1 = posicao z
    ret



move:
# a0 = comando
    li a1, base
    sb a0, 0x21(a1)
    ret



handBreak:
# a0 = comando
    li t0, base
    sb a0, 0x22(t0)
    ret



rotateVector:
# (a0, a1) = (x, z) ==> (a0, a1) = (z, -x)
    li t0, -1
    mul t0, a0, t0
    mv a0, a1
    mv a1, t0
    ret



turn:
# a0 = x deslocamento; a1 = z deslocamento; a2 = x vetor base; a3 = z vetor base 
    mul t2, a0, a2              # produto interno entre vetor rotacionado trajetória e deslocamento real
    mul t3, a1, a3
    add a4, t2, t3

    li t0, 0
    beqz a4, retTurn            # se produto interno = 0, vai
    blt a4, t0, left            # se produto interno < 0, vira esquerda
right:                          # se produto interno > 0, vira direita
    li t0, -25
    j retTurn
left:
    li t0, 25
retTurn:
    li a0, base
    sb t0, 0x20(a0)
    ret


_start:
    call gps
    mv s0, a0                   # s0 = x atual
    mv s1, a1                   # s1 = z atual
    li s2, 73                   # s2 = x final
    li s3, -19                  # s3 = z final

    li a0, 1
    call move
    li a0, 2750
    call sleep
loop:
    li a0, 0
    call move
    li a0, 90
    call sleep
    li a0, 1
    call move

    sub a0, s2, s0
    sub a1, s3, s1
    call rotateVector
    mv s4, a0                   # s4 = x trajetoria
    mv s5, a1                   # s5 = z trajetoria

    call gps
    mv t0, s0                   # t0 = x antigo
    mv t1, s1                   # t1 = z antigo
    mv s0, a0                   # s0 = x atual
    mv s1, a1                   # s1 = z atual
    sub a0, a0, t0              # a0 = x deslocamento
    sub a1, a1, t1              # a1 = z deslocamento

    mv a2, s4                   # a2 = x vetor base
    mv a3, s5                   # a3 = z vetor base
    call turn

    call gps
    sub a0, s2, a0              # a0 = distancia x do alvo
    sub a1, s3, a1              # a1 = distancia z do alvo
    mul a0, a0, a0
    mul a1, a1, a1
    add a0, a0, a1              # a0 = distancia ao alvo ao quadrado
    li t0, 225                  # t0 = 15^2
    bge a0, t0, loop

exit:
    li a0, 0
    call move
    li a0, 1
    call handBreak
    li a0, 0
    li a7, 93
    ecall
    