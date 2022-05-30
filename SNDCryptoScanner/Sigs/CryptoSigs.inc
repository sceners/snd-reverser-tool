
.data

;****************************************************************************************************************************************************

CAST_Name				db 	"CAST", 0
CAST_Details			db	"Encryption Algorithm", 0
CAST_DS					dd	30fb40d4h, 9fa0ff0bh, 6beccd2fh, 3f258c7ah, 1e213f2fh, 9c004dd3h, 6003e540h, 0
CAST_SigLength			equ ($ - CAST_DS)/4 - 1
CAST_FoundBool			dd	00h
CAST_FoundOffsets		dd	CAST_SigLength dup(00)

SIG_CAST				SIG_DATA <offset CAST_Name, offset CAST_Details, offset CAST_DS, CAST_SigLength, offset SearchEngine_DWORD, offset CAST_FoundBool, offset CAST_FoundOffsets>

;****************************************************************************************************************************************************

CASTM_Name				db 	"CAST (Modified)", 0
CASTM_Details			db	"Encryption Algorithm", 0
CASTM_DS				dd	0e216300dh, 0bbddfffch, 0a7ebdabdh, 35648095h, 7789f8b7h, 0e6c1121bh, 0e241600h, 0
CASTM_SigLength			equ ($ - CASTM_DS)/4 - 1
CASTM_FoundBool			dd	00h
CASTM_FoundOffsets		dd	CASTM_SigLength dup(00)

SIG_CASTM				SIG_DATA <offset CASTM_Name, offset CASTM_Details, offset CASTM_DS, CASTM_SigLength, offset SearchEngine_DWORD, offset CASTM_FoundBool, offset CASTM_FoundOffsets>

;****************************************************************************************************************************************************

GOST1_Name				db 	"GOST (Sig 1)", 0
GOST1_Details			db	"Encryption Algorithm", 0
GOST1_DS				db 	04h, 0ah, 09h, 02h, 0ch, 08h, 000h, 0dh, 06h, 0bh, 001h, 00ch, 07h, 0fh, 05h, 03h, 0
GOST1_SigLength			equ ($ - GOST1_DS) - 1
GOST1_FoundBool			dd	00h
GOST1_FoundOffsets		dd	00000000h

SIG_GOST1				SIG_DATA <offset GOST1_Name, offset GOST1_Details, offset GOST1_DS, GOST1_SigLength, offset SearchEngine_BYTES, offset GOST1_FoundBool, offset GOST1_FoundOffsets>

;****************************************************************************************************************************************************

GOST2_Name				db 	"GOST (Char Table) (Sig 1)", 0
GOST2_Details			db	"Encryption Algorithm", 0
GOST2_DS				db	024h, 02Ah, 029h, 022h, 02Dh, 028h, 020h, 02Eh, 026h, 02Bh, 021h, 02Ch, 027h
						db	02Fh, 025h, 023h, 034h, 03Ah, 039h, 032h, 03Dh, 038h, 030h, 03Eh, 036h, 03Bh
						db	031h, 03Ch, 037h, 03Fh, 035h, 033h, 084h, 08Ah, 089h, 082h, 08Dh, 088h, 080h
						db	08Eh, 086h, 08Bh, 081h, 08Ch, 087h, 08Fh, 085h, 083h, 014h, 01Ah, 019h, 012h
						db	01Dh, 018h, 010h, 01Eh, 016h, 01Bh, 011h, 01Ch, 017h, 01Fh, 015h, 013h, 004h
						db	00Ah, 009h, 002h, 00Dh, 008h, 000h, 00Eh, 006h, 00Bh, 001h, 00Ch, 007h, 00Fh
						db	005h, 003h, 074h, 07Ah, 079h, 072h, 07Dh, 078h, 070h, 07Eh, 076h, 07Bh, 071h
						db	07Ch, 077h, 07Fh, 075h, 073h, 054h, 05Ah, 059h, 052h, 05Dh, 058h, 050h, 05Eh
						db	056h, 05Bh, 051h, 05Ch, 057h, 05Fh, 055h, 053h, 094h, 09Ah, 099h, 092h, 09Dh
						db	098h, 090h, 09Eh, 096h, 09Bh, 091h, 09Ch, 097h, 09Fh, 095h, 093h, 0
GOST2_SigLength			equ ($ - GOST2_DS) - 1
GOST2_FoundBool			dd	00h
GOST2_FoundOffsets		dd	00000000h

SIG_GOST2				SIG_DATA <offset GOST2_Name, offset GOST2_Details, offset GOST2_DS, GOST2_SigLength, offset SearchEngine_BYTES, offset GOST2_FoundBool, offset GOST2_FoundOffsets>

;****************************************************************************************************************************************************

GOST3_Name				db 	"GOST (Char Table) (Sig 2)", 0
GOST3_Details			db	"Encryption Algorithm", 0
GOST3_DS				db	01Dh, 01Bh, 014h, 011h, 013h, 01Fh, 015h, 019h, 010h, 01Ah, 01Eh, 017h, 016h
						db	018h, 012h, 01Ch, 0FDh, 0FBh, 0F4h, 0F1h, 0F3h, 0FFh, 0F5h, 0F9h, 0F0h, 0FAh
						db	0FEh, 0F7h, 0F6h, 0F8h, 0F2h, 0FCh, 0DDh, 0DBh, 0D4h, 0D1h, 0D3h, 0DFh, 0D5h
						db	0D9h, 0D0h, 0DAh, 0DEh, 0D7h, 0D6h, 0D8h, 0D2h, 0DCh, 00Dh, 00Bh, 004h, 001h
						db	003h, 00Fh, 005h, 009h, 000h, 00Ah, 00Eh, 007h, 006h, 008h, 002h, 00Ch, 05Dh
						db	05Bh, 054h, 051h, 053h, 05Fh, 055h, 059h, 050h, 05Ah, 05Eh, 057h, 056h, 058h
						db	052h, 05Ch, 07Dh, 07Bh, 074h, 071h, 073h, 07Fh, 075h, 079h, 070h, 07Ah, 07Eh
						db	077h, 076h, 078h, 072h, 07Ch, 0ADh, 0ABh, 0A4h, 0A1h, 0A3h, 0AFh, 0A5h, 0A9h
						db	0A0h, 0AAh, 0AEh, 0A7h, 0A6h, 0A8h, 0A2h, 0ACh, 04Dh, 04Bh, 044h, 041h, 043h
						db	04Fh, 045h, 049h, 040h, 04Ah, 04Eh, 047h, 046h, 048h, 042h, 04Ch, 0
GOST3_SigLength			equ ($ - GOST3_DS) - 1
GOST3_FoundBool			dd	00h
GOST3_FoundOffsets		dd	00000000h

SIG_GOST3				SIG_DATA <offset GOST3_Name, offset GOST3_Details, offset GOST3_DS, GOST3_SigLength, offset SearchEngine_BYTES, offset GOST3_FoundBool, offset GOST3_FoundOffsets>

;****************************************************************************************************************************************************

GOST4_Name				db 	"GOST (Sig 2)", 0
GOST4_Details			db	"Encryption Algorithm", 0
GOST4_DS				db	14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7
						db	15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10
						db	10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8
						db	7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15
						db	2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9
						db	12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11
						db	4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1
						db	13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7, 0
GOST4_SigLength			equ ($ - GOST4_DS) - 1
GOST4_FoundBool			dd	00h
GOST4_FoundOffsets		dd	00000000h

SIG_GOST4				SIG_DATA <offset GOST4_Name, offset GOST4_Details, offset GOST4_DS, GOST4_SigLength, offset SearchEngine_BYTES, offset GOST4_FoundBool, offset GOST4_FoundOffsets>

;****************************************************************************************************************************************************

