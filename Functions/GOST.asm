
	HashGost			proto	:dword, :UINT
	HashGostEx			proto	:dword, :UINT, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
	GOSTStr2Str			proto	:LPSTR, :LPSTR, :BOOL
	GOSTByte2Eax		proto	:dword, :UINT
	GOSTInit			proto
	GOSTUpdate			proto	:dword, :dword
	GOSTFinal			proto
	GOSTBurn			proto
	GOSTTransform1		proto	:dword, :UINT
	GOSTTransform2		proto	:dword, :dword

.const
	SIZE_GOST			equ		(32*10000h) + 32 ; BlockSize(Hi) + DigestSize(Lo)

.data
	uStdSBox			db 4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3
						db 14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9
						db 5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11
						db 7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3
						db 6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2
						db 4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14
						db 13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12
						db 1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12

.data?
	GOST_sum			dd 8 dup (?)
	GOST_hash			dd 8 dup (?)
	GOST_len			dd 8 dup (?)
	GOST_partial		dd 8 dup (?)
	GOST_partial_bytes	dd ?
	TablesInitialized	BOOL ?
	g_pSBox1			dd 256 dup (?)
	g_pSBox2			dd 256 dup (?)
	g_pSBox3			dd 256 dup (?)
	g_pSBox4			dd 256 dup (?)
	GOST_digest			dd 8 dup (?)
	
.code


GOST_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:

		mov	esi, offset HASHES_Current
		assume esi:ptr HASH_PARAMETERS
		invoke HashGostEx, _Input, _len, [esi].GOSTparameterA, [esi].GOSTparameterB, [esi].GOSTparameterC, \
			[esi].GOSTparameterD, [esi].GOSTparameterE, [esi].GOSTparameterF, [esi].GOSTparameterG, [esi].GOSTparameterH
		assume esi:nothing

		mov	edi, eax
		xor	ebx, ebx
	@@:
		mov	eax, dword ptr[edi+ebx*4]
		bswap eax
		invoke wsprintf, addr sTempBuf, addr hex32bitlc, eax
		invoke lstrcat, _Output, addr sTempBuf
		inc	ebx
		cmp	ebx, 8
		jl @b

		invoke lstrlen, _Output
		HexLen
		ret
GOST_RT endp


;align dword
;HashGost proc pData:dword, dwDataLen:UINT	
;		invoke HashGostEx, pData, dwDataLen, 0, 0, 0, 0, 0, 0, 0, 0	
;		ret
;HashGost endp


align dword
HashGostEx proc uses esi edi pData:dword, dwDataLen:UINT, dwInit1:dword, dwInit2:dword, dwInit3:dword, dwInit4:dword, dwInit5:dword, dwInit6:dword, dwInit7:dword, dwInit8:dword
		invoke GOSTInit
		xor ecx, ecx
		mov cl, 8
		lea esi, dwInit1
		mov edi, offset GOST_hash
		rep movsd		
		invoke GOSTUpdate, pData, dwDataLen
		invoke GOSTFinal		
		ret
HashGostEx endp


align dword
GOSTInit proc uses edi	
		.if !TablesInitialized
			invoke GOSTBurn
			mov TablesInitialized, TRUE
		.endif	
		xor eax, eax
		mov ecx, eax
		mov cl, (sizeof GOST_sum + sizeof GOST_hash + sizeof GOST_len + sizeof GOST_partial + sizeof GOST_partial_bytes) / 4
		mov edi, offset GOST_sum
		rep stosd
		ret	
GOSTInit endp


