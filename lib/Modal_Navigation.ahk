; ============================================================================
; Modal.ahk Navigation Library
; AutoHotkey v1.x
; 
; Provides vim-like navigation functions that work with the core library.
; Supports repeat counts and visual mode selection.
; ============================================================================

#Include %A_ScriptDir%\lib\Modal_Core.ahk

; ============================================================================
; BASIC NAVIGATION
; ============================================================================

Modal_NavLeft() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{Left}", count)
    } else {
        Modal_SendKey("{Left}", count)
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavRight() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{Right}", count)
    } else {
        Modal_SendKey("{Right}", count)
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavUp() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{Up}", count)
    } else {
        Modal_SendKey("{Up}", count)
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavDown() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{Down}", count)
    } else {
        Modal_SendKey("{Down}", count)
    }
    
    Modal_ClearRepeatCount()
}

; ============================================================================
; WORD NAVIGATION
; ============================================================================

Modal_NavWordLeft() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        SendInput, +^{Left %count%}
    } else {
        SendInput, ^{Left %count%}
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavWordRight() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        SendInput, +^{Right %count%}
    } else {
        SendInput, ^{Right %count%}
    }
    
    Modal_ClearRepeatCount()
}

; ============================================================================
; LINE NAVIGATION
; ============================================================================

