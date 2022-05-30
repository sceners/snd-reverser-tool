
.data
_setting	byte 'Settings.ini', 0

;--> DEFINE THE OPTIONS SECTION OF SETTINGS.INI
_options	byte 'Options', 0
_scheme		byte 'Scheme', 0
_ontop		byte 'OnTop', 0
_trans		byte 'TransMove', 0
_tray		byte 'Min2Tray', 0

;--> DEFINE THE MEMO SECTION OF SETTINGS.INI
_memo		byte 'Memo', 0
_memodata	byte 'MemoData', 0



.code

LoadScheme proc

		mov	eax, MyScheme

		.if eax == 2
			mov	CR_BG_SCHEME, CR_BG2
			mov	CR_BTNDOWN_SCHEME, CR_BTNDOWN2
			mov	CR_BTNOVER_SCHEME, CR_BTNDOWN2
			mov	CR_TEXT_SCHEME, CR_TEXT2
			mov	CR_MIDDLE_SCHEME, CR_MIDDLE2
			mov	CR_INBG_SCHEME, CR_INBG2
			mov CR_INTEXT_SCHEME, CR_INTEXT2
			mov	CR_RECT_SCHEME, CR_RECT2
			mov	CR_EDITBG_SCHEME, CR_EDITBG2
			mov	CR_HOVERTEXT_SCHEME, CR_HOVERTEXT2
			mov	CR_NORMTEXT_SCHEME, CR_NORMTEXT2
			mov	CR_DOWNEDGE_SCHEME, CR_HOVEREDGE2
			mov	CR_HOVEREDGE_SCHEME, CR_HOVEREDGE2
			mov	CR_BTNNORM_SCHEME, CR_BTNNORM2
			mov	bChangeFont, FALSE
		.elseif eax == 3
			mov	CR_BG_SCHEME, CR_BG3
			mov	CR_BTNDOWN_SCHEME, CR_BTNDOWN3
			mov	CR_BTNOVER_SCHEME, CR_BTNDOWN3
			mov	CR_TEXT_SCHEME, CR_TEXT3
			mov	CR_MIDDLE_SCHEME, CR_MIDDLE3
			mov	CR_INBG_SCHEME, CR_INBG3
			mov CR_INTEXT_SCHEME, CR_INTEXT3
			mov	CR_RECT_SCHEME, CR_RECT3
			mov	CR_EDITBG_SCHEME, CR_EDITBG3
			mov	CR_HOVERTEXT_SCHEME, CR_HOVERTEXT3
			mov	CR_NORMTEXT_SCHEME, CR_NORMTEXT3
			mov	CR_HOVEREDGE_SCHEME, CR_HOVEREDGE3
			mov	CR_DOWNEDGE_SCHEME, CR_HOVEREDGE3
			mov	CR_BTNNORM_SCHEME, CR_BTNNORM3
			mov	bChangeFont, TRUE
		.elseif eax == 4
			mov	CR_BG_SCHEME, CR_BG4
			mov	CR_BTNDOWN_SCHEME, CR_BTNDOWN4
			mov	CR_BTNOVER_SCHEME, CR_BTNDOWN4
			mov	CR_TEXT_SCHEME, CR_TEXT4
			mov	CR_MIDDLE_SCHEME, CR_MIDDLE4
			mov	CR_INBG_SCHEME, CR_INBG4
			mov CR_INTEXT_SCHEME, CR_INTEXT4
			mov	CR_RECT_SCHEME, CR_RECT4
			mov	CR_EDITBG_SCHEME, CR_EDITBG4
			mov	CR_HOVERTEXT_SCHEME, CR_HOVERTEXT4
			mov	CR_NORMTEXT_SCHEME, CR_NORMTEXT4
			mov	CR_DOWNEDGE_SCHEME, CR_HOVEREDGE4
			mov	CR_HOVEREDGE_SCHEME, CR_HOVEREDGE4
			mov	CR_BTNNORM_SCHEME, CR_BTNNORM4
			mov	bChangeFont, FALSE
		.elseif eax == 5
			invoke	GetSysColor, COLOR_BTNFACE
			mov	CR_BG_SCHEME, eax
			mov	CR_BTNNORM_SCHEME, eax
			mov	CR_RECT_SCHEME, eax
			mov	CR_INBG_SCHEME, eax
			invoke GetSysColor, COLOR_HIGHLIGHT
			mov	CR_HOVEREDGE_SCHEME, eax
			mov	CR_DOWNEDGE_SCHEME, eax
			invoke ColorShift, eax, 050h
			mov	CR_BTNOVER_SCHEME, eax
			mov	eax, CR_HOVEREDGE_SCHEME
			invoke ColorShift, eax, 20h
			mov	CR_BTNDOWN_SCHEME, eax
			invoke GetSysColor, COLOR_WINDOW
			mov	CR_EDITBG_SCHEME, eax
			mov	bChangeFont, FALSE
			invoke GetSysColor, COLOR_BTNTEXT
			mov	CR_TEXT_SCHEME, eax
			mov CR_INTEXT_SCHEME, eax
			mov	CR_HOVERTEXT_SCHEME, eax
			mov	CR_NORMTEXT_SCHEME, eax
		.else
			mov	CR_BG_SCHEME, CR_BG1
			mov	CR_BTNDOWN_SCHEME, CR_BTNDOWN1
			mov	CR_BTNOVER_SCHEME, CR_BTNDOWN1
			mov	CR_TEXT_SCHEME, CR_TEXT1
			mov	CR_MIDDLE_SCHEME, CR_MIDDLE1
			mov	CR_INBG_SCHEME, CR_INBG1
			mov CR_INTEXT_SCHEME, CR_INTEXT1
			mov	CR_RECT_SCHEME, CR_RECT1
			mov	CR_EDITBG_SCHEME, CR_EDITBG1
			mov	CR_HOVERTEXT_SCHEME, CR_HOVERTEXT1
			mov	CR_NORMTEXT_SCHEME, CR_NORMTEXT1
			mov	CR_HOVEREDGE_SCHEME, CR_HOVEREDGE1
			mov	CR_DOWNEDGE_SCHEME, CR_HOVEREDGE1
			mov	CR_BTNNORM_SCHEME, CR_BTNNORM1
			mov	bChangeFont, TRUE
		.endif

		invoke ColorShift, CR_BTNDOWN_SCHEME, 26h
		invoke CreateSolidBrush, eax
		mov	hMnuColor, eax
		invoke CreateSolidBrush, CR_BG_SCHEME
		mov hBgColor, eax
		invoke CreateSolidBrush, CR_BTNDOWN_SCHEME
		mov hBtnColor, eax
		invoke CreateSolidBrush, CR_BTNOVER_SCHEME
		mov hBtnOver, eax
		invoke CreateSolidBrush, CR_MIDDLE_SCHEME
		mov hMiddleColor, eax
		invoke CreateSolidBrush, CR_INBG_SCHEME
		mov hInbgColor, eax
		invoke CreateSolidBrush, CR_EDITBG_SCHEME
		mov	hEditBgColor, eax
		invoke CreateSolidBrush, CR_BTNNORM_SCHEME
		mov	hBtnNormColor, eax

		invoke CreatePen, PS_INSIDEFRAME, 1, CR_RECT_SCHEME
		mov hEdge, eax
		invoke CreatePen, PS_INSIDEFRAME, 1, CR_HOVEREDGE_SCHEME
		mov hEdgeHover, eax
		invoke CreatePen, PS_INSIDEFRAME, 1, CR_DOWNEDGE_SCHEME
		mov hEdgeDown, eax
		invoke CreatePen, PS_INSIDEFRAME, 1, CR_BG_SCHEME
		mov hEdgeBg, eax

		call CreateMenuClass
		ret
