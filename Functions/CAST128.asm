x0123	equ	dword ptr [edi]
x0	equ	byte ptr [edi+ 3]
x1	equ	byte ptr [edi+ 2]
_x2	equ	byte ptr [edi+ 1]
x3	equ	byte ptr [edi+ 0]
x4567	equ	dword ptr [edi+4]
x4	equ	byte ptr [edi+ 7]
x5	equ	byte ptr [edi+ 6]
x6	equ	byte ptr [edi+ 5]
x7	equ	byte ptr [edi+ 4]
x89AB	equ	dword ptr [edi+8]
x8	equ	byte ptr [edi+11]
x9	equ	byte ptr [edi+10]
xA	equ	byte ptr [edi+ 9]
xB	equ	byte ptr [edi+ 8]
xCDEF	equ	dword ptr [edi+12]
xC	equ	byte ptr [edi+15]
xD	equ	byte ptr [edi+14]
xE	equ	byte ptr [edi+13]
xF	equ	byte ptr [edi+12]
z0123	equ	dword ptr [edi+16]
z0	equ	byte ptr [edi+19]
z1	equ	byte ptr [edi+18]
z2	equ	byte ptr [edi+17]
z3	equ	byte ptr [edi+16]
z4567	equ	dword ptr [edi+20]
z4	equ	byte ptr [edi+23]
z5	equ	byte ptr [edi+22]
z6	equ	byte ptr [edi+21]
z7	equ	byte ptr [edi+20]
z89AB	equ	dword ptr [edi+24]
z8	equ	byte ptr [edi+27]
z9	equ	byte ptr [edi+26]
zA	equ	byte ptr [edi+25]
zB	equ	byte ptr [edi+24]
zCDEF	equ	dword ptr [edi+28]
zC	equ	byte ptr [edi+31]
zD	equ	byte ptr [edi+30]
zE	equ	byte ptr [edi+29]
zF	equ	byte ptr [edi+28]
CAST128_SetKey	PROTO	:DWORD
CAST128_Clear	PROTO
CAST128_Encrypt	PROTO	:DWORD, :DWORD
CAST128_Decrypt	PROTO	:DWORD, :DWORD
KEY_SIZE	equ	80;128		; 80, 128
;#Eg‰«Íï
KEY_FROM_EAX	MACRO	box3, box2, box1, box0, boxX, xorParam, boxXIndex, dest

	mov	bl, al
	mov	cl, ah
	mov	edx, dword ptr [box3+4*ebx]
	rol	eax, 16
	xor	edx, dword ptr [box2+4*ecx]
	mov	bl, al
	mov	cl, ah
	xor	edx, dword ptr [box1+4*ebx]
	xor	edx, dword ptr [box0+4*ecx]
	mov	bl, boxXIndex
	xor	edx, xorParam
	xor	edx, dword ptr [boxX+4*ebx]
	mov	dest, edx

ENDM

KEY_FROM_EDX	MACRO	box3, box2, box1, box0, boxX, xorParam, boxXIndex, dest

	mov	bl, dl
	mov	cl, dh
	mov	eax, dword ptr [box3+4*ebx]
	rol	edx, 16
	xor	eax, dword ptr [box2+4*ecx]
	mov	bl, dl
	mov	cl, dh
	xor	eax, dword ptr [box1+4*ebx]
	xor	eax, dword ptr [box0+4*ecx]
	mov	bl, boxXIndex
	xor	eax, xorParam
	xor	eax, dword ptr [boxX+4*ebx]
	mov	dest, eax

ENDM

KEYS		MACRO	box5Index, box6Index, box7Index, box8Index, boxX, boxXIndex

	mov	bl, box5Index
	mov	cl, box6Index
	mov	eax, dword ptr [S5+4*ebx]
	xor	eax, dword ptr [S6+4*ecx]
	mov	bl, box7Index
	mov	cl, box8Index
	xor	eax, dword ptr [S7+4*ebx]
	xor	eax, dword ptr [S8+4*ecx]
	mov	bl, boxXIndex
	xor	eax, dword ptr [boxX+4*ebx]
	mov	dword ptr [esi], eax
	add	esi, 4
ENDM

ROUND_1		MACRO	arg_1, arg_2, keyIndex
;F1
	mov	eax, arg_1
IF	KEY_SIZE eq 128
	mov	ecx, dword ptr [edi+16*4+4*keyIndex]
ELSEIF	KEY_SIZE eq  80
	mov	ecx, dword ptr [edi+12*4+4*keyIndex]
ENDIF
	add	eax, dword ptr [edi+4*keyIndex]		;F1: add, F2: xor, F3: sub
	rol	eax, cl
							;a little trick here. all shift operators are incremented by 16 so
							;in eax we don't have standard  b0b1b2b3 but b2b3b0b1
;G1
	mov	bl, ah
	mov	dl, al
	mov	ecx, dword ptr [S1+4*ebx]
	shr	eax, 16
	xor	ecx, dword ptr [S2+4*edx]
	mov	bl, ah
	mov	dl, al
	sub	ecx, dword ptr [S3+4*ebx]
	add	ecx, dword ptr [S4+4*edx]
	xor	arg_2, ecx
ENDM

ROUND_2		MACRO	arg_1, arg_2, keyIndex
;F2
	mov	eax, arg_1
IF	KEY_SIZE eq 128
	mov	ecx, dword ptr [edi+16*4+4*keyIndex]
ELSEIF	KEY_SIZE eq  80
	mov	ecx, dword ptr [edi+12*4+4*keyIndex]
ENDIF
	xor	eax, dword ptr [edi+4*keyIndex]		;F1: add, F2: xor, F3: sub
	rol	eax, cl
;G2
	mov	bl, ah
	mov	dl, al
	mov	ecx, dword ptr [S1+4*ebx]
	shr	eax, 16
	sub	ecx, dword ptr [S2+4*edx]
	mov	bl, ah
	mov	dl, al
	add	ecx, dword ptr [S3+4*ebx]
	xor	ecx, dword ptr [S4+4*edx]
	xor	arg_2, ecx
ENDM

ROUND_3		MACRO	arg_1, arg_2, keyIndex
;F3
	mov	eax, dword ptr [edi+4*keyIndex]
IF	KEY_SIZE eq 128
	mov	ecx, dword ptr [edi+16*4+4*keyIndex]
ELSEIF	KEY_SIZE eq  80
	mov	ecx, dword ptr [edi+12*4+4*keyIndex]
ENDIF
	sub	eax, arg_1				;F1: add, F2: xor, F3: sub
	rol	eax, cl
;G3
	mov	bl, ah
	mov	dl, al
	mov	ecx, dword ptr [S1+4*ebx]
	shr	eax, 16
	add	ecx, dword ptr [S2+4*edx]
	mov	bl, ah
	mov	dl, al
	xor	ecx, dword ptr [S3+4*ebx]
	sub	ecx, dword ptr [S4+4*edx]
	xor	arg_2, ecx
