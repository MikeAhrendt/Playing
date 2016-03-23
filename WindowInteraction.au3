$win = WinWait("Malwarebytes")

$upd = ControlGetHandle($win, "", "Qt5QWindowIcon2")

ControlClick($win, "", "Qt5QWindowIcon2", "left", 1, 885, 215)

ConsoleWrite($upd)