RC2_Name				db 	"RC2 (Char Table)", 0
RC2_Details				db	"Encryption Algorithm", 0
RC2_DS					db	0d9h, 078h, 0f9h, 0c4h, 019h, 0ddh, 0b5h, 0edh, 028h, 0e9h, 0fdh, 079h, 04ah, 0a0h
						db	0d8h, 09dh, 0c6h, 07eh, 037h, 083h, 02bh, 076h, 053h, 08eh, 062h, 04ch, 064h, 088h
						db	044h, 08bh, 0fbh, 0a2h, 017h, 09ah, 059h, 0f5h, 087h, 0b3h, 04fh, 013h, 061h, 045h
						db	06dh, 08dh, 009h, 081h, 07dh, 032h, 0bdh, 08fh, 040h, 0ebh, 086h, 0b7h, 07bh, 00bh
						db	0f0h, 095h, 021h, 022h, 05ch, 06bh, 04eh, 082h, 054h, 0d6h, 065h, 093h, 0ceh, 060h
						db	0b2h, 01ch, 073h, 056h, 0c0h, 014h, 0a7h, 08ch, 0f1h, 0dch, 012h, 075h, 0cah, 01fh
						db	03bh, 0beh, 0e4h, 0d1h, 042h, 03dh, 0d4h, 030h, 0a3h, 03ch, 0b6h, 026h, 06fh, 0bfh
						db	00eh, 0dah, 046h, 069h, 007h, 057h, 027h, 0f2h, 01dh, 09bh, 0bch, 094h, 043h, 003h
						db	0f8h, 011h, 0c7h, 0f6h, 090h, 0efh, 03eh, 0e7h, 006h, 0c3h, 0d5h, 02fh, 0c8h, 066h
						db	01eh, 0d7h, 008h, 0e8h, 0eah, 0deh, 080h, 052h, 0eeh, 0f7h, 084h, 0aah, 072h, 0ach
						db	035h, 04dh, 06ah, 02ah, 096h, 01ah, 0d2h, 071h, 05ah, 015h, 049h, 074h, 04bh, 09fh
						db	0d0h, 05eh, 004h, 018h, 0a4h, 0ech, 0c2h, 0e0h, 041h, 06eh, 00fh, 051h, 0cbh, 0cch
						db	024h, 091h, 0afh, 050h, 0a1h, 0f4h, 070h, 039h, 099h, 07ch, 03ah, 085h, 023h, 0b8h
						db	0b4h, 07ah, 0fch, 002h, 036h, 05bh, 025h, 055h, 097h, 031h, 02dh, 05dh, 0fah, 098h
						db	0e3h, 08ah, 092h, 0aeh, 005h, 0dfh, 029h, 010h, 067h, 06ch, 0bah, 0c9h, 0d3h, 000h
						db	0e6h, 0cfh, 0e1h, 09eh, 0a8h, 02ch, 063h, 016h, 001h, 03fh, 058h, 0e2h, 089h, 0a9h
						db	00dh, 038h, 034h, 01bh, 0abh, 033h, 0ffh, 0b0h, 0bbh, 048h, 00ch, 05fh, 0b9h, 0b1h
						db	0cdh, 02eh, 0c5h, 0f3h, 0dbh, 047h, 0e5h, 0a5h, 09ch, 077h, 00ah, 0a6h, 020h, 068h
						db	0feh, 07fh, 0c1h, 0adh, 0
RC2_SigLength			equ ($ - RC2_DS) - 1
RC2_FoundBool			dd	00h
RC2_FoundOffsets		dd	00000000h

SIG_RC2					SIG_DATA <offset RC2_Name, offset RC2_Details, offset RC2_DS, RC2_SigLength, offset SearchEngine_BYTES, offset RC2_FoundBool, offset RC2_FoundOffsets>

;****************************************************************************************************************************************************

RC2L_Name				db 	"RC2 (Long Table)", 0
RC2L_Details			db	"Encryption Algorithm", 0
RC2L_DS					dd	0d9h, 078h, 0f9h, 0c4h, 019h, 0ddh, 0b5h, 0edh, 028h, 0e9h, 0fdh, 079h, 04ah, 0a0h
						dd	0d8h, 09dh, 0c6h, 07eh, 037h, 083h, 02bh, 076h, 053h, 08eh, 062h, 04ch, 064h, 088h
						dd	044h, 08bh, 0fbh, 0a2h, 017h, 09ah, 059h, 0f5h, 087h, 0b3h, 04fh, 013h, 061h, 045h
						dd	06dh, 08dh, 009h, 081h, 07dh, 032h, 0bdh, 08fh, 040h, 0ebh, 086h, 0b7h, 07bh, 00bh
						dd	0f0h, 095h, 021h, 022h, 05ch, 06bh, 04eh, 082h, 054h, 0d6h, 065h, 093h, 0ceh, 060h
						dd	0b2h, 01ch, 073h, 056h, 0c0h, 014h, 0a7h, 08ch, 0f1h, 0dch, 012h, 075h, 0cah, 01fh
						dd	03bh, 0beh, 0e4h, 0d1h, 042h, 03dh, 0d4h, 030h, 0a3h, 03ch, 0b6h, 026h, 06fh, 0bfh
						dd	00eh, 0dah, 046h, 069h, 007h, 057h, 027h, 0f2h, 01dh, 09bh, 0bch, 094h, 043h, 003h
						dd	0f8h, 011h, 0c7h, 0f6h, 090h, 0efh, 03eh, 0e7h, 006h, 0c3h, 0d5h, 02fh, 0c8h, 066h
						dd	01eh, 0d7h, 008h, 0e8h, 0eah, 0deh, 080h, 052h, 0eeh, 0f7h, 084h, 0aah, 072h, 0ach
						dd	035h, 04dh, 06ah, 02ah, 096h, 01ah, 0d2h, 071h, 05ah, 015h, 049h, 074h, 04bh, 09fh
						dd	0d0h, 05eh, 004h, 018h, 0a4h, 0ech, 0c2h, 0e0h, 041h, 06eh, 00fh, 051h, 0cbh, 0cch
						dd	024h, 091h, 0afh, 050h, 0a1h, 0f4h, 070h, 039h, 099h, 07ch, 03ah, 085h, 023h, 0b8h
						dd	0b4h, 07ah, 0fch, 002h, 036h, 05bh, 025h, 055h, 097h, 031h, 02dh, 05dh, 0fah, 098h
						dd	0e3h, 08ah, 092h, 0aeh, 005h, 0dfh, 029h, 010h, 067h, 06ch, 0bah, 0c9h, 0d3h, 000h
						dd	0e6h, 0cfh, 0e1h, 09eh, 0a8h, 02ch, 063h, 016h, 001h, 03fh, 058h, 0e2h, 089h, 0a9h
						dd	00dh, 038h, 034h, 01bh, 0abh, 033h, 0ffh, 0b0h, 0bbh, 048h, 00ch, 05fh, 0b9h, 0b1h
						dd	0cdh, 02eh, 0c5h, 0f3h, 0dbh, 047h, 0e5h, 0a5h, 09ch, 077h, 00ah, 0a6h, 020h, 068h
						dd	0feh, 07fh, 0c1h, 0adh, 0
RC2L_SigLength			equ ($ - RC2L_DS)/4 - 1
RC2L_FoundBool			dd	00h
RC2L_FoundOffsets		dd	00000000h

SIG_RC2L				SIG_DATA <offset RC2L_Name, offset RC2L_Details, offset RC2L_DS, RC2L_SigLength, offset SearchEngine_BYTES, offset RC2L_FoundBool, offset RC2L_FoundOffsets>

;****************************************************************************************************************************************************

RC4_Name				db 	"RC4", 0
RC4_Details				db	"Encryption Algorithm", 0
RC4_DS					dd	0fffefdfch, 0fbfaf9f8h, 0f7f6f5f4h, 0f3f2f1f0h, 0
RC4_SigLength			equ ($ - RC4_DS)/4 - 1
RC4_FoundBool			dd	00h
RC4_FoundOffsets		dd	RC4_SigLength dup(00)

SIG_RC4					SIG_DATA <offset RC4_Name, offset RC4_Details, offset RC4_DS, RC4_SigLength, offset SearchEngine_DWORD, offset RC4_FoundBool, offset RC4_FoundOffsets>

;****************************************************************************************************************************************************

RC5_Name				db 	"RC5", 0
RC5_Details				db	"Encryption Algorithm", 0
RC5_DS					dd	0d7c7e065h, 075ff5a1eh, 01436d3d7h, 0b26e4d90h, 050a5c749h, 0eedd4102h, 08d14babbh
						dd	02b4c3474h, 0c983ae2dh, 067bb27e6h, 005f2a19fh, 0a42a1b58h, 042619511h, 0e0990ecah
						dd	07ed08883h, 01d08023ch, 0
RC5_SigLength			equ ($ - RC5_DS)/4 - 1
RC5_FoundBool			dd	00h
RC5_FoundOffsets		dd	RC5_SigLength dup(00)

