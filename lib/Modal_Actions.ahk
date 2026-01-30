; ============================================================================
; Modal.ahk Actions Library
; AutoHotkey v1.x
; 
; Provides vim-like editing actions that work with the core library.
; Supports delete, yank, paste, undo/redo, and other editing operations.
; ============================================================================

#Include %A_ScriptDir%\lib\Modal_Core.ahk

; ============================================================================
; DELETION ACTIONS
; ============================================================================

Modal_Delete() {
    count := Modal_GetRepeatCount()
    SendInput, {Delete %count%}
    Modal_ClearRepeatCount()
}

Modal_DeleteBack() {
    count := Modal_GetRepeatCount()
    SendInput, {Backspace %count%}
    Modal_ClearRepeatCount()
}

Modal_DeleteWord() {
    count := Modal_GetRepeatCount()
    Loop, %count% {
        SendInput, ^{Delete}
    }
    Modal_ClearRepeatCount()
}

Modal_DeleteWordBack() {
    count := Modal_GetRepeatCount()
    Loop, %count% {
        SendInput, ^{Backspace}
    }
    Modal_ClearRepeatCount()
}

Modal_DeleteLine() {
    ; Select entire line and delete
    SendInput, {Home}+{End}{Delete}{Delete}
    Modal_ClearRepeatCount()
}

Modal_DeleteToLineEnd() {
    ; Delete from cursor to end of line
    SendInput, +{End}{Delete}
    Modal_ClearRepeatCount()
}

Modal_DeleteToLineStart() {
    ; Delete from cursor to start of line
    SendInput, +{Home}{Delete}
    Modal_ClearRepeatCount()
}

Modal_DeleteSelection() {
    ; Delete current selection
    SendInput, {Delete}
    Modal_ClearRepeatCount()
}

; ============================================================================
; YANK (COPY) ACTIONS
; ============================================================================

Modal_Yank() {
    ; Copy selection
    SendInput, ^c
    Modal_Notify("Yanked")
    Modal_ClearRepeatCount()
}

Modal_YankLine() {
    ; Copy entire line
    SendInput, {Home}+{End}^c{Right}
    Modal_Notify("Line Yanked")
    Modal_ClearRepeatCount()
}

Modal_YankLines() {
    ; Copy multiple lines based on repeat count
    count := Modal_GetRepeatCount()
    SendInput, {Home}+{Down %count%}^c{Right}
    Modal_Notify("Lines Yanked")
    Modal_ClearRepeatCount()
}

Modal_YankWord() {
    ; Copy word at cursor
    SendInput, ^{Left}+^{Right}^c
    Modal_Notify("Word Yanked")
    Modal_ClearRepeatCount()
}

Modal_YankToLineEnd() {
    ; Copy from cursor to end of line
    SendInput, +{End}^c{Right}
    Modal_Notify("Yanked to End")
    Modal_ClearRepeatCount()
}

; ============================================================================
; PASTE ACTIONS
; ============================================================================

Modal_Paste() {
    ; Paste after cursor
    if (Modal_ClipboardHasNewline()) {
        SendInput, {End}{Enter}^v
    } else {
        SendInput, ^v
    }
    Modal_ClearRepeatCount()
}

Modal_PasteBefore() {
    ; Paste before cursor
    if (Modal_ClipboardHasNewline()) {
        SendInput, {Home}^v{Enter}{Up}
    } else {
        SendInput, ^v
    }
    Modal_ClearRepeatCount()
}

Modal_PasteLine() {
    ; Paste as new line below
    SendInput, {End}{Enter}^v
    Modal_ClearRepeatCount()
}

Modal_PasteLineBefore() {
    ; Paste as new line above
    SendInput, {Home}^v{Enter}{Up}
    Modal_ClearRepeatCount()
}

; ============================================================================
; CUT ACTIONS
; ============================================================================

Modal_Cut() {
    ; Cut selection
    SendInput, ^x
    Modal_ClearRepeatCount()
}

Modal_CutLine() {
    ; Cut entire line
    SendInput, {Home}+{End}+{Right}^x
    Modal_ClearRepeatCount()
}

; ============================================================================
; UNDO/REDO ACTIONS
; ============================================================================

Modal_Undo() {
    count := Modal_GetRepeatCount()
    Loop, %count% {
        SendInput, ^z
    }
    Modal_ClearRepeatCount()
}

