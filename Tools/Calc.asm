
INCLUDE biglib.inc
INCLUDELIB Tools\biglib.lib

.const
IDC_X = 99
BTN_0 = 0
BTN_1 = 1
BTN_2 = 2
BTN_3 = 3
BTN_4 = 4
BTN_5 = 5
BTN_6 = 6
BTN_7 = 7
BTN_8 = 8
BTN_9 = 9
BTN_A = 10
BTN_B = 11
BTN_C = 12
BTN_D = 13
BTN_E = 14
BTN_F = 15
BTN_EQ = 16
BTN_ADD = 17
BTN_AND = 18
BTN_SHR = 19
BTN_SUB = 20
BTN_XOR = 21
BTN_SHL = 22
BTN_MUL = 23
BTN_OR = 24
BTN_POW = 25

BTN_DIV = 27
BTN_MOD = 28
BTN_NOT = 29
BTN_REVERSE = 30
BTN_CE_IN = 31
BTN_BSWAP_IN = 32
BTN_CE_ANS = 33
BTN_PRIME = 34
OPT_HEX		= 40
OPT_DEC		= 41
;= Texts

IDC_VAL_IN = 200
IDC_CHR_IN = 201
IDC_ANS	= 202

.data
calc_title	BYTE  'Big Calc 1.0 - SND RT',0
prime_true	BYTE  'True',0
prime_false	BYTE  'False',0
math_to_do	DWORD 0
good_2_go	DWORD 0
only_byte_value BOOL 0
hex_calc_base	BYTE  0
last_bswap_size DWORD 0
hWndHexEdit	DWORD 0
hWndCalc	HWND  0
bswap_press	BOOL  0
breaker		DWORD 10 dup(0)

;strings
temp_string	BYTE 512 dup(0)
;inputs
big_a		BYTE 512 dup(0)
big_b		BYTE 512 dup(0)



.data?
;memory
hBig1 		DWORD ? ; to save the BigNum handles
hBig2 		DWORD ?
hBig3		DWORD ?
.code

