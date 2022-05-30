
;***************************************************************************************
; PROTOS
;***************************************************************************************
;---------------------------------------------------------------------------------
;proto the proc's in main.asm
;---------------------------------------------------------------------------------
DialogProc 					proto :HWND, :UINT, :WPARAM, :LPARAM
AbtDialogProc 				proto :HWND, :UINT, :WPARAM, :LPARAM
callRTFunction 				proto :HWND
Copy 						proto :HWND

;---------------------------------------------------------------------------------
;proto the proc's in the various functions
;---------------------------------------------------------------------------------
MemoDialogProc 				proto :HWND, :UINT, :WPARAM, :LPARAM
ScanDialogProc 				proto :HWND, :UINT, :WPARAM, :LPARAM
EnumDialogProc 				proto :HWND, :UINT, :WPARAM, :LPARAM
CalcDialogProc 				proto :HWND, :UINT, :WPARAM, :LPARAM
BruteDialogProc 			proto :HWND, :UINT, :WPARAM, :LPARAM
ModifyDialogProc 			proto :HWND, :UINT, :WPARAM, :LPARAM

;---------------------------------------------------------------------------------
;proto the proc's in menusNbuttons.asm
;---------------------------------------------------------------------------------
EditProc 					proto :HWND, :UINT, :WPARAM, :LPARAM
BtnProc 					proto :HWND, :UINT, :WPARAM, :LPARAM
ComboProc 	 				proto :HWND, :UINT, :WPARAM, :LPARAM
BruteHashComboProc			proto :HWND, :UINT, :WPARAM, :LPARAM
EditProcHex					proto :HWND, :UINT, :WPARAM, :LPARAM
EnableDlgItem 				proto :HWND, :dword, :BOOL
EnableBtns					proto :HWND
DisableBtns					proto :HWND
ColorShift					proto :dword, :dword

;---------------------------------------------------------------------------------
; proto the procs in release.asm
;---------------------------------------------------------------------------------
Initialize 					proto :HWND
Generate 					proto :HWND
Copy 						proto :HWND



;***************************************************************************************
; MACROS
;***************************************************************************************

HexLen	macro
	xor	edx, edx
	mov	ecx, 2
	idiv ecx
endm

DecLen	macro
	xor	edx, edx
	mov	ecx, 3
	idiv ecx
endm


;***************************************************************************************
; resource identifiers
;***************************************************************************************
;---------------------------------------------------------------------------------
;-->DIALOGS
;---------------------------------------------------------------------------------
IDI_MAIN					equ 100
IDD_MAIN 					equ 200
IDD_ABOUT					equ 201
IDD_SCAN					equ 202
IDD_ENUM					equ 203
IDD_CALC					equ 204
IDD_MEMO					equ 205
IDD_BRUTE					equ 206
IDD_BRUTE_HELP				equ 207
IDD_MODIFY					equ 208

IDC_BUTTONAREA 				equ 399
IDC_TITLEBAR 				equ 400
IDC_TITLE 					equ 401
IDC_LOGOAREA 				equ 403

;---------------------------------------------------------------------------------
;--> TEXTS
;---------------------------------------------------------------------------------
IDC_KEY						equ 425
IDC_INPUT 					equ 404
IDC_OUTPUT 					equ 405
IDC_INFO 					equ 600

;---------------------------------------------------------------------------------
;--> BUTTONS
;---------------------------------------------------------------------------------
IDC_SETTINGS				equ 406
IDC_COPY 					equ 407
IDC_EXIT 					equ 408
IDC_ABOUT 					equ 409
IDC_SWAP 					equ 410
IDC_CLOSE 					equ 411
IDC_CLEAR 					equ 412
IDC_MIN						equ 413 
IDC_OPTIONS					equ 414
IDC_TOOLS					equ 415


;---------------------------------------------------------------------------------
;--> MENUS
;---------------------------------------------------------------------------------
IDM_TOOLS					equ 150
IDM_SETTINGS				equ 151
IDM_COLSCHEME				equ 152
IDM_OPTIONS					equ 153
IDM_INOUTOPTS				equ 154
IDM_ENCOPTS					equ 155
IDM_ENCMODE					equ 156
IDM_AUTOSTRIP				equ 158
IDM_TRAY					equ 157
IDM_TRANS					equ 622
IDM_ONTOP					equ 510
IDM_TRAYM					equ 520
IDM_SCHEME1					equ 531
IDM_SCHEME2					equ 532
IDM_SCHEME3					equ 533
IDM_SCHEME4					equ 534
IDM_SCHEME5					equ 535
IDM_SCAN					equ 550
IDM_ENUM					equ 551
IDM_CALC					equ 552
IDM_MEMO					equ 553
IDM_BRUTE					equ 554
IDM_MODIFY					equ 555
IDM_QUICKTITLE				equ 601
IDM_RIAH					equ 611
IDM_RKAH					equ 612
IDM_DOAH					equ 613
IDM_DOUP					equ 614
IDM_DOIF					equ 615
IDM_BSI						equ 621
IDM_BSK						equ 622
IDM_PI						equ 623
IDM_EBC						equ 631
IDM_CBC						equ 632
IDM_SNOTHING				equ 641
IDM_SSPACES					equ 642
IDM_SNONHEX					equ 643
IDM_SNONALPHA				equ 644
IDM_RESTORE					equ 690
IDM_EXIT					equ 691

