#Requires AutoHotkey v2.0
#SingleInstance
#NoTrayIcon

; Define your hotkey to open the search bar
^!r:: ; Win + Q to trigger the search bar
{
    global MyGui
    MyGui := Gui(,)
    MyGui.SetFont("S24 Q4 BOLD", "Arial")
    MyGui.Opt("+AlwaysOnTop -Caption -SysMenu +LastFound")
    MyGui.BackColor := "7C7062" 

    MyGui.Add("Edit", "vCommand ym W450 H50")  ; The ym option starts a new column of controls.
    MyGui.Add("Button", "default ym H50", "RUN").OnEvent("Click", ProcessUserInput)
    
    SetTimer(CheckFocus, 100)
    MyGui.OnEvent("Escape", CloseGui)
    MyGui.OnEvent("Close", CloseGui)

    WinSetTransColor(MyGui.BackColor " 255", MyGui)
    MyGui.Show(" W750 " " H85 ")






    CheckFocus(*)
    {
        global MyGui
        if (WinExist("PowerRun.ahk ahk_class AutoHotkeyGUI")) ; Check if the GUI object exists
        {
            ; Use WinExist() to check if the window is still present
            if (MyGui && WinExist("ahk_id " MyGui.hWnd))
            {
                if !WinActive("ahk_id " MyGui.hWnd)
                {
                    CloseGui()
                }
            }
        }
        else
        {
            SetTimer(, 0)
        }
    }

    CloseGui(*)
    {
        global MyGui
        MyGui.Destroy()  ; Destroy the GUI
        SetTimer(, 0)  ; Stop the focus-checking timer
        MyGui := ""  ; Reset MyGui to avoid referencing an invalid GUI object
    }


    ProcessUserInput(*)
    {
        Saved := MyGui.Submit()
       
    }


    
}
