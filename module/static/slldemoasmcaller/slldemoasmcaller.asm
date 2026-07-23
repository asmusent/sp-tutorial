include slldemoasmcaller.inc
.code
main		proc
	;ENTER   0x80,0x0
	;SUB     RSP,0x60

	call AllocConsole

	lea rsi,str1
	lea rdi,buffer
	
	mov rcx,rdi
	mov rdx,rsi
	
	call astrcpy
	mov rcx,cfm$("\nastrcpy:\t\t")
	call StdOut
	lea rcx,buffer
	call StdOut

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
	call astrcat
	add rsp,(1+4+3)*8	
	mov rcx,cfm$("\nastrcat:\t\t")
	call StdOut
	mov rcx,rdi
	call StdOut
	
	mov rcx,rdi
	mov rdx,"x"
	mov r8,15
	call amemset
	mov rcx,cfm$("\namemset:\t\t")
	call StdOut
	mov rcx,rdi
	call StdOut

	mov rcx,rsi
	call astrlen
	mov rcx,rdi
	mov rdx,rsi
	mov r8,rax
	call amemcpy
	mov rcx,cfm$("\namemcpy:\t\t")
	call StdOut
	mov rcx,rdi
	call StdOut
			
	mov rcx,rsi
	call astrlen
	mov rbx,rax
	
	rcall vc_printf,cfm$("%s%s%s"),cfm$("\nastrlen:\t\tLength of string \l"),rsi
	rcall vc_printf,cfm$("%s%d"),cfm$("\r equal "),rbx
	waitkey cfm$("\nPress \lEnter\r ...")	
	ret
main endp
end
