#include <Windows.h>

//Source https://gist.github.com/tracend/912308
enum class ScanCodes
{
	LSHIFT = 0x2A,
	LCTRL = 0x1D,
	LALT = 0x38,
};

static inline void inputKey( ScanCodes key, bool pressed )
{
	INPUT ip;
	ip.type = INPUT_KEYBOARD;

	//Press Key
	ip.ki.wScan = (unsigned int)key;
	ip.ki.time = 0;
	ip.ki.dwExtraInfo = 0;
	ip.ki.wVk = 0;
	ip.ki.dwFlags = KEYEVENTF_SCANCODE;
	ip.ki.dwFlags |= pressed ? 0 : KEYEVENTF_KEYUP;
	SendInput( 1, &ip, sizeof( INPUT ) );
}

static inline void inputMouseButton( unsigned int action )
{
	INPUT ip;
	ip.type = INPUT_MOUSE;

	//Press Key
	ip.type = INPUT_MOUSE;
	ip.mi.dx = 0;
	ip.mi.dy = 0;
	ip.mi.dwFlags = action; // MOUSEEVENTF_RIGHTDOWN | MOUSEEVENTF_RIGHTUP );
	ip.mi.mouseData = 0;
	ip.mi.dwExtraInfo = NULL;
	ip.mi.time = 0;
	SendInput( 1, &ip, sizeof( INPUT ) );
}

static inline void leftMouse(bool pressed)
{
	inputMouseButton( pressed ? MOUSEEVENTF_LEFTDOWN : MOUSEEVENTF_LEFTUP );
}

static inline void rightMouse(bool pressed)
{
	inputMouseButton( pressed ? MOUSEEVENTF_RIGHTDOWN : MOUSEEVENTF_RIGHTUP );
}

static inline void keyALT(bool pressed)
{
	inputKey( ScanCodes::LALT, pressed );
}

static inline void keySHIFT(bool pressed)
{
	printf( "LSHIFT %d\n", pressed );
	inputKey( ScanCodes::LSHIFT, pressed );
}

static inline void keyCONTROL(bool pressed)
{
	printf( "LCTRL %d\n", pressed );
	inputKey( ScanCodes::LCTRL, pressed );
}

static inline void releaseAllEmulatedKeys()
{
	printf( "Releasing All Emulated Keys\n" );
	keyCONTROL( false );
	keySHIFT( false );
	leftMouse( false );
	rightMouse( false );
}