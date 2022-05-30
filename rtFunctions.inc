

;define the REVERSER TOOL functions to be included
include Functions\OTHERS.asm
include Functions\CRC16.asm
include Functions\CRC16CCITT.asm
include Functions\CRC32.asm
include Functions\CRC32b.asm
include Functions\BASE64.asm
include Functions\BASE32.asm
include Functions\MD2.asm
include Functions\MD4.asm
include Functions\MD5.asm
include Functions\SHA0.asm
include Functions\SHA1.asm
include Functions\SHA256.asm
include Functions\SHA384.asm
include Functions\SHA512.asm
include Functions\RIPEMD128.asm
include Functions\RIPEMD160.asm
include Functions\RIPEMD256.asm
include Functions\RIPEMD320.asm
include Functions\HAVAL.asm
include Functions\ADLER32.asm
include Functions\TIGER.asm
include Functions\WHIRLPOOL.asm
include Functions\PANAMA.asm
include Functions\GOST.asm
include Functions\BASE16.asm
include Functions\BASE10.asm
include Functions\BASE2.asm
include Functions\STRINGXOR.asm
include Functions\STRINGROT.asm
include Functions\URLEncode.asm
include Functions\CAESAR.asm
include Functions\STRINGTRANSFORMS.asm
include Functions\BLOWFISH.asm
include Functions\TWOFISH.asm
include Functions\TEA.asm
include Functions\RC2.asm
include Functions\RC4.asm
include Functions\RC5.asm
include Functions\RC6.asm
include Functions\UUCODE.asm
include Functions\XXCODE.asm
include Functions\DES.asm
include Functions\3DES.asm
include Functions\NEWDES.asm
include Functions\SKIPJACK.asm
include Functions\CAST128.asm
include Functions\CAST256.asm
include Functions\AES.asm
include Functions\MARS.asm
include Functions\3WAY.asm
include Functions\SNEFRU.asm



.data	
;***************************************************************************************
;Define data to power the combo box
;***************************************************************************************

line_break1			db '------------------------------------------------------- Hashing --------------------------------------------------------', 0
line_break2			db '------------------------------------------------------ Encryption ------------------------------------------------------', 0
line_break3			db '------------------------------------------------------- Encoding -------------------------------------------------------', 0
line_break4			db '----------------------------------------------- Conversion / Transformation --------------------------------------------', 0

