#include <array.au3>


$o = FileOpen("C:\Mem\message")
$r = FileRead($o)

$a = StringRegExp($r, "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", 3)

$a = _ArrayUnique($a)

_ArrayDisplay($a)
;ConsoleWrite($r)