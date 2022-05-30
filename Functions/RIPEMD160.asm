

RipeMD160RESULT		STRUCT
	dtA		dd	?
	dtB		dd	?
	dtC		dd	?
	dtD		dd	?
	dtE		dd 	?
RipeMD160RESULT		ENDS

F	MACRO 					;F(X, Y, Z) = X xor Y xor Z
	xor	eax, ecx			;eax = X
	xor	eax, edx			;ecx = Y
ENDM						;edx = Z

FF	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F
	add	eax, _a
	add	eax, x
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	rol	ecx, 10
	mov	_c, ecx
ENDM

G	MACRO					;G(X, Y, Z) = XY v not(X) Z
	and	ecx, eax			;eax = X
	not	eax				;ecx = Y
	and	eax, edx			;edx = Z
	or	eax, ecx	
ENDM

GG	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	G
	add	eax, _a
	add	eax, x
	add	eax, 5a827999h
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	mov	ecx, _c
	rol	ecx, 10
	mov	_c, ecx
ENDM

H	MACRO					;H(X, Y, Z) = (X v not(Y)) xor Z )
	not	ecx				;eax = X
	or	eax, ecx			;ecx = Y
	xor	eax, edx			;edx = Z
ENDM

HH	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	H
	add	eax, _a
	add	eax, x
	add	eax, 6ed9eba1h
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	mov	ecx, _c
	rol	ecx, 10
	mov	_c, ecx
ENDM

I	MACRO					;I(X, Y, Z) = XZ v Y not(Z)
	and	eax, edx			;eax = X
	not	edx				;ecx = Y
	and	edx, ecx			;edx = Z
	or	eax, edx
ENDM

II	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	I
	add	eax, _a
	add	eax, x
	add	eax, 8f1bbcdch
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	rol	ecx, 10
	mov	_c, ecx
ENDM

J	MACRO					;J(X, Y, Z) = X xor ( Y v not(Z) )
	not	edx				;eax = X
	or	edx, ecx			;ecx = Y
	xor	eax, edx			;edx = Z
ENDM

JJ	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	J
	add	eax, _a
	add	eax, x
	add	eax, 0a953fd4eh
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	rol	ecx, 10
	mov	_c, ecx
ENDM

JJJ	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	J
	add	eax, _a
	add	eax, x
	add	eax, 50a28be6h
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	rol	ecx, 10
	mov	_c, ecx
ENDM

III	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	I
	add	eax, _a
	add	eax, x
	add	eax, 5c4dd124h
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	rol	ecx, 10
	mov	_c, ecx
ENDM

HHH	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	H
	add	eax, _a
	add	eax, x
	add	eax, 6d703ef3h
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	mov	ecx, _c
	rol	ecx, 10
	mov	_c, ecx
ENDM

GGG	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	G
	add	eax, _a
	add	eax, x
	add	eax, 7a6d76e9h
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	mov	ecx, _c
	rol	ecx, 10
	mov	_c, ecx
ENDM

FFF	MACRO	_a, _b, _c, _d, _e, x, s	;all args are dwords (same as FF)
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F
	add	eax, _a
	add	eax, x
	rol	eax, s
	add	eax, _e
	mov	_a, eax
	rol	ecx, 10
	mov	_c, ecx
ENDM

.data

sznumber1_RMD160			dd 100h dup(0)
szRipeMD160Format	db '%.8x%.8x%.8x%.8x%.8x', 0


.code
;***************************************************************************************
;Start RipeMD160 Handler functions
;***************************************************************************************

RIPEMD160_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push offset sTempBuf
		push [_len]
		push _Input
		call RipeMD160
		invoke	wsprintf, _Output, addr strFormat, _Input
		HexLen
 ret
RIPEMD160_RT endp



