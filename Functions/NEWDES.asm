comment			*

Algorithm			: Newdes
Block			: 8bytes
KeySize			: SIZE_USER_KEY	( default = 15 bytes )

Usage			: 
			  ( Encrypt )
			  
			  invoke	newdes_encryptsetkey,addr ptrInkey ( default ptrInkey_length = 15 bytes )
			  invoke	newdes_crypt,addr ptrIndata,addr ptrOutdata ( 8 bytes Encrypt )
			  
			  ( Decrypt )
			  
			  invoke	newdes_decryptsetkey,addr ptrInkey ( default ptrInkey_length = 15 bytes )
			  invoke	newdes_crypt,addr ptrIndata,addr ptrOutdata ( 8 bytes Decrypt )
			  
Coded by x3chun		( 2004.06.24 )
			( x3chun@korea.com  or  x3chun@hanyang.ac.kr ) ( http://x3chun.ce.ro )
			
comment			*
			  
_crypt			macro	a,b

			mov	al,[esi+b]	; esi = ptrIndata
			xor	al,[edi+ecx]
			xlat
			xor	[esi+a],al
			inc	ecx
			
endm

newdes_encryptsetkey	proto	:DWORD
newdes_decryptsetkey	proto	:DWORD
newdes_crypt		proto	:DWORD, :DWORD

.const

SIZE_ROTOR		equ	256
SIZE_KEY_UNRAV		equ	60
SIZE_USER_KEY		equ	15		; setkey length
BLOCK_BYTES		equ	8

.data

newdes_rotor		db	    32,137,239,188,102,125,221, 72,212, 68, 81, 37, 86,237,147,149
			db	    70,229, 17,124,115,207, 33, 20,122,143, 25,215, 51,183,138,142
			db	   146,211,110,173,  1,228,189, 14,103, 78,162, 36,253,167,116,255
			db	   158, 45,185, 50, 98,168,250,235, 54,141,195,247,240, 63,148,  2
			db	   224,169,214,180, 62, 22,117,108, 19,172,161,159,160, 47, 43,171
			db	   194,175,178, 56,196,112, 23,220, 89, 21,164,130,157,  8, 85,251
			db	   216, 44, 94,179,226, 38, 90,119, 40,202, 34,206, 35, 69,231,246
			db	    29,109, 74, 71,176,  6, 60,145, 65, 13, 77,151, 12,127, 95,199
			db	    57,101,  5,232,150,210,129, 24,181, 10,121,187, 48,193,139,252
			db	   219, 64, 88,233, 96,128, 80, 53,191,144,218, 11,106,132,155,104
			db	    91,136, 31, 42,243, 66,126,135, 30, 26, 87,186,182,154,242,123
			db	    82,166,208, 39,152,190,113,205,114,105,225, 84, 73,163, 99,111
			db	   204, 61,200,217,170, 15,198, 28,192,254,134,234,222,  7,236,248
			db	   201, 41,177,156, 92,131, 67,249,245,184,203,  9,241,  0, 27, 46
			db	   133,174, 75, 18, 93,209,100,120, 76,213, 16, 83,  4,107,140, 52
			db	    58, 55,  3,244, 97,197,238,227,118, 49, 79,230,223,165,153, 59
			
.data?

newdes_key_unravelled	db	SIZE_KEY_UNRAV	dup(?)

.code
DESNEW_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			INVOKE newdes_encryptsetkey,addr sKeyIn
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
			INVOKE newdes_crypt,offset bf_encryptbuf,offset bf_tempbuf
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
DESNEW_ENC_RT endp
DESNEW_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		INVOKE newdes_decryptsetkey,addr sKeyIn
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
			
		
			INVOKE newdes_crypt,offset bf_encryptbuf,offset bf_tempbuf
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
DESNEW_DEC_RT endp
newdes_encryptsetkey	proc	ptrInkey:DWORD

			pushad
			mov	esi,[esp+28h]	; ptrInkey
			mov	edx,esi
			mov	edi,offset newdes_key_unravelled
			mov	ebp,(SIZE_KEY_UNRAV/SIZE_USER_KEY)
@_r1:
			mov	ecx,SIZE_USER_KEY
			cld
			rep	movsb
			mov	esi,edx
			dec	ebp
			jnz	@_r1
			popad
			ret
			
newdes_encryptsetkey	endp

newdes_decryptsetkey	proc	ptrInkey:DWORD

			pushad
			mov	esi,[esp+28h]	; ptrInkey
			mov	edi,offset newdes_key_unravelled
			xor	ebx,ebx
			mov	ecx,11		; ecx = userkeyidx
@_r5:
			xor	edx,edx
			mov	al,[esi+ecx]
			mov	[edi+ebx],al
			inc	ecx
			inc	ebx
			cmp	ecx,SIZE_USER_KEY
			jnz	@_r1
			xor	ecx,ecx
@_r1:
			mov	al,[esi+ecx]
			mov	[edi+ebx],al
			inc	ecx
			inc	ebx
			cmp	ecx,SIZE_USER_KEY
			jnz	@_r2
			xor	ecx,ecx
@_r2:
			mov	al,[esi+ecx]
			mov	[edi+ebx],al
			inc	ecx
			inc	ebx
			cmp	ecx,SIZE_USER_KEY
			jnz	@_r3
			xor	ecx,ecx
@_r3:
			mov	al,[esi+ecx]
			mov	[edi+ebx],al
			inc	ebx
			lea	eax,[ecx+9]
			mov	ebp,15
			div	ebp
			mov	ecx,edx
			cmp	ecx,12
			jz	@_r4
			mov	al,[esi+ecx]
			mov	[edi+ebx],al
			inc	ecx
			inc	ebx
			mov	al,[esi+ecx]
			mov	[edi+ebx],al
			inc	ecx
			inc	ebx
			mov	al,[esi+ecx]
			mov	[edi+ebx],al
			inc	ebx
			lea	eax,[ecx+9]
			xor	edx,edx
			mov	ebp,15
			div	ebp
			mov	ecx,edx
			jmp	@_r5
@_r4:	
			popad
			ret
			
newdes_decryptsetkey	endp

newdes_crypt		proc	ptrIndata:DWORD, ptrOutdata:DWORD

			pushad
			mov	esi,[esp+28h]	; ptrIndata
			mov	edi,[esp+2ch]	; ptrOutdata
			mov	edx,edi
			mov	ecx,8
			cld
			rep	movsb
			xor	ecx,ecx
			mov	esi,edx
			mov	edi,offset newdes_key_unravelled
			mov	ebx,offset newdes_rotor
			mov	ebp,8		; count
@_r1:
			_crypt	4,0
			_crypt	5,1
			_crypt	6,2
			_crypt	7,3
			_crypt	1,4
			mov	al,[esi+4]
			xor	al,[esi+5]
			xlat
			xor	[esi+2],al
			_crypt	3,6
			_crypt	0,7
			dec	ebp
			jnz	@_r1
			_crypt	4,0
			_crypt	5,1
			_crypt	6,2
			_crypt	7,3
			popad
			ret
			
newdes_crypt		endp