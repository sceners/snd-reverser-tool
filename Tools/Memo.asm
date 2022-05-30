


.const
IDC_MEMO_EDIT			equ 100
IDC_MEMO_X 				equ 101
IDC_GRAB_INPUT 			equ 102
IDC_GRAB_OUTPUT 		equ 103
IDC_GRAB_ALL			equ 104
IDC_MEMO_CLEAR 			equ 105
IDS_MEMO_TITLE			equ 401

IDM_GRAB				equ 810
IDM_GI					equ 811
IDM_GO					equ 812
IDM_GIO					equ 813
IDM_GKO					equ 814
IDM_GIKO				equ 815


.data?
MemoBuffer				CHAR 1024 dup(?)
hMenuGrab				HWND ?
mnuGrab					HWND ?
mnuMemoItem				MENUITEMINFO <?>
mnuMemo					MENUINFO <?>


.data
hMemo					HWND 0
newlineBytes			BYTE 0dh, 0ah, 0dh, 0ah, 0
memoTitle				db 'Memo Area', 0
memoFunctionString		db 'Function: ', 0
memoInputString			db 0dh, 0ah, 'Input: ', 0
memoKeyString			db 0dh, 0ah, 'Key: ', 0
memoOutputString		db 0dh, 0ah, 'Output: ', 0
bMemoInput				BOOL 0
bMemoKey				BOOL 0
bMemoOutput				BOOL 0


.code

;***************************************************************************************
; Basic Dialog Box Proc
;***************************************************************************************
MemoDialogProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local sBtnText[10h]:TCHAR ; for WM_DRAWITEM
	local i:dword

		.if uMsg == WM_INITDIALOG	
			mov eax,  hWnd
			mov hMemo, eax

			invoke SetWindowText, hWnd, addr memoTitle
			;invoke SetWindowPos, hWindow, HWND_TOP, 50, 50, 0, 0, SWP_NOSIZE
			;invoke SetWindowPos, hWnd, HWND_TOP, 595, 50, 0, 0, SWP_NOSIZE

			call MemoCreateMenuClass
			mov ebx, IDC_MEMO_X
			;subclass buttons
		@@:
			invoke GetDlgItem, hWnd, ebx
			push eax
			invoke SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, addr BtnProc
			mov	OldBtnProc, eax
			inc	ebx
			cmp	ebx, IDC_MEMO_CLEAR
			jle	@b

			invoke SetDlgItemText, hWnd, IDC_MEMO_EDIT, addr MemoBuffer


		.elseif uMsg == WM_CTLCOLORDLG
			mov eax, hBgColor
			ret


		.elseif uMsg == WM_MEASUREITEM
			.if wParam == 0
				mov edx, lParam
				mov (MEASUREITEMSTRUCT ptr [edx]).itemWidth, 130
				mov (MEASUREITEMSTRUCT ptr [edx]).itemHeight, 18
			.endif


		.elseif uMsg == WM_CTLCOLORSTATIC || uMsg == WM_CTLCOLOREDIT
			invoke GetDlgCtrlID, lParam
			.if eax == IDE_SCAN_EDIT 
				invoke SetTextColor, wParam, CR_INTEXT_SCHEME
				invoke SetBkColor, wParam, CR_EDITBG_SCHEME
				invoke SetBkMode, wParam, OPAQUE
				mov eax, hEditBgColor
			.else
				.if	eax == IDS_SCAN_TITLE
					invoke SelectObject, wParam, hTitleFont
				.endif
				invoke SetTextColor, wParam, CR_INTEXT_SCHEME
				invoke SetBkMode, wParam, TRANSPARENT
				invoke SetBkColor, wParam, CR_BG_SCHEME
				mov eax, hBgColor
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
				invoke GetDlgItemText, hWnd, [esi].CtlID, addr sBtnText, sizeof sBtnText
				invoke SetBkMode, [esi].hdc, TRANSPARENT
				invoke DrawText, [esi].hdc, addr sBtnText, -1, addr [esi].rcItem, DT_CENTER or DT_VCENTER or DT_SINGLELINE

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


		.elseif uMsg == WM_LBUTTONDOWN
			invoke SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0


		.elseif uMsg == WM_COMMAND
			mov eax, wParam ; item, control, or accelerator identifier
			mov edx, eax; notification code
			and eax, 0FFFFh
			shr edx, 16


			.if (eax == IDC_MEMO_EDIT && edx == EN_UPDATE)
				call SaveMemoData


			.elseif eax == IDC_GRAB_INPUT
				invoke GetDlgItem, hWnd, eax
				invoke GetWindowRect, eax, addr OptBtnRect
				invoke GetWindowRect, hWnd, addr DlgRect
				mov	eax, OptBtnRect.left
				mov	ebx, OptBtnRect.bottom
				invoke TrackPopupMenu, mnuGrab, TPM_LEFTALIGN, eax, ebx, 0, hWnd, addr DlgRect


			.elseif eax == IDM_GI || eax == IDM_GO || eax == IDM_GIO || eax == IDM_GKO || eax == IDM_GIKO
				mov bMemoInput, FALSE
				mov bMemoKey, FALSE
				mov bMemoOutput, FALSE

				.if eax == IDM_GI
					mov bMemoInput, TRUE
				.elseif eax == IDM_GO
					mov bMemoOutput, TRUE
				.elseif eax == IDM_GIO
					mov bMemoInput, TRUE
					mov bMemoOutput, TRUE
				.elseif eax == IDM_GKO
					mov bMemoKey, TRUE
					mov bMemoOutput, TRUE
				.elseif eax == IDM_GIKO
					mov bMemoInput, TRUE
					mov bMemoKey, TRUE
					mov bMemoOutput, TRUE
				.endif

				invoke RtlZeroMemory, offset MemoBuffer, sizeof MemoBuffer
				invoke RtlZeroMemory, offset sTempBuf, sizeof sTempBuf
				invoke GetDlgItemText, hWnd, IDC_MEMO_EDIT, addr MemoBuffer, sizeof MemoBuffer
				
				.if bMemoInput == TRUE
					invoke GetDlgItemText, hWindow, IDC_INPUT, addr sTempBuf, sizeof sTempBuf
					invoke lstrcat, addr MemoBuffer, addr memoInputString
					invoke lstrcat, addr MemoBuffer, addr sTempBuf
				.endif

				.if bMemoKey == TRUE
					invoke GetDlgItemText, hWindow, IDC_KEY, addr sTempBuf, sizeof sTempBuf
					invoke lstrcat, addr MemoBuffer, addr memoKeyString
					invoke lstrcat, addr MemoBuffer, addr sTempBuf
				.endif

				.if bMemoOutput == TRUE
					invoke GetDlgItemText, hWindow, IDC_OUTPUT, addr sTempBuf, sizeof sTempBuf
					invoke lstrcat, addr MemoBuffer, addr memoOutputString
					invoke lstrcat, addr MemoBuffer, addr sTempBuf
				.endif

				invoke SetDlgItemText, hWnd, IDC_MEMO_EDIT, addr MemoBuffer


			.elseif eax == IDC_MEMO_CLEAR
				invoke RtlZeroMemory, offset MemoBuffer, sizeof MemoBuffer
				invoke SetDlgItemText, hWnd, IDC_MEMO_EDIT, NULL


			.elseif eax == IDC_MEMO_X
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0
				
			.endif


		.elseif uMsg == WM_CLOSE
			mov hMemo, 00h
			invoke GetDlgItemText, hWnd, IDC_MEMO_EDIT, addr MemoBuffer, sizeof MemoBuffer
			call SaveMemoData
			invoke EndDialog, hWnd, 0

		.endif
	@End:
		xor eax, eax
		ret
