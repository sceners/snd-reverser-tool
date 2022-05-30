
BruteHelpDialogProc		proto :HWND, :UINT , :WPARAM, :LPARAM
getAlphabetCharacters	proto
buildString_NoSalt		proto
buildString_Prepend		proto
buildString_Append		proto
buildString_Mask		proto
bruteEnableFields		proto
bruteDisableFields		proto


.const
IDC_BRUTE_X 			equ 101		;id is used by the help box as well as the main window
IDC_BRUTE_START			equ 102
IDC_BRUTE_STOP			equ 103
IDC_BRUTE_RESET 		equ 104
IDC_BRUTE_HELP	 		equ 105
EDIT_CUSTOM				equ 201
EDIT_TARGET				equ 202
EDIT_SALT				equ 203
EDIT_STATUS				equ 204
IDC_COMBO_HASHTYPE		equ 301
IDC_COMBO_ALPHABET		equ 302
IDC_COMBO_SALT			equ 303
IDS_BRUTE_TITLE			equ 401
IDS_BRUTE_HELP_TITLE	equ 401
EDIT_HELP_TEXT			equ 201


.data?
bruteThreadID			dd ?
updateThreadID			dd ?
hHashComboSelect		dd ?
hAlphaComboSelect		dd ?
hSaltComboSelect		dd ?
selectedHash			dd ?
selectedHashIndex		db ?
selectedAlpha			dd ?
selectedSalt			dd ?
selectedBrute			dd ?
targetHash				db 200 dup(?)
tempBuffer				db 200 dup(?)
resultBuffer			db 200 dup(?)
keyBuffer				db 20 dup(?)
bruteIndexBuffer		db 20 dup(?)
printBuffer				db 100 dup(?)
alphabetBuffer			db 100 dup(?)
saltBuffer				db 100 dup(?)


.data
hBruteWindow			dd 0
hStatus					dd 0
hCustom					dd 0
hHelpText				dd 0
brutingFlag				dd 00h
alphabetLength			dd 00h
maxLength				dd 08h

CurrentKeyFormat		db "Currently Testing : %s", 0
SolutionFound			db "Solution Found : %s", 0
NoSolutionFound			db "Sorry - No Solution Found", 0
BruteForceReset			db "Progress Reset.", 0
ErrorNoAlgorithm		db "Error - You Have Not Selected a Hashing Algorithm.", 0
ErrorNoInput			db "Error - You Have Not Entered a Hash.", 0
ErrorNoAlphabet			db "Error - You Have Not Selected an Alphabet.", 0
ErrorWrongLength		db "Error - The Hash You Entered Is The Wrong Length.", 0
ErrorInvalidMask		db "Error - You must have at least one ? char in your mask.", 0

sHelpText				db 0dh, 0ah, 'This is a basic but flexible hash bruteforcer which will hopefully be useful to you. It is '
						db 'NOT optimised at the moment but usage should be straight forward and self explanatory.', 0dh, 0ah, 0dh, 0ah
						db 'The alphabet used can be customised so you can use every printable character '
						db 'or just a subset as required. Either select an option from the menu or type directly '
						db 'into the edit box - it is the set of values in the edit box which will be used.', 0dh, 0ah, 0dh, 0ah
						db 'The hash to be bruteforced must be of correct length but can contain wildcards in the form '
						db 'of question marks (?). One wildcard must be used for each unknown so that the hash remains '
						db 'the correct length.', 0dh, 0ah, 0dh, 0ah
						db 'The salt works as follows : ', 0dh, 0ah, 0dh, 0ah
						db '- selecting the PREPEND option adds the salt value to the beginning of every test. This would '
						db 'be useful if you knew the start of the key.', 0dh, 0ah, 0dh, 0ah
						db '- selecting the APPEND option adds the salt value to the end of every test. You guessed it, '
						db 'this would be useful if you knew the end of the key.', 0dh, 0ah, 0dh, 0ah
						db '- selecting the MASK option allows the use of wildcards where unknow values will be bruteforced. '
						db 'Simple example : bruteforcing MD5 ??1bc210a22?b?d9061c?57e66?2d??0 with a mask L?k?_SnD will '
						db 'bruteforce the 2 unknown chars until it finds a match with Loki_SnD.', 0
	

