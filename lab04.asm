.data
	prompt: .asciiz "Enter a string: "
	char1: .asciiz "This string has  "
	char2: .asciiz " characters.\n"
	lowPrompt: .asciiz "Specify start index: "
	highPrompt: .asciiz "Specify End index: "
	ending: .asciiz "Your substring is:\n"
	buffer: .space 64
	substring: .space 64
.text 
	printGreeting:
		addi $v0, $zero, 4
		la $a0, prompt
		syscall
		
		la $a0, buffer
		li $a1, 64
		jal _readString
		addi $s0,$v0,0 #Length of the string
		
		addi $v0, $zero, 4
		la $a0, char1
		syscall
		
		addi $v0, $zero, 1
		add $a0, $zero, $s0
		syscall
		
		addi $v0, $zero, 4
		la $a0, char2
		syscall
		
		addi $v0, $zero, 4
		la $a0, lowPrompt
		syscall
		
		addi $v0, $zero, 5
		syscall
		add $s1, $zero, $v0 #Lower Bound
		
		addi $v0, $zero, 4
		la $a0, highPrompt
		syscall
		
		addi $v0, $zero, 5
		syscall
		add $s2, $zero, $v0 #Higher Bound
		
		addi $v0,$zero,4
		la $a0,ending
		syscall
		
		la $a0, buffer
		la $a1, substring
		addi $a2,$s1,0
		addi $a3,$s2,0
		jal _subString
		
		addi $v0,$zero,4
		la $a0,substring
		syscall
		
		addi $v0,$zero,10
		syscall
		
		
	_readString:
		addi $t9,$ra, 0
		addi $v0,$zero,8
		syscall
		removeN:
			addi $t0,$zero,0
			removeLoop:
				lb $t1,buffer($t0)
				addi $t0,$t0,1
				bne $t1,$zero,removeLoop
				beq $a1,$s0,skip
				subi $t0,$t0,2
				sb $zero,buffer($t0)
			skip:
		jal _strlen
		addi $ra,$t9,0
		jr $ra
	_strlen:
			li $t0, 0 # initialize the count to zero
		loop:
			lb $t1, 0($a0) # load the next character into t1
			beq $t1,0, exit # check for the null character
			addi $a0, $a0, 1 # increment the string pointer
			addi $t0, $t0, 1 # increment the count
			j loop # return to the top of the loop
		exit:
			addi $v0,$t0,0
			jr $ra
	_subString:
		addi $t9, $ra,0
		addi $t8, $a1,0
		addi $t7,$zero,0#Counter for substring
		addi $t6, $a2,0#Counter for string
		slti $t0,$a2,0
		bne $t0,$zero,null
		slti $t0,$a3,0
		bne $t0,$zero,null
		slt $t0,$a2,$s0
		beq $t0,$zero,null
		slt $t0,$a3,$s0
		beq $t0,$zero,higherBound
	returnHigherBound:
		slt $t0,$a2,$a3
		beq $t0,$zero,null
		j subloop
		
		higherBound:
			addi $a3,$s0,0
			j returnHigherBound
			
		subloop:
			lb $t1,buffer($t6)
			sb $t1, substring($t7)
			addi $t6,$t6,1
			addi $t7,$t7,1
			beq $t6,$a3,null
			j subloop
	null:
		sb $zero substring($t7)
		j finish
			
					
	finish:
		addi $ra,$t9,0
		addi $v0,$t8,0
		jr $ra
