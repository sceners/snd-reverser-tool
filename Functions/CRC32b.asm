

.data
szBUD		db 20h dup(0)
;/* This polynomial (0x04c11db7) is used at: AUTODIN II, Ethernet, & FDDI */

table_crc32b	dd 000000000h, 004c11db7h, 009823b6eh, 00d4326d9h, 0130476dch, 017c56b6bh
		dd 01a864db2h, 01e475005h, 02608edb8h, 022c9f00fh, 02f8ad6d6h, 02b4bcb61h
		dd 0350c9b64h, 031cd86d3h, 03c8ea00ah, 0384fbdbdh, 04c11db70h, 048d0c6c7h
		dd 04593e01eh, 04152fda9h, 05f15adach, 05bd4b01bh, 0569796c2h, 052568b75h
		dd 06a1936c8h, 06ed82b7fh, 0639b0da6h, 0675a1011h, 0791d4014h, 07ddc5da3h
		dd 0709f7b7ah, 0745e66cdh, 09823b6e0h, 09ce2ab57h, 091a18d8eh, 095609039h
		dd 08b27c03ch, 08fe6dd8bh, 082a5fb52h, 08664e6e5h, 0be2b5b58h, 0baea46efh
		dd 0b7a96036h, 0b3687d81h, 0ad2f2d84h, 0a9ee3033h, 0a4ad16eah, 0a06c0b5dh
		dd 0d4326d90h, 0d0f37027h, 0ddb056feh, 0d9714b49h, 0c7361b4ch, 0c3f706fbh
		dd 0ceb42022h, 0ca753d95h, 0f23a8028h, 0f6fb9d9fh, 0fbb8bb46h, 0ff79a6f1h
		dd 0e13ef6f4h, 0e5ffeb43h, 0e8bccd9ah, 0ec7dd02dh, 034867077h, 030476dc0h
		dd 03d044b19h, 039c556aeh, 0278206abh, 023431b1ch, 02e003dc5h, 02ac12072h
		dd 0128e9dcfh, 0164f8078h, 01b0ca6a1h, 01fcdbb16h, 0018aeb13h, 0054bf6a4h
		dd 00808d07dh, 00cc9cdcah, 07897ab07h, 07c56b6b0h, 071159069h, 075d48ddeh
		dd 06b93dddbh, 06f52c06ch, 06211e6b5h, 066d0fb02h, 05e9f46bfh, 05a5e5b08h
		dd 0571d7dd1h, 053dc6066h, 04d9b3063h, 0495a2dd4h, 044190b0dh, 040d816bah
		dd 0aca5c697h, 0a864db20h, 0a527fdf9h, 0a1e6e04eh, 0bfa1b04bh, 0bb60adfch
		dd 0b6238b25h, 0b2e29692h, 08aad2b2fh, 08e6c3698h, 0832f1041h, 087ee0df6h
		dd 099a95df3h, 09d684044h, 0902b669dh, 094ea7b2ah, 0e0b41de7h, 0e4750050h
		dd 0e9362689h, 0edf73b3eh, 0f3b06b3bh, 0f771768ch, 0fa325055h, 0fef34de2h
		dd 0c6bcf05fh, 0c27dede8h, 0cf3ecb31h, 0cbffd686h, 0d5b88683h, 0d1799b34h
		dd 0dc3abdedh, 0d8fba05ah, 0690ce0eeh, 06dcdfd59h, 0608edb80h, 0644fc637h
		dd 07a089632h, 07ec98b85h, 0738aad5ch, 0774bb0ebh, 04f040d56h, 04bc510e1h
		dd 046863638h, 042472b8fh, 05c007b8ah, 058c1663dh, 0558240e4h, 051435d53h
		dd 0251d3b9eh, 021dc2629h, 02c9f00f0h, 0285e1d47h, 036194d42h, 032d850f5h
		dd 03f9b762ch, 03b5a6b9bh, 00315d626h, 007d4cb91h, 00a97ed48h, 00e56f0ffh
		dd 01011a0fah, 014d0bd4dh, 019939b94h, 01d528623h, 0f12f560eh, 0f5ee4bb9h
		dd 0f8ad6d60h, 0fc6c70d7h, 0e22b20d2h, 0e6ea3d65h, 0eba91bbch, 0ef68060bh
		dd 0d727bbb6h, 0d3e6a601h, 0dea580d8h, 0da649d6fh, 0c423cd6ah, 0c0e2d0ddh
		dd 0cda1f604h, 0c960ebb3h, 0bd3e8d7eh, 0b9ff90c9h, 0b4bcb610h, 0b07daba7h
		dd 0ae3afba2h, 0aafbe615h, 0a7b8c0cch, 0a379dd7bh, 09b3660c6h, 09ff77d71h
		dd 092b45ba8h, 09675461fh, 08832161ah, 08cf30badh, 081b02d74h, 0857130c3h
		dd 05d8a9099h, 0594b8d2eh, 05408abf7h, 050c9b640h, 04e8ee645h, 04a4ffbf2h
		dd 0470cdd2bh, 043cdc09ch, 07b827d21h, 07f436096h, 07200464fh, 076c15bf8h
		dd 068860bfdh, 06c47164ah, 061043093h, 065c52d24h, 0119b4be9h, 0155a565eh
		dd 018197087h, 01cd86d30h, 0029f3d35h, 0065e2082h, 00b1d065bh, 00fdc1bech
		dd 03793a651h, 03352bbe6h, 03e119d3fh, 03ad08088h, 02497d08dh, 02056cd3ah
		dd 02d15ebe3h, 029d4f654h, 0c5a92679h, 0c1683bceh, 0cc2b1d17h, 0c8ea00a0h
		dd 0d6ad50a5h, 0d26c4d12h, 0df2f6bcbh, 0dbee767ch, 0e3a1cbc1h, 0e760d676h
		dd 0ea23f0afh, 0eee2ed18h, 0f0a5bd1dh, 0f464a0aah, 0f9278673h, 0fde69bc4h
		dd 089b8fd09h, 08d79e0beh, 0803ac667h, 084fbdbd0h, 09abc8bd5h, 09e7d9662h
		dd 0933eb0bbh, 097ffad0ch, 0afb010b1h, 0ab710d06h, 0a6322bdfh, 0a2f33668h
		dd 0bcb4666dh, 0b8757bdah, 0b5365d03h, 0b1f740b4h	;end - 256 dword
    
