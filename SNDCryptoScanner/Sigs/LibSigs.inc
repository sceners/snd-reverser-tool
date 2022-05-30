
.data

;****************************************************************************************************************************************************

MIRACL_Name				db 	"MIRACL", 0
MIRACL_Details			db	"C++ Big Number Library - Possible RSA?", 0
MIRACL_DS				db	08Bh, 086h, 0D4h, 001h, 000h, 000h, 08Bh, 04Eh, 018h, 0C7h, 086h, 080h, 000h, 000h
						db	000h, 001h, 000h, 000h, 000h, 08Bh, 000h, 083h, 0C4h, 00Ch, 025h, 0FFh, 0FFh, 0FFh
						db	07Fh, 08Bh, 0D0h, 081h, 0E2h, 0FFh, 0FFh, 000h, 000h, 03Bh, 0D1h, 0
MIRACL_SigLength		equ ($ - MIRACL_DS) - 1
MIRACL_FoundBool		dd	00h
MIRACL_FoundOffsets		dd	00000000h

SIG_MIRACL				SIG_DATA <offset MIRACL_Name, offset MIRACL_Details, offset MIRACL_DS, MIRACL_SigLength, offset SearchEngine_BYTES, offset MIRACL_FoundBool, offset MIRACL_FoundOffsets>

;****************************************************************************************************************************************************

BIGLIB_Name				db 	"Biglib", 0
BIGLIB_Details			db	"ASM Big Number Library by Roy - Possible RSA?", 0
BIGLIB_DS				db	00Fh, 0A3h, 04Eh, 004h, 00Fh, 092h, 0C0h, 008h, 047h, 004h, 08Bh, 055h, 00Ch, 08Bh
						db	01Ah, 039h, 01Fh, 0
BIGLIB_SigLength		equ ($ - BIGLIB_DS) - 1
BIGLIB_FoundBool		dd	00h
BIGLIB_FoundOffsets		dd	00000000h

SIG_BIGLIB				SIG_DATA <offset BIGLIB_Name, offset BIGLIB_Details, offset BIGLIB_DS, BIGLIB_SigLength, offset SearchEngine_BYTES, offset BIGLIB_FoundBool, offset BIGLIB_FoundOffsets>

;****************************************************************************************************************************************************

BIGLIBCREATE_Name		db 	"BigCreate", 0
BIGLIBCREATE_Details	db	"ASM Big Number Library by Roy - Possible RSA?", 0
BIGLIBCREATE_DS			db 	51h, 57h, 56h, 6ah, 04h, 68h, 00h, 10h, 00h, 00h, 6ah, 54h, 6ah, 00h, 0e8h, 30h
						db	11h, 00h, 00, 8bh, 4dh, 08h, 85h, 0c9h, 74h, 09h, 0
BIGLIBCREATE_SigLength	equ ($ - BIGLIBCREATE_DS) - 1
BIGLIBCREATE_FoundBool	dd	00h
BIGLIBCREATE_FO			dd	00000000h

SIG_BIGLIBCREATE		SIG_DATA <offset BIGLIBCREATE_Name, offset BIGLIBCREATE_Details, offset BIGLIBCREATE_DS, BIGLIBCREATE_SigLength, offset SearchEngine_BYTES, offset BIGLIBCREATE_FoundBool, offset BIGLIBCREATE_FO>

;****************************************************************************************************************************************************

BIGLIBDESTROY_Name		db 	"BigDestroy", 0
BIGLIBDESTROY_Details	db	"ASM Big Number Library by Roy - Possible RSA?", 0
BIGLIBDESTROY_DS		db 	51h, 57h, 56h, 68h, 00h, 80h, 00h, 00h, 6ah, 00h, 0ffh, 75h, 08h, 0e8h, 0ah, 11h
						db	00h, 00h, 0
BIGLIBDESTROY_SigLength	equ ($ - BIGLIBDESTROY_DS) - 1
BIGLIBDESTROY_FoundBool	dd	00h
BIGLIBDESTROY_FO		dd	00000000h

SIG_BIGLIBDESTROY		SIG_DATA <offset BIGLIBDESTROY_Name, offset BIGLIBDESTROY_Details, offset BIGLIBDESTROY_DS, BIGLIBDESTROY_SigLength, offset SearchEngine_BYTES, offset BIGLIBDESTROY_FoundBool, offset BIGLIBDESTROY_FO>

