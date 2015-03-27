
.data
openParen: .asciiz "("
closedParen: .asciiz ")\n"
comma: .asciiz ", "
moves:	.word 0:500
backtraceMoves: .word 0:500

.text

main:
	li $s0, 0						# ensure count is 0
	li $s1, 1						# ensure we log first move
	jal _moveForward					# move forward from (0, -1) to (0, 0)
	jal _leftHandRule					# start left hand algo
	jal _traceBack						# left hand algo finished, return back w/ best path
	jal _faceEast
	jal _moveForward
	addi	$a0, $0, 0
	addi	$a1, $0, -1
	jal _backtracking2
	j gameOver
	
_leftHandRule:
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _isGameOver						# check game over
	lw $ra, 4($sp)
	addi $sp, $sp, 4

	beq $v0, 1 leftHandGameOver				# break if game over

	li $s1, 1						# make sure we log moves in _moveForward
	
	addi $sp, $sp -4
	sw $ra, 4($sp)
	jal _isWallLeft						# check if wall on left side
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	beqz $v0, leftHandNoLeftWall			
	beq $v0, 1, leftHandIsLeftWall
		
	leftHandIsLeftWall:
		addi $sp, $sp -4
		sw $ra, 4($sp)
		jal _isWallFront				# is wall in front?
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		beqz $v0, leftHandIsLeftWallCanMove
		beq $v0, 1, leftHandIsLeftWallCantMove
		
		leftHandIsLeftWallCanMove:
			addi $sp, $sp -4
			sw $ra, 4($sp)
			jal _moveForward			# move forward
			lw $ra, 4($sp)
			addi $sp, $sp, 4

			j _leftHandRule
		leftHandIsLeftWallCantMove:
			addi $sp, $sp -4
			sw $ra, 4($sp)
			jal _pivotRight				# pivot right
			lw $ra, 4($sp)
			addi $sp, $sp, 4
			
			j _leftHandRule
			
	leftHandNoLeftWall:
		addi $sp, $sp -4
		sw $ra, 4($sp)
		
		addi $sp, $sp -4
		sw $ra, 4($sp)
		jal _pivotLeft					# do a left turn
		jal _moveForward
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		j _leftHandRule
	
	leftHandGameOver:
		jr $ra

_traceBack:
	li $s1, 0						# make sure we dont log moves in _moveForward
	
	addi $sp, $sp -4
	sw $ra, 4($sp)
	jal _isAtBeggining
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	beq $v0, 1, traceBackDone				# is in (0, -1), completed.
	
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _traceBackMove
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	j _traceBack
	
	traceBackDone:
		jr $ra

_traceBackMove:
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _popMove
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	add $s3, $zero, $v0					# $s3 is now the current move we must trace
	
	#### FACING NORTH
	add $v0, $zero, $s3	# Set value of $v0 to be $t9
	srl $v0, $v0, 11	# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	beq $v0, 1, traceBackMoveGoSouth
	
	#### FACING EAST
	add $v0, $zero, $s3	# Set value of $v0 to be $t9
	srl $v0, $v0, 10	# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	beq $v0, 1, traceBackMoveGoWest
	
	#### FACING SOUTH
	add $v0, $zero, $s3	# Set value of $v0 to be $t9
	srl $v0, $v0, 9		# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	beq $v0, 1, traceBackMoveGoNorth
	
	#### FACING WEST
	add $v0, $zero, $s3	# Set value of $v0 to be $t9
	srl $v0, $v0, 8		# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	beq $v0, 1, traceBackMoveGoEast
	
	traceBackMoveGoSouth:
		addi $sp, $sp -4
		sw $ra, 4($sp) 
		jal _faceSouth
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		beq  $v0, 1, traceBackMoveExecute
		
	traceBackMoveGoNorth:
		addi $sp, $sp -4
		sw $ra, 4($sp) 
		jal _faceNorth
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		beq  $v0, 1, traceBackMoveExecute
			
	traceBackMoveGoEast:
		addi $sp, $sp -4
		sw $ra, 4($sp) 
		jal _faceEast
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		beq  $v0, 1, traceBackMoveExecute

	traceBackMoveGoWest:
		addi $sp, $sp -4
		sw $ra, 4($sp) 
		jal _faceWest
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		beq  $v0, 1, traceBackMoveExecute
		
	traceBackMoveExecute:
		addi $sp, $sp -4
		sw $ra, 4($sp) 
		jal _moveForward
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		jr $ra	

