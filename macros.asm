#macros for the project
.data
	nL: .asciiz "\n"
	baseDeck: .word 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13
.text

.macro printString(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro 

.macro printInt(%Int)
	li $v0, 1
	move $a0, %Int
	syscall
.end_macro 

.macro exitProgram
	li $v0, 10
	syscall
.end_macro 

.macro newLine
	printString(nL)
.end_macro 

.macro currentHoldings
	#Print casino amount
	printString(houseHas)
	printInt($s7)
	newLine

	#Print player amount
	printString(playerHas)
	printInt($t0)
	newLine
.end_macro

.macro dealCard(%personHandValue,%aceRegister)
	#adds drawn card's value to person's hand value and updates ace
	
	#Random Number Generator (puts a number from 0-51 into $a0)
	li $v0, 42 
	li $a0, 0
	li $a1, 52
	syscall
	
	#change RN into deck's card (ex 50->13->K)
	la $s0, baseDeck
	mul $a0, $a0, 4
	add $s0, $s0, $a0
	lw $s1, 0($s0)
	
	#branches for non number cards (ace,jack,queen,king)
	beq $s1, 1, drawAce
	beq $s1, 11, drawFace
	beq $s1, 12, drawFace
	beq $s1, 13, drawFace
	
	add %personHandValue, %personHandValue, $s1
	j bustCheck
	
drawAce:
	beq %aceRegister, 1, hasAce
	
	add %personHandValue, %personHandValue, 11
	li %aceRegister, 1
	j bustCheck
	#done to cover for 2 aces in hand
	hasAce:
		add %personHandValue, %personHandValue, 1
		j bustCheck
		
drawFace:
	#11,12,13 = J,Q,K = 10
	add %personHandValue, %personHandValue, 10
	j bustCheck
	
bustCheck:
	#Here to check if bust, if so covert any aces from 11 to 1
	ble %personHandValue, 21, endingJump
	beq %aceRegister, 0, endingJump
	
	#calls if handVal >= 22 and has ace; converts ace 11 to 1
	li %aceRegister, 0
	sub %personHandValue, %personHandValue, 10
	
endingJump:
.end_macro 
