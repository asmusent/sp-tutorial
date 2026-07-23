include \masm64\include64\masm64rt.inc
.data
x	QWORD	1.0
.data?
y	QWORD	?
.code
exponenta		proc
LOCAL FpuContext:WOW64_FLOATING_SAVE_AREA
LOCAL CWR:WORD
	fsave FpuContext
	fld qword ptr [rcx]	
	fldl2e			
	fmul				  
	fld   st(0)			  
	fstcw CWR
	mov ax,CWR
	mov cx,ax
	or ah,1100b		
	mov CWR,ax
	fldcw CWR	
	frndint			   
	mov CWR,cx
	fldcw CWR
	fsubr  st(0),st(1)	  
	f2xm1			  
	fld1				  
	fadd				  
	fscale			  
	fstsw ax			; (R|E)AX для повернення з функції 
	fstp  qword ptr [rdx]
	frstor FpuContext
	ret
exponenta endp

main		proc
	lea rcx,x
	lea rdx,y
	call exponenta
	add rsp,2*8
	rcall vc_printf,cfm$("%s%f"),cfm$("e^x = "),y
	waitkey cfm$("\nPress \lEnter\r ...")	
	ret
main endp
end
