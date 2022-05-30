
.data
tempspace	dd	00h


.code

;***************************************************************************************
;Start String URLEncode Handler functions
;***************************************************************************************
URLENCODE_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword

		call DisableKeyEdit

		push _Output
		push _len
		push _Input
		call URLEncode

		invoke lstrlen,_Output

	    ret
URLENCODE_RT endp


;***************************************************************************************
;Start String URLDecode Handler functions
;***************************************************************************************
URLDECODE_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword

		call DisableKeyEdit

		push _Output
		push _len
		push _Input
		call URLDecode

		invoke lstrlen,_Output

	    ret
URLDECODE_RT endp


;***************************************************************************************
;Start Encode/decode functions
;***************************************************************************************
URLEncode proc _inputString:dword, stringlength:dword, _outputBuffer:dword
		mov esi, _inputString
		mov edi, _outputBuffer
	@encodeLoop:
		movsx ebx, byte ptr ds:[esi]
		cmp bl, 00h
		je @done

		.if (bl < 30h) || (bl > 30h && bl < 41h)
			mov byte ptr [edi], 25h
			inc edi
			invoke wsprintf, edi, addr hexFormatU, ebx
			add edi, 02h
		.else
			mov byte ptr [edi], bl
			inc edi
		.endif
		inc esi
		jmp @encodeLoop

	@done:
		ret	
URLEncode endp



URLDecode proc _inputString:dword, stringlength:dword, _outputBuffer:dword
		mov esi, _inputString
		mov edi, _outputBuffer
	@decodeLoop:
		movsx ebx, byte ptr ds:[esi]
		cmp bl, 00h
		je @done

		.if bl == 25h
			inc esi
			mov bx, word ptr ds:[esi]
			mov dword ptr [tempspace], ebx
			push edi
			invoke BASE16_DECODE_RT, addr tempspace, edi, 2h
			pop edi
			add esi, 02h
		.else
			mov byte ptr [edi], bl
			inc esi
		.endif
		inc edi
		jmp @decodeLoop

	@done:
		ret	
URLDecode endp