;****************************************************************************************************************************************************

FGINT_Name				db 	"FGInt", 0
FGINT_Details			db	"Delphi Big Number Library - Possible RSA?", 0
FGINT_DS				db	"FGInt", 0, 0
FGINT_SigLength			equ ($ - FGINT_DS) - 1
FGINT_FoundBool			dd	00h
FGINT_FoundOffsets		dd	00000000h

SIG_FGINT				SIG_DATA <offset FGINT_Name, offset FGINT_Details, offset FGINT_DS, FGINT_SigLength, offset SearchEngine_BYTES, offset FGINT_FoundBool, offset FGINT_FoundOffsets>

;****************************************************************************************************************************************************

FGINTRSA_Name			db 	"FGInt (Delphi RSA)", 0
FGINTRSA_Details		db	"Delphi Big Number Library - Possible RSA?", 0
FGINTRSA_DS				db	"FGIntRSA", 0, 0
FGINTRSA_SigLength		equ ($ - FGINTRSA_DS) - 1
FGINTRSA_FoundBool		dd	00h
FGINTRSA_FoundOffsets	dd	00000000h

SIG_FGINTRSA			SIG_DATA <offset FGINTRSA_Name, offset FGINTRSA_Details, offset FGINTRSA_DS, FGINTRSA_SigLength, offset SearchEngine_BYTES, offset FGINTRSA_FoundBool, offset FGINTRSA_FoundOffsets>

;****************************************************************************************************************************************************

FGINTDSA_Name			db 	"FGInt (Delphi DSA)", 0
FGINTDSA_Details		db	"Delphi Big Number Library - Possible RSA?", 0
FGINTDSA_DS				db	"FGIntDSA", 0, 0
FGINTDSA_SigLength		equ ($ - FGINTDSA_DS) - 1
FGINTDSA_FoundBool		dd	00h
FGINTDSA_FoundOffsets	dd	00000000h

SIG_FGINTDSA			SIG_DATA <offset FGINTDSA_Name, offset FGINTDSA_Details, offset FGINTDSA_DS, FGINTDSA_SigLength, offset SearchEngine_BYTES, offset FGINTDSA_FoundBool, offset FGINTDSA_FoundOffsets>

;****************************************************************************************************************************************************

FGINTGOSTDSA_Name		db 	"FGInt (Delphi GOSTDSA)", 0
FGINTGOSTDSA_Details	db	"Delphi Big Number Library - Possible RSA?", 0
FGINTGOSTDSA_DS			db	"FGIntGOSTDSA", 0, 0
FGINTGOSTDSA_SigLength	equ ($ - FGINTGOSTDSA_DS) - 1
FGINTGOSTDSA_FoundBool	dd	00h
FGINTGOSTDSA_FO			dd	00000000h

SIG_FGINTGOSTDSA		SIG_DATA <offset FGINTGOSTDSA_Name, offset FGINTGOSTDSA_Details, offset FGINTGOSTDSA_DS, FGINTGOSTDSA_SigLength, offset SearchEngine_BYTES, offset FGINTGOSTDSA_FoundBool, offset FGINTGOSTDSA_FO>

;****************************************************************************************************************************************************

FGINTELGAMAL_Name		db 	"FGInt (Delphi ElGamal)", 0
FGINTELGAMAL_Details	db	"Delphi Big Number Library - Possible RSA?", 0
FGINTELGAMAL_DS			db	"FGIntElGamal", 0, 0
FGINTELGAMAL_SigLength	equ ($ - FGINTELGAMAL_DS) - 1
FGINTELGAMAL_FoundBool	dd	00h
FGINTELGAMAL_FO			dd	00000000h

SIG_FGINTELGAMAL		SIG_DATA <offset FGINTELGAMAL_Name, offset FGINTELGAMAL_Details, offset FGINTELGAMAL_DS, FGINTELGAMAL_SigLength, offset SearchEngine_BYTES, offset FGINTELGAMAL_FoundBool, offset FGINTELGAMAL_FO>

;****************************************************************************************************************************************************

ECELGAMAL_Name			db 	"ECElgamal", 0
ECELGAMAL_Details		db	"Delphi Elliptic Curve ElGamal Code", 0
ECELGAMAL_DS			db	"ECElGamal", 0, 0
ECELGAMAL_SigLength		equ ($ - ECELGAMAL_DS) - 1
ECELGAMAL_FoundBool		dd	00h
ECELGAMAL_FoundOffsets	dd	00000000h

