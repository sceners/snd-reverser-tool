comment ~

Algo	: CAST-256 by Carlisle Adams (+ Howard Heys, Stafford Tavares, Michael Wiener)
Block	: 16 bytes
Key	: 32 bytes (256b)

	push	offset password
	call	Cast256_SetKey

	push	offset plaintext
	push	offset ciphertext
	call	Cast256_Encrypt

	push	offset ciphertext
	push	offset plaintext
	call	Cast256_Decrypt

	call	Cast256_Clear


24.03.2002 WiteG//xtreeme (witeg@poczta.fm, www.witeg.prv.pl)

~
f1	macro	userKey, point, key_point

	mov	eax, dword ptr [key_point]
	mov	ecx, dword ptr [key_point+ point]
	add	eax, userKey
	rol	eax, cl
	mov	bl, ah		;_S2
	mov	cl, al		;_S3
	shr	eax, 16
	mov	dl, al		;_S1
	shr	eax, 8		;S0

	mov	eax, dword ptr [S0 + 4*eax]
	xor	eax, dword ptr [_S1 + 4*edx]
	sub	eax, dword ptr [_S2 + 4*ebx]
	add	eax, dword ptr [_S3 + 4*ecx]

endm

f2	macro	userKey, point, key_point

	mov	eax, dword ptr [key_point]
	mov	ecx, dword ptr [key_point+ point]
	xor	eax, userKey
	rol	eax, cl
	mov	bl, ah		;_S2
	mov	cl, al		;_S3
	shr	eax, 16
	mov	dl, al		;_S1
	shr	eax, 8		;S0

	mov	eax, dword ptr [S0 + 4*eax]
	sub	eax, dword ptr [_S1 + 4*edx]
	add	eax, dword ptr [_S2 + 4*ebx]
	xor	eax, dword ptr [_S3 + 4*ecx]

endm

f3	macro	userKey, point, key_point

	mov	eax, dword ptr [key_point]
	mov	ecx, dword ptr [key_point+ point]
	sub	eax, userKey
	rol	eax, cl
	mov	bl, ah		;_S2
	mov	cl, al		;_S3
	shr	eax, 16
	mov	dl, al		;_S1
	shr	eax, 8		;S0

	mov	eax, dword ptr [S0 + 4*eax]
	add	eax, dword ptr [_S1 + 4*edx]
	xor	eax, dword ptr [_S2 + 4*ebx]
	sub	eax, dword ptr [_S3 + 4*ecx]

endm

