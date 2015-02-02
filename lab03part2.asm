.data
	start: .asciiz "x^y calculator"
	enterPromptX: .asciiz "\nPlease enter x:  "
	enterPromptY: .asciiz "\nHere is the y: "
	carrot: .asciiz "^"
	equals: .asciiz "= "
	neg: .asciiz "\nInteger must be nonnegative. "
.text 
printGreeting:
	addi $v0, $zero, 4
	la $a0, start
	syscall
printPrompt: 
	addi $v0, $zero, 4
	la $a0, enterPromptX
	syscall
	j readInt
readInt: 
	addi $v0, $zero, 5
	syscall
	add $s2, $zero, $v0
	slt $t0,$s2,$zero
	bne $t0,$zero,Negx
	j printPromptY
Negx:
	addi $v0, $zero, 4
	la $a0, neg
	syscall
	j printPrompt
printPromptY:
	addi $v0, $zero, 4
	la $a0, enterPromptY
	syscall
	j readIntY
readIntY:
	addi $v0, $zero, 5
	syscall
	add $t0, $zero, $v0
	slt $s3,$t0,$zero
	bne $s3,$zero,Negy
	slti $s3,$t0,1
	bne $s3,$zero,y0
	addi $t3,$zero,0
	addi $t1,$zero,0
	j multi
y0:
	addi $s5,$zero, 1
	j finish
Negy:
	addi $v0, $zero, 4
	la $a0, neg
	syscall
	j printPromptY
resetMulti:
	addi $t3,$zero,0
	addi $t1,$t1,1
	addi $s2,$s5,0
	
	beq $t1,$t0, finish
multi:
	
	add $s5,$s5,$s2
	addi $t3,$t3,1
	bne $t3,$s2,multi
	j resetMulti
finish:	
printNumx: 
	addi $v0, $zero, 1
	add $a0, $zero, $s2
	syscall
printCarrot:
	addi $v0, $zero, 4
	la $a0, carrot
	syscall
printNumY:
	addi $v0, $zero, 1
	add $a0, $zero, $t0
	syscall
printEqual:
	addi $v0, $zero, 4
	la $a0, equals 
	syscall
printResult:
	addi $v0, $zero, 1
	add $a0, $zero, $s5
	syscall
done:
	addi $v0,$zero,10
	syscall