;***************************************************************************************
;Start RipeMD160 functions
;***************************************************************************************
RipeMD160 proc	uses eax ebx ecx edx edi esi, ptBuffer:dword, dtBufferLength:dword, ptRipeMD160Result:dword
			local	dta:dword, dtb:dword, dtc:dword, dtd:dword, dte:dword
			local	dta2:dword, dtb2:dword, dtc2:dword, dtd2:dword, dte2:dword, szData:dword
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
			mov	esi, ptRipeMD160Result
			assume esi:ptr RipeMD160RESULT
			mov eax, [edi].RIPE160parameterA
			mov	[esi].dtA, eax
			mov eax, [edi].RIPE160parameterB
			mov	[esi].dtB, eax
			mov eax, [edi].RIPE160parameterC
			mov	[esi].dtC, eax
			mov eax, [edi].RIPE160parameterD
			mov	[esi].dtD, eax
			mov eax, [edi].RIPE160parameterE
			mov	[esi].dtE, eax
			assume edi:nothing
			;mov	[esi].dtA, 067452301h
			;mov	[esi].dtB, 0efcdab89h
			;mov	[esi].dtC, 098badcfeh
			;mov	[esi].dtD, 010325476h
			;mov	[esi].dtE, 0c3d2e1f0h
			mov	edi, ptBuffer
