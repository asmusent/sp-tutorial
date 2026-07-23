#include <iostream>
#include <cstdlib>
#include <cstdio>
using namespace std;

extern "C"
{
    unsigned int astrlen(char* lpstr);
    void amemcpy(char* lpdst, char* lpsrc, unsigned int n);
    void astrcpy(char* lpdst, char* lpsrc);
    void amemset(char* lpdest, char chr, unsigned int count);
    void astrcat(unsigned int strcount, ...);
}

int main()
{
	char str1[] = "First string";
	char str2[] = "+second string";
	char str3[] = "+third string";
	char str4[] = "+fourth string";
	char str5[] = "+fifth string";
	char str6[] = "+sixth string";

	char buffer[256];
	
	astrcpy(buffer, str1);
	cout << "astrcpy:\t" << buffer << endl;

	astrcat(6, buffer, str2, str3, str4, str5, str6);
	cout << "astrcat:\t" << buffer << endl;

	amemset(buffer, 'x', 15);
	cout << "amemset:\t" << buffer << endl;

	amemcpy(buffer, str1, astrlen(str1));
	cout << "amemcpy:\t" << buffer << endl;

	cout << "astrlen:\tLength of string '" << str1 << "' equal " << astrlen(str1) << endl;

	system("pause");
	return 0;
}
