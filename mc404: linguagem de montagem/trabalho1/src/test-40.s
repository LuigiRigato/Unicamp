.globl _start
 
_start:
  li a0, 134985  #<<<=== Coloque o número do seu RA aqui
  li a1, 0
  li a2, 0
  li a3, -1
loop:
  andi t0, a0, 1
  add  a1, a1, t0
  xor  a2, a2, t0
  addi a3, a3, 1
  srli a0, a0, 1
  fence r, rw
  fence iorw, ow
  fence orw, iow
  fence.i
  fence.i
  ebreak
  bnez a0, loop
  div a3, a1, a2
  lr.w a2, (a5)
  fence io, rw


end:
  la a0, result
  sw a1, 0(a0)
  li a0, 0
  li a7, 93
  ecall

result:
  ecall