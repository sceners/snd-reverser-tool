

.data
HavalSIZE dd 256
HavalPASS dd 5
HavalVERSION equ 1
;HavalOLD equ 1

.data?
HavalHashBuf db 128 dup(?)
HavalLen dd ?
HavalIndex dd ?
HavalDigest dd 8 dup(?)


.code

F_x macro xX, wW, cC
	ror eax, 7
	mov ecx, xX
	ror ecx, 11
	add eax, wW
	ifb <cC>
	add eax, ecx
	else
	lea eax, [eax+ecx+cC]
	endif
	mov xX, eax
endm

F_1 macro _x6, _x5, _x4, _x3, _x2, _x1, _x0
	mov eax, _x0
	mov ecx, _x2
	mov edx, _x3
	xor eax, _x4;x0 ^ x4
	and ecx, _x5;x2 & x5
	and eax, _x1;x1 & (x0^x4)
	and edx, _x6;x3 & x6
	xor eax, ecx
	xor eax, edx
	xor eax, _x0
endm

F_2 macro _x6, _x5, _x4, _x3, _x2, _x1, _x0
	mov eax, _x3
	mov ebx, _x1
	xor eax, -1
	mov edx, _x5
	mov ecx, _x4
	and eax, ebx
	and ecx, edx
	xor eax, _x6
	xor eax, ecx
	xor eax, _x0;(x1) & ~(x3) ^ (x4) & (x5) ^ (x6) ^ (x0)
	and eax, _x2
	xor ebx, edx
	and ebx, _x4
	and edx, _x3
	xor edx, ebx
	xor eax, _x0
	xor eax, edx
endm

F_3 macro _x6, _x5, _x4, _x3, _x2, _x1, _x0
	mov eax, _x2
	mov ecx, _x1
	mov edx, _x0
	and eax, ecx
	xor eax, _x6
	mov ebx, _x5
	xor eax, edx;(x1) & (x2) ^ (x6) ^ (x0)
	and eax, _x3
	and ecx, _x4
	and ebx, _x2
	xor eax, ecx
	xor eax, edx
	xor eax, ebx
endm

F_4 macro _x6, _x5, _x4, _x3, _x2, _x1, _x0
	mov ecx, _x5
	mov edx, _x6
	mov eax, _x2
	mov ebx, edx
	xor ebx, -1
	and ebx, _x3
	xor eax, -1
	and eax, ecx
	xor eax, ebx
	xor eax, edx;x6
	xor eax, _x1
	xor eax, _x0;(x5) & ~(x2) ^ (x3) & ~(x6) ^ (x1) ^ (x6) ^ (x0)
	and eax, _x4
	mov ecx, _x2
	and ecx, _x1
	xor ecx, edx
	xor ecx, _x5;(x1) & (x2) ^ (x5) ^ (x6)
	and ecx, _x3
	and edx, _x2
	xor edx, _x0
	xor eax, ecx
	xor eax, edx
endm

F_5 macro _x6, _x5, _x4, _x3, _x2, _x1, _x0
	mov eax, _x1
	mov ecx, _x2
	mov edx, _x3
	and eax, ecx
	mov ebx, _x5
	and eax, edx
	xor eax, -1
	xor eax, ebx
	and eax, _x0
	and ecx, ebx
	xor eax, ecx
	mov ebx, _x1
	mov edx, _x3
	and ebx, _x4
	and edx, _x6
	xor eax, ebx
	xor eax, edx
endm

HavalPASS1_T3 macro x7, x6, x5, x4, x3, x2, x1, x0, w
	F_1 x1, x0, x3, x5, x6, x2, x4
	F_x x7, w
endm

HavalPASS1_T4 macro x7, x6, x5, x4, x3, x2, x1, x0, w
	F_1 x2, x6, x1, x4, x5, x3, x0
	F_x x7, w
endm

HavalPASS1_T5 macro x7, x6, x5, x4, x3, x2, x1, x0, w
	F_1 x3, x4, x1, x0, x5, x2, x6
	F_x x7, w
endm

HavalPASS2_T3 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_2 x4, x2, x1, x0, x5, x3, x6
	F_x x7, w, _c
endm

HavalPASS2_T4 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_2 x3, x5, x2, x0, x1, x6, x4
	F_x x7, w, _c
endm

HavalPASS2_T5 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_2 x6, x2, x1, x0, x3, x4, x5
	F_x x7, w, _c
endm

HavalPASS3_T3 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_3 x6, x1, x2, x3, x4, x5, x0
	F_x x7, w, _c
endm

HavalPASS3_T4 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_3 x1, x4, x3, x6, x0, x2, x5
	F_x x7, w, _c
endm

HavalPASS3_T5 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_3 x2, x6, x0, x4, x3, x1, x5
	F_x x7, w, _c
endm

HavalPASS4_T4 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_4 x6, x4, x0, x5, x2, x1, x3
	F_x x7, w, _c
endm

HavalPASS4_T5 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_4 x1, x5, x3, x2, x0, x4, x6
	F_x x7, w, _c
endm

HavalPASS5_T5 macro x7, x6, x5, x4, x3, x2, x1, x0, w, _c
	F_5 x2, x5, x0, x6, x4, x3, x1
	F_x x7, w, _c
endm

HavalBURN macro
	xor eax, eax
	mov HavalIndex, eax
	mov edi, Offset HavalHashBuf
	mov ecx, 128/4
	rep stosd
endm

;***************************************************************************************
;Start Haval Handler functions
;***************************************************************************************

