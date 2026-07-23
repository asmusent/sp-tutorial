include example31.inc
.data
x		db 1,2,3,-4,-5,6,0,7,8,0,5,8	 
y		dw 1,2,3,-4,-5,6,0,7,8,0,5,0	 
.code
main proc
	lea rsi,x
	xor rbx,rbx
	mov rcx, lengthof x	
m1:	cmp byte ptr [rsi],0
	jle m2
	add bl, byte ptr [rsi]
	adc bh,0			
m2:	inc rsi		
	loop m1
;##############################################	
	xor rdi,rdi
	lea rsi,y
	mov rcx,lengthof y
m3:	cmp word ptr [rsi],0
	jge m4
	inc rdi
m4:	add rsi, type y 
	loop m3
	ret    	
main endp
end
