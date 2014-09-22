
; #Include ../../lib/ControlGetFocus.ahk

; While 1==1 {
; Sleep 1000
; Tooltip % ControlGetFocus("A")
; }

; #r::Reload

GetActualKeyPress()
{
Key:=RegExReplace(A_ThisHotkey,"\*","")
; KeyPrefix:=SubStr(Key, 1, RegExMatch(Key,"\[A-Za-z0-9\]"))
; Key:=SubStr(Key, RegExMatch(Key,"[A-Za-z0-9]"))
Key := (GetKeystate("Alt", "D")   ? ("!") : ("")) . Key
Key := (GetKeystate("Shift", "D") ? ("+") : ("")) . Key
Key := (GetKeystate("Ctrl", "D")  ? ("^") : ("")) . Key
Key := (GetKeystate("LWin", "D")   ? ("#") : ("")) . Key
; Tooltip % KeyPrefix . "===" . Key
}


; *r::GetActualKeyPress()

; Goto (g) {{{1
#If SubStr(ControlGetFocus("A"),1,19)=="ATL:BrowserListView" and vim_mode == "g"
; Move to top
g::SendInput {Home}
; New Tab
n::SendInput ^{Insert}
; gt/T:: Next/Previous tab
t::SendInput ^!{Right}
+t::SendInput ^!{Left}
; gc:: Close tab
c::SendInput ^{F4}
; gf:: Go to file tree
f::ControlFocus, ATL:FolderTreeView1, A
; gs:: Go to mini scrap
s::ControlFocus, Mini scrap settings, A

; goto Docs, Desktop, home

; docs
k::^k
; desktop
d::Send ^{Backspace}
; root
r::Send +{Backspace}
; user home
h::SendInput +{Tab}`%homepath`%{Enter}
#If
;}}}
; Ordering files (o);  {{{1
; o + s|t|n|d
#If SubStr(ControlGetFocus("A"),1,19)=="ATL:BrowserListView" and vim_mode == "o"
; By Size
s::^!s
t::^!t
n::^!n
d::^!d
#If
;}}}
; Options (z);  {{{1
#If SubStr(ControlGetFocus("A"),1,19)=="ATL:BrowserListView" and vim_mode == "z"
;h show hidden files 
h::^!+h
;u show dir size
u::SendInput ^d
;f filter
f::SendInput ^h
;r recents
r::SendInput !{F2}
;z toggle filter
z::SendInput ^j
#If
;}}}

; Tree View {{{1
#If SubStr(ControlGetFocus("A"),1,18)=="ATL:FolderTreeView"
    h::Send {Left}
    l::Send {Right}
#If
;}}}

#If (SubStr(ControlGetFocus("A"),1,19)=="ATL:BrowserListView" or SubStr(ControlGetFocus("A"),1,18)=="ATL:FolderTreeView") and vim_mode !="f"
; movement

j::Down
k::Up
l::Enter
h::Backspace

; Move a half page down, up
+j::SendInput {Shift Up}{PgDn}
+k::SendInput {Shift Up}{PgUp}
; +k::SendInput {Shift Up}{Up 10}
; +j::SendInput {Shift Up}{Down 10}

; Back and forth in history
+h::SendInput {Shift Up}!{Left}
+l::SendInput {Shift Up}!{Right}

; gg:: Go to top

o::
g::
z::
f::
vim_mode := A_ThisHotkey
Tooltip, % vim_mode, 1, 1
SetTimer ModeReset, -500
return

+g::SendInput {Shift Up}{End}

~Enter::GoSub, ModeReset

; View file in quick view
i::^q
+e::SendInput {F4}

; Bookmarks (` for go to, m for add current)
'::SendInput !bm
m::SendInput !ba

; Mapped to quick search
/::SendInput ^!+f

; Command console
+s::SendInput {F10}

; Launch custom applications
:::SendInput !uum


+v::SendInput !s
v::NumpadMult

; keep mapping for paste
^v::SendInput ^v
; !1::
; !2::
; !3::
; !4::
; !5::
; !6::
; !7::
; !8::
; !9::




#If

#If vim_mode == "f"

~Enter::
Esc::
GoSub, ModeReset
return

#If

ModeReset:
if (A_ThisHotkey == "f")
{
    sleep, 3000
}
Tooltip
vim_mode :=
return