;*********************************************************************************************************
; SETUP THE HASHTYPE COMBO BOX VARIABLES FOR USE ON THE BRUTE FORCE DIALOG
;*********************************************************************************************************

hash_top_line			db '--------------------------------------- Select a hash type ---------------------------------------', 0

hHashComboData			dd offset hash_top_line
						dd offset gost_string
						dd offset md2_string
						dd offset md4_string
						dd offset md5_string
						dd offset panama_string
						dd offset ripemd128_string
						dd offset ripemd160_string
						dd offset ripemd256_string
						dd offset ripemd320_string
						dd offset sha0_string
						dd offset sha1_string
						dd offset sha256_string
						dd offset sha384_string
						dd offset sha512_string
						dd offset tiger_string
						dd offset whirlpool_string

HashComboDataSize		equ ($ - hHashComboData)/4

_hashfunction			dd 00000000h
						dd offset GOST_RT
						dd offset MD2_RT
						dd offset MD4_RT
						dd offset MD5_RT
						dd offset PANAMA_RT
						dd offset RIPEMD128_RT
						dd offset RIPEMD160_RT
						dd offset RIPEMD256_RT
						dd offset RIPEMD320_RT
						dd offset SHA0_RT
						dd offset SHA1_RT
						dd offset SHA256_RT
						dd offset SHA384_RT
						dd offset SHA512_RT
						dd offset TIGER_RT
						dd offset WHIRLPOOL_RT

_hashlengths			db 00h
						db 40h	; Gost 256bit
						db 20h	; MD2 128bit
						db 20h	; MD4 128bit
						db 20h	; MD5 128bit
						db 40h	; Panama 256bit
						db 20h	; RIPEMD128 128bit
						db 28h	; RIPEMD160 160bit
						db 40h	; RIPEMD256 256bit
						db 50h	; RIPEMD320 320bit
						db 28h	; SHA0 128bit
						db 28h	; SHA1 128bit
						db 40h	; SHA256 256bit
						db 60h	; SHA384 384bit
						db 80h	; SHA512 384bit
						db 30h	; Tiger 192bit
						db 80h	; Whirlpool 512bit


;*********************************************************************************************************
; SETUP THE ALPHABET COMBO BOX VARIABLES FOR USE ON THE BRUTE FORCE DIALOG
;*********************************************************************************************************
alpha_top_line							db '------------------------- Select an alphabet and customise it below -------------------------', 0
alpha_string_lower 						db 'Lowercase Alphabet',0
alpha_string_lower_numbers 				db 'Lowercase Alphabet + Numbers',0
alpha_string_lower_numbers_chars 		db 'Lowercase Alphabet + Numbers + Special Characters',0
alpha_string_upper 						db 'Uppercase Alphabet',0
alpha_string_upper_numbers 				db 'Uppercase Alphabet + Numbers',0
alpha_string_upper_numbers_chars 		db 'Uppercase Alphabet + Numbers + Special Characters',0
alpha_string_lower_upper 				db 'Lowercase Alphabet + Uppercase Alphabet',0
alpha_string_lower_upper_numbers 		db 'Lowercase Alphabet + Uppercase Alphabet + Numbers',0
alpha_string_lower_upper_numbers_chars	db 'Lowercase Alphabet + Uppercase Alphabet + Numbers + Special Characters',0
alpha_string_chars						db 'Special Characters Only',0
alpha_string_numbers 					db 'Numbers Only',0


hAlphaComboData			dd offset alpha_top_line
						dd offset alpha_string_lower
						dd offset alpha_string_lower_numbers
						dd offset alpha_string_lower_numbers_chars
						dd offset alpha_string_upper
						dd offset alpha_string_upper_numbers
						dd offset alpha_string_upper_numbers_chars
						dd offset alpha_string_lower_upper
						dd offset alpha_string_lower_upper_numbers
						dd offset alpha_string_lower_upper_numbers_chars
						dd offset alpha_string_chars
						dd offset alpha_string_numbers

