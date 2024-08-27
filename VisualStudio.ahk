#Requires AutoHotkey v2.0
#SingleInstance
#NoTrayIcon

HotIfWinactive("ahk_exe devenv.exe")
    Hotkey("!Space", VisualStudio_SwitchSourceHeaderFiles)
HotIfWinactive()

VisualStudio_SwitchSourceHeaderFiles(ThisHotKey)
{
    SendInput "^k"
    SendInput "^o"
}