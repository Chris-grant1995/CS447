.data
	buffer: .space 64
.text
	jal _lhr
	addi $v0, $zero, 10
	syscall
_lhr:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	moveAgain:
	srl $t7,$t9,23 #Row Num
	sll $t6, $t9,8
	srl $t6,$t6,23#Col Num
	sll $t5,$t9,20
	andi $t5,$t9,3840 #1111 0000 0000 in decimal to store direction
	addi $t4,$t9,15 #1111 in decimal to store walls
	
	jal _move
	
	addi $t8,$zero,4 
	add $t7,$t7,$t6
	bne $t7,15,moveAgain
	
	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra
_move:
	addi $t8,$zero,1
moveWait:bnez $t8,moveWait
	jr $ra