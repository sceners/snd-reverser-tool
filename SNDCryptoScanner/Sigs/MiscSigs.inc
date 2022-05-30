
.data

;****************************************************************************************************************************************************

BASE32_Name				db 	"Base32 Alphabet", 0
BASE32_Details			db	"Basic Reversible Encoding Scheme", 0
BASE32_DS				db	"ABCDEFGHIJKLMNOPQRSTUVWXYZ234567", 0
BASE32_SigLength		equ ($ - BASE32_DS) - 1
BASE32_FoundBool		dd	00h
BASE32_FoundOffsets		dd	00000000h

SIG_BASE32				SIG_DATA <offset BASE32_Name, offset BASE32_Details, offset BASE32_DS, BASE32_SigLength, offset SearchEngine_BYTES, offset BASE32_FoundBool, offset BASE32_FoundOffsets>

;****************************************************************************************************************************************************

BASE64_Name				db 	"Base64 Alphabet", 0
BASE64_Details			db	"Basic Reversible Encoding Scheme", 0
BASE64_DS				db	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", 0
BASE64_SigLength		equ ($ - BASE64_DS) - 1
BASE64_FoundBool		dd	00h
BASE64_FoundOffsets		dd	00000000h

SIG_BASE64				SIG_DATA <offset BASE64_Name, offset BASE64_Details, offset BASE64_DS, BASE64_SigLength, offset SearchEngine_BYTES, offset BASE64_FoundBool, offset BASE64_FoundOffsets>

;****************************************************************************************************************************************************

BASE64FG_Name			db 	"Base64 Alphabet (FGInt Implementation)", 0
BASE64FG_Details		db	"Basic Reversible Encoding Scheme (FGInt)", 0
BASE64FG_DS				db	"aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789+=", 0
BASE64FG_SigLength		equ ($ - BASE64FG_DS) - 1
BASE64FG_FoundBool		dd	00h
BASE64FG_FoundOffsets	dd	00000000h

SIG_BASE64FG			SIG_DATA <offset BASE64FG_Name, offset BASE64FG_Details, offset BASE64FG_DS, BASE64FG_SigLength, offset SearchEngine_BYTES, offset BASE64FG_FoundBool, offset BASE64FG_FoundOffsets>

;****************************************************************************************************************************************************

BASE64VB_Name			db 	"Base64 Alphabet (Unicode/VB)", 0
BASE64VB_Details		db	"Basic Reversible Encoding Scheme", 0
BASE64VB_DS	 			db	41h, 00h, 42h, 00h, 43h, 00h, 44h, 00h, 45h, 00h, 46h, 00h, 47h, 00h, 48h, 00h
						db	49h, 00h, 4Ah, 00h, 4Bh, 00h, 4Ch, 00h, 4Dh, 00h, 4Eh, 00h, 4Fh, 00h, 50h, 00h
						db	51h, 00h, 52h, 00h, 53h, 00h, 54h, 00h, 55h, 00h, 56h, 00h, 57h, 00h, 58h, 00h
						db	59h, 00h, 5Ah, 00h, 61h, 00h, 62h, 00h, 63h, 00h, 64h, 00h, 65h, 00h, 66h, 00h
						db	67h, 00h, 68h, 00h, 69h, 00h, 6Ah, 00h, 6Bh, 00h, 6Ch, 00h, 6Dh, 00h, 6Eh, 00h
						db	6Fh, 00h, 70h, 00h, 71h, 00h, 72h, 00h, 73h, 00h, 74h, 00h, 75h, 00h, 76h, 00h
						db	77h, 00h, 78h, 00h, 79h, 00h, 7Ah, 00h, 30h, 00h, 31h, 00h, 32h, 00h, 33h, 00h
						db	34h, 00h, 35h, 00h, 36h, 00h, 37h, 00h, 38h, 00h, 39h, 00h, 2Bh, 00h, 2Fh, 0
BASE64VB_SigLength		equ ($ - BASE64VB_DS) - 1
BASE64VB_FoundBool		dd	00h
BASE64VB_FoundOffsets	dd	00000000h

SIG_BASE64VB			SIG_DATA <offset BASE64VB_Name, offset BASE64VB_Details, offset BASE64VB_DS, BASE64VB_SigLength, offset SearchEngine_BYTES, offset BASE64VB_FoundBool, offset BASE64VB_FoundOffsets>

;****************************************************************************************************************************************************
