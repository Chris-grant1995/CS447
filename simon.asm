.data
	seqeunceBuffer: .space 100
.text
start:
		

waitStart:	bne $t9,16,waitStart
		addi $t8,$t9,0
startLoop2:	bne $t8,$zero, startLoop2
gameLoop:	addi $t9,$t9,0
		jal _getRandom
		addi $s0,$v0,0
		addi $a0,$s0,0
		jal _storeRandom
		jal _playSequence
		jal _userPlay #0 if wins, 1 if loses 
		beq $v0, $zero,gameLoop
		addi $t8,$zero,15
startLoop:	bne $t8,$zero, startLoop
		j start
		
		addi $v0,$zero,10
		syscall
_getRandom:
	li $a1, 4
	li $v0, 42
	syscall
	addi $v0, $zero,1
	sllv  $v0,$v0,$a0
	jr $ra
	
_storeRandom:
		addi $t0,$a0,0
		addi $t2,$zero,0
	loop:	lb $t1,seqeunceBuffer($t2)
		beq $t1,$zero store
		addi $t2, $t2,1
		j loop
	store:
		sb $t0,seqeunceBuffer($t2)
		jr $ra
_playSequence:
	addi $t2,$zero,0
	playLoop:	lb $t1,seqeunceBuffer($t2)
			beq $t1,$zero done
			addi $t8,$t1,0
	playWait:	bne $t8,$zero, playWait
			addi $t2, $t2,1
			j playLoop
	done:
		jr $ra
_userPlay:
	addi $t2,$zero,0
	playingLoop:	lb $t1,seqeunceBuffer($t2)
			