.code
S0		dd	030FB40D4h, 09FA0FF0Bh, 06BECCD2Fh, 03F258C7Ah, 01E213F2Fh, 09C004DD3h, 06003E540h, 0CF9FC949h
		dd	0BFD4AF27h, 088BBBDB5h, 0E2034090h, 098D09675h, 06E63A0E0h, 015C361D2h, 0C2E7661Dh, 022D4FF8Eh
		dd	028683B6Fh, 0C07FD059h, 0FF2379C8h, 0775F50E2h, 043C340D3h, 0DF2F8656h, 0887CA41Ah, 0A2D2BD2Dh
		dd	0A1C9E0D6h, 0346C4819h, 061B76D87h, 022540F2Fh, 02ABE32E1h, 0AA54166Bh, 022568E3Ah, 0A2D341D0h
		dd	066DB40C8h, 0A784392Fh, 0004DFF2Fh, 02DB9D2DEh, 097943FACh, 04A97C1D8h, 0527644B7h, 0B5F437A7h
		dd	0B82CBAEFh, 0D751D159h, 06FF7F0EDh, 05A097A1Fh, 0827B68D0h, 090ECF52Eh, 022B0C054h, 0BC8E5935h
		dd	04B6D2F7Fh, 050BB64A2h, 0D2664910h, 0BEE5812Dh, 0B7332290h, 0E93B159Fh, 0B48EE411h, 04BFF345Dh
		dd	0FD45C240h, 0AD31973Fh, 0C4F6D02Eh, 055FC8165h, 0D5B1CAADh, 0A1AC2DAEh, 0A2D4B76Dh, 0C19B0C50h
		dd	0882240F2h, 00C6E4F38h, 0A4E4BFD7h, 04F5BA272h, 0564C1D2Fh, 0C59C5319h, 0B949E354h, 0B04669FEh
		dd	0B1B6AB8Ah, 0C71358DDh, 06385C545h, 0110F935Dh, 057538AD5h, 06A390493h, 0E63D37E0h, 02A54F6B3h
		dd	03A787D5Fh, 06276A0B5h, 019A6FCDFh, 07A42206Ah, 029F9D4D5h, 0F61B1891h, 0BB72275Eh, 0AA508167h
		dd	038901091h, 0C6B505EBh, 084C7CB8Ch, 02AD75A0Fh, 0874A1427h, 0A2D1936Bh, 02AD286AFh, 0AA56D291h
		dd	0D7894360h, 0425C750Dh, 093B39E26h, 0187184C9h, 06C00B32Dh, 073E2BB14h, 0A0BEBC3Ch, 054623779h
		dd	064459EABh, 03F328B82h, 07718CF82h, 059A2CEA6h, 004EE002Eh, 089FE78E6h, 03FAB0950h, 0325FF6C2h
		dd	081383F05h, 06963C5C8h, 076CB5AD6h, 0D49974C9h, 0CA180DCFh, 0380782D5h, 0C7FA5CF6h, 08AC31511h
		dd	035E79E13h, 047DA91D0h, 0F40F9086h, 0A7E2419Eh, 031366241h, 0051EF495h, 0AA573B04h, 04A805D8Dh
		dd	0548300D0h, 000322A3Ch, 0BF64CDDFh, 0BA57A68Eh, 075C6372Bh, 050AFD341h, 0A7C13275h, 0915A0BF5h
		dd	06B54BFABh, 02B0B1426h, 0AB4CC9D7h, 0449CCD82h, 0F7FBF265h, 0AB85C5F3h, 01B55DB94h, 0AAD4E324h
		dd	0CFA4BD3Fh, 02DEAA3E2h, 09E204D02h, 0C8BD25ACh, 0EADF55B3h, 0D5BD9E98h, 0E31231B2h, 02AD5AD6Ch
		dd	0954329DEh, 0ADBE4528h, 0D8710F69h, 0AA51C90Fh, 0AA786BF6h, 022513F1Eh, 0AA51A79Bh, 02AD344CCh
		dd	07B5A41F0h, 0D37CFBADh, 01B069505h, 041ECE491h, 0B4C332E6h, 0032268D4h, 0C9600ACCh, 0CE387E6Dh
		dd	0BF6BB16Ch, 06A70FB78h, 00D03D9C9h, 0D4DF39DEh, 0E01063DAh, 04736F464h, 05AD328D8h, 0B347CC96h
		dd	075BB0FC3h, 098511BFBh, 04FFBCC35h, 0B58BCF6Ah, 0E11F0ABCh, 0BFC5FE4Ah, 0A70AEC10h, 0AC39570Ah
		dd	03F04442Fh, 06188B153h, 0E0397A2Eh, 05727CB79h, 09CEB418Fh, 01CACD68Dh, 02AD37C96h, 00175CB9Dh
		dd	0C69DFF09h, 0C75B65F0h, 0D9DB40D8h, 0EC0E7779h, 04744EAD4h, 0B11C3274h, 0DD24CB9Eh, 07E1C54BDh
		dd	0F01144F9h, 0D2240EB1h, 09675B3FDh, 0A3AC3755h, 0D47C27AFh, 051C85F4Dh, 056907596h, 0A5BB15E6h
		dd	0580304F0h, 0CA042CF1h, 0011A37EAh, 08DBFAADBh, 035BA3E4Ah, 03526FFA0h, 0C37B4D09h, 0BC306ED9h
		dd	098A52666h, 05648F725h, 0FF5E569Dh, 00CED63D0h, 07C63B2CFh, 0700B45E1h, 0D5EA50F1h, 085A92872h
		dd	0AF1FBDA7h, 0D4234870h, 0A7870BF3h, 02D3B4D79h, 042E04198h, 00CD0EDE7h, 026470DB8h, 0F881814Ch
		dd	0474D6AD7h, 07C0C5E5Ch, 0D1231959h, 0381B7298h, 0F5D2F4DBh, 0AB838653h, 06E2F1E23h, 083719C9Eh
		dd	0BD91E046h, 09A56456Eh, 0DC39200Ch, 020C8C571h, 0962BDA1Ch, 0E1E696FFh, 0B141AB08h, 07CCA89B9h
		dd	01A69E783h, 002CC4843h, 0A2F7C579h, 0429EF47Dh, 0427B169Ch, 05AC9F049h, 0DD8F0F00h, 05C8165BFh

