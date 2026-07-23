include \masm64\include64\masm64rt.inc
.data
eps				REAL8 1.0E-15
a				REAL8 0.0
.data?
b				REAL8 ?
x				REAL8 ?
fx				REAL8 ?
.code
main proc
	finit
	fld eps			; eps
	fld1				; 1, eps
	fld1				; 1, 1, eps
	fadd				; 2,eps
	fld a				; a,2,eps
	fld st(1)			; 2,a,2,eps
	fldpi				; pi,2,a,2,eps
	fdivr				; b=pi/2,a,2,eps
next:				; b,a,2,eps
	fld st(0)			; b,b,a,2,eps
	fsub st(0),st(2)	; b-a,b,a,2,eps
	fabs				;|b-a|,b,a,2,eps
	fcomip st(0),st(4)	; b,a,2,eps
	jc OK			; st(0)<st(i) => ZF=PF=0, CF=1
	fld st(0)			; b,b,a,2,eps
	fadd st(0),st(2)	; b+a,b,a,2,eps
	fdiv st(0),st(3)		; c=(b+a)/2,b,a,2,eps
	fld st(0)			; c,c,b,a,2,eps
	call Function		; f(c),c,b,a,2,eps
	ftst				; f(c),c,b,a,2,eps
	fstsw ax			; B C3 TOP C2 C1 C0
	test ax,4500h		; 0   1  000   1  0    1   00000000b
	fstp st(0)			; c,b,a,2,eps
	jz @F			; C3=C2=C0=0 => st(0)>0    
	fstp st(2)			; b,a=c,2,eps
	jmp next			; b,a,2,eps
@@:	fstp st(1)			; b=c,a,2,eps
	jmp next			; b,a,2,eps
OK:	fadd				; b+a,2,eps
	fdivr				; x=(b+a)/2,eps
	fld st(0)			; x,x,eps
	call Function		; f(x),x,eps
	fstp fx			; x,eps
	fstp x			; eps
	fstp st(0)
	rcall vc_printf,cfm$("%s%f"),cfm$("x="),x
	rcall vc_printf,cfm$("%s%f"),cfm$("\nf\ax\b="),fx
	waitkey cfm$("\nPress \lEnter\r ...")	
	ret
main endp

Function proc 
; f(x)= cos(x)-sqrt(x)
; Âõ³ä  : x â st(0)
; Âèõ³ä : f(x) â st(0)
		fld st(0)
		fsqrt
		fxch
		fcos
		fsub		
		ret
Function	endp    	
end