AlphaComboDataSize		equ ($ - hAlphaComboData)/4


; Foramt for this dword is : (CHARS - NUMBERS - UPPER - LOWER)
_alphafunction			dd  00000000h
						dd  000000FFh
						dd  00FF00FFh
						dd 0FFFF00FFh
						dd  0000FF00h
						dd  00FFFF00h
						dd 0FFFFFF00h
						dd  0000FFFFh
						dd  00FFFFFFh
						dd 0FFFFFFFFh
						dd 0FF000000h
						dd  00FF0000h



;*********************************************************************************************************
; SETUP THE SALT COMBO BOX VARIABLES FOR USE ON THE BRUTE FORCE DIALOG
;*********************************************************************************************************
salt_none				db 'No Salt', 0
salt_prepend 			db 'Prepend Salt to Bruteforced Characters',0
salt_append 			db 'Append Salt to Bruteforced Characters',0
salt_mask				db 'Use a Mask For the Bruteforced Characters',0


hSaltComboData			dd offset salt_none
						dd offset salt_prepend
						dd offset salt_append
						dd offset salt_mask

SaltComboDataSize		equ ($ - hSaltComboData)/4

_saltbrute				dd  offset brute_normal
						dd  offset brute_normal
						dd  offset brute_normal
						dd  offset brute_mask

_saltfunction			dd  offset buildString_NoSalt
						dd  offset buildString_Prepend
						dd  offset buildString_Append
						dd  offset buildString_Mask

.code

