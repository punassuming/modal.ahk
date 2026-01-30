; ============================================================================
; Xplorer2_Modal.ahk - Modal Vim Navigation for xplorer2
; AutoHotkey v1.x
;
; A standalone version of modal navigation specifically for xplorer2 file manager.
; This is a simplified version for users who only need xplorer2 support.
;
; USAGE:
;   1. Run this script with AutoHotkey v1.x
;   2. Open xplorer2 file manager
;   3. Use vim-like keys for navigation
;
; KEYBINDINGS:
;   hjkl - Navigation (Left/Down/Up/Right)
;   H/L - History back/forward
;   J/K - Page down/up
;   gg/G - Go to first/last item
;   / - Quick search
;   ' - Bookmarks menu
;   m - Add bookmark
;   gt/gT - Next/previous tab
;   gc - Close tab
;   gf - Focus folder tree
;   gd - Go to desktop
;   gh - Go to home directory
;   zz - Toggle filter
;   zh - Toggle hidden files
;   os/ot/on/od - Order by size/time/name/date
; ============================================================================

#NoEnv
#Persistent
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetKeyDelay, -1

; Global state
vim_mode := ""

; Get focused control in xplorer2
ControlGetFocus_A() {
    ControlGetFocus, ctrl, A
    return ctrl
}

; Check if we're in xplorer2 browser list
IsXplorer2List() {
    ctrl := ControlGetFocus_A()
    return (SubStr(ctrl, 1, 19) == "ATL:BrowserListView")
}

; Check if we're in xplorer2 tree view
IsXplorer2Tree() {
    ctrl := ControlGetFocus_A()
    return (SubStr(ctrl, 1, 18) == "ATL:FolderTreeView")
}

; Reset vim mode after timeout
ModeReset:
    if (A_ThisHotkey == "f") {
        sleep, 3000
    }
    Tooltip
    vim_mode := ""
return

; ============================================================================
; TREE VIEW NAVIGATION
; ============================================================================

#If IsXplorer2Tree()
    h::Send {Left}
    l::Send {Right}
    j::Send {Down}
    k::Send {Up}
#If

; ============================================================================
; PREFIX MODES (g, o, z, f)
; ============================================================================

#If IsXplorer2List() && vim_mode == "g"
    ; gg - Go to top
    g::SendInput {Home}
    ; gt - Next tab
    t::SendInput ^!{Right}
    ; gT - Previous tab
    +t::SendInput ^!{Left}
    ; gc - Close tab
    c::SendInput ^{F4}
    ; gn - New tab
    n::SendInput ^{Insert}
    ; gf - Focus tree
    f::ControlFocus, ATL:FolderTreeView1, A
    ; gd - Desktop
    d::Send ^{Backspace}
    ; gr - Root
    r::Send +{Backspace}
    ; gh - Home
    h::SendInput +{Tab}`%homepath`%{Enter}
    ; gk - Quick access
    k::^k
#If

#If IsXplorer2List() && vim_mode == "o"
    ; Order by size
    s::^!s
    ; Order by time
    t::^!t
    ; Order by name
    n::^!n
    ; Order by date
    d::^!d
#If

#If IsXplorer2List() && vim_mode == "z"
    ; Toggle hidden files
    h::^!+h
    ; Show directory size
    u::SendInput ^d
    ; Filter
    f::SendInput ^h
    ; Recents
    r::SendInput !{F2}
    ; Toggle filter
    z::SendInput ^j
#If

; ============================================================================
; MAIN NAVIGATION
; ============================================================================

#If (IsXplorer2List() || IsXplorer2Tree()) && vim_mode != "f"

; Basic navigation
j::Down
k::Up
l::Enter
h::Backspace

; Page navigation
+j::SendInput {Shift Up}{PgDn}
+k::SendInput {Shift Up}{PgUp}

; History navigation
+h::SendInput {Shift Up}!{Left}
+l::SendInput {Shift Up}!{Right}

; Go to end
+g::SendInput {Shift Up}{End}

; Enter prefix modes
o::
g::
z::
f::
    vim_mode := A_ThisHotkey
    Tooltip, % vim_mode, 1, 1
    SetTimer ModeReset, -500
return

; Clear mode on enter
~Enter::GoSub, ModeReset

; Preview file
i::^q

; Edit file
+e::SendInput {F4}

; Bookmarks
'::SendInput !bm
m::SendInput !ba

; Quick search
/::SendInput ^!+f

; Command console
+s::SendInput {F10}

; User menu
:::SendInput !uum

; Selection
+v::SendInput !s
v::NumpadMult

; Keep paste working
^v::SendInput ^v

#If

; ============================================================================
; FILTER MODE (f prefix for type-ahead filter)
; ============================================================================

#If vim_mode == "f"
    ~Enter::
    Esc::
        GoSub, ModeReset
    return
#If