HAVAL128_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call EnableKeyEdit
		movzx eax, byte ptr[sKeyIn]

		.if	eax >= 3 && eax <= 5 || eax >= '3' && eax <= '5'
			.if	eax > 5
				sub eax, 30h
			.endif

			push eax
			push 128
			call HavalInit
			push [_len]
			push _Input
			call HavalUpdate
			call HavalFinal

			mov	edi, eax			
			xor	ebx, ebx
		@@:
			mov	eax, dword ptr[edi+ebx*4]
			bswap eax
			invoke wsprintf, _Input, addr hex32bitlc, eax
			invoke lstrcat, _Output, _Input
			inc	ebx
			cmp	ebx, 4
			jl @b

			invoke lstrlen, _Output
			HexLen
		.else
			invoke SetDlgItemText, hWindow, IDC_INFO, addr ErrorHavalRounds
			mov	eax, -1
		.endif
		ret
HAVAL128_RT endp


HAVAL160_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call EnableKeyEdit
		movzx eax, byte ptr[sKeyIn]

		.if	eax >= 3 && eax <= 5 || eax >= '3' && eax <= '5'
			.if	eax > 5
				sub eax, 30h
			.endif

			push eax
			push 160
			call HavalInit
			push [_len]
			push _Input
			call HavalUpdate
			call HavalFinal

			mov	edi, eax
			xor	ebx, ebx
		@@:
			mov	eax, dword ptr[edi+ebx*4]
			bswap eax
			invoke wsprintf, _Input, addr hex32bitlc, eax
			invoke lstrcat, _Output, _Input
			inc	ebx
			cmp	ebx, 5
			jl @b

			invoke lstrlen, _Output
			HexLen
		.else
			invoke SetDlgItemText, hWindow, IDC_INFO, addr ErrorHavalRounds
			mov	eax, -1
		.endif
		ret
HAVAL160_RT endp


HAVAL192_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call EnableKeyEdit
		movzx eax, byte ptr[sKeyIn]

		.if	eax >= 3 && eax <= 5 || eax >= '3' && eax <= '5'
			.if	eax > 5
				sub eax, 30h
			.endif

			push eax
			push 192
			call HavalInit
			push [_len]
			push _Input
			call HavalUpdate
			call HavalFinal

			mov	edi, eax
			xor	ebx, ebx
		@@:
			mov	eax, dword ptr[edi+ebx*4]
			bswap eax
			invoke wsprintf, _Input, addr hex32bitlc, eax
			invoke lstrcat, _Output, _Input
			inc	ebx
			cmp	ebx, 6
			jl @b

			invoke lstrlen, _Output
			HexLen
		.else
			invoke SetDlgItemText, hWindow, IDC_INFO, addr ErrorHavalRounds
			mov	eax, -1
		.endif
		ret
HAVAL192_RT endp


HAVAL224_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call EnableKeyEdit
		movzx eax, byte ptr[sKeyIn]

		.if	eax >= 3 && eax <= 5 || eax >= '3' && eax <= '5'
			.if	eax > 5
				sub eax, 30h
			.endif

			push eax
			push 224
			call HavalInit
			push [_len]
			push _Input
			call HavalUpdate
			call HavalFinal

			mov	edi, eax
			xor	ebx, ebx
		@@:
			mov	eax, dword ptr[edi+ebx*4]
			bswap eax
			invoke wsprintf, _Input, addr hex32bitlc, eax
			invoke lstrcat, _Output, _Input
			inc	ebx
			cmp	ebx, 7
			jl @b

			invoke lstrlen, _Output
			HexLen
		.else
			invoke SetDlgItemText, hWindow, IDC_INFO, addr ErrorHavalRounds
			mov	eax, -1
		.endif
		ret
HAVAL224_RT endp


HAVAL256_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call EnableKeyEdit
		movzx eax, byte ptr[sKeyIn]

		.if	eax >= 3 && eax <= 5 || eax >= '3' && eax <= '5'
			.if	eax > 5
				sub eax, 30h
			.endif

			push eax
			push 256
			call HavalInit
			push [_len]
			push _Input
			call HavalUpdate
			call HavalFinal

			mov	edi, eax
			xor	ebx, ebx
		@@:
			mov	eax, dword ptr[edi+ebx*4]
			bswap eax
			invoke wsprintf, _Input, addr hex32bitlc, eax
			invoke lstrcat, _Output, _Input
			inc	ebx
			cmp	ebx, 8
			jl @b

			invoke lstrlen, _Output
			HexLen
		.else
			invoke SetDlgItemText, hWindow, IDC_INFO, addr ErrorHavalRounds
			mov	eax, -1
		.endif
		ret
HAVAL256_RT endp



;***************************************************************************************
;Start Haval functions
;***************************************************************************************


