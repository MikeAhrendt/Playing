#include <FileConstants.au3>

$file = "C:\Test\data"

$s  = FileGetSize($file)

$b = FileOpen($file, 16384)

$data = FileRead($b, 256)

ConsoleWrite($s)