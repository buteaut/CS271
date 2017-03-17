TITLE Macro Array     (Program6a.asm)

; Author: Thomas Buteau
; CS271-400 / Project 6a                Date: 3-19-17
; Description: This program utilizes macros and procedures to collect an array of 
;		10 unsigned 32bit numbers from the user then display them as well as 
;		their sum and average.

INCLUDE Irvine32.inc

; (insert constant definitions here)
ARR_MAX	=	10	;maximum amount of numbers in the array
USER_MIN	=	1	;minimum number accepted from user
USER_MAX	=	429496729	;max number accepted from user
;displayString macro taken from lecture 26 video mWriteStr macro
displayString	MACRO	buffer
	push	EDX
	mov	EDX, [buffer]
	call	WriteString
	pop	EDX
ENDM

;getString macro taken from lecture 26 video mReadStr macro with small alterations
getString	MACRO	buffer, prompt
	push	ECX
	push	EDX
	mov	EDX, [prompt]
	call	WriteString
	mov	EDX, [buffer]
	mov	ECX, 11 ;hardcoded to continue testing, fix before deadline
	call	ReadString
	pop	EDX
	pop	ECX
ENDM

.data
intro1	byte		"Macro Array",0
intro2	byte		"By Thomas Buteau",0
intro3	byte		"Enter 10 positive integers and I'll display them as well as their sum and average.",0
intro4	byte		"User value: ",0

read1	byte		11	DUP(0) ;user input string to convert to number
covnum	dword	?	;converted number from user input string
arrSize	dword	ARR_MAX
intArr	dword	ARR_MAX	DUP(?)
result1	byte		"The array of integers is as follows:",0
tab1		byte		"	",0
result2	byte		"The sum of the integers is: ",0
result3	byte		"The average of the integers is: ",0
sum		qword	0
mean		dword	0

error1	byte		"The user entry is not a valid positive integer, please try again.",0

; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)
	push	OFFSET	intro1
	push	OFFSET	intro2
	push	OFFSET	intro3

	call	intro

	push	OFFSET	covnum
	push	OFFSET	intArr
	push			arrSize
	push	OFFSET	error1
	push	OFFSET	intro4
	push	OFFSET	read1

	call readVal

	push OFFSET	intArr
	push			arrSize
	push	OFFSET	sum

	call sumArr

	push	OFFSET	sum
	push			arrSize
	push	OFFSET	mean

	call	aveArr

	;push	OFFSET	sum

	;call	writeVal
	push	OFFSET	mean
	push	OFFSET	result3
	push	OFFSET	sum
	push	OFFSET	result2
	push	OFFSET	tab1
	push	OFFSET	intArr
	push			arrSize
	push	OFFSET	result1
	call	results
	
	;call	WriteDec ;testing purposes
	call	Crlf
	exit	; exit to operating system
main ENDP



;	introduction procedure
;	Inputs: none
;	Outputs: none
;	Description: Prints out greeting statements.
intro PROC
	;starting message
	push		EBP
	mov		EBP, ESP
	displayString	EBP+16 ;Title
	call		Crlf
	displayString	EBP+12 ;Author
	call		Crlf
	displayString	EBP+8 ;Description
	call		Crlf
	call		Crlf
	
	pop		EBP
	ret	12

intro ENDP

;	getUserData procedure
;	Inputs: read1, intro4, error1, arrSize, intArr, covnum (all from system stack)
;	Outputs: intArr
;	Description: runs loop that gets user data, calls validate, then adds 
;			user data to array.
readVal PROC
	;user instructions
	push		EBP
	mov		EBP, ESP
	mov		ECX, [EBP+20] ;arrSize
	mov		EDI, [EBP+24] ;intArr
ArrLoop1: ;loops getting input from user and putting it in the array
	getString	EBP+8, EBP+12
	call		Crlf
	call	validate
	mov		ESI, [EBP+28] ;covnum
	mov		EAX,[ESI]
	cld
	stosd ;adds EAX value to location stored in EDI
	loop arrLoop1
	pop		EBP
	ret	24
readVal ENDP

;	validate procedure
;	Inputs: read1, intro4, error1, covnum (all from system stack)
;	Outputs: covnum (on system stack)
;	Description: Converts user string into integer then checks if integer is
;			in acceptable range. If not gets new string from user and repeats.
validate PROC
	push		EAX
	push		ECX
	push		EDX
	push		ESI
	push		EBP
	mov		EBP, ESP
	mov		ESI, [EBP+52]
	jmp		convert 

inval:	
	displayString	EBP+40 ;error message
	call		Crlf
	getString	EBP+32, EBP+36 ;ask user for input
	call		Crlf

convert:
	mov		EDX,	[EBP+32]
	call		ParseDecimal32 ;converts string in EDX to number in EAX
				
