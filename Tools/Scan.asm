
include SNDCryptoScanner\Includes\Engine.inc
include SNDCryptoScanner\Sigs\CryptoSigs.inc
include SNDCryptoScanner\Sigs\HashSigs.inc
include SNDCryptoScanner\Sigs\LibSigs.inc
include SNDCryptoScanner\Sigs\MiscSigs.inc
include SNDCryptoScanner\Includes\Engine.asm


.const
IDC_SCAN_CHOOSE			equ 100
IDC_SCAN_X 				equ 101
IDC_SCAN_TXT 			equ 102
IDC_SCAN_IDC			equ 103
IDE_SCAN_EDIT 			equ 200
IDT_TREE				equ 300
IDS_STATUS				equ 400
IDS_SCAN_TITLE			equ 401

IDP_PROGRESS			equ 500
POSMAX					equ	200
EACHSIGVALUE			equ	POSMAX/numberOfSignatures

IDM_EXPORTIDC			equ 800
IDM_BONLY				equ 801
IDM_CONLY				equ 802
IDM_BANDC				equ 803


.data?
hWndTree				HWND ?
hScan					HWND ?
tvis 					TV_INSERTSTRUCT <>
tvi 					TVITEM <>
ht 						TV_HITTESTINFO <>
hDrop					dd ?
pos						dd ?
progresshdlg			HWND ?
hMenuIDC				HWND ?
mnuIDC					HWND ?
mnuScanItem				MENUITEMINFO <?>
mnuScan					MENUINFO <?>


.data
YepFound				dd 10h dup(00)
Lape					dd 5h dup(00)
Lapefrmt				db "%lu.%04u", 0
o_						db "Scan has found %lu possible crypto/hash signatures!", 0

Crypto		 			OPENFILENAME <>
CryptoFilterString 		db "Executable (.exe)", 0, "*.exe", 0
						db "Dll Library (.dll)", 0, "*.dll", 0
						db "*.sys, *.ocx, *.ax, *.scr", 0, "*.sys;*.ocx;*.ax;*.scr", 0
						db "All Files", 0, "*.*", 0 , 0
CryptoCaption 			db "Choose your PE file", 0
offsetFormat			db 'Signature %s found at offset %.8X (VA: %.8X)', 0

ExportFile	 			OPENFILENAME <>
ExportTXTFilterString 	db "Text Files", 0, "*.txt", 0 , 0
ExportIDCFilterString 	db "IDC Files", 0, "*.idc", 0 , 0
ExportCaption 			db "Choose your Export file", 0
ExportFileDefault		db "CryptoExport", 0
ExportIDCDefaultExt		db "idc", 0
ExportTXTDefaultExt		db "txt", 0
ExportFileName			db 250 dup (0)
ExportFilePath 			db 250 dup (0)
hExportFile 			dd 00h
newLine					db 0dh, 0ah
exportTXTFormat			db '|- Signature %s found at offset %.8X (VA: %.8X)', 0
exportCommentFormat		db 09h, 09h, 'MakeComm(PrevNotTail(0x%.8X), "%s (%s)");', 0dh, 0ah, 0
exportBookmarkFormat	db 09h, 09h, 'MarkPosition(0x%.8X, 0, 0, 0, slotidx + %d, "%s");',  0dh, 0ah, 0
exportIDCHeader			db '#include <idc.idc>', 0dh, 0ah, 0dh, 0ah, 'static main(void)', 0dh, 0ah, '{', 0dh, 0ah, 0
exportBookmarkVars		db 09h, 09h, 'auto slotidx;', 0dh, 0ah, 09h, 09h, 'slotidx = 1;', 0dh, 0ah, 0dh, 0ah, 0
exportIDCFooter			db 0dh, 0ah, 7dh, 0dh, 0ah, 0
slotIDX		 			dd 01h
bBookmark				BOOL 0
bComment				BOOL 0

field1Data	 			db 256 dup (0)
field2Data	 			db 20 dup (0)
field3Data	 			db 20 dup (0)
ParentHandle 			db 20 dup (0)
dBackVirtualAddress		db 04 dup (0)
dBackSizeOfRawData		db 04 dup (0)
tempbuffer				db 250 dup (0)