ENDM
.data
S1	dd 030fb40d4h,09fa0ff0bh,06beccd2fh,03f258c7ah,01e213f2fh,09c004dd3h,06003e540h,0cf9fc949h
	dd 0bfd4af27h,088bbbdb5h,0e2034090h,098d09675h,06e63a0e0h,015c361d2h,0c2e7661dh,022d4ff8eh
	dd 028683b6fh,0c07fd059h,0ff2379c8h,0775f50e2h,043c340d3h,0df2f8656h,0887ca41ah,0a2d2bd2dh
	dd 0a1c9e0d6h,0346c4819h,061b76d87h,022540f2fh,02abe32e1h,0aa54166bh,022568e3ah,0a2d341d0h
	dd 066db40c8h,0a784392fh,0004dff2fh,02db9d2deh,097943fach,04a97c1d8h,0527644b7h,0b5f437a7h
	dd 0b82cbaefh,0d751d159h,06ff7f0edh,05a097a1fh,0827b68d0h,090ecf52eh,022b0c054h,0bc8e5935h
	dd 04b6d2f7fh,050bb64a2h,0d2664910h,0bee5812dh,0b7332290h,0e93b159fh,0b48ee411h,04bff345dh
	dd 0fd45c240h,0ad31973fh,0c4f6d02eh,055fc8165h,0d5b1caadh,0a1ac2daeh,0a2d4b76dh,0c19b0c50h
	dd 0882240f2h,00c6e4f38h,0a4e4bfd7h,04f5ba272h,0564c1d2fh,0c59c5319h,0b949e354h,0b04669feh
	dd 0b1b6ab8ah,0c71358ddh,06385c545h,0110f935dh,057538ad5h,06a390493h,0e63d37e0h,02a54f6b3h
	dd 03a787d5fh,06276a0b5h,019a6fcdfh,07a42206ah,029f9d4d5h,0f61b1891h,0bb72275eh,0aa508167h
	dd 038901091h,0c6b505ebh,084c7cb8ch,02ad75a0fh,0874a1427h,0a2d1936bh,02ad286afh,0aa56d291h
	dd 0d7894360h,0425c750dh,093b39e26h,0187184c9h,06c00b32dh,073e2bb14h,0a0bebc3ch,054623779h
	dd 064459eabh,03f328b82h,07718cf82h,059a2cea6h,004ee002eh,089fe78e6h,03fab0950h,0325ff6c2h
	dd 081383f05h,06963c5c8h,076cb5ad6h,0d49974c9h,0ca180dcfh,0380782d5h,0c7fa5cf6h,08ac31511h
	dd 035e79e13h,047da91d0h,0f40f9086h,0a7e2419eh,031366241h,0051ef495h,0aa573b04h,04a805d8dh
	dd 0548300d0h,000322a3ch,0bf64cddfh,0ba57a68eh,075c6372bh,050afd341h,0a7c13275h,0915a0bf5h
	dd 06b54bfabh,02b0b1426h,0ab4cc9d7h,0449ccd82h,0f7fbf265h,0ab85c5f3h,01b55db94h,0aad4e324h
	dd 0cfa4bd3fh,02deaa3e2h,09e204d02h,0c8bd25ach,0eadf55b3h,0d5bd9e98h,0e31231b2h,02ad5ad6ch
	dd 0954329deh,0adbe4528h,0d8710f69h,0aa51c90fh,0aa786bf6h,022513f1eh,0aa51a79bh,02ad344cch
	dd 07b5a41f0h,0d37cfbadh,01b069505h,041ece491h,0b4c332e6h,0032268d4h,0c9600acch,0ce387e6dh
	dd 0bf6bb16ch,06a70fb78h,00d03d9c9h,0d4df39deh,0e01063dah,04736f464h,05ad328d8h,0b347cc96h
	dd 075bb0fc3h,098511bfbh,04ffbcc35h,0b58bcf6ah,0e11f0abch,0bfc5fe4ah,0a70aec10h,0ac39570ah
	dd 03f04442fh,06188b153h,0e0397a2eh,05727cb79h,09ceb418fh,01cacd68dh,02ad37c96h,00175cb9dh
	dd 0c69dff09h,0c75b65f0h,0d9db40d8h,0ec0e7779h,04744ead4h,0b11c3274h,0dd24cb9eh,07e1c54bdh
	dd 0f01144f9h,0d2240eb1h,09675b3fdh,0a3ac3755h,0d47c27afh,051c85f4dh,056907596h,0a5bb15e6h
	dd 0580304f0h,0ca042cf1h,0011a37eah,08dbfaadbh,035ba3e4ah,03526ffa0h,0c37b4d09h,0bc306ed9h
	dd 098a52666h,05648f725h,0ff5e569dh,00ced63d0h,07c63b2cfh,0700b45e1h,0d5ea50f1h,085a92872h
	dd 0af1fbda7h,0d4234870h,0a7870bf3h,02d3b4d79h,042e04198h,00cd0ede7h,026470db8h,0f881814ch
	dd 0474d6ad7h,07c0c5e5ch,0d1231959h,0381b7298h,0f5d2f4dbh,0ab838653h,06e2f1e23h,083719c9eh
	dd 0bd91e046h,09a56456eh,0dc39200ch,020c8c571h,0962bda1ch,0e1e696ffh,0b141ab08h,07cca89b9h
	dd 01a69e783h,002cc4843h,0a2f7c579h,0429ef47dh,0427b169ch,05ac9f049h,0dd8f0f00h,05c8165bfh
	
S2	dd 01f201094h,0ef0ba75bh,069e3cf7eh,0393f4380h,0fe61cf7ah,0eec5207ah,055889c94h,072fc0651h
	dd 0ada7ef79h,04e1d7235h,0d55a63ceh,0de0436bah,099c430efh,05f0c0794h,018dcdb7dh,0a1d6eff3h
	dd 0a0b52f7bh,059e83605h,0ee15b094h,0e9ffd909h,0dc440086h,0ef944459h,0ba83ccb3h,0e0c3cdfbh
	dd 0d1da4181h,03b092ab1h,0f997f1c1h,0a5e6cf7bh,001420ddbh,0e4e7ef5bh,025a1ff41h,0e180f806h
	dd 01fc41080h,0179bee7ah,0d37ac6a9h,0fe5830a4h,098de8b7fh,077e83f4eh,079929269h,024fa9f7bh
	dd 0e113c85bh,0acc40083h,0d7503525h,0f7ea615fh,062143154h,00d554b63h,05d681121h,0c866c359h
	dd 03d63cf73h,0cee234c0h,0d4d87e87h,05c672b21h,0071f6181h,039f7627fh,0361e3084h,0e4eb573bh
	dd 0602f64a4h,0d63acd9ch,01bbc4635h,09e81032dh,02701f50ch,099847ab4h,0a0e3df79h,0ba6cf38ch
	dd 010843094h,02537a95eh,0f46f6ffeh,0a1ff3b1fh,0208cfb6ah,08f458c74h,0d9e0a227h,04ec73a34h
	dd 0fc884f69h,03e4de8dfh,0ef0e0088h,03559648dh,08a45388ch,01d804366h,0721d9bfdh,0a58684bbh
	dd 0e8256333h,0844e8212h,0128d8098h,0fed33fb4h,0ce280ae1h,027e19ba5h,0d5a6c252h,0e49754bdh
	dd 0c5d655ddh,0eb667064h,077840b4dh,0a1b6a801h,084db26a9h,0e0b56714h,021f043b7h,0e5d05860h
	dd 054f03084h,0066ff472h,0a31aa153h,0dadc4755h,0b5625dbfh,068561be6h,083ca6b94h,02d6ed23bh
	dd 0eccf01dbh,0a6d3d0bah,0b6803d5ch,0af77a709h,033b4a34ch,0397bc8d6h,05ee22b95h,05f0e5304h
	dd 081ed6f61h,020e74364h,0b45e1378h,0de18639bh,0881ca122h,0b96726d1h,08049a7e8h,022b7da7bh
	dd 05e552d25h,05272d237h,079d2951ch,0c60d894ch,0488cb402h,01ba4fe5bh,0a4b09f6bh,01ca815cfh
	dd 0a20c3005h,08871df63h,0b9de2fcbh,00cc6c9e9h,00beeff53h,0e3214517h,0b4542835h,09f63293ch
	dd 0ee41e729h,06e1d2d7ch,050045286h,01e6685f3h,0f33401c6h,030a22c95h,031a70850h,060930f13h
	dd 073f98417h,0a1269859h,0ec645c44h,052c877a9h,0cdff33a6h,0a02b1741h,07cbad9a2h,02180036fh
	dd 050d99c08h,0cb3f4861h,0c26bd765h,064a3f6abh,080342676h,025a75e7bh,0e4e6d1fch,020c710e6h
	dd 0cdf0b680h,017844d3bh,031eef84dh,07e0824e4h,02ccb49ebh,0846a3baeh,08ff77888h,0ee5d60f6h
	dd 07af75673h,02fdd5cdbh,0a11631c1h,030f66f43h,0b3faec54h,0157fd7fah,0ef8579cch,0d152de58h
	dd 0db2ffd5eh,08f32ce19h,0306af97ah,002f03ef8h,099319ad5h,0c242fa0fh,0a7e3ebb0h,0c68e4906h
	dd 0b8da230ch,080823028h,0dcdef3c8h,0d35fb171h,0088a1bc8h,0bec0c560h,061a3c9e8h,0bca8f54dh
	dd 0c72feffah,022822e99h,082c570b4h,0d8d94e89h,08b1c34bch,0301e16e6h,0273be979h,0b0ffeaa6h
	dd 061d9b8c6h,000b24869h,0b7ffce3fh,008dc283bh,043daf65ah,0f7e19798h,07619b72fh,08f1c9ba4h
	dd 0dc8637a0h,016a7d3b1h,09fc393b7h,0a7136eebh,0c6bcc63eh,01a513742h,0ef6828bch,0520365d6h
	dd 02d6a77abh,03527ed4bh,0821fd216h,0095c6e2eh,0db92f2fbh,05eea29cbh,0145892f5h,091584f7fh
	dd 05483697bh,02667a8cch,085196048h,08c4baceah,0833860d4h,00d23e0f9h,06c387e8ah,00ae6d249h
	dd 0b284600ch,0d835731dh,0dcb1c647h,0ac4c56eah,03ebd81b3h,0230eabb0h,06438bc87h,0f0b5b1fah
	dd 08f5ea2b3h,0fc184642h,00a036b7ah,04fb089bdh,0649da589h,0a345415eh,05c038323h,03e5d3bb9h
	dd 043d79572h,07e6dd07ch,006dfdf1eh,06c6cc4efh,07160a539h,073bfbe70h,083877605h,04523ecf1h
	
