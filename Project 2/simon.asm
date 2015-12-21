.data
	seqeunceBuffer: .space 100
.text
start:
		

waitStart:	bne $t9,16,waitStart
		addi $t8,$t9,0
startLoop2:	bne $t8,$zero, startLoop2
gameLoop:	addi $t9,$t9,0
		addi $v0,$zero,0
		jal _getRandom
		addi $s0,$v0,0
		addi $a0,$s0,0
		addi $v0,$zero,0
		jal _storeRandom
		jal _playSequence
		jal _userPlay #0 if wins, 1 if loses 
		beq $v0,0,gameLoop
		addi $t8,$zero,15
startLoop:	bne $t8,$zero, startLoop
		jal _wipeBuffer
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
	addi $t9,$zero,0
	playingLoop:	lb $t1,seqeunceBuffer($t2)
			beq $t1,0,win
	inputLoop:	beq $t9, 0, inputLoop
			addi $t0,$t9,0
			addi $t8,$t9,0
	playInSound:	bne $t8,0,playInSound
			addi $t9,$zero,0
			bne $t1,$t0, lose
			addi $t2,$t2,1
			j playingLoop
	win:
			addi $v0,$zero,0
			j return
	lose:
			addi $v0,$zero,1
			j return
	return:
			jr $ra
_wipeBuffer:
	addi $t2,$zero,0
	wipeLoop:	lb $t1,seqeunceBuffer($t2)
			beq $t1,$zero doneWiping
			sb $zero, seqeunceBuffer($t2)
			addi $t2, $t2,1
			j wipeLoop
	doneWiping:
		jr $ra
			