SIG_RC5					SIG_DATA <offset RC5_Name, offset RC5_Details, offset RC5_DS, RC5_SigLength, offset SearchEngine_DWORD, offset RC5_FoundBool, offset RC5_FoundOffsets>

;****************************************************************************************************************************************************

RC6_Name				db 	"RC6", 0
RC6_Details				db	"Encryption Algorithm", 0
RC6_DS					dd	0bb3f7bf5h, 05976f5aeh, 0f7ae6f67h, 095e5e920h, 0341d62d9h, 0d254dc92h, 0708c564bh
						dd	00ec3d004h, 0acfb49bdh, 04b32c376h, 0e96a3d2fh, 087a1b6e8h, 025d930a1h, 0c410aa5ah
						dd	062482413h, 0007f9dcch, 09eb71785h, 03cee913eh, 0
RC6_SigLength			equ ($ - RC6_DS)/4 - 1
RC6_FoundBool			dd	00h
RC6_FoundOffsets		dd	RC6_SigLength dup(00)

SIG_RC6					SIG_DATA <offset RC6_Name, offset RC6_Details, offset RC6_DS, RC6_SigLength, offset SearchEngine_DWORD, offset RC6_FoundBool, offset RC6_FoundOffsets>

;****************************************************************************************************************************************************

RC56a_Name				db 	"RC5/6 (Common Signature) (Sig 1)", 0
RC56a_Details			db	"Encryption Algorithm", 0
RC56a_DS				dd	0b7e15163h, 09e3779b9h, 0
RC56a_SigLength			equ ($ - RC56a_DS)/4 - 1
RC56a_FoundBool			dd	00h
RC56a_FoundOffsets		dd	RC56a_SigLength dup(00)

SIG_RC56a				SIG_DATA <offset RC56a_Name, offset RC56a_Details, offset RC56a_DS, RC56a_SigLength, offset SearchEngine_DWORD, offset RC56a_FoundBool, offset RC56a_FoundOffsets>

;****************************************************************************************************************************************************

RC56b_Name				db 	"RC5/6 (Common Signature) (Sig 2)", 0
RC56b_Details			db	"Encryption Algorithm", 0
RC56b_DS				dd	0b7e15163h, 061C88647h, 0
RC56b_SigLength			equ ($ - RC56b_DS)/4 - 1
RC56b_FoundBool			dd	00h
RC56b_FoundOffsets		dd	RC56b_SigLength dup(00)

SIG_RC56b				SIG_DATA <offset RC56b_Name, offset RC56b_Details, offset RC56b_DS, RC56b_SigLength, offset SearchEngine_DWORD, offset RC56b_FoundBool, offset RC56b_FoundOffsets>

;****************************************************************************************************************************************************

BLOWFISH_Name			db 	"Blowfish", 0
BLOWFISH_Details		db	"Encryption Algorithm (Requires Key?)", 0
BLOWFISH_DS				dd	0243f6a88h, 085a308d3h, 013198a2eh, 003707344h, 0a4093822h, 0299f31d0h, 0082efa98h
						dd	0ec4e6c89h, 0452821e6h, 038d01377h, 0be5466cfh, 034e90c6ch, 0c0ac29b7h, 0c97c50ddh
						dd	03f84d5b5h, 0b5470917h, 09216d5d9h, 08979fb1bh, 05e5c9ec2h, 0196a2463h, 068fb6fafh
						dd	03e6c53b5h, 01339b2ebh, 03b52ec6fh, 06dfc511fh, 09b30952ch, 0cc814544h, 0af5ebd09h
						dd	0bee3d004h, 0de334afdh, 0660f2807h, 0192e4bb3h, 0
BLOWFISH_SigLength		equ ($ - BLOWFISH_DS)/4 - 1
BLOWFISH_FoundBool		dd	00h
BLOWFISH_FoundOffsets	dd	BLOWFISH_SigLength dup(00)

SIG_BLOWFISH			SIG_DATA <offset BLOWFISH_Name, offset BLOWFISH_Details, offset BLOWFISH_DS, BLOWFISH_SigLength, offset SearchEngine_DWORD, offset BLOWFISH_FoundBool, offset BLOWFISH_FoundOffsets>

;****************************************************************************************************************************************************

TWOFISH1_Name			db 	"Twofish (Sig 1)", 0
TWOFISH1_Details		db	"Encryption Algorithm", 0
TWOFISH1_DS				db	0A9h, 067h, 0B3h, 0E8h, 004h, 0FDh, 0A3h, 076h, 0
TWOFISH1_SigLength		equ ($ - TWOFISH1_DS) - 1
TWOFISH1_FoundBool		dd	00h
TWOFISH1_FoundOffsets	dd	00000000h

SIG_TWOFISH1			SIG_DATA <offset TWOFISH1_Name, offset TWOFISH1_Details, offset TWOFISH1_DS, TWOFISH1_SigLength, offset SearchEngine_BYTES, offset TWOFISH1_FoundBool, offset TWOFISH1_FoundOffsets>

;****************************************************************************************************************************************************

TWOFISH2_Name			db 	"Twofish (Sig 2)", 0
TWOFISH2_Details		db	"Encryption Algorithm", 0
TWOFISH2_DS				db	04fh, 0f2h, 065h, 08eh, 078h, 05ch, 058h, 019h, 08dh, 0e5h, 098h, 057h, 067h
						db	07fh, 005h, 064h, 0afh, 063h, 0b6h, 0feh, 0f5h, 0b7h, 03ch, 0a5h, 0ceh, 0e9h
						db	068h, 044h, 0e0h, 04dh, 043h, 069h, 029h, 02eh, 0ach, 015h, 059h, 0a8h, 00ah
						db	09eh, 0
TWOFISH2_SigLength		equ ($ - TWOFISH2_DS) - 1
TWOFISH2_FoundBool		dd	00h
TWOFISH2_FoundOffsets	dd	00000000h

SIG_TWOFISH2			SIG_DATA <offset TWOFISH2_Name, offset TWOFISH2_Details, offset TWOFISH2_DS, TWOFISH2_SigLength, offset SearchEngine_BYTES, offset TWOFISH2_FoundBool, offset TWOFISH2_FoundOffsets>

;****************************************************************************************************************************************************

DESC1C_Name				db 	"DES Crypt1 (Char Table)", 0
DESC1C_Details			db	"Encryption Algorithm", 0
DESC1C_DS				db	0D2h, 0D3h, 0D4h, 0D5h, 0D6h, 0D7h, 0D8h, 0D9h, 0DAh, 0DBh, 0DCh, 0DDh, 0DEh, 0DFh
						db	0E0h, 0E1h, 0E2h, 0E3h, 0E4h, 0E5h, 0E6h, 0E7h, 0E8h, 0E9h, 0EAh, 0EBh, 0ECh, 0EDh
						db	0EEh, 0EFh, 0F0h, 0F1h, 0F2h, 0F3h, 0F4h, 0F5h, 0F6h, 0F7h, 0F8h, 0F9h, 0FAh, 0FBh
						db	0FCh, 0FDh, 0FEh, 0FFh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 008h, 009h
						db 	00Ah, 00Bh, 005h, 006h, 007h, 008h, 009h, 00Ah, 00Bh, 00Ch, 00Dh, 00Eh, 00Fh, 010h
						db	011h, 012h, 013h, 014h, 015h, 016h, 017h, 018h, 019h, 01Ah, 01Bh, 01Ch, 01Dh, 01Eh
						db	01Fh, 020h, 021h, 022h, 023h, 024h, 025h, 020h, 021h, 022h, 023h, 024h, 025h, 026h
						db	027h, 028h, 029h, 02Ah, 02Bh, 02Ch, 02Dh, 02Eh, 02Fh, 030h, 031h, 032h, 033h, 034h
						db 	035h, 036h, 037h, 038h, 039h, 03Ah, 03Bh, 03Ch, 03Dh, 03Eh, 03Fh, 040h, 041h, 042h
						db	043h, 044h, 0
DESC1C_SigLength		equ ($ - DESC1C_DS) - 1
DESC1C_FoundBool		dd	00h
DESC1C_FoundOffsets		dd	00000000h

SIG_DESC1C				SIG_DATA <offset DESC1C_Name, offset DESC1C_Details, offset DESC1C_DS, DESC1C_SigLength, offset SearchEngine_BYTES, offset DESC1C_FoundBool, offset DESC1C_FoundOffsets>

