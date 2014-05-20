; Modal_Vim.ahk
; Initial Build: Rich Alesi
; Friday, May 29, 2009
;
; Modified for AHK_L by Andrej Mitrovic
; Version 0.3
; August 12, 2010

;; globals
inputNumber := " "
modal = 0
shift_mode = 0

unvimize()

#SingleInstance force
#MaxHotkeysPerInterval 800000
; #NoTrayIcon
SetWinDelay, 0
CoordMode, Mouse
#Persistent
SetKeyDelay, -1
; CoordMode, Tooltip, Screen

; ^!home::ExitApp

; Close, edit script
; #If (edit_script == 0)
; ^!home::
; WinGetActiveTitle, aTitle
; WinGetClass, class, %aTitle%
; if (class != "IrfanView")
; {
   ; Run, Scite "G:\Documents and Settings\Andrej\Desktop\Ahk Scripts\vim_mode.ahk"
   ; ExitApp
; }
; return
; #If

;;; GUI
notify(text, time = 0)
{
   if (text == "")
   {
      Progress, Off
      return
   }  
   
   Progress, y989 b2 fs10 zh0 W150 WS700, %text%, , , Verdana
   if (time != 0)
   {
      Sleep, %time%
      Progress, Off
   }
   return
}

;;; Number-normalizer, do not allow more than X ammount of digits
normalize(reset_number)
{
   global inputNumber
   if (inputNumber > 500)
   {
      inputNumber := reset_number
   }
}

;;; Mode-Switch key
CAPSLOCK::
{
   if (modal == 0)
   {
      vimize()
      notify("vim mode", 400)
   }
   else
   {
      unvimize()
      notify("insert mode", 400)
   }
   return
}

;;; Mode-Switch and Cleanup Functions
vimize()    ;; Enter Vim mode
{
   global
   modal := true
   resetGUI()
   return
}

unvimize()  ;; Exit Vim mode, do cleanup
{
   global
   modal := false
   resetGUI()
   resetInputNumber()
   return
}

resetInputNumber()
{
   global
   resetGUI()
   inputNumber := " "
}

resetGUI()
{
   Progress, Off
}

SC029::
{
   if (modal == true)
   {
      return    ; Early exit, shift_mode can't be used while in vim mode
   }
   
   if (shift_mode == 0)
   {
      shift_mode = 1
      return
   }
   else
   {
      shift_mode = 0
      return
   }
   return
}

;;; !@#$ shift_mode works only when not in modal mode
#If (shift_mode == true)

