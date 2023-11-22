/* =============================================================================
** DCS-EFM-ImGui, file: FmGui.cpp Created: 18-JUN-2022
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
#include "FmGui.hpp"
// #include "cppimmo/FmGui.hpp"

#include <MinHook.h>

#include <sstream>
#include <stack>
#include <algorithm>

/* DirectX headers here: */
#include <d3d11.h>

/* ImGui Implementation Headers here: */
#include <imgui.h>
#include <imgui_impl_dx11.h>
#include <imgui_impl_win32.h>

#define FMGUI_ENABLE_IMPLOT
#if defined FMGUI_ENABLE_IMPLOT
#include <implot.h>
#endif

/* Simple linking solution. */
#pragma comment(lib, "d3d11.lib")

/* Function from imgui_impl_win32; defined elsewhere */
extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(
	HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

using IDXGISwapChainPresentPtr =
	std::add_pointer<HRESULT FMGUI_FASTCALL(IDXGISwapChain *pSwapChain,
		UINT syncInterval, UINT flags)>::type;

namespace FmGui
{
// Functions
static LPVOID LookupSwapChainVTable(void);
static std::string MinHookStatusToStdString(MH_STATUS mhStatus);
static HRESULT FMGUI_FASTCALL SwapChainPresentImpl(
	IDXGISwapChain *pSwapChain,
	UINT syncInterval,
	UINT flags
);
static HRESULT GetDevice(
	IDXGISwapChain *const pSwapChain,
	ID3D11Device **ppDevice
);
static HRESULT GetDeviceContext(
	IDXGISwapChain *const pSwapChain,
	ID3D11Device **ppDevice,
	ID3D11DeviceContext **ppDeviceContext
);
static void OnResize(IDXGISwapChain *pSwapChain, UINT newWidth, UINT newHeight);
static LRESULT WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
// Variables
static ID3D11Device *pDevice = nullptr;
static ID3D11DeviceContext *pDeviceContext = nullptr;
static ID3D11RenderTargetView *pRenderTargetView = nullptr;
static constexpr LPCSTR dxgiModuleName = "dxgi.dll";
static std::FILE *pFileStdout = stdout;
static std::FILE *pFileStderr = stderr;
// Function pointer type
static IDXGISwapChainPresentPtr pSwapChainPresentTrampoline = nullptr;
static HWND hWnd = nullptr;
// WndProc used by application, in this case DCS: World
static WNDPROC pWndProcApp = nullptr;
static bool isInitialized = false, areWidgetsEnabled = false;
static FmGuiRoutinePtr pWidgetRoutine = nullptr;
static FmGuiInputRoutinePtr pInputRoutine = nullptr;
// ImGui Configuration
// static constexpr ImGuiConfigFlags imGuiConfigFlags =
// 	ImGuiConfigFlags_NavNoCaptureKeyboard;
// static constexpr const char *imGuiConfigFileName = "imgui.ini";
static ImGuiContext *pImGuiContext = nullptr;
#if defined FMGUI_ENABLE_IMPLOT
static ImPlotContext *pImPlotContext = nullptr;
#endif
static bool isImGuiImplWin32Initialized = false;
static bool isImGuiImplDX11Initialized = false;
static FmGuiConfig fmGuiConfig;
static FmGuiMessageCallback pMessageCallback = nullptr;
static std::stack<FmGuiMessage> messageStack;
static constexpr std::stack<FmGuiMessage>::size_type
	messageStackMaxSize = 24;
} // namespace FmGui

// Todo turn this logic into a inline static function.
#define PUSH_MSG(SEVERITY, CONTENT) printf("%s\n", CONTENT);

//#define PUSH_MSG(SEVERITY, CONTENT) \
//	if (messageStack.size() > messageStackMaxSize) { \
//		messageStack.pop(); \
//	} \
//	else { \
//		if (messageStack.top().content != CONTENT) { \
//			messageStack.emplace( \
//				FmGuiMessage( \
//					SEVERITY, \
//					CONTENT, \
//					__FILE__, \
//					__func__, \
//					__LINE__ \
//			)); \
//			if (pMessageCallback != nullptr) \
//				pMessageCallback(messageStack.top()); \
//		} \
//	}

void
FmGui::SetRoutinePtr(FmGuiRoutinePtr pRoutine)
{
	pWidgetRoutine = pRoutine;
}

void
FmGui::SetInputRoutinePtr(FmGuiInputRoutinePtr pInputRoutine)
{
	FmGui::pInputRoutine = pInputRoutine;
}

void
FmGui::SetMessageCallback(FmGuiMessageCallback pMessageCallback)
{
	FmGui::pMessageCallback = pMessageCallback;
}

std::string
FmGui::AddressDump(void)
{
	std::ostringstream oss; oss.precision(2);
	oss << std::hex
		<< "ID3D11Device Pointer Location: "
		<< reinterpret_cast<void *>(&pDevice) << '\n'
		<< "ID3D11DeviceContext Pointer Location: "
		<< reinterpret_cast<void *>(&pDeviceContext) << '\n'
		<< "ID3D11RenderTargetView Pointer Location: "
		<< reinterpret_cast<void *>(&pRenderTargetView) << '\n';
	// << "IDXGISwapChain Pointer Location: "
	// << reinterpret_cast<void *>(&pSwapChain) << '\n';
	return oss.str();
}

std::string
FmGui::DebugLayerMessageDump(void)
{
	ID3D11InfoQueue *pInfoQueue = nullptr;
	if (!pDevice || FAILED(pDevice->QueryInterface(__uuidof(ID3D11InfoQueue),
		reinterpret_cast<void **>(&pInfoQueue)))) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "QueryInterface failed!");
		return std::string();
	}

	if (FAILED(pInfoQueue->PushEmptyStorageFilter())) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH,
				 "ID3D11InfoQueue::PushEmptyStorageFilter failed!");
		return std::string();
	}

	std::ostringstream oss;
	const UINT64 messageCount = pInfoQueue->GetNumStoredMessages();

	for (UINT64 index = 0; index < messageCount; ++index) {
		SIZE_T messageSize = 0;
		// Get the size of the message.
		if (FAILED(pInfoQueue->GetMessage(index, nullptr, &messageSize))) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH, "GetMessage failed!");
			return std::string();
		}
		// Allocate memory.
		D3D11_MESSAGE *message = (D3D11_MESSAGE *)std::malloc(messageSize);
		if (!message) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH, "std::malloc failed!");
			return std::string();
		}
		// Get the message itself.
		if (FAILED(pInfoQueue->GetMessage(index, message, &messageSize))) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "ID3D11InfoQueue::GetMessaged failed!");
			return std::string();
		}
		
		oss << "D3D11 MESSAGE|ID:" << static_cast<int>(message->ID)
			<< "|CATEGORY:" << static_cast<int>(message->Category)
			<< "|SEVERITY:" << static_cast<int>(message->Severity)
			<< "|DESC_LEN:" << message->DescriptionByteLength
			<< "|DESC:" << message->pDescription;
		std::free(message);
	}
	pInfoQueue->ClearStoredMessages();
	ReleaseCOM(pInfoQueue);
	return std::string();
}

