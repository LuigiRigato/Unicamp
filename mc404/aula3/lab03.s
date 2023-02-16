	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall read (63) 
	ecall	
	mv	a3, a0
	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	power
	.p2align	2
	.type	power,@function
power:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -16(s0)
	sw	a1, -20(s0)
	lw	a0, -20(s0)
	li	a1, 0
	bne	a0, a1, .LBB2_2
	j	.LBB2_1
.LBB2_1:
	li	a0, 1
	sw	a0, -12(s0)
	j	.LBB2_7
.LBB2_2:
	lw	a0, -16(s0)
	sw	a0, -24(s0)
	li	a0, 1
	sw	a0, -28(s0)
	j	.LBB2_3
.LBB2_3:
	lw	a0, -28(s0)
	lw	a1, -20(s0)
	bge	a0, a1, .LBB2_6
	j	.LBB2_4
.LBB2_4:
	lw	a1, -16(s0)
	lw	a0, -24(s0)
	mul	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB2_5
.LBB2_5:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB2_3
.LBB2_6:
	lw	a0, -24(s0)
	sw	a0, -12(s0)
	j	.LBB2_7
.LBB2_7:
	lw	a0, -12(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end2:
	.size	power, .Lfunc_end2-power

	.globl	charToDec
	.p2align	2
	.type	charToDec,@function
charToDec:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sb	a0, -9(s0)
	lbu	a0, -9(s0)
	li	a1, 48
	blt	a0, a1, .LBB3_3
	j	.LBB3_1
.LBB3_1:
	lbu	a1, -9(s0)
	li	a0, 57
	blt	a0, a1, .LBB3_3
	j	.LBB3_2
.LBB3_2:
	lbu	a0, -9(s0)
	addi	a0, a0, -48
	sw	a0, -16(s0)
	j	.LBB3_11
.LBB3_3:
	lbu	a0, -9(s0)
	li	a1, 97
	blt	a0, a1, .LBB3_6
	j	.LBB3_4
.LBB3_4:
	lbu	a1, -9(s0)
	li	a0, 102
	blt	a0, a1, .LBB3_6
	j	.LBB3_5
.LBB3_5:
	lbu	a0, -9(s0)
	addi	a0, a0, -87
	sw	a0, -16(s0)
	j	.LBB3_10
.LBB3_6:
	lbu	a0, -9(s0)
	li	a1, 65
	blt	a0, a1, .LBB3_9
	j	.LBB3_7
.LBB3_7:
	lbu	a1, -9(s0)
	li	a0, 70
	blt	a0, a1, .LBB3_9
	j	.LBB3_8
.LBB3_8:
	lbu	a0, -9(s0)
	addi	a0, a0, -55
	sw	a0, -16(s0)
	j	.LBB3_9
.LBB3_9:
	j	.LBB3_10
.LBB3_10:
	j	.LBB3_11
.LBB3_11:
	lw	a0, -16(s0)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	charToDec, .Lfunc_end3-charToDec

	.globl	decToChar
	.p2align	2
	.type	decToChar,@function
decToChar:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	li	a1, 0
	blt	a0, a1, .LBB4_3
	j	.LBB4_1
.LBB4_1:
	lw	a1, -12(s0)
	li	a0, 9
	blt	a0, a1, .LBB4_3
	j	.LBB4_2
.LBB4_2:
	lw	a0, -12(s0)
	addi	a0, a0, 48
	sw	a0, -16(s0)
	j	.LBB4_7
.LBB4_3:
	lw	a0, -12(s0)
	li	a1, 10
	blt	a0, a1, .LBB4_6
	j	.LBB4_4
.LBB4_4:
	lw	a1, -12(s0)
	li	a0, 15
	blt	a0, a1, .LBB4_6
	j	.LBB4_5
.LBB4_5:
	lw	a0, -12(s0)
	addi	a0, a0, 55
	sw	a0, -16(s0)
	j	.LBB4_6
.LBB4_6:
	j	.LBB4_7
.LBB4_7:
	lbu	a0, -16(s0)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end4:
	.size	decToChar, .Lfunc_end4-decToChar

	.globl	hexToBin
	.p2align	2
	.type	hexToBin,@function
hexToBin:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 0
	sw	a0, -24(s0)
	lw	a1, -16(s0)
	li	a0, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	li	a0, 98
	sb	a0, 1(a1)
	li	a0, 2
	sw	a0, -44(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 0
	beq	a0, a1, .LBB5_12
	j	.LBB5_2
.LBB5_2:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	call	charToDec
	sw	a0, -20(s0)
	li	a0, 0
	sw	a0, -48(s0)
	j	.LBB5_3
.LBB5_3:
	lw	a1, -48(s0)
	li	a0, 3
	blt	a0, a1, .LBB5_6
	j	.LBB5_4
.LBB5_4:
	lw	a0, -20(s0)
	srli	a1, a0, 31
	add	a1, a0, a1
	andi	a1, a1, -2
	sub	a0, a0, a1
	lw	a1, -48(s0)
	slli	a2, a1, 2
	addi	a1, s0, -40
	add	a1, a1, a2
	sw	a0, 0(a1)
	lw	a0, -20(s0)
	srli	a1, a0, 31
	add	a0, a0, a1
	srai	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB5_5
.LBB5_5:
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB5_3
.LBB5_6:
	li	a0, 0
	sw	a0, -52(s0)
	j	.LBB5_7
.LBB5_7:
	lw	a1, -52(s0)
	li	a0, 3
	blt	a0, a1, .LBB5_10
	j	.LBB5_8
.LBB5_8:
	lw	a1, -52(s0)
	li	a0, 3
	sub	a0, a0, a1
	slli	a1, a0, 2
	addi	a0, s0, -40
	add	a0, a0, a1
	lw	a0, 0(a0)
	call	decToChar
	lw	a2, -16(s0)
	lw	a1, -52(s0)
	lw	a3, -24(s0)
	add	a1, a1, a3
	add	a1, a1, a2
	sb	a0, 2(a1)
	j	.LBB5_9
.LBB5_9:
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB5_7
.LBB5_10:
	lw	a0, -24(s0)
	addi	a0, a0, 4
	sw	a0, -24(s0)
	j	.LBB5_11
.LBB5_11:
	lw	a0, -44(s0)
	addi	a0, a0, 1
	sw	a0, -44(s0)
	j	.LBB5_1
.LBB5_12:
	lw	a0, -24(s0)
	addi	a0, a0, 2
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end5:
	.size	hexToBin, .Lfunc_end5-hexToBin

	.globl	desinverteVetor
	.p2align	2
	.type	desinverteVetor,@function
desinverteVetor:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
	sw	a0, -28(s0)
	j	.LBB6_1
.LBB6_1:
	lw	a0, -28(s0)
	lw	a1, -20(s0)
	bge	a0, a1, .LBB6_4
	j	.LBB6_2
.LBB6_2:
	lw	a1, -16(s0)
	lw	a0, -20(s0)
	lw	a2, -28(s0)
	sub	a0, a0, a2
	add	a0, a0, a1
	lb	a0, -1(a0)
	lw	a1, -12(s0)
	lw	a3, -24(s0)
	add	a2, a2, a3
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB6_3
.LBB6_3:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB6_1
.LBB6_4:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end6:
	.size	desinverteVetor, .Lfunc_end6-desinverteVetor

	.globl	divisoesSucessivas
	.p2align	2
	.type	divisoesSucessivas,@function
divisoesSucessivas:
	addi	sp, sp, -80
	sw	ra, 76(sp)
	sw	s0, 72(sp)
	addi	s0, sp, 80
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
	sw	a0, -68(s0)
	j	.LBB7_1
.LBB7_1:
	lw	a0, -12(s0)
	li	a1, 0
	beq	a0, a1, .LBB7_4
	j	.LBB7_2
.LBB7_2:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	rem	a0, a0, a1
	call	decToChar
	lw	a2, -68(s0)
	addi	a1, s0, -59
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a1, -20(s0)
	lw	a0, -12(s0)
	div	a0, a0, a1
	sw	a0, -12(s0)
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB7_3
.LBB7_3:
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB7_1
.LBB7_4:
	lw	a0, -16(s0)
	lw	a2, -64(s0)
	lw	a3, -24(s0)
	addi	a1, s0, -59
	call	desinverteVetor
	lw	a0, -64(s0)
	lw	ra, 76(sp)
	lw	s0, 72(sp)
	addi	sp, sp, 80
	ret
.Lfunc_end7:
	.size	divisoesSucessivas, .Lfunc_end7-divisoesSucessivas

	.globl	strToInt
	.p2align	2
	.type	strToInt,@function
strToInt:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
	sw	a0, -28(s0)
	lw	a0, -24(s0)
	sw	a0, -32(s0)
	j	.LBB8_1
.LBB8_1:
	lw	a0, -32(s0)
	lw	a1, -12(s0)
	bge	a0, a1, .LBB8_4
	j	.LBB8_2
.LBB8_2:
	lw	a0, -16(s0)
	lw	a1, -32(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	call	charToDec
	sw	a0, -36(s0)
	lw	a0, -20(s0)
	lw	a2, -12(s0)
	lw	a1, -32(s0)
	not	a1, a1
	add	a1, a1, a2
	call	power
	mv	a1, a0
	lw	a0, -36(s0)
	mul	a1, a0, a1
	lw	a0, -28(s0)
	add	a0, a0, a1
	sw	a0, -28(s0)
	j	.LBB8_3
.LBB8_3:
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	.LBB8_1
.LBB8_4:
	lw	a0, -28(s0)
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end8:
	.size	strToInt, .Lfunc_end8-strToInt

	.globl	positiveBinToDec
	.p2align	2
	.type	positiveBinToDec,@function
positiveBinToDec:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	li	a3, 2
	mv	a2, a3
	call	strToInt
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	a1, -16(s0)
	li	a2, 10
	li	a3, 0
	call	divisoesSucessivas
	sw	a0, -28(s0)
	lw	a0, -28(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end9:
	.size	positiveBinToDec, .Lfunc_end9-positiveBinToDec

	.globl	negativeBinToDec
	.p2align	2
	.type	negativeBinToDec,@function
negativeBinToDec:
	addi	sp, sp, -112
	sw	ra, 108(sp)
	sw	s0, 104(sp)
	addi	s0, sp, 112
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a0, 48
	sb	a0, -55(s0)
	li	a0, 98
	sb	a0, -54(s0)
	li	a0, 2
	sw	a0, -96(s0)
	j	.LBB10_1
.LBB10_1:
	lw	a0, -96(s0)
	lw	a1, -20(s0)
	bge	a0, a1, .LBB10_4
	j	.LBB10_2
.LBB10_2:
	lw	a0, -12(s0)
	lw	a1, -96(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	call	charToDec
	mv	a1, a0
	li	a0, 1
	sub	a0, a0, a1
	call	decToChar
	lw	a2, -96(s0)
	addi	a1, s0, -55
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB10_3
.LBB10_3:
	lw	a0, -96(s0)
	addi	a0, a0, 1
	sw	a0, -96(s0)
	j	.LBB10_1
.LBB10_4:
	lw	a0, -20(s0)
	addi	a1, s0, -55
	li	a3, 2
	mv	a2, a3
	call	strToInt
	sw	a0, -100(s0)
	lw	a0, -100(s0)
	addi	a0, a0, 1
	sw	a0, -100(s0)
	lw	a0, -100(s0)
	lw	a1, -16(s0)
	li	a2, 10
	li	a3, 0
	call	divisoesSucessivas
	sw	a0, -104(s0)
	lw	a0, -104(s0)
	lw	ra, 108(sp)
	lw	s0, 104(sp)
	addi	sp, sp, 112
	ret
.Lfunc_end10:
	.size	negativeBinToDec, .Lfunc_end10-negativeBinToDec

	.globl	decPositiveToBin
	.p2align	2
	.type	decPositiveToBin,@function
decPositiveToBin:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a1, -16(s0)
	li	a0, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	li	a0, 98
	sb	a0, 1(a1)
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	li	a2, 10
	li	a3, 0
	call	strToInt
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	a1, -16(s0)
	li	a3, 2
	mv	a2, a3
	call	divisoesSucessivas
	sw	a0, -28(s0)
	lw	a0, -28(s0)
	addi	a0, a0, 2
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end11:
	.size	decPositiveToBin, .Lfunc_end11-decPositiveToBin

	.globl	decNegativeToBin
	.p2align	2
	.type	decNegativeToBin,@function
decNegativeToBin:
	addi	sp, sp, -80
	sw	ra, 76(sp)
	sw	s0, 72(sp)
	addi	s0, sp, 80
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	lw	a1, -16(s0)
	li	a0, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	li	a0, 98
	sb	a0, 1(a1)
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	li	a2, 10
	li	a3, 1
	sw	a3, -72(s0)
	call	strToInt
	mv	a1, a0
	lw	a0, -72(s0)
	sw	a1, -64(s0)
	lw	a1, -64(s0)
	addi	a1, a1, -1
	sw	a1, -64(s0)
	sw	a0, -68(s0)
	j	.LBB12_1
.LBB12_1:
	lw	a0, -64(s0)
	li	a1, 0
	beq	a0, a1, .LBB12_4
	j	.LBB12_2
.LBB12_2:
	lw	a1, -64(s0)
	srli	a0, a1, 31
	add	a0, a1, a0
	andi	a0, a0, -2
	sub	a0, a0, a1
	addi	a0, a0, 1
	call	decToChar
	lw	a2, -68(s0)
	addi	a1, s0, -59
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -64(s0)
	srli	a1, a0, 31
	add	a0, a0, a1
	srai	a0, a0, 1
	sw	a0, -64(s0)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB12_3
.LBB12_3:
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB12_1
.LBB12_4:
	lw	a0, -16(s0)
	lw	a2, -24(s0)
	addi	a1, s0, -59
	li	a3, 2
	call	desinverteVetor
	lw	a0, -24(s0)
	addi	a0, a0, 2
	lw	ra, 76(sp)
	lw	s0, 72(sp)
	addi	sp, sp, 80
	ret
.Lfunc_end12:
	.size	decNegativeToBin, .Lfunc_end12-decNegativeToBin

	.globl	decToHex
	.p2align	2
	.type	decToHex,@function
decToHex:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a1, -16(s0)
	li	a0, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	li	a0, 120
	sb	a0, 1(a1)
	lw	a0, -12(s0)
	lbu	a0, 0(a0)
	li	a1, 45
	bne	a0, a1, .LBB13_2
	j	.LBB13_1
.LBB13_1:
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	li	a2, 10
	li	a3, 1
	call	strToInt
	sw	a0, -24(s0)
	j	.LBB13_3
.LBB13_2:
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	li	a2, 10
	li	a3, 0
	call	strToInt
	sw	a0, -24(s0)
	j	.LBB13_3
.LBB13_3:
	lw	a0, -24(s0)
	lw	a1, -16(s0)
	li	a2, 16
	li	a3, 2
	call	divisoesSucessivas
	sw	a0, -28(s0)
	lw	a0, -28(s0)
	addi	a0, a0, 2
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end13:
	.size	decToHex, .Lfunc_end13-decToHex

	.globl	changeEnd
	.p2align	2
	.type	changeEnd,@function
changeEnd:
	addi	sp, sp, -176
	sw	ra, 172(sp)
	sw	s0, 168(sp)
	addi	s0, sp, 176
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a1, -20(s0)
	li	a0, 32
	sub	a0, a0, a1
	sw	a0, -132(s0)
	li	a0, 0
	sw	a0, -136(s0)
	j	.LBB14_1
.LBB14_1:
	lw	a0, -136(s0)
	lw	a1, -132(s0)
	bge	a0, a1, .LBB14_4
	j	.LBB14_2
.LBB14_2:
	lw	a1, -136(s0)
	addi	a0, s0, -55
	add	a1, a0, a1
	li	a0, 48
	sb	a0, 0(a1)
	j	.LBB14_3
.LBB14_3:
	lw	a0, -136(s0)
	addi	a0, a0, 1
	sw	a0, -136(s0)
	j	.LBB14_1
.LBB14_4:
	li	a0, 0
	sw	a0, -140(s0)
	j	.LBB14_5
.LBB14_5:
	lw	a0, -140(s0)
	lw	a1, -20(s0)
	bge	a0, a1, .LBB14_8
	j	.LBB14_6
.LBB14_6:
	lw	a0, -12(s0)
	lw	a2, -140(s0)
	add	a0, a2, a0
	lb	a0, 2(a0)
	lw	a1, -132(s0)
	add	a2, a1, a2
	addi	a1, s0, -55
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB14_7
.LBB14_7:
	lw	a0, -140(s0)
	addi	a0, a0, 1
	sw	a0, -140(s0)
	j	.LBB14_5
.LBB14_8:
	li	a0, 0
	sw	a0, -144(s0)
	li	a0, 3
	sw	a0, -148(s0)
	j	.LBB14_9
.LBB14_9:
	lw	a0, -148(s0)
	li	a1, 0
	blt	a0, a1, .LBB14_16
	j	.LBB14_10
.LBB14_10:
	li	a0, 1
	sw	a0, -152(s0)
	j	.LBB14_11
.LBB14_11:
	lw	a1, -152(s0)
	li	a0, 8
	blt	a0, a1, .LBB14_14
	j	.LBB14_12
.LBB14_12:
	lw	a0, -148(s0)
	slli	a0, a0, 3
	lw	a1, -152(s0)
	add	a1, a0, a1
	addi	a0, s0, -55
	add	a0, a0, a1
	lb	a0, 0(a0)
	lw	a2, -144(s0)
	addi	a1, a2, 1
	sw	a1, -144(s0)
	addi	a1, s0, -90
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB14_13
.LBB14_13:
	lw	a0, -152(s0)
	addi	a0, a0, 1
	sw	a0, -152(s0)
	j	.LBB14_11
.LBB14_14:
	j	.LBB14_15
.LBB14_15:
	lw	a0, -148(s0)
	addi	a0, a0, -1
	sw	a0, -148(s0)
	j	.LBB14_9
.LBB14_16:
	li	a0, 32
	addi	a1, s0, -90
	li	a2, 2
	li	a3, 0
	sw	a3, -164(s0)
	call	strToInt
	lw	a3, -164(s0)
	sw	a0, -156(s0)
	lw	a0, -156(s0)
	lw	a1, -16(s0)
	li	a2, 10
	call	divisoesSucessivas
	sw	a0, -160(s0)
	lw	a0, -160(s0)
	lw	ra, 172(sp)
	lw	s0, 168(sp)
	addi	sp, sp, 176
	ret
.Lfunc_end14:
	.size	changeEnd, .Lfunc_end14-changeEnd

	.globl	barraZeroToN
	.p2align	2
	.type	barraZeroToN,@function
barraZeroToN:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -16(s0)
	j	.LBB15_1
.LBB15_1:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 0
	beq	a0, a1, .LBB15_4
	j	.LBB15_2
.LBB15_2:
	j	.LBB15_3
.LBB15_3:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB15_1
.LBB15_4:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a1, a0, a1
	li	a0, 10
	sb	a0, 0(a1)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end15:
	.size	barraZeroToN, .Lfunc_end15-barraZeroToN

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -256
	sw	ra, 252(sp)
	sw	s0, 248(sp)
	addi	s0, sp, 256
	li	a0, 0
	sw	a0, -12(s0)
	addi	a1, s0, -32
	li	a2, 20
	call	read
	sw	a0, -192(s0)
	lbu	a0, -31(s0)
	li	a1, 120
	bne	a0, a1, .LBB16_6
	j	.LBB16_1
.LBB16_1:
	addi	a0, s0, -32
	addi	a1, s0, -102
	call	hexToBin
	sw	a0, -176(s0)
	lw	a0, -176(s0)
	li	a1, 34
	bne	a0, a1, .LBB16_4
	j	.LBB16_2
.LBB16_2:
	lbu	a0, -100(s0)
	li	a1, 49
	bne	a0, a1, .LBB16_4
	j	.LBB16_3
.LBB16_3:
	lw	a2, -176(s0)
	addi	a0, s0, -102
	addi	a1, s0, -67
	call	negativeBinToDec
	sw	a0, -180(s0)
	j	.LBB16_5
.LBB16_4:
	lw	a2, -176(s0)
	addi	a0, s0, -102
	addi	a1, s0, -67
	call	positiveBinToDec
	sw	a0, -180(s0)
	j	.LBB16_5
.LBB16_5:
	lw	a2, -176(s0)
	addi	a0, s0, -102
	sw	a0, -212(s0)
	addi	a1, s0, -172
	sw	a1, -196(s0)
	call	changeEnd
	mv	a1, a0
	lw	a0, -212(s0)
	sw	a1, -188(s0)
	call	barraZeroToN
	addi	a0, s0, -67
	sw	a0, -208(s0)
	call	barraZeroToN
	addi	a0, s0, -32
	sw	a0, -204(s0)
	call	barraZeroToN
	lw	a0, -196(s0)
	call	barraZeroToN
	lw	a1, -212(s0)
	lw	a2, -176(s0)
	li	a0, 1
	sw	a0, -200(s0)
	call	write
	lw	a1, -208(s0)
	lw	a0, -200(s0)
	lw	a2, -180(s0)
	call	write
	lw	a1, -204(s0)
	lw	a0, -200(s0)
	lw	a2, -192(s0)
	call	write
	lw	a0, -200(s0)
	lw	a1, -196(s0)
	lw	a2, -188(s0)
	call	write
	j	.LBB16_10
.LBB16_6:
	lbu	a0, -32(s0)
	li	a1, 45
	bne	a0, a1, .LBB16_8
	j	.LBB16_7
.LBB16_7:
	lw	a2, -192(s0)
	addi	a0, s0, -32
	sw	a0, -228(s0)
	addi	a1, s0, -102
	sw	a1, -232(s0)
	call	decNegativeToBin
	mv	a1, a0
	lw	a0, -228(s0)
	sw	a1, -176(s0)
	lw	a2, -192(s0)
	addi	a1, s0, -137
	sw	a1, -224(s0)
	call	decToHex
	mv	a1, a0
	lw	a0, -232(s0)
	sw	a1, -184(s0)
	lw	a2, -176(s0)
	addi	a1, s0, -172
	sw	a1, -216(s0)
	call	changeEnd
	mv	a1, a0
	lw	a0, -232(s0)
	sw	a1, -188(s0)
	call	barraZeroToN
	lw	a0, -228(s0)
	call	barraZeroToN
	lw	a0, -224(s0)
	call	barraZeroToN
	lw	a0, -216(s0)
	call	barraZeroToN
	lw	a1, -232(s0)
	lw	a2, -176(s0)
	li	a0, 1
	sw	a0, -220(s0)
	call	write
	lw	a1, -228(s0)
	lw	a0, -220(s0)
	lw	a2, -180(s0)
	call	write
	lw	a1, -224(s0)
	lw	a0, -220(s0)
	lw	a2, -192(s0)
	call	write
	lw	a0, -220(s0)
	lw	a1, -216(s0)
	lw	a2, -188(s0)
	call	write
	j	.LBB16_9
.LBB16_8:
	lw	a2, -192(s0)
	addi	a0, s0, -32
	sw	a0, -248(s0)
	addi	a1, s0, -102
	sw	a1, -252(s0)
	call	decPositiveToBin
	mv	a1, a0
	lw	a0, -248(s0)
	sw	a1, -176(s0)
	lw	a2, -192(s0)
	addi	a1, s0, -137
	sw	a1, -244(s0)
	call	decToHex
	mv	a1, a0
	lw	a0, -252(s0)
	sw	a1, -184(s0)
	lw	a2, -176(s0)
	addi	a1, s0, -172
	sw	a1, -236(s0)
	call	changeEnd
	mv	a1, a0
	lw	a0, -252(s0)
	sw	a1, -188(s0)
	call	barraZeroToN
	lw	a0, -248(s0)
	call	barraZeroToN
	lw	a0, -244(s0)
	call	barraZeroToN
	lw	a0, -236(s0)
	call	barraZeroToN
	lw	a1, -252(s0)
	lw	a2, -176(s0)
	li	a0, 1
	sw	a0, -240(s0)
	call	write
	lw	a1, -248(s0)
	lw	a0, -240(s0)
	lw	a2, -180(s0)
	call	write
	lw	a1, -244(s0)
	lw	a0, -240(s0)
	lw	a2, -192(s0)
	call	write
	lw	a0, -240(s0)
	lw	a1, -236(s0)
	lw	a2, -188(s0)
	call	write
	j	.LBB16_9
.LBB16_9:
	j	.LBB16_10
.LBB16_10:
	li	a0, 0
	lw	ra, 252(sp)
	lw	s0, 248(sp)
	addi	sp, sp, 256
	ret
.Lfunc_end16:
	.size	main, .Lfunc_end16-main

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end17:
	.size	_start, .Lfunc_end17-_start

	.ident	"Ubuntu clang version 14.0.0-1ubuntu1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym power
	.addrsig_sym charToDec
	.addrsig_sym decToChar
	.addrsig_sym hexToBin
	.addrsig_sym desinverteVetor
	.addrsig_sym divisoesSucessivas
	.addrsig_sym strToInt
	.addrsig_sym positiveBinToDec
	.addrsig_sym negativeBinToDec
	.addrsig_sym decPositiveToBin
	.addrsig_sym decNegativeToBin
	.addrsig_sym decToHex
	.addrsig_sym changeEnd
	.addrsig_sym barraZeroToN
	.addrsig_sym main
