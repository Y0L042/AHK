#Requires AutoHotkey v2.0
#SingleInstance
#NoTrayIcon

global lastActiveTerminal := ""

; Ctrl+Alt+Space - Focus existing terminal or open a new one if none exists
^!Space:: 
{
	global lastActiveTerminal

    windows := WinGetList("ahk_class CASCADIA_HOSTING_WINDOW_CLASS ahk_exe WindowsTerminal.exe")
    
    if (windows.Length == 0) 
    {
        Run("wt.exe") ; Launches a new terminal
    } 
    else 
    {
        activeWindow := WinActive("A")
        
        ; If there are multiple terminal windows
        if (windows.Length > 1) 
        {
            Loop windows.Length
            {
                if (windows[A_Index] == activeWindow)
                {
                    nextWindow := windows[A_Index + 1] ? windows[A_Index + 1] : windows[1]
                    WinActivate(nextWindow)
                    lastActiveTerminal := nextWindow
                    return
                }
            }
        } 
        else 
        {
            WinActivate windows[1]
            lastActiveTerminal := windows[1]
        }
        
        ; If no terminal is currently focused, focus the last active terminal
        if (activeWindow != lastActiveTerminal && WinExist(lastActiveTerminal)) 
        {
            WinActivate(lastActiveTerminal)
        }
    }
}

; Ctrl+Shift+Alt+Space - Always open a new terminal
^+!Space:: 
{
    Run("wt.exe")
}
