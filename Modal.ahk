; ============================================================================
; Modal.ahk - Unified Modal Vim Navigation for Windows
; AutoHotkey v1.x
;
; A unified modal navigation system for Windows 10/11 applications.
; Provides vim-like hjkl navigation, configurable per-application keybindings,
; and easy extensibility through INI configuration files.
;
; USAGE:
;   1. Run this script with AutoHotkey v1.x
;   2. Press CapsLock to toggle between Normal and Insert modes
;   3. In Normal mode, use vim-like keys (hjkl) for navigation
;   4. Edit config/settings.ini to customize keybindings for your apps
;
; AUTHORS:
;   Based on work by Rich Alesi, Achal Dave, Andrej Mitrovic, 
;   Jongbin Jung, Kylir Horton, and other contributors.
;
; LICENSE: MIT
; ============================================================================

#NoEnv
#Persistent
#SingleInstance, Force
#MaxHotkeysPerInterval, 200
SendMode Input
SetWorkingDir %A_ScriptDir%
SetKeyDelay, -1
CoordMode, Tooltip, Screen

; Include core libraries
#Include %A_ScriptDir%\lib\Modal_Core.ahk
#Include %A_ScriptDir%\lib\Modal_Navigation.ahk
#Include %A_ScriptDir%\lib\Modal_Actions.ahk

; ============================================================================
; INITIALIZATION
; ============================================================================

; Initialize the modal system
Modal_Init()

; Set default icon
if (FileExist("icons\normal.ico")) {
    Menu, Tray, Icon, icons\normal.ico
} else if (FileExist("vim.ico")) {
    Menu, Tray, Icon, vim.ico
}

; Create tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Normal Mode, TrayNormalMode
Menu, Tray, Add, Insert Mode, TrayInsertMode
Menu, Tray, Add
Menu, Tray, Add, Reload Config, TrayReloadConfig
Menu, Tray, Add, Reload Script, TrayReloadScript
Menu, Tray, Add
Menu, Tray, Add, About, TrayAbout
Menu, Tray, Add, Exit, TrayExit
Menu, Tray, Default, Normal Mode
Menu, Tray, Tip, Modal.ahk - Normal Mode

return

; ============================================================================
; TRAY MENU HANDLERS
; ============================================================================

TrayNormalMode:
    Modal_EnterNormalMode()
return

TrayInsertMode:
    Modal_EnterInsertMode()
return

TrayReloadConfig:
    Modal_ReloadConfig()
return

TrayReloadScript:
    Reload
return