_3way_enc_string	db '3-Way (Encrypt)', 0
_3way_dec_string	db '3-Way (Decrypt)', 0
adler32_string		db 'Adler32 (Checksum)', 0
aes_enc_string		db 'AES (Rijndael - Encrypt)', 0
aes_dec_string		db 'AES (Rijndael - Decrypt)', 0
base2enc_string		db 'Base2 Encode (String to Binary)', 0
base2dec_string		db 'Base2 Decode (Binary to String)', 0
char2dec_string		db 'Base10 Encode (String to Dec)', 0
dec2char_string		db 'Base10 Decode (Dec to String)', 0
char2hex_string		db 'Base16 Encode (String to Hex)', 0
hex2char_string		db 'Base16 Decode (Hex to String)', 0
base32_enc_string	db 'Base32 Encode (String to Base32)', 0
base32_dec_string	db 'Base32 Decode (Base32 to String)', 0
base64_enc_string	db 'Base64 Encode (String to Base64)', 0
base64_dec_string	db 'Base64 Decode (Base64 to String)', 0
blowfish_enc_string	db 'Blowfish (Encrypt)', 0
blowfish_dec_string	db 'Blowfish (Decrypt)', 0
cast128enc_string	db 'Cast128 (80bit key - Encrypt)', 0
cast128dec_string	db 'Cast128 (80bit key - Decrypt)', 0
cast256enc_string	db 'Cast256 (Encrypt)', 0
cast256dec_string	db 'Cast256 (Decrypt)', 0
caesar_string		db 'Caesar Cipher Bruteforce (All 25 Rotations)', 0
upper_string		db 'Convert a String To Uppercase', 0
lower_string		db 'Convert a String To Lowercase', 0
dec2hex_string		db 'Convert Decimal Number to Hex', 0
hex2dec_string		db 'Convert Hex Number to Decimal', 0
crc16_string		db 'CRC16 (Cyclic Redundancy Code)', 0
crc16ccitt_string	db 'CRC16ccitt (Cyclic Redundancy Code)', 0
crc32_string		db 'CRC32 (Cyclic Redundancy Code)', 0
crc32b_string		db 'CRC32b (Cyclic Redundancy Code)', 0
des_enc_string		db 'DES (Data Encryption Standard - Encrypt)', 0
des_dec_string		db 'DES (Data Encryption Standard - Decrypt)', 0
desnew_enc_string	db 'DES New (Data Encryption Standard - Encrypt)', 0
desnew_dec_string	db 'DES New (Data Encryption Standard - Decrypt)', 0
des3_enc_string		db 'DES Triple (Data Encryption Standard - Encrypt)', 0
des3_dec_string		db 'DES Triple (Data Encryption Standard - Decrypt)', 0
gost_string			db 'GOST (256bit Cryptographic Hash Function)', 0
haval128_string		db 'HAVAL 128 (3/4/5 Rounds) (Cryptographic Hash Function)', 0
haval160_string		db 'HAVAL 160 (3/4/5 Rounds) (Cryptographic Hash Function)', 0
haval192_string		db 'HAVAL 192 (3/4/5 Rounds) (Cryptographic Hash Function)', 0
haval224_string		db 'HAVAL 224 (3/4/5 Rounds) (Cryptographic Hash Function)', 0
haval256_string		db 'HAVAL 256 (3/4/5 Rounds) (Cryptographic Hash Function)', 0
mars_enc_string		db 'Mars (Encrypt)', 0
mars_dec_string		db 'Mars (Decrypt)', 0
md2_string			db 'MD2 (Message Digest 2)', 0
md4_string			db 'MD4 (Message Digest 4)', 0
md5_string			db 'MD5 (Message Digest 5)', 0
panama_string		db 'Panama (256bit Cryptographic Hash Function)', 0
sha0_string			db 'SHA-0 (Secure Hash Algorithm)', 0
sha1_string			db 'SHA-1 (Secure Hash Algorithm)', 0
sha256_string		db 'SHA-256 (Secure Hash Algorithm)', 0
sha384_string		db 'SHA-384 (Secure Hash Algorithm)', 0
sha512_string		db 'SHA-512 (Secure Hash Algorithm)', 0
rc2_enc_string		db 'RC2 (Rivest Cipher 2 - Encrypt)', 0
rc2_dec_string		db 'RC2 (Rivest Cipher 2 - Decrypt)', 0
rc4_enc_string		db 'RC4 (Rivest Cipher 4 - Encrypt)', 0
rc4_dec_string		db 'RC4 (Rivest Cipher 4 - Decrypt)', 0
rc5_enc_string		db 'RC5 (Rivest Cipher 5 - Encrypt)', 0
rc5_dec_string		db 'RC5 (Rivest Cipher 5 - Decrypt)', 0
rc6_enc_string		db 'RC6 (Rivest Cipher 6 - Encrypt)', 0
rc6_dec_string		db 'RC6 (Rivest Cipher 6 - Decrypt)', 0
reverse_string		db 'Reverse a String', 0
ripemd128_string	db 'RIPEMD-128 (RACE Integrity Primitives Evaluation Message Digest)', 0
ripemd160_string	db 'RIPEMD-160 (RACE Integrity Primitives Evaluation Message Digest)', 0
ripemd256_string	db 'RIPEMD-256 (RACE Integrity Primitives Evaluation Message Digest)', 0
ripemd320_string	db 'RIPEMD-320 (RACE Integrity Primitives Evaluation Message Digest)', 0
stringrot_string	db 'ROT (ROT a string against the value of the key)', 0
sj_enc_string		db 'SkipJack (Encrypt)', 0
sj_dec_string		db 'SkipJack (Decrypt)', 0
snefru128_string	db 'SNEFRU 128 (4/8 Rounds) (Cryptographic Hash Function)', 0
snefru256_string	db 'SNEFRU 256 (4/8 Rounds) (Cryptographic Hash Function)', 0
tea_enc_string		db 'TEA (Tiny Encryption Algorithm - Encrypt)', 0
tea_dec_string		db 'TEA (Tiny Encryption Algorithm - Decrypt)', 0
extea_enc_string	db 'TEAx (Tiny Encryption Algorithm - Encrypt)', 0
extea_dec_string	db 'TEAx (Tiny Encryption Algorithm - Decrypt)', 0
xxtea_enc_string	db 'TEAxx (Tiny Encryption Algorithm - Encrypt)', 0
xxtea_dec_string	db 'TEAxx (Tiny Encryption Algorithm - Decrypt)', 0
tiger_string		db 'Tiger (192bit Cryptographic Hash Function)', 0
twofish_enc_string	db 'Twofish (Encrypt)', 0
twofish_dec_string	db 'Twofish (Decrypt)', 0
urlencode_string	db 'URLEncode (converts unsafe characters only)', 0
urldecode_string	db 'URLDecode (converts all hex chars to ascii)', 0
uucode_enc_string	db 'UUCode Encode (Unix to Unix Encoding)', 0
uucode_dec_string	db 'UUCode Decode (Unix to Unix Decoding)', 0
whirlpool_string	db 'Whirlpool (512bit Cryptographic Hash Function)', 0
stringxor_string	db 'XOR (XOR a string against the value of the key)', 0
xxcode_enc_string	db 'XXCode Encode (Unix to Unix Encoding)', 0
xxcode_dec_string	db 'XXCode Decode (Unix to Unix Decoding)', 0



