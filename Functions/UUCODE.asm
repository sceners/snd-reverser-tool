

.code
UUE_ENCODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit
	mov	eax,_len
	.if	_len > 0 
		push	_Output
		push	_len
		
		push	_Input
		call	UUEncode
		invoke lstrlen,_Output
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO, SADD("Please provide some input for this function.")
	 	mov	eax,FALSE
	.endif
		ret
UUE_ENCODE_RT	ENDP


UUE_DECODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
	call DisableKeyEdit

	mov	esi,_Input
	.if	(byte ptr [esi]>33 || byte ptr [esi]<97) && (_len > 01h)
	
		push	_Output
		push	_len
		push	_Input
		call	UUDecode
		invoke lstrlen,_Output
	 .else
	 	invoke SetDlgItemText, hWindow, IDC_INFO, SADD("Input in invalid, provide correct input for this function.")
	 	mov	eax,FALSE
	.endif
		ret
UUE_DECODE_RT	ENDP

UUEncode		proc	ptrIndata:DWORD, ptrIndata_length:DWORD, ptrOutdata:DWORD
	
		pushad
		xor	ebx,ebx		
		mov	esi,[esp+28h]	; ptrIndata
		mov	edi,[esp+30h]	; ptrOutdata
		mov	eax,[esp+2ch]	; ptrIndata_length
		cmp	eax,0
		jz	@_err
		add	eax,20h
		mov	[edi],al
		sub	al,20h
		mov	ebp,eax
		mov	ecx,3
		cdq
		idiv	ecx
		test	edx,edx
		jz	@_OK
		sub	ecx,edx
		lea	edi,[esi+ebp]
		lea	esi,[esi+ebp]
		sub	esi,ecx
		.if	ecx==1
		sub	esi,2
		.elseif
		dec	esi
		.endif
		rep	movsb
@_OK:
		mov	esi,[esp+28h]	; ptrIndata
		mov	edi,[esp+30h]	; ptrOutdata
		mov	eax,ebp	
		add	eax,2
		mov	ecx,3
		cdq
		idiv	ecx
		mov	ecx,eax
		xor	ebp,ebp
@_loop:		
		mov	al,[esi+ebx]
		mov	ah,al
		and	al,0FCh
		shr	al,2
		add	al,32
		cmp	al,32
		jnz	@_r1
		mov	byte ptr [edi+ebp+1],96
@_r1:
		mov	[edi+ebp+1],al
		and	ah,03h
		shl	ah,4
		mov	al,[esi+ebx+1]
		mov	dl,al
		and	al,0F0h
		shr	al,4
		or	al,ah
		add	al,32
		cmp	al,32
		jnz	@_r2
		mov	byte ptr [edi+ebp+2],96
@_r2:
		mov	[edi+ebp+2],al
		and	dl,0Fh
		shl	dl,2
		mov	dh,[esi+ebx+2]
		mov	al,dh
		and	dh,0C0h
		shr	dh,6
		or	dl,dh
		add	dl,32
		cmp	dl,32
		jnz	@_r3
		mov	byte ptr [edi+ebp+3],96
@_r3:
		mov	[edi+ebp+3],dl
		and	al,3Fh
		add	al,32
		cmp	al,32
		jnz	@_r4
		mov	byte ptr [edi+ebp+4],96
@_r4:
		mov	[edi+ebp+4],al
		add	ebx,3
		add	ebp,4
		dec	ecx
		jnz	@_loop	
@_err:
		popad
		ret
		
UUEncode		endp

UUDecode	proc	ptrIndata:DWORD, ptrIndata_length:DWORD, ptrOutdata:DWORD

		pushad
		xor	ebx,ebx
		xor	ebp,ebp
		mov	esi,[esp+28h]	; ptrIndata
		mov	edi,[esp+30h]	; ptrOutdata
		mov	ecx,[esp+2ch]	; ptrIndata_length
		cmp	ecx,0
		jz	@_err
		add	ecx,2
		sar	ecx,2
@_loop:	
		cmp	byte ptr [esi+ebp+1],96
		jnz	@_r1
		mov	byte ptr [esi+ebp+1],0
		jmp	@_next
@_r1:
		sub	byte ptr [esi+ebp+1],32
@_next:
		cmp	byte ptr [esi+ebp+2],96
		jnz	@_r2
		mov	byte ptr [esi+ebp+2],0
		jmp	@_next1
@_r2:
		sub	byte ptr [esi+ebp+2],32
@_next1:
		cmp	byte ptr [esi+ebp+3],96
		jnz	@_r3
		mov	byte ptr [esi+ebp+3],0
		jmp	@_next2
@_r3:
		sub	byte ptr [esi+ebp+3],32
@_next2:
		cmp	byte ptr [esi+ebp+4],96
		jnz	@_r4
		mov	byte ptr [esi+ebp+4],0
		jmp	@_next3
@_r4:
		sub	byte ptr [esi+ebp+4],32
@_next3:
		mov	al,[esi+ebp+1]
		mov	ah,[esi+ebp+2]
		mov	dl,ah
		shl	al,2
		shr	ah,4
		and	ah,03h
		or	al,ah
		mov	[edi+ebx],al
		mov	dh,[esi+ebp+3]
		mov	al,dh
		shr	dh,2
		and	dh,0Fh
		shl	dl,4
		or	dl,dh
		mov	[edi+ebx+1],dl
		mov	ah,[esi+ebp+4]
		and	ah,3Fh
		shl	al,6
		or	al,ah
		mov	[edi+ebx+2],al
		add	ebp,4
		add	ebx,3
		dec	ecx
		jnz	@_loop
		mov	cl,[esi]
		sub	cl,20h
		mov	byte ptr [edi+ecx],0
@_err:
		popad
		ret
		
UUDecode	endp


