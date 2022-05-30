

.data
fMouseDown 	 	BOOL 0
fButtonDown	 	BOOL 0
fButtonHover 	BOOL 0


.code

CreateMenuClass	Proc

		invoke LoadMenu, hInstance, IDM_TOOLS
		mov	hMenuTools, eax
		invoke GetSubMenu, eax, 0
		mov	mnuTools, eax

		invoke LoadMenu, hInstance, IDM_SETTINGS
		mov hMenuSettings, eax
		invoke GetSubMenu, eax, 0
		mov	mnuSettings, eax

		invoke LoadMenu, hInstance, IDM_COLSCHEME
		mov hMenuColScheme, eax
		invoke GetSubMenu, eax, 0	
		mov mnuColScheme, eax

		invoke LoadMenu, hInstance, IDM_OPTIONS
		mov	hMenuOptions, eax
		invoke GetSubMenu, eax, 0
		mov	mnuOptions, eax

		invoke LoadMenu, hInstance, IDM_INOUTOPTS
		mov	hMenuInOutOpts, eax
		invoke GetSubMenu, eax, 0
		mov	mnuInOutOpts, eax

		invoke LoadMenu, hInstance, IDM_AUTOSTRIP
		mov	hMenuAutoStrip, eax
		invoke GetSubMenu, eax, 0
		mov	mnuAutoStrip, eax

		invoke LoadMenu, hInstance, IDM_ENCOPTS
		mov	hMenuEncOpts, eax
		invoke GetSubMenu, eax, 0
		mov	mnuEncOpts, eax

		invoke LoadMenu, hInstance, IDM_ENCMODE
		mov	hMenuEncMode, eax
		invoke GetSubMenu, eax, 0
		mov	mnuEncMode, eax

		invoke LoadMenu, hInstance, IDM_TRAY
		mov hMenuTray, eax
		invoke GetSubMenu, eax, 0
		mov mnuTray, eax



		mov	mnuMain.fMask, MIM_BACKGROUND or MIM_APPLYTOSUBMENUS
		mov	eax, hBgColor
		mov	mnuMain.hbrBack, eax
		mov	mnuMain.cbSize, SIZEOF mnuMain

		invoke SetMenuInfo, mnuTools, addr mnuMain
		invoke SetMenuInfo, mnuSettings, addr mnuMain
		invoke SetMenuInfo, mnuColScheme, addr mnuMain
		invoke SetMenuInfo, mnuOptions, addr mnuMain
		invoke SetMenuInfo, mnuInOutOpts, addr mnuMain
		invoke SetMenuInfo, mnuAutoStrip, addr mnuMain
		invoke SetMenuInfo, mnuEncOpts, addr mnuMain
		invoke SetMenuInfo, mnuEncMode, addr mnuMain



		mov	mnuItem.cbSize, SIZEOF mnuItem
		mov mnuItem.fMask, MIIM_DATA or MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE or MIIM_CHECKMARKS
		mov mnuItem.fType, MFT_OWNERDRAW or MFT_STRING
		mov mnuItem.fState, MFS_ENABLED
		mov mnuItem.hSubMenu, 0

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Tools menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuItem.wID, IDM_MEMO
		mov mnuItem.dwItemData, IDM_MEMO
		invoke SetMenuItemInfo, mnuTools, IDM_MEMO, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_SCAN
		mov mnuItem.dwItemData, IDM_SCAN
		invoke SetMenuItemInfo, mnuTools, IDM_SCAN, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_ENUM
		mov mnuItem.dwItemData, IDM_ENUM
		invoke SetMenuItemInfo, mnuTools, IDM_ENUM, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_CALC
		mov mnuItem.dwItemData, IDM_CALC
		invoke SetMenuItemInfo, mnuTools, IDM_CALC, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_BRUTE
		mov mnuItem.dwItemData, IDM_BRUTE
		invoke SetMenuItemInfo, mnuTools, IDM_BRUTE, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_MODIFY
		mov mnuItem.dwItemData, IDM_MODIFY
		invoke SetMenuItemInfo, mnuTools, IDM_MODIFY, FALSE, addr mnuItem

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Settings menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuItem.wID, IDM_ONTOP
		mov mnuItem.dwItemData, IDM_ONTOP
		invoke SetMenuItemInfo, mnuSettings, IDM_ONTOP, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_TRANS
		mov mnuItem.dwItemData, IDM_TRANS
		invoke SetMenuItemInfo, mnuSettings, IDM_TRANS, FALSE, addr mnuItem
		
		mov mnuItem.wID, IDM_TRAYM
		mov mnuItem.dwItemData, IDM_TRAYM
		invoke SetMenuItemInfo, mnuSettings, IDM_TRAYM, FALSE, addr mnuItem

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the key menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuItem.wID, IDM_QUICKTITLE
		mov mnuItem.dwItemData, IDM_QUICKTITLE
		invoke SetMenuItemInfo, mnuOptions, IDM_QUICKTITLE, FALSE, addr mnuItem

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Input Output sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuItem.wID, IDM_RIAH
		mov mnuItem.dwItemData, IDM_RIAH
		invoke SetMenuItemInfo, mnuOptions, IDM_RIAH, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_RKAH
		mov mnuItem.dwItemData, IDM_RKAH
		invoke SetMenuItemInfo, mnuOptions, IDM_RKAH, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_DOAH
		mov mnuItem.dwItemData, IDM_DOAH
		invoke SetMenuItemInfo, mnuOptions, IDM_DOAH, FALSE, addr mnuItem

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Auto Strip sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuItem.wID, IDM_SSPACES
		mov mnuItem.dwItemData, IDM_SSPACES
		invoke SetMenuItemInfo, mnuOptions, IDM_SSPACES, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_SNONHEX
		mov mnuItem.dwItemData, IDM_SNONHEX
		invoke SetMenuItemInfo, mnuOptions, IDM_SNONHEX, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_SNONALPHA
		mov mnuItem.dwItemData, IDM_SNONALPHA
		invoke SetMenuItemInfo, mnuOptions, IDM_SNONALPHA, FALSE, addr mnuItem

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Input Output sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuItem.wID, IDM_BSI
		mov mnuItem.dwItemData, IDM_BSI
		invoke SetMenuItemInfo, mnuOptions, IDM_BSI, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_BSK
		mov mnuItem.dwItemData, IDM_BSK
		invoke SetMenuItemInfo, mnuOptions, IDM_BSK, FALSE, addr mnuItem

		mov mnuItem.wID, IDM_PI
		mov mnuItem.dwItemData, IDM_PI
		invoke SetMenuItemInfo, mnuOptions, IDM_PI, FALSE, addr mnuItem


		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Colour schemes sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		push mnuColScheme
		pop mnuItem.hSubMenu
		mov mnuItem.wID, IDM_COLSCHEME
		mov mnuItem.dwItemData, IDM_COLSCHEME
		invoke InsertMenuItem, mnuSettings, 3, TRUE, addr mnuItem
		mov mnuItem.fType, MFT_OWNERDRAW or MFT_STRING or MFT_RADIOCHECK

		mov	ebx, IDM_SCHEME1
	@@:
		push ebx
		mov	mnuItem.hSubMenu, 0
		mov mnuItem.wID, ebx
		mov mnuItem.dwItemData, ebx
		mov mnuItem.dwTypeData, 0
		invoke SetMenuItemInfo, mnuColScheme, ebx, FALSE, addr mnuItem
		pop	ebx
		inc	ebx
		cmp	ebx, IDM_SCHEME5
		jle	@b


		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Auto Strip sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		push mnuAutoStrip
		pop mnuItem.hSubMenu
		mov mnuItem.wID, IDM_AUTOSTRIP
		mov mnuItem.dwItemData, IDM_AUTOSTRIP
		invoke InsertMenuItem, mnuOptions, 1, TRUE, addr mnuItem
		mov mnuItem.fType, MFT_OWNERDRAW or MFT_STRING or MFT_RADIOCHECK

		mov	ebx, IDM_SNOTHING
	@@:
		push ebx
		mov	mnuItem.hSubMenu, 0
		mov mnuItem.wID, ebx
		mov mnuItem.dwItemData, ebx
		mov mnuItem.dwTypeData, 0
		invoke SetMenuItemInfo, mnuAutoStrip, ebx, FALSE, addr mnuItem
		pop	ebx
		inc	ebx
		cmp	ebx, IDM_SNONALPHA
		jle	@b


		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Input Output Options sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		push mnuInOutOpts
		pop mnuItem.hSubMenu
		mov mnuItem.wID, IDM_INOUTOPTS
		mov mnuItem.dwItemData, IDM_INOUTOPTS
		invoke InsertMenuItem, mnuOptions, 2, TRUE, addr mnuItem
		mov mnuItem.fType, MFT_OWNERDRAW or MFT_STRING or MFT_RADIOCHECK

		mov	ebx, IDM_RIAH
	@@:
		push ebx
		mov	mnuItem.hSubMenu, 0
		mov mnuItem.wID, ebx
		mov mnuItem.dwItemData, ebx
		mov mnuItem.dwTypeData, 0
		invoke SetMenuItemInfo, mnuInOutOpts, ebx, FALSE, addr mnuItem
		pop	ebx
		inc	ebx
		cmp	ebx, IDM_DOIF
		jle	@b


		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Encryption Options sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		push mnuEncOpts
		pop mnuItem.hSubMenu
		mov mnuItem.wID, IDM_ENCOPTS
		mov mnuItem.dwItemData, IDM_ENCOPTS
		invoke InsertMenuItem, mnuOptions, 3, TRUE, addr mnuItem
		mov mnuItem.fType, MFT_OWNERDRAW or MFT_STRING or MFT_RADIOCHECK

		mov	ebx, IDM_BSI
	@@:
		push ebx
		mov	mnuItem.hSubMenu, 0
		mov mnuItem.wID, ebx
		mov mnuItem.dwItemData, ebx
		mov mnuItem.dwTypeData, 0
		invoke SetMenuItemInfo, mnuEncOpts, ebx, FALSE, addr mnuItem
		pop	ebx
		inc	ebx
		cmp	ebx, IDM_PI
		jle	@b

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the Encryption Mode sub menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		push mnuEncMode
		pop mnuItem.hSubMenu
		mov mnuItem.wID, IDM_ENCMODE
		mov mnuItem.dwItemData, IDM_ENCMODE
		invoke InsertMenuItem, mnuOptions, 4, TRUE, addr mnuItem
		mov mnuItem.fType, MFT_OWNERDRAW or MFT_STRING or MFT_RADIOCHECK

		mov	ebx, IDM_EBC
	@@:
		push ebx
		mov	mnuItem.hSubMenu, 0
		mov mnuItem.wID, ebx
		mov mnuItem.dwItemData, ebx
		mov mnuItem.dwTypeData, 0
		invoke SetMenuItemInfo, mnuEncMode, ebx, FALSE, addr mnuItem
		pop	ebx
		inc	ebx
		cmp	ebx, IDM_CBC
		jle	@b

		invoke CheckMenuItem, mnuEncMode, IDM_EBC, MF_CHECKED
		invoke DrawMenuBar, hWindow

		ret
