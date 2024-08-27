#Requires AutoHotkey v2.0

; #SingleInstance

; Define paths to module scripts
global ModuleScripts := [
    ".\VisualStudio.ahk",
    ".\TerminalShortcut.ahk",
    ".\DoomRL.ahk",
    ".\TerminalWorkspaces.ahk"
]

; Load and run module scripts
for each, script in ModuleScripts {
    try {
        RunModule(script)
    } catch Error {
        MsgBox "Failed to run module: " script "`n" Error.message
    }
}

; Function to include and run a module script
RunModule(scriptPath) {
    if !FileExist(scriptPath) {
        throw Error("File does not exist: " scriptPath)
    }
    Run scriptPath
}
