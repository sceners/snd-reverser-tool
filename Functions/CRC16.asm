
;Begin of CRC16 Function :)
;Base Idea:
;Function proc sInput, sOutput, inputlength, key

.data

table_crc16	dw 00000h, 0C0C1h, 0C181h, 00140h, 0C301h, 003C0h, 00280h, 0C241h
			dw 0C601h, 006C0h, 00780h, 0C741h, 00500h, 0C5C1h, 0C481h, 00440h
			dw 0CC01h, 00CC0h, 00D80h, 0CD41h, 00F00h, 0CFC1h, 0CE81h, 00E40h
			dw 00A00h, 0CAC1h, 0CB81h, 00B40h, 0C901h, 009C0h, 00880h, 0C841h
			dw 0D801h, 018C0h, 01980h, 0D941h, 01B00h, 0DBC1h, 0DA81h, 01A40h
			dw 01E00h, 0DEC1h, 0DF81h, 01F40h, 0DD01h, 01DC0h, 01C80h, 0DC41h
			dw 01400h, 0D4C1h, 0D581h, 01540h, 0D701h, 017C0h, 01680h, 0D641h
			dw 0D201h, 012C0h, 01380h, 0D341h, 01100h, 0D1C1h, 0D081h, 01040h
			dw 0F001h, 030C0h, 03180h, 0F141h, 03300h, 0F3C1h, 0F281h, 03240h
			dw 03600h, 0F6C1h, 0F781h, 03740h, 0F501h, 035C0h, 03480h, 0F441h
			dw 03C00h, 0FCC1h, 0FD81h, 03D40h, 0FF01h, 03FC0h, 03E80h, 0FE41h
			dw 0FA01h, 03AC0h, 03B80h, 0FB41h, 03900h, 0F9C1h, 0F881h, 03840h
			dw 02800h, 0E8C1h, 0E981h, 02940h, 0EB01h, 02BC0h, 02A80h, 0EA41h
			dw 0EE01h, 02EC0h, 02F80h, 0EF41h, 02D00h, 0EDC1h, 0EC81h, 02C40h
			dw 0E401h, 024C0h, 02580h, 0E541h, 02700h, 0E7C1h, 0E681h, 02640h
			dw 02200h, 0E2C1h, 0E381h, 02340h, 0E101h, 021C0h, 02080h, 0E041h
			dw 0A001h, 060C0h, 06180h, 0A141h, 06300h, 0A3C1h, 0A281h, 06240h
			dw 06600h, 0A6C1h, 0A781h, 06740h, 0A501h, 065C0h, 06480h, 0A441h
			dw 06C00h, 0ACC1h, 0AD81h, 06D40h, 0AF01h, 06FC0h, 06E80h, 0AE41h
			dw 0AA01h, 06AC0h, 06B80h, 0AB41h, 06900h, 0A9C1h, 0A881h, 06840h
			dw 07800h, 0B8C1h, 0B981h, 07940h, 0BB01h, 07BC0h, 07A80h, 0BA41h
			dw 0BE01h, 07EC0h, 07F80h, 0BF41h, 07D00h, 0BDC1h, 0BC81h, 07C40h
			dw 0B401h, 074C0h, 07580h, 0B541h, 07700h, 0B7C1h, 0B681h, 07640h
			dw 07200h, 0B2C1h, 0B381h, 07340h, 0B101h, 071C0h, 07080h, 0B041h
			dw 05000h, 090C1h, 09181h, 05140h, 09301h, 053C0h, 05280h, 09241h
			dw 09601h, 056C0h, 05780h, 09741h, 05500h, 095C1h, 09481h, 05440h
			dw 09C01h, 05CC0h, 05D80h, 09D41h, 05F00h, 09FC1h, 09E81h, 05E40h
			dw 05A00h, 09AC1h, 09B81h, 05B40h, 09901h, 059C0h, 05880h, 09841h
			dw 08801h, 048C0h, 04980h, 08941h, 04B00h, 08BC1h, 08A81h, 04A40h
			dw 04E00h, 08EC1h, 08F81h, 04F40h, 08D01h, 04DC0h, 04C80h, 08C41h
			dw 04400h, 084C1h, 08581h, 04540h, 08701h, 047C0h, 04680h, 08641h
			dw 08201h, 042C0h, 04380h, 08341h, 04100h, 081C1h, 08081h, 04040h
		
.code

;***************************************************************************************
;Start CRC16 Handler functions
;***************************************************************************************

CRC16_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call DisableKeyEdit

		mov esi, offset HASHES_Current
		assume esi:ptr HASH_PARAMETERS
		mov ebx, [esi].CRC16parameterA
		push ebx
		assume esi:nothing
		;push -1
		push _len
		push _Output
		push _Input
		call CRC16
		mov	eax, 2	;length
        ret
CRC16_RT endp


;***************************************************************************************
;Start CRC16 functions
;***************************************************************************************
CRC16 proc uses esi edx ecx eax _Input:dword, _Output:dword, _len:dword, _key:dword 
		;xor	eax, eax
		mov eax, _key
		mov	esi, _Input
		xor	ecx, ecx
		xor	edx, edx
	crc16_boucle:
		mov	dx, ax		
		and	dx, 255
		xor	dl, byte ptr [ecx+esi]
		mov	dx, word ptr [2*edx+table_crc16]
		shr	ax, 8
		xor	ax, dx
		inc	ecx
		cmp	ecx, _len
		jl	crc16_boucle
	crc16_end:
		invoke	wsprintf, _Output, addr hex16bit, ax
		xor	ecx, ecx
		ret
CRC16 endp

; ------------------------------------------------------------------------------