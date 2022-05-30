

RipeMD128		PROTO	:DWORD, :DWORD, :DWORD

RipeMD128RESULT		STRUCT
	dtA		dd	?
	dtB		dd	?
	dtC		dd	?
	dtD		dd	?
RipeMD128RESULT		ENDS


F	MACRO 					;F(X, Y, Z) = X xor Y xor Z
	xor	eax, ecx			;eax = X
	xor	eax, edx			;ecx = Y
ENDM					;edx = Z

FF	MACRO	_a, _b, _c, _d, x, s		;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F
	add	eax, _a
	add	eax, x
	rol	eax, s	
	mov	_a, eax
ENDM
	
G	MACRO					;G(X, Y, Z) = XY v not(X) Z
	and	ecx, eax			;eax = X
	not	eax				;ecx = Y
	and	eax, edx			;edx = Z
	or	eax, ecx	
ENDM

GG	MACRO	_a, _b, _c, _d, x, s		;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	G
	add	eax, _a
	add	eax, x
	add	eax, 5a827999h
	rol	eax, s
	mov	_a, eax
ENDM

H	MACRO					;H(X, Y, Z) = (X v not(Y)) xor Z )
	not	ecx				;eax = X
	or	eax, ecx			;ecx = Y
	xor	eax, edx			;edx = Z
ENDM

HH	MACRO	_a, _b, _c, _d, x, s		;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	H
	add	eax, _a
	add	eax, x
	add	eax, 6ed9eba1h
	rol	eax, s
	mov	_a, eax
ENDM

I	MACRO					;I(X, Y, Z) = XZ v Y not(Z)
	and	eax, edx			;eax = X
	not	edx				;ecx = Y
	and	ecx, edx			;edx = Z
	or	eax, ecx
ENDM

II	MACRO	_a, _b, _c, _d, x, s		;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	I
	add	eax, _a
	add	eax, x
	add	eax, 8f1bbcdch
	rol	eax, s
	mov	_a, eax
ENDM

III	MACRO	_a, _b, _c, _d, x, s		;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	I
	add	eax, _a
	add	eax, x
	add	eax, 50a28be6h
	rol	eax, s
	mov	_a, eax
ENDM

HHH	MACRO	_a, _b, _c, _d, x, s		;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	H
	add	eax, _a
	add	eax, x
	add	eax, 5c4dd124h
	rol	eax, s
	mov	_a, eax
ENDM

GGG	MACRO	_a, _b, _c, _d, x, s		;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	G
	add	eax, _a
	add	eax, x
	add	eax, 6d703ef3h
	rol	eax, s
	mov	_a, eax
ENDM

FFF	MACRO	_a, _b, _c, _d, x, s		;all args are dwords (same as FF)
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F
	add	eax, _a
	add	eax, x
	rol	eax, s	
	mov	_a, eax
ENDM

.data
szBUFF				db 20h dup(0)
szRipeMD128Format	db '%.8x%.8x%.8x%.8x', 0


.code
;***************************************************************************************
;Start RipeMD128 Handler functions
;***************************************************************************************

RIPEMD128_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push offset sTempBuf
		push [_len]
		push _Input
		call RipeMD128
		invoke	wsprintf, _Output, addr strFormat, _Input
		INVOKE lstrlen, _Output
		
		HexLen
		
        ret
RIPEMD128_RT endp



;***************************************************************************************
;Start RipeMD128 functions
;***************************************************************************************

RipeMD128 proc	uses eax ebx ecx edx edi esi, ptBuffer:dword, dtBufferLength:dword, ptRipeMD128Result:dword
			local	dta:dword, dtb:dword, dtc:dword, dtd:dword
			local	dta2:dword, dtb2:dword, dtc2:dword, dtd2:dword, szData:dword
			mov	edi, ptBuffer
			mov	eax, dtBufferLength
			inc	eax
			add	edi, eax
			mov	byte ptr [edi-1], 080h
			xor	edx, edx
			mov	ebx, 64
			div	ebx
			neg	edx
			add	edx, 64
			cmp	edx, 8
			jae	@f
			add	edx, 64
@@:			mov	ecx, edx
			xor	al, al
			rep	stosb
			mov	eax, dtBufferLength
			inc	edx
			add	dtBufferLength, edx
			xor	edx, edx
			mov	ebx, 8
			mul	ebx
			mov	dword ptr [edi-8], eax
			mov	dword ptr [edi-4], edx
			mov	edx, dtBufferLength
			mov	szData, edx
			mov edi, offset HASHES_Current
			assume edi:ptr HASH_PARAMETERS
			mov	esi, ptRipeMD128Result
			assume	esi:ptr RipeMD128RESULT
			mov eax, [edi].RIPE128parameterA
			mov	[esi].dtA, eax
			mov eax, [edi].RIPE128parameterB
			mov	[esi].dtB, eax
			mov eax, [edi].RIPE128parameterC
			mov	[esi].dtC, eax
			mov eax, [edi].RIPE128parameterD
			mov	[esi].dtD, eax
			assume edi:nothing
			;mov	[esi].dtA, 067452301h
			;mov	[esi].dtB, 0efcdab89h
			;mov	[esi].dtC, 098badcfeh
			;mov	[esi].dtD, 010325476h
			mov	edi, ptBuffer