align dword
GOSTUpdate proc uses esi edi pData:dword, dwDataLen:UINT
	local i:dword, j:dword
		
		mov ecx, GOST_partial_bytes
		mov i, ecx
		xor edx, edx
		mov j, edx
		mov esi, pData
		mov edi, offset GOST_partial
		.while ecx < 32 && edx < dwDataLen 
			mov al, byte ptr [esi+edx]
			mov byte ptr [edi+ecx], al	
			inc i
			mov ecx, i
			inc j
			mov edx, j
		.endw
		
		.if i < 32
			push i
			pop GOST_partial_bytes
			jmp @GOSTUpdate_Quit
		.endif
		invoke GOSTTransform1, addr GOST_partial, 256

		mov edx, j
		add edx, 32
		.while edx < dwDataLen
			mov ecx, esi
			add ecx, j
			invoke GOSTTransform1, ecx, 256
			add j, 32
			mov edx, j
			add edx, 32
		.endw

		xor ecx, ecx
		mov i, ecx
		mov edx, j
		.while edx < dwDataLen
			mov al, byte ptr [esi+edx]
			mov byte ptr [edi+ecx], al	
			inc i
			mov ecx, i
			inc j
			mov edx, j
		.endw

		push i
		pop GOST_partial_bytes
	@GOSTUpdate_Quit:
		ret
GOSTUpdate endp


align dword
GOSTFinal proc uses esi edi
	local i_:dword, j_:dword
	local a_:dword

		xor eax, eax
		mov i_, eax
		mov j_, eax

		mov edx, GOST_partial_bytes
		.if edx > 0
			xor ecx, ecx
			mov cl, 32
			sub cl, dl
			lea edi, GOST_partial[edx]
			rep stosb
			shl edx, 3
			invoke GOSTTransform1, addr GOST_partial, edx
		.endif

		invoke GOSTTransform2, addr GOST_hash, addr GOST_len
		invoke GOSTTransform2, addr GOST_hash, addr GOST_sum

		mov esi, offset GOST_hash
		mov edi, offset GOST_digest
		.while i_ < 8
			mov ecx, i_
			mov edx, j_
			mov eax, dword ptr [esi+ecx*4]
			mov byte ptr [edi+edx], al
			shr eax, 8
			mov byte ptr [edi+edx+1], al
			shr eax, 8
			mov byte ptr [edi+edx+2], al
			shr eax, 8
			mov byte ptr [edi+edx+3], al			
			add j_, 4
			inc i_
		.endw		
		mov eax, offset GOST_hash
		ret
GOSTFinal endp


align dword
GOSTBurn proc uses esi edi
	local a:dword, b:dword, i:dword
	local ax_:dword, bx_:dword, cx_:dword, dx_:dword

		xor eax, eax
		mov a, eax
		mov i, eax
		mov esi, offset uStdSBox
		.while a < 16
			mov ecx, 1*16
			add ecx, a
			movzx eax, byte ptr [esi+ecx]
			shl eax, 15
			mov ax_, eax

			mov ecx, 3*16
			add ecx, a
			movzx eax, byte ptr [esi+ecx]
			shl eax, 23
			mov bx_, eax
			
			mov ecx, 5*16
			add ecx, a
			movzx eax, byte ptr [esi+ecx]
			mov ecx, eax
			shr eax, 1
			shl ecx, 31
			or eax, ecx
			mov cx_, eax

			mov ecx, 7*16
			add ecx, a
			movzx eax, byte ptr [esi+ecx]
			shl eax, 7
			mov dx_, eax

			xor eax, eax
			mov b, eax
			.while b < 16
				mov ecx, 0*16
				add ecx, b
				movzx eax, byte ptr [esi+ecx]
				shl eax, 11
				or eax, ax_
				mov edi, offset g_pSBox1
				add edi, i
				mov [edi], eax

				mov ecx, 2*16
				add ecx, b
				movzx eax, byte ptr [esi+ecx]
				shl eax, 19
				or eax, bx_
				mov edi, offset g_pSBox2
				add edi, i
				mov [edi], eax
				
				mov ecx, 4*16
				add ecx, b
				movzx eax, byte ptr [esi+ecx]
				shl eax, 27
				or eax, cx_
				mov edi, offset g_pSBox3
				add edi, i
				mov [edi], eax
				
				mov ecx, 6*16
				add ecx, b
				movzx eax, byte ptr [esi+ecx]
				shl eax, 3
				or eax, dx_
				mov edi, offset g_pSBox4
				add edi, i
				mov [edi], eax
				
				add i, 4
				inc b
			.endw
			inc a
		.endw
		ret
