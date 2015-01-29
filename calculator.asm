.text

State_0:
	add $t9,$zero,0 #Set Keypad to 0
	add $t8,$zero,0 #Set Display to 0
	addi $t0,$zero,0 #Opp 1
	addi $t1, $zero, 0 #Opp 2
	addi $t2, $zero, 0 #Opperator
	addi $t3, $zero,0 #Result
	add $t8,$zero,0
wait:
	beq $t9,$zero,wait
State_1:
	sll $t9,$t9,1
	srl $t9,$t9,1
	
	slti $s1, $t9, 10
	beq $s1, $zero, oppS1
numS1:	
	sll $t5,$t0,1
	sll $t6,$t0,3
	add $t0,$t5,$t6
	
	add $t0,$t9,$t0
	add $t8,$t0,0
	add $t9,$zero,0
	j wait
oppS1:
	slti $s1,$t9,14
	beq $s1, $zero, eqS1
	slti $s1,$t9,15
	beq $s1, $zero, State_0
	add $t2, $t9,$zero
	
	
eqS1:
	add $t3,$t0,$zero
	add $t8,$t0,0
	