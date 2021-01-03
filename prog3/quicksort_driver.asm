; Program #3: Quick Sort
; Author:     Maddison Davenport
; Date:       4/9/2019

.686
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:WORD

INCLUDE debug.h
INCLUDE str_utils.h
INCLUDE quicksort.h

MAXLEN		EQU 14 

.STACK 4096

.DATA

	array		WORD 1000 DUP(?)
	num			WORD ?
	string		BYTE MAXLEN DUP(?)
	source		BYTE ?
	dest		BYTE ?
	prompt      BYTE "*****Sorted*****"

.CODE
_start:

	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0

	lea ebx, array

	while_loop:
	
		input string, MAXLEN
		cmp string, 'x'
		je done_while
		
		lea eax, string
		
		mov ecx, 0
		mov esi, eax
		mov edi, ebx
		cld
		mov cx, MAXLEN
		
		rep movsb
		
		mov BYTE PTR [edi], 0
		
		add ebx, MAXLEN
		
		inc num
		
		jmp while_loop
		
	done_while:
	
		lea ebx, array
		
		output [ebx]
		output carriage
		
		mov cx, 0
		
	print_while:	
	
		inc cx
			
		cmp cx, num
		je end_print
			
		add ebx, MAXLEN			
		output [ebx]
		output carriage
			
		jmp print_while
			
	end_print:
		
		quicksort array, num, MAXLEN
		
		lea ebx, array
		
		output carriage
		output prompt
		output carriage
		output carriage

		lea ebx, array
		
		mov cx, 0
		
	print_sorted_while:	
		
		cmp cx, num
		je done
				
		output [ebx]
		add ebx, MAXLEN	
		output carriage
		inc cx
			
		jmp print_sorted_while
		
	done:		

INVOKE ExitProcess, 0

PUBLIC _start
END
	
	