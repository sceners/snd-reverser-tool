

F1	MACRO					;F1(B, C, D) = BC v not(B) D
	and	ecx, eax			;eax = B
	not	eax					;ecx = C
	and	eax, edx			;edx = D
	or	eax, ecx	
endm						;result in eax [edx=_d]

ROUND1	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F1						;eax = F1(B, C, D)
	add	eax, wt				;eax = F1(B, C, D) + wt
	add	eax, k				;eax = F1(B, C, D) + wt + k
	add	eax, _e				;eax = F1(B, C, D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	edx, _b
	mov	ecx, _a
	mov	_b, ecx				;_b = _a
	rol	ecx, 5
	add	eax, ecx			;eax = S5(A) + F1(B, C, D) + e + wt + k
	mov	ecx, _c
	mov	_d, ecx				;_d = _c
	ror	edx, 2
	mov	_c, edx				;_c = S30(B)
	mov	_a, eax				;_a = S5(A) + F1(B, C, D) + e + wt + k
endm

F2	MACRO					;F2(B, C, D) = B xor C xor D
	xor	eax, ecx			;eax = B
	xor	eax, edx			;ecx = C
endm						;edx = D

ROUND2	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F2						;eax = F2(B, C, D)
	add	eax, wt				;eax = F2(B, C, D) + wt
	add	eax, k				;eax = F2(B, C, D) + wt + k
	add	eax, _e				;eax = F2(B, C, D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	_d, ecx				;_d = _c
	mov	ecx, _b
	ror	ecx, 2
	mov	_c, ecx				;_c = S30(B)
	mov	ecx, _a
	mov	_b, ecx				;_b = _a	
	rol	ecx, 5
	add	eax, ecx
	mov	_a, eax				;_a = S5(A) + F2(B, C, D) + e + wt + k	
endm

F3	MACRO					;F3(B, C, D) = BC v BD v CD
	push	eax				;eax = B
	and	eax, ecx			;ecx = C
	and	ecx, edx			;edx = D
	or	eax, ecx
	pop	ecx
	and	ecx, edx
	or	eax, ecx
endm						;result in eax [edx=_d]

ROUND3	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F3						;eax = F3(B, C, D)
	add	eax, wt				;eax = F3(B, C, D) + wt
	add	eax, k				;eax = F3(B, C, D) + wt + k
	add	eax, _e				;eax = F3(B, C, D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	edx, _b
	mov	ecx, _a
	mov	_b, ecx				;_b = _a
	rol	ecx, 5
	add	eax, ecx			;eax = S5(A) + F3(B, C, D) + e + wt + k
	mov	ecx, _c
	mov	_d, ecx				;_d = _c
	ror	edx, 2
	mov	_c, edx				;_c = S30(B)
	mov	_a, eax				;_a = S5(A) + F3(B, C, D) + e + wt + k
endm

F4	MACRO					;F4(B, C, D) = B xor C xor D	(= F2)
	xor	eax, ecx			;eax = B
	xor	eax, edx			;ecx = C
endm						;edx = D

ROUND4	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F4						;eax = F4(B, C, D)
	add	eax, wt				;eax = F4(B, C, D) + wt
	add	eax, k				;eax = F4(B, C, D) + wt + k
	add	eax, _e				;eax = F4(B, C, D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	_d, ecx				;_d = _c
	mov	ecx, _b
	ror	ecx, 2
	mov	_c, ecx				;_c = S30(B)
	mov	ecx, _a
	mov	_b, ecx				;_b = _a	
	rol	ecx, 5
	add	eax, ecx
	mov	_a, eax				;_a = S5(A) + F4(B, C, D) + e + wt + k	
endm

;------------------------------------------------------------------------- 
MAXSIZE					equ	260

.data
sBuff_SHA1				db 200h dup(0)
sFormat_SHA1			db '%.8x%.8x%.8x%.8x%.8x', 0
szWhat_SHA1				dd 0
padding2_bis_SHA1		db 80h, 63 dup(0)

.data?	
w0_SHA1					dd 80 dup(?)
lastblock2_bis_SHA1		db 64 dup(?)		
						db 64 dup(?)		
lastblock2_bis_SHA1_use	dd ?		

h0_sha1					dd ?	;state
h1_sha1					dd ?
h2_sha1					dd ?
h3_sha1					dd ?
h4_sha1					dd ?

save_h0_sha1			dd ?
save_h1_sha1			dd ?
save_h2_sha1			dd ?
save_h3_sha1			dd ?
save_h4_sha1			dd ?

length_sha1				dq ?		
nbloop_sha1				dd ?


.code

;***************************************************************************************
;Start SHA1 Handler functions
;***************************************************************************************

SHA1_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push [_len]
		push _Input
		call SHA1
		invoke	wsprintf, _Output, addr strFormat, _Input
		HexLen
 ret
SHA1_RT endp



;***************************************************************************************
;Start SHA1 functions
;***************************************************************************************


SHA1_Init proc
		mov edi, offset HASHES_Current
		assume edi:ptr HASH_PARAMETERS
		mov eax, [edi].SHA1parameterA
		mov	dword ptr [h0_sha1], eax
		mov eax, [edi].SHA1parameterB
		mov	dword ptr [h1_sha1], eax
		mov eax, [edi].SHA1parameterC
		mov	dword ptr [h2_sha1], eax
		mov eax, [edi].SHA1parameterD
		mov	dword ptr [h3_sha1], eax
		mov eax, [edi].SHA1parameterE
		mov	dword ptr [h4_sha1], eax
		assume edi:nothing
		ret
SHA1_Init endp


SHA1_Pad proc buffer:dword, len_SHA1:dword
	local lenmod: dword
	local endlen: dword
		mov	ecx, len_SHA1
		mov	eax, ecx
		shr	eax, 6								;64 bytes = one 512-bit block
		mov	nbloop_sha1, eax					;(located at offset buffer)
		mov	eax, 56d
		and	ecx, 3Fh
		.if	(ecx<56d)
			mov	lastblock2_bis_SHA1_use, 1		;1 * 512-bit block is needed (offset lastblock)
			mov	endlen, 56d						;store length at "dword ptr [lastblock+56d]" and "dword ptr [lastblock+60d]"
		.else
			mov lastblock2_bis_SHA1_use, 2		;2 * 512-bit block is needed (offset lastblock)
			add	eax, 64d
			mov	endlen, 120d					;store length at "dword ptr [lastblock+120d]" and "dword ptr [lastblock+124d]"
		.endif	
		sub	eax, ecx							;number of byte of padding (0x80 ..)	 
		mov	lenmod, ecx							;len mod 64

		mov	esi, buffer
		mov	edi, offset lastblock2_bis_SHA1
		mov	ecx, nbloop_sha1
		add	ecx, ecx
		mov	edx, ecx
		add	edx, edx
		lea	ecx, [2*ecx+edx]
		lea	esi, [8*ecx+esi]	

		push eax			
		push lenmod
		push esi
		push edi
		call RtlMoveMemory						;, edi, esi, lenmod
		add	edi, lenmod
		push offset padding2_bis_SHA1
		push edi
		call RtlMoveMemory						;last arg is already on the stack	

		mov	ecx, len_SHA1						;64-bit representation of "len"
		mov	edx, ecx
		and	edx, 0E0000000h						;save the 3 highest bits
		bswap edx
		shl	ecx, 3								;len is in bytes, it's now in bits
		mov	dword ptr [length_sha1], ecx
		mov	dword ptr [length_sha1+4], edx

		mov	edx, endlen
		mov	eax, dword ptr [length_sha1+4]
		mov	ecx, dword ptr [length_sha1+0]		;difference:
		bswap eax								;md5 : low-order word first
		bswap ecx								;sha-1: hight-order word first
		mov	dword ptr [lastblock2_bis_SHA1+edx], eax
		mov	dword ptr [lastblock2_bis_SHA1+edx+4], ecx
		ret
SHA1_Pad	endp


SHA1_Transform	proc
		push dword ptr [h0_sha1]
		pop	dword ptr [save_h0_sha1]
		push dword ptr [h1_sha1]
		pop	dword ptr [save_h1_sha1]
		push dword ptr [h2_sha1]
		pop	dword ptr [save_h2_sha1]
		push dword ptr [h3_sha1]
		pop	dword ptr [save_h3_sha1]
		push dword ptr [h4_sha1]
		pop	dword ptr [save_h4_sha1]

		;/* Create the 80 32-bit words array (w) */
		for i, <0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15>
			mov	eax, dword ptr [edi+4*i]
			bswap	eax
			mov	dword ptr [w0_SHA1+4*i], eax
		endm
		for i, <16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79>
			mov	eax, dword ptr [w0_SHA1+(4*i)-12d]	;3*4
			xor	eax, dword ptr [w0_SHA1+(4*i)-32d]	;8*4
			xor	eax, dword ptr [w0_SHA1+(4*i)-56d]	;14*4
			xor	eax, dword ptr [w0_SHA1+(4*i)-64d]	;16*4
			rol	eax, 1
			mov	dword ptr [w0_SHA1+i*4], eax
		endm

		;/* 4 rounds */
		mov	esi, 5A827999h		;K0..K19
		for i, <0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19>
			ROUND1	h0_sha1, h1_sha1, h2_sha1, h3_sha1, h4_sha1, [w0_SHA1+4*i], esi
		endm

		mov	esi, 6ED9EBA1h		;K20..K39
		for i, <20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39>
			ROUND2	h0_sha1, h1_sha1, h2_sha1, h3_sha1, h4_sha1, [w0_SHA1+4*i], esi
		endm

		mov	esi, 8F1BBCDCh		;K40..K59
		for i, <40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59>
			ROUND3	h0_sha1, h1_sha1, h2_sha1, h3_sha1, h4_sha1, [w0_SHA1+4*i], esi
		endm

		mov	esi, 0CA62C1D6h		;K60..K79
		for i, <60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79>
			ROUND4	h0_sha1, h1_sha1, h2_sha1, h3_sha1, h4_sha1, [w0_SHA1+4*i], esi
		endm

		mov	eax, save_h0_sha1
		add	h0_sha1, eax
		mov	eax, save_h1_sha1
		add	h1_sha1, eax
		mov	eax, save_h2_sha1
		add	h2_sha1, eax
		mov	eax, save_h3_sha1
		add	h3_sha1, eax
		mov	eax, save_h4_sha1
		add	h4_sha1, eax
		;invoke wsprintf, addr sznumber1, addr sFormat_SHA1, h0_sha1, h1_sha1, h2_sha1, h3_sha1, h4_sha1
		ret
SHA1_Transform	endp


SHA1 proc buffer:dword, len_SHA1:dword
	public SHA1
	local counter : dword

		call SHA1_Init
		push len_SHA1
		push buffer
		call SHA1_Pad

		mov	edi, buffer
		mov	esi, nbloop_sha1
		mov	counter, esi
	@sha1_loop:
		cmp	counter, 0
		jz	@sha1_loop_end
		call SHA1_Transform
		add	edi, 64d
		dec	counter
		jmp	@sha1_loop
	@sha1_loop_end:
		mov	edi, offset lastblock2_bis_SHA1
		mov	esi, lastblock2_bis_SHA1_use
		mov	counter, esi
	@sha1_loop2:
		cmp	counter, 0
		jz	@sha1_loop_end2
		call SHA1_Transform
		add	edi, 64d
		dec	counter
		jmp	@sha1_loop2
	@sha1_loop_end2:
		invoke wsprintf, buffer, addr sFormat_SHA1, h0_sha1, h1_sha1, h2_sha1, h3_sha1, h4_sha1
		mov	eax, offset h0_sha1
		xor	ecx, ecx	
		ret
SHA1 endp


