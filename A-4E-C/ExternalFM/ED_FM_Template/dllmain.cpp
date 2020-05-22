// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include <iostream>
#include <fcntl.h>
#include <stdio.h>
#include <io.h>
#include <windows.h>
#include <fstream>

FILE* stream;

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	

	

	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
#ifdef DEBUG_CONSOLE
		if (AllocConsole())
		{
			freopen_s(&stream, "CONOUT$", "w", stdout);
			SetConsoleTitle((L"DCS A-4 Debug Console"));
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_BLUE);
		}
#endif
		break;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

