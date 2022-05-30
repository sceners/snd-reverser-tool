
.const
u64 struct
	Lo dd ?
	Hi dd ?
u64 ends

.data?
SHA384HashBuf db 128 dup(?)
SHA384Len_Lo u64 <?>
SHA384Index dd ?
SHA384Digest u64 8 dup(<?>)

.data
SHA384CHAIN label qword
dq 0CBBB9D5DC1059ED8h, 0629A292A367CD507h, 09159015A3070DD17h, 0152FECD8F70E5939h
dq 067332667FFC00B31h, 08EB44A8768581511h, 0DB0C2E0D64F98FA7h, 047B5481DBEFA4FA4h

SHA384K label qword
dq 0428A2F98D728AE22h, 07137449123EF65CDh, 0B5C0FBCFEC4D3B2Fh, 0E9B5DBA58189DBBCh
dq 03956C25BF348B538h, 059F111F1B605D019h, 0923F82A4AF194F9Bh, 0AB1C5ED5DA6D8118h
dq 0D807AA98A3030242h, 012835B0145706FBEh, 0243185BE4EE4B28Ch, 0550C7DC3D5FFB4E2h
dq 072BE5D74F27B896Fh, 080DEB1FE3B1696B1h, 09BDC06A725C71235h, 0C19BF174CF692694h
dq 0E49B69C19EF14AD2h, 0EFBE4786384F25E3h, 00FC19DC68B8CD5B5h, 0240CA1CC77AC9C65h
dq 02DE92C6F592B0275h, 04A7484AA6EA6E483h, 05CB0A9DCBD41FBD4h, 076F988DA831153B5h
dq 0983E5152EE66DFABh, 0A831C66D2DB43210h, 0B00327C898FB213Fh, 0BF597FC7BEEF0EE4h
dq 0C6E00BF33DA88FC2h, 0D5A79147930AA725h, 006CA6351E003826Fh, 0142929670A0E6E70h
dq 027B70A8546D22FFCh, 02E1B21385C26C926h, 04D2C6DFC5AC42AEDh, 053380D139D95B3DFh
dq 0650A73548BAF63DEh, 0766A0ABB3C77B2A8h, 081C2C92E47EDAEE6h, 092722C851482353Bh
dq 0A2BFE8A14CF10364h, 0A81A664BBC423001h, 0C24B8B70D0F89791h, 0C76C51A30654BE30h
dq 0D192E819D6EF5218h, 0D69906245565A910h, 0F40E35855771202Ah, 0106AA07032BBD1B8h
dq 019A4C116B8D2D0C8h, 01E376C085141AB53h, 02748774CDF8EEB99h, 034B0BCB5E19B48A8h
dq 0391C0CB3C5C95A63h, 04ED8AA4AE3418ACBh, 05B9CCA4F7763E373h, 0682E6FF3D6B2B8A3h
dq 0748F82EE5DEFB2FCh, 078A5636F43172F60h, 084C87814A1F0AB72h, 08CC702081A6439ECh
dq 090BEFFFA23631E28h, 0A4506CEBDE82BDE9h, 0BEF9A3F7B2C67915h, 0C67178F2E372532Bh
dq 0CA273ECEEA26619Ch, 0D186B8C721C0C207h, 0EADA7DD6CDE0EB1Eh, 0F57D4F7FEE6ED178h
dq 006F067AA72176FBAh, 00A637DC5A2C898A6h, 0113F9804BEF90DAEh, 01B710B35131C471Bh
dq 028DB77F523047D84h, 032CAAB7B40C72493h, 03C9EBE0A15C9BEBCh, 0431D67C49C100D4Ch
dq 04CC5D4BECB3E42B6h, 0597F299CFC657E2Ah, 05FCB6FAB3AD6FAECh, 06C44198C4A475817h


.code

;***************************************************************************************
;Start SHA384 Handler functions
;***************************************************************************************

