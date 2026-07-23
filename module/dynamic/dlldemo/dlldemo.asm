include dlldemo.inc

.code
DllMain	proc
	mov rax, TRUE
	ret
DllMain endp

StringLength	proc PRIVATE
; Внутрішня функція для визначення довжини ASCIIZ-рядка
; Передавання параметрів регістрове
; Вхід: RDI - адреса рядка, Вихід: RAX - довжина
; Внутрішня функція зберігає ВСІ регістри, які використовує
	push rdi
	push rcx 
	mov rcx,-1
	xor al,al
	repnz scasb
	neg ecx
	lea rax,[ecx-2]
	pop rcx
	pop rdi
 	ret
StringLength endp

option prologue:none
option epilogue:none
astrlen proc EXPORT
;size_t strlen(const char* String)
	mov [rsp+8],rdi
	mov rdi,rcx
	call StringLength
	mov rdi,[rsp+8]
	ret 
astrlen endp

amemcpy proc EXPORT
;void *memcpy(void *dst, const void *src, size_t n)
	mov [rsp+8],rsi
	mov [rsp+16],rdi
	mov [rsp+24],rbx
	mov rdi,rcx
	mov rsi,rdx
	mov rcx,r8
	mov rbx,rcx
	shr rcx,3
	rep movsq
	mov rcx,rbx
	and rcx,7
	rep movsb
	mov rsi,[rsp+8]
	mov rdi,[rsp+16]
	mov rbx,[rsp+24]
	ret 
amemcpy endp

astrcpy	proc EXPORT
;char *strcpy(char *strDestination, const char *strSource)
	mov [rsp+8],rsi
	mov [rsp+16],rdi
	mov rdi,rdx
	call StringLength
	mov rsi,rdi
	mov rdi,rcx
	lea rcx,[rax+1]	; копіюємо і 0 для завершення рядка
	shr ecx,3
	rep movsq
	lea rcx,[rax+1]
	and ecx,7
	rep movsb
	mov rsi,[rsp+8]
	mov rdi,[rsp+16]	
	ret
astrcpy endp

amemset	proc EXPORT 
;void *memset( void *dest, unsigned char c, size_t count );
		mov [rsp+8],rdi
		mov [rsp+16],rbx
		mov rdi,rcx
		mov rax,rdx
		mov ah,al
		mov bx,ax
		shl rax,16
		or ax,bx
		mov ebx,eax
		shl rax,32
		or rax,rbx
		mov rcx,r8
		shr rcx,3
		rep stosq
		mov rcx,r8
		and rcx,7
		rep stosb
		mov rdi,[rsp+8]
		mov rbx,[rsp+16]
		ret
amemset	endp

cat2str	proc PRIVATE
	call StringLength
	mov rcx,rax
	xchg rsi,rdi
	rep movsb
	xchg rsi,rdi
	ret
cat2str endp

astrcat	proc EXPORT 
; astrcat(unsigned int strcount, ...)
; Виконує конкатенацію декількох ASCIIZ-рядків 
; Вхід: strcount - кількість рядків, що буде приєднуватися
; ... - перелік адрес рядків. До першого рядка будуть
; приєднуватися усі інші
; Вихід: немає
	mov [rsp+8],rsi
	mov [rsp+16],rdi
	mov [rsp+24],rbx
	mov [rsp+32],rbp
	
	mov rbx,rcx	
@@:	mov rdi,rdx
	call StringLength
	lea rsi,[rdi+rax]	; RSI - адреса кінця рядка приймача
	
	cmp rbx,2
	jne @F
	mov rdi,r8
	call cat2str
	jmp exit
@@:	cmp rbx,3
	jne @F
	mov rdi,r8
	call cat2str	

	mov rdi,r9
	call cat2str	
	jmp exit	
@@:	mov rdi,r8
	call cat2str

	mov rdi,r9
	call cat2str
		
	mov r10,(1+3)*8	; return address + 3 shadows
	sub rbx,3
@@:	or rbx,rbx
	jz exit
	add r10,8		; + 1 shadow the first time and the next parameter after
	mov rdi,[rsp+r10]
	call cat2str
	dec rbx
	jmp @B
exit:	xor al,al
	mov rdi,rsi
	stosb
	
	mov rsi,[rsp+8]
	mov rdi,[rsp+16]
	mov rbx,[rsp+24]
	mov rbp,[rsp+32]	
	ret
astrcat endp
end