S3	dd 08defc240h,025fa5d9fh,0eb903dbfh,0e810c907h,047607fffh,0369fe44bh,08c1fc644h,0aececa90h
	dd 0beb1f9bfh,0eefbcaeah,0e8cf1950h,051df07aeh,0920e8806h,0f0ad0548h,0e13c8d83h,0927010d5h
	dd 011107d9fh,007647db9h,0b2e3e4d4h,03d4f285eh,0b9afa820h,0fade82e0h,0a067268bh,08272792eh
	dd 0553fb2c0h,0489ae22bh,0d4ef9794h,0125e3fbch,021fffceeh,0825b1bfdh,09255c5edh,01257a240h
	dd 04e1a8302h,0bae07fffh,0528246e7h,08e57140eh,03373f7bfh,08c9f8188h,0a6fc4ee8h,0c982b5a5h
	dd 0a8c01db7h,0579fc264h,067094f31h,0f2bd3f5fh,040fff7c1h,01fb78dfch,08e6bd2c1h,0437be59bh
	dd 099b03dbfh,0b5dbc64bh,0638dc0e6h,055819d99h,0a197c81ch,04a012d6eh,0c5884a28h,0ccc36f71h
	dd 0b843c213h,06c0743f1h,08309893ch,00feddd5fh,02f7fe850h,0d7c07f7eh,002507fbfh,05afb9a04h
	dd 0a747d2d0h,01651192eh,0af70bf3eh,058c31380h,05f98302eh,0727cc3c4h,00a0fb402h,00f7fef82h
	dd 08c96fdadh,05d2c2aaeh,08ee99a49h,050da88b8h,08427f4a0h,01eac5790h,0796fb449h,08252dc15h
	dd 0efbd7d9bh,0a672597dh,0ada840d8h,045f54504h,0fa5d7403h,0e83ec305h,04f91751ah,0925669c2h
	dd 023efe941h,0a903f12eh,060270df2h,00276e4b6h,094fd6574h,0927985b2h,08276dbcbh,002778176h
	dd 0f8af918dh,04e48f79eh,08f616ddfh,0e29d840eh,0842f7d83h,0340ce5c8h,096bbb682h,093b4b148h
	dd 0ef303cabh,0984faf28h,0779faf9bh,092dc560dh,0224d1e20h,08437aa88h,07d29dc96h,02756d3dch
	dd 08b907ceeh,0b51fd240h,0e7c07ce3h,0e566b4a1h,0c3e9615eh,03cf8209dh,06094d1e3h,0cd9ca341h
	dd 05c76460eh,000ea983bh,0d4d67881h,0fd47572ch,0f76cedd9h,0bda8229ch,0127dadaah,0438a074eh
	dd 01f97c090h,0081bdb8ah,093a07ebeh,0b938ca15h,097b03cffh,03dc2c0f8h,08d1ab2ech,064380e51h
	dd 068cc7bfbh,0d90f2788h,012490181h,05de5ffd4h,0dd7ef86ah,076a2e214h,0b9a40368h,0925d958fh
	dd 04b39fffah,0ba39aee9h,0a4ffd30bh,0faf7933bh,06d498623h,0193cbcfah,027627545h,0825cf47ah
	dd 061bd8ba0h,0d11e42d1h,0cead04f4h,0127ea392h,010428db7h,08272a972h,09270c4a8h,0127de50bh
	dd 0285ba1c8h,03c62f44fh,035c0eaa5h,0e805d231h,0428929fbh,0b4fcdf82h,04fb66a53h,00e7dc15bh
	dd 01f081fabh,0108618aeh,0fcfd086dh,0f9ff2889h,0694bcc11h,0236a5caeh,012deca4dh,02c3f8cc5h
	dd 0d2d02dfeh,0f8ef5896h,0e4cf52dah,095155b67h,0494a488ch,0b9b6a80ch,05c8f82bch,089d36b45h
	dd 03a609437h,0ec00c9a9h,044715253h,00a874b49h,0d773bc40h,07c34671ch,002717ef6h,04feb5536h
	dd 0a2d02fffh,0d2bf60c4h,0d43f03c0h,050b4ef6dh,007478cd1h,0006e1888h,0a2e53f55h,0b9e6d4bch
	dd 0a2048016h,097573833h,0d7207d67h,0de0f8f3dh,072f87b33h,0abcc4f33h,07688c55dh,07b00a6b0h
	dd 0947b0001h,0570075d2h,0f9bb88f8h,08942019eh,04264a5ffh,0856302e0h,072dbd92bh,0ee971b69h
	dd 06ea22fdeh,05f08ae2bh,0af7a616dh,0e5c98767h,0cf1febd2h,061efc8c2h,0f1ac2571h,0cc8239c2h
	dd 067214cb8h,0b1e583d1h,0b7dc3e62h,07f10bdceh,0f90a5c38h,00ff0443dh,0606e6dc6h,060543a49h
	dd 05727c148h,02be98a1dh,08ab41738h,020e1be24h,0af96da0fh,068458425h,099833be5h,0600d457dh
	dd 0282f9350h,08334b362h,0d91d1120h,02b6d8da0h,0642b1e31h,09c305a00h,052bce688h,01b03588ah
	dd 0f7baefd5h,04142ed9ch,0a4315c11h,083323ec5h,0dfef4636h,0a133c501h,0e9d3531ch,0ee353783h
	