CreateMenuClass	endp



EnableBtns proc _hWnd:HWND
		invoke EnableDlgItem, _hWnd, IDC_COPY, TRUE
		invoke EnableDlgItem, _hWnd, IDC_CLEAR, TRUE
		invoke EnableDlgItem, _hWnd, IDC_SWAP, TRUE
		ret
EnableBtns endp


DisableBtns	proc _hWnd:HWND
		invoke EnableDlgItem, _hWnd, IDC_COPY, FALSE
	 	invoke EnableDlgItem, _hWnd, IDC_CLEAR, FALSE
	 	invoke EnableDlgItem, _hWnd, IDC_SWAP, FALSE
	 	ret
DisableBtns	endp


EnableKeyEdit proc
		invoke EnableDlgItem, hWindow, IDC_KEY, TRUE
		ret
EnableKeyEdit endp


DisableKeyEdit proc
		;pushad
		invoke EnableDlgItem, hWindow, IDC_KEY, FALSE
		;invoke SetDlgItemText, hWindow, IDC_KEY, NULL
		;popad
		ret
DisableKeyEdit endp





EditProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

		.if uMsg == WM_GETDLGCODE
			mov eax, DLGC_WANTALLKEYS or DLGC_HASSETSEL
			ret

		.elseif uMsg == WM_CHAR
			mov eax, wParam
			.if eax == VK_TAB ;|| eax == VK_RETURN
				xor eax, eax
				ret
			.endif

		.elseif uMsg == WM_KEYDOWN
			mov eax, wParam
			.if eax == VK_TAB
				invoke GetParent, hWnd
				invoke PostMessage, eax, WM_NEXTDLGCTL, 0, 0
				xor eax, eax
				ret
			.endif
			invoke InvalidateRect, hWnd, NULL, FALSE
		.endif

		invoke CallWindowProc, OldEditProc, hWnd, uMsg, wParam, lParam
		ret
