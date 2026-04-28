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
gainMessage: .asciiz "You Won: $"
lossMessage: .asciiz "You Lost: $"
repromptMessage: .asciiz "Would you like to play again? (Enter 'Y' or 'N')"
playerBroke: .asciiz "You have no more money, sorry..."
casinoBroke: .asciiz "The casino has no more money, congratulations!"
arrow: .asciiz "->"
dollarSign: .asciiz "$"
houseHas: .asciiz "The house currently has: $"
playerHas: .asciiz "The player currently has: $"
casinoHoldings: .word 100 # house starts with $100
playerHoldings: .word 50 # player starts with $50

.text
lw $t0, playerHoldings # current money
lw $s7, casinoHoldings

#Print the hello message
printString(helloplayerMsg)

#Print the wager message
printString(wagerMsg)

#Print casino and player amount
currentHoldings

#Read the wager amount
printString(dollarSign)
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
	j playerWin
playerWin:
	printString(pWinMessage)
	li $t8, 1 # flag for player win
	newLine
	j roundEnd
dealerWin:
	printString(dWinMessage)
	li $t8, 2 # flag for dealer win
	newLine
	j roundEnd
tieGame:
	printString(tiedMessage)
	li $t8, 0 # flag for tie
	newLine
	j roundEnd
	
hit:
	printString(pHand)
	dealCard(playerHandValue, playerHasAce)
	printInt(playerHandValue)
	newLine
	ble playerHandValue, 21, decisionLoop
	#only happens if over 21
	printString(bustMessage)
	newLine
	li $t8, 2
	j roundEnd
	
# $t8 is a flag: 1 for player win, 2 for dealer win
roundEnd:
	beq $t8, 1, wagerWon
	beq $t8, 2, wagerLost
	currentHoldings
	j reprompt # tie, neither wins/loses money
	
wagerWon:
	add $t0, $t0, betAmount
	sub $s7, $s7, betAmount
	printString(gainMessage)
	printInt($t1)
	newLine
	currentHoldings
	j reprompt
	
wagerLost:
	sub $t0, $t0, betAmount
	add $s7, $s7, betAmount
	printString(lossMessage)
	printInt($t1)
	newLine
	currentHoldings
	j reprompt

reprompt:
	# ask player if they'd like to continue
	# if either player or casino is broke, end-game
	bgt $t0, 0, checkCasino # If money > 0, skip broke message
	printString(playerBroke)
	j exit

checkCasino:
	# checks if casino is broke
	bgt $s7, 0, askToContinue
	printString(casinoBroke)
	j exit

askToContinue:
	printString(repromptMessage)
	li $v0, 8
	la $a0, impBuffer
	li $a1, 5
	syscall

	#check input
	la $s3, impBuffer
	lb $s3, 0($s3)
	li $s4, 'Y'
	beq $s3, $s4, resetWager
	li $s4, 'y'
	beq $s3, $s4, resetWager
	
	j exit # exit if 'N'

resetWager:
	# reset wager if player wants to bet a different amount
	printString(wagerMsg)
	printString(dollarSign)
	li $v0, 5
	syscall
	move $t1, $v0 # update the betAmount ($t1)
	j startGame
	
#TODO: Make it loop back to startGame with a player choice
exit:
	exitProgram
