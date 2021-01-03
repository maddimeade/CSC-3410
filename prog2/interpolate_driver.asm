; Program #2: Newton's Interpolating Polynomials
; Author:     Maddison Davenport
; Date:       3/19/2019

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE interpolate.h
INCLUDE compute_b.h
INCLUDE float.h
INCLUDE sort_points.h
INCLUDE debug.h

.STACK  4096

.DATA

points			REAL4 40 DUP(?)
tolerance		REAL4 0.0001
x				REAL4 ?
result			REAL4 ?
point			WORD 0
deg				WORD ?
prompt1			BYTE "Enter the x-coordinate of the desired interpolated y.", CR, LF, 0
prompt2			BYTE "Enter the degree of the interpolating polynomial.",CR, LF, 0
prompt3			BYTE "You may enter up to 20 points, one at a time.", CR, Lf, 0
quitPrompt		BYTE "Input q to quit.", CR, LF, 0
resultPrompt	BYTE "The result: ", 0

.CODE
_start:

	output prompt1
	input text, 8
	atof text, x
	
	output prompt2
	input text, 8
	atoi text
	
	mov deg, ax
	
	output prompt3
	output quitPrompt
	mov ecx, 0
	mov cx, 40
	lea ebx, points
	
while_loop:
	
	cmp text, 'q'
	je done_while

	cmp cx, 0
	je done_while
	
	input text, 8
	atof text, REAL4 PTR [ebx]
	add ebx, 4
	inc point
	dec cx
	
	jmp while_loop
	
done_while:
	
	shr point, 1
	
	sort_points points, x, tolerance, point
	
	print_points points, point
	
	output carriage
	
	interpolate points, x, deg, result
	
	output resultPrompt
	
	ftoa result, WORD PTR 4, WORD PTR 9, text

	output text
	
	output carriage

INVOKE ExitProcess, 0
	
PUBLIC _start

END