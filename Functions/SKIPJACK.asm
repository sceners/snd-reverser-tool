comment		*

Algorithm		: Skipjack
Block		: 8bytes
KeySize		: keylen<=10

Usage		: invoke	skipjack_setkey,addr ptrInkey,ptrInkey_length	( ptrInkey_length<=10 )
		  invoke	skipjack_encrypt,addr ptrIndata,addr ptrOutdata  ( 8bytes Encrypt )
		  invoke	skipjack_decrypt,addr ptrIndata,addr ptrOutdata  ( 8bytes Decrypt )
		  
Coded by x3chun	(2004.06.xx)
		( x3chun@korea.com  or  x3chun@hanyang.ac.kr )  ( http://x3chun.ce.ro )
		
comment		*

g0		macro	w

		_g	w,0,1,2,3
		
endm

g1		macro	w	

		_g	w,4,5,6,7
		
endm

g2		macro	w

		_g	w,8,9,0,1
		
endm

g3		macro	w

		_g	w,2,3,4,5
		
endm

g4		macro	w

		_g	w,6,7,8,9
		
endm

h0		macro	w
	
		_h	w,0,1,2,3
		
endm

h1		macro	w

		_h	w,4,5,6,7
		
endm

h2		macro	w

		_h	w,8,9,0,1
		
endm

h3		macro	w

		_h	w,2,3,4,5
		
endm

h4		macro	w

		_h	w,6,7,8,9
		
endm

_g		macro	w,i,j,k,l

		xor	ax,ax
		mov	bp,w		; w
		and	bp,0FFh
		mov	ah,[skipjacktab+i*256+ebp]
		xor	w,ax
		mov	bp,w
		xor	ax,ax
		shr	bp,8
		mov	al,[skipjacktab+j*256+ebp]
		xor	w,ax
		mov	bp,w
		xor	ax,ax
		and	bp,0FFh
		mov	ah,[skipjacktab+k*256+ebp]
		xor	w,ax
		mov	bp,w
		xor	ax,ax
		shr	bp,8
		mov	al,[skipjacktab+l*256+ebp]
		xor	w,ax
	
endm

_h		macro	w,i,j,k,l

		xor	ax,ax
		mov	bp,w		; w
		shr	bp,8
		mov	al,[skipjacktab+l*256+ebp]
		xor	w,ax
		mov	bp,w
		xor	ax,ax
		and	bp,0FFh
		mov	ah,[skipjacktab+k*256+ebp]
		xor	w,ax
		mov	bp,w
		xor	ax,ax
		shr	bp,8
		mov	al,[skipjacktab+j*256+ebp]
		xor	w,ax
		mov	bp,w
		xor	ax,ax
		and	bp,0FFh
		mov	ah,[skipjacktab+i*256+ebp]
		xor	w,ax
	
endm

_xor		macro	a,b,c	; w4^=w1^1 -> w4,w1,1

		mov	bp,b
		xor	a,bp
		xor	a,c
		
endm

skipjack_setkey		proto	:DWORD,:BYTE
skipjack_encrypt	proto	:DWORD,:DWORD
skipjack_decrypt	proto	:DWORD,:DWORD

.const

w1		equ	word ptr [edi]
w2		equ	word ptr [edi+2]
w3		equ	word ptr [edi+4]
w4		equ	word ptr [edi+6]

.data

fTable		db	0a3h,0d7h,009h,083h,0f8h,048h,0f6h,0f4h,0b3h,021h,015h,078h,099h,0b1h,0afh,0f9h
		db	0e7h,02dh,04dh,08ah,0ceh,04ch,0cah,02eh,052h,095h,0d9h,01eh,04eh,038h,044h,028h
		db	00ah,0dfh,002h,0a0h,017h,0f1h,060h,068h,012h,0b7h,07ah,0c3h,0e9h,0fah,03dh,053h
		db	096h,084h,06bh,0bah,0f2h,063h,09ah,019h,07ch,0aeh,0e5h,0f5h,0f7h,016h,06ah,0a2h
		db	039h,0b6h,07bh,00fh,0c1h,093h,081h,01bh,0eeh,0b4h,01ah,0eah,0d0h,091h,02fh,0b8h
		db	055h,0b9h,0dah,085h,03fh,041h,0bfh,0e0h,05ah,058h,080h,05fh,066h,00bh,0d8h,090h
		db	035h,0d5h,0c0h,0a7h,033h,006h,065h,069h,045h,000h,094h,056h,06dh,098h,09bh,076h
		db	097h,0fch,0b2h,0c2h,0b0h,0feh,0dbh,020h,0e1h,0ebh,0d6h,0e4h,0ddh,047h,04ah,01dh
		db	042h,0edh,09eh,06eh,049h,03ch,0cdh,043h,027h,0d2h,007h,0d4h,0deh,0c7h,067h,018h
		db	089h,0cbh,030h,01fh,08dh,0c6h,08fh,0aah,0c8h,074h,0dch,0c9h,05dh,05ch,031h,0a4h
		db	070h,088h,061h,02ch,09fh,00dh,02bh,087h,050h,082h,054h,064h,026h,07dh,003h,040h
		db	034h,04bh,01ch,073h,0d1h,0c4h,0fdh,03bh,0cch,0fbh,07fh,0abh,0e6h,03eh,05bh,0a5h
		db	0adh,004h,023h,09ch,014h,051h,022h,0f0h,029h,079h,071h,07eh,0ffh,08ch,00eh,0e2h
		db	00ch,0efh,0bch,072h,075h,06fh,037h,0a1h,0ech,0d3h,08eh,062h,08bh,086h,010h,0e8h
		db	008h,077h,011h,0beh,092h,04fh,024h,0c5h,032h,036h,09dh,0cfh,0f3h,0a6h,0bbh,0ach
		db	05eh,06ch,0a9h,013h,057h,025h,0b5h,0e3h,0bdh,0a8h,03ah,001h,005h,059h,02ah,046h
		
.data?

skipjacktab	db	256*10	dup(?)

.code

skipjack_setkey	proc	ptrInkey:DWORD, ptrInkey_length:BYTE

		pushad
		invoke RtlZeroMemory,offset skipjacktab,sizeof skipjacktab-1
		
		mov	esi,[esp+28h]	; ptrInkey
		mov	edi,offset skipjacktab
		mov	ebx,offset fTable
		mov	ch,[esp+2ch]	; ptrInkey_length
@_r2:
		xor	edx,edx	; c
		lodsb
		mov	cl,al
@_r1:
		mov	al,cl
		xor	al,dl
		xlat
		stosb
		inc	edx
		cmp	edx,100h
		jl	@_r1
		dec	ch
		jnz	@_r2	
		popad
		ret
		
skipjack_setkey	endp

skipjack_encrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		xor	ebx,ebx
		xor	ebp,ebp
		mov	esi,[esp+28h]
		mov	edi,[esp+2ch]
		mov	eax,dword ptr[esi]
		mov	ebx,dword ptr[esi+4]
		rol	eax,10h
		bswap	eax
		rol	ebx,10h
		bswap	ebx
		mov	dword ptr[edi],eax
		mov	dword ptr[edi+4],ebx
		g0	w1
		_xor	w4,w1,1
		g1	w4
		_xor	w3,w4,2
		g2	w3
		_xor	w2,w3,3
		g3	w2
		_xor	w1,w2,4
		g4	w1
		_xor	w4,w1,5
		g0	w4
		_xor	w3,w4,6
		g1	w3
		_xor	w2,w3,7
		g2	w2
		_xor	w1,w2,8
		_xor	w2,w1,9
		g3	w1
		_xor	w1,w4,10
		g4	w4
		_xor	w4,w3,11
		g0	w3
		_xor	w3,w2,12
		g1	w2
		_xor	w2,w1,13
		g2	w1
		_xor	w1,w4,14
		g3	w4
		_xor	w4,w3,15
		g4	w3
		_xor	w3,w2,16
		g0	w2
		g1	w1
		_xor	w4,w1,17
		g2	w4
		_xor	w3,w4,18
		g3	w3
		_xor	w2,w3,19
		g4	w2
		_xor	w1,w2,20
		g0	w1
		_xor	w4,w1,21
		g1	w4
		_xor	w3,w4,22
		g2	w3
		_xor	w2,w3,23
		g3	w2
		_xor	w1,w2,24
		_xor	w2,w1,25
		g4	w1
		_xor	w1,w4,26
		g0	w4
		_xor	w4,w3,27
		g1	w3
		_xor	w3,w2,28
		g2	w2
		_xor	w2,w1,29
		g3	w1
		_xor	w1,w4,30
		g4	w4
		_xor	w4,w3,31
		g0	w3
		_xor	w3,w2,32
		g1	w2
		mov	eax,dword ptr[edi]
		mov	ebx,dword ptr[edi+4]
		rol	eax,10h
		bswap	eax
		rol	ebx,10h
		bswap	ebx
		mov	dword ptr[edi],eax
		mov	dword ptr[edi+4],ebx	
		popad
		ret
		
skipjack_encrypt	endp

skipjack_decrypt	proc	ptrIndata:DWORD, ptrOutdata:DWORD

		pushad
		xor	ebx,ebx
		xor	ebp,ebp
		mov	esi,[esp+28h]
		mov	edi,[esp+2ch]
		mov	eax,dword ptr[esi]
		mov	ebx,dword ptr[esi+4]
		rol	eax,10h
		bswap	eax
		rol	ebx,10h
		bswap	ebx
		mov	dword ptr[edi],eax
		mov	dword ptr[edi+4],ebx
		h1	w2
		_xor	w3,w2,32
		h0	w3
		_xor	w4,w3,31
		h4	w4
		_xor	w1,w4,30
		h3	w1
		_xor	w2,w1,29
		h2	w2
		_xor	w3,w2,28
		h1	w3
		_xor	w4,w3,27
		h0	w4
		_xor	w1,w4,26
		h4	w1
		_xor	w2,w1,25
		_xor	w1,w2,24
		h3	w2
		_xor	w2,w3,23
		h2	w3
		_xor	w3,w4,22
		h1	w4
		_xor	w4,w1,21
		h0	w1
		_xor	w1,w2,20
		h4	w2
		_xor	w2,w3,19
		h3	w3
		_xor	w3,w4,18
		h2	w4
		_xor	w4,w1,17
		h1	w1	
		h0	w2
		_xor	w3,w2,16
		h4	w3
		_xor	w4,w3,15
		h3	w4
		_xor	w1,w4,14
		h2	w1
		_xor	w2,w1,13
		h1	w2
		_xor	w3,w2,12
		h0	w3
		_xor	w4,w3,11
		h4	w4
		_xor	w1,w4,10
		h3	w1
		_xor	w2,w1,9	
		_xor	w1,w2,8
		h2	w2
		_xor	w2,w3,7
		h1	w3
		_xor	w3,w4,6
		h0	w4
		_xor	w4,w1,5
		h4	w1
		_xor	w1,w2,4
		h3	w2
		_xor	w2,w3,3
		h2	w3
		_xor	w3,w4,2
		h1	w4
		_xor	w4,w1,1
		h0	w1
		mov	eax,dword ptr[edi]
		mov	ebx,dword ptr[edi+4]
		rol	eax,10h
		bswap	eax
		rol	ebx,10h
		bswap	ebx
		mov	dword ptr[edi],eax
		mov	dword ptr[edi+4],ebx
		popad
		ret
		
skipjack_decrypt	endp
SKIPJACK_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 10)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen110
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			INVOKE skipjack_setkey,addr sKeyIn,al
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
		
			mov	esi,_Input
			mov	ebx,_len
			;part into multiples of 8
	EncryptLoop:
			push	esi	;source
			mov	eax,ebx	;length
			
			mov	ecx,8
			xor	edx,edx
			div	ecx
			.if	eax == 0
				mov	eax,edx
			.else
				mov	eax,8
			.endif
			push	eax
			push	esi
			
			Call Bit8Prepare
			
			.if bCipherMode == 1
				push	8
				push	offset bf_encryptbuf
				call	CipherXor
			.endif
			INVOKE skipjack_encrypt,offset bf_encryptbuf,offset bf_tempbuf
			;convert output to hex string
			mov	eax,dword ptr[bf_tempbuf]
			mov	edx,dword ptr[bf_tempbuf+4]
			bswap	eax
			bswap	edx

			invoke wsprintf,addr bf_tempbufout,addr sFormat_2,eax,edx
			invoke	lstrcat,_Output,addr bf_tempbufout
			pop	esi
			add	esi,8
			sub	ebx,8
			
			cmp	ebx,0
			jg	EncryptLoop
			INVOKE lstrlen,_Output
			HexLen
		.ENDIF
		ret
