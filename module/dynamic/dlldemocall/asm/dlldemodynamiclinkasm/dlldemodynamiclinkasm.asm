include dlldemodynamiclinkasm.inc
.code
main		proc
	call AllocConsole
	mov rcx,cfm$("dlldemo.dll")
	call LoadLibrary
	or rax,rax
	jnz @F
	mov rcx,cfm$("\nUnable to load library")
	call StdOut	
	jmp exit
@@:	mov dll,rax
	mov rcx,rax
	mov rdx,cfm$("astrlen")
	mov rbx,rdx
	call GetProcAddress
	or rax,rax	
	jz err
	mov strlen,rax

	mov rcx,dll
	mov rdx,cfm$("astrcpy")
	mov rbx,rdx
	call GetProcAddress
	or rax,rax
	jz err
	mov strcpy,rax
	
	mov rcx,dll
	mov rdx,cfm$("amemcpy")
	mov rbx,rdx
	call GetProcAddress
	or rax,rax
	jz err
	mov memcpy,rax
	
	mov rcx,dll
	mov rdx,cfm$("amemset")
	mov rbx,rdx
	call GetProcAddress
	or rax,rax
	jz err
	mov memset,rax
	
	mov rcx,dll
	mov rdx,cfm$("astrcat")
	mov rbx,rdx
	call GetProcAddress
	or rax,rax
	jz err
	mov strcat,rax	
;--------------------By function name ---------------------------
	mov rcx,cfm$("-------------------- By function name ---------------------------")
	call StdOut
		
	lea rsi,str1
	lea rdi,buffer

	;invoke astrcpy,rdi,rsi
	mov rcx,rdi
	mov rdx,rsi
	call strcpy
	mov rcx,cfm$("\nastrcpy:\t")
	call StdOut
	lea rcx,buffer
	call StdOut
	
	;invoke astrcat,6,rdi,addr str2,addr str3,addr str4,addr str5,addr str6
	sub rsp,(1+4+3)*8	; return address+shadow+tree parameters
	mov rcx,6
	lea rdx,buffer
	lea r8,str2
	lea r9,str3
	lea rax,str4
	mov [rsp+4*8],rax
	lea rax,str5
	mov [rsp+5*8],rax
	lea rax,str6
	mov [rsp+6*8],rax
	call strcat
	add rsp,(1+4+3)*8
	mov rcx,cfm$("\nstrcat:\t\t")
	call StdOut
	mov rcx,rdi
	call StdOut
	
	;invoke amemset,rdi,'x',15
	mov rcx,rdi
	mov rdx,"x"
	mov r8,15
	call memset
	mov rcx,cfm$("\namemset:\t")
	call StdOut
	mov rcx,rdi
	call StdOut

	;invoke astrlen,rsi
	mov rcx,rsi
	call strlen
	mov rcx,rdi
	mov rdx,rsi
	mov r8,rax
	call memcpy
	mov rcx,cfm$("\namemcpy:\t")
	call StdOut
	mov rcx,rdi
	call StdOut
			
	mov rcx,rsi
	call strlen
	mov rbx,rax
	rcall vc_printf,cfm$("%s%s%s"),cfm$("\nastrlen:\t\tLength of string \l"),rsi
	rcall vc_printf,cfm$("%s%d"),cfm$("\r equal "),rbx
comment #	
	mov rcx,rdi
	mov rdx,cfm$("\nastrlen:\tLength of string -")
	call strcpy
	mov rcx,2
	mov rdx,rdi
	mov r8,rsi
	mov r9,cfm$("\- equal ")
	call strcat
	mov rcx,rdi
	call strlen
	mov rcx,rbx
	lea rdx,[rdi+rax]
	call QwordToStrUSignDec
	mov rcx,rdi
	call StdOut
#			
	lea rdi,strcpy
	mov r12,101
next:
	mov rcx,dll
	mov rdx,r12
	call GetProcAddress
	or rax,rax
	jnz @F
	inc byte ptr ordinal+3
	lea rbx,ordinal
	jmp err
