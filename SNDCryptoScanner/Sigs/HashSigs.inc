
.data

;****************************************************************************************************************************************************

CRC16_Name			db 	"CRC16 (Table)", 0
CRC16_Details		db	"Basic 16bit Hashing Algorithm", 0
CRC16_DS			dd	0c181c0c1h, 0c3010140h, 0028003c0h, 0c601c241h, 0078006c0h, 00500c741h, 0c481c5c1h
					dd	0cc010440h, 00d800cc0h, 00f00cd41h, 0ce81cfc1h, 00a000e40h, 0cb81cac1h, 0c9010b40h
					dd 	0088009c0h, 0d801c841h, 0198018c0h, 01b00d941h, 0da81dbc1h, 01e001a40h, 0
CRC16_SigLength		equ ($ - CRC16_DS)/4 - 1
CRC16_FoundBool		dd	00h
CRC16_FoundOffsets	dd	CRC16_SigLength dup(00)

SIG_CRC16			SIG_DATA <offset CRC16_Name, offset CRC16_Details, offset CRC16_DS, CRC16_SigLength, offset SearchEngine_DWORD, offset CRC16_FoundBool, offset CRC16_FoundOffsets>

;****************************************************************************************************************************************************

CRC32_Name			db 	"CRC32 (Table)", 0
CRC32_Details		db	"Basic 32bit Hashing Algorithm", 0
CRC32_DS			dd	077073096h, 0ee0e612ch, 0990951bah, 0076dc419h, 0706af48fh, 0e963a535h, 09e6495a3h
					dd	00edb8832h, 079dcb8a4h, 0e0d5e91eh, 097d2d988h, 009b64c2bh, 07eb17cbdh, 0e7b82d07h
					dd	090bf1d91h, 01db71064h, 06ab020f2h, 0f3b97148h, 084be41deh, 01adad47dh, 0
CRC32_SigLength		equ ($ - CRC32_DS)/4 - 1
CRC32_FoundBool		dd	00h
CRC32_FoundOffsets	dd	CRC32_SigLength dup(00)

SIG_CRC32			SIG_DATA <offset CRC32_Name, offset CRC32_Details, offset CRC32_DS, CRC32_SigLength, offset SearchEngine_DWORD, offset CRC32_FoundBool, offset CRC32_FoundOffsets>

;****************************************************************************************************************************************************

CRC32b_Name			db 	"CRC32b (Table)", 0
CRC32b_Details		db	"Basic 32bit Hashing Algorithm", 0
CRC32b_DS			dd 	004c11db7h, 009823b6eh, 00d4326d9h, 0130476dch, 017c56b6bh, 01a864db2h, 01e475005h
					dd 	02608edb8h, 022c9f00fh, 02f8ad6d6h, 02b4bcb61h, 0350c9b64h, 031cd86d3h, 03c8ea00ah
					dd 	0384fbdbdh, 04c11db70h, 048d0c6c7h, 04593e01eh, 04152fda9h, 05f15adach, 0
CRC32b_SigLength	equ ($ - CRC32b_DS)/4 - 1
CRC32b_FoundBool	dd	00h
CRC32b_FoundOffsets	dd	CRC32b_SigLength dup(00)

SIG_CRC32b			SIG_DATA <offset CRC32b_Name, offset CRC32b_Details, offset CRC32b_DS, CRC32b_SigLength, offset SearchEngine_DWORD, offset CRC32b_FoundBool, offset CRC32b_FoundOffsets>

;****************************************************************************************************************************************************

MD2_Name			db 	"MD2 (Char Table)", 0
MD2_Details			db	"Basic 128bit Hashing Algorithm", 0
MD2_DS				db	029h, 02eh, 043h, 0c9h, 0a2h, 0d8h, 07ch, 001h, 03dh, 036h, 054h, 0a1h, 0ech, 0f0h
					db	006h, 013h, 062h, 0a7h, 005h, 0f3h, 0c0h, 0c7h, 073h, 08ch, 098h, 093h, 02bh, 0d9h
					db	0bch, 04ch, 082h, 0cah, 01eh, 09bh, 057h, 03ch, 0fdh, 0d4h, 0e0h, 016h, 067h, 042h
					db	06fh, 018h, 08ah, 017h, 0e5h, 012h, 0beh, 04eh, 0c4h, 0d6h, 0dah, 09eh, 0deh, 049h
					db	0a0h, 0fbh, 0f5h, 08eh, 0bbh, 02fh, 0eeh, 07ah, 0a9h, 068h, 079h, 091h, 015h, 0b2h
					db	007h, 03fh, 094h, 0c2h, 010h, 089h, 00bh, 022h, 05fh, 021h, 080h, 07fh, 05dh, 09ah
					db	05ah, 090h, 032h, 027h, 035h, 03eh, 0cch, 0e7h, 0bfh, 0f7h, 097h, 003h, 0ffh, 019h
					db	030h, 0b3h, 048h, 0a5h, 0b5h, 0d1h, 0d7h, 05eh, 092h, 02ah, 0ach, 056h, 0aah, 0c6h
					db	04fh, 0b8h, 038h, 0d2h, 096h, 0a4h, 07dh, 0b6h, 076h, 0fch, 06bh, 0e2h, 09ch, 074h
					db	004h, 0f1h, 045h, 09dh, 070h, 059h, 064h, 071h, 087h, 020h, 086h, 05bh, 0cfh, 065h
					db	0e6h, 02dh, 0a8h, 002h, 01bh, 060h, 025h, 0adh, 0aeh, 0b0h, 0b9h, 0f6h, 01ch, 046h
					db	061h, 069h, 034h, 040h, 07eh, 00fh, 055h, 047h, 0a3h, 023h, 0ddh, 051h, 0afh, 03ah
					db	0c3h, 05ch, 0f9h, 0ceh, 0bah, 0c5h, 0eah, 026h, 02ch, 053h, 00dh, 06eh, 085h, 028h
					db	084h, 009h, 0d3h, 0dfh, 0cdh, 0f4h, 041h, 081h, 04dh, 052h, 06ah, 0dch, 037h, 0c8h
					db	06ch, 0c1h, 0abh, 0fah, 024h, 0e1h, 07bh, 008h, 00ch, 0bdh, 0b1h, 04ah, 078h, 088h
					db	095h, 08bh, 0e3h, 063h, 0e8h, 06dh, 0e9h, 0cbh, 0d5h, 0feh, 03bh, 000h, 01dh, 039h
					db	0f2h, 0efh, 0b7h, 00eh, 066h, 058h, 0d0h, 0e4h, 0a6h, 077h, 072h, 0f8h, 0ebh, 075h
					db	04bh, 00ah, 031h, 044h, 050h, 0b4h, 08fh, 0edh, 01fh, 01ah, 0dbh, 099h, 08dh, 033h
					db	09fh, 011h, 083h, 014h, 0
