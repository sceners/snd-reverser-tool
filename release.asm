
;***************************************************************************************
;include the Reverser Tool Functions Definitions
;***************************************************************************************
include hashStructures.inc
include rtFunctions.inc


.code

;***************************************************************************************
; Determine selected combo box option and call the corresponding function
;***************************************************************************************
callRTFunction proc uses ebx esi edi hWnd:HWND
		local _inputlength:dword
		local _keylength:dword
		local _hexvals:dword

		invoke RtlZeroMemory, addr sOutput, sizeof sOutput-1
		invoke RtlZeroMemory, addr sInput, sizeof sInput-1
		invoke RtlZeroMemory, addr sTempBuf, sizeof sTempBuf-1
		invoke SetDlgItemText, hWindow, IDC_INFO, NULL
		call EnableKeyEdit

		; Get the data from the Input field (call name error if it is blank)		
		invoke GetDlgItemText, hWnd, IDC_INPUT, addr sInput, SIZEOF sInput
		mov	_inputlength, eax
		invoke GetDlgItemText, hWnd, IDC_KEY, addr sKeyIn, SIZEOF sKeyIn
		mov	_keylength, eax
		invoke SetDlgItemText, hWnd, IDC_INFO, NULL


		; process the autostrip options where applicable
		.if bStripSpaces == TRUE
			mov esi, offset sInput
			mov edi, offset sTempBuf
		@stripSpacesLoop:
			mov bl, byte ptr [esi]
			cmp bl, 00h
			je @finishedSpaceStrip
			cmp bl, 20h
			je @foundspace
			mov byte ptr [edi], bl
			inc edi
		@foundspace:
			inc esi
			jmp @stripSpacesLoop

		@finishedSpaceStrip:
			invoke lstrcpy, addr sInput, addr sTempBuf
			invoke lstrlen, addr sInput
			mov	_inputlength, eax
			;invoke SetDlgItemText, hWnd, IDC_INPUT, addr sInput
		.endif


		.if bStripNonHex == TRUE
			mov esi, offset sInput
			mov edi, offset sTempBuf
		@stripNonHexLoop:
			mov bl, byte ptr [esi]
			cmp bl, 00h
			je @finishedNonHexStrip
			.if (bl >= 30h && bl <= 39h) || (bl >= 41h && bl <= 46h) || (bl >= 61h && bl <= 66h)
				mov byte ptr [edi], bl
				inc edi
			.endif
			inc esi			
			jmp @stripNonHexLoop

		@finishedNonHexStrip:
			invoke lstrcpy, addr sInput, addr sTempBuf
			invoke lstrlen, addr sInput
			mov	_inputlength, eax
			;invoke SetDlgItemText, hWnd, IDC_INPUT, addr sInput
		.endif


		.if bStripNonAlpha == TRUE
			mov esi, offset sInput
			mov edi, offset sTempBuf
		@stripNonAlphaLoop:
			mov bl, byte ptr [esi]
			cmp bl, 00h
			je @finishedNonAlphaStrip
			.if (bl >= 30h && bl <= 39h) || (bl >= 41h && bl <= 5ah) || (bl >= 61h && bl <= 7ah)
				mov byte ptr [edi], bl
				inc edi
			.endif
			inc esi			
			jmp @stripNonAlphaLoop

		@finishedNonAlphaStrip:
			invoke lstrcpy, addr sInput, addr sTempBuf
			invoke lstrlen, addr sInput
			mov	_inputlength, eax
			;invoke SetDlgItemText, hWnd, IDC_INPUT, addr sInput
		.endif


		mov	edx, TRUE
		.if bInputAsHex == TRUE && _inputlength > 0
			;Convert Hex2Chars
			mov	ebx, _inputlength
			mov	eax, ebx
			mov	ecx, 2
			cdq
			idiv ecx
			.if	edx == 0
				invoke RtlZeroMemory, offset sTempBuf, sizeof sTempBuf-1
				push ebx
				push offset sTempBuf
				push offset sInput
				call HEX2CHR_RT
				.if eax != -1
					invoke lstrcpy, addr sInput, addr sTempBuf
					invoke lstrlen, addr sInput
					mov _inputlength, eax
					mov	edx, TRUE
				.else
					invoke SetDlgItemText, hWnd, IDC_INFO, SADD("Error Reading Input as Hex : Invalid char in input or no input entered. Use 0-9, A-F and a-f only.")
					invoke SetDlgItemText, hWnd, IDC_OUTPUT, SADD(" ")
					mov	edx, FALSE
				.endif
			.else
				invoke SetDlgItemText, hWnd, IDC_INFO, SADD("Error Reading Input as Hex : Please enter input length in multiples of 2 (you should use trailing 0's if needed i.e. 01 rather than 1)")
				invoke SetDlgItemText, hWnd, IDC_OUTPUT, SADD(" ")
				mov	edx, FALSE
			.endif
		.endif


		.if bKeyAsHex == TRUE && _keylength > 0 && edx == TRUE
			;Convert Hex2Chars
			mov	ebx, _keylength
			mov	eax, ebx
			mov	ecx, 2
			cdq
			idiv ecx
			.if	edx == 0
				invoke RtlZeroMemory, offset sTempBuf, sizeof sTempBuf-1		
				push ebx
				push offset sTempBuf
				push offset sKeyIn
				call HEX2CHR_RT
				.if eax != -1
					invoke lstrcpy, addr sKeyIn, addr sTempBuf
					invoke lstrlen, addr sKeyIn
					mov	edx, TRUE
				.else
					invoke SetDlgItemText, hWnd, IDC_INFO, SADD("Error Reading Key as Hex : Invalid char in key or no key entered. Use 0-9, A-F and a-f only.")
					invoke SetDlgItemText, hWnd, IDC_OUTPUT, SADD(" ")
					mov	edx, FALSE
				.endif
			.else
				invoke SetDlgItemText, hWnd, IDC_INFO, SADD("Error Reading Key as Hex : Please enter a key length in multiples of 2 (you should use trailing 0's if needed i.e. 01 rather than 1)")
				invoke SetDlgItemText, hWnd, IDC_OUTPUT, SADD(" ")
				mov	edx, FALSE
			.endif
		.endif


		.if	edx == TRUE
			invoke SendMessage, hComboSelect, CB_GETCURSEL, 0, 0
			mov	edx, [_function+eax*4]
			push _inputlength
			push offset sOutput
			push offset sInput
			call edx

			;if the function returns successfully then display output, otherwise display error message
			.if eax != -1
				mov	ebx, eax
				imul ebx, 8	;bits
				push eax
				invoke wsprintfA, addr sTempBuf, addr strleng, eax, ebx
				pop	eax
				invoke SetDlgItemText, hWnd, IDC_INFO, addr sTempBuf
				invoke RtlZeroMemory, offset sTempBuf, sizeof sTempBuf-1

				.if bOutputIfUnicode == TRUE
					invoke lstrlenW, addr sOutput
					invoke WideCharToMultiByte, 0, 0, addr sOutput, eax, addr sTempBuf, eax, 0, 0
					invoke wsprintf, addr sOutput, addr sTempBuf
				.endif

				; test to see if the 'display output as hex' button has been pressed. If so, convert it before printing to screen
				.if bOutputAsHex == TRUE
					invoke RtlZeroMemory, offset sTempBuf, sizeof sTempBuf-1
					invoke lstrlen, addr sOutput
					push eax
					push offset sTempBuf
					push offset sOutput
					call CHR2HEX_RT
					invoke lstrcpy, addr sOutput, addr sTempBuf
					mov	edx, TRUE
				.endif

				; test to see if the 'display output in uppercase' button has been pressed. If so, convert it before printing to screen
				.if bOutputInUppercase == TRUE
					invoke CharUpperA, addr sOutput
				.endif

				; Finally, print the output to the screen
				invoke SetDlgItemText, hWnd, IDC_OUTPUT, addr sOutput

			.else
				;clear the output box if there was an error
				invoke SetDlgItemText, hWnd, IDC_OUTPUT, SADD(" ")
			.endif

		.endif
		ret
