#MaxMem 4095 ; in MB
#MaxThreadsPerHotkey, 5 ; allow same hotkey to be run while it is already running IE a hotkey to toggle something
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically
#UseHook
#InstallKeybdHook
SendMode Input ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir, %A_ScriptDir% ; Ensure consistent working dir.
SetNumLockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff
SetTitleMatchMode,2
DetectHiddenWindows, On
CoordMode, Mouse, Screen
A_crlf := "`r`n"
; CapsLock:: Shift ; Shift
; +Escape::Exitapp ; Shift Escape exits the script

