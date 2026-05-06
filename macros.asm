#macros for the project
.data
	nL: .asciiz "\n"
	divides: .asciiz "--------------------------------\n"
	A: .asciiz "Ace"
	J: .asciiz "Jack"
	Q: .asciiz "Queen"
	K: .asciiz "King"
	#full deck never gets edited while base deck gets cards removed from it
	baseDeckSize: .word 52
	fullDeck: .word 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13
	baseDeck: .word 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13
	
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

.macro divider
	printString(divides)
.end_macro 

.macro currentHoldings
	#Print casino amount
	printString(houseHas)
	printInt($s7)
	newLine

	#Print player amount
	printString(playerHas)
	printInt($t0)
	newLine
.end_macro

#TODO t7 t9

.macro refillDeck #only as macro to look better/less clutter in dealCard
refillLoop:	
	beq $t9, 52, endRefill 
	lw $s1, ($t7) 
	sw $s1, ($s0) #takes and puts number from full deck into baseDeck
	add $s0, $s0, 4
	add $t7, $t7, 4
	add $t9, $t9, 1
	j refillLoop
endRefill:
.end_macro 


.macro dealCard(%personHandValue,%aceRegister)
	#adds drawn card's value to person's hand value and updates ace
	la $t9, baseDeckSize
	lw $t9, ($t9) 
	#get the current deck's size; skip over refill deck section if deck size isnt 0
	bgtz $t9, drawCard 
	
	#load addresses for refillDeck loop; $t9 becomes a counter
	la $s0, baseDeck
	la $t7, fullDeck
	refillDeck
	
	#after refill, set baseDeckSize back to 52
	la $s0, baseDeckSize
	sw $t9, ($s0) 
drawCard:
	#Random Number Generator (puts a number from 0 to basedecksize-1 into $a0)
	li $v0, 42 
	li $a0, 0
	lw $a1, baseDeckSize 	
	syscall
	
	#change RN into deck's card (ex 50->13->K) and removes the card from deck
	la $s0, baseDeck
	la $t9, baseDeckSize
	lw $t9, ($t9) #gets the deck's size
	sub $t9, $t9, 1 #last value is n-1 where n is number of cards in deck 
	mul $t9, $t9, 4 
	add $s0, $s0, $t9
	lw $t9, ($s0)  #sets t9 to the last value of baseDeck
	
	la $s0, baseDeck #reset address
	mul $a0, $a0, 4
	add $s0, $s0, $a0
	lw $s1, 0($s0) #set $s1 to value of drawn card
	
	
	sw $t9, ($s0) #overwrites the drawn card with the value of the last
	la $t9, baseDeckSize
	lw $t7, ($t9)
	sub $t7, $t7, 1
	sw $t7, ($t9) #decrease baseDeckSize
	
	#branches for non number cards (ace,jack,queen,king)
	beq $s1, 1, drawAce
	beq $s1, 11, drawFace
	beq $s1, 12, drawFace
	beq $s1, 13, drawFace
	
	add %personHandValue, %personHandValue, $s1
	j bustCheck
	
drawAce:
	beq %aceRegister, 1, hasAce
	
	add %personHandValue, %personHandValue, 11
	li %aceRegister, 1
	j bustCheck
	#done to cover for 2 aces in hand
	hasAce:
		add %personHandValue, %personHandValue, 1
		j bustCheck
		
drawFace:
	#11,12,13 = J,Q,K = 10
	add %personHandValue, %personHandValue, 10
	j bustCheck
	
bustCheck:
	#Here to check if bust, if so covert any aces from 11 to 1
	ble %personHandValue, 21, endingJump
	beq %aceRegister, 0, endingJump
	
	#calls if handVal >= 22 and has ace; converts ace 11 to 1
	li %aceRegister, 0
	sub %personHandValue, %personHandValue, 10
	
endingJump:
.end_macro 

#use register $s1 for the card after a dealCard macro
.macro printCard(%register) 
	beq %register, 1, Ace
	beq %register, 11, Jack
	beq %register, 12, Queen
	beq %register, 13, King
	#if regular number
	printInt(%register)
	j exitMacro
Ace:
	printString(A)
	j exitMacro 
Jack:
	printString(J)
	j exitMacro 
Queen:
	printString(Q)
	j exitMacro 
King:
	printString(K)
exitMacro:
.end_macro 

