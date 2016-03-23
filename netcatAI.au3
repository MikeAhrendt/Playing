#include <StringConstants.au3>

TCPStartup()
$ip = "10.97.13.186"
$port = "2600"
$sock = TCPConnect($ip, $port)
$data = FileRead("C:\Users\mic64887\Desktop\Texts\A.txt")
TCPSend($sock, $data)
TCPCloseSocket($sock)
TCPShutdown()