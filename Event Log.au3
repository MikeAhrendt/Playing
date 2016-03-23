#include <EventLog.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <WinAPI.au3>

Local $t

$g = GUICreate("Login Data", 500, 335)

GUICtrlCreateLabel("Start Date and Time:", 15, 25)

$backdate = @MDAY - 15
If $backdate < 0 Then $backdate = "01"

$Gstart = GUICtrlCreateInput(@MON & "/" & $backdate & "/" & @YEAR & " 13:00:00", 140, 20, 330)
GUICtrlSetTip($Gstart, "MM/DD/YYYY 23:45:00")

GUICtrlCreateLabel("End Date and Time:", 15, 55)

$Gend = GUICtrlCreateInput(@MON & "/" & @MDAY & "/" & @YEAR & " 13:00:00", 140, 50, 330)
GUICtrlSetTip($Gend, "MM/DD/YYYY 23:45:00")

GUICtrlCreateLabel("Computer Name:", 15, 125)
$Computer = GUICtrlCreateInput(@ComputerName, 140, 120, 330)

GUICtrlCreateLabel("User Name:", 15, 155)
$User = GUICtrlCreateInput(@UserName, 140, 150, 330)

GUICtrlCreateLabel("Save Location", 15, 230)
$save = GUICtrlCreateInput("", 115, 225, 355)


$run = GUICtrlCreateButton("Get Data", 370, 290, 100)

GUISetState(@SW_SHOW, $g)

GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

 While 1
   Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
			ExitLoop
		 Case $run

			If StringRegExp($Gstart, "\d\d\/\d\d\/\d\d\d\d \d\d\:\d\d\:\d\d") <> 1 Or If StringRegExp($Gend, "\d\d\/\d\d\/\d\d\d\d \d\d\:\d\d\:\d\d") <> Then
			   MsgBox(48, "Error!", "Please Fill in start time like mm\dd\yyyy hh:mm:ss")
			   ExitLoop
			EndIf

			GUISetState(@SW_HIDE, $g)

			ProgressOn("Login Data", "Querying the Security Logs", "Working...","","",18)

			$CN = GUICtrlRead($Computer)		;Define Computer Name to Login On

			$loc = @DesktopCommonDir & "\" & $CN & "_" & GUICtrlRead($User) & "_" & @MON & @MDAY & @YEAR & ".csv"

			$SL = FileOpen($loc, 10)

			$start = _ConvertToEpoch(GUICtrlRead($Gstart))
			$end = _ConvertToEpoch(GUICtrlRead($Gend))

			$src = _EventLog__Open($CN, "Security")

			$eA = _EventLog__Count($src)

			$chk = Floor($eA / 2)

			$data = _EventLog__Read($src, FALSE, TRUE, $chk)

			$PM = StringInStr($data[3], "PM")

			   If $PM > 0 Then
				  $mt = StringLeft($data[3], 2) + 12
				  $t = StringRegExpReplace($data[3], '\d{2}', $mt, 1)
				  $t = StringTrimRight($t,3)
			   EndIf

			$AM = StringInStr($data[3], "AM")

			If $AM > 0 Then $t = StringTrimRight($data[3], 3)

			$time = _ConvertToEpoch($data[2] & " " & $t)

			If $time < $start & $time < $end Then					; Lines 44-66 are a performance enhancement.  Tells code which direction to run analysis from
			   $order = False
			Else
			   $order = True
			EndIf

			_EventLog__Close($src)

			$src = _EventLog__Open($CN, "Security")

			For $i = 0 To $eA Step 1

			   ProgressSet(Floor(($i / $eA)*100))

			   $data = _EventLog__Read($src, TRUE, $order)

			   $PM = StringInStr($data[3], "PM")

			   If $PM > 0 Then
				  $mt = StringLeft($data[3], 2) + 12
				  $t = StringRegExpReplace($data[3], '\d{2}', $mt, 1)
				  $t = StringTrimRight($t,3)
			   EndIf

			   $AM = StringInStr($data[3], "AM")

			   If $AM > 0 Then $t = StringTrimRight($data[3], 3)

			   $time = _ConvertToEpoch($data[2] & " " & $t)

			   If $time > $start AND $time < $end Then
				  If $data[6] = "4634" OR $data[6] = "4624" OR $data[6] = "8000" OR $data[6] = "8001" OR $data[6] = "7000" OR $data[6] = "7001" Then
					 $usr = StringInStr($data[13], GUICtrlRead($USER))
					 If $usr > 0 Then
						$z = StringInStr($data[13], '.')
						$evt = StringStripCR(StringLeft($data[13], $z + 1))
						;$fevt = StringStripCR($data[13])         ;Used for more detail
						FileWriteLine($SL, $data[2] & " " & $data[3] & ", " & $evt & ", " & $data[6] & "," & $data[1] & @CRLF)		;   Add for $fevt declaration:  &"," & $fevt
					 EndIf
				  EndIf
			   EndIf

			   If $order = False AND $start > $time Then ExitLoop				; Performance Enhancement.  Stop search once items are found
			   If $order = True AND $end < $time Then ExitLoop					; Performance Enhancement.  Stop search once items are found

			Next

			FileClose($SL)

			ProgressSet(100, "Done!")

			Sleep(5000)

			ProgressOff()

			GUISetState(@SW_SHOW, $g)
	  EndSwitch
WEnd

GUIDelete()



Func _ConvertToEpoch($date)
    Local $main_split = StringSplit($date, " ")
    If $main_split[0] - 2 Then
        Return SetError(1, 0, "") ; invalid time format
    EndIf
    Local $asDatePart = StringSplit($main_split[1], "/")
    Local $asTimePart = StringSplit($main_split[2], ":")
    If $asDatePart[0] - 3 Or $asTimePart[0] - 3 Then
        Return SetError(1, 0, "") ; invalid time format
    EndIf
    If $asDatePart[1] < 3 Then
        $asDatePart[1] += 12
        $asDatePart[3] -= 1
    EndIf


    Local $i_aFactor = Int($asDatePart[3] / 100)
    Local $i_bFactor = Int($i_aFactor / 4)
    Local $i_cFactor = 2 - $i_aFactor + $i_bFactor
    Local $i_eFactor = Int(1461 * ($asDatePart[3] + 4716) / 4)
    Local $i_fFactor = Int(153 * ($asDatePart[1] + 1) / 5)
    Local $aDaysDiff = $i_cFactor + $asDatePart[2] + $i_eFactor + $i_fFactor - 2442112
    Local $iTimeDiff = $asTimePart[1] * 3600 + $asTimePart[2] * 60 + $asTimePart[3]
    Return $aDaysDiff * 86400 + $iTimeDiff
 EndFunc


Func _WM_COMMAND($hWHnd, $iMsg, $wParam, $lParam)

    ; If it was an update message from our input
    If _WinAPI_HiWord($wParam) = $EN_CHANGE And _WinAPI_LoWord($wParam) = $save Then

        ; Set the label to the new data
        GUICtrlSetData($save, @DesktopCommonDir & "\" & GUICtrlRead($Computer))

    EndIf

EndFunc