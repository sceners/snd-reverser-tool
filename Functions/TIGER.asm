

.const
u64 struct
	Lo dd ?
	Hi dd ?
u64 ends

.data
;/* S boxes */
TigerK1 label qword
dq 002AAB17CF7E90C5Eh, 0AC424B03E243A8ECh, 072CD5BE30DD5FCD3h, 06D019B93F6F97F3Ah
dq 0CD9978FFD21F9193h, 07573A1C9708029E2h, 0B164326B922A83C3h, 046883EEE04915870h
dq 0EAACE3057103ECE6h, 0C54169B808A3535Ch, 04CE754918DDEC47Ch, 00AA2F4DFDC0DF40Ch
dq 010B76F18A74DBEFAh, 0C6CCB6235AD1AB6Ah, 013726121572FE2FFh, 01A488C6F199D921Eh
dq 04BC9F9F4DA0007CAh, 026F5E6F6E85241C7h, 0859079DBEA5947B6h, 04F1885C5C99E8C92h
dq 0D78E761EA96F864Bh, 08E36428C52B5C17Dh, 069CF6827373063C1h, 0B607C93D9BB4C56Eh
dq 07D820E760E76B5EAh, 0645C9CC6F07FDC42h, 0BF38A078243342E0h, 05F6B343C9D2E7D04h
dq 0F2C28AEB600B0EC6h, 06C0ED85F7254BCACh, 071592281A4DB4FE5h, 01967FA69CE0FED9Fh
dq 0FD5293F8B96545DBh, 0C879E9D7F2A7600Bh, 0860248920193194Eh, 0A4F9533B2D9CC0B3h
dq 09053836C15957613h, 0DB6DCF8AFC357BF1h, 018BEEA7A7A370F57h, 0037117CA50B99066h
dq 06AB30A9774424A35h, 0F4E92F02E325249Bh, 07739DB07061CCAE1h, 0D8F3B49CECA42A05h
dq 0BD56BE3F51382F73h, 045FAED5843B0BB28h, 01C813D5C11BF1F83h, 08AF0E4B6D75FA169h
dq 033EE18A487AD9999h, 03C26E8EAB1C94410h, 0B510102BC0A822F9h, 0141EEF310CE6123Bh
dq 0FC65B90059DDB154h, 0E0158640C5E0E607h, 0884E079826C3A3CFh, 0930D0D9523C535FDh
dq 035638D754E9A2B00h, 04085FCCF40469DD5h, 0C4B17AD28BE23A4Ch, 0CAB2F0FC6A3E6A2Eh
dq 02860971A6B943FCDh, 03DDE6EE212E30446h, 06222F32AE01765AEh, 05D550BB5478308FEh
dq 0A9EFA98DA0EDA22Ah, 0C351A71686C40DA7h, 01105586D9C867C84h, 0DCFFEE85FDA22853h
dq 0CCFBD0262C5EEF76h, 0BAF294CB8990D201h, 0E69464F52AFAD975h, 094B013AFDF133E14h
dq 006A7D1A32823C958h, 06F95FE5130F61119h, 0D92AB34E462C06C0h, 0ED7BDE33887C71D2h
dq 079746D6E6518393Eh, 05BA419385D713329h, 07C1BA6B948A97564h, 031987C197BFDAC67h
dq 0DE6C23C44B053D02h, 0581C49FED002D64Dh, 0DD474D6338261571h, 0AA4546C3E473D062h
dq 0928FCE349455F860h, 048161BBACAAB94D9h, 063912430770E6F68h, 06EC8A5E602C6641Ch
dq 087282515337DDD2Bh, 02CDA6B42034B701Bh, 0B03D37C181CB096Dh, 0E108438266C71C6Fh
dq 02B3180C7EB51B255h, 0DF92B82F96C08BBCh, 05C68C8C0A632F3BAh, 05504CC861C3D0556h
dq 0ABBFA4E55FB26B8Fh, 041848B0AB3BACEB4h, 0B334A273AA445D32h, 0BCA696F0A85AD881h
dq 024F6EC65B528D56Ch, 00CE1512E90F4524Ah, 04E9DD79D5506D35Ah, 0258905FAC6CE9779h
dq 02019295B3E109B33h, 0F8A9478B73A054CCh, 02924F2F934417EB0h, 03993357D536D1BC4h
dq 038A81AC21DB6FF8Bh, 047C4FBF17D6016BFh, 01E0FAADD7667E3F5h, 07ABCFF62938BEB96h
dq 0A78DAD948FC179C9h, 08F1F98B72911E50Dh, 061E48EAE27121A91h, 04D62F7AD31859808h
dq 0ECEBA345EF5CEAEBh, 0F5CEB25EBC9684CEh, 0F633E20CB7F76221h, 0A32CDF06AB8293E4h
dq 0985A202CA5EE2CA4h, 0CF0B8447CC8A8FB1h, 09F765244979859A3h, 0A8D516B1A1240017h
dq 00BD7BA3EBB5DC726h, 0E54BCA55B86ADB39h, 01D7A3AFD6C478063h, 0519EC608E7669EDDh
dq 00E5715A2D149AA23h, 0177D4571848FF194h, 0EEB55F3241014C22h, 00F5E5CA13A6E2EC2h
dq 08029927B75F5C361h, 0AD139FABC3D6E436h, 00D5DF1A94CCF402Fh, 03E8BD948BEA5DFC8h
dq 0A5A0D357BD3FF77Eh, 0A2D12E251F74F645h, 066FD9E525E81A082h, 02E0C90CE7F687A49h
dq 0C2E8BCBEBA973BC5h, 0000001BCE509745Fh, 0423777BBE6DAB3D6h, 0D1661C7EAEF06EB5h
dq 0A1781F354DAACFD8h, 02D11284A2B16AFFCh, 0F1FC4F67FA891D1Fh, 073ECC25DCB920ADAh
dq 0AE610C22C2A12651h, 096E0A810D356B78Ah, 05A9A381F2FE7870Fh, 0D5AD62EDE94E5530h
dq 0D225E5E8368D1427h, 065977B70C7AF4631h, 099F889B2DE39D74Fh, 0233F30BF54E1D143h
dq 09A9675D3D9A63C97h, 05470554FF334F9A8h, 0166ACB744A4F5688h, 070C74CAAB2E4AEADh
dq 0F0D091646F294D12h, 057B82A89684031D1h, 0EFD95A5A61BE0B6Bh, 02FBD12E969F2F29Ah
dq 09BD37013FEFF9FE8h, 03F9B0404D6085A06h, 04940C1F3166CFE15h, 009542C4DCDF3DEFBh
dq 0B4C5218385CD5CE3h, 0C935B7DC4462A641h, 03417F8A68ED3B63Fh, 0B80959295B215B40h
dq 0F99CDAEF3B8C8572h, 0018C0614F8FCB95Dh, 01B14ACCD1A3ACDF3h, 084D471F200BB732Dh
dq 0C1A3110E95E8DA16h, 0430A7220BF1A82B8h, 0B77E090D39DF210Eh, 05EF4BD9F3CD05E9Dh
dq 09D4FF6DA7E57A444h, 0DA1D60E183D4A5F8h, 0B287C38417998E47h, 0FE3EDC121BB31886h
dq 0C7FE3CCC980CCBEFh, 0E46FB590189BFD03h, 03732FD469A4C57DCh, 07EF700A07CF1AD65h
dq 059C64468A31D8859h, 0762FB0B4D45B61F6h, 0155BAED099047718h, 068755E4C3D50BAA6h
dq 0E9214E7F22D8B4DFh, 02ADDBF532EAC95F4h, 032AE3909B4BD0109h, 0834DF537B08E3450h
dq 0FA209DA84220728Dh, 09E691D9B9EFE23F7h, 00446D288C4AE8D7Fh, 07B4CC524E169785Bh
dq 021D87F0135CA1385h, 0CEBB400F137B8AA5h, 0272E2B66580796BEh, 03612264125C2B0DEh
dq 0057702BDAD1EFBB2h, 0D4BABB8EACF84BE9h, 091583139641BC67Bh, 08BDC2DE08036E024h
dq 0603C8156F49F68EDh, 0F7D236F7DBEF5111h, 09727C4598AD21E80h, 0A08A0896670A5FD7h
dq 0CB4A8F4309EBA9CBh, 081AF564B0F7036A1h, 0C0B99AA778199ABDh, 0959F1EC83FC8E952h
dq 08C505077794A81B9h, 03ACAAF8F056338F0h, 007B43F50627A6778h, 04A44AB49F5ECCC77h
dq 03BC3D6E4B679EE98h, 09CC0D4D1CF14108Ch, 04406C00B206BC8A0h, 082A18854C8D72D89h
dq 067E366B35C3C432Ch, 0B923DD61102B37F2h, 056AB2779D884271Dh, 0BE83E1B0FF1525AFh
dq 0FB7C65D4217E49A9h, 06BDBE0E76D48E7D4h, 008DF828745D9179Eh, 022EA6A9ADD53BD34h
dq 0E36E141C5622200Ah, 07F805D1B8CB750EEh, 0AFE5C7A59F58E837h, 0E27F996A4FB1C23Ch
dq 0D3867DFB0775F0D0h, 0D0E673DE6E88891Ah, 0123AEB9EAFB86C25h, 030F1D5D5C145B895h
dq 0BB434A2DEE7269E7h, 078CB67ECF931FA38h, 0F33B0372323BBF9Ch, 052D66336FB279C74h
dq 0505F33AC0AFB4EAAh, 0E8A5CD99A2CCE187h, 0534974801E2D30BBh, 08D2D5711D5876D90h
dq 01F1A412891BC038Eh, 0D6E2E71D82E56648h, 074036C3A497732B7h, 089B67ED96361F5ABh
dq 0FFED95D8F1EA02A2h, 0E72B3BD61464D43Dh, 0A6300F170BDC4820h, 0EBC18760ED78A77Ah
;256 qwords
TigerK2 label qword
dq 0E6A6BE5A05A12138h, 0B5A122A5B4F87C98h, 0563C6089140B6990h, 04C46CB2E391F5DD5h
dq 0D932ADDBC9B79434h, 008EA70E42015AFF5h, 0D765A6673E478CF1h, 0C4FB757EAB278D99h
dq 0DF11C6862D6E0692h, 0DDEB84F10D7F3B16h, 06F2EF604A665EA04h, 04A8E0F0FF0E0DFB3h
dq 0A5EDEEF83DBCBA51h, 0FC4F0A2A0EA4371Eh, 0E83E1DA85CB38429h, 0DC8FF882BA1B1CE2h
dq 0CD45505E8353E80Dh, 018D19A00D4DB0717h, 034A0CFEDA5F38101h, 00BE77E518887CAF2h
dq 01E341438B3C45136h, 0E05797F49089CCF9h, 0FFD23F9DF2591D14h, 0543DDA228595C5CDh
dq 0661F81FD99052A33h, 08736E641DB0F7B76h, 015227725418E5307h, 0E25F7F46162EB2FAh
dq 048A8B2126C13D9FEh, 0AFDC541792E76EEAh, 003D912BFC6D1898Fh, 031B1AAFA1B83F51Bh
dq 0F1AC2796E42AB7D9h, 040A3A7D7FCD2EBACh, 01056136D0AFBBCC5h, 07889E1DD9A6D0C85h
dq 0D33525782A7974AAh, 0A7E25D09078AC09Bh, 0BD4138B3EAC6EDD0h, 0920ABFBE71EB9E70h
dq 0A2A5D0F54FC2625Ch, 0C054E36B0B1290A3h, 0F6DD59FF62FE932Bh, 03537354511A8AC7Dh
dq 0CA845E9172FADCD4h, 084F82B60329D20DCh, 079C62CE1CD672F18h, 08B09A2ADD124642Ch
dq 0D0C1E96A19D9E726h, 05A786A9B4BA9500Ch, 00E020336634C43F3h, 0C17B474AEB66D822h
dq 06A731AE3EC9BAAC2h, 08226667AE0840258h, 067D4567691CAECA5h, 01D94155C4875ADB5h
dq 06D00FD985B813FDFh, 051286EFCB774CD06h, 05E8834471FA744AFh, 0F72CA0AEE761AE2Eh
dq 0BE40E4CDAEE8E09Ah, 0E9970BBB5118F665h, 0726E4BEB33DF1964h, 0703B000729199762h
dq 04631D816F5EF30A7h, 0B880B5B51504A6BEh, 0641793C37ED84B6Ch, 07B21ED77F6E97D96h
dq 0776306312EF96B73h, 0AE528948E86FF3F4h, 053DBD7F286A3F8F8h, 016CADCE74CFC1063h
dq 0005C19BDFA52C6DDh, 068868F5D64D46AD3h, 03A9D512CCF1E186Ah, 0367E62C2385660AEh
dq 0E359E7EA77DCB1D7h, 0526C0773749ABE6Eh, 0735AE5F9D09F734Bh, 0493FC7CC8A558BA8h
dq 0B0B9C1533041AB45h, 0321958BA470A59BDh, 0852DB00B5F46C393h, 091209B2BD336B0E5h
dq 06E604F7D659EF19Fh, 0B99A8AE2782CCB24h, 0CCF52AB6C814C4C7h, 04727D9AFBE11727Bh
dq 07E950D0C0121B34Dh, 0756F435670AD471Fh, 0F5ADD442615A6849h, 04E87E09980B9957Ah
dq 02ACFA1DF50AEE355h, 0D898263AFD2FD556h, 0C8F4924DD80C8FD6h, 0CF99CA3D754A173Ah
dq 0FE477BACAF91BF3Ch, 0ED5371F6D690C12Dh, 0831A5C285E687094h, 0C5D3C90A3708A0A4h
dq 00F7F903717D06580h, 019F9BB13B8FDF27Fh, 0B1BD6F1B4D502843h, 01C761BA38FFF4012h
dq 00D1530C4E2E21F3Bh, 08943CE69A7372C8Ah, 0E5184E11FEB5CE66h, 0618BDB80BD736621h
dq 07D29BAD68B574D0Bh, 081BB613E25E6FE5Bh, 0071C9C10BC07913Fh, 0C7BEEB7909AC2D97h
dq 0C3E58D353BC5D757h, 0EB017892F38F61E8h, 0D4EFFB9C9B1CC21Ah, 099727D26F494F7ABh
dq 0A3E063A2956B3E03h, 09D4A8B9A4AA09C30h, 03F6AB7D500090FB4h, 09CC0F2A057268AC0h
dq 03DEE9D2DEDBF42D1h, 0330F49C87960A972h, 0C6B2720287421B41h, 00AC59EC07C00369Ch
dq 0EF4EAC49CB353425h, 0F450244EEF0129D8h, 08ACC46E5CAF4DEB6h, 02FFEAB63989263F7h
dq 08F7CB9FE5D7A4578h, 05BD8F7644E634635h, 0427A7315BF2DC900h, 017D0C4AA2125261Ch
dq 03992486C93518E50h, 0B4CBFEE0A2D7D4C3h, 07C75D6202C5DDD8Dh, 0DBC295D8E35B6C61h
dq 060B369D302032B19h, 0CE42685FDCE44132h, 006F3DDB9DDF65610h, 08EA4D21DB5E148F0h
dq 020B0FCE62FCD496Fh, 02C1B912358B0EE31h, 0B28317B818F5A308h, 0A89C1E189CA6D2CFh
dq 00C6B18576AAADBC8h, 0B65DEAA91299FAE3h, 0FB2B794B7F1027E7h, 004E4317F443B5BEBh
dq 04B852D325939D0A6h, 0D5AE6BEEFB207FFCh, 0309682B281C7D374h, 0BAE309A194C3B475h
dq 08CC3F97B13B49F05h, 098A9422FF8293967h, 0244B16B01076FF7Ch, 0F8BF571C663D67EEh
dq 01F0D6758EEE30DA1h, 0C9B611D97ADEB9B7h, 0B7AFD5887B6C57A2h, 06290AE846B984FE1h
dq 094DF4CDEACC1A5FDh, 0058A5BD1C5483AFFh, 063166CC142BA3C37h, 08DB8526EB2F76F40h
dq 0E10880036F0D6D4Eh, 09E0523C9971D311Dh, 045EC2824CC7CD691h, 0575B8359E62382C9h
dq 0FA9E400DC4889995h, 0D1823ECB45721568h, 0DAFD983B8206082Fh, 0AA7D29082386A8CBh
dq 0269FCD4403B87588h, 01B91F5F728BDD1E0h, 0E4669F39040201F6h, 07A1D7C218CF04ADEh
dq 065623C29D79CE5CEh, 02368449096C00BB1h, 0AB9BF1879DA503BAh, 0BC23ECB1A458058Eh
dq 09A58DF01BB401ECCh, 0A070E868A85F143Dh, 04FF188307DF2239Eh, 014D565B41A641183h
dq 0EE13337452701602h, 0950E3DCF3F285E09h, 059930254B9C80953h, 03BF299408930DA6Dh
dq 0A955943F53691387h, 0A15EDECAA9CB8784h, 029142127352BE9A0h, 076F0371FFF4E7AFBh
dq 00239F450274F2228h, 0BB073AF01D5E868Bh, 0BFC80571C10E96C1h, 0D267088568222E23h
dq 09671A3D48E80B5B0h, 055B5D38AE193BB81h, 0693AE2D0A18B04B8h, 05C48B4ECADD5335Fh
dq 0FD743B194916A1CAh, 02577018134BE98C4h, 0E77987E83C54A4ADh, 028E11014DA33E1B9h
dq 0270CC59E226AA213h, 071495F756D1A5F60h, 09BE853FB60AFEF77h, 0ADC786A7F7443DBFh
dq 00904456173B29A82h, 058BC7A66C232BD5Eh, 0F306558C673AC8B2h, 041F639C6B6C9772Ah
dq 0216DEFE99FDA35DAh, 011640CC71C7BE615h, 093C43694565C5527h, 0EA038E6246777839h
dq 0F9ABF3CE5A3E2469h, 0741E768D0FD312D2h, 00144B883CED652C6h, 0C20B5A5BA33F8552h
dq 01AE69633C3435A9Dh, 097A28CA4088CFDECh, 08824A43C1E96F420h, 037612FA66EEEA746h
dq 06B4CB165F9CF0E5Ah, 043AA1C06A0ABFB4Ah, 07F4DC26FF162796Bh, 06CBACC8E54ED9B0Fh
dq 0A6B7FFEFD2BB253Eh, 02E25BC95B0A29D4Fh, 086D6A58BDEF1388Ch, 0DED74AC576B6F054h
dq 08030BDBC2B45805Dh, 03C81AF70E94D9289h, 03EFF6DDA9E3100DBh, 0B38DC39FDFCC8847h
dq 0123885528D17B87Eh, 0F2DA0ED240B1B642h, 044CEFADCD54BF9A9h, 01312200E433C7EE6h
dq 09FFCC84F3A78C748h, 0F0CD1F72248576BBh, 0EC6974053638CFE4h, 02BA7B67C0CEC4E4Ch
dq 0AC2F4DF3E5CE32EDh, 0CB33D14326EA4C11h, 0A4E9044CC77E58BCh, 05F513293D934FCEFh
dq 05DC9645506E55444h, 050DE418F317DE40Ah, 0388CB31A69DDE259h, 02DB4A83455820A86h
dq 09010A91E84711AE9h, 04DF7F0B7B1498371h, 0D62A2EABC0977179h, 022FAC097AA8D5C0Eh
;256 qwords
TigerK3 label qword
dq 0F49FCC2FF1DAF39Bh, 0487FD5C66FF29281h, 0E8A30667FCDCA83Fh, 02C9B4BE3D2FCCE63h
dq 0DA3FF74B93FBBBC2h, 02FA165D2FE70BA66h, 0A103E279970E93D4h, 0BECDEC77B0E45E71h
dq 0CFB41E723985E497h, 0B70AAA025EF75017h, 0D42309F03840B8E0h, 08EFC1AD035898579h
dq 096C6920BE2B2ABC5h, 066AF4163375A9172h, 02174ABDCCA7127FBh, 0B33CCEA64A72FF41h
dq 0F04A4933083066A5h, 08D970ACDD7289AF5h, 08F96E8E031C8C25Eh, 0F3FEC02276875D47h
dq 0EC7BF310056190DDh, 0F5ADB0AEBB0F1491h, 09B50F8850FD58892h, 04975488358B74DE8h
dq 0A3354FF691531C61h, 00702BBE481D2C6EEh, 089FB24057DEDED98h, 0AC3075138596E902h
dq 01D2D3580172772EDh, 0EB738FC28E6BC30Dh, 05854EF8F63044326h, 09E5C52325ADD3BBEh
dq 090AA53CF325C4623h, 0C1D24D51349DD067h, 02051CFEEA69EA624h, 013220F0A862E7E4Fh
dq 0CE39399404E04864h, 0D9C42CA47086FCB7h, 0685AD2238A03E7CCh, 0066484B2AB2FF1DBh
dq 0FE9D5D70EFBF79ECh, 05B13B9DD9C481854h, 015F0D475ED1509ADh, 00BEBCD060EC79851h
dq 0D58C6791183AB7F8h, 0D1187C5052F3EEE4h, 0C95D1192E54E82FFh, 086EEA14CB9AC6CA2h
dq 03485BEB153677D5Dh, 0DD191D781F8C492Ah, 0F60866BAA784EBF9h, 0518F643BA2D08C74h
dq 08852E956E1087C22h, 0A768CB8DC410AE8Dh, 038047726BFEC8E1Ah, 0A67738B4CD3B45AAh
dq 0AD16691CEC0DDE19h, 0C6D4319380462E07h, 0C5A5876D0BA61938h, 016B9FA1FA58FD840h
dq 0188AB1173CA74F18h, 0ABDA2F98C99C021Fh, 03E0580AB134AE816h, 05F3B05B773645ABBh
dq 02501A2BE5575F2F6h, 01B2F74004E7E8BA9h, 01CD7580371E8D953h, 07F6ED89562764E30h
dq 0B15926FF596F003Dh, 09F65293DA8C5D6B9h, 06ECEF04DD690F84Ch, 04782275FFF33AF88h
dq 0E41433083F820801h, 0FD0DFE409A1AF9B5h, 04325A3342CDB396Bh, 08AE77E62B301B252h
dq 0C36F9E9F6655615Ah, 085455A2D92D32C09h, 0F2C7DEA949477485h, 063CFB4C133A39EBAh
dq 083B040CC6EBC5462h, 03B9454C8FDB326B0h, 056F56A9E87FFD78Ch, 02DC2940D99F42BC6h
dq 098F7DF096B096E2Dh, 019A6E01E3AD852BFh, 042A99CCBDBD4B40Bh, 0A59998AF45E9C559h
dq 0366295E807D93186h, 06B48181BFAA1F773h, 01FEC57E2157A0A1Dh, 04667446AF6201AD5h
dq 0E615EBCACFB0F075h, 0B8F31F4F68290778h, 022713ED6CE22D11Eh, 03057C1A72EC3C93Bh
dq 0CB46ACC37C3F1F2Fh, 0DBB893FD02AAF50Eh, 0331FD92E600B9FCFh, 0A498F96148EA3AD6h
dq 0A8D8426E8B6A83EAh, 0A089B274B7735CDCh, 087F6B3731E524A11h, 0118808E5CBC96749h
dq 09906E4C7B19BD394h, 0AFED7F7E9B24A20Ch, 06509EADEEB3644A7h, 06C1EF1D3E8EF0EDEh
dq 0B9C97D43E9798FB4h, 0A2F2D784740C28A3h, 07B8496476197566Fh, 07A5BE3E6B65F069Dh
dq 0F96330ED78BE6F10h, 0EEE60DE77A076A15h, 02B4BEE4AA08B9BD0h, 06A56A63EC7B8894Eh
dq 002121359BA34FEF4h, 04CBF99F8283703FCh, 0398071350CAF30C8h, 0D0A77A89F017687Ah
dq 0F1C1A9EB9E423569h, 08C7976282DEE8199h, 05D1737A5DD1F7ABDh, 04F53433C09A9FA80h
dq 0FA8B0C53DF7CA1D9h, 03FD9DCBC886CCB77h, 0C040917CA91B4720h, 07DD00142F9D1DCDFh
dq 08476FC1D4F387B58h, 023F8E7C5F3316503h, 0032A2244E7E37339h, 05C87A5D750F5A74Bh
dq 0082B4CC43698992Eh, 0DF917BECB858F63Ch, 03270B8FC5BF86DDAh, 010AE72BB29B5DD76h
dq 0576AC94E7700362Bh, 01AD112DAC61EFB8Fh, 0691BC30EC5FAA427h, 0FF246311CC327143h
dq 03142368E30E53206h, 071380E31E02CA396h, 0958D5C960AAD76F1h, 0F8D6F430C16DA536h
dq 0C8FFD13F1BE7E1D2h, 07578AE66004DDBE1h, 005833F01067BE646h, 0BB34B5AD3BFE586Dh
dq 0095F34C9A12B97F0h, 0247AB64525D60CA8h, 0DCDBC6F3017477D1h, 04A2E14D4DECAD24Dh
dq 0BDB5E6D9BE0A1EEBh, 02A7E70F7794301ABh, 0DEF42D8A270540FDh, 001078EC0A34C22C1h
dq 0E5DE511AF4C16387h, 07EBB3A52BD9A330Ah, 077697857AA7D6435h, 0004E831603AE4C32h
dq 0E7A21020AD78E312h, 09D41A70C6AB420F2h, 028E06C18EA1141E6h, 0D2B28CBD984F6B28h
dq 026B75F6C446E9D83h, 0BA47568C4D418D7Fh, 0D80BADBFE6183D8Eh, 00E206D7F5F166044h
dq 0E258A43911CBCA3Eh, 0723A1746B21DC0BCh, 0C7CAA854F5D7CDD3h, 07CAC32883D261D9Ch
dq 07690C26423BA942Ch, 017E55524478042B8h, 0E0BE477656A2389Fh, 04D289B5E67AB2DA0h
dq 044862B9C8FBBFD31h, 0B47CC8049D141365h, 0822C1B362B91C793h, 04EB14655FB13DFD8h
dq 01ECBBA0714E2A97Bh, 06143459D5CDE5F14h, 053A8FBF1D5F0AC89h, 097EA04D81C5E5B00h
dq 0622181A8D4FDB3F3h, 0E9BCD341572A1208h, 01411258643CCE58Ah, 09144C5FEA4C6E0A4h
dq 00D33D06565CF620Fh, 054A48D489F219CA1h, 0C43E5EAC6D63C821h, 0A9728B3A72770DAFh
dq 0D7934E7B20DF87EFh, 0E35503B61A3E86E5h, 0CAE321FBC819D504h, 0129A50B3AC60BFA6h
dq 0CD5E68EA7E9FB6C3h, 0B01C90199483B1C7h, 03DE93CD5C295376Ch, 0AED52EDF2AB9AD13h
dq 02E60F512C0A07884h, 0BC3D86A3E36210C9h, 035269D9B163951CEh, 00C7D6E2AD0CDB5FAh
dq 059E86297D87F5733h, 0298EF221898DB0E7h, 055000029D1A5AA7Eh, 08BC08AE1B5061B45h
dq 0C2C31C2B6C92703Ah, 094CC596BAF25EF42h, 00A1D73DB22540456h, 004B6A0F9D9C4179Ah
dq 0EFFDAFA2AE3D3C60h, 0F7C8075BB49496C4h, 09CC5C7141D1CD4E3h, 078BD1638218E5534h
dq 0B2F11568F850246Ah, 0EDFABCFA9502BC29h, 0796CE5F2DA23051Bh, 0AAE128B0DC93537Ch
dq 03A493DA0EE4B29AEh, 0B5DF6B2C416895D7h, 0FCABBD25122D7F37h, 070810B58105DC4B1h
dq 0E10FDD37F7882A90h, 0524DCAB5518A3F5Ch, 03C9E85878451255Bh, 04029828119BD34E2h
dq 074A05B6F5D3CECCBh, 0B610021542E13ECAh, 00FF979D12F59E2ACh, 06037DA27E4F9CC50h
dq 05E92975A0DF1847Dh, 0D66DE190D3E623FEh, 05032D6B87B568048h, 09A36B7CE8235216Eh
dq 080272A7A24F64B4Ah, 093EFED8B8C6916F7h, 037DDBFF44CCE1555h, 04B95DB5D4B99BD25h
dq 092D3FDA169812FC0h, 0FB1A4A9A90660BB6h, 0730C196946A4B9B2h, 081E289AA7F49DA68h
dq 064669A0F83B1A05Fh, 027B3FF7D9644F48Bh, 0CC6B615C8DB675B3h, 0674F20B9BCEBBE95h
dq 06F31238275655982h, 05AE488713E45CF05h, 0BF619F9954C21157h, 0EABAC46040A8EAE9h
dq 0454C6FE9F2C0C1CDh, 0419CF6496412691Ch, 0D3DC3BEF265B0F70h, 06D0E60F5C3578A9Eh
;256 qwords
TigerK4 label qword
dq 05B0E608526323C55h, 01A46C1A9FA1B59F5h, 0A9E245A17C4C8FFAh, 065CA5159DB2955D7h
dq 005DB0A76CE35AFC2h, 081EAC77EA9113D45h, 0528EF88AB6AC0A0Dh, 0A09EA253597BE3FFh
dq 0430DDFB3AC48CD56h, 0C4B3A67AF45CE46Fh, 04ECECFD8FBE2D05Eh, 03EF56F10B39935F0h
dq 00B22D6829CD619C6h, 017FD460A74DF2069h, 06CF8CC8E8510ED40h, 0D6C824BF3A6ECAA7h
dq 061243D581A817049h, 0048BACB6BBC163A2h, 0D9A38AC27D44CC32h, 07FDDFF5BAAF410ABh
dq 0AD6D495AA804824Bh, 0E1A6A74F2D8C9F94h, 0D4F7851235DEE8E3h, 0FD4B7F886540D893h
dq 0247C20042AA4BFDAh, 0096EA1C517D1327Ch, 0D56966B4361A6685h, 0277DA5C31221057Dh
dq 094D59893A43ACFF7h, 064F0C51CCDC02281h, 03D33BCC4FF6189DBh, 0E005CB184CE66AF1h
dq 0FF5CCD1D1DB99BEAh, 0B0B854A7FE42980Fh, 07BD46A6A718D4B9Fh, 0D10FA8CC22A5FD8Ch
dq 0D31484952BE4BD31h, 0C7FA975FCB243847h, 04886ED1E5846C407h, 028CDDB791EB70B04h
dq 0C2B00BE2F573417Fh, 05C9590452180F877h, 07A6BDDFFF370EB00h, 0CE509E38D6D9D6A4h
dq 0EBEB0F00647FA702h, 01DCC06CF76606F06h, 0E4D9F28BA286FF0Ah, 0D85A305DC918C262h
dq 0475B1D8732225F54h, 02D4FB51668CCB5FEh, 0A679B9D9D72BBA20h, 053841C0D912D43A5h
dq 03B7EAA48BF12A4E8h, 0781E0E47F22F1DDFh, 0EFF20CE60AB50973h, 020D261D19DFFB742h
dq 016A12B03062A2E39h, 01960EB2239650495h, 0251C16FED50EB8B8h, 09AC0C330F826016Eh
dq 0ED152665953E7671h, 002D63194A6369570h, 05074F08394B1C987h, 070BA598C90B25CE1h
dq 0794A15810B9742F6h, 00D5925E9FCAF8C6Ch, 03067716CD868744Eh, 0910AB077E8D7731Bh
dq 06A61BBDB5AC42F61h, 093513EFBF0851567h, 0F494724B9E83E9D5h, 0E887E1985C09648Dh
dq 034B1D3C675370CFDh, 0DC35E433BC0D255Dh, 0D0AAB84234131BE0h, 008042A50B48B7EAFh
dq 09997C4EE44A3AB35h, 0829A7B49201799D0h, 0263B8307B7C54441h, 0752F95F4FD6A6CA6h
dq 0927217402C08C6E5h, 02A8AB754A795D9EEh, 0A442F7552F72943Dh, 02C31334E19781208h
dq 04FA98D7CEAEE6291h, 055C3862F665DB309h, 0BD0610175D53B1F3h, 046FE6CB840413F27h
dq 03FE03792DF0CFA59h, 0CFE700372EB85E8Fh, 0A7BE29E7ADBCE118h, 0E544EE5CDE8431DDh
dq 08A781B1B41F1873Eh, 0A5C94C78A0D2F0E7h, 039412E2877B60728h, 0A1265EF3AFC9A62Ch
dq 0BCC2770C6A2506C5h, 03AB66DD5DCE1CE12h, 0E65499D04A675B37h, 07D8F523481BFD216h
dq 00F6F64FCEC15F389h, 074EFBE618B5B13C8h, 0ACDC82B714273E1Dh, 0DD40BFE003199D17h
dq 037E99257E7E061F8h, 0FA52626904775AAAh, 08BBBF63A463D56F9h, 0F0013F1543A26E64h
dq 0A8307E9F879EC898h, 0CC4C27A4150177CCh, 01B432F2CCA1D3348h, 0DE1D1F8F9F6FA013h
dq 0606602A047A7DDD6h, 0D237AB64CC1CB2C7h, 09B938E7225FCD1D3h, 0EC4E03708E0FF476h
dq 0FEB2FBDA3D03C12Dh, 0AE0BCED2EE43889Ah, 022CB8923EBFB4F43h, 069360D013CF7396Dh
dq 0855E3602D2D4E022h, 0073805BAD01F784Ch, 033E17A133852F546h, 0DF4874058AC7B638h
dq 0BA92B29C678AA14Ah, 00CE89FC76CFAADCDh, 05F9D4E0908339E34h, 0F1AFE9291F5923B9h
dq 06E3480F60F4A265Fh, 0EEBF3A2AB29B841Ch, 0E21938A88F91B4ADh, 057DFEFF845C6D3C3h
dq 02F006B0BF62CAAF2h, 062F479EF6F75EE78h, 011A55AD41C8916A9h, 0F229D29084FED453h
dq 042F1C27B16B000E6h, 02B1F76749823C074h, 04B76ECA3C2745360h, 08C98F463B91691BDh
dq 014BCC93CF1ADE66Ah, 08885213E6D458397h, 08E177DF0274D4711h, 0B49B73B5503F2951h
dq 010168168C3F96B6Bh, 00E3D963B63CAB0AEh, 08DFC4B5655A1DB14h, 0F789F1356E14DE5Ch
dq 0683E68AF4E51DAC1h, 0C9A84F9D8D4B0FD9h, 03691E03F52A0F9D1h, 05ED86E46E1878E80h
dq 03C711A0E99D07150h, 05A0865B20C4E9310h, 056FBFC1FE4F0682Eh, 0EA8D5DE3105EDF9Bh
dq 071ABFDB12379187Ah, 02EB99DE1BEE77B9Ch, 021ECC0EA33CF4523h, 059A4D7521805C7A1h
dq 03896F5EB56AE7C72h, 0AA638F3DB18F75DCh, 09F39358DABE9808Eh, 0B7DEFA91C00B72ACh
dq 06B5541FD62492D92h, 06DC6DEE8F92E4D5Bh, 0353F57ABC4BEEA7Eh, 0735769D6DA5690CEh
dq 00A234AA642391484h, 0F6F9508028F80D9Dh, 0B8E319A27AB3F215h, 031AD9C1151341A4Dh
dq 0773C22A57BEF5805h, 045C7561A07968633h, 0F913DA9E249DBE36h, 0DA652D9B78A64C68h
dq 04C27A97F3BC334EFh, 076621220E66B17F4h, 0967743899ACD7D0Bh, 0F3EE5BCAE0ED6782h
dq 0409F753600C879FCh, 006D09A39B5926DB6h, 06F83AEB0317AC588h, 001E6CA4A86381F21h
dq 066FF3462D19F3025h, 072207C24DDFD3BFBh, 04AF6B6D3E2ECE2EBh, 09C994DBEC7EA08DEh
dq 049ACE597B09A8BC4h, 0B38C4766CF0797BAh, 0131B9373C57C2A75h, 0B1822CCE61931E58h
dq 09D7555B909BA1C0Ch, 0127FAFDD937D11D2h, 029DA3BADC66D92E4h, 0A2C1D57154C2ECBCh
dq 058C5134D82F6FE24h, 01C3AE3515B62274Fh, 0E907C82E01CB8126h, 0F8ED091913E37FCBh
dq 03249D8F9C80046C9h, 080CF9BEDE388FB63h, 01881539A116CF19Eh, 05103F3F76BD52457h
dq 015B7E6F5AE47F7A8h, 0DBD7C6DED47E9CCFh, 044E55C410228BB1Ah, 0B647D4255EDB4E99h
dq 05D11882BB8AAFC30h, 0F5098BBB29D3212Ah, 08FB5EA14E90296B3h, 0677B942157DD025Ah
dq 0FB58E7C0A390ACB5h, 089D3674C83BD4A01h, 09E2DA4DF4BF3B93Bh, 0FCC41E328CAB4829h
dq 003F38C96BA582C52h, 0CAD1BDBD7FD85DB2h, 0BBB442C16082AE83h, 0B95FE86BA5DA9AB0h
dq 0B22E04673771A93Fh, 0845358C9493152D8h, 0BE2A488697B4541Eh, 095A2DC2DD38E6966h
dq 0C02C11AC923C852Bh, 02388B1990DF2A87Bh, 07C8008FA1B4F37BEh, 01F70D0C84D54E503h
dq 05490ADEC7ECE57D4h, 0002B3C27D9063A3Ah, 07EAEA3848030A2BFh, 0C602326DED2003C0h
dq 083A7287D69A94086h, 0C57A5FCB30F57A8Ah, 0B56844E479EBE779h, 0A373B40F05DCBCE9h
dq 0D71A786E88570EE2h, 0879CBACDBDE8F6A0h, 0976AD1BCC164A32Fh, 0AB21E25E9666D78Bh
dq 0901063AAE5E5C33Ch, 09818B34448698D90h, 0E36487AE3E1E8ABBh, 0AFBDF931893BDCB4h
dq 06345A0DC5FBBD519h, 08628FE269B9465CAh, 01E5D01603F9C51ECh, 04DE44006A15049B7h
dq 0BF6C70E5F776CBB1h, 0411218F2EF552BEDh, 0CB0C0708705A36A3h, 0E74D14754F986044h
dq 0CD56D9430EA8280Eh, 0C12591D7535F5065h, 0C83223F1720AEF96h, 0C3A0396F7363A51Fh

