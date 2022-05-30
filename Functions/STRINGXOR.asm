

.code

;***************************************************************************************
;Start String XOR Handler functions
;***************************************************************************************

STRINGXOR_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit

		push _Output
		push offset sKeyIn
		push _Input
		call STRINGXOR

		INVOKE lstrlen,_Output

	    ret
STRINGXOR_RT endp




;***************************************************************************************
;Start String XOR functions
;***************************************************************************************


STRINGXOR PROC _inputString:dword, _keyString:dword, _outputBuffer:dword
		pushad
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov esi, _inputString
		mov edi, _keyString
		mov bl, byte ptr ds:[edi]
		cmp bl, 00h
		je @done
		
	@xorLoop:
		mov al, byte ptr ds:[esi]
		cmp al, 00h
		je @done
	@@:
		mov bl, byte ptr ds:[edi+ecx]
		cmp bl, 00h
		jne @notYetEnd
		xor ecx, ecx
		jmp @B
	@notYetEnd:
		xor al, bl
		mov edi, _outputBuffer
		mov byte ptr ds:[edi+edx], al
		inc esi
		inc ecx
		inc edx
		mov edi, _keyString
		jmp @xorLoop
		
	@done:		
		popad
		ret	
STRINGXOR ENDP
