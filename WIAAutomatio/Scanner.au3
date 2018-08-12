#include-once
#include <Array.au3>

#Region - WIA Constants
; FormatID

Global Const $wiaFormatBMP = "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatPNG = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatGIF = "{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatJPEG = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatTIFF = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}"
Global Const $wiaFormatAVI = "{32F8CA14-087C-4908-B7C4-6757FE7E90AB}"

; EventID

Global Const $wiaEventDeviceConnected = "{A28BBADE-64B6-11D2-A231-00C04FA31809}"
Global Const $wiaEventDeviceDisconnected = "{143E4E83-6497-11D2-A231-00C04FA31809}"
Global Const $wiaEventItemCreated = "{4C8F4EF5-E14F-11D2-B326-00C04F68CE61}"
Global Const $wiaEventItemDeleted = "{1D22A559-E14F-11D2-B326-00C04F68CE61}"
Global Const $wiaEventScanImage = "{A6C5A715-8C6E-11D2-977A-0000F87A926F}"
Global Const $wiaEventScanPrintImage = "{B441F425-8C6E-11D2-977A-0000F87A926F}"
Global Const $wiaEventScanFaxImage = "{C00EB793-8C6E-11D2-977A-0000F87A926F}"
Global Const $wiaEventScanOCRImage = "{9D095B89-37D6-4877-AFED-62A297DC6DBE}"
Global Const $wiaEventScanEmailImage = "{C686DCEE-54F2-419E-9A27-2FC7F2E98F9E}"
Global Const $wiaEventScanFilmImage = "{9B2B662C-6185-438C-B68B-E39EE25E71CB}"
Global Const $wiaEventScanImage2 = "{FC4767C1-C8B3-48A2-9CFA-2E90CB3D3590}"
Global Const $wiaEventScanImage3 = "{154E27BE-B617-4653-ACC5-0FD7BD4C65CE}"
Global Const $wiaEventScanImage4 = "{A65B704A-7F3C-4447-A75D-8A26DFCA1FDF}"

; CommandID

Global Const $wiaCommandSynchronize = "{9B26B7B2-ACAD-11D2-A093-00C04F72DC3C}"
Global Const $wiaCommandTakePicture = "{AF933CAC-ACAD-11D2-A093-00C04F72DC3C}"
Global Const $wiaCommandDeleteAllItems = "{E208C170-ACAD-11D2-A093-00C04F72DC3C}"
Global Const $wiaCommandChangeDocument = "{04E725B0-ACAE-11D2-A093-00C04F72DC3C}"
Global Const $wiaCommandUnloadDocument = "{1F3B3D8E-ACAE-11D2-A093-00C04F72DC3C}"

; WiaSubType enumeration

Global Const $UnspecifiedSubType = 0
Global Const $RangeSubType = 1
Global Const $ListSubType = 2
Global Const $FlagSubType = 3

; WiaDeviceType enumeration

Global Const $DeviceTypeUnspecified = 0
Global Const $DeviceTypeScanner = 1
Global Const $DeviceTypeCamera = 2
Global Const $DeviceTypeVideo = 3

; WiaItemFlag enumeration

Global Const $FreeItemFlag = 0x0
Global Const $ImageItemFlag = 0x01
Global Const $FileItemFlag = 0x02
Global Const $FolderItemFlag = 0x04
Global Const $RootItemFlag = 0x08
Global Const $AnalyzeItemFlag = 0x010
Global Const $AudioItemFlag = 0x020
Global Const $selectDeviceiceItemFlag = 0x040
Global Const $DeletedItemFlag = 0x080
Global Const $DisconnectedItemFlag = 0x0100
Global Const $HPanoramaItemFlag = 0x0200
Global Const $VPanoramaItemFlag = 0x0400
Global Const $BurstItemFlag = 0x0800
Global Const $StorageItemFlag = 0x01000
Global Const $TransferItemFlag = 0x02000
Global Const $GeneratedItemFlag = 0x04000
Global Const $HasAttachmentsItemFlag = 0x08000
Global Const $VideoItemFlag = 0x010000
Global Const $RemovedItemFlag = 0x80000000

; WiaPropertyType enumeration

Global Const $UnsupportedPropertyType = 0
Global Const $BooleanPropertyType = 1
Global Const $BytePropertyType = 2
Global Const $IntegerPropertyType = 3
Global Const $UnsignedIntegerPropertyType = 4
Global Const $LongPropertyType = 5
Global Const $UnsignedLongPropertyType = 6
Global Const $ErrorCodePropertyType = 7
Global Const $LargeIntegerPropertyType = 8
Global Const $UnsignedLargeIntegerPropertyType = 9
Global Const $SinglePropertyType = 10
Global Const $DoublePropertyType = 11
Global Const $CurrencyPropertyType = 12
Global Const $DatePropertyType = 13
Global Const $FileTimePropertyType = 14
Global Const $ClassIDPropertyType = 15
Global Const $StringPropertyType = 16
Global Const $ObjectPropertyType = 17
Global Const $HandlePropertyType = 18
Global Const $VariantPropertyType = 19
Global Const $VectorOfBooleansPropertyType = 101
Global Const $VectorOfBytesPropertyType = 102
Global Const $VectorOfIntegersPropertyType = 103
Global Const $VectorOfUnsignedIntegersPropertyType = 104
Global Const $VectorOfLongsPropertyType = 105
Global Const $VectorOfUnsignedLongsPropertyType = 106
Global Const $VectorOfErrorCodesPropertyType = 107
Global Const $VectorOfLargeIntegersPropertyType = 108
Global Const $VectorOfUnsignedLargeIntegersPropertyType = 109
Global Const $VectorOfSinglesPropertyType = 110
Global Const $VectorOfDoublesPropertyType = 111
Global Const $VectorOfCurrenciesPropertyType = 112
Global Const $VectorOfDatesPropertyType = 113
Global Const $VectorOfFileTimesPropertyType = 114
Global Const $VectorOfClassIDsPropertyType = 115
Global Const $VectorOfStringsPropertyType = 116
Global Const $VectorOfVariantsPropertyType = 119

; WiaImagePropertyType enumeration

Global Const $UndefinedImagePropertyType = 1000
Global Const $ByteImagePropertyType = 1001
Global Const $StringImagePropertyType = 1002
Global Const $UnsignedIntegerImagePropertyType = 1003
Global Const $LongImagePropertyType = 1004
Global Const $UnsignedLongImagePropertyType = 1005
Global Const $RationalImagePropertyType = 1006
Global Const $UnsignedRationalImagePropertyType = 1007
Global Const $VectorOfUndefinedImagePropertyType = 1100
Global Const $VectorOfBytesImagePropertyType = 1101
Global Const $VectorOfUnsignedIntegersImagePropertyType = 1102
Global Const $VectorOfLongsImagePropertyType = 1103
Global Const $VectorOfUnsignedLongsImagePropertyType = 1104
Global Const $VectorOfRationalsImagePropertyType = 1105
Global Const $VectorOfUnsignedRationalsImagePropertyType = 1106

; WiaEventFlag enumeration

Global Const $NotificationEvent = 1
Global Const $ActionEvent = 2

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

Func _scanNow($filepath, $open = 1, $brightness = 0, $contrast = 0, $colorMode = $ColorIntent)
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