;****************************************************************************************************************************************************

DESC1L_Name				db 	"DES Crypt1 (Long Table)", 0
DESC1L_Details			db	"Encryption Algorithm", 0
DESC1L_DS				dd	0d2h, 0d3h, 0d4h, 0d5h, 0d6h, 0d7h, 0d8h, 0d9h, 0dah, 0dbh, 0dch, 0ddh, 0deh, 0dfh
						dd	0e0h, 0e1h, 0e2h, 0e3h, 0e4h, 0e5h, 0e6h, 0e7h, 0e8h, 0e9h, 0eah, 0ebh, 0ech, 0edh
						dd	0eeh, 0efh, 0f0h, 0f1h, 0f2h, 0f3h, 0f4h, 0f5h, 0f6h, 0f7h, 0f8h, 0f9h, 0fah, 0fbh
						dd	0fch, 0fdh, 0feh, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 008h, 009h
						dd 	00ah, 00bh, 005h, 006h, 007h, 008h, 009h, 00ah, 00bh, 00ch, 00dh, 00eh, 00fh, 010h
						dd	011h, 012h, 013h, 014h, 015h, 016h, 017h, 018h, 019h, 01ah, 01bh, 01ch, 01dh, 01eh
						dd	01fh, 020h, 021h, 022h, 023h, 024h, 025h, 020h, 021h, 022h, 023h, 024h, 025h, 026h
						dd	027h, 028h, 029h, 02ah, 02bh, 02ch, 02dh, 02eh, 02fh, 030h, 031h, 032h, 033h, 034h
						dd 	035h, 036h, 037h, 038h, 039h, 03ah, 03bh, 03ch, 03dh, 03eh, 03fh, 040h, 041h, 042h
						dd	043h, 044h, 0
DESC1L_SigLength		equ ($ - DESC1L_DS)/4 - 1
DESC1L_FoundBool		dd	00h
DESC1L_FoundOffsets		dd	00000000h

SIG_DESC1L				SIG_DATA <offset DESC1L_Name, offset DESC1L_Details, offset DESC1L_DS, DESC1L_SigLength, offset SearchEngine_BYTES, offset DESC1L_FoundBool, offset DESC1L_FoundOffsets>

;****************************************************************************************************************************************************

DESC2C_Name				db 	"DES Crypt2 (Char Table)", 0
DESC2C_Details			db	"Encryption Algorithm", 0
DESC2C_DS				db	2Eh, 2Fh, 30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 41h, 42h, 43h, 44h
						db	45h, 46h, 47h, 48h, 49h, 4Ah, 4Bh, 4Ch, 4Dh, 4Eh, 4Fh, 50h, 51h, 52h, 53h, 54h
						db	55h, 56h, 57h, 58h, 59h, 5Ah, 61h, 62h, 63h, 64h, 65h, 66h, 67h, 68h, 69h, 6Ah
						db	6Bh, 6Ch, 6Dh, 6Eh, 6Fh, 70h, 71h, 72h, 73h, 74h, 75h, 76h, 77h, 78h, 79h, 7Ah, 0
DESC2C_SigLength		equ ($ - DESC2C_DS) - 1
DESC2C_FoundBool		dd	00h
DESC2C_FoundOffsets		dd	00000000h

SIG_DESC2C				SIG_DATA <offset DESC2C_Name, offset DESC2C_Details, offset DESC2C_DS, DESC2C_SigLength, offset SearchEngine_BYTES, offset DESC2C_FoundBool, offset DESC2C_FoundOffsets>

;****************************************************************************************************************************************************

DESC2L_Name				db 	"DES Crypt2 (Long Table)", 0
DESC2L_Details			db	"Encryption Algorithm", 0
DESC2L_DS				dd	02080800h, 00080000h, 02000002h, 02080802h, 00000802h, 40108010h, 40000010h
						dd	00008000h, 00108010h, 40008010h, 20800080h, 20820080h, 00820000h, 01004004h
						dd	01004204h, 0
DESC2L_SigLength		equ ($ - DESC2L_DS)/4 - 1
DESC2L_FoundBool		dd	00h
DESC2L_FoundOffsets		dd	DESC2L_SigLength dup(00)

SIG_DESC2L				SIG_DATA <offset DESC2L_Name, offset DESC2L_Details, offset DESC2L_DS, DESC2L_SigLength, offset SearchEngine_DWORD, offset DESC2L_FoundBool, offset DESC2L_FoundOffsets>

;****************************************************************************************************************************************************

DESC3C_Name				db 	"DES Crypt3 (Char Table)", 0
DESC3C_Details			db	"Encryption Algorithm", 0
DESC3C_DS				db	14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7, 0, 15, 7, 4, 14, 2, 13, 1
						db	10, 6, 12, 11, 9, 5, 3, 8, 4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0
						db	15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13, 0
DESC3C_SigLength		equ ($ - DESC3C_DS) - 1
DESC3C_FoundBool		dd	00h
DESC3C_FoundOffsets		dd	00000000h

SIG_DESC3C				SIG_DATA <offset DESC3C_Name, offset DESC3C_Details, offset DESC3C_DS, DESC3C_SigLength, offset SearchEngine_BYTES, offset DESC3C_FoundBool, offset DESC3C_FoundOffsets>

;****************************************************************************************************************************************************

DESC3L_Name				db 	"DES Crypt3 (Long Table)", 0
DESC3L_Details			db	"Encryption Algorithm", 0
DESC3L_DS				dd	000080000h, 000080010h, 020080000h, 020080010h, 000090000h, 000090010h, 020090000h
						dd	020090010h, 000080800h, 000080810h, 020080800h, 020080810h, 000090800h, 000090810h
						dd	020090800h, 020090810h, 000080020h, 000080030h, 020080020h, 020080030h, 000090020h
						dd	000090030h, 020090020h, 020090030h, 000080820h, 000080830h, 020080820h, 020080830h
						dd	000090820h, 000090830h, 020090820h, 020090830h, 0
DESC3L_SigLength		equ ($ - DESC3L_DS)/4 - 1
DESC3L_FoundBool		dd	00h
DESC3L_FoundOffsets		dd	DESC3L_SigLength dup(00)

SIG_DESC3L				SIG_DATA <offset DESC3L_Name, offset DESC3L_Details, offset DESC3L_DS, DESC3L_SigLength, offset SearchEngine_DWORD, offset DESC3L_FoundBool, offset DESC3L_FoundOffsets>

;****************************************************************************************************************************************************

NEWDES_Name				db 	"New DES", 0
NEWDES_Details			db	"Encryption Algorithm", 0
NEWDES_DS				db	194, 175, 178, 56, 196, 112, 23, 220, 89, 21, 164, 130, 157, 8, 85, 251, 216, 44, 94
						db	179, 226, 38, 90, 119, 40, 202, 34, 206, 35, 69, 231, 246, 29, 109, 74, 71, 176, 6, 60
						db	145, 65, 13, 77, 151, 12, 127, 95, 199, 57, 101, 5, 232, 150, 210, 129, 24, 181, 10
						db	121, 187, 48, 193, 139, 252, 219, 64, 88, 233, 96, 128, 80, 53, 191, 144, 218, 11, 106
						db	132, 155, 104, 91, 136, 31, 42, 243, 66, 126, 135, 30, 26, 87, 186, 182, 154, 242, 123
						db	82, 166, 208, 39, 152, 190, 113, 205, 114, 105, 225, 84, 73, 163, 99, 111, 204, 61, 200
						db	217, 170, 15, 198, 28, 192, 254, 134, 234, 222, 7, 236, 248, 0
NEWDES_SigLength		equ ($ - NEWDES_DS) - 1
NEWDES_FoundBool		dd	00h
NEWDES_FoundOffsets		dd	00000000h

SIG_NEWDES				SIG_DATA <offset NEWDES_Name, offset NEWDES_Details, offset NEWDES_DS, NEWDES_SigLength, offset SearchEngine_BYTES, offset NEWDES_FoundBool, offset NEWDES_FoundOffsets>

;****************************************************************************************************************************************************

