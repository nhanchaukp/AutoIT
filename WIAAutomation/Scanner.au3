#include-once
#include <Array.au3>

#Region - WIA Constants
; FormatID

Global Const $wiaFormatBMP = "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatPNG = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatGIF = "{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatJPEG = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatTIFF = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}"

; WiaDeviceType enumeration

Global Const $DeviceTypeUnspecified = 0
Global Const $DeviceTypeScanner = 1
Global Const $DeviceTypeCamera = 2
Global Const $DeviceTypeVideo = 3

; WiaImageIntent enumeration

Global Const $UnspecifiedIntent = 0
Global Const $ColorIntent = 1
Global Const $GrayscaleIntent = 2
Global Const $TextIntent = 4

; WiaImageBias enumeration

Global Const $MinimizeSize = 65536
Global Const $MaximizeQuality = 131072

; WiaPropertyConstant enumeration
Global Const $wiaBrightnessPercents = "6154"
Global Const $wiaContrastPercents = "6155"
Global Const $wiaColorMode = "6146" ;
#EndRegion - WIA Constants

Global $device
Global $item
Global $image
Global $COMerror = ObjEvent("AutoIt.Error", "_evetError")
Global $dialog = ObjCreate("WIA.CommonDialog")
Global $imgProcess = ObjCreate( "Wia.ImageProcess")
$imgProcess.Filters.Add($IP.FilterInfos("Convert").FilterID)
; #FUNCTION# ====================================================================================================================
; Name ..........: _scanNow
; Description ...: Scan tài liệu bằng máy scan
; Syntax ........: _scanNow($filepath, [$open = 1, [$brightness = 0, [$contrast = 0, [$colorMode = $ColorIntent]]]])
; Parameters ....: $filepath 	- Đường dẫn lưu tập tin
;                  $open 		- Tùy chọn mở thư mục sau khi scan: 1 - mở
;                  $brightness 	- Độ sáng ảnh scan. Min: -50, Max: 50
;                  $contrast 	- Độ tương phản ảnh scan. Min: -50, Max: 50
;                  $quanlity 	- Chất lượng ảnh. Min: 0, Max: 100
;                  $colorMode 	- Chế độ màu. Xem ở trên "WiaImageIntent enumeration"
; Return values .:
; Author ........: nhanchau.com (email: me@nhanchau.com)
; Facebook ......: fb.com/chauthainhan
; Donate <3 - quyên góp ủng hộ : http://unghotoi.com/nhanchaukp
; ===============================================================================================================================
Func _scanNow($filepath, $open = 1, $brightness = 0, $contrast = 0,$quanlity=80 , $colorMode = $ColorIntent)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	_PathSplit($filepath, $sDrive, $sDir, $sFileName, $sExtension)
	Local $formatSelect
	Switch StringLower($sExtension)
		Case ".bmp"
			$formatSelect = $wiaFormatBMP
		Case ".gif"
			$formatSelect = $wiaFormatGIF
		Case ".jpg", ".jpeg"
			$formatSelect = $wiaFormatJPEG
		Case ".png"
			$formatSelect = $wiaFormatPNG
		Case ".tif"
			$formatSelect = $wiaFormatTIFF
		Case Else
			$formatSelect = $wiaFormatJPEG
			$filepath = StringReplace($filepath, $sExtension, ".JPG") ; change to default extention
	EndSwitch
	$device = $dialog.ShowSelectDevice($DeviceTypeScanner) ; select device scanner
	If IsObj($device) Then
		$item = $device.Items(1)
		If IsObj($item) Then
			;set properties scanner here
			$item.Properties($wiaBrightnessPercents).Value = $brightness
			$item.Properties($wiaContrastPercents).Value = $contrast
			$item.Properties($wiaColorMode).Value = $colorMode
			$image = $dialog.ShowTransfer($item, $formatSelect)
			;set quanlity format
			$imgProcess.Filters(1).Properties("FormatID").Value = $formatSelect
			$imgProcess.Filters(1).Properties("Quality").Value = $quanlity
			$image = $IP.Apply($image)
			If IsObj($image) Then
				$filepath = StringReplace($filepath, $sExtension, "(%s)" & StringLower($sExtension))
				Local $x = 0, $finalPath
				; process name exist problem
				While 1
					If $x == 0 Then
						$finalPath = StringReplace($filepath, "(%s)", "")
					Else
						$finalPath = StringFormat($filepath, $x)
					EndIf
					If Not FileExists($finalPath) Then ExitLoop
					$x += 1
				WEnd
				If Not FileExists($sDrive & $sDir) Then DirCreate($sDrive & $sDir) ;create dir if not exist
				$image.SaveFile($finalPath) ; process save image scanned
				; open folder after scan
				If $open == 1 And FileExists($sDrive & $sDir) Then
					ShellExecuteWait($sDrive & $sDir)
				EndIf
			EndIf
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_scanNow

Func _evetError()
	Local $HexNumber = Hex($COMerror.number, 8)
	ConsoleWrite("We intercepted a COM Error !" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $COMerror.description & @CRLF & _
			"err.windescription:" & @TAB & $COMerror.windescription & @CRLF & _
			"err.number is: " & @TAB & $HexNumber & @CRLF & _
			"err.lastdllerror is: " & @TAB & $COMerror.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $COMerror.scriptline & @CRLF & _
			"err.source is: " & @TAB & $COMerror.source & @CRLF & _
			"err.helpfile is: " & @TAB & $COMerror.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $COMerror.helpcontext)
	Local $err = StringIsSpace($COMerror.description) ? $COMerror.windescription : $COMerror.description
	SetError(1)
	MsgBox(0 + 16, "Thông báo", $err)
EndFunc   ;==>_evetError