singleSig				dd 0
sigCounter				dd 0
hThreadSearch			dd 0
tempdword	 			dd 20 dup (0)


.code

;***************************************************************************************
; Basic Dialog Box Proc
;***************************************************************************************
ScanDialogProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local sBtnText[10h]:TCHAR ; for WM_DRAWITEM
	local i:dword

		.if uMsg == WM_INITDIALOG
			mov eax, hWnd
			mov hScan, eax

			call ScanCreateMenuClass
			;subclass buttons
			mov ebx, IDC_SCAN_CHOOSE
		@@:
			invoke GetDlgItem, hWnd, EBX
			push eax
			invoke  SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, addr BtnProc
			mov	OldBtnProc, eax
			inc	ebx
			cmp	ebx, IDC_SCAN_IDC 
			jle	@b

			; BackGround & Text Color
		 	invoke GetDlgItem, hWnd, IDT_TREE
		 	mov	hWndTree, eax
			invoke SendMessage, hWndTree, TVM_SETBKCOLOR, 0, CR_EDITBG_SCHEME
			invoke SendMessage, hWndTree, TVM_SETTEXTCOLOR, 0, CR_TEXT_SCHEME
			invoke SendMessage, hWndTree, TVM_DELETEITEM, 0, TVI_ROOT
			mov tvis.hParent, NULL 
			mov tvis.hInsertAfter, TVI_ROOT
			mov tvis.item.imask, TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
			;invoke SendMessage, hWndTree, WM_SETFONT, hFontL, 1

			; Open File Dialog
			mov	eax, hWnd
			mov	Crypto.hwndOwner, eax
			mov Crypto.lStructSize, sizeof Crypto
			mov Crypto.lpstrFile, offset CryptoFilePath 
			mov Crypto.lpstrFilter, offset CryptoFilterString
			mov Crypto.nMaxFile, MAXSIZE 
			mov Crypto.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY 
			mov Crypto.lpstrTitle, offset CryptoCaption

			; Export File Dialog
			invoke lstrcat, addr ExportFilePath, addr ExportFileDefault
			mov	eax, hWnd
			mov	ExportFile.hwndOwner, eax
			mov ExportFile.lStructSize, sizeof ExportFile
			mov ExportFile.lpstrFile, offset ExportFilePath 
			mov ExportFile.nMaxFile, MAXSIZE 
			mov ExportFile.Flags, OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY 
			mov ExportFile.lpstrTitle, offset ExportCaption

			; DRAG Files
			invoke DragAcceptFiles, hWnd, TRUE

			;Progressbar stuff
			invoke GetDlgItem, hWnd, IDP_PROGRESS
			mov	progresshdlg, eax
			invoke SendMessage, progresshdlg, PBM_SETBKCOLOR, 0, CR_BG_SCHEME
			invoke SendMessage, progresshdlg, PBM_SETBARCOLOR, 0, CR_NORMTEXT_SCHEME
			;invoke ShowWindow, progresshdlg, SW_HIDE


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
			mov edx, eax ; notification code
			and eax, 0FFFFh
			shr edx, 16

			.if eax == IDC_SCAN_CHOOSE
				invoke 	GetOpenFileName, addr Crypto
				.if eax
			@BeginOpen:
					invoke lstrcpy, addr ScanFileName, addr CryptoFilePath
					invoke SetDlgItemText, hWnd, IDE_SCAN_EDIT, addr CryptoFilePath
					call ReadFileToMemory
					.if eax == 0
						invoke SetDlgItemText, hWnd, IDS_STATUS, SADD("Error opening file. Maybe in use.")
						jmp	@End
					.else
						invoke SetDlgItemText, hWnd, IDS_STATUS, NULL
						call CheckValidPEFile
						.if eax == 01h
							invoke SendMessage, hWndTree, TVM_DELETEITEM, 0, TVI_ROOT		; Delete ALL Item
							push hWnd
							call CryptoSearchThread
							invoke GlobalFree, CryptoFile
							invoke CloseHandle, CryptoFile
						.else
							invoke SetDlgItemText, hWnd, IDS_STATUS, SADD("Not a valid PE file, PE signature not found.")
							invoke GlobalFree, CryptoFile
							invoke CloseHandle, CryptoFile
							jmp	@End
						.endif
					.endif
				.else
					invoke SetDlgItemText, hWnd, IDE_SCAN_EDIT, NULL
				.endif

		 	.elseif eax == IDC_SCAN_X
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0


		 	.elseif eax == IDC_SCAN_TXT
				call exportTextFile


		 	.elseif eax == IDC_SCAN_IDC
				invoke GetDlgItem, hWnd, eax
				invoke GetWindowRect, eax, addr OptBtnRect
				invoke GetWindowRect, hWnd, addr DlgRect
				mov	eax, OptBtnRect.left
				mov	ebx, OptBtnRect.bottom
				invoke TrackPopupMenu, mnuIDC, TPM_LEFTALIGN, eax, ebx, 0, hWnd, addr DlgRect


			.elseif eax == IDM_BONLY || eax == IDM_CONLY || eax == IDM_BANDC
				mov bBookmark, FALSE
				mov bComment, FALSE
				.if eax == IDM_BONLY
					mov bBookmark, TRUE
				.elseif eax == IDM_CONLY
					mov bComment, TRUE
				.elseif eax == IDM_BANDC
					mov bBookmark, TRUE
					mov bComment, TRUE
				.endif
				call exportIDCFile

		 	.endif


		.elseif uMsg == WM_DROPFILES
			push wParam
			pop	hDrop
			invoke DragQueryFile, hDrop, 0, offset CryptoFilePath, sizeof CryptoFilePath
			invoke DragFinish, hDrop
			jmp	@BeginOpen


		.elseif uMsg == WM_CLOSE
			invoke EndDialog, hWnd, 0
		.endif

	@End:
		xor eax, eax
		ret
