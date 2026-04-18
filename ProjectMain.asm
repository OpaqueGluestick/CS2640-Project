#Group 3: Anthony Keshishian, Gavin Mah, Muhammad Ebueng, Sebastian Gutierrez
#4/13/2026
#Blackjack Project

.include "macros.asm"
#rough guess of t-register's uses
.eqv currentMoney $t0
.eqv betAmount $t1
.eqv dealerHiddenCardValue $t2
.eqv dealerHandValue $t3
.eqv playerHandValue $t4
.eqv dealerHasAce $t5
.eqv playerHasAce $t6

.data
baseDeck: .word a, a, a, a, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, J, J, J, J, Q, Q, Q, Q, K, K, K, K

.text
dealCard:
	#Random Number Generator (puts a number from 0-51 into $a0)
	li $v0, 42 
	li $a0, 0
	li $a1, 52
	syscall
	#move $t5 ,$a0  (may change)

	printInt($t2)
	
	exitProgram