GOSTBurn endp


align dword
GOSTTransform1 proc uses esi pData:dword, dwBits:UINT
	local i_:dword, j_:dword
	local a_:dword, c_:dword
	local m_[8]:dword

		xor eax, eax
		mov i_, eax
		mov j_, eax
		mov a_, eax
		mov c_, eax
		mov edx, eax
		mov esi, pData
		.while i_ <8
			movzx eax, byte ptr [esi+edx]
			movzx ecx, byte ptr [esi+edx+1]
			shl ecx, 8
			or eax, ecx
			movzx ecx, byte ptr [esi+edx+2]
			shl ecx, 16
			or eax, ecx
			movzx ecx, byte ptr [esi+edx+3]
			shl ecx, 24
			or eax, ecx
			add edx, 4
			mov ecx, i_
			mov m_[ecx*4], eax
			
			.if c_
				add GOST_sum[ecx*4], eax
				inc GOST_sum[ecx*4]
				.if GOST_sum[ecx*4] <= eax
					mov c_, TRUE
				.else
					mov c_, FALSE
				.endif
			.else
				add GOST_sum[ecx*4], eax
				.if GOST_sum[ecx*4] < eax
					mov c_, TRUE
				.else
					mov c_, FALSE
				.endif
			.endif
			
			inc i_
		.endw		
		invoke GOSTTransform2, addr GOST_hash, addr m_

		mov eax, dwBits
		add GOST_len, eax
		.if GOST_len < eax
			inc GOST_len+4
		.endif
		ret
GOSTTransform1 endp


