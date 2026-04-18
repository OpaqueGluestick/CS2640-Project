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
	#Random Number Generator (a0=seed, a1=upper limit not inclusive, output to a0)
	li $v0, 42 
	li $a0, 0
	li $a1, 53
	syscall
	move $t2 ,$a0
	
	printInt($t2)
	
	exitProgram