;***************************************************************************************
; Basic Dialog Box Proc
;***************************************************************************************
BruteDialogProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local sBtnText[10h]:TCHAR
	local i:dword

		.if uMsg == WM_INITDIALOG
			mov eax, hWnd
			mov hBruteWindow, eax

			invoke GetDlgItem, hWnd, EDIT_STATUS
			mov hStatus, eax
			invoke GetDlgItem, hWnd, EDIT_CUSTOM
			mov hCustom, eax

			;cycle through all the buttons setting the font and subclassing them
			;save the old button proc for reference
			mov ebx, IDC_BRUTE_X
		@@:
			invoke GetDlgItem, hWnd, ebx
			push eax
			invoke SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, addr BtnProc
			inc	ebx
			cmp	ebx, IDC_BRUTE_HELP
			jle	@b

			invoke GetDlgItem, hWnd, IDC_COMBO_HASHTYPE
			mov	hHashComboSelect, eax
			invoke GetWindowLong, hHashComboSelect, GWL_WNDPROC
		 	mov OldComboProc, eax
			invoke SetWindowLong, hHashComboSelect, GWL_USERDATA, OldComboProc
			invoke SetWindowLong, hHashComboSelect, GWL_WNDPROC, ComboProc

			xor	ebx, ebx
		@@:
			mov	eax, [hHashComboData+ebx*4]
			invoke SendMessage, hHashComboSelect, CB_ADDSTRING, 0, eax
			inc	ebx 
			cmp	ebx, HashComboDataSize
			jne	@b
			invoke SendMessage, hHashComboSelect, CB_SETCURSEL, 0, 0

			invoke GetDlgItem, hWnd, IDC_COMBO_ALPHABET
			mov	hAlphaComboSelect, eax
			invoke GetWindowLong, hAlphaComboSelect, GWL_WNDPROC
		 	mov OldComboProc, eax
			invoke SetWindowLong, hAlphaComboSelect, GWL_USERDATA, OldComboProc
			invoke SetWindowLong, hAlphaComboSelect, GWL_WNDPROC, ComboProc

			xor	ebx, ebx
		@@:
			mov	eax, [hAlphaComboData+ebx*4]
			invoke SendMessage, hAlphaComboSelect, CB_ADDSTRING, 0, eax
			inc	ebx 
			cmp	ebx, AlphaComboDataSize
			jne	@b
			invoke SendMessage, hAlphaComboSelect, CB_SETCURSEL, 0, 0

			invoke GetDlgItem, hWnd, IDC_COMBO_SALT
			mov	hSaltComboSelect, eax
			invoke GetWindowLong, hSaltComboSelect, GWL_WNDPROC
		 	mov OldComboProc, eax
			invoke SetWindowLong, hSaltComboSelect, GWL_USERDATA, OldComboProc
			invoke SetWindowLong, hSaltComboSelect, GWL_WNDPROC, ComboProc

			xor	ebx, ebx
		@@:
			mov	eax, [hSaltComboData+ebx*4]
			invoke SendMessage, hSaltComboSelect, CB_ADDSTRING, 0, eax
			inc	ebx 
			cmp	ebx, SaltComboDataSize
			jne	@b
			invoke SendMessage, hSaltComboSelect, CB_SETCURSEL, 0, 0
			mov ebx, offset buildString_NoSalt
			mov [selectedSalt], ebx
			mov ebx, offset brute
			mov [selectedBrute], ebx


		.elseif uMsg == WM_CTLCOLORDLG
			mov eax, hBgColor
			ret


		.elseif uMsg == WM_CTLCOLORSTATIC || uMsg == WM_CTLCOLOREDIT
			;invoke SelectObject, wParam, hTitleFont
			invoke GetDlgCtrlID, lParam
			.if	eax == IDS_BRUTE_TITLE
				invoke SelectObject, wParam, hTitleFont
			.endif
			invoke SetTextColor, wParam, CR_INTEXT_SCHEME
			invoke SetBkMode, wParam, TRANSPARENT
			invoke SetBkColor, wParam, CR_BG_SCHEME
			mov eax, hBgColor
			ret


		.elseif uMsg == WM_DRAWITEM
			push esi
			push ebx
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
					.if [esi].itemState & ODS_DISABLED
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

			.endif
			assume esi:nothing
			pop ebx
			pop esi
 
 
		.elseif uMsg == WM_LBUTTONDOWN
			invoke SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0


		.elseif uMsg == WM_COMMAND
			mov eax, wParam
			mov edx, eax
			and eax, 0FFFFh
			shr edx, 16

			.if eax == IDC_COMBO_HASHTYPE
				invoke SendMessage, hHashComboSelect, CB_GETCURSEL, 0, 0
				mov [selectedHashIndex], al
				mov	edx, [_hashfunction+eax*4]
				mov selectedHash, edx

			.elseif eax == IDC_COMBO_ALPHABET
				invoke SendMessage, hAlphaComboSelect, CB_GETCURSEL, 0, 0
				mov	edx, [_alphafunction+eax*4]
				mov selectedAlpha, edx
				invoke RtlZeroMemory, addr alphabetBuffer, sizeof alphabetBuffer
				call getAlphabetCharacters

			.elseif eax == IDC_COMBO_SALT
				invoke SendMessage, hSaltComboSelect, CB_GETCURSEL, 0, 0
				mov	edx, [_saltfunction+eax*4]
				mov selectedSalt, edx
				mov	edx, [_saltbrute+eax*4]
				mov selectedBrute, edx
				.if eax > 0
					invoke EnableDlgItem, hWnd, EDIT_SALT, TRUE
				.else
					invoke EnableDlgItem, hWnd, EDIT_SALT, FALSE
					invoke SetDlgItemText, hWnd, EDIT_SALT, NULL
				.endif

			.elseif eax == IDC_BRUTE_START
				; global flag indicates that brute forcing is currently taking place
				mov brutingFlag, 01h
				mov eax, selectedHash
				.if eax > 0
					invoke GetDlgItemTextA, hWnd, EDIT_CUSTOM, offset alphabetBuffer, sizeof alphabetBuffer
					mov alphabetLength, eax
					.if eax > 0
						invoke GetDlgItemTextA, hWnd, EDIT_TARGET, offset targetHash, sizeof targetHash
						.if eax > 0
							movsx edx, [selectedHashIndex]
							movsx edx, [_hashlengths+edx]
							and edx, 0ffh
							.if eax == edx
								call bruteDisableFields
								invoke GetDlgItemTextA, hWnd, EDIT_SALT, offset saltBuffer, sizeof saltBuffer
								mov eax, [selectedBrute]
								invoke CreateThread, NULL, NULL, eax, NULL, 0, addr bruteThreadID
								mov eax, OFFSET updatecurrent
								invoke CreateThread, NULL, NULL, eax, NULL, 0, addr updateThreadID
							.else
								invoke SetWindowText, hStatus, addr ErrorWrongLength
							.endif
						.else
							invoke SetWindowText, hStatus, addr ErrorNoInput
						.endif
					.else
						invoke SetWindowText, hStatus, addr ErrorNoAlphabet
					.endif
				.else
					invoke SetWindowText, hStatus, addr ErrorNoAlgorithm
				.endif

			.elseif eax == IDC_BRUTE_STOP
				mov brutingFlag, 00h
				call bruteEnableFields
				call updatecurrent

			.elseif eax == IDC_BRUTE_RESET
				mov brutingFlag, 00h
				call bruteEnableFields
				call reset

			.elseif eax == IDC_BRUTE_X 
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0

			.elseif eax == IDC_BRUTE_HELP
				invoke DialogBoxParam, hInstance, IDD_BRUTE_HELP, hWnd, addr BruteHelpDialogProc, NULL

			.endif


		.elseif uMsg == WM_CLOSE
			invoke EndDialog, hWnd, 0

		.endif

	@End:
		xor eax, eax
		ret