static LPVOID
FmGui::LookupSwapChainVTable(void)
{
	/*
	 * The following code has been disabled for now.It may be further explored
	 * in the future.
	 */
	/* WNDCLASSEXA wndClassEx;
	ZeroMemory(&wndClassEx, sizeof(wndClassEx));
	wndClassEx.cbSize = sizeof(WNDCLASSEXA);
	wndClassEx.style = CS_HREDRAW | CS_VREDRAW;
	wndClassEx.lpfnWndProc = nullptr;
	wndClassEx.cbClsExtra = 0;
	wndClassEx.cbWndExtra = 0;
	wndClassEx.hInstance = GetModuleHandle(nullptr);
	wndClassEx.hIcon = nullptr;
	wndClassEx.hCursor = nullptr;
	wndClassEx.hbrBackground = nullptr;
	wndClassEx.lpszMenuName = nullptr;
	wndClassEx.lpszClassName = "FmGuiWndClassName";
	wndClassEx.hIconSm = nullptr;

	if (RegisterClassExA(&wndClassEx) == 0) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "RegisterClassEx failed!");
		return nullptr;
	}

	constexpr int fakeWndWidth = 100, fakeWndHeight = 100;
	HWND hLocalWnd = CreateWindowExA(
		NULL,
		wndClassEx.lpszClassName,
		"Fake Window",
		WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		fakeWndWidth,
		fakeWndHeight,
		nullptr,
		nullptr,
		wndClassEx.hInstance,
		nullptr
	);
	if (!hLocalWnd) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "CreateWindowEx failed!");
		UnregisterClassA(wndClassEx.lpszClassName, wndClassEx.hInstance);
		return nullptr;
	} */

	D3D_FEATURE_LEVEL featureLevel;
	const D3D_FEATURE_LEVEL featureLevels[] = {
		D3D_FEATURE_LEVEL_10_1,
		D3D_FEATURE_LEVEL_11_0
	};
	const UINT numFeatureLevels = std::size(featureLevels);

	UINT creationFlags = D3D11_CREATE_DEVICE_BGRA_SUPPORT;
#if defined _DEBUG
	creationFlags |= D3D11_CREATE_DEVICE_DEBUG;
#endif
	ID3D11Device *pLocalDevice = nullptr;
	ID3D11DeviceContext *pLocalDeviceContext = nullptr;
	IDXGISwapChain *pLocalSwapChain = nullptr;

	DXGI_RATIONAL refreshRateRational;
	ZeroMemory(&refreshRateRational, sizeof(refreshRateRational));
	refreshRateRational.Numerator = 60;
	refreshRateRational.Denominator = 1;

	DXGI_MODE_DESC bufferModeDesc;
	ZeroMemory(&bufferModeDesc, sizeof(bufferModeDesc));
	bufferModeDesc.Width = 100;
	bufferModeDesc.Height = 100;
	bufferModeDesc.RefreshRate = refreshRateRational;
	bufferModeDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	bufferModeDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;

	DXGI_SAMPLE_DESC sampleDesc;
	ZeroMemory(&sampleDesc, sizeof(sampleDesc));
	sampleDesc.Count = 1;
	sampleDesc.Quality = 0;

	DXGI_SWAP_CHAIN_DESC swapChainDesc;
	ZeroMemory(&swapChainDesc, sizeof(swapChainDesc));
	swapChainDesc.BufferDesc = bufferModeDesc;
	swapChainDesc.SampleDesc = sampleDesc;
	swapChainDesc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	swapChainDesc.BufferCount = 1;
	HWND hWndFg = GetForegroundWindow(); // GetActiveWindow()
	if (!hWndFg) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "GetForegroundWindow failed!");
		return nullptr;
	}
	else {
		constexpr int titleBufferSize = 256;
		CHAR title[titleBufferSize];
		GetWindowTextA(hWndFg, title, titleBufferSize);

		char buffer[124];
		const std::size_t bufferLength = std::size(buffer);
		std::snprintf(buffer, bufferLength, "FmGui has window \"%s\".", title);
		PUSH_MSG(FmGuiMessageSeverity::NOTIFICATION,
				 std::string(buffer, bufferLength));
	}
	swapChainDesc.OutputWindow = hWndFg;
	swapChainDesc.Windowed = TRUE;
	swapChainDesc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
	swapChainDesc.Flags = DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;
	if (FAILED(D3D11CreateDeviceAndSwapChain(
		nullptr,
		D3D_DRIVER_TYPE_HARDWARE,
		nullptr,
		creationFlags,
		featureLevels,
		numFeatureLevels,
		D3D11_SDK_VERSION,
		&swapChainDesc,
		&pLocalSwapChain,
		&pLocalDevice,
		&featureLevel,
		&pLocalDeviceContext
	))) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH,
				 "D3D11CreateDeviceAndSwapChain failed!");
		// DestroyWindow(hLocalWnd);
		// UnregisterClassA(wndClassEx.lpszClassName, wndClassEx.hInstance);
		return nullptr;
	}

	DWORD_PTR *pLocalSwapChainVTable = nullptr;
	pLocalSwapChainVTable = reinterpret_cast<DWORD_PTR *>(pLocalSwapChain);
	pLocalSwapChainVTable = reinterpret_cast<DWORD_PTR *>(
		pLocalSwapChainVTable[0]);
	LPVOID resultant = reinterpret_cast<LPVOID>(pLocalSwapChainVTable[8]);

	ReleaseCOM(pLocalDevice);
	ReleaseCOM(pLocalDeviceContext);
	ReleaseCOM(pLocalSwapChain);
	// DestroyWindow(hLocalWnd);
	// UnregisterClassA(wndClassEx.lpszClassName, wndClassEx.hInstance);
	return resultant;
}