DESX_Name				db 	"DESX", 0
DESX_Details			db	"Encryption Algorithm", 0
DESX_DS					dd	010001040h, 000001000h, 000040000h, 010041040h, 010000000h, 010001040h, 000000040h
						dd	010000000h, 000040040h, 010040000h, 010041040h, 000041000h, 010041000h, 000041040h
						dd	000001000h, 000000040h, 010040000h, 010000040h, 010001000h, 000001040h, 000041000h
						dd	000040040h, 010040040h, 010041000h, 000001040h, 000000000h, 000000000h, 010040040h
						dd	010000040h, 010001000h, 000041040h, 000040000h, 000041040h, 000040000h, 010041000h
						dd	000001000h, 000000040h, 010040040h, 000001000h, 000041040h, 010001000h, 000000040h
						dd	010000040h, 010040000h, 010040040h, 010000000h, 000040000h, 010001040h, 000000000h
						dd	010041040h, 000040040h, 010000040h, 010040000h, 010001000h, 010001040h, 000000000h
						dd	010041040h, 000041000h, 000041000h, 000001040h, 000001040h, 000040040h, 010000000h
						dd	010041000h, 0
DESX_SigLength			equ ($ - DESX_DS)/4 - 1
DESX_FoundBool			dd	00h
DESX_FoundOffsets		dd	DESX_SigLength dup(00)

SIG_DESX				SIG_DATA <offset DESX_Name, offset DESX_Details, offset DESX_DS, DESX_SigLength, offset SearchEngine_DWORD, offset DESX_FoundBool, offset DESX_FoundOffsets>

;****************************************************************************************************************************************************

RIJNDAEL1_Name			db 	"RIJNDAEL (Sig 1)", 0
RIJNDAEL1_Details		db	"Encryption Algorithm", 0
RIJNDAEL1_DS			db	0a5h, 063h, 063h, 0c6h, 084h, 07ch, 07ch, 0f8h, 0
RIJNDAEL1_SigLength		equ ($ - RIJNDAEL1_DS) - 1
RIJNDAEL1_FoundBool		dd	00h
RIJNDAEL1_FoundOffsets	dd	00000000h

SIG_RIJNDAEL1			SIG_DATA <offset RIJNDAEL1_Name, offset RIJNDAEL1_Details, offset RIJNDAEL1_DS, RIJNDAEL1_SigLength, offset SearchEngine_BYTES, offset RIJNDAEL1_FoundBool, offset RIJNDAEL1_FoundOffsets>

;****************************************************************************************************************************************************

RIJNDAEL2_Name			db 	"RIJNDAEL (Sig 2)", 0
RIJNDAEL2_Details		db	"Encryption Algorithm", 0
RIJNDAEL2_DS			db	225, 248, 152, 17, 105, 217, 142, 148, 155, 30, 135, 233, 206, 85, 40, 223
						db	140, 161, 137, 13, 191, 230, 66, 104, 65, 153, 45, 15, 176, 84, 187, 22, 0
RIJNDAEL2_SigLength		equ ($ - RIJNDAEL2_DS) - 1
RIJNDAEL2_FoundBool		dd	00h
RIJNDAEL2_FoundOffsets	dd	00000000h

SIG_RIJNDAEL2			SIG_DATA <offset RIJNDAEL2_Name, offset RIJNDAEL2_Details, offset RIJNDAEL2_DS, RIJNDAEL2_SigLength, offset SearchEngine_BYTES, offset RIJNDAEL2_FoundBool, offset RIJNDAEL2_FoundOffsets>

;****************************************************************************************************************************************************

RIJNDAEL3_Name			db 	"RIJNDAEL (Sig 3)", 0
RIJNDAEL3_Details		db	"Encryption Algorithm", 0
RIJNDAEL3_DS			db	0d3h, 23h, 0abh, 73h, 02h, 0e2h, 72h, 4bh, 8fh, 57h, 0e3h, 1fh, 0abh, 2ah, 66h, 55h
						db	28h, 07h, 0b2h, 0ebh, 0c2h, 03h, 2fh, 0b5h, 7bh, 9ah, 86h, 0c5h, 08h, 0a5h, 0d3h, 37h, 0
RIJNDAEL3_SigLength		equ ($ - RIJNDAEL3_DS) - 1
RIJNDAEL3_FoundBool		dd	00h
RIJNDAEL3_FoundOffsets	dd	00000000h

SIG_RIJNDAEL3			SIG_DATA <offset RIJNDAEL3_Name, offset RIJNDAEL3_Details, offset RIJNDAEL3_DS, RIJNDAEL3_SigLength, offset SearchEngine_BYTES, offset RIJNDAEL3_FoundBool, offset RIJNDAEL3_FoundOffsets>

;****************************************************************************************************************************************************

MARS1_Name				db 	"MARS (Sig 1)", 0
MARS1_Details			db	"Encryption Algorithm", 0
MARS1_DS				dd	07796943ch, 0facabf3dh, 0c09730cdh, 0f7679969h, 0da44e9edh, 02c854c12h
						dd	035935fa3h, 02f057d9fh, 0690624f8h, 01cb0bafdh, 07b0dbdc6h, 0810f23bbh
						dd 	0fa929a1ah, 06d969a17h, 06742979bh, 074ac7d05h, 0
MARS1_SigLength			equ ($ - MARS1_DS)/4 - 1
MARS1_FoundBool			dd	00h
MARS1_FoundOffsets		dd	MARS1_SigLength dup(00)

SIG_MARS1				SIG_DATA <offset MARS1_Name, offset MARS1_Details, offset MARS1_DS, MARS1_SigLength, offset SearchEngine_DWORD, offset MARS1_FoundBool, offset MARS1_FoundOffsets>

;****************************************************************************************************************************************************

MARS2_Name				db 	"MARS (Sig 2)", 0
MARS2_Details			db	"Encryption Algorithm", 0
MARS2_DS				dd	009d0c479h, 028c8ffe0h, 084aa6c39h, 09dad7287h, 07dff9be3h, 0d4268361h
						dd	0c96da1d4h, 0
MARS2_SigLength			equ ($ - MARS2_DS)/4 - 1
MARS2_FoundBool			dd	00h
MARS2_FoundOffsets		dd	MARS2_SigLength dup(00)

SIG_MARS2				SIG_DATA <offset MARS2_Name, offset MARS2_Details, offset MARS2_DS, MARS2_SigLength, offset SearchEngine_DWORD, offset MARS2_FoundBool, offset MARS2_FoundOffsets>

;****************************************************************************************************************************************************

ICE_Name				db 	"ICE", 0
ICE_Details				db	"Encryption Algorithm", 0
ICE_DS					db	083h, 085h, 09bh, 0cdh, 0cch, 0a7h, 0adh, 041h, 04bh, 02eh, 0d4h, 033h, 0eah, 0cbh
						db	02eh, 004h, 0
ICE_SigLength			equ ($ - ICE_DS) - 1
ICE_FoundBool			dd	00h
ICE_FoundOffsets		dd	00000000h

SIG_ICE					SIG_DATA <offset ICE_Name, offset ICE_Details, offset ICE_DS, ICE_SigLength, offset SearchEngine_BYTES, offset ICE_FoundBool, offset ICE_FoundOffsets>

;****************************************************************************************************************************************************

MISTY_Name				db 	"MISTY", 0
MISTY_Details			db	"Encryption Algorithm", 0
MISTY_DS				db	019h, 012h, 065h, 02fh, 030h, 039h, 008h, 068h, 05fh, 078h, 02ah, 04ch, 064h, 045h
						db	075h, 03dh, 059h, 048h, 003h, 057h, 07ch, 04fh, 062h, 03ch, 01dh, 021h, 05eh, 027h
						db	06ah, 070h, 04dh, 03ah, 0
MISTY_SigLength			equ ($ - MISTY_DS) - 1
MISTY_FoundBool			dd	00h
MISTY_FoundOffsets		dd	00000000h

SIG_MISTY				SIG_DATA <offset MISTY_Name, offset MISTY_Details, offset MISTY_DS, MISTY_SigLength, offset SearchEngine_BYTES, offset MISTY_FoundBool, offset MISTY_FoundOffsets>

;****************************************************************************************************************************************************

TEA1_Name				db 	"TEA or Extended TEA Decryption (Sig 1)", 0
TEA1_Details			db	"Encryption Algorithm", 0
TEA1_DS					dd	9E3779B9h, 0C6EF3720h, 0
TEA1_SigLength			equ ($ - TEA1_DS)/4 - 1
TEA1_FoundBool			dd	00h
TEA1_FoundOffsets		dd	TEA1_SigLength dup(00)