_updateStatus:
	li $t8, 4
	updateStatusLoop:
		bnez $t8, updateStatusLoop
		addi $sp, $sp -4
		sw $ra, 4($sp)
		jal _printCell
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		jr $ra

_moveForward:
	li $t8, 1
	
	moveForwardLoop:
		bnez $t8, moveForwardLoop
		
		addi $sp, $sp -4
		sw $ra, 4($sp)
		jal _updateStatus
		lw $ra, 4($sp)
		addi $sp, $sp, 4

		beqz $s1, moveForwardLoopBreak			# if $s0 set to 0 then don't log move
	
		addi $sp, $sp -4
		sw $ra, 4($sp)
		jal _logMove
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		moveForwardLoopBreak:
			jr $ra

_pivotRight:
	li $t8, 3
	turnRightLoop:
		bnez $t8, turnRightLoop
		addi $sp, $sp -4
		sw $ra, 4($sp)
		jal _updateStatus
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		jr $ra

_pivotLeft:
	li $t8, 2
	turnLeftLoop:
		bnez $t8, turnLeftLoop
		addi $sp, $sp -4
		sw $ra, 4($sp) 
		jal _updateStatus
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		jr $ra

_faceNorth:
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _isNorth
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	beq, $v0, 1, faceNorthBreak
	
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _pivotRight
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	j _faceNorth
	
	faceNorthBreak:
		jr $ra
	
_faceSouth:
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _isSouth
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	beq, $v0, 1, faceSouthBreak
	
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _pivotLeft
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	j _faceSouth
	
	faceSouthBreak:
		jr $ra

_faceEast:
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _isEast
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	beq, $v0, 1, faceEastBreak
	
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _pivotRight
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	j _faceEast
	
	faceEastBreak:
		jr $ra
_faceWest:
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _isWest
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	beq, $v0, 1, faceWestBreak
	
	addi $sp, $sp -4
	sw $ra, 4($sp) 
	jal _pivotLeft
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	j _faceWest
	
	faceWestBreak:
		jr $ra
		


_printCell:
	#print open parens
	la $a0, openParen
	li $v0, 4
	syscall
	
	addi $sp, $sp -4
	sw $ra, 4($sp)
	jal _getRow
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	#Print Row
	add $a0, $zero, $v0
	li $v0, 1
	syscall
	
	#print open comma
	la $a0, comma
	li $v0, 4
	syscall
	
	addi $sp, $sp -4
	sw $ra, 4($sp)
	jal _getCol
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	#Print Col
	add $a0, $zero, $v0
	li $v0, 1
	syscall
	
	#print open parens
	la $a0, closedParen
	li $v0, 4
	syscall
	
	jr $ra

########################################################
# Pops a move from moves array
# Outputs:
#	$v0 : move
########################################################
_popMove:
	beqz $s0, popMoveEnd
	
	subi $t0, $s0, 1
	li $t1, 4
	mult $t0, $t1
	mflo $t0
	
	lw $v0, moves($t0)
	sw $zero, moves($t0)
	subi $s0, $s0, 1
	
	popMoveEnd:
		jr $ra

_logMove:
	li $t0, 0
	beqz $s0, logMoveAddMove

	subi $t5, $s0, 2				# setting $t5 to count - 2... 1 for indexing, 1 to check 2nd to last

	li $t0, 4
	mult $t5, $t0
	mflo $t0

	lw $t1, moves($t0)
	
	addi $sp, $sp -4
	sw $ra, 4($sp)
	jal _cellEqualT9
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	bnez $v0, logMoveDeleteMove
	beqz $v0, logMoveAddMove

	logMoveDeleteMove:
		subi $t5, $s0, 1
		li $t0, 4
		mult $t5, $t0
		mflo $t0

		sw $zero, moves($t0)
		subi $s0, $s0, 1
		jr $ra
		
	logMoveAddMove:
		li $t0, 4
		mult $s0, $t0
		mflo $t0
		sw $t9, moves($t0)
		addi $s0, $s0, 1
		jr $ra