;---------------------------------------------------------------------------------
;--> STATICS
;---------------------------------------------------------------------------------
IDS_LENGTH					equ 700
IDM_KEYGEN 					equ 500

;---------------------------------------------------------------------------------
;--> COMBOBOX
;---------------------------------------------------------------------------------
IDC_FUNCTION 				equ 420

;---------------------------------------------------------------------------------
;--> TRAY
;---------------------------------------------------------------------------------
WM_SHELLNOTIFY 				equ WM_USER+5
IDI_TRAY 					equ 0


;***************************************************************************************
;Define the Colour schemes
;***************************************************************************************
;---------------------------------------------------------------------------------
; colors scheme #1 - Grey and Orange - Dark
;---------------------------------------------------------------------------------
CR_BG1 						equ 0222222h
CR_BTNDOWN1 				equ 0444444h
CR_TEXT1 					equ 0999999h
CR_MIDDLE1 					equ 0e1e1e1h
CR_INBG1 					equ CR_BG1
CR_INTEXT1 					equ 0aaaaaah
CR_RECT1	 				equ CR_BG1
CR_EDITBG1 					equ 0444444h
CR_HOVERTEXT1 				equ 00087ffh
CR_NORMTEXT1 				equ 01e74cbh
CR_HOVEREDGE1				equ CR_TEXT1
CR_BTNNORM1					equ CR_BG1 

;---------------------------------------------------------------------------------
; colors scheme #2 - White and Light Blue - Light
;---------------------------------------------------------------------------------
CR_BG2 						equ White
CR_BTNDOWN2 				equ 0f4e9c9h
CR_TEXT2 					equ 0996600h
CR_MIDDLE2 					equ 0000000h
CR_INBG2 					equ 0fcf8eah
CR_INTEXT2 					equ CR_TEXT2
CR_RECT2					equ 0dfc47bh
CR_EDITBG2 					equ 0fbf7ech
CR_HOVERTEXT2 				equ 0663300h
CR_NORMTEXT2 				equ CR_TEXT2
CR_HOVEREDGE2				equ 0d5ccb1h
CR_BTNNORM2					equ CR_INBG2

;---------------------------------------------------------------------------------
; colors scheme #3 - Navy Blue - Middle
;---------------------------------------------------------------------------------
CR_BG3 						equ 0514638h
CR_BTNDOWN3 				equ 0908577h
CR_TEXT3 					equ 0aaaaaah
CR_MIDDLE3 					equ 0000000h
CR_INBG3 					equ 04b4133h
CR_INTEXT3 					equ CR_TEXT3
CR_RECT3					equ 0999999h
CR_EDITBG3 					equ 04b4133h
CR_HOVERTEXT3 				equ 0403a32h
CR_NORMTEXT3 				equ 0c2c1beh
CR_HOVEREDGE3				equ 0eeedeah
CR_BTNNORM3					equ 0403a32h

;---------------------------------------------------------------------------------
; colors scheme #4 - Deep Red - Middle
;---------------------------------------------------------------------------------
CR_BG4 						equ 0000045h
CR_BTNDOWN4 				equ 07785aah
CR_TEXT4 					equ 0aaaaaah
CR_MIDDLE4 					equ 0000000h
CR_INBG4 					equ 0334190h
CR_INTEXT4 					equ CR_TEXT4
CR_RECT4	 				equ CR_BG4
CR_EDITBG4 					equ CR_INBG4
CR_HOVERTEXT4 				equ 0323a40h
CR_NORMTEXT4 				equ 0bec1c2h
CR_HOVEREDGE4				equ 0ddddeeh
CR_BTNNORM4					equ CR_BG4 


;***************************************************************************************
;MENU Struct
;***************************************************************************************
;MENUINFO STRUCT
;	cbSize					dd ?
;	fMask					dd ?
;	dwStyle					dd ?
;	cyMax					dd ?
;	hbrBack					HBRUSH ?
;	dwContextHelpID			dd ?
;	dwMenuData				dd ?
;MENUINFO ENDS


; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


.data

;***************************************************************************************
;Define 'ABOUT' Information
;***************************************************************************************
sTeam 						TCHAR "SND TEAM", 0
sSoftware 					TCHAR "SND Reverser Tool 1.5b1", 0
uSize						dd 60h

sAboutText					db 0dh, 0ah, 0dh, 0ah
							db 'SND Reverser Tool 1.5b1', 0dh, 0ah
							db 'Code by Loki and PuNkDuDe', 0dh, 0ah
							db 0dh, 0ah
							db 'Release date - xx.xx.2008', 0dh, 0ah		
							db 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah
							db 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah
							db 'Greetz fly out to....', 0dh, 0ah
							db 'ArTeam, CracksLatinoS, Fixdown, ', 0dh, 0ah
							db 'REVENGE Crew, TSRh, Unpack.CN', 0dh, 0ah
							db 'ICU, CUG, RES, CiM, VDown, MP2k', 0dh, 0ah
							db 'China Serials2K and AstaLaVista.', 0dh, 0ah
							db 0dh, 0ah
							db 'Also to; syk071c, Ufo-Pu55y, HVC, Till.ch', 0dh, 0ah
							db 'Cektop, Ziggy, lena151, Ecliptic, Sonny27', 0dh, 0ah
							db 'Teddy Rogers, Fungus, Killboy, Encrypto', 0dh, 0ah
							db 'quosego, MiTEstARK, SuperCRacker, willie', 0dh, 0ah
							db 'Bone Enterprise, Zer0burn, Xes, The Riddler', 0dh, 0ah
							db '3ck5u6, LoL and YOU for using the tool!', 0dh, 0ah
							db 0dh, 0ah
							db 'Special thanks to Drizz for crpytolib', 0dh, 0ah
							db 'and to WiteG for many crypto sources.', 0dh, 0ah, 0dh, 0ah
							db 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah
							db 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah, 0dh, 0ah
							db 'Seek n Destroy 2008', 0dh, 0ah
							db 'Visit us : http://snd.astalavista.ms', 0dh, 0ah
							db 'For Bugs and Feedback visit the forum.', 0

sLogoSize					equ $-1 - offset sAboutText

;***************************************************************************************
; Dialog variables
;***************************************************************************************
tiClass 					db 'Tooltips_class32', 0
testicle					db 'Testing', 0 
hWindow						dd 0
RsrcName 					db "RANGE", 0
RsrcType 					db "RGN", 0 
Font						db 'Verdana', 0
ExitBtnRct					RECT <151, 158, (148+60), (158+14)>
MoveDlg						BOOL 0	; determine if dialog moves with mouse move


;***************************************************************************************
;Define formatting parameters
;***************************************************************************************
hex8bit						db '%.2X', 0
hex16bit					db '%.4X', 0
hex32bit					db '%.8X', 0
hex64bit					db '%.8X%.8X', 0
hex8bitlc					db '%.2x', 0
hex16bitlc					db '%.4x', 0
hex32bitlc					db '%.8x', 0
hexFormat					db '%x', 0
hexFormatU					db '%X', 0
strFormat					db '%s', 0
charFormat					db '%c', 0
decFormat					db '%d', 0
strleng						db 'Output Length : %lu bytes / %lu bits', 0
hex256bit					db '%.8x%.8x%.8x%.8x', 0
hex192bit					db '%.8x%.8x%.8x', 0
sFormat_2 					db '%.8x%.8x', 0


;***************************************************************************************
; error messages
;***************************************************************************************
sErrorMsgNull				db "Please provide some input for this function.", 0
sErrorMsg8Len 				db "Length needs to be in multipes of 8.", 0
sErrorKey32Chr 				db "The key must be 32 characters long", 0
sErrorKey64Chr 				db "The key must be 64 characters long", 0
sErrorMsgHex 				db "Input contains invalid chars 0-9, A-F, a-f only.", 0
sErrorHexLen 				db "Please provide some input for this function, length is multiple of 2.", 0
sErrorDecLen 				db "Please provide some input for this function, length is multiple of 3.", 0
sErrorMaxLen 				db "Sorry, the length of the input exceeds the maximum size for this function.", 0
sErrorLen110 				db "The length of the key must be between 1 and 10 bytes.", 0
sErrorLen116 				db "The length of the key must be between 1 and 16 bytes.", 0
sErrorLen132 				db "The length of the key must be between 1 and 32 bytes.", 0
sErrorLen1128 				db "The length of the key must be between 1 and 128 bytes.", 0
sErrorLen464 				db "The length of the key must be between 4 and 56.", 0
sError64b					db "Please provide some input for this function, length is multiple of 64-bits.", 0
sError128b 					db "Please provide some input for this function, length is multiple of 128-bits.", 0
ErrorSelectFunction			db "Please select a function from the drop down box.", 0
ErrorHavalRounds			db "Error : Enter the number of rounds (3, 4 or 5) into the key box.", 0
ErrorSNEFRURounds			db "Error : Enter the number of rounds (4 or 8) into the key box.", 0