hashloop:		mov	eax, [esi].dtA
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
			mov	eax, [esi].dtE
			mov	dte, eax
			mov	dte2, eax
			;PuNkDuDe
			;B21676A4-2CD4F229-BB90DEE3-B5ADB227-9FD76DCD
		;/* round 1 */
			FF dta, dtb, dtc, dtd, dte, dword ptr [edi+4*00], 11
			FF dte, dta, dtb, dtc, dtd, dword ptr [edi+4*01], 14
			FF dtd, dte, dta, dtb, dtc, dword ptr [edi+4*02], 15
			FF dtc, dtd, dte, dta, dtb, dword ptr [edi+4*03], 12
			FF dtb, dtc, dtd, dte, dta, dword ptr [edi+4*04], 5
			FF dta, dtb, dtc, dtd, dte, dword ptr [edi+4*05], 8
			FF dte, dta, dtb, dtc, dtd, dword ptr [edi+4*06], 7
			FF dtd, dte, dta, dtb, dtc, dword ptr [edi+4*07], 9
			FF dtc, dtd, dte, dta, dtb, dword ptr [edi+4*08], 11
			FF dtb, dtc, dtd, dte, dta, dword ptr [edi+4*09], 13
			FF dta, dtb, dtc, dtd, dte, dword ptr [edi+4*10], 14
			FF dte, dta, dtb, dtc, dtd, dword ptr [edi+4*11], 15
			FF dtd, dte, dta, dtb, dtc, dword ptr [edi+4*12], 6
			FF dtc, dtd, dte, dta, dtb, dword ptr [edi+4*13], 7
			FF dtb, dtc, dtd, dte, dta, dword ptr [edi+4*14], 9
			FF dta, dtb, dtc, dtd, dte, dword ptr [edi+4*15], 8
		;/* round 2 */
			GG dte, dta, dtb, dtc, dtd, dword ptr [edi+4*07], 7
			GG dtd, dte, dta, dtb, dtc, dword ptr [edi+4*04], 6
			GG dtc, dtd, dte, dta, dtb, dword ptr [edi+4*13], 8
			GG dtb, dtc, dtd, dte, dta, dword ptr [edi+4*01], 13
			GG dta, dtb, dtc, dtd, dte, dword ptr [edi+4*10], 11
			GG dte, dta, dtb, dtc, dtd, dword ptr [edi+4*06], 9
			GG dtd, dte, dta, dtb, dtc, dword ptr [edi+4*15], 7
			GG dtc, dtd, dte, dta, dtb, dword ptr [edi+4*03], 15
			GG dtb, dtc, dtd, dte, dta, dword ptr [edi+4*12], 7
			GG dta, dtb, dtc, dtd, dte, dword ptr [edi+4*00], 12
			GG dte, dta, dtb, dtc, dtd, dword ptr [edi+4*09], 15
			GG dtd, dte, dta, dtb, dtc, dword ptr [edi+4*05], 9
			GG dtc, dtd, dte, dta, dtb, dword ptr [edi+4*02], 11
			GG dtb, dtc, dtd, dte, dta, dword ptr [edi+4*14], 7
			GG dta, dtb, dtc, dtd, dte, dword ptr [edi+4*11], 13
			GG dte, dta, dtb, dtc, dtd, dword ptr [edi+4*08], 12
		;/* round 3 */
			HH dtd, dte, dta, dtb, dtc, dword ptr [edi+4*03], 11
			HH dtc, dtd, dte, dta, dtb, dword ptr [edi+4*10], 13
			HH dtb, dtc, dtd, dte, dta, dword ptr [edi+4*14], 6
			HH dta, dtb, dtc, dtd, dte, dword ptr [edi+4*04], 7
			HH dte, dta, dtb, dtc, dtd, dword ptr [edi+4*09], 14
			HH dtd, dte, dta, dtb, dtc, dword ptr [edi+4*15], 9
			HH dtc, dtd, dte, dta, dtb, dword ptr [edi+4*08], 13
			HH dtb, dtc, dtd, dte, dta, dword ptr [edi+4*01], 15
			HH dta, dtb, dtc, dtd, dte, dword ptr [edi+4*02], 14
			HH dte, dta, dtb, dtc, dtd, dword ptr [edi+4*07], 8
			HH dtd, dte, dta, dtb, dtc, dword ptr [edi+4*00], 13
			HH dtc, dtd, dte, dta, dtb, dword ptr [edi+4*06], 6
			HH dtb, dtc, dtd, dte, dta, dword ptr [edi+4*13], 5
			HH dta, dtb, dtc, dtd, dte, dword ptr [edi+4*11], 12
			HH dte, dta, dtb, dtc, dtd, dword ptr [edi+4*05], 7
			HH dtd, dte, dta, dtb, dtc, dword ptr [edi+4*12], 5
		;/* round 4 */
			II dtc, dtd, dte, dta, dtb, dword ptr [edi+4*01], 11
			II dtb, dtc, dtd, dte, dta, dword ptr [edi+4*09], 12
			II dta, dtb, dtc, dtd, dte, dword ptr [edi+4*11], 14
			II dte, dta, dtb, dtc, dtd, dword ptr [edi+4*10], 15
			II dtd, dte, dta, dtb, dtc, dword ptr [edi+4*00], 14
			II dtc, dtd, dte, dta, dtb, dword ptr [edi+4*08], 15
			II dtb, dtc, dtd, dte, dta, dword ptr [edi+4*12], 9
			II dta, dtb, dtc, dtd, dte, dword ptr [edi+4*04], 8
			II dte, dta, dtb, dtc, dtd, dword ptr [edi+4*13], 9
			II dtd, dte, dta, dtb, dtc, dword ptr [edi+4*03], 14
			II dtc, dtd, dte, dta, dtb, dword ptr [edi+4*07], 5
			II dtb, dtc, dtd, dte, dta, dword ptr [edi+4*15], 6
			II dta, dtb, dtc, dtd, dte, dword ptr [edi+4*14], 8
			II dte, dta, dtb, dtc, dtd, dword ptr [edi+4*05], 6
			II dtd, dte, dta, dtb, dtc, dword ptr [edi+4*06], 5
			II dtc, dtd, dte, dta, dtb, dword ptr [edi+4*02], 12
		;/* round 5 */
			JJ dtb, dtc, dtd, dte, dta, dword ptr [edi+4*04], 9
			JJ dta, dtb, dtc, dtd, dte, dword ptr [edi+4*00], 15
			JJ dte, dta, dtb, dtc, dtd, dword ptr [edi+4*05], 5
			JJ dtd, dte, dta, dtb, dtc, dword ptr [edi+4*09], 11
			JJ dtc, dtd, dte, dta, dtb, dword ptr [edi+4*07], 6
			JJ dtb, dtc, dtd, dte, dta, dword ptr [edi+4*12], 8
			JJ dta, dtb, dtc, dtd, dte, dword ptr [edi+4*02], 13
			JJ dte, dta, dtb, dtc, dtd, dword ptr [edi+4*10], 12
			JJ dtd, dte, dta, dtb, dtc, dword ptr [edi+4*14], 5
			JJ dtc, dtd, dte, dta, dtb, dword ptr [edi+4*01], 12
			JJ dtb, dtc, dtd, dte, dta, dword ptr [edi+4*03], 13
			JJ dta, dtb, dtc, dtd, dte, dword ptr [edi+4*08], 14
			JJ dte, dta, dtb, dtc, dtd, dword ptr [edi+4*11], 11
			JJ dtd, dte, dta, dtb, dtc, dword ptr [edi+4*06], 8
			JJ dtc, dtd, dte, dta, dtb, dword ptr [edi+4*15], 5
			JJ dtb, dtc, dtd, dte, dta, dword ptr [edi+4*13], 6
		;/* parallel round 1 */
			JJJ dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*05], 8
			JJJ dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*14], 9
			JJJ dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*07], 9
			JJJ dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*00], 11
			JJJ dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*09], 13
			JJJ dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*02], 15
			JJJ dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*11], 15
			JJJ dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*04], 5
			JJJ dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*13], 7
			JJJ dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*06], 7
			JJJ dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*15], 8
			JJJ dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*08], 11
			JJJ dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*01], 14
			JJJ dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*10], 14
			JJJ dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*03], 12
			JJJ dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*12], 6
		;/* parallel round 2 */
			III dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*06], 9 
			III dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*11], 13
			III dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*03], 15
			III dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*07], 7
			III dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*00], 12
			III dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*13], 8
			III dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*05], 9
			III dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*10], 11
			III dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*14], 7
			III dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*15], 7
			III dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*08], 12
			III dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*12], 7
			III dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*04], 6
			III dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*09], 15
			III dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*01], 13
			III dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*02], 11
		;/* parallel round 3 */
			HHH dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*15], 9
			HHH dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*05], 7
			HHH dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*01], 15
			HHH dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*03], 11
			HHH dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*07], 8
			HHH dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*14], 6
			HHH dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*06], 6
			HHH dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*09], 14
			HHH dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*11], 12
			HHH dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*08], 13
			HHH dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*12], 5
			HHH dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*02], 14
			HHH dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*10], 13
			HHH dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*00], 13
			HHH dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*04], 7
			HHH dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*13], 5
		;/* parallel round 4 */ 
			GGG dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*08], 15
			GGG dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*06], 5
			GGG dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*04], 8
			GGG dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*01], 11
			GGG dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*03], 14
			GGG dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*11], 14
			GGG dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*15], 6
			GGG dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*00], 14
			GGG dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*05], 6
			GGG dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*12], 9
			GGG dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*02], 12
			GGG dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*13], 9
			GGG dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*09], 12
			GGG dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*07], 5
			GGG dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*10], 15
			GGG dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*14], 8
		;/* parallel round 5 */
			FFF dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*12] , 8
			FFF dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*15] , 5
			FFF dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*10] , 12
			FFF dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*04] , 9
			FFF dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*01] , 12
			FFF dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*05] , 5
			FFF dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*08] , 14
			FFF dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*07] , 6
			FFF dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*06] , 8
			FFF dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*02] , 13
			FFF dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*13] , 6
			FFF dta2, dtb2, dtc2, dtd2, dte2, dword ptr [edi+4*14] , 5
			FFF dte2, dta2, dtb2, dtc2, dtd2, dword ptr [edi+4*00] , 15
			FFF dtd2, dte2, dta2, dtb2, dtc2, dword ptr [edi+4*03] , 13
			FFF dtc2, dtd2, dte2, dta2, dtb2, dword ptr [edi+4*09] , 11
			FFF dtb2, dtc2, dtd2, dte2, dta2, dword ptr [edi+4*11] , 11

		;/* combine results */
			mov	ecx, [esi].dtB
			add	ecx, dtc
			add	ecx, dtd2
			;
			mov	eax, [esi].dtC
			add	eax, dtd
			add	eax, dte2
			mov	[esi].dtB, eax
			;
			mov	eax, [esi].dtD
			add	eax, dte
			add	eax, dta2
			mov	[esi].dtC, eax
			;
			mov	eax, [esi].dtE
			add	eax, dta
			add	eax, dtb2
			mov	[esi].dtD, eax
			;
			mov	eax, [esi].dtA
			add	eax, dtb
			add	eax, dtc2
			mov	[esi].dtE, eax
			;
			mov	[esi].dtA, ecx
			
			
			add	edi, 64
			sub	[szData], 64
			jg	hashloop
			
			mov	ecx, 20
@@FINAL:		mov	eax, dword ptr [esi]
			xchg	al, ah
			rol	eax, 16
			xchg	al, ah
			mov	dword ptr [esi], eax
			add	esi, 4
			sub	ecx, 4
			jnz	@@FINAL
			mov	esi, ptRipeMD160Result
			invoke	wsprintfA, ptBuffer, addr szRipeMD160Format, [esi].dtA, [esi].dtB, [esi].dtC, [esi].dtD, [esi].dtE

	ret
RipeMD160 endp

