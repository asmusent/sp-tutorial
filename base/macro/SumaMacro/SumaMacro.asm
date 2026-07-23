include SumaMacro.inc
.data
ByteArray		db 1,2,3,4,5
WordArray	dw 1,2,3,4,5
DWordArray	dd 1,2,3,4,5
QWordArray	dq 1,2,3,4,5
.code
main		proc
	SumArray1 ByteArray,b,bl,al
	SumArray1 WordArray,w,bx,ax
	SumArray1 DWordArray,d,ebx,eax
	SumArray1 QWordArray,q,rbx,rax
	
	SumArray2 ByteArray,b,<add bl,al>
	SumArray2 WordArray,w,<add bx,ax>
	SumArray2 DWordArray,d,<add ebx,eax>
	SumArray2 QWordArray,q,<add rbx,rax>
	
	SumArray3 ByteArray,bl,byte
	SumArray3 WordArray,bx,word
	SumArray3 DWordArray,ebx,dword
	SumArray3 QWordArray,rbx,qword
	
	SumArray4 ByteArray
	SumArray4 WordArray
	SumArray4 DWordArray
	SumArray4 QWordArray	
	ret
main endp
end
