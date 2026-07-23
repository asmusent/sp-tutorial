include \masm64\include64\masm64rt.inc
.data
integral			REAL8 0.0
a				REAL8 0.0
b				REAL8 10.0
n				DWORD 100000
.code
main		proc
	call AllocConsole
	finit
	fld b				; b
	fsub a			; b-a
	fidiv n			; h=(b-a)/n
	fld a				; a, h
	fld st(0)			; a, a, h
	call Function		; s=f(a), a, h
	fxch 				; a, s, h
	mov ebx,n
	dec ebx
@@:	fadd st(0),st(2)	; x=a+h, s, h
	fld st(0)			; x, x, s, h
	call Function			; f(x), x, s, h
	faddp st(2),st(0)	; x, s=s+f(a+h), h
	dec ebx
	or ebx,ebx
	jnz @B
	fxch st(2)			; h, s=s+f(a+h), x 
	fmul				; I=s*h, x
	fstp integral		; x
	fstp st(0)			;
	
	rcall vc_printf,cfm$("%s%f"),cfm$("Integral = "),integral
	waitkey cfm$("\nPress \lEnter\r ...")
	ret
main endp
Function proc
; Вхід - число в st(0)
; Вихід - квадрат числа в st(0)
	fld st(0)
	fmul
	ret
Function endp
end