_S1		dd	01F201094h, 0EF0BA75Bh, 069E3CF7Eh, 0393F4380h, 0FE61CF7Ah, 0EEC5207Ah, 055889C94h, 072FC0651h
		dd	0ADA7EF79h, 04E1D7235h, 0D55A63CEh, 0DE0436BAh, 099C430EFh, 05F0C0794h, 018DCDB7Dh, 0A1D6EFF3h
		dd	0A0B52F7Bh, 059E83605h, 0EE15B094h, 0E9FFD909h, 0DC440086h, 0EF944459h, 0BA83CCB3h, 0E0C3CDFBh
		dd	0D1DA4181h, 03B092AB1h, 0F997F1C1h, 0A5E6CF7Bh, 001420DDBh, 0E4E7EF5Bh, 025A1FF41h, 0E180F806h
		dd	01FC41080h, 0179BEE7Ah, 0D37AC6A9h, 0FE5830A4h, 098DE8B7Fh, 077E83F4Eh, 079929269h, 024FA9F7Bh
		dd	0E113C85Bh, 0ACC40083h, 0D7503525h, 0F7EA615Fh, 062143154h, 00D554B63h, 05D681121h, 0C866C359h
		dd	03D63CF73h, 0CEE234C0h, 0D4D87E87h, 05C672B21h, 0071F6181h, 039F7627Fh, 0361E3084h, 0E4EB573Bh
		dd	0602F64A4h, 0D63ACD9Ch, 01BBC4635h, 09E81032Dh, 02701F50Ch, 099847AB4h, 0A0E3DF79h, 0BA6CF38Ch
		dd	010843094h, 02537A95Eh, 0F46F6FFEh, 0A1FF3B1Fh, 0208CFB6Ah, 08F458C74h, 0D9E0A227h, 04EC73A34h
		dd	0FC884F69h, 03E4DE8DFh, 0EF0E0088h, 03559648Dh, 08A45388Ch, 01D804366h, 0721D9BFDh, 0A58684BBh
		dd	0E8256333h, 0844E8212h, 0128D8098h, 0FED33FB4h, 0CE280AE1h, 027E19BA5h, 0D5A6C252h, 0E49754BDh
		dd	0C5D655DDh, 0EB667064h, 077840B4Dh, 0A1B6A801h, 084DB26A9h, 0E0B56714h, 021F043B7h, 0E5D05860h
		dd	054F03084h, 0066FF472h, 0A31AA153h, 0DADC4755h, 0B5625DBFh, 068561BE6h, 083CA6B94h, 02D6ED23Bh
		dd	0ECCF01DBh, 0A6D3D0BAh, 0B6803D5Ch, 0AF77A709h, 033B4A34Ch, 0397BC8D6h, 05EE22B95h, 05F0E5304h
		dd	081ED6F61h, 020E74364h, 0B45E1378h, 0DE18639Bh, 0881CA122h, 0B96726D1h, 08049A7E8h, 022B7DA7Bh
		dd	05E552D25h, 05272D237h, 079D2951Ch, 0C60D894Ch, 0488CB402h, 01BA4FE5Bh, 0A4B09F6Bh, 01CA815CFh
		dd	0A20C3005h, 08871DF63h, 0B9DE2FCBh, 00CC6C9E9h, 00BEEFF53h, 0E3214517h, 0B4542835h, 09F63293Ch
		dd	0EE41E729h, 06E1D2D7Ch, 050045286h, 01E6685F3h, 0F33401C6h, 030A22C95h, 031A70850h, 060930F13h
		dd	073F98417h, 0A1269859h, 0EC645C44h, 052C877A9h, 0CDFF33A6h, 0A02B1741h, 07CBAD9A2h, 02180036Fh
		dd	050D99C08h, 0CB3F4861h, 0C26BD765h, 064A3F6ABh, 080342676h, 025A75E7Bh, 0E4E6D1FCh, 020C710E6h
		dd	0CDF0B680h, 017844D3Bh, 031EEF84Dh, 07E0824E4h, 02CCB49EBh, 0846A3BAEh, 08FF77888h, 0EE5D60F6h
		dd	07AF75673h, 02FDD5CDBh, 0A11631C1h, 030F66F43h, 0B3FAEC54h, 0157FD7FAh, 0EF8579CCh, 0D152DE58h
		dd	0DB2FFD5Eh, 08F32CE19h, 0306AF97Ah, 002F03EF8h, 099319AD5h, 0C242FA0Fh, 0A7E3EBB0h, 0C68E4906h
		dd	0B8DA230Ch, 080823028h, 0DCDEF3C8h, 0D35FB171h, 0088A1BC8h, 0BEC0C560h, 061A3C9E8h, 0BCA8F54Dh
		dd	0C72FEFFAh, 022822E99h, 082C570B4h, 0D8D94E89h, 08B1C34BCh, 0301E16E6h, 0273BE979h, 0B0FFEAA6h
		dd	061D9B8C6h, 000B24869h, 0B7FFCE3Fh, 008DC283Bh, 043DAF65Ah, 0F7E19798h, 07619B72Fh, 08F1C9BA4h
		dd	0DC8637A0h, 016A7D3B1h, 09FC393B7h, 0A7136EEBh, 0C6BCC63Eh, 01A513742h, 0EF6828BCh, 0520365D6h
		dd	02D6A77ABh, 03527ED4Bh, 0821FD216h, 0095C6E2Eh, 0DB92F2FBh, 05EEA29CBh, 0145892F5h, 091584F7Fh
		dd	05483697Bh, 02667A8CCh, 085196048h, 08C4BACEAh, 0833860D4h, 00D23E0F9h, 06C387E8Ah, 00AE6D249h
		dd	0B284600Ch, 0D835731Dh, 0DCB1C647h, 0AC4C56EAh, 03EBD81B3h, 0230EABB0h, 06438BC87h, 0F0B5B1FAh
		dd	08F5EA2B3h, 0FC184642h, 00A036B7Ah, 04FB089BDh, 0649DA589h, 0A345415Eh, 05C038323h, 03E5D3BB9h
		dd	043D79572h, 07E6DD07Ch, 006DFDF1Eh, 06C6CC4EFh, 07160A539h, 073BFBE70h, 083877605h, 04523ECF1h

