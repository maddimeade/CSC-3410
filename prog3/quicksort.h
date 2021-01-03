.NOLIST
.686

EXTRN quicksort_proc : Near32

quicksort			MACRO array, num, MAXLEN, xtra

				IFB <array>
					.ERR <missing "array" in quicksort>
				ELSEIFB <num>
					.ERR <missing "num" in quicksort>
				ELSEIFB <MAXLEN>
					.ERR <missing "MEXLEN" in quicksort>
				ELSEIFNB <xtra>
					.ERR <extra op in quicksort>
				ELSE
					
						push ebx
							push num
							push 0
							lea ebx, array
							push ebx
							push num
							push MAXLEN
							call quicksort_proc
						pop ebx
						
				ENDIF
						ENDM
.NOLISTMACRO
.LIST