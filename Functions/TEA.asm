TEAInit	proto :DWORD
TEAEncrypt	proto :DWORD,:DWORD
TEADecrypt	proto :DWORD,:DWORD

TEA_ROUNDS equ 32
TEA_DELTA equ 9E3779B9h

.data?
TEA_KEY dd 4 dup(?)

.code

align dword
;d74c51c7d53091fd bsawp key
;cb208e722e7da375

TEAInit proc pKey:DWORD
	mov eax,pKey
	mov ecx,[eax+0*4]
	mov edx,[eax+1*4]
	.if bBswapKey
	bswap ecx
	bswap edx
	.endif
	mov [TEA_KEY+0*4],ecx
	mov [TEA_KEY+1*4],edx
	mov ecx,[eax+2*4]
	mov edx,[eax+3*4]
	.if bBswapKey
	bswap ecx
	bswap edx
	.endif
	mov [TEA_KEY+2*4],ecx
	mov [TEA_KEY+3*4],edx
	ret
TEAInit endp

; v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
    
TEAROUND macro y,z,k,enc
	mov ecx,z
	shl ecx,4 ;(v1<<4)
	mov edi,z
	lea esi,[z+ebx]
	add ecx,[TEA_KEY+(k+0)*4];(v1<<4) + k0) 
	shr edi,5
	xor ecx,esi
	add edi,[TEA_KEY+(k+1)*4]
	xor ecx,edi
	if enc eq 1 
	add y,ecx
	else
	sub y,ecx
	endif