SKIPJACK_ENC_RT endp
SKIPJACK_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 10)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen110
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
		INVOKE skipjack_setkey,addr sKeyIn,al
		mov bPassedRound,0
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,16
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
			
			push	8	;length
			push	esi
			call	Bit8Prepare
			
		
			INVOKE skipjack_decrypt,offset bf_encryptbuf,offset bf_tempbuf
			DecryptEnd 8
			mov	eax,dword ptr[esi]
			mov	edx,dword ptr[esi+4]
			
			mov	dword ptr[edi+4*0],eax
			mov	dword ptr[edi+4*1],edx
			add	edi,8
			pop	esi
			add	esi,8
			sub	ebx,8
			
			cmp	ebx,0
			jg	DecryptLoop
			INVOKE lstrlen,_Output
		.if bPadInput
			;now we need to clean it up :)
		
		mov	edi,_Output

		movzx	ebx,byte ptr[edi+eax-1];get last char
		.if	ebx < 8	;padding chars are 1-8
			sub	eax,ebx	;fix up length 
			mov	byte ptr[edi+eax],0	;clear it up :)
		.endif
		.endif
		.elseif
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sErrorMsgHex
		mov	eax,FALSE
		.endif
		
		jmp @endGenerate
	@inputError:
		invoke SetDlgItemText, hWindow, IDC_INFO, addr sError64b
		mov eax, FALSE		
	@endGenerate:
		.ENDIF
		ret
SKIPJACK_DEC_RT endp