BruteDialogProc endp



BruteHelpDialogProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local sBtnText[10h]:TCHAR
	local i:dword

		.if uMsg == WM_INITDIALOG
			invoke GetDlgItem, hWnd, EDIT_HELP_TEXT
			mov hHelpText, eax
			invoke SetWindowText, hHelpText, addr sHelpText
			mov ebx, IDC_BRUTE_X
			invoke GetDlgItem, hWnd, ebx
			push eax
			invoke SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, addr BtnProc


		.elseif uMsg == WM_CTLCOLORDLG
			mov eax, hBgColor
			ret


		.elseif uMsg == WM_CTLCOLORSTATIC || uMsg == WM_CTLCOLOREDIT
			;invoke SelectObject, wParam, hTitleFont
			invoke GetDlgCtrlID, lParam
			.if	eax == IDS_BRUTE_HELP_TITLE
				invoke SelectObject, wParam, hTitleFont
			.endif
			invoke SetTextColor, wParam, CR_INTEXT_SCHEME
			invoke SetBkMode, wParam, TRANSPARENT
			invoke SetBkColor, wParam, CR_BG_SCHEME
			mov eax, hBgColor
			ret


		.elseif uMsg == WM_DRAWITEM
			push esi
			push ebx
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
					.if [esi].itemState & ODS_DISABLED
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
			.endif
			assume esi:nothing
			pop ebx
			pop esi


		.elseif uMsg == WM_COMMAND
			invoke SendMessage, hWnd, WM_CLOSE, 0, 0


		.elseif uMsg == WM_LBUTTONDOWN
			invoke SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0


		.elseif uMsg == WM_RBUTTONDOWN
			invoke SendMessage, hWnd, WM_CLOSE, 0, 0


		.elseif uMsg == WM_CLOSE
			invoke EndDialog, hWnd, 0

		.endif
		xor eax, eax
		ret
BruteHelpDialogProc endp


