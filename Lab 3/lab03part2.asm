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
	add $t2, $zero, $v0
	slt $t0,$t2,$zero
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
	add $t3, $zero, $v0
	slt $s3,$t3,$zero
	bne $s3,$zero,Negy
	slti $s3,$t3,1
	bne $s3,$zero,y0
	addi $a0,$t2,0
	addi $a1,$t3,0
	jal _power
	j finish
y0:
	addi $s5,$zero, 1
	j finish
Negy:
	addi $v0, $zero, 4
	la $a0, neg
	syscall
	j printPromptY

finish:	
printNumx: 
	addi $v0, $zero, 1
	add $a0, $zero, $t2
	syscall
printCarrot:
	addi $v0, $zero, 4
	la $a0, carrot
	syscall
printNumY:
	addi $v0, $zero, 1
	add $a0, $zero, $t3
	syscall
printEqual:
	addi $v0, $zero, 4
	la $a0, equals 
	syscall
printResult:
	addi $v0, $zero, 1
	add $a0, $zero, $s2
	syscall
done:
	addi $v0,$zero,10
	syscall
	
_power:
	add  $s0, $zero, $a0	
	add   $s1, $zero, $a1
	add   $s7, $zero, $ra
	addi  $s2, $zero, 1
	add $s3,$zero,$zero
ploop:
	slt $s4, $s3, $s1
	beq $s4, $zero, pdone
	add $a0, $zero, $s2
	add $a1, $zero, $s0
	jal _multi
	add $s2, $zero, $v0
	addi $s3, $s3, 1
	j ploop
pdone:
	add $ra, $zero, $s7
	jr $ra
_multi:
	add  $v0, $zero, $zero
	add  $t0, $zero, $zero
loop:   slt  $t1, $t0, $a1
	beq  $t1, $zero, doneM
	add  $v0, $v0, $a0
	addi $t0, $t0, 1
	j loop
doneM:
	jr $ra