callRTFunction endp


;***************************************************************************************
; Copy the contents of the output box into the clipboard
;***************************************************************************************
Copy proc uses ebx esi edi hWnd:HWND
		mov ebx, FALSE ; success flag
		invoke GetDlgItemText, hWnd, IDC_OUTPUT, addr sOutput, SIZEOF sOutput
		.if eax
			invoke OpenClipboard, hWnd
			.if eax
				invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_DDESHARE, SIZEOF sOutput
				.if eax != NULL
					push eax
					push eax
					; Copy the serial into the clipboard
					invoke GlobalLock, eax
					mov edi, eax
					mov esi, OFFSET sOutput
					mov ecx, SIZEOF sOutput
					rep movsb
					pop eax
					invoke GlobalUnlock, eax
					invoke EmptyClipboard
					pop eax
					invoke SetClipboardData, CF_TEXT, eax
					mov ebx, TRUE
				.endif
				invoke CloseClipboard
			.endif
		.endif
		.if ebx
			invoke SetDlgItemText, hWnd, IDC_INFO, SADD("The output has been copied into the clipboard.")
		.else
			invoke SetDlgItemText, hWnd, IDC_INFO, SADD("An error occured, please copy the serial by hand.")
		.endif
		mov eax, TRUE
		ret
Copy endp