getAlphabetCharacters proc
		pushad
		mov eax, selectedAlpha
		mov esi, offset tempBuffer
		xor ebx, ebx
		xor ecx, ecx

		;process lowercase letters
		cmp al, 00h
		je @process_uppercase
		mov bl, 61h
	@process_lowercase_loop:
		mov byte ptr ds:[esi+ecx], bl
		inc ecx
		inc ebx
		cmp ebx, 7Bh
		jne @process_lowercase_loop

	@process_uppercase:
		shr eax, 08h
		cmp al, 00h
		je @process_numbers
		mov bl, 41h
	@process_uppercase_loop:
		mov byte ptr ds:[esi+ecx], bl
		inc ecx
		inc ebx
		cmp ebx, 5Bh
		jne @process_uppercase_loop

	@process_numbers:
		shr eax, 08h
		cmp al, 00h
		je @process_specialchars_1
		mov bl, 30h
	@process_numbers_loop:
		mov byte ptr ds:[esi+ecx], bl
		inc ecx
		inc ebx
		cmp ebx, 3Ah
		jne @process_numbers_loop

	@process_specialchars_1:
		shr eax, 08h
		cmp al, 00h
		je @alphabetBuilt
		mov bl, 21h
	@process_specialchars_1_loop:
		mov byte ptr ds:[esi+ecx], bl
		inc ecx
		inc ebx
		cmp ebx, 30h
		jne @process_specialchars_1_loop
		mov bl, 3Ah
	@process_specialchars_2_loop:
		mov byte ptr ds:[esi+ecx], bl
		inc ecx
		inc ebx
		cmp ebx, 41h
		jne @process_specialchars_2_loop
		mov bl, 5Bh
	@process_specialchars_3_loop:
		mov byte ptr ds:[esi+ecx], bl
		inc ecx
		inc ebx
		cmp ebx, 61h
		jne @process_specialchars_3_loop
		mov bl, 7Bh
	@process_specialchars_4_loop:
		mov byte ptr ds:[esi+ecx], bl
		inc ecx
		inc ebx
		cmp ebx, 7Fh
		jne @process_specialchars_4_loop

	@alphabetBuilt:
		mov byte ptr ds:[esi+ecx], 00h
		invoke SetWindowText, hCustom, addr tempBuffer
		popad
		ret
getAlphabetCharacters endp


;##########################################################################################


;**************************** Text Progress Update Routine ******************************

updatecurrent proc
	@updateagain:
		mov eax, 500
		wait
		cmp brutingFlag, 00h
		je @no_more_updates
		invoke wsprintf, addr printBuffer, addr CurrentKeyFormat, addr keyBuffer
		invoke SetWindowText, hStatus, addr printBuffer
		jmp @updateagain
	@no_more_updates:
		ret
updatecurrent endp


;**************************** Rest brute force Routine ******************************

reset proc
		pushad
		invoke RtlZeroMemory, addr keyBuffer, SIZEOF keyBuffer
		invoke RtlZeroMemory, addr bruteIndexBuffer, SIZEOF bruteIndexBuffer
		;invoke RtlZeroMemory, addr solution, SIZEOF solution
		invoke SetWindowText, hStatus, addr BruteForceReset
		popad
		ret
reset endp


;**************************** bruteforce co-ordination routine ******************************

brute_normal proc near
		pushad
		mov maxLength, 08h
		mov edi, offset keyBuffer 				;load edi with the address of the buffer that we will use to create our key
		mov esi, offset bruteIndexBuffer 		;load esi with the address of the buffer that we will use to create our key
		movsx ebx, byte ptr [esi]
		mov bl, byte ptr [alphabetBuffer+ebx]
		mov byte ptr [edi], bl

		call brute
		popad
		ret
brute_normal endp



brute_mask proc near
		pushad
		mov byte ptr [maxLength], 00h
		mov edi, offset saltBuffer
		xor ecx, ecx
	@get_mask_length_loop:
		cmp byte ptr ds:[edi], 00h
		je @got_mask_length
		cmp byte ptr ds:[edi], 3Fh
		jne @not_mask_char
		inc ecx
	@not_mask_char:
		inc edi
		inc byte ptr [maxLength]
		jmp @get_mask_length_loop

	@got_mask_length:
		cmp ecx, 00h
		je @invalid_mask
		mov edi, offset keyBuffer
	@set_initial_loop:
		cmp ecx, 00h
		je @finish_loop
		mov bl, byte ptr [alphabetBuffer]
		mov byte ptr [edi], bl
		dec ecx
		inc edi
		jmp @set_initial_loop

	@finish_loop:		
		mov edi, offset keyBuffer
		mov esi, offset bruteIndexBuffer
		movsx ebx, byte ptr [esi]
		mov bl, byte ptr [alphabetBuffer+ebx]
		mov byte ptr [edi], bl
		call brute
		popad
		ret

	@invalid_mask:
		mov brutingFlag, 00h
		invoke TerminateThread, addr updateThreadID, NULL
		call bruteEnableFields
		invoke SetWindowText, hStatus, addr ErrorInvalidMask
		popad
		ret
