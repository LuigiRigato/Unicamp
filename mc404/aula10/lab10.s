.globl _start
.globl logica_controle

.bss
.align 4
isr_stack:                      # Final pilha ISR
.skip 1024
isr_stack_end:                  # Base pilha ISR
stack:                          # Final pilha
.skip 1024
stack_end:                      # Base pilha

.text
.align 4
.set base, 0xFFFF0100

int_handler:
# a7 = codigo da syscall
    # Salva contexto
    csrrw sp, mscratch, sp
    addi sp, sp, -64
    sw t0, (sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw a2, 20(sp)
    sw a7, 24(sp)

    # Trata interrupção
    li t0, 10
    li t1, 11
    li t2, 15
    beq a7, t0, set_engine_and_steering
    beq a7, t1, set_handbreak
    beq a7, t2, get_position
    j int_handler_end

set_engine_and_steering:
    li t0, base
    sb a0, 0x21(t0)
    sb a1, 0x20(t0)
    j int_handler_end

set_handbreak:
    li t0, base
    sb a0, 0x22(t0)
    j int_handler_end

get_position:
    li t0, base
    li t1, 1
    sb t1, (t0)

0:
    lb t2, (t0)
    beq t1, t2, 0b

    lw a0, 0x10(t0)             # a0 = posicao x
    lw a1, 0x14(t0)             # a1 = posicao y
    lw a2, 0x18(t0)             # a2 = posicao z

int_handler_end:
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    # Restaura contexto
    lw t0, (sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw a0, 12(sp)
    lw a1, 16(sp)
    lw a2, 20(sp)
    lw a7, 24(sp)
    addi sp, sp, 64
    csrrw sp, mscratch, sp
    mret



_start:
    la t0, int_handler
    csrw mtvec, t0

    la t0, isr_stack_end
    csrw mscratch, t0

    la sp, stack_end            # inicializa a pilha

    csrr t1, mstatus            # atualiza o mstatus.MPP
    li t2, ~0x1800
    and t1, t1, t2
    csrw mstatus, t1
    la t0, user_main            # atualiza para privilégio de usuário
    csrw mepc, t0
    mret

    call user_main



gps:
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 15
    ecall
    mv a1, a2
    
    lw ra, (sp)
    addi sp, sp, 16
    ret                         # a0 = posicao x; a1 = posicao z



move:
# a0 = comando
    addi sp, sp, -16
    sw ra, (sp)

    li a1, 0
    li a7, 10
    ecall

    lw ra, (sp)
    addi sp, sp, 16
    ret



handBreak:
# a0 = comando
    addi sp, sp, -16
    sw ra, (sp)

    li a7, 11
    ecall
    
    lw ra, (sp)
    addi sp, sp, 16
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
    addi sp, sp, -16
    sw ra, (sp)

    mul t2, a0, a2              # produto interno entre vetor rotacionado trajetória e deslocamento real
    mul t3, a1, a3
    add a4, t2, t3

    beqz a4, retTurn            # se produto interno = 0, vai
    li t0, 0
    blt a4, t0, left            # se produto interno < 0, vira esquerda

right:                          # se produto interno > 0, vira direita
    li t0, -16
    j retTurn

left:
    li t0, 16

retTurn:
    li a0, 1
    mv a1, t0
    li a7, 10
    ecall

    li a0, 30000
    call sleep

    lw ra, (sp)
    addi sp, sp, 16    
    ret



sleep:
# a0 = número de repetições
    li t0, 0
0:
    addi a0, a0, -1
    blt t0, a0, 0b
    ret



logica_controle:
    addi sp, sp, -32
    sw ra, (sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    call gps
    mv s0, a0                   # s0 = x atual
    mv s1, a1                   # s1 = z atual
    li s2, 73                   # s2 = x final
    li s3, -19                  # s3 = z final

    li a0, 1
    li a1, 0
    call move
    li a0, 10000
    call sleep

loop:
    li a0, 0
    li a1, 0
    call move
    li a0, 10000
    call sleep
    li a0, 1
    li a1, 0
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

    li a0, 1
    call handBreak
    li a0, 15000
    call sleep
    li a0, 0
    call handBreak

    call gps
    sub a0, s2, a0              # a0 = distancia x do alvo
    sub a1, s3, a1              # a1 = distancia z do alvo
    mul a0, a0, a0
    mul a1, a1, a1
    add a0, a0, a1              # a0 = distancia ao alvo ao quadrado
    li t0, 225                  # t0 = 15^2
    bge a0, t0, loop

end:
    li a0, 0
    li a1, 0
    call move
    li a0, 1
    call handBreak

    lw ra, (sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 32
    ret
