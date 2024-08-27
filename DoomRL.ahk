#Requires AutoHotkey v2.0
#SingleInstance
#NoTrayIcon

HotIfWinactive("ahk_exe drl.exe")
    Hotkey("x", DoomRL_ESC_DOWN)
	Hotkey("x up", DoomRL_ESC_UP)
HotIfWinactive()

DoomRL_ESC_DOWN(ThisHotKey)
{
    SendInput "{Esc down}"
}

DoomRL_ESC_UP(ThisHotKey)
{
	SendInput "{Esc up}"
}