hComboData			dd offset line_break1
					dd offset adler32_string
					dd offset crc16_string
					dd offset crc16ccitt_string
					dd offset crc32_string
					dd offset crc32b_string
					dd offset gost_string
					dd offset haval128_string
					dd offset haval160_string
					dd offset haval192_string
					dd offset haval224_string
					dd offset haval256_string
					dd offset md2_string
					dd offset md4_string
					dd offset md5_string
					dd offset panama_string
					dd offset ripemd128_string
					dd offset ripemd160_string
					dd offset ripemd256_string
					dd offset ripemd320_string
					dd offset sha0_string
					dd offset sha1_string
					dd offset sha256_string
					dd offset sha384_string
					dd offset sha512_string
					dd offset snefru128_string
					dd offset snefru256_string
					dd offset tiger_string
					dd offset whirlpool_string

					dd offset line_break2
					dd offset _3way_enc_string
					dd offset _3way_dec_string
					dd offset aes_enc_string
					dd offset aes_dec_string
					dd offset blowfish_enc_string
					dd offset blowfish_dec_string
					dd offset caesar_string
					dd offset cast128enc_string
					dd offset cast128dec_string
					dd offset cast256enc_string
					dd offset cast256dec_string
					dd offset des_enc_string
					dd offset des_dec_string
					dd offset des3_enc_string
					dd offset des3_dec_string
					dd offset desnew_enc_string
					dd offset desnew_dec_string
					dd offset mars_enc_string
					dd offset mars_dec_string
					dd offset rc2_enc_string
					dd offset rc2_dec_string
					dd offset rc4_enc_string
					dd offset rc4_dec_string
					dd offset rc5_enc_string
					dd offset rc5_dec_string
					dd offset rc6_enc_string
					dd offset rc6_dec_string
					dd offset stringrot_string
					dd offset sj_enc_string
					dd offset sj_dec_string
					dd offset tea_enc_string
					dd offset tea_dec_string
					dd offset extea_enc_string
					dd offset extea_dec_string
					dd offset xxtea_enc_string
					dd offset xxtea_dec_string
					dd offset twofish_enc_string
					dd offset twofish_dec_string
					dd offset stringxor_string

					dd offset line_break3
					dd offset base2enc_string
					dd offset base2dec_string
					dd offset char2dec_string
					dd offset dec2char_string
					dd offset char2hex_string
					dd offset hex2char_string
					dd offset base32_enc_string
					dd offset base32_dec_string
					dd offset base64_enc_string
					dd offset base64_dec_string
					dd offset uucode_enc_string
					dd offset uucode_dec_string
					dd offset xxcode_enc_string
					dd offset xxcode_dec_string

					dd offset line_break4
					dd offset upper_string
					dd offset lower_string
					dd offset reverse_string
					dd offset urlencode_string
					dd offset urldecode_string
					dd offset dec2hex_string
					dd offset hex2dec_string

