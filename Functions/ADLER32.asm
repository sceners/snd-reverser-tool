

.const

ADLER32_BASE equ 65521 ; largest prime smaller than 65536
ADLER32_NMAX equ 5552 ; largest n such that 255n(n+1)/2 + (n+1)(BASE-1) <= 2^32-1

.code

align dword

ADLER32_RT proc uses esi edx ecx  _Input:dword, _Output:dword, _len:dword
		call DisableKeyEdit

		mov esi, offset HASHES_Current
		assume esi:ptr HASH_PARAMETERS
		mov ebx, [esi].ADLER32parameterA
		push ebx
		assume esi:nothing
		;push 1		
		push _len
		push _Input
		call Adler32
		invoke wsprintf, _Output, addr hex32bit, eax
		HexLen
        ret
ADLER32_RT endp


Adler32 proc uses edi esi ebx lpBuffer:dword, dwBufLen:dword, dwAdler:dword
	mov eax, dwAdler
	mov ecx, dwBufLen
	mov ebx, dwAdler
	and eax, 0FFFFh
	shr ebx, 16
	mov esi, lpBuffer
	jmp @F
	.repeat
		mov edi, ADLER32_NMAX
		.if ecx<edi
			mov edi, ecx
		.endif
        sub ecx, edi
		.repeat
			movzx edx, byte ptr [esi]
			add eax, edx
			inc esi
			add ebx, eax
			dec edi
		.until ZERO?
        mov edi, ADLER32_BASE
        xor edx, edx
        div edi
        push edx
        mov eax, ebx
        xor edx, edx
        div edi
        mov ebx, edx
        pop eax
@@:		test ecx, ecx
	.until ZERO?
	shl ebx, 16
	add eax, ebx
	ret
Adler32 endp

