

;*******************************************************************
;* Twelve important macros					   *
;*******************************************************************
F	MACRO 					;F(X,Y,Z) = X xor Y xor Z
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

G	MACRO					;G(X,Y,Z) = XY v not(X) Z
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

H	MACRO					;H(X,Y,Z) = (X v not(Y)) xor Z )
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

I	MACRO					;I(X,Y,Z) = XZ v Y not(Z)
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

;*******************************************************************
;*  DATA                                                           *
;*******************************************************************
	.data
sBuff_RMD256		db 20h dup(0)
sFormat_RMD256		db '%.8x%.8x%.8x%.8x%.8x%.8x%.8x%.8x',0
padding16	db 80h, 63 dup(0)

	.data?	
lastblock16	db 64 dup(?)		;last 512-bit block after padding
		db 64 dup(?)		;if length (mod 64) > 55 then another 512-bit block is required
					;// example: length = 59 ; pad = 61 ; 64-bit length representation = 8
					;// which makes two blocks: 59+5 AND 56+8
lastblock16_use	dd ?			;use the second lastblock ?

a_ripemd256	dd ?	;state
b_ripemd256	dd ?
c_ripemd256	dd ?
d_ripemd256	dd ?
aa_ripemd256	dd ?
bb_ripemd256	dd ?
cc_ripemd256	dd ?
dd_ripemd256	dd ?

save1_a	dd ?
save1_b	dd ?
save1_c	dd ?
save1_d	dd ?
save2_a	dd ?
save2_b	dd ?
save2_c	dd ?
save2_d	dd ?

length_ripemd256	dq ?		;64-bit representation of the message’s length (before padding bits were added)
nbloop_ripemd256	dd ?		;number (-1 or -2) of loop (block of 512-bit processing).



.code
;***************************************************************************************
;Start RipeMD256 Handler functions
;***************************************************************************************

RIPEMD256_RT proc uses esi edx ecx _Input:dword,_Output:dword,_len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push offset sTempBuf
		push [_len]
		push _Input
		call RipeMD256
		invoke	wsprintf,_Output, addr strFormat, _Input
		INVOKE lstrlen,_Output
		
		HexLen
        ret
RIPEMD256_RT endp



;*******************************************************************
;* RIPEMD256_Init                                                  *
;*******************************************************************
RIPEMD256_Init	proc
		mov edi, offset HASHES_Current
		assume edi:ptr HASH_PARAMETERS
		mov eax, [edi].RIPE256parameterA
		mov	dword ptr [a_ripemd256], eax
		mov eax, [edi].RIPE256parameterB
		mov	dword ptr [b_ripemd256], eax
		mov eax, [edi].RIPE256parameterC
		mov	dword ptr [c_ripemd256], eax
		mov eax, [edi].RIPE256parameterD
		mov	dword ptr [d_ripemd256], eax
		mov eax, [edi].RIPE256parameterE
		mov	dword ptr [aa_ripemd256], eax
		mov eax, [edi].RIPE256parameterF
		mov	dword ptr [bb_ripemd256], eax
		mov eax, [edi].RIPE256parameterG
		mov	dword ptr [cc_ripemd256], eax
		mov eax, [edi].RIPE256parameterH
		mov	dword ptr [dd_ripemd256], eax
		assume edi:nothing
		ret
RIPEMD256_Init	endp

;*******************************************************************
;* RIPEMD256_Pad - Pad out to 56 mod 64                            *
;* - buffer: data buffer					   *
;* - len : length (in bytes of the buffer)			   *
;*******************************************************************
RIPEMD256_Pad	proc	buffer:dword, len_RMD256:dword
		local	lenmod: dword
		local	endlen: dword
	mov	ecx, len_RMD256
	mov	eax, ecx
	shr	eax, 6		;64 bytes = one 512-bit block
	mov	nbloop_ripemd256, eax	;(located at offset buffer)
	mov	eax, 56d
	and	ecx, 3Fh
	.if	(ecx<56d)
	 mov	lastblock16_use,1 ;1 * 512-bit block is needed (offset lastblock)
	 mov	endlen, 56d	;store length at "dword ptr [lastblock+56d]" and "dword ptr [lastblock+60d]"
	.else
	 mov	lastblock16_use,2	;2 * 512-bit block is needed (offset lastblock)
	 add	eax, 64d
	 mov	endlen, 120d	;store length at "dword ptr [lastblock+120d]" and "dword ptr [lastblock+124d]"
	.endif	
	sub	eax, ecx	;number of byte of padding (0x80 ..)	 
	mov	lenmod, ecx	;len mod 64

	;we are now making the lastbock (offset lastblock16)
	mov	esi, buffer
	mov	edi, offset lastblock16
	mov	ecx, nbloop_ripemd256
	add	ecx ,ecx
	mov	edx, ecx
	add	edx, edx
	lea	ecx, [2*ecx+edx]
	lea	esi, [8*ecx+esi]	;esi = buffer + 64*nbloop

	push	eax			
	push    lenmod
	push	ESI
	PUSH	EDI
	call	RtlMoveMemory;, edi, esi, lenmod
	
	add	edi, lenmod
	PUSH    offset padding16
	PUSH    EDI
	call	RtlMoveMemory
	;call	RtlMoveMemory, edi, offset padding16	;last arg is already on the stack	
	;
	mov	ecx, len_RMD256		;64-bit representation of "len_RMD256"
	mov	edx, ecx
	and	edx, 0E0000000h		;save the 3 highest bits
	bswap	edx
	shl	ecx, 3			;len_RMD256 is in bytes, it's now in bits
	mov	dword ptr [length_ripemd256], ecx
	mov	dword ptr [length_ripemd256+4], edx
	;
	mov	edx, endlen
	mov	eax, dword ptr [length_ripemd256+0]
	mov	ecx, dword ptr [length_ripemd256+4]
	mov	dword ptr [lastblock16+edx], eax
	mov	dword ptr [lastblock16+edx+4], ecx
	ret