ScanDialogProc endp


ScanCreateMenuClass	Proc
		invoke LoadMenu, hInstance, IDM_EXPORTIDC
		mov	hMenuIDC, eax
		invoke GetSubMenu, eax, 0
		mov	mnuIDC, eax

		mov	mnuScan.fMask, MIM_BACKGROUND or MIM_APPLYTOSUBMENUS
		mov	eax, hBgColor
		mov	mnuScan.hbrBack, eax
		mov	mnuScan.cbSize, sizeof mnuScan
		invoke SetMenuInfo, mnuIDC, addr mnuScan

		mov	mnuScanItem.cbSize, sizeof mnuScanItem
		mov mnuScanItem.fMask, MIIM_DATA or MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE or MIIM_CHECKMARKS
		mov mnuScanItem.fType, MFT_OWNERDRAW or MFT_STRING
		mov mnuScanItem.fState, MFS_ENABLED
		mov mnuScanItem.hSubMenu, 0

		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		;Process the IDC menu
		;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		mov mnuScanItem.wID, IDM_BONLY
		mov mnuScanItem.dwItemData, IDM_BONLY
		invoke SetMenuItemInfo, mnuIDC, IDM_BONLY, FALSE, addr mnuScanItem

		mov mnuScanItem.wID, IDM_CONLY
		mov mnuScanItem.dwItemData, IDM_CONLY
		invoke SetMenuItemInfo, mnuIDC, IDM_CONLY, FALSE, addr mnuScanItem

		mov mnuScanItem.wID, IDM_BANDC
		mov mnuScanItem.dwItemData, IDM_BANDC
		invoke SetMenuItemInfo, mnuIDC, IDM_BANDC, FALSE, addr mnuScanItem

		invoke DrawMenuBar, hScan
		ret
ScanCreateMenuClass	endp

;##########################################################################################


CryptoSearchThread proc ChildCryptoSearchhWnd:dword
		local	Exitth:dword
		mov hScanStop, 0
		pushad
		mov	pos, 0
		mov	eax, offset CryptoSearchEngineSimple
		mov	ebx, ChildCryptoSearchhWnd
		invoke CreateThread, NULL, NULL, eax, ebx, NORMAL_PRIORITY_CLASS, offset hThreadSearch
		popad
		ret
CryptoSearchThread endp


;##########################################################################################

