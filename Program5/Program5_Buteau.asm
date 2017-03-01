TITLE Array Sort     (Program5.asm)

; Author: Thomas Buteau
; CS271-400 / Project 5                 Date: 3-5-17
; Description: This program generates a user determined number, between
;			10 and 200, of random numbers and puts them in an array.
;			The array is then displayed, sorted from largest to smallest,
;			then the sorted array is also displayed along with the median
;			value which is rounded to the nearest int.

INCLUDE Irvine32.inc

; (insert constant definitions here)
USER_MIN	=	10	; minimum user defined range of numbers for the array
USER_MAX	=	200	; maximum user defined range of numbers for the array
RAND_MIN	=	100	; minimum randomly generated number
RAND_MAX	=	999	; maximum randomly generated number

.data
intro1	byte		"Array Sort",0
intro2	byte		"By Thomas Buteau",0
intro3	byte		"Enter the amount of numbers in the array.",0
intro4	byte		"The min/max array size is 10/200.",0
error1	byte		"User input out of range. Enter a number between 10 and 200.",0
disp1	byte		"The values in the array are: ",0
space1	byte		"	",0
medi1	byte		"The median value in the array is ",0

arrSize	dword	?
array	dword	USER_MAX	DUP(?)
; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)
	call		Randomize ;seeds random for RandomRange
	call		intro
	push		OFFSET	array
	push		OFFSET	arrSize
	call		getUserData
	call		generate
	call		display
	call		sort
	call		median
	call		display

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;	introduction procedure
;	Inputs: none
;	Outputs: none
;	Description: Prints out greeting statements.
intro PROC
	;starting message
	mov		EDX, OFFSET intro1
	call		WriteString
	call		Crlf
	
	mov		EDX, OFFSET intro2
	call		WriteString
	call		Crlf

	ret

intro ENDP

;	getUserData procedure
;	Inputs: none
;	Outputs: arrSize EAX, EDX (EAX and EDX used in validate PROC)
;	Description: Asks user for amount of numbers to fill array with,
;			validates input with validate procedure, and sets
;			arrSize equal to user input.
getUserData PROC
	;user instructions
	push		EBP
	mov		EBP, ESP
	mov		EDX, OFFSET intro3
	call		WriteString
	call		Crlf
	mov		EDX, OFFSET intro4
	call		WriteString
	call		Crlf
	call		ReadInt
	push		EAX
	push		EDX
	call		validate
	pop		EAX
	mov		EBX, [EBP+8]
	mov		[EBX], EAX
	pop		EBP
	ret
getUserData ENDP

;	validate procedure
;	Inputs: EDX, EAX
;	Outputs: EAX
;	Description: First checks EDX to see if non-integer has been
;			entered, then compares EAX to USER_MAX and
;			USER_MIN. If any tests fail displays error, gets
;			user input again, and rechecks data. EAX is valid
;			when the procedure is done.
validate PROC
	push		EBP
	mov		EBP, ESP
	mov		EDX, [EBP+8]
	mov		EAX, [EBP+12]
	jmp		check ;jumps over error message initially

inval:	;error message
	mov		EDX, OFFSET error1
	call		WriteString
	call		ReadInt
	call		Crlf

check:	;checks EAX against upper and lower limits
	jo		inval ;goes to end if non-integer is entered
	cmp		EAX, USER_MAX
	jnle		inval ;goes to end if greater than 200
	cmp		EAX, USER_MIN
	jnge		inval ;goes to end if less than 10
	mov		[EBP+12], EAX
	pop		EBP
	ret 4	;pops the EDX value off the stack and returns
validate ENDP

;	generate procedure
;	Inputs: array, arrSize (both from system stack)
;	Outputs: none
;	Description: Fills the array up to arrSize with random integers that
;			range from RAND_MIN to RAND_MAX.
generate PROC
	push		EBP
	mov		EBP, ESP

	;This section of code is based on the Mult.asm code sample
	;on page 357 of textbook
	cld		
	mov		ESI, [EBP+12]	;move array address to ESI
	mov		EDI, ESI
	mov		EAX, [EBP+8]	;move arrSize to ECX
	mov		ECX, [EAX]

Arrgen:	;loop that generates random ints and puts them in the array
	mov		EAX, RAND_MAX
	sub		EAX, RAND_MIN
	inc		EAX
	call		RandomRange
	add		EAX, RAND_MIN
	stosd
	loop		Arrgen

	pop		EBP
	ret
generate ENDP

;	display procedure
;	Inputs: array, arrSize (both from system stack)
;	Outputs: none
;	Description: Prints the contents of array to the screen with a
;			line break every 10 items.
display PROC
	push		EBP
	mov		EBP, ESP
	cld		
	mov		ESI, [EBP+12]	;move array address to ESI
	mov		EAX, [EBP+8]	
	mov		ECX, [EAX]	;move arrSize to ECX

	mov		EDX, OFFSET disp1
	call		WriteString
	call		Crlf
	

PrintL:	;loop that prints the contents of the array
	lodsd
	call		WriteDec
	mov		EDX, OFFSET space1
	call		WriteString
	mov		EBX, [EBP+8]
	mov		EAX, [EBX]
	inc		EAX
	sub		EAX, ECX
	cmp		EAX, 0
	je		PrintL2
	mov		EBX, 10
	mov		EDX, 0
	div		EBX
	cmp		EDX, 0
	jne		PrintL2
	call		Crlf
PrintL2:	;PrintL loop part 2
	loop		PrintL

	call		Crlf

	pop		EBP
	ret
display ENDP

;	sort procedure
;	Inputs: array, arrSize (both from system stack)
;	Outputs: none
;	Description: Sorts the array in descending order. Largely taken
;			from BubbleSort program on page 375 of textbook.
sort PROC
	push		EBP
	mov		EBP, ESP

	mov		EBX, [EBP+8]
	mov		ECX, [EBX]	;move arrSize to ECX
	dec		ECX

L1:
	push		ECX
	mov		EBX, [EBP+12]	;move array address to ESI
	mov		ESI, EBX

L2:
	mov		EAX, [ESI]
	cmp		[ESI+4], EAX
	jnge		L3
	xchg		EAX, [ESI+4]
	mov		[ESI], EAX

L3:
	add		ESI, 4
	loop		L2

	pop		ECX
	loop		L1
	
	pop		EBP
	ret
sort ENDP

median PROC
	push		EBP
	mov		EBP, ESP

	mov		EBX, [EBP+8]
	mov		EAX, [EBX]	;move arrSize to EAX
	mov		EDX, 0
	mov		EBX, 2
	div		EBX
	mov		EBX, 4
	mul		EBX
	mov		ESI, [EBP+12]
	mov		EAX, [ESI+EAX]

	mov		EDX, OFFSET medi1
	call		Crlf
	call		WriteString
	call		WriteDec
	call		Crlf
	call		Crlf

	pop		EBP
	ret
median ENDP

END main