RIPEMD256_Pad	endp

;*******************************************************************
;* RIPEMD256_Transform - the main algo (uses eax, ecx, edx)        *
;*  - in edi : 512-bit block					   *
;*******************************************************************
RIPEMD256_Transform	proc
	push	dword ptr [a_ripemd256]
	pop	dword ptr [save1_a]
	;
	push	dword ptr [b_ripemd256]
	pop	dword ptr [save1_b]
	;
	push	dword ptr [c_ripemd256]
	pop	dword ptr [save1_c]
	;
	push	dword ptr [d_ripemd256]
	pop	dword ptr [save1_d]
	;	
	push	dword ptr [aa_ripemd256]
	pop	dword ptr [save2_a]
	;
	push	dword ptr [bb_ripemd256]
	pop	dword ptr [save2_b]
	;
	push	dword ptr [cc_ripemd256]
	pop	dword ptr [save2_c]
	;
	push	dword ptr [dd_ripemd256]
	pop	dword ptr [save2_d]

;/* round 1 */
	FF save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*00], 11
	FF save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*01], 14
	FF save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*02], 15
	FF save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*03], 12
	FF save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*04], 5
	FF save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*05], 8
	FF save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*06], 7
	FF save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*07], 9
	FF save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*08], 11
	FF save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*09], 13
	FF save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*10], 14
	FF save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*11], 15
	FF save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*12], 6
	FF save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*13], 7
	FF save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*14], 9
	FF save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*15], 8
;/* parallel round 1 */
	III save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*05], 8
	III save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*14], 9
	III save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*07], 9
	III save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*00], 11
	III save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*09], 13
	III save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*02], 15
	III save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*11], 15
	III save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*04], 5
	III save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*13], 7
	III save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*06], 7
	III save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*15], 8
	III save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*08], 11
	III save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*01], 14
	III save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*10], 14
	III save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*03], 12
	III save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*12], 6
	mov	eax, save1_a
	xchg	save2_a, eax
	mov	save1_a, eax
;/* round 2 */
	GG save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*07], 7
	GG save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*04], 6
	GG save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*13], 8
	GG save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*01], 13
	GG save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*10], 11
	GG save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*06], 9
	GG save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*15], 7
	GG save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*03], 15
	GG save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*12], 7
	GG save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*00], 12
	GG save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*09], 15
	GG save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*05], 9
	GG save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*02], 11
	GG save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*14], 7
	GG save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*11], 13
	GG save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*08], 12
;/* parallel round 2 */
	HHH save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*06], 9
	HHH save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*11], 13
	HHH save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*03], 15
	HHH save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*07], 7
	HHH save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*00], 12
	HHH save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*13], 8
	HHH save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*05], 9
	HHH save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*10], 11
	HHH save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*14], 7
	HHH save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*15], 7
	HHH save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*08], 12
	HHH save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*12], 7
	HHH save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*04], 6
	HHH save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*09], 15
	HHH save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*01], 13
	HHH save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*02], 11
	mov	eax, save1_b
	xchg	save2_b, eax
	mov	save1_b, eax
;/* round 3 */
	HH save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*03], 11
	HH save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*10], 13
	HH save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*14], 6
	HH save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*04], 7
	HH save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*09], 14
	HH save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*15], 9
	HH save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*08], 13
	HH save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*01], 15
	HH save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*02], 14
	HH save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*07], 8
	HH save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*00], 13
	HH save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*06], 6
	HH save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*13], 5
	HH save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*11], 12
	HH save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*05], 7
	HH save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*12], 5
;/* parallel round 3 */   
	GGG save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*15], 9
	GGG save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*05], 7
	GGG save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*01], 15
	GGG save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*03], 11
	GGG save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*07], 8
	GGG save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*14], 6
	GGG save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*06], 6
	GGG save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*09], 14
	GGG save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*11], 12
	GGG save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*08], 13
	GGG save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*12], 5
	GGG save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*02], 14
	GGG save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*10], 13
	GGG save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*00], 13
	GGG save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*04], 7
	GGG save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*13], 5
	mov	eax, save1_c
	xchg	save2_c, eax
	mov	save1_c, eax