########################################################
# Checks if a given Cell is equal to the current cell
# Inputs:
# 	$t1: number 1
# Outputs:
#	$v0 : bool
########################################################

_cellEqualT9:
	add $v0, $zero, $t9	#col $t9
	srl $v0, $v0, 16	
	andi $v0, $v0, 255
	
	add $v1, $zero, $t1 	#col $t1
	srl $v1, $v1, 16
	andi $v1, $v1, 255	
	
	bne $v0, $v1, cellEqualFalse
	
	add $v0, $zero, $t9	# row $t9
	srl $v0, $v0, 24
	add $v1, $zero, $t1	# row $t1
	srl $v1, $v1, 24
	
	bne $v0, $v1, cellEqualFalse
	beq $v0, $v1, cellEqualTrue
	
	cellEqualTrue:
		li $v0, 1
		jr $ra
	cellEqualFalse:
		li $v0, 0
		jr $ra
		

########################################################
# Returns 1 if car is in cell (0, -1) 
# Outputs:
#	$v0 : bool
########################################################
_isAtBeggining:
	addi $sp, $sp -4
	sw $ra, 4($sp)
	jal _getRow
	add $t0, $zero, $v0
	jal _getCol
	add $t1, $zero, $v0
	lw $ra, 4($sp)
	addi $sp, $sp, 4

	bne $t0, 0, isAtBegginingNo
	bne $t1, 255, isAtBegginingNo
	
	li $v0, 1
	jr $ra
	
	isAtBegginingNo:
		li $v0, 0
		jr $ra

			
########################################################
# Returns 1 if game is over
# Outputs:
#	$v0 : Bool
########################################################
_isGameOver:
	addi $sp, $sp -4
	sw $ra, 4($sp)
	jal _getRow
	add $t0, $zero, $v0
	jal _getCol
	add $t1, $zero, $v0
	lw $ra, 4($sp)
	addi $sp, $sp, 4	

	bne $t0, 7, gameOverNo
	bne $t1, 8, gameOverNo
	
	li $v0, 1
	jr $ra
	
	gameOverNo:
		li $v0, 0
		jr $ra


################################################################################################################
#
# THE FOLLOWING CODE BELOW ARE THE HANDLERS FOR THE $t9 REGISTER
#
################################################################################################################

########################################################
# Returns the Car's current row
# Outputs:
#	$v0 : row
########################################################
_getRow:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 24	# shift right 24 bits
	jr $ra
	
########################################################
# Returns the Car's current col
# Outputs:
#	$v0 : col
########################################################
_getCol:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 16	# shift right logical 16bits
	andi $v0, $v0, 255
	jr $ra
	
########################################################
# Returns 1 if car is facing north
# Outputs:
#	$v0 : isNorth
########################################################
_isNorth:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 11	# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	jr $ra
	
########################################################
# Returns 1 if car is facing south
# Outputs:
#	$v0 : isSouth
########################################################
_isSouth:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 9		# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	jr $ra
	
########################################################
# Returns 1 if car is facing east
# Outputs:
#	$v0 : isEast
########################################################
_isEast:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 10	# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	jr $ra
	
########################################################
# Returns 1 if car is facing west
# Outputs:
#	$v0 : isWest
########################################################
_isWest:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 8		# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	jr $ra
	
########################################################
# Returns 1 if wall in front of car
# Outputs:
#	$v0 : isWall
########################################################
_isWallFront:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 3		# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	jr $ra
	
########################################################
# Returns 1 if wall behind of car
# Outputs:
#	$v0 : isWall
########################################################
_isWallBehind:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	andi $v0, $v0, 1	# get value of last bit
	jr $ra
	
########################################################
# Returns 1 if wall on right of robot
# Outputs:
#	$v0 : isWall
########################################################
_isWallRight:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 1		# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	jr $ra
	
########################################################
# Returns 1 if wall on left of robot
# Outputs:
#	$v0 : isWall
########################################################
_isWallLeft:
	add $v0, $zero, $t9	# Set value of $v0 to be $t9
	srl $v0, $v0, 2		# shift right 11 bits
	andi $v0, $v0, 1	# get value of last bit
	jr $ra