EditProc endp



BtnProc	proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local rect:RECT
	local pt:POINT
	local ps:PAINTSTRUCT
	local tmpFont:LOGFONT
		
		.if uMsg ==WM_NCHITTEST
			mov eax, 1 ;We want to handle the non client hit test so we return true or 1
			ret

		.elseif uMsg == WM_LBUTTONDOWN
			mov hover, FALSE

		.elseif uMsg == WM_MOUSEMOVE		
			invoke GetParent, hWnd
			push ebx
			mov ebx, eax
			invoke GetActiveWindow
			.if eax == ebx
				invoke GetCursorPos, addr pt
				invoke GetWindowRect, hWnd, addr rect
				invoke PtInRect, addr rect, pt.x, pt.y
				.if eax
					invoke GetCapture
					.if !eax
						invoke SetCapture, hWnd
						invoke SetCursor, hCur				
						invoke InvalidateRect, hWnd, FALSE, FALSE					
					.endif
				.else
					invoke GetCapture
					.if eax
						invoke ReleaseCapture
						invoke InvalidateRect, hWnd, FALSE, FALSE					
					.endif
				.endif
			.endif

		.elseif uMsg == WM_MOUSELEAVE
			mov hover, FALSE
		.endif

		invoke CallWindowProc, OldBtnProc, hWnd, uMsg, wParam, lParam
		ret
