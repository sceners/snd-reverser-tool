
*********************************
*				*
* SnD Reverser Tool Changelog	*
* ---------------------------	*
*				*
*********************************

30.04.08 : SND Reverser Tool 1.4b5 : Private Release
Functions:
	+ CRC16ccitt (Thanks UFO-Pu55y)
	+ GOST Hash (Thanks UFO-Pu55y)
	+ Panama Hash (Thanks UFO-Pu55y)
	+ SNEFRU 128/256 Hashes (4/8 Rounds) (Thanks UFO-Pu55y)
	+ URLEncode and URLDecode
Options:
	+ Cleaned up the options menu
	+ Autostrip spaces from input
	+ Autostrip non hex chars from input
	+ Autostrip non alpha numeric chars from input
	+ Read Input as Hex
	+ Read Key as Hex
	+ Display Output as Hex
	+ Display Output in Uppercase
	+ Display Output if Unicode (thanks Sub Zer0)
	+ Deep Red Colour Scheme
Fixes:
	* thanks to syk071c who reported and then fixed a bug in the Blowfish encryption.
	* fixed a further issue with Blowfish only encrypting/decrypting the first block of data.
	* fixed crash with UUDecode when entering a single byte (thanks UFO-Pu55y).
	* fixed crash in 512bit calculator when trying to bswap an empty input (thanks HVC)
	* changed bruteforcer status field from DISABLED to READONLY to allow copying of solution (thanks ChupaChu)
Tools:
	+ updated the crypto scanner tool to use updated signatures and engine as in the Olly/Immunity Plugins.
	+ added "Export to .txt" and "Export as IDC" options to the crypto scanner (thanks HVC)
	  (and also thanks to kanal's writers whom the idea is obviously taken from)
	* fixed minor cosmetic bugs in the crypto scanner (thanks HVC)
	+ added ADLER32 initialisation vector to the hash modification tool.
	+ added CRC16 initialisation vector to the hash modification tool.
	+ added CRC16ccitt initialisation vector to the hash modification tool.
	+ added CRC32 initialisation vector to the hash modification tool.
	+ added CRC32b initialisation vector to the hash modification tool.
	+ added GOST hash initialisation vectors to the hash modification tool.
	+ added HAVAL hash initialisation vectors to the hash modification tool.
	+ added PANAMA hash initialisation vectors to the hash modification tool.
	+ added SHA384 hash initialisation vectors to the hash modification tool (implemented as 32bit vectors).
	+ added SHA512hash initialisation vectors to the hash modification tool (implemented as 32bit vectors).
	+ added SNEFRU hash initialisation vectors to the hash modification tool.
	+ added TIGER hash initialisation vectors to the hash modification tool (implemented as 32bit vectors).
	+ added WHIRLPOOL hash initialisation vectors to the hash modification tool (implemented as 32bit vectors).
	+ added GOST to the hash brute force tool.
	+ added PANAMA to the hash brute force tool.
	+ added RIPEMD320 to the hash brute force tool.
	+ added SHA384 to the hash brute force tool.
	+ added SHA512 to the hash brute force tool.
	+ added TIGER to the hash brute force tool.
	+ added WHIRLPOOL to the hash brute force tool.


18.01.08 : SND Reverser Tool 1.3 : Public Release
Fixes:
	* minor bug fixes for the public build.


17.01.2008 : SND Reverser Tool 1.2.2 : Private Release
New Tools:
	+ Improved Flexible Hash Bruteforcer
	+ Added basic hash modification code for hashes with dword sized initialisation vectors. Others may
	  follow later if we get requests to include them.


11.01.2008 : SND Reverser Tool 1.2.1 : Private Release
New Tools:
	+ Flexible Hash Bruteforcer


20.09.2007 : SND Reverser Tool 1.2 : Public Release
New Tools:
	+ Memo Tool (to keep track of current workings)
	+ 512bit Calculator



06.09.2007 : SND Reverser Tool 1.1 : Public Release
New Functions:
	+ UUCode & XXCode
	+ AES/Rijndael
	+ Cast128, Cast256
	+ DES, Triple DES, DESNew
	+ Mars
	+ Skipjack
New Tools Menu Added With Following Tools:
	+ PE File Crypto Scanner
	+ Disabled Control Enabler
Fixes:
	* Removed alpha blend option to enable the tool on Win98



29.08.2007 : SND Reverser Tool 1.0 : Public Release
New Functions:
	+ Blowfish
	+ Twofish
	+ RC2, RC4, RC5, RC6
	+ TEA, xTEA, xxTEA
	+ HAVAL 128/160/192/240/256 with 3/4/5 rounds
Other Additions and Changes:
	+ minimise to tray option
	+ minor GUI changes and fixes



21.08.2007 : SND Reverser Tool 0.1 beta : Private Release
Hashes include: 
	+ Adler32
	+ Crc16,Crc32,Crc32b
	+ MD2,MD4,MD5
	+ SHA0,SHA1,SHA256,SHA384,SHA512
	+ RIPE-MD128,RIPE-MD160,RIPE-MD256,RIPE-MD320
	+ Tiger
	+ Whirlpool.
Base Conversions include:
	+ Base2(Binary)
	+ Base10(Decimal)
	+ Base16(Hexadecimal)
	+ Base32
	+ Base64
Extra Base conversions:
	+ hex input to Base32 
	+ hex input to Base64
Encryptions:
	+ String ROT
	+ String XOR
	+ Caesar Bruteforce
Other Functions:
	+ Reverse String
	+ Uppercase
	+ Lowercase


Key:
+ = Function/Code Added
- = Function/Code Removed
... = In progress
? = Idea/Suggestion
* = Fixed bug