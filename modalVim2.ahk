; Modal_Vim.ahk
; Initial Build: Rich Alesi
; Friday, May 29, 2009
;
; Modified for AHK_L by Andrej Mitrovic
; August 10, 2010

#Persistent
#SingleInstance, Force
SetKeyDelay, -1
CoordMode, Tooltip, Screen

;; globals
inputNumber := " "
modal := false

;;; GUI
notify(text, time = 2000)
{
   ; Progress, y980 b2 fs10 zh0 WS800, %text%, , , Verdana
   Progress, y989 b2 fs10 zh0 W150 WS700, %text%, , , Verdana
   Sleep, %time%
   Progress, Off
   return
}

;;; Mode-Switch key
CAPSLOCK::
if (modal == false)
{
   vimize()
}
else
{
   unvimize()
}
return

;;; Mode-Switch and Cleanup Functions
vimize()    ;; Enter Vim mode
{
   global
   modal := true
   notify("vim mode", 600)
   return
}

unvimize()  ;; Exit Vim mode, do cleanup
{
   global
   modal := false
   notify("insert mode", 600)
   resetInputNumber()
   return
}

resetInputNumber()
{
   global
   inputNumber := " "
}


;;; Modal Commands
#If (modal == true)


;;; The following allows appending numbers before a command, 
;;; e.g. 2, 4, w == 24w which can then be used throughout the rest of the commands.
;;; The number is usually reset to 0 by a move/modify command or ESC.

Esc::
{
   unvimize()
   return
}

0::
{
   inputNumber = %inputNumber%0
   return
}

1::
{
   inputNumber = %inputNumber%1
   return
}

2::
{
   inputNumber = %inputNumber%2
   return
}

3::
{
   inputNumber = %inputNumber%3
   return
}

4::
{
   inputNumber = %inputNumber%4
   return
}

5::
{
   inputNumber = %inputNumber%5
   return
}

6::
{
   inputNumber = %inputNumber%6
   return
}

7::
{
   inputNumber = %inputNumber%7
   return
}

8::
{
   inputNumber = %inputNumber%8
   return
}

9::
{
   inputNumber = %inputNumber%9
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

k::
{
   Send, {Down %inputNumber%} 
   resetInputNumber()
   return
}

i::
{
   Send, {Up %inputNumber%} 
   resetInputNumber()
   return
}

a::Send, {Home}
e::Send, {End}
w::
{
   Send, ^{Right %inputNumber%}
   resetInputNumber()
   return
}

b::
{
   Send, ^{Left %inputNumber%}
   resetInputNumber()
   return
}

;;; Searching
/::Send, ^f     ;; Search
n::Send {F3}    ;; Search next
+n::Send +{F3}  ;; Search previous
^/::Send, ^h    ;; Replace

;;; Pasting
p::     ;; Paste at new line
IfInString, clipboard, `n
{
   Send, {END}{ENTER}^v{DEL}
}
Else
{
   Send, ^v
}
return

+p::    ;; Paste at beginning of line (does not work for some reason)
IfInString, clipboard, `n
{
   Send, {Home}^v
}
Else
{
   Send, ^v
}
return

;;; Indent and Undo
+.::Send, {Home}`t                      ;; Indent  
+,::Send, {Shift Down}{Tab}{Shift Up}   ;; Un-indent
u::Send, ^z     ;; Undo
+u::Send, ^y    ;; Redo

#If
