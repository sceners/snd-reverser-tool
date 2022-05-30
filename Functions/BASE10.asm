.data

.code
;***************************************************************************************
;Start Char2Hex Handler functions
;***************************************************************************************
;***************************************************************************************
;Start Char2Hex Handler functions
;***************************************************************************************
BASE10_ENCODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit
	mov	eax,_len
	.if	_len > 0 
	
		push	_len
		push	_Output
		push	_Input
		call	CHR2DEC_RT
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgNull
	.endif
		ret
BASE10_ENCODE_RT	ENDP


BASE10_DECODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit
	mov	eax,_len
	DecLen
	.if	_len > 1 && edx == 0
	
		push	_len
		push	_Output
		push	_Input
		call	DEC2CHR_RT
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorDecLen
	.endif
		ret
BASE10_DECODE_RT	ENDP


CHR2DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
local	i:dword
	    mov	ebx,_len
	    .if	ebx > 0
	    mov	i,ebx
	    mov	esi,_Input
	    mov edi,_Output
	   @@:
		movzx	eax,byte ptr[esi] 
		;xor	ebx,ebx
		mov	ecx,10
		xor	edx,edx
		idiv	ecx
		;add	al,'0'
		;inc	ebx
		add	dl,'0'
		mov	byte ptr[edi+2],dl
		xor	edx,edx
		idiv	ecx
		
		add	dl,'0'
		mov	byte ptr[edi+1],dl
		
		add	al,'0'
		
		mov	byte ptr[edi],al
		
		add	edi,3
		inc	esi

	   	dec	i
	   	jne	@b
	     .endif
	     INVOKE lstrlen,_Output
	     DecLen
	     ret
CHR2DEC_RT endp

DEC2CHR_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	     mov	eax,_len
	     mov	ecx,3
	     xor	edx,edx
	     idiv	ecx
	     mov	ecx,eax	;length/3
		;must be multiple of 3
	     .if	edx == 0 && _len > 0
	     
			mov	esi,_Input
			mov	edi,_Output
			mov	ebx,eax	;length /3
		@@:
			movzx	eax,byte ptr[esi]
			sub	eax,'0'
			
			imul	eax,10
			mov	edx,eax
			
			movzx   eax,byte ptr[esi+1]
			sub	eax,'0'
			
			add	edx,eax
			imul	edx,10
			movzx   eax,byte ptr[esi+2]
			sub	eax,'0'
			add	edx,eax
			
			add	esi,3
			mov	byte ptr[edi],dl
			inc	edi
			dec	ebx
			jne	@b
			
			mov	eax,ecx	;new length
	     .else
	     	mov	byte ptr[edi],0
		mov	eax,-1
		jmp	@exit	
	
	     .endif
	     INVOKE lstrlen,_Output
		
@exit:	    
	     ret
DEC2CHR_RT endp
