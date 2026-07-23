include example33.inc
.data
x 	dw 7,8,0,5,8,3,-10,5,0,0,14,-5,3,-7	 
.code
main proc
	lea rbx,x
	xor rsi,rsi
	mov ax,[rbx]
	mov rdi,rsi
	mov rcx, lengthof x
	dec rcx
	inc rsi
next:
	cmp [rbx+rsi*2],ax
	jle @F
	mov ax,[rbx+rsi*2]
	mov rdi,rsi
@@: inc rsi
	loop next	    	
	ret
main endp
end