TigerCHAIN label qword
dq 00123456789ABCDEFh, 0FEDCBA9876543210h, 0F096A5B4C3B2E187h

.data?
TigerHashBuf db 64 dup(?)
TigerLen dd ?
TigerIndex dd ?
TigerDigest u64 8 dup(<?>)

.code



;***************************************************************************************
;Start tiger Handler functions
;***************************************************************************************
;123=a86807bb96a714fe9b22425893e698334cd71e36b0eef2be
;The quick brown fox jumps over the lazy dog=6d12a41e72e644f017b6f0e2f7b44c6285f06dd5d2c5b075
TIGER_RT proc uses esi edx ecx _Input:dword, _Output:dword, _len:dword
		call DisableKeyEdit

		mov esi, offset HASHES_Current
		mov edi, offset TigerCHAIN
		assume esi:ptr HASH_PARAMETERS
		mov ebx, [esi].TIGERparameterA
		mov dword ptr [edi], ebx
		mov ebx, [esi].TIGERparameterB
		mov dword ptr [edi+4], ebx 
		mov ebx, [esi].TIGERparameterC
		mov dword ptr [edi+8], ebx 
		mov ebx, [esi].TIGERparameterD
		mov dword ptr [edi+12], ebx 
		mov ebx, [esi].TIGERparameterE
		mov dword ptr [edi+16], ebx 
		mov ebx, [esi].TIGERparameterF
		mov dword ptr [edi+20], ebx 
		assume esi:nothing

		call TigerInit
		push [_len]
		push _Input
		call TigerUpdate
		call TigerFinal
		mov	edi, offset TigerDigest
		xor	ebx, ebx
	@@:
		mov	eax, dword ptr[edi+ebx*4]
		bswap eax
		invoke wsprintf, _Input, addr hex32bitlc, eax
		invoke lstrcat, _Output, _Input
		inc	ebx
		cmp	ebx, 6
		jl @b
		invoke lstrlen, _Output
		HexLen
		ret
