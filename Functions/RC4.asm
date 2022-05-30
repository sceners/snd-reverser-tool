

RC4Init proto :DWORD,:DWORD
RC4Encrypt proto :DWORD,:DWORD

.data?
align 4
rc4_key db 256 dup(?)
rc4_x dd ?
rc4_y dd ?

.code

align 4
RC4Init proc uses esi edi ebx pKey:DWORD,dwKeyLen:DWORD
	xor eax,eax
	mov ecx,256-16
	mov rc4_x,eax
	mov rc4_y,eax
	mov esi,offset rc4_key
	mov edx,0FFFEFDFCh
	mov eax,0FBFAF9F8h
	mov ebx,0F7F6F5F4h
	mov edi,0F3F2F1F0h
	.repeat
		mov dword ptr[esi+ecx+3*4],edx
		mov dword ptr[esi+ecx+2*4],eax
		mov dword ptr[esi+ecx+1*4],ebx
		mov dword ptr[esi+ecx+0*4],edi
		sub edx,010101010h
		sub eax,010101010h
		sub ebx,010101010h
		sub edi,010101010h
		sub ecx,16
	.until sign?;esi < offset rc4_key
	xor edx,edx
	xor ecx,ecx
	mov esi,pKey
	xor ebx,ebx
	mov edi,dwKeyLen
	.repeat
	@@:
		mov al,rc4_key[ecx]
		add dl,[esi+ebx]
		add dl,al
		mov ah,rc4_key[edx]
		inc ebx
		mov rc4_key[edx],al
		mov rc4_key[ecx],ah
		cmp ebx,edi
		jae @F
		inc cl
		jnz @B
		.break
	@@:		
		xor ebx,ebx
		inc cl
	.until zero?
	ret
RC4Init endp

align 4
RC4Encrypt proc uses esi edi ebx pBlock:DWORD,dwBlockLen:DWORD
	mov edi,pBlock
	mov edx,rc4_x
	mov ecx,dwBlockLen
	mov ebx,rc4_y
	dec edi
	xor eax,eax
	.repeat
		add bl,rc4_key[edx+1]
		mov al,rc4_key[edx+1]
		mov ch,rc4_key[ebx]
		mov rc4_key[ebx],al
		mov rc4_key[edx+1],ch
		add al,ch
		inc edi
		mov al,rc4_key[eax]
		inc dl
		xor [edi],al
		dec cl
	.until zero?
	mov rc4_x,edx
	mov rc4_y,ebx
	ret
RC4Encrypt endp
RC4Decrypt equ <RC4Encrypt>
RC4_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 128)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen1128
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			INVOKE RC4Init ,addr sKeyIn,eax
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
		
			mov	esi,_Input
			mov	ebx,_len
			;part into multiples of 8
	EncryptLoop:
			push	esi	;source
			mov	eax,ebx	;length
			
			mov	ecx,8
			xor	edx,edx
			div	ecx
			.if	eax == 0
				mov	eax,edx
			.else
				mov	eax,8
			.endif
			push	eax
			push	esi
			Call Bit8Prepare
			
			;.if bCipherMode == 1
			;push	8
			;push	offset bf_encryptbuf
			;call	CipherXor
			;.endif
		
			INVOKE RC4Encrypt,offset bf_encryptbuf,8
			;convert output to hex string
			mov	eax,dword ptr[bf_encryptbuf]
			mov	edx,dword ptr[bf_encryptbuf+4]
			bswap	eax
			bswap	edx
			invoke wsprintf,addr bf_tempbufout,addr sFormat_2,eax,edx
			invoke	lstrcat,_Output,addr bf_tempbufout
			pop	esi
			add	esi,8
			sub	ebx,8
			
			cmp	ebx,0
			jg	EncryptLoop
			INVOKE lstrlen,_Output
			HexLen
		.ENDIF
		ret
RC4_ENC_RT endp
RC4_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 128)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen1128
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		INVOKE RC4Init,addr sKeyIn,eax
		mov	bPassedRound,0
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,16
		xor	edx,edx
		div	ecx
		cmp	edx,0
		jne	@inputError
		
		invoke RtlZeroMemory,offset bf_decryptbuf,sizeof bf_decryptbuf-1
		;convert hex to chars
		push	_len
		push	offset bf_decryptbuf
		push	_Input
		call	HEX2CHR_RT
		mov	ebx,eax	;length
		.if	eax != -1 ; all chars are ok

		mov	esi,offset bf_decryptbuf
		mov	edi,_Output	;destination
		
		;now we do similar as encryption
	DecryptLoop:
			push	esi	
			push	8	;length
			push	esi
			call	Bit8Prepare
			
		
			INVOKE RC4Decrypt,offset bf_encryptbuf,8
			;DecryptEnd 8
			mov	esi,offset bf_encryptbuf
			mov	eax,dword ptr[esi]
			mov	edx,dword ptr[esi+4]
			mov	dword ptr[edi+4*0],eax
			mov	dword ptr[edi+4*1],edx
			add	edi,8
			pop	esi
			add	esi,8
			sub	ebx,8
			
			cmp	ebx,0
			jg	DecryptLoop
			;now we need to clean it up :)
		INVOKE lstrlen,_Output
		mov	edi,_Output
		movzx	ebx,byte ptr[edi+eax-1];get last char
		.if	ebx < 8	;padding chars are 1-8
			sub	eax,ebx	;fix up length 
			mov	byte ptr[edi+eax],0	;clear it up :)
		.endif
		.elseif
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgHex
		mov	eax,FALSE
		.endif
		
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sError64b
		mov eax, FALSE		
	@endGenerate:
		.ENDIF
		ret
RC4_DEC_RT endp

