; Program #1: Vankin's Mile
; Author:     Maddison Davenport
; Date:       3/5/2019

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:WORD

INCLUDE debug.h

.STACK 4096

.DATA
grid			WORD 100 DUP(?)
outputGrid		WORD 100 DUP(?)
rows			WORD ?
colS			WORD ?
row				WORD 1
col				WORD 1
arrayCounter	WORD 1
MAXNBRS			WORD ?
string			BYTE 8 DUP(?), 0
result_string   BYTE 8 DUP(?), 0
loc             WORD 0
loc2			WORD 0
			
setElement	MACRO matrix_addr, row, col, loc
			local wloop, done
						
				push eax
				push ebx
				push ecx
				push edx
				
				lea ebx, matrix_addr
						
				;getting location
				mov ax, row
				sub ax, 1
				mov dx, cols
				
				mul dx 
				mov cx, col
				sub cx, 1
				add ax, cx 
				mov cx, 0
				
				wloop:				
					cmp cx, ax
					je done
						
					add ebx, 2
					inc cx
					cmp cx, ax
					jl wloop
							
				done:
					mov ax, loc
					;atoi loc
					mov [ebx], ax
					
				pop edx
				pop ecx
				pop ebx
				pop eax
					
				ENDM

getElement	MACRO matrix_addr, row, col, loc
			local wloop, done
				
				push eax
				push ebx
				push ecx
				push edx
				
				lea ebx, matrix_addr
					
				mov ax, row
				sub ax, 1
				mov dx, cols
				mul dx 	
						
				mov cx, col
				sub cx, 1
				add ax, cx 
				mov cx, 0
							
				cmp cx, ax
				je done
							
				wloop:
					add ebx, 2
					inc cx
					cmp cx, ax
					jl wloop
							
				done:
				;itoa loc, [ebx]
				mov ax, [ebx]
				mov loc, ax
				
				pop edx
				pop ecx
				pop ebx
				pop eax
			
			ENDM
		
output_grid	MACRO	matrix_addr, row, col
			local while1, while2, done1, done2
					
				push ebx
				push ecx
				push edx
					
				lea ebx, matrix_addr
				mov cx, row
					
				while1:
				cmp cx, 0
				je done1
	
				mov dx, col
					
				while2:
				cmp dx, 0
				je done2
			
				itoa string, [ebx]
				output string
				add ebx, 2
			
				dec dx
				jmp while2
					
				done2:
		
				output carriage
				dec cx
				jmp while1
					
				done1:
				output carriage
				
				pop edx
				pop ecx
				pop ebx
				
			ENDM
.CODE
_start:

	inputW string, rows
	inputW string, cols
	mov ax, rows
	mov cx, cols
	mul cx
	mov MAXNBRS, ax
	
	lea ebx, grid
	mov ecx, 0			
	mov cx, MAXNBRS
	
	while_loop:
	
		cmp cx, 0
		je end_loop
			
		input string, 8		
		atoi string
		mov [ebx], ax
		add ebx, 2					
			
		dec cx
		jmp while_loop
	
	end_loop:
		
		output_grid grid, rows, cols
		
		 mov ax, 1
		 mov row, ax
		
		 mov ax, 1
		 mov col, ax
		
	while_grid_into_output:
	
		getElement grid, row, col, loc
		setElement outputGrid, row, col, loc
		
		inc arrayCounter
		
		mov ax, MAXNBRS
		cmp ax, arrayCounter
		jl end_grid_into_output
		
		inc col
		mov ax, col
		cmp ax, cols
		jg increase_row
		
		jmp while_grid_into_output
		
		increase_row:
			inc row
			mov ax, row
			cmp ax, rows
			jg end_grid_into_output
		
			mov ax, 1
			mov col, ax
			
			jmp while_grid_into_output
		
	
	end_grid_into_output:
	
	
		mov ax, rows
		mov row, ax
		
		mov ax, cols
		mov col, ax
	
	while_bottom_row:
	 
		getElement outputGrid, row, col, loc
		
		dec col	
		;mov cx, 0
		cmp col, WORD PTR 0
		je end_bottom_row				
		
		;mov al, 0
		cmp loc, WORD PTR 0
		jle while_bottom_row
			
		getElement outputGrid, row, col, loc2
		mov ax, 0
		mov ax, loc2
		add ax, loc
		mov loc2, ax
		setElement outputGrid, row, col, loc2
			
		jmp while_bottom_row
		
	end_bottom_row:
	
		mov ax, cols
		mov col, ax
		
		dec row
	
	while_solve:
		
		;mov ax, 0
		cmp row, WORD PTR 0
		je end_solve
			
		inc row
		getElement outputGrid, row, col, loc
		dec row
		
		;mov al, 0
		cmp loc, WORD PTR 0
		jle while_solve2
			
		getElement outputGrid, row, col, loc2
		mov ax, loc2
		add ax, loc
		mov loc2, ax
		setElement outputGrid, row, col, loc2
		
	while_solve2:
		getElement outputGrid, row, col, loc	
		dec col
		;mov ax, 0
		cmp col, WORD PTR 0
		je end_solve2
				
		inc row
		getElement outputGrid, row, col, loc2	
		dec row
				
		mov ax, loc
		cmp ax, loc2
		jl add_bottom				
				
		getElement outputGrid, row, col, loc2
		mov ax, loc2
		add ax, loc
		mov loc2, ax
		setElement outputGrid, row, col, loc2
		jmp done_add
				
	add_bottom:
		getElement outputGrid, row, col, loc
		mov ax, loc2
		add ax, loc
		mov loc2, ax
		setElement outputGrid, row, col, loc2
				
	done_add:
		jmp while_solve2
	
	end_solve2:
			
		dec row
			
		mov ax, cols
		mov col, ax
			
		jmp while_solve
			
	end_solve:
	
		output_grid outputGrid, rows, cols
	
	mov ax, 1
	mov row, ax
	mov col, ax
	
	while_string:
		mov ax, row
		cmp ax, rows					
		jg end_string
		
		mov ax, col
		cmp ax, cols
		jg end_string
		
		inc col
		mov ax, col
		cmp ax, cols				
		jg right
		
		getElement outputGrid, row, col, loc
		dec col
		jmp go_right
		
		right:						
		mov ax, 0
		mov loc, ax
		dec col
		go_right:
		
		inc row
		mov ax, row
		cmp ax, rows					
		jg down
		
		getElement outputGrid, row, col, loc2	
		dec row
		jmp go_down
		
		down:						
		mov ax, 0
		mov loc2, ax
		dec row
		go_down:
		
		mov ax, loc2
		cmp loc, ax 				
		jl downPlz					
		
		mov result_string, 'r'			
		output result_string
		inc col
		jmp done_move
		
		downPlz:
		mov result_string, 'd'		
		output result_string
		inc row
		
		done_move:
		jmp while_string

	end_string:
	
	output carriage
	output carriage

INVOKE ExitProcess, 0

PUBLIC _start
END