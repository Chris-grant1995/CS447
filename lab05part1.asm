.data
	names: .asciiz "steve", "john", "chelsea", "julia", "ryan"
 	ages: .byte 20, 25, 22, 21, 23
 	prompt: .asciiz "Please enter a name: "
 	input: .space 64
	nf: .asciiz "Not found!\n"
	age: .asciiz "Age is: "
 	
 .text
 	addi $v0, $zero, 4
	la $a0, prompt
	syscall
		
	la $a0, input
	addi $a1, $zero, 64
	jal _readString
	la $s0, input			
	add $s1, $zero, $zero		
	la $s2, names			
	
mainLoop:
	addi $t0, $zero, 5
	slt $t1, $s1, $t0
	beq $t1, $zero, notFound	
	add $a0, $s0, $zero
	add $a1, $s2, $zero
	jal _strEqual
	bne $v0, $zero, found		
	addi $s1, $s1, 1
nextStringLoop:
	addi $s2, $s2, 1
	lb $t2, ($s2)
	beq $t2, $zero, nextStringDone
	j nextStringLoop
nextStringDone:
	addi $s2, $s2, 1
	j mainLoop
	
notFound:
	addi $v0, $zero, 4
	la $a0, nf
	syscall

	addi $v0, $zero, 10
	syscall
	
found:
	addi $v0, $zero, 4
	la $a0, age
	syscall
	
	la $a0, ages
	add $a1, $s1, $zero
	jal _lookUpAge
	
	add $a0, $v0, $zero
	addi $v0, $zero, 1
	syscall
	
	
	addi $v0, $zero, 10
	syscall

_strEqual:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	sub $t2, $t0, $t1
	bne $t2, $zero,nEqual
	beq $t1, $zero, equal
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j _strEqual
	
nEqual:
	addi $v0, $zero, 0
	jr $ra
	
equal:
	addi $v0, $zero, 1
	jr $ra

_lookUpAge: 
	add $a0, $a0, $a1
	lb $v0, ($a0)
	jr $ra
	
_readString:
		addi $t9,$ra, 0
		addi $v0,$zero,8
		syscall
		removeN:
			addi $t0,$zero,0
			removeLoop:
				lb $t1,input($t0)
				addi $t0,$t0,1
				bne $t1,$zero,removeLoop
				beq $a1,$s0,skip
				subi $t0,$t0,2
				sb $zero,input($t0)
			skip:
		jal _strlen
		addi $ra,$t9,0
		jr $ra
	
	
	
_strlen:
			li $t0, 0 
		loop:
			lb $t1, 0($a0) 
			beq $t1,0, exit
			addi $a0, $a0, 1 # increment the string pointer
			addi $t0, $t0, 1 # increment the count
			j loop # return to the top of the loop
		exit:
			addi $v0,$t0,0
			jr $ra
