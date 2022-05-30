

F1	MACRO					;F1(B,C,D) = BC v not(B) D
	and	ecx, eax			;eax = B
	not	eax				;ecx = C
	and	eax, edx			;edx = D
	or	eax, ecx	
ENDM						;result in eax [edx=_d]

ROUND1	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F1					;eax = F1(B,C,D)
	add	eax, wt				;eax = F1(B,C,D) + wt
	add	eax, k				;eax = F1(B,C,D) + wt + k
	add	eax, _e				;eax = F1(B,C,D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	edx, _b
	mov	ecx, _a
	mov	_b, ecx				;_b = _a
	rol	ecx, 5
	add	eax, ecx			;eax = S5(A) + F1(B,C,D) + e + wt + k
	mov	ecx, _c
	mov	_d, ecx				;_d = _c
	ror	edx, 2
	mov	_c, edx				;_c = S30(B)
	mov	_a, eax				;_a = S5(A) + F1(B,C,D) + e + wt + k
ENDM

F2	MACRO					;F2(B,C,D) = B xor C xor D
	xor	eax, ecx			;eax = B
	xor	eax, edx			;ecx = C
ENDM						;edx = D

ROUND2	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F2					;eax = F2(B,C,D)
	add	eax, wt				;eax = F2(B,C,D) + wt
	add	eax, k				;eax = F2(B,C,D) + wt + k
	add	eax, _e				;eax = F2(B,C,D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	_d, ecx				;_d = _c
	mov	ecx, _b
	ror	ecx, 2
	mov	_c, ecx				;_c = S30(B)
	mov	ecx, _a
	mov	_b, ecx				;_b = _a	
	rol	ecx, 5
	add	eax, ecx
	mov	_a, eax				;_a = S5(A) + F2(B,C,D) + e + wt + k	
ENDM

F3	MACRO					;F3(B,C,D) = BC v BD v CD
	push	eax				;eax = B
	and	eax, ecx			;ecx = C
	and	ecx, edx			;edx = D
	or	eax, ecx
	pop	ecx
	and	ecx, edx
	or	eax, ecx
ENDM						;result in eax [edx=_d]

ROUND3	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F3					;eax = F3(B,C,D)
	add	eax, wt				;eax = F3(B,C,D) + wt
	add	eax, k				;eax = F3(B,C,D) + wt + k
	add	eax, _e				;eax = F3(B,C,D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	edx, _b
	mov	ecx, _a
	mov	_b, ecx				;_b = _a
	rol	ecx, 5
	add	eax, ecx			;eax = S5(A) + F3(B,C,D) + e + wt + k
	mov	ecx, _c
	mov	_d, ecx				;_d = _c
	ror	edx, 2
	mov	_c, edx				;_c = S30(B)
	mov	_a, eax				;_a = S5(A) + F3(B,C,D) + e + wt + k
ENDM

F4	MACRO					;F4(B,C,D) = B xor C xor D	(= F2)
	xor	eax, ecx			;eax = B
	xor	eax, edx			;ecx = C
ENDM						;edx = D

ROUND4	MACRO	_a, _b, _c, _d, _e, wt, k
	mov	eax, _b
	mov	ecx, _c
	mov	edx, _d
	F4					;eax = F4(B,C,D)
	add	eax, wt				;eax = F4(B,C,D) + wt
	add	eax, k				;eax = F4(B,C,D) + wt + k
	add	eax, _e				;eax = F4(B,C,D) + e + wt + k
	mov	_e, edx				;_e = _d
	mov	_d, ecx				;_d = _c
	mov	ecx, _b
	ror	ecx, 2
	mov	_c, ecx				;_c = S30(B)
	mov	ecx, _a
	mov	_b, ecx				;_b = _a	
	rol	ecx, 5
	add	eax, ecx
	mov	_a, eax				;_a = S5(A) + F4(B,C,D) + e + wt + k	
ENDM

;------------------------------------------------------------------------- 
MAXSIZE			equ	260

.data
sBuff		db 200h dup(0)
sFormat		db '%.8x%.8x%.8x%.8x%.8x',0
szWhat		dd 0
padding2_bis	db 80h, 63 dup(0)

.data?	
w0		dd 80 dup(?)
lastblock2_bis	db 64 dup(?)		
		db 64 dup(?)		
lastblock2_bis_use	dd ?		

h0_	dd ?	;state
h1_	dd ?
h2_	dd ?
h3_	dd ?
h4_	dd ?

save_h0_	dd ?
save_h1_	dd ?
save_h2_	dd ?
save_h3_	dd ?
save_h4_	dd ?

length_sha0	dq ?		
nbloop_sha0	dd ?


.code


;***************************************************************************************
;Start SHA0 Handler functions
;***************************************************************************************

SHA0_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push [_len]
		push _Input
		call SHA0
		invoke	wsprintf,_Output, addr strFormat, _Input
		HexLen
        ret
SHA0_RT endp



;***************************************************************************************
;Start SHA0 functions
;***************************************************************************************

SHA0_Init proc
		mov edi, offset HASHES_Current
		assume edi:ptr HASH_PARAMETERS
		mov eax, [edi].SHA0parameterA
		mov	dword ptr [h0_], eax
		mov eax, [edi].SHA0parameterB
		mov	dword ptr [h1_], eax
		mov eax, [edi].SHA0parameterC
		mov	dword ptr [h2_], eax
		mov eax, [edi].SHA0parameterD
		mov	dword ptr [h3_], eax
		mov eax, [edi].SHA0parameterE
		mov	dword ptr [h4_], eax
		assume edi:nothing
		ret
SHA0_Init endp

SHA0_Pad	proc	buffer:dword, len_SHA0:dword
		local	lenmod: dword
		local	endlen: dword
	mov	ecx, len_SHA0
	mov	eax, ecx
	shr	eax, 6			;64 bytes = one 512-bit block
	mov	nbloop_sha0, eax	;(located at offset buffer)
	mov	eax, 56d
	and	ecx, 3Fh
	.if	(ecx<56d)
	 mov	lastblock2_bis_use, 1	;1 * 512-bit block is needed (offset lastblock)
	 mov	endlen, 56d		;store length at "dword ptr [lastblock+56d]" and "dword ptr [lastblock+60d]"
	.else
	 mov	lastblock2_bis_use, 2	;2 * 512-bit block is needed (offset lastblock)
	 add	eax, 64d
	 mov	endlen, 120d		;store length at "dword ptr [lastblock+120d]" and "dword ptr [lastblock+124d]"
	.endif	
	sub	eax, ecx		;number of byte of padding (0x80 ..)	 
	mov	lenmod, ecx		;len mod 64

	
	mov	esi, buffer
	mov	edi, offset lastblock2_bis
	mov	ecx, nbloop_sha0
	add	ecx ,ecx
	mov	edx, ecx
	add	edx, edx
	lea	ecx, [2*ecx+edx]
	lea	esi, [8*ecx+esi]	

	push	eax			
	push    lenmod
	push	ESI
	PUSH	EDI
	call	RtlMoveMemory;, edi, esi, lenmod
	add	edi, lenmod
	PUSH     offset padding2_bis
	PUSH    EDI
	call	RtlMoveMemory	;last arg is already on the stack	
	;
	mov	ecx, len_SHA0		;64-bit representation of "len"
	mov	edx, ecx
	and	edx, 0E0000000h		;save the 3 highest bits
	bswap	edx
	shl	ecx, 3			;len is in bytes, it's now in bits
	mov	dword ptr [length_sha0], ecx
	mov	dword ptr [length_sha0+4], edx
	;
	mov	edx, endlen
	mov	eax, dword ptr [length_sha0+4]		;
	mov	ecx, dword ptr [length_sha0+0]		;difference:
	bswap	eax					;md5  : low-order word first
	bswap	ecx					;sha-1: hight-order word first
	mov	dword ptr [lastblock2_bis+edx], eax		;
	mov	dword ptr [lastblock2_bis+edx+4], ecx	;
	ret
SHA0_Pad	endp


SHA0_Transform	proc
	push	dword ptr [h0_]
	pop	dword ptr [save_h0_]
	push	dword ptr [h1_]
	pop	dword ptr [save_h1_]
	push	dword ptr [h2_]
	pop	dword ptr [save_h2_]
	push	dword ptr [h3_]
	pop	dword ptr [save_h3_]
	push	dword ptr [h4_]
	pop	dword ptr [save_h4_]

;/* Create the 80 32-bit words array (w) */
	FOR i, <0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15>
	 mov	eax, dword ptr [edi+4*i]
	 bswap	eax
	 mov	dword ptr [w0+4*i], eax
	ENDM
	FOR i, <16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79>
	 mov	eax, dword ptr [w0+(4*i)-12d]	;3*4
	 xor	eax, dword ptr [w0+(4*i)-32d]	;8*4
	 xor	eax, dword ptr [w0+(4*i)-56d]	;14*4
	 xor	eax, dword ptr [w0+(4*i)-64d]	;16*4
	 mov	dword ptr [w0+i*4], eax
	ENDM

;/* 4 rounds */
	mov	esi, 5A827999h		;K0..K19
	FOR i, <0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19>
		ROUND1	h0_,h1_,h2_,h3_,h4_, [w0+4*i], esi
	ENDM
	mov	esi, 6ED9EBA1h		;K20..K39
	FOR i, <20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39>
		ROUND2	h0_,h1_,h2_,h3_,h4_, [w0+4*i], esi
	ENDM
	mov	esi, 8F1BBCDCh		;K40..K59
	FOR i, <40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59>
		ROUND3	h0_,h1_,h2_,h3_,h4_, [w0+4*i], esi
	ENDM
	mov	esi, 0CA62C1D6h		;K60..K79
	FOR i, <60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79>
		ROUND4	h0_,h1_,h2_,h3_,h4_, [w0+4*i], esi
	ENDM
;
	mov	eax, save_h0_
	add	h0_, eax
	mov	eax, save_h1_
	add	h1_, eax
	mov	eax, save_h2_
	add	h2_, eax
	mov	eax, save_h3_
	add	h3_, eax
	mov	eax, save_h4_
	add	h4_, eax
	;invoke wsprintf,addr sznumber1,addr sFormat,h0_,h1_,h2_,h3_,h4_
	ret
SHA0_Transform	endp

SHA0	proc	buffer:dword, len_SHA0:dword
		public	SHA0
		local	counter : dword
	call	SHA0_Init
	PUSH      len_SHA0
	push    buffer
	call	SHA0_Pad

	mov	edi, buffer
	mov	esi, nbloop_sha0
	mov	counter, esi
sha0_loop:
	cmp	counter, 0
	jz	sha0_loop_end
	call	SHA0_Transform
	add	edi, 64d
	dec	counter
	jmp	sha0_loop
sha0_loop_end:

	mov	edi, offset lastblock2_bis
	mov	esi, lastblock2_bis_use
	mov	counter, esi
sha0_loop2:
	cmp	counter, 0
	jz	sha0_loop_end2
	call	SHA0_Transform
	add	edi, 64d
	dec	counter
	jmp	sha0_loop2
sha0_loop_end2:
	invoke wsprintf,buffer,addr sFormat,h0_,h1_,h2_,h3_,h4_
	mov	eax, offset h0_
	xor	ecx, ecx	
	ret
SHA0	endp


