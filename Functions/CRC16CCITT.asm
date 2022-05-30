
HashCrc16ccittEx	proto	:dword, :dword, :UINT, :dword

.const
SIZE_CRC16CCITT		equ (4*10000h) + 2 ; BlockSize(Hi) + DigestSize(Lo)

.data
t_crc16ccitt		dw 00000h, 01021h, 02042h, 03063h, 04084h, 050A5h, 060C6h, 070E7h
					dw 08108h, 09129h, 0A14Ah, 0B16Bh, 0C18Ch, 0D1ADh, 0E1CEh, 0F1EFh
					dw 01231h, 00210h, 03273h, 02252h, 052B5h, 04294h, 072F7h, 062D6h
					dw 09339h, 08318h, 0B37Bh, 0A35Ah, 0D3BDh, 0C39Ch, 0F3FFh, 0E3DEh
					dw 02462h, 03443h, 00420h, 01401h, 064E6h, 074C7h, 044A4h, 05485h
					dw 0A56Ah, 0B54Bh, 08528h, 09509h, 0E5EEh, 0F5CFh, 0C5ACh, 0D58Dh
					dw 03653h, 02672h, 01611h, 00630h, 076D7h, 066F6h, 05695h, 046B4h
					dw 0B75Bh, 0A77Ah, 09719h, 08738h, 0F7DFh, 0E7FEh, 0D79Dh, 0C7BCh
					dw 048C4h, 058E5h, 06886h, 078A7h, 00840h, 01861h, 02802h, 03823h
					dw 0C9CCh, 0D9EDh, 0E98Eh, 0F9AFh, 08948h, 09969h, 0A90Ah, 0B92Bh
					dw 05AF5h, 04AD4h, 07AB7h, 06A96h, 01A71h, 00A50h, 03A33h, 02A12h
					dw 0DBFDh, 0CBDCh, 0FBBFh, 0EB9Eh, 09B79h, 08B58h, 0BB3Bh, 0AB1Ah
					dw 06CA6h, 07C87h, 04CE4h, 05CC5h, 02C22h, 03C03h, 00C60h, 01C41h
					dw 0EDAEh, 0FD8Fh, 0CDECh, 0DDCDh, 0AD2Ah, 0BD0Bh, 08D68h, 09D49h
					dw 07E97h, 06EB6h, 05ED5h, 04EF4h, 03E13h, 02E32h, 01E51h, 00E70h
					dw 0FF9Fh, 0EFBEh, 0DFDDh, 0CFFCh, 0BF1Bh, 0AF3Ah, 09F59h, 08F78h
					dw 09188h, 081A9h, 0B1CAh, 0A1EBh, 0D10Ch, 0C12Dh, 0F14Eh, 0E16Fh
					dw 01080h, 000A1h, 030C2h, 020E3h, 05004h, 04025h, 07046h, 06067h
					dw 083B9h, 09398h, 0A3FBh, 0B3DAh, 0C33Dh, 0D31Ch, 0E37Fh, 0F35Eh
					dw 002B1h, 01290h, 022F3h, 032D2h, 04235h, 05214h, 06277h, 07256h
					dw 0B5EAh, 0A5CBh, 095A8h, 08589h, 0F56Eh, 0E54Fh, 0D52Ch, 0C50Dh
					dw 034E2h, 024C3h, 014A0h, 00481h, 07466h, 06447h, 05424h, 04405h
					dw 0A7DBh, 0B7FAh, 08799h, 097B8h, 0E75Fh, 0F77Eh, 0C71Dh, 0D73Ch
					dw 026D3h, 036F2h, 00691h, 016B0h, 06657h, 07676h, 04615h, 05634h
					dw 0D94Ch, 0C96Dh, 0F90Eh, 0E92Fh, 099C8h, 089E9h, 0B98Ah, 0A9ABh
					dw 05844h, 04865h, 07806h, 06827h, 018C0h, 008E1h, 03882h, 028A3h
					dw 0CB7Dh, 0DB5Ch, 0EB3Fh, 0FB1Eh, 08BF9h, 09BD8h, 0ABBBh, 0BB9Ah
					dw 04A75h, 05A54h, 06A37h, 07A16h, 00AF1h, 01AD0h, 02AB3h, 03A92h
					dw 0FD2Eh, 0ED0Fh, 0DD6Ch, 0CD4Dh, 0BDAAh, 0AD8Bh, 09DE8h, 08DC9h
					dw 07C26h, 06C07h, 05C64h, 04C45h, 03CA2h, 02C83h, 01CE0h, 00CC1h
					dw 0EF1Fh, 0FF3Eh, 0CF5Dh, 0DF7Ch, 0AF9Bh, 0BFBAh, 08FD9h, 09FF8h
					dw 06E17h, 07E36h, 04E55h, 05E74h, 02E93h, 03EB2h, 00ED1h, 01EF0h

.code

;***************************************************************************************
;Start CRC16 Handler functions
;***************************************************************************************

CRC16CCITT_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call DisableKeyEdit

		mov esi, offset HASHES_Current
		assume esi:ptr HASH_PARAMETERS
		mov ebx, [esi].CRC16CCITTparameterA
		push ebx
		assume esi:nothing
		;push -1
		push _len
		push _Output
		push _Input
		call HashCrc16ccittEx
		mov	eax, 2	;length
        ret
CRC16CCITT_RT endp


align dword
HashCrc16ccittEx proc uses esi pData:dword, pOutput:dword, dwDataLen:UINT, dwCRC:dword
		mov	edx, dwCRC
		and	edx, 0FFFFh
		xor	eax, eax
		mov	esi, pData
		.while dwDataLen
			mov	cx, dx
			lodsb
			xor	al, ch
			mov	dx, word ptr [t_crc16ccitt + 2 * eax]
			xor	dh, cl
			dec	dwDataLen
		.endw
		mov eax, edx
		invoke	wsprintf, pOutput, addr hex16bit, dx
		xor	ecx, ecx
		ret
HashCrc16ccittEx endp
