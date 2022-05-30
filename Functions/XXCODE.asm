
.data
xxChars	db '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',0

.code
XXE_ENCODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit
	mov	eax,_len
	.if	_len > 0 
		push	_Output
		push	_len
		
		push	_Input
		call	XXEncode
		invoke lstrlen,_Output
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO, SADD("Please provide some input for this function.")
	 	mov	eax,FALSE
	.endif
		ret
XXE_ENCODE_RT	ENDP


XXE_DECODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit

	mov	esi,_Input
	.if	byte ptr [esi]>33 || byte ptr [esi]<97
	
		push	_Output
		push	_len
		push	_Input
		call	XXDecode
		invoke lstrlen,_Output
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO, SADD("Input in invalid, provide correct input for this function.")
	 	mov	eax,FALSE
	.endif
		ret
XXE_DECODE_RT	ENDP

XXEncode	proc	ptrIndata:DWORD, ptrInLen:DWORD, ptrOutdata:DWORD
		
		;c1 = p >> 2;	
		;c2 = ((p&3 )<< 4)  | (p[1] >> 4) 	
		;c3 = ((p[1] & 15 )<< 2)| (p[2] >> 6)	
		;c4 = p[2] & 063;
		
		mov	esi,ptrIndata
		mov	edi,ptrOutdata
		xor	ebx,ebx
	@Calculation:
		;c1 =  (p) >> 2
		movzx	eax,byte ptr[esi]
		shr	eax,2
		movzx	eax,byte ptr[xxChars+eax]
		mov	byte ptr[edi],al
		;c2 = ((p & 3) << 4)+ (p[1] >> 4)
		movzx	eax,byte ptr[esi]
		and	eax,3
		shl	eax,4
		movzx	ecx,byte ptr[esi+1]
		shr	ecx,4
		add	eax,ecx
		movzx	eax,byte ptr[xxChars+eax]
		mov	byte ptr[edi+1],al
		;c3 = ((p[1]&15)<<2)+(p[2] >> 6)
		movzx	eax,byte ptr[esi+1]
		and	eax,15
		shl	eax,2
		
		movzx	ecx,byte ptr[esi+2]
		shr	ecx,6
		add	eax,ecx
		
		movzx	eax,byte ptr[xxChars+eax]
		mov	byte ptr[edi+2],al
		;c4 = p[2] & 63
		movzx	eax,byte ptr[esi+2]
		and	eax,63
		movzx	eax,byte ptr[xxChars+eax]
		mov	byte ptr[edi+3],al
		
		add	edi,4
		add	esi,3
		
		add	ebx,3
		cmp	ebx,ptrInLen
		jl	@Calculation
		ret
		
XXEncode		endp

XXDecode	proc	ptrIndata:DWORD, ptrInLen:DWORD, ptrOutdata:DWORD
	
	
	
	;	if (n >= 1)		putc(c1, f)
	;	if (n >= 2)		putc(c2, f)
	;	if (n >= 3)		putc(c3, f);

	;I5JCOoFpF4I+
	
		mov	esi,ptrIndata
		mov	edi,ptrOutdata
		xor	ebx,ebx
	@Calculation:
		;c1 = DEC(*p) << 2 | DEC(p[1]) >> 4
		movzx	eax,byte ptr[esi]
		Call 	FindChar
		mov	ecx,eax
		shl	ecx,2
		movzx	eax,byte ptr[esi+1]
		Call 	FindChar
		push	eax
		shr	eax,4
		add	ecx,eax
		mov	byte ptr[edi],cl
		;c2 = DEC(p[1]) << 4 | DEC(p[2]) >> 2
		pop	ecx
		shl	ecx,4
		movzx	eax,byte ptr[esi+2]
		Call 	FindChar
		push	eax
		shr	eax,2
		add	ecx,eax
		mov	byte ptr[edi+1],cl
		;c3 = DEC(p[2]) << 6 | DEC(p[3])
		pop	ecx
		shl	ecx,6
		movzx	eax,byte ptr[esi+3]
		Call 	FindChar
		add	ecx,eax
		mov	byte ptr[edi+2],cl

		
		add	edi,3
		add	esi,4
		
		add	ebx,4
		cmp	ebx,ptrInLen
		jl	@Calculation
		ret
		
XXDecode	endp
FindChar	proc uses ecx edi
	
	
	mov	edi,offset xxChars
	mov	ecx,sizeof xxChars-1
	repne scasb
	mov	eax,sizeof xxChars-1
	sub	eax,ecx
	dec	eax
	ret
FindChar	endp