
	HashPanama			proto	:dword,:UINT
	HashPanamaEx		proto	:dword,:UINT,:dword,:dword,:dword,:dword,:dword,:dword,:dword,:dword
	PanamaInit			proto
	PanamaUpdate		proto	:dword, :dword
	PanamaFinal			proto
	PanamaTransform		proto
	PanamaTransform2	proto


.data?
	PanamaINITS			dd	?
						dd	?
						dd	?
						dd	?
						dd	?
						dd	?
						dd	?
						dd	?
	PanamaHashBuf		dd	124h dup (?)
	PanamaTemp			db	20h dup (?)
	PanamaLen			dd	?
	PanamaIndex			dd	?
	PanamaDigest		dd	8 dup (?)


.code

PANAMA_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:

		mov	esi, offset HASHES_Current
		assume esi:ptr HASH_PARAMETERS
		invoke HashPanamaEx, _Input, _len, [esi].PANAMAparameterA, [esi].PANAMAparameterB, [esi].PANAMAparameterC, \
			[esi].PANAMAparameterD, [esi].PANAMAparameterE, [esi].PANAMAparameterF, [esi].PANAMAparameterG, [esi].PANAMAparameterH
		assume esi:nothing

		mov	edi, eax
		xor	ebx, ebx
	@@:
		mov	eax, dword ptr[edi+ebx*4]
		bswap eax
		invoke wsprintf, _Input, addr hex32bitlc, eax
		invoke lstrcat, _Output, _Input
		inc	ebx
		cmp	ebx, 8
		jl @b

		invoke lstrlen, _Output
		HexLen
		ret
PANAMA_RT endp


align dword
HashPanama proc pData:dword, dwDataLen:UINT	
		invoke HashPanamaEx, pData, dwDataLen, 1, 0, 0, 0, 0, 0, 0, 0	
		ret
HashPanama endp


align dword
HashPanamaEx proc uses esi edi pData:dword, dwDataLen:UINT, dwInit1:dword, dwInit2:dword, dwInit3:dword, dwInit4:dword, dwInit5:dword, dwInit6:dword, dwInit7:dword, dwInit8:dword
		xor ecx, ecx
		mov cl, 8 ; 8 inits
		lea esi, dwInit1
		mov edi, offset PanamaINITS
		rep movsd		
		invoke PanamaInit
		invoke PanamaUpdate, pData, dwDataLen
		invoke PanamaFinal
		ret
HashPanamaEx endp


align dword
PanamaInit proc uses esi edi	
		cld
		mov edi, offset PanamaHashBuf
		mov esi, edi
		xor eax, eax
		mov ecx, (sizeof PanamaHashBuf)/4
		rep stosd
		mov PanamaLen, eax
		mov PanamaIndex, eax	
		ret
PanamaInit endp



align dword
PanamaUpdate proc uses ebx esi edi pData:dword, dwDataLen:dword	
		mov ecx, dwDataLen
		.if !ecx
			jmp @QuitPanamaUpdate
		.endif
		cld
		mov edi, offset PanamaHashBuf
		mov eax, PanamaLen
		and eax, 1fh
		add PanamaLen, ecx
		adc PanamaIndex, 0
		mov edx, 20h
		test eax, eax
		je @PanamaUpdate1
		sub edx, eax
		cmp ecx, edx
		jnb @PanamaUpdate2
		mov esi, pData
		add edi, 490h
		add edi, eax
		rep movsb
		jmp @QuitPanamaUpdate
	@PanamaUpdate2:
		xchg edx, ecx
		mov esi, pData
		add edi, 490h
		mov ebx, esi
		add esi, eax
		mov eax, ecx
		rep movsb
		mov ecx, eax
		xchg edx, ecx
		mov eax, esi
		mov esi, ebx
		mov esi, pData
		mov ebx, esi
		pushad
		invoke PanamaTransform
		popad
		mov esi, eax
		mov esi, ebx
		sub ecx, edx
		mov edx, 20h
		jnz @PanamaUpdate3
		jmp @QuitPanamaUpdate
	@PanamaUpdate1:
		mov esi, pData
	@PanamaUpdate3:
		cmp ecx, edx
		jb @PanamaUpdate4
		xchg edi, esi
		pushad
		invoke PanamaTransform
		popad
		xchg edi, esi
		add esi, edx
		sub ecx, edx
		jnz @PanamaUpdate3
		jmp @QuitPanamaUpdate
	@PanamaUpdate4:
		add edi, 490h
		rep movsb
	@QuitPanamaUpdate:
		ret