SIG_TEA1				SIG_DATA <offset TEA1_Name, offset TEA1_Details, offset TEA1_DS, TEA1_SigLength, offset SearchEngine_DWORD, offset TEA1_FoundBool, offset TEA1_FoundOffsets>

;****************************************************************************************************************************************************

TEA2_Name				db 	"TEA or Extended TEA Decryption (Sig 2)", 0
TEA2_Details			db	"Encryption Algorithm", 0
TEA2_DS					dd	9E3779B9h, 0C6EF3720h, 0
TEA2_SigLength			equ ($ - TEA2_DS)/4 - 1
TEA2_FoundBool			dd	00h
TEA2_FoundOffsets		dd	TEA2_SigLength dup(00)

SIG_TEA2				SIG_DATA <offset TEA2_Name, offset TEA2_Details, offset TEA2_DS, TEA2_SigLength, offset SearchEngine_DWORD, offset TEA2_FoundBool, offset TEA2_FoundOffsets>

;****************************************************************************************************************************************************

SAFER1_Name				db 	"SAFER (Sig 1)", 0
SAFER1_Details			db	"Encryption Algorithm", 0
SAFER1_DS				db	044h, 0E9h, 0CDh, 0E6h, 046h, 042h, 08Fh, 00Ah, 0C1h, 0CCh, 0B9h, 065h, 0B0h
						db	0D2h, 0C6h, 0ACh, 01Eh, 041h, 062h, 029h, 02Eh, 00Eh, 074h, 050h, 002h, 05Ah
						db	0C3h, 025h, 07Bh, 08Ah, 02Ah, 05Bh, 0F0h, 006h, 00Dh, 047h, 06Fh, 070h, 09Dh
						db	07Eh, 010h, 0CEh, 012h, 027h, 0D5h, 04Ch, 04Fh, 0D6h, 079h, 030h, 068h, 036h
						db	075h, 07Dh, 0E4h, 0EDh, 080h, 06Ah, 090h, 037h, 0A2h, 05Eh, 076h, 0AAh, 0
SAFER1_SigLength		equ ($ - SAFER1_DS) - 1
SAFER1_FoundBool		dd	00h
SAFER1_FoundOffsets		dd	00000000h

SIG_SAFER1				SIG_DATA <offset SAFER1_Name, offset SAFER1_Details, offset SAFER1_DS, SAFER1_SigLength, offset SearchEngine_BYTES, offset SAFER1_FoundBool, offset SAFER1_FoundOffsets>

;****************************************************************************************************************************************************

SAFER2_Name				db 	"SAFER (Sig 2)", 0
SAFER2_Details			db	"Encryption Algorithm", 0
SAFER2_DS				db	080h, 000h, 0B0h, 009h, 060h, 0EFh, 0B9h, 0FDh, 010h, 012h, 09Fh, 0E4h, 069h
						db	0BAh, 0ADh, 0F8h, 0C0h, 038h, 0C2h, 065h, 04Fh, 006h, 094h, 0FCh, 019h, 0DEh
						db	06Ah, 01Bh, 05Dh, 04Eh, 0A8h, 082h, 070h, 0EDh, 0E8h, 0ECh, 072h, 0B3h, 015h
						db	0C3h, 0FFh, 0ABh, 0B6h, 047h, 044h, 001h, 0ACh, 025h, 0C9h, 0FAh, 08Eh, 041h
						db	01Ah, 021h, 0CBh, 0D3h, 00Dh, 06Eh, 0FEh, 026h, 058h, 0DAh, 032h, 00Fh, 0
SAFER2_SigLength		equ ($ - SAFER2_DS) - 1
SAFER2_FoundBool		dd	00h
SAFER2_FoundOffsets		dd	00000000h

SIG_SAFER2				SIG_DATA <offset SAFER2_Name, offset SAFER2_Details, offset SAFER2_DS, SAFER2_SigLength, offset SearchEngine_BYTES, offset SAFER2_FoundBool, offset SAFER2_FoundOffsets>

;****************************************************************************************************************************************************

RUBY_Name				db 	"RUBY", 0
RUBY_Details			db	"Encryption Algorithm (WiteG)", 0
RUBY_DS					dd	0456c6091h, 0aa7110c3h, 0
RUBY_SigLength			equ ($ - RUBY_DS)/4 - 1
RUBY_FoundBool			dd	00h
RUBY_FoundOffsets		dd	RUBY_SigLength dup(00)

SIG_RUBY				SIG_DATA <offset RUBY_Name, offset RUBY_Details, offset RUBY_DS, RUBY_SigLength, offset SearchEngine_DWORD, offset RUBY_FoundBool, offset RUBY_FoundOffsets>

;****************************************************************************************************************************************************

ENIGMA_Name				db 	"ENIGMA", 0
ENIGMA_Details			db	"Encryption Algorithm (WiteG)", 0
ENIGMA_DS				dd	08088405h, 7FFFFFFFh, 0
ENIGMA_SigLength		equ ($ - ENIGMA_DS)/4 - 1
ENIGMA_FoundBool		dd	00h
ENIGMA_FoundOffsets		dd	ENIGMA_SigLength dup(00)

SIG_ENIGMA				SIG_DATA <offset ENIGMA_Name, offset ENIGMA_Details, offset ENIGMA_DS, ENIGMA_SigLength, offset SearchEngine_DWORD, offset ENIGMA_FoundBool, offset ENIGMA_FoundOffsets>

;****************************************************************************************************************************************************

SKIPJACK_Name			db 	"SkipJack", 0
SKIPJACK_Details		db	"Encryption Algorithm", 0
SKIPJACK_DS				db 	096h, 084h, 06bh, 0bah, 0f2h, 063h, 09ah, 019h, 07ch, 0aeh, 0e5h, 0f5h, 0f7h, 016h
						db 	06ah, 0a2h, 039h, 0b6h, 07bh, 00fh, 0c1h, 093h, 081h, 01bh, 0eeh, 0b4h, 01ah, 0eah
						db 	0d0h, 091h, 02fh, 0b8h, 055h, 0b9h, 0dah, 085h, 03fh, 041h, 0bfh, 0e0h, 05ah, 058h
						db 	080h, 05fh, 066h, 00bh, 0d8h, 090h, 035h, 0d5h, 0c0h, 0a7h, 033h, 006h, 065h, 069h
						db 	045h, 000h, 094h, 056h, 06dh, 098h, 09bh, 076h, 097h, 0fch, 0b2h, 0c2h, 0b0h, 0feh
						db 	0dbh, 020h, 0e1h, 0ebh, 0d6h, 0e4h, 0ddh, 047h, 04ah, 01dh, 042h, 0edh, 09eh, 06eh
						db 	049h, 03ch, 0cdh, 043h, 027h, 0d2h, 007h, 0d4h, 0deh, 0c7h, 067h, 018h, 089h, 0cbh
						db 	030h, 01fh, 08dh, 0c6h, 08fh, 0aah, 0c8h, 074h, 0dch, 0c9h, 05dh, 05ch, 031h, 0a4h
						db 	070h, 088h, 061h, 02ch, 09fh, 00dh, 02bh, 087h, 050h, 082h, 054h, 064h, 026h, 07dh
						db 	003h, 040h, 0
SKIPJACK_SigLength		equ ($ - SKIPJACK_DS) - 1
SKIPJACK_FoundBool		dd	00h
SKIPJACK_FoundOffsets	dd	00000000h

SIG_SKIPJACK			SIG_DATA <offset SKIPJACK_Name, offset SKIPJACK_Details, offset SKIPJACK_DS, SKIPJACK_SigLength, offset SearchEngine_BYTES, offset SKIPJACK_FoundBool, offset SKIPJACK_FoundOffsets>

;****************************************************************************************************************************************************