S4	dd 09db30420h,01fb6e9deh,0a7be7befh,0d273a298h,04a4f7bdbh,064ad8c57h,085510443h,0fa020ed1h
	dd 07e287affh,0e60fb663h,0095f35a1h,079ebf120h,0fd059d43h,06497b7b1h,0f3641f63h,0241e4adfh
	dd 028147f5fh,04fa2b8cdh,0c9430040h,00cc32220h,0fdd30b30h,0c0a5374fh,01d2d00d9h,024147b15h
	dd 0ee4d111ah,00fca5167h,071ff904ch,02d195ffeh,01a05645fh,00c13fefeh,0081b08cah,005170121h
	dd 080530100h,0e83e5efeh,0ac9af4f8h,07fe72701h,0d2b8ee5fh,006df4261h,0bb9e9b8ah,07293ea25h
	dd 0ce84ffdfh,0f5718801h,03dd64b04h,0a26f263bh,07ed48400h,0547eebe6h,0446d4ca0h,06cf3d6f5h
	dd 02649abdfh,0aea0c7f5h,036338cc1h,0503f7e93h,0d3772061h,011b638e1h,072500e03h,0f80eb2bbh
	dd 0abe0502eh,0ec8d77deh,057971e81h,0e14f6746h,0c9335400h,06920318fh,0081dbb99h,0ffc304a5h
	dd 04d351805h,07f3d5ce3h,0a6c866c6h,05d5bcca9h,0daec6feah,09f926f91h,09f46222fh,03991467dh
	dd 0a5bf6d8eh,01143c44fh,043958302h,0d0214eebh,0022083b8h,03fb6180ch,018f8931eh,0281658e6h
	dd 026486e3eh,08bd78a70h,07477e4c1h,0b506e07ch,0f32d0a25h,079098b02h,0e4eabb81h,028123b23h
	dd 069dead38h,01574ca16h,0df871b62h,0211c40b7h,0a51a9ef9h,00014377bh,0041e8ac8h,009114003h
	dd 0bd59e4d2h,0e3d156d5h,04fe876d5h,02f91a340h,0557be8deh,000eae4a7h,00ce5c2ech,04db4bba6h
	dd 0e756bdffh,0dd3369ach,0ec17b035h,006572327h,099afc8b0h,056c8c391h,06b65811ch,05e146119h
	dd 06e85cb75h,0be07c002h,0c2325577h,0893ff4ech,05bbfc92dh,0d0ec3b25h,0b7801ab7h,08d6d3b24h
	dd 020c763efh,0c366a5fch,09c382880h,00ace3205h,0aac9548ah,0eca1d7c7h,0041afa32h,01d16625ah
	dd 06701902ch,09b757a54h,031d477f7h,09126b031h,036cc6fdbh,0c70b8b46h,0d9e66a48h,056e55a79h
	dd 0026a4cebh,052437effh,02f8f76b4h,00df980a5h,08674cde3h,0edda04ebh,017a9be04h,02c18f4dfh
	dd 0b7747f9dh,0ab2af7b4h,0efc34d20h,02e096b7ch,01741a254h,0e5b6a035h,0213d42f6h,02c1c7c26h
	dd 061c2f50fh,06552daf9h,0d2c231f8h,025130f69h,0d8167fa2h,00418f2c8h,0001a96a6h,00d1526abh
	dd 063315c21h,05e0a72ech,049bafefdh,0187908d9h,08d0dbd86h,0311170a7h,03e9b640ch,0cc3e10d7h
	dd 0d5cad3b6h,00caec388h,0f73001e1h,06c728affh,071eae2a1h,01f9af36eh,0cfcbd12fh,0c1de8417h
	dd 0ac07be6bh,0cb44a1d8h,08b9b0f56h,0013988c3h,0b1c52fcah,0b4be31cdh,0d8782806h,012a3a4e2h
	dd 06f7de532h,058fd7eb6h,0d01ee900h,024adffc2h,0f4990fc5h,09711aac5h,0001d7b95h,082e5e7d2h
	dd 0109873f6h,000613096h,0c32d9521h,0ada121ffh,029908415h,07fbb977fh,0af9eb3dbh,029c9ed2ah
	dd 05ce2a465h,0a730f32ch,0d0aa3fe8h,08a5cc091h,0d49e2ce7h,00ce454a9h,0d60acd86h,0015f1919h
	dd 077079103h,0dea03af6h,078a8565eh,0dee356dfh,021f05cbeh,08b75e387h,0b3c50651h,0b8a5c3efh
	dd 0d8eeb6d2h,0e523be77h,0c2154529h,02f69efdfh,0afe67afbh,0f470c4b2h,0f3e0eb5bh,0d6cc9876h
	dd 039e4460ch,01fda8538h,01987832fh,0ca007367h,0a99144f8h,0296b299eh,0492fc295h,09266beabh
	dd 0b5676e69h,09bd3dddah,0df7e052fh,0db25701ch,01b5e51eeh,0f65324e6h,06afce36ch,00316cc04h
	dd 08644213eh,0b7dc59d0h,07965291fh,0ccd6fd43h,041823979h,0932bcdf6h,0b657c34dh,04edfd282h
	dd 07ae5290ch,03cb9536bh,0851e20feh,09833557eh,013ecf0b0h,0d3ffb372h,03f85c5c1h,00aef7ed2h

