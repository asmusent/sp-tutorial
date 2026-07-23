include \masm64\include64\masm64rt.inc

.data
str1		CHAR "First string",0
str2		CHAR "+second string",0
str3		CHAR "+third string",0
str4		CHAR "+fourth string",0
str5		CHAR "+fifth string",0 
str6		CHAR "+sixth string",0
ordinal	CHAR "@101"

.data?
buffer		db 256 dup (?)
dll			HANDLE ?
strlen		PVOID ?
strcpy		PVOID ?	;@101
memcpy		PVOID ?	;@102
memset		PVOID ?	;@103
strcat		PVOID ?	;@104