PanamaUpdate endp



align dword
PanamaFinal proc uses ebx esi edi	
		cld
		mov edi, offset PanamaHashBuf
		mov eax, PanamaLen
		mov ebx, eax
		and ebx, 1fh
		cmp ebx, 20h
		jnb @PanamaFinal1
		mov ecx, 20h
		sub ecx, ebx
		add edi, 490h
		add edi, ebx
		mov esi, offset PanamaINITS
		rep movsb
		mov edi, offset PanamaHashBuf
	@PanamaFinal1:
		mov esi, edi
		add edi, 490h
		pushad
		invoke PanamaTransform
		popad
		pushad
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		invoke PanamaTransform2
		push edi
		mov edi, esi
		add esi, 24h
		push ecx
		mov ecx, 8
		rep movsd
		pop ecx
		pop edi
		popad
		mov ecx, 8
		mov edi, offset PanamaDigest
		mov esi, offset PanamaHashBuf
		rep movsd
		mov edi, offset PanamaHashBuf
		mov esi, edi
		xor eax, eax
		mov ecx, 124h
		rep stosd
		mov PanamaLen, eax
		mov PanamaIndex, eax
		mov eax, offset PanamaDigest		
		ret
PanamaFinal endp



align dword
PanamaTransform proc	
		mov ebx, esi
		add ebx, 88h
		mov ebp, ebx
		mov eax, dword ptr [esi+488h]
		add eax, 1fh
		and eax, 1fh
		mov dword ptr [esi+48Ch], eax
		mov edx, eax
		shl eax, 5
		add ebx, eax
		add edx, 19h
		and edx, 1fh
		shl edx, 5
		add ebp, edx
		mov eax, dword ptr [ebx]
		mov edx, dword ptr [edi]
		xor edx, eax
		mov dword ptr [ebx], edx
		xor dword ptr [ebp+18h], eax
		mov eax, dword ptr [ebx+4]
		mov edx, dword ptr [edi+4]
		xor edx, eax
		mov dword ptr [ebx+4], edx
		xor dword ptr [ebp+1ch], eax
		mov eax, dword ptr [ebx+8]
		mov edx, dword ptr [edi+8]
		xor edx, eax
		mov dword ptr [ebx+8], edx
		xor dword ptr [ebp], eax
		mov eax, dword ptr [ebx+0Ch]
		mov edx, dword ptr [edi+0Ch]
		xor edx, eax
		mov dword ptr [ebx+0Ch], edx
		xor dword ptr [ebp+4], eax
		mov eax, dword ptr [ebx+10h]
		mov edx, dword ptr [edi+10h]
		xor edx, eax
		mov dword ptr [ebx+10h], edx
		xor dword ptr [ebp+8], eax
		mov eax, dword ptr [ebx+14h]
		mov edx, dword ptr [edi+14h]
		xor edx, eax
		mov dword ptr [ebx+14h], edx
		xor dword ptr [ebp+0Ch], eax
		mov eax, dword ptr [ebx+18h]
		mov edx, dword ptr [edi+18h]
		xor edx, eax
		mov dword ptr [ebx+18h], edx
		xor dword ptr [ebp+10h], eax
		mov eax, dword ptr [ebx+1ch]
		mov edx, dword ptr [edi+1ch]
		xor edx, eax
		mov dword ptr [ebx+1ch], edx
		xor dword ptr [ebp+14h], eax
		mov eax, dword ptr [esi+8]
		not eax
		or eax, dword ptr [esi+4]
		xor eax, dword ptr [esi]
		rol eax, 0             
		mov dword ptr [esi+44h], eax
		mov eax, dword ptr [esi+0Ch]
		not eax
		or eax, dword ptr [esi+8]
		xor eax, dword ptr [esi+4]
		rol eax, 0Fh
		mov dword ptr [esi+58h], eax
		mov eax, dword ptr [esi+10h]
		not eax
		or eax, dword ptr [esi+0Ch]
		xor eax, dword ptr [esi+8]
		rol eax, 17h
		mov dword ptr [esi+6Ch], eax
		mov eax, dword ptr [esi+14h]
		not eax
		or eax, dword ptr [esi+10h]
		xor eax, dword ptr [esi+0Ch]
		rol eax, 18h
		mov dword ptr [esi+80h], eax
		mov eax, dword ptr [esi+18h]
		not eax
		or eax, dword ptr [esi+14h]
		xor eax, dword ptr [esi+10h]
		rol eax, 6
		mov dword ptr [esi+50h], eax
		mov eax, dword ptr [esi+1ch]
		not eax
		or eax, dword ptr [esi+18h]
		xor eax, dword ptr [esi+14h]
		rol eax, 4
		mov dword ptr [esi+64h], eax
		mov eax, dword ptr [esi+20h]
		not eax
		or eax, dword ptr [esi+1ch]
		xor eax, dword ptr [esi+18h]
		rol eax, 1Bh
		mov dword ptr [esi+78h], eax
		mov eax, dword ptr [esi+24h]
		not eax
		or eax, dword ptr [esi+20h]
		xor eax, dword ptr [esi+1ch]
		rol eax, 1
		mov dword ptr [esi+48h], eax
		mov eax, dword ptr [esi+28h]
		not eax
		or eax, dword ptr [esi+24h]
		xor eax, dword ptr [esi+20h]
		rol eax, 15h
		mov dword ptr [esi+5Ch], eax
		mov eax, dword ptr [esi+2Ch]
		not eax
		or eax, dword ptr [esi+28h]
		xor eax, dword ptr [esi+24h]
		rol eax, 2
		mov dword ptr [esi+70h], eax
		mov eax, dword ptr [esi+30h]
		not eax
		or eax, dword ptr [esi+2Ch]
		xor eax, dword ptr [esi+28h]
		rol eax, 8
		mov dword ptr [esi+84h], eax
		mov eax, dword ptr [esi+34h]
		not eax
		or eax, dword ptr [esi+30h]
		xor eax, dword ptr [esi+2Ch]
		rol eax, 0Ah
		mov dword ptr [esi+54h], eax
		mov eax, dword ptr [esi+38h]
		not eax
		or eax, dword ptr [esi+34h]
		xor eax, dword ptr [esi+30h]
		rol eax, 0Dh
		mov dword ptr [esi+68h], eax
		mov eax, dword ptr [esi+3Ch]
		not eax
		or eax, dword ptr [esi+38h]
		xor eax, dword ptr [esi+34h]
		rol eax, 9
		mov dword ptr [esi+7Ch], eax
		mov eax, dword ptr [esi+40h]
		not eax
		or eax, dword ptr [esi+3Ch]
		xor eax, dword ptr [esi+38h]
		rol eax, 3
		mov dword ptr [esi+4Ch], eax
		mov eax, dword ptr [esi]
		not eax
		or eax, dword ptr [esi+40h]
		xor eax, dword ptr [esi+3Ch]
		rol eax, 1ch
		mov dword ptr [esi+60h], eax
		mov eax, dword ptr [esi+4]
		not eax
		or eax, dword ptr [esi]
		xor eax, dword ptr [esi+40h]
		rol eax, 0Eh
		mov dword ptr [esi+74h], eax
		mov ebx, esi
		add ebx, 88h
		mov ebp, ebx
		mov eax, dword ptr [esi+488h]
		mov edx, eax
		add eax, 10h
		and eax, 1fh
		shl eax, 5
		add ebx, eax
		add edx, 4
		and edx, 1fh
		shl edx, 5
		add ebp, edx
		mov eax, 1
		xor eax, dword ptr [esi+54h]
		xor eax, dword ptr [esi+48h]
		xor eax, dword ptr [esi+44h]
		mov dword ptr [esi], eax
		mov eax, dword ptr [edi]
		xor eax, dword ptr [esi+58h]
		xor eax, dword ptr [esi+4Ch]
		xor eax, dword ptr [esi+48h]
		mov dword ptr [esi+4], eax
		mov eax, dword ptr [edi+4]
		xor eax, dword ptr [esi+5Ch]
		xor eax, dword ptr [esi+50h]
		xor eax, dword ptr [esi+4Ch]
		mov dword ptr [esi+8], eax
		mov eax, dword ptr [edi+8]
		xor eax, dword ptr [esi+60h]
		xor eax, dword ptr [esi+54h]
		xor eax, dword ptr [esi+50h]
		mov dword ptr [esi+0Ch], eax
		mov eax, dword ptr [edi+0Ch]
		xor eax, dword ptr [esi+64h]
		xor eax, dword ptr [esi+58h]
		xor eax, dword ptr [esi+54h]
		mov dword ptr [esi+10h], eax
		mov eax, dword ptr [edi+10h]
		xor eax, dword ptr [esi+68h]
		xor eax, dword ptr [esi+5Ch]
		xor eax, dword ptr [esi+58h]
		mov dword ptr [esi+14h], eax
		mov eax, dword ptr [edi+14h]
		xor eax, dword ptr [esi+6Ch]
		xor eax, dword ptr [esi+60h]
		xor eax, dword ptr [esi+5Ch]
		mov dword ptr [esi+18h], eax
		mov eax, dword ptr [edi+18h]
		xor eax, dword ptr [esi+70h]
		xor eax, dword ptr [esi+64h]
		xor eax, dword ptr [esi+60h]
		mov dword ptr [esi+1ch], eax
		mov eax, dword ptr [edi+1ch]
		xor eax, dword ptr [esi+74h]
		xor eax, dword ptr [esi+68h]
		xor eax, dword ptr [esi+64h]
		mov dword ptr [esi+20h], eax
		mov eax, dword ptr [ebx]
		xor eax, dword ptr [esi+78h]
		xor eax, dword ptr [esi+6Ch]
		xor eax, dword ptr [esi+68h]
		mov dword ptr [esi+24h], eax
		mov eax, dword ptr [ebx+4]
		xor eax, dword ptr [esi+7Ch]
		xor eax, dword ptr [esi+70h]
		xor eax, dword ptr [esi+6Ch]
		mov dword ptr [esi+28h], eax
		mov eax, dword ptr [ebx+8]
		xor eax, dword ptr [esi+80h]
		xor eax, dword ptr [esi+74h]
		xor eax, dword ptr [esi+70h]
		mov dword ptr [esi+2Ch], eax
		mov eax, dword ptr [ebx+0Ch]
		xor eax, dword ptr [esi+84h]
		xor eax, dword ptr [esi+78h]
		xor eax, dword ptr [esi+74h]
		mov dword ptr [esi+30h], eax
		mov eax, dword ptr [ebx+10h]
		xor eax, dword ptr [esi+44h]
		xor eax, dword ptr [esi+7Ch]
		xor eax, dword ptr [esi+78h]
		mov dword ptr [esi+34h], eax
		mov eax, dword ptr [ebx+14h]
		xor eax, dword ptr [esi+48h]
		xor eax, dword ptr [esi+80h]
		xor eax, dword ptr [esi+7Ch]
		mov dword ptr [esi+38h], eax
		mov eax, dword ptr [ebx+18h]
		xor eax, dword ptr [esi+4Ch]
		xor eax, dword ptr [esi+84h]
		xor eax, dword ptr [esi+80h]
		mov dword ptr [esi+3Ch], eax
		mov eax, dword ptr [ebx+1ch]
		xor eax, dword ptr [esi+50h]
		xor eax, dword ptr [esi+44h]
		xor eax, dword ptr [esi+84h]
		mov dword ptr [esi+40h], eax
		mov eax, dword ptr [esi+48Ch]
		mov dword ptr [esi+488h], eax		
		ret
