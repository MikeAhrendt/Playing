#include <WinHttp.au3>
#include <Array.au3>



;HttpSetProxy(2, "dvlxsec01.spectrum-health.org:2323")

$net = _WinHttpOpen("echo 42", "$WINHTTP_ACCESS_TYPE_NAMED_PROXY", "dvlxsec01.spectrum-health.org:2323")
$iconn = _WinHttpConnect($net, '54.69.62.117')
$post = "input=Whatever You Want to See" & @CRLF
$tst = _WinHttpSimpleRequest($iconn, "POST", '/b.php', '',$post)
ConsoleWrite($tst & @error)
;_ArrayDisplay($tst)