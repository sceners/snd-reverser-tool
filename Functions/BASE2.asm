.data

.code
;***************************************************************************************
;Start Char2Hex Handler functions
;***************************************************************************************
;***************************************************************************************
;Start Char2Hex Handler functions
;***************************************************************************************
BASE2_ENCODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit
	mov	eax,_len
	.if	_len > 0 
	
	mov esi,_Input
	mov ebx,_len
	mov edi,_Output
	xor eax,eax
	xor edx,edx
	stosb
	dec edi
	test ebx,ebx
	jz @F
	.repeat
		movzx eax,byte ptr [esi]
		inc esi
		.repeat
			mov cl,'0' shr 1
			add al,al
			adc cl,cl
			inc edx
			mov [edi],cl
			inc edi
		.until !(edx&7)
		dec ebx
	.until zero?
@@:	mov eax,edx	;length
	mov	ecx,8
	xor	edx,edx
	idiv	ecx
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgNull
	 	mov	eax,FALSE
	.endif
		ret
BASE2_ENCODE_RT	ENDP


BASE2_DECODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit
	mov	eax,_len
	mov	ecx,8
	xor	edx,edx
	idiv	ecx
	.if	_len > 1 && edx == 0
	
	xor eax,eax
	mov esi,_Input
	xor edx,edx
	mov edi,_Output
	xor ebx,ebx
	jmp @F
	.repeat
		add edx,edx
		inc esi
		and eax,1
		add ebx,1
		or edx,eax
		.if !(ebx&7)
			mov [edi],dl
			inc edi
		.endif
	@@:	movzx eax,byte ptr [esi]
	.until !eax
	mov eax,ebx
	mov	ecx,8
	xor	edx,edx
	idiv	ecx
	ret
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsg8Len
	 	mov	eax,FALSE
	.endif
		ret
BASE2_DECODE_RT	ENDP
