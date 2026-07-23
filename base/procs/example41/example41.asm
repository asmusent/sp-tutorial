include example41.inc
.data
src		db "0123456789",0
.data?
dst		db 1+lengthof src dup (?)
buf		db 18 dup (?) 
.code
strlen	proc	
;size_t strlen(const char* String);
;¬х≥д:	RDI - адреса р€дка 
;¬их≥д:	RAX - довжина р€дка
		push rcx
		push rdi
		
		mov rcx,-1
		xor al,al
		repnz scasb
		neg rcx
		lea rax,[rcx-2]
		
		pop rdi
		pop rcx
		ret
strlen endp
memcpy	proc
;void *memcpy(void *dst, const void *src, size_t n)	
;¬х≥д:	RDI - адреса приймача
;		RSI - адреса джерела
;		RCX - к≥льк≥сть байт≥в
;¬их≥д:	немаЇ	
		push rsi
		push rdi
		push rcx
				
		push rcx
		shr rcx,3
		rep movsq
		pop rcx
		and rcx,111b
		rep movsb
		
		pop rcx
		pop rdi
		pop rsi
		ret
memcpy	endp
memset	proc	
;void *memset( void *dest, int c, size_t count );	
;¬х≥д:	RDI - адреса р€дка, AL - символ, RCX - к≥льк≥сть
;¬их≥д:	немаЇ
		push rdi
		push rbx
		
		mov ah,al
		mov bx,ax
		shl rax,16
		or ax,bx
		mov ebx,eax
		shl rax,32
		or rax,rbx
		mov rbx,rcx
		shr ecx,3
		rep stosq
		mov rcx,rbx
		and rcx,111b
		rep stosb
		
		pop rbx
		pop rdi
		ret
memset	endp
main proc
	lea rdi,src
	call strlen
	
	mov rcx,rax	;в RAX довжина р€дка в≥д strlen
	lea rsi,src
	lea rdi,dst
	call memcpy
	
	lea rdi,buf 
	mov al,-1
	mov rcx,lengthof buf
	call memset
	ret
main endp
end
