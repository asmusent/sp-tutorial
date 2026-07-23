include example34.inc
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
@@:	cmp word ptr [rbx+rsi*2],ax
	cmovg ax,word ptr [rbx+rsi*2]
	cmovg rdi,rsi
	inc rsi
	loop @B	
	ret
main endp
end