MD2_SigLength		equ ($ - MD2_DS) - 1
MD2_FoundBool		dd	00h
MD2_FoundOffsets	dd	00000000h

SIG_MD2				SIG_DATA <offset MD2_Name, offset MD2_Details, offset MD2_DS, MD2_SigLength, offset SearchEngine_BYTES, offset MD2_FoundBool, offset MD2_FoundOffsets>

;****************************************************************************************************************************************************

MD2L_Name			db 	"MD2 (Long Table)", 0
MD2L_Details		db	"Basic 128bit Hashing Algorithm", 0
MD2L_DS				dd	029h, 02eh, 043h, 0c9h, 0a2h, 0d8h, 07ch, 001h, 03dh, 036h, 054h, 0a1h, 0ech, 0f0h
					dd	006h, 013h, 062h, 0a7h, 005h, 0f3h, 0c0h, 0c7h, 073h, 08ch, 098h, 093h, 02bh, 0d9h
					dd	0bch, 04ch, 082h, 0cah, 01eh, 09bh, 057h, 03ch, 0fdh, 0d4h, 0e0h, 016h, 067h, 042h
					dd	06fh, 018h, 08ah, 017h, 0e5h, 012h, 0beh, 04eh, 0c4h, 0d6h, 0dah, 09eh, 0deh, 049h
					dd	0a0h, 0fbh, 0f5h, 08eh, 0bbh, 02fh, 0eeh, 07ah, 0a9h, 068h, 079h, 091h, 015h, 0b2h
					dd	007h, 03fh, 094h, 0c2h, 010h, 089h, 00bh, 022h, 05fh, 021h, 080h, 07fh, 05dh, 09ah
					dd	05ah, 090h, 032h, 027h, 035h, 03eh, 0cch, 0e7h, 0bfh, 0f7h, 097h, 003h, 0ffh, 019h
					dd	030h, 0b3h, 048h, 0a5h, 0b5h, 0d1h, 0d7h, 05eh, 092h, 02ah, 0ach, 056h, 0aah, 0c6h
					dd	04fh, 0b8h, 038h, 0d2h, 096h, 0a4h, 07dh, 0b6h, 076h, 0fch, 06bh, 0e2h, 09ch, 074h
					dd	004h, 0f1h, 045h, 09dh, 070h, 059h, 064h, 071h, 087h, 020h, 086h, 05bh, 0cfh, 065h
					dd	0e6h, 02dh, 0a8h, 002h, 01bh, 060h, 025h, 0adh, 0aeh, 0b0h, 0b9h, 0f6h, 01ch, 046h
					dd	061h, 069h, 034h, 040h, 07eh, 00fh, 055h, 047h, 0a3h, 023h, 0ddh, 051h, 0afh, 03ah
					dd	0c3h, 05ch, 0f9h, 0ceh, 0bah, 0c5h, 0eah, 026h, 02ch, 053h, 00dh, 06eh, 085h, 028h
					dd	084h, 009h, 0d3h, 0dfh, 0cdh, 0f4h, 041h, 081h, 04dh, 052h, 06ah, 0dch, 037h, 0c8h
					dd	06ch, 0c1h, 0abh, 0fah, 024h, 0e1h, 07bh, 008h, 00ch, 0bdh, 0b1h, 04ah, 078h, 088h
					dd	095h, 08bh, 0e3h, 063h, 0e8h, 06dh, 0e9h, 0cbh, 0d5h, 0feh, 03bh, 000h, 01dh, 039h
					dd	0f2h, 0efh, 0b7h, 00eh, 066h, 058h, 0d0h, 0e4h, 0a6h, 077h, 072h, 0f8h, 0ebh, 075h
					dd	04bh, 00ah, 031h, 044h, 050h, 0b4h, 08fh, 0edh, 01fh, 01ah, 0dbh, 099h, 08dh, 033h
					dd	09fh, 011h, 083h, 014h, 0
MD2L_SigLength		equ ($ - MD2L_DS)/4 - 1
MD2L_FoundBool		dd	00h
MD2L_FoundOffsets	dd	00000000h

SIG_MD2L			SIG_DATA <offset MD2L_Name, offset MD2L_Details, offset MD2L_DS, MD2L_SigLength, offset SearchEngine_BYTES, offset MD2L_FoundBool, offset MD2L_FoundOffsets>

;****************************************************************************************************************************************************

MD4_Name			db 	"MD4", 0
MD4_Details			db	"128bit Hashing Algorithm", 0
MD4_DS				dd	067452301h, 0efcdab89h, 098badcfeh, 010325476h, 05a827999h, 06ed9eba1h, 0
MD4_SigLength		equ ($ - MD4_DS)/4 - 1
MD4_FoundBool		dd	00h
MD4_FoundOffsets	dd	MD4_SigLength dup(00)

