/* =============================================================================
** DCS-EFM-ImGui, file: DllMain.cpp Created: 23-JUN-2022
**
** Copyright 2022 Brian Hoffpauir, USA
** All rights reserved.
**
** Redistribution and use of this source file, with or without modification, is
** permitted provided that the following conditions are met:
**
** 1. Redistributions of this source file must retain the above copyright
**    notice, this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright notice,
**    this list of conditions and the following disclaimer in the documentation
**    and/or other materials provided with the distribution.
**
** THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
** WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
** MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
** EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
** PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
** OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
** WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
** OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
** ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
** =============================================================================
**/
#define WIN_32_LEAN_AND_MEAN
#include <Windows.h>
#include <cstdio>
#include <cstdlib>
#include <io.h>
#include <fcntl.h>

#if defined _DEBUG
#include <crtdbg.h>
#endif

static void DumpClientDebugFunc(void *userPortion, size_t blockSize);
static BOOL APIENTRY DllMain(
	HMODULE hModule,
	DWORD ulReasonForCall,
	LPVOID lpReserved
);

BOOL APIENTRY
DllMain(HMODULE hModule, DWORD dwReasonForCall, LPVOID lpReserved)
{
#if defined _DEBUG && (defined _WIN32 || defined _WIN64)
	int dbgFlag = _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG);
	dbgFlag |= _CRTDBG_LEAK_CHECK_DF;
	_CrtSetDbgFlag(dbgFlag);
	_CrtSetDumpClient(DumpClientDebugFunc);
	// Need to determine where to call _CrtDumpMemoryLeaks
#endif
	switch (dwReasonForCall) {
	case DLL_PROCESS_ATTACH:
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

inline static void
DumpClientDebugFunc(void* userPortion, size_t blockSize)
{
	/* std::size_t addr = reinterpret_cast<std::size_t>(userPortion);
	std::printf("Memory leak at: %u, bytes alloc: %u", addr, blockSize); */
}
