.686P ; 686 instruction set, including privilegied ones
.XMM
.MODEL FLAT, STDCALL

;***************************************************************************************
; define the standard MASM libraries to be included
;***************************************************************************************
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\include\advapi32.inc
include \masm32\include\masm32.inc
include \masm32\include\comctl32.inc
include \masm32\include\winmm.inc
include \masm32\include\Shell32.inc
include \masm32\include\ComDlg32.inc
includelib \masm32\LIB\user32.lib
includelib \masm32\LIB\kernel32.lib
includelib \masm32\LIB\gdi32.lib
includelib \masm32\LIB\advapi32.lib
includelib \masm32\LIB\masm32.lib
includelib \masm32\LIB\comctl32.lib
includelib \masm32\LIB\winmm.lib
includelib \masm32\LIB\Shell32.lib
includelib \masm32\LIB\ComDlg32.lib

include \masm32\MACROS\MACROS.ASM

	
;***************************************************************************************
; Reverser Tool Specific Includes
;***************************************************************************************

include data.inc
include release.asm

include tools\Scan.asm
include tools\Enum.asm
include tools\Calc.asm
include tools\Memo.asm
include tools\Brute.asm
include tools\Modify.asm

include settings.asm
include menusNbuttons.asm



;***************************************************************************************
; Start of the CODE Section
;***************************************************************************************
.CODE

start:
		;invoke GetCommandLine
		;mov	CommandLine, eax
		invoke CreateMutexA, NULL, FALSE, addr sSoftware
		invoke GetLastError
		cmp	al, ERROR_ALREADY_EXISTS
		je @only_one

		invoke GetModuleHandle, NULL
		mov hInstance, eax
		invoke DialogBoxParam, eax, IDD_MAIN, NULL, addr DialogProc, 0
	@only_one:
		invoke ExitProcess, 0