$1::!
$2::@
$3::#
$4::$
$5::Send `%
$6::Send {^}
$7::Send {&}
$8::Send {*}
$9::(
$0::)

SC028::Send, {"}

#If


;;; Vim Mode
#If (modal == true)

Esc::   ;; Reset input number and any commands
{
   inputNumber := ""
   Progress, off
   return
}

;;; The following allows appending numbers before a command, 
;;; e.g. 2, 4, w == 24w which can then be used throughout the rest of the commands.
;;; The number is usually reset to 0 by a move/modify command or ESC.
$0::
{
   if (inputNumber < 1)
   {
      return    ;; Putting 0 in first place does not make sense
   }

   inputNumber = %inputNumber%0
   normalize("")
   notify(inputNumber)
   return
}

$1::
{
   inputNumber = %inputNumber%1
   normalize(1)
   notify(inputNumber)
   return
}

$2::
{
   inputNumber = %inputNumber%2
   normalize(2)
   notify(inputNumber)
   return
}

$3::
{
   inputNumber = %inputNumber%3
   normalize(3)
   notify(inputNumber)
   return
}

$4::
{
   inputNumber = %inputNumber%4
   normalize(4)
   notify(inputNumber)
   return
}

$5::
{
   inputNumber = %inputNumber%5
   normalize(5)
   notify(inputNumber)
   return
}

$6::
{
   inputNumber = %inputNumber%6
   normalize(6)
   notify(inputNumber)
   return
}

$7::
{
   inputNumber = %inputNumber%7
   normalize(7)
   notify(inputNumber)
   return
}

$8::
{
   inputNumber = %inputNumber%8
   normalize(8)
   notify(inputNumber)
   return
}

$9::
{
   inputNumber = %inputNumber%9
   normalize(9)
   notify(inputNumber)
   return
}


;;; Navigation
j::
{
   Send, {Left %inputNumber%} 
   resetInputNumber()
   return
}

l::
{
   Send, {Right %inputNumber%} 
   resetInputNumber()
   return
}

i::
{
   Send, {Up %inputNumber%} 
   resetInputNumber()
   return
}

k::
{
   Send, {Down %inputNumber%} 
   resetInputNumber()
   return
}

^i::
{
   Send, {PgUp}
   return
}

^k::
{
   Send, {PgDn}
   return
}

SC027::Send, {Enter}
a::Send, {Home}
e::Send, {End}

w::     ;; Move # words forward
{
   Send, ^{Right %inputNumber%}
   resetInputNumber()
   return
}

b::     ;; Move # words back
{
   Send, ^{Left %inputNumber%}
   resetInputNumber()
   return
}   

[::     ;; Set cursor to previous block
{
   Send, ^[
   return
}

]::     ;; Set cursor to next block
{
   Send, ^]
   return
}

g::     ;; Go to # line number
{
   Send, ^g%inputNumber%{Enter}
   resetInputNumber()
   return
}

;;; Selections
+i::    ;; Select Up
{
   Send, {shift down}{Up %inputNumber%}{shift up}
   resetInputNumber()
   return
}

+k::    ;; Select Down
{
   Send, {shift down}{Down %inputNumber%}{shift up}
   resetInputNumber()
   return
}

+j::    ;; Select Left
{
   Send, {shift down}{Left %inputNumber%}{shift up}
   resetInputNumber()
   return
}

+l::    ;; Select Right
{
   Send, {shift down}{Right %inputNumber%}{shift up}
   resetInputNumber()
   return
}

^+i::    ;; Select Page Up
{
   Send, {shift down}{PgUp}{shift up}
   return
}

^+k::    ;; Select Page Down
{
   Send, {shift down}{PgDn}{shift up}
   return
}

+w::    ;; Select # Next Word
{
   Send, +^{Right %inputNumber%}
   resetInputNumber()
   return
}

+b::    ;; Select # Previous Words
{
   Send, +^{Left %inputNumber%}
   resetInputNumber()
   return
}

+[::    ;; Select to previous block
{
   Send, {ctrl down}{shift down}[{ctrl up}{shift up}
   return
}

+]::    ;; Select to next block
{
   Send, {ctrl down}{shift down}]{ctrl up}{shift up}
   return
}

;;; Search & Replace
/::     ;; Search
{
   Send, ^f             ;; Call the search dialog
   unvimize()           ;; Switch to insert mode
   KeyWait, Enter, D    ;; Enter exits search dialog
   vimize()             ;; Return back to vim mode
   return
}

^/::    ;; Replace
{
   Send, ^h         ;; Call the replace dialog
   unvimize()       ;; Switch to insert mode
   KeyWait, Esc, D  ;; Esc exits replace dialog
   vimize()         ;; Return back to vim mode
   return
}

n::Send {F3}    ;; Search next
+n::Send +{F3}  ;; Search previous


; Editing
$c::     ;; Copy selection
{
   Send ^c
   notify("Selection copied.", 1000)
   return
}

f::    ;; delete # characters
{
   Send, {Backspace %inputNumber%}
   resetInputNumber()
   return
}

d::    ;; backspace delete # characters
{
   Send, {Delete %inputNumber%}
   resetInputNumber()
   return
}

q::     ;; Comment a line or selected lines
{
   Send, ^q
   return
}

u::Send, ^z     ;; Undo
y::Send, ^y     ;; Redo

^u::    ;; Reopen last closed file
{
   Send, {alt down}f{1}{alt up}
   return
}

; :*C:wd::    ;; Delete # words
; {
   ; Send, {CTRL down}DEL %inputNumber%}{CTRL up}
   ; resetInputNumber()
   ; return

; }

;;; Pasting
p::     ;; Paste at new line
IfInString, clipboard, `n
{
   Send, {END}{ENTER}^v{DEL}
}
Else
{
   Send, {END}{ENTER}^v ;^v
}
return

+p::    ;; Paste at beginning of line (does not work for some reason)
IfInString, clipboard, `n
{
   Send, {Home}^v{Enter}
}
Else
{
   Send, ^v
}
return

; Note, this doesnt currently work with multiple selections
;;; Indenting
.::Send, {Home}`t                            ;; Indent  
,::Send, {Home}{Shift Down}{Tab}{Shift Up}   ;; Un-indent

;;; Scite commands
^[::    ;; Select previous tab
{
   Send, {ctrl down}{shift down}{Tab}{shift up}{ctrl up}
   return
}

^]::    ;; Select next tab
{
   Send, ^{Tab}
   return
}

x::     ;; Close tab
{
   Send, ^w
   return
}

s::     ;; Save tab
{
   Send, ^s
   return
}

#If