S5	dd 07ec90c04h,02c6e74b9h,09b0e66dfh,0a6337911h,0b86a7fffh,01dd358f5h,044dd9d44h,01731167fh
	dd 008fbf1fah,0e7f511cch,0d2051b00h,0735aba00h,02ab722d8h,0386381cbh,0acf6243ah,069befd7ah
	dd 0e6a2e77fh,0f0c720cdh,0c4494816h,0ccf5c180h,038851640h,015b0a848h,0e68b18cbh,04caadeffh
	dd 05f480a01h,00412b2aah,0259814fch,041d0efe2h,04e40b48dh,0248eb6fbh,08dba1cfeh,041a99b02h
	dd 01a550a04h,0ba8f65cbh,07251f4e7h,095a51725h,0c106ecd7h,097a5980ah,0c539b9aah,04d79fe6ah
	dd 0f2f3f763h,068af8040h,0ed0c9e56h,011b4958bh,0e1eb5a88h,08709e6b0h,0d7e07156h,04e29fea7h
	dd 06366e52dh,002d1c000h,0c4ac8e05h,09377f571h,00c05372ah,0578535f2h,02261be02h,0d642a0c9h
	dd 0df13a280h,074b55bd2h,0682199c0h,0d421e5ech,053fb3ce8h,0c8adedb3h,028a87fc9h,03d959981h
	dd 05c1ff900h,0fe38d399h,00c4eff0bh,0062407eah,0aa2f4fb1h,04fb96976h,090c79505h,0b0a8a774h
	dd 0ef55a1ffh,0e59ca2c2h,0a6b62d27h,0e66a4263h,0df65001fh,00ec50966h,0dfdd55bch,029de0655h
	dd 0911e739ah,017af8975h,032c7911ch,089f89468h,00d01e980h,0524755f4h,003b63cc9h,00cc844b2h
	dd 0bcf3f0aah,087ac36e9h,0e53a7426h,001b3d82bh,01a9e7449h,064ee2d7eh,0cddbb1dah,001c94910h
	dd 0b868bf80h,00d26f3fdh,09342ede7h,004a5c284h,0636737b6h,050f5b616h,0f24766e3h,08eca36c1h
	dd 0136e05dbh,0fef18391h,0fb887a37h,0d6e7f7d4h,0c7fb7dc9h,03063fcdfh,0b6f589deh,0ec2941dah
	dd 026e46695h,0b7566419h,0f654efc5h,0d08d58b7h,048925401h,0c1bacb7fh,0e5ff550fh,0b6083049h
	dd 05bb5d0e8h,087d72e5ah,0ab6a6ee1h,0223a66ceh,0c62bf3cdh,09e0885f9h,068cb3e47h,0086c010fh
	dd 0a21de820h,0d18b69deh,0f3f65777h,0fa02c3f6h,0407edac3h,0cbb3d550h,01793084dh,0b0d70ebah
	dd 00ab378d5h,0d951fb0ch,0ded7da56h,04124bbe4h,094ca0b56h,00f5755d1h,0e0e1e56eh,06184b5beh
	dd 0580a249fh,094f74bc0h,0e327888eh,09f7b5561h,0c3dc0280h,005687715h,0646c6bd7h,044904db3h
	dd 066b4f0a3h,0c0f1648ah,0697ed5afh,049e92ff6h,0309e374fh,02cb6356ah,085808573h,04991f840h
	dd 076f0ae02h,0083be84dh,028421c9ah,044489406h,0736e4cb8h,0c1092910h,08bc95fc6h,07d869cf4h
	dd 0134f616fh,02e77118dh,0b31b2be1h,0aa90b472h,03ca5d717h,07d161bbah,09cad9010h,0af462ba2h
	dd 09fe459d2h,045d34559h,0d9f2da13h,0dbc65487h,0f3e4f94eh,0176d486fh,0097c13eah,0631da5c7h
	dd 0445f7382h,0175683f4h,0cdc66a97h,070be0288h,0b3cdcf72h,06e5dd2f3h,020936079h,0459b80a5h
	dd 0be60e2dbh,0a9c23101h,0eba5315ch,0224e42f2h,01c5c1572h,0f6721b2ch,01ad2fff3h,08c25404eh
	dd 0324ed72fh,04067b7fdh,00523138eh,05ca3bc78h,0dc0fd66eh,075922283h,0784d6b17h,058ebb16eh
	dd 044094f85h,03f481d87h,0fcfeae7bh,077b5ff76h,08c2302bfh,0aaf47556h,05f46b02ah,02b092801h
	dd 03d38f5f7h,00ca81f36h,052af4a8ah,066d5e7c0h,0df3b0874h,095055110h,01b5ad7a8h,0f61ed5adh
	dd 06cf6e479h,020758184h,0d0cefa65h,088f7be58h,04a046826h,00ff6f8f3h,0a09c7f70h,05346aba0h
	dd 05ce96c28h,0e176eda3h,06bac307fh,0376829d2h,085360fa9h,017e3fe2ah,024b79767h,0f5a96b20h
	dd 0d6cd2595h,068ff1ebfh,07555442ch,0f19f06beh,0f9e0659ah,0eeb9491dh,034010718h,0bb30cab8h
	dd 0e822fe15h,088570983h,0750e6249h,0da627e55h,05e76ffa8h,0b1534546h,06d47de08h,0efe9e7d4h
	
S6	dd 0f6fa8f9dh,02cac6ce1h,04ca34867h,0e2337f7ch,095db08e7h,0016843b4h,0eced5cbch,0325553ach
	dd 0bf9f0960h,0dfa1e2edh,083f0579dh,063ed86b9h,01ab6a6b8h,0de5ebe39h,0f38ff732h,08989b138h
	dd 033f14961h,0c01937bdh,0f506c6dah,0e4625e7eh,0a308ea99h,04e23e33ch,079cbd7cch,048a14367h
	dd 0a3149619h,0fec94bd5h,0a114174ah,0eaa01866h,0a084db2dh,009a8486fh,0a888614ah,02900af98h
	dd 001665991h,0e1992863h,0c8f30c60h,02e78ef3ch,0d0d51932h,0cf0fec14h,0f7ca07d2h,0d0a82072h
	dd 0fd41197eh,09305a6b0h,0e86be3dah,074bed3cdh,0372da53ch,04c7f4448h,0dab5d440h,06dba0ec3h
	dd 0083919a7h,09fbaeed9h,049dbcfb0h,04e670c53h,05c3d9c01h,064bdb941h,02c0e636ah,0ba7dd9cdh
	dd 0ea6f7388h,0e70bc762h,035f29adbh,05c4cdd8dh,0f0d48d8ch,0b88153e2h,008a19866h,01ae2eac8h
	dd 0284caf89h,0aa928223h,09334be53h,03b3a21bfh,016434be3h,09aea3906h,0efe8c36eh,0f890cdd9h
	dd 080226daeh,0c340a4a3h,0df7e9c09h,0a694a807h,05b7c5ecch,0221db3a6h,09a69a02fh,068818a54h
	dd 0ceb2296fh,053c0843ah,0fe893655h,025bfe68ah,0b4628abch,0cf222ebfh,025ac6f48h,0a9a99387h
	dd 053bddb65h,0e76ffbe7h,0e967fd78h,00ba93563h,08e342bc1h,0e8a11be9h,04980740dh,0c8087dfch
	dd 08de4bf99h,0a11101a0h,07fd37975h,0da5a26c0h,0e81f994fh,09528cd89h,0fd339fedh,0b87834bfh
	dd 05f04456dh,022258698h,0c9c4c83bh,02dc156beh,04f628daah,057f55ec5h,0e2220abeh,0d2916ebfh
	dd 04ec75b95h,024f2c3c0h,042d15d99h,0cd0d7fa0h,07b6e27ffh,0a8dc8af0h,07345c106h,0f41e232fh
	dd 035162386h,0e6ea8926h,03333b094h,0157ec6f2h,0372b74afh,0692573e4h,0e9a9d848h,0f3160289h
	dd 03a62ef1dh,0a787e238h,0f3a5f676h,074364853h,020951063h,04576698dh,0b6fad407h,0592af950h
	dd 036f73523h,04cfb6e87h,07da4cec0h,06c152daah,0cb0396a8h,0c50dfe5dh,0fcd707abh,00921c42fh
	dd 089dff0bbh,05fe2be78h,0448f4f33h,0754613c9h,02b05d08dh,048b9d585h,0dc049441h,0c8098f9bh
	dd 07dede786h,0c39a3373h,042410005h,06a091751h,00ef3c8a6h,0890072d6h,028207682h,0a9a9f7beh
	dd 0bf32679dh,0d45b5b75h,0b353fd00h,0cbb0e358h,0830f220ah,01f8fb214h,0d372cf08h,0cc3c4a13h
	dd 08cf63166h,0061c87beh,088c98f88h,06062e397h,047cf8e7ah,0b6c85283h,03cc2acfbh,03fc06976h
	dd 04e8f0252h,064d8314dh,0da3870e3h,01e665459h,0c10908f0h,0513021a5h,06c5b68b7h,0822f8aa0h
	dd 03007cd3eh,074719eefh,0dc872681h,0073340d4h,07e432fd9h,00c5ec241h,08809286ch,0f592d891h
	dd 008a930f6h,0957ef305h,0b7fbffbdh,0c266e96fh,06fe4ac98h,0b173ecc0h,0bc60b42ah,0953498dah
	dd 0fba1ae12h,02d4bd736h,00f25faabh,0a4f3fcebh,0e2969123h,0257f0c3dh,09348af49h,0361400bch
	dd 0e8816f4ah,03814f200h,0a3f94043h,09c7a54c2h,0bc704f57h,0da41e7f9h,0c25ad33ah,054f4a084h
	dd 0b17f5505h,059357cbeh,0edbd15c8h,07f97c5abh,0ba5ac7b5h,0b6f6deafh,03a479c3ah,05302da25h
	dd 0653d7e6ah,054268d49h,051a477eah,05017d55bh,0d7d25d88h,044136c76h,00404a8c8h,0b8e5a121h
	dd 0b81a928ah,060ed5869h,097c55b96h,0eaec991bh,029935913h,001fdb7f1h,0088e8dfah,09ab6f6f5h
	dd 03b4cbf9fh,04a5de3abh,0e6051d35h,0a0e1d855h,0d36b4cf1h,0f544edebh,0b0e93524h,0bebb8fbdh
	dd 0a2d762cfh,049c92f54h,038b5f331h,07128a454h,048392905h,0a65b1db8h,0851c97bdh,0d675cf2fh
	
