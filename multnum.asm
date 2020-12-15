;ECE 109 001 Fall 2019
;Sam Huneycutt (shhuneyc)
;created 23 September 2019
;Program 1: Digit Multiplication Program: compute the product of two single digit numbers
;

	.ORIG	x3000
	
;
;Get first input character from user
;
	LEA R0, PROMPT1		;print PROMPT1 string
	PUTS

	;Digits 0-9 have ASCII codes 48-57
CHAR1 	GETC			;request character
	OUT			;echo
	LD R7, QUIT		;load q ASCII code (113)
	ADD R7, R0, R7		;compare input character to 113 (q)
	BRz EXIT		;if q, jump to exit code
	LD R5, REJECT		;load 9 ASCII code opposite (-57)
	ADD R1, R0, R5		;add character code and -57
	BRp CHAR1		;positive result represents ASCII code > 57, not digit. Get new character from user
	LD R6, NEG30		;load 0 ASCII code opposite (-48)
	ADD R1, R0, R6		;add character code and -48
	BRn CHAR1		;negative result represents ASCII code < 48, not digit. Get new character from user

;
;Get second imput character from user    
;Process is identical except number is stored in R2
;
	LEA R0,	PROMPT2		;print PROMPT2 string
	PUTS

CHAR2 	GETC
	OUT
	LD R7, QUIT         
	ADD R7, R0, R7
	BRz EXIT
	ADD R2, R0, R5
	BRp CHAR2
	ADD R2, R0, R6
	BRn CHAR2
	;R1 contains first input number
	;R2 contains second input number


;
;multiply using repeated addition
;
	;R3 is product
	;R4 is counter
	AND R3, R3, #0		;clear R3
	AND R4, R4, #0		;clear R4
	ADD R4,	R1, #0		;set R4 to the first input number
	BRnp MULT		;skips the special code below if the result is nonzero
	
ZERO	;
	;In the special case that the first input digit is 0, the logic used at MULT will give a false answer
	;To mitigate, manually set R1 and R2 to zero and jump to RESULT where 00 will be printed
	AND R1, R1, 0
	AND R2, R2, 0
	LEA R7, RESULT
	JMP R7


MULT	ADD R3, R3, R2		;add second input number to R3
	ADD R4, R4, #-1		;decrement counter
	BRp MULT		;loop until counter is zero
	;R3 contains the product as a raw number


;    
;separate the number into digits by repeatedly subtracting 10 
;
	AND R2, R2, #0		;clear R2 (counter)

DIGIT	ADD R2, R2, 1		;increment counter (count how many 10s are in the number)
	ADD R3, R3, #-10	;subtract 10 from product
	BRzp DIGIT		;continue into result is negative

	;we have actually incremented the counter 1 too high and subtracted 1 too many 10s from the product

	ADD R1, R3, #10		;add the extra 10 back (to get remainder)
	ADD R2, R2, #-1		;decrement counter (# of 10s)

	;R1 contains the 1's digit of product (remainder)
	;R2 contains the 10's digit of product

;
;Print result to screen
;
RESULT	LEA R0, PROMPT3		;print PROMPT4 string
	PUTS
	
	LD R6, PLUS30		;load ASCII offset (x30)
	ADD R2, R2, #0		;check if the 10s digit is zero
	BRz ONE			;skip printing the 10s digit if it is zero
TEN	ADD R0, R2, R6		;add ASCII offset to 10s digit
	OUT			;print character
ONE	ADD R0, R1, R6		;add ASCII offset to 1s digit
	OUT			;print character

	LD R7, BEGIN		;load memory address x3000
	JMP R7			;jump to x3000 (beginning of instructions)



;exit code for when user enters q 
EXIT	LEA R0, PROMPT4		;print PROMPT4
	PUTS
	HALT			;stop execution



PROMPT1	.STRINGZ	"\nEnter First Number (0-9): "
PROMPT2	.STRINGZ	"\nEnter Second Number (0-9): "
PROMPT3	.STRINGZ	"\nThe product of the two numbers is: "
PROMPT4	.STRINGZ	"\nThank you for playing!"
NEG30	.FILL	#-48		;negative ASCII offset
REJECT	.FILL	#-57		;-ASCII 9
PLUS30	.FILL	#48		;positive ASCII offset
BEGIN	.FILL	x3000		;PC start x3000
QUIT	.FILL	#-113		;-ASCII q

	.END