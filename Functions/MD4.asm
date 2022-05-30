
MD4RESULT		struct
	dtA		dd	?
	dtB		dd	?
	dtC		dd	?
	dtD		dd	?
MD4RESULT		ends

G macro
	mov ecx, eax	;Copy the X value
	and eax, ebx	;XY
	and ecx, edx	;XZ
	and ebx, edx	;YZ
	or eax, ecx		;XY v XZ
	or eax, ebx		;v YZ
endm

F macro
	and ebx, eax	
	not eax		
	and eax, edx	
	or eax, ebx	
endm

H macro
	xor eax, ebx	;X ^ Y
	xor eax, edx	;X ^ Z
endm

GG macro	dwA, dwB, dwC, dwD, dwX, chS, dwT
	mov eax, dwB
	mov ebx, dwC
	mov edx, dwD
	G
	add eax, dwA
	mov ecx, dwX
	add eax, ecx
	add eax, dwT
	mov cl, chS
	rol eax, cl
	mov dwA, eax
endm

FF macro dwA, dwB, dwC, dwD, dwX, chS
	mov eax, dwB
	mov ebx, dwC
	mov edx, dwD
	F		; F ( B, C, D )
	mov ecx, dwX
	add eax, ecx	; + X[?]
	add eax, dwA	; + A
	mov cl, chS	
	rol eax, cl		;rol

	mov dwA, eax
endm

HH macro	dwA, dwB, dwC, dwD, dwX, chS, dwT
	mov eax, dwB
	mov ebx, dwC
	mov edx, dwD
	H
	add eax, dwA
	mov ecx, dwX
	add eax, ecx
	add eax, dwT
	mov cl, chS
	rol eax, cl
	
	mov dwA, eax
endm

;------------------------------------------------------------------------- 
MD4CONST1 		equ 5a827999h ;sqrt(2)
MD4CONST2 		equ 6ed9eba1h ;sqrt(3)

.data
szTMP			db 20h dup(0)
szMD4Format		db '%.8x%.8x%.8x%.8x', 0


.code
;***************************************************************************************
;Start MD4 Handler functions
;***************************************************************************************

MD4_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push offset sTempBuf
		push [_len]
		push _Input
		call MD4
		invoke	wsprintf, _Output, addr strFormat, _Input
		HexLen
 ret
MD4_RT endp



;***************************************************************************************
;Start MD4 functions
;***************************************************************************************