TrayAbout:
    MsgBox, 64, Modal.ahk, Modal.ahk - Vim-like Navigation for Windows`n`nA unified modal navigation system for Windows 10/11.`n`nPress CapsLock to toggle between Normal and Insert modes.`nEdit config\settings.ini to customize keybindings.
return

TrayExit:
    ExitApp
return

; ============================================================================
; MODE TOGGLE HOTKEY
; ============================================================================

; CapsLock toggles modal mode
CapsLock::
    Modal_ToggleMode()
return

; Shift+Escape is an alternative toggle
+Escape::
    Modal_ToggleMode()
return

; Ctrl+CapsLock sends actual CapsLock
^CapsLock::
    SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"
return

; ============================================================================
; NORMAL MODE HOTKEYS
; ============================================================================

#If Modal_IsNormalMode()

; Exit to insert mode
i::Modal_InsertAtCursor()
+i::Modal_InsertAtLineStart()
a::Modal_InsertAfterCursor()
+a::Modal_InsertAtLineEnd()

; New lines
o::Modal_InsertNewLineBelow()
+o::Modal_InsertNewLineAbove()

; Basic navigation (hjkl)
h::Modal_NavLeft()
j::Modal_NavDown()
k::Modal_NavUp()
l::Modal_NavRight()

; Word navigation
w::Modal_NavWordRight()
b::Modal_NavWordLeft()

; Line navigation
0::
    global Modal_RepeatCount
    if (Modal_HasPendingKey() || Modal_RepeatCount != "") {
        Modal_AddRepeatDigit("0")
    } else {
        Modal_NavLineStart()
    }
return

$::Modal_NavLineEnd()
^::Modal_NavLineStart()  ; Same as 0, first column

; Page navigation
^u::Modal_NavHalfPageUp()
^d::Modal_NavHalfPageDown()
^b::Modal_NavPageUp()
^f::Modal_NavPageDown()

; Document navigation
g::
    if (Modal_GetPendingKey() = "g") {
        Modal_NavDocStart()
        Modal_ClearRepeatCount()
    } else {
        Modal_SetPendingKey("g")
    }
return

+g::Modal_NavDocEnd()

; Visual mode
v::Modal_EnterVisualMode()
+v::
    Modal_SelectLine()
    Modal_EnterVisualMode()
return

; Deletion
x::Modal_Delete()
+x::Modal_DeleteBack()

d::
    pending := Modal_GetPendingKey()
    if (pending = "d") {
        Modal_DeleteLine()
    } else {
        Modal_SetPendingKey("d")
    }
return

+d::Modal_DeleteToLineEnd()

; Yank (copy)
y::
    pending := Modal_GetPendingKey()
    if (pending = "y") {
        Modal_YankLine()
    } else {
        Modal_SetPendingKey("y")
    }
return

+y::Modal_YankToLineEnd()

; Paste
p::Modal_Paste()
+p::Modal_PasteBefore()

; Change
c::
    pending := Modal_GetPendingKey()
    if (pending = "c") {
        Modal_ChangeLine()
    } else {
        Modal_SetPendingKey("c")
    }
return

+c::Modal_ChangeToLineEnd()

; Undo/Redo
u::Modal_Undo()
^r::Modal_Redo()

; Search
/::Modal_Search()
n::Modal_SearchNext()
+n::Modal_SearchPrev()

; Join lines
+j::Modal_JoinLines()

; Indent/Unindent
>::Modal_IndentLine()
<::Modal_UnindentLine()

; Save
^s::Modal_Save()

; Repeat count digits
1::Modal_AddRepeatDigit("1")
2::Modal_AddRepeatDigit("2")
3::Modal_AddRepeatDigit("3")
4::Modal_AddRepeatDigit("4")
5::Modal_AddRepeatDigit("5")
6::Modal_AddRepeatDigit("6")
7::Modal_AddRepeatDigit("7")
8::Modal_AddRepeatDigit("8")
9::Modal_AddRepeatDigit("9")

; Escape clears pending commands
Escape::
    Modal_ClearRepeatCount()
    Tooltip
return

; Reload script (Ctrl+Shift+Alt+R)
^+!r::Reload

#If

; ============================================================================
; VISUAL MODE HOTKEYS
; ============================================================================

#If Modal_IsVisualMode()

; Navigation in visual mode (extends selection)
h::Modal_SelectLeft()
j::Modal_SelectDown()
k::Modal_SelectUp()
l::Modal_SelectRight()

w::Modal_SelectWordRight()
b::Modal_SelectWordLeft()

0::Modal_SelectToLineStart()
$::Modal_SelectToLineEnd()

; Actions on selection
d::
x::
    Modal_DeleteSelection()
    Modal_EnterNormalMode()
return

y::
    Modal_Yank()
    Modal_EnterNormalMode()
return

c::
    Modal_Change()
return

; Exit visual mode
Escape::
    SendInput, {Right}
    Modal_EnterNormalMode()
return

v::
    SendInput, {Right}
    Modal_EnterNormalMode()
return

#If

; ============================================================================
; INSERT MODE HOTKEYS
; ============================================================================

#If Modal_IsInsertMode()

; Escape returns to normal mode
Escape::Modal_EnterNormalMode()

; jk is a common escape sequence (optional)
; Uncomment if you want this feature:
; ~j::
;     Input, char, L1 T0.2
;     if (char = "k") {
;         SendInput, {Backspace}
;         Modal_EnterNormalMode()
;     }
; return

#If

; ============================================================================
; APPLICATION-SPECIFIC HOTKEYS
; ============================================================================

; Xplorer2 file manager
#If Modal_IsNormalMode() && Modal_IsAppActive("Xplorer2")

; Override navigation for file manager
h::SendInput, {Backspace}
j::SendInput, {Down}
k::SendInput, {Up}
l::SendInput, {Enter}
; Legacy compatibility: old xplorer2/ranger scripts also used Alt+h/j/k/l.
!h::SendInput, {Backspace}
!j::SendInput, {Down}
!k::SendInput, {Up}
!l::SendInput, {Enter}

; Page navigation
+j::SendInput, {PgDn}
+k::SendInput, {PgUp}

; History
+h::SendInput, !{Left}
+l::SendInput, !{Right}

; Go to end
+g::SendInput, {End}

; Quick search
/::SendInput, ^!+f

; Preview file
i::SendInput, ^q

; Edit file
+e::SendInput, {F4}
!f::SendInput, !h

; Bookmarks
'::SendInput, !bm
m::SendInput, !ba

; Command console
+s::SendInput, {F10}
!t::SendInput, ^{Insert}

; User menu
:::SendInput, !uum

; Selection
+v::SendInput, !s
v::SendInput, {NumpadMult}
+Space::SendInput, !a
`::SendInput, !b