E2_Name					db 	"E2", 0
E2_Details				db	"Encryption Algorithm by Nippon TeleGraph", 0
E2_DS					db 	091h, 022h, 004h, 0edh, 0a6h, 048h, 049h, 067h, 0ech, 0f7h, 0c0h, 039h, 0ceh, 0f2h
						db	02dh, 0beh, 05dh, 01ch, 0e3h, 087h, 007h, 00dh, 07ah, 0f4h, 0fbh, 032h, 0f5h, 08ch
						db	0dbh, 08fh, 025h, 096h, 0a8h, 0eah, 0cdh, 033h, 065h, 054h, 006h, 08dh, 089h, 00ah
						db	05eh, 0d9h, 016h, 00eh, 071h, 06ch, 00bh, 0ffh, 060h, 0d2h, 02eh, 0d3h, 0c8h, 055h
						db	0c2h, 023h, 0b7h, 074h, 0e2h, 09bh, 0dfh, 077h, 02bh, 0b9h, 03ch, 062h, 013h, 0e5h
						db	094h, 034h, 0b1h, 027h, 084h, 09fh, 0d7h, 051h, 000h, 061h, 0adh, 085h, 073h, 003h
						db	008h, 040h, 0efh, 068h, 0feh, 097h, 01fh, 0deh, 0afh, 066h, 0e8h, 0b8h, 0aeh, 0bdh
						db	0b3h, 0ebh, 0c6h, 06bh, 047h, 0a9h, 0d8h, 0a7h, 072h, 0eeh, 01dh, 07eh, 0aah, 0b6h
						db 	075h, 0cbh, 0d4h, 030h, 069h, 020h, 07fh, 037h, 05bh, 09dh, 078h, 0a3h, 0f1h, 076h
						db	0fah, 005h, 0
E2_SigLength			equ ($ - E2_DS) - 1
E2_FoundBool			dd	00h
E2_FoundOffsets			dd	00000000h

SIG_E2					SIG_DATA <offset E2_Name, offset E2_Details, offset E2_DS, E2_SigLength, offset SearchEngine_BYTES, offset E2_FoundBool, offset E2_FoundOffsets>

;****************************************************************************************************************************************************

ECC_Name				db 	"ECC Pegwit Curve Point", 0
ECC_Details				db	"ECC Pegwit Curve Point Algorithm", 0
ECC_DS					db	00, 0cch, 38h, 2fh, 05h, 10h, 25h, 0aah, 45h, 89h, 1bh, 68h, 44h, 82h, 48h, 67h, 0dh
						db	0ebh, 4fh, 0ceh, 055h, 0
ECC_SigLength			equ ($ - ECC_DS) - 1
ECC_FoundBool			dd	00h
ECC_FoundOffsets		dd	00000000h

SIG_ECC					SIG_DATA <offset ECC_Name, offset ECC_Details, offset ECC_DS, ECC_SigLength, offset SearchEngine_BYTES, offset ECC_FoundBool, offset ECC_FoundOffsets>

;****************************************************************************************************************************************************

SQUARE_Name				db 	"SQUARE", 0
SQUARE_Details			db	"Encryption Algorithm", 0
SQUARE_DS				dd	002BC68E3h, 00C628555h, 031233F2Ah, 0F713AB61h, 0726DD498h, 0199ACB21h, 061A4223Ch
						dd	0CD3D9D45h, 023B4FD05h, 05F07C42Bh, 0C0012C9Bh, 00F80D93Dh, 0745C6C48h, 0857E7FF9h
						dd	01FAB73F1h, 00EDEEDB6h, 0
SQUARE_SigLength		equ ($ - SQUARE_DS) - 1
SQUARE_FoundBool		dd	00h
SQUARE_FoundOffsets		dd	00000000h

SIG_SQUARE				SIG_DATA <offset SQUARE_Name, offset SQUARE_Details, offset SQUARE_DS, SQUARE_SigLength, offset SearchEngine_BYTES, offset SQUARE_FoundBool, offset SQUARE_FoundOffsets>

;****************************************************************************************************************************************************

SNEFRU_Name				db 	"SNEFRU", 0
SNEFRU_Details			db	"Encryption Algorithm", 0
SNEFRU_DS				dd	064F9001Bh, 0FEDDCDF6h, 07C8FF1E2h, 011D71514h, 08B8C18D3h, 0DDDF881Eh, 06EAB5056h
						dd	088CED8E1h, 049148959h, 069C56FD5h, 0B7994F03h, 00FBCEE3Eh, 03C264940h, 021557E58h
						dd	0E14B3FC2h, 02E5CF591h, 0
SNEFRU_SigLength		equ ($ - SNEFRU_DS) - 1
SNEFRU_FoundBool		dd	00h
SNEFRU_FoundOffsets		dd	00000000h

SIG_SNEFRU				SIG_DATA <offset SNEFRU_Name, offset SNEFRU_Details, offset SNEFRU_DS, SNEFRU_SigLength, offset SearchEngine_BYTES, offset SNEFRU_FoundBool, offset SNEFRU_FoundOffsets>

;****************************************************************************************************************************************************

SHARK_Name				db 	"SHARK", 0
SHARK_Details			db	"Encryption Algorithm", 0
SHARK_DS				dd	064F9001Bh, 0FEDDCDF6h, 07C8FF1E2h, 011D71514h, 08B8C18D3h, 0DDDF881Eh, 06EAB5056h
						dd	088CED8E1h, 049148959h, 069C56FD5h, 0B7994F03h, 00FBCEE3Eh, 03C264940h, 021557E58h
						dd	0E14B3FC2h, 02E5CF591h, 0
SHARK_SigLength			equ ($ - SHARK_DS) - 1
SHARK_FoundBool			dd	00h
SHARK_FoundOffsets		dd	00000000h

SIG_SHARK				SIG_DATA <offset SHARK_Name, offset SHARK_Details, offset SHARK_DS, SHARK_SigLength, offset SearchEngine_BYTES, offset SHARK_FoundBool, offset SHARK_FoundOffsets>

;****************************************************************************************************************************************************

Q128_Name				db 	"Q128", 0
Q128_Details			db	"Encryption Algorithm", 0
Q128_DS					dd	0D6D92632h, 05E84404Dh, 04F341282h, 071654B06h, 0D48D6A0Bh, 0245BECC4h, 0C8F84D80h
						dd	022C620C9h, 066AA8B02h, 00AC697FFh, 08B755A36h, 02577931Ch, 0438D17B6h, 0BB7B1BD1h
						dd	0E0A8F51Eh, 0F4FD583Dh, 0
Q128_SigLength			equ ($ - Q128_DS) - 1
Q128_FoundBool			dd	00h
Q128_FoundOffsets		dd	00000000h

SIG_Q128				SIG_DATA <offset Q128_Name, offset Q128_Details, offset Q128_DS, Q128_SigLength, offset SearchEngine_BYTES, offset Q128_FoundBool, offset Q128_FoundOffsets>

;****************************************************************************************************************************************************

FROG_Name				db 	"FROG", 0
FROG_Details			db	"Encryption Algorithm", 0
FROG_DS					db	071h, 015h, 0E8h, 012h, 071h, 05Ch, 03Fh, 09Dh, 07Ch, 0C1h, 0A6h, 0C5h, 07Eh, 038h
						db	0E5h, 0E5h, 09Ch, 0A2h, 036h, 011h, 0E6h, 059h, 0BDh, 057h, 0A9h, 000h, 051h, 0CCh
						db	008h, 046h, 0CBh, 0E1h, 0A0h, 03Bh, 0A7h, 0BDh, 064h, 09Dh, 054h, 00Bh, 007h, 082h
						db	01Dh, 033h, 020h, 02Dh, 087h, 0EDh, 08Bh, 021h, 011h, 0DDh, 018h, 032h, 059h, 04Ah
						db	015h, 0CDh, 0BFh, 0F2h, 054h, 035h, 003h, 0E6h, 0E7h, 076h, 00Fh, 00Fh, 06Bh, 004h
						db	015h, 022h, 003h, 09Ch, 039h, 042h, 05Dh, 0FFh, 0BFh, 003h, 055h, 087h, 0CDh, 0C8h
						db	0B9h, 0CCh, 034h, 025h, 023h, 018h, 044h, 0B9h, 0C9h, 00Ah, 0E0h, 0EAh, 007h, 078h
						db	0C9h, 073h, 0D8h, 067h, 039h, 0FFh, 05Dh, 06Eh, 02Ah, 0F9h, 044h, 00Eh, 01Dh, 037h
						db	080h, 054h, 025h, 098h, 0DDh, 089h, 027h, 00Bh, 0FCh, 032h, 090h, 023h, 0B2h, 0BEh
						db	02Bh, 0A2h, 067h, 0F9h, 06Dh, 008h, 0EBh, 021h, 09Eh, 06Fh, 0FCh, 0CDh, 0A9h, 036h
						db	00Ah, 014h, 0DDh, 0C9h, 0B2h, 0E0h, 059h, 0B8h, 0B6h, 041h, 0C9h, 00Ah, 03Ch, 006h
						db	0BFh, 0AEh, 04Fh, 062h, 01Ah, 0A0h, 0FCh, 033h, 03Fh, 04Fh, 006h, 066h, 07Bh, 0ADh
						db	031h, 003h, 06Eh, 0E9h, 05Ah, 09Eh, 0E4h, 0D2h, 0D1h, 0EDh, 01Eh, 05Fh, 01Ch, 0B3h
						db	0CCh, 0DCh, 048h, 0A3h, 04Dh, 0A6h, 0C0h, 062h, 0A5h, 019h, 091h, 0A2h, 05Bh, 0D4h
						db	029h, 0E6h, 06Eh, 006h, 06Bh, 0BBh, 07Fh, 026h, 052h, 062h, 01Eh, 043h, 0E1h, 050h
						db	0D0h, 086h, 03Ch, 0FAh, 099h, 057h, 094h, 03Ch, 042h, 0A5h, 048h, 01Dh, 0A5h, 052h
						db	0D3h, 0CFh, 000h, 0B1h, 0CEh, 00Dh, 006h, 00Eh, 05Ch, 0F8h, 03Ch, 0C9h, 084h, 05Fh
						db	023h, 0D7h, 076h, 0B1h, 079h, 0B4h, 01Bh, 053h, 083h, 01Ah, 027h, 02Eh, 00Ch, 0
