
;*******************************************************************
;* Five important macros					   *
;*******************************************************************
MAJ	MACRO					;MAJ(X,Y,Z)
	mov	ebx, eax			;eax = X
	or	eax, ecx			;ecx = Y
	and	eax, edx			;edx = Z
	and	ecx, ebx
	or	eax, ecx
	ENDM

CH_	MACRO					;CH(X,Y,Z)
	xor	ecx, edx			;eax = X
	and	eax, ecx			;ecx = Y
	xor	eax, edx			;edx = Z
	ENDM

SIG1	MACRO					;SIG1(X) = S(x,6) ^ S(x,11) ^ S(x,25)
	mov	ebx, ecx			;#define S(x,s) ROTR32(x, s)
	mov	edx, ecx
	ror	ecx, 6
	ror	ebx, 11d
	ror	edx, 25d
	xor	ecx, ebx
	xor	ecx, edx
	ENDM

SIG0	MACRO					;SIG0(X) = S(x,2) ^ S(x,13) ^ S(x,22)
	mov	ebx, ecx			;#define S(x,s) ROTR32(x, s)
	mov	edx, ecx
	ror	ecx, 2
	ror	ebx, 13d
	ror	edx, 22d
	xor	ecx, ebx
	xor	ecx, edx
	ENDM

ROUND	MACRO	_a, _b, _c, _d, _e, _f, _g, _h, wj, ki
	mov	eax, _a
	mov	ecx, _b
	mov	edx, _c
	MAJ
	push	eax				;save MAJ(a,b,c)
	mov	eax, _e
	mov	ecx, _f
	mov	edx, _g
	CH_
	add	eax, wj
	add	eax, ki
	add	eax, _h
	;
	mov	ecx, _e
	SIG1					;result in ecx
	add	eax, ecx
	;
	mov	ecx, _d
	add	ecx, eax
	mov	_d, ecx
	;
	mov	ecx, _a
	SIG0					;result in ecx
	add	eax, ecx
	pop	ecx
	add	eax, ecx
	mov	_h ,eax
	ENDM

;extrn	ExitProcess : PROC
;extrn	RtlMoveMemory : PROC

	.data

;sha256_k	dd 0428A2F98h, 071374491h, 0B5C0FBCFh, 0E9B5DBA5h, 03956C25Bh, 059F111F1h, 0923F82A4h, 0AB1C5ED5
;		dd 0D807AA98h, 012835B01h, 0243185BEh, 0550C7DC3h, 072BE5D74h, 080DEB1FEh, 09BDC06A7h, 0C19BF174
;		dd 0E49B69C1h, 0EFBE4786h, 00FC19DC6h, 0240CA1CCh, 02DE92C6Fh, 04A7484AAh, 05CB0A9DCh, 076F988DA
;		dd 0983E5152h, 0A831C66Dh, 0B00327C8h, 0BF597FC7h, 0C6E00BF3h, 0D5A79147h, 006CA6351h, 014292967
;		dd 027B70A85h, 02E1B2138h, 04D2C6DFCh, 053380D13h, 0650A7354h, 0766A0ABBh, 081C2C92Eh, 092722C85
;		dd 0A2BFE8A1h, 0A81A664Bh, 0C24B8B70h, 0C76C51A3h, 0D192E819h, 0D6990624h, 0F40E3585h, 0106AA070
;		dd 019A4C116h, 01E376C08h, 02748774Ch, 034B0BCB5h, 0391C0CB3h, 04ED8AA4Ah, 05B9CCA4Fh, 0682E6FF3
;		dd 0748F82EEh, 078A5636Fh, 084C87814h, 08CC70208h, 090BEFFFAh, 0A4506CEBh, 0BEF9A3F7h, 0C67178F2

sDAATA		db 100h dup(0)
sFormat1_SHA256	db '%.8x%.8x%.8x%.8x%.8x%.8x%.8x%.8x',0
padding5	db 80h, 63 dup(0)
					;the last 512-bit block is located at (offset lastblock)
	.data?	