hComboDataSize		equ ($ - hComboData)/4



_function			dd offset NULL_RT
					dd offset ADLER32_RT
					dd offset CRC16_RT
					dd offset CRC16CCITT_RT
					dd offset CRC32_RT
					dd offset CRC32b_RT
					dd offset GOST_RT
					dd offset HAVAL128_RT
					dd offset HAVAL160_RT
					dd offset HAVAL192_RT
					dd offset HAVAL224_RT
					dd offset HAVAL256_RT
					dd offset MD2_RT
					dd offset MD4_RT
					dd offset MD5_RT
					dd offset PANAMA_RT
					dd offset RIPEMD128_RT
					dd offset RIPEMD160_RT
					dd offset RIPEMD256_RT
					dd offset RIPEMD320_RT
					dd offset SHA0_RT
					dd offset SHA1_RT
					dd offset SHA256_RT
					dd offset SHA384_RT
					dd offset SHA512_RT
					dd offset SNEFRU128_RT
					dd offset SNEFRU256_RT
					dd offset TIGER_RT
					dd offset WHIRLPOOL_RT

					dd offset NULL_RT
					dd offset _3WAY_ENC_RT
					dd offset _3WAY_DEC_RT
					dd offset AES_ENC_RT
					dd offset AES_DEC_RT
					dd offset BLOWFISH_ENC_RT
					dd offset BLOWFISH_DEC_RT
					dd offset CAESAR_RT
					dd offset CAST128_ENC_RT
					dd offset CAST128_DEC_RT
					dd offset CAST256_ENC_RT
					dd offset CAST256_DEC_RT
					dd offset DES_ENC_RT
					dd offset DES_DEC_RT
					dd offset _3DES_ENC_RT
					dd offset _3DES_DEC_RT
					dd offset DESNEW_ENC_RT
					dd offset DESNEW_DEC_RT
					dd offset MARS_ENC_RT
					dd offset MARS_DEC_RT
					dd offset RC2_ENC_RT
					dd offset RC2_DEC_RT
					dd offset RC4_ENC_RT
					dd offset RC4_DEC_RT
					dd offset RC5_ENC_RT
					dd offset RC5_DEC_RT
					dd offset RC6_ENC_RT
					dd offset RC6_DEC_RT
					dd offset STRINGROT_RT
					dd offset SKIPJACK_ENC_RT
					dd offset SKIPJACK_DEC_RT
					dd offset TEA_ENC_RT
					dd offset TEA_DEC_RT
					dd offset ExTEA_ENC_RT
					dd offset ExTEA_DEC_RT
					dd offset XXTEA_ENC_RT
					dd offset XXTEA_DEC_RT
					dd offset TWOFISH_ENC_RT
					dd offset TWOFISH_DEC_RT
					dd offset STRINGXOR_RT

					dd offset NULL_RT
					dd offset BASE2_ENCODE_RT
					dd offset BASE2_DECODE_RT
					dd offset BASE10_ENCODE_RT
					dd offset BASE10_DECODE_RT
					dd offset BASE16_ENCODE_RT
					dd offset BASE16_DECODE_RT
					dd offset BASE32_ENCODE_RT
					dd offset BASE32_DECODE_RT
					dd offset BASE64_ENCODE_RT
					dd offset BASE64_DECODE_RT
					dd offset UUE_ENCODE_RT
					dd offset UUE_DECODE_RT
					dd offset XXE_ENCODE_RT
					dd offset XXE_DECODE_RT

					dd offset NULL_RT
					dd offset STRINGT_UPPER_RT
					dd offset STRINGT_LOWER_RT
					dd offset STRINGT_REVERSE_RT
					dd offset URLENCODE_RT
					dd offset URLDECODE_RT
					dd offset DEC2HEX_RT
					dd offset HEX2DEC_RT

