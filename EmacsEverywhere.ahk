;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         David <tchepak@gmail.com>
;
; Script Function:
;   Provides an Emacs-like keybinding emulation mode that can be toggled on and off using
;   the CapsLock key.
;


;==========================
;Initialise
;==========================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;enabledIcon := "emacs_everywhere_16.ico"
;disabledIcon := "emacs_everywhere_disabled_16.ico"
IsInEmacsMode := false
SetEmacsMode(false)

;==========================
;Functions
;==========================
SetEmacsMode(toActive) {
  local iconFile := toActive ? enabledIcon : disabledIcon
  local state := toActive ? "ON" : "OFF"

  IsInEmacsMode := toActive
  TrayTip, Emacs Everywhere, Emacs mode is %state%, 10, 1
  Menu, Tray, Icon, %iconFile%,
  Menu, Tray, Tip, Emacs Everywhere`nEmacs mode is %state%  

  Send {Shift Up}
}

SendCommand(emacsKey, translationToWindowsKeystrokes, secondWindowsKeystroke="") {
  global IsInEmacsMode
  if (IsInEmacsMode) {
    Send, %translationToWindowsKeystrokes%
    if (secondWindowsKeystroke<>"") {
      Send, %secondWindowsKeystroke%
    }
  } else {
    Send, %emacsKey% ;passthrough original keystroke
  }
  return
}

;==========================
;Emacs mode toggle
;==========================

CapsLock::
  SetEmacsMode(!IsInEmacsMode)
return

;==========================
;Character navigation
;==========================

$^p::SendCommand("^p","{Up}")

$^n::SendCommand("^n","{Down}")

$^f::SendCommand("^f","{Right}")

$^b::SendCommand("^b","{Left}")

;==========================
;Word Navigation
;==========================

$!p::SendCommand("!p","^{Up}")

$!n::SendCommand("!n","^{Down}")

$!f::SendCommand("!f","^{Right}")

$!b::SendCommand("!b","^{Left}")

;==========================
;Line Navigation
;==========================

$^a::SendCommand("^a","{Home}")

$^e::SendCommand("^e","{End}")

;==========================
;Page Navigation
;==========================

;Ctrl-V disabled. Too reliant on that for pasting :$
;$^v::SendCommand("^v","{PgDn}")
;$!v::SendCommand("!v","{PgUp}")

$!<::SendCommand("!<","^{Home}")

$!>::SendCommand("!>","^{End}")

;==========================
;Undo
;==========================

$^_::SendCommand("^_","^z")

;==========================
;Killing and Deleting
;==========================

$^d::SendCommand("^d","{Delete}")

$!d::SendCommand("!d","^+{Right}","{Delete}")

$!Delete::SendCommand("!{Del}","^+{Left}","{Del}")

$^k::SendCommand("^k","+{End}","{Delete}")

$^w::SendCommand("^w","+{Delete}","{Shift Up}") ;cut region

$!w::SendCommand("!w","^{Insert}","{Shift Up}") ;copy region

$^y::SendCommand("^y","+{Insert}") ;paste