SIG_MD4				SIG_DATA <offset MD4_Name, offset MD4_Details, offset MD4_DS, MD4_SigLength, offset SearchEngine_DWORD, offset MD4_FoundBool, offset MD4_FoundOffsets>

;****************************************************************************************************************************************************

MD5_Name			db 	"MD5", 0
MD5_Details			db	"128bit Hashing Algorithm", 0
MD5_DS				dd	067452301h, 0efcdab89h, 098badcfeh, 010325476h, 0d76aa478h, 0e8c7b756h, 0242070dbh
					dd	0c1bdceeeh, 0f57c0fafh, 04787c62ah, 0a8304613h, 0fd469501h, 0698098d8h, 08b44f7afh
					dd	0ffff5bb1h, 0895cd7beh, 06b901122h, 0fd987193h, 0a679438eh, 049b40821h, 0f61e2562h
					dd	0c040b340h, 0265e5a51h, 0e9b6c7aah, 0d62f105dh, 002441453h, 0d8a1e681h, 0e7d3fbc8h
					dd	021e1cde6h, 0c33707d6h, 0f4d50d87h, 0455a14edh, 0a9e3e905h, 0fcefa3f8h, 0676f02d9h
					dd	08d2a4c8ah, 0fffa3942h, 08771f681h, 06d9d6122h, 0fde5380ch, 0a4beea44h, 04bdecfa9h
					dd	0f6bb4b60h, 0bebfbc70h, 0289b7ec6h, 0eaa127fah, 0d4ef3085h, 004881d05h, 0d9d4d039h
					dd	0e6db99e5h, 01fa27cf8h, 0c4ac5665h, 0f4292244h, 0432aff97h, 0ab9423a7h, 0fc93a039h
					dd	0655b59c3h, 08f0ccc92h, 0ffeff47dh, 085845dd1h, 06fa87e4fh, 0fe2ce6e0h, 0a3014314h
					dd	04e0811a1h, 0f7537e82h, 0bd3af235h, 02ad7d2bbh, 0eb86d391h, 0
MD5_SigLength		equ ($ - MD5_DS)/4 - 1
MD5_FoundBool		dd	00h
MD5_FoundOffsets	dd	MD5_SigLength dup(00)

SIG_MD5				SIG_DATA <offset MD5_Name, offset MD5_Details, offset MD5_DS, MD5_SigLength, offset SearchEngine_DWORD, offset MD5_FoundBool, offset MD5_FoundOffsets>

;****************************************************************************************************************************************************

MD5M_Name			db 	"MD5 (Modified Initialisation Vectors)", 0
MD5M_Details		db	"128bit Hashing Algorithm", 0
MD5M_DS				dd	0d76aa478h, 0e8c7b756h, 0242070dbh, 0c1bdceeeh, 0f57c0fafh, 04787c62ah, 0a8304613h
					dd	0fd469501h, 0698098d8h, 08b44f7afh, 0ffff5bb1h, 0895cd7beh, 06b901122h, 0fd987193h
					dd	0a679438eh, 049b40821h, 0f61e2562h, 0c040b340h, 0265e5a51h, 0e9b6c7aah, 0d62f105dh
					dd	002441453h, 0d8a1e681h, 0e7d3fbc8h, 021e1cde6h, 0c33707d6h, 0f4d50d87h, 0455a14edh
					dd	0a9e3e905h, 0fcefa3f8h, 0676f02d9h, 08d2a4c8ah, 0fffa3942h, 08771f681h, 06d9d6122h
					dd	0fde5380ch, 0a4beea44h, 04bdecfa9h, 0f6bb4b60h, 0bebfbc70h, 0289b7ec6h, 0eaa127fah
					dd	0d4ef3085h, 004881d05h, 0d9d4d039h, 0e6db99e5h, 01fa27cf8h, 0c4ac5665h, 0f4292244h
					dd	0432aff97h, 0ab9423a7h, 0fc93a039h, 0655b59c3h, 08f0ccc92h, 0ffeff47dh, 085845dd1h
					dd	06fa87e4fh, 0fe2ce6e0h, 0a3014314h, 04e0811a1h, 0f7537e82h, 0bd3af235h, 02ad7d2bbh
					dd	0eb86d391h, 0
MD5M_SigLength		equ ($ - MD5M_DS)/4 - 1
MD5M_FoundBool		dd	00h
MD5M_FoundOffsets	dd	MD5M_SigLength dup(00)

SIG_MD5M			SIG_DATA <offset MD5M_Name, offset MD5M_Details, offset MD5M_DS, MD5M_SigLength, offset SearchEngine_DWORD, offset MD5M_FoundBool, offset MD5M_FoundOffsets>

;****************************************************************************************************************************************************

MD5U_Name			db 	"MD5 (Unicode)", 0
MD5U_Details		db	"128bit Hashing Algorithm", 0
MD5U_DS				dd	00370036h, 00350034h, 00330032h, 00310030h, 00660065h, 00640063h, 00620061h, 00390038h
					dd	00380039h, 00610062h, 00630064h, 00650066h, 00300031h, 00320033h, 00340035h, 00360037h
					dd	00370064h, 00610036h, 00340061h, 00380037h, 0
MD5U_SigLength		equ ($ - MD5U_DS)/4 - 1
MD5U_FoundBool		dd	00h
MD5U_FoundOffsets	dd	MD5U_SigLength dup(00)

SIG_MD5U			SIG_DATA <offset MD5U_Name, offset MD5U_Details, offset MD5U_DS, MD5U_SigLength, offset SearchEngine_DWORD, offset MD5U_FoundBool, offset MD5U_FoundOffsets>

;****************************************************************************************************************************************************