TIGER_RT endp



SHR64 macro RegLo, RegHi, N
	shrd RegLo, RegHi, N
	shr RegHi, N
endm

SHL64 macro RegLo, RegHi, N
	shld RegHi, RegLo, N
	shl RegLo, N
endm

KEY_SCHEDULE MACRO
	mov eax, TID.u64.Lo
	mov edx, TID.u64.Hi
	mov ebx, TIK.u64.Lo
	mov ecx, TIK.u64.Hi
	xor ebx, 0A5A5A5A5h
	xor ecx, 0A5A5A5A5h
	sub eax, ebx
	sbb edx, ecx
	mov TID.u64.Lo, eax
	mov TID.u64.Hi, edx
	mov ebx, TIE.u64.Lo
	mov ecx, TIE.u64.Hi
	xor ebx, eax
	xor ecx, edx
	mov TIE.u64.Lo, ebx
	mov TIE.u64.Hi, ecx
	mov eax, TIF.u64.Lo
	mov edx, TIF.u64.Hi
	add eax, ebx
	adc edx, ecx
	mov TIF.u64.Lo, eax
	mov TIF.u64.Hi, edx
	xor ebx, -1
	xor ecx, -1
	shld ecx, ebx, 19
	shl ebx, 19
	mov esi, TIG.u64.Lo
	mov edi, TIG.u64.Hi
	xor eax, ebx
	xor edx, ecx
	sub esi, eax
	sbb edi, edx
	mov TIG.u64.Lo, esi
	mov TIG.u64.Hi, edi
	mov eax, TIH.u64.Lo
	mov edx, TIH.u64.Hi
	xor eax, esi
	xor edx, edi
	mov TIH.u64.Lo, eax
	mov TIH.u64.Hi, edx
	mov ebx, TII.u64.Lo
	mov ecx, TII.u64.Hi
	add ebx, eax
	adc ecx, edx
	mov TII.u64.Lo, ebx
	mov TII.u64.Hi, ecx
	xor eax, -1
	xor edx, -1
	shrd eax, edx, 23
	shr edx, 23
	xor eax, ebx
	xor edx, ecx
	mov esi, TIJ.u64.Lo
	mov edi, TIJ.u64.Hi
	sub esi, eax
	sbb edi, edx
	mov TIJ.u64.Lo, esi
	mov TIJ.u64.Hi, edi
	mov eax, TIK.u64.Lo
	mov edx, TIK.u64.Hi
	xor eax, esi
	xor edx, edi
	mov TIK.u64.Lo, eax
	mov TIK.u64.Hi, edx
	mov ebx, TID.u64.Lo
	mov ecx, TID.u64.Hi
	add ebx, eax
	adc ecx, edx
	mov TID.u64.Lo, ebx
	mov TID.u64.Hi, ecx
	xor eax, -1
	xor edx, -1
	shld edx, eax, 19
	shl eax, 19
	xor eax, ebx
	xor edx, ecx
	mov esi, TIE.u64.Lo
	mov edi, TIE.u64.Hi
	sub esi, eax
	sbb edi, edx
	mov TIE.u64.Lo, esi
	mov TIE.u64.Hi, edi
	mov eax, TIF.u64.Lo
	mov edx, TIF.u64.Hi
	xor eax, esi
	xor edx, edi
	mov TIF.u64.Lo, eax
	mov TIF.u64.Hi, edx
	mov ebx, TIG.u64.Lo
	mov ecx, TIG.u64.Hi
	add ebx, eax
	adc ecx, edx
	mov TIG.u64.Lo, ebx
	mov TIG.u64.Hi, ecx
	xor eax, -1
	xor edx, -1
	shrd eax, edx, 23
	shr edx, 23
	xor eax, ebx
	xor edx, ecx
	mov esi, TIH.u64.Lo
	mov edi, TIH.u64.Hi
	sub esi, eax
	sbb edi, edx
	mov TIH.u64.Lo, esi
	mov TIH.u64.Hi, edi
	mov eax, TII.u64.Lo
	mov edx, TII.u64.Hi
	xor eax, esi
	xor edx, edi
	mov TII.u64.Lo, eax
	mov TII.u64.Hi, edx
	mov ebx, TIJ.u64.Lo
	mov ecx, TIJ.u64.Hi
	add ebx, eax
	adc ecx, edx
	mov TIJ.u64.Lo, ebx
	mov TIJ.u64.Hi, ecx
	mov eax, TIK.u64.Lo
	mov edx, TIK.u64.Hi
	xor ebx, 089ABCDEFh
	xor ecx, 001234567h
	sub eax, ebx
	sbb edx, ecx
	mov TIK.u64.Lo, eax
	mov TIK.u64.Hi, edx