MD4 proc uses eax ebx ecx edx edi esi, ptBuffer:dword, dtBufferLength:dword, ptMD4Result:dword
	local dta:dword, dtb:dword, dtc:dword, dtd:dword, szData:dword
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
	@@:
		mov	ecx, edx
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
		mov	esi, ptMD4Result
		mov edi, offset HASHES_Current
		assume esi:ptr MD4RESULT
		assume edi:ptr HASH_PARAMETERS
		mov eax, [edi].MD4parameterA
		mov	[esi].dtA, eax
		mov eax, [edi].MD4parameterB
		mov	[esi].dtB, eax
		mov eax, [edi].MD4parameterC
		mov	[esi].dtC, eax
		mov eax, [edi].MD4parameterD
		mov	[esi].dtD, eax
		assume edi:nothing
		;mov	[esi].dtA, 067452301h
		;mov	[esi].dtB, 0efcdab89h
		;mov	[esi].dtC, 098badcfeh
		;mov	[esi].dtD, 010325476h
		mov	edi, ptBuffer
	@hashloop:
		mov	eax, [esi].dtA
		mov	dta, eax
		mov	eax, [esi].dtB
		mov	dtb, eax
		mov	eax, [esi].dtC
		mov	dtc, eax
		mov	eax, [esi].dtD
		mov	dtd, eax

		FF	dta, dtb, dtc, dtd, dword ptr [edi+00h], 03
		FF	dtd, dta, dtb, dtc, dword ptr [edi+04h], 07
		FF	dtc, dtd, dta, dtb, dword ptr [edi+08h], 11
		FF	dtb, dtc, dtd, dta, dword ptr [edi+0Ch], 19
		FF	dta, dtb, dtc, dtd, dword ptr [edi+10h], 03
		FF	dtd, dta, dtb, dtc, dword ptr [edi+14h], 07
		FF	dtc, dtd, dta, dtb, dword ptr [edi+18h], 11
		FF	dtb, dtc, dtd, dta, dword ptr [edi+1Ch], 19
		FF	dta, dtb, dtc, dtd, dword ptr [edi+20h], 03
		FF	dtd, dta, dtb, dtc, dword ptr [edi+24h], 07
		FF	dtc, dtd, dta, dtb, dword ptr [edi+28h], 11
		FF	dtb, dtc, dtd, dta, dword ptr [edi+2Ch], 19
		FF	dta, dtb, dtc, dtd, dword ptr [edi+30h], 03
		FF	dtd, dta, dtb, dtc, dword ptr [edi+34h], 07
		FF	dtc, dtd, dta, dtb, dword ptr [edi+38h], 11
		FF	dtb, dtc, dtd, dta, dword ptr [edi+3Ch], 19

		GG	dta, dtb, dtc, dtd, dword ptr [edi+00h], 03, MD4CONST1
		GG	dtd, dta, dtb, dtc, dword ptr [edi+10h], 05, MD4CONST1
		GG	dtc, dtd, dta, dtb, dword ptr [edi+20h], 09, MD4CONST1
		GG	dtb, dtc, dtd, dta, dword ptr [edi+30h], 13, MD4CONST1
		GG	dta, dtb, dtc, dtd, dword ptr [edi+04h], 03, MD4CONST1
		GG	dtd, dta, dtb, dtc, dword ptr [edi+14h], 05, MD4CONST1
		GG	dtc, dtd, dta, dtb, dword ptr [edi+24h], 09, MD4CONST1
		GG	dtb, dtc, dtd, dta, dword ptr [edi+34h], 13, MD4CONST1
		GG	dta, dtb, dtc, dtd, dword ptr [edi+08h], 03, MD4CONST1
		GG	dtd, dta, dtb, dtc, dword ptr [edi+18h], 05, MD4CONST1
		GG	dtc, dtd, dta, dtb, dword ptr [edi+28h], 09, MD4CONST1
		GG	dtb, dtc, dtd, dta, dword ptr [edi+38h], 13, MD4CONST1
		GG	dta, dtb, dtc, dtd, dword ptr [edi+0Ch], 03, MD4CONST1
		GG	dtd, dta, dtb, dtc, dword ptr [edi+1Ch], 05, MD4CONST1
		GG	dtc, dtd, dta, dtb, dword ptr [edi+2Ch], 09, MD4CONST1
		GG	dtb, dtc, dtd, dta, dword ptr [edi+3Ch], 13, MD4CONST1

		HH	dta, dtb, dtc, dtd, dword ptr [edi+00h], 03, MD4CONST2
		HH	dtd, dta, dtb, dtc, dword ptr [edi+20h], 09, MD4CONST2
		HH	dtc, dtd, dta, dtb, dword ptr [edi+10h], 11, MD4CONST2
		HH	dtb, dtc, dtd, dta, dword ptr [edi+30h], 15, MD4CONST2

		HH	dta, dtb, dtc, dtd, dword ptr [edi+08h], 03, MD4CONST2
		HH	dtd, dta, dtb, dtc, dword ptr [edi+28h], 09, MD4CONST2
		HH	dtc, dtd, dta, dtb, dword ptr [edi+18h], 11, MD4CONST2
		HH	dtb, dtc, dtd, dta, dword ptr [edi+38h], 15, MD4CONST2

		HH	dta, dtb, dtc, dtd, dword ptr [edi+04h], 03, MD4CONST2
		HH	dtd, dta, dtb, dtc, dword ptr [edi+24h], 09, MD4CONST2
		HH	dtc, dtd, dta, dtb, dword ptr [edi+14h], 11, MD4CONST2
		HH	dtb, dtc, dtd, dta, dword ptr [edi+34h], 15, MD4CONST2

		HH	dta, dtb, dtc, dtd, dword ptr [edi+0Ch], 03, MD4CONST2
		HH	dtd, dta, dtb, dtc, dword ptr [edi+2Ch], 09, MD4CONST2
		HH	dtc, dtd, dta, dtb, dword ptr [edi+1Ch], 11, MD4CONST2
		HH	dtb, dtc, dtd, dta, dword ptr [edi+3Ch], 15, MD4CONST2

		mov	eax, dta
		add	[esi].dtA, eax
		mov	eax, dtb
		add	[esi].dtB, eax
		mov	eax, dtc
		add	[esi].dtC, eax
		mov	eax, dtd
		add	[esi].dtD, eax
		add	edi, 64
		sub	[szData], 64
		jg	@hashloop
		mov	ecx, 16
	@@FINAL:
		mov	eax, dword ptr [esi]
		xchg	al, ah
		rol	eax, 16
		xchg	al, ah
		mov	dword ptr [esi], eax
		add	esi, 4
		sub	ecx, 4
		jnz	@@FINAL
		mov	esi, ptMD4Result
		invoke	wsprintfA, ptBuffer, addr szMD4Format, [esi].dtA, [esi].dtB, [esi].dtC, [esi].dtD
		ret
MD4 endp