ParentTreeViewAdd proc _SigName:dword
		mov tvis.hParent, NULL 
		mov tvis.hInsertAfter, TVI_ROOT
		mov tvis.item.imask, TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
		mov	eax, _SigName
		mov tvis.item.pszText, eax
		mov tvis.item.iImage, 0
		mov tvis.item.iSelectedImage, 1
		invoke SendMessage, hWndTree, TVM_INSERTITEM, 0, addr tvis
		mov dword ptr [ParentHandle], eax
		invoke InvalidateRect, hWndTree, NULL, TRUE
		ret
ParentTreeViewAdd endp


ChildTreeViewAdd proc _TextToPrint:dword, _Parent:dword
		mov eax, _Parent
		mov tvis.hParent, eax
		mov tvis.hInsertAfter, TVI_LAST
		mov	eax, _TextToPrint
		mov tvis.item.pszText, eax
		invoke SendMessage, hWndTree, TVM_INSERTITEM, 0, addr tvis
		invoke InvalidateRect, hWndTree, NULL, TRUE
		ret
ChildTreeViewAdd endp


;##########################################################################################


OffsetToVA proc uses edi esi edx ecx ebx
		mov esi, CryptoMem
		assume esi:ptr IMAGE_DOS_HEADER
		add esi, [esi].e_lfanew
		assume esi:ptr IMAGE_NT_HEADERS
		mov edi, ebx 									; edi == VA
		mov edx, esi
		add edx, sizeof IMAGE_NT_HEADERS
		mov cx, [esi].FileHeader.NumberOfSections
		movzx ecx, cx
		assume edx:ptr IMAGE_SECTION_HEADER
		.while ecx > 0 									; check all sections
			mov ebx, [esi].OptionalHeader.ImageBase
			.if edi >= [edx].PointerToRawData
				mov eax, [edx].PointerToRawData
				add eax, [edx].SizeOfRawData
				.if edi < eax 							; The address is in this section
					add ebx, [edx].VirtualAddress
					add ebx, edi
					sub ebx, [edx].PointerToRawData
					mov ecx, 01h

					;save the virtual adress of beginning of section for the Plugin API DisassembleBack
					mov eax, [edx].VirtualAddress
					add eax, [esi].OptionalHeader.ImageBase
					mov dword ptr [dBackVirtualAddress], eax

					;save the size of section for the Plugin API DisassembleBack
					mov eax, [edx].SizeOfRawData
					mov dword ptr [dBackSizeOfRawData], eax
				.endif
			.endif
			add edx, sizeof IMAGE_SECTION_HEADER
			dec ecx
		.endw
		assume edx:nothing
		assume esi:nothing
		mov eax, ebx
		ret
OffsetToVA endp 


RelevantPrintFunction proc uses ecx
		assume edi:ptr SIG_DATA
		invoke ParentTreeViewAdd, [edi].CryptoName

		xor ecx, ecx
		mov dword ptr [sigCounter], ecx
		mov singleSig, 00h
		mov eax, offset SearchEngine_BYTES
		mov ebx, [edi].SearchAlgorithm
		cmp eax, ebx
		jne @print_found_offsets
		mov singleSig, 01h

	@print_found_offsets:
		cmp ecx, [edi].SignatureLength
		je @finished_print
		imul edx, ecx, 4

		cmp singleSig, 01h
		je @print_singleSig

	@print_multipleSig:
		mov eax, [edi].Signature
		add eax, edx
		mov eax, dword ptr ds:[eax]
		bswap eax
		mov tempdword, eax
		invoke BASE16_ENCODE_RT, addr tempdword, addr field1Data, 4
		;invoke CharUpperA, addr field1Data
		jmp @print_offsets

	@print_singleSig:
		mov eax, [edi].Signature
		;editted to use 10h instead of sig length (ebx) as was causing issue with long data.
		;mov ebx, [edi].SignatureLength
		invoke BASE16_ENCODE_RT, eax, addr field1Data, 10h

	@print_offsets:
		mov byte ptr [field1Data+8], 00h
		mov eax, [edi].FoundOffsets
		add eax, edx
		mov ebx, dword ptr ds:[eax]
		invoke OffsetToVA						;uses the value in ebx as the file offset
		invoke wsprintf, addr tempbuffer, addr offsetFormat, addr field1Data, ebx, eax
		mov eax, dword ptr [ParentHandle]
		invoke ChildTreeViewAdd, addr tempbuffer, eax

		inc dword ptr [sigCounter]
		mov ecx, dword ptr [sigCounter]
		cmp singleSig, 01h
		je @finished_print
		jmp @print_found_offsets
		
	@finished_print:
		;assume edi:nothing
		ret