;***************************************************************************************
; Basic Dialog Box Proc
;***************************************************************************************
CalcDialogProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
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
			invoke SetBkMode, wParam, OPAQUE
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

		.ELSEIF uMsg == WM_SETFOCUS
			
		.ELSEIF uMsg == WM_COMMAND
			
			mov eax, wParam ; item, control, or accelerator identifier
			mov edx, eax    ; notification code
			and eax, 0FFFFh
			shr edx, 16

			.IF eax >= BTN_0 && eax <= BTN_9
				mov	ebx,eax
				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string, SIZEOF temp_string-1
				.IF only_byte_value == TRUE
					mov	ecx,1
				.else
					mov	ecx,512
				.endif
				.IF	eax <= ecx
				add	ebx,'0'
				mov	byte ptr[temp_string+eax],bl
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string
				.ENDIF
				mov	last_bswap_size,0
				mov	bswap_press,FALSE
				
				jmp	@DoEnd	
				
				
			.ELSEIF eax >= BTN_A && eax <= BTN_F
				mov	ebx,eax
				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string, SIZEOF temp_string-1
				.IF only_byte_value == TRUE
					mov	ecx,1
				.else
					mov	ecx,512
				.endif
				.IF	eax <= ecx
				add	ebx,'7'
				mov	byte ptr[temp_string+eax],bl
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string
				.ENDIF
				mov	last_bswap_size,0
				mov	bswap_press,FALSE
				jmp	@DoEnd	
				
			.ELSEIF eax >= BTN_ADD && eax <= BTN_NOT
				
				mov	math_to_do,eax
				
				.IF	EAX == BTN_SHL || EAX == BTN_SHR || EAX == BTN_POW
					
					mov only_byte_value,TRUE
				.ELSE
					mov only_byte_value,FALSE
				.ENDIF
				
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				invoke GetDlgItemText, hWnd, IDC_ANS, ADDR big_a, SIZEOF big_a-1
				mov	good_2_go,eax
				.IF 	EAX == 1 && byte ptr[big_a] == '0' || byte ptr[big_a] == 'T' || byte ptr[big_a] == 'F'
					mov	good_2_go,0
					xor	eax,eax
				.ENDIF
				.IF	EAX > 0
				invoke RtlZeroMemory, ADDR big_b, SIZEOF big_b-1
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR big_b, SIZEOF big_b-1
				.IF EAX > 0
				jmp	@Compute
				.ENDIF
				.ELSE
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR big_a, SIZEOF big_a-1
				
				invoke SetDlgItemText, hWnd, IDC_ANS, ADDR big_a
				INVOKE SetDlgItemText,hWnd,IDC_VAL_IN,NULL
				.ENDIF
				JMP	@DoEnd
				
			.ELSEIF eax == BTN_CE_ANS
				invoke SetDlgItemText, hWnd, IDC_ANS,NULL
				invoke SetDlgItemText, hWnd, IDC_VAL_IN,NULL
				mov only_byte_value,FALSE
				MOV math_to_do,FALSE
				JMP	@DoEnd
			.ELSEIF eax == BTN_CE_IN
				invoke SetDlgItemText, hWnd, IDC_VAL_IN,NULL
				mov only_byte_value,FALSE
				MOV math_to_do,FALSE
				JMP	@DoEnd
			.ELSEIF (eax == IDC_CHR_IN && edx == EN_UPDATE)	
				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				
				invoke GetDlgItemText, hWnd, IDC_CHR_IN, ADDR temp_string, SIZEOF temp_string-1
				mov	ebx,eax

				INVOKE CHR2HEX_RT,addr temp_string,addr big_a,ebx
								
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, ADDR big_a
			.ELSEIF (eax == IDC_VAL_IN && edx == EN_UPDATE)	
				;add some check to see for bad chars
				
			.ELSEIF eax == BTN_PRIME
			
				;convert output to Decimal
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR big_a, SIZEOF big_a-1
				invoke BigCreate, BIG_512, BIG_STRING, offset big_a, hex_calc_base
				mov hBig1, eax
				INVOKE BigIsPrime,hBig1
				
				.IF	EAX == TRUE
					mov	eax,offset prime_true
				.ELSE
					mov	eax,offset prime_false
				.ENDIF
				
				invoke SetDlgItemText, hWnd, IDC_ANS, eax
				invoke BigDestroy, hBig1
					
				JMP	@DoEnd
			.ELSEIF eax == OPT_HEX
			.IF hex_calc_base == 10
				mov	hex_calc_base,16
				mov	ebx,BTN_A
			@@:
				INVOKE GetDlgItem, hWnd, EBX
				INVOKE EnableWindow,EAX,TRUE
				INC	EBX
				cmp	EBX,BTN_F
				jle	@b
				INVOKE GetDlgItem, hWnd, BTN_BSWAP_IN
				INVOKE EnableWindow,EAX,TRUE
				INVOKE GetDlgItem, hWnd, BTN_REVERSE
				INVOKE EnableWindow,EAX,TRUE
				
				;convert output to Decimal
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				invoke GetDlgItemText, hWnd, IDC_ANS, ADDR big_a, SIZEOF big_a-1
				invoke BigCreate, BIG_512, BIG_STRING, offset big_a, 10
				mov 	hBig1, eax
				invoke BigToString,hBig1, offset temp_string,16
				invoke SetDlgItemText, hWnd, IDC_ANS, ADDR temp_string
				invoke BigDestroy, hBig1
				;convert the input to decimal
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR big_a, SIZEOF big_a-1
				invoke BigCreate, BIG_512, BIG_STRING, offset big_a, 10
				mov 	hBig1, eax
				invoke BigToString,hBig1, offset temp_string,16
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string
				invoke BigDestroy, hBig1
			.ENDIF
				JMP	@DoEnd
			.ELSEIF eax == OPT_DEC
				.IF hex_calc_base == 16
				mov	hex_calc_base,10
				mov	ebx,BTN_A
			@@:
				INVOKE GetDlgItem, hWnd, EBX
				INVOKE EnableWindow,EAX,FALSE
				INC	EBX
				cmp	EBX,BTN_F
				jle	@b
				INVOKE GetDlgItem, hWnd, BTN_BSWAP_IN
				INVOKE EnableWindow,EAX,FALSE
				INVOKE GetDlgItem, hWnd, BTN_REVERSE
				INVOKE EnableWindow,EAX,FALSE
				
				;convert output to Decimal
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				invoke GetDlgItemText, hWnd, IDC_ANS, ADDR big_a, SIZEOF big_a-1
				invoke BigCreate, BIG_512, BIG_STRING, offset big_a, 16
				mov hBig1, eax
				invoke BigToString,hBig1, offset temp_string,10
				invoke SetDlgItemText, hWnd, IDC_ANS, ADDR temp_string

				invoke BigDestroy, hBig1
				;convert input to Decimal
				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR big_a, SIZEOF big_a-1
				invoke BigCreate, BIG_512, BIG_STRING, offset big_a, 16
				mov hBig1, eax
				invoke BigToString,hBig1, offset temp_string,10
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string

				invoke BigDestroy, hBig1

				.ENDIF
				JMP	@DoEnd
			.ELSEIF eax == BTN_REVERSE
				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string, SIZEOF temp_string-1
				INVOKE STRINGT_REVERSE_RT,addr temp_string,addr big_a,eax
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, addr big_a
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				JMP	@DoEnd
			.ELSEIF eax == BTN_BSWAP_IN
				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR temp_string, SIZEOF temp_string-1
				cmp eax, 00h
				je @no_bswap_input
				.if last_bswap_size == 0
				mov	last_bswap_size,eax
				.endif
				mov	ebx,eax
				mov	ecx,2
				xor	edx,edx
				idiv	ecx
				mov	edi,offset temp_string
				.IF edx != 0
					;need to add a 0 in front
					dec	edi
					mov	byte ptr[edi],'0'
					inc	ebx
				.ENDIF
				INVOKE HEX2CHR_RT,edi,addr big_a,ebx
				
				mov	ecx,4
				xor	edx,edx
				idiv ecx
				mov	ebx,eax
				mov	edi,offset big_a
				xor	edx,edx
				
			@@:	mov	eax,dword ptr[edi]
				bswap eax
				mov	dword ptr [edi],eax
				add	edi,4
				add	edx,4
				dec	ebx
				cmp	ebx,0
				jge	@B
				
				mov	esi,edx

				invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				
				INVOKE CHR2HEX_RT,addr big_a,addr temp_string,esi
				.if  bswap_press == TRUE
				mov	bswap_press,FALSE
				
				mov	eax,last_bswap_size
				.if	eax > 0
				.if	byte ptr[temp_string] == '0'
					inc	eax
				.endif
				mov	byte ptr[temp_string+eax],0
				mov	last_bswap_size,0
				.endif
				.endif
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, addr temp_string
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				mov	bswap_press,TRUE
				JMP	@DoEnd
			@no_bswap_input:

			.ELSEIF eax == BTN_EQ
			
				;the real stuff is done here :)
				invoke RtlZeroMemory, ADDR big_a, SIZEOF big_a-1
				invoke GetDlgItemText, hWnd, IDC_ANS, ADDR big_a, SIZEOF big_a-1
				mov	good_2_go,eax
				
				invoke RtlZeroMemory, ADDR big_b, SIZEOF big_b-1
				invoke GetDlgItemText, hWnd, IDC_VAL_IN, ADDR big_b, SIZEOF big_b-1
				
				.IF EAX > 0 && good_2_go > 0
				@Compute:
					invoke RtlZeroMemory, ADDR temp_string, SIZEOF temp_string-1
				
					invoke BigCreate, BIG_512, BIG_STRING, offset big_a, [hex_calc_base]
					mov hBig1, eax
					invoke BigCreate, BIG_512, BIG_STRING, offset big_b, [hex_calc_base]
					mov hBig2, eax
					invoke BigCreate, BIG_512, BIG_STRING, offset temp_string, [hex_calc_base]
					mov hBig3, eax

					mov	eax,math_to_do
					.IF 	EAX == BTN_ADD
						invoke BigAdd, hBig1, hBig2
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_SUB
						invoke BigSub, hBig1, hBig2
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_AND
						invoke BigAnd, hBig1, hBig2
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_XOR
						invoke BigXor, hBig1, hBig2
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_OR
						invoke BigOr, hBig1, hBig2
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_NOT	;this is a bit different
					;should we not the input or output value?
						invoke BigNot, hBig1
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_MUL
						invoke BigMul, hBig1, hBig2
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_MOD || EAX == BTN_DIV
						PUSH	EAX

						INVOKE BigDiv,hBig1,hBig2,hBig3

						POP	EAX
						.IF	EAX == BTN_MOD
							mov	edi,hBig3
						.ELSE
							mov	edi,hBig1
						.ENDIF
											
					.ELSEIF EAX == BTN_SHL
						INVOKE htodw,addr big_b
						INVOKE BigShl,hBig1,eax
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_SHR
						INVOKE htodw,addr big_b
						INVOKE BigShr,hBig1,eax
						MOV	edi,hBig1
					.ELSEIF EAX == BTN_POW
						INVOKE htodw,addr big_b
						INVOKE BigPow,hBig1,eax
						MOV	edi,hBig1
					.ENDIF
					.IF math_to_do > 0
					invoke BigToString, edi, offset temp_string,[hex_calc_base]
					.ENDIF
				; destroy the BigNums to free memory
				invoke BigDestroy, hBig1
				invoke BigDestroy, hBig2
				invoke BigDestroy, hBig3
				invoke SetDlgItemText, hWnd, IDC_ANS, ADDR temp_string	
				invoke SetDlgItemText, hWnd, IDC_VAL_IN, NULL	
				
				.ENDIF
				;mov math_to_do,0
				jmp	@DoEnd	
				
			.ELSEIF  eax == IDC_X 
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0
				
			.ENDIF
			
			
		.ELSEIF uMsg == WM_INITDIALOG	
			push	hWnd
			pop	hWndCalc
			MOV ebx,BTN_0
			;subclass buttons
			@@:
			invoke GetDlgItem, hWnd, EBX
			push	eax
			invoke 	SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, ADDR BtnProc
			mov	OldBtnProc,eax
			inc	ebx
			cmp	ebx,BTN_PRIME
			jle	@b
			invoke GetDlgItem, hWnd, IDC_X
			push	eax
			invoke 	SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, ADDR BtnProc
			mov	OldBtnProc,eax
			;limit inputs
			
			
			INVOKE GetDlgItem, hWnd, IDC_CHR_IN
			INVOKE SendMessage,eax,EM_LIMITTEXT,64,NULL	;4 Bytes max

			INVOKE SetWindowText,hWnd,addr calc_title

			invoke GetDlgItem, hWnd, IDC_VAL_IN
			mov	hWndHexEdit,eax
			invoke SetWindowLong, eax, GWL_WNDPROC, ADDR EditProcHex
			mov	OldEditProc,eax
			invoke SetFocus,hWndHexEdit
			
			INVOKE CheckRadioButton,hWnd,OPT_HEX,OPT_DEC,OPT_HEX
			mov	hex_calc_base,16
			
		.ELSEIF uMsg == WM_CLOSE
			invoke EndDialog, hWnd, 0
		.ENDIF
