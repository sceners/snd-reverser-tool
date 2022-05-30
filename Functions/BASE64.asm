
.data
base64table		db 66 dup(0)
strCHARS		db 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=',0
			dd 10 dup(0)
			;	dd 255 dup(0)



.code


;***************************************************************************************
;Start BASE64 Handler functions
;***************************************************************************************

BASE64_ENCODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		Call EnableKeyEdit
		invoke lstrlen,addr sKeyIn
		.if	eax == 0
			INVOKE SetDlgItemText, hWindow, IDC_KEY, addr strCHARS
			INVOKE lstrcpy,addr base64table,addr strCHARS
			
		.elseif eax != sizeof base64table-1
			invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorKey64Chr
			mov eax, FALSE
		.else
		INVOKE lstrcpy,addr base64table,addr sKeyIn
		;call DisableKeyEdit
		mov	ecx,[_len]
		cmp ecx, 0
		je @inputError
		push	_Output
		push	_len
		push	_Input
		call BASE64_ENCODE
		
		.endif
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgNull
		mov eax, FALSE		
	@endGenerate:
		ret
BASE64_ENCODE_RT endp



BASE64_DECODE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		Call EnableKeyEdit
		invoke lstrlen,addr sKeyIn
		.if	eax == 0
			INVOKE SetDlgItemText, hWindow, IDC_KEY, addr strCHARS
			INVOKE lstrcpy,addr base64table,addr strCHARS
			
		.elseif eax != sizeof base64table-1
			invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorKey64Chr
			mov eax, FALSE
		.else
		INVOKE lstrcpy,addr base64table,addr sKeyIn
		
		;call DisableKeyEdit
		mov	ecx,[_len]
		cmp ecx, 2
		jl @inputError
		
		push	_Output
		push	_len
		push	_Input
		call BASE64_DECODE
			
		INVOKE lstrlen,_Output
		.endif
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgNull
		mov eax, FALSE		
	@endGenerate:
		ret
BASE64_DECODE_RT endp
.data
_quicktable64		db 256 dup(0)

.code
BASE64_ENCODE	PROC	uses edx esi edi ecx strInput:LPSTR,strInLen:DWORD,strOutput:LPSTR
			mov	edi,strOutput
			mov	esi,strInput
			mov	ecx,3
			mov	eax,strInLen
			xor	edx,edx
			xor	ebx,ebx			;length
			idiv	ecx
			test	eax,eax
			je	_do_padding
		.WHILE	EAX > 0
			movzx	edx,byte ptr[esi]	;current char
			mov	ecx,edx
			shr	edx,2
			movzx	edx,byte ptr[base64table+edx]
			mov	byte ptr[edi],dl
			movzx	edx,byte ptr[esi+1]
			and	ecx,3
			shl	ecx,4
			shr	edx,4
			add	ecx,edx
			movzx	ecx,byte ptr[base64table+ecx]
			mov	byte ptr[edi+1],cl
			movzx	edx,byte ptr[esi+1]
			and	edx, 15							
			shl	edx, 2							
			xor	ecx, ecx						
			movzx	ecx,byte ptr[esi+2]					
			shr	ecx, 6							
			add	edx, ecx						
			movzx	edx,byte ptr[base64table+edx]
			mov	byte ptr[edi+2],dl	
			movzx	edx,byte ptr[esi+2]					
			and	edx, 63	;length of char table							
			movzx	edx,byte ptr[base64table+edx]
			mov	byte ptr[edi+3],dl
			add	ebx,4
			dec	eax
			add	edi,4
			add	esi,3
		.ENDW
		_do_padding:
			mov	eax,strInLen
			xor	edx,edx
			mov	ecx,3
			idiv	ecx
			.IF	edx == 1
				movzx	eax, byte ptr[esi]							
				shr	eax, 2								
				movzx	eax,byte ptr[base64table+eax]
				mov	byte ptr[edi], al	
				movzx	eax, byte ptr[esi]	
				and	eax, 3
				shl	eax, 4								
				movzx	eax,byte ptr[base64table+eax]
				mov	byte ptr[edi+1], al	
				mov	byte ptr [edi+2], '='		
				mov	byte ptr [edi+3], '=' 
				add	ebx,4
			.ELSEIF	edx == 2
				movzx	eax, byte ptr[esi]							
				shr	eax, 2								
				movzx	eax,byte ptr[base64table+eax]
				mov	byte ptr[edi], al	

				movzx	eax, byte ptr[esi]	
				and	eax, 3
				shl	eax, 4								

				movzx	edx,byte ptr[esi+1]
				shr	edx, 4
				add	eax,edx
				movzx	eax,byte ptr[base64table+eax]
				mov	byte ptr[edi+1], al	

				movzx	eax,byte ptr[esi+1]
				and	eax,15
				shl	eax,2
				movzx	eax,byte ptr[base64table+eax]
				mov	byte ptr[edi+2], al	
				mov	byte ptr[edi+3], '='
				add	ebx,4
			.ENDIF

			mov	eax,ebx
			
			ret
BASE64_ENCODE		ENDP
;///////////////////////////////////////////
;/// Base 64 Make Table for fast decoding :)
;///////////////////////////////////////////
MakeDecodeTable64	proc uses ecx edx ebx
			mov edx,sizeof base64table
			xor	eax,eax
		@@:
			xor ecx,ecx
			mov cl,byte ptr [base64table+eax]
			mov byte ptr [ecx+_quicktable64],al
			inc eax
			dec edx
			JNZ @b

			xor	eax,eax
			ret
MakeDecodeTable64		endp
BASE64_DECODE	PROC	uses edx esi edi ecx strInput:LPSTR,strInLen:DWORD,strOutput:LPSTR
			call	MakeDecodeTable64
			
			mov	edi,strOutput
			mov	esi,strInput
			mov	eax,strInLen
			xor	ebx,ebx

		.WHILE	ebx < strInLen

			movzx	edx,byte ptr[esi]
			movzx	edx,byte ptr[_quicktable64+edx]
			.IF 	edx !=64
			shl	edx,2
			movzx	ecx,byte ptr[esi+1]
			movzx	ecx,byte ptr[_quicktable64+ecx]
			.IF	ecx !=64
			shr	ecx,4
			and	ecx,3
			or	ecx,edx
			mov	byte ptr[edi],cl
			.ENDIF
			.ENDIF
			movzx	ecx,byte ptr[esi+1]
			movzx	ecx,byte ptr[_quicktable64+ecx]
			.IF 	ecx !=64
			and	ecx,15
			shl	ecx,4
			movzx	edx,byte ptr[esi+2]
			movzx	edx,byte ptr[_quicktable64+edx]
			.IF 	edx !=64
			shr	edx,2
			and	edx,15
			or	edx,ecx
			mov	byte ptr[edi+1],dl
			.ENDIF
			.ENDIF
			movzx	ecx,byte ptr[esi+2]
			movzx	ecx,byte ptr[_quicktable64+ecx]
			.IF 	ecx !=64
			and	ecx,3
			shl	ecx,6
			
			movzx	edx,byte ptr[esi+3]
			movzx	edx,byte ptr[_quicktable64+edx]
			.IF 	edx !=64
			or	edx,ecx
			mov	byte ptr[edi+2],dl
			.ENDIF
			.ENDIF
			add	edi,3
			add	ebx,4
			add	esi,4
			
		.ENDW
			
			mov	edi,strOutput
			xor	eax,eax
			mov	ecx,-1
			repne	cmpsb
			not	ecx
			dec	ecx
			mov	eax,ecx
			
			ret
BASE64_DECODE		ENDP