w_sha256	dd 64 dup(?)
lastblock5	db 64 dup(?)		;last 512-bit block after padding
		db 64 dup(?)		;if length (mod 64) > 55 then another 512-bit block is required
					;// example: length = 59 ; pad = 61 ; 64-bit length representation = 8
					;// which makes two blocks: 59+5 AND 56+8
lastblock5_use	dd ?			;use the second lastblock ?

a_sha256	dd ?
b_sha256	dd ?
c_sha256	dd ?
d_sha256	dd ?
e_sha256	dd ?
f_sha256	dd ?
g_sha256	dd ?
h_sha256	dd ?

save_a_sha256	dd ?
save_b_sha256	dd ?
save_c_sha256	dd ?
save_d_sha256	dd ?
save_e_sha256	dd ?
save_f_sha256	dd ?
save_g_sha256	dd ?
save_h_sha256	dd ?

length_sha256	dq ?		;64-bit representation of the message’s length (before padding bits were added)
nbloop_sha256	dd ?		;number (-1 or -2) of loop (block of 512-bit processing).

;*******************************************************************
;*  CODE                                                           *
;*******************************************************************
	.code


;***************************************************************************************
;Start SHA256 Handler functions
;***************************************************************************************

SHA256_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push [_len]
		push _Input
		call SHA256
		invoke	wsprintf,_Output, addr strFormat, _Input
		HexLen
        ret
SHA256_RT endp




;*******************************************************************
;* SHA256_Init                                                 *
;*******************************************************************
SHA256_Init	proc
		mov edi, offset HASHES_Current
		assume edi:ptr HASH_PARAMETERS
		mov eax, [edi].SHA256parameterA
		mov	dword ptr [a_sha256], eax
		mov eax, [edi].SHA256parameterB
		mov	dword ptr [b_sha256], eax
		mov eax, [edi].SHA256parameterC
		mov	dword ptr [c_sha256], eax
		mov eax, [edi].SHA256parameterD
		mov	dword ptr [d_sha256], eax
		mov eax, [edi].SHA256parameterE
		mov	dword ptr [e_sha256], eax
		mov eax, [edi].SHA256parameterF
		mov	dword ptr [f_sha256], eax
		mov eax, [edi].SHA256parameterG
		mov	dword ptr [g_sha256], eax
		mov eax, [edi].SHA256parameterH
		mov	dword ptr [h_sha256], eax
		assume edi:nothing	
		ret
SHA256_Init	endp

;*******************************************************************
;* SHA256_Pad - Pad out to 56 mod 64                            *
;* - buffer: data buffer					   *
;* - len : length (in bytes of the buffer)			   *
;*******************************************************************
SHA256_Pad	proc	buffer:dword, len_SHA256:dword
		local	lenmod: dword
		local	endlen: dword
	mov	ecx, len_SHA256
	mov	eax, ecx
	shr	eax, 6			;64 bytes = one 512-bit block
	mov	nbloop_sha256, eax	;(located at offset buffer)
	mov	eax, 56d
	and	ecx, 3Fh
	.if	(ecx<56d)
	 mov	lastblock5_use,1	;1 * 512-bit block is needed (offset lastblock)
	 mov	endlen, 56d		;store length at "dword ptr [lastblock+56d]" and "dword ptr [lastblock+60d]"
	.else
	 mov	lastblock5_use,2	;2 * 512-bit block is needed (offset lastblock)
	 add	eax, 64d
	 mov	endlen, 120d	;store length at "dword ptr [lastblock+120d]" and "dword ptr [lastblock+124d]"
	.endif	
	sub	eax, ecx	;number of byte of padding (0x80 ..)	 
	mov	lenmod, ecx	;len mod 64

	;we are now making the lastbock (offset lastblock5)
	mov	esi, buffer
	mov	edi, offset lastblock5
	mov	ecx, nbloop_sha256
	add	ecx ,ecx
	mov	edx, ecx
	add	edx, edx
	lea	ecx, [2*ecx+edx]
	lea	esi, [8*ecx+esi]	;esi = buffer + 64*nbloop

	push	eax	
	push	lenmod
	push	esi
	push	edi
	call	RtlMoveMemory;, edi, esi, lenmod
	add	edi, lenmod
	push	offset padding5
	push	edi
	call	RtlMoveMemory;, edi, offset padding5	;last arg is already on the stack	
	;
	mov	ecx, len_SHA256		;64-bit representation of "len"
	mov	edx, ecx
	and	edx, 0E0000000h		;save the 3 highest bits
	bswap	edx
	shl	ecx, 3			;len is in bytes, it's now in bits
	mov	dword ptr [length_sha256], ecx
	mov	dword ptr [length_sha256+4], edx
	;
	mov	edx, endlen
	mov	eax, dword ptr [length_sha256+4]
	mov	ecx, dword ptr [length_sha256+0]
	bswap	eax
	bswap	ecx
	mov	dword ptr [lastblock5+edx], eax
	mov	dword ptr [lastblock5+edx+4], ecx
	ret
