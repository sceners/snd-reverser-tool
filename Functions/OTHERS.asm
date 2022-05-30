
.data?
bf_encryptbuf			db 64 dup(?)
bf_tempbuf				db 64 dup(?)
bf_tempbufout			db 64 dup(?)
bf_decryptbuf			db 256 dup(?)
bf_xorin				db 16 dup(?)
bPassedRound			db ?


.code

DecryptEnd	macro s
	mov	esi, offset bf_tempbuf
	.if bCipherMode == 1
		.if bPassedRound
			pop	esi						;hrmmm bad i know
			push esi
			sub	esi, s
			push s
			push esi
			call CipherXor
		.endif
		mov	bPassedRound, 1
	.endif
endm


NULL_RT	proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		;used for nothing :-)
		call DisableKeyEdit
		invoke SetDlgItemText, hWindow, IDC_INFO, addr ErrorSelectFunction
		mov	eax, -1
		ret
NULL_RT endp


DEC2HEX_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call DisableKeyEdit
		mov	eax, _len
		DecLen
		.if	_len > 3 && edx == 0
			push eax
			;convert Dec to chars then to hex
			push _len
			push _Output
			push _Input
			call DEC2CHR_RT

			;clear input to then copy it
			invoke RtlZeroMemory, _Input, _len

			pop	eax	;length / 3
			push eax;_len
			push _Input
			push _Output
			call CHR2HEX_RT
			invoke lstrcpy, _Output, _Input
			invoke lstrlen, _Output
			HexLen
		.else
		 	invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorDecLen
		.endif
		ret
DEC2HEX_RT	endp


HEX2DEC_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call DisableKeyEdit
		mov	eax, _len
		HexLen
		.if	_len > 1 && edx == 0
			push eax
			push _len
			push _Output
			push _Input
			call HEX2CHR_RT

			;clear input to then copy it
			invoke RtlZeroMemory, _Input, _len

			pop	eax	;length / 3
			push eax;_len
			push _Input
			push _Output
			call CHR2DEC_RT
			invoke lstrcpy, _Output, _Input
			invoke lstrlen, _Output
			DecLen
		 .else
		 	invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorHexLen
		.endif
		ret
HEX2DEC_RT	endp


Bit8Prepare	proc uses esi edi edx ecx _Input:dword, _len:dword
		.if bPadInput
			mov	eax, 8
			;get input length
			sub	eax, _len
			mov	ecx, sizeof bf_encryptbuf-1
			mov	edi, offset bf_encryptbuf
			rep stosb
		.else
			xor	eax, eax	;no padding
			mov	ecx, sizeof bf_encryptbuf-1
			mov	edi, offset bf_encryptbuf
			rep stosb
		.endif

		mov	edi, offset bf_encryptbuf
		mov	esi, _Input
		xor	ecx, ecx
	@@:		
		movzx	eax, byte ptr[esi+ecx]
		cmp	eax, 0
		je	@done
		mov	byte ptr[edi+ecx], al
		inc	ecx
		cmp	ecx, 8
		jne	@b
	@done:		
		ret
Bit8Prepare	endp


Bit12Prepare proc uses esi edi edx ecx _Input:dword, _len:dword
		.if bPadInput
			mov	eax, 12
			;get input length
			sub	eax, _len
			mov	ecx, sizeof bf_encryptbuf-1
			mov	edi, offset bf_encryptbuf
			rep stosb
		.else
			xor	eax, eax	;no padding
			mov	ecx, sizeof bf_encryptbuf-1
			mov	edi, offset bf_encryptbuf
			rep stosb
		.endif

		mov	edi, offset bf_encryptbuf
		mov	esi, _Input
		xor	ecx, ecx
	@@:	
		movzx	eax, byte ptr[esi+ecx]
		cmp	eax, 0
		je	@done
		mov	byte ptr[edi+ecx], al
		inc	ecx
		cmp	ecx, 12
		jne	@b
	@done:		
		ret
Bit12Prepare endp


Bit16Prepare proc uses esi edi edx ecx _Input:dword, _len:dword
		.if bPadInput
			mov	eax, 16
			;get input length
			sub	eax, _len
			mov	ecx, sizeof bf_encryptbuf-1
			mov	edi, offset bf_encryptbuf
			rep stosb
		.else
			xor	eax, eax	;no padding
			mov	ecx, sizeof bf_encryptbuf-1
			mov	edi, offset bf_encryptbuf
			rep stosb
		.endif

		mov	edi, offset bf_encryptbuf
		mov	esi, _Input
		xor	ecx, ecx
	@@:	
		movzx	eax, byte ptr[esi+ecx]
		cmp	eax, 0
		je	@done
		mov	byte ptr[edi+ecx], al
		inc	ecx
		cmp	ecx, 16
		jne	@b
	@done:
		ret
Bit16Prepare	endp



;In the cipher-block chaining (CBC) mode, each block of plaintext is XORed with the previous ciphertext block before being encrypted. 
;This way, each ciphertext block is dependent on all plaintext blocks processed up to that point. Also, to make each message unique, 
;an initialization vector must be used in the first block.
CipherXor proc uses esi edi edx ecx ebx _Input:dword, _bits:dword
		;First block is key :)
		mov	ecx, _bits
		mov	esi, _Input
		mov	edi, offset bf_xorin
		rep movsb		
		;Copy 
		xor	ebx, ebx
		mov	esi, offset bf_xorin		;Input
		mov	edi, offset bf_tempbuf		;Last Cipher Block Output
		mov	ecx, _Input
		;xor each part byte by byte :S
	@@:	
		movzx eax, byte ptr[esi+ebx]	
		movzx edx, byte ptr[edi+ebx]
		xor	eax, edx
		;mov 	byte ptr[bf_encryptbuf+ebx], al
		mov byte ptr[ecx+ebx], al
		inc	ebx
		cmp	ebx, _bits
		jne	@b		
		ret
CipherXor endp
