#RequireAdmin

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <File.au3>

;============================================================================
;Chrome Extension Hunter
;
;Coder:  mike
;
;Description:  Traverse computers looking for Chrome and any extensions used
;
;Version 0.1
;=============================================================================

$g = GUICreate("Chrome Extension Hunter", 400, 90)

$IPs = GUICtrlCreateInput(@IPAddress1, 10, 15, 380)
$RUN = GUICtrlCreateButton("RUN", 325, 50, 50)

GUISetState(@SW_SHOW)

While 1
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
		 ExitLoop
	  Case $RUN
		 $ip = GUICtrlRead($IPs)

		 $ping = Ping($ip)

		 If $ping <> 1 Then MsgBox(16, "Error!", "Please Enter in a Reachable Address")
		 ConsoleWrite($ping)

		 If $ping = 1 Then
			$folders = _FileListToArray("\\" & $ip * "\C$\Users", "*", 2, TRUE)

			For $i = 1 to $folders[0]
			   $ext = _FileListToArray($folders[$i] & "\AppData\Local\Google\Chrome\User Data\Default\Extensions\", "*", 2, TRUE)
			   For $b = 1 to Ubound($ext) - 1
				  $ver = _FileListToArray($ext[$b], "*", 2, TRUE)
				  For $a = 1 to Ubound($ver) - 1
					 $data = _FileListToArray($ver[$a], "*", 0, TRUE)
					 For $c = 1 to UBound($data) - 1
						$manifest = StringInStr($data[$c], "manifest.json")
						If $manifest <> 0 Then
						  $apex = FileReadToArray($data[$c])
						  For $z = 1 to Ubound($apex) - 1
							 If StringInStr($apex[$z], '"name":') <> 0 Then $name = StringStripWS($apex[$z],3)
							 If StringInStr($apex[$z], '"description":') <> 0 Then $desc = StringStripWS($apex[$z],3)
						   Next
							 If StringInStr($name, "__MSG") = 0 Then FileWriteLine("C:\Test\Beta.txt", @IPAddress1 & " - " & $name & $desc)
						EndIf
					 Next
				  Next
			   Next
			Next

			EndIf
   EndSwitch
WEnd

GUIDelete()