SHA256_Pad	endp

;*******************************************************************
;* SHA256_Transform - the main algo (uses eax, ecx, edx)        *
;*  - in edi : 512-bit block					   *
;*******************************************************************
SHA256_Transform	proc

	push	a_sha256
	pop	save_a_sha256
	push	b_sha256
	pop	save_b_sha256
	push	c_sha256
	pop	save_c_sha256
	push	d_sha256
	pop	save_d_sha256
	push	e_sha256
	pop	save_e_sha256
	push	f_sha256
	pop	save_f_sha256
	push	g_sha256
	pop	save_g_sha256
	push	h_sha256
	pop	save_h_sha256

;/* Create the 64 32-bit words array (w_sha256) */
	FOR i, <0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15>
	 mov	eax, dword ptr [edi+4*i]
	 bswap	eax
	 mov	dword ptr [w_sha256+4*i], eax
	ENDM
	FOR i, <16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63>

	 mov	eax, dword ptr [w_sha256+(4*i)-08d]	;sig1(w[-2])
	 mov	ecx, eax				;
	 mov	edx, eax				;#define sig0(x) (S(x,7) ^ S(x,18) ^ R(x,3))
	 ror	ecx, 17d				;#define sig1(x) (S(x,17) ^ S(x,19) ^ R(x,10))
	 ror	edx, 19d				;#define R(x,s)  ((x) >> (s))
	 shr	eax, 10d				;#define S(x,s) ROTR32(x, s)
	 xor	eax, ecx
	 xor	eax, edx
 	 ;
 	 add	eax, dword ptr [w_sha256+(4*i)-28d]	;-4*7
	 push	eax
	 ; 
	 mov	eax, dword ptr [w_sha256+(4*i)-60d]	;-4*15
	 mov	ecx, eax
	 mov	edx, eax
	 ror	ecx, 07h
	 ror	edx, 18d
	 shr	eax, 3
	 xor	eax, ecx
	 xor	eax, edx
 	 ;
 	 pop	ecx
 	 add	eax, ecx
 	 add	eax, dword ptr [w_sha256+(4*i)-64d]	;-4*16 
 	 mov	dword ptr [w_sha256+i*4], eax
	ENDM
