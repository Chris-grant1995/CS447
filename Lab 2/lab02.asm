.data
	enterPrompt: .asciiz "\nEnter a number between 0 and 9: "
	low: .asciiz "\nYour Guess is too low."
	high: .asciiz "\nYour Guess is too high"
	lose: .asciiz "\nYou lose. The number was "
	period: .asciiz "."
	win: .asciiz "\nCongratulations! You win!"
.text 
	addi $t0, $zero,0 #counter
	addi $t9, $zero, 3
	#Generating Random Number
	addi $v0, $zero,42
	add $a0,$zero, $zero
	addi $a1, $zero, 10
	syscall 
	add $s1, $zero, $a0

printPrompt: 
	addi $v0, $zero, 4
	la $a0, enterPrompt
	syscall
	j readInt
readInt: 
	addi $v0, $zero, 5
	syscall
	add $s2, $zero, $v0
	j loop
loop:	
	beq $s1,$s2 youWin
	addi $t0, $t0,1
	beq $t0,$t9,youLose
	slt $t2, $s2,$s1
	beq $t2, $zero, tooHigh
	bne $t2,$zero, tooLow
tooHigh:
	addi $v0, $zero, 4
	la $a0, high
	syscall
	j printPrompt
tooLow:
	addi $v0, $zero, 4
	la $a0, low
	syscall
	j printPrompt
		
printNum: 
	addi $v0, $zero, 1
	add $a0, $zero, $s0
	syscall
	j done
youWin:
	addi $v0, $zero, 4
	la $a0, win
	syscall
	j done
youLose:
	addi $v0, $zero, 4
	la $a0, lose
	syscall
	j printNum
done:
	addi $v0,$zero,10
	syscall