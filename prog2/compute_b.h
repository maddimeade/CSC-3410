.NOLIST
.386

EXTRN compute_b_proc: Near32

compute_b 		MACRO address, var1, var2
	
	push address
	push var1
	push var2
	call compute_b_proc
	

ENDM

.NOLISTMACRO
.LIST