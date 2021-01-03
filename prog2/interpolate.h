.NOLIST
.386

EXTERN interpolate_proc: Near32

interpolate 		MACRO array, x, deg, result
	
	push ebx
	
	lea ebx, array
	push ebx
	push x
	push deg
	call interpolate_proc
	
	pop ebx
	
	fstp result

ENDM

.NOLISTMACRO
.LIST