hashloop:	
			mov	eax, [esi].dtA
			mov	dta, eax
			mov	dta2, eax
			mov	eax, [esi].dtB
			mov	dtb, eax
			mov	dtb2, eax
			mov	eax, [esi].dtC
			mov	dtc, eax
			mov	dtc2, eax
			mov	eax, [esi].dtD
			mov	dtd, eax
			mov	dtd2, eax
		;/* round 1 */
			FF	dta, dtb, dtc, dtd, dword ptr [edi+00h], 11
			FF	dtd, dta, dtb, dtc, dword ptr [edi+04h], 14
			FF	dtc, dtd, dta, dtb, dword ptr [edi+08h], 15
			FF	dtb, dtc, dtd, dta, dword ptr [edi+0Ch], 12
			FF	dta, dtb, dtc, dtd, dword ptr [edi+10h], 5
			FF	dtd, dta, dtb, dtc, dword ptr [edi+14h], 8
			FF	dtc, dtd, dta, dtb, dword ptr [edi+18h], 7
			FF	dtb, dtc, dtd, dta, dword ptr [edi+1Ch], 9
			FF	dta, dtb, dtc, dtd, dword ptr [edi+20h], 11
			FF	dtd, dta, dtb, dtc, dword ptr [edi+24h], 13
			FF	dtc, dtd, dta, dtb, dword ptr [edi+28h], 14
			FF	dtb, dtc, dtd, dta, dword ptr [edi+2Ch], 15
			FF	dta, dtb, dtc, dtd, dword ptr [edi+30h], 6
			FF	dtd, dta, dtb, dtc, dword ptr [edi+34h], 7
			FF	dtc, dtd, dta, dtb, dword ptr [edi+38h], 9
			FF	dtb, dtc, dtd, dta, dword ptr [edi+3Ch], 8
		;/* round 2 */
			GG 	dta, dtb, dtc, dtd, dword ptr [edi+4*07], 7
			GG 	dtd, dta, dtb, dtc, dword ptr [edi+4*04], 6
			GG 	dtc, dtd, dta, dtb, dword ptr [edi+4*13], 8
			GG 	dtb, dtc, dtd, dta, dword ptr [edi+4*01], 13
			GG 	dta, dtb, dtc, dtd, dword ptr [edi+4*10], 11
			GG 	dtd, dta, dtb, dtc, dword ptr [edi+4*06], 9
			GG 	dtc, dtd, dta, dtb, dword ptr [edi+4*15], 7
			GG 	dtb, dtc, dtd, dta, dword ptr [edi+4*03], 15
			GG 	dta, dtb, dtc, dtd, dword ptr [edi+4*12], 7
			GG 	dtd, dta, dtb, dtc, dword ptr [edi+4*00], 12
			GG 	dtc, dtd, dta, dtb, dword ptr [edi+4*09], 15
			GG 	dtb, dtc, dtd, dta, dword ptr [edi+4*05], 9
			GG 	dta, dtb, dtc, dtd, dword ptr [edi+4*02], 11
			GG 	dtd, dta, dtb, dtc, dword ptr [edi+4*14], 7
			GG 	dtc, dtd, dta, dtb, dword ptr [edi+4*11], 13
			GG 	dtb, dtc, dtd, dta, dword ptr [edi+4*08], 12
		;/* round 3 */
			HH 	dta, dtb, dtc, dtd, dword ptr [edi+4*03], 11
			HH 	dtd, dta, dtb, dtc, dword ptr [edi+4*10], 13
			HH 	dtc, dtd, dta, dtb, dword ptr [edi+4*14], 6
			HH 	dtb, dtc, dtd, dta, dword ptr [edi+4*04], 7
			HH 	dta, dtb, dtc, dtd, dword ptr [edi+4*09], 14
			HH 	dtd, dta, dtb, dtc, dword ptr [edi+4*15], 9
			HH 	dtc, dtd, dta, dtb, dword ptr [edi+4*08], 13
			HH 	dtb, dtc, dtd, dta, dword ptr [edi+4*01], 15
			HH 	dta, dtb, dtc, dtd, dword ptr [edi+4*02], 14
			HH 	dtd, dta, dtb, dtc, dword ptr [edi+4*07], 8
			HH 	dtc, dtd, dta, dtb, dword ptr [edi+4*00], 13
			HH 	dtb, dtc, dtd, dta, dword ptr [edi+4*06], 6
			HH 	dta, dtb, dtc, dtd, dword ptr [edi+4*13], 5
			HH 	dtd, dta, dtb, dtc, dword ptr [edi+4*11], 12
			HH 	dtc, dtd, dta, dtb, dword ptr [edi+4*05], 7
			HH 	dtb, dtc, dtd, dta, dword ptr [edi+4*12], 5
		;/* round 4 */
			II 	dta, dtb, dtc, dtd, dword ptr [edi+4*01], 11
			II 	dtd, dta, dtb, dtc, dword ptr [edi+4*09], 12
			II 	dtc, dtd, dta, dtb, dword ptr [edi+4*11], 14
			II 	dtb, dtc, dtd, dta, dword ptr [edi+4*10], 15
			II 	dta, dtb, dtc, dtd, dword ptr [edi+4*00], 14
			II 	dtd, dta, dtb, dtc, dword ptr [edi+4*08], 15
			II	dtc, dtd, dta, dtb, dword ptr [edi+4*12], 9
			II 	dtb, dtc, dtd, dta, dword ptr [edi+4*04], 8
			II 	dta, dtb, dtc, dtd, dword ptr [edi+4*13], 9
			II 	dtd, dta, dtb, dtc, dword ptr [edi+4*03], 14
			II 	dtc, dtd, dta, dtb, dword ptr [edi+4*07], 5
			II 	dtb, dtc, dtd, dta, dword ptr [edi+4*15], 6
			II 	dta, dtb, dtc, dtd, dword ptr [edi+4*14], 8
			II 	dtd, dta, dtb, dtc, dword ptr [edi+4*05], 6
			II 	dtc, dtd, dta, dtb, dword ptr [edi+4*06], 5
			II 	dtb, dtc, dtd, dta, dword ptr [edi+4*02], 12
		;/* parallel round 1 */
			III 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*05], 8
			III 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*14], 9
			III 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*07], 9
			III 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*00], 11
			III 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*09], 13
			III 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*02], 15
			III 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*11], 15
			III 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*04], 5
			III 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*13], 7
			III 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*06], 7
			III 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*15], 8
			III 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*08], 11
			III 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*01], 14
			III 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*10], 14
			III 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*03], 12
			III 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*12], 6
		;/* parallel round 2 */
			HHH 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*06], 9
			HHH 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*11], 13
			HHH 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*03], 15
			HHH 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*07], 7
			HHH 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*00], 12
			HHH 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*13], 8
			HHH 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*05], 9
			HHH 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*10], 11
			HHH 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*14], 7
			HHH 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*15], 7
			HHH 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*08], 12
			HHH 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*12], 7
			HHH 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*04], 6
			HHH 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*09], 15
			HHH 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*01], 13
			HHH 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*02], 11
		;/* parallel round 3 */   
			GGG 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*15], 9
			GGG 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*05], 7
			GGG 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*01], 15
			GGG 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*03], 11
			GGG 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*07], 8
			GGG 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*14], 6
			GGG 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*06], 6
			GGG 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*09], 14
			GGG 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*11], 12
			GGG 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*08], 13
			GGG 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*12], 5
			GGG 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*02], 14
			GGG 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*10], 13
			GGG 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*00], 13
			GGG 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*04], 7
			GGG 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*13], 5
		;/* parallel round 4 */
			FFF 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*08], 15
			FFF 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*06], 5
			FFF 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*04], 8
			FFF 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*01], 11
			FFF 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*03], 14
			FFF 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*11], 14
			FFF 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*15], 6
			FFF 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*00], 14
			FFF 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*05], 6
			FFF 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*12], 9
			FFF 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*02], 12
			FFF 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*13], 9
			FFF 	dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*09], 12
			FFF 	dtd2, dta2, dtb2, dtc2, dword ptr [edi+4*07], 5
			FFF 	dtc2, dtd2, dta2, dtb2, dword ptr [edi+4*10], 15
			FFF 	dtb2, dtc2, dtd2, dta2, dword ptr [edi+4*14], 8

			
			mov	ecx, [esi].dtB
			add	ecx, dtc
			add	ecx, dtd2

			mov	eax, [esi].dtC
			add	eax, dtd
			add	eax, dta2
			mov	[esi].dtB, eax

			mov	eax, [esi].dtD
			add	eax, dta
			add	eax, dtb2
			mov	[esi].dtC, eax

			mov	eax, [esi].dtA
			add	eax, dtb
			add	eax, dtc2
			mov	[esi].dtD, eax
			mov	[esi].dtA, ecx
			
			
			add	edi, 64
			sub	[szData], 64
			jg	hashloop
			
			mov	ecx, 16
@@FINAL:		mov	eax, dword ptr [esi]
			xchg	al, ah
			rol	eax, 16
			xchg	al, ah
			mov	dword ptr [esi], eax
			add	esi, 4
			sub	ecx, 4
			jnz	@@FINAL
			mov	esi, ptRipeMD128Result
			invoke	wsprintfA, ptBuffer, addr szRipeMD128Format, [esi].dtA, [esi].dtB, [esi].dtC, [esi].dtD

	ret
RipeMD128 endp