SIG_ECELGAMAL			SIG_DATA <offset ECELGAMAL_Name, offset ECELGAMAL_Details, offset ECELGAMAL_DS, ECELGAMAL_SigLength, offset SearchEngine_BYTES, offset ECELGAMAL_FoundBool, offset ECELGAMAL_FoundOffsets>

;****************************************************************************************************************************************************

ECDSA_Name				db 	"ECDSA", 0
ECDSA_Details			db	"Delphi Elliptic Curve DSA Code", 0
ECDSA_DS				db	"ECDSA", 0, 0
ECDSA_SigLength			equ ($ - ECDSA_DS) - 1
ECDSA_FoundBool			dd	00h
ECDSA_FoundOffsets		dd	00000000h

SIG_ECDSA				SIG_DATA <offset ECDSA_Name, offset ECDSA_Details, offset ECDSA_DS, ECDSA_SigLength, offset SearchEngine_BYTES, offset ECDSA_FoundBool, offset ECDSA_FoundOffsets>

;****************************************************************************************************************************************************

ECGF_Name				db 	"ECGFp", 0
ECGF_Details			db	"Delphi Elliptic Curve Over GF Code", 0
ECGF_DS					db	"ECGFp", 0, 0
ECGF_SigLength			equ ($ - ECGF_DS) - 1
ECGF_FoundBool			dd	00h
ECGF_FoundOffsets		dd	00000000h

SIG_ECGF				SIG_DATA <offset ECGF_Name, offset ECGF_Details, offset ECGF_DS, ECGF_SigLength, offset SearchEngine_BYTES, offset ECGF_FoundBool, offset ECGF_FoundOffsets>

;****************************************************************************************************************************************************

TLBRSA1_Name			db 	"TLBRSA (Sig 1)", 0
TLBRSA1_Details			db	"Delphi RSA Library", 0
TLBRSA1_DS				db	"TRSAHashMethod", 0, 0
TLBRSA1_SigLength		equ ($ - TLBRSA1_DS) - 1
TLBRSA1_FoundBool		dd	00h
TLBRSA1_FoundOffsets	dd	00000000h

SIG_TLBRSA1				SIG_DATA <offset TLBRSA1_Name, offset TLBRSA1_Details, offset TLBRSA1_DS, TLBRSA1_SigLength, offset SearchEngine_BYTES, offset TLBRSA1_FoundBool, offset TLBRSA1_FoundOffsets>

;****************************************************************************************************************************************************

TLBRSA2_Name			db 	"TLBRSA (Sig 2)", 0
TLBRSA2_Details			db	"Delphi RSA Library", 0
TLBRSA2_DS				db	"TLbRSA", 0, 0
TLBRSA2_SigLength		equ ($ - TLBRSA2_DS) - 1
TLBRSA2_FoundBool		dd	00h
TLBRSA2_FoundOffsets	dd	00000000h

SIG_TLBRSA2				SIG_DATA <offset TLBRSA2_Name, offset TLBRSA2_Details, offset TLBRSA2_DS, TLBRSA2_SigLength, offset SearchEngine_BYTES, offset TLBRSA2_FoundBool, offset TLBRSA2_FoundOffsets>

;****************************************************************************************************************************************************

LB_Name					db 	"LB Library", 0
LB_Details				db	"Delphi Big Number Library", 0
LB_DS					db	"Lb", 0, 0
LB_SigLength			equ ($ - LB_DS) - 1
LB_FoundBool			dd	00h
LB_FoundOffsets			dd	00000000h

SIG_LB					SIG_DATA <offset LB_Name, offset LB_Details, offset LB_DS, LB_SigLength, offset SearchEngine_BYTES, offset LB_FoundBool, offset LB_FoundOffsets>

;****************************************************************************************************************************************************

MSCRYPTO1_Name			db 	"CryptCreateHash", 0
MSCRYPTO1_Details		db	"MS Crypto API", 0
MSCRYPTO1_DS			db 	"CryptCreateHash", 0
MSCRYPTO1_SigLength		equ ($ - MSCRYPTO1_DS) - 1
MSCRYPTO1_FoundBool		dd	00h
MSCRYPTO1_FoundOffsets	dd	00000000h