SHA1_Name			db 	"SHA1", 0
SHA1_Details		db	"160bit Hashing Algorithm", 0
SHA1_DS				dd	067452301h, 0efcdab89h, 098badcfeh, 010325476h, 0c3d2e1f0h, 05a827999h, 06ed9eba1h
					dd	08f1bbcdch, 0ca62c1d6h, 0
SHA1_SigLength		equ ($ - SHA1_DS)/4 - 1
SHA1_FoundBool		dd	00h
SHA1_FoundOffsets	dd	SHA1_SigLength dup(00)

SIG_SHA1			SIG_DATA <offset SHA1_Name, offset SHA1_Details, offset SHA1_DS, SHA1_SigLength, offset SearchEngine_DWORD, offset SHA1_FoundBool, offset SHA1_FoundOffsets>

;****************************************************************************************************************************************************

SHA1M_Name			db 	"SHA1 (Modified Initialisation Vectors)", 0
SHA1M_Details		db	"160bit Hashing Algorithm", 0
SHA1M_DS			dd	5a827999h, 6ed9eba1h, 8f1bbcdch, 0ca62c1d6h, 0
SHA1M_SigLength		equ ($ - SHA1M_DS)/4 - 1
SHA1M_FoundBool		dd	00h
SHA1M_FoundOffsets	dd	SHA1M_SigLength dup(00)

SIG_SHA1M			SIG_DATA <offset SHA1M_Name, offset SHA1M_Details, offset SHA1M_DS, SHA1M_SigLength, offset SearchEngine_DWORD, offset SHA1M_FoundBool, offset SHA1M_FoundOffsets>

;****************************************************************************************************************************************************

SHA1U_Name			db 	"SHA1 (Unicode)", 0
SHA1U_Details		db	"160bit Hashing Algorithm", 0
SHA1U_DS			dd	00370036h, 00350034h, 00330032h, 00310030h, 00660065h, 00640063h, 00620061h, 00390038h
					dd	00380039h, 00610062h, 00630064h, 00650066h, 00300031h, 00320033h, 00340035h, 00360037h
					dd	00610035h, 00320038h, 00390037h, 00390039h, 0
SHA1U_SigLength		equ ($ - SHA1U_DS)/4 - 1
SHA1U_FoundBool		dd	00h
SHA1U_FoundOffsets	dd	SHA1U_SigLength dup(00)

SIG_SHA1U			SIG_DATA <offset SHA1U_Name, offset SHA1U_Details, offset SHA1U_DS, SHA1U_SigLength, offset SearchEngine_DWORD, offset SHA1U_FoundBool, offset SHA1U_FoundOffsets>

;****************************************************************************************************************************************************

SHA224_Name			db 	"SHA224", 0
SHA224_Details		db	"224bit Hashing Algorithm", 0
SHA224_DS			dd	0c1059ed8h, 0367cd507h, 03070dd17h, 0f70e5939h, 0ffc00b31h, 068581511h, 064f98fa7h
					dd	0befa4fa4h, 0
SHA224_SigLength	equ ($ - SHA224_DS)/4 - 1
SHA224_FoundBool	dd	00h
SHA224_FoundOffsets	dd	SHA224_SigLength dup(00)

SIG_SHA224			SIG_DATA <offset SHA224_Name, offset SHA224_Details, offset SHA224_DS, SHA224_SigLength, offset SearchEngine_DWORD, offset SHA224_FoundBool, offset SHA224_FoundOffsets>

;****************************************************************************************************************************************************

SHA256_Name			db 	"SHA256", 0
SHA256_Details		db	"256bit Hashing Algorithm", 0
SHA256_DS			dd	06a09e667h, 0bb67ae85h, 03c6ef372h, 0a54ff53ah, 0510e527fh, 09b05688ch, 01f83d9abh
					dd	05be0cd19h, 0428a2f98h, 071374491h, 0b5c0fbcfh, 0e9b5dba5h, 03956c25bh, 059f111f1h
					dd	0923f82a4h, 0ab1c5ed5h, 0d807aa98h, 012835b01h, 0243185beh, 0550c7dc3h, 072be5d74h
					dd	080deb1feh, 09bdc06a7h, 0c19bf174h, 0e49b69c1h, 0efbe4786h, 00fc19dc6h, 0240ca1cch
					dd	02de92c6fh, 04a7484aah, 05cb0a9dch, 076f988dah, 0983e5152h, 0a831c66dh, 0b00327c8h
					dd	0bf597fc7h, 0c6e00bf3h, 0d5a79147h, 006ca6351h, 014292967h, 027b70a85h, 02e1b2138h
					dd	04d2c6dfch, 053380d13h, 0650a7354h, 0766a0abbh, 081c2c92eh, 092722c85h, 0a2bfe8a1h
					dd	0a81a664bh, 0c24b8b70h, 0c76c51a3h, 0d192e819h, 0d6990624h, 0f40e3585h, 0106aa070h 
					dd	019a4c116h, 01e376c08h, 02748774ch, 034b0bcb5h, 0391c0cb3h, 04ed8aa4ah, 05b9cca4fh
					dd	0682e6ff3h, 0748f82eeh, 078a5636fh, 084c87814h, 08cc70208h, 090befffah, 0a4506cebh
					dd	0bef9a3f7h, 0c67178f2h, 0
SHA256_SigLength	equ ($ - SHA256_DS)/4 - 1
SHA256_FoundBool	dd	00h
SHA256_FoundOffsets	dd	SHA256_SigLength dup(00)

SIG_SHA256			SIG_DATA <offset SHA256_Name, offset SHA256_Details, offset SHA256_DS, SHA256_SigLength, offset SearchEngine_DWORD, offset SHA256_FoundBool, offset SHA256_FoundOffsets>

;****************************************************************************************************************************************************

