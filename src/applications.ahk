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

; 戻る（Ctrl + [）の設定
^sc01b:: {
    ; ule4Jis の兼ね合いで Ctrl + ] を押した時にもこのキーが発火するので、その場合は次に進むようにケア
    if (Utils.isActiveWindow(Configs.windowTitles.ule4Jis) && (A_PriorKey == "LControl" || A_PriorKey == "[")) {
        Send "!{Right}"
        return
    }

    Send "!{Left}"
    return
}

; 進む（Ctrl + ]）の設定
^sc02b:: {
    Send "!{Right}"
}

#HotIf
; --------------------------------------------