LoadScheme endp


LoadSettings proc
		invoke GetAppPath, addr sTempA
		invoke lstrcat, addr sTempA, addr _setting

		invoke GetPrivateProfileInt, addr _options, addr _scheme, 0, addr sTempA
		mov	MyScheme, eax
		call LoadScheme

		.if	MyScheme == 2
			invoke CheckMenuItem, mnuSettings, IDM_SCHEME2, MF_CHECKED
		.elseif MyScheme == 3
			invoke CheckMenuItem, mnuSettings, IDM_SCHEME3, MF_CHECKED
		.elseif MyScheme == 4
			invoke CheckMenuItem, mnuSettings, IDM_SCHEME4, MF_CHECKED
		.elseif MyScheme == 5
			invoke CheckMenuItem, mnuSettings, IDM_SCHEME5, MF_CHECKED
		.else
			invoke CheckMenuItem, mnuSettings, IDM_SCHEME1, MF_CHECKED
		.endif

		invoke GetPrivateProfileInt, addr _options, addr _ontop, 0, addr sTempA
		.if	eax == TRUE
			invoke CheckMenuItem, mnuSettings, IDM_ONTOP, MF_CHECKED
			invoke SetWindowPos, hWindow, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE
		.endif

		invoke GetPrivateProfileInt, addr _options, addr _trans, 0, addr sTempA
		mov	bAnimateWin, FALSE
		.if	eax == TRUE
			invoke CheckMenuItem, mnuSettings, IDM_TRANS, MF_CHECKED
			mov	bAnimateWin, TRUE
		.endif 
	
		invoke GetPrivateProfileInt, addr _options, addr _tray, 0, addr sTempA
		mov	bTrayIcon, FALSE
		.if	eax == TRUE
			invoke CheckMenuItem, mnuSettings, IDM_TRAYM, MF_CHECKED
			mov	bTrayIcon, TRUE
		.endif

		call LoadMemoData

		ret
