
.data
sDATA			db 20h dup(0)
szFrmt			db '%.8x',0
sznumber1		db 40h dup(0)
szMDBUFF		db 20h dup(0)
padding24		db	16 dup(-1)
			db	01h, 15 dup(-1)
			db	02h, 02h, 14 dup(-1)
			db	03h, 03h, 03h, 13 dup(-1)
			db	04h, 04h, 04h, 04h, 12 dup(-1)
			db	05h, 05h, 05h, 05h, 05h, 11 dup(-1)
			db	06h, 06h, 06h, 06h, 06h, 06h, 10 dup(-1)
			db	07h, 07h, 07h, 07h, 07h ,07h, 07h, 9 dup(-1)
			db	08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 8 dup(-1)
			db	09h, 09h, 09h, 09h, 09h, 09h, 09h, 09h, 09h, 7 dup(-1)
			db	0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 6 dup(-1)
			db	0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 5 dup(-1)
			db	0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 4 dup(-1)
			db	0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 3 dup(-1)
			db	0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 2 dup(-1)
			db	0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 1 dup(-1)
			db	10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h, 10h

md2_s			db 41, 46, 67, 201, 162, 216, 124, 1, 61, 54, 84, 161, 236, 240, 6
			db 19, 98, 167, 5, 243, 192, 199, 115, 140, 152, 147, 43, 217, 188
			db 76, 130, 202, 30, 155, 87, 60, 253, 212, 224, 22, 103, 66, 111, 24
			db 138, 23, 229, 18, 190, 78, 196, 214, 218, 158, 222, 73, 160, 251
			db 245, 142, 187, 47, 238, 122, 169, 104, 121, 145, 21, 178, 7, 63
			db 148, 194, 16, 137, 11, 34, 95, 33, 128, 127, 93, 154, 90, 144, 50
			db 39, 53, 62, 204, 231, 191, 247, 151, 3, 255, 25, 48, 179, 72, 165
			db 181, 209, 215, 94, 146, 42, 172, 86, 170, 198, 79, 184, 56, 210
			db 150, 164, 125, 182, 118, 252, 107, 226, 156, 116, 4, 241, 69, 157
			db 112, 89, 100, 113, 135, 32, 134, 91, 207, 101, 230, 45, 168, 2, 27
			db 96, 37, 173, 174, 176, 185, 246, 28, 70, 97, 105, 52, 64, 126, 15
			db 85, 71, 163, 35, 221, 81, 175, 58, 195, 92, 249, 206, 186, 197
			db 234, 38, 44, 83, 13, 110, 133, 40, 132, 9, 211, 223, 205, 244, 65
			db 129, 77, 82, 106, 220, 55, 200, 108, 193, 171, 250, 36, 225, 123
			db 8, 12, 189, 177, 74, 120, 136, 149, 139, 227, 99, 232, 109, 233
			db 203, 213, 254, 59, 0, 29, 57, 242, 239, 183, 14, 102, 88, 208, 228
			db 166, 119, 114, 248, 235, 117, 75, 10, 49, 68, 80, 180, 143, 237
			db 31, 26, 219, 153, 141, 51, 159, 17, 131, 20	;/* 256 bytes */

.data?
lastblock24		db 16 dup(?)	;will contain the last bytes of buffer + padding
md2_x			db 48 dup(?)
md2_checksum		db 16 dup(?)
md2_state		db 16 dup(?)
md2_nbloop		dd ?	


.code

;***************************************************************************************
;Start MD2 Handler functions
;***************************************************************************************

MD2_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword
		cmp brutingFlag, 01h
		je @skip_key_disable
		call DisableKeyEdit
	@skip_key_disable:
		push [_len]
		push _Input
		call MD2
		invoke	wsprintf,_Output, addr strFormat, _Input
		HexLen
        ret
MD2_RT endp



;***************************************************************************************
;Start MD2 functions
;***************************************************************************************

MD2_Transform	proc

	;/* Copy block and state (into X) */
	FOR i, <0, 4, 8, 12>
	mov	eax, dword ptr [edi+i]
	mov	ecx, dword ptr [md2_state+i]
	mov	dword ptr [md2_x+i+16], eax
	mov	dword ptr [md2_x+i], ecx
	ENDM

	;/* Fill the last 16 chars of X */
	FOR i, <0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15>
	movzx	eax, byte ptr [md2_x+i+16]
	xor	al, byte ptr [md2_x+i]
	mov	byte ptr [md2_x+i+32], al
	ENDM

	;/* Do 18 rounds. */	
	xor	edx, edx		;/* t */
	FOR i, <0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17>
	  FOR j, <0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47>
	  mov	al, byte ptr [md2_x+j]
	  xor	al, byte ptr [md2_s+edx]
	  movzx	edx, al
	  mov	byte ptr [md2_x+j], al
	  ENDM
	add	dl, i			;/* Set t to (t+j) modulo 256 */
	ENDM

	;/* Save new state */
	FOR i, <0, 4, 8, 12>
	mov	eax, dword ptr [md2_x+i]
	mov	dword ptr [md2_state+i], eax
	ENDM
	
	;/* Update checksum */
	movzx	edx, byte ptr [md2_checksum+15]
	FOR i, <0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15>
	movzx	eax, byte ptr [edi+i]
	xor	al, dl
	movzx	edx, byte ptr [eax+md2_s]
	xor	dl, byte ptr [md2_checksum+i]
	mov	byte ptr [md2_checksum+i], dl
	ENDM

	ret
MD2_Transform	endp


MD2_Init	proc
	FOR i, <0,4,8,12>
	mov	dword ptr [md2_checksum+i], 0
	mov	dword ptr [md2_state+i], 0
	ENDM
	ret
MD2_Init	endp


MD2_Pad	proc	buffer:dword, md2len:dword
		local	lenmod: dword
	mov	eax, md2len
	mov	ecx, eax
	shr	eax, 4		;/16
	mov	md2_nbloop, eax
	and	ecx, 0Fh
	mov	lenmod, ecx

	;build lastblock24
	mov	edi, offset lastblock24
	mov	esi, buffer
	add	esi, md2len	; + len
	sub	esi, ecx	; - lenmod
	invoke	RtlMoveMemory, edi, esi, lenmod	
	add	edi, lenmod
	;
	mov	ecx, 16
	sub	ecx, lenmod
	mov	eax, ecx
	shl	eax, 4		;*16
	lea	eax, [eax+padding24]
	invoke	RtlMoveMemory, edi, eax, ecx

	ret
MD2_Pad	endp


MD2	proc	buffer:dword, md2len:dword
		public	MD2
	mov	edi,offset sznumber1
	mov	ecx,33
	xor	al,al
	rep stosb
	
	call	MD2_Init
	invoke	MD2_Pad, buffer, md2len
	mov	edi, buffer
	mov	esi, md2_nbloop
md2_loop:
	test	esi, esi
	jz	md2_loop_end
	call	MD2_Transform
	add	edi, 16d
	dec	esi
	jmp	md2_loop
md2_loop_end:
	mov	edi, offset lastblock24
	call	MD2_Transform
	mov	edi, offset md2_checksum
	call	MD2_Transform
	;
	mov	esi,4
	mov	edi, offset md2_state
	
md2_print:	
	mov 	eax, dword ptr [edi]
	bswap 	eax
	invoke	wsprintf,addr szMDBUFF,addr szFrmt,eax
	invoke	lstrcat,addr sznumber1,addr szMDBUFF
	add 	edi, 4
	dec	esi
	test	esi,esi
	jnz	md2_print
	invoke	lstrcpy,buffer,addr sznumber1
	ret
MD2	endp
