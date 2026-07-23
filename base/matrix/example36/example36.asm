include example36.inc
.data
matrix	dw 1,5,3,2,7
cols		=($-matrix)/type matrix
		dw 2,5,7,8,9
		dw 4,9,3,2,6
rows		= ($-matrix)/(cols*type matrix)		
.data?
result		dd cols dup (?)
.code
main proc
	lea rdi,result
	lea rbx,matrix
	mov rcx,cols
cols_cycle:
	push rcx
	xor rax,rax
	xor rdx,rdx
	xor rsi,rsi
	mov rcx,rows
rows_cycle:
	add ax,word ptr [rbx+rsi]
	adc dx,0
	add rsi,cols*type matrix
	loop rows_cycle
	shl rdx,16
	or rdx,rax
	mov dword ptr [rdi],edx
	add rdi,type result
	add rbx,type matrix
	pop rcx
	loop cols_cycle	    	
	ret
main endp
end