SHA384_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:

		mov	esi, offset HASHES_Current
		mov edi, offset SHA384CHAIN
		assume esi:ptr HASH_PARAMETERS
		mov ebx, [esi].SHA384parameterA
		mov dword ptr [edi], ebx
		mov ebx, [esi].SHA384parameterB
		mov dword ptr [edi+4], ebx 
		mov ebx, [esi].SHA384parameterC
		mov dword ptr [edi+8], ebx 
		mov ebx, [esi].SHA384parameterD
		mov dword ptr [edi+12], ebx 
		mov ebx, [esi].SHA384parameterE
		mov dword ptr [edi+16], ebx 
		mov ebx, [esi].SHA384parameterF
		mov dword ptr [edi+20], ebx 
		mov ebx, [esi].SHA384parameterG
		mov dword ptr [edi+24], ebx 
		mov ebx, [esi].SHA384parameterH
		mov dword ptr [edi+28], ebx 
		mov ebx, [esi].SHA384parameterI
		mov dword ptr [edi+32], ebx 
		mov ebx, [esi].SHA384parameterJ
		mov dword ptr [edi+36], ebx 
		mov ebx, [esi].SHA384parameterK
		mov dword ptr [edi+40], ebx 
		mov ebx, [esi].SHA384parameterL
		mov dword ptr [edi+44], ebx 
		mov ebx, [esi].SHA384parameterM
		mov dword ptr [edi+48], ebx 
		mov ebx, [esi].SHA384parameterN
		mov dword ptr [edi+52], ebx 
		mov ebx, [esi].SHA384parameterO
		mov dword ptr [edi+56], ebx 
		mov ebx, [esi].SHA384parameterP
		mov dword ptr [edi+60], ebx 
		assume esi:nothing

		call SHA384Init
		push [_len]
		push _Input
		call SHA384Update
		call SHA384Final
		mov	edi, offset SHA384Digest
		xor	ebx, ebx
	@@:
		mov	eax, dword ptr[edi+ebx*4]
		bswap eax
		invoke wsprintf, _Input, addr hex32bitlc, eax
		invoke lstrcat, _Output, _Input
		inc	ebx
		cmp	ebx, 12
		jl @b
		invoke lstrlen, _Output
		HexLen
	     ret
SHA384_RT endp


;MOV64 macro m2:req, m1:req
;	mov eax, [m1].u64.Lo
;	mov edx, [m1].u64.Hi
;	mov [m2].u64.Lo, eax
;	mov [m2].u64.Hi, edx
;endm

ADD64 macro m2:req, m1:req
	mov eax, [m1].u64.Lo
	mov edx, [m1].u64.Hi
	add [m2].u64.Lo, eax
	adc [m2].u64.Hi, edx
endm

ROR64 macro RegLo, RegHi, N
	if N lt 32
		shrd RegLo, RegHi, N
		shrd RegHi, ebp, N
	else
		shld RegLo, RegHi, 64-N
		shld RegHi, ebp, 64-N
	endif
endm

SHR64 macro RegLo, RegHi, N
	shrd RegLo, RegHi, N
	shr RegHi, N
endm

SHL64 macro RegLo, RegHi, N
	shld RegHi, RegLo, N
	shl RegLo, N
endm

SIGMA macro qwX, n1, n2, n3 
	mov eax, [qwX].u64.Lo
	mov edx, [qwX].u64.Hi
	mov esi, eax
	mov edi, edx
	mov ebx, eax
	mov ecx, edx
;	push ebp
	mov ebp, eax
	ROR64 eax, edx, n1;np
	ROR64 ebx, ecx, n2;np
	ROR64 esi, edi, n3;np
;	pop ebp
	xor eax, ebx
	xor edx, ecx
	xor eax, esi
	xor edx, edi	
endm

SIGMA2 macro qwX, n1, n2, n3
	mov eax, [qwX].u64.Lo
	mov edx, [qwX].u64.Hi
	mov ebx, eax
	mov ecx, edx
	mov esi, eax
	mov edi, edx
	mov ebx, eax
	mov ecx, edx
;	push ebp
	mov ebp, eax
	ROR64 eax, edx, n1;np
	ROR64 ebx, ecx, n2;np
	SHR64 esi, edi, n3;np
;	pop ebp
	xor eax, ebx
	xor edx, ecx
	xor eax, esi
	xor edx, edi
endm

SHA384R macro qwA, qwB, qwC, qwD, qwE, qwF, qwG, qwH, Iter
;SIG1()
	SIGMA qwE, 14, 18, 41
;CH()
	mov ebx, qwF.u64.Lo
	mov ecx, qwF.u64.Hi
	mov esi, qwE.u64.Lo
	mov edi, qwE.u64.Hi
	xor ebx, qwG.u64.Lo
	xor ecx, qwG.u64.Hi
	and esi, ebx
	and edi, ecx
	xor esi, qwG.u64.Lo
	xor edi, qwG.u64.Hi
; + h + K[i] + W[i]
	add eax, qwH.u64.Lo
	adc edx, qwH.u64.Hi
	add eax, esi
	adc edx, edi
	mov esi, cnt
	shl esi, 3
	add esi, Iter
	add eax, SHA384K[esi*8].u64.Lo
	adc edx, SHA384K[esi*8].u64.Hi
	add eax, SHA384W[esi*8].u64.Lo
	adc edx, SHA384W[esi*8].u64.Hi
	mov SHA384tmp.u64.Lo, eax; T1
	mov SHA384tmp.u64.Hi, edx