;***************************************************************************************
; stored color scheme variables
;***************************************************************************************
MyScheme					dd 0
CR_BG_SCHEME				dd 0
CR_BTNDOWN_SCHEME 			dd 0
CR_BTNNORM_SCHEME			dd 0
CR_TEXT_SCHEME 				dd 0
CR_MIDDLE_SCHEME 			dd 0
CR_INBG_SCHEME 				dd 0
CR_INTEXT_SCHEME 			dd 0
CR_RECT_SCHEME	 			dd 0
CR_EDITBG_SCHEME			dd 0
CR_HOVERTEXT_SCHEME 		dd 0
CR_NORMTEXT_SCHEME 			dd 0
CR_DOWNTEXT_SCHEME 			dd 0
CR_HOVEREDGE_SCHEME			dd 0
CR_DOWNEDGE_SCHEME			dd 0
CR_BTNOVER_SCHEME			dd 0


;***************************************************************************************
;-->  MENU SETTINGS
;***************************************************************************************
bTrayIcon					BOOL 0
bOnTop						BOOL 0
bStripSpaces				BOOL 0
bStripNonHex				BOOL 0
bStripNonAlpha				BOOL 0
bInputAsHex					BOOL 0
bKeyAsHex					BOOL 0
bOutputAsHex				BOOL 0
bOutputInUppercase			BOOL 0
bOutputIfUnicode			BOOL 0
bBswapInput					BOOL 0
bBswapKey					BOOL 0
bPadInput					BOOL 0
bCipherMode					BOOL 0


; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


.data?

;***************************************************************************************
;Define input, output and other buffers
;***************************************************************************************
sInput						CHAR 1024 dup(?)
sOutput						CHAR 2048 dup(?)
sKeyIn						CHAR 256 dup(?)
sTempBuf					CHAR 1024 dup(?)
rnd32_seed					dd ?


hFont						dd ?
mnuItem						MENUITEMINFO <?>
mnuMain						MENUINFO <?>
RsrcHand 					dd ?
RsrcSize 					dd ?
RsrcPoint 					dd ?
hInstance 					HINSTANCE ?

OldEditProc 				WNDPROC ?
OldBtnProc					WNDPROC ?
OldComboProc				WNDPROC ?
hEdgeBg						HPEN ?
hEditBgColor				HBRUSH ?
hBgColor 					HBRUSH ?
hBtnOver					HBRUSH ?
hBtnColor 					HBRUSH ?
hMiddleColor 				HBRUSH ?
hInbgColor 					HBRUSH ?
hMnuColor					HBRUSH ?
hEdgeDown					HPEN ?
hEdge 						HPEN ?
hEdgeHover					HPEN ?
hWindowDC					dd ?
hComboSelect				dd ?
hBtnNormColor				HBRUSH ?

hMenuSettings				HWND ?
hMenuColScheme				HWND ?
hMenuTray					HWND ?
hMenuOptions				HWND ?
hMenuAutoStrip				HWND ?
hMenuInOutOpts				HWND ?
hMenuEncOpts				HWND ?
hMenuEncMode				HWND ?
hMenuTools					HWND ?

mnuSettings					HWND ?
mnuColScheme				HWND ?
mnuTray						HWND ?
mnuOptions					HWND ?
mnuAutoStrip				HWND ?
mnuInOutOpts				HWND ?
mnuEncOpts					HWND ?
mnuEncMode					HWND ?
mnuTools					HWND ?

TitleFont 					LOGFONT <?>
hTitleFont 					HFONT ?

WndRect 					RECT <?>
OptBtnRect	 				RECT <?>
DlgRect		 				RECT <?>

hWndRgn 					HRGN ?
hIcon						dd ?
MainProc					dd ?
hitpoint					POINT <>
OldPos						POINT <>
NewPos						POINT <>
CloseBtnRct					RECT <?>
GenBtnRct					RECT <?>
CopyBtnRct					RECT <?>

hScanStop					dd ?
ScanFinished				dd ?

;--> SETTINGS
bAnimateWin					BOOL ?
bChangeFont					BOOL ?
hCur						dd ?
hover						BOOL ?
CommandLine					dd ?
hToolTip					dd ?
iSizeVersion				dd ?
sTempA						db 256 dup(?)
sTempB						db 256 dup(?)
note 						NOTIFYICONDATA <>
