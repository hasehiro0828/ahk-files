#Requires AutoHotkey v2.0

#Include ./lib/IMEv2.ahk
#Include ./utils.ahk
#Include ./applications.ahk
#Include ./configs.ahk

#SingleInstance Force

; main.ahk を再起動
^!.:: {
    MsgBox("Rerun main.ahk")
    Reload()
}

;=============================================
; キーボードの Remap
;---------------------------------------------
; Alt 単押しでカーソルのフォーカスが外れるのを防ぐ
~LAlt:: Send "{Blind}{vk07}"
~RAlt:: Send "{Blind}{vk07}"

; Copilot ボタンを無効化
#+F23:: Send "{Blind}{vk07}"

; Win + Alt + Ctrl + BackSpace で Delete
#!^BackSpace::Delete
;=============================================
; macOS 風キーバインド
; cf. https://jimon.info/macos-like-windows#単語単位カーソル移動を再現
; --------------------------------------------
; cmd+矢印 の挙動を再現
^Left::Home ; Mac の「cmd + ←」風
^Right::End ; Mac の「cmd + →」風
^Up::^Home ; Mac の「cmd + ↑」風
^Down::^End ; Mac の「cmd + ↓」風

; Option+左右 の挙動を再現
!Left:: SendInput "^{Left}" ; Mac の「option + ←」風
!Right:: SendInput "^{Right}" ; Mac の「option + →」風
+!Left:: SendInput "^+{Left}" ; Mac の「option + shift + ←」風
+!Right:: SendInput "^+{Right}" ; Mac の「option + shift + →」風

; Mac の control + j,k,l,; が Windows では win + j,k,l,; になるので、macと同じ位置で使えるようにする
#j::^j
#k::^k
#l::^l
#;::^;

; Mac の cmd + tab 的に使えるように変更
; cmd + shift ではうまくいかなかったので caps lock で代用
LCtrl & Tab::AltTab
LCtrl & sc03A::ShiftAltTab ; sc03A=caps lock

; 削除系
!Backspace:: Send "{LCtrl Down}{Backspace}{LCtrl Up}" ; 単語削除
^Backspace:: Send "{LShift Down}{Home Down}{Backspace}{Home Up}{LShift Up}" ; 行頭まで削除
;=============================================
; IME や Ule4Jis など文字入力関連の設定
;---------------------------------------------
~LCtrl:: Send "{Blind}{vk07}"
~RCtrl:: Send "{Blind}{vk07}"

; 左 Ctrl 単押しで IME を OFF
~LCtrl Up:: {
    if (A_Priorkey != "LControl") {
        return
    }
    IME_SET(0)
}

; 右 Ctrl 単押しで IME を ON
~RCtrl Up:: {
    if (A_Priorkey != "RControl") {
        return
    }
    IME_SET(1)
}

; caps lock の２連打で Ule4Jis の有効/無効を切り替える
~sc03A:: {
    ; REF: https://ahkscript.github.io/ja/docs/v2/FAQ.htm#DoublePress
    if (ThisHotkey != A_PriorHotkey || A_TimeSincePriorHotkey > 200) {
        return
    }

    if (Utils.isActiveWindow(Configs.windowTitles.ule4Jis)) {
        WinClose(Configs.windowTitles.ule4Jis)
        MsgBox ("ULE4JIS を終了しました")
        return
    }
    Run(Configs.paths.ule4Jis)
}
; ============================================
; window 操作関連
; FancyZones の設定も必要
; Mac では BetterTouchTool で行っている設定
; --------------------------------------------
; ウィンドウを最大化
^!,:: WinMaximize("A")
; ウィンドウを最大化してから、次のディスプレイに移動
^!m:: {
    WinMaximize("A")

    Send("{LWin Down}")
    Send("+{Right}")
    Send("{LWin Up}")
}

; ウィンドウを FancyZones 上の左に移動
^!j:: {
    Send("{LWin Down}")
    Send("{Left}")
    Send("{LWin Up}")
}
; ウィンドウを FancyZones 上の右に移動
^!k:: {
    Send("{LWin Down}")
    Send("{Right}")
    Send("{LWin Up}")
}
; ============================================
; アプリの終了や最小化関連の操作
; --------------------------------------------
; Mac では cmd + Q でアプリの終了
^q:: WinClose("A")

; Mac では cmd + h で非表示、 cmd + m で最小化
; Windows では 非表示出来ないので最小化のみ
; 最小化したウィンドウを復元するために配列に格納しておく
minimizedWindows := []
^h::
^m:: {
    activeWindow := WinActive("A")
    WinMinimize(activeWindow)
    minimizedWindows.Push(activeWindow)
}
^+h::
^+m:: {
    if minimizedWindows.Length <= 0 {
        MsgBox "最小化されたウィンドウがありません。"
        return
    }
    lastMinimizedWindow := minimizedWindows.Pop()

    ; もしウィンドウが最小化状態であれば復元
    if WinGetMinMax(lastMinimizedWindow) == -1 {
        WinRestore(lastMinimizedWindow)
    }
}