SIG_MSCRYPTO1			SIG_DATA <offset MSCRYPTO1_Name, offset MSCRYPTO1_Details, offset MSCRYPTO1_DS, MSCRYPTO1_SigLength, offset SearchEngine_BYTES, offset MSCRYPTO1_FoundBool, offset MSCRYPTO1_FoundOffsets>

;****************************************************************************************************************************************************

MSCRYPTO2_Name			db 	"CryptDestroyHash", 0
MSCRYPTO2_Details		db	"MS Crypto API", 0
MSCRYPTO2_DS			db 	"CryptDestroyHash", 0
MSCRYPTO2_SigLength		equ ($ - MSCRYPTO2_DS) - 1
MSCRYPTO2_FoundBool		dd	00h
MSCRYPTO2_FoundOffsets	dd	00000000h

SIG_MSCRYPTO2			SIG_DATA <offset MSCRYPTO2_Name, offset MSCRYPTO2_Details, offset MSCRYPTO2_DS, MSCRYPTO2_SigLength, offset SearchEngine_BYTES, offset MSCRYPTO2_FoundBool, offset MSCRYPTO2_FoundOffsets>

;****************************************************************************************************************************************************

MSCRYPTO3_Name			db 	"CryptGetHashParam", 0
MSCRYPTO3_Details		db	"MS Crypto API", 0
MSCRYPTO3_DS			db 	"CryptGetHashParam", 0
MSCRYPTO3_SigLength		equ ($ - MSCRYPTO3_DS) - 1
MSCRYPTO3_FoundBool		dd	00h
MSCRYPTO3_FoundOffsets	dd	00000000h

SIG_MSCRYPTO3			SIG_DATA <offset MSCRYPTO3_Name, offset MSCRYPTO3_Details, offset MSCRYPTO3_DS, MSCRYPTO3_SigLength, offset SearchEngine_BYTES, offset MSCRYPTO3_FoundBool, offset MSCRYPTO3_FoundOffsets>

;****************************************************************************************************************************************************

MSCRYPTO4_Name			db 	"CryptHashData", 0
MSCRYPTO4_Details		db	"MS Crypto API", 0
MSCRYPTO4_DS			db 	"CryptHashData", 0
MSCRYPTO4_SigLength		equ ($ - MSCRYPTO4_DS) - 1
MSCRYPTO4_FoundBool		dd	00h
MSCRYPTO4_FoundOffsets	dd	00000000h

SIG_MSCRYPTO4			SIG_DATA <offset MSCRYPTO4_Name, offset MSCRYPTO4_Details, offset MSCRYPTO4_DS, MSCRYPTO4_SigLength, offset SearchEngine_BYTES, offset MSCRYPTO4_FoundBool, offset MSCRYPTO4_FoundOffsets>

;****************************************************************************************************************************************************

MSCRYPTO5_Name			db 	"CryptEncrypt", 0
MSCRYPTO5_Details		db	"MS Crypto API", 0
MSCRYPTO5_DS			db 	"CryptEncrypt", 0
MSCRYPTO5_SigLength		equ ($ - MSCRYPTO5_DS) - 1
MSCRYPTO5_FoundBool		dd	00h
MSCRYPTO5_FoundOffsets	dd	00000000h

SIG_MSCRYPTO5			SIG_DATA <offset MSCRYPTO5_Name, offset MSCRYPTO5_Details, offset MSCRYPTO5_DS, MSCRYPTO5_SigLength, offset SearchEngine_BYTES, offset MSCRYPTO5_FoundBool, offset MSCRYPTO5_FoundOffsets>

;****************************************************************************************************************************************************

MSCRYPTO6_Name			db 	"CryptDecrypt", 0
MSCRYPTO6_Details		db	"MS Crypto API", 0
MSCRYPTO6_DS			db 	"CryptDecrypt", 0
MSCRYPTO6_SigLength		equ ($ - MSCRYPTO6_DS) - 1
MSCRYPTO6_FoundBool		dd	00h
MSCRYPTO6_FoundOffsets	dd	00000000h

SIG_MSCRYPTO6			SIG_DATA <offset MSCRYPTO6_Name, offset MSCRYPTO6_Details, offset MSCRYPTO6_DS, MSCRYPTO6_SigLength, offset SearchEngine_BYTES, offset MSCRYPTO6_FoundBool, offset MSCRYPTO6_FoundOffsets>

;****************************************************************************************************************************************************