@@:	mov qword ptr [rdi],rax
	lea rdi,[rdi+sizeof(PVOID)]
	inc r12
	cmp r12,105
	jb next
	mov rcx,cfm$("\n-------------------- By function ordinal ---------------------------")
	call StdOut

	lea rsi,str1
	lea rdi,buffer

	;invoke astrcpy,rdi,rsi
	mov rcx,rdi
	mov rdx,rsi
	call strcpy
	mov rcx,cfm$("\nastrcpy:\t")
	call StdOut
	lea rcx,buffer
	call StdOut
	
	;invoke astrcat,6,rdi,addr str2,addr str3,addr str4,addr str5,addr str6
	sub rsp,(1+4+3)*8	; return address+shadow+tree parameters
	mov rcx,6
	lea rdx,buffer
	lea r8,str2
	lea r9,str3
	lea rax,str4
	mov [rsp+4*8],rax
	lea rax,str5
	mov [rsp+5*8],rax
	lea rax,str6
	mov [rsp+6*8],rax
	call strcat
	add rsp,(1+4+3)*8
	mov rcx,cfm$("\nstrcat:\t\t")
	call StdOut
	mov rcx,rdi
	call StdOut
	
	;invoke amemset,rdi,'x',15
	mov rcx,rdi
	mov rdx,"x"
	mov r8,15
	call memset
	mov rcx,cfm$("\namemset:\t")
	call StdOut
	mov rcx,rdi
	call StdOut

	;invoke astrlen,rsi
	mov rcx,rsi
	call strlen
	mov rcx,rdi
	mov rdx,rsi
	mov r8,rax
	call memcpy
	mov rcx,cfm$("\namemcpy:\t")
	call StdOut
	mov rcx,rdi
	call StdOut
			
	mov rcx,rsi
	call strlen
	mov rbx,rax
	rcall vc_printf,cfm$("%s%s%s"),cfm$("\nastrlen:\t\tLength of string \l"),rsi
	rcall vc_printf,cfm$("%s%d"),cfm$("\r equal "),rbx
comment #	
	mov rcx,rdi
	mov rdx,cfm$("\nastrlen:\tLength of string \-")
	call strcpy
	mov rcx,2
	mov rdx,rdi
	mov r8,rsi
	mov r9,cfm$("\- equal ")
	call strcat
	mov rcx,rdi
	call strlen
	mov rcx,rbx
	lea rdx,[rdi+rax]
	call QwordToStrUSignDec
	mov rcx,rdi
	call StdOut
#
;--------------------By exported function name ------------------------------
	mov rcx,cfm$("\n------------------- By exported function name ------------------------------")
	call StdOut

	lea rsi,str1
	lea rdi,buffer
	
	mov rcx,rdi
	xor rdx,rdx
	mov r8,sizeof buffer
	call memset
	
	mov rcx,dll
	mov rdx,cfm$("StrCopy")
	mov rbx,rdx
	call GetProcAddress
	or rax,rax
	jz err
	lea rcx,buffer
	lea rdx,str1
	call rax
	mov rcx,cfm$("\nStrCopy:\t")
	call StdOut
	lea rcx,buffer
	call StdOut

	mov rcx,dll
	mov rdx,cfm$("StrCatEx")
	mov rbx,rdx
	call GetProcAddress
	or rax,rax
	jz err
	;invoke astrcat,6,edi,addr str2,addr str3,addr str4,addr str5,addr str6
	sub rsp,(1+4+3)*8	; return address+shadow+tree parameters
	mov rcx,6
	lea rdx,buffer
	lea r8,str2
	lea r9,str3
	lea rax,str4
	mov [rsp+4*8],rax
	lea rax,str5
	mov [rsp+5*8],rax
	lea rax,str6
	mov [rsp+6*8],rax
	call strcat
	add rsp,(1+4+3)*8
	mov rcx,cfm$("\nStrCatEx:\t")
	call StdOut
	mov rcx,rdi
	call StdOut
	jmp exit
err:	mov rcx,cfm$("\nUnable to get function address ")
	call StdOut
	mov rcx,rbx
	call StdOut  
	mov rcx,dll
	call FreeLibrary
exit:	waitkey cfm$("\nPress \lEnter\r ...")	
	ret
main endp
end
