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
	
	add $t8,$zero,$zero
	add $t0,$t9,$t0
	add $t8,$t0,0
	add $t9,$zero,0
	j wait

oppS1:
	beq $t9, 10, addition
	beq $t9, 11, subtraction
	beq $t9, 12, multi
	beq $t9, 13, divide	
	beq $t9, 14, equal
	beq $t9, 15, State_0
addition:
	addi $t2, $zero, 10
	addi $t9,$zero, 0
	j State_2w
subtraction:
	addi $t2,$zero, 11
	addi $t9,$zero, 0
	j State_2w
multi:
	addi $t2,$zero, 12
	addi $t9,$zero, 0
	j State_2w
divide: 
	addi $t2,$zero, 13
	addi $t9,$zero, 0
	j State_2w
equal:
	addi $t2,$zero, 14
	add $t3, $t0,$zero
	add $t8, $t3,$zero
	j State_4w
State_2w:
	beq $t9,$zero,State_2w
State_2:
	sll $t9,$t9,1
	srl $t9,$t9,1
	
	slti $s1, $t9, 10
	beq $s1, $zero, oppS2
numS2:	
	sll $t5,$t1,1
	sll $t6,$t1,3
	add $t1,$t5,$t6
	add $t8,$zero,$zero
	add $t1,$t9,$t1
	add $t8,$t1,0
	add $t9,$zero,0
	j State_3w

oppS2:
	beq $t9, 10, setOpp2
	beq $t9, 11, setOpp2
	beq $t9, 12, setOpp2
	beq $t9, 13, setOpp2	
	beq $t9, 14, equal
	beq $t9, 15, State_0
setOpp2:
	add $t2,$t9,$zero
	addi $t9,$zero, 0
	add $t8,$t0,$zero
	j State_2w
State_3w:
	beq $t9,$zero,State_3w
State_3:
	sll $t9,$t9,1
	srl $t9,$t9,1
	
	slti $s1, $t9, 10
	beq $s1, $zero, oppS3
numS3:	
	sll $t5,$t1,1
	sll $t6,$t1,3
	add $t1,$t5,$t6
	add $t8,$zero,$zero
	add $t1,$t9,$t1
	add $t8,$t1,0
	add $t9,$zero,0
	j State_3w
oppS3:
	beq $t9, 10, calc
	beq $t9, 11, calc
	beq $t9, 12, calc
	beq $t9, 13, calc	
	beq $t9, 14,calc
	beq $t9, 15, State_0
calc:
	addi $s5,$zero,0
	addi $s6, $zero,0
	beq $t2,12,calcMulti
	beq $t2,13, calcDivide
	beq $t2, 10, calcAdd
	beq $t2, 11, calcMinus
calcMulti:
	add $t3,$t3,$t0
	addi $s5,$s5,1
	bne $s5,$t1,calcMulti
	j finishCalc
calcDivide: 
	slti $s7,$t0,0
	beq $s7,1,divideNeg
dividePos:
	sub $t0,$t0,$t1
	slti $s6,$t0,0
	bne $s6,$zero, finishCalc
	addi $t3,$t3,1
	slti $s6,$t0,1
	bne $s6,$zero, finishCalc
	
	j dividePos
divideNeg:	
	addi $s7,$zero,-1
	add $t0,$t0,$t1
	slt $t6,$zero,$t0
	bne $s6,0,finishCalc
	subi $t3,$t3,1
	slt $s6,$s7,$t0
	bne $s6,0,finishCalc
	j divideNeg
	
calcAdd:
	add $t3, $t0,$t1
	j finishCalc
calcMinus:
	sub $t3,$t0,$t1
	j finishCalc
finishCalc:
	add $t8,$t3,$zero
	beq $t9,14, finEQ
	addi $t0,$t3, 0
	add $t3, $zero,$zero
	add $t1,$zero,$zero
	
	add $t2, $t9,$zero
	j State_2
finEQ:
	add $t2, $zero,$zero
	add $t1,$zero,$zero
	add $t9, $zero,$zero

	j State_4w
State_4w:
	beq $t9,$zero,State_4w
State_4:
	sll $t9,$t9,1
	srl $t9,$t9,1
	slti $s1, $t9, 10
	beq $s1, $zero, OppS4
numS4:	
	add $t8,$zero,$zero
	add $t0,$t9,$t0
	add $t8,$t0,0
	add $t9,$zero,0
	j wait
OppS4:
	beq $t9, 14,EqS4
	beq $t9, 15 State_0
	add $t0,$t3,$zero
	add $t3, $zero,$zero
	add $t1, $zero,$zero
	add $t2,$t9,$zero
	j State_2w
EqS4:
	add $t8,$t3, $zero
	addi $t1,$zero,0
	add $t3,$zero,$zero
	add $t9, $zero,$zero
	j State_4w