RelevantPrintFunction endp


RelevantProgressFunction proc
		pushad
		add	pos, EACHSIGVALUE
		invoke SendMessage, progresshdlg, PBM_SETPOS, pos, 0
		popad
		ret
RelevantProgressFunction endp


exportTextFile proc
		invoke RtlZeroMemory, offset ExportFilePath, sizeof ExportFilePath-1
		invoke lstrcat, addr ExportFilePath, addr ExportFileDefault
		mov ExportFile.lpstrFile, offset ExportFilePath 
		mov ExportFile.lpstrFilter, offset ExportTXTFilterString
		mov ExportFile.lpstrDefExt, offset ExportTXTDefaultExt
		invoke GetSaveFileName, addr ExportFile
		.if eax
			invoke lstrcpy, addr ExportFileName, addr ExportFilePath
			invoke CreateFile, addr ExportFileName, GENERIC_WRITE, FILE_SHARE_WRITE, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
			.if eax == INVALID_HANDLE_VALUE
				invoke CloseHandle, eax
				xor eax, eax
			.else
				mov hExportFile, eax
				xor ecx, ecx
			@print_next_loop:
				cmp ecx, numberOfSignatures
				je @finished_print
				mov	edi, [_nextSignature+ecx*4]
				assume edi:ptr SIG_DATA
				mov eax, [edi].FoundBOOL
				.if dword ptr [eax] == 01h
					pushad
					mov ebx, [edi].CryptoName
					invoke lstrlen, ebx
					invoke WriteFile, hExportFile, ebx, eax, addr tempdword, 0
					invoke WriteFile, hExportFile, addr newLine, sizeof newLine, addr tempdword, 0

					xor ecx, ecx
					mov dword ptr [sigCounter], ecx
					mov singleSig, 00h
					mov eax, offset SearchEngine_BYTES
					mov ebx, [edi].SearchAlgorithm
					cmp eax, ebx
					jne @print_found_offsets
					mov singleSig, 01h

				@print_found_offsets:
					cmp ecx, [edi].SignatureLength
					je @finished_print_inner
					imul edx, ecx, 4

					cmp singleSig, 01h
					je @print_singleSig

				@print_multipleSig:
					mov eax, [edi].Signature
					add eax, edx
					mov eax, dword ptr ds:[eax]
					bswap eax
					mov tempdword, eax
					invoke BASE16_ENCODE_RT, addr tempdword, addr field1Data, 4
					;invoke CharUpperA, addr field1Data
					jmp @print_offsets

				@print_singleSig:
					mov eax, [edi].Signature
					mov ebx, [edi].SignatureLength
					invoke BASE16_ENCODE_RT, eax, addr field1Data, ebx
					;invoke CharUpperA, addr field1Data

				@print_offsets:
					mov byte ptr [field1Data+8], 00h
					mov eax, [edi].FoundOffsets
					add eax, edx
					mov ebx, dword ptr ds:[eax]
					invoke OffsetToVA						;uses the value in ebx as the file offset
					invoke wsprintf, addr tempbuffer, addr exportTXTFormat, addr field1Data, ebx, eax
					invoke lstrlen, addr tempbuffer
					invoke WriteFile, hExportFile, addr tempbuffer, eax, addr tempdword, 0
					invoke WriteFile, hExportFile, addr newLine, sizeof newLine, addr tempdword, 0

					inc dword ptr [sigCounter]
					mov ecx, dword ptr [sigCounter]
					cmp singleSig, 01h
					je @finished_print_inner
					jmp @print_found_offsets
					
				@finished_print_inner:
					;assume edi:nothing
					popad
				.endif
				assume edi:nothing
				inc ecx
				jmp @print_next_loop
			@finished_print:
				invoke CloseHandle, hExportFile
			.endif
		.endif
		ret
exportTextFile endp


