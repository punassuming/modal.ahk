
#IfWinActive ahk_class OpusApp
Lwin::Send {Ctrl Down}
Lwin Up::Send {Ctrl Up}

^a::Send {Home}
^e::Send {End}
^k::Send +{End}{Del}
!-::Send ^z
!=::Send ^y
^w::Send ^{Backspace}

#IfWinActive