;SIG0
	SIGMA qwA, 28, 34, 39
;MAJ	
	mov ebx, qwA.u64.Lo
	mov ecx, qwA.u64.Hi
	or ebx, qwB.u64.Lo
	or ecx, qwB.u64.Hi
	and ebx, qwC.u64.Lo
	and ecx, qwC.u64.Hi
	mov esi, qwB.u64.Lo
	mov edi, qwB.u64.Hi
	and esi, qwA.u64.Lo
	and edi, qwA.u64.Hi
	or ebx, esi
	or ecx, edi
;
	mov esi, SHA384tmp.u64.Lo; T1
	mov edi, SHA384tmp.u64.Hi
	add eax, ebx
	adc edx, ecx
	add eax, esi
	adc edx, edi
	mov qwH.u64.Lo, eax
	mov qwH.u64.Hi, edx
;d += T1
	add qwD.u64.Lo, esi
	adc qwD.u64.Hi, edi
ENDM

align dword
SHA384Transform proc
	pushad
	SHA384locals equ 8*8+1*4+1*8+80*8
	sub esp, SHA384locals
	llA equ dword ptr [esp+0*8]
	llB equ dword ptr [esp+1*8]
	llC equ dword ptr [esp+2*8]
	llD equ dword ptr [esp+3*8]
	llE equ dword ptr [esp+4*8]
	llF equ dword ptr [esp+5*8]
	llG equ dword ptr [esp+6*8]
	llH equ dword ptr [esp+7*8]
	cnt equ dword ptr [esp+16*4]
	SHA384tmp equ dword ptr [esp+17*4]
	SHA384W equ dword ptr [esp+19*4]
	mov esi, offset SHA384Digest
	mov edi, offset SHA384HashBuf	
	;MOV64 llA, esi[0*8]
	;MOV64 llB, esi[1*8]
	;MOV64 llC, esi[2*8]
	;MOV64 llD, esi[3*8]
	;MOV64 llE, esi[4*8]
	;MOV64 llF, esi[5*8]
	;MOV64 llG, esi[6*8]
	;MOV64 llH, esi[7*8]
	mov eax, dword ptr[esi+4*0];.u64.Lo
	mov edx, dword ptr[esi+4*1];.u64.Hi
	mov dword ptr[llA+4*0], eax
	mov dword ptr[llA+4*1], edx
	mov eax, dword ptr[esi+4*2];.u64.Lo
	mov edx, dword ptr[esi+4*3];.u64.Hi
	mov dword ptr[llB+4*0], eax
	mov dword ptr[llB+4*1], edx
	mov eax, dword ptr[esi+4*4];.u64.Lo
	mov edx, dword ptr[esi+4*5];.u64.Hi
	mov dword ptr[llC+4*0], eax
	mov dword ptr[llC+4*1], edx
	mov eax, dword ptr[esi+4*6];.u64.Lo
	mov edx, dword ptr[esi+4*7];.u64.Hi
	mov dword ptr[llD+4*0], eax
	mov dword ptr[llD+4*1], edx
	mov eax, dword ptr[esi+4*8];.u64.Lo
	mov edx, dword ptr[esi+4*9];.u64.Hi
	mov dword ptr[llE+4*0], eax
	mov dword ptr[llE+4*1], edx
	mov eax, dword ptr[esi+4*10];.u64.Lo
	mov edx, dword ptr[esi+4*11];.u64.Hi
	mov dword ptr[llF+4*0], eax
	mov dword ptr[llF+4*1], edx
	mov eax, dword ptr[esi+4*12];.u64.Lo
	mov edx, dword ptr[esi+4*13];.u64.Hi
	mov dword ptr[llG+4*0], eax
	mov dword ptr[llG+4*1], edx
	mov eax, dword ptr[esi+4*14];.u64.Lo
	mov edx, dword ptr[esi+4*15];.u64.Hi
	mov dword ptr[llH+4*0], eax
	mov dword ptr[llH+4*1], edx
	
	xor esi, esi
	.repeat
		mov eax, [edi+8*esi].u64.Lo
		mov edx, [edi+8*esi].u64.Hi
		mov ebx, [edi+8*esi+8].u64.Lo
		mov ecx, [edi+8*esi+8].u64.Hi
		bswap eax
		bswap edx
		bswap ebx
		bswap ecx
		mov [SHA384W+8*esi].u64.Lo, edx
		mov [SHA384W+8*esi].u64.Hi, eax
		mov [SHA384W+8*esi+8].u64.Lo, ecx
		mov [SHA384W+8*esi+8].u64.Hi, ebx
		add esi, 2
	.until esi==16
	mov cnt, esi
	.repeat
		mov edi, cnt
		lea esi, [edi-2]
		SIGMA2 SHA384W[esi*8], 19, 61, 6
		mov edi, cnt
		lea esi, [edi-7]
		add eax, SHA384W[esi*8].u64.Lo
		adc edx, SHA384W[esi*8].u64.Hi
		mov SHA384W[edi*8].u64.Lo, eax
		mov SHA384W[edi*8].u64.Hi, edx
		mov edi, cnt
		lea esi, [edi-15]
		SIGMA2 SHA384W[esi*8], 1, 8, 7
		mov edi, cnt
		lea esi, [edi-16]
		add eax, SHA384W[esi*8].u64.Lo
		adc edx, SHA384W[esi*8].u64.Hi
		add SHA384W[edi*8].u64.Lo, eax
		adc SHA384W[edi*8].u64.Hi, edx
		inc cnt
	.until cnt==80
	xor edx, edx
	mov cnt, edx
	.repeat
		SHA384R llA, llB, llC, llD, llE, llF, llG, llH, 0
		SHA384R llH, llA, llB, llC, llD, llE, llF, llG, 1
		SHA384R llG, llH, llA, llB, llC, llD, llE, llF, 2
		SHA384R llF, llG, llH, llA, llB, llC, llD, llE, 3
		SHA384R llE, llF, llG, llH, llA, llB, llC, llD, 4
		SHA384R llD, llE, llF, llG, llH, llA, llB, llC, 5
		SHA384R llC, llD, llE, llF, llG, llH, llA, llB, 6
		SHA384R llB, llC, llD, llE, llF, llG, llH, llA, 7
		inc cnt
	.until cnt == 10
	ADD64 SHA384Digest[0*8], llA
	ADD64 SHA384Digest[1*8], llB
	ADD64 SHA384Digest[2*8], llC
	ADD64 SHA384Digest[3*8], llD
	ADD64 SHA384Digest[4*8], llE
	ADD64 SHA384Digest[5*8], llF
	ADD64 SHA384Digest[6*8], llG
	ADD64 SHA384Digest[7*8], llH
	add esp, SHA384locals
	popad
	ret