brute_mask endp


brute proc near

	@bruteNextValue:
		mov eax, brutingFlag					; check to see that the bruting flag is still set i.e. determine whether to continue brute forcing
		test eax, eax							;if flag is not set then jump to the exit.
		je @exit

		call selectedSalt						;format the current key to be tested (into tempBuffer) depending on the salt style selected
		cmp ecx, 0FFh
		jg @no_solution

		call calculateTarget					;check the current brute force value
		cmp eax, 01h		 					;calculateTarget sets eax to 01h when solution has been found
		je @foundsolution						;solution found, no need to brute force further
		mov edi, offset keyBuffer				;reset edi to beginning of the key buffer
		mov esi, offset bruteIndexBuffer		;reset esi to beginning of the brute buffer

	@incChar:
		inc byte ptr [esi] 						;add one to the first byte of the key
		movsx ebx, byte ptr [alphabetLength]	;get the length of the alphabet list
		cmp byte ptr [esi], bl					;compare the new value to upper limit to see if we're maxed out
		jg @processNextChar 					;if maxed out then we add 1 to the next byte in the key
		movsx ebx, byte ptr [esi]
		mov bl, byte ptr [alphabetBuffer+ebx-1]
		mov byte ptr [edi], bl		
		jmp @bruteNextValue

	@processNextChar:
		mov byte ptr [esi], 00h
		mov bl, byte ptr [alphabetBuffer]
		mov byte ptr [edi], bl					;current edi is maxed so reset to lower value
		inc edi
		inc esi
		jmp @incChar

	@foundsolution:
		mov brutingFlag, 00h
		invoke TerminateThread, addr updateThreadID, NULL
		call bruteEnableFields
		call selectedSalt						;gets the full solution into the tempBuffer ready for displaying
		invoke wsprintf, addr printBuffer, addr SolutionFound, addr tempBuffer
		invoke SetWindowText, hStatus, addr printBuffer
		ret

	@no_solution:
		mov brutingFlag, 00h
		invoke TerminateThread, addr updateThreadID, NULL
		call bruteEnableFields
		invoke SetWindowText, hStatus, addr NoSolutionFound
		ret

	@exit:
		mov brutingFlag, 00h
		ret
brute endp


buildString_NoSalt proc
		xor ecx, ecx
		mov edx, maxLength
		mov esi, offset keyBuffer
		mov edi, offset tempBuffer
	@string_copy_loop:
		mov bl, byte ptr ds:[esi+ecx]
		cmp bl, 00h
		je @copy_complete
		mov byte ptr ds:[edi+ecx], bl
		inc ecx
		jmp @string_copy_loop
	@copy_complete:
		mov byte ptr ds:[edi+ecx], bl
		cmp byte ptr ds:[keyBuffer+edx], 00h
		jne @no_solution
		ret

	@no_solution:
		mov ecx, 0FFh
		ret
buildString_NoSalt endp


buildString_Prepend proc
		xor ecx, ecx
		xor edx, edx
		mov esi, offset saltBuffer
		mov edi, offset tempBuffer
	@salt_prepend_loop:
		mov bl, byte ptr ds:[esi+ecx]
		cmp bl, 00h
		je @prepend_complete
		mov byte ptr ds:[edi+ecx], bl
		inc ecx
		jmp @salt_prepend_loop
	@prepend_complete:

		mov esi, offset keyBuffer
	@string_copy_loop:
		mov bl, byte ptr ds:[esi]
		cmp bl, 00h
		je @copy_complete
		mov byte ptr ds:[edi+ecx], bl
		inc esi
		inc ecx
		inc edx
		jmp @string_copy_loop
	@copy_complete:
		mov byte ptr ds:[edi+ecx], bl
		cmp byte ptr ds:[keyBuffer+edx], 00h
		jne @no_solution
		ret

	@no_solution:
		mov ecx, 0FFh
		ret
buildString_Prepend endp