ENDM

ROUND MACRO a_, b_, c_, x_, mulp
	mov ebx, [x_].u64.Lo
	mov ecx, [x_].u64.Hi
	mov eax, [c_].u64.Lo
	mov edx, [c_].u64.Hi
	xor eax, ebx
	xor edx, ecx
	mov [c_].u64.Lo, eax
	mov [c_].u64.Hi, edx
	mov ebx, eax
	mov ecx, edx
	and ebx, 0FFh
	and ecx, 0FFh
	mov esi, [TigerK1+8*ebx].u64.Lo;0
	mov edi, [TigerK1+8*ebx].u64.Hi
	xor esi, [TigerK3+8*ecx].u64.Lo;1
	xor edi, [TigerK3+8*ecx].u64.Hi
	mov ebx, eax
	mov ecx, edx
	shr ebx, 16
	and ebx, 0FFh
	shr ecx, 16	
	and ecx, 0FFh
	xor esi, [TigerK2+8*ebx].u64.Lo;2
	xor edi, [TigerK2+8*ebx].u64.Hi
	xor esi, [TigerK4+8*ecx].u64.Lo;3
	xor edi, [TigerK4+8*ecx].u64.Hi
	mov Tigertmp[0], esi
	mov Tigertmp[4], edi
	mov ebx, eax
	mov ecx, edx
	shr ebx, 8
	and ebx, 0FFh
	shr ecx, 8
	and ecx, 0FFh
	mov esi, [TigerK4+8*ebx].u64.Lo
	mov edi, [TigerK4+8*ebx].u64.Hi
	xor esi, [TigerK2+8*ecx].u64.Lo
	xor edi, [TigerK2+8*ecx].u64.Hi
	shr eax, 24
	shr edx, 24
	xor esi, [TigerK3+8*eax].u64.Lo
	xor edi, [TigerK3+8*eax].u64.Hi
	xor esi, [TigerK1+8*edx].u64.Lo
	xor edi, [TigerK1+8*edx].u64.Hi
	add esi, [b_].u64.Lo
	adc edi, [b_].u64.Hi
	mov eax, Tigertmp[0]
	mov edx, Tigertmp[4]
	sub [a_].u64.Lo, eax
	sbb [a_].u64.Hi, edx
	if mulp eq 5
	mov ebx, esi
	mov ecx, edi
	shld edi, esi, 2
	shl esi, 2
	add esi, ebx
	adc edi, ecx	
	elseif mulp eq 7
	mov ebx, esi
	mov ecx, edi
	shld edi, esi, 3
	shl esi, 3
	sub esi, ebx
	sbb edi, ecx	
	elseif mulp eq 9
	mov ebx, esi
	mov ecx, edi
	shld edi, esi, 3
	shl esi, 3
	add esi, ebx
	adc edi, ecx	
	endif
	mov [b_].u64.Lo, esi
	mov [b_].u64.Hi, edi
