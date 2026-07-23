include example42.inc
.data
src		db "0123456789",0
.data?
dst		db 1+lengthof src dup (?)
buf		db 18 dup (?)  
.code
strlen	proc
;size_t strlen(const char* String)
;Вхід:	адреса рядка в стеку,
;Вихід:	RAX - довжина рядка
		push rcx
		push rdi
		mov rdi,[rsp+3*8]
		mov rcx,-1
		xor al,al
		repnz scasb
		neg rcx
		lea rax,[rcx-2]
		pop rdi
		pop rcx
		ret 8
strlen	endp
memcpy	proc
;void *memcpy(void *dst, const void *src, size_t n)
		push rbp
		mov rbp,rsp
			
		push rdi
		push rsi
		
		mov rdi,[rbp+2*8]		
		mov rsi,[rbp+3*8]
		mov rcx,[rbp+4*8]
		shr rcx,3
		rep movsq
		mov rcx,[rbp+4*8]
		and rcx,0111b
		rep movsb
		
		pop rsi
		pop rdi
		pop rbp
		ret
memcpy	endp
memset	proc
;void *memset(void *dest, int c, size_t count );	
		push rbp
		mov rbp,rsp
		
		push rdi
		push rbx
		
		mov rdi,[rbp+3*8+2]
		mov al,[rbp+3*8]
		mov rcx,[rbp+2*8]
		mov ah,al
		mov bx,ax
		shl rax,16
		or ax,bx
		mov ebx,eax
		shl rax,32
		or rax,rbx
		shr ecx,3
		rep stosq
		mov rcx,[rbp+2*8]
		and ecx,0111b
		rep stosb
		
		pop rbx
		pop rdi
		pop rbp
		ret 2*8+2
memset	endp

main proc
	lea rax,src
	push rax
	call strlen
	
	push rax		; в RAX довжина рядка від strlen
	lea rax,src
	push rax
	lea rax,dst
	push rax
	call memcpy
	add rsp,3*8
	
	lea rax,buf
	push rax
	mov al,-1
	movzx ax,al
	push ax
	push lengthof buf
	call memset    	
	ret
main endp
end