_S2		dd	08DEFC240h, 025FA5D9Fh, 0EB903DBFh, 0E810C907h, 047607FFFh, 0369FE44Bh, 08C1FC644h, 0AECECA90h
		dd	0BEB1F9BFh, 0EEFBCAEAh, 0E8CF1950h, 051DF07AEh, 0920E8806h, 0F0AD0548h, 0E13C8D83h, 0927010D5h
		dd	011107D9Fh, 007647DB9h, 0B2E3E4D4h, 03D4F285Eh, 0B9AFA820h, 0FADE82E0h, 0A067268Bh, 08272792Eh
		dd	0553FB2C0h, 0489AE22Bh, 0D4EF9794h, 0125E3FBCh, 021FFFCEEh, 0825B1BFDh, 09255C5EDh, 01257A240h
		dd	04E1A8302h, 0BAE07FFFh, 0528246E7h, 08E57140Eh, 03373F7BFh, 08C9F8188h, 0A6FC4EE8h, 0C982B5A5h
		dd	0A8C01DB7h, 0579FC264h, 067094F31h, 0F2BD3F5Fh, 040FFF7C1h, 01FB78DFCh, 08E6BD2C1h, 0437BE59Bh
		dd	099B03DBFh, 0B5DBC64Bh, 0638DC0E6h, 055819D99h, 0A197C81Ch, 04A012D6Eh, 0C5884A28h, 0CCC36F71h
		dd	0B843C213h, 06C0743F1h, 08309893Ch, 00FEDDD5Fh, 02F7FE850h, 0D7C07F7Eh, 002507FBFh, 05AFB9A04h
		dd	0A747D2D0h, 01651192Eh, 0AF70BF3Eh, 058C31380h, 05F98302Eh, 0727CC3C4h, 00A0FB402h, 00F7FEF82h
		dd	08C96FDADh, 05D2C2AAEh, 08EE99A49h, 050DA88B8h, 08427F4A0h, 01EAC5790h, 0796FB449h, 08252DC15h
		dd	0EFBD7D9Bh, 0A672597Dh, 0ADA840D8h, 045F54504h, 0FA5D7403h, 0E83EC305h, 04F91751Ah, 0925669C2h
		dd	023EFE941h, 0A903F12Eh, 060270DF2h, 00276E4B6h, 094FD6574h, 0927985B2h, 08276DBCBh, 002778176h
		dd	0F8AF918Dh, 04E48F79Eh, 08F616DDFh, 0E29D840Eh, 0842F7D83h, 0340CE5C8h, 096BBB682h, 093B4B148h
		dd	0EF303CABh, 0984FAF28h, 0779FAF9Bh, 092DC560Dh, 0224D1E20h, 08437AA88h, 07D29DC96h, 02756D3DCh
		dd	08B907CEEh, 0B51FD240h, 0E7C07CE3h, 0E566B4A1h, 0C3E9615Eh, 03CF8209Dh, 06094D1E3h, 0CD9CA341h
		dd	05C76460Eh, 000EA983Bh, 0D4D67881h, 0FD47572Ch, 0F76CEDD9h, 0BDA8229Ch, 0127DADAAh, 0438A074Eh
		dd	01F97C090h, 0081BDB8Ah, 093A07EBEh, 0B938CA15h, 097B03CFFh, 03DC2C0F8h, 08D1AB2ECh, 064380E51h
		dd	068CC7BFBh, 0D90F2788h, 012490181h, 05DE5FFD4h, 0DD7EF86Ah, 076A2E214h, 0B9A40368h, 0925D958Fh
		dd	04B39FFFAh, 0BA39AEE9h, 0A4FFD30Bh, 0FAF7933Bh, 06D498623h, 0193CBCFAh, 027627545h, 0825CF47Ah
		dd	061BD8BA0h, 0D11E42D1h, 0CEAD04F4h, 0127EA392h, 010428DB7h, 08272A972h, 09270C4A8h, 0127DE50Bh
		dd	0285BA1C8h, 03C62F44Fh, 035C0EAA5h, 0E805D231h, 0428929FBh, 0B4FCDF82h, 04FB66A53h, 00E7DC15Bh
		dd	01F081FABh, 0108618AEh, 0FCFD086Dh, 0F9FF2889h, 0694BCC11h, 0236A5CAEh, 012DECA4Dh, 02C3F8CC5h
		dd	0D2D02DFEh, 0F8EF5896h, 0E4CF52DAh, 095155B67h, 0494A488Ch, 0B9B6A80Ch, 05C8F82BCh, 089D36B45h
		dd	03A609437h, 0EC00C9A9h, 044715253h, 00A874B49h, 0D773BC40h, 07C34671Ch, 002717EF6h, 04FEB5536h
		dd	0A2D02FFFh, 0D2BF60C4h, 0D43F03C0h, 050B4EF6Dh, 007478CD1h, 0006E1888h, 0A2E53F55h, 0B9E6D4BCh
		dd	0A2048016h, 097573833h, 0D7207D67h, 0DE0F8F3Dh, 072F87B33h, 0ABCC4F33h, 07688C55Dh, 07B00A6B0h
		dd	0947B0001h, 0570075D2h, 0F9BB88F8h, 08942019Eh, 04264A5FFh, 0856302E0h, 072DBD92Bh, 0EE971B69h
		dd	06EA22FDEh, 05F08AE2Bh, 0AF7A616Dh, 0E5C98767h, 0CF1FEBD2h, 061EFC8C2h, 0F1AC2571h, 0CC8239C2h
		dd	067214CB8h, 0B1E583D1h, 0B7DC3E62h, 07F10BDCEh, 0F90A5C38h, 00FF0443Dh, 0606E6DC6h, 060543A49h
		dd	05727C148h, 02BE98A1Dh, 08AB41738h, 020E1BE24h, 0AF96DA0Fh, 068458425h, 099833BE5h, 0600D457Dh
		dd	0282F9350h, 08334B362h, 0D91D1120h, 02B6D8DA0h, 0642B1E31h, 09C305A00h, 052BCE688h, 01B03588Ah
		dd	0F7BAEFD5h, 04142ED9Ch, 0A4315C11h, 083323EC5h, 0DFEF4636h, 0A133C501h, 0E9D3531Ch, 0EE353783h