MemoDialogProc endp


;##########################################################################################

MemoCreateMenuClass	Proc
		invoke LoadMenu, hInstance, IDM_GRAB
		mov	hMenuGrab, eax
		invoke GetSubMenu, eax, 0
		mov	mnuGrab, eax

		mov	mnuMemo.fMask, MIM_BACKGROUND or MIM_APPLYTOSUBMENUS
		mov	eax, hBgColor
		mov	mnuMemo.hbrBack, eax
		mov	mnuMemo.cbSize, sizeof mnuMemo
		invoke SetMenuInfo, mnuIDC, addr mnuMemo

		mov	mnuMemoItem.cbSize, sizeof mnuMemoItem
		mov mnuMemoItem.fMask, MIIM_DATA or MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE or MIIM_CHECKMARKS
		mov mnuMemoItem.fType, MFT_OWNERDRAW or MFT_STRING
		mov mnuMemoItem.fState, MFS_ENABLED
		mov mnuMemoItem.hSubMenu, 0

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the IDC menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuMemoItem.wID, IDM_GI
		mov mnuMemoItem.dwItemData, IDM_GI
		invoke SetMenuItemInfo, mnuGrab, IDM_GI, FALSE, addr mnuMemoItem

		mov mnuMemoItem.wID, IDM_GO
		mov mnuMemoItem.dwItemData, IDM_GO
		invoke SetMenuItemInfo, mnuGrab, IDM_GO, FALSE, addr mnuMemoItem

		mov mnuMemoItem.wID, IDM_GIO
		mov mnuMemoItem.dwItemData, IDM_GIO
		invoke SetMenuItemInfo, mnuGrab, IDM_GIO, FALSE, addr mnuMemoItem

		mov mnuMemoItem.wID, IDM_GKO
		mov mnuMemoItem.dwItemData, IDM_GKO
		invoke SetMenuItemInfo, mnuGrab, IDM_GKO, FALSE, addr mnuMemoItem

		mov mnuMemoItem.wID, IDM_GIKO
		mov mnuMemoItem.dwItemData, IDM_GIKO
		invoke SetMenuItemInfo, mnuGrab, IDM_GIKO, FALSE, addr mnuMemoItem

		invoke DrawMenuBar, hMemo
		ret
MemoCreateMenuClass	endp


