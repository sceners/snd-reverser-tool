# SND Reverser Tool.

#### Written in 2008.

[Original package](https://defacto2.net/f/b11d03e)

![image](https://user-images.githubusercontent.com/513842/170957958-a425d7c8-b973-4058-bfae-c3ca86470aee.png)

---
```
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
```
