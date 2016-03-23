#include <_ProcessListFunctions.au3>
#include <Array.au3>
#include <NomadMemory.au3>

$p = ProcessExists("notepad++.exe")

$b = _ProcessListModules($p)

;_ArrayDisplay($b)

$b = _ProcessGetModuleBaseAddress($p, "notepad++.exe")

ConsoleWrite($b)

$i =  1

Do

$o = _MemoryOpen($p)
$m = _MemoryRead($b, $o, "uint64")
$b = $b + 0x8
$m = BinaryToString($m)
FileWrite("memdump", $m)

$i = $i +1
Until $i = 127

;ConsoleWrite(@CRLF & $z)

