#Group 3: Anthony Keshishian, Gavin Mah, Muhammad Ebueng, Sebastian Gutierrez
#4/13/2026
#Blackjack Project

.include "macros.asm"
.eqv $t0, currentMoney
.eqv $t1, betAmount
.eqv $t2, dealerHiddenCardValue

.data
	
.text
dealCard:
	#Random Number Generator (a0=seed, a1=upper limit not inclusive, output to a0)
	li $v0, 42 
	li $a0, 0
	li $a1, 53
	move $t2 ,$a0
	
	