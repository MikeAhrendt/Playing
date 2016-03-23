For $i = 20 to 0 Step -1
   $key = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $i)
   ConsoleWrite($key & @CRLF)
Next