FROG_SigLength			equ ($ - FROG_DS) - 1
FROG_FoundBool			dd	00h
FROG_FoundOffsets		dd	00000000h

SIG_FROG				SIG_DATA <offset FROG_Name, offset FROG_Details, offset FROG_DS, FROG_SigLength, offset SearchEngine_BYTES, offset FROG_FoundBool, offset FROG_FoundOffsets>

;****************************************************************************************************************************************************

DFC_Name				db 	"DFC", 0
DFC_Details				db	"Encryption Algorithm", 0
DFC_DS					dd	04422a52eh, 0cb238feeh, 0e5ab6addh, 0835fd1a0h, 0753d0a8fh, 078e537d2h, 0b95bb79dh
						dd	08dcaec64h, 02c1e9f23h, 0b829b5c2h, 0780bf387h, 037df8bb3h, 000d01334h, 0a0d0bd86h
						dd	045cbfa73h, 0a6160ffeh, 0
DFC_SigLength			equ ($ - DFC_DS)/4 - 1
DFC_FoundBool			dd	00h
DFC_FoundOffsets		dd	DFC_SigLength dup(00)

SIG_DFC					SIG_DATA <offset DFC_Name, offset DFC_Details, offset DFC_DS, DFC_SigLength, offset SearchEngine_DWORD, offset DFC_FoundBool, offset DFC_FoundOffsets>

;****************************************************************************************************************************************************

MMB_Name				db 	"MMB", 0
MMB_Details				db	"Encryption Algorithm", 0
MMB_DS					dd	025f1cdbh, 04be39b6h, 12f8e6d8h, 2f8e6d81h, 0dad4694h, 06d6a34ah, 81b5a8d2h, 281b5a8dh, 0
MMB_SigLength			equ ($ - MMB_DS)/4 - 1
MMB_FoundBool			dd	00h
MMB_FoundOffsets		dd	MMB_SigLength dup(00)

SIG_MMB					SIG_DATA <offset MMB_Name, offset MMB_Details, offset MMB_DS, MMB_SigLength, offset SearchEngine_DWORD, offset MMB_FoundBool, offset MMB_FoundOffsets>

;****************************************************************************************************************************************************

CRYPTON_Name			db 	"CRYPTON", 0
CRYPTON_Details			db	"Encryption Algorithm", 0
CRYPTON_DS				dd	3fcff3fch, 0fc3fcff3h, 0f3fc3fcfh, 0cff3fc3fh, 0
CRYPTON_SigLength		equ ($ - CRYPTON_DS) - 1
CRYPTON_FoundBool		dd	00h
CRYPTON_FoundOffsets	dd	00000000h

SIG_CRYPTON				SIG_DATA <offset CRYPTON_Name, offset CRYPTON_Details, offset CRYPTON_DS, CRYPTON_SigLength, offset SearchEngine_BYTES, offset CRYPTON_FoundBool, offset CRYPTON_FoundOffsets>

;****************************************************************************************************************************************************

HPC_Name				db 	"HPC", 0
HPC_Details				db	"Encryption Algorithm", 0
HPC_DS					dd	0a23249d6h, 2b992ddfh, 0c0b36173h, 25b946ebh, 0e9e17158h, 0c442f56bh, 0
HPC_SigLength			equ ($ - HPC_DS)/4 - 1
HPC_FoundBool			dd	00h
HPC_FoundOffsets		dd	HPC_SigLength dup(00)

SIG_HPC					SIG_DATA <offset HPC_Name, offset HPC_Details, offset HPC_DS, HPC_SigLength, offset SearchEngine_DWORD, offset HPC_FoundBool, offset HPC_FoundOffsets>

;****************************************************************************************************************************************************

LOKI_Name				db 	"Loki", 0
LOKI_Details			db	"Encryption Algorithm", 0
LOKI_DS					dd	7f4a7c15h, 9e3779b9h, 0
LOKI_SigLength			equ ($ - LOKI_DS)/4 - 1
LOKI_FoundBool			dd	00h
LOKI_FoundOffsets		dd	LOKI_SigLength dup(00)

SIG_LOKI				SIG_DATA <offset LOKI_Name, offset LOKI_Details, offset LOKI_DS, LOKI_SigLength, offset SearchEngine_DWORD, offset LOKI_FoundBool, offset LOKI_FoundOffsets>

;****************************************************************************************************************************************************

REDOC1_Name				db 	"REDOC (Sig 1)", 0
REDOC1_Details			db	"Encryption Algorithm", 0
REDOC1_DS				db	114, 77, 62, 14, 91, 113, 233, 170, 56, 152, 0
REDOC1_SigLength		equ ($ - REDOC1_DS) - 1
REDOC1_FoundBool		dd	00h
REDOC1_FoundOffsets		dd	00000000h

SIG_REDOC1				SIG_DATA <offset REDOC1_Name, offset REDOC1_Details, offset REDOC1_DS, REDOC1_SigLength, offset SearchEngine_BYTES, offset REDOC1_FoundBool, offset REDOC1_FoundOffsets>

;****************************************************************************************************************************************************

REDOC2_Name				db 	"REDOC (Sig 2)", 0
REDOC2_Details			db	"Encryption Algorithm", 0
REDOC2_DS				db	1, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73
						db	79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 0
REDOC2_SigLength		equ ($ - REDOC2_DS) - 1
REDOC2_FoundBool		dd	00h
REDOC2_FoundOffsets		dd	00000000h

SIG_REDOC2				SIG_DATA <offset REDOC2_Name, offset REDOC2_Details, offset REDOC2_DS, REDOC2_SigLength, offset SearchEngine_BYTES, offset REDOC2_FoundBool, offset REDOC2_FoundOffsets>

;****************************************************************************************************************************************************

S1_Name					db 	"S1 (Sig 2)", 0
S1_Details				db	"Encryption Algorithm", 0
S1_DS					db	07, 02, 11, 14, 10, 16, 1, 15, 2, 0, 3, 17, 7, 3, 17, 10, 17, 12, 5, 13, 0, 17, 0
S1_SigLength			equ ($ - S1_DS) - 1
S1_FoundBool			dd	00h
S1_FoundOffsets			dd	00000000h

SIG_S1					SIG_DATA <offset S1_Name, offset S1_Details, offset S1_DS, S1_SigLength, offset SearchEngine_BYTES, offset S1_FoundBool, offset S1_FoundOffsets>

;****************************************************************************************************************************************************

SEAL_Name				db 	"SEAL", 0
SEAL_Details			db	"Encryption Algorithm", 0
SEAL_DS					dd	5a827999h, 6ed9eba1h, 8f1bbcdh, 0ca62c1d6h, 0
SEAL_SigLength			equ ($ - SEAL_DS)/4 - 1
SEAL_FoundBool			dd	00h
SEAL_FoundOffsets		dd	SEAL_SigLength dup(00)

SIG_SEAL				SIG_DATA <offset SEAL_Name, offset SEAL_Details, offset SEAL_DS, SEAL_SigLength, offset SearchEngine_DWORD, offset SEAL_FoundBool, offset SEAL_FoundOffsets>

;****************************************************************************************************************************************************
