

RESULT struct
	dtA dd ?
	dtB dd ?
	dtC dd ?
	dtD dd ?
RESULT ends


MD5FF macro dta, dtb, dtc, dtd, x, s, t
	mov eax, dtb
	mov ebx, dtc
	mov ecx, dtd
	and ebx, eax
	not eax
	and eax, ecx
	or eax, ebx
	add eax, dta
	add eax, x
	add eax, t
	mov cl, s
	rol eax, cl
	add eax, dtb
	mov dta, eax
endm

MD5GG macro dta, dtb, dtc, dtd, x, s, t
	mov eax, dtb
	mov ebx, dtc
	mov ecx, dtd
	and eax, ecx
	not ecx
	and ecx, ebx
	or eax, ecx
	add eax, dta
	add eax, x
	add eax, t
	mov cl, s
	rol eax, cl
	add eax, dtb
	mov dta, eax
endm

MD5HH macro dta, dtb, dtc, dtd, x, s, t				
	mov eax, dtb
	mov ebx, dtc
	mov ecx, dtd
	xor eax, ebx
	xor eax, ecx
	add eax, dta
	add eax, x
	add eax, t
	mov cl, s
	rol eax, cl
	add eax, dtb
	mov dta, eax
endm

MD5II macro	dta, dtb, dtc, dtd, x, s, t
	mov eax, dtb
	mov ebx, dtc
	mov ecx, dtd
	not ecx
	or eax, ecx
	xor eax, ebx
	add eax, dta
	add eax, x
	add eax, t
	mov cl, s
	rol eax, cl
	add eax, dtb
	mov dta, eax
endm


.data
sex				db 200h dup(0)
sFormat1		db '%.8x%.8x%.8x%.8x', 0


.code
;***************************************************************************************
;Start MD5 Handler functions
;***************************************************************************************

MD5_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push offset sTempBuf
		push [_len]
		push _Input
		call MD5
		invoke	wsprintf, _Output, addr strFormat, _Input
		HexLen		
		ret
MD5_RT endp



;***************************************************************************************
;Start MD5 functions
;***************************************************************************************

