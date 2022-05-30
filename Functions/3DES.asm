

_3des_setkey PROTO :DWORD,:DWORD
_3des_encrypt PROTO :DWORD,:DWORD
_3des_decrypt PROTO :DWORD,:DWORD

_3DES_ENCRYPT	macro	LL,R,S,X

		mov	ebp,R
		xor	ebp,[_3des_roundkey+X+S*4]	; u
		mov	edx,R
		xor	edx,[_3des_roundkey+X+S*4+4] ; t
		ror	edx,4
		mov	esi,ebp			; u
		mov	edi,ebp			; u
		mov	ecx,ebp			; u
		shr	esi,2
		and	esi,3fh
		shr	edi,10
		and	edi,3fh
		shr	ecx,18
		and	ecx,3fh
		shr	ebp,26
		and	ebp,3fh
		xor	LL,[des_SPtrans+0*64*4+esi*4]
		xor	LL,[des_SPtrans+2*64*4+edi*4]
		xor	LL,[des_SPtrans+4*64*4+ecx*4]
		xor	LL,[des_SPtrans+6*64*4+ebp*4]
		mov	esi,edx
		mov	edi,edx
		mov	ecx,edx
		shr	esi,2
		and	esi,3fh
		shr	edi,10
		and	edi,3fh
		shr	ecx,18
		and	ecx,3fh
		shr	edx,26
		and	edx,3fh
		xor	LL,[des_SPtrans+1*64*4+esi*4]
		xor	LL,[des_SPtrans+3*64*4+edi*4]
		xor	LL,[des_SPtrans+5*64*4+ecx*4]
		xor	LL,[des_SPtrans+7*64*4+edx*4]
		
endm

.data?

_3des_roundkey	dd	DES_NO_ROUNDKEY*3	dup(?)



.code
_3des_setkey	proc	ptrInkey:DWORD, ptrInkey_length:DWORD

		pushad
		mov	esi,[esp+28h]	; ptrInkey
		push	esi
		call	des_setkey
		push	offset _3des_roundkey
		push	offset des_roundkey
		call	_move
		lea	esi,[esi+8]
		push	esi
		call	des_setkey
		push	offset _3des_roundkey+128
		push	offset des_roundkey
		call	_move
		mov	ecx,[esp+2ch]	; ptrInkey_length
		cmp	ecx,16
		ja	@_r1
		push	offset _3des_roundkey+128*2
		push	offset _3des_roundkey
		call	_move	
		jmp	@_r2
@_r1:
		lea	esi,[esi+8]
		push	esi
		call	des_setkey
		push	offset _3des_roundkey+128*2
		push	offset des_roundkey
		call	_move
@_r2:
		popad
		ret
		
_3des_setkey	endp

