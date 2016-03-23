#include <EventLog.au3>
#include <Array.au3>

Local $t

$CN = ""		;Define Computer Name to Login On

$start = _ConvertToEpoch("12/20/2015 00:00:000")
$end = _ConvertToEpoch("12/26/2015 00:00:000")

$src = _EventLog__Open($CN, "Security")

$eA = _EventLog__Count($src)

$chk = Floor($eA / 2)

ConsoleWrite($chk)

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

If $time < $start & $time < $end Then $order = FALSE


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
