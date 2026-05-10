# CS2640-Project: Blackjack
A program made using Mars MIPS Assembler and Runtime Simulator 

## About the Program
This program is meant to simulate games of Blackjack through the Run I/O tab of Mars IDE.  
This can be used to practice card counting or just to have fun
### What Blackjack is and How it Works
Blackjack is a casino game with a player and a dealer. A standard deck of 52 cards is used and the goal is to get as close to the number 21 without going over.  
Ace cards are worth either 1 or 11 points and face cards are worth 10 points. The cards from 2-9 are all worth their respective number in points.
The player bets money and when they win, they get paid at a ratio of 1 to 1 (double the amount you put in) while a loss means they lose their bet. Busting is when the player goes over 21 and loses the round.
  
A round starts with both the player and dealer drawing 2 cards. The dealer will have 1 card face-up while the other is face-down. 
The player is given the option to hit, stand, or double down. Hitting is when the player draws another card and standing is when the player doesn't want to draw anymore.
Doubling down means that the player doubles the amount that they bet and draw exactly one more card. They cannot draw anymore after doubling down.  
After standing or hitting into a 21, the dealer will draw cards till they get or go over 17. If the dealer busts then the player wins.
If the player's first two cards equal 21, then they instantly win with a payout of 3 to 2 (win 1.5 times the bet amount). 

The deck only refills its cards once all 52 cards are gone.
## How to Run the Program
1) Open Mars IDE jar file
2) Press file in the top left then open
3) Select and open both 'ProjectMain.asm' and Macros.asm using step 2
4) Navigate to 'ProjectMain.asm'
5) Press the wrench and screwdriver icon to assemble the code
6) Press the green play button to start the program
7) Interact with the program in the Run I/O tab at the bottom and follow the prompts