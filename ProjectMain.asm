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
dHand: .asciiz "Dealer Hand Value: "
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
dollarSign: .asciiz "$"
houseHas: .asciiz "The house currently has: $"
playerHas: .asciiz "The player currently has: $"
dealerDrawMsg: .asciiz "The Dealer Drew: "
playerDrawMsg: .asciiz "The Player Drew: "
casinoHoldings: .word 100 # house starts with $100
playerHoldings: .word 50 # player starts with $50
playerBlackjackMessage: .asciiz "Congrats on the blackjack!"

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
	li dealerHiddenCardValue, 0
	li playerHasAce, 0
	li playerHandValue, 0
	
newHand:
	divider
	#Deal Starting Hands
	printString(dealerDrawMsg)#The Dealer Drew: # + ?
	dealCard(dealerHandValue, dealerHasAce)
	printCard($s1)
	move $s5, $s1 #saves card for when player stands
	dealCard(dealerHiddenCardValue, dealerHasAce)
	move $s6, $s1 #saves the exact card drawn for later reveal
	printString(plusSign)
	printString(questionmark)
	newLine
	
	printString(playerDrawMsg)
	dealCard(playerHandValue, playerHasAce)
	printCard($s1)
	printString(plusSign)
	dealCard(playerHandValue, playerHasAce)
	printCard($s1)
	newLine
	divider
decisionLoop:
	printString(choicePrompt)
	li $v0, 8
	la $a0, impBuffer
	li $a1, 5
	syscall
	newLine
	
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
	printString(dealerDrawMsg)
	printCard($s5)
	printString(plusSign)
	printCard($s6)
	add dealerHandValue, dealerHandValue, dealerHiddenCardValue
	newLine
	newLine
	#dealer hand < 16 = hit; else stand (subject to change)
dealerHitLoop:
	bge dealerHandValue, 17, checkWinner
	dealCard(dealerHandValue, dealerHasAce)
	printString(dealerDrawMsg)
	printCard($s1)
	newLine
	printString(dHand)
	printInt(dealerHandValue)
	newLine
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
	printString(playerDrawMsg)
	dealCard(playerHandValue, playerHasAce)
	printCard($s1)
	newLine
	printString(pHand)
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
	divider
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