SHA256M_Name		db 	"SHA256 (Modified Initialisation Vectors)", 0
SHA256M_Details		db	"256bit Hashing Algorithm", 0
SHA256M_DS			dd	0428a2f98h, 071374491h, 0b5c0fbcfh, 0e9b5dba5h, 03956c25bh, 059f111f1h, 0923f82a4h
					dd	0ab1c5ed5h, 0d807aa98h, 012835b01h, 0243185beh, 0550c7dc3h, 072be5d74h, 080deb1feh
					dd	09bdc06a7h, 0c19bf174h, 0e49b69c1h, 0efbe4786h, 00fc19dc6h, 0240ca1cch, 02de92c6fh
					dd	04a7484aah, 05cb0a9dch, 076f988dah, 0983e5152h, 0a831c66dh, 0b00327c8h, 0bf597fc7h
					dd	0c6e00bf3h, 0d5a79147h, 006ca6351h, 014292967h, 027b70a85h, 02e1b2138h, 04d2c6dfch
					dd	053380d13h, 0650a7354h, 0766a0abbh, 081c2c92eh, 092722c85h, 0a2bfe8a1h, 0a81a664bh
					dd	0c24b8b70h, 0c76c51a3h, 0d192e819h, 0d6990624h, 0f40e3585h, 0106aa070h, 019a4c116h
					dd	01e376c08h, 02748774ch, 034b0bcb5h, 0391c0cb3h, 04ed8aa4ah, 05b9cca4fh, 0682e6ff3h
					dd	0748f82eeh, 078a5636fh, 084c87814h, 08cc70208h, 090befffah, 0a4506cebh, 0bef9a3f7h
					dd	0c67178f2h, 0
SHA256M_SigLength	equ ($ - SHA256M_DS)/4 - 1
SHA256M_FoundBool	dd	00h
SHA256M_FO			dd	SHA256M_SigLength dup(00)

SIG_SHA256M			SIG_DATA <offset SHA256M_Name, offset SHA256M_Details, offset SHA256M_DS, SHA256M_SigLength, offset SearchEngine_DWORD, offset SHA256M_FoundBool, offset SHA256M_FO>

;****************************************************************************************************************************************************

SHA384_Name			db 	"SHA384", 0
SHA384_Details		db	"384bit Hashing Algorithm", 0
SHA384_DS			dq 0cbbb9d5dc1059ed8h, 0629a292a367cd507h, 09159015a3070dd17h, 0152fecd8f70e5939h
					dq 067332667ffc00b31h, 08eb44a8768581511h, 0db0c2e0d64f98fa7h, 047b5481dbefa4fa4h
					dq 0428a2f98d728ae22h, 07137449123ef65cdh, 0b5c0fbcfec4d3b2fh, 0e9b5dba58189dbbch
					dq 03956c25bf348b538h, 059f111f1b605d019h, 0923f82a4af194f9bh, 0ab1c5ed5da6d8118h
					dq 0d807aa98a3030242h, 012835b0145706fbeh, 0243185be4ee4b28ch, 0550c7dc3d5ffb4e2h
					dq 072be5d74f27b896fh, 080deb1fe3b1696b1h, 09bdc06a725c71235h, 0c19bf174cf692694h
					dq 0e49b69c19ef14ad2h, 0efbe4786384f25e3h, 00fc19dc68b8cd5b5h, 0240ca1cc77ac9c65h
					dq 02de92c6f592b0275h, 04a7484aa6ea6e483h, 05cb0a9dcbd41fbd4h, 076f988da831153b5h
					dq 0983e5152ee66dfabh, 0a831c66d2db43210h, 0b00327c898fb213fh, 0bf597fc7beef0ee4h
					dq 0c6e00bf33da88fc2h, 0d5a79147930aa725h, 006ca6351e003826fh, 0142929670a0e6e70h
					dq 027b70a8546d22ffch, 02e1b21385c26c926h, 04d2c6dfc5ac42aedh, 053380d139d95b3dfh
					dq 0650a73548baf63deh, 0766a0abb3c77b2a8h, 081c2c92e47edaee6h, 092722c851482353bh
					dq 0a2bfe8a14cf10364h, 0a81a664bbc423001h, 0c24b8b70d0f89791h, 0c76c51a30654be30h
					dq 0d192e819d6ef5218h, 0d69906245565a910h, 0f40e35855771202ah, 0106aa07032bbd1b8h
					dq 019a4c116b8d2d0c8h, 01e376c085141ab53h, 02748774cdf8eeb99h, 034b0bcb5e19b48a8h
					dq 0391c0cb3c5c95a63h, 04ed8aa4ae3418acbh, 05b9cca4f7763e373h, 0682e6ff3d6b2b8a3h
					dq 0748f82ee5defb2fch, 078a5636f43172f60h, 084c87814a1f0ab72h, 08cc702081a6439ech
					dq 090befffa23631e28h, 0a4506cebde82bde9h, 0bef9a3f7b2c67915h, 0c67178f2e372532bh
					dq 0ca273eceea26619ch, 0d186b8c721c0c207h, 0eada7dd6cde0eb1eh, 0f57d4f7fee6ed178h
					dq 006f067aa72176fbah, 00a637dc5a2c898a6h, 0113f9804bef90daeh, 01b710b35131c471bh
					dq 028db77f523047d84h, 032caab7b40c72493h, 03c9ebe0a15c9bebch, 0431d67c49c100d4ch
					dq 04cc5d4becb3e42b6h, 0597f299cfc657e2ah, 05fcb6fab3ad6faech, 06c44198c4a475817h, 0
SHA384_SigLength	equ ($ - SHA384_DS)/4 - 1
SHA384_FoundBool	dd	00h
SHA384_FoundOffsets	dd	SHA384_SigLength dup(00)

SIG_SHA384			SIG_DATA <offset SHA384_Name, offset SHA384_Details, offset SHA384_DS, SHA384_SigLength, offset SearchEngine_DWORD, offset SHA384_FoundBool, offset SHA384_FoundOffsets>