MD5	proc uses eax ebx ecx edx edi esi, ptBuffer:dword, dtBufferLength:dword, ptMD5Result:dword
	local dta:dword, dtb:dword, dtc:dword, dtd:dword
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
		mov	esi, ptMD5Result
		mov edi, offset HASHES_Current
		assume esi:ptr RESULT
		assume edi:ptr HASH_PARAMETERS
		mov eax, [edi].MD5parameterA
		mov	[esi].dtA, eax
		mov eax, [edi].MD5parameterB
		mov	[esi].dtB, eax
		mov eax, [edi].MD5parameterC
		mov	[esi].dtC, eax
		mov eax, [edi].MD5parameterD
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

		MD5FF	dta, dtb, dtc, dtd, dword ptr [edi+00*4], 07, 0d76aa478h
		MD5FF	dtd, dta, dtb, dtc, dword ptr [edi+01*4], 12, 0e8c7b756h
		MD5FF	dtc, dtd, dta, dtb, dword ptr [edi+02*4], 17, 0242070dbh
		MD5FF	dtb, dtc, dtd, dta, dword ptr [edi+03*4], 22, 0c1bdceeeh
		MD5FF	dta, dtb, dtc, dtd, dword ptr [edi+04*4], 07, 0f57c0fafh
		MD5FF	dtd, dta, dtb, dtc, dword ptr [edi+05*4], 12, 04787c62ah
		MD5FF	dtc, dtd, dta, dtb, dword ptr [edi+06*4], 17, 0a8304613h
		MD5FF	dtb, dtc, dtd, dta, dword ptr [edi+07*4], 22, 0fd469501h
		MD5FF	dta, dtb, dtc, dtd, dword ptr [edi+08*4], 07, 0698098d8h
		MD5FF	dtd, dta, dtb, dtc, dword ptr [edi+09*4], 12, 08b44f7afh
		MD5FF	dtc, dtd, dta, dtb, dword ptr [edi+10*4], 17, 0ffff5bb1h
		MD5FF	dtb, dtc, dtd, dta, dword ptr [edi+11*4], 22, 0895cd7beh
		MD5FF	dta, dtb, dtc, dtd, dword ptr [edi+12*4], 07, 06b901122h
		MD5FF	dtd, dta, dtb, dtc, dword ptr [edi+13*4], 12, 0fd987193h
		MD5FF	dtc, dtd, dta, dtb, dword ptr [edi+14*4], 17, 0a679438eh
		MD5FF	dtb, dtc, dtd, dta, dword ptr [edi+15*4], 22, 049b40821h

		MD5GG	dta, dtb, dtc, dtd, dword ptr [edi+01*4], 05, 0f61e2562h
		MD5GG	dtd, dta, dtb, dtc, dword ptr [edi+06*4], 09, 0c040b340h
		MD5GG	dtc, dtd, dta, dtb, dword ptr [edi+11*4], 14, 0265e5a51h
		MD5GG	dtb, dtc, dtd, dta, dword ptr [edi+00*4], 20, 0e9b6c7aah
		MD5GG	dta, dtb, dtc, dtd, dword ptr [edi+05*4], 05, 0d62f105dh
		MD5GG	dtd, dta, dtb, dtc, dword ptr [edi+10*4], 09, 002441453h
		MD5GG	dtc, dtd, dta, dtb, dword ptr [edi+15*4], 14, 0d8a1e681h
		MD5GG	dtb, dtc, dtd, dta, dword ptr [edi+04*4], 20, 0e7d3fbc8h
		MD5GG	dta, dtb, dtc, dtd, dword ptr [edi+09*4], 05, 021e1cde6h
		MD5GG	dtd, dta, dtb, dtc, dword ptr [edi+14*4], 09, 0c33707d6h
		MD5GG	dtc, dtd, dta, dtb, dword ptr [edi+03*4], 14, 0f4d50d87h
		MD5GG	dtb, dtc, dtd, dta, dword ptr [edi+08*4], 20, 0455a14edh
		MD5GG	dta, dtb, dtc, dtd, dword ptr [edi+13*4], 05, 0a9e3e905h
		MD5GG	dtd, dta, dtb, dtc, dword ptr [edi+02*4], 09, 0fcefa3f8h
		MD5GG	dtc, dtd, dta, dtb, dword ptr [edi+07*4], 14, 0676f02d9h
		MD5GG	dtb, dtc, dtd, dta, dword ptr [edi+12*4], 20, 08d2a4c8ah

		MD5HH	dta, dtb, dtc, dtd, dword ptr [edi+05*4], 04, 0fffa3942h
		MD5HH	dtd, dta, dtb, dtc, dword ptr [edi+08*4], 11, 08771f681h
		MD5HH	dtc, dtd, dta, dtb, dword ptr [edi+11*4], 16, 06d9d6122h
		MD5HH	dtb, dtc, dtd, dta, dword ptr [edi+14*4], 23, 0fde5380ch
		MD5HH	dta, dtb, dtc, dtd, dword ptr [edi+01*4], 04, 0a4beea44h
		MD5HH	dtd, dta, dtb, dtc, dword ptr [edi+04*4], 11, 04bdecfa9h
		MD5HH	dtc, dtd, dta, dtb, dword ptr [edi+07*4], 16, 0f6bb4b60h
		MD5HH	dtb, dtc, dtd, dta, dword ptr [edi+10*4], 23, 0bebfbc70h
		MD5HH	dta, dtb, dtc, dtd, dword ptr [edi+13*4], 04, 0289b7ec6h
		MD5HH	dtd, dta, dtb, dtc, dword ptr [edi+00*4], 11, 0eaa127fah
		MD5HH	dtc, dtd, dta, dtb, dword ptr [edi+03*4], 16, 0d4ef3085h
		MD5HH	dtb, dtc, dtd, dta, dword ptr [edi+06*4], 23, 004881d05h
		MD5HH	dta, dtb, dtc, dtd, dword ptr [edi+09*4], 04, 0d9d4d039h
		MD5HH	dtd, dta, dtb, dtc, dword ptr [edi+12*4], 11, 0e6db99e5h
		MD5HH	dtc, dtd, dta, dtb, dword ptr [edi+15*4], 16, 01fa27cf8h
		MD5HH	dtb, dtc, dtd, dta, dword ptr [edi+02*4], 23, 0c4ac5665h

		MD5II	dta, dtb, dtc, dtd, dword ptr [edi+00*4], 06, 0f4292244h
		MD5II	dtd, dta, dtb, dtc, dword ptr [edi+07*4], 10, 0432aff97h
		MD5II	dtc, dtd, dta, dtb, dword ptr [edi+14*4], 15, 0ab9423a7h
		MD5II	dtb, dtc, dtd, dta, dword ptr [edi+05*4], 21, 0fc93a039h
		MD5II	dta, dtb, dtc, dtd, dword ptr [edi+12*4], 06, 0655b59c3h
		MD5II	dtd, dta, dtb, dtc, dword ptr [edi+03*4], 10, 08f0ccc92h
		MD5II	dtc, dtd, dta, dtb, dword ptr [edi+10*4], 15, 0ffeff47dh
		MD5II	dtb, dtc, dtd, dta, dword ptr [edi+01*4], 21, 085845dd1h
		MD5II	dta, dtb, dtc, dtd, dword ptr [edi+08*4], 06, 06fa87e4fh
		MD5II	dtd, dta, dtb, dtc, dword ptr [edi+15*4], 10, 0fe2ce6e0h
		MD5II	dtc, dtd, dta, dtb, dword ptr [edi+06*4], 15, 0a3014314h
		MD5II	dtb, dtc, dtd, dta, dword ptr [edi+13*4], 21, 04e0811a1h
		MD5II	dta, dtb, dtc, dtd, dword ptr [edi+04*4], 06, 0f7537e82h
		MD5II	dtd, dta, dtb, dtc, dword ptr [edi+11*4], 10, 0bd3af235h
		MD5II	dtc, dtd, dta, dtb, dword ptr [edi+02*4], 15, 02ad7d2bbh
		MD5II	dtb, dtc, dtd, dta, dword ptr [edi+09*4], 21, 0eb86d391h
		mov	eax, dta
		add	[esi].dtA, eax
		mov	eax, dtb
		add	[esi].dtB, eax
		mov	eax, dtc
		add	[esi].dtC, eax
		mov	eax, dtd
		add	[esi].dtD, eax
		add	edi, 64
		sub	edx, 64
		jnz	@hashloop
		mov	ecx, 4
	@@:			
		mov eax, dword ptr [esi]
		bswap eax
		mov dword ptr [esi], eax
		add esi, 4
		loop @b
		mov	esi, ptMD5Result
		invoke wsprintfA, ptBuffer, addr sFormat1, [esi].dtA, [esi].dtB, [esi].dtC, [esi].dtD
		ret
MD5 endp