ENDM

align 4
TigerTransform proc
	pushad
	Tigerlocals equ 12*8
	sub esp, Tigerlocals
	TID equ [esp+0*8]
	TIE equ [esp+1*8]
	TIF equ [esp+2*8]
	TIG equ [esp+3*8]
	TIH equ [esp+4*8]
	TII equ [esp+5*8]
	TIJ equ [esp+6*8]
	TIK equ [esp+7*8]
	TIA equ [esp+8*8]
	TIB equ [esp+9*8]
	TIC equ [esp+10*8]
	Tigertmp equ dword ptr [esp+11*8]
	
	mov esi, offset TigerDigest
	mov edi, offset TigerHashBuf	
	
	;MOV64 TIA, esi[0*8]
	;MOV64 TIB, esi[1*8]
	;MOV64 TIC, esi[2*8]
	
	;MOV64 TID, edi[0*8]
	;MOV64 TIE, edi[1*8]
	;MOV64 TIF, edi[2*8]
	;MOV64 TIG, edi[3*8]
	;MOV64 TIH, edi[4*8]
	;MOV64 TII, edi[5*8]
	;MOV64 TIJ, edi[6*8]
	;MOV64 TIK, edi[7*8]
	
	mov eax, dword ptr[esi+4*0];.u64.Lo
	mov edx, dword ptr[esi+4*1];.u64.Hi
	mov dword ptr[TIA+4*0], eax
	mov dword ptr[TIA+4*1], edx
	mov eax, dword ptr[esi+4*2];.u64.Lo
	mov edx, dword ptr[esi+4*3];.u64.Hi
	mov dword ptr[TIB+4*0], eax
	mov dword ptr[TIB+4*1], edx
	mov eax, dword ptr[esi+4*4];.u64.Lo
	mov edx, dword ptr[esi+4*5];.u64.Hi
	mov dword ptr[TIC+4*0], eax
	mov dword ptr[TIC+4*1], edx
	
	mov eax, dword ptr[edi+4*0];.u64.Lo
	mov edx, dword ptr[edi+4*1];.u64.Hi
	mov dword ptr[TID+4*0], eax
	mov dword ptr[TID+4*1], edx
	mov eax, dword ptr[edi+4*2];.u64.Lo
	mov edx, dword ptr[edi+4*3];.u64.Hi
	mov dword ptr[TIE+4*0], eax
	mov dword ptr[TIE+4*1], edx
	mov eax, dword ptr[edi+4*4];.u64.Lo
	mov edx, dword ptr[edi+4*5];.u64.Hi
	mov dword ptr[TIF+4*0], eax
	mov dword ptr[TIF+4*1], edx
	mov eax, dword ptr[edi+4*6];.u64.Lo
	mov edx, dword ptr[edi+4*7];.u64.Hi
	mov dword ptr[TIG+4*0], eax
	mov dword ptr[TIG+4*1], edx
	mov eax, dword ptr[edi+4*8];.u64.Lo
	mov edx, dword ptr[edi+4*9];.u64.Hi
	mov dword ptr[TIH+4*0], eax
	mov dword ptr[TIH+4*1], edx

	mov eax, dword ptr[edi+4*10];.u64.Lo
	mov edx, dword ptr[edi+4*11];.u64.Hi
	mov dword ptr[TII+4*0], eax
	mov dword ptr[TII+4*1], edx
	mov eax, dword ptr[edi+4*12];.u64.Lo
	mov edx, dword ptr[edi+4*13];.u64.Hi
	mov dword ptr[TIJ+4*0], eax
	mov dword ptr[TIJ+4*1], edx
	mov eax, dword ptr[edi+4*14];.u64.Lo
	mov edx, dword ptr[edi+4*15];.u64.Hi
	mov dword ptr[TIK+4*0], eax
	mov dword ptr[TIK+4*1], edx
	
	ROUND TIA, TIB, TIC, TID, 5
	ROUND TIB, TIC, TIA, TIE, 5
	ROUND TIC, TIA, TIB, TIF, 5
	ROUND TIA, TIB, TIC, TIG, 5
	ROUND TIB, TIC, TIA, TIH, 5
	ROUND TIC, TIA, TIB, TII, 5
	ROUND TIA, TIB, TIC, TIJ, 5
	ROUND TIB, TIC, TIA, TIK, 5

	KEY_SCHEDULE

	ROUND TIC, TIA, TIB, TID, 7
	ROUND TIA, TIB, TIC, TIE, 7
	ROUND TIB, TIC, TIA, TIF, 7
	ROUND TIC, TIA, TIB, TIG, 7
	ROUND TIA, TIB, TIC, TIH, 7
	ROUND TIB, TIC, TIA, TII, 7
	ROUND TIC, TIA, TIB, TIJ, 7
	ROUND TIA, TIB, TIC, TIK, 7	

	KEY_SCHEDULE

	ROUND TIB, TIC, TIA, TID, 9
	ROUND TIC, TIA, TIB, TIE, 9
	ROUND TIA, TIB, TIC, TIF, 9
	ROUND TIB, TIC, TIA, TIG, 9
	ROUND TIC, TIA, TIB, TIH, 9
	ROUND TIA, TIB, TIC, TII, 9
	ROUND TIB, TIC, TIA, TIJ, 9
	ROUND TIC, TIA, TIB, TIK, 9
	mov esi, offset TigerDigest
	;XOR64 [esi+0*8], TIA;01
	mov eax, dword ptr[TIA+4*0]
	mov edx, dword ptr[TIA+4*1]
	xor dword ptr[esi+4*0], eax
	xor dword ptr[esi+4*1], edx
	
	;SUB64 TIB, esi[1*8]
	mov eax, dword ptr[esi+4*2]
	mov edx, dword ptr[esi+4*3]
	sub dword ptr[TIB+4*0], eax
	sbb dword ptr[TIB+4*1], edx
	;MOV64 esi[1*8], TIB;23
	
	mov eax, dword ptr[TIB+4*0]
	mov edx, dword ptr[TIB+4*1]
	mov dword ptr[esi+4*2], eax
	mov dword ptr[esi+4*3], edx
	;ADD64 esi[2*8], TIC;34
	mov eax, dword ptr[TIC]
	mov edx, dword ptr[TIC+4]
	add dword ptr[esi+4*4], eax
	adc dword ptr[esi+4*5], edx
	
	add esp, Tigerlocals
	popad
	ret