BtnProc	Endp




ComboProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local rect:RECT
	local rect2:RECT
	local pt:POINT
	local ps:PAINTSTRUCT
	local hdc:HDC

		.if uMsg == WM_PAINT
			invoke SendMessage, hWnd, CB_GETCURSEL, 0, 0
			push eax
			invoke BeginPaint, hWnd, addr ps
			mov	hdc, eax

			invoke GetClientRect, hWnd, addr rect
			invoke InflateRect, addr rect, -1, -1
			invoke GetSystemMetrics, SM_CXVSCROLL
			sub	rect.right, eax
			invoke IntersectClipRect, hdc, rect.left, rect.top, rect.right, rect.bottom

			invoke CallWindowProc, OldComboProc, hWnd, WM_PAINT, wParam, lParam
			invoke SelectClipRgn, hdc, NULL
			invoke GetSystemMetrics, SM_CXVSCROLL
			add	rect.right, eax
			invoke ExcludeClipRect, hdc, rect.left, rect.top, rect.right, rect.bottom

			invoke GetClientRect, hWnd, addr rect2
			invoke GetSysColorBrush, COLOR_3DSHADOW
			invoke FillRect, hdc, addr rect2, eax

			;// now draw the button
			invoke SelectClipRgn, hdc, NULL
			invoke GetSystemMetrics, SM_CXVSCROLL
			mov	edx, rect.right
			sub	edx, eax
			mov	rect.left, edx

			.if fButtonDown == TRUE
				invoke DrawFrameControl, hdc, addr rect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or DFCS_FLAT or DFCS_PUSHED			
			.else
				invoke DrawFrameControl, hdc, addr rect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or DFCS_FLAT		
			.endif
			pop	eax
			invoke SendMessage, hWnd, CB_SETCURSEL, eax, 0
			invoke EndPaint, hWnd, addr ps

		.elseif uMsg == WM_LBUTTONUP
			.if fMouseDown
				mov fMouseDown, FALSE
				mov fButtonDown, FALSE
				invoke InvalidateRect, hWnd, FALSE, FALSE
			.endif

		.elseif uMsg == WM_LBUTTONDOWN || uMsg == WM_LBUTTONDBLCLK
			mov	eax, lParam
			movsx ebx, ax
			mov	pt.x, ebx
			shr	eax, 16
			mov	pt.y, eax
			invoke GetClientRect, hWnd, addr rect
			invoke InflateRect, addr rect, -1, -1
			invoke GetSystemMetrics, SM_CXVSCROLL
			mov	edx, rect.right
			sub	edx, eax
			mov	rect.left, edx
			invoke PtInRect, addr rect, pt.x, pt.y
			.if eax
				mov fMouseDown, TRUE
				mov fButtonDown, TRUE
				invoke InvalidateRect, hWnd, FALSE, FALSE
			.endif

		.elseif uMsg == WM_MOUSEMOVE 
			mov	eax, lParam
			movsx ebx, ax
			mov	pt.x, ebx
			shr	eax, 16
			mov	pt.y, eax
			invoke GetClientRect, hWnd, addr rect
			invoke InflateRect, addr rect, -1, -1
			invoke SetCursor, hCur
			invoke PtInRect, addr rect, pt.x, pt.y
			.if fButtonHover != eax
				mov fButtonHover, eax
				invoke InvalidateRect, hWnd, 0, 1
				;invoke SetTimer, hWnd, 1, 10, NULL
			.endif			
		.endif

		invoke CallWindowProc, OldComboProc, hWnd, uMsg, wParam, lParam
		ret
