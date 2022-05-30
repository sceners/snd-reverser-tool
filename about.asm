

.const
IDC_ABT_FORUM 	= 100
IDC_ABT_WEB 	= 101
IDC_ABT_CLOSE 	= 102
IDC_ABT_X 		= 103
PictureW 		= 336
PictureH 		= 240


.data
_open		db 'open', 0
wwweb 		db 'http://snd.astalavista.ms/', 0
wwforum 	db 'http://www.tuts4you.com/forum/', 0

MyRect 		RECT <1, 1, PictureW, PictureH>
hColDot1	HBRUSH		?
hColDot2	HBRUSH		?

x			dd 0
x2			dd 0
txtMul10	dd 0
MADE 		db 0
ScrollCol1	dd 0
haltsec		dd 0
tHalt		BOOL 0
hPen 		dd 0
oldPen 		dd 0

;/used for Orbit Proc
DEG 		dq 1.74532925199433E-02 ;Constant for converting degrees to radians
Radius 		REAL4 20.0 ;250.0	;distance
AngleOffs 	REAL4 180.0
Ratio 		REAL4 -3.0	
Angle 		REAL4 0.0
tempX 		REAL4 0.0
tempY 		REAL4 0.0
CntX 		REAL4 40.0
CntY 		dd 0
PntX1 		dd 0
PntY1 		dd 0
PntX2 		dd 0
PntY2 		dd 0
Ang 		dd 0


.data?
hmainDC 	dd			?
hmainbmp 	dd			?
hdc			HDC 		?
txtRct		RECT		<?>
ps			PAINTSTRUCT	<?>
lb 			LOGBRUSH 	<?>
lb1 		LOGBRUSH 	<?>
lb2 		LOGBRUSH 	<?>
hFont2		dd			?
FadeUp		BOOL		?
FadeDown	BOOL		?


.code

Orbit	proc
		finit
		;PntX1 = CntX - (Sin(Angle * DEG) * Radius) 
		fild [Angle]
		fmul [DEG]
		fsin
		fstp dword ptr [tempX]
		fld CntX
		fld Radius	;distance
		fmul dword ptr [tempX]
		fsubp st(1), st
		fistp dword ptr[PntX1]	;X1
		;PntY1 = CntY - (Cos(Angle * DEG) * (Radius / Ratio))
		fild [Angle]
		fmul [DEG]
		fcos
		fstp dword ptr [tempX]
		fild CntY
		fld Radius	;distance
		fdiv dword ptr[Ratio]
		fmul dword ptr [tempX]
		fsubp st(1), st
		fistp dword ptr[PntY1]	;Y1
		; PntX2 = CntX - (Sin((Angle + 180) * DEG) * Radius)
		fild [Angle]
		fadd [AngleOffs]
		fmul [DEG]
		fsin
		fstp [tempX]
		fld CntX
		fld Radius	;distance
		fmul dword ptr [tempX]
		fsubp st(1), st
		fistp dword ptr[PntX2]	;X2
		;PntY2 = CntY - (Cos((Angle + 180) * DEG) * (Radius / Ratio))
		fild [Angle]
		fadd [AngleOffs]
		fmul [DEG]
		fcos
		fstp [tempX]
		fild CntY
		fld Radius	;distance
		fdiv dword ptr[Ratio]
		fmul dword ptr [tempX]
		fsubp st(1), st
		fistp dword ptr[PntY2]	;Y2
		ret
Orbit	endp



