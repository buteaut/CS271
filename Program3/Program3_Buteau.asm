TITLE Number Crunch Project     (Project3.asm)

; Author: Thomas Buteau
; CS271-400 / Project 3                 Date: 2-12-17
; Description: This program take in numbers from the user ranging 
;			from -1 to -100 until the user enters a number 
;			outside of this range. Then the program the amount
;			of numbers entered, their sum, and average.

INCLUDE Irvine32.inc

; constant definitions
UPPER_LIMIT = -1
LOWER_LIMIT = -100

.data

; (insert variable definitions here)
intro1	byte	"Number Crunch",0
intro2	byte	"By Thomas Buteau",0
intro3	byte	"Please enter your name: ",0
userName	byte 21 dup(0)
greeting	byte	"Greetings, ",0
request1	byte	"Enter numbers between -100 and -1 and I will crunch them for you.",0
request2	byte	"Entering a number outside of this range begins the crunch.",0
request3	byte	"Enter number: ",0
intCount	dword	0
intSum	dword	0
error1	byte	"No valid numbers were entered.",0
numCount1	byte	"The amount of valid entries is: ",0
numCount2	byte	" numbers within the accepted range.",0
sumText	byte "The sum of those numbers is ",0
avgText	byte	"The average of those numbers is ",0
bye1		byte	"Thank you for running Number Crunch.",0
bye2		byte	"Goodbye, ",0

.code
main PROC
	
	;starting message
	mov		EDX, OFFSET intro1
	call		WriteString
	call		Crlf
	mov		EDX, OFFSET intro2
	call		WriteString
	call		Crlf
	
	;Requests the user's name
	mov		EDX, OFFSET intro3
	call		WriteString
	mov		EDX, OFFSET userName
	mov		ECX, SIZEOF userName
	call		ReadString
	
	;user greeting
	mov		EDX, OFFSET greeting
	call		WriteString
	mov		EDX, OFFSET userName
	call		WriteString
	call		Crlf

	;user instructions
	mov		EDX, OFFSET request1
	call		WriteString
	call		Crlf
	mov		EDX, OFFSET request2
	call		WriteString
	call		Crlf

	;user input loop
InLoop:
	mov		EDX, OFFSET request3
	call		WriteString
	call		ReadInt
	jo		Summary ;goes to end if non-integer is entered
	cmp		EAX, UPPER_LIMIT
	jnle		Summary ;goes to end if greater than -1
	cmp		EAX, LOWER_LIMIT
	jnge		Summary ;goes to end if less than -100

	;adds to the sum
	mov		EBX, intSum
	add		EBX,EAX 
	mov		intSum, EBX

	;adds to the count
	mov		EAX, intCount
	add		EAX,1 
	mov		intCount, EAX
	jmp		InLoop ;loops until user enters bad data

	;error message if no valid numbers are entered
Error:
	mov		EDX, OFFSET error1
	call		WriteString
	call		Crlf
	jmp		Bye

	;calculates and prints results
Summary:
	;jumps to error message if no valid numbers are entered
	cmp		intCount, 0
	jz		Error
	
	;prints amount of numbers entered
	mov		EDX, OFFSET numCount1
	call		Crlf
	call		WriteString
	mov		EAX, intCount
	call		WriteDec
	call		Crlf

	;prints sum of numbers entered
	mov		EDX, OFFSET sumText
	call		WriteString
	mov		EAX,intSum
	call		WriteInt
	call		Crlf

	;calculates and prints average of numbers enterd
	mov		EDX, OFFSET avgText
	call		WriteString
	mov		EAX, intSum
	CDQ		;extends the sign bit into EDX
	IDIV		intCount
	call		WriteInt
	call		Crlf

Bye:
	;goodbye statements
	mov		EDX, OFFSET bye1
	call		WriteString
	call		Crlf
	mov		EDX, OFFSET bye2
	call		WriteString
	mov		EDX, OFFSET userName
	call		WriteString
	call		Crlf
	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
