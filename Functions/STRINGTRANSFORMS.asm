

.code

;***************************************************************************************
;Start String Transformation functions
;***************************************************************************************

STRINGT_UPPER_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		call DisableKeyEdit
		INVOKE wsprintfA, _Output, _Input
		INVOKE CharUpperA, _Output
		INVOKE lstrlen, _Output
	    ret
STRINGT_UPPER_RT endp


STRINGT_LOWER_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		call DisableKeyEdit
		INVOKE wsprintfA, _Output, _Input
		INVOKE CharLowerA, _Output
		INVOKE lstrlen, _Output
	    ret
STRINGT_LOWER_RT endp



STRINGT_REVERSE_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		call DisableKeyEdit
		cmp [_len], 00h
		je @noInput
		mov ecx, [_len]
		mov esi, _Input
		mov edi, _Output
	@loopReverse:
		mov bl, BYTE PTR DS:[esi+ecx-1]
		mov BYTE PTR DS:[edi], bl
		inc edi
		LOOP @loopReverse
		INVOKE lstrlen, _Output
	@noInput:
	    ret
STRINGT_REVERSE_RT endp
