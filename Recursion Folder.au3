;Directory Recursion

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <File.au3>

$folders = _FileListToArray("\\10.97.13.147\C$\Users", "*", 2)

Local $apex, $name, $desc

For $i = 1 to $folders[0]
   $ext = _FileListToArray("\\10.97.13.147\C$\Users\" & $folders[$i] & "\AppData\Local\Google\Chrome\User Data\Default\Extensions\", "*", 2)
   _ArrayDisplay($ext)
   For $j = 1 to Ubound($ext) - 1
	  $data = InetRead("https://chrome.google.com/webstore/detail/" & $ext[$j], 2)
	  ConsoleWrite(BinaryToString($data))
   Next

#CS
For $b = 1 to Ubound($ext) - 1
	  $ver = _FileListToArray($ext[$b], "*", 2, TRUE)
	  For $a = 1 to Ubound($ver) - 1
		 $data = _FileListToArray($ver[$a], "*", 0, TRUE)
		 ;_ArrayDisplay($data)
		 For $c = 1 to UBound($data) - 1
			$manifest = StringInStr($data[$c], "manifest.json")
			If $manifest <> 0 Then
			  ;ConsoleWrite($data[$c] & @CRLF)
			  $apex = FileReadToArray($data[$c])
			  For $z = 1 to Ubound($apex) - 1
				 If StringInStr($apex[$z], '"name":') <> 0 Then $name = StringStripWS($apex[$z],3)
			     If StringInStr($apex[$z], '"description":') <> 0 Then $desc = StringStripWS($apex[$z],3)
			   Next
				 ;_ArrayDisplay($apex)
				 If StringInStr($name, "__MSG") = 0 Then FileWriteLine("C:\Test\Beta.txt", @IPAddress1 & " - " & $name & $desc)
			EndIf
		 Next
	  Next
   Next
#CE

   ;$file = FileReadToArray("\\" & $ip & "\C$\Users\" & $folders[$i] & "\AppData\Local\Google\Chrome\User Data\Default\Extensions\")
Next