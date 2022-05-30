
.data
caesarSpacer		db 'ROT-%d : ', 0
caesarLengthError	db 'Error - Due to output size, input should be between 1 and 29 chars. ', 0dh, 0ah
					db 'Use this tool to find the ROT value (if unknown), then use the ROT tool '
					db 'with your larger input.', 0

.code

;***************************************************************************************
;Start CAESAR BRUTE FORCE Handler functions
;***************************************************************************************

CAESAR_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword

		call DisableKeyEdit
		cmp [_len], 0
		je @invalid_size_input
		cmp [_len], 29
		jg @invalid_size_input

		push _Output
		push _len
		push _Input
		call CAESAR
		mov eax, [_len]
		add eax, 08h
		mov ebx, 25
		mul bl
		ret

	@invalid_size_input:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr caesarLengthError
		mov eax, -1
	    ret
CAESAR_RT endp


;***************************************************************************************
;Start CAESAR functions
;***************************************************************************************

CAESAR proc _inputString:dword, _inputLength:dword, _outputBuffer:dword
		mov esi, _inputString
		mov edi, _outputBuffer
		mov ecx, _inputLength		
		mov edx, 01h	

	@caesarLoop:
		push ecx
		push edx		
		invoke wsprintfA, edi, addr caesarSpacer, edx
		pop edx
		pop ecx
		add edi, 08h
	
	@cStringLoop:	
		movzx ebx, byte ptr ds:[esi]
		cmp bl, 00h
		je @done
		cmp bl, 7ah
		jg @process_next_char
		cmp bl, 60h
		jg @valid_caesar_char
		cmp bl, 5ah
		jg @process_next_char
		cmp bl, 40h
		jg @valid_caesar_char
		jmp @process_next_char

	@valid_caesar_char:
		add bl, dl
		.if ((ebx > 7ah) || ((ebx > 5ah) && (byte ptr ds:[esi] < 61h)))
			sub bl, 1ah
		.endif
	@process_next_char:
		mov byte ptr [edi], bl
		inc edi
		inc esi
		loop @cStringLoop

	@done:
		mov esi, _inputString
		mov word ptr [edi], 0a0dh
		add edi, 02h
		mov ecx, _inputLength
		inc edx
		cmp edx, 1ah
		jl @caesarLoop
		ret	
CAESAR endp
