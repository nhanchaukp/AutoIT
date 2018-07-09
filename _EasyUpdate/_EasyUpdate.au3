#include-once
#include <File.au3> ; for save ini file
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>

_EasyUpdate('http://test.com/update.ini', 'Test.exe', '1.0')

; #FUNCTION# ====================================================================================================================
; Name ..........: _EasyUpdate
; Description ...: Kiểm tra cập nhật chương trình
; Syntax ........: _EasyUpdate($iniURL, $sciptName, $curVersion)
; Parameters ....: $iniURL 			- Đường dẫn file ini trên server chưa thông tin về bản cập nhật
;                  $sciptName       - Tên của chương trình cần cập nhật, Ví dụ: MyProgram.exe
;                  $curVersion		- Phiên bản hiện tại của chương trình
; Return values .:
; Author ........: nhanchau.com (email: ctnhan044@gmail.com)
; Facebook ......: fb.com/chauthainhan
; Donate <3 - quyên góp ủng hộ : http://unghotoi.com/nhanchaukp
; ===============================================================================================================================
Func _EasyUpdate($iniURL, $sciptName, $curVersion)
   Local $chose
   Local $iniFilePath = _createIniFilePath($iniURL)	; create ini file on local from $iniURL
   If @error Then
	  MsgBox(0+48, "Warning !", $iniFilePath)
	  Return
   EndIf

   $iscriptName = IniRead($iniFilePath, "EasyUpdater", "scriptName", 0)
   $urlDownload = IniRead($iniFilePath, "EasyUpdater", "scriptUrl", 0)
   $lastedVersion = IniRead($iniFilePath, "EasyUpdater", "scriptVersion", 0);
   $dateUpdate = IniRead($iniFilePath, "EasyUpdater", "dateUpdate", 0);
   $logContent = StringReplace(IniRead($iniFilePath, "EasyUpdater", "changeLog", 0), "<br>", @CRLF)
   FileDelete($iniFilePath) ;delete ini in local after read all
   If $iscriptName==0 Or $iscriptName <> $sciptName Then	;find scriptName on server
	  MsgBox(0+48, "Warning !", "Not found sofware !")
	  Return
   ElseIf Number($curVersion < $lastedVersion) And $urlDownload==0 Then	;check url download null
	  MsgBox(0+48, "Warning !", "Download update error. Url download not found!")
	  Return
   ElseIf Number($curVersion >= $lastedVersion) Then	;compare version
	  MsgBox(0+48, "Warning !", "This is lasted version")
	  Return
   EndIf
   $choose = _msgUpdate("New version available",$logContent, 'Program '&$sciptName&' has new version '&$lastedVersion&@CRLF&'Download update version now?', $lastedVersion, $dateUpdate)
   If $choose == 1 Then; select "Download"
	  Local $sDrive, $sDir, $sFileName, $sExtension
	  _PathSplit($sciptName, $sDrive, $sDir, $sFileName, $sExtension)

	  Local $newNameFile = $sFileName &" "& $lastedVersion & $sExtension
	  _downloadProgress($urlDownload, $newNameFile)
	  If Not @error Then
		 MsgBox(0+64,"Congratulations !", "Software update complete."&@CRLF&"Press OK to run new software")
		 If @Compiled Then; if script Compile then delete current script
			$sTempFile = _TempFile(@TempDir & "\", @ScriptName&"_", ".cmd", Default); create temp .cmd file in temp folder to run new program
			$UpdateScript = '@ECHO ON' & _
							  @CRLF & _
							  'DEL /F "'& @ScriptFullPath &'"'& _ ; delete current script
							  @CRLF & _
							  '	"'& @ScriptDir &"\"& $newNameFile &'"'& _ ; run new script
							  @CRLF & _
							  'DEL /F "'& $sTempFile & '"' & _ ; delete temp .cmd file after excute
							  @CRLF
			If Not FileWrite($sTempFile, $UpdateScript) Then
			   MsgBox(0+48, "Not run update", "Can not run update file, please open manually")
			EndIf
			Run($sTempFile, "", Default)
		 EndIf
		 Return; done
	  EndIf
   EndIf
EndFunc

Func _createIniFilePath($url)
   Local Const $sFilePath = _TempFile(@TempDir & "\", @ScriptName&"_", ".ini", Default) ; create ini temp file
   $iniContent = _getContentUrl($url)
   If @error Then Return SetError(1, 0, $iniContent)

   Local $matchLog = StringRegExp($iniContent, '<MULTILINE>(?s)(.*?)</MULTILINE>', 3) ;$STR_REGEXPARRAYGLOBALMATCH (3)
   If @error Then Return SetError(1, 0, "Can not read change log content")

   $getLog = StringReplace($matchLog[0],@CRLF,"<br>")											; change break-line to <br>
   $iniContent = StringReplace($iniContent,'<MULTILINE>'&$matchLog[0]&'</MULTILINE>',$getLog)	; replace changeLog key to new content with <br> include
   If Not FileWrite($sFilePath, $iniContent) Then Return SetError(1, 0, "Write file error!")

   FileClose($sFilePath)
   Return SetError(0, 0, $sFilePath)
EndFunc

Func _getContentUrl($sURL)
   Local $sData = InetRead($sURL, 2)
   $sData = BinaryToString($sData, 4)
   If (@error) Then Return SetError(1, 0, "Can not get update ini from url!")
   Return SetError(0, 0, $sData)
EndFunc

Func _msgUpdate($title, $log, $msg, $lastedVersion, $dateUpdate, $fontSize = 8.5)
   Local $w_Width = 400, $w_Heigth = 400
   ;from WindowsConstants.au3
   ; 0x00000008 = $WS_EX_TOPMOST, 0x00C00000 = $WS_CAPTION
   ; 0x1000 = $ES_WANTRETURN, 0x00100000 = $WS_HSCROLL, 0x00200000 = $WS_VSCROLL, 0x0800 = $ES_READONLY
   If Not StringIsSpace($log) Then ; if change log not empty content
	  $lastedVersion = "Version "&$lastedVersion&" "
	  If $dateUpdate<>0 Then $lastedVersion = $lastedVersion & "["& $dateUpdate &"]"& @CRLF&@CRLF
	  $log = $lastedVersion & $log; Join content

	  Local $hGUI_Viewer =   GUICreate($title, $w_Width, $w_Heigth, -1, -1, 0x00C00000, 0x00000008)
	  GUICtrlCreateEdit($log, 5, 5, $w_Width - 10, $w_Heigth - 35, BitOR(0x0800, 0x1000, 0x00100000, 0x00200000))
	  GUICtrlSetBkColor(-1, 0xffffff)
	  GUICtrlSetFont(-1, $fontSize, 0, 0, "Calibri")
	  Local $btnUpdate = GUICtrlCreateButton("Update Now", $w_Width - 140, $w_Heigth - 26, 80, 22, 0x0300+0x0C00+0x0001); from ButtonConstants.au3: 0x0001 = $BS_DEFPUSHBUTTON
	  Local $btnSkip = GUICtrlCreateButton("Skip", $w_Width - 55, $w_Heigth - 26, 50, 22, 0x0300+0x0C00)

	  GUISetState(@SW_SHOW)
	  While 1
			Switch GUIGetMsg()
			   Case $btnUpdate
				  GUIDelete($hGUI_Viewer)
				  Return 1
			   Case $btnSkip
				  GUIDelete($hGUI_Viewer)
				  Return 0
			EndSwitch
	  WEnd
   EndIf
   If MsgBox(4, $title, $msg)==6 Then Return 1; $ID_OK(6) replace to 1
 EndFunc

 Func _downloadProgress($sURL, $sFilename)
	Local $iSize, $iTotalSize, $hDownload, $iSec, $iCurrentBytes, $iReadBytes, $szDrive, $szDir, $szFName, $szExt
	_PathSplit($sURL, $szDrive, $szDir, $szFName, $szExt)
	$iSize = InetGetSize ($sURL)
	$iTotalSize = Round($iSize / 1024)
	$hDownload = INetGet($sURL, $sFilename, 16, 1) ; from InetConstants.au3:  $INET_FORCEBYPASS (16) = By-pass forcing the connection online, $INET_DOWNLOADBACKGROUND (1) = Background download
	ProgressOn("", "Download "&$szFName& "...", "Conecting...", -1, -1, 2+1)
	Do
		$iSec = @SEC
		$iCurrentBytes = Round(InetGetInfo($hDownload,0))
		While @SEC = $iSec
			Sleep(1000)
		WEnd
		$iReadBytes = Round(InetGetInfo($hDownload,0))
		$iTotalSize = $iTotalSize - (($iReadBytes - $iCurrentBytes) /1024)
		ProgressSet(100 - Round($iTotalSize / $iSize * 100000), 100 - Round($iTotalSize / $iSize * 100000) & "%")
	Until InetGetInfo($hDownload,2)
	ProgressOff()
	If Not InetGetInfo($hDownload,3) Then Return SetError(1, 0, 0)
EndFunc	;==>InetgetProgress
