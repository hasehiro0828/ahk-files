#Requires AutoHotkey v2.0

#SingleInstance Force

class Utils {
    static isActiveWindow(windowTitle) {
        DetectHiddenWindows(true)
        window := WinExist(windowTitle)
        if (window > 0) {
            return true
        }
        return false
    }
}