endm
ExTEAROUND1	macro y,z,enc
	;y += (((z << 4) ^ (z >> 5)) + z) ^ (sum + k[sum & 3]);	
		mov ecx,z
		shl ecx,4 	;(z << 4)
		mov edi,z
		shr edi,5	;(z >> 5)
		xor ecx,edi 	;(z << 4) ^ (z >> 5)
		add ecx,z 	;(z << 4) ^ (z >> 5)) + z)
		mov esi,ebx	;sum
		and esi,3	;k[sum & 3]
		mov edi,ebx	
		add edi,dword ptr[TEA_KEY+esi*4] ;(sum + k[sum & 3])
		xor ecx,edi	;((z << 4) ^ (z >> 5)) + z) ^ (sum + k[sum & 3]
		if enc eq 1 
		add y,ecx
		else
		sub y,ecx
		endif
endm
ExTEAROUND2	macro y,z,enc
	;y += (((z << 4) ^ (z >> 5)) + z) ^ (sum + k[(sum>>11) & 3]);
		mov ecx,z
		shl ecx,4 	;(z << 4)
		mov edi,z
		shr edi,5	;(z >> 5)
		xor ecx,edi 	;(z << 4) ^ (z >> 5)
		add ecx,z 	;(z << 4) ^ (z >> 5)) + z)
		mov esi,ebx	;sum
		shr esi,11
		and esi,3	;k[sum>>11& 3]
		mov edi,ebx	
		add edi,dword ptr[TEA_KEY+esi*4] ;(sum + k[sum & 3])
		xor ecx,edi	;((z << 4) ^ (z >> 5)) + z) ^ (sum + k[sum & 3]
		if enc eq 1 
		add y,ecx
		else
		sub y,ecx
		endif
endm
align dword
TEAEncrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
	mov esi,pBlockIn
	mov eax,dword ptr[esi+0*4];y
	mov edx,dword ptr[esi+1*4];z
	xor ebx,ebx
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	.repeat
		add ebx,TEA_DELTA
		TEAROUND eax,edx,0,1
		TEAROUND edx,eax,2,1
		add ebx,TEA_DELTA
		TEAROUND eax,edx,0,1
		TEAROUND edx,eax,2,1
	.until ebx == TEA_DELTA*TEA_ROUNDS
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	mov esi,pBlockOut
	mov dword ptr[esi+0*4],eax
	mov dword ptr[esi+1*4],edx
	ret
TEAEncrypt endp

align dword
TEADecrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
	mov esi,pBlockIn
	mov eax,dword ptr[esi+0*4]
	mov edx,dword ptr[esi+1*4]
	mov ebx,TEA_DELTA*TEA_ROUNDS
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	.repeat
		TEAROUND edx,eax,2,0
		TEAROUND eax,edx,0,0
		sub ebx,TEA_DELTA
		TEAROUND edx,eax,2,0
		TEAROUND eax,edx,0,0
		sub ebx,TEA_DELTA
	.until zero?
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	mov esi,pBlockOut
	mov dword ptr[esi+0*4],eax
	mov dword ptr[esi+1*4],edx
	ret
TEADecrypt endp
TEA_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
		
			INVOKE TEAInit,addr sKeyIn
			
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
			INVOKE TEAEncrypt,offset bf_encryptbuf,offset bf_tempbuf
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
TEA_ENC_RT endp
TEA_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
		
		INVOKE TEAInit,addr sKeyIn
		
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,16
		xor	edx,edx
		div	ecx
		cmp	edx,0
		jne	@inputError
		invoke RtlZeroMemory,offset bf_decryptbuf,sizeof bf_decryptbuf-1
		mov	bPassedRound,0
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
			
		
			INVOKE TEADecrypt,offset bf_encryptbuf,offset bf_tempbuf

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
TEA_DEC_RT endp

;v0 += ((v1 << 4 ^ v1 >> 5) + v1) ^ (sum + k[sum & 3]);
;sum += delta;
;v1 += ((v0 << 4 ^ v0 >> 5) + v0) ^ (sum + k[sum>>11 & 3]);
ExTEAEncrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
LOCAL	i:DWORD
	mov esi,pBlockIn
	mov eax,dword ptr[esi+0*4];y
	mov edx,dword ptr[esi+1*4];z
	xor ebx,ebx
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	.repeat
		add ebx,TEA_DELTA
		ExTEAROUND1 eax,edx,1
		ExTEAROUND2 edx,eax,1
		add ebx,TEA_DELTA
		ExTEAROUND1 eax,edx,1
		ExTEAROUND2 edx,eax,1
	.until ebx == TEA_DELTA*TEA_ROUNDS
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	mov esi,pBlockOut
	mov dword ptr[esi+0*4],eax
	mov dword ptr[esi+1*4],edx
	ret
ExTEAEncrypt endp

align dword
ExTEADecrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
mov esi,pBlockIn
	mov eax,dword ptr[esi+0*4]
	mov edx,dword ptr[esi+1*4]
	mov ebx,TEA_DELTA*TEA_ROUNDS
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	.repeat
		ExTEAROUND2 edx,eax,0
		ExTEAROUND1 eax,edx,0
		sub ebx,TEA_DELTA
		ExTEAROUND2 edx,eax,0
		ExTEAROUND1 eax,edx,0
		sub ebx,TEA_DELTA
	.until zero?
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	mov esi,pBlockOut
	mov dword ptr[esi+0*4],eax
	mov dword ptr[esi+1*4],edx
	ret
ExTEADecrypt endp
ExTEA_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
		
			INVOKE TEAInit,addr sKeyIn
			
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
		
			INVOKE ExTEAEncrypt,offset bf_encryptbuf,offset bf_tempbuf
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
ExTEA_ENC_RT endp
ExTEA_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		INVOKE TEAInit,addr sKeyIn
		
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,16
		xor	edx,edx
		div	ecx
		cmp	edx,0
		jne	@inputError
		invoke RtlZeroMemory,offset bf_decryptbuf,sizeof bf_decryptbuf-1
		mov	bPassedRound,0
		
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
			
		
			INVOKE ExTEADecrypt,offset bf_encryptbuf,offset bf_tempbuf
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
ExTEA_DEC_RT endp
;   var z = v[n-1], y = v[0], delta = 0x9E3779B9;
;    var mx, e, q = Math.floor(6 + 52/n), sum = 0;
;    while (q-- > 0) {  // 6 + 52/n operations gives between 6 & 32 mixes on each word
;        sum += delta;
;        e = sum>>>2 & 3;

;        for (var p = 0; p < n; p++) {
;            y = v[(p+1)%n];
;            mx = (z>>>5 ^ y<<2) + (y>>>3 ^ z<<4) ^ (sum^y) + (k[p&3 ^ e] ^ z);
;            z = v[p] += mx;
;http://www.movable-type.co.uk/scripts/tea-block.html
XXTEAROUND	macro y,z,e,p,enc

	
		mov ecx,z
		shr ecx,5
		mov edi,z
		shl edi,2
		xor ecx,edi	;(z>>>5 ^ y<<2) 
		mov esi,z
		shr esi,3
		mov edi,z
		shl edi,4	;(y>>>3 ^ z<<4)
		xor esi,edi
		add ecx,esi	;(z>>>5 ^ y<<2) + (y>>>3 ^ z<<4)

		mov  edi,p
		xor  edi,e
		mov  edi,dword ptr[TEA_KEY+edi*4] ;(k[p&3 ^ e] ^ z);
		xor  edi,z
		
		mov  esi,ebx			; (sum^y)
		xor  esi,z
		add  edi,esi

		xor  ecx,edi	;(z>>>5 ^ y<<2) + (y>>>3 ^ z<<4) ^ (sum^y) + (k[p&3 ^ e] ^ z)
		
		
		if enc eq 1 
		add y,ecx
		else
		sub y,ecx
		endif
endm
;PuNkDuDe
XXTEAEncrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
LOCAL	_e:DWORD
	mov esi,pBlockIn
	mov eax,dword ptr[esi+0*4];y
	mov edx,dword ptr[esi+1*4];z
	xor ebx,ebx
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	.repeat
		add ebx,TEA_DELTA
		mov _e,ebx
		shr _e,2
		and _e,3
		
		XXTEAROUND eax,edx,_e,0,1
		XXTEAROUND edx,eax,_e,1,1

		add ebx,TEA_DELTA
		mov _e,ebx
		shr _e,2
		and _e,3
		
		XXTEAROUND eax,edx,_e,0,1
		XXTEAROUND edx,eax,_e,1,1
		
	.until ebx == TEA_DELTA*TEA_ROUNDS
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	mov esi,pBlockOut
	mov dword ptr[esi+0*4],eax
	mov dword ptr[esi+1*4],edx
	ret
XXTEAEncrypt endp

align dword
XXTEADecrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
LOCAL	_e:DWORD
mov esi,pBlockIn
	mov eax,dword ptr[esi+0*4]
	mov edx,dword ptr[esi+1*4]
	mov ebx,TEA_DELTA*TEA_ROUNDS
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	.repeat
		mov _e,ebx
		shr _e,2
		and _e,3
		XXTEAROUND edx,eax,_e,1,0
		XXTEAROUND eax,edx,_e,0,0
		sub ebx,TEA_DELTA
		mov _e,ebx
		shr _e,2
		and _e,3
		XXTEAROUND edx,eax,_e,1,0
		XXTEAROUND eax,edx,_e,0,0
		sub ebx,TEA_DELTA
	.until zero?
	.if bBswapInput
	bswap eax
	bswap edx
	.endif
	mov esi,pBlockOut
	mov dword ptr[esi+0*4],eax
	mov dword ptr[esi+1*4],edx
	ret
XXTEADecrypt endp

XXTEA_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
			
			INVOKE TEAInit,addr sKeyIn
			;INVOKE TEAInit,addr sKeyIn
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
			INVOKE XXTEAEncrypt,offset bf_encryptbuf,offset bf_tempbuf
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
XXTEA_ENC_RT endp
XXTEA_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		INVOKE TEAInit,addr sKeyIn
			
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,16
		xor	edx,edx
		div	ecx
		cmp	edx,0
		jne	@inputError
		invoke RtlZeroMemory,offset bf_decryptbuf,sizeof bf_decryptbuf-1
		mov	bPassedRound,0
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
			
		
			INVOKE XXTEADecrypt,offset bf_encryptbuf,offset bf_tempbuf
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
XXTEA_DEC_RT endp
