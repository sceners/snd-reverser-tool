

.code

ReadFileToMemory proc
		invoke CreateFile, addr ScanFileName, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		.if eax == INVALID_HANDLE_VALUE
			invoke CloseHandle, eax
			xor eax, eax
		.else
			mov CryptoFile, eax
			invoke GetFileSize, eax, NULL
			mov CryptoSize, eax
			.if CryptoMem != 00h
				invoke GlobalFree, CryptoMem
			.endif
			invoke GlobalAlloc, GMEM_FIXED, CryptoSize
			mov CryptoMem, eax
			invoke ReadFile, CryptoFile, CryptoMem, CryptoSize, addr CryptoSizeF1, NULL
			mov eax, 01h
		.endif
		ret
ReadFileToMemory endp


CheckValidPEFile proc
		mov	edi, CryptoMem
		.if word ptr [edi] == "ZM"
			add	edi, dword ptr [edi+3ch]
			.if word ptr [edi] == "EP"
				mov eax, 01h
			.else
				mov eax, 00h
			.endif
		.else
			mov eax, 00h
		.endif
		ret
CheckValidPEFile endp


;##########################################################################################


CryptoSearchEngineSimple proc
	local count:dword
	local threadexit:dword

		mov scaningFlag, 01h
		mov	CryptoSimpleSig, 00h


		xor ecx, ecx
		assume edi:ptr SIG_DATA
	@reset_all_found_flags_loop:
		cmp ecx, numberOfSignatures
		je @finished_reset_all_found_flags
		mov	edi, [_nextSignature+ecx*4]
		mov eax, [edi].FoundBOOL
		mov dword ptr [eax], 00h
		inc ecx
		jmp @reset_all_found_flags_loop


	@finished_reset_all_found_flags:
		assume edi:nothing
		xor ecx, ecx
	@search_next_sig_loop:
		cmp ecx, numberOfSignatures
		je @finished_search
		mov	CryptoSimpleSig, 00h
		mov	edi, [_nextSignature+ecx*4]
		assume edi:ptr SIG_DATA
		call [edi].SearchAlgorithm
		assume edi:nothing
		inc ecx
		call RelevantProgressFunction
		jmp @search_next_sig_loop

	@finished_search:
		call FixResultDependencies								;resets 'FoundBOOL' on some sigs to ensure accurate reporting.

		xor ecx, ecx
	@print_next_loop:
		cmp ecx, numberOfSignatures
		je @finished_print
		mov	edi, [_nextSignature+ecx*4]
		assume edi:ptr SIG_DATA
		mov eax, [edi].FoundBOOL
		.if dword ptr [eax] == 01h
			call RelevantPrintFunction							;differs between the console version and the plugin/other versions
		.endif
		assume edi:nothing
		inc ecx
		jmp @print_next_loop


	@finished_print:
		mov scaningFlag, 00h
		ret
CryptoSearchEngineSimple endp


;##########################################################################################


FixResultDependencies proc
		pushad

		.if MD5_FoundBool == 01h
			mov MD5M_FoundBool, 00h				;verified
		.endif

		.if	SHA1_FoundBool == 01h
			mov MD4_FoundBool, 00h				;verified
			mov SHA1M_FoundBool, 00h			;verified
		.endif

		.if	SHA512_FoundBool == 01h
			mov SHA224_FoundBool, 00h			;?????????????????????????
			mov SHA256_FoundBool, 00h			;verified
			mov SHA256M_FoundBool, 00h			;verified
			mov SHA384512M_FB, 00h				;verified
		.endif

		.if	SHA384_FoundBool == 01h
			mov SHA384512M_FB, 00h				;verified
		.endif

		.if	SHA384512M_FB == 01h
			mov SHA224_FoundBool, 00h			;?????????????????????????
			mov SHA256_FoundBool, 00h			;verified
			mov SHA256M_FoundBool, 00h			;verified
		.endif

		.if	SHA256_FoundBool == 01h
			mov SHA224_FoundBool, 00h			;?????????????????????????
			mov SHA256M_FoundBool, 00h			;verified
		.endif

		.if	RIPEMD320_FoundBool == 01h
			mov RIPEMD128_FoundBool, 00h		;verified
			mov RIPEMD160_FoundBool, 00h		;verified
			mov RIPEMD256_FoundBool, 00h		;verified
		.endif

		.if	RIPEMD256_FoundBool == 01h
			mov RIPEMD128_FoundBool, 00h		;verified
		.endif

		.if	RIPEMD160_FoundBool == 01h
			mov RIPEMD128_FoundBool, 00h		;verified
		.endif

		
		.if	CAST_FoundBool == 01h
			mov CASTM_FoundBool, 00h
		.endif

		.if	RIJNDAEL2_FoundBool == 01h
			mov RIJNDAEL3_FoundBool, 00h
		.endif

		.if	GOST1_FoundBool == 01h
			mov GOST2_FoundBool, 00h
			mov GOST3_FoundBool, 00h
			mov GOST4_FoundBool, 00h
		.endif

		.if	GOST2_FoundBool == 01h
			mov GOST3_FoundBool, 00h
			mov GOST4_FoundBool, 00h
		.endif

		.if	GOST3_FoundBool == 01h
			mov GOST4_FoundBool, 00h
		.endif

		.if	TWOFISH1_FoundBool == 01h
			mov TWOFISH2_FoundBool, 00h
		.endif

		.if	MARS1_FoundBool == 01h
			mov MARS2_FoundBool, 00h
		.endif

		.if	SAFER1_FoundBool == 01h
			mov SAFER2_FoundBool, 00h
		.endif

		.if	TLBRSA1_FoundBool == 01h
			mov TLBRSA2_FoundBool, 00h
		.endif

		.if	LOKI_FoundBool == 01h
			mov TEA2_FoundBool, 00h
		.endif

		.if	TEA1_FoundBool == 01h
			mov TEA2_FoundBool, 00h
		.endif
		
		popad
		ret