;***************************************************************************************
; Basic Dialog Box Proc
;***************************************************************************************
DialogProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local ti:TOOLINFO 
	local hdc:HDC
	local ps:PAINTSTRUCT
	local stRectMove:RECT
	local stRectMoveMemo:RECT
	local sBtnText[10h]:TCHAR


		.if uMsg == WM_INITDIALOG
			mov	eax, hWnd
			mov	hWindow, eax

			;set the window titles appropriately
			invoke SetWindowText, hWnd, addr sSoftware
			invoke SetDlgItemText, hWnd, IDC_TITLE, addr sSoftware

			; subclass the edit controls
			invoke GetDlgItem, hWnd, IDC_INPUT
			invoke SetWindowLong, eax, GWL_WNDPROC, addr EditProc
			mov OldEditProc, eax
			invoke GetDlgItem, hWnd, IDC_OUTPUT
			invoke SetWindowLong, eax, GWL_WNDPROC, addr EditProc

			;create the font to be used in the edit boxes etc
			invoke CreateFont, 14, 0, 0, 0, FW_BOLD, 0, 0, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, DEFAULT_PITCH, SADD("Verdana")
			mov hFont, eax

			;load the software dialog design
			invoke LoadImage, hInstance, IDI_MAIN, IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR
			mov hIcon, eax
			invoke SendMessage, hWnd, WM_SETICON, ICON_BIG, eax

			;load the cursor for use over the combo box and the buttons
			invoke LoadCursor, hInstance, 169
			mov	hCur, eax

			;set cursor focus to the INPUT edit box
			invoke GetDlgItem, hWnd, IDC_INPUT
			invoke SetFocus, eax

			;load settings from the settings.ini
			call LoadSettings

			;setup the font used in the title
			invoke SendMessage, hWnd, WM_GETFONT, 0, 0
			invoke GetObject, eax, SIZEOF LOGFONT, addr TitleFont
			mov TitleFont.lfWeight, FW_BOLD
			sub TitleFont.lfHeight, 2
			invoke CreateFontIndirect, addr TitleFont
			mov hTitleFont, eax

			;load region data
			invoke FindResource, hInstance, addr RsrcName, addr RsrcType
			mov RsrcHand, eax
			invoke LoadResource, hInstance, eax
			mov RsrcPoint, eax
			invoke SizeofResource, hInstance, RsrcHand
			mov RsrcSize, eax
			invoke LockResource, RsrcPoint
			mov RsrcPoint, eax

			;create region and pass it to our window
			invoke ExtCreateRegion, NULL, RsrcSize, eax
			invoke SetWindowRgn, hWnd, eax, TRUE

			;initialise hashes to default values - function is stored in Modify.asm
			call InitialiseHashes

			;********** SUBCLASSING THE BUTTONS AND THE COMBO BOX **********
			;cycle through all the buttons setting the font and subclassing them (save the old button proc for reference)
			mov ebx, IDC_SETTINGS
		@@:
			invoke GetDlgItem, hWnd, EBX
			push eax
			invoke SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, addr BtnProc
			mov	OldBtnProc, eax
			inc	ebx
			cmp	ebx, IDC_TOOLS
			jle	@b

			;save handle for the combobox
			invoke GetDlgItem, hWnd, IDC_FUNCTION
			mov	hComboSelect, eax

			;subclass the combobox and ensure that the USERDATA still uses the old proc
			invoke GetWindowLong, hComboSelect, GWL_WNDPROC
		 	mov OldComboProc, eax
			invoke SetWindowLong, hComboSelect, GWL_USERDATA, OldComboProc
			invoke SetWindowLong, hComboSelect, GWL_WNDPROC, ComboProc

			;initialise the combobox data by adding the relevant strings
			xor	ebx, ebx
		@@:
			mov	eax, [hComboData+ebx*4]
			invoke SendMessage, hComboSelect, CB_ADDSTRING, 0, eax
			inc	ebx
			cmp	ebx, hComboDataSize
			jne	@b


			;by default, 'nothing' is auto stripped from the input
			invoke CheckMenuItem, mnuAutoStrip, IDM_SNOTHING, MF_CHECKED


			;load the tooltips
			invoke CreateWindowEx, NULL, addr tiClass, NULL, TTS_ALWAYSTIP, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, hWnd, NULL, hInstance, NULL
			mov hToolTip, eax
			mov ti.cbSize, sizeof ti
			mov ti.uFlags, TTF_SUBCLASS
			invoke EnumChildWindows, hWnd, addr EnumChild, addr ti
			invoke SendMessage, hToolTip, TTM_SETTIPBKCOLOR, CR_BG_SCHEME, 0
			invoke SendMessage, hToolTip, TTM_SETTIPTEXTCOLOR, CR_TEXT_SCHEME, 0
			invoke SendMessage, hComboSelect, CB_SETCURSEL, 0, 0
			invoke GetDlgItem, hWnd, IDC_KEY


		.elseif uMsg == WM_CTLCOLORDLG
			mov eax, hBgColor
			ret


		.elseif uMsg == WM_CTLCOLORSTATIC
			invoke GetDlgCtrlID, lParam
			push eax
			.if eax == IDC_TITLE
				invoke SelectObject, wParam, hTitleFont
				invoke SetTextColor, wParam, CR_INTEXT_SCHEME
			.else
				invoke SetTextColor, wParam, CR_TEXT_SCHEME
			.endif

			invoke SetBkMode, wParam, TRANSPARENT
			pop eax

			.if eax == IDC_OUTPUT || eax == IDC_INFO
				invoke SetBkColor, wParam, CR_INBG_SCHEME
				invoke SetBkMode, wParam, OPAQUE
				mov eax, hInbgColor
			.else
				invoke SetBkColor, wParam, CR_BG_SCHEME
				mov eax, hBgColor
			.endif
			ret


		.elseif uMsg == WM_CTLCOLOREDIT
			invoke GetDlgCtrlID, lParam
			.if eax == IDC_INPUT || eax == IDC_KEY || eax == IDC_INFO
				invoke SetTextColor, wParam, CR_INTEXT_SCHEME
				invoke SetBkColor, wParam, CR_EDITBG_SCHEME
				invoke SetBkMode, wParam, OPAQUE
				mov eax, hEditBgColor
			.else
				invoke SetTextColor, wParam, CR_NORMTEXT_SCHEME
				invoke SetBkMode, wParam, TRANSPARENT
				invoke SetBkColor, wParam, CR_BG_SCHEME
				mov eax, hInbgColor
			.endif
			ret


		.elseif uMsg == WM_DRAWITEM
			push esi
			mov esi, lParam
			assume esi:ptr DRAWITEMSTRUCT

			.if [esi].CtlType == ODT_BUTTON
				; change the control background color if pushed
				invoke SelectObject, [esi].hdc, hBtnNormColor
				invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME
				invoke GetCursorPos, addr hitpoint
				invoke GetWindowRect, [esi].hwndItem, addr CloseBtnRct
				invoke PtInRect, addr CloseBtnRct, hitpoint.x, hitpoint.y

				.if eax	;hover
					.if [esi].itemState & ODS_DISABLED	;remove the hover if disabled.
						invoke SelectObject, [esi].hdc, hBtnColor
						invoke SetTextColor, [esi].hdc, CR_TEXT_SCHEME
						invoke SelectObject, [esi].hdc, hEdgeDown
					.elseif [esi].itemState & ODS_SELECTED
						invoke SelectObject, [esi].hdc, hBtnColor
						invoke SetTextColor, [esi].hdc, CR_HOVERTEXT_SCHEME
						invoke SelectObject, [esi].hdc, hEdgeDown
					.else
						invoke SelectObject, [esi].hdc, hBtnOver
						invoke SetTextColor, [esi].hdc, CR_HOVERTEXT_SCHEME
						invoke SelectObject, [esi].hdc, hEdgeHover
					.endif
				.else
					.if [esi].itemState & ODS_DISABLED
						invoke SelectObject, [esi].hdc, hBtnColor
						invoke SetTextColor, [esi].hdc, CR_TEXT_SCHEME
						invoke SelectObject, [esi].hdc, hEdgeDown
					.else
						invoke SelectObject, [esi].hdc, hBtnNormColor
						invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME
						invoke SelectObject, [esi].hdc, hEdge
					.endif					
				.endif

				invoke FillRect, [esi].hdc, addr [esi].rcItem, hBtnColor
				invoke Rectangle, [esi].hdc, [esi].rcItem.left, [esi].rcItem.top, [esi].rcItem.right, [esi].rcItem.bottom
				.if [esi].itemState & ODS_SELECTED
					invoke OffsetRect, addr [esi].rcItem, 1, 1
				.endif

				; write the text
				invoke GetDlgItemText, hWnd, [esi].CtlID, addr sBtnText, SIZEOF sBtnText
				invoke SetBkMode, [esi].hdc, TRANSPARENT
				invoke DrawText, [esi].hdc, addr sBtnText, -1, addr [esi].rcItem, DT_CENTER or DT_VCENTER or DT_SINGLELINE

			.elseif [esi].CtlType == ODT_COMBOBOX
				.if [esi].itemState & ODS_SELECTED && [esi].itemState & ODA_SELECT || [esi].itemState & ODS_FOCUS
					invoke FillRect, [esi].hdc, addr [esi].rcItem, hBtnColor
					invoke SetBkMode, [esi].hdc, TRANSPARENT
					invoke SetTextColor, [esi].hdc, CR_HOVERTEXT_SCHEME
				.else				
					invoke FillRect, [esi].hdc, addr [esi].rcItem, hInbgColor
					invoke SetBkMode, [esi].hdc, TRANSPARENT
					invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME
				.endif

				mov	ebx, [esi].itemData
				invoke OffsetRect, addr [esi].rcItem, 4, 0
				invoke DrawText, [esi].hdc, ebx, -1, addr [esi].rcItem, DT_LEFT or DT_VCENTER or DT_SINGLELINE
				mov	eax, hBtnColor

			.elseif [esi].CtlType == ODT_MENU
				invoke SelectObject, [esi].hdc, hBtnNormColor
				invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME

				.if [esi].itemState & ODS_SELECTED
					invoke SelectObject, [esi].hdc, hBtnColor
					invoke SetTextColor, [esi].hdc, CR_HOVERTEXT_SCHEME
					invoke SelectObject, [esi].hdc, hEdgeHover
				.elseif [esi].itemState & ODS_CHECKED 
					invoke SelectObject, [esi].hdc, hMnuColor
					invoke SetTextColor, [esi].hdc, CR_HOVERTEXT_SCHEME
					invoke SelectObject, [esi].hdc, hEdgeHover
				.else
					invoke SelectObject, [esi].hdc, hBgColor
					invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME
					Invoke SelectObject, [esi].hdc, hEdgeBg
				.endif
				invoke SetBkMode, [esi].hdc, TRANSPARENT
				invoke FillRect, [esi].hdc, addr [esi].rcItem, hBtnColor
				invoke Rectangle, [esi].hdc, [esi].rcItem.left, [esi].rcItem.top, [esi].rcItem.right, [esi].rcItem.bottom

				mov	eax, [esi].itemID
				invoke LoadString, hInstance, eax, addr sTempA, sizeof sTempA-1
				add	[esi].rcItem.left, 4
				invoke DrawText, [esi].hdc, addr sTempA, -1, addr [esi].rcItem, DT_LEFT or DT_VCENTER or DT_SINGLELINE
				mov	eax, hBtnColor
				mov	eax, 1
			.endif
			assume esi:nothing
			pop esi


		.elseif uMsg == WM_PAINT
			invoke BeginPaint, hWnd, addr ps
			mov	hdc, eax
			invoke DrawIconEx, hdc, 3, 2, hIcon, 16, 16, 0, 0, DI_NORMAL
			invoke EndPaint, hWnd, addr ps


		.elseif uMsg == WM_MEASUREITEM
			.if wParam == 0
				mov edx, lParam
				mov (MEASUREITEMSTRUCT ptr [edx]).itemWidth, 130
				mov (MEASUREITEMSTRUCT ptr [edx]).itemHeight, 18
			.endif


		.elseif uMsg == WM_LBUTTONDOWN
			mov MoveDlg, TRUE
			invoke SetCapture, hWnd
			invoke GetCursorPos, addr OldPos
			;.if !bAnimateWin
			;	invoke SetLayeredWindowAttributes, hWnd, 0, 200, LWA_ALPHA
			;.endif
			;invoke SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0


	 	.elseif uMsg == WM_LBUTTONUP
	 		mov MoveDlg, FALSE
			invoke ReleaseCapture
			;invoke SetLayeredWindowAttributes, hWnd, 0, 255, LWA_ALPHA


		.elseif uMsg == WM_MOUSEMOVE
			.if MoveDlg == TRUE
				invoke GetWindowRect, hWnd, addr stRectMove
				invoke GetCursorPos, addr NewPos
				mov eax, NewPos.x
				mov ecx, eax
				sub eax, OldPos.x
				mov OldPos.x, ecx
				add eax, stRectMove.left

				mov ebx, NewPos.y
				mov ecx, ebx
				sub ebx, OldPos.y
				mov OldPos.y, ecx
				add ebx, stRectMove.top

				mov ecx, stRectMove.right
				sub ecx, stRectMove.left
				mov edx, stRectMove.bottom
				sub edx, stRectMove.top
				invoke MoveWindow, hWnd, eax, ebx, ecx, edx, TRUE
			.endif


		.elseif uMsg == WM_SIZE
			.if wParam == SIZE_MINIMIZED
				;if we checked "Minimize to system tray"
				.if bTrayIcon == TRUE
					mov note.cbSize, sizeof NOTIFYICONDATA
					push hWnd
					pop note.hwnd
					mov note.uID, IDI_TRAY
					mov note.uFlags, NIF_ICON + NIF_MESSAGE + NIF_TIP
					mov note.uCallbackMessage, WM_SHELLNOTIFY
					mov	eax, hIcon
					mov note.hIcon, eax
					invoke lstrcpy, addr note.szTip, addr sSoftware
					invoke ShowWindow, hWnd, SW_HIDE
					invoke Shell_NotifyIcon, NIM_ADD, addr note
				.endif
			.endif


		.elseif uMsg == WM_SHELLNOTIFY
			.if wParam == IDI_TRAY
				.if lParam == WM_RBUTTONDOWN
					invoke GetCursorPos, addr NewPos
					invoke TrackPopupMenu, hMenuTray, TPM_RIGHTALIGN, NewPos.x, NewPos.y, NULL, hWnd, NULL
				.elseif lParam == WM_LBUTTONDBLCLK
					invoke SendMessage, hWnd, WM_COMMAND, IDM_RESTORE, 0
				.endif
			.endif


		;**********************************************************************
		;**********************************************************************
		; --> START OF WM_COMMAND PROCESSING
		;**********************************************************************
		;**********************************************************************
		.elseif uMsg == WM_COMMAND
			mov eax, wParam
			mov edx, eax
			and eax, 0FFFFh
			shr edx, 16

			;**********************************************************************
			; --> PROCESS THE SELECTED FUNCTION ON INPUT CHANGE ETC
			;**********************************************************************

			.if ((eax == IDC_INPUT || eax == IDC_KEY) && edx == EN_UPDATE) || ax == IDC_FUNCTION
				invoke callRTFunction, hWnd
				.if eax == TRUE
					invoke EnableBtns, hWnd
				.else
					invoke DisableBtns, hWnd
				.endif


			;**********************************************************************
			; --> BEGIN PROCESSING MENUS
			;**********************************************************************
			;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;--> SETTINGS MENU AND SUBMENUS
			;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
			.elseif eax == IDC_SETTINGS
				invoke GetDlgItem, hWnd, eax
				invoke GetWindowRect, eax, addr OptBtnRect
				invoke GetWindowRect, hWnd, addr DlgRect
				mov	eax, OptBtnRect.left
				mov	ebx, OptBtnRect.bottom
				invoke TrackPopupMenu, mnuSettings, TPM_LEFTALIGN, eax, ebx, 0, hWnd, addr DlgRect


			.elseif eax == IDM_SCHEME1 || eax == IDM_SCHEME2 || eax == IDM_SCHEME3 || eax == IDM_SCHEME4 || eax == IDM_SCHEME5
				mov	ebx, eax
				push ebx
				invoke CheckMenuItem, mnuSettings, IDM_SCHEME1, MF_UNCHECKED
				invoke CheckMenuItem, mnuSettings, IDM_SCHEME2, MF_UNCHECKED
				invoke CheckMenuItem, mnuSettings, IDM_SCHEME3, MF_UNCHECKED
				invoke CheckMenuItem, mnuSettings, IDM_SCHEME4, MF_UNCHECKED
				invoke CheckMenuItem, mnuSettings, IDM_SCHEME5, MF_UNCHECKED
				pop	ebx
				invoke CheckMenuItem, mnuSettings, ebx, MF_CHECKED
				call SaveSettings
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0
				invoke DialogBoxParam, eax, IDD_MAIN, NULL, addr DialogProc, 0


			.elseif eax == IDM_ONTOP
				invoke CheckMenuItem, mnuSettings, IDM_ONTOP, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuSettings, IDM_ONTOP, MF_CHECKED
					invoke SetWindowPos, hWindow, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE
					mov bOnTop, TRUE
				.else
					invoke CheckMenuItem, mnuSettings, IDM_ONTOP, MF_UNCHECKED
					invoke SetWindowPos, hWindow, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE
					mov bOnTop, FALSE
				.endif
				call SaveSettings
				call LoadSettings


			.elseif eax == IDM_RESTORE
				invoke Shell_NotifyIcon, NIM_DELETE, addr note
				invoke ShowWindow, hWnd, SW_RESTORE


			.elseif eax == IDM_TRAYM
				invoke CheckMenuItem, mnuSettings, IDM_TRAYM, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuSettings, IDM_TRAYM, MF_CHECKED
					mov	bTrayIcon, TRUE
				.else
					invoke CheckMenuItem, mnuSettings, IDM_TRAYM, MF_UNCHECKED
					mov	bTrayIcon, FALSE
				.endif 
				call SaveSettings
				call LoadSettings


	 		;.elseif eax == IDM_TRANS
			;	 invoke CheckMenuItem, mnuOptions, IDM_TRANS, MF_BYCOMMAND
			;	.if eax != MF_CHECKED
			;		invoke CheckMenuItem, mnuOptions, IDM_TRANS, MF_CHECKED
			;		mov	bAnimateWin, TRUE
			;	.else
			;		invoke CheckMenuItem, mnuOptions, IDM_TRANS, MF_UNCHECKED
			;		mov	bAnimateWin, FALSE
			;	.endif
			;	call SaveSettings
			;	call LoadSettings
			
			
			;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;--> KEY OPTIONS MENU AND SUBMENUS
			;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
			.elseif eax == IDC_OPTIONS
				invoke GetDlgItem, hWnd, eax
				invoke GetWindowRect, eax, addr OptBtnRect
				invoke GetWindowRect, hWnd, addr DlgRect
				mov	eax, OptBtnRect.left
				mov	ebx, OptBtnRect.bottom
				invoke TrackPopupMenu, mnuOptions, TPM_LEFTALIGN, eax, ebx, 0, hWnd, addr DlgRect


			; Start menu processing for the 'auto strip' options
			.elseif eax == IDM_SNOTHING || eax == IDM_SSPACES || eax == IDM_SNONHEX || eax == IDM_SNONALPHA
				mov bStripSpaces, FALSE
				mov bStripNonHex, FALSE
				mov bStripNonAlpha, FALSE
				.if eax == IDM_SSPACES
					mov bStripSpaces, TRUE
				.elseif eax == IDM_SNONHEX
					mov bStripNonHex, TRUE
				.elseif eax == IDM_SNONALPHA
					mov bStripNonAlpha, TRUE
				.endif
				push eax
				invoke CheckMenuItem, mnuAutoStrip, IDM_SNOTHING, MF_UNCHECKED
				invoke CheckMenuItem, mnuAutoStrip, IDM_SSPACES, MF_UNCHECKED
				invoke CheckMenuItem, mnuAutoStrip, IDM_SNONHEX, MF_UNCHECKED
				invoke CheckMenuItem, mnuAutoStrip, IDM_SNONALPHA, MF_UNCHECKED
				pop eax	
				invoke CheckMenuItem, mnuAutoStrip, eax, MF_CHECKED
				invoke callRTFunction, hWnd


			; Start menu processing for the 'input output' options
			.elseif eax == IDM_RIAH
				invoke CheckMenuItem, mnuInOutOpts, IDM_RIAH, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuInOutOpts, IDM_RIAH, MF_CHECKED
					mov bInputAsHex, TRUE
				.else
					invoke CheckMenuItem, mnuInOutOpts, IDM_RIAH, MF_UNCHECKED
					mov bInputAsHex, FALSE
				.endif
				invoke callRTFunction, hWnd


			.elseif eax == IDM_RKAH
				invoke CheckMenuItem, mnuInOutOpts, IDM_RKAH, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuInOutOpts, IDM_RKAH, MF_CHECKED
					mov bKeyAsHex, TRUE
				.else
					invoke CheckMenuItem, mnuInOutOpts, IDM_RKAH, MF_UNCHECKED
					mov bKeyAsHex, FALSE
				.endif
				invoke callRTFunction, hWnd


			.elseif eax == IDM_DOAH
				invoke CheckMenuItem, mnuInOutOpts, IDM_DOAH, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuInOutOpts, IDM_DOAH, MF_CHECKED
					mov bOutputAsHex, TRUE
				.else
					invoke CheckMenuItem, mnuInOutOpts, IDM_DOAH, MF_UNCHECKED
					mov bOutputAsHex, FALSE
				.endif
				invoke callRTFunction, hWnd


			.elseif eax == IDM_DOUP
				invoke CheckMenuItem, mnuInOutOpts, IDM_DOUP, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuInOutOpts, IDM_DOUP, MF_CHECKED
					mov bOutputInUppercase, TRUE
				.else
					invoke CheckMenuItem, mnuInOutOpts, IDM_DOUP, MF_UNCHECKED
					mov bOutputInUppercase, FALSE
				.endif
				invoke callRTFunction, hWnd


			.elseif eax == IDM_DOIF
				invoke CheckMenuItem, mnuInOutOpts, IDM_DOIF, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuInOutOpts, IDM_DOIF, MF_CHECKED
					mov bOutputIfUnicode, TRUE
				.else
					invoke CheckMenuItem, mnuInOutOpts, IDM_DOIF, MF_UNCHECKED
					mov bOutputIfUnicode, FALSE
				.endif
				invoke callRTFunction, hWnd

			; Start menu processing for the encryption options
			.elseif eax == IDM_BSI
				invoke CheckMenuItem, mnuEncOpts, IDM_BSI, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuEncOpts, IDM_BSI, MF_CHECKED
					mov bBswapInput, TRUE
				.else
					invoke CheckMenuItem, mnuEncOpts, IDM_BSI, MF_UNCHECKED
					mov bBswapInput, FALSE
				.endif
				invoke callRTFunction, hWnd


			.elseif eax == IDM_BSK
				invoke CheckMenuItem, mnuEncOpts, IDM_BSK, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuEncOpts, IDM_BSK, MF_CHECKED
					mov bBswapKey, TRUE
				.else
					invoke CheckMenuItem, mnuEncOpts, IDM_BSK, MF_UNCHECKED
					mov bBswapKey, FALSE
				.endif
				invoke callRTFunction, hWnd


			.elseif eax == IDM_PI
				invoke CheckMenuItem, mnuEncOpts, IDM_PI, MF_BYCOMMAND
				.if eax != MF_CHECKED
					invoke CheckMenuItem, mnuEncOpts, IDM_PI, MF_CHECKED
					mov bPadInput, TRUE
				.else
					invoke CheckMenuItem, mnuEncOpts, IDM_PI, MF_UNCHECKED
					mov bPadInput, FALSE
				.endif
				invoke callRTFunction, hWnd


			.elseif eax == IDM_EBC || eax == IDM_CBC
				push eax
				invoke CheckMenuItem, mnuEncMode, IDM_EBC, MF_UNCHECKED
				invoke CheckMenuItem, mnuEncMode, IDM_CBC, MF_UNCHECKED
				pop	eax
				mov	ebx, eax
				sub	ebx, IDM_EBC
				mov	bCipherMode, ebx
				invoke CheckMenuItem, mnuEncMode, eax, MF_CHECKED
				invoke callRTFunction, hWnd


			;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
			;-->TOOLS MENU AND SUBMENUS
			;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
			.elseif eax == IDC_TOOLS
				invoke GetDlgItem, hWnd, eax
				invoke GetWindowRect, eax, addr OptBtnRect
				invoke GetWindowRect, hWnd, addr DlgRect
				mov	eax, OptBtnRect.left
				mov	ebx, OptBtnRect.bottom
				invoke TrackPopupMenu, mnuTools, TPM_LEFTALIGN, eax, ebx, 0, hWnd, addr DlgRect

			.elseif eax==IDC_ABOUT
				invoke DialogBoxParam, hInstance, IDD_ABOUT, hWnd, addr AbtDialogProc, NULL

			.elseif eax==IDM_MEMO
				invoke CreateDialogParam, hInstance, IDD_MEMO, hWnd, addr MemoDialogProc, NULL

			.elseif eax==IDM_SCAN
				invoke CreateDialogParam, hInstance, IDD_SCAN, hWnd, addr ScanDialogProc, NULL

			.elseif eax==IDM_ENUM
				invoke CreateDialogParam, hInstance, IDD_ENUM, hWnd, addr EnumDialogProc, NULL

			.elseif eax==IDM_CALC
				invoke CreateDialogParam, hInstance, IDD_CALC, hWnd, addr CalcDialogProc, NULL

			.elseif eax==IDM_BRUTE
				invoke CreateDialogParam, hInstance, IDD_BRUTE, hWnd, addr BruteDialogProc, NULL

			.elseif eax==IDM_MODIFY
				invoke CreateDialogParam, hInstance, IDD_MODIFY, hWnd, addr ModifyDialogProc, NULL
			;--------------------------------------------------------------------------------------------------------------------------------------------------------------------


			;**********************************************************************
			; --> BEGIN PROCESSING MAIN DIALOG BUTTONS
			;**********************************************************************
			
			.elseif eax == IDC_MIN
				invoke ShowWindow, hWnd, SW_MINIMIZE

			.elseif eax == IDC_COPY
				invoke Copy, hWnd
				.if eax
					invoke EnableDlgItem, hWnd, IDC_COPY, FALSE
				.endif

			.elseif eax == IDC_SWAP
				invoke GetDlgItemText, hWnd, IDC_INPUT, addr sInput, SIZEOF sInput
				invoke GetDlgItemText, hWnd, IDC_OUTPUT, addr sOutput, SIZEOF sOutput
				invoke SetDlgItemText, hWnd, IDC_OUTPUT, addr sInput
				invoke SetDlgItemText, hWnd, IDC_INPUT, addr sOutput

			.elseif eax == IDC_CLEAR
				invoke wsprintfA, addr sTempBuf, addr strleng, 0, 0
				invoke SetDlgItemText, hWnd, IDS_LENGTH, addr sTempBuf
				invoke SetDlgItemText, hWnd, IDC_OUTPUT, NULL
				invoke SetDlgItemText, hWnd, IDC_INPUT, NULL
				invoke SetDlgItemText, hWnd, IDC_INFO, NULL
				invoke DisableBtns, hWnd
				invoke GetDlgItem, hWnd, IDC_INPUT
				invoke SetFocus, eax

			.elseif eax == IDC_EXIT || eax == IDC_CLOSE || eax == IDM_EXIT
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0

			.endif


			;**********************************************************************
			; --> PROCESS THE WM_CLOSE MESSAGE AND CLEAR UP DATA
			;**********************************************************************

		.elseif uMsg == WM_CLOSE
			invoke DestroyMenu, hMenuSettings
			invoke DestroyMenu, hMenuColScheme
			invoke DestroyMenu, hMenuTray
			invoke DestroyMenu, hMenuOptions
			invoke DestroyMenu, hMenuInOutOpts
			invoke DestroyMenu, hMenuEncOpts
			invoke DestroyMenu, hMenuEncMode
			invoke DestroyMenu, hMenuTools
			
			invoke DestroyIcon, hIcon
			invoke DeleteObject, hMnuColor
			invoke DeleteObject, hEditBgColor
			invoke DeleteObject, hBtnColor
			invoke DeleteObject, hEdgeHover
			invoke DeleteObject, hBtnNormColor
			invoke DeleteObject, hWndRgn
			invoke DeleteObject, hTitleFont
			invoke DeleteObject, hEdge
			invoke DeleteObject, hInbgColor
			invoke DeleteObject, hMiddleColor
			invoke DeleteObject, hBgColor
			
			invoke SendMessage, hMemo, WM_CLOSE, 0, 0
			call SaveMemoData
			
			invoke EndDialog, hWnd, 0

		.endif

		xor eax, eax
		ret
DialogProc endp


include about.asm

END start
