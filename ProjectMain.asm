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
choicePrompt: .asciiz "Hit or Stand? (Enter 'H' or 'S') "
dHand: .asciiz "Dealer Hand: "
questionmark: .asciiz "?"
plusSign: .asciiz " + "
pHand: .asciiz "Your Hand Value: "
impBuffer: .space 5
bustMessage: .asciiz "Bust"
pWinMessage: .asciiz "You Win"
dWinMessage: .asciiz "Dealer Wins"
tiedMessage: .asciiz "Its a Tie"
arrow: .asciiz "->"

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
	
newHand:
	#Deal Starting Hands
	printString(dHand)#Dealer Hand Value: # + ?
	dealCard(dealerHandValue, dealerHasAce)
	dealCard(dealerHiddenCardValue, dealerHasAce)
	printInt(dealerHandValue)
	printString(plusSign)
	printString(questionmark)
	newLine
	
	printString(pHand)
	dealCard(playerHandValue, playerHasAce)
	printInt(playerHandValue)
	printString(arrow)
	dealCard(playerHandValue, playerHasAce)
	#TODO: make it show 1st card + 2nd card instead of total hand value (currently shows "1st card" + "(1st + 2nd)"
	printInt(playerHandValue)
	newLine
	
decisionLoop:
	printString(choicePrompt)
	li $v0, 8
	la $a0, impBuffer
	li $a1, 5
	syscall
	
	#check input
	la $s2, impBuffer
	lb $s2, 0($s2)
	li $s3, 'H'
	beq $s2, $s3, hit
stand:
	#remind player of their hand
	printString(pHand)
	printInt(playerHandValue)
	newLine
	
	#reveal hand's value
	printString(dHand)
	add dealerHandValue, dealerHandValue, dealerHiddenCardValue
	printInt(dealerHandValue)
	newLine
	
	#dealer hand < 16 = hit; else stand (subject to change)
dealerHitLoop:
	bge dealerHandValue, 17, checkWinner
	printString(dHand)
	dealCard(dealerHandValue, dealerHasAce)
	printInt(dealerHandValue)
	newLine
	
	j dealerHitLoop
	
checkWinner:
	bge dealerHandValue, 22, playerWin
	beq dealerHandValue, playerHandValue, tieGame
	bgt dealerHandValue, playerHandValue, dealerWin
	#if not above then player hand > dealer hand and goes to player win 
playerWin:
	printString(pWinMessage)
	j exit
dealerWin:
	printString(dWinMessage)
	j exit
tieGame:
	printString(tiedMessage)
	j exit
	
hit:
	printString(pHand)
	dealCard(playerHandValue, playerHasAce)
	printInt(playerHandValue)
	newLine
	ble playerHandValue, 21, decisionLoop
	#only happens if over 21
	printString(bustMessage)
#TODO: Make it loop back to startGame with a player choice
exit:
	exitProgram