SHA384Transform endp

SHA384BURN macro
	xor eax, eax
	mov SHA384Index, eax
	mov edi, Offset SHA384HashBuf
	mov ecx, (sizeof SHA384HashBuf)/4
	rep stosd
endm

align dword
SHA384Init proc uses edi esi
	xor eax, eax
	mov SHA384Len_Lo.Hi, eax
	mov SHA384Len_Lo.Lo, eax
	mov edi, Offset SHA384Digest
	mov esi, Offset SHA384CHAIN
	mov ecx, 64/4
	rep movsd	
	SHA384BURN
	mov eax, Offset SHA384Digest 
	ret
SHA384Init endp

align dword
SHA384Update proc uses esi edi ebx buf:dword, _len:dword
	mov ebx, _len
	mov eax, ebx
	xor edx, edx
	shld edx, eax, 3
	shl eax, 3
	add SHA384Len_Lo.Lo, eax
	add SHA384Len_Lo.Hi, edx
	.while ebx
		mov eax, SHA384Index
		mov edx, 128
		sub edx, eax
		.if edx <= ebx;len
			lea edi, [SHA384HashBuf+eax]	
			mov esi, buf
			mov ecx, edx
			rep movsb
			mov buf, esi
			sub ebx, edx
			call SHA384Transform
			SHA384BURN
		.else
			lea edi, [SHA384HashBuf+eax]	
			mov esi, buf
			mov ecx, ebx
			rep movsb
			add SHA384Index, ebx
			.break
		.endif
	.endw
	ret
SHA384Update endp

align dword
SHA384Final proc uses esi edi
	mov ecx, SHA384Index
	mov byte ptr [SHA384HashBuf+ecx], 80h
	.if ecx >= 112
		call SHA384Transform
		SHA384BURN
	.endif
	mov eax, SHA384Len_Lo.Lo
	mov edx, SHA384Len_Lo.Hi
	bswap eax
	bswap edx
	mov [SHA384HashBuf+120].u64.Lo, edx
	mov [SHA384HashBuf+120].u64.Hi, eax
	call SHA384Transform
	mov eax, offset SHA384Digest
	xor ecx, ecx
	.repeat; DwSWAP
		mov	esi, [eax+ecx].u64.Lo
		mov	edi, [eax+ecx].u64.Hi
		bswap edi
		bswap esi
		mov	[eax+ecx].u64.Hi, esi
		mov	[eax+ecx].u64.Lo, edi
		add ecx, 8
	.until ecx==384/8
	ret
SHA384Final endp