bool
FmGui::SetWidgetVisibility(bool isEnabled)
{
	const bool previousValue = areWidgetsEnabled;
	areWidgetsEnabled = isEnabled;
	return previousValue;
}

inline static std::string
FmGui::MinHookStatusToStdString(MH_STATUS mhStatus)
{
	char buffer[124];
	const std::size_t bufferLength = std::size(buffer);
	const int written = std::snprintf(buffer, bufferLength, "%s",
									  MH_StatusToString(mhStatus));
	return (written > 0) ? std::string(buffer, written) : "";
}

bool
FmGui::StartupHook(const FmGuiConfig &config)
{
	fmGuiConfig = config;
	PUSH_MSG(FmGuiMessageSeverity::NOTIFICATION,
			 "Redirecting Direct3D routines...");
	// HMODULE hDxgi = GetModuleHandleA(dxgiModuleName);
	// DWORD_PTR dwpDxgi = reinterpret_cast<DWORD_PTR>(hDxgi);
	LPVOID pSwapChainPresentOriginal = LookupSwapChainVTable();
	if (!pSwapChainPresentOriginal) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "FmGui::LookupSwapChainVTable!");
	}
	// DWORD_PTR hDxgi = (DWORD_PTR)GetModuleHandle(L"dxgi.dll");
	// 
	// LPVOID pSwapChainPresentOriginal = reinterpret_cast<LPVOID>(
	// 	(IDXGISwapChainPresentPtr)((DWORD_PTR)hDxgi + 0x5070));

	MH_STATUS mhStatus = MH_Initialize();
	if (mhStatus != MH_OK) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "MH_Initialize failed: "
				 + MinHookStatusToStdString(mhStatus) + '!');
		return false;
	}

	mhStatus = MH_CreateHook(pSwapChainPresentOriginal, &SwapChainPresentImpl,
		reinterpret_cast<LPVOID *>(&pSwapChainPresentTrampoline));
	if (mhStatus != MH_OK) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "MH_CreateHook failed: "
				 + MinHookStatusToStdString(mhStatus) + '!');
		return false;
	}
	mhStatus = MH_EnableHook(pSwapChainPresentOriginal);
	if (mhStatus != MH_OK) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "MH_EnableHook failed: "
				 + MinHookStatusToStdString(mhStatus) + '!');
		return false;
	}

	PUSH_MSG(FmGuiMessageSeverity::NOTIFICATION,
			 "Direct3D Redirection complete.");
	return true;
}