buildString_Append proc
		xor ecx, ecx
		xor edx, edx
		mov edi, offset tempBuffer
		mov esi, offset keyBuffer
	@string_copy_loop:
		mov bl, byte ptr ds:[esi+ecx]
		cmp bl, 00h
		je @copy_complete
		mov byte ptr ds:[edi+ecx], bl
		inc ecx
		inc edx
		jmp @string_copy_loop
	@copy_complete:

		mov esi, offset saltBuffer
	@salt_append_loop:
		mov bl, byte ptr ds:[esi]
		cmp bl, 00h
		je @append_complete
		mov byte ptr ds:[edi+ecx], bl
		inc esi
		inc ecx
		jmp @salt_append_loop
	@append_complete:
		mov byte ptr ds:[edi+ecx], bl
		cmp byte ptr ds:[keyBuffer+edx], 00h
		jne @no_solution
		ret

	@no_solution:
		mov ecx, 0FFh
		ret
buildString_Append endp


buildString_Mask proc
		xor ecx, ecx
		xor edx, edx
		mov esi, offset keyBuffer
	@string_copy_loop:
		cmp byte ptr ds:[saltBuffer+ecx], 00h
		je @copy_complete
		cmp byte ptr ds:[saltBuffer+ecx], 3Fh
		je @mask_value
		mov bl, byte ptr ds:[saltBuffer+ecx]
		mov byte ptr ds:[tempBuffer+ecx], bl
		jmp @get_next_values
	@mask_value:
		mov bl, byte ptr ds:[esi]
		mov byte ptr ds:[tempBuffer+ecx], bl
		inc esi
		inc edx
	@get_next_values:
		inc ecx
		jmp @string_copy_loop

	@copy_complete:
		mov byte ptr ds:[tempBuffer+ecx], 00h
		cmp byte ptr ds:[keyBuffer+edx], 00h
		jne @no_solution
		ret

	@no_solution:
		mov ecx, 0FFh
		ret
buildString_Mask endp


calculateTarget proc
		push ecx						;length of string as set in the previous procs
		push offset resultBuffer
		push offset tempBuffer
		call selectedHash

		mov esi, offset resultBuffer
		mov edi, offset targetHash
	@compare_hashes_loop:
		movsx ebx, byte ptr ds:[esi]
		movsx edx, byte ptr ds:[edi]
		cmp bl, 00h
		je @match_found
		cmp dl, 3Fh
		je @next_chars
		cmp bl, dl
		jne @no_match_found
	@next_chars:
		inc edi
		inc esi
		jmp @compare_hashes_loop

	@match_found:
		mov esi, offset resultBuffer
		mov byte ptr [esi], 00h
		mov eax, 01h
		ret

	@no_match_found:
		mov esi, offset resultBuffer
		mov byte ptr [esi], 00h
		mov eax, 00h
		ret
calculateTarget endp


bruteEnableFields proc
		invoke EnableDlgItem, hBruteWindow, IDC_COMBO_HASHTYPE, TRUE
		invoke EnableDlgItem, hBruteWindow, IDC_COMBO_ALPHABET, TRUE
		invoke EnableDlgItem, hBruteWindow, IDC_COMBO_SALT, TRUE
		invoke EnableDlgItem, hBruteWindow, EDIT_SALT, TRUE
		invoke EnableDlgItem, hBruteWindow, EDIT_CUSTOM, TRUE
		invoke EnableDlgItem, hBruteWindow, EDIT_TARGET, TRUE
		ret
bruteEnableFields endp


bruteDisableFields proc
		invoke EnableDlgItem, hBruteWindow, IDC_COMBO_HASHTYPE, FALSE
		invoke EnableDlgItem, hBruteWindow, IDC_COMBO_ALPHABET, FALSE
		invoke EnableDlgItem, hBruteWindow, IDC_COMBO_SALT, FALSE
		invoke EnableDlgItem, hBruteWindow, EDIT_SALT, FALSE
		invoke EnableDlgItem, hBruteWindow, EDIT_CUSTOM, FALSE
		invoke EnableDlgItem, hBruteWindow, EDIT_TARGET, FALSE
		ret
bruteDisableFields endp