ComboProc endp



EnableDlgItem proc hWnd:HWND, nDlgItem:dword, bEnable:BOOL
		invoke GetDlgItem, hWnd, nDlgItem
		invoke EnableWindow, eax, bEnable
		ret
EnableDlgItem endp


;***************************************************************************************
; Used for ToolTips
;***************************************************************************************

EnumChild proc uses edi hChild:dword, lParam:dword
	local buffer[256]:BYTE
	local hId:dword

		mov edi, lParam 		
		assume edi:ptr TOOLINFO 		
		or [edi].uFlags, TTF_IDISHWND 		
		push hChild 		
		pop [edi].uId
		invoke GetDlgCtrlID, hChild
		mov hId, eax
		invoke LoadString, hInstance, hId, addr buffer, 255
		lea eax, buffer
		mov [edi].lpszText, eax
		invoke SendMessage, hToolTip, TTM_ADDTOOL, NULL, edi 
		;invoke SendMessage, hToolTip, TTM_SETDELAYTIME, TTDT_AUTOMATIC, -1
		assume edi:nothing
		ret
EnumChild endp


ColorShift	proc uses ebx ecx edx inColor:dword, offs:dword
	local red:dword
	local blue:dword
	local green:dword
	local delta:dword

		mov	eax, inColor
		shr	eax, 16
		and	eax, 255
		add	eax, offs
		mov	blue, eax

		mov	eax, inColor
		shr	eax, 8
		and	eax, 255
		add	eax, offs
		mov	green, eax

		mov	eax, inColor
		and	eax, 255
		add	eax, offs
		mov	red, eax

		.if	red > 255
			mov	red, 255
		.elseif red < 0
			mov	red, 0
		.endif

		.if	green > 255
			mov	green, 255
		.elseif green < 0
			mov	green, 0
		.endif

		.if	blue > 255
			mov	blue, 255
		.elseif blue < 0
			mov	blue, 0
		.endif		

		mov	eax, blue
		shl	eax, 16
		mov	edx, green
		mov	ah, dl
		mov	edx, red
		mov	al, dl
		ret
ColorShift	endp
