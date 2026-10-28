; AHK v2 script to turn CapsLock into Esc on tap and Ctrl on hold
#Requires AutoHotkey v2.0-beta
#SingleInstance

; Define the behavior for CapsLock
ih := InputHook("B L0.15 T0.15", "{Esc}") ; if hold capslock for more than 150ms then it is only ctrl and not esc
*CapsLock:: {
    ih.Start()
    ; send Ctrl when first tap and held
    Send("{Ctrl down}")
    KeyWait("CapsLock")
    Send("{Ctrl up}")

    ; wait 150ms to check if tap to send esc
    reason := ih.Wait()
    if (reason = "Stopped") {
        Send "{Esc}"
    } else if (reason = "Max") {
        Send "{Blind}{Ctrl down}" ih.Input
    }
}
*CapsLock up::
{
    if (ih.InProgress) {
        ih.Stop()
    } else {
        Send "{Ctrl up}"
    }
}