;***************************************************************************************
; Basic Dialog Box Proc
;***************************************************************************************
AbtDialogProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local sBtnText[10h]:TCHAR ; for WM_DRAWITEM
	local i:dword

		.if uMsg == WM_INITDIALOG
			;//colors for DNA Strand
			invoke CreateFont, 10, 6, 0, 0, 0, 0, 0, 0, OEM_CHARSET, 0, 0, 0, 0, SADD("Arial") 
			mov hFont2, eax
			mov lb1.lbStyle, BS_SOLID
			mov lb1.lbColor, 255 ; Red
			mov lb1.lbHatch, NULL

			invoke CreateBrushIndirect, addr lb1
			mov hColDot1, eax
			mov lb1.lbStyle, BS_SOLID
			mov lb1.lbColor, Yellow ; Yellow
			mov lb1.lbHatch, NULL

			invoke CreateBrushIndirect, addr lb1
			mov hColDot2, eax

			invoke SetTimer, hWnd, 1, 10, NULL
			invoke SetTimer, hWnd, 2, 50, NULL
			invoke SetTimer, hWnd, 3, 50, NULL

			invoke GetDC, hWnd
			mov hdc, eax

			mov esi, PictureW
			mov edi, PictureH

			invoke CreateCompatibleDC, hdc
			mov hmainDC, eax
			invoke CreateCompatibleBitmap, hdc, esi, edi
			mov hmainbmp, eax
			invoke SelectObject, hmainDC, eax
			invoke ReleaseDC, hWnd, hdc

			mov	MADE, FALSE
			mov	Ang, 0

			;subclass buttons
			mov ebx, IDC_ABT_FORUM
		@@:
			invoke GetDlgItem, hWnd, EBX
			push eax
			invoke 	SendMessage, eax, WM_SETFONT, hFont, 0
			pop	eax
			invoke SetWindowLong, eax, GWL_WNDPROC, addr BtnProc
			mov	OldBtnProc, eax
			inc	ebx
			cmp	ebx, IDC_ABT_X
			jle	@b


		.elseif uMsg == WM_CTLCOLORDLG
			mov eax, hBgColor
			ret

		.elseif uMsg == WM_CTLCOLORSTATIC
			invoke SelectObject, wParam, hTitleFont
			invoke SetTextColor, wParam, CR_INTEXT_SCHEME
			invoke SetBkMode, wParam, TRANSPARENT
			invoke SetBkColor, wParam, CR_BG_SCHEME
			mov eax, hBgColor

		.elseif uMsg == WM_DRAWITEM
			push esi
			mov esi, lParam
			assume esi:ptr DRAWITEMSTRUCT

			invoke SelectObject, [esi].hdc, hBtnNormColor
			invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME
			invoke GetCursorPos, addr hitpoint
			invoke GetWindowRect, [esi].hwndItem, addr CloseBtnRct
			invoke PtInRect, addr CloseBtnRct, hitpoint.x, hitpoint.y

			.if eax	;hover
				invoke SelectObject, [esi].hdc, hBtnColor
				invoke SetTextColor, [esi].hdc, CR_HOVERTEXT_SCHEME
				invoke SelectObject, [esi].hdc, hEdgeHover
			.else
				.if [esi].itemState & ODS_DISABLED
					invoke SelectObject, [esi].hdc, hBtnColor
					invoke SetTextColor, [esi].hdc, CR_TEXT_SCHEME
				.else
					invoke SelectObject, [esi].hdc, hBtnNormColor
					invoke SetTextColor, [esi].hdc, CR_NORMTEXT_SCHEME
					invoke SelectObject, [esi].hdc, hEdge
				.endif
			.endif
			invoke FillRect, [esi].hdc, addr [esi].rcItem, hBtnColor
			invoke Rectangle, [esi].hdc, [esi].rcItem.left, [esi].rcItem.top, [esi].rcItem.right, [esi].rcItem.bottom

			; write the text
			invoke GetDlgItemText, hWnd, [esi].CtlID, addr sBtnText, SIZEOF sBtnText
			invoke SetBkMode, [esi].hdc, TRANSPARENT
			invoke DrawText, [esi].hdc, addr sBtnText, -1, addr [esi].rcItem, DT_CENTER or DT_VCENTER or DT_SINGLELINE

			.if [esi].itemState & ODS_SELECTED
				invoke OffsetRect, addr [esi].rcItem, -1, -1
			.endif

			; change the position of the text
			.if [esi].itemState & ODS_FOCUS
				invoke InflateRect, addr [esi].rcItem, -4, -4
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
			.if eax == IDC_ABT_WEB
				invoke ShellExecute, NULL, offset _open, offset wwweb, NULL, NULL, SW_MAXIMIZE ;web site
			.elseif eax == IDC_ABT_FORUM
				invoke ShellExecute, NULL, offset _open, offset wwforum, NULL, NULL, SW_MAXIMIZE ;forum
		 	.elseif eax == IDC_ABT_X || eax == IDC_ABT_CLOSE
				invoke SendMessage, hWnd, WM_CLOSE, 0, 0
		 	.endif


		 .elseif uMsg == WM_TIMER
			.if	wParam == 1
				invoke RedrawWindow, hWnd, addr MyRect, 0, RDW_INVALIDATE
			.endif
			.if	wParam == 2
				.if x == 98 || x2 == 82 || x2 == 0FFFFFFAEh ;|| x2 == 0FFFFFF16h
					.if haltsec < 120
						mov tHalt, TRUE
						inc	haltsec
					.else
						mov haltsec, 0
						mov tHalt, FALSE
						dec x
					.endif
				.else
					.if	x == 0FFFFFD96h
						mov	x, 20
					.endif
					dec	x
				.endif
			.endif
			.if	wParam == 3	;color transition
				.if	txtMul10 > 62
					mov	FadeUp, FALSE
				.endif
				.if	txtMul10 == 0
					mov	FadeUp, TRUE
				.endif
				.if	FadeUp==TRUE
					inc	txtMul10
				.else
					dec	txtMul10
				.endif
				
				mov	eax, txtMul10
				imul eax, 3
				add	eax, 10
				push eax
				push CR_HOVERTEXT_SCHEME
				call ColorShift
				;mov	edx, 255
				;sub	edx, eax
				;mov	al, 255
				;mov	ah, dl
				mov	ScrollCol1, eax
			.endif


		.elseif uMsg == WM_PAINT
			invoke BeginPaint, hWnd, addr ps
			mov hdc, eax
			invoke FillRect, hmainDC, addr MyRect, hBgColor
			invoke Sleep, 20
			;Rotation;
			add	Ang, 5
			mov	i, 0
			
		@@:	
			mov	eax, i
			imul	eax, 8 	;Deg offset
			mov	ebx, Ang
			add	ebx, eax
			mov	Angle, ebx
			mov	ebx, 40	;distance from top
			mov	eax, i
			imul	eax, 10	;distance apart
			add	ebx, eax
			mov	CntY, ebx
			
			call Orbit
			invoke SelectObject, hmainDC, hColDot1			
			mov	eax, PntX1
			add	eax, 6
			mov	ebx, PntY1
			add	ebx, 6
			Invoke Ellipse, hmainDC, PntX1, PntY1, eax, ebx
			invoke SelectObject, hmainDC, hColDot2
			mov	eax, PntX2
			add	eax, 6
			mov	ebx, PntY2
			add	ebx, 6
			Invoke Ellipse, hmainDC, PntX2, PntY2, eax, ebx

			;---------------------------------
			; Draw linesbetween the circles
			;---------------------------------
			mov	eax, i
			imul eax, 12
			mov	edx, 255
			sub	edx, eax
			shl eax, 16
			mov	al, dl
			; RGB edx, 0, eax
			mov lb.lbStyle, BS_SOLID
			mov lb.lbColor, eax
			mov lb.lbHatch, 0
			invoke ExtCreatePen, PS_SOLID or PS_GEOMETRIC or PS_ENDCAP_ROUND or PS_JOIN_ROUND, 1, addr lb, 0, 0
			mov hPen, eax 
		 
			invoke SelectObject, hmainDC, eax
			mov	eax, PntY1
			add	eax, 2	;fix up ellipse size 
			invoke MoveToEx, hmainDC, PntX1, eax, 0
			mov	edx, PntY2
			add	edx, 2	;fix up ellipse size 
			invoke LineTo, hmainDC, PntX2, edx
			invoke DeleteObject, hPen
			inc i
			cmp i, 18	;number of strands
			jne	@b

			mov txtRct.left, 20
			mov	txtRct.right, PictureW
			mov	txtRct.bottom, PictureH-20
			invoke SelectObject, hmainDC, hFont2
			invoke SetBkMode, hmainDC, TRANSPARENT
			invoke SetTextColor, hmainDC, ScrollCol1

			mov	eax, x
			add	eax, 120
			mov	x2, eax
			mov	txtRct.top, eax
			invoke	DrawText, hmainDC, addr sAboutText, sLogoSize, addr txtRct, DT_CENTER
			invoke BitBlt, hdc, 0, 0, PictureW, PictureH, hmainDC, 0, 0, SRCCOPY
			;Add the text out :)
			invoke EndPaint, hWnd, addr ps


		.elseif uMsg == WM_CLOSE
			invoke KillTimer, hWnd, 1
		 	invoke KillTimer, hWnd, 2
		 	invoke KillTimer, hWnd, 3
		 	invoke DeleteObject, hColDot1
		 	invoke DeleteObject, hColDot2
		 	invoke DeleteDC, hmainDC
		 	invoke DeleteObject, hmainbmp
			invoke DeleteObject, hFont2
			invoke EndDialog, hWnd, 0

		.endif

		xor eax, eax
		ret
AbtDialogProc endp
