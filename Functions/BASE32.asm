;//////////////////////////////////////////
;Base32 - PuNkDuDe 2007
;/////////////////////////////////////////

.data
;///////////////////////////////////////////
;/// Base 32 definitions
;///////////////////////////////////////////
;ADDR sKeyIn, SIZEOF sKeyIn
Base32Chars	db 33 dup(0)
Base32CharsStd 	db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567',0 ;char table 
_quick			dw 0, 1, 3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047, 4095, 8191, 16383, 32767, 65535
;// Resulted number of chars must be integral multiple of
;// 40 input bits div 5 output group bits
.code

;***************************************************************************************
;Start BASE32 Handler functions
;***************************************************************************************

BASE32_ENCODE_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		Call EnableKeyEdit
		invoke lstrlen,addr sKeyIn
		.if	eax == 0
			INVOKE SetDlgItemText, hWindow, IDC_KEY, addr Base32CharsStd
			INVOKE lstrcpy,addr Base32Chars,addr Base32CharsStd
			
		.elseif eax != sizeof Base32CharsStd-1
			invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorKey32Chr
			mov eax, FALSE
		.else
		;call DisableKeyEdit
		mov eax, [_len]
		cmp eax, 0
		je @inputError
		INVOKE lstrcpy,addr Base32Chars,addr sKeyIn
		
		push 0
		push _Output
		push _len
		push _Input
		call BASE32_ENCODE
		INVOKE lstrlen,_Output
		.endif
		;mov eax, TRUE
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgNull
		mov eax, FALSE		
	@endGenerate:
		ret
BASE32_ENCODE_RT endp



BASE32_DECODE_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword
		Call EnableKeyEdit
		invoke lstrlen,addr sKeyIn
		.if	eax == 0
			INVOKE SetDlgItemText, hWindow, IDC_KEY, addr Base32CharsStd
			INVOKE lstrcpy,addr Base32Chars,addr Base32CharsStd
			
		.elseif eax != sizeof Base32CharsStd-1
			invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorKey32Chr
			mov eax, FALSE
		.else
		INVOKE lstrcpy,addr Base32Chars,addr sKeyIn
		
		;call DisableKeyEdit
		mov eax, [_len]
		cmp eax, 2
		jl @inputError

		push 0
		push _Output
		push _len
		push _Input
		call BASE32_DECODE
		INVOKE lstrlen,_Output
		.endif
		;mov eax, TRUE
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgNull
		mov eax, FALSE		
	@endGenerate:
		ret
BASE32_DECODE_RT endp




;///////////////////////////////////////////
;/// Base 32 Encode Proc
;///////////////////////////////////////////
BASE32_ENCODE	proc uses ebx edi esi pIn:dword, InLen:dword, pOut:dword, padding:byte
local	_bits:dword
local	i	:dword
		mov	edi,pOut
		mov	esi,pIn
		xor	ebx,ebx
		mov	_bits,5	
		mov	eax,InLen
		mov	i,eax
		xor	eax,eax
			
		.while i != 0
			shl	ebx,8
			movzx	ecx,byte ptr[esi]
			or	ebx,ecx
			add	eax,8
		
			.if	eax > 5
				.while _bits <= eax
					sub	eax,_bits
					mov	ecx,eax
					mov	edx,ebx
					shr	edx,cl
					movzx	ecx,byte ptr[edx+Base32Chars]
					mov	byte ptr[edi],cl
					inc	edi
					
					movzx	ecx,word ptr[eax*2+_quick]
					and	ebx,ecx
				.endw	
			.endif
			inc	esi
			dec	i
		.endw
			.if	eax != 0
				mov	ecx,5	
				sub	ecx,eax
				shl	ebx,cl
				movzx	edx,byte ptr[ebx+Base32Chars]
				mov	byte ptr[edi],dl
				inc	edi
				
			.endif
			.if	padding == TRUE ; ===?
				mov	eax,edi
				sub	eax,pOut
				mov	ecx,8
				cdq
				idiv	ecx
				
				sub	ecx,edx
				.if	ecx > 0
					xor	edx,edx
					mov	dl,'='
					mov	dh,dl
					mov	eax,edx
					shl	eax,16
					mov	ax,dx
					mov	edx,ecx
					sar	ecx,2
					js	@f
					rep	stosd
					mov	ecx,edx
					and	ecx,3
					rep	stosb
				@@:
				.endif
			.endif
			xor	eax,eax
			ret
BASE32_ENCODE		endp



.data
;///////////////////////////////////////////
;/// Base 32 Decode Proc
;///////////////////////////////////////////
_quicktable		db 256 dup(0)


.code
BASE32_DECODE	proc uses ebx edi esi pIn:dword,InLen:dword,pOut:dword,padding:byte
local	_bits:dword
local	i	:dword, declen:dword,magic:dword,count:dword,outnum:dword

			call	MakeDecodeTable
			
			mov	edi,pOut
			mov	esi,pIn
			xor	ebx,ebx
			mov	magic,ebx
			mov	_bits,5	
			xor	eax,eax
			
			
			mov	count,0
			mov	outnum,0
		@@:	
			movzx	ecx,byte ptr[esi]
			and	ecx,255
			mov	edx,ecx
			movzx	ecx, byte ptr[edx+_quicktable]
		.if	ecx > 0
			mov	ecx,_bits
			shl	eax,cl
			movzx	ecx,byte ptr[edx+_quicktable]
			dec	ecx
			or 	eax,ecx
			add	count,5
			.while count >= 8
				sub	count,8
				mov	ecx,count
				mov	edx,eax
				shr	edx,cl
				
				mov	byte ptr[edi],dl
				inc	edi
				
			.endw
			inc	esi
			jmp	@dec_count
		.elseif ecx == 13
			inc	esi
		.elseif ecx == 10
			inc	esi
		.else
			jmp	@end
		.endif
		@dec_count:
			dec	InLen
			jne	@b
			
		@end:	
				
			xor	eax,eax
			ret
BASE32_DECODE		endp


;///////////////////////////////////////////
;/// Base 32 Make Table for fast decoding :)
;///////////////////////////////////////////
MakeDecodeTable	proc uses ecx edx ebx
			mov edx,sizeof Base32Chars
			mov eax,1
		@@:
			xor ecx,ecx
			mov cl,byte ptr [Base32Chars+eax-1]
			mov byte ptr [ecx+_quicktable],al
			inc eax
			dec edx
			JNZ @b

			xor	eax,eax
			ret
MakeDecodeTable		endp

