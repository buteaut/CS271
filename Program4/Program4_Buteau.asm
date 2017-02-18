TITLE Composite Numbers Project     (Project4.asm)

; Author: Thomas Buteau
; CS271-400 / Project 4                 Date: 2-19-17
; Description: This program take in a number from the user ranging 
;			from 1 to 400 then calculates and displays that many
;			composite (non-prime) numbers at 10 per line.

INCLUDE Irvine32.inc

;constant values
UPPER_LIMIT	=	400
LOWER_LIMIT	=	1

.data

intro1	byte		"Composite Numbers",0
intro2	byte		"By Thomas Buteau",0
intro3	byte		"Enter the number of composites to be displayed.",0
intro4	byte		"Up to 400 composites can be displayed.",0
error1	byte		"User input out of range. Enter a number between 1 and 400.",0
compcnt	dword	? ;user entered composite count
currcnt	dword	? ;current number of composites displayed
lastchk	dword	2 ;last number examined
space	byte		"	",0
ec1		byte		"**EC: Output columns are alined.",0


outtro1	byte	"This concludes the program.",0

.code
main PROC

	call		intro

	call		getUserData
	
	call		showComposites

	call		bye

	call		Crlf ;break point to test program
	exit	; exit to operating system
main ENDP


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
	
	mov		EDX, OFFSET ec1
	call		WriteString
	call		Crlf
	
	ret

intro ENDP

;	getUserData procedure
;	Inputs: none
;	Outputs: compcnt EAX, EDX (EAX and EDX used in validate PROC)
;	Description: Asks user for number of composites to display
;			validates input with validate procedure and sets
;			compcnt equal to user input.
getUserData PROC
	;user instructions
	mov		EDX, OFFSET intro3
	call		WriteString
	call		Crlf
	mov		EDX, OFFSET intro4
	call		WriteString
	call		Crlf
	call		ReadInt
	call		validate
	mov		compcnt, EAX

	ret
getUserData ENDP

;	validate procedure
;	Inputs: EDX, EAX
;	Outputs: EAX
;	Description: First checks EDX to see if non-integer has been
;			entered, then compares EAX to UPPER_LIMIT and
;			LOWER_LIMIT. If any tests fail displays error, gets
;			user input again, and rechecks data. EAX is valid
;			when the procedure is done.
validate PROC
	jmp		check ;jumps over error message initially

inval:	;error message
	mov		EDX, OFFSET error1
	call		WriteString
	call		ReadInt
	call		Crlf

check:	;checks EAX against upper and lower limits
	jo		inval ;goes to end if non-integer is entered
	cmp		EAX, UPPER_LIMIT
	jnle		inval ;goes to end if greater than 400
	cmp		EAX, LOWER_LIMIT
	jnge		inval ;goes to end if less than 1
	ret
validate ENDP

;	showComposites procedure
;	Inputs: compcnt
;	Outputs: none
;	Description: Loop that calls showComposites and writes
;			the resulting composite then a space and every
;			10 entries goes to a new line. Loop continues
;			for compcnt number of times.
showComposites PROC
	mov	ECX, compcnt

prtl:	;print loop
	call		isComposite
	call		WriteDec
	mov		EDX, OFFSET space
	call		WriteString
	inc		currcnt ;tracks number of composites printed
	mov		EAX, currcnt
	mov		EBX, 10
	mov		EDX, 0
	div		EBX		
	cmp		EDX, 0	;compares remainder to 0
	jne		prtl2	;if currcnt mod 10 != 0 jump
	call		Crlf		;new line every 10 entries
prtl2:	;print loop part 2
	loop		prtl		
	
	call		Crlf		;new line after all entries are finished

	ret
showComposites ENDP

;	isComposite procedure
;	Inputs: lastchk
;	Outputs: EAX
;	Description: Determines if the number after lastchk is a composite
;			via a division loop checking for remainders. If it is a 
;			composite the procedure sets EAX equal to it and ends.
;			If not it increments lastchk and continues until one is
;			found.
isComposite PROC
	push		EBX
	push		ECX
	push		EDX

checkstart:	
	inc		lastchk
	mov		ECX, lastchk
	dec		ECX
	dec		ECX
	mov		EBX, 1

checkComp:	;loop checks for factors of lastchk
	mov		EAX, lastchk
	mov		EDX, 0
	inc		EBX
	div		EBX
	cmp		EDX, 0
	jz		isComp ;factors found, jump to isComp
	loop		checkComp ;EBX is not factor, try EBX+1
	jmp		checkStart ;no factors, try new number

isComp:
	mov		EAX, lastchk ;moves most recent composite to EAX
	pop		EDX
	pop		ECX
	pop		EBX
	ret
isComposite ENDP

;	bye procedure
;	Inputs: none
;	Outputs: none
;	Description: End of program statements.
bye PROC
	;goodbye message
	mov		EDX, OFFSET outtro1
	call		WriteString
	call		Crlf
	
	ret
bye ENDP

END main
