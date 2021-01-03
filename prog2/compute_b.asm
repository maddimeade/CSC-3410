; Program #2: Newton's Interpolating Polynomials
; Author:     Maddison Davenport
; Date:       3/19/2019

.386
.MODEL FLAT

INCLUDE debug.h

PUBLIC	compute_b_proc

address	EQU [ebp+12]
var1	EQU [ebp+10]
var2	EQU [ebp+8]

.CODE

compute_b_proc	PROC	NEAR32

	push ebp
	mov ebp, esp
	
	push edx
	push ecx
	push eax
	
	mov ecx, address
	mov edx, 0
	
	mov dx, var1
	cmp dx, var2
	je base_case
	
	inc WORD PTR var2
	
	push ecx
	
	push WORD PTR var1
	push WORD PTR var2
	call compute_b_proc
	
	dec WORD PTR var2
	dec WORD PTR var1
	
	push ecx
	
	push WORD PTR var1
	push WORD PTR var2
	call compute_b_proc
	inc WORD PTR var1
	
	fsub
	
	mov dx, var1

	mov eax, edx
	mov edx, 8
	mul edx
	mov edx, eax
	add ecx, edx
	fld REAL4 PTR [ecx]
	sub ecx, edx
	
	mov dx, var2

	mov eax, edx
	mov edx, 8
	mul edx
	mov edx, eax
	
	add ecx, edx
	
	fld REAL4 PTR [ecx]
	
	fsub
	
	fdiv
	
	jmp done
	
base_case:
		
	mov dx, var1

	mov eax, edx
	mov edx, 8
	mul edx
	mov edx, eax
	
	add dx, 4
	add ecx, edx
	
	fld REAL4 PTR [ecx]
		
done:
	
	pop eax
	pop ecx
	pop edx
	mov esp, ebp
	pop ebp 
	ret 8
		
compute_b_proc	ENDP
	
	END