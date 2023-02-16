.globl _start
.globl play_note
.globl _system_time
.globl main_isr

.bss
.align 4
isr_stack:                      # Final pilha ISR
.skip 1024
isr_stack_end:                  # Base pilha ISR
stack:                          # Final pilha
.skip 1024
stack_end:                      # Base pilha

.data
_system_time: .word 0

.text
.align 2
.set baseGPT, 0xFFFF0100
.set baseMIDI, 0xFFFF0300

main_isr:
   # Salva contexto
   csrrw sp, mscratch, sp
   addi sp, sp, -64
   sw t0, 0(sp)
   sw t1, 4(sp)
   sw t2, 8(sp)

   # Trata a interrupção
   li t0, baseGPT
   li t1, 1
   sw t1, (t0)
   li t2, 0
0:
   lw t1, (t0)
   bne t1, t2, 0b

   li t0, baseGPT
   lw t1, 4(t0)
   la t2, _system_time
   sw t1, (t2)

   li t1, 100
   sw t1, 8(t0)
   
   # Recupera contexto
   lw t2, 8(sp)
   lw t1, 4(sp)
   lw t0, 0(sp)

   addi sp, sp, 64
   csrrw sp, mscratch, sp
   mret



play_note:
# a0 = ch; a1 = inst; a2 = note; a3 = vel; a4 = dur
   li t0, baseMIDI
   sb a0, (t0)
   sh a1, 2(t0)
   sb a2, 4(t0)
   sb a3, 5(t0)
   sh a4, 6(t0)
   ret



_start:
   la t0, isr_stack_end
   csrw mscratch, t0

   la t0, main_isr
   csrw mtvec, t0

   csrr t0, mie
   li t1, 0x800
   or t0, t0, t1
   csrw mie, t0

   csrr t0, mstatus
   ori t0, t0, 0x8
   csrw mstatus, t0

   li t0, baseGPT
   li t1, 100
   sw t1, 8(t0)

   jal main