include example37.inc
.data
str1   		db "uiop",0
str2   		db "qwertyuiopasdfghjkl",0
str3			db "qw erty uio pasd fgh jkl",0
.code
main proc
; Знайти довжину рядка str3	
	lea rdi,str3
	mov rcx,-1
	xor al,al
	repnz scasb
	neg rcx
	lea rcx,[rcx-2]		; в RCX - довжина рядка str3	
; Підрахувати кількість слів в str3
	lea rdi,str3
	xor rbx,rbx
	mov al,20h
@@:	repnz scasb
	jecxz @F
	inc ebx		; в EВX - кількість слів
	jmp @B
; Знайти входження рядка str1 в str2
@@:	mov rcx,lengthof str2-lengthof str1+1
	lea rbx,str2
@@:	push rcx
	mov rdi,rbx
	lea rsi,str1
	mov rcx,lengthof str1
	repe cmpsb
	jecxz @F
	inc rbx
	pop rcx
	loop @B
	jmp NotFound
@@:	pop rcx		; в RВX - адреса початку підрядка str1 в рядку str2
	lea rax,str2
	sub rbx,rax	; в RВX - позиція (з нуля) підрядка str1 в рядку str2 
NotFound:
; Прибрати пробіли в str3
	lea rsi,str3
	mov rdi,rsi
@@:	lodsb
	or al,al
	jz @F
	cmp al,20h
	je @B
	stosb
	jmp @B
@@:	stosb	
; Перетворити строкові літери в str3 на прописні
	lea rsi,str3
	mov rdi,rsi
@@:	lodsb
	or al,al
	jz @F
	cmp al,"a"
	jb @B
	cmp al,"z"
	ja @B
	and al,11011111b
	stosb
	jmp @B
@@:	stosb
; Зашифрувати str3 
	lea rsi,str3
	mov rdi,rsi
@@:	lodsb
	or al,al
	jz @F
	xor al,10101010b
	stosb
	jmp @B
@@:	stosb    	
	ret
main endp
end
