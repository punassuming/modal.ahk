; Modal_Vim : Modal VIM commands in any application
; Auto-Execute
; Initial Build: Rich Alesi
; Friday, May 29, 2009 


; TODO
; : modal commands
;	q
;	w
;	e
; Movement
; A, I
; o, O
; Delete
; D - delete to end of line
; Y 
; ~ - Change case
; u , r (undo and redo)
; t , T (til item, #)
; gg, GG



; Only work in edit windows

#Persistent
#SingleInstance, Force
SendMode, Input
SetKeyDelay, -1
;#NoTrayIcon
Menu, Tray, Icon, %A_ScriptDir%\vim.ico
CoordMode, Tooltip, Screen


modal =
context =
num =

SetTimer, vim, 20
return




; Disable CAPSLOCK
CAPSLOCK::
+CAPSLOCK::
return

; Use with vimacs
#IfWinActive ahk_class Vim
CAPSLOCK::Send {LControl Down}
CAPSLOCK Up::Send {LControl Up}
#IfWinActive

^CAPSLOCK::CAPSLOCK

vimModeOn := false

+Esc::
	vimModeOn := !vimModeOn
return

vim:
While GetKeyState("CAPSLOCK", "P") and not WinActive("ahk_class Vim")
{
    vimize()
    if modal != 
		Tooltip, %context%: %num%, 60, 10
	else if num !=
		Tooltip, %num%, 60, 10
	else
		Tooltip
	SetTimer, vim, off
}
modal = 
num = 
unvimize()
SetTimer, vim, on
Tooltip
Return

vimize()
{
  Gui 11:Show, Minimize, vimOn ; Hide,
  vimModeOn := true
}

unvimize()
{
  Gui 11:Destroy
  vimModeOn := false
}

#IFWinExist vimOn

; Multiples
1:: num = %num%1
2:: num = %num%2
3:: num = %num%3
4:: num = %num%4
5:: num = %num%5
6:: num = %num%6
7:: num = %num%7
8:: num = %num%8
9:: num = %num%9
0:: num = %num%0

; ~ toggle case

; Navigation

; Go to beginning of line
a::
if modal =
	send, {Home}
else
{
	Send, +{Home}
	GoSub, Run_Mode
}
return

; Go to end of line
e::
if modal =
	send, {End}
else
{
	Send, +{End}
	GoSub, Run_Mode
}
return

; Keyboard Navigation
h::Send, {Left}
j::Send, {Down}
k::Send, {Up}
l::Send, {Right}

; Join
+j::Send {End}{Delete}

; Forward a word
w::
if modal =
	send, ^{RIGHT %num%}
else
{
	Send, ^{Left}+^{RIGHT %num%}
	GoSub, Run_Mode
}
return

;Back a word
b::
if modal =
	Send, ^{LEFT %num%}
else
{
	Send, ^{Right}+^{LEFT %num%}
	GoSub, Run_Mode
}
return


; Searching
/::
s::
  send, ^f ;; search
  unvimize()
  return
^/::
  send, ^h ;; search
  unvimize()
  return 
n::Send {F3}

; Pasting

p::
IfInString, clipboard, `n
{
	Send, {END}{ENTER}^v{DEL}
}
Else
{
	Send, ^v
}
return

+p::
IfInString, clipboard, `n
{
	Send, {Home}^v
}
Else
{
	Send, ^v
}
return

; Indent and Undo
+,::Send, {Home}{HOME}{Del}
+.::Send, {Home}`t

; Undo and redo
u::Send, ^z
+u:: Send, ^y

; Modal Delete
d::
if modal = 
{
	context = Delete Mode
	modal = x
	;GoSub, Modal_Input
}
else if modal = x
{
	GoSub, GetLineSelection
	GoSub, Run_Mode
}
return

; Yanking
y::
if modal = 
{
	context = Yank Mode
	modal = c
	;GoSub, Modal_Input
}
else if modal = c
{
	GoSub, GetLineSelection
	GoSub, Run_Mode
}
return

r::Reload

#IfWinExist

; ===== SubRoutines =====

GetLineSelection:
	Send, {Home}{Shift Down}{End}{DOWN %num%}{Home}{Shift Up}
Return

Run_Mode:
	Send, ^%modal%
	Send {RIGHT}{Left}
	num =
	modal =
return