_3des_encrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]	; ptrIndata
		mov	eax,dword ptr[esi]		; r
		mov	ebx,dword ptr[esi+4]	; l
		.if bBswapInput
		bswap eax
		bswap ebx
		.endif
		IP	eax,ebx
		ror	eax,29
		ror	ebx,29
		_3DES_ENCRYPT          ebx,eax, 0,0
		_3DES_ENCRYPT          eax,ebx, 2,0
		_3DES_ENCRYPT          ebx,eax, 4,0
		_3DES_ENCRYPT          eax,ebx, 6,0
		_3DES_ENCRYPT          ebx,eax, 8,0
		_3DES_ENCRYPT          eax,ebx,10,0
		_3DES_ENCRYPT          ebx,eax,12,0
		_3DES_ENCRYPT          eax,ebx,14,0
		_3DES_ENCRYPT          ebx,eax,16,0
		_3DES_ENCRYPT          eax,ebx,18,0
		_3DES_ENCRYPT          ebx,eax,20,0
		_3DES_ENCRYPT          eax,ebx,22,0
		_3DES_ENCRYPT          ebx,eax,24,0
		_3DES_ENCRYPT          eax,ebx,26,0
		_3DES_ENCRYPT          ebx,eax,28,0
		_3DES_ENCRYPT          eax,ebx,30,0
		ror	eax,3
		ror	ebx,3
		FP	eax,ebx
		xchg	eax,ebx
		IP	eax,ebx
		ror	eax,29
		ror	ebx,29
		_3DES_ENCRYPT          ebx,eax,30,128
		_3DES_ENCRYPT          eax,ebx,28,128
		_3DES_ENCRYPT          ebx,eax,26,128
		_3DES_ENCRYPT          eax,ebx,24,128
		_3DES_ENCRYPT          ebx,eax,22,128
		_3DES_ENCRYPT          eax,ebx,20,128
		_3DES_ENCRYPT          ebx,eax,18,128
		_3DES_ENCRYPT          eax,ebx,16,128
		_3DES_ENCRYPT          ebx,eax,14,128
		_3DES_ENCRYPT          eax,ebx,12,128
		_3DES_ENCRYPT          ebx,eax,10,128
		_3DES_ENCRYPT          eax,ebx, 8,128
		_3DES_ENCRYPT          ebx,eax, 6,128
		_3DES_ENCRYPT          eax,ebx, 4,128
		_3DES_ENCRYPT          ebx,eax, 2,128
		_3DES_ENCRYPT          eax,ebx, 0,128
		ror	eax,3
		ror	ebx,3
		FP	eax,ebx
		xchg	eax,ebx
		IP	eax,ebx
		ror	eax,29
		ror	ebx,29
		_3DES_ENCRYPT          ebx,eax, 0,128*2
		_3DES_ENCRYPT          eax,ebx, 2,128*2
		_3DES_ENCRYPT          ebx,eax, 4,128*2
		_3DES_ENCRYPT          eax,ebx, 6,128*2
		_3DES_ENCRYPT          ebx,eax, 8,128*2
		_3DES_ENCRYPT          eax,ebx,10,128*2
		_3DES_ENCRYPT          ebx,eax,12,128*2
		_3DES_ENCRYPT          eax,ebx,14,128*2
		_3DES_ENCRYPT          ebx,eax,16,128*2
		_3DES_ENCRYPT          eax,ebx,18,128*2
		_3DES_ENCRYPT          ebx,eax,20,128*2
		_3DES_ENCRYPT          eax,ebx,22,128*2
		_3DES_ENCRYPT          ebx,eax,24,128*2
		_3DES_ENCRYPT          eax,ebx,26,128*2
		_3DES_ENCRYPT          ebx,eax,28,128*2
		_3DES_ENCRYPT          eax,ebx,30,128*2
		ror	eax,3
		ror	ebx,3
		FP	eax,ebx
		mov	edi,[esp+2ch]	; ptrOutdata
		.if bBswapInput
		bswap eax
		bswap ebx
		.endif
		mov	dword ptr[edi],ebx
		mov	dword ptr[edi+4],eax
		popad
		ret
		
_3des_encrypt	endp

