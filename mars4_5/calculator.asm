.text
add $t9,$zero,0 #Set Keypad to 0
add $t8,$zero,0 #Set Display to 0

State_0:
wait:
	beq $t9,$zero,wait
State_1:
	
	add $t0,$t9,0
	sll $t9,$t9,1
	srl $t9,$t9,1
	add $t8,$t0,0
	add $t9,$zero,0
	j wait