Modal_Redo() {
    count := Modal_GetRepeatCount()
    Loop, %count% {
        SendInput, ^y
    }
    Modal_ClearRepeatCount()
}

; ============================================================================
; INSERT MODE ACTIONS
; ============================================================================

Modal_InsertAtCursor() {
    ; Enter insert mode at cursor
    Modal_EnterInsertMode()
}

Modal_InsertAtLineStart() {
    ; Enter insert mode at start of line
    SendInput, {Home}
    Modal_EnterInsertMode()
}

Modal_InsertAfterCursor() {
    ; Enter insert mode after cursor
    SendInput, {Right}
    Modal_EnterInsertMode()
}

Modal_InsertAtLineEnd() {
    ; Enter insert mode at end of line
    SendInput, {End}
    Modal_EnterInsertMode()
}

Modal_InsertNewLineBelow() {
    ; Insert new line below and enter insert mode
    SendInput, {End}{Enter}
    Modal_EnterInsertMode()
}

Modal_InsertNewLineAbove() {
    ; Insert new line above and enter insert mode
    SendInput, {Home}{Enter}{Up}
    Modal_EnterInsertMode()
}

; ============================================================================
; CHANGE ACTIONS (delete and enter insert mode)
; ============================================================================

Modal_Change() {
    ; Change selection (delete and insert)
    SendInput, {Delete}
    Modal_EnterInsertMode()
}

Modal_ChangeWord() {
    ; Change word
    SendInput, ^+{Right}{Delete}
    Modal_EnterInsertMode()
}

Modal_ChangeLine() {
    ; Change entire line
    SendInput, {Home}+{End}{Delete}
    Modal_EnterInsertMode()
}

Modal_ChangeToLineEnd() {
    ; Change from cursor to end of line
    SendInput, +{End}{Delete}
    Modal_EnterInsertMode()
}

; ============================================================================
; LINE MANIPULATION
; ============================================================================

Modal_JoinLines() {
    ; Join current line with next line
    SendInput, {End}{Delete}{Space}
    Modal_ClearRepeatCount()
}

Modal_IndentLine() {
    ; Indent current line
    SendInput, {Home}{Tab}
    Modal_ClearRepeatCount()
}

Modal_UnindentLine() {
    ; Unindent current line
    SendInput, {Home}+{Tab}
    Modal_ClearRepeatCount()
}

Modal_DuplicateLine() {
    ; Duplicate current line
    SendInput, {Home}+{End}^c{End}{Enter}^v
    Modal_ClearRepeatCount()
}

Modal_MoveLinesUp() {
    ; Move selected lines up (if supported by editor)
    SendInput, !{Up}
    Modal_ClearRepeatCount()
}

Modal_MoveLinesDown() {
    ; Move selected lines down (if supported by editor)
    SendInput, !{Down}
    Modal_ClearRepeatCount()
}

; ============================================================================
; FILE OPERATIONS
; ============================================================================

Modal_Save() {
    SendInput, ^s
    Modal_Notify("Saved")
    Modal_ClearRepeatCount()
}

Modal_SaveAs() {
    SendInput, ^+s
    Modal_ClearRepeatCount()
}

Modal_Open() {
    SendInput, ^o
    Modal_ClearRepeatCount()
}

Modal_New() {
    SendInput, ^n
    Modal_ClearRepeatCount()
}

Modal_Close() {
    SendInput, ^w
    Modal_ClearRepeatCount()
}

Modal_Quit() {
    SendInput, !{F4}
    Modal_ClearRepeatCount()
}

; ============================================================================
; MISC ACTIONS
; ============================================================================

Modal_ToggleComment() {
    ; Toggle comment (editor-specific, Ctrl+/ is common)
    SendInput, ^/
    Modal_ClearRepeatCount()
}

Modal_Format() {
    ; Format code/document (editor-specific)
    SendInput, ^+f
    Modal_ClearRepeatCount()
}

; Note: True vim-style repeat (dot command) is complex to implement.
; This function is a placeholder for future implementation.
; For now, users should use application-specific repeat commands.
Modal_RepeatLastCommand() {
    ; Reserved for future implementation of vim-style dot command
    ; Currently does nothing as proper implementation requires
    ; tracking the last action performed
    Modal_ClearRepeatCount()
}

Modal_Replace() {
    ; Replace character at cursor (enter replace mode briefly)
    SendInput, {Insert}
    ; Wait for one character then switch back
    ; This is simplified - full implementation would need more logic
    Modal_ClearRepeatCount()
}
