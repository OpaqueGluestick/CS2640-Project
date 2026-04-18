#Group 3: Anthony Keshishian, Gavin Mah, Muhammad Ebueng, Sebastian Gutierrez
#4/13/2026
#Blackjack Project

.include "macros.asm"
.eqv currentMoney $t0
.eqv betAmount $t1
.eqv dealerHiddenCardValue $t2

.data
	
.text
dealCard:
	#Random Number Generator (puts a number from 0-51 into $t2)
	li $v0, 42 
	li $a0, 0
	li $a1, 52
	syscall
	move $t2 ,$a0
	
	printInt($t2)
	
	exitProgram