LoadSettings endp



SaveSettings proc
		invoke GetAppPath, addr sTempA
		invoke lstrcat, addr sTempA, addr _setting

		invoke CheckMenuItem, mnuSettings, IDM_ONTOP, MF_BYCOMMAND
		.if eax != MF_CHECKED
			mov	byte ptr[sTempB], '0'
		.else
			mov	byte ptr[sTempB], '1'
		.endif
		invoke WritePrivateProfileString, addr _options, addr _ontop, addr sTempB, addr sTempA

		invoke CheckMenuItem, mnuSettings, IDM_TRANS, MF_BYCOMMAND
		.if eax != MF_CHECKED
			mov	byte ptr[sTempB], '0'
		.else
			mov	byte ptr[sTempB], '1'
		.endif
		invoke WritePrivateProfileString, addr _options, addr _trans, addr sTempB, addr sTempA

		invoke CheckMenuItem, mnuSettings, IDM_TRAYM, MF_BYCOMMAND
		.if eax != MF_CHECKED
			mov	byte ptr[sTempB], '0'
		.else
			mov	byte ptr[sTempB], '1'
		.endif
		invoke WritePrivateProfileString, addr _options, addr _tray, addr sTempB, addr sTempA


		invoke CheckMenuItem, mnuSettings, IDM_SCHEME1, MF_BYCOMMAND
		.if eax != MF_CHECKED
			invoke CheckMenuItem, mnuSettings, IDM_SCHEME2, MF_BYCOMMAND
			.if eax != MF_CHECKED
				invoke CheckMenuItem, mnuSettings, IDM_SCHEME3, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuSettings, IDM_SCHEME4, MF_BYCOMMAND
					.if eax != MF_CHECKED
						mov	byte ptr[sTempB], '5'					
					.else
						mov	byte ptr[sTempB], '4'
					.endif
				.else
					mov	byte ptr[sTempB], '3'
				.endif
			.else
				mov	byte ptr[sTempB], '2'
			.endif
		.else
			mov	byte ptr[sTempB], '1'
		.endif
		invoke WritePrivateProfileString, addr _options, addr _scheme, addr sTempB, addr sTempA

		call SaveMemoData

		ret
SaveSettings endp


SaveMemoData proc
		invoke GetAppPath, addr sTempA
		invoke lstrcat, addr sTempA, addr _setting

		;invoke lstrcpyA, addr sKeyIn, addr base64MemoChars
		invoke lstrcpy, addr sKeyIn, addr strCHARS

		invoke RtlZeroMemory, offset sTempBuf, sizeof sTempBuf-1
		invoke lstrlen, addr MemoBuffer
		push eax
		push offset sTempBuf
		push offset MemoBuffer
		call BASE64_ENCODE_RT
		invoke WritePrivateProfileString, addr _memo, addr _memodata, addr sTempBuf, addr sTempA
		ret
SaveMemoData endp


LoadMemoData proc
		invoke GetAppPath, addr sTempA
		invoke lstrcat, addr sTempA, addr _setting
		
		invoke RtlZeroMemory, offset sTempBuf, sizeof sTempBuf-1
		invoke RtlZeroMemory, offset MemoBuffer, sizeof MemoBuffer-1
		invoke lstrcpy, addr sKeyIn, addr strCHARS
		invoke GetPrivateProfileString, addr _memo, addr _memodata, NULL, addr sTempBuf, sizeof sTempBuf, addr sTempA
		.if	eax > 0
			invoke lstrlen, addr sTempBuf
			.if eax > 0
				push eax
				push offset MemoBuffer
				push offset sTempBuf
				call BASE64_DECODE_RT
			.endif
		.endif
		ret
LoadMemoData endp
