

.data
rotplusTitle		db 'ROT + : ',0
rotminusTitle		db 'ROT - : ',0

.code

;***************************************************************************************
;Start String XOR Handler functions
;***************************************************************************************

STRINGROT_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		
		.IF [_len]
			push _len
			push _Output
			push offset sKeyIn
			push _Input
			call STRINGROT
		.ENDIF

		mov eax, [_len]

	    ret
STRINGROT_RT endp




;***************************************************************************************
;Start String XOR functions
;***************************************************************************************


STRINGROT PROC _inputString:dword, _keyString:dword, _outputBuffer:dword, inputLength:dword

		mov edi, _keyString
		mov bl, byte ptr ds:[edi]
		cmp bl, 00h
		je @done

		mov edi, _outputBuffer
		invoke wsprintfA, edi, addr rotplusTitle
		add edi, [inputLength]
		add edi, 08h
		mov WORD PTR DS:[edi], 0a0dh
		add edi, 02h
		invoke wsprintfA, edi, addr rotminusTitle

		mov edi, _keyString
		mov esi, _inputString
		
		xor ecx, ecx
		xor edx, edx
		
	@rotLoop:
		movzx eax, byte ptr ds:[esi]
		cmp al, 00h
		je @done
	@@:
		movzx ebx, byte ptr ds:[edi+ecx]
		cmp bl, 00h
		jne @notYetEnd
		xor ecx, ecx
		jmp @B
	@notYetEnd:
		add eax, ebx
		mov edi, _outputBuffer 
		add edi, 08h
		mov byte ptr ds:[edi+edx], al
		sub eax, ebx
		sub eax, ebx
		add edi, [inputLength]
		add edi, 0Ah
		mov byte ptr ds:[edi+edx], al
		inc esi
		inc ecx
		inc edx
		mov edi, _keyString
		jmp @rotLoop
		
	@done:		
		ret	
STRINGROT ENDP
