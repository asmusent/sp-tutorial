include RungeKutt4.inc
.code
main	 proc
LOCAL Buffer[4096]:BYTE
	call AllocConsole
	mov ebx,n
	xor rdi,rdi
	finit
	fld yn			; yn
	fld xn			; xn, yn
	fld xk			; xk, xn, yn
	fsub st(0),st(1)	; xk-xn, xn, yn
	fild n			; n, xn-xk, xn, yn
	fdivp st(1),st(0)	; h=(xn-xk)/n, xn, yn
	fld st(0)			; h, h, xn, yn
	fld st(0)			; h, h, h, xn, yn
	fld1				; 1, h, h, h, xn, yn
	fld1				; 1, 1, h, h, h, xn, yn
	fadd				; 2, h, h, h, xn, yn
	fld st(0)			; 2, 2, h, h, h, xn, yn
	fadd st(1),st(0)	; 2, 4, h, h, h,  xn, yn
	fadd st(1),st(0)	; 2, 6, h, h, h, xn, yn
	fdivp st(2),st(0)	; 6, h/2, h, h, xn, yn
	fdivp st(2),st(0)	; h/2, h/6, h, xn, yn
	fstp h2			; h/6, h, xn, yn
	fstp h6			; h, xn, yn
	fstp h			; xn, yn
@@:	fld st(0)			; xn, xn, yn
	fxch st(2) 		; yn, xn, xn
	fld st(0)			; yn, yn, xn, xn
	fxch st(3)			; xn, yn, xn, yn
	call Function			; rk1=f(xn,yn), xn, yn
	fst rk1			
	fld h2			; h/2, rk1, xn, yn
	fmul st(1),st(0)	; h/2, rk1*h/2, xn, yn
	fadd st(0),st(2)	; xn+h/2, rk1*h/2, xn, yn
	fxch				; rk1*h/2, xn+h/2, xn, yn
	fadd st(0),st(3)	; yn+rk1*h/2, xn+h/2, xn, yn
	fxch				; xn+h/2, yn+rk1*h/2, xn, yn
	call Function			; rk2=f(xn+h/2, yn+rk1*h/2), xn, yn
	fst rk2			; rk2, xn, yn
	fld h2			; h/2, rk2, xn, yn
	fmul st(1),st(0)	; h/2, rk2*h/2, xn, yn
	fadd st(0),st(2)	; xn+h/2, rk2*h/2, xn, yn
	fxch				; rk2*h/2, xn+h/2, xn, yn
	fadd st(0),st(3)	; yn+rk2*h/2, xn+h/2, xn, yn
	fxch				; xn+h/2, yn+rk2*h/2, xn, yn
	call Function		; rk3=f(xn+h/2, yn+rk2*h/2), xn, yn
	fst rk3			; rk3, xn, yn
	fld h				; h, rk3, xn, yn
	fmul st(1),st(0)	; h, h*rk3, xn, yn
	fadd st(0),st(2)	; xn+h, h*rk3, xn, yn
	fxch				; h*rk3, xn+h, xn, yn
	fadd st(0),st(3)	; yn+h*rk3, xn+h, xn, yn
	fxch				; xn+h, yn+h*rk3, xn, yn
	call Function			; rk4=f(xn+h, yn+h*rk3), xn, yn
	fld rk3			; rk3, rk4, xn, yn
	fld rk2			; rk2, rk3, rk4, xn, yn
	fld rk1			; rk1, rk2, rk3, rk4, xn, yn
	faddp st(3),st(0)	; rk2, rk3, rk4+rk1, xn, yn
	fld st(0)			; rk2, rk2, rk3, rk4+rk1, xn, yn
	fadd				; 2*rk2=rk2+rk2, rk3, rk4+rk1, xn, yn	
	faddp st(2),st(0)	; rk3, rk4+2*rk2+rk1, xn, yn
	fld st(0)			; rk3, rk3, rk4+2*rk2+rk1, xn, yn
	fadd				; 2*rk3=rk3+rk3, rk4+2*rk2+rk1, xn, yn
	fadd				; rk4+2*rk3+2*rk2+rk1,xn, yn
	fmul h6			; h*(rk4+2*rk3+2*rk2+rk1)/6,xn, yn
	faddp st(2),st(0)	; xn, yi=yn+h*(rk4+2*rk3+2*rk2+rk1)/6
	fadd h			; xi=xn+h, yi=yn+h*(rk4+2*rk3+2*rk2+rk1)/6
	fst x[rdi*8]
	fxch
	fst y[rdi*8]
	fxch
	inc rdi
	dec ebx
	or ebx,ebx
	jnz @B
	
	mov ebx,n
	xor rdi,rdi
	lea rsi,Buffer
@@:	mov dword ptr [rsi],"(f=y"
	lea rsi,[rsi+4]
	mov r12,x[rdi*8]
	rcall fptoa,r12,rsi
	rcall lstrlen,rsi
	mov word ptr [rsi+rax],"=)"
	lea rsi,[rsi+rax+2]
	mov r12,y[rdi*8]
	rcall fptoa,r12,rsi
	rcall lstrlen,rsi
	mov dword ptr [rsi+rax],0A0Dh
	lea rsi,Buffer
	invoke StdOut,rsi
	inc rdi
	dec ebx
	or ebx,ebx
	jnz @B
	waitkey cfm$("\nPress \lEnter\r ...")
	ret	
main	 endp
Function proc
; dy/dx=f(x,y)=2*(x*x+y)
; Âõ³ä  : x â st(0), y â st(1)	; x, y
; Âèõ³ä : f(x,y) â st(0)
		fld st(0)		; x, x, y
		fmul			; x*x, y
		fadd			; x*x+y
		fld st(0)		; x*x+y, x*x+y
		fadd			; 2*(x*x+y)
		ret
Function	endp
end