S7	dd 085e04019h,0332bf567h,0662dbfffh,0cfc65693h,02a8d7f6fh,0ab9bc912h,0de6008a1h,02028da1fh
	dd 00227bce7h,04d642916h,018fac300h,050f18b82h,02cb2cb11h,0b232e75ch,04b3695f2h,0b28707deh
	dd 0a05fbcf6h,0cd4181e9h,0e150210ch,0e24ef1bdh,0b168c381h,0fde4e789h,05c79b0d8h,01e8bfd43h
	dd 04d495001h,038be4341h,0913cee1dh,092a79c3fh,0089766beh,0baeeadf4h,01286becfh,0b6eacb19h
	dd 02660c200h,07565bde4h,064241f7ah,08248dca9h,0c3b3ad66h,028136086h,00bd8dfa8h,0356d1cf2h
	dd 0107789beh,0b3b2e9ceh,00502aa8fh,00bc0351eh,0166bf52ah,0eb12ff82h,0e3486911h,0d34d7516h
	dd 04e7b3affh,05f43671bh,09cf6e037h,04981ac83h,0334266ceh,08c9341b7h,0d0d854c0h,0cb3a6c88h
	dd 047bc2829h,04725ba37h,0a66ad22bh,07ad61f1eh,00c5cbafah,04437f107h,0b6e79962h,042d2d816h
	dd 00a961288h,0e1a5c06eh,013749e67h,072fc081ah,0b1d139f7h,0f9583745h,0cf19df58h,0bec3f756h
	dd 0c06eba30h,007211b24h,045c28829h,0c95e317fh,0bc8ec511h,038bc46e9h,0c6e6fa14h,0bae8584ah
	dd 0ad4ebc46h,0468f508bh,07829435fh,0f124183bh,0821dba9fh,0aff60ff4h,0ea2c4e6dh,016e39264h
	dd 092544a8bh,0009b4fc3h,0aba68cedh,09ac96f78h,006a5b79ah,0b2856e6eh,01aec3ca9h,0be838688h
	dd 00e0804e9h,055f1be56h,0e7e5363bh,0b3a1f25dh,0f7debb85h,061fe033ch,016746233h,03c034c28h
	dd 0da6d0c74h,079aac56ch,03ce4e1adh,051f0c802h,098f8f35ah,01626a49fh,0eed82b29h,01d382fe3h
	dd 00c4fb99ah,0bb325778h,03ec6d97bh,06e77a6a9h,0cb658b5ch,0d45230c7h,02bd1408bh,060c03eb7h
	dd 0b9068d78h,0a33754f4h,0f430c87dh,0c8a71302h,0b96d8c32h,0ebd4e7beh,0be8b9d2dh,07979fb06h
	dd 0e7225308h,08b75cf77h,011ef8da4h,0e083c858h,08d6b786fh,05a6317a6h,0fa5cf7a0h,05dda0033h
	dd 0f28ebfb0h,0f5b9c310h,0a0eac280h,008b9767ah,0a3d9d2b0h,079d34217h,0021a718dh,09ac6336ah
	dd 02711fd60h,0438050e3h,0069908a8h,03d7fedc4h,0826d2befh,04eeb8476h,0488dcf25h,036c9d566h
	dd 028e74e41h,0c2610acah,03d49a9cfh,0bae3b9dfh,0b65f8de6h,092aeaf64h,03ac7d5e6h,09ea80509h
	dd 0f22b017dh,0a4173f70h,0dd1e16c3h,015e0d7f9h,050b1b887h,02b9f4fd5h,0625aba82h,06a017962h
	dd 02ec01b9ch,015488aa9h,0d716e740h,040055a2ch,093d29a22h,0e32dbf9ah,0058745b9h,03453dc1eh
	dd 0d699296eh,0496cff6fh,01c9f4986h,0dfe2ed07h,0b87242d1h,019de7eaeh,0053e561ah,015ad6f8ch
	dd 066626c1ch,07154c24ch,0ea082b2ah,093eb2939h,017dcb0f0h,058d4f2aeh,09ea294fbh,052cf564ch
	dd 09883fe66h,02ec40581h,0763953c3h,001d6692eh,0d3a0c108h,0a1e7160eh,0e4f2dfa6h,0693ed285h
	dd 074904698h,04c2b0eddh,04f757656h,05d393378h,0a132234fh,03d321c5dh,0c3f5e194h,04b269301h
	dd 0c79f022fh,03c997e7eh,05e4f9504h,03ffafbbdh,076f7ad0eh,0296693f4h,03d1fce6fh,0c61e45beh
	dd 0d3b5ab34h,0f72bf9b7h,01b0434c0h,04e72b567h,05592a33dh,0b5229301h,0cfd2a87fh,060aeb767h
	dd 01814386bh,030bcc33dh,038a0c07dh,0fd1606f2h,0c363519bh,0589dd390h,05479f8e6h,01cb8d647h
	dd 097fd61a9h,0ea7759f4h,02d57539dh,0569a58cfh,0e84e63adh,0462e1b78h,06580f87eh,0f3817914h
	dd 091da55f4h,040a230f3h,0d1988f35h,0b6e318d2h,03ffa50bch,03d40f021h,0c3c0bdaeh,04958c24ch
	dd 0518f36b2h,084b1d370h,00fedce83h,0878ddadah,0f2a279c7h,094e01be8h,090716f4bh,0954b8aa3h
	