align 4
HavalTransform3 proc
LOCAL t7, t6, t5, t4, t3, t2, t1, t0
	pushad
	mov esi, offset HavalDigest
	mov edi, offset HavalHashBuf
	mov	eax, dword ptr [esi+0*4]
	mov	ebx, dword ptr [esi+1*4]
	mov	ecx, dword ptr [esi+2*4]
	mov	edx, dword ptr [esi+3*4]
	mov	t0, eax
	mov	t1, ebx
	mov	t2, ecx
	mov	t3, edx
	mov	eax, dword ptr [esi+4*4]
	mov	ebx, dword ptr [esi+5*4]
	mov	ecx, dword ptr [esi+6*4]
	mov	edx, dword ptr [esi+7*4]
	mov	t4, eax
	mov	t5, ebx
	mov	t6, ecx
	mov	t7, edx
	; 1
	HavalPASS1_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*00]
	HavalPASS1_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*01]
	HavalPASS1_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*02]
	HavalPASS1_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*03]
	HavalPASS1_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*04]
	HavalPASS1_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*05]
	HavalPASS1_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*06]
	HavalPASS1_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*07]
	HavalPASS1_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*08]
	HavalPASS1_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*09]
	HavalPASS1_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*10]
	HavalPASS1_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*11]
	HavalPASS1_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*12]
	HavalPASS1_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*13]
	HavalPASS1_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*14]
	HavalPASS1_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*15]
	HavalPASS1_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*16]
	HavalPASS1_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*17]
	HavalPASS1_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*18]
	HavalPASS1_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*19]
	HavalPASS1_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*20]
	HavalPASS1_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*21]
	HavalPASS1_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*22]
	HavalPASS1_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*23]
	HavalPASS1_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*24]
	HavalPASS1_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*25]
	HavalPASS1_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*26]
	HavalPASS1_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*27]
	HavalPASS1_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*28]
	HavalPASS1_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*29]
	HavalPASS1_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*30]
	HavalPASS1_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*31]
	; 2 
	HavalPASS2_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*05], 0452821E6h
	HavalPASS2_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*14], 038D01377h
	HavalPASS2_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*26], 0BE5466CFh
	HavalPASS2_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*18], 034E90C6Ch
	HavalPASS2_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*11], 0C0AC29B7h
	HavalPASS2_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*28], 0C97C50DDh
	HavalPASS2_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*07], 03F84D5B5h
	HavalPASS2_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*16], 0B5470917h
	HavalPASS2_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*00], 09216D5D9h
	HavalPASS2_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*23], 08979FB1Bh
	HavalPASS2_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*20], 0D1310BA6h
	HavalPASS2_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*22], 098DFB5ACh
	HavalPASS2_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*01], 02FFD72DBh
	HavalPASS2_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*10], 0D01ADFB7h
	HavalPASS2_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*04], 0B8E1AFEDh
	HavalPASS2_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*08], 06A267E96h
	HavalPASS2_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*30], 0BA7C9045h
	HavalPASS2_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*03], 0F12C7F99h
	HavalPASS2_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*21], 024A19947h
	HavalPASS2_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*09], 0B3916CF7h
	HavalPASS2_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*17], 00801F2E2h
	HavalPASS2_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*24], 0858EFC16h
	HavalPASS2_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*29], 0636920D8h
	HavalPASS2_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*06], 071574E69h
	HavalPASS2_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*19], 0A458FEA3h
	HavalPASS2_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*12], 0F4933D7Eh
	HavalPASS2_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*15], 00D95748Fh
	HavalPASS2_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*13], 0728EB658h
	HavalPASS2_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*02], 0718BCD58h
	HavalPASS2_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*25], 082154AEEh
	HavalPASS2_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*31], 07B54A41Dh
	HavalPASS2_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*27], 0C25A59B5h
	; 3
	HavalPASS3_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*19], 09C30D539h
	HavalPASS3_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*09], 02AF26013h
	HavalPASS3_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*04], 0C5D1B023h
	HavalPASS3_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*20], 0286085F0h
	HavalPASS3_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*28], 0CA417918h
	HavalPASS3_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*17], 0B8DB38EFh
	HavalPASS3_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*08], 08E79DCB0h
	HavalPASS3_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*22], 0603A180Eh
	HavalPASS3_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*29], 06C9E0E8Bh
	HavalPASS3_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*14], 0B01E8A3Eh
	HavalPASS3_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*25], 0D71577C1h
	HavalPASS3_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*12], 0BD314B27h
	HavalPASS3_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*24], 078AF2FDAh
	HavalPASS3_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*30], 055605C60h
	HavalPASS3_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*16], 0E65525F3h
	HavalPASS3_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*26], 0AA55AB94h
	HavalPASS3_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*31], 057489862h
	HavalPASS3_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*15], 063E81440h
	HavalPASS3_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*07], 055CA396Ah
	HavalPASS3_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*03], 02AAB10B6h
	HavalPASS3_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*01], 0B4CC5C34h
	HavalPASS3_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*00], 01141E8CEh
	HavalPASS3_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*18], 0A15486AFh
	HavalPASS3_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*27], 07C72E993h
	HavalPASS3_T3 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*13], 0B3EE1411h
	HavalPASS3_T3 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*06], 0636FBC2Ah
	HavalPASS3_T3 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*21], 02BA9C55Dh
	HavalPASS3_T3 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*10], 0741831F6h
	HavalPASS3_T3 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*23], 0CE5C3E16h
	HavalPASS3_T3 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*11], 09B87931Eh
	HavalPASS3_T3 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*05], 0AFD6BA33h
	HavalPASS3_T3 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*02], 06C24CF5Ch
	; 4
	mov	eax, t0
	mov	ebx, t1
	mov	ecx, t2
	mov	edx, t3
	add	dword ptr [esi+0*4], eax
	add	dword ptr [esi+1*4], ebx
	add	dword ptr [esi+2*4], ecx
	add	dword ptr [esi+3*4], edx
	mov	eax, t4
	mov	ebx, t5
	mov	ecx, t6
	mov	edx, t7
	add	dword ptr [esi+4*4], eax
	add	dword ptr [esi+5*4], ebx
	add	dword ptr [esi+6*4], ecx
	add	dword ptr [esi+7*4], edx
	popad
	ret
HavalTransform3 endp

