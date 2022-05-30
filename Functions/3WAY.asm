comment		*

Algorithm		: 3-way	( Block Cipher )
Block		: 12 bytes
KeySize		: 96 bits ( 12 bytes )

Usage		: invoke	_3way_enrypt,ptrInkey,addr ptrIndata,addr ptrOutdata 	( key,data to encrypt,output  : 12 bytes Keysize, 12 bytes Indata Encrypt )
		  invoke	_3way_derypt,ptrInkey,addr ptrIndata,addr ptrOutdata 	( key,data to encrypt,output  : 12 bytes Keysize, 12 bytes Indata decrypt )
		  
Coded by x3chun	( 2004.06.10 ) 
		( x3chun@korea.com  or  x3chun@hanyang.ac.kr )  ( http://x3chun.ce.ro )
		
comment		*

rndcon_gen	macro	strt,rtab

		local	@_r1,@_r2
		
		mov	eax,strt
@_r2:
		mov	[rtab+ecx*4],eax
		shl	eax,1
		test	eax,10000h
		jz	@_r1
		xor	eax,11011h
@_r1:
		inc	ecx
		cmp	ecx,NMBR
		jle	@_r2
			
endm

theta		macro	a

		mov	eax, [a+8]
		mov	ecx, [a+4]
		mov	edx, [a+0]
		mov	esi, ecx
		mov	edi, edx
		xor	esi, eax
		mov	ebx, ecx
		shl	edi, 8
		shr	esi, 8
		xor	edi, edx
		xor	esi, edx
		xor	edi, ecx
		xor	esi, ecx
		xor	edi, eax
		xor	esi, eax
		shl	edi, 8
		shr	esi, 8
		xor	edi, edx
		xor	esi, eax
		xor	edi, eax
		mov	ebp, eax
		shr	esi, 8
		shl	edi, 8
		xor	esi, edi
		mov	edi, edx
		xor	edi, eax
		xor	esi, edx
		shl	ebx, 8
		shr	edi, 8
		xor	ebx, edx
		xor	edi, edx
		xor	ebx, ecx
		xor	edi, ecx
		xor	ebx, eax
		xor	edi, eax
		shl	ebx, 8
		shr	edi, 8
		xor	ebx, edx
		xor	edi, edx
		xor	ebx, ecx
		shr	edi, 8
		shl	ebx, 8
		xor	edi, ebx
		mov	ebx, edx
		xor	ebx, ecx
		xor	edi, ecx
		shl	ebp, 8
		shr	ebx, 8
		xor	ebp, edx
		xor	ebx, edx
		xor	ebp, ecx
		xor	ebx, ecx
		xor	ebp, eax
		xor	ebx, eax
		shl	ebp, 8
		shr	ebx, 8
		xor	ebp, ecx
		xor	ebx, ecx
		xor	ebp, eax
		shr	ebx, 8
		shl	ebp, 8
		xor	ebx, ebp
		xor	ebx, eax
		mov	[a+0], esi
		mov	[a+4], edi
		mov	[a+8], ebx
			
endm

pi_1		macro	a

		mov	eax,[a+0]
		shr	eax,10
		shl	dword ptr [a+0],22
		xor	[a+0],eax
		mov	eax,[a+8]
		shl	eax,1
		shr	dword ptr [a+8],31
		xor	[a+8],eax

endm

pi_2		macro	a

		mov	eax,[a+0]
		shl	eax,1
		shr	dword ptr [a+0],31
		xor	[a+0],eax
		mov	eax,[a+8]
		shr	eax,10
		shl	dword ptr [a+8],22
		xor	[a+8],eax
		
endm

mu		macro	a

		local	@_r1,@_r2,@_r3,@_r4
		
		xor	eax,eax		; b[0]
		xor	ebx,ebx		; b[1]
		xor	ecx,ecx		; b[2]
		mov	edx,32
@_r4:
		shl	eax,1
		shl	ebx,1
		shl	ecx,1
		test	byte ptr [a],1
		jz	@_r1
		or	ecx,1
@_r1:
		test	byte ptr [a+4],1
		jz	@_r2
		or	ebx,1
@_r2:
		test	byte ptr [a+8],1
		jz	@_r3
		or	eax,1
@_r3:
		shr	dword ptr [a+0],1
		shr	dword ptr [a+4],1
		shr	dword ptr [a+8],1
		dec	edx
		jnz	@_r4
		mov	[a+0],eax
		mov	[a+4],ebx
		mov	[a+8],ecx
endm

_gamma		macro	a,register,x,y,z

		mov	register,[a+z]
		not	register
		or	register,[a+y]
		xor	register,[a+x]
		
endm

gamma		macro	a

		_gamma	a,eax,0,4,8
		_gamma	a,ebx,4,8,0
		_gamma	a,ecx,8,0,4
		
endm
		
rho		macro	a

		theta	a
		pi_1	a
		gamma	a
		mov	[esp+0],eax
		mov	[esp+4],ebx
		mov	[esp+8],ecx
		pi_2	a
		
endm

_3way_encrypt	proto	:DWORD, :DWORD, :DWORD
_3way_decrypt	proto	:DWORD, :DWORD, :DWORD

.const

NMBR		equ	11
STRT_E		equ	0b0bh
STRT_D		equ	0b1b1h

.data?

_rcon		dd	NMBR+1	dup(?)
_ki		dd	3h	dup(?)
_3esp		dd	?
_loop3way	dd	?
_k		dd	?

.code

_3way_encrypt	proc	ptrInkey:DWORD, ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	_3esp,esp
		mov	esi,[esp+2ch]
		mov	edi,[esp+30h]
		mov	edx,edi
		mov	ecx,12
		cld
		rep	movsb
		rndcon_gen STRT_E,_rcon
		xor	ecx,ecx		; i
		mov	_loop3way,ecx	; count
		mov	esi,[esp+28h]	; ptrInkey
		mov	esp,edx
		mov	_k,esi
@_r1:
		mov	edi,_k
		mov	ecx,_loop3way
		mov	eax,[_rcon+ecx*4]
		shl	eax,16
		xor	eax,[edi]
		xor	[esp],eax
		mov	eax,[edi+4]
		xor	[esp+4],eax
		mov	eax,[_rcon+ecx*4]
		xor	eax,[edi+8]
		xor	[esp+8],eax
		rho	esp
		inc	_loop3way
		cmp	_loop3way,NMBR
		jl	@_r1
		mov	edi,_k
		mov	eax,[_rcon+NMBR*4]
		shl	eax,16
		xor	eax,[edi]
		xor	[esp],eax
		mov	eax,[edi+4]
		xor	[esp+4],eax
		mov	eax,[_rcon+NMBR*4]
		xor	eax,[edi+8]
		xor	[esp+8],eax
		theta	esp
		mov	esp,_3esp
		popad
		ret
		
_3way_encrypt	endp

_3way_decrypt	proc	ptrInkey:DWORD, ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		mov	_3esp,esp
		mov	esi,[esp+28h]	; ptrInkey
		mov	edi,offset _ki
		mov	ecx,12
		cld
		rep	movsb
		mov	esi,[esp+2ch]	; ptrIndata
		mov	edi,[esp+30h]	; ptrOutdata
		mov	esp,edi
		mov	ecx,12
		cld	
		rep	movsb
		theta	_ki
		mu	_ki
		xor	ecx,ecx
		rndcon_gen STRT_D,_rcon
		mu	esp
		xor	ecx,ecx		; i
		mov	_loop3way,ecx	; count
@_r1:
		mov	edi,offset _ki
		mov	ecx,_loop3way
		mov	eax,[_rcon+ecx*4]
		shl	eax,16
		xor	eax,[edi]
		xor	[esp],eax
		mov	eax,[edi+4]
		xor	[esp+4],eax
		mov	eax,[_rcon+ecx*4]
		xor	eax,[edi+8]
		xor	[esp+8],eax
		rho	esp
		inc	_loop3way
		cmp	_loop3way,NMBR
		jl	@_r1
		mov	edi,offset _ki
		mov	eax,[_rcon+NMBR*4]
		shl	eax,16
		xor	eax,[edi]
		xor	[esp],eax
		mov	eax,[edi+4]
		xor	[esp+4],eax
		mov	eax,[_rcon+NMBR*4]
		xor	eax,[edi+8]
		xor	[esp+8],eax
		theta	esp
		mu	esp
		mov	esp,_3esp
		popad
		ret
		
_3way_decrypt	endp



_3WAY_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 24)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen132
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE	
			
			
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
			invoke RtlZeroMemory,offset bf_encryptbuf,sizeof bf_encryptbuf-1
		
			mov	esi,_Input
			mov	ebx,_len
			;part into multiples of 8
	EncryptLoop:
			push	esi	;source
			mov	eax,ebx	;length
			
			mov	ecx,12
			xor	edx,edx
			div	ecx
			.if	eax == 0
				mov	eax,edx
			.else
				mov	eax,12
			.endif
			push	eax
			push	esi
			
			Call Bit12Prepare
			
			.if bCipherMode == 1
				push	12
				push	offset bf_encryptbuf
				call	CipherXor
			.endif
			pushad
			INVOKE _3way_encrypt,offset sKeyIn,offset bf_encryptbuf,offset bf_tempbuf
			;convert output to hex string
			mov	eax,dword ptr[bf_tempbuf]
			mov	edx,dword ptr[bf_tempbuf+4]
			bswap	eax
			bswap	edx
			mov	ebx,dword ptr[bf_tempbuf+8]
			bswap	ebx
			
			invoke wsprintf,addr bf_tempbufout,addr hex192bit,eax,edx,ebx
			invoke	lstrcat,_Output,addr bf_tempbufout
			popad
			pop	esi
			add	esi,12
			sub	ebx,12
			
			cmp	ebx,0
			jg	EncryptLoop
		
			INVOKE lstrlen,_Output
			HexLen
		.ENDIF
		ret