;/* round 4 */
	II save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*01], 11
	II save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*09], 12
	II save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*11], 14
	II save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*10], 15
	II save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*00], 14
	II save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*08], 15
	II save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*12], 9
	II save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*04], 8
	II save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*13], 9
	II save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*03], 14
	II save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*07], 5
	II save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*15], 6
	II save1_a, save1_b, save1_c, save1_d, dword ptr [edi+4*14], 8
	II save1_d, save1_a, save1_b, save1_c, dword ptr [edi+4*05], 6
	II save1_c, save1_d, save1_a, save1_b, dword ptr [edi+4*06], 5
	II save1_b, save1_c, save1_d, save1_a, dword ptr [edi+4*02], 12
;/* parallel round 4 */
	FFF save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*08], 15
	FFF save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*06], 5
	FFF save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*04], 8
	FFF save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*01], 11
	FFF save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*03], 14
	FFF save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*11], 14
	FFF save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*15], 6
	FFF save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*00], 14
	FFF save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*05], 6
	FFF save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*12], 9
	FFF save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*02], 12
	FFF save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*13], 9
	FFF save2_a, save2_b, save2_c, save2_d, dword ptr [edi+4*09], 12
	FFF save2_d, save2_a, save2_b, save2_c, dword ptr [edi+4*07], 5
	FFF save2_c, save2_d, save2_a, save2_b, dword ptr [edi+4*10], 15
	FFF save2_b, save2_c, save2_d, save2_a, dword ptr [edi+4*14], 8
	mov	eax, save1_d
	xchg	save2_d, eax
	mov	save1_d, eax

;/* combine results */
	mov	eax, a_ripemd256
	add	eax, save1_a
	mov	a_ripemd256, eax
	;
	mov	ecx, b_ripemd256
	add	ecx, save1_b
	mov	b_ripemd256, ecx
	;
	mov	edx, c_ripemd256
	add	edx, save1_c
	mov	c_ripemd256, edx
	;
	mov	eax, d_ripemd256
	add	eax, save1_d
	mov	d_ripemd256, eax
	;
	mov	ecx, aa_ripemd256
	add	ecx, save2_a
	mov	aa_ripemd256, ecx
	;
	mov	edx, bb_ripemd256
	add	edx, save2_b
	mov	bb_ripemd256, edx
	;
	mov	eax, cc_ripemd256
	add	eax, save2_c
	mov	cc_ripemd256, eax
	;
	mov	ecx, dd_ripemd256
	add	ecx, save2_d
	mov	dd_ripemd256, ecx

	ret
RIPEMD256_Transform	endp

;*******************************************************************
;* RIPEMD256_Compute - result: eax:ebx:ecx:edx		  	   *
;*******************************************************************
RipeMD256	proc	buffer:dword, len_RMD256:dword
			public	RipeMD256
	call	RIPEMD256_Init
	push	len_RMD256
	push	buffer
	call	RIPEMD256_Pad;, buffer, len_RMD256
	mov	edi, buffer
	mov	esi, nbloop_ripemd256
ripemd256_loop:
	test	esi, esi
	jz	ripemd256_loop_end
	call	RIPEMD256_Transform
	add	edi, 64d
	dec	esi
	jmp	ripemd256_loop
ripemd256_loop_end:

	mov	edi, offset lastblock16
	mov	esi, lastblock16_use
ripemd256_loop2:
	test	esi, esi
	jz	ripemd256_loop_end2
	call	RIPEMD256_Transform		;don't use esi
	add	edi, 64d
	dec	esi
	jmp	ripemd256_loop2
ripemd256_loop_end2:
	mov	eax, a_ripemd256
	bswap 	eax
	mov 	a_ripemd256, eax
	
	mov	eax, b_ripemd256
	bswap 	eax
	mov 	b_ripemd256, eax

	mov	eax, c_ripemd256
	bswap 	eax
	mov 	c_ripemd256, eax
	
	mov	eax, d_ripemd256
	bswap 	eax
	mov 	d_ripemd256, eax

	mov	eax, aa_ripemd256
	bswap 	eax
	mov 	aa_ripemd256, eax
	
	mov	eax, bb_ripemd256
	bswap 	eax
	mov 	bb_ripemd256, eax

	mov	eax, cc_ripemd256
	bswap 	eax
	mov 	cc_ripemd256, eax
	
	mov	eax, dd_ripemd256
	bswap 	eax
	mov 	dd_ripemd256, eax
	invoke wsprintf,buffer,addr sFormat_RMD256,a_ripemd256,b_ripemd256,c_ripemd256,d_ripemd256,aa_ripemd256,bb_ripemd256,cc_ripemd256,dd_ripemd256
	;mov	ecx, 8		;we have to bswap 8 dwords (if we want to use wsprintf %08X..)
	;mov	eax, offset a_ripemd256
	ret
RipeMD256	endp

