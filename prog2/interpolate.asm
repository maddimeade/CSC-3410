; Program #2: Newton's Interpolating Polynomials
; Author:     Maddison Davenport
; Date:       3/19/2019

.386
.MODEL FLAT

INCLUDE debug.h
INCLUDE compute_b.h

PUBLIC	interpolate_proc 

address	EQU [ebp+14]
x		EQU [ebp+10]
deg		EQU [ebp+8]
tempVal	EQU [ebp-2]	

.CODE

interpolate_proc	PROC	NEAR32

	push ebp
	mov ebp, esp
	
	push ecx
	push edx
	push eax
	
	mov eax, 0
	mov ecx, 0
	mov edx, 0
	mov cx, deg
	
while_loop1:
		
	cmp cx, 0
	je done_while1
		
	mov tempVal, cx
	compute_b DWORD PTR address, WORD PTR tempVal, WORD PTR 0
		
	mov dx, cx
		
while_loop2:
		
	cmp dx, 0
	je done_while2
			
	fld REAL4 PTR x
	dec dx
	shl dx, 3

	add ebx, edx
	fld REAL4 PTR [ebx]
	sub bx, dx
	
	shr dx, 3

	fsub
			
	jmp while_loop2
			
done_while2:
	
	mov dx, cx

while_multiplying:
		
	cmp dx, 0
	je done_multiplying
			
	fmul
			
	dec dx
	jmp while_multiplying
			
done_multiplying:
			
	dec cx
	jmp while_loop1
		
done_while1:
	
	fld REAL4 PTR [ebx+4]
	mov cx, deg
		
while_adding:
	
	cmp cx, 0
	je done_adding
		
	fadd
		
	dec cx
	jmp while_adding
		
done_adding:
	
	popf
	pop eax
	pop edx
	pop ecx
	
	mov esp, ebp
	pop ebp
	ret 10
		
interpolate_proc	ENDP
	
END
			
		
		