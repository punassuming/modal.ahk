; ============================================================================
; Modal.ahk Core Library
; AutoHotkey v1.x
; 
; Core functionality for modal vim-like navigation across Windows applications.
; This file provides the foundation for mode management, configuration loading,
; and key binding processing.
; ============================================================================

; Global variables
global Modal_Mode := "normal"
global Modal_PrevMode := ""
global Modal_RepeatCount := ""
global Modal_PendingKey := ""
global Modal_Config := {}
global Modal_AppConfigs := {}
global Modal_CurrentApp := ""
global Modal_Enabled := true

; ============================================================================
; INITIALIZATION
; ============================================================================

Modal_Init() {
    global Modal_Config, Modal_AppConfigs
    
    ; Set script options
    #Persistent
    #SingleInstance, Force
    SetKeyDelay, -1
    CoordMode, Tooltip, Screen
    SendMode, Input
    
    ; Load configuration
    Modal_LoadConfig()
    
    ; Set up tray icon
    if (FileExist(Modal_Config.IconNormal)) {
        Menu, Tray, Icon, % Modal_Config.IconNormal
    }
    
    ; Set initial mode
    Modal_SetMode(Modal_Config.DefaultMode)
    
    return true
}

; ============================================================================
; CONFIGURATION MANAGEMENT
; ============================================================================

Modal_LoadConfig() {
    global Modal_Config, Modal_AppConfigs
    configPath := A_ScriptDir . "\config\settings.ini"
    
    ; Load global settings
    Modal_Config := {}
    IniRead, toggleKey, %configPath%, Global, ToggleKey, CapsLock
    IniRead, activationMethod, %configPath%, Global, ActivationMethod, toggle
    IniRead, showNotifications, %configPath%, Global, ShowNotifications, true
    IniRead, notificationTimeout, %configPath%, Global, NotificationTimeout, 600
    IniRead, iconNormal, %configPath%, Global, IconNormal, icons\normal.ico
    IniRead, iconInsert, %configPath%, Global, IconInsert, icons\insert.ico
    IniRead, defaultMode, %configPath%, Global, DefaultMode, normal
    IniRead, enableRepeatCount, %configPath%, Global, EnableRepeatCount, true
    IniRead, maxRepeatCount, %configPath%, Global, MaxRepeatCount, 500
    
    Modal_Config.ToggleKey := toggleKey
    Modal_Config.ActivationMethod := activationMethod
    Modal_Config.ShowNotifications := (showNotifications = "true")
    Modal_Config.NotificationTimeout := notificationTimeout
    Modal_Config.IconNormal := A_ScriptDir . "\" . iconNormal
    Modal_Config.IconInsert := A_ScriptDir . "\" . iconInsert
    Modal_Config.DefaultMode := defaultMode
    Modal_Config.EnableRepeatCount := (enableRepeatCount = "true")
    Modal_Config.MaxRepeatCount := maxRepeatCount
    
    ; Load default bindings
    Modal_Config.Defaults := Modal_LoadSection(configPath, "Default")
    
    ; Load application-specific configurations
    Modal_AppConfigs := {}
    Modal_LoadAppConfigs(configPath)
}

Modal_LoadSection(configPath, section) {
    bindings := {}
    
    IniRead, sectionContent, %configPath%, %section%
    if (sectionContent = "ERROR" || sectionContent = "") {
        return bindings
    }
    
    Loop, Parse, sectionContent, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "" || SubStr(line, 1, 1) = ";") {
            continue
        }
        
        pos := InStr(line, "=")
        if (pos > 0) {
            key := Trim(SubStr(line, 1, pos - 1))
            value := Trim(SubStr(line, pos + 1))
            bindings[key] := value
        }
    }
    
    return bindings
}

