#Requires AutoHotkey v2.0

#Include utils.ahk
; ============================================
; Chrome 専用
; --------------------------------------------
#HotIf WinActive("ahk_exe chrome.exe")

; alt + ctrl + i で開発者ツール
^!i::+^i

#HotIf
; ============================================
; Excel 専用
; --------------------------------------------
#HotIf WinActive("ahk_exe EXCEL.EXE")

; Shift + Enter でセルを編集する
+Enter::F2

; Ctrl + Enter で改行する
^Enter::!Enter

; Ctrl + Shift + z でやり直す
^+z::^y

; alt の２連打でコンテキストメニューを表示する
~LAlt:: {
    ; REF: https://ahkscript.github.io/ja/docs/v2/FAQ.htm#DoublePress
    if (A_ThisHotkey != A_PriorHotkey || A_TimeSincePriorHotkey > 200) {
        return
    }

    Send "{Shift Down}{F10}{Shift Up}"
}

#HotIf
; ============================================
; Slack 専用
; --------------------------------------------
#HotIf WinActive("ahk_exe slack.EXE")

; ctrl + [ で go back
^sc01A::!Left
; ctrl + ] で go forward
^sc02b::!Right

#HotIf
; ============================================
; VSCode 専用
; --------------------------------------------
#HotIf WinActive("ahk_exe Code.exe")

; ctrl + [ で go back
^sc01A::!Left
; ctrl + ] で go forward
^sc02b::!Right

#HotIf