;****************************************************************************************************************************************************

SHA512_Name			db 	"SHA512", 0
SHA512_Details		db	"512bit Hashing Algorithm", 0
SHA512_DS			dq	06a09e667f3bcc908h, 0bb67ae8584caa73bh, 03c6ef372fe94f82bh, 0a54ff53a5f1d36f1h
					dq	0510e527fade682d1h, 09b05688c2b3e6c1fh, 01f83d9abfb41bd6bh, 05be0cd19137e2179h
					dq	0428a2f98d728ae22h, 07137449123ef65cdh, 0b5c0fbcfec4d3b2fh, 0e9b5dba58189dbbch
					dq	03956c25bf348b538h, 059f111f1b605d019h, 0923f82a4af194f9bh, 0ab1c5ed5da6d8118h
					dq	0d807aa98a3030242h, 012835b0145706fbeh, 0243185be4ee4b28ch, 0550c7dc3d5ffb4e2h
					dq	072be5d74f27b896fh, 080deb1fe3b1696b1h, 09bdc06a725c71235h, 0c19bf174cf692694h
					dq	0e49b69c19ef14ad2h, 0efbe4786384f25e3h, 00fc19dc68b8cd5b5h, 0240ca1cc77ac9c65h
					dq	02de92c6f592b0275h, 04a7484aa6ea6e483h, 05cb0a9dcbd41fbd4h, 076f988da831153b5h
					dq	0983e5152ee66dfabh, 0a831c66d2db43210h, 0b00327c898fb213fh, 0bf597fc7beef0ee4h
					dq	0c6e00bf33da88fc2h, 0d5a79147930aa725h, 006ca6351e003826fh, 0142929670a0e6e70h
					dq	027b70a8546d22ffch, 02e1b21385c26c926h, 04d2c6dfc5ac42aedh, 053380d139d95b3dfh
					dq	0650a73548baf63deh, 0766a0abb3c77b2a8h, 081c2c92e47edaee6h, 092722c851482353bh
					dq	0a2bfe8a14cf10364h, 0a81a664bbc423001h, 0c24b8b70d0f89791h, 0c76c51a30654be30h
					dq	0d192e819d6ef5218h, 0d69906245565a910h, 0f40e35855771202ah, 0106aa07032bbd1b8h
					dq	019a4c116b8d2d0c8h, 01e376c085141ab53h, 02748774cdf8eeb99h, 034b0bcb5e19b48a8h
					dq	0391c0cb3c5c95a63h, 04ed8aa4ae3418acbh, 05b9cca4f7763e373h, 0682e6ff3d6b2b8a3h
					dq	0748f82ee5defb2fch, 078a5636f43172f60h, 084c87814a1f0ab72h, 08cc702081a6439ech
					dq	090befffa23631e28h, 0a4506cebde82bde9h, 0bef9a3f7b2c67915h, 0c67178f2e372532bh
					dq	0ca273eceea26619ch, 0d186b8c721c0c207h, 0eada7dd6cde0eb1eh, 0f57d4f7fee6ed178h
					dq	006f067aa72176fbah, 00a637dc5a2c898a6h, 0113f9804bef90daeh, 01b710b35131c471bh
					dq	028db77f523047d84h, 032caab7b40c72493h, 03c9ebe0a15c9bebch, 0431d67c49c100d4ch
					dq	04cc5d4becb3e42b6h, 0597f299cfc657e2ah, 05fcb6fab3ad6faech, 06c44198c4a475817h, 0
SHA512_SigLength	equ ($ - SHA512_DS)/4 - 1
SHA512_FoundBool	dd	00h
SHA512_FoundOffsets	dd	SHA512_SigLength dup(00)

SIG_SHA512			SIG_DATA <offset SHA512_Name, offset SHA512_Details, offset SHA512_DS, SHA512_SigLength, offset SearchEngine_DWORD, offset SHA512_FoundBool, offset SHA512_FoundOffsets>

;****************************************************************************************************************************************************

SHA384512M_Name		db 	"SHA512 or SHA384 (Modified Initialisation Vectors)", 0
SHA384512M_Details	db	"384 or 512bit Hashing Algorithms", 0
SHA384512M_DS		dq	0428a2f98d728ae22h, 07137449123ef65cdh, 0b5c0fbcfec4d3b2fh, 0e9b5dba58189dbbch
					dq	03956c25bf348b538h, 059f111f1b605d019h, 0923f82a4af194f9bh, 0ab1c5ed5da6d8118h
					dq	0d807aa98a3030242h, 012835b0145706fbeh, 0243185be4ee4b28ch, 0550c7dc3d5ffb4e2h
					dq	072be5d74f27b896fh, 080deb1fe3b1696b1h, 09bdc06a725c71235h, 0c19bf174cf692694h
					dq	0e49b69c19ef14ad2h, 0efbe4786384f25e3h, 00fc19dc68b8cd5b5h, 0240ca1cc77ac9c65h
					dq	02de92c6f592b0275h, 04a7484aa6ea6e483h, 05cb0a9dcbd41fbd4h, 076f988da831153b5h
					dq	0983e5152ee66dfabh, 0a831c66d2db43210h, 0b00327c898fb213fh, 0bf597fc7beef0ee4h
					dq	0c6e00bf33da88fc2h, 0d5a79147930aa725h, 006ca6351e003826fh, 0142929670a0e6e70h
					dq	027b70a8546d22ffch, 02e1b21385c26c926h, 04d2c6dfc5ac42aedh, 053380d139d95b3dfh
					dq	0650a73548baf63deh, 0766a0abb3c77b2a8h, 081c2c92e47edaee6h, 092722c851482353bh
					dq	0a2bfe8a14cf10364h, 0a81a664bbc423001h, 0c24b8b70d0f89791h, 0c76c51a30654be30h
					dq	0d192e819d6ef5218h, 0d69906245565a910h, 0f40e35855771202ah, 0106aa07032bbd1b8h
					dq	019a4c116b8d2d0c8h, 01e376c085141ab53h, 02748774cdf8eeb99h, 034b0bcb5e19b48a8h
					dq	0391c0cb3c5c95a63h, 04ed8aa4ae3418acbh, 05b9cca4f7763e373h, 0682e6ff3d6b2b8a3h
					dq	0748f82ee5defb2fch, 078a5636f43172f60h, 084c87814a1f0ab72h, 08cc702081a6439ech
					dq	090befffa23631e28h, 0a4506cebde82bde9h, 0bef9a3f7b2c67915h, 0c67178f2e372532bh
					dq	0ca273eceea26619ch, 0d186b8c721c0c207h, 0eada7dd6cde0eb1eh, 0f57d4f7fee6ed178h
					dq	006f067aa72176fbah, 00a637dc5a2c898a6h, 0113f9804bef90daeh, 01b710b35131c471bh
					dq	028db77f523047d84h, 032caab7b40c72493h, 03c9ebe0a15c9bebch, 0431d67c49c100d4ch
					dq	04cc5d4becb3e42b6h, 0597f299cfc657e2ah, 05fcb6fab3ad6faech, 06c44198c4a475817h, 0
