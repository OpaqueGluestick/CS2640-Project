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
helloplayerMsg: .asciiz "Hello player, welcome to our Blackjack simulation\n"
wagerMsg: .asciiz "How much would you like to wager? \n"

.text
#Print the hello message
printString(helloplayerMsg)

#Print the wager message
printString(wagerMsg)

#Read the wager amount
li $v0, 5
syscall
move $t1, $v0

startGame:
	#initialize hasAce (0=false 1=true)
	li dealerHasAce, 0
	li platerHasAce, 0