_S3		dd	09DB30420h, 01FB6E9DEh, 0A7BE7BEFh, 0D273A298h, 04A4F7BDBh, 064AD8C57h, 085510443h, 0FA020ED1h
		dd	07E287AFFh, 0E60FB663h, 0095F35A1h, 079EBF120h, 0FD059D43h, 06497B7B1h, 0F3641F63h, 0241E4ADFh
		dd	028147F5Fh, 04FA2B8CDh, 0C9430040h, 00CC32220h, 0FDD30B30h, 0C0A5374Fh, 01D2D00D9h, 024147B15h
		dd	0EE4D111Ah, 00FCA5167h, 071FF904Ch, 02D195FFEh, 01A05645Fh, 00C13FEFEh, 0081B08CAh, 005170121h
		dd	080530100h, 0E83E5EFEh, 0AC9AF4F8h, 07FE72701h, 0D2B8EE5Fh, 006DF4261h, 0BB9E9B8Ah, 07293EA25h
		dd	0CE84FFDFh, 0F5718801h, 03DD64B04h, 0A26F263Bh, 07ED48400h, 0547EEBE6h, 0446D4CA0h, 06CF3D6F5h
		dd	02649ABDFh, 0AEA0C7F5h, 036338CC1h, 0503F7E93h, 0D3772061h, 011B638E1h, 072500E03h, 0F80EB2BBh
		dd	0ABE0502Eh, 0EC8D77DEh, 057971E81h, 0E14F6746h, 0C9335400h, 06920318Fh, 0081DBB99h, 0FFC304A5h
		dd	04D351805h, 07F3D5CE3h, 0A6C866C6h, 05D5BCCA9h, 0DAEC6FEAh, 09F926F91h, 09F46222Fh, 03991467Dh
		dd	0A5BF6D8Eh, 01143C44Fh, 043958302h, 0D0214EEBh, 0022083B8h, 03FB6180Ch, 018F8931Eh, 0281658E6h
		dd	026486E3Eh, 08BD78A70h, 07477E4C1h, 0B506E07Ch, 0F32D0A25h, 079098B02h, 0E4EABB81h, 028123B23h
		dd	069DEAD38h, 01574CA16h, 0DF871B62h, 0211C40B7h, 0A51A9EF9h, 00014377Bh, 0041E8AC8h, 009114003h
		dd	0BD59E4D2h, 0E3D156D5h, 04FE876D5h, 02F91A340h, 0557BE8DEh, 000EAE4A7h, 00CE5C2ECh, 04DB4BBA6h
		dd	0E756BDFFh, 0DD3369ACh, 0EC17B035h, 006572327h, 099AFC8B0h, 056C8C391h, 06B65811Ch, 05E146119h
		dd	06E85CB75h, 0BE07C002h, 0C2325577h, 0893FF4ECh, 05BBFC92Dh, 0D0EC3B25h, 0B7801AB7h, 08D6D3B24h
		dd	020C763EFh, 0C366A5FCh, 09C382880h, 00ACE3205h, 0AAC9548Ah, 0ECA1D7C7h, 0041AFA32h, 01D16625Ah
		dd	06701902Ch, 09B757A54h, 031D477F7h, 09126B031h, 036CC6FDBh, 0C70B8B46h, 0D9E66A48h, 056E55A79h
		dd	0026A4CEBh, 052437EFFh, 02F8F76B4h, 00DF980A5h, 08674CDE3h, 0EDDA04EBh, 017A9BE04h, 02C18F4DFh
		dd	0B7747F9Dh, 0AB2AF7B4h, 0EFC34D20h, 02E096B7Ch, 01741A254h, 0E5B6A035h, 0213D42F6h, 02C1C7C26h
		dd	061C2F50Fh, 06552DAF9h, 0D2C231F8h, 025130F69h, 0D8167FA2h, 00418F2C8h, 0001A96A6h, 00D1526ABh
		dd	063315C21h, 05E0A72ECh, 049BAFEFDh, 0187908D9h, 08D0DBD86h, 0311170A7h, 03E9B640Ch, 0CC3E10D7h
		dd	0D5CAD3B6h, 00CAEC388h, 0F73001E1h, 06C728AFFh, 071EAE2A1h, 01F9AF36Eh, 0CFCBD12Fh, 0C1DE8417h
		dd	0AC07BE6Bh, 0CB44A1D8h, 08B9B0F56h, 0013988C3h, 0B1C52FCAh, 0B4BE31CDh, 0D8782806h, 012A3A4E2h
		dd	06F7DE532h, 058FD7EB6h, 0D01EE900h, 024ADFFC2h, 0F4990FC5h, 09711AAC5h, 0001D7B95h, 082E5E7D2h
		dd	0109873F6h, 000613096h, 0C32D9521h, 0ADA121FFh, 029908415h, 07FBB977Fh, 0AF9EB3DBh, 029C9ED2Ah
		dd	05CE2A465h, 0A730F32Ch, 0D0AA3FE8h, 08A5CC091h, 0D49E2CE7h, 00CE454A9h, 0D60ACD86h, 0015F1919h
		dd	077079103h, 0DEA03AF6h, 078A8565Eh, 0DEE356DFh, 021F05CBEh, 08B75E387h, 0B3C50651h, 0B8A5C3EFh
		dd	0D8EEB6D2h, 0E523BE77h, 0C2154529h, 02F69EFDFh, 0AFE67AFBh, 0F470C4B2h, 0F3E0EB5Bh, 0D6CC9876h
		dd	039E4460Ch, 01FDA8538h, 01987832Fh, 0CA007367h, 0A99144F8h, 0296B299Eh, 0492FC295h, 09266BEABh
		dd	0B5676E69h, 09BD3DDDAh, 0DF7E052Fh, 0DB25701Ch, 01B5E51EEh, 0F65324E6h, 06AFCE36Ch, 00316CC04h
		dd	08644213Eh, 0B7DC59D0h, 07965291Fh, 0CCD6FD43h, 041823979h, 0932BCDF6h, 0B657C34Dh, 04EDFD282h
		dd	07AE5290Ch, 03CB9536Bh, 0851E20FEh, 09833557Eh, 013ECF0B0h, 0D3FFB372h, 03F85C5C1h, 00AEF7ED2h