SHA384512M_SL		equ ($ - SHA384512M_DS)/4 - 1
SHA384512M_FB		dd	00h
SHA384512M_FO		dd	SHA384512M_SL dup(00)

SIG_SHA384512M		SIG_DATA <offset SHA384512M_Name, offset SHA384512M_Details, offset SHA384512M_DS, SHA384512M_SL, offset SearchEngine_DWORD, offset SHA384512M_FB, offset SHA384512M_FO>

;****************************************************************************************************************************************************

RIPEMD128_Name		db 	"RIPEMD128", 0
RIPEMD128_Details	db	"128bit Hashing Algorithm", 0
RIPEMD128_DS		dd	067452301h, 0efcdab89h, 098badcfeh, 010325476h, 05a827999h, 06ed9eba1h, 08f1bbcdch
					dd	050a28be6h, 05c4dd124h, 06d703ef3h, 0
RIPEMD128_SigLength	equ ($ - RIPEMD128_DS)/4 - 1
RIPEMD128_FoundBool	dd	00h
RIPEMD128_FO		dd	RIPEMD128_SigLength dup(00)

SIG_RIPEMD128		SIG_DATA <offset RIPEMD128_Name, offset RIPEMD128_Details, offset RIPEMD128_DS, RIPEMD128_SigLength, offset SearchEngine_DWORD, offset RIPEMD128_FoundBool, offset RIPEMD128_FO>

;****************************************************************************************************************************************************

RIPEMD160_Name		db 	"RIPEMD160", 0
RIPEMD160_Details	db	"160bit Hashing Algorithm", 0
RIPEMD160_DS		dd	067452301h, 0efcdab89h, 098badcfeh, 010325476h, 0c3d2e1f0h, 05a827999h, 06ed9eba1h
					dd	08f1bbcdch, 0a953fd4eh, 050a28be6h, 05c4dd124h, 06d703ef3h, 07a6d76e9h, 0
RIPEMD160_SigLength	equ ($ - RIPEMD160_DS)/4 - 1
RIPEMD160_FoundBool	dd	00h
RIPEMD160_FO		dd	RIPEMD160_SigLength dup(00)

SIG_RIPEMD160		SIG_DATA <offset RIPEMD160_Name, offset RIPEMD160_Details, offset RIPEMD160_DS, RIPEMD160_SigLength, offset SearchEngine_DWORD, offset RIPEMD160_FoundBool, offset RIPEMD160_FO>

;****************************************************************************************************************************************************

RIPEMD256_Name		db 	"RIPEMD256", 0
RIPEMD256_Details	db	"256bit Hashing Algorithm", 0
RIPEMD256_DS		dd	067452301h, 0efcdab89h, 098badcfeh, 010325476h, 076543210h, 0fedcba98h, 089abcdefh
					dd	001234567h, 05a827999h, 06ed9eba1h, 08f1bbcdch, 050a28be6h, 05c4dd124h, 06d703ef3h, 0
RIPEMD256_SigLength	equ ($ - RIPEMD256_DS)/4 - 1
RIPEMD256_FoundBool	dd	00h
RIPEMD256_FO		dd	RIPEMD256_SigLength dup(00)

SIG_RIPEMD256		SIG_DATA <offset RIPEMD256_Name, offset RIPEMD256_Details, offset RIPEMD256_DS, RIPEMD256_SigLength, offset SearchEngine_DWORD, offset RIPEMD256_FoundBool, offset RIPEMD256_FO>

;****************************************************************************************************************************************************

RIPEMD320_Name		db 	"RIPEMD320", 0
RIPEMD320_Details	db	"320bit Hashing Algorithm", 0
RIPEMD320_DS		dd	067452301h, 0efcdab89h, 098badcfeh, 010325476h, 0c3d2e1f0h, 076543210h, 0fedcba98h
					dd	089abcdefh, 001234567h, 03c2d1e0fh, 05a827999h, 06ed9eba1h, 08f1bbcdch, 050a28be6h
					dd	05c4dd124h, 06d703ef3h, 07a6d76e9h, 0a953fd4eh, 0
RIPEMD320_SigLength	equ ($ - RIPEMD320_DS)/4 - 1
RIPEMD320_FoundBool	dd	00h
RIPEMD320_FO		dd	RIPEMD320_SigLength dup(00)

SIG_RIPEMD320		SIG_DATA <offset RIPEMD320_Name, offset RIPEMD320_Details, offset RIPEMD320_DS, RIPEMD320_SigLength, offset SearchEngine_DWORD, offset RIPEMD320_FoundBool, offset RIPEMD320_FO>

