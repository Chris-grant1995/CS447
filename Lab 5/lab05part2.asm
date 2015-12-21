.data 
	prompt: .asciiz "Enter a nonnegative integer: "
	end: .asciiz "! = "
	fail: .asciiz "Invalid integer; try again.\n"
.text
start:
	addi $v0, $zero, 4
	la $a0, prompt
	syscall
	
	addi $v0,$zero,5
	syscall
	addi $s0,$v0,0
	slti $t0,$s0,0
	bne $t0, $zero, failed
	addi $a0,$s0,0
	jal _Fac
	addi $s1, $v0,0
	div $s1,$s1,$s0 #Needed because _Fac returns n*n*(n-1)...
	addi $v0,$zero,1
	addi $a0,$s0,0
	syscall
	
	addi $v0, $zero, 4
	la $a0, end
	syscall
	
	addi $v0,$zero,1
	addi $a0,$s1,0
	syscall
	
	addi $v0,$zero, 10
	syscall
	
failed:
	addi $v0, $zero, 4
	la $a0, fail
	syscall	
	j start
_Fac:
		addi $sp, $sp, -8 
		sw $ra, 4($sp) 
		sw $a0, 0($sp)
		ble $a0, $zero, fact_return
		addi $a0, $a0, -1
		jal _Fac
		lw $a0, 0($sp)
		mul $v0,$v0,$a0
	fact_return:
    		lw $ra 4($sp)
    		addi $sp, $sp, 8
    		jr $ra