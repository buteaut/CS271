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
intro1 byte "Number Crunch",0
intro2 byte "By Thomas Buteau",0
intro3 byte "Please enter your name: ",0
userName byte 21 dup(0)
greeting byte "Greetings, ",0
request1 byte "How many numbers would you like from the Fibonacci sequence?",0
.code
main PROC
	
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
	call		ReadString
	
	;user greeting
	mov		edx, OFFSET greeting
	call		WriteString
	mov		edx, OFFSET userName
	call		WriteString
	call		Crlf
	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