Cast256_SetKey	proc	ptrPass:DWORD

	pushad
	mov	edi, offset dd_table
	mov	ecx, 8*24
	mov	eax, 05A827999h
@@:
	mov	dword ptr [edi], eax
	add	eax, 06ED9EBA1h
	add	edi, 4
	dec	ecx
	jnz	@B
	
	mov	eax, 19
	mov	ecx, 8*24
@@:
	mov	dword ptr [edi], eax
	add	al, 17
	add	edi, 4
	and	al, 1Fh
	dec	ecx
	jnz	@B

	mov	esi, ptrPass
	mov	edi, offset copyPass
	mov	eax, dword ptr [esi + 0]
	mov	ebx, dword ptr [esi + 4]
	mov	ecx, dword ptr [esi + 8]
	mov	edx, dword ptr [esi +12]
	mov	dword ptr [edi + 0], eax
	mov	dword ptr [edi + 4], ebx
	mov	dword ptr [edi + 8], ecx
	mov	dword ptr [edi +12], edx
	mov	eax, dword ptr [esi +16]
	mov	ebx, dword ptr [esi +20]
	mov	ecx, dword ptr [esi +24]
	mov	edx, dword ptr [esi +28]
	mov	dword ptr [edi +16], eax
	mov	dword ptr [edi +20], ebx
	mov	dword ptr [edi +24], ecx
	mov	dword ptr [edi +28], edx

	mov	_old_esp, esp
	mov	esi, offset dd_table
	mov	ebp, offset internal_Km
	xor	ecx, ecx
	xor	ebx, ebx
	xor	edx, edx
	mov	_counter, 12

@@key_loop:
	mov	esp, 1