S8	dd 0e216300dh,0bbddfffch,0a7ebdabdh,035648095h,07789f8b7h,0e6c1121bh,00e241600h,0052ce8b5h
	dd 011a9cfb0h,0e5952f11h,0ece7990ah,09386d174h,02a42931ch,076e38111h,0b12def3ah,037ddddfch
	dd 0de9adeb1h,00a0cc32ch,0be197029h,084a00940h,0bb243a0fh,0b4d137cfh,0b44e79f0h,0049eedfdh
	dd 00b15a15dh,0480d3168h,08bbbde5ah,0669ded42h,0c7ece831h,03f8f95e7h,072df191bh,07580330dh
	dd 094074251h,05c7dcdfah,0abbe6d63h,0aa402164h,0b301d40ah,002e7d1cah,053571daeh,07a3182a2h
	dd 012a8ddech,0fdaa335dh,0176f43e8h,071fb46d4h,038129022h,0ce949ad4h,0b84769adh,0965bd862h
	dd 082f3d055h,066fb9767h,015b80b4eh,01d5b47a0h,04cfde06fh,0c28ec4b8h,057e8726eh,0647a78fch
	dd 099865d44h,0608bd593h,06c200e03h,039dc5ff6h,05d0b00a3h,0ae63aff2h,07e8bd632h,070108c0ch
	dd 0bbd35049h,02998df04h,0980cf42ah,09b6df491h,09e7edd53h,006918548h,058cb7e07h,03b74ef2eh
	dd 0522fffb1h,0d24708cch,01c7e27cdh,0a4eb215bh,03cf1d2e2h,019b47a38h,0424f7618h,035856039h
	dd 09d17dee7h,027eb35e6h,0c9aff67bh,036baf5b8h,009c467cdh,0c18910b1h,0e11dbf7bh,006cd1af8h
	dd 07170c608h,02d5e3354h,0d4de495ah,064c6d006h,0bcc0c62ch,03dd00db3h,0708f8f34h,077d51b42h
	dd 0264f620fh,024b8d2bfh,015c1b79eh,046a52564h,0f8d7e54eh,03e378160h,07895cda5h,0859c15a5h
	dd 0e6459788h,0c37bc75fh,0db07ba0ch,00676a3abh,07f229b1eh,031842e7bh,024259fd7h,0f8bef472h
	dd 0835ffcb8h,06df4c1f2h,096f5b195h,0fd0af0fch,0b0fe134ch,0e2506d3dh,04f9b12eah,0f215f225h
	dd 0a223736fh,09fb4c428h,025d04979h,034c713f8h,0c4618187h,0ea7a6e98h,07cd16efch,01436876ch
	dd 0f1544107h,0bedeee14h,056e9af27h,0a04aa441h,03cf7c899h,092ecbae6h,0dd67016dh,0151682ebh
	dd 0a842eedfh,0fdba60b4h,0f1907b75h,020e3030fh,024d8c29eh,0e139673bh,0efa63fb8h,071873054h
	dd 0b6f2cf3bh,09f326442h,0cb15a4cch,0b01a4504h,0f1e47d8dh,0844a1be5h,0bae7dfdch,042cbda70h
	dd 0cd7dae0ah,057e85b7ah,0d53f5af6h,020cf4d8ch,0cea4d428h,079d130a4h,03486ebfbh,033d3cddch
	dd 077853b53h,037effcb5h,0c5068778h,0e580b3e6h,04e68b8f4h,0c5c8b37eh,00d809ea2h,0398feb7ch
	dd 0132a4f94h,043b7950eh,02fee7d1ch,0223613bdh,0dd06caa2h,037df932bh,0c4248289h,0acf3ebc3h
	dd 05715f6b7h,0ef3478ddh,0f267616fh,0c148cbe4h,09052815eh,05e410fabh,0b48a2465h,02eda7fa4h
	dd 0e87b40e4h,0e98ea084h,05889e9e1h,0efd390fch,0dd07d35bh,0db485694h,038d7e5b2h,057720101h
	dd 0730edebch,05b643113h,094917e4fh,0503c2fbah,0646f1282h,07523d24ah,0e0779695h,0f9c17a8fh
	dd 07a5b2121h,0d187b896h,029263a4dh,0ba510cdfh,081f47c9fh,0ad1163edh,0ea7b5965h,01a00726eh
	dd 011403092h,000da6d77h,04a0cdd61h,0ad1f4603h,0605bdfb0h,09eedc364h,022ebe6a8h,0cee7d28ah
	dd 0a0e736a0h,05564a6b9h,010853209h,0c7eb8f37h,02de705cah,08951570fh,0df09822bh,0bd691a6ch
	dd 0aa12e4f2h,087451c0fh,0e0f6a27ah,03ada4819h,04cf1764fh,00d771c2bh,067cdb156h,0350d8384h
	dd 05938fa0fh,042399ef3h,036997b07h,00e84093dh,04aa93e61h,08360d87bh,01fa98b0ch,01149382ch
	dd 0e97625a5h,00614d1b7h,00e25244bh,00c768347h,0589e8d82h,00d2059d1h,0a466bb1eh,0f8da0a82h
	dd 004f19130h,0ba6e4ec0h,099265164h,01ee7230dh,050b2ad80h,0eaee6801h,08db2a283h,0ea8bf59eh

.data?
IF	KEY_SIZE eq 128
cast128_internalKey	dd 32 dup (?)
ELSEIF	KEY_SIZE eq  80
cast128_internalKey	dd 24 dup (?)
ENDIF

cast128_tempkey		dd  8 dup (?)
.code
CAST128_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			INVOKE CAST128_SetKey,addr sKeyIn
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
			INVOKE CAST128_Encrypt,offset bf_tempbuf,offset bf_encryptbuf
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
			INVOKE CAST128_Clear
			INVOKE lstrlen,_Output
			HexLen
		.ENDIF
		ret
CAST128_ENC_RT endp
CAST128_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 16)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen116
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
	
		INVOKE CAST128_SetKey,addr sKeyIn
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
			
		
			INVOKE CAST128_Decrypt,offset bf_tempbuf,offset bf_encryptbuf
			DecryptEnd 8
			mov	eax,dword ptr[esi]
			mov	edx,dword ptr[esi+4]
			
			mov	dword ptr[edi+4*0],eax
			mov	dword ptr[edi+4*1],edx
			add	edi,8
			pop	esi
			add	esi,8
			sub	ebx,8
			;ce766f7a6e7575e775a123c01a9a0f5a
			cmp	ebx,0
			jg	DecryptLoop
			;now we need to clean it up :)
			INVOKE CAST128_Clear
		INVOKE lstrlen,_Output
		mov	edi,_Output
		movzx	ebx,byte ptr[edi+eax-1];get last char
		.if	ebx < 8	;padding chars are 1-8
			sub	eax,ebx	;fix up length 
			mov	byte ptr[edi+eax],0	;clear it up :)
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
CAST128_DEC_RT endp
OPTION PROLOGUE:None		;we don't want prologue
OPTION EPILOGUE:None		;and epilogue code this time

CAST128_SetKey	proc	arg1:DWORD

	pushad
	
	cld
	mov	esi, dword ptr [esp+ 24h]
	mov	edi, offset cast128_tempkey

IF	KEY_SIZE eq 128

	xor	ebx, ebx
	xor	ecx, ecx
@@:	mov	eax, dword ptr [esi+ecx]
.if bBswapKey
	
	bswap	eax
.endif
	mov	dword ptr [edi+ecx], eax
	add	ecx, 4
	and	ecx, 0Fh
	jnz	@B

	mov	esi, offset cast128_internalKey
@@:
	call	@hash

	KEYS	z8, z9, z7, z6, S5, z2
	KEYS	zA, zB, z5, z4, S6, z6
	KEYS	zC, zD, z3, z2, S7, z9
	KEYS	zE, zF, z1, z0, S8, zC
	KEYS	x3, _x2, xC, xD, S5, x8
	KEYS	x1, x0, xE, xF, S6, xD
	KEYS	x7, x6, x8, x9, S7, x3
	KEYS	x5, x4, xA, xB, S8, x7

	call	@hash

	KEYS	z3, z2, zC, zD, S5, z9
	KEYS	z1, z0, zE, zF, S6, zC
	KEYS	z7, z6, z8, z9, S7, z2
	KEYS	z5, z4, zA, zB, S8, z6
	KEYS	x8, x9, x7, x6, S5, x3
	KEYS	xA, xB, x5, x4, S6, x7
	KEYS	xC, xD, x3, _x2, S7, x8
	KEYS	xE, xF, x1, x0, S8, xD

	cmp	esi, offset cast128_internalKey + 32*4
	jnz	@B

	sub	esi, 16*4
@@:	add	dword ptr [esi], 16			;!!!
	and	dword ptr [esi], 1Fh
	add	esi, 4
	cmp	esi, offset cast128_internalKey + 32*4
	jnz	@B

