#macros for the project
.data
	nL: .asciiz "\n"
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

.macro addTo(%location,%value)
	add %location, %location, %value
.end_macro 

.macro subFrom(%location,%value)
	sub %location, %location, %value
.end_macro 
