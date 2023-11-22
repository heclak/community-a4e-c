/* =============================================================================
** DCS-EFM-ImGui, file: FmGui.hpp Created: 18-JUN-2022
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
#ifndef _FMGUI_HPP_
#define _FMGUI_HPP_ 0

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>

#include <cstdio>
#include <cstdlib>
#include <type_traits>
#include <string>
#include <vector>

/*
 * ImGui headers not included in this file. The user will need to do this
 * themselves
 */
// #include <imgui/imgui.h>

/*
 * The build process may define FMGUI_ENABLE_IMPLOT to enable the ImPlot
 * extension .
 */

#if !defined(FMGUI_FASTCALL)
#define FMGUI_FASTCALL __fastcall
#endif

// Disable ImGui XINPUT
#define IMGUI_IMPL_WIN32_DISABLE_GAMEPAD

// Forward declare IDXGISwapChain structure.
struct IDXGISwapChain;

enum struct FmGuiStyle
{
	CLASSIC,
	DARK,
	LIGHT
};

// Forward declare typedef for ImGuiConfigFlags.
using ImGuiConfigFlags = int;

struct FmGuiConfig
{
public:
	FmGuiConfig(void);
	FmGuiConfig(const FmGuiConfig &) = default;
	FmGuiConfig &operator=(const FmGuiConfig &) = default;
	FmGuiConfig(FmGuiConfig &&) noexcept = default;
	FmGuiConfig &operator=(FmGuiConfig &&) noexcept = default;
public:
	/*
	 * Enumeration that can be set to the three default styles provided by ImGui
	 * in the form FmGuiStyle::CLASSIC, FmGuiStyle::DARK, & FmGuiStyle::LIGHT.
	 * Default value: FmGuiStyle::DARK
	 */
	FmGuiStyle imGuiStyle;
	/*
	 * The configuration flags passed to the ImGui context. See ImGui
	 * documentation for ImGuiConfigFlags.
	 * Default value: ImGuiConfigFlags_NavNoCaptureKeyboard
	 */
	ImGuiConfigFlags imGuiConfigFlags;
	/*
	 * Full path and filename of the auto generated ImGui .ini configuration file.
	 * This can be a full or relative path. See Examples/Fm.cpp for more info.
	 * This string is empty by default and results in no configuration file.
	 * Default value: "" (empty)
	 */
	std::string imGuiIniFileName;
	/*
	 * The rate in seconds at which the .ini configuration file is updated.
	 * Only applicable when the ImGui .ini is enabled.
	 * Default value: 5.0f
	 */
	float imGuiIniSavingRate;
};

enum struct FmGuiMessageSeverity
{
	NOTIFICATION,
	LOW,
	MEDIUM,
	HIGH
};

struct FmGuiMessage
{
public:
	FmGuiMessage(
		FmGuiMessageSeverity severity,
		const std::string &content,
		const std::string &file,
		const std::string &function,
		std::size_t line
	);
	FmGuiMessage(const FmGuiMessage &) = default;
	FmGuiMessage &operator=(const FmGuiMessage &) = default;
	FmGuiMessage(FmGuiMessage &&) noexcept = default;
	FmGuiMessage &operator=(FmGuiMessage &&) noexcept = default;
public:
	FmGuiMessageSeverity severity;
	std::string content;
	std::string file;
	std::string function;
	std::size_t line;
};

inline FmGuiMessage::FmGuiMessage(
	 FmGuiMessageSeverity severity,
	 const std::string &content,
	 const std::string &file,
	 const std::string &function,
	 std::size_t line
	)
	: severity(severity),
	  content(content),
	  file(file),
	  function(function),
	  line(line)
{
}

using FmGuiMessageCallback =
	std::add_pointer<void(const FmGuiMessage &message)>::type;
using FmGuiRoutinePtr = std::add_pointer<void(void)>::type;
using FmGuiInputRoutinePtr = std::add_pointer<void(UINT uMsg, WPARAM wParam,
												   LPARAM lParam)>::type;

namespace FmGui
{
/*
 * Set pointer to function that uses the ImGui immediate mode widgets.
 * See FmGuiRoutinePtr for a specification.
 * Example:
 * void FmGuiRoutine(void)
 * {
 * 	   ImGui::ShowDemoWindow();
 * }
 * Elsewhere perform a call to SetRoutinePtr(FmGuiRoutine);
 */
void SetRoutinePtr(FmGuiRoutinePtr pRoutine);
/*
 * Set pointer to function that handles Win32 WndProc input.
 * See FmGuiInputRoutinePtr for a specification.
 * Example:
 * void FmGuiInputRoutine(UINT uMsg, WPARAM wParam, LPARAM lParam)
 * {
 * 	   // Toggle widgets on Alt + W keypress.
 * 	   static bool areWidgetsEnabled = true;
 * 	   if (uMsg == WM_KEYDOWN) {
 * 	   	   if (wParam == 'W' && (GetAsyncKeyState(VK_MENU) & 0x8000)) {
 * 	   	   	   areWidgetsEnabled = !areWidgetsEnabled;
 * 	   	   	   FmGui::ChangeWidgetVisibility(areWidgetsEnabled);
 * 	   	   }
 * 	   }
 * }
 * Elsewhere perform a call to SetInputRoutinePtr(FmGuiInputRoutine);
 * 
 * Supplementary reading:
 * https://docs.microsoft.com/en-us/windows/win32/inputdev/using-keyboard-input
 * https://docs.microsoft.com/en-us/windows/win32/inputdev/keyboard-input
 * https://docs.microsoft.com/en-us/windows/win32/learnwin32/keyboard-input
 */
void SetInputRoutinePtr(FmGuiInputRoutinePtr pInputRoutine);
/*
 * Set all widget visibility and return previous value.
 */
bool SetWidgetVisibility(bool isEnabled);
/*
 * Start the FmGui and ImGui.
 * You can supply an optional configuration using an FmGuiConfig object.
 * Example:
 * FmGuiConfig config;
 * config.imGuiStyle = FmGuiStyle::DARK;
 * if (!FmGui::StartupHook(config)) {
 *     // FAILED!
 * }
 */
bool StartupHook(const FmGuiConfig &config = FmGuiConfig());
/*
 * Return formatted string of the D3D context memory addresses.
 */
std::string AddressDump(void);
/*
 * Return a string message with the last error generated by FmGui.
 */
const FmGuiMessage &GetLastError(void);
/*
 * Return a vector of error messages in order of first to last occurence.
 */
std::vector<FmGuiMessage> GetEveryMessage(void);
/*
 * Sets the FmGuiMessageCallback to be used by FmGui.
 */
void SetMessageCallback(FmGuiMessageCallback pMessageCallback);
/*
 * Return formatted string of the D3D debug layer warning/error
 * messages. Note: DirectX 11 does not have a callback to do this
 * in real time. Only a vaild call if the hook was started successfully.
 * Returns an empty string to indicate and error.
 */
std::string DebugLayerMessageDump(void);
/*
 * Shutdown the FmGui and ImGui.
 */
bool ShutdownHook(void);

} // namespace FmGui

namespace FmGui
{
/*
 * These functions aren't meant for users.
 */
template<typename Type>
inline void
ReleaseCOM(Type *pInterface)
{
	if (pInterface != nullptr) {
		pInterface->Release();
		pInterface = nullptr;
	}
}

template<typename Type>
inline void
ReleaseCOM(Type **ppInterface)
{
	if (*ppInterface != nullptr) {
		(*ppInterface)->Release();
		(*ppInterface) = nullptr;
	}
}

} // namespace FmGui

#endif /* !_FMGUI_HPP_ */