;****************************************************************************************************************************************************

TIGER_Name			db 	"Tiger", 0
TIGER_Details		db	"192bit Hashing Algorithm", 0
TIGER_DS			dq	00123456789abcdefh, 0fedcba9876543210h, 0f096a5b4c3b2e187h, 06d019b93f6f97f3ah
					dq	0cd9978ffd21f9193h, 07573a1c9708029e2h, 0b164326b922a83c3h, 046883eee04915870h
					dq	0eaace3057103ece6h, 0c54169b808a3535ch, 04ce754918ddec47ch, 00aa2f4dfdc0df40ch
					dq	010b76f18a74dbefah, 0c6ccb6235ad1ab6ah, 013726121572fe2ffh, 01a488c6f199d921eh
					dq	04bc9f9f4da0007cah, 026f5e6f6e85241c7h, 0859079dbea5947b6h, 04f1885c5c99e8c92h
					dq	0d78e761ea96f864bh, 08e36428c52b5c17dh, 069cf6827373063c1h, 0b607c93d9bb4c56eh
					dq	07d820e760e76b5eah, 0645c9cc6f07fdc42h, 0bf38a078243342e0h, 05f6b343c9d2e7d04h
					dq	0f2c28aeb600b0ec6h, 06c0ed85f7254bcach, 071592281a4db4fe5h, 01967fa69ce0fed9fh
					dq	0fd5293f8b96545dbh, 0c879e9d7f2a7600bh, 0860248920193194eh, 0a4f9533b2d9cc0b3h
					dq	0e9214e7f22d8b4dfh, 02addbf532eac95f4h, 032ae3909b4bd0109h, 0834df537b08e3450h
					dq	0fa209da84220728dh, 09e691d9b9efe23f7h, 00446d288c4ae8d7fh, 07b4cc524e169785bh
					dq	021d87f0135ca1385h, 0cebb400f137b8aa5h, 0272e2b66580796beh, 03612264125c2b0deh, 0 
TIGER_SigLength		equ ($ - TIGER_DS)/4 - 1
TIGER_FoundBool		dd	00h
TIGER_FoundOffsets	dd	TIGER_SigLength dup(00)

SIG_TIGER			SIG_DATA <offset TIGER_Name, offset TIGER_Details, offset TIGER_DS, TIGER_SigLength, offset SearchEngine_DWORD, offset TIGER_FoundBool, offset TIGER_FoundOffsets>

;****************************************************************************************************************************************************

WHIRLPOOL_Name		db 	"Whirlpool", 0
WHIRLPOOL_Details	db	"512bit Hashing Algorithm", 0
WHIRLPOOL_DS		dq	01823c6e887b8014fh, 036a6d2f5796f9152h, 060bc9b8ea30c7b35h, 01de0d7c22e4bfe57h
					dq	0157737e59ff04adah, 058c9290ab1a06b85h, 0bd5d10f4cb3e0567h, 0e427418ba77d95d8h
					dq	0fbee7c66dd17479eh, 0ca2dbf07ad5a8333h, 0c6c63fc67ef991b8h, 0e8e887e8136fcdfbh
					dq	0878726874ca113cbh, 0b8b8dab8a9626d11h, 00101040108050209h, 04f4f214f426e9e0dh
					dq	03636d836adee6c9bh, 0a6a6a2a6590451ffh, 0d2d26fd2debdb90ch, 0f5f5f3f5fb06f70eh
					dq	07979f979ef80f296h, 06f6fa16f5fcede30h, 091917e91fcef3f6dh, 052525552aa07a4f8h
					dq	0b5b5eeb5c15b7774h, 0afaf86af112943beh, 06a6ab56a77dfd41dh, 050505d50ba0da0eah
					dq	045450945124c8a57h, 0f3f3ebf3cb18fb38h, 03030c0309df060adh, 0efef9bef2b74c3c4h
					dq	0d4caca0fca1ec589h, 0582d2db42d75995ah, 02ebfbfc6bf917963h, 03f07071c07381b0eh
					dq	0acadad8ead012347h, 0b05a5a755aea2fb4h, 0ef838336836cb51bh, 0b63333cc3385ff66h, 0
WHIRLPOOL_SigLength	equ ($ - WHIRLPOOL_DS)/4 - 1
WHIRLPOOL_FoundBool	dd	00h
WHIRLPOOL_FO		dd	WHIRLPOOL_SigLength dup(00)

SIG_WHIRLPOOL		SIG_DATA <offset WHIRLPOOL_Name, offset WHIRLPOOL_Details, offset WHIRLPOOL_DS, WHIRLPOOL_SigLength, offset SearchEngine_DWORD, offset WHIRLPOOL_FoundBool, offset WHIRLPOOL_FO>

;****************************************************************************************************************************************************

HAVAL_Name			db 	"HAVAL", 0
HAVAL_Details		db	"192->256bit Hashing Algorithm (3->5 Rounds)", 0
HAVAL_DS			dd	0243f6a88h, 085a308d3h, 013198a2eh, 003707344h, 0a4093822h, 0299f31d0h, 0082efa98h
					dd	0ec4e6c89h, 0000000ffh, 0ff000000h, 000ff0000h, 00000ff00h, 0
HAVAL_SigLength	equ ($ - HAVAL_DS)/4 - 1
HAVAL_FoundBool	dd	00h
HAVAL_FoundOffsets	dd	HAVAL_SigLength dup(00)

SIG_HAVAL			SIG_DATA <offset HAVAL_Name, offset HAVAL_Details, offset HAVAL_DS, HAVAL_SigLength, offset SearchEngine_DWORD, offset HAVAL_FoundBool, offset HAVAL_FoundOffsets>

;****************************************************************************************************************************************************

