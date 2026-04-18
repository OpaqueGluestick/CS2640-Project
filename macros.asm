#macros for the project
.data
	nL: .asciiz "\n"
	baseDeck: .word a, a, a, a, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, J, J, J, J, Q, Q, Q, Q, K, K, K, K
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

.macro addTo(%location,%value)
	add %location, %location, %value
.end_macro 

.macro subFrom(%location,%value)
	sub %location, %location, %value
.end_macro 

.macro dealCard(%personHandValue,%aceRegister)
	#adds drawn card's value to person's hand value and updates ace
	
	#Random Number Generator (puts a number from 0-51 into $a0)
	li $v0, 42 
	li $a0, 0
	li $a1, 52
	syscall
	
	#change RN into deck's card (ex 50->K)
	la $s0, baseDeck
	mul $a0, $a0, 4
	lw $a0, $a0($s0)
	
	beq $a0, 'a', drawAce
	beq $a0, 'J', drawJ
	beq $a0, 'Q', drawQ
	beq $a0, 'K', drawK
drawAce:
	beq %aceRegister, 1, hasAce
	
	add %personHandValue, %personHandValue, 11
	li %aceRegister, 1
	
	hasAce:
		add %personHandValue, %personHandValue, 1
	
drawJ:
drawQ:
drawK:
bustAceCheck:
	beq %aceRegister, 1, endingJump
endingJump:
.end_macro 