exportIDCFile proc
		invoke RtlZeroMemory, offset ExportFilePath, sizeof ExportFilePath-1
		mov dword ptr [slotIDX], 00h
		invoke lstrcat, addr ExportFilePath, addr ExportFileDefault
		mov ExportFile.lpstrFile, offset ExportFilePath 
		mov ExportFile.lpstrFilter, offset ExportIDCFilterString
		mov ExportFile.lpstrDefExt, offset ExportIDCDefaultExt
		invoke GetSaveFileName, addr ExportFile
		.if eax
			invoke lstrcpy, addr ExportFileName, addr ExportFilePath
			invoke CreateFile, addr ExportFileName, GENERIC_WRITE, FILE_SHARE_WRITE, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
			.if eax == INVALID_HANDLE_VALUE
				invoke CloseHandle, eax
				xor eax, eax
			.else
				mov hExportFile, eax
				invoke WriteFile, hExportFile, addr exportIDCHeader, sizeof exportIDCHeader-1, addr tempdword, 0
				.if bBookmark == TRUE
					invoke WriteFile, hExportFile, addr exportBookmarkVars, sizeof exportBookmarkVars-1, addr tempdword, 0
				.endif				
				xor ecx, ecx
			@print_next_loop:
				cmp ecx, numberOfSignatures
				je @finished_print
				mov	edi, [_nextSignature+ecx*4]
				assume edi:ptr SIG_DATA
				mov eax, [edi].FoundBOOL
				.if dword ptr [eax] == 01h
					pushad

					xor ecx, ecx
					mov dword ptr [sigCounter], ecx
					mov singleSig, 00h
					mov eax, offset SearchEngine_BYTES
					mov ebx, [edi].SearchAlgorithm
					cmp eax, ebx
					jne @print_found_offsets
					mov singleSig, 01h

				@print_found_offsets:
					cmp ecx, [edi].SignatureLength
					je @finished_print_inner
					imul edx, ecx, 4

					cmp singleSig, 01h
					je @print_singleSig

				@print_multipleSig:
					mov eax, [edi].Signature
					add eax, edx
					mov eax, dword ptr ds:[eax]
					bswap eax
					mov tempdword, eax
					invoke BASE16_ENCODE_RT, addr tempdword, addr field1Data, 4
					;invoke CharUpperA, addr field1Data
					jmp @print_offsets

				@print_singleSig:
					mov eax, [edi].Signature
					mov ebx, [edi].SignatureLength
					invoke BASE16_ENCODE_RT, eax, addr field1Data, ebx
					;invoke CharUpperA, addr field1Data

				@print_offsets:
					mov byte ptr [field1Data+8], 00h
					mov eax, [edi].FoundOffsets
					add eax, edx
					mov ebx, dword ptr ds:[eax]
					invoke OffsetToVA						;uses the value in ebx as the file offset
					mov edx, eax
					dec edx
					.if bBookmark == TRUE
						push eax
						invoke wsprintf, addr tempbuffer, addr exportBookmarkFormat, edx, slotIDX, [edi].CryptoName
						invoke lstrlen, addr tempbuffer
						invoke WriteFile, hExportFile, addr tempbuffer, eax, addr tempdword, 0
						pop eax
					.endif
					.if bComment == TRUE
						invoke wsprintf, addr tempbuffer, addr exportCommentFormat, eax, [edi].CryptoName, addr field1Data
						invoke lstrlen, addr tempbuffer
						invoke WriteFile, hExportFile, addr tempbuffer, eax, addr tempdword, 0
					.endif

					inc dword ptr [slotIDX]
					inc dword ptr [sigCounter]
					mov ecx, dword ptr [sigCounter]
					cmp singleSig, 01h
					je @finished_print_inner
					jmp @print_found_offsets
					
				@finished_print_inner:
					;assume edi:nothing
					popad
				.endif
				assume edi:nothing
				inc ecx
				jmp @print_next_loop
			@finished_print:
				invoke WriteFile, hExportFile, addr exportIDCFooter, sizeof exportIDCFooter-1, addr tempdword, 0
				invoke CloseHandle, hExportFile
			.endif
		.endif
		ret
exportIDCFile endp
