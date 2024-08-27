#Requires AutoHotkey v2.0
#SingleInstance
#NoTrayIcon

#Include ".\lib\Lib\ExplorerUtils.ahk"

; Create a group of the windows that contain files and/or folders:
; ahk_group ExplorerDesktopGroup
GroupAdd("ExplorerDesktopGroup", "ahk_class ExploreWClass")
GroupAdd("ExplorerDesktopGroup", "ahk_class CabinetWClass")
GroupAdd("ExplorerDesktopGroup", "ahk_class Progman")
GroupAdd("ExplorerDesktopGroup", "ahk_class WorkerW")


#HotIf WinActive("ahk_group ExplorerDesktopGroup")

	^!n:: Terminal_Nvim(Explorer_GetSelection())
	^!+n:: Terminal_Nvim_WSL(Explorer_GetSelection())

    #p:: MsgBox(Explorer_GetSelection())
#HotIf

Explorer_GetSelection() {
    ; https://www.autohotkey.com/boards/viewtopic.php?style=17&t=60403#p255169
    result := ""
    winClass := WinGetClass("ahk_id" . hWnd := WinExist("A"))
    if !(winClass ~= "^(Progman|WorkerW|(Cabinet|Explore)WClass)$")
        Return 
    shellWindows := ComObject("Shell.Application").Windows
    if (winClass ~= "Progman|WorkerW")
        shellFolderView := shellWindows.Item( ComValue(VT_UI4 := 0x13, SWC_DESKTOP := 0x8) ).Document
    else {
        for window in shellWindows 
        if (hWnd = window.HWND) && (shellFolderView := window.Document)
            break
   }
    for item in shellFolderView.SelectedItems
        result .= (result = "" ? "" : "`n") . item.Path
    Return result
}

D_explorerGetPath(hwnd := 0) { ; https://www.autohotkey.com/boards/viewtopic.php?p=387113#p387113
	 Static winTitle := 'ahk_class CabinetWClass'
	 hWnd ?    explorerHwnd := WinExist(winTitle ' ahk_id ' hwnd)
		  : ((!explorerHwnd := WinActive(winTitle)) && explorerHwnd := WinExist(winTitle))
	 If explorerHwnd
	  For window in ComObject('Shell.Application').Windows
	   Try If window && window.hwnd && window.hwnd = explorerHwnd
		Return window.Document.Folder.Self.Path
 Return False
}

explorerGetPath(hwnd := 0) { 
    Static winTitle := 'ahk_class CabinetWClass'
    
    ; If hwnd is passed, get the specific explorer window by hwnd, otherwise use the active window
    explorerHwnd := hwnd ? WinExist(winTitle ' ahk_id ' hwnd) : WinActive(winTitle)
    
    if !explorerHwnd
        Return False
    
    ; Loop through all Shell.Application windows
    For window in ComObject('Shell.Application').Windows
    {
        Try 
		{
            ; Check if the window's hwnd matches the explorerHwnd
            if (window && window.hwnd = explorerHwnd) 
			{
                ; Check if the current tab matches the active tab
                if window.Document.FocusedItem 
				{
                    Return window.Document.Folder.Self.Path
				}
            }
        }
    }
    Return False
}

Terminal_Nvim(Target) {
    ; Determine the directory or parent directory
	tab := ExUtils.GetActiveTab()
	res := ""
	if (Target)
	{
		res := False
		res := InStr(Target, tab.path) 
	}

	if (not res or not Target)
	{
		Target := tab.path
		
		if (Target == False)
		{
			Target := ""
			Return False
		}

		needle := "\\"
		replacement := "/"
		Target := RegExReplace(Target, needle, replacement)
	}
	else if FileExist(Target) and InStr(FileExist(Target), "D") ; Directory
    {
		needle := "\\"
		replacement := "/"
		Target := RegExReplace(Target, needle, replacement)
        Dir := Target
    }
    else ; File
    {
		needle := "\\"
		replacement := "/"
		Target := RegExReplace(Target, needle, replacement)

        SplitPath(Target, &Name, &Dir)
    }
	
	needle := '""'
	replacement := ""
	Target := RegExReplace(Target, needle, replacement)
	Target := RegExReplace(Target, "//wsl.localhost/Ubuntu/home/vlamf_wsl", "~")

	Run("wt.exe new-tab -p UCRT64_MSYS2 -ft nvim " Target)

	Sleep 750
	WinActivate("ahk_exe WindowsTerminal.exe") 

	Target := ""
}

Terminal_Nvim_WSL(Target) {
    ; Determine the directory or parent directory
	tab := ExUtils.GetActiveTab()
	res := ""
	if (Target)
	{
		res := False
		res := InStr(Target, tab.path) 
	}

	if (not res or not Target)
	{
		Target := tab.path
		
		if (Target == False)
		{
			Target := ""
			Return False
		}

		needle := "\\"
		replacement := "/"
		Target := RegExReplace(Target, needle, replacement)
	}
	else if FileExist(Target) and InStr(FileExist(Target), "D") ; Directory
    {
		needle := "\\"
		replacement := "/"
		Target := RegExReplace(Target, needle, replacement)
        Dir := Target
    }
    else ; File
    {
		needle := "\\"
		replacement := "/"
		Target := RegExReplace(Target, needle, replacement)

        SplitPath(Target, &Name, &Dir)
    }
	
	needle := '""'
	replacement := ""
	Target := RegExReplace(Target, needle, replacement)
	Target := RegExReplace(Target, "//wsl.localhost/Ubuntu/home/vlamf_wsl", "~")
MsgBox(Target)
	Run("wt.exe new-tab -d " Target " -p Ubuntu -ft nvim ." )
	Sleep 500
	WinActivate("ahk_exe WindowsTerminal.exe") 
	
	Target := ""
}
