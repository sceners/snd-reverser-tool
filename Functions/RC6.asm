
;; RC6.ASM -- Implementation of RC6 in MASM
;; (C)opyLeft 2005 by drizz                

;; P2 533MHz
;; -----------------------------------------
;; RC6Init:    1463 cycles
;; RC6Encrypt:  248 cycles
;; RC6Decrypt:  226 cycles
;; -----------------------------------------


RC6Init       PROTO :DWORD,:DWORD
RC6Encrypt    PROTO :DWORD,:DWORD
RC6Decrypt    PROTO :DWORD,:DWORD

.const
RC6ROUNDS equ 20
RC6KR equ ((RC6ROUNDS+2)*2)
RC6_P equ 0B7E15163h
RC6_Q equ 09E3779B9h

.data?
RC6_KEY dd RC6KR dup(?)

.code

; uses ecx
RC6SETUP macro A,B,kEy,_L
	add A,B
	add A,kEy
	rol A,3
	lea ecx,[A+B]
	mov kEy,A
	add B,A
	add B,_L
	rol B,cl
	mov _L,B
endm

RC6Init proc pKey:DWORD,dwKeyLen:DWORD
LOCAL RC6L[8]:dword
LOCAL SaveEsi,SaveEdi,SaveEbx
 	shr dwKeyLen,2
    mov SaveEsi,esi
    mov SaveEdi,edi
    mov SaveEbx,ebx
 	xor edx,edx
	mov eax,pKey
	.repeat
		mov ecx,[eax][edx*4][0*4]
		mov ebx,[eax][edx*4][1*4]
		mov RC6L[edx*4][0*4],ecx
		mov RC6L[edx*4][1*4],ebx
		add edx,2	
	.until edx >= dwKeyLen
    mov eax,RC6_P
    xor edx,edx
    mov edi,offset RC6_KEY
	mov ecx,RC6_P+RC6_Q
    .repeat
	    mov [edi][edx*4][0*4],eax
	    mov [edi][edx*4][1*4],ecx
		add edx,2
		lea eax,[ecx+RC6_Q]
		cmp edx,RC6KR
		lea ecx,[eax+RC6_Q]	
    .until zero?
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	xor edi,edi
	xor esi,esi
	.repeat
		RC6SETUP eax,ebx,RC6_KEY[edi*4][0*4],RC6L[esi*4][0*4]
		RC6SETUP eax,ebx,RC6_KEY[edi*4][1*4],RC6L[esi*4][1*4]
		add edx,2
		add edi,2
		add esi,2
		cmp edi,RC6KR
		sbb ecx,ecx
		and edi,ecx
		cmp esi,dwKeyLen
		sbb ecx,ecx
		and esi,ecx
	.until edx >= RC6KR*3
    mov eax,offset RC6_KEY
    mov esi,SaveEsi
    mov edi,SaveEdi
    mov ebx,SaveEbx
	ret
RC6Init endp
RC6_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 128)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen1128
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			INVOKE RC6Init ,addr sKeyIn,eax
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
		
			mov	esi,_Input
			mov	ebx,_len
			;part into multiples of 16
	EncryptLoop:
			push	esi	;source
			push	ebx	;len
			mov	eax,ebx	;length
			
			mov	ecx,16
			xor	edx,edx
			div	ecx
			.if	eax == 0
				mov	eax,edx
			.else
				mov	eax,16
			.endif
			push	eax
			push	esi
			Call Bit16Prepare

			.if bCipherMode == 1
				push	16
				push	offset bf_encryptbuf
				call	CipherXor
			.endif
			
			INVOKE RC6Encrypt,offset bf_encryptbuf,offset bf_tempbuf
			;convert output to hex string
			mov	eax,dword ptr[bf_tempbuf]
			mov	ebx,dword ptr[bf_tempbuf+4]
			mov	ecx,dword ptr[bf_tempbuf+4*2]
			mov	edx,dword ptr[bf_tempbuf+4*3]
			bswap	eax
			bswap	edx
			bswap	ecx
			bswap	ebx
			invoke wsprintf,addr bf_tempbufout,addr sFormat1,eax,ebx,ecx,edx
			invoke	lstrcat,_Output,addr bf_tempbufout
			
			pop	ebx
			pop	esi
			
			add	esi,16
			sub	ebx,16
			
			cmp	ebx,0
			jg	EncryptLoop
			INVOKE lstrlen,_Output
			HexLen
		.ENDIF
		ret
RC6_ENC_RT endp
RC6_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 128)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen1128
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		INVOKE RC6Init,addr sKeyIn,eax
		mov	bPassedRound,0
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,32
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
			push	16	;length
			push	esi
			call	Bit16Prepare
			
		
			INVOKE RC6Decrypt,offset bf_encryptbuf,offset bf_tempbuf
			DecryptEnd 16
			
		;	mov	eax,dword ptr[bf_tempbuf]
		;	mov	edx,dword ptr[bf_tempbuf+4]
			mov	eax,dword ptr[esi]
			mov	edx,dword ptr[esi+4]
			mov	dword ptr[edi+4*0],eax
			mov	dword ptr[edi+4*1],edx
			mov	eax,dword ptr[esi+8]
			mov	edx,dword ptr[esi+12]
		;	mov	eax,dword ptr[bf_tempbuf+4*2]
		;	mov	edx,dword ptr[bf_tempbuf+4*3]
			mov	dword ptr[edi+4*2],eax
			mov	dword ptr[edi+4*3],edx
			
			add	edi,16
			pop	esi
			add	esi,16
			sub	ebx,16
			
			cmp	ebx,0
			jg	DecryptLoop
			;now we need to clean it up :)
		INVOKE lstrlen,_Output
		mov	edi,_Output
		movzx	ebx,byte ptr[edi+eax-1];get last char
		.if	ebx < 16	;padding chars are 1-8
			sub	eax,ebx	;fix up length 
			mov	byte ptr[edi+eax],0	;clear it up :)
		.endif
		.elseif
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgHex
		mov	eax,FALSE
		.endif
		
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sError128b
		mov eax, FALSE		
	@endGenerate:
		.ENDIF
		ret
