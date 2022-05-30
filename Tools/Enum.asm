
EnableAllWindows 	proto
ProcessMainWindows	proto hWnd:HWND, lParam:LPARAM
ProcessChildWindows	proto hWnd:HWND, lParam:LPARAM

.const
IDC_ENUM_X   		= 101
IDC_ENUM_ENABLE		= 102
IDC_ENUM_START 		= 103
IDC_ENUM_STOP  		= 104
IDS_ENUM_TITLE		= 401
TIMERID				equ WM_USER

.data?
tvis_enum			TV_INSERTSTRUCT <>
ht_enum				TV_HITTESTINFO <>

.data
LoopListViewHeader	db 	"While this loop is active, all disabled controls are enabled every 200ms",0
MainListViewHeader	db 	"The Following List Shows All Controls That Have Been Enabled:",0
hMainHeaderItem		dd	00000000h
EnumP				dd	50h dup(00)
EnumP_Format		db 	"PARENT  -  Handle : %08X  -  Text : ",22h,"%s",22h,0
EnumPh				dd	00000000h
EnumC				db	50h dup(00)
EnumC_Format		db	"CHILD  -  Handle : %08X  -  Text : ",22h,"%s",22h,0
EnumCh				dd	00000000h
hLastParentWritten	dd	00000000h
hCurrentParent		dd	00000000h
hLastParentTVM		dd	00000000h
textBuffer			db	20h dup(00)
LoopingFlag			dd	FALSE


.code

;***************************************************************************************
; Basic Dialog Box Proc
;***************************************************************************************
EnumDialogProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	LOCAL sBtnText[10h]:TCHAR ; for WM_DRAWITEM
	LOCAL i:DWORD


		.IF uMsg == WM_CTLCOLORDLG
		    mov eax, hBgColor
		    ret


		.ELSEIF uMsg == WM_CTLCOLORSTATIC || uMsg == WM_CTLCOLOREDIT
			;invoke SelectObject, wParam, hTitleFont
			invoke GetDlgCtrlID, lParam
			.IF	EAX == IDS_ENUM_TITLE
				invoke SelectObject, wParam, hTitleFont
			.ENDIF
			invoke SetTextColor, wParam, CR_INTEXT_SCHEME
			invoke SetBkMode, wParam, TRANSPARENT
			invoke SetBkColor, wParam, CR_BG_SCHEME
			mov eax, hBgColor
			ret


		.ELSEIF uMsg == WM_DRAWITEM
			push esi
			mov esi, lParam
			ASSUME esi:ptr DRAWITEMSTRUCT

			; change the control background color if pushed
			invoke SelectObject, [esi].hdc, hBtnNormColor
			invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME		
			invoke GetCursorPos,addr hitpoint
			invoke GetWindowRect,[esi].hwndItem,addr CloseBtnRct
			invoke PtInRect,addr CloseBtnRct,hitpoint.x,hitpoint.y

			.if eax	;hover		
				invoke SelectObject, [esi].hdc, hBtnColor
				invoke SetTextColor, [esi].hdc, CR_HOVERTEXT_SCHEME
				invoke SelectObject, [esi].hdc, hEdgeHover
			.else
				.IF [esi].itemState & ODS_DISABLED
					invoke SelectObject, [esi].hdc, hBtnColor
					invoke SetTextColor, [esi].hdc, CR_TEXT_SCHEME
				.ELSE
					invoke SelectObject, [esi].hdc, hBtnNormColor
					invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME
					invoke SelectObject, [esi].hdc, hEdge
				.ENDIF			
			.endif

			invoke FillRect, [esi].hdc, ADDR [esi].rcItem, hBtnColor
			invoke Rectangle, [esi].hdc, [esi].rcItem.left, [esi].rcItem.top, [esi].rcItem.right, [esi].rcItem.bottom

			; write the text
			invoke GetDlgItemText, hWnd, [esi].CtlID, ADDR sBtnText, SIZEOF sBtnText
			invoke SetBkMode, [esi].hdc, TRANSPARENT
			invoke DrawText, [esi].hdc, ADDR sBtnText, -1, ADDR [esi].rcItem, DT_CENTER or DT_VCENTER or DT_SINGLELINE

			.IF [esi].itemState & ODS_SELECTED
				invoke OffsetRect, ADDR [esi].rcItem, -1, -1
			.ENDIF

			; change the position of the text
			.IF [esi].itemState & ODS_FOCUS
				invoke InflateRect, ADDR [esi].rcItem, -4, -4
			.ENDIF

			ASSUME esi:NOTHING
			pop esi
  
  
		.ELSEIF uMsg == WM_LBUTTONDOWN
			invoke SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0


		.ELSEIF uMsg == WM_COMMAND
			mov eax, wParam ; item, control, or accelerator identifier
			mov edx, eax    ; notification code
			and eax, 0FFFFh
			shr edx, 16

			.IF eax == IDC_ENUM_ENABLE
				invoke EnableAllWindows

			.ELSEIF  eax == IDC_ENUM_START
				invoke SetTimer,hWnd,TIMERID,200,NULL
				mov LoopingFlag, TRUE

			.ELSEIF  eax == IDC_ENUM_STOP
				invoke KillTimer,hWnd,TIMERID
				mov LoopingFlag, FALSE

			.ELSEIF  eax == IDC_ENUM_X 
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0
				
			.ENDIF


		.ELSEIF uMsg == WM_INITDIALOG			
			MOV ebx,IDC_ENUM_X
			;subclass buttons
			@@:
			invoke GetDlgItem, hWnd, EBX
			push	eax
			invoke 	SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, ADDR BtnProc
			mov	OldBtnProc,eax
			inc	ebx
			cmp	ebx,IDC_ENUM_STOP 
			jle	@b
		   ; BackGround & Text  Color
		   	INVOKE GetDlgItem,hWnd,IDT_TREE
		   	mov	hWndTree,eax	   	
			INVOKE SendMessage, hWndTree, TVM_SETBKCOLOR, 0, CR_EDITBG_SCHEME
			INVOKE SendMessage, hWndTree, TVM_SETTEXTCOLOR, 0, CR_TEXT_SCHEME
			INVOKE SendMessage, hWndTree, TVM_DELETEITEM, 0, TVI_ROOT
           	mov tvis_enum.hParent, NULL   
         	mov tvis_enum.hInsertAfter, TVI_ROOT
          	mov tvis_enum.item.imask, TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE

		.ELSEIF uMsg == WM_TIMER
			invoke EnableAllWindows


		.ELSEIF uMsg == WM_CLOSE
			invoke EndDialog, hWnd, 0
		.ENDIF