@End:
	xor eax, eax
	ret
@DoEnd:
	invoke SetFocus,hWndHexEdit
	INVOKE lstrlen,ADDR temp_string
	invoke SendMessage, hWndHexEdit, EM_SETSEL, eax, eax
	jmp	@End
CalcDialogProc ENDP

EditProcHex PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
		
	.IF uMsg == WM_GETDLGCODE
		mov eax, DLGC_WANTALLKEYS or DLGC_HASSETSEL
		ret
		
	.ELSEIF uMsg == WM_CHAR
		mov eax, wParam
		
		.IF eax >= '0' && eax <= '9' || eax >= 'A' && eax <= 'F' && hex_calc_base == 16 || eax >= 'a' && eax <= 'f' && hex_calc_base == 16 || eax == VK_BACK
			mov	ebx,TRUE
			
		.ELSE
			mov	ebx,FALSE
		.ENDIF
		.IF EAX == '^' ;XOR
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_XOR,NULL
		.ELSEIF EAX == '%' ;MOD
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_MOD,NULL
		.ELSEIF EAX == '>' ;SHR
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_SHR,NULL
		.ELSEIF EAX == '<' ;SHL
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_SHL,NULL
		.ELSEIF EAX == '&' ;AND
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_AND,NULL
		.ELSEIF EAX == '|' ;OR
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_OR,NULL
		.ELSEIF EAX == '!' ;NOT
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_NOT,NULL	
		.ELSEIF EAX == '='
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_EQ,NULL
		.ENDIF
		mov	last_bswap_size,0
		mov	bswap_press,FALSE
		
		.IF ebx == FALSE
			
			
			xor	eax,eax
			ret
			
		.ENDIF

	.ELSEIF uMsg == WM_KEYDOWN
		mov eax, wParam
		mov	last_bswap_size,0
		mov	bswap_press,FALSE
		.IF EAX == VK_MULTIPLY
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_MUL,NULL
		.ELSEIF EAX == VK_ADD
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_ADD,NULL
		.ELSEIF EAX == VK_SUBTRACT
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_SUB,NULL
		.ELSEIF EAX == VK_DIVIDE
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_DIV,NULL
		.ELSEIF EAX == VK_DELETE
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_CE_IN,NULL
		.ELSEIF EAX == VK_RETURN
			INVOKE SendMessage,hWndCalc,WM_COMMAND,BTN_EQ,NULL
		
		.ELSE

		.ENDIF
		
	invoke InvalidateRect, hWnd, NULL, FALSE
	.ENDIF

	invoke CallWindowProc, OldEditProc, hWnd, uMsg, wParam, lParam
	ret
EditProcHex ENDP