Modal_LoadAppConfigs(configPath) {
    global Modal_AppConfigs
    
    ; Read the INI file to find all App_ sections
    FileRead, content, %configPath%
    
    ; Find all sections starting with [App_
    pos := 1
    while (pos := RegExMatch(content, "i)\[App_(\w+)\]", match, pos)) {
        appName := match1
        sectionName := "App_" . appName
        
        ; Check if enabled
        IniRead, enabled, %configPath%, %sectionName%, Enabled, false
        if (enabled = "true") {
            appConfig := {}
            appConfig.Name := appName
            
            IniRead, windowClass, %configPath%, %sectionName%, WindowClass, 
            IniRead, windowTitle, %configPath%, %sectionName%, WindowTitle,
            IniRead, controlPattern, %configPath%, %sectionName%, ControlPattern,
            
            appConfig.WindowClass := windowClass
            appConfig.WindowTitle := windowTitle
            appConfig.ControlPattern := controlPattern
            appConfig.Bindings := Modal_LoadSection(configPath, sectionName)
            
            Modal_AppConfigs[appName] := appConfig
        }
        
        pos += StrLen(match)
    }
}

Modal_ReloadConfig() {
    Modal_LoadConfig()
    Modal_Notify("Configuration Reloaded")
}

; ============================================================================
; MODE MANAGEMENT
; ============================================================================

Modal_SetMode(mode) {
    global Modal_Mode, Modal_PrevMode, Modal_Config, Modal_RepeatCount, Modal_PendingKey
    
    Modal_PrevMode := Modal_Mode
    Modal_Mode := mode
    Modal_RepeatCount := ""
    Modal_PendingKey := ""
    
    ; Update tray icon based on mode
    if (mode = "normal") {
        if (FileExist(Modal_Config.IconNormal)) {
            Menu, Tray, Icon, % Modal_Config.IconNormal
        }
        Modal_Notify("Normal Mode")
    } else if (mode = "insert") {
        if (FileExist(Modal_Config.IconInsert)) {
            Menu, Tray, Icon, % Modal_Config.IconInsert
        }
        Modal_Notify("Insert Mode")
    } else if (mode = "visual") {
        Modal_Notify("Visual Mode")
    }
    
    return mode
}

Modal_ToggleMode() {
    global Modal_Mode
    
    if (Modal_Mode = "normal") {
        Modal_SetMode("insert")
    } else {
        Modal_SetMode("normal")
    }
}

Modal_EnterInsertMode() {
    Modal_SetMode("insert")
}

Modal_EnterNormalMode() {
    Modal_SetMode("normal")
}

Modal_EnterVisualMode() {
    Modal_SetMode("visual")
}

Modal_IsNormalMode() {
    global Modal_Mode
    return (Modal_Mode = "normal")
}

Modal_IsInsertMode() {
    global Modal_Mode
    return (Modal_Mode = "insert")
}

Modal_IsVisualMode() {
    global Modal_Mode
    return (Modal_Mode = "visual")
}

; ============================================================================
; REPEAT COUNT HANDLING
; ============================================================================

Modal_AddRepeatDigit(digit) {
    global Modal_RepeatCount, Modal_Config
    
    if (!Modal_Config.EnableRepeatCount) {
        return false
    }
    
    Modal_RepeatCount .= digit
    
    ; Limit the repeat count
    if (Modal_RepeatCount + 0 > Modal_Config.MaxRepeatCount) {
        Modal_RepeatCount := Modal_Config.MaxRepeatCount
    }
    
    Modal_ShowRepeatCount()
    return true
}

Modal_GetRepeatCount() {
    global Modal_RepeatCount
    
    count := Modal_RepeatCount + 0
    if (count < 1) {
        count := 1
    }
    
    return count
}

Modal_ClearRepeatCount() {
    global Modal_RepeatCount
    Modal_RepeatCount := ""
    Tooltip
}

Modal_ShowRepeatCount() {
    global Modal_RepeatCount, Modal_PendingKey
    
    display := Modal_RepeatCount
    if (Modal_PendingKey != "") {
        display .= Modal_PendingKey
    }
    
    if (display != "") {
        Tooltip, %display%, 60, 10
    }
}

; ============================================================================
; PENDING KEY HANDLING (for multi-key commands like gg, dd, etc.)
; ============================================================================

Modal_SetPendingKey(key) {
    global Modal_PendingKey
    Modal_PendingKey := key
    Modal_ShowRepeatCount()
    
    ; Set timeout to clear pending key
    SetTimer, Modal_ClearPendingKey, -500
}

Modal_GetPendingKey() {
    global Modal_PendingKey
    return Modal_PendingKey
}

Modal_ClearPendingKey:
    global Modal_PendingKey
    Modal_PendingKey := ""
    Tooltip
return

Modal_HasPendingKey() {
    global Modal_PendingKey
    return (Modal_PendingKey != "")
}

; ============================================================================
; APPLICATION DETECTION
; ============================================================================

Modal_GetCurrentApp() {
    global Modal_AppConfigs
    
    ; Get active window info
    WinGetClass, winClass, A
    WinGetTitle, winTitle, A
    ControlGetFocus, focusedControl, A
    
    ; Search through configured apps
    for appName, appConfig in Modal_AppConfigs {
        ; Check window class match
        if (appConfig.WindowClass != "") {
            if (!RegExMatch(winClass, appConfig.WindowClass)) {
                continue
            }
        }
        
        ; Check window title match (if specified)
        if (appConfig.WindowTitle != "") {
            if (!RegExMatch(winTitle, appConfig.WindowTitle)) {
                continue
            }
        }
        
        ; Check control pattern match (if specified)
        if (appConfig.ControlPattern != "") {
            if (!RegExMatch(focusedControl, appConfig.ControlPattern)) {
                continue
            }
        }
        
        ; All checks passed
        return appName
    }
    
    return ""
}

Modal_GetCurrentControl() {
    ControlGetFocus, control, A
    return control
}

Modal_IsAppActive(appName) {
    global Modal_AppConfigs
    
    if (!Modal_AppConfigs.HasKey(appName)) {
        return false
    }
    
    appConfig := Modal_AppConfigs[appName]
    WinGetClass, winClass, A
    
    if (appConfig.WindowClass != "") {
        return RegExMatch(winClass, appConfig.WindowClass)
    }
    
    return false
}

; ============================================================================
; KEY BINDING LOOKUP
; ============================================================================

Modal_GetBinding(action) {
    global Modal_AppConfigs, Modal_Config
    
    ; First check if there's an app-specific binding
    currentApp := Modal_GetCurrentApp()
    
    if (currentApp != "" && Modal_AppConfigs.HasKey(currentApp)) {
        appBindings := Modal_AppConfigs[currentApp].Bindings
        if (appBindings.HasKey(action)) {
            return appBindings[action]
        }
    }
    
    ; Fall back to default bindings
    if (Modal_Config.Defaults.HasKey(action)) {
        return Modal_Config.Defaults[action]
    }
    
    return ""
}

; ============================================================================
; KEY SENDING UTILITIES
; ============================================================================

Modal_SendKey(keys, count := 1) {
    if (keys = "") {
        return
    }
    
    Loop, %count% {
        SendInput, %keys%
    }
}

Modal_SendWithShift(keys, count := 1) {
    if (keys = "") {
        return
    }
    
    Loop, %count% {
        SendInput, +%keys%
    }
}

Modal_SendAction(action, useRepeatCount := true) {
    global Modal_RepeatCount
    
    binding := Modal_GetBinding(action)
    if (binding = "") {
        return false
    }
    
    count := 1
    if (useRepeatCount) {
        count := Modal_GetRepeatCount()
    }
    
    Modal_SendKey(binding, count)
    Modal_ClearRepeatCount()
    
    return true
}

; ============================================================================
; NOTIFICATION SYSTEM
; ============================================================================

Modal_Notify(message, duration := "") {
    global Modal_Config
    
    if (!Modal_Config.ShowNotifications) {
        return
    }
    
    if (duration = "") {
        duration := Modal_Config.NotificationTimeout
    }
    
    ; Use Progress bar as notification (AHK v1 compatible)
    Progress, y989 b2 fs10 zh0 W150 WS700, %message%, , , Verdana
    
    if (duration > 0) {
        SetTimer, Modal_HideNotification, -%duration%
    }
}

Modal_HideNotification:
    Progress, Off
return

Modal_NotifyOff() {
    Progress, Off
}

; ============================================================================
; GUI HELPERS (for mode indication)
; ============================================================================

Modal_ShowModeGUI(modeName) {
    ; Create a minimal GUI for mode indication
    ; This is used for conditional hotkeys with #IfWinExist
    Gui, Modal:+AlwaysOnTop -Caption +ToolWindow +Disabled -SysMenu +Owner
    Gui, Modal:Show, Hide, Modal_%modeName%
}

Modal_HideModeGUI() {
    Gui, Modal:Destroy
}

; ============================================================================
; UTILITY FUNCTIONS
; ============================================================================

Modal_ControlGetFocus(winTitle := "A") {
    ControlGetFocus, ctrl, %winTitle%
    return ctrl
}

Modal_WinGetClass(winTitle := "A") {
    WinGetClass, cls, %winTitle%
    return cls
}

Modal_WinGetTitle(winTitle := "A") {
    WinGetTitle, title, %winTitle%
    return title
}

Modal_Debug(message) {
    static debugLog := ""
    debugLog .= A_Now . ": " . message . "`n"
    
    ; Optionally write to file
    ; FileAppend, %message%`n, modal_debug.log
    
    ; Show in tooltip for debugging
    ; Tooltip, %message%
}

; ============================================================================
; CLIPBOARD HELPERS
; ============================================================================

Modal_ClipboardHasNewline() {
    return InStr(clipboard, "`n")
}

Modal_CopyToClipboard() {
    SendInput, ^c
    ClipWait, 1
}

Modal_PasteFromClipboard() {
    SendInput, ^v
}

Modal_CutToClipboard() {
    SendInput, ^x
    ClipWait, 1
}