static HRESULT FMGUI_FASTCALL
FmGui::SwapChainPresentImpl(IDXGISwapChain *pSwapChain, UINT syncInterval,
					 UINT flags)
{
	if (!isInitialized) {
		bool boolResult;
		HRESULT hResult;

		PUSH_MSG(FmGuiMessageSeverity::NOTIFICATION,
				 "Setting up present hook...");
		hResult = GetDevice(pSwapChain, &pDevice);
		if (FAILED(hResult)) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH, "FmGui::GetDevice failed!");
			return pSwapChainPresentTrampoline(pSwapChain, syncInterval, flags);
		}
		hResult = GetDeviceContext(pSwapChain, &pDevice,
								   &pDeviceContext);
		if (FAILED(hResult)) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "FmGui::GetDeviceContext failed!");
			return pSwapChainPresentTrampoline(pSwapChain, syncInterval, flags);
		}
		pImGuiContext = ImGui::CreateContext();
		if (!pImGuiContext) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "ImGui::CreateContext failed!");
			return pSwapChainPresentTrampoline(pSwapChain, syncInterval, flags);
		}
#if defined FMGUI_ENABLE_IMPLOT
		pImPlotContext = ImPlot::CreateContext();
		if (!pImPlotContext) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "ImPlot::CreateContext failed!");
			return pSwapChainPresentTrampoline(pSwapChain, syncInterval, flags);
		}