RC6_DEC_RT endp
OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

RC6ENCRND macro _I,_A,_B,_C,_D
	lea eax,[_B+_B+1]
	lea ecx,[_D+_D+1]
	imul eax,_B
	imul ecx,_D
	rol eax,5
	rol ecx,5
	xor _A,eax
	xor _C,ecx
	rol _A,cl
	mov cl,al
	rol _C,cl
	add _A,RC6_KEY[_I*4+0*4]
	add _C,RC6_KEY[_I*4+1*4]
endm

RC6Encrypt proc pPlainText:DWORD,pCipherText:DWORD
	push ebp
	push esi
	push edi
	push ebx
	mov eax,[esp][1*4][4*4];pPlainText
	mov esi,[eax][0*4]
	mov ebx,[eax][1*4]
	mov edi,[eax][2*4]
	mov ebp,[eax][3*4]
	add ebx,RC6_KEY[0*4]
	add ebp,RC6_KEY[1*4]
    RC6ENCRND 02,esi,ebx,edi,ebp
    RC6ENCRND 04,ebx,edi,ebp,esi
    RC6ENCRND 06,edi,ebp,esi,ebx
    RC6ENCRND 08,ebp,esi,ebx,edi
    RC6ENCRND 10,esi,ebx,edi,ebp
    RC6ENCRND 12,ebx,edi,ebp,esi
    RC6ENCRND 14,edi,ebp,esi,ebx
    RC6ENCRND 16,ebp,esi,ebx,edi
    RC6ENCRND 18,esi,ebx,edi,ebp
    RC6ENCRND 20,ebx,edi,ebp,esi
    RC6ENCRND 22,edi,ebp,esi,ebx
    RC6ENCRND 24,ebp,esi,ebx,edi
    RC6ENCRND 26,esi,ebx,edi,ebp
    RC6ENCRND 28,ebx,edi,ebp,esi
    RC6ENCRND 30,edi,ebp,esi,ebx
    RC6ENCRND 32,ebp,esi,ebx,edi
    RC6ENCRND 34,esi,ebx,edi,ebp
    RC6ENCRND 36,ebx,edi,ebp,esi
    RC6ENCRND 38,edi,ebp,esi,ebx
    RC6ENCRND 40,ebp,esi,ebx,edi
	mov eax,[esp][2*4][4*4];pCipherText
	add esi,RC6_KEY[42*4]
	add edi,RC6_KEY[43*4]
	mov [eax][0*4],esi
	mov [eax][1*4],ebx
	mov [eax][2*4],edi
	mov [eax][3*4],ebp
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret 2*4
RC6Encrypt endp

RC6DECRND macro  _I,_A,_B,_C,_D
	sub _C,RC6_KEY[_I*4+1*4]
	lea eax,[_D+_D+1]
	sub _A,RC6_KEY[_I*4+0*4]
	lea edx,[_B+_B+1]
	imul eax,_D
	imul edx,_B
	rol eax,5
	rol edx,5
	mov cl,dl
	ror _C,cl
	mov cl,al
	ror _A,cl
	xor _C,eax
	xor _A,edx
endm

RC6Decrypt proc pCipherText:DWORD,pPlainText:DWORD
	push ebp
	push esi
	push edi
	push ebx
	mov edx,[esp][1*4][4*4];pCipherText
	mov esi,[edx][0*4]
	mov ebx,[edx][1*4]
	mov edi,[edx][2*4]
	mov ebp,[edx][3*4]
	sub esi,RC6_KEY[42*4]
	sub edi,RC6_KEY[43*4]
	RC6DECRND 40,ebp,esi,ebx,edi
	RC6DECRND 38,edi,ebp,esi,ebx
	RC6DECRND 36,ebx,edi,ebp,esi
	RC6DECRND 34,esi,ebx,edi,ebp
	RC6DECRND 32,ebp,esi,ebx,edi
	RC6DECRND 30,edi,ebp,esi,ebx
	RC6DECRND 28,ebx,edi,ebp,esi
	RC6DECRND 26,esi,ebx,edi,ebp
	RC6DECRND 24,ebp,esi,ebx,edi
	RC6DECRND 22,edi,ebp,esi,ebx
	RC6DECRND 20,ebx,edi,ebp,esi
	RC6DECRND 18,esi,ebx,edi,ebp
	RC6DECRND 16,ebp,esi,ebx,edi
	RC6DECRND 14,edi,ebp,esi,ebx
	RC6DECRND 12,ebx,edi,ebp,esi
	RC6DECRND 10,esi,ebx,edi,ebp
	RC6DECRND 08,ebp,esi,ebx,edi
	RC6DECRND 06,edi,ebp,esi,ebx
	RC6DECRND 04,ebx,edi,ebp,esi
	RC6DECRND 02,esi,ebx,edi,ebp
	mov edx,[esp][2*4][4*4];pPlainText
	sub ebp,RC6_KEY[1*4]
	sub ebx,RC6_KEY[0*4]
	mov [edx][0*4],esi
	mov [edx][1*4],ebx
	mov [edx][2*4],edi
	mov [edx][3*4],ebp
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret 2*4
RC6Decrypt endp

OPTION PROLOGUE:PROLOGUEDEF
OPTION EPILOGUE:EPILOGUEDEF