; Ordering (o prefix)
o::
    Input, char, L1 T1
    if (char = "s") {
        SendInput, ^!s  ; Order by size
    } else if (char = "t") {
        SendInput, ^!t  ; Order by time
    } else if (char = "n") {
        SendInput, ^!n  ; Order by name
    } else if (char = "d") {
        SendInput, ^!d  ; Order by date
    }
return

; View options (z prefix)
z::
    Input, char, L1 T1
    if (char = "h") {
        SendInput, ^!+h  ; Toggle hidden files
    } else if (char = "u") {
        SendInput, ^d    ; Show directory size
    } else if (char = "f") {
        SendInput, ^h    ; Filter
    } else if (char = "r") {
        SendInput, !{F2} ; Recents
    } else if (char = "z") {
        SendInput, ^j    ; Toggle filter
    }
return

; Goto commands (g prefix)
g::
    Input, char, L1 T1
    if (char = "g") {
        SendInput, {Home}  ; Go to top
    } else if (char = "t") {
        SendInput, ^!{Right}  ; Next tab
    } else if (char = "T") {
        SendInput, ^!{Left}   ; Previous tab
    } else if (char = "c") {
        SendInput, ^{F4}      ; Close tab
    } else if (char = "n") {
        SendInput, ^{Insert}  ; New tab
    } else if (char = "f") {
        ; Focus tree view
        ControlFocus, ATL:FolderTreeView1, A
    } else if (char = "d") {
        SendInput, ^{Backspace}  ; Desktop
    } else if (char = "r") {
        SendInput, +{Backspace}  ; Root
    } else if (char = "h") {
        ; Go to home directory using environment variable
        EnvGet, homePath, USERPROFILE
        SendInput, +{Tab}%homePath%{Enter}  ; Home
    } else if (char = "k") {
        SendInput, ^k  ; Quick access/docs
    }
return

#If

; ============================================================================
; WINDOWS EXPLORER
; ============================================================================

#If Modal_IsNormalMode() && Modal_IsAppActive("Explorer")

h::SendInput, {Backspace}
j::SendInput, {Down}
k::SendInput, {Up}
l::SendInput, {Enter}

+j::SendInput, {PgDn}
+k::SendInput, {PgUp}

+h::SendInput, !{Left}
+l::SendInput, !{Right}

/::SendInput, ^f

g::
    Input, char, L1 T1
    if (char = "g") {
        SendInput, {Home}
    }
return

+g::SendInput, {End}

#If

; ============================================================================
; EXCEL
; ============================================================================

#If Modal_IsNormalMode() && Modal_IsAppActive("Excel")

h::SendInput, {Left}
j::SendInput, {Down}
k::SendInput, {Up}
l::SendInput, {Right}

w::SendInput, ^{Right}
b::SendInput, ^{Left}

0::SendInput, {Home}
$::SendInput, {End}

i::
    SendInput, {F2}
    Modal_EnterInsertMode()
return

d::SendInput, {Delete}
; Legacy Excel mapping: select row, open context menu, choose Delete.
+d::SendInput, +{Space}{AppsKey}d

c::
    SendInput, {Delete}{F2}
    Modal_EnterInsertMode()
return

u::SendInput, ^z

#If

; ============================================================================
; WORD
; ============================================================================

#If Modal_IsNormalMode() && Modal_IsAppActive("Word")

; Legacy Word compatibility: treat LWin as Ctrl while in modal normal mode.
; Use CapsLock/Escape to leave normal mode and restore regular Win-key behavior.
LWin::SendInput, {Ctrl Down}
LWin Up::SendInput, {Ctrl Up}

; Legacy Emacs-style cursor/edit bindings previously defined in applications/Word.ahk.
^a::SendInput, {Home}
^e::SendInput, {End}
^k::SendInput, +{End}{Del}
!-::SendInput, ^z
!=::SendInput, ^y
^w::SendInput, ^{Backspace}

#If

; ============================================================================
; END OF SCRIPT
; ============================================================================