align 4
HavalTransform4 proc
LOCAL t7, t6, t5, t4, t3, t2, t1, t0
	pushad
	mov esi, offset HavalDigest
	mov edi, offset HavalHashBuf
	mov	eax, dword ptr [esi+0*4]
	mov	ebx, dword ptr [esi+1*4]
	mov	ecx, dword ptr [esi+2*4]
	mov	edx, dword ptr [esi+3*4]
	mov	t0, eax
	mov	t1, ebx
	mov	t2, ecx
	mov	t3, edx
	mov	eax, dword ptr [esi+4*4]
	mov	ebx, dword ptr [esi+5*4]
	mov	ecx, dword ptr [esi+6*4]
	mov	edx, dword ptr [esi+7*4]
	mov	t4, eax
	mov	t5, ebx
	mov	t6, ecx
	mov	t7, edx
	; 1
	HavalPASS1_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*00]
	HavalPASS1_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*01]
	HavalPASS1_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*02]
	HavalPASS1_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*03]
	HavalPASS1_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*04]
	HavalPASS1_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*05]
	HavalPASS1_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*06]
	HavalPASS1_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*07]
	HavalPASS1_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*08]
	HavalPASS1_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*09]
	HavalPASS1_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*10]
	HavalPASS1_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*11]
	HavalPASS1_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*12]
	HavalPASS1_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*13]
	HavalPASS1_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*14]
	HavalPASS1_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*15]
	HavalPASS1_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*16]
	HavalPASS1_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*17]
	HavalPASS1_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*18]
	HavalPASS1_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*19]
	HavalPASS1_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*20]
	HavalPASS1_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*21]
	HavalPASS1_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*22]
	HavalPASS1_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*23]
	HavalPASS1_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*24]
	HavalPASS1_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*25]
	HavalPASS1_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*26]
	HavalPASS1_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*27]
	HavalPASS1_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*28]
	HavalPASS1_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*29]
	HavalPASS1_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*30]
	HavalPASS1_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*31]
	; 2 
	HavalPASS2_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*05], 0452821E6h
	HavalPASS2_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*14], 038D01377h
	HavalPASS2_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*26], 0BE5466CFh
	HavalPASS2_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*18], 034E90C6Ch
	HavalPASS2_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*11], 0C0AC29B7h
	HavalPASS2_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*28], 0C97C50DDh
	HavalPASS2_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*07], 03F84D5B5h
	HavalPASS2_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*16], 0B5470917h
	HavalPASS2_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*00], 09216D5D9h
	HavalPASS2_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*23], 08979FB1Bh
	HavalPASS2_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*20], 0D1310BA6h
	HavalPASS2_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*22], 098DFB5ACh
	HavalPASS2_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*01], 02FFD72DBh
	HavalPASS2_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*10], 0D01ADFB7h
	HavalPASS2_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*04], 0B8E1AFEDh
	HavalPASS2_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*08], 06A267E96h
	HavalPASS2_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*30], 0BA7C9045h
	HavalPASS2_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*03], 0F12C7F99h
	HavalPASS2_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*21], 024A19947h
	HavalPASS2_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*09], 0B3916CF7h
	HavalPASS2_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*17], 00801F2E2h
	HavalPASS2_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*24], 0858EFC16h
	HavalPASS2_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*29], 0636920D8h
	HavalPASS2_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*06], 071574E69h
	HavalPASS2_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*19], 0A458FEA3h
	HavalPASS2_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*12], 0F4933D7Eh
	HavalPASS2_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*15], 00D95748Fh
	HavalPASS2_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*13], 0728EB658h
	HavalPASS2_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*02], 0718BCD58h
	HavalPASS2_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*25], 082154AEEh
	HavalPASS2_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*31], 07B54A41Dh
	HavalPASS2_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*27], 0C25A59B5h
	; 3
	HavalPASS3_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*19], 09C30D539h
	HavalPASS3_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*09], 02AF26013h
	HavalPASS3_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*04], 0C5D1B023h
	HavalPASS3_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*20], 0286085F0h
	HavalPASS3_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*28], 0CA417918h
	HavalPASS3_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*17], 0B8DB38EFh
	HavalPASS3_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*08], 08E79DCB0h
	HavalPASS3_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*22], 0603A180Eh
	HavalPASS3_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*29], 06C9E0E8Bh
	HavalPASS3_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*14], 0B01E8A3Eh
	HavalPASS3_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*25], 0D71577C1h
	HavalPASS3_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*12], 0BD314B27h
	HavalPASS3_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*24], 078AF2FDAh
	HavalPASS3_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*30], 055605C60h
	HavalPASS3_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*16], 0E65525F3h
	HavalPASS3_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*26], 0AA55AB94h
	HavalPASS3_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*31], 057489862h
	HavalPASS3_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*15], 063E81440h
	HavalPASS3_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*07], 055CA396Ah
	HavalPASS3_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*03], 02AAB10B6h
	HavalPASS3_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*01], 0B4CC5C34h
	HavalPASS3_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*00], 01141E8CEh
	HavalPASS3_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*18], 0A15486AFh
	HavalPASS3_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*27], 07C72E993h
	HavalPASS3_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*13], 0B3EE1411h
	HavalPASS3_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*06], 0636FBC2Ah
	HavalPASS3_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*21], 02BA9C55Dh
	HavalPASS3_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*10], 0741831F6h
	HavalPASS3_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*23], 0CE5C3E16h
	HavalPASS3_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*11], 09B87931Eh
	HavalPASS3_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*05], 0AFD6BA33h
	HavalPASS3_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*02], 06C24CF5Ch
	; 4
	HavalPASS4_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*24], 07A325381h
	HavalPASS4_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*04], 028958677h
	HavalPASS4_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*00], 03B8F4898h
	HavalPASS4_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*14], 06B4BB9AFh
	HavalPASS4_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*02], 0C4BFE81Bh
	HavalPASS4_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*07], 066282193h
	HavalPASS4_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*28], 061D809CCh
	HavalPASS4_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*23], 0FB21A991h
	HavalPASS4_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*26], 0487CAC60h
	HavalPASS4_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*06], 05DEC8032h
	HavalPASS4_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*30], 0EF845D5Dh
	HavalPASS4_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*20], 0E98575B1h
	HavalPASS4_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*18], 0DC262302h
	HavalPASS4_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*25], 0EB651B88h
	HavalPASS4_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*19], 023893E81h
	HavalPASS4_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*03], 0D396ACC5h
	HavalPASS4_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*22], 00F6D6FF3h
	HavalPASS4_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*11], 083F44239h
	HavalPASS4_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*31], 02E0B4482h
	HavalPASS4_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*21], 0A4842004h
	HavalPASS4_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*08], 069C8F04Ah
	HavalPASS4_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*27], 09E1F9B5Eh
	HavalPASS4_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*12], 021C66842h
	HavalPASS4_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*09], 0F6E96C9Ah
	HavalPASS4_T4 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*01], 0670C9C61h
	HavalPASS4_T4 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*29], 0ABD388F0h
	HavalPASS4_T4 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*05], 06A51A0D2h
	HavalPASS4_T4 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*15], 0D8542F68h
	HavalPASS4_T4 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*17], 0960FA728h
	HavalPASS4_T4 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*10], 0AB5133A3h
	HavalPASS4_T4 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*16], 06EEF0B6Ch
	HavalPASS4_T4 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*13], 0137A3BE4h
	
	mov	eax, t0
	mov	ebx, t1
	mov	ecx, t2
	mov	edx, t3
	add	dword ptr [esi+0*4], eax
	add	dword ptr [esi+1*4], ebx
	add	dword ptr [esi+2*4], ecx
	add	dword ptr [esi+3*4], edx
	mov	eax, t4
	mov	ebx, t5
	mov	ecx, t6
	mov	edx, t7
	add	dword ptr [esi+4*4], eax
	add	dword ptr [esi+5*4], ebx
	add	dword ptr [esi+6*4], ecx
	add	dword ptr [esi+7*4], edx
	popad
	ret