TigerTransform endp

TigerBURN macro
	xor eax, eax
	mov TigerIndex, eax
	mov edi, Offset TigerHashBuf
	mov ecx, (sizeof TigerHashBuf)/4
	rep stosd
endm

align 4
TigerInit proc uses edi esi
	xor eax, eax
	mov TigerLen, eax
	mov edi, Offset TigerDigest
	mov esi, Offset TigerCHAIN
	mov ecx, (sizeof TigerDigest)/4
	rep movsd	
	TigerBURN
	mov eax, Offset TigerDigest 
	ret
TigerInit endp

align 4
TigerUpdate proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx, dwBufLen
	add TigerLen, ebx
	.while ebx
		mov eax, TigerIndex
		mov edx, 64
		sub edx, eax
		.if edx <= ebx
			lea edi, [TigerHashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call TigerTransform
			TigerBURN
		.else
			lea edi, [TigerHashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, TigerIndex
			add eax, ebx
			mov TigerIndex, eax
			.break
		.endif
	.endw
	ret
TigerUpdate endp

align 4
TigerFinal proc uses esi edi
	mov ecx, TigerIndex
	mov byte ptr [TigerHashBuf+ecx], 01h
	.if ecx >= 56
		call TigerTransform
		TigerBURN
	.endif
	mov eax, TigerLen
	xor edx, edx
	shld edx, eax, 3
	shl eax, 3
	mov dword ptr [TigerHashBuf+56], eax
	mov dword ptr [TigerHashBuf+60], edx
	call TigerTransform
	mov eax, offset TigerDigest
	xor ecx, ecx
	ret
TigerFinal endp