#endif
		ImGui::SetCurrentContext(pImGuiContext);
#if defined FMGUI_ENABLE_IMPLOT
		ImPlot::SetCurrentContext(pImPlotContext);
#endif
		ImGuiIO &imGuiIO = ImGui::GetIO();
		// Configuration of the current ImGui context.
		imGuiIO.ConfigFlags |= fmGuiConfig.imGuiConfigFlags;
#if defined FMGUI_ENABLE_IMPLOT
		/*
		 * For ImPlot enable meshes with over 64,000 vertices while using the
		 * default backend 16 bit value for indexed drawing.
		 * https://github.com/ocornut/imgui/issues/2591
		 * (Extremely Important Note) Option 2:
		 * https://github.com/epezent/implot/blob/master/README.md
		 */
		imGuiIO.BackendFlags |= ImGuiBackendFlags_RendererHasVtxOffset;
#endif
		if (fmGuiConfig.imGuiIniFileName.empty())
			imGuiIO.IniFilename = nullptr;
		else
			imGuiIO.IniFilename = fmGuiConfig.imGuiIniFileName.c_str();
		imGuiIO.IniSavingRate = fmGuiConfig.imGuiIniSavingRate;
		switch (fmGuiConfig.imGuiStyle) {
		case FmGuiStyle::CLASSIC:
			ImGui::StyleColorsClassic();
			break;
		case FmGuiStyle::DARK:
			ImGui::StyleColorsDark();
			break;
		case FmGuiStyle::LIGHT:
			ImGui::StyleColorsLight();
			break;
		}

		// Get the IDXGISwapChain's description.
		DXGI_SWAP_CHAIN_DESC swapChainDesc;
		ZeroMemory(&swapChainDesc, sizeof(swapChainDesc));
		if (FAILED(pSwapChain->GetDesc(&swapChainDesc))) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "IDXGISwapChain::GetDesc failed!");
			return pSwapChainPresentTrampoline(pSwapChain, syncInterval, flags);
		}
		// Set global window handle to the OutputWindow of the IDXGISwapChain.
		hWnd = swapChainDesc.OutputWindow;
		pWndProcApp = reinterpret_cast<WNDPROC>(SetWindowLongPtr(hWnd,
			GWLP_WNDPROC, reinterpret_cast<LONG_PTR>(WndProc)));
		if (pWndProcApp == NULL) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH, "SetWindowLongPtr failed!");
			return S_FALSE;
		}

		// ImGui Win32 and DX11 implementation initialization.
		bool result = ImGui_ImplWin32_Init(hWnd);
		isImGuiImplWin32Initialized = result;
		if (!result) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "ImGui_ImplWin32_Init failed!");
			return S_FALSE;
		}

		result = ImGui_ImplDX11_Init(pDevice, pDeviceContext);
		isImGuiImplDX11Initialized = result;
		if (!result) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "ImGui_ImplDX11_Init failed!");
			return S_FALSE;
		}
		imGuiIO.ImeWindowHandle = hWnd;

		// Retrieve the back buffer from the IDXGISwapChain.
		ID3D11Texture2D *pSwapChainBackBuffer = nullptr;
		hResult = pSwapChain->GetBuffer(0, __uuidof(ID3D11Texture2D),
			reinterpret_cast<LPVOID *>(&pSwapChainBackBuffer));
		if (FAILED(hResult)) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "IDXGISwapChain::GetBuffer failed!");
			return S_FALSE;
		}
		hResult = pDevice->CreateRenderTargetView(pSwapChainBackBuffer,
												  nullptr, &pRenderTargetView);
		if (FAILED(hResult)) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH,
					 "ID3D11Device::CreateRenderTargetView failed!");
			return S_FALSE;
		}
		ReleaseCOM(pSwapChainBackBuffer);
		isInitialized = true;
	}
	else {
		ImGui::SetCurrentContext(pImGuiContext);
		// Check for NULL context.
		if (!ImGui::GetCurrentContext())
			return pSwapChainPresentTrampoline(pSwapChain, syncInterval, flags);
		ImGui_ImplWin32_NewFrame();
		ImGui_ImplDX11_NewFrame();

		ImGui::NewFrame();
		if (areWidgetsEnabled) {
			if (pWidgetRoutine != nullptr)
				pWidgetRoutine();
		}
		ImGui::EndFrame();
		ImGui::Render();

		pDeviceContext->OMSetRenderTargets(1, &pRenderTargetView, nullptr);
		ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
	}
	return pSwapChainPresentTrampoline(pSwapChain, syncInterval, flags);
}