@@:
	f1	dword ptr [edi + 7*4], 4*8*24, esi
	xor	dword ptr [edi + 6*4], eax

	f2	dword ptr [edi + 6*4], 4*8*24, esi+ 4
	xor	dword ptr [edi + 5*4], eax

	f3	dword ptr [edi + 5*4], 4*8*24, esi+ 8
	xor	dword ptr [edi + 4*4], eax

	f1	dword ptr [edi + 4*4], 4*8*24, esi+12
	xor	dword ptr [edi + 3*4], eax

	f2	dword ptr [edi + 3*4], 4*8*24, esi+16
	xor	dword ptr [edi + 2*4], eax

	f3	dword ptr [edi + 2*4], 4*8*24, esi+20
	xor	dword ptr [edi + 1*4], eax

	f1	dword ptr [edi + 1*4], 4*8*24, esi+24
	xor	dword ptr [edi + 0*4], eax

	f2	dword ptr [edi + 0*4], 4*8*24, esi+28
	xor	dword ptr [edi + 7*4], eax
	
	add	esi, 32
	dec	esp
	jz	@B

	mov	ebx, dword ptr [edi+0*4]
	mov	eax, dword ptr [edi+7*4]
	and	ebx, 1Fh
	mov	dword ptr [ebp], eax
	mov	dword ptr [ebp + 12*16], ebx
	mov	ebx, dword ptr [edi+2*4]
	mov	eax, dword ptr [edi+5*4]
	and	ebx, 1Fh
	mov	dword ptr [ebp + 4], eax
	mov	dword ptr [ebp + 12*16 + 4], ebx
	mov	ebx, dword ptr [edi+4*4]
	mov	eax, dword ptr [edi+3*4]
	and	ebx, 1Fh
	mov	dword ptr [ebp + 8], eax
	mov	dword ptr [ebp + 12*16 + 8], ebx
	mov	ebx, dword ptr [edi+6*4]
	mov	eax, dword ptr [edi+1*4]
	and	ebx, 1Fh
	mov	dword ptr [ebp +12], eax
	mov	dword ptr [ebp + 12*16 +12], ebx
	add	ebp, 16
	dec	_counter
	jnz	@@key_loop
	
	mov	esp, _old_esp
	popad
	ret

Cast256_SetKey	endp

Cast256_Encrypt	proc	ptrOut:DWORD, ptrIn:DWORD
	pushad

	mov	esi, ptrIn
	mov	edi, ptrOut

	mov	eax, dword ptr [esi + 0]
	mov	ebx, dword ptr [esi + 4]
	mov	ecx, dword ptr [esi + 8]
	mov	edx, dword ptr [esi +12]
	mov	dword ptr [edi + 0], eax
	mov	dword ptr [edi + 4], ebx
	mov	dword ptr [edi + 8], ecx
	mov	dword ptr [edi +12], edx

	mov	esi, offset internal_Km
	xor	ebx, ebx
	xor	edx, edx


	mov	ebp, 6
@@:
	f1	dword ptr [edi + 3*4], 4*12*4, (esi)
	xor	dword ptr [edi + 2*4], eax

	f2	dword ptr [edi + 2*4], 4*12*4, (esi+ 4)
	xor	dword ptr [edi + 1*4], eax

	f3	dword ptr [edi + 1*4], 4*12*4, (esi+ 8)
	xor	dword ptr [edi + 0*4], eax

	f1	dword ptr [edi + 0*4], 4*12*4, (esi+12)
	xor	dword ptr [edi + 3*4], eax
	add	esi, 16

	dec	ebp
	jnz	@B

	mov	ebp, 6
@@:
	f1	dword ptr [edi + 0*4], 4*12*4, (esi+12)
	xor	dword ptr [edi + 3*4], eax

	f3	dword ptr [edi + 1*4], 4*12*4, (esi+8)
	xor	dword ptr [edi + 0*4], eax

	f2	dword ptr [edi + 2*4], 4*12*4, (esi+4)
	xor	dword ptr [edi + 1*4], eax

	f1	dword ptr [edi + 3*4], 4*12*4, esi
	xor	dword ptr [edi + 2*4], eax

	add	esi, 16

	dec	ebp
	jnz	@B

	popad
	ret
Cast256_Encrypt		endp

Cast256_Decrypt		proc	ptrOut:DWORD, ptrIn:DWORD
	pushad

	mov	esi, ptrIn
	mov	edi, ptrOut

	mov	eax, dword ptr [esi + 0]
	mov	ebx, dword ptr [esi + 4]
	mov	ecx, dword ptr [esi + 8]
	mov	edx, dword ptr [esi +12]
	mov	dword ptr [edi + 0], eax
	mov	dword ptr [edi + 4], ebx
	mov	dword ptr [edi + 8], ecx
	mov	dword ptr [edi +12], edx

	mov	esi, offset internal_Km+11*16
	xor	ebx, ebx
	xor	edx, edx

	mov	ebp, 6
@@:
	f1	dword ptr [edi + 3*4], 4*12*4, (esi)
	xor	dword ptr [edi + 2*4], eax

	f2	dword ptr [edi + 2*4], 4*12*4, (esi+ 4)
	xor	dword ptr [edi + 1*4], eax

	f3	dword ptr [edi + 1*4], 4*12*4, (esi+ 8)
	xor	dword ptr [edi + 0*4], eax

	f1	dword ptr [edi + 0*4], 4*12*4, (esi+12)
	xor	dword ptr [edi + 3*4], eax

	sub	esi, 16

	dec	ebp
	jnz	@B

	mov	ebp, 6
