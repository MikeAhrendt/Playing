#include <wininet.au3>

$tst =_WinINet_Startup()
$t = _WinINet_InternetOpen("Malicious C2")
$c = _WinINet_InternetConnect($t,$INTERNET_SERVICE_FTP,'10.97.13.186', '2621')
;$c = _WinINet_FtpGetCurrentDirectory($c)

ConsoleWrite($c)