check:	;checks EAX against upper and lower limits
	cmp		EAX, USER_MAX
	jnle		inval ;goes to end if greater than 200
	cmp		EAX, USER_MIN
	jnge		inval ;goes to end if less than 10

	mov		[ESI],EAX

	pop		EBP
	pop		ESI
	pop		EDX
	pop		ECX
	pop		EAX
	ret 
validate ENDP

;	sumArr procedure
;	Inputs: intArr, arrSize, sum (all from system stack)
;	Outputs: sum (on system stack)
;	Description: Adds all the values in intArr and pushes the result to sum.
sumArr PROC
	push		ESI
	push		EBX
	push		EAX
	push		ECX
	push		EBP
	mov		EBP, ESP
	mov		ECX, [EBP+28] ;intArr
	mov		ESI, [EBP+24] ;arrSize
	mov		EBX, [ESI] ;sum variable
	mov		ESI, [EBP+32]

sumL1:
	cld
	lodsd	;loads next number from intArr into EAX
	add		EBX, EAX
	loop		sumL1
	mov		EAX, [EBP+24]
	mov		[EAX], EBX ;moves sum to sum variable

	pop		EBP
	pop		ECX
	pop		EAX
	pop		EBX
	pop		ESI
	ret	12
sumArr ENDP

;	aveArr procedure
;	Inputs: sum, arrSize mean (all from system stack)
;	Outputs: mean (on system stack)
;	Description: Divides sum by arrSize and pushed the result to mean.
aveArr PROC
	push		EAX
	push		EBX
	push		EDX
	push		ESI
	push		EBP
	mov		EBP, ESP
	mov		ESI, [EBP+32]
	mov		EAX, [ESI] ;sum
	mov		EBX, [EBP+28] ;arrSize
	mov		ESI, [EBP+24] ;mean

	mov		EDX, 0
	div		EBX
	mov		EBX, EAX 
	mov		[ESI], EBX  ;moves average in mean

	pop		EBP
	pop		ESI
	pop		EDX
	pop		EBX
	pop		EAX
	ret	12

aveArr ENDP

;	writeVal procedure
;	Inputs: number from system stack
;	Outputs: None
;	Description: Takes the number on the top of the stack, converts it
;			to a string and prints it.
writeVal PROC
.data	
	intStr	byte	11	DUP(0) ;local string for printing integers
.code
	push		EAX
	push		EBX
	push		ECX
	push		EDX
	push		EDI
	push		ESI
	push		EBP
	mov		EBP, ESP

	mov		EDX, 0
	mov		EAX, [EBP+32] ;number to convert to string
	mov		EBX, 10 ;to ensure each digit is recorded
	mov		ECX, 0 ;count of digits pushed to stack
	mov		EDI, OFFSET intStr

	cmp		EAX, 10
	jge		strLoop ;jumps to loop if number is 2 or more digits long
	add		EAX, 48 ;convert to ASCII character
	push		EAX
	inc		ECX
	jmp		wrtLoop

strLoop:
	mov		EDX, 0
	div		EBX
	add		EDX, 48 ;convert to ASCII character
	push		EDX
	inc		ECX
	cmp		EAX, 10
	jge		strLoop ;if remainder exists loop

	add		EAX, 48 ;convert to ASCII character
	push		EAX
	inc		ECX

wrtLoop:	;writes digits in stack to intStr
	cld
	pop		EAX
	stosb	
	loop		wrtLoop

	displayString	OFFSET intStr

	mov		EDI, OFFSET intStr
	mov		ECX,	SIZEOF intStr
	mov		EAX, 0
	cld
	rep		stosd ;clears the string for the next iteration
	
	pop		EBP
	pop		ESI
	pop		EDI
	pop		EDX
	pop		ECX
	pop		EBX
	pop		EAX
	ret	4
writeVal ENDP

;	results procedure
;	Inputs: result1, arrSize, intArr, tab1, result2, sum, result3, mean (from system stack)
;	Outputs: None
;	Description: Prints out the array, sum, and average.
results PROC
	push		EAX
	push		ECX
	push		EDX
	push		ESI
	push		EBP
	mov		EBP, ESP

	displayString	EBP+24 ;result1
	call		Crlf

	mov		ECX, [EBP+28] ;arrSize
	mov		ESI, [EBP+32] ;intArr 
	cld

ArrayL1:
	lodsd
	push		EAX
	call		writeVal
	displayString	EBP+36 ;tab
	loop		ArrayL1
	call		Crlf

	displayString	EBP+40 ;result2
	call		Crlf

	mov		ESI, [EBP+44] ;sum
	mov		EAX, [ESI]
	push		EAX
	call		writeVal
	call		Crlf

	displayString	EBP+48 ;result3
	call		Crlf

	mov		ESI, [EBP+52] ;mean
	mov		EAX, [ESI]
	push		EAX
	call		writeVal
	call		Crlf

	pop		EBP
	pop		ESI
	pop		EDX
	pop		ECX
	pop		EAX

	ret 32
results ENDP

END main
