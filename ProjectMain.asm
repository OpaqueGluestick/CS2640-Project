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
#Ace:(0=false 1=true)
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
	#initialize hands
	li dealerHasAce, 0
	li dealerHandValue, 0
	li playerHasAce, 0
	li playerHandValue, 0
	
	#test/example of dealing a card to player (remove # to see or copy & paste to run multiple draws)
	#printInt(playerHandValue)
	#newLine
	#dealCard(playerHandValue, playerHasAce)
	#printInt(playerHandValue)
	
	exitProgram