static HRESULT
FmGui::GetDevice(IDXGISwapChain *const pSwapChain, ID3D11Device **ppDevice)
{
	HRESULT retVal = pSwapChain->GetDevice(__uuidof(ID3D11Device),
		reinterpret_cast<PVOID *>(ppDevice));
	return retVal;
}

static HRESULT
FmGui::GetDeviceContext(IDXGISwapChain *const pSwapChain,
	ID3D11Device **ppDevice, ID3D11DeviceContext **ppDeviceContext)
{
	(*ppDevice)->GetImmediateContext(ppDeviceContext);
	return (ppDeviceContext != nullptr) ? S_OK : E_FAIL;
}

bool
FmGui::ShutdownHook(void)
{
	// Reverse order of initialization.
	MH_STATUS mhStatus = MH_DisableHook(MH_ALL_HOOKS);
	if (mhStatus != MH_OK) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "MH_DisableHook failed: "
				 + MinHookStatusToStdString(mhStatus) + '!');
		return false;
	}
	mhStatus = MH_Uninitialize();
	if (mhStatus != MH_OK) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "MH_Uninitialize failed: "
				 + MinHookStatusToStdString(mhStatus) + '!');
		return false;
	}

	if (isImGuiImplDX11Initialized) {
		ImGui_ImplDX11_Shutdown();
		isImGuiImplDX11Initialized = false;
	}
	
	if (isImGuiImplWin32Initialized) {
		ImGui_ImplWin32_Shutdown();
		isImGuiImplWin32Initialized = false;
	}

#if defined FMGUI_ENABLE_IMPLOT
	if (pImPlotContext != nullptr) {
		ImPlot::DestroyContext(pImPlotContext);
	}
#endif
	
	if (pImGuiContext != nullptr) {
		ImGui::DestroyContext(pImGuiContext);
		pImGuiContext = nullptr;
	}

	ReleaseCOM(pDevice);
	ReleaseCOM(pDeviceContext);
	ReleaseCOM(pRenderTargetView);
	if (hWnd) {
		// Set hWnd's WndProc back to it's original proc.
		if (SetWindowLongPtr(hWnd, GWLP_WNDPROC,
			reinterpret_cast<LONG_PTR>(pWndProcApp)) == 0) {
			PUSH_MSG(FmGuiMessageSeverity::HIGH, "SetWindowLongPtr failed!");
			return false;
		}
	}
	// Set the Present initialization check to false.
	isInitialized = false;
	return true;
}

const FmGuiMessage &
FmGui::GetLastError(void)
{
	return messageStack.top();
}

std::vector<FmGuiMessage>
FmGui::GetEveryMessage(void)
{
	std::vector<FmGuiMessage> errorMessages;
	while (!messageStack.empty()) {
		errorMessages.push_back(messageStack.top());
		messageStack.pop();
	}
	std::reverse(std::begin(errorMessages), std::end(errorMessages));
	return errorMessages; // Hope for return value optimization.
}

