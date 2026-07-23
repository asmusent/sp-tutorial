include \masm64\include64\masm64rt.inc
includelib dlldemo.lib

externdef astrlen:proc
externdef astrcpy:proc
externdef astrcat:proc
externdef amemset:proc
externdef amemcpy:proc

.data
str1		CHAR "First string",0
str2		CHAR "+second string",0
str3		CHAR "+third string",0
str4		CHAR "+fourth string",0
str5		CHAR "+fifth string",0 
str6		CHAR "+sixth string",0

.data?
buffer		db 256 dup (?)