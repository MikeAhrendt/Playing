#include <array.au3>

Local $b[1]


For $y = 2007 to 2016 Step 1

   $year = $y

   For $m = 1 to 12 Step 1

	  $month = $m

	  $URL = "http://blog.dynamoo.com/" & $year & "_" & $month & "_01_archive.html"

		 $data = InetRead($URL)

		 $data = BinaryToString($data)

		 ConsoleWrite($URL & @CRLF)

		 $a = StringRegExp($data, "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", 3)


		 _ArrayAdd($b, $a)

   Next

Next


_ArrayDisplay($b)