HavalTransform4 endp

align 4
HavalTransform5 proc
LOCAL t7, t6, t5, t4, t3, t2, t1, t0
	pushad
	mov esi, offset HavalDigest
	mov edi, offset HavalHashBuf
	mov	eax, dword ptr [esi+0*4]
	mov	ebx, dword ptr [esi+1*4]
	mov	ecx, dword ptr [esi+2*4]
	mov	edx, dword ptr [esi+3*4]
	mov	t0, eax
	mov	t1, ebx
	mov	t2, ecx
	mov	t3, edx
	mov	eax, dword ptr [esi+4*4]
	mov	ebx, dword ptr [esi+5*4]
	mov	ecx, dword ptr [esi+6*4]
	mov	edx, dword ptr [esi+7*4]
	mov	t4, eax
	mov	t5, ebx
	mov	t6, ecx
	mov	t7, edx
	; 1
	HavalPASS1_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*00]
	HavalPASS1_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*01]
	HavalPASS1_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*02]
	HavalPASS1_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*03]
	HavalPASS1_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*04]
	HavalPASS1_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*05]
	HavalPASS1_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*06]
	HavalPASS1_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*07]
	HavalPASS1_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*08]
	HavalPASS1_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*09]
	HavalPASS1_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*10]
	HavalPASS1_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*11]
	HavalPASS1_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*12]
	HavalPASS1_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*13]
	HavalPASS1_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*14]
	HavalPASS1_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*15]
	HavalPASS1_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*16]
	HavalPASS1_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*17]
	HavalPASS1_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*18]
	HavalPASS1_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*19]
	HavalPASS1_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*20]
	HavalPASS1_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*21]
	HavalPASS1_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*22]
	HavalPASS1_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*23]
	HavalPASS1_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*24]
	HavalPASS1_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*25]
	HavalPASS1_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*26]
	HavalPASS1_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*27]
	HavalPASS1_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*28]
	HavalPASS1_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*29]
	HavalPASS1_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*30]
	HavalPASS1_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*31]
	; 2 
	HavalPASS2_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*05], 0452821E6h
	HavalPASS2_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*14], 038D01377h
	HavalPASS2_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*26], 0BE5466CFh
	HavalPASS2_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*18], 034E90C6Ch
	HavalPASS2_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*11], 0C0AC29B7h
	HavalPASS2_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*28], 0C97C50DDh
	HavalPASS2_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*07], 03F84D5B5h
	HavalPASS2_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*16], 0B5470917h
	HavalPASS2_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*00], 09216D5D9h
	HavalPASS2_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*23], 08979FB1Bh
	HavalPASS2_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*20], 0D1310BA6h
	HavalPASS2_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*22], 098DFB5ACh
	HavalPASS2_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*01], 02FFD72DBh
	HavalPASS2_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*10], 0D01ADFB7h
	HavalPASS2_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*04], 0B8E1AFEDh
	HavalPASS2_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*08], 06A267E96h
	HavalPASS2_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*30], 0BA7C9045h
	HavalPASS2_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*03], 0F12C7F99h
	HavalPASS2_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*21], 024A19947h
	HavalPASS2_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*09], 0B3916CF7h
	HavalPASS2_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*17], 00801F2E2h
	HavalPASS2_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*24], 0858EFC16h
	HavalPASS2_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*29], 0636920D8h
	HavalPASS2_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*06], 071574E69h
	HavalPASS2_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*19], 0A458FEA3h
	HavalPASS2_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*12], 0F4933D7Eh
	HavalPASS2_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*15], 00D95748Fh
	HavalPASS2_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*13], 0728EB658h
	HavalPASS2_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*02], 0718BCD58h
	HavalPASS2_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*25], 082154AEEh
	HavalPASS2_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*31], 07B54A41Dh
	HavalPASS2_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*27], 0C25A59B5h
	; 3
	HavalPASS3_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*19], 09C30D539h
	HavalPASS3_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*09], 02AF26013h
	HavalPASS3_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*04], 0C5D1B023h
	HavalPASS3_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*20], 0286085F0h
	HavalPASS3_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*28], 0CA417918h
	HavalPASS3_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*17], 0B8DB38EFh
	HavalPASS3_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*08], 08E79DCB0h
	HavalPASS3_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*22], 0603A180Eh
	HavalPASS3_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*29], 06C9E0E8Bh
	HavalPASS3_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*14], 0B01E8A3Eh
	HavalPASS3_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*25], 0D71577C1h
	HavalPASS3_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*12], 0BD314B27h
	HavalPASS3_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*24], 078AF2FDAh
	HavalPASS3_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*30], 055605C60h
	HavalPASS3_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*16], 0E65525F3h
	HavalPASS3_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*26], 0AA55AB94h
	HavalPASS3_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*31], 057489862h
	HavalPASS3_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*15], 063E81440h
	HavalPASS3_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*07], 055CA396Ah
	HavalPASS3_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*03], 02AAB10B6h
	HavalPASS3_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*01], 0B4CC5C34h
	HavalPASS3_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*00], 01141E8CEh
	HavalPASS3_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*18], 0A15486AFh
	HavalPASS3_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*27], 07C72E993h
	HavalPASS3_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*13], 0B3EE1411h
	HavalPASS3_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*06], 0636FBC2Ah
	HavalPASS3_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*21], 02BA9C55Dh
	HavalPASS3_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*10], 0741831F6h
	HavalPASS3_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*23], 0CE5C3E16h
	HavalPASS3_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*11], 09B87931Eh
	HavalPASS3_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*05], 0AFD6BA33h
	HavalPASS3_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*02], 06C24CF5Ch

	HavalPASS4_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*24], 07A325381h
	HavalPASS4_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*04], 028958677h
	HavalPASS4_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*00], 03B8F4898h
	HavalPASS4_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*14], 06B4BB9AFh
	HavalPASS4_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*02], 0C4BFE81Bh
	HavalPASS4_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*07], 066282193h
	HavalPASS4_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*28], 061D809CCh
	HavalPASS4_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*23], 0FB21A991h
	HavalPASS4_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*26], 0487CAC60h
	HavalPASS4_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*06], 05DEC8032h
	HavalPASS4_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*30], 0EF845D5Dh
	HavalPASS4_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*20], 0E98575B1h
	HavalPASS4_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*18], 0DC262302h
	HavalPASS4_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*25], 0EB651B88h
	HavalPASS4_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*19], 023893E81h
	HavalPASS4_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*03], 0D396ACC5h
	HavalPASS4_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*22], 00F6D6FF3h
	HavalPASS4_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*11], 083F44239h
	HavalPASS4_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*31], 02E0B4482h
	HavalPASS4_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*21], 0A4842004h
	HavalPASS4_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*08], 069C8F04Ah
	HavalPASS4_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*27], 09E1F9B5Eh
	HavalPASS4_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*12], 021C66842h
	HavalPASS4_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*09], 0F6E96C9Ah
	HavalPASS4_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*01], 0670C9C61h
	HavalPASS4_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*29], 0ABD388F0h
	HavalPASS4_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*05], 06A51A0D2h
	HavalPASS4_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*15], 0D8542F68h
	HavalPASS4_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*17], 0960FA728h
	HavalPASS4_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*10], 0AB5133A3h
	HavalPASS4_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*16], 06EEF0B6Ch
	HavalPASS4_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*13], 0137A3BE4h

	HavalPASS5_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*27], 0BA3BF050h
	HavalPASS5_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*03], 07EFB2A98h
	HavalPASS5_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*21], 0A1F1651Dh
	HavalPASS5_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*26], 039AF0176h
	HavalPASS5_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*17], 066CA593Eh
	HavalPASS5_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*11], 082430E88h
	HavalPASS5_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*20], 08CEE8619h
	HavalPASS5_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*29], 0456F9FB4h
	HavalPASS5_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*19], 07D84A5C3h
	HavalPASS5_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*00], 03B8B5EBEh
	HavalPASS5_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*12], 0E06F75D8h
	HavalPASS5_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*07], 085C12073h
	HavalPASS5_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*13], 0401A449Fh
	HavalPASS5_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*08], 056C16AA6h
	HavalPASS5_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*31], 04ED3AA62h
	HavalPASS5_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*10], 0363F7706h
	HavalPASS5_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*05], 01BFEDF72h
	HavalPASS5_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*09], 0429B023Dh
	HavalPASS5_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*14], 037D0D724h
	HavalPASS5_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*30], 0D00A1248h
	HavalPASS5_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*18], 0DB0FEAD3h
	HavalPASS5_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*06], 049F1C09Bh
	HavalPASS5_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*28], 0075372C9h
	HavalPASS5_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*24], 080991B7Bh
	HavalPASS5_T5 t7, t6, t5, t4, t3, t2, t1, t0, [edi+4*02], 025D479D8h
	HavalPASS5_T5 t6, t5, t4, t3, t2, t1, t0, t7, [edi+4*23], 0F6E8DEF7h
	HavalPASS5_T5 t5, t4, t3, t2, t1, t0, t7, t6, [edi+4*16], 0E3FE501Ah
	HavalPASS5_T5 t4, t3, t2, t1, t0, t7, t6, t5, [edi+4*22], 0B6794C3Bh
	HavalPASS5_T5 t3, t2, t1, t0, t7, t6, t5, t4, [edi+4*04], 0976CE0BDh
	HavalPASS5_T5 t2, t1, t0, t7, t6, t5, t4, t3, [edi+4*01], 004C006BAh
	HavalPASS5_T5 t1, t0, t7, t6, t5, t4, t3, t2, [edi+4*25], 0C1A94FB6h
	HavalPASS5_T5 t0, t7, t6, t5, t4, t3, t2, t1, [edi+4*15], 0409F60C4h
	
	mov	eax, t0
	mov	ebx, t1
	mov	ecx, t2
	mov	edx, t3
	add	dword ptr [esi+0*4], eax
	add	dword ptr [esi+1*4], ebx
	add	dword ptr [esi+2*4], ecx
	add	dword ptr [esi+3*4], edx
	mov	eax, t4
	mov	ebx, t5
	mov	ecx, t6
	mov	edx, t7
	add	dword ptr [esi+4*4], eax
	add	dword ptr [esi+5*4], ebx
	add	dword ptr [esi+6*4], ecx
	add	dword ptr [esi+7*4], edx
	popad
	ret