FixResultDependencies endp


;##########################################################################################


SearchEngine_DWORD proc uses ecx
	local _SigLength:dword
	local _SigName:dword

		assume edi:ptr SIG_DATA
		push dword ptr [edi].SignatureLength	
		pop _SigLength
		push dword ptr [edi].CryptoName
		pop _SigName
		mov	esi, [edi].Signature

		xor edx, edx
		.while edx != [_SigLength]
			movsx eax, byte ptr [esi+edx*4+3]
			push eax
			push dword ptr [esi+edx*4]
			push CryptoMem
			call dwordc

			mov	eax, CryptoSize
			sub	eax, ecx
			sub	eax, 4
			mov	esi, [edi].FoundOffsets
			mov dword ptr [esi+edx*4], eax
			mov	esi, [edi].Signature
			inc	edx
		.endw

		mov eax, [_SigLength]
		.if	CryptoSimpleSig == eax
			mov eax, [edi].FoundBOOL
			mov dword ptr [eax], 01h
		.endif

		assume edi:nothing
		ret
SearchEngine_DWORD endp



SearchEngine_BYTES proc uses ecx
	local _SigLength:dword
	local _SigName:dword

		assume edi:ptr SIG_DATA
		push dword ptr [edi].SignatureLength	
		pop _SigLength
		push dword ptr [edi].CryptoName
		pop _SigName
		mov	esi, [edi].Signature

		mov eax, [edi].SignatureLength
		push eax
		push dword ptr [esi]
		push esi
		push CryptoMem
		call bytec

		mov	ecx, CryptoMem
		sub	eax, ecx
		sub	eax, 1
		mov	esi, [edi].FoundOffsets
		mov dword ptr [esi], eax

		.if	CryptoSimpleSig == 1
			mov eax, [edi].FoundBOOL
			mov dword ptr [eax], 01h
		.endif
		ret
SearchEngine_BYTES endp


;##########################################################################################


dwordc proc uses edi address:dword, _Comparedword:dword, CompareAL:dword
		mov	ecx, CryptoSize
		mov	edi, address
		mov	ebx, _Comparedword
		mov	al, byte ptr CompareAL
	@Check:
		repnz scasb
		cmp	ecx, 0
		jz	@Check1
		cmp	dword ptr [edi-4], ebx
		jnz	@Check
		inc	CryptoSimpleSig
	@Check1:
		ret
dwordc endp


;##########################################################################################


bytec proc uses edi _ScanAddress:dword, _Signature:dword, _CompareAL:dword, _SignatureSize:dword

		mov	ecx, CryptoSize
		mov	edi, _ScanAddress
	@find_next_byte_match:
		mov	al, byte ptr _CompareAL
		repnz scasb
		cmp	ecx, 0
		je	@finished_searching
		push ecx
		push edi
		dec	edi
		mov	ecx, _SignatureSize
		mov	esi, _Signature

	@check_next_byte:
		cmp ecx, 00h
		jne @not_end_of_signature
		inc	CryptoSimpleSig
		pop edi
		pop ecx
		jmp	@finished_searching
	@not_end_of_signature:
		mov	al, byte ptr [edi]
		cmp	al, byte ptr [esi]
		jne	@not_correct_signature
		inc	edi
		inc	esi
		dec ecx
		jmp @check_next_byte

	@not_correct_signature:
		pop edi
		pop ecx
		jmp	@find_next_byte_match

	@finished_searching:
		mov eax, edi
		ret
bytec endp

;##########################################################################################