@End:
	xor eax, eax
	ret
EnumDialogProc ENDP


;##########################################################################################

ParentTreeViewadd_enum proc P:DWORD,hP:DWORD
		mov eax, DWORD PTR DS:[hMainHeaderItem]
		mov tvis_enum.hParent, eax
		;mov tvis_enum.hParent, TVI_ROOT
		mov tvis_enum.hInsertAfter, TVI_LAST
		mov tvis_enum.item.imask, TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
		mov eax, P
		mov tvis_enum.item.pszText, eax
		mov tvis_enum.item.iImage, 0
		mov tvis_enum.item.iSelectedImage, 1
		invoke SendMessage, hWndTree, TVM_INSERTITEM, 0, addr tvis_enum
		mov hP, eax
		
		mov DWORD PTR DS:[hLastParentTVM], eax
		mov eax, DWORD PTR DS:[hCurrentParent]
		mov DWORD PTR DS:[hLastParentWritten], eax
		
		invoke UpdateWindow,hWndTree
		invoke InvalidateRect,hWndTree,NULL,TRUE
		ret
ParentTreeViewadd_enum endp

ChildTreeViewadd_enum proc Chi:DWORD,hChi:DWORD
		mov eax, DWORD PTR DS:[hLastParentTVM]
		mov tvis_enum.hParent, eax
		;mov tvis_enum.hParent, TVI_ROOT
		mov tvis_enum.hInsertAfter, TVI_LAST
		mov eax, Chi
		mov tvis_enum.item.pszText, eax
		INVOKE SendMessage, hWndTree, TVM_INSERTITEM, 0, addr tvis_enum
		mov hChi, eax
		invoke UpdateWindow,hWndTree
		invoke InvalidateRect,hWndTree,NULL,TRUE
		ret
ChildTreeViewadd_enum endp

;##########################################################################################


EnableAllWindows proc
		invoke SendMessage, hWndTree, TVM_DELETEITEM, 0, TVI_ROOT
		
		mov tvis_enum.hParent, NULL   
		mov tvis_enum.hInsertAfter, TVI_ROOT
		mov tvis_enum.item.imask, TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
		
		.IF LoopingFlag == TRUE
			mov eax, offset LoopListViewHeader
		.ELSE
			mov eax, offset MainListViewHeader
		.ENDIF
		mov tvis_enum.item.pszText, eax
		mov tvis_enum.item.iImage, 0
		mov tvis_enum.item.iSelectedImage, 1
		invoke SendMessage, hWndTree, TVM_INSERTITEM, 0, addr tvis_enum
		mov DWORD PTR DS:[hMainHeaderItem], eax
			
		invoke EnumWindows, offset ProcessMainWindows, NULL
		ret
EnableAllWindows endp


ProcessMainWindows proc hWnd:HWND, lParam:LPARAM
		invoke GetWindowText, hWnd, ADDR textBuffer, SIZEOF textBuffer
		invoke wsprintf, addr EnumP, addr EnumP_Format, hWnd, addr textBuffer
		mov eax, hWnd
		mov DWORD PTR DS:[hCurrentParent], eax
		invoke EnumChildWindows, hWnd, offset ProcessChildWindows, NULL
		mov	eax,TRUE
		ret
ProcessMainWindows endp


ProcessChildWindows proc hWnd:HWND, lParam:LPARAM
		invoke	IsWindowEnabled, hWnd
		cmp	eax,TRUE
		je	@getNext
		invoke EnableWindow,hWnd,TRUE
		invoke GetWindowText, hWnd, ADDR textBuffer, SIZEOF textBuffer
		invoke wsprintf, addr EnumC, addr EnumC_Format, hWnd, addr textBuffer

		mov eax, DWORD PTR DS:[hLastParentWritten]
		cmp eax, DWORD PTR DS:[hCurrentParent]
		je @parentAlreadyCreated
		invoke ParentTreeViewadd_enum, addr EnumP, EnumPh
	@parentAlreadyCreated:
		invoke ChildTreeViewadd_enum, addr EnumC, EnumCh
		invoke UpdateWindow, hWnd

	@getNext:
		mov	eax,TRUE
		ret
ProcessChildWindows endp