#########################################################
gameOver:
	li $v0, 10
	syscall
_backtracking2:
 	addi $sp, $sp, -8
 	sw $ra, 0($sp)
 	sw $s0, 4($sp)

 	add $s0, $a0, $zero
 
  	jal _getCol				# if at dest
	subi $t0, $v0, 8
	jal _getRow 
	subi $t1, $v0, 7
	or $t0, $t0, $t1
	beq $t0, $zero, backtrackReturnTrue	# return true
	
backtrackCheckNorth:
	addi $a0, $zero, 0
	jal _turnToFace
	jal _getFront
	bne $v0, $zero, backtrackCheckEast
	addi $t0, $zero, 2
	beq $t0, $s0, backtrackCheckEast
	jal _move
	jal _backtracking2
	bne $v0, $zero, backtrackReturnTrue
	addi $a0, $zero, 2
	jal _turnToFace
	jal _move
	j backtrackCheckEast
	
backtrackCheckEast:
	addi $a0, $zero, 1
	jal _turnToFace
	jal _getFront
	bne $v0, $zero, backtrackCheckSouth
	addi $t0, $zero, 3
	beq $t0, $s0, backtrackCheckSouth
	jal _move
	jal _backtracking2
	bne $v0, $zero, backtrackReturnTrue
	addi $a0, $zero, 3
	jal _turnToFace
	jal _move
	j backtrackCheckSouth
	
backtrackCheckSouth:
	addi $a0, $zero, 2
	jal _turnToFace
	jal _getFront
	bne $v0, $zero, backtrackCheckWest
	addi $t0, $zero, 0
	beq $t0, $s0, backtrackCheckWest
	jal _move
	jal _backtracking2
	bne $v0, $zero, backtrackReturnTrue
	addi $a0, $zero, 0
	jal _turnToFace
	jal _move
	j backtrackCheckWest
	
backtrackCheckWest:
	addi $a0, $zero, 3
	jal _turnToFace
	jal _getFront
	bne $v0, $zero, backtrackReturnFalse
	addi $t0, $zero, 1
	beq $t0, $s0, backtrackReturnFalse
	jal _move
	jal _backtracking2
	bne $v0, $zero, backtrackReturnTrue
	addi $a0, $zero, 1
	jal _turnToFace
	jal _move
	j backtrackReturnFalse
	
backtrackReturnFalse:
	add $v0, $zero, 0
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
backtrackReturnTrue:
	add $v0, $zero, 1
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
 
 
 # _turnToFace
 # turns to face the given direction
 # parameters:
 # $a0 - the direction to face 0 = north, 1 = east, 2 = south, 3 = west
_turnToFace:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	jal _getDirection
	add $s0, $v0, $zero
	beq $s0, $a0, turnToFaceDone	# if facing the right way, return
	
	addi $t0, $s0, -1
	seq $t1, $t0, $a0
	addi $t0, $s0, 3
	seq $t2, $t0, $a0
	or $t1, $t1, $t2
	bne $t1, $zero, turnToFaceLeft
	
	add $t0, $s0, 1
	seq $t1, $t0, $a0
	addi $t0, $s0, -3
	seq $t2, $t0, $a0
	or $t1, $t1, $t2
	bne $t1, $zero, turnToFaceRight
	
	j turnToFaceBack
	
turnToFaceLeft:
	jal _turnLeft
	j turnToFaceDone
	
turnToFaceRight:
	jal _turnRight
	j turnToFaceDone

turnToFaceBack:
	jal _turnLeft
	jal _turnLeft
	j turnToFaceDone
	
turnToFaceDone:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
 
 # _getDirectionTo
 # gets the direction from point A to point B (assuming they share an axis)
 # parameters:
 # $a0 - column of A
 # $a1 - row of A
 # $a2 - column of B
 # $a3 - row of B
 # returns:
 # $v0 - 0 = north, 1 = east, 2 = south, 3 = west, -1 = same point