_3des_decrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]	; ptrIndata
		mov	eax,dword ptr[esi]		; r
		mov	ebx,dword ptr[esi+4]	; l
		.if bBswapInput
		bswap eax
		bswap ebx
		.endif
		IP	eax,ebx
		ror	eax,29
		ror	ebx,29
		_3DES_ENCRYPT          ebx,eax,30,128*2
		_3DES_ENCRYPT          eax,ebx,28,128*2
		_3DES_ENCRYPT          ebx,eax,26,128*2
		_3DES_ENCRYPT          eax,ebx,24,128*2
		_3DES_ENCRYPT          ebx,eax,22,128*2
		_3DES_ENCRYPT          eax,ebx,20,128*2
		_3DES_ENCRYPT          ebx,eax,18,128*2
		_3DES_ENCRYPT          eax,ebx,16,128*2
		_3DES_ENCRYPT          ebx,eax,14,128*2
		_3DES_ENCRYPT          eax,ebx,12,128*2
		_3DES_ENCRYPT          ebx,eax,10,128*2
		_3DES_ENCRYPT          eax,ebx, 8,128*2
		_3DES_ENCRYPT          ebx,eax, 6,128*2
		_3DES_ENCRYPT          eax,ebx, 4,128*2
		_3DES_ENCRYPT          ebx,eax, 2,128*2
		_3DES_ENCRYPT          eax,ebx, 0,128*2
		ror	eax,3
		ror	ebx,3
		FP	eax,ebx
		xchg	eax,ebx
		IP	eax,ebx
		ror	eax,29
		ror	ebx,29
		_3DES_ENCRYPT          ebx,eax, 0,128
		_3DES_ENCRYPT          eax,ebx, 2,128
		_3DES_ENCRYPT          ebx,eax, 4,128
		_3DES_ENCRYPT          eax,ebx, 6,128
		_3DES_ENCRYPT          ebx,eax, 8,128
		_3DES_ENCRYPT          eax,ebx,10,128
		_3DES_ENCRYPT          ebx,eax,12,128
		_3DES_ENCRYPT          eax,ebx,14,128
		_3DES_ENCRYPT          ebx,eax,16,128
		_3DES_ENCRYPT          eax,ebx,18,128
		_3DES_ENCRYPT          ebx,eax,20,128
		_3DES_ENCRYPT          eax,ebx,22,128
		_3DES_ENCRYPT          ebx,eax,24,128
		_3DES_ENCRYPT          eax,ebx,26,128
		_3DES_ENCRYPT          ebx,eax,28,128
		_3DES_ENCRYPT          eax,ebx,30,128
		ror	eax,3
		ror	ebx,3
		FP	eax,ebx
		xchg	eax,ebx
		IP	eax,ebx
		ror	eax,29
		ror	ebx,29
		_3DES_ENCRYPT          ebx,eax,30,0
		_3DES_ENCRYPT          eax,ebx,28,0
		_3DES_ENCRYPT          ebx,eax,26,0
		_3DES_ENCRYPT          eax,ebx,24,0
		_3DES_ENCRYPT          ebx,eax,22,0
		_3DES_ENCRYPT          eax,ebx,20,0
		_3DES_ENCRYPT          ebx,eax,18,0
		_3DES_ENCRYPT          eax,ebx,16,0
		_3DES_ENCRYPT          ebx,eax,14,0
		_3DES_ENCRYPT          eax,ebx,12,0
		_3DES_ENCRYPT          ebx,eax,10,0
		_3DES_ENCRYPT          eax,ebx, 8,0
		_3DES_ENCRYPT          ebx,eax, 6,0
		_3DES_ENCRYPT          eax,ebx, 4,0
		_3DES_ENCRYPT          ebx,eax, 2,0
		_3DES_ENCRYPT          eax,ebx, 0,0
		ror	eax,3
		ror	ebx,3
		FP	eax,ebx
		mov	edi,[esp+2ch]	; ptrOutdata
		.if bBswapInput
		bswap eax
		bswap ebx
		.endif
		mov	dword ptr[edi],ebx
		mov	dword ptr[edi+4],eax
		popad
		ret
		
_3des_decrypt	endp

_move		proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	esi,[esp+28h]	;ptrIndata
		mov	edi,[esp+2ch]	;ptrOutdata
		mov	ecx,DES_NO_ROUNDKEY	
		cld
		rep	movsd
		popad
		ret
		
_move		endp

_3DES_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 128)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen1128
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			INVOKE _3des_setkey,addr sKeyIn,eax
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
			
			.if bCipherMode == 1
				push	8
				push	offset bf_encryptbuf
				call	CipherXor
			.endif
			INVOKE _3des_encrypt,offset bf_encryptbuf,offset bf_tempbuf
			;convert output to hex string
			mov	eax,dword ptr[bf_tempbuf]
			mov	edx,dword ptr[bf_tempbuf+4]
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
_3DES_ENC_RT endp
_3DES_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 128)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen1128
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		INVOKE _3des_setkey,addr sKeyIn,eax
		mov bPassedRound,0
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
			
		
			INVOKE _3des_decrypt,offset bf_encryptbuf,offset bf_tempbuf
			DecryptEnd 8
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
_3DES_DEC_RT endp

