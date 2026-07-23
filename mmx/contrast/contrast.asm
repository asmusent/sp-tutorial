include contrast.inc
.code
main		proc
; Контрастування на бажані значення
; мінімальної Ymin и максимальної Ymax яскравості
; Y = (X - Xmin)*(Ymax - Ymin)/(Xmax - Xmin) + Ymin
	call AllocConsole
	call GetCommandLineW
	lea rbx,argc
	mov argv, rvcall(CommandLineToArgvW, rax, rbx);
	.if argv==0
		errorui()
		ret
	.endif
	mov rbx,argv
	mov rbx,[rbx+8]

	invoke CreateFileW, rbx, GENERIC_READ, 0, 0,\
					 OPEN_EXISTING, 0, 0
	mov hFile1,rax
	rcall LocalFree, argv
	.if hFile1 == INVALID_HANDLE_VALUE
		errorui()
		ret
	.endif
	
	; bfSize типу DWORD в BITMAPFILEHEADER
	rcall GetFileSize, hFile1, NULL
	.if fileSizeLow == -1 ; INVALID_FILE_SIZE   
		errorui()
		jmp err1	
	.endif	
	mov fileSizeLow, eax

	invoke CreateFileMapping, hFile1, NULL, \
   			PAGE_READONLY, NULL, eax, NULL
	.if rax == NULL
		errorui()
		jmp err1	
	.endif	
	mov hMemFile1, rax
	
	invoke MapViewOfFile, rax, FILE_MAP_READ, NULL, NULL, NULL
	.if rax == NULL
		errorui()
		jmp err2	
	.endif	
	mov hMem1,rax
	
	mov rsi,rax	; В rsi адреса початку даних файла-джерела 
	mov rbx,rax
	lea rbx,[rbx+sizeof BITMAPFILEHEADER]
	cmp word ptr (BITMAPINFO PTR [rbx]).bmiHeader.biBitCount, 24
	je @F
	;Цей формат BMP-файлу не пiдтримується
	rcall MessageBox,0,"Unsupported file format",0, MB_ICONERROR
	jmp err6	

@@:	invoke CreateFile, chr$("output.bmp"),\
			GENERIC_READ or GENERIC_WRITE, NULL, NULL,\
  			CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
	.if rax == INVALID_HANDLE_VALUE
		errorui()
		jmp err3	
	.endif
	mov hFile2, rax
	   
	invoke CreateFileMapping, rax, NULL,\
  			PAGE_READWRITE, NULL, fileSizeLow, NULL
	.if rax == NULL
		errorui()
		jmp err4	
	.endif  			
	mov hMemFile2, rax
	
	invoke MapViewOfFile, rax, FILE_MAP_WRITE, \
					NULL, NULL, fileSizeLow
	.if rax == NULL
		errorui()
		jmp err5	
	.endif	
	mov hMem2,rax

	mov rdi,rax	; В rdi адреса початку даних файла-приймача
; копіюємо заголовок в новий файл - він буде той самий 
	mov ecx,sizeof BITMAPFILEHEADER
	add ecx,(BITMAPINFO PTR [rbx]).bmiHeader.biSize
	rep movsb			
	mov r12, rsi		; потім знадобиться
;визначимо кількість пікселів для обробки як Width х Height
	mov eax,(BITMAPINFO PTR [rbx]).bmiHeader.biWidth
	mul (BITMAPINFO PTR [rbx]).bmiHeader.biHeight	
	mov ecx,eax	; bfSize в BITMAPFILEHEADER типу DWORD
	mov r13d, ecx	; потім знадобиться
	dec ecx		; на один піксель менше для пропуску 
				; початкового значення min и max
; R1 G1 B1 R2 G2 B2 R3 G3 B3 . . .
	movd	mm0,dword ptr [rsi]	; початкове
	movq	mm1,mm0			; значення min и max	
@@:	add rsi,3						; беремо RGB 
	movd	mm2,dword ptr [rsi]	; наступного пікселя
	pminub	mm0,mm2			; і шукаємо
	pmaxub	mm1,mm2			; min і max 
loop @B

	psubusb	mm1,mm0		; Xmax - Xmin в mm1, Xmin в mm0
							; Ymin=0
	movd	mm2,Ymax		; Ymax - Ymin в mm2 
; В розширенні MMX немає команди ділення.
; "ММХ-ділення" реалізуємо власним макро pdivuslb 
; на базі основної системи команд  
; Вираз (Ymax - Ymin)/(Xmax - Xmin) складається з
; фіксованих значень і обчислюється тільки один раз 

	pdivuslb mm2,mm1,mm3	;mm3 = (Ymax - Ymin)/(Xmax - Xmin)
	mov ecx, r13d				; кількість пікселів для обробки
	mov rsi, r12				; в rsi адреса початку даних,
	; а rdi залишилось від rep movsb, Xmin в mm0
	psubd	  mm2,mm2	; mm2=0 для распакування
	punpcklbw mm3,mm2	; распакували для pmullw 
@@:	movd	  mm4,dword ptr [rsi]
	psubusb	  mm4,mm0	; mm4=(X - Xmin) 
	punpcklbw mm4,mm2	; распакували для pmullw
 	pmullw	 mm4,mm3 	; mm4=(X - Xmin)*(Ymax - Ymin)/(Xmax - Xmin)	
	packuswb	 mm4,mm2	; запакували mm4 для пересилання
	movd	 dword ptr [rdi],mm4  
	add rsi,3
	add rdi,3
loop @B
  	
err6:	rcall UnmapViewOfFile, hMem2
err5:rcall CloseHandle, hMemFile2
err4:rcall CloseHandle, hFile2
err3:rcall UnmapViewOfFile, hMem1
err2:rcall CloseHandle, hMemFile1
err1:rcall CloseHandle, hFile1
	ret
main endp
end