align dword
GOSTTransform2 proc uses esi edi h_:dword, m_:dword
	local i_:dword, l_:dword, r_:dword, t_:dword
	local k0_[8]:dword, u_[8]:dword, v_[8]:dword, w_[8]:dword, s_[8]:dword

		xor ecx, ecx
		mov cl, 8
		mov esi, h_
		lea edi, u_
		rep movsd
		xor ecx, ecx
		mov cl, 8
		mov esi, m_
		lea edi, v_
		rep movsd
		xor eax, eax
		mov i_, eax		
		jmp @GOSTTransform3_1

	@GOSTTransform3_0:
		mov eax, i_
		add eax, 2
		mov i_, eax

	@GOSTTransform3_1:
		cmp i_, 8
		jge @GOSTTransform3_4
		mov eax, u_
		xor eax, v_
		mov w_[0*4], eax
		mov eax, u_[1*4]
		xor eax, v_[1*4]
		mov w_[1*4], eax
		mov eax, u_[2*4]
		xor eax, v_[2*4]
		mov w_[2*4], eax
		mov eax, u_[3*4]
		xor eax, v_[3*4]
		mov w_[3*4], eax
		mov eax, u_[4*4]
		xor eax, v_[4*4]
		mov w_[4*4], eax
		mov eax, u_[5*4]
		xor eax, v_[5*4]
		mov w_[5*4], eax
		mov eax, u_[6*4]
		xor eax, v_[6*4]
		mov w_[6*4], eax
		mov eax, u_[7*4]
		xor eax, v_[7*4]
		mov w_[7*4], eax
		mov eax, w_[0*4]
		and eax, 0ffh
		mov ecx, w_[2*4]
		and ecx, 0ffh
		shl ecx, 8
		or eax, ecx
		mov edx, w_[4*4]
		and edx, 0ffh
		shl edx, 10h
		or eax, edx
		mov ecx, w_[6*4]
		and ecx, 0ffh
		shl ecx, 18h
		or eax, ecx
		mov k0_[0*4], eax
		mov eax, w_[0*4]
		and eax, 0ff00h
		shr eax, 8
		mov ecx, w_[2*4]
		and ecx, 0ff00h
		or eax, ecx
		mov edx, w_[4*4]
		and edx, 0ff00h
		shl edx, 8
		or eax, edx
		mov ecx, w_[6*4]
		and ecx, 0ff00h
		shl ecx, 10h
		or eax, ecx
		mov k0_[1*4], eax
		mov eax, w_[0*4]
		and eax, 0ff0000h
		shr eax, 10h
		mov ecx, w_[2*4]
		and ecx, 0ff0000h
		shr ecx, 8
		or eax, ecx
		mov edx, w_[4*4]
		and edx, 0ff0000h
		or eax, edx
		mov ecx, w_[6*4]
		and ecx, 0ff0000h
		shl ecx, 8
		or eax, ecx
		mov k0_[2*4], eax
		mov eax, w_[0*4]
		and eax, 0ff000000h
		shr eax, 18h
		mov ecx, w_[2*4]
		and ecx, 0ff000000h
		shr ecx, 10h
		or eax, ecx
		mov edx, w_[4*4]
		and edx, 0ff000000h
		shr edx, 8
		or eax, edx
		mov ecx, w_[6*4]
		and ecx, 0ff000000h
		or eax, ecx
		mov k0_[3*4], eax
		mov eax, w_[1*4]
		and eax, 0ffh
		mov ecx, w_[3*4]
		and ecx, 0ffh
		shl ecx, 8
		or eax, ecx
		mov edx, w_[5*4]
		and edx, 0ffh
		shl edx, 10h
		or eax, edx
		mov ecx, w_[7*4]
		and ecx, 0ffh
		shl ecx, 18h
		or eax, ecx
		mov k0_[4*4], eax
		mov eax, w_[1*4]
		and eax, 0ff00h
		shr eax, 8
		mov ecx, w_[3*4]
		and ecx, 0ff00h
		or eax, ecx
		mov edx, w_[5*4]
		and edx, 0ff00h
		shl edx, 8
		or eax, edx
		mov ecx, w_[7*4]
		and ecx, 0ff00h
		shl ecx, 10h
		or eax, ecx
		mov k0_[5*4], eax
		mov eax, w_[1*4]
		and eax, 0ff0000h
		shr eax, 10h
		mov ecx, w_[3*4]
		and ecx, 0ff0000h
		shr ecx, 8
		or eax, ecx
		mov edx, w_[5*4]
		and edx, 0ff0000h
		or eax, edx
		mov ecx, w_[7*4]
		and ecx, 0ff0000h
		shl ecx, 8
		or eax, ecx
		mov k0_[6*4], eax
		mov eax, w_[1*4]
		and eax, 0ff000000h
		shr eax, 18h
		mov ecx, w_[3*4]
		and ecx, 0ff000000h
		shr ecx, 10h
		or eax, ecx
		mov edx, w_[5*4]
		and edx, 0ff000000h
		shr edx, 8
		or eax, edx
		mov ecx, w_[7*4]
		and ecx, 0ff000000h
		or eax, ecx
		mov k0_[7*4], eax
		mov eax, i_
		mov ecx, h_
		mov edx, [ecx+eax*4]
		mov r_, edx
		mov eax, i_
		mov ecx, h_
		mov edx, [ecx+eax*4+4]
		mov l_, edx
		mov eax, k0_[0*4]
		add eax, r_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, l_
		mov l_, edx
		mov eax, k0_[1*4]
		add eax, l_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, r_
		mov r_, edx
		mov eax, k0_[2*4]
		add eax, r_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, l_
		mov l_, edx
		mov eax, k0_[3*4]
		add eax, l_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, r_
		mov r_, edx
		mov eax, k0_[4*4]
		add eax, r_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, l_
		mov l_, edx
		mov eax, k0_[5*4]
		add eax, l_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, r_
		mov r_, edx
		mov eax, k0_[6*4]
		add eax, r_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, l_
		mov l_, edx
		mov eax, k0_[7*4]
		add eax, l_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, r_
		mov r_, edx
		mov eax, k0_[0*4]
		add eax, r_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, l_
		mov l_, edx
		mov eax, k0_[1*4]
		add eax, l_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, r_
		mov r_, edx
		mov eax, k0_[2*4]
		add eax, r_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, l_
		mov l_, edx
		mov eax, k0_[3*4]
		add eax, l_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		mov ecx, t_
		shr ecx, 18h
		xor edx, g_pSBox4[ecx*4]
		xor edx, r_
		mov r_, edx
		mov eax, k0_[4*4]
		add eax, r_
		mov t_, eax
		mov eax, t_
		and eax, 0ffh
		mov ecx, t_
		shr ecx, 8
		and ecx, 0ffh
		mov edx, g_pSBox1[eax*4]
		xor edx, g_pSBox2[ecx*4]
		mov eax, t_
		shr eax, 10h
		and eax, 0ffh
		xor edx, g_pSBox3[eax*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[5*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[6*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[7*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[0*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[1*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[2*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[3*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[4*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[5*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[6*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[7*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[7*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[6*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[5*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[4*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[3*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[2*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, k0_[1*4]
		ADD EAX, r_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, l_
		MOV l_, EDX
		MOV EAX, k0_[0*4]
		ADD EAX, l_
		MOV t_, EAX
		MOV EAX, t_
		AND EAX, 0FFh
		MOV ECX, t_
		SHR ECX, 8
		AND ECX, 0FFh
		MOV EDX, g_pSBox1[EAX*4]
		XOR EDX, g_pSBox2[ECX*4]
		MOV EAX, t_
		SHR EAX, 10h
		AND EAX, 0FFh
		XOR EDX, g_pSBox3[EAX*4]
		MOV ECX, t_
		SHR ECX, 18h
		XOR EDX, g_pSBox4[ECX*4]
		XOR EDX, r_
		MOV r_, EDX
		MOV EAX, r_
		MOV t_, EAX
		MOV EAX, l_
		MOV r_, EAX
		MOV EAX, t_
		MOV l_, EAX
		MOV EAX, i_
		MOV ECX, r_
		MOV s_[EAX*4], ECX
		MOV EAX, i_
		MOV ECX, l_
		MOV s_[EAX*4+4], ECX
		CMP i_, 6
		JNZ @GOSTTransform3_2
		JMP @GOSTTransform3_4

	@GOSTTransform3_2:
		MOV EAX, u_
		XOR EAX, u_[2*4]
		MOV l_, EAX
		MOV EAX, u_[1*4]
		XOR EAX, u_[3*4]
		MOV r_, EAX
		MOV EAX, u_[2*4]
		MOV u_, EAX
		MOV EAX, u_[3*4]
		MOV u_[1*4], EAX
		MOV EAX, u_[4*4]
		MOV u_[2*4], EAX
		MOV EAX, u_[5*4]
		MOV u_[3*4], EAX
		MOV EAX, u_[6*4]
		MOV u_[4*4], EAX
		MOV EAX, u_[7*4]
		MOV u_[5*4], EAX
		MOV EAX, l_
		MOV u_[6*4], EAX
		MOV EAX, r_
		MOV u_[7*4], EAX
		CMP i_, 2
		JNZ @GOSTTransform3_3
		MOV EAX, u_
		XOR EAX, 0FF00FF00h
		MOV u_, EAX
		MOV EAX, u_[1*4]
		XOR EAX, 0FF00FF00h
		MOV u_[1*4], EAX
		MOV EAX, u_[2*4]
		XOR EAX, 0FF00FFh
		MOV u_[2*4], EAX
		MOV EAX, u_[3*4]
		XOR EAX, 0FF00FFh
		MOV u_[3*4], EAX
		MOV EAX, u_[4*4]
		XOR EAX, 0FFFF00h
		MOV u_[4*4], EAX
		MOV EAX, u_[5*4]
		XOR EAX, 0FF0000FFh
		MOV u_[5*4], EAX
		MOV EAX, u_[6*4]
		XOR EAX, 0FFh
		MOV u_[6*4], EAX
		MOV EAX, u_[7*4]
		XOR EAX, 0FF00FFFFh
		MOV u_[7*4], EAX
@GOSTTransform3_3:
		MOV EAX, v_
		MOV l_, EAX
		MOV EAX, v_[2*4]
		MOV r_, EAX
		MOV EAX, v_[4*4]
		MOV v_, EAX
		MOV EAX, v_[6*4]
		MOV v_[2*4], EAX
		MOV EAX, l_
		XOR EAX, r_
		MOV v_[4*4], EAX
		MOV EAX, v_
		XOR EAX, r_
		MOV v_[6*4], EAX
		MOV EAX, v_[1*4]
		MOV l_, EAX
		MOV EAX, v_[3*4]
		MOV r_, EAX
		MOV EAX, v_[5*4]
		MOV v_[1*4], EAX
		MOV EAX, v_[7*4]
		MOV v_[3*4], EAX
		MOV EAX, l_
		XOR EAX, r_
		MOV v_[5*4], EAX
		MOV EAX, v_[1*4]
		XOR EAX, r_
		MOV v_[7*4], EAX
		JMP @GOSTTransform3_0
@GOSTTransform3_4:
		MOV EAX, m_
		MOV ECX, [EAX]
		XOR ECX, s_[6*4]
		MOV u_, ECX
		MOV EAX, m_
		MOV ECX, [EAX+4]
		XOR ECX, s_[7*4]
		MOV u_[1*4], ECX
		MOV EAX, s_[0*4]
		SHL EAX, 10h
		MOV ECX, m_
		XOR EAX, [ECX+8]
		MOV EDX, s_[0*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[0*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		MOV EDX, s_[1*4]
		AND EDX, 0FFFFh
		XOR EAX, EDX
		MOV ECX, s_[1*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[2*4]
		SHL EDX, 10h
		XOR EAX, EDX
		XOR EAX, s_[6*4]
		MOV ECX, s_[6*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[7*4]
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV u_[2*4], EAX
		MOV EAX, s_[0*4]
		AND EAX, 0FFFFh
		MOV ECX, m_
		XOR EAX, [ECX+0Ch]
		MOV EDX, s_[0*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[1*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		MOV EDX, s_[1*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[1*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[2*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[2*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[3*4]
		SHL EDX, 10h
		XOR EAX, EDX
		XOR EAX, s_[6*4]
		MOV ECX, s_[6*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[6*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		MOV EDX, s_[7*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV u_[3*4], EAX
		MOV EAX, s_[0*4]
		AND EAX, 0FFFF0000h
		MOV ECX, m_
		XOR EAX, [ECX+10h]
		MOV EDX, s_[0*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[0*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[1*4]
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, s_[1*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[2*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[2*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[3*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[3*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[4*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[6*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[6*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		MOV EDX, s_[7*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV u_[4*4], EAX
		MOV EAX, s_[0*4]
		SHL EAX, 10h
		MOV ECX, m_
		XOR EAX, [ECX+14h]
		MOV EDX, s_[0*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[0*4]
		AND ECX, 0FFFF0000h
		XOR EAX, ECX
		MOV EDX, s_[1*4]
		AND EDX, 0FFFFh
		XOR EAX, EDX
		XOR EAX, s_[2*4]
		MOV ECX, s_[2*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[3*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[3*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[4*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[4*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[5*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[6*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[6*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		AND ECX, 0FFFF0000h
		XOR EAX, ECX
		MOV EDX, s_[7*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV u_[5*4], EAX
		MOV EAX, m_
		MOV ECX, [EAX+18h]
		XOR ECX, s_[0*4]
		MOV EDX, s_[1*4]
		SHR EDX, 10h
		XOR ECX, EDX
		MOV EAX, s_[2*4]
		SHL EAX, 10h
		XOR ECX, EAX
		XOR ECX, s_[3*4]
		MOV EDX, s_[3*4]
		SHR EDX, 10h
		XOR ECX, EDX
		MOV EAX, s_[4*4]
		SHL EAX, 10h
		XOR ECX, EAX
		MOV EDX, s_[4*4]
		SHR EDX, 10h
		XOR ECX, EDX
		MOV EAX, s_[5*4]
		SHL EAX, 10h
		XOR ECX, EAX
		MOV EDX, s_[5*4]
		SHR EDX, 10h
		XOR ECX, EDX
		XOR ECX, s_[6*4]
		MOV EAX, s_[6*4]
		SHL EAX, 10h
		XOR ECX, EAX
		MOV EDX, s_[6*4]
		SHR EDX, 10h
		XOR ECX, EDX
		MOV EAX, s_[7*4]
		SHL EAX, 10h
		XOR ECX, EAX
		MOV u_[6*4], ECX
		MOV EAX, s_[0*4]
		AND EAX, 0FFFF0000h
		MOV ECX, m_
		XOR EAX, [ECX+1Ch]
		MOV EDX, s_[0*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[1*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		MOV EDX, s_[1*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[2*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[3*4]
		SHL EDX, 10h
		XOR EAX, EDX
		XOR EAX, s_[4*4]
		MOV ECX, s_[4*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[5*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[5*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, s_[6*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		MOV EDX, s_[7*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, s_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV u_[7*4], EAX
		MOV EAX, u_[1*4]
		SHL EAX, 10h
		MOV ECX, h_
		XOR EAX, [ECX]
		MOV EDX, u_
		SHR EDX, 10h
		XOR EAX, EDX
		MOV v_, EAX
		MOV EAX, u_[2*4]
		SHL EAX, 10h
		MOV ECX, h_
		XOR EAX, [ECX+4]
		MOV EDX, u_[1*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV v_[1*4], EAX
		MOV EAX, u_[3*4]
		SHL EAX, 10h
		MOV ECX, h_
		XOR EAX, [ECX+8]
		MOV EDX, u_[2*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV v_[2*4], EAX
		MOV EAX, u_[4*4]
		SHL EAX, 10h
		MOV ECX, h_
		XOR EAX, [ECX+0Ch]
		MOV EDX, u_[3*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV v_[3*4], EAX
		MOV EAX, u_[5*4]
		SHL EAX, 10h
		MOV ECX, h_
		XOR EAX, [ECX+10h]
		MOV EDX, u_[4*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV v_[4*4], EAX
		MOV EAX, u_[6*4]
		SHL EAX, 10h
		MOV ECX, h_
		XOR EAX, [ECX+14h]
		MOV EDX, u_[5*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV v_[5*4], EAX
		MOV EAX, u_[7*4]
		SHL EAX, 10h
		MOV ECX, h_
		XOR EAX, [ECX+18h]
		MOV EDX, u_[6*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV v_[6*4], EAX
		MOV EAX, u_
		AND EAX, 0FFFF0000h
		MOV ECX, h_
		XOR EAX, [ECX+1Ch]
		MOV EDX, u_
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, u_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, u_[1*4]
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, u_[1*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, u_[6*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, u_[7*4]
		AND ECX, 0FFFF0000h
		XOR EAX, ECX
		MOV v_[7*4], EAX
		MOV EAX, v_
		AND EAX, 0FFFF0000h
		MOV ECX, v_
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[1*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[1*4]
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, v_[2*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[3*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[4*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[5*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[5*4]
		MOV ECX, v_[6*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[7*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[7*4]
		AND EDX, 0FFFFh
		XOR EAX, EDX
		MOV ECX, h_
		MOV [ECX], EAX
		MOV EAX, v_
		SHL EAX, 10h
		MOV ECX, v_
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, v_[1*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		XOR EAX, v_[2*4]
		MOV EDX, v_[2*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[3*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[4*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[5*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[6*4]
		SHL EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[6*4]
		MOV ECX, v_[7*4]
		AND ECX, 0FFFF0000h
		XOR EAX, ECX
		MOV EDX, v_[7*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, h_
		MOV [ECX+4], EAX
		MOV EAX, v_
		AND EAX, 0FFFFh
		MOV ECX, v_
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[1*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[1*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[1*4]
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, v_[2*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[3*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[3*4]
		MOV ECX, v_[4*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[5*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[6*4]
		MOV ECX, v_[6*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[7*4]
		AND EDX, 0FFFFh
		XOR EAX, EDX
		MOV ECX, v_[7*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[7*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, h_
		MOV [ECX+8], EAX
		MOV EAX, v_
		SHL EAX, 10h
		MOV ECX, v_
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, v_[1*4]
		AND ECX, 0FFFF0000h
		XOR EAX, ECX
		MOV EDX, v_[1*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[2*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[2*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[2*4]
		MOV ECX, v_[3*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[4*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[4*4]
		MOV ECX, v_[5*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[6*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[7*4]
		AND ECX, 0FFFFh
		XOR EAX, ECX
		MOV EDX, v_[7*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, h_
		MOV [ECX+0Ch], EAX
		MOV EAX, v_
		SHR EAX, 10h
		MOV ECX, v_[1*4]
		SHL ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[1*4]
		MOV EDX, v_[2*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[2*4]
		MOV ECX, v_[3*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[3*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[3*4]
		MOV ECX, v_[4*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[5*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[5*4]
		MOV ECX, v_[6*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[6*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[7*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, h_
		MOV [EDX+10h], EAX
		MOV EAX, v_
		SHL EAX, 10h
		MOV ECX, v_
		AND ECX, 0FFFF0000h
		XOR EAX, ECX
		MOV EDX, v_[1*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[1*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[1*4]
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, v_[2*4]
		SHL ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[2*4]
		MOV EDX, v_[3*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[3*4]
		MOV ECX, v_[4*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[4*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[4*4]
		MOV ECX, v_[5*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[6*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[6*4]
		SHR ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[6*4]
		MOV EDX, v_[7*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[7*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[7*4]
		AND EDX, 0FFFF0000h
		XOR EAX, EDX
		MOV ECX, h_
		MOV [ECX+14h], EAX
		MOV EAX, v_
		XOR EAX, v_[2*4]
		MOV ECX, v_[2*4]
		SHR ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[3*4]
		MOV EDX, v_[3*4]
		SHL EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[4*4]
		MOV ECX, v_[4*4]
		SHR ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[5*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[5*4]
		SHR ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[5*4]
		MOV EDX, v_[6*4]
		SHL EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[6*4]
		SHR ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[6*4]
		MOV EDX, v_[7*4]
		SHL EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[7*4]
		MOV ECX, h_
		MOV [ECX+18h], EAX
		MOV EAX, v_
		SHR EAX, 10h
		XOR EAX, v_
		MOV ECX, v_[1*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[1*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[2*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[3*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[3*4]
		MOV ECX, v_[4*4]
		SHL ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[4*4]
		MOV EDX, v_[5*4]
		SHR EDX, 10h
		XOR EAX, EDX
		XOR EAX, v_[5*4]
		MOV ECX, v_[6*4]
		SHL ECX, 10h
		XOR EAX, ECX
		MOV EDX, v_[6*4]
		SHR EDX, 10h
		XOR EAX, EDX
		MOV ECX, v_[7*4]
		SHL ECX, 10h
		XOR EAX, ECX
		XOR EAX, v_[7*4]
		MOV EDX, h_
		MOV [EDX+01Ch], EAX	
		ret	
GOSTTransform2 endp
