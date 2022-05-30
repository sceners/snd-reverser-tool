
ReadFileToMemory			proto
CheckValidPEFile 			proto
CryptoSearchEngineSimple	proto
SearchEngine_DWORD 			proto
SearchEngine_BYTES 			proto
FixResultDependencies 		proto
dwordc						proto	:dword, :dword, :dword
bytec						proto	:dword, :dword, :dword, :dword


SIG_DATA struc
	CryptoName				dword 00000000h
	FurtherDetails			dword 00000000h
	Signature    			dword 00000000h
	SignatureLength			dword 00000000h
	SearchAlgorithm			dword 00000000h
	FoundBOOL				dword 00000000h
	FoundOffsets 			dword 00000000h
SIG_DATA ends


.data
scaningFlag					dd 4 dup (0)
CryptoSimpleSig				dd 4 dup (0)

ScanFileName				db 256 dup(0)
CryptoFile 					dd 00h					; Crypto File Handle
CryptoMem	 				dd 00h					; Crypto MemPoint
CryptoSize					dd 00h					; Crypto Size
CryptoSizeF1	 			dd 00h
CryptoFilePath 				db 260 dup (0)


_nextSignature				dd offset SIG_CRC16
							dd offset SIG_CRC32
							dd offset SIG_CRC32b
							dd offset SIG_MD2
							dd offset SIG_MD2L
							dd offset SIG_MD4
							dd offset SIG_MD5
							dd offset SIG_MD5M
							dd offset SIG_MD5U
							dd offset SIG_SHA1
							dd offset SIG_SHA1M
							dd offset SIG_SHA224
							dd offset SIG_SHA256
							dd offset SIG_SHA256M
							dd offset SIG_SHA384
							dd offset SIG_SHA512
							dd offset SIG_SHA384512M
							dd offset SIG_RIPEMD128
							dd offset SIG_RIPEMD160
							dd offset SIG_RIPEMD256
							dd offset SIG_RIPEMD320
							dd offset SIG_TIGER
							dd offset SIG_WHIRLPOOL
							dd offset SIG_HAVAL
							dd offset SIG_BASE32
							dd offset SIG_BASE64
							dd offset SIG_BASE64FG
							dd offset SIG_BASE64VB
							dd offset SIG_CAST
							dd offset SIG_CASTM
							dd offset SIG_RC2
							dd offset SIG_RC2L
							dd offset SIG_RC4
							dd offset SIG_RC5
							dd offset SIG_RC6
							dd offset SIG_RC56a
							dd offset SIG_RC56b
							dd offset SIG_BLOWFISH
							dd offset SIG_TWOFISH1
							dd offset SIG_TWOFISH2
							dd offset SIG_DESC1C
							dd offset SIG_DESC1L
							dd offset SIG_DESC2C
							dd offset SIG_DESC2L
							dd offset SIG_DESC3C
							dd offset SIG_DESC3L
							dd offset SIG_NEWDES
							dd offset SIG_DESX
							dd offset SIG_RIJNDAEL1
							dd offset SIG_RIJNDAEL2
							dd offset SIG_RIJNDAEL3
							dd offset SIG_GOST1
							dd offset SIG_GOST2
							dd offset SIG_GOST3
							dd offset SIG_GOST4
							dd offset SIG_TEA1
							dd offset SIG_TEA2
							dd offset SIG_MARS1
							dd offset SIG_MARS2
							dd offset SIG_SKIPJACK
							dd offset SIG_RUBY
							dd offset SIG_ENIGMA
							dd offset SIG_SAFER1
							dd offset SIG_SAFER2
							dd offset SIG_SEAL
							dd offset SIG_SQUARE
							dd offset SIG_SNEFRU
							dd offset SIG_SHARK
							dd offset SIG_FROG
							dd offset SIG_LOKI
							dd offset SIG_MISTY
							dd offset SIG_CRYPTON
							dd offset SIG_ICE
							dd offset SIG_ECC
							dd offset SIG_HPC
							dd offset SIG_DFC
							dd offset SIG_MMB
							dd offset SIG_E2
							dd offset SIG_Q128
							;dd offset SIG_REDOC1
							;dd offset SIG_REDOC2
							;dd offset SIG_S1
							dd offset SIG_MIRACL
							dd offset SIG_BIGLIB
							dd offset SIG_BIGLIBCREATE
							dd offset SIG_BIGLIBDESTROY
							dd offset SIG_FGINT
							dd offset SIG_FGINTRSA
							dd offset SIG_FGINTDSA
							dd offset SIG_FGINTGOSTDSA
							dd offset SIG_FGINTELGAMAL
							dd offset SIG_ECELGAMAL
							dd offset SIG_ECDSA
							dd offset SIG_ECGF
							dd offset SIG_TLBRSA1
							dd offset SIG_TLBRSA2
							;dd offset SIG_LB

numberOfSignatures			equ ($ - _nextSignature)/4