@@:
	f1	dword ptr [edi + 0*4], 4*12*4, (esi+12)
	xor	dword ptr [edi + 3*4], eax

	f3	dword ptr [edi + 1*4], 4*12*4, (esi+8)
	xor	dword ptr [edi + 0*4], eax

	f2	dword ptr [edi + 2*4], 4*12*4, (esi+4)
	xor	dword ptr [edi + 1*4], eax

	f1	dword ptr [edi + 3*4], 4*12*4, esi
	xor	dword ptr [edi + 2*4], eax

	sub	esi, 16
	dec	ebp
	jnz	@B

	popad
	ret
Cast256_Decrypt		endp

Cast256_Clear		proc

	push	eax
	push	ecx
	push	edi

	xor	eax, eax
	mov	ecx, (8*24)+(8*24)+(12*4)+(12*4)+2+8
	mov	edi, offset dd_table
	cld
	rep	stosd

	pop	edi
	pop	ecx
	pop	eax
	ret

Cast256_Clear		endp

.data?
dd_table	dd (8*24) dup (?)
db_table	dd (8*24) dup (?)
internal_Km	dd (12*4) dup (?)
internal_Kr	dd (12*4) dup (?)
_counter	dd ?
_old_esp	dd ?
copyPass	dd 8 dup (?)
.code
CAST256_ENC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn

		.IF (EAX < 1) || (EAX > 32)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen132
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			push	offset sKeyIn
			call Cast256_SetKey
			
			invoke RtlZeroMemory,offset bf_tempbuf,sizeof bf_tempbuf-1
			invoke RtlZeroMemory,offset bf_encryptbuf,sizeof bf_encryptbuf-1
		
			mov	esi,_Input
			mov	ebx,_len
			;part into multiples of 8
	EncryptLoop:
			push	esi	;source
			mov	eax,ebx	;length
			
			mov	ecx,16
			xor	edx,edx
			div	ecx
			.if	eax == 0
				mov	eax,edx
			.else
				mov	eax,16
			.endif
			push	eax
			push	esi
			
			Call Bit16Prepare
			
			.if bCipherMode == 1
				push	16
				push	offset bf_encryptbuf
				call	CipherXor
			.endif
			pushad
			INVOKE Cast256_Encrypt,offset bf_tempbuf,offset bf_encryptbuf
			;convert output to hex string
			mov	eax,dword ptr[bf_tempbuf]
			mov	edx,dword ptr[bf_tempbuf+4]
			bswap	eax
			bswap	edx
			mov	ebx,dword ptr[bf_tempbuf+8]
			mov	ecx,dword ptr[bf_tempbuf+12]
			bswap	ebx
			bswap	ecx

			invoke wsprintf,addr bf_tempbufout,addr hex256bit,eax,edx,ebx,ecx
			invoke	lstrcat,_Output,addr bf_tempbufout
			popad
			pop	esi
			add	esi,16
			sub	ebx,16
			
			cmp	ebx,0
			jg	EncryptLoop
			call Cast256_Clear	
			INVOKE lstrlen,_Output
			HexLen
		.ENDIF
		ret
CAST256_ENC_RT endp
CAST256_DEC_RT proc uses esi edx ecx  _Input:dword,_Output:dword,_len:dword

		call EnableKeyEdit
		invoke lstrlen, addr sKeyIn
		.IF (EAX < 1) || (EAX > 32)
			invoke SetDlgItemText, hWindow, IDC_INFO,addr sErrorLen132
			invoke SetDlgItemText, hWindow, IDC_OUTPUT,NULL
			mov eax, FALSE
		.ELSE
			push	offset sKeyIn
			Call Cast256_SetKey
			
			
			
		mov bPassedRound,0
		mov eax, [_len]
		cmp eax, 2
		jl @inputError
		mov	ecx,32
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
			push	16	;length
			push	esi
			call	Bit16Prepare
			
		
			INVOKE Cast256_Decrypt,offset bf_tempbuf,offset bf_encryptbuf
			DecryptEnd 16
			mov	eax,dword ptr[esi]
			mov	edx,dword ptr[esi+4]
			
			mov	dword ptr[edi+4*0],eax
			mov	dword ptr[edi+4*1],edx
			mov	eax,dword ptr[esi+8]
			mov	edx,dword ptr[esi+12]
			mov	dword ptr[edi+4*2],eax
			mov	dword ptr[edi+4*3],edx
			
			add	edi,16
			pop	esi
			add	esi,16
			sub	ebx,16
	
			cmp	ebx,0
			jg	DecryptLoop
			;now we need to clean it up :)
			call Cast256_Clear
		INVOKE lstrlen,_Output
		mov	edi,_Output
		movzx	ebx,byte ptr[edi+eax-1];get last char
		.if	ebx < 16	;padding chars are 1-8
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
CAST256_DEC_RT endp
