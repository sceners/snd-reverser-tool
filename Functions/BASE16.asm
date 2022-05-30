;***************************************************************************************
;Start Char2Hex Handler functions
;***************************************************************************************
BASE16_ENCODE_RT proc uses esi edi edx ecx  _Input:dword, _Output:dword, _len:dword
		mov	eax, _len
		.if	_len > 0	
			push _len
			push _Output
			push _Input
			call CHR2HEX_RT
		.endif
		ret
BASE16_ENCODE_RT endp


BASE16_DECODE_RT proc uses esi edi edx ecx  _Input:dword, _Output:dword, _len:dword
		mov	eax, _len
		HexLen
		.if	_len > 1 && edx == 0		
			push _len
			push _Output
			push _Input
			call HEX2CHR_RT
		.endif
		ret
BASE16_DECODE_RT endp


CHR2HEX_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword
		mov	ebx, _len
		.if	ebx > 0
			mov	esi, _Input
			mov edi, _Output
		@@:
			movzx eax, byte ptr[esi] 
			mov	ecx, 16
			xor	edx, edx
			idiv ecx

			.if	eax <= 9
				add	eax, '0'
			.else
				add	eax, 'W' ;lowercase
			.endif

			.if	edx <= 9
				add	edx, '0'
			.else
				add	edx, 'W' ;lowercase
			.endif

			mov	byte ptr[edi], al
			mov	byte ptr[edi+1], dl
			add	edi, 2
			inc	esi
			dec	ebx
			jne	@b
		.endif
		invoke lstrlen, _Output
		HexLen
		ret
CHR2HEX_RT endp


HEX2CHR_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword
		mov eax, _len
		mov ecx, 2
		xor edx, edx
		idiv ecx
		mov ecx, eax	;length/2
		mov esi, _Input
		mov edi, _Output

		;must be multiple of 2
		.if edx == 0 && _len > 0
			;mov	esi, _Input
			;mov	edi, _Output
			mov	ebx, eax	;length / 2
		@@:
			movzx eax, byte ptr[esi]
			call CharCalc
			cmp	eax, -1
			je	@exit
			imul eax, 16
			mov	edx, eax
			movzx eax, byte ptr[esi+1]
			call CharCalc
			cmp	eax, -1
			je @exit
			add	edx, eax
			add	esi, 2
			mov	byte ptr[edi], dl
			inc	edi
			dec	ebx
			jne	@b
			mov	eax, ecx	;new length
		.else
			mov	byte ptr[edi], 0
			mov	eax, -1
			jmp	@exit
		.endif

		invoke lstrlen, _Output
		@exit:	    
		ret
HEX2CHR_RT endp


CharCalc proc
		.if	eax >= '0' && eax <= '9'
			sub	eax, '0'
		.elseif eax >= 'a' && eax <= 'f'
			sub	eax, 'W'
		.elseif eax >= 'A' && eax <= 'F'
			sub	eax, '7'
		.else
			mov	eax, -1				
		.endif
		ret
CharCalc endp
