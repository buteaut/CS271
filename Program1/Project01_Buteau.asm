TITLE Arithmetic Project     (Project1.asm)

; Author: Thomas Buteau
; Course / Project ID                 Date: 1-12-17
; Description: This program take in 2 numbers from the user then performs various arithmetic operations on them and displays the results.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

author	BYTE		"by Thomas Buteau",0
title1	BYTE		"		Arithmetic Project		",0
prompt0	BYTE		"Please enter 2 numbers to see their sum, difference, product, quotient, and remainder.",0
prompt1	BYTE		"First Number: ",0
num1		DWORD		?
prompt2	BYTE		"Second Number: ",0
num2		DWORD		?
val_add	DWORD		?
val_sub	DWORD		?
val_mul	DWORD		?
val_div	DWORD		?
val_mod	DWORD		?
plus		BYTE		" + ",0
minus	BYTE		" - ",0
division	BYTE		" / ",0
multi	BYTE		" * ",0
remain	BYTE		" remainder ",0
equals	BYTE		" = ",0
exit1	BYTE		"This concludes the program, bye.",0


.code
main PROC

; Introduction section
	mov		edx,	OFFSET title1
	call		WriteString
	mov		edx, OFFSET author
	call		WriteString
	call		CrLf
	call		CrLf
	
; User input section	
	mov		edx, OFFSET prompt0
	call		WriteString
	call		CrLf
	
	mov		edx, OFFSET prompt1
	call		WriteString
	call		ReadInt
	mov		num1, eax
	
	mov		edx, OFFSET prompt2
	call		WriteString
	call		ReadInt
	mov		num2, eax
	call		CrLf
	
; Calculation section
	mov		eax, num1
	add		eax, num2
	mov		val_add, eax

	mov		eax, num1
	sub		eax, num2
	mov		val_sub, eax

	xor		edx, edx	;set edx to 0
	mov		eax, num1
	mul		num2
	mov		val_mul, eax

	xor		edx, edx	;set edx to 0
	mov		eax, num1
	div		num2
	mov		val_div, eax
	mov		val_mod, edx

; Display results section

; Addition
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET plus
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET equals
	call		WriteString
	mov		eax, val_add
	call		WriteDec
	call		CrLf

; Subtraction
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET minus
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET equals
	call		WriteString
	mov		eax, val_sub
	call		WriteDec
	call		CrLf

; Multipication
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET multi
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET equals
	call		WriteString
	mov		eax, val_mul
	call		WriteDec
	call		CrLf

; Division and Remainder
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET division
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET equals
	call		WriteString
	mov		eax, val_div
	call		WriteDec
	mov		edx, OFFSET remain
	call		WriteString
	mov		eax, val_mod
	call		WriteDec
	call		CrLf
	call		CrLf

; Exit message
	mov		edx, OFFSET exit1
	call		WriteString
	call		CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
