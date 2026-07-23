include example43.inc
.data
src		db "0123456789",0
.code
ReverseStr	proc
;int ReverseStr(char* src, size_t n)
		push rbp
		mov rbp,rsp
		
		mov rcx,[rbp+3*8]
		cmp rcx,256
		jb @F
		mov rax,-1
		jmp ivalid_length		
@@:		sub rsp,256
; rbp-256 - адреса початку буферу розміром 256 байт 
; buffer	equ	<[rbp-256]>
; lea rdi, buffer => lea rdi, [rbp-256]

; sub rsp,8
; rbp-(256+8) - адреса змінної розміром 8 байт
; x	equ	<qword ptr [rbp-(256+8)]>
; mov rax,x
; sub rsp,(256+8+N+...)
; buffer	equ	<[rbp-256]>
; x			equ	<qword ptr [rbp-(256+8)]>
; ???		equ	<??? ptr [rbp-(256+8+sizeof(???))]>
; .....................................................................
		push rdi
		push rsi
		
		mov rsi,[rbp+2*8]
		lea rdi,[rbp-256]		
		rep movsb
		
		lea rsi,[rbp-256]
		mov rdi,[rbp+2*8]
		mov rcx,[rbp+3*8]
		lea rdi,[rdi+rcx-1]	; зміщення з 0, а довжина натуральне число 

@@:		cld
		lodsb
		std
		stosb		
		loop @B
		xor rax,rax
				
		pop rsi
		pop rdi
ivalid_length:
		mov rsp, rbp		
		pop rbp
		ret 2*8
ReverseStr	endp
main proc
	push lengthof src - 1 ;тільки символи без кінцевого 0
	lea rax,src
	push rax
	call ReverseStr   	
	ret
main endp
end
