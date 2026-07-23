include example35.inc
.data
matrix	dw 1,5,3,2,7
cols		=($-matrix)/type matrix			; кількість стовпчиків
		dw 2,5,7,8,9
		dw 4,9,3,2,6
rows		= ($-matrix)/(cols*type matrix)	; кількість рядків
.data?
result	dd rows dup (?)				; масив результатів
.code
main proc
	lea rdi,result	; в rdi - адреса результату внутрішнього циклу
	lea rbx,matrix	; в rbx - адреса першого рядка
	mov rcx,rows	; кількість рядків - лічильник зовнішнього циклу
rows_cycle:
	push rcx		; зберегти лічильник зовнішнього циклу
	xor rax,rax	; в dx:ax буде накопичуватися сума елементів
	xor rdx,rdx	; у внутрішньому циклі
	xor rsi,rsi		; починаючи з першого (зміщення від бази 0)
	mov rcx,cols	; для всіх елементів рядка
cols_cycle:
	add ax,word ptr [rbx+rsi*type matrix]	; додати елемент до суми 
	adc dx,0				; з врахуванням можливого переносу
	inc rsi				; і перейти до наступного
	loop cols_cycle
	shl edx,16			; скласти з пари dx:ax єдине 32-х бітне
	or dx,ax				; в регістрі edx
	mov dword ptr [rdi],edx	; і зберегти результат
	add rdi,type result		; перерахувати адресу наступного результату
	add rbx, cols*type matrix; перерахувати адресу наступного рядка
	pop rcx				; й перейти до його обробки 
	loop rows_cycle		; якщо він не останній    	
	ret
main endp
end
