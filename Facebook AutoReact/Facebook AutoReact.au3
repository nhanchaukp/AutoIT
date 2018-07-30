#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Auto Reaction on Facebook
#AutoIt3Wrapper_Res_Description=Auto Reaction Facebook
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Nhân Châu KP
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <_HttpRequest.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <WindowsConstants.au3>
Global $_REACTING = 0, $reactions[6] = ["LIKE", "LOVE", "WOW", "HAHA", "SAD", "ANGRY"], $chk_react[6]
$GUI = GUICreate("Facebook AutoReact", 500, 550)
GUISetFont(9, -1, "Segoe UI")
GUISetBkColor(0xffffff, $GUI)
GUICtrlCreateLabel("FB Token", 5, 8)
$txtToken = GUICtrlCreateInput("", 60, 5, 435, -1)
GUICtrlCreateLabel("Bỏ qua ID (;)", 5, 35)
$txtSkipID = GUICtrlCreateInput("100004887041534;364997627165697;...", 80, 30, 415)
GUICtrlSetFont(-1, 12, -1, -1, "Calibri")
GUICtrlCreateLabel("Chọn cảm xúc (chọn nhiều sẽ ra ngẫu nhiên)", 5, 57)
For $i = 0 To UBound($reactions) - 1 Step 1
	$chk_react[$i] = GUICtrlCreateCheckbox($reactions[$i], (($i + 1) * 62) - 50, 75, 60)
Next
GUICtrlSetState($chk_react[0], $GUI_CHECKED)
GUICtrlCreateLabel("Thời gian làm mới (giây) ", 5, 105, 140)
$txtSleep = GUICtrlCreateInput("10", 145, 100, 30)
GUICtrlCreateLabel("Số lượng bài viết mỗi lượt ", 200, 105)
$txtLimit = GUICtrlCreateInput("10", 350, 100, 30)
$btnStart = GUICtrlCreateButton("Bắt đầu", 5, 130, 490, 30)
Global $console = GUICtrlCreateEdit("", 5, 165, 490, 550 - 190, BitOR(0x1000, 0x00200000))
GUICtrlSetFont(-1, 8.5, -1, -1, "Consolas")
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, 0x05DF11)
GUICtrlCreateLabel("Facebook: Nhân Châu KP _ Contact: me@nhanchau.com", 5, 550 - 20)
GUIRegisterMsg($WM_NCLBUTTONDOWN, 'WM_NCLBUTTONDOWN')
GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnStart
			Local $sl_react[6], $chk = 0, $token = GUICtrlRead($txtToken)
			For $i = 0 To UBound($reactions) - 1 Step 1
				If GUICtrlRead($chk_react[$i]) = $GUI_CHECKED Then
					$sl_react[$chk] = $reactions[$i]
					$chk += 1
				EndIf
			Next
			If StringIsSpace($token) Then
				MsgBox(0, "Thông báo", "Chưa có token kìa")
			ElseIf $chk = 0 Then
				MsgBox(0, "Thông báo", "Hãy chọn một cảm xúc đi chứ")
			Else
				ReDim $sl_react[$chk]
				$_REACTING = 1
				_AutoLike($token, GUICtrlRead($txtSkipID), $sl_react, GUICtrlRead($txtLimit), GUICtrlRead($txtSleep))
			EndIf
	EndSwitch
WEnd

Func _AutoLike($token, $skip_ID, $react, $limit = 10, $sleep = 0)
	GUICtrlSetData($console, "")
	$sleep = Number($sleep)
;~ 	Lấy new feed
	$feed = _HttpRequest(2, 'https://graph.facebook.com/me/home?fields=id,message,name&access_token=' & $token & '&offset=0&limit=' & $limit)
	$list_ID = _StringBetween($feed, '"id": "', '",')
	If UBound($list_ID) = 0 Then
		Return 0
	EndIf

;~ 	Loại bỏ ID đã chọn
	For $i = 0 To UBound($list_ID) - 1 Step 1
		$getID = StringSplit($list_ID[$i], '_')
		If StringInStr($skip_ID, $getID[1]) > 0 Then
			_ArrayDelete($list_ID, $i)
		EndIf
	Next

;~ 	Bắt đầu tương ớt
	For $i = 0 To UBound($list_ID) - 1 Step 1
		Local $act = $sl_react[Random(0, UBound($sl_react) - 1, 1)]
		$getID = StringSplit($list_ID[$i], '_')
		$read_console = GUICtrlRead($console)
		_HttpRequest(2, 'https://graph.facebook.com/' & $list_ID[$i] & '/reactions?type=' & $act & '&method=post&access_token=' & $token)
		Sleep(200)
		$return = _HttpRequest(3, 'https://graph.facebook.com/' & $getID[1] & '?fields=name&access_token=' & $token)
		Local $name = _StringBetween($return, '"name": "', '",')
		$name = @error = 0 ? $name[0] : $list_ID[$i]
		$name = Execute("'" & StringRegExpReplace($name, "(\\u([[:xdigit:]]{4}))", "' & ChrW(0x$2) & '") & "'")
		GUICtrlSetData($console, $read_console & "Đã " & $act & " bài viết của " & $name & @CRLF & "  Link: https://www.facebook.com/" & $list_ID[$i] & @CRLF)
		Sleep(800)
	Next

;~ 	Nếu muốn treo liên tục
	If $sleep > 0 Then
		Local $read_console = GUICtrlRead($console)
		Local $counter = $sleep
		While $counter > 0
			GUICtrlSetData($console, $read_console & @CRLF & " Tiếp tục sau " & $counter & " giây... ")
			$counter -= 1
			Sleep(1000)
		WEnd
		_AutoLike($token, $skip_ID, $react, $limit, $sleep)
	EndIf
	$_REACTING = 0
	Return 1
EndFunc   ;==>_AutoLike


Func WM_NCLBUTTONDOWN($hWnd, $iMsg, $iwParam, $ilParam)
	If $iwParam = 0x14 And $_REACTING = 1 Then
		If MsgBox($MB_YESNO + $MB_ICONQUESTION, "Thông báo", "Đang chạy auto reaction bạn có muốn ngừng chứ?") = 6 Then
			GUIDelete()
			Exit
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NCLBUTTONDOWN
