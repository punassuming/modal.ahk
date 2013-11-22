#If WinActive(xpl_class) and (CurControl(xpl_class, "ATL:BrowserListView3") or CurControl(xpl_class, "ATL:BrowserListView2") or CurControl(xpl_class, "ATL:BrowserListView4"))

!j::Down
!k::Up
^k::Send ^k
^f::^f
!f::!h
!l::Enter
!h::Backspace
+h::Send !Left
+l::Send !Right
/::Send !/
`::Send !b
+v::Send !mi
!t::Send ^Insert
+Space::Send !a

#If
