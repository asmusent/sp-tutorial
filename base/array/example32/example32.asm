include example32.inc
.data
x	dw 1,2,3,-4,-5,6,0,7,8,0,5,8,3
.code
main proc
	lea rbx,x			
	xor rax,rax
	xor rdx,rdx
	xor rsi,rsi
	mov rcx,lengthof x	
next:
	test rsi,1
	jz @F	; jnz @F
	cmp word ptr [rbx+rsi*type x],0
	jle @F
	add ax, word ptr [rbx+rsi*type x]
	adc dx,0
@@:	inc rsi
	loop next
	shl edx,16
	mov dx,ax			
	ret
main endp
end
