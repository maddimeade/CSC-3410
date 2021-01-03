.686
.MODEL FLAT

PUBLIC quicksort_proc, partition_proc, swap_proc

INCLUDE debug.h
INCLUDE str_utils.h

.CODE

quicksort_proc     PROC   NEAR32

maxlen	EQU [ebp + 16]
array	EQU [ebp + 12]
lo		EQU [ebp + 10]
hi		EQU [ebp + 8]

		push ebp            
		mov ebp, esp
		push ecx
		pushf
		
		mov eax, lo
		cmp eax, hi
		jge done
		
		push WORD PTR maxlen
		push DWORD PTR array
		push WORD PTR lo
		push WORD PTR hi
		call partition_proc
		
		dec ax
		
		push WORD PTR maxlen
		push DWORD PTR array
		push WORD PTR lo
		push WORD PTR ax
		call quicksort_proc
		
		inc ax
		inc ax
		
		push WORD PTR maxlen
		push DWORD PTR array
		push WORD PTR ax
		push WORD PTR hi
		call quicksort_proc
		
		done:
		
		popf
		pop ecx
		mov esp, ebp
		pop ebp
		ret 10

quicksort_proc	ENDP


partition_proc		PROC	NEAR32

maxlen  EQU [ebp + 16]
array	EQU [ebp + 12]
lo		EQU [ebp + 10]
hi		EQU [ebp + 8]
i       EQU [ebp - 2]
j       EQU [ebp - 4]

			push ebp
			mov ebp, esp
			pushw 0
			pushw 0
			push eax
			push ebx
			push ecx
			push edx
			pushf
		
			mov ebx, DWORD PTR hi
			mov eax, DWORD PTR maxlen
			mul ebx
			add eax, DWORD PTR array			;pivot, arr[hi], eax
			
			mov bx, WORD PTR lo
			mov WORD PTR i, bx
			mov WORD PTR j, bx
			
			mov ax, WORD PTR hi
			dec ax
			mov WORD PTR hi, ax
			
		for_loop:
			
			mov bx, WORD PTR j
			cmp bx, hi                ;comparing j to (hi-1)
			je done
			
			mov ecx, eax               ;moving pivot into ecx so i can use eax
			mov ebx, DWORD PTR j
			mov eax, DWORD PTR maxlen
			mul ebx
			add eax, DWORD PTR array
			
			push eax
			push ecx
			call compare_proc           ; comparing arr[j] to pivot
			cmp ax, 0            
			jg skip
			
			mov eax, edx               ; putting arr[j] in edx
			mov ebx, DWORD PTR i
			mov eax, DWORD PTR maxlen
			mul ebx
			add eax, DWORD PTR array       ;eax is arr[i] now
			
			push WORD PTR maxlen
			push eax
			push edx
			call swap_proc
			
			mov bx, WORD PTR i
			inc bx
			mov WORD PTR i, bx
			
		skip:
		
			mov bx, WORD PTR j
			inc bx
			mov WORD PTR j, bx
			jmp for_loop
			
		done:

			mov ebx, DWORD PTR i
			mov eax, DWORD PTR maxlen
			mul ebx			
			add eax, DWORD PTR array 
			
			push eax
			push ecx
			call swap_proc
			
			pop edx
			pop ecx
			pop ebx
			pop eax
			popf
			mov esp, ebp
			pop ebp
			ret 10
	
partition_proc	ENDP


swap_proc		PROC	NEAR32

maxlen  EQU [ebp + 16]
var1	EQU [ebp + 12]
var2	EQU [ebp + 8]

		push ebp  		
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		pushf
		
		mov esi, var1
		mov edi, var2
		
		cld
		mov cx, maxlen
			
	while_loop:
		 
		cmp cx, 0
		je end_loop
		
		lodsb
		dec esi
		xchg esi, edi
		movsb
		dec esi
		dec edi
		xchg esi, edi
		stosb
		dec edi 
		inc esi
		inc edi
		dec cx
		jmp while_loop
	
	end_loop:
		
		popf
		pop edx
		pop ecx
		pop ebx	
		pop eax
		mov esp, ebp
		pop ebp
		ret 10

swap_proc	ENDP

END

 
