include \masm64\include64\masm64rt.inc

BITMAPINFOHEADER STRUCT
	biSize			DWORD ?
	biWidth			LONG ?
	biHeight			LONG ?
	biPlanes			WORD ?
	biBitCount		WORD ?
	biCompression		DWORD ?
	biSizeImage		DWORD ?
	biXPelsPerMeter	LONG ?
	biYPelsPerMeter	LONG ?
	biClrUsed			DWORD ?
	biClrImportant		DWORD ?
BITMAPINFOHEADER ENDS
LPBITMAPINFOHEADER	typedef PTR BITMAPINFOHEADER

RGBQUAD STRUCT
	rgbBlue		BYTE ?
	rgbGreen		BYTE ?
	rgbRed		BYTE ?
	rgbReserved	BYTE ?
RGBQUAD ENDS
LPRGBQUAD	typedef PTR RGBQUAD

BITMAPINFO STRUCT
    bmiHeader	BITMAPINFOHEADER <?>
    bmiColors	RGBQUAD 1 dup (<>)
BITMAPINFO ENDS
LPBITMAPINFO	typedef PTR BITMAPINFO

BITMAPFILEHEADER STRUCT
	bfType			WORD ? 
	bfSize			DWORD ?
	bfReserved1		WORD ?
	bfReserved2		WORD ?
	bfOffBits			DWORD ?
BITMAPFILEHEADER ENDS
LPBITMAPFILEHEADER	typedef PTR BITMAPFILEHEADER

pdivuslb	macro RegMMX1,RegMMX2,RegMMX3
	push rax
	push rbx
	push rcx
	push rdx
	movd eax,RegMMX1
	movd ebx,RegMMX2
	mov rcx,4
@@:	push rax
	push rbx
	and eax,0FFh
	and ebx,0FFh
	div bl
	shrd edx,eax,8 	
	pop rbx
	pop rax
	shr eax,8
	shr ebx,8
	loop @B
	movd RegMMX3,edx
	pop rdx
	pop rcx
	pop rbx
	pop rax
endm

.const
Ymin			DWORD 0
Ymax			DWORD 00FFFFFFh

.data?
argv				LPCWSTR ?
argc				DWORD ?
hFile1        		HANDLE ?
hFile2        		HANDLE ?
fileSizeLow     	DWORD ?
hMemFile1     		HANDLE ?
hMemFile2     		HANDLE ?
hMem1       		HANDLE ?
hMem2       		HANDLE ?