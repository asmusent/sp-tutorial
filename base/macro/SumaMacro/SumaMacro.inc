SumArray1 MACRO	Name,type,reg1,reg2
LOCAL	next
	push rcx
	push rsi
	push rax
	xor rbx,rbx
	mov rcx,LENGTHOF Name
	lea rsi,Name
next:
	lods&type
	add reg1,reg2
	loop next
	pop rax
	pop rsi
	pop rcx
ENDM
SumArray2	MACRO	Name,type,plus
LOCAL	next
	FOR Register,<rax,rcx,rsi>
		push Register
	ENDM
	xor rbx,rbx
	mov rcx,LENGTHOF Name
	lea rsi,Name
next:	lods&type
	plus
	loop next
	FOR Register,<rsi,rcx,rax>
		pop Register
	ENDM
ENDM
SumArray3 MACRO	Name,sum,type
LOCAL	next
	FORC l,cda
		push r&l&x
	ENDM
	xor sum,sum
	mov rcx,LENGTHOF Name
	lea rdx,Name
next:add sum, type ptr [rdx]
	add rdx, SIZE Name
	loop next
	FORC l,adc
		pop r&l&x
	ENDM
ENDM
pushl	MACRO	list:VARARG	
	FOR operand,<list>
		push operand 
	ENDM
ENDM
popl	MACRO	list:VARARG	
	FOR operand,<list>
		pop operand 
	ENDM
ENDM
SumArray4 MACRO	Name
LOCAL	next
	IFB <Name>
		ECHO Array name required
		.ERR
	ENDIF
	IFNDEF Name
		ECHO &Name not defined
		.ERR
	ENDIF
	pushl rax,rcx,rsi
	xor rbx,rbx
	mov rcx,SIZEOF Name / SIZE Name
	lea rsi,Name
next:
	IF SIZE Name EQ 1
		lodsb
		add bl,al
	ELSEIF SIZE Name EQ 2
		lodsw
		add bx,ax
	ELSEIF SIZE Name EQ 4
		lodsd
		add ebx,eax
	ELSEIF SIZE Name EQ 8
		lodsq
		add rbx,rax		
	ELSE
		.ERR
	ENDIF
	loop next
	popl rsi,rcx,rax
ENDM