Modal_NavLineStart() {
    if (Modal_IsVisualMode()) {
        SendInput, +{Home}
    } else {
        SendInput, {Home}
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavLineEnd() {
    if (Modal_IsVisualMode()) {
        SendInput, +{End}
    } else {
        SendInput, {End}
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavFirstNonBlank() {
    ; Go to first non-blank character of line
    SendInput, {Home}
    ; Note: AHK doesn't have a direct way to find first non-blank
    Modal_ClearRepeatCount()
}

; ============================================================================
; PAGE NAVIGATION
; ============================================================================

Modal_NavPageUp() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{PgUp}", count)
    } else {
        Modal_SendKey("{PgUp}", count)
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavPageDown() {
    count := Modal_GetRepeatCount()
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{PgDn}", count)
    } else {
        Modal_SendKey("{PgDn}", count)
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavHalfPageUp() {
    ; Move up half a page (approximately 10 lines)
    count := Modal_GetRepeatCount() * 10
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{Up}", count)
    } else {
        Modal_SendKey("{Up}", count)
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavHalfPageDown() {
    ; Move down half a page (approximately 10 lines)
    count := Modal_GetRepeatCount() * 10
    
    if (Modal_IsVisualMode()) {
        Modal_SendWithShift("{Down}", count)
    } else {
        Modal_SendKey("{Down}", count)
    }
    
    Modal_ClearRepeatCount()
}

; ============================================================================
; DOCUMENT NAVIGATION
; ============================================================================

Modal_NavDocStart() {
    if (Modal_IsVisualMode()) {
        SendInput, +^{Home}
    } else {
        SendInput, ^{Home}
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavDocEnd() {
    if (Modal_IsVisualMode()) {
        SendInput, +^{End}
    } else {
        SendInput, ^{End}
    }
    
    Modal_ClearRepeatCount()
}

Modal_NavGotoLine() {
    ; Go to line number (from repeat count)
    count := Modal_GetRepeatCount()
    
    ; Most apps use Ctrl+G for goto line
    SendInput, ^g
    Sleep, 100
    SendInput, %count%{Enter}
    
    Modal_ClearRepeatCount()
}

; ============================================================================
; HISTORY NAVIGATION (for file managers and browsers)
; ============================================================================

Modal_NavHistoryBack() {
    SendInput, !{Left}
    Modal_ClearRepeatCount()
}

Modal_NavHistoryForward() {
    SendInput, !{Right}
    Modal_ClearRepeatCount()
}

; ============================================================================
; FILE MANAGER NAVIGATION
; ============================================================================

Modal_NavParentDir() {
    ; Go to parent directory
    SendInput, {Backspace}
    Modal_ClearRepeatCount()
}

Modal_NavEnterDir() {
    ; Enter directory/open file
    SendInput, {Enter}
    Modal_ClearRepeatCount()
}

Modal_NavFocusTree() {
    ; This is app-specific, try common methods
    ; For xplorer2: Shift+Tab usually works
    SendInput, +{Tab}
    Modal_ClearRepeatCount()
}

; ============================================================================
; SELECTION FUNCTIONS
; ============================================================================

Modal_SelectLeft() {
    count := Modal_GetRepeatCount()
    SendInput, +{Left %count%}
    Modal_ClearRepeatCount()
}

Modal_SelectRight() {
    count := Modal_GetRepeatCount()
    SendInput, +{Right %count%}
    Modal_ClearRepeatCount()
}

Modal_SelectUp() {
    count := Modal_GetRepeatCount()
    SendInput, +{Up %count%}
    Modal_ClearRepeatCount()
}

Modal_SelectDown() {
    count := Modal_GetRepeatCount()
    SendInput, +{Down %count%}
    Modal_ClearRepeatCount()
}

Modal_SelectWordLeft() {
    count := Modal_GetRepeatCount()
    SendInput, +^{Left %count%}
    Modal_ClearRepeatCount()
}

Modal_SelectWordRight() {
    count := Modal_GetRepeatCount()
    SendInput, +^{Right %count%}
    Modal_ClearRepeatCount()
}

Modal_SelectLine() {
    SendInput, {Home}+{End}
    Modal_ClearRepeatCount()
}

Modal_SelectLineDown() {
    count := Modal_GetRepeatCount()
    SendInput, {Home}+{Down %count%}
    Modal_ClearRepeatCount()
}

Modal_SelectToLineStart() {
    SendInput, +{Home}
    Modal_ClearRepeatCount()
}

Modal_SelectToLineEnd() {
    SendInput, +{End}
    Modal_ClearRepeatCount()
}

Modal_SelectAll() {
    SendInput, ^a
    Modal_ClearRepeatCount()
}

Modal_SelectToDocStart() {
    SendInput, +^{Home}
    Modal_ClearRepeatCount()
}

Modal_SelectToDocEnd() {
    SendInput, +^{End}
    Modal_ClearRepeatCount()
}

; ============================================================================
; SCROLL FUNCTIONS (without moving cursor)
; ============================================================================

Modal_ScrollUp() {
    count := Modal_GetRepeatCount()
    Loop, %count% {
        SendInput, ^{Up}
    }
    Modal_ClearRepeatCount()
}

Modal_ScrollDown() {
    count := Modal_GetRepeatCount()
    Loop, %count% {
        SendInput, ^{Down}
    }
    Modal_ClearRepeatCount()
}

Modal_ScrollPageUp() {
    SendInput, {PgUp}
    Modal_ClearRepeatCount()
}

Modal_ScrollPageDown() {
    SendInput, {PgDn}
    Modal_ClearRepeatCount()
}

; ============================================================================
; TAB/WINDOW NAVIGATION
; ============================================================================

Modal_TabNext() {
    SendInput, ^{Tab}
    Modal_ClearRepeatCount()
}

Modal_TabPrev() {
    SendInput, ^+{Tab}
    Modal_ClearRepeatCount()
}

Modal_TabClose() {
    SendInput, ^w
    Modal_ClearRepeatCount()
}

Modal_TabNew() {
    SendInput, ^t
    Modal_ClearRepeatCount()
}

Modal_TabGoto(n) {
    ; Go to nth tab (1-9)
    if (n >= 1 && n <= 9) {
        SendInput, ^%n%
    }
    Modal_ClearRepeatCount()
}

; ============================================================================
; SEARCH FUNCTIONS
; ============================================================================

Modal_Search() {
    SendInput, ^f
    Modal_EnterInsertMode()
}

Modal_SearchNext() {
    SendInput, {F3}
    Modal_ClearRepeatCount()
}

Modal_SearchPrev() {
    SendInput, +{F3}
    Modal_ClearRepeatCount()
}

Modal_SearchReplace() {
    SendInput, ^h
    Modal_EnterInsertMode()
}

; ============================================================================
; UTILITY NAVIGATION
; ============================================================================

Modal_Click() {
    Click
    Modal_ClearRepeatCount()
}

Modal_Escape() {
    SendInput, {Escape}
    Modal_EnterNormalMode()
}