_getDirectionTo:
	slt $t0, $a2, $a0
	bne $t0, $zero, getDirectionWest
	slt $t0, $a0, $a2
	bne $t0, $zero, getDirectionEast
	slt $t0, $a3, $a1
	bne $t0, $zero, getDirectionNorth
	slt $t0, $a1, $a3
	bne $t0, $zero, getDirectionSouth
	
	addi $v0, $zero, -1
	jr $ra
	
getDirectionNorth:
	addi $v0, $zero, 0
	jr $ra
	
getDirectionEast:
	addi $v0, $zero, 1
	jr $ra
	
getDirectionSouth:
	addi $v0, $zero, 2
	jr $ra
	
getDirectionWest:
	addi $v0, $zero, 3
	jr $ra


 # _readStep
 # reads a step from the list of steps
 # parameters: 
 # $a0 - the address of the step array
 # $a1 - the index of the step to read
 # returns:
 # $v0 - the col value of the step read
 # $v1 - the row value of the step read
_readStep:
	sll $a1, $a1, 1
	add $a0, $a0, $a1
	lb $v0, ($a0)
	lb $v1, 1($a0)
	jr $ra

 # _writeStep
 # adds a step to the list of steps
 # parameters:
 # $a0 - the address of the step aray
 # $a1 - the index of the step to add
 # $a2 - the col value of the step to be added
 # $a3 - the row value of the step to be added
_writeStep:
	sll $a1, $a1, 1
	add $a0, $a0, $a1
	sb $a2, ($a0)
	sb $a3, 1($a0)
	jr $ra

 # _move
 # moves the robot forward one space
_move:
	addi $t8, $zero, 1
moveWait:
	bne $t8, $zero, moveWait
	jr $ra
	
 # _turnLeft
 # turns the robot left
_turnLeft:
	addi $t8, $zero, 2
turnLeftWait:
	bne $t8, $zero, turnLeftWait
	jr $ra
	
 # _turnRight
 # turns the robot right
_turnRight:
	addi $t8, $zero, 3
turnRightWait:
	bne $t8, $zero, turnRightWait
	jr $ra
	
 # _update
 # updates the status of the car
_update:
	addi $t8, $zero, 4
updateWait:
	bne $t8, $zero, updateWait
	jr $ra

 # _getRow
 # gets the current row of the robot
 # returns:
 # v0 - signed row of robot
#_getRow:
#	sra $v0, $t9, 24
#	jr $ra

 # _getCol
 # gets the current colun of the robot
 # returns:
 # v0 - signed column of robot
##	sll $v0, $t9, 8
#	sra $v0, $v0, 24
#	jr $ra

 # _getDirection
 # checks which direction the car is facing
 # returns:
 # v0 - 0 = north, 1 = east, 2 = south, 3 = west 
_getDirection:
	andi $v0, $t9, 0x800
	beq $v0, $zero, getDirEast
	addi $v0, $zero, 0
	jr $ra
getDirEast:
	andi $v0, $t9, 0x400
	beq $v0, $zero, getDirSouth
	addi $v0, $zero, 1
	jr $ra
getDirSouth:
	andi $v0, $t9, 0x200
	beq $v0, $zero, getDirWest
	addi $v0, $zero, 2
	jr $ra
getDirWest:
	addi $v0, $zero, 3
	jr $ra

 # _getFront
 # checks for a wall in front of the robot
 # returns:
 # v0 - 1 if there is a wall, 0 if there is not
_getFront:
	srl $v0, $t9, 3
	andi $v0, $v0, 1
	jr $ra

 # _getLeft
 # checks for a wall to the left of the robot
 # returns:
 # v0 - 1 if there is a wall, 0 if there is not
_getLeft:
	srl $v0, $t9, 2
	andi $v0, $v0, 1
	jr $ra

 # _getRight
 # checks for a wall to the right of the robot
 # returns:
 # v0 - 1 if there is a wall, 0 if there is not
_getRight:
	srl $v0, $t9, 1
	andi $v0, $v0, 1
	jr $ra

 # _getBack
 # checks for a wall to the back of the robot
 # returns:
 # v0 - 1 if there is a wall, 0 if there is not
_getBack:
	andi $v0, $t9, 1
	jr $ra