;*******************************************************************
;*  CODE                                                           *
;*******************************************************************

.code

;***************************************************************************************
;Start CRC32b Handler functions
;***************************************************************************************

CRC32b_RT proc uses esi edx ecx _Input:dword,_Output:dword,_len:dword
		call DisableKeyEdit

		mov esi, offset HASHES_Current
		assume esi:ptr HASH_PARAMETERS
		mov ebx, [esi].CRC32bparameterA
		push ebx
		assume esi:nothing
		;push 0ffffffffh
		push _len
		push _Output
		push _Input
		call CRC32b
		mov	eax,4
        ret
CRC32b_RT endp


;***************************************************************************************
;Start CRC32b functions
;***************************************************************************************
CRC32b	proc uses esi edx ecx eax _Input:dword,_Output:dword,_len:dword,_key:dword  
		mov	eax, _key
		mov	esi, _Input
		xor	ecx, ecx
	crc32b_boucle:
		mov	edx, eax
		shr	edx, 24
		xor	dl, byte ptr [ecx+esi]
		mov	edx, dword ptr [4*edx+table_crc32b]
		shl	eax, 8
		xor	eax, edx
		inc	ecx
		cmp	ecx, [_len]
		jl	crc32b_boucle
	crc32b_end:
		xor	eax, _key
		invoke	wsprintf,_Output,addr hex32bit,eax
		xor	ecx, ecx
		ret
CRC32b	endp