_3WAY_ENC_RT endp
_3WAY_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 24)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen132
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			
			
		mov bPassedRound,0
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,24
		xor	edx,edx
		div	ecx
		cmp	edx,0
		jne	@inputError
		invoke RtlZeroMemory,offset bf_decryptbuf,sizeof bf_decryptbuf-1
		;convert hex to chars
		push	_len
		push	offset bf_decryptbuf
		push	_Input
		call	HEX2CHR_RT
		mov	ebx,eax	;length
		.if	eax != -1 ; all chars are ok

		mov	esi,offset bf_decryptbuf
		mov	edi,_Output	;destination
		
		;now we do similar as encryption
	DecryptLoop:
			push	esi	
			push	12	;length
			push	esi
			call	Bit12Prepare
			
		
			INVOKE _3way_decrypt,offset sKeyIn,offset bf_encryptbuf,offset bf_tempbuf
			
			DecryptEnd 12
			mov	eax,dword ptr[esi]
			mov	edx,dword ptr[esi+4]
			
			mov	dword ptr[edi+4*0],eax
			mov	dword ptr[edi+4*1],edx
			mov	eax,dword ptr[esi+8]
			mov	dword ptr[edi+4*2],eax
			
			
			add	edi,12
			pop	esi
			add	esi,12
			sub	ebx,12
	
			cmp	ebx,0
			jg	DecryptLoop
			;now we need to clean it up :)
		
		INVOKE lstrlen,_Output
		mov	edi,_Output
		movzx	ebx,byte ptr[edi+eax-1];get last char
		.if	ebx < 12	;padding chars are 1-8
			sub	eax,ebx	;fix up length 
			mov	byte ptr[edi+eax],0	;clear it up :)
		.endif
		.elseif
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgHex
		mov	eax,FALSE
		.endif
		
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sError128b
		mov eax, FALSE		
	@endGenerate:
		.ENDIF
		ret
_3WAY_DEC_RT endp

