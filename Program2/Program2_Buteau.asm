TITLE Fibonacci Project     (Project2.asm)

; Author: Thomas Buteau
; Course / Project ID                 Date: 1-29-17
; Description: This program take in a number anywhere from 1 to 46, 
;			ensures through data validation that the input is 
;			correct, then calculates and displays the Fibonacci 
;			sequence to that number.

INCLUDE Irvine32.inc
; (insert constant definitions here)
UPPER_LIMIT = 46
LOWER_LIMIT = 1

.data
; (insert variable definitions here)
intro1 byte "Fibonacci Sequence",0
intro2 byte "By Thomas Buteau",0
intro3 byte "Please enter your name: ",0
userName byte 21 dup(0)
greeting byte "Greetings, ",0
request1 byte "How many numbers would you like from the Fibonacci sequence?",0
request2 byte "Enter a number between 1 and 46: ",0
userNum DWORD ?
rangeError1 byte "The value entered is out of range.",0
exit1 byte "This concludes the program.",0
exit2 byte "Goodbye, ",0
loopTemp DWORD ?
fibTemp DWORD ?
strTab byte "	",0
innerLoopCount DWORD ?


.code
main PROC
; (insert executable instructions here)
	;starting message
	mov		edx, OFFSET intro1
	call		WriteString
	call		Crlf
	mov		edx, OFFSET intro2
	call		WriteString
	call		Crlf
	
	;Requests the user's name
	mov		edx, OFFSET intro3
	call		WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call		ReadString ;Input validation if time is available
	
	;user greeting
	mov		edx, OFFSET greeting
	call		WriteString
	mov		edx, OFFSET userName
	call		WriteString
	call		Crlf

	;request Fibonacci sequence limit
	mov		edx, OFFSET request1
	call		WriteString
	call		Crlf
	mov		edx, OFFSET request2
	call		WriteString
	call		ReadDec  ;Need to add input validation here
	mov		userNum, EAX
	call		Crlf

	mov		ECX, userNum
	mov		EAX, 1
	mov		EBX, 1
	mov		loopTemp, 2
L1:	;loop for Fibonacci sequence
	mov		innerLoopCount, 5
	call		Crlf
	mov		EDX, OFFSET strTab
	cmp		loopTemp, 2
	je		L3 ;jump to L3 for first two numbers in sequence
L2:	;inner loop writes one line
	mov		fibTemp, EAX
	add		EAX, EBX
	mov		EBX, fibTemp
	call		WriteDec
	call		WriteString
	dec		innerLoopCount
	cmp		innerLoopCount, 0
	LOOPZ	L1 ;jumps to L1 every 5th number
	inc		ECX ;fixes ECX after LOOPZ decrements it
	loop		L2
	
	cmp		ECX, 0
	je		L4

L3:	;loop for first two numbers in sequence
	call		WriteDec
	call		WriteString
	dec		innerLoopCount
	dec		loopTemp
	cmp		loopTemp, 0
	loopne	L3
	inc		ECX
	loop		L2

L4:
	call Crlf
	mov		EDX, OFFSET exit1
	call		WriteString
	call		Crlf

	mov		EDX, OFFSET exit2
	call		WriteString
	mov		EDX, OFFSET userName
	call		WriteString
	call		Crlf
	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