HavalTransform5 endp

align 4
HavalTransform proc
	.if HavalPASS == 3
		call HavalTransform3
	.elseif HavalPASS == 4
		call HavalTransform4
	.else
		call HavalTransform5
	.endif	
	ret
HavalTransform endp

align 4
HavalInit proc uses esi edi DigestSizeBits:dword, Passes:dword
	mov eax, Passes
	mov edx, DigestSizeBits
	mov HavalPASS, eax
	mov HavalSIZE, edx
	xor eax, eax
	mov HavalLen, eax
	HavalBURN
	;mov eax, Offset HavalDigest;	for setting start digest
	;mov dword ptr [eax+0*4], 0243F6A88h
	;mov dword ptr [eax+1*4], 085A308D3h
	;mov dword ptr [eax+2*4], 013198A2Eh
	;mov dword ptr [eax+3*4], 003707344h
	;mov dword ptr [eax+4*4], 0A4093822h
	;mov dword ptr [eax+5*4], 0299F31D0h
	;mov dword ptr [eax+6*4], 0082EFA98h
	;mov dword ptr [eax+7*4], 0EC4E6C89h
	mov edi, offset HASHES_Current
	mov esi, offset HavalDigest
	assume edi:ptr HASH_PARAMETERS
	mov eax, [edi].HAVALparameterA
	mov	dword ptr [esi+0*4], eax
	mov eax, [edi].HAVALparameterB
	mov	dword ptr [esi+1*4], eax
	mov eax, [edi].HAVALparameterC
	mov	dword ptr [esi+2*4], eax
	mov eax, [edi].HAVALparameterD
	mov	dword ptr [esi+3*4], eax
	mov eax, [edi].HAVALparameterE
	mov	dword ptr [esi+4*4], eax
	mov eax, [edi].HAVALparameterF
	mov	dword ptr [esi+5*4], eax
	mov eax, [edi].HAVALparameterG
	mov	dword ptr [esi+6*4], eax
	mov eax, [edi].HAVALparameterH
	mov	dword ptr [esi+7*4], eax
	assume edi:nothing
	mov eax, esi
	ret
