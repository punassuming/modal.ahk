#ESC::
xl_over:=!xl_over
return

Loop {
; If WinActive("ahk_class XLMAIN")
; {
; ControlGetFocus, xl, ahk_class XLMAIN
; If (xl=="EXCEL71") && ( xl_over=0 ) 
; {
;     xl_vim=1
;     tooltip, Normal Mode
; }
; Else
; {
;     xl_vim=0
;     tooltip, InsertMode
; }
; }
; Else
; {
;     xl_vim=0
;     tooltip
; }
}


#IF xl_vim == 1
*h::Send {left}
*l::Send {right}
*j::Send {down}
*k::Send {up}
u::Send ^z
i::Send {F2}
d::Send {Del}
+d::Send +{Space}{AppsKey}d
*0::Send ^{Left}
*$::Send ^{RIGHT}
c::Send {Del}{F2}
v::
Send {Shift Down}
Tooltip, Visual
return

+v::
Send {Shift Up}
Tooltip
Return
#IF
