.data
	prompt: .asciiz "Enter a string: "
	char1: .asciiz "This string has  "
	char2: .asciiz " characters.\n"
	lowPrompt: .asciiz "Specify start index: "
	highPrompt: .asciiz "Specify End index: "
	ending: .asciiz "Your substring is:"
	buffer: .space 64
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
		
		addi $v0,$zero,4
		la $a0,ending
		syscall
		
		addi $v0,$zero,4
		la $a0,buffer
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