PanamaTransform endp



align dword
PanamaTransform2 proc	
		mov ebx, esi          
		add ebx, 88h
		mov ebp, ebx
		mov eax, dword ptr [esi+488h]
		add eax, 1fh
		and eax, 1fh
		mov dword ptr [esi+48Ch], eax
		mov edx, eax
		shl eax, 5
		add ebx, eax
		add edx, 19h
		and edx, 1fh
		shl edx, 5
		add ebp, edx
		mov eax, dword ptr [ebx]
		mov edx, dword ptr [esi+4]
		xor edx, eax
		mov dword ptr [ebx], edx
		xor dword ptr [ebp+18h], eax
		mov eax, dword ptr [ebx+4]
		mov edx, dword ptr [esi+8]
		xor edx, eax
		mov dword ptr [ebx+4], edx
		xor dword ptr [ebp+1ch], eax
		mov eax, dword ptr [ebx+8]
		mov edx, dword ptr [esi+0Ch]
		xor edx, eax
		mov dword ptr [ebx+8], edx
		xor dword ptr [ebp], eax
		mov eax, dword ptr [ebx+0Ch]
		mov edx, dword ptr [esi+10h]
		xor edx, eax
		mov dword ptr [ebx+0Ch], edx
		xor dword ptr [ebp+4], eax
		mov eax, dword ptr [ebx+10h]
		mov edx, dword ptr [esi+14h]
		xor edx, eax
		mov dword ptr [ebx+10h], edx
		xor dword ptr [ebp+8], eax
		mov eax, dword ptr [ebx+14h]
		mov edx, dword ptr [esi+18h]
		xor edx, eax
		mov dword ptr [ebx+14h], edx
		xor dword ptr [ebp+0Ch], eax
		mov eax, dword ptr [ebx+18h]
		mov edx, dword ptr [esi+1ch]
		xor edx, eax
		mov dword ptr [ebx+18h], edx
		xor dword ptr [ebp+10h], eax
		mov eax, dword ptr [ebx+1ch]
		mov edx, dword ptr [esi+20h]
		xor edx, eax
		mov dword ptr [ebx+1ch], edx
		xor dword ptr [ebp+14h], eax
		mov eax, dword ptr [esi+8]
		not eax
		or eax, dword ptr [esi+4]
		xor eax, dword ptr [esi]
		rol eax, 0                     
		mov dword ptr [esi+44h], eax
		mov eax, dword ptr [esi+0Ch]
		not eax
		or eax, dword ptr [esi+8]
		xor eax, dword ptr [esi+4]
		rol eax, 0Fh
		mov dword ptr [esi+58h], eax
		mov eax, dword ptr [esi+10h]
		not eax
		or eax, dword ptr [esi+0Ch]
		xor eax, dword ptr [esi+8]
		rol eax, 17h
		mov dword ptr [esi+6Ch], eax
		mov eax, dword ptr [esi+14h]
		not eax
		or eax, dword ptr [esi+10h]
		xor eax, dword ptr [esi+0Ch]
		rol eax, 18h
		mov dword ptr [esi+80h], eax
		mov eax, dword ptr [esi+18h]
		not eax
		or eax, dword ptr [esi+14h]
		xor eax, dword ptr [esi+10h]
		rol eax, 6
		mov dword ptr [esi+50h], eax
		mov eax, dword ptr [esi+1ch]
		not eax
		or eax, dword ptr [esi+18h]
		xor eax, dword ptr [esi+14h]
		rol eax, 4
		mov dword ptr [esi+64h], eax
		mov eax, dword ptr [esi+20h]
		not eax
		or eax, dword ptr [esi+1ch]
		xor eax, dword ptr [esi+18h]
		rol eax, 1Bh
		mov dword ptr [esi+78h], eax
		mov eax, dword ptr [esi+24h]
		not eax
		or eax, dword ptr [esi+20h]
		xor eax, dword ptr [esi+1ch]
		rol eax, 1
		mov dword ptr [esi+48h], eax
		mov eax, dword ptr [esi+28h]
		not eax
		or eax, dword ptr [esi+24h]
		xor eax, dword ptr [esi+20h]
		rol eax, 15h
		mov dword ptr [esi+5Ch], eax
		mov eax, dword ptr [esi+2Ch]
		not eax
		or eax, dword ptr [esi+28h]
		xor eax, dword ptr [esi+24h]
		rol eax, 2
		mov dword ptr [esi+70h], eax
		mov eax, dword ptr [esi+30h]
		not eax
		or eax, dword ptr [esi+2Ch]
		xor eax, dword ptr [esi+28h]
		rol eax, 8
		mov dword ptr [esi+84h], eax
		mov eax, dword ptr [esi+34h]
		not eax
		or eax, dword ptr [esi+30h]
		xor eax, dword ptr [esi+2Ch]
		rol eax, 0Ah
		mov dword ptr [esi+54h], eax
		mov eax, dword ptr [esi+38h]
		not eax
		or eax, dword ptr [esi+34h]
		xor eax, dword ptr [esi+30h]
		rol eax, 0Dh
		mov dword ptr [esi+68h], eax
		mov eax, dword ptr [esi+3Ch]
		not eax
		or eax, dword ptr [esi+38h]
		xor eax, dword ptr [esi+34h]
		rol eax, 9
		mov dword ptr [esi+7Ch], eax
		mov eax, dword ptr [esi+40h]
		not eax
		or eax, dword ptr [esi+3Ch]
		xor eax, dword ptr [esi+38h]
		rol eax, 3
		mov dword ptr [esi+4Ch], eax
		mov eax, dword ptr [esi]
		not eax
		or eax, dword ptr [esi+40h]
		xor eax, dword ptr [esi+3Ch]
		rol eax, 1ch
		mov dword ptr [esi+60h], eax
		mov eax, dword ptr [esi+4]
		not eax
		or eax, dword ptr [esi]
		xor eax, dword ptr [esi+40h]
		rol eax, 0Eh
		mov dword ptr [esi+74h], eax
		mov ebx, esi
		add ebx, 88h
		mov ebp, ebx
		mov eax, dword ptr [esi+488h]
		mov edx, eax
		add eax, 10h
		and eax, 1fh
		shl eax, 5
		add ebx, eax
		add edx, 4
		and edx, 1fh
		shl edx, 5
		add ebp, edx
		mov eax, 1
		xor eax, dword ptr [esi+54h]
		xor eax, dword ptr [esi+48h]
		xor eax, dword ptr [esi+44h]
		mov dword ptr [esi], eax
		mov eax, dword ptr [ebp]
		xor eax, dword ptr [esi+58h]
		xor eax, dword ptr [esi+4Ch]
		xor eax, dword ptr [esi+48h]
		mov dword ptr [esi+4], eax
		mov eax, dword ptr [ebp+4]
		xor eax, dword ptr [esi+5Ch]
		xor eax, dword ptr [esi+50h]
		xor eax, dword ptr [esi+4Ch]
		mov dword ptr [esi+8], eax
		mov eax, dword ptr [ebp+8]
		xor eax, dword ptr [esi+60h]
		xor eax, dword ptr [esi+54h]
		xor eax, dword ptr [esi+50h]
		mov dword ptr [esi+0Ch], eax
		mov eax, dword ptr [ebp+0Ch]
		xor eax, dword ptr [esi+64h]
		xor eax, dword ptr [esi+58h]
		xor eax, dword ptr [esi+54h]
		mov dword ptr [esi+10h], eax
		mov eax, dword ptr [ebp+10h]
		xor eax, dword ptr [esi+68h]
		xor eax, dword ptr [esi+5Ch]
		xor eax, dword ptr [esi+58h]
		mov dword ptr [esi+14h], eax
		mov eax, dword ptr [ebp+14h]
		xor eax, dword ptr [esi+6Ch]
		xor eax, dword ptr [esi+60h]
		xor eax, dword ptr [esi+5Ch]
		mov dword ptr [esi+18h], eax
		mov eax, dword ptr [ebp+18h]
		xor eax, dword ptr [esi+70h]
		xor eax, dword ptr [esi+64h]
		xor eax, dword ptr [esi+60h]
		mov dword ptr [esi+1ch], eax
		mov eax, dword ptr [ebp+1ch]
		xor eax, dword ptr [esi+74h]
		xor eax, dword ptr [esi+68h]
		xor eax, dword ptr [esi+64h]
		mov dword ptr [esi+20h], eax
		mov eax, dword ptr [ebx]
		xor eax, dword ptr [esi+78h]
		xor eax, dword ptr [esi+6Ch]
		xor eax, dword ptr [esi+68h]
		mov dword ptr [esi+24h], eax
		mov eax, dword ptr [ebx+4]
		xor eax, dword ptr [esi+7Ch]
		xor eax, dword ptr [esi+70h]
		xor eax, dword ptr [esi+6Ch]
		mov dword ptr [esi+28h], eax
		mov eax, dword ptr [ebx+8]
		xor eax, dword ptr [esi+80h]
		xor eax, dword ptr [esi+74h]
		xor eax, dword ptr [esi+70h]
		mov dword ptr [esi+2Ch], eax
		mov eax, dword ptr [ebx+0Ch]
		xor eax, dword ptr [esi+84h]
		xor eax, dword ptr [esi+78h]
		xor eax, dword ptr [esi+74h]
		mov dword ptr [esi+30h], eax
		mov eax, dword ptr [ebx+10h]
		xor eax, dword ptr [esi+44h]
		xor eax, dword ptr [esi+7Ch]
		xor eax, dword ptr [esi+78h]
		mov dword ptr [esi+34h], eax
		mov eax, dword ptr [ebx+14h]
		xor eax, dword ptr [esi+48h]
		xor eax, dword ptr [esi+80h]
		xor eax, dword ptr [esi+7Ch]
		mov dword ptr [esi+38h], eax
		mov eax, dword ptr [ebx+18h]
		xor eax, dword ptr [esi+4Ch]
		xor eax, dword ptr [esi+84h]
		xor eax, dword ptr [esi+80h]
		mov dword ptr [esi+3Ch], eax
		mov eax, dword ptr [ebx+1ch]
		xor eax, dword ptr [esi+50h]
		xor eax, dword ptr [esi+44h]
		xor eax, dword ptr [esi+84h]
		mov dword ptr [esi+40h], eax
		mov eax, dword ptr [esi+48Ch]
		mov dword ptr [esi+488h], eax		
		ret
PanamaTransform2 endp