HavalInit endp

align 4
HavalUpdate proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx, dwBufLen
	add HavalLen, ebx
	.while ebx
		mov eax, HavalIndex
		mov edx, 128
		sub edx, eax
		.if edx <= ebx
			lea edi, [HavalHashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call HavalTransform
			HavalBURN
		.else
			lea edi, [HavalHashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, HavalIndex
			add eax, ebx
			mov HavalIndex, eax
			.break
		.endif
	.endw
	ret
HavalUpdate endp

align 4
HavalFinal proc uses esi edi ebx
	mov ecx, HavalIndex
	IFDEF HavalOLD
	mov byte ptr [HavalHashBuf+ecx], 80h
	else
	mov byte ptr [HavalHashBuf+ecx], 01h
	endif
	.if ecx >= 118
		call HavalTransform
		HavalBURN
	.endif
	mov eax, HavalSIZE
	shl eax, 6
	mov edx, HavalPASS
	shl edx, 3
	or eax, HavalVERSION
	or eax, edx
	mov word ptr [HavalHashBuf+118], ax 
	mov eax, HavalLen
	xor edx, edx
	shld edx, eax, 3
	shl eax, 3
	mov dword ptr [HavalHashBuf+120], eax
	mov dword ptr [HavalHashBuf+120+4], edx
	call HavalTransform
	mov esi, offset HavalDigest
	.if HavalSIZE == 128
		mov eax, dword ptr [esi+7*4]
		mov ebx, dword ptr [esi+6*4]
		mov ecx, dword ptr [esi+5*4]
		mov edx, dword ptr [esi+4*4]
		and eax, 0000000FFh
		and ebx, 0FF000000h
		and ecx, 000FF0000h
		and edx, 00000FF00h
		or eax, ebx
		or eax, ecx
		or eax, edx
		ror eax, 8
		add eax, dword ptr [esi+0*4]
		mov dword ptr [esi+0*4], eax
		mov eax, dword ptr [esi+7*4]
		mov ebx, dword ptr [esi+6*4]
		mov ecx, dword ptr [esi+5*4]
		mov edx, dword ptr [esi+4*4]
		and eax, 00000FF00h
		and ebx, 0000000FFh
		and ecx, 0FF000000h
		and edx, 000FF0000h
		or eax, ebx
		or eax, ecx
		or eax, edx
		ror eax, 16
		add eax, dword ptr [esi+1*4]
		mov dword ptr [esi+1*4], eax
		mov eax, dword ptr [esi+7*4]
		mov ebx, dword ptr [esi+6*4]
		mov ecx, dword ptr [esi+5*4]
		mov edx, dword ptr [esi+4*4]
		and eax, 000FF0000h
		and ebx, 00000FF00h
		and ecx, 0000000FFh
		and edx, 0FF000000h
		or eax, ebx
		or eax, ecx
		or eax, edx
		ror eax, 24
		add eax, dword ptr [esi+2*4]
		mov dword ptr [esi+2*4], eax
		mov eax, dword ptr [esi+7*4]
		mov ebx, dword ptr [esi+6*4]
		mov ecx, dword ptr [esi+5*4]
		mov edx, dword ptr [esi+4*4]
		and eax, 0FF000000h
		and ebx, 000FF0000h
		and ecx, 00000FF00h
		and edx, 0000000FFh
		or eax, ebx
		or eax, ecx
		or eax, edx
		add eax, dword ptr [esi+3*4]
		mov dword ptr [esi+3*4], eax
	.elseif HavalSIZE == 160
		mov	eax, dword ptr [esi+7*4]
		mov	edx, dword ptr [esi+6*4]
		mov	ecx, dword ptr [esi+5*4]
		and	eax, 3Fh
		and	edx, (7Fh SHL 25)
		and	ecx, (3Fh SHL 19)
		or	eax, edx
		or	eax, ecx
		ror	eax, 19
		add	dword ptr [esi+0*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		mov	edx, dword ptr [esi+5*4]
		and	eax, (3Fh SHL 6)
		and	ecx, 3Fh
		and	edx, (7Fh SHL 25)
		or	eax, edx
		or	eax, ecx
		ror	eax, 25
		add	dword ptr [esi+1*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		mov	edx, dword ptr [esi+5*4]
		and	eax, (7Fh SHL 12)
		and	ecx, (3Fh SHL 6)
		and	edx, 3Fh
		or	eax, edx
		or	eax, ecx
		add	dword ptr [esi+2*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		mov	edx, dword ptr [esi+5*4]
		and	eax, (3Fh SHL 19)
		and	ecx, (7Fh SHL 12)
		and	edx, (3Fh SHL 6)
		or	eax, edx
		or	eax, ecx
		shr	eax, 6
		add	dword ptr [esi+3*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		mov	edx, dword ptr [esi+5*4]
		and	eax, (7Fh SHL 25)
		and	ecx, (3Fh SHL 19)
		and	edx, (7Fh SHL 12)
		or	eax, edx
		or	eax, ecx
		shr	eax, 12
		add	dword ptr [esi+4*4], eax
	.elseif HavalSIZE == 192
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		and	eax, 1Fh
		and	ecx, (3Fh SHL 26)
		or	eax, ecx
		ror	eax, 26
		add	dword ptr [esi+0*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		and	eax, (1Fh SHL 5)
		and	ecx, 1Fh
		or	eax, ecx
		add	dword ptr [esi+1*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		and	eax, (3Fh SHL 10)
		and	ecx, (1Fh SHL 5)
		or	eax, ecx
		shr	eax, 5
		add	dword ptr [esi+2*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		and	eax, (1Fh SHL 16)
		and	ecx, (3Fh SHL 10)
		or eax, ecx
		shr	eax, 10
		add	dword ptr [esi+3*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		and	eax, (1Fh SHL 21)
		and	ecx, (1Fh SHL 16)
		or eax, ecx
		shr	eax, 16
		add	dword ptr [esi+4*4], eax
		mov	eax, dword ptr [esi+7*4]
		mov	ecx, dword ptr [esi+6*4]
		and	eax, (3Fh SHL 26)
		and	ecx, (1Fh SHL 21)
		or eax, ecx
		shr	eax, 21
		add	dword ptr [esi+5*4], eax
	.elseif HavalSIZE == 224
		mov	eax, dword ptr [esi+7*4]
		mov	ebx, eax
		mov	ecx, eax
		mov	edx, eax
		mov	edi, eax
		shr	eax, 27
		and	eax, 1Fh
		shr	ebx, 22
		and	ebx, 1Fh
		shr	ecx, 18
		and	ecx, 0Fh
		shr	edx, 13
		and	edx, 1Fh
		shr	edi, 9
		and	edi, 0Fh
		add	dword ptr [esi+0*4], eax
		add	dword ptr [esi+1*4], ebx
		add	dword ptr [esi+2*4], ecx
		add	dword ptr [esi+3*4], edx
		add	dword ptr [esi+4*4], edi
		mov	eax, dword ptr [esi+7*4]
		mov edx, eax
		shr	eax, 4
		and	eax, 1Fh
		and	edx, 0Fh
		add	dword ptr [esi+5*4], eax
		add	dword ptr [esi+6*4], edx
	.endif
	mov eax, esi
	ret
HavalFinal endp