static void
FmGui::OnResize(IDXGISwapChain *pSwapChain, UINT newWidth, UINT newHeight)
{
	/*
	 * This function is not fully implemented yet.
	 *
	 * First release the RenderTargetView.
	 * Then Resize the SwapChain buffers.
	 * Get the BackBuffer, Recreate the RenderTargetView,
	 * and finally release the BackBuffer pointer.
	 * Also set the render targets of the DeviceContext as well as the
	 * rasterizer viewport.
	 */
	ReleaseCOM(pRenderTargetView);

	DXGI_SWAP_CHAIN_DESC swapChainDesc;
	ZeroMemory(&swapChainDesc, sizeof(swapChainDesc));
	if (FAILED(pSwapChain->GetDesc(&swapChainDesc))) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH, "IDXGISwapChain::GetDesc failed!");
		return;
	}
	
	if (FAILED(pSwapChain->ResizeBuffers(
		swapChainDesc.BufferCount,
		newWidth, newHeight,
		swapChainDesc.BufferDesc.Format, 0u))) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH,
				 "IDXGISwapChain::ResizeBuffers failed!");
		return;
	}

	ID3D11Texture2D *pSwapChainBackBuffer = nullptr;
	if (FAILED(pSwapChain->GetBuffer(0u, __uuidof(ID3D11Texture2D),
		reinterpret_cast<void **>(&pSwapChainBackBuffer)))) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH,
				 "IDXGISwapChain::GetBuffer failed!");
		ReleaseCOM(pSwapChainBackBuffer);
		return;
	}

	if (FAILED(pDevice->CreateRenderTargetView(
		pSwapChainBackBuffer, nullptr,
		&pRenderTargetView))) {
		PUSH_MSG(FmGuiMessageSeverity::HIGH,
				 "ID3D11Device::CreateRenderTargetView failed!");
		ReleaseCOM(pSwapChainBackBuffer);
		return;
	}
	ReleaseCOM(pSwapChainBackBuffer);
	pDeviceContext->OMSetRenderTargets(1, &pRenderTargetView, nullptr);
	CD3D11_VIEWPORT viewport(0.0f, 0.0f, static_cast<float>(newWidth),
							 static_cast<float>(newHeight), 0.0f, 1.0f);
	pDeviceContext->RSSetViewports(1, &viewport);
}

static LRESULT
FmGui::WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	// Check if there is a valid context.
	if (ImGui::GetCurrentContext()) {
		ImGuiIO &imGuiIO = ImGui::GetIO();
		POINT cursorPos; GetCursorPos(&cursorPos);
		if (FmGui::hWnd)
			ScreenToClient(FmGui::hWnd, &cursorPos);
		imGuiIO.MousePos.x = cursorPos.x;
		imGuiIO.MousePos.y = cursorPos.y;
	}
	// Only handle if widgets are enabled.
	if (areWidgetsEnabled) {
		// Check for a non-NULL context and handle ImGui events.
		if (ImGui::GetCurrentContext()
			&& ImGui_ImplWin32_WndProcHandler(hWnd, uMsg, wParam, lParam)) {
			return TRUE;
		}
		// Handle user's non-NULL input routine.
		if (pInputRoutine != nullptr)
			pInputRoutine(uMsg, wParam, lParam);
	}
	// Other events.
	switch (uMsg) {
	case WM_SIZE: {
		const UINT newWidth = static_cast<UINT>(LOWORD(lParam));
		const UINT newHeight = static_cast<UINT>(HIWORD(lParam));
		// TODO: Resize IDXGISwapChain
		// OnResize(newWidth, newHeight);
		break;
	}
	}
	return CallWindowProc(pWndProcApp, hWnd, uMsg, wParam, lParam);
}

/*
 * FmGuiConfig's members need be defined where imgui/imgui.h is included. 
 */
FmGuiConfig::FmGuiConfig(void)
	: imGuiStyle(FmGuiStyle::DARK),
	  imGuiConfigFlags(
		  static_cast<ImGuiConfigFlags>(ImGuiConfigFlags_NavNoCaptureKeyboard)
	  ),
	  imGuiIniFileName(),
	  imGuiIniSavingRate(5.0f)
{
}
