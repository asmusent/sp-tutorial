include arithmetic.inc
.data
x	db 2
y	db 3
z	db 4
u	dw 5
v	dw 5
w	dd 71
.data?
result	dd ?
.code
main proc
	; отримуємо по черзі х та у в квадраті та зберігаємо ці 
	; значення в регістрах для того щоб не обчислювати їх ще раз
	; при розрахунку чисельника другого дробу
    	mov al,x		; AL=x
    	mul al		; AX=AL*AL = x^2
    	mov bx,ax	; й зберегли квадрат х в BX
    	mov al,y		; AL = y
    	mul al		; AX = AL*AL = y^2
    	mov cx,ax	; й зберегли квадрат х в CX
    	mov al,z		; AL = z
    	mul al		; AX = AL*AL = z^2
    	add ax,bx		; AX = z^2+x^2
    	add ax,cx		; AX = z^2+x^2+y^2
    	inc ax		; AX = z^2+x^2+y^2+1
    	; Розширемо для подальшого ділення на слово
    	cwd			; DX:AX = z^2+x^2+y^2+1
    	; Обчисюємо знаменник 
    	movzx esi,u	; SI = u
    	movzx edi,v	; DI = v
    	; SI = u та DI = v ще знадобляться для подальших розрахунків
    	; Робимо робочу копію SI = u   
    	mov r8w,si	; R8W = SI = u
    	add r8w,di	; R8W = u + v
    	; [...] - це позначення "ціла частина числа" 
    	div r8w		; (DX:AX)/R8W => AX = [(x^2+y^2+z^2+1)/(u+v)]
        	; Розширемо для подальшого додавання до подвійного слова  	
    	cwde		; EAX = [(x^2+y^2+z^2+1)/(u+v)]
    	; Звільнемо EAX який буде приймати участь в наступних розрахунках 
    	mov r8d,eax	; R8D = [(x^2+y^2+z^2+1)/(u+v)]
    	
    	mov ax,bx	; квадрат х зберігали в BX
    	mul cx		; квадрат y зберігали в CX. Отже DX:AX = x^2+y^2
    	
	xchg dh,dl	; збираємо результат 
	bswap edx	; з пари DX:AX
	mov dx,ax	; в єдине 32-розрядне в EDX для подальшого ділення
 	mov ebx,edx	; звільняємо EDX який буде задіяний в подальшому
    	 
	mov ax, si	; обчислюємо (SI = u)
	mul ax		; квадрат u
	xchg dh,dl	; і збираємо результат 
	bswap edx	; з пари DX:AX
	mov dx,ax	; в єдине 32-розрядне
    	mov ecx,w	; ECX = w
    	sub ecx,edx	; ECX = w - 2v
    	lea edx,[edi+edi]	; обчислюємо 2v (DI = v => EDX = EDI+EDI = v+v = 2v)
    	sub ecx,edx	; ECX = w - 2v - u^2
    	mov eax,ebx	; EAX = x^2+y^2 
    	cdq			; розширюємо до EDX:EAX для ділення
    	div ecx		; (EDX:EAX)/ECX
    	add r8d,eax	; додаємо EAX до першого дробу в R8D
    	mov result, r8d; зберігаємо результат обчислень
    	ret			; ВСЕ!!!
main endp
end