ELSEIF	KEY_SIZE eq 80

	xor	eax, eax
	xor	ebx, ebx
	mov	ecx, 10
	cld
	rep	movsb
	mov	ecx, 6
	rep	stosb

	mov	esi, offset cast128_internalKey
	sub	edi, 16

	mov	eax, dword ptr [edi]
	mov	edx, dword ptr [edi+4]
	.if bBswapKey
	bswap	eax
	bswap	edx
	.endif
	mov	dword ptr [edi], eax
	mov	dword ptr [edi+4], edx

	mov	eax, dword ptr [edi+8]
	.if bBswapKey
	bswap	eax
	.endif
	mov	dword ptr [edi+8], eax

@@:
	call	@hash

	KEYS	z8, z9, z7, z6, S5, z2
	KEYS	zA, zB, z5, z4, S6, z6
	KEYS	zC, zD, z3, z2, S7, z9
	KEYS	zE, zF, z1, z0, S8, zC
	KEYS	x3, _x2, xC, xD, S5, x8
	KEYS	x1, x0, xE, xF, S6, xD
	KEYS	x7, x6, x8, x9, S7, x3
	KEYS	x5, x4, xA, xB, S8, x7

	call	@hash

	KEYS	z3, z2, zC, zD, S5, z9
	KEYS	z1, z0, zE, zF, S6, zC
	KEYS	z7, z6, z8, z9, S7, z2
	KEYS	z5, z4, zA, zB, S8, z6

	cmp	esi, offset cast128_internalKey + 24*4
	jnz	@B

	sub	esi, 12*4
@@:	add	dword ptr [esi], 16			;!!!
	and	dword ptr [esi], 1Fh
	add	esi, 4
	cmp	esi, offset cast128_internalKey + 24*4
	jnz	@B

ENDIF
	popad
	ret	4

@hash:
	mov	eax, xCDEF

	KEY_FROM_EAX	S6, S8, S5, S7, S7, x0123, x8, z0123	;z0123	= x0123 ^ S5[xD] ^ S6[xF] ^ S7[xC] ^ S8[xE] ^ S7[x8];	//xCDEF, x8
	KEY_FROM_EDX	S8, S6, S7, S5, S8, x89AB, xA, z4567	;z4567	= x89AB ^ S5[z0] ^ S6[z2] ^ S7[z1] ^ S8[z3] ^ S8[xA];	//z0123, xA
	KEY_FROM_EAX	S5, S6, S7, S8, S5, xCDEF, x9, z89AB	;z89AB	= xCDEF ^ S5[z7] ^ S6[z6] ^ S7[z5] ^ S8[z4] ^ S5[x9];	//z4567, x9
	KEY_FROM_EDX	S7, S5, S6, S8, S6, x4567, xB, zCDEF	;zCDEF	= x4567 ^ S5[zA] ^ S6[z9] ^ S7[zB] ^ S8[z8] ^ S6[xB];	//z89AB, xB

	mov	eax, z4567
	
	KEY_FROM_EAX	S6, S8, S5, S7, S7, z89AB, z0, x0123	;x0123	= z89AB ^ S5[z5] ^ S6[z7] ^ S7[z4] ^ S8[z6] ^ S7[z0];	//z4567, z0
	KEY_FROM_EDX	S8, S6, S7, S5, S8, z0123, z2, x4567	;x4567	= z0123 ^ S5[x0] ^ S6[_x2] ^ S7[x1] ^ S8[x3] ^ S8[z2];	//x0123, z2
	KEY_FROM_EAX	S5, S6, S7, S8, S5, z4567, z1, x89AB	;x89AB	= z4567 ^ S5[x7] ^ S6[x6] ^ S7[x5] ^ S8[x4] ^ S5[z1];	//x4567, z1
	KEY_FROM_EDX	S7, S5, S6, S8, S6, zCDEF, z3, xCDEF	;xCDEF	= zCDEF ^ S5[xA] ^ S6[x9] ^ S7[xB] ^ S8[x8] ^ S6[z3];	//x89AB, z3

	ret
CAST128_SetKey	endp

CAST128_Clear	proc
	push	ecx
IF	KEY_SIZE eq 128
	mov	ecx, (40-1)*4
ELSEIF	KEY_SIZE eq  80
	mov	ecx, (32-1)*4
ENDIF
@@:	and	dword ptr [cast128_internalKey+ecx], 0
	sub	ecx, 4
	jns	@B
	pop	ecx
	ret
CAST128_Clear	endp

CAST128_Encrypt	proc	arg1:DWORD, arg2:DWORD

	pushad
	mov	esi, dword ptr [esp+ 28h]		; offset plain
	mov	edi, offset cast128_internalKey
	
	mov	ebp, dword ptr [esi]
	mov	esi, dword ptr [esi+4]
	.if bBswapInput
	bswap	ebp	
	bswap	esi
	.endif
	xor	ebx, ebx
	xor	edx, edx

	ROUND_1		esi, ebp,  0
	ROUND_2		ebp, esi,  1
	ROUND_3		esi, ebp,  2
	ROUND_1		ebp, esi,  3
	ROUND_2		esi, ebp,  4
	ROUND_3		ebp, esi,  5
	ROUND_1		esi, ebp,  6
	ROUND_2		ebp, esi,  7
	ROUND_3		esi, ebp,  8
	ROUND_1		ebp, esi,  9
	ROUND_2		esi, ebp, 10
	ROUND_3		ebp, esi, 11

IF	KEY_SIZE eq 128
	ROUND_1		esi, ebp, 12
	ROUND_2		ebp, esi, 13
	ROUND_3		esi, ebp, 14
	ROUND_1		ebp, esi, 15
ENDIF
	.if bBswapInput
	
	bswap	ebp
	bswap	esi
	.endif
	mov	edi, dword ptr [esp+ 24h]
	mov	dword ptr [edi], esi
	mov	dword ptr [edi+4], ebp

	popad
	ret	8
CAST128_Encrypt	endp

CAST128_Decrypt	proc	arg1:DWORD, arg2:DWORD

	pushad
	mov	esi, dword ptr [esp+ 28h]		; offset input
	mov	edi, offset cast128_internalKey
	
	mov	ebp, dword ptr [esi]
	mov	esi, dword ptr [esi+4]
	.if bBswapInput
	
	bswap	ebp
	bswap	esi
	.endif
	xor	ebx, ebx
	xor	edx, edx

IF	KEY_SIZE eq 128
	ROUND_1		esi, ebp, 15
	ROUND_3		ebp, esi, 14
	ROUND_2		esi, ebp, 13
	ROUND_1		ebp, esi, 12
ENDIF
	ROUND_3		esi, ebp, 11
	ROUND_2		ebp, esi, 10
	ROUND_1		esi, ebp,  9
	ROUND_3		ebp, esi,  8
	ROUND_2		esi, ebp,  7
	ROUND_1		ebp, esi,  6
	ROUND_3		esi, ebp,  5
	ROUND_2		ebp, esi,  4
	ROUND_1		esi, ebp,  3
	ROUND_3		ebp, esi,  2
	ROUND_2		esi, ebp,  1
	ROUND_1		ebp, esi,  0
	.if bBswapInput
	
	bswap	ebp
	bswap	esi
	.endif
	mov	edi, dword ptr [esp+ 24h]		; offset output
	mov	dword ptr [edi], esi
	mov	dword ptr [edi+4], ebp

	popad
	ret	8
CAST128_Decrypt	endp

OPTION EPILOGUE:EPILOGUEDEF
OPTION PROLOGUE:PROLOGUEDEF	;but on exit set it to default

ALIGN	16
