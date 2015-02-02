.data
	enterPrompt: .asciiz "\nPlease enter your integer:  "
	output: .asciiz "\nHere is the output: "
.text 

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
	addi $t0,$zero, 7
	sra $s0, $s2,15
	and $s0,$s0,$t0
	
	addi $v0, $zero, 4
	la $a0, output
	syscall
	j printNum
printNum: 
	addi $v0, $zero, 1
	add $a0, $zero, $s0
	syscall
	j done

done:
	addi $v0,$zero,10
	syscall