;/* let's go */
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*00], 0428A2F98h
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*01], 071374491h
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*02], 0B5C0FBCFh
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*03], 0E9B5DBA5h
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*04], 03956C25Bh
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*05], 059F111F1h
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*06], 0923F82A4h
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*07], 0AB1C5ED5h
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*08], 0D807AA98h
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*09], 012835B01h
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*10], 0243185BEh
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*11], 0550C7DC3h
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*12], 072BE5D74h
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*13], 080DEB1FEh
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*14], 09BDC06A7h
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*15], 0C19BF174h
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*16], 0E49B69C1h
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*17], 0EFBE4786h
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*18], 00FC19DC6h
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*19], 0240CA1CCh
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*20], 02DE92C6Fh
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*21], 04A7484AAh
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*22], 05CB0A9DCh
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*23], 076F988DAh
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*24], 0983E5152h
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*25], 0A831C66Dh
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*26], 0B00327C8h
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*27], 0BF597FC7h
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*28], 0C6E00BF3h
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*29], 0D5A79147h
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*30], 006CA6351h
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*31], 014292967h
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*32], 027B70A85h
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*33], 02E1B2138h
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*34], 04D2C6DFCh
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*35], 053380D13h
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*36], 0650A7354h
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*37], 0766A0ABBh
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*38], 081C2C92Eh
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*39], 092722C85h
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*40], 0A2BFE8A1h
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*41], 0A81A664Bh
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*42], 0C24B8B70h
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*43], 0C76C51A3h
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*44], 0D192E819h
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*45], 0D6990624h
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*46], 0F40E3585h
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*47], 0106AA070h
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*48], 019A4C116h
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*49], 01E376C08h
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*50], 02748774Ch
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*51], 034B0BCB5h
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*52], 0391C0CB3h
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*53], 04ED8AA4Ah
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*54], 05B9CCA4Fh
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*55], 0682E6FF3h
	ROUND a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, w_sha256[4*56], 0748F82EEh
	ROUND h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, w_sha256[4*57], 078A5636Fh
	ROUND g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, w_sha256[4*58], 084C87814h
	ROUND f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, e_sha256, w_sha256[4*59], 08CC70208h
	ROUND e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, d_sha256, w_sha256[4*60], 090BEFFFAh
	ROUND d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, c_sha256, w_sha256[4*61], 0A4506CEBh
	ROUND c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, b_sha256, w_sha256[4*62], 0BEF9A3F7h
	ROUND b_sha256, c_sha256, d_sha256, e_sha256, f_sha256, g_sha256, h_sha256, a_sha256, w_sha256[4*63], 0C67178F2h
;	
	mov	eax, save_a_sha256
	add	a_sha256, eax
	mov	eax, save_b_sha256
	add	b_sha256, eax
	mov	eax, save_c_sha256
	add	c_sha256, eax
	mov	eax, save_d_sha256
	add	d_sha256, eax
	mov	eax, save_e_sha256
	add	e_sha256, eax
	mov	eax, save_f_sha256
	add	f_sha256, eax
	mov	eax, save_g_sha256
	add	g_sha256, eax
	mov	eax, save_h_sha256
	add	h_sha256, eax
	ret
SHA256_Transform	endp

;*******************************************************************
;* SHA256 - result: eax:ebx:ecx:edx		  	   *
;*******************************************************************
SHA256	proc	buffer:dword, len_SHA256:dword
		public	SHA256
	call	SHA256_Init
	push	len_SHA256
	push	buffer
	call	SHA256_Pad
	mov	edi, buffer
	mov	esi, nbloop_sha256
sha256_loop:
	test	esi, esi
	jz	sha256_loop_end
	call	SHA256_Transform
	add	edi, 64d
	dec	esi
	jmp	sha256_loop
sha256_loop_end:

	mov	edi, offset lastblock5
	mov	esi, lastblock5_use
sha256_loop2:
	test	esi, esi
	jz	sha256_loop_end2
	call	SHA256_Transform		;don't use esi
	add	edi, 64d
	dec	esi
	jmp	sha256_loop2
sha256_loop_end2:
	invoke	wsprintfA,buffer,addr sFormat1_SHA256,a_sha256,b_sha256,c_sha256,d_sha256,e_sha256,f_sha256,g_sha256,h_sha256
	;xor	ecx, ecx	;nothing to bswap.. a,..,h contains the value
	;mov	eax,  offset a_sha256		;pointer to a,b,c,d,e,f,g,h
	ret
SHA256	endp

