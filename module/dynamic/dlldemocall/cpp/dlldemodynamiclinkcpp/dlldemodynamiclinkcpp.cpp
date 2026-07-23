#include <windows.h>
#include <iostream>

using namespace std;

typedef DWORD(*dllstrlen)(LPSTR);
typedef void(*dllmemcpy)(LPSTR lpdst, LPSTR lpsrc, DWORD n);
typedef void(*dllstrcpy)(char*, char*);
typedef void(*dllfcstrcpy)(char* lpdst, char* lpsrc);
typedef void(*dllmemset)(char* lpdest, char chr, unsigned int count);
typedef void(*dllfcmemset)(char* lpdest, char chr, unsigned int count);
typedef void(*dllstrcat)(unsigned int strcount, ...);

int main()
{
	char str1[] = "First string";
	char str2[] = "+second string";
	char str3[] = "+third string";
	char str4[] = "+fourth string";
	char str5[] = "+fifth string";
	char str6[] = "+sixth string";

	char buffer[256];

	HMODULE		dll;
	dllmemcpy		pmemcpy;
	dllstrcpy		pstrcpy;
	dllmemset		pmemset;
	dllstrcat			pstrcat;
	dllstrlen			pstrlen;

	if ((dll = LoadLibrary(L"dlldemo.dll")) != NULL)
	{
		cout << "---------------------------- By original name ----------------------------" << endl;
		//astrcpy(buffer,str1);
		pstrcpy = (dllstrcpy)GetProcAddress(dll, "astrcpy");
		pstrcpy(buffer, str1);
		cout << "astrcpy:\t" << buffer << endl;
		//__debugbreak();
		//astrcat(6,buffer, str2, str3, str4, str5, str6);
		pstrcat = (dllstrcat)GetProcAddress(dll, "astrcat");
		pstrcat(6, buffer, str2, str3, str4, str5, str6);
		cout << "astrcat:\t" << buffer << endl;

		//amemset(buffer,'x',15);
		pmemset = (dllmemset)GetProcAddress(dll, "amemset");
		pmemset(buffer, 'x', 15);
		cout << "amemset:\t" << buffer << endl;

		//amemcpy(buffer,str1,astrlen(str1)+1);
		pmemcpy = (dllmemcpy)GetProcAddress(dll, "amemcpy");
		pstrlen = (dllstrlen)GetProcAddress(dll, "astrlen");
		pmemcpy(buffer, str1, pstrlen(str1));
		cout << "amemcpy:\t" << buffer << endl;
		cout << "astrlen:\tLength of string '" << str1 << "' equal " << pstrlen(str1) << endl;

		cout << "---------------------------- By ordinal ----------------------------" << endl;
		//amemset(buffer,0,astrlen(str1));
		pmemset(buffer, 0, pstrlen(str1));

		//astrcpy(buffer,str1);
		pstrcpy = (dllstrcpy)GetProcAddress(dll, (LPCSTR)MAKEINTRESOURCE(101));
		pstrcpy(buffer, str1);
		cout << "astrcpy:\t" << buffer << endl;

		//astrcat(6,buffer, str2, str3, str4, str5, str6);
		pstrcat = (dllstrcat)GetProcAddress(dll, (LPCSTR)MAKEINTRESOURCE(104));
		pstrcat(6, buffer, str2, str3, str4, str5, str6);
		cout << "astrcat:\t" << buffer << endl;

		//amemset(buffer,'x',15);
		pmemset = (dllmemset)GetProcAddress(dll, (LPCSTR)MAKEINTRESOURCE(103));
		pmemset(buffer, 'x', 15);
		cout << "amemset:\t" << buffer << endl;

		//amemcpy(buffer,str1,astrlen(str1)+1);
		pmemcpy = (dllmemcpy)GetProcAddress(dll, (LPCSTR)MAKEINTRESOURCE(102));
		pmemcpy(buffer, str1, pstrlen(str1));
		cout << "amemcpy:\t" << buffer << endl;
		cout << "astrlen:\tLength of string '" << str1 << "' equal " << pstrlen(str1) << endl;
				
		cout << "---------------------------- By exported name ----------------------------" << endl;
		//amemset(buffer,0,astrlen(str1));
		pmemset(buffer, 0, pstrlen(str1));
		pstrcpy = (dllstrcpy)GetProcAddress(dll, "StrCopy");
		//StrCopy(buffer,str1);
		pstrcpy(buffer, str1);
		cout << "StrCopy:\t" << buffer << endl;

		pstrcat = (dllstrcat)GetProcAddress(dll, "StrCatEx");
		//StrCatEx(6,buffer, str2, str3, str4, str5, str6);
		pstrcat(6, buffer, str2, str3, str4, str5, str6);
		cout << "StrCatEx:\t" << buffer << endl;
		

	}
	else
	{
		MessageBox(0, L"Не можу завантажити бібліотеку", NULL, MB_OK | MB_ICONERROR);
		return -1;
	}
	return 0;
}
