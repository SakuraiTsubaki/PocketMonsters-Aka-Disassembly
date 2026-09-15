; Residual bytes at $0068-$00FF in the Japanese Red builds.
; These bytes are not executed. They are preserved exactly because a
; bit-perfect reconstruction must retain them.

SECTION "Garbage Header", ROM0[$0068]
IF DEF(AKA_JP_REV0)
	db $FF, $DF, $3D, $5D, $F3, $37, $FD, $71, $F5, $BF, $57, $FD, $97, $76, $BB, $D9
	db $DF, $DF, $FF, $D9, $FF, $FF, $D9, $9F, $FF, $FF, $FF, $DF, $FF, $FD, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FD, $FF, $FF, $DF, $FF, $FF, $7F, $FF, $FF
	db $FF, $FF, $FF, $FB, $FF, $FF, $FF, $F3, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $DF
	db $FF, $FF, $BF, $FB, $DF, $FF, $F7, $B7, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $77
	db $7F, $FF, $FB, $FF, $FF, $F7, $FF, $F7, $FF, $FD, $7F, $FF, $FD, $DF, $FF, $DF
	db $FF, $FF, $FF, $FF, $FF, $FF, $F7, $FF, $7F, $FF, $FF, $FF, $FF, $FD, $FF, $FF
	db $FF, $FB, $7B, $FF, $FF, $F7, $FF, $FB, $FD, $FF, $FF, $FF, $FF, $F7, $FF, $FD
	db $FF, $FF, $F7, $FF, $FF, $FF, $FF, $FF, $FD, $FD, $FF, $FF, $FF, $FF, $FF, $FF
	db $F7, $FF, $FF, $FF, $FB, $FF, $FF, $FF
ENDC

IF DEF(AKA_JP_REVA)
	db $FF, $01, $FF, $28, $5F, $24, $FF, $FF, $FF, $62, $FF, $C4, $76, $80, $7F, $02
	db $D5, $0F, $FF, $01, $E6, $23, $DF, $FF, $00, $7F, $85, $FF, $54, $7F, $34, $BB
	db $92, $FF, $55, $DD, $91, $4F, $08, $DF, $FF, $68, $FD, $04, $97, $5C, $DD, $9C
	db $DD, $60, $C9, $20, $7F, $04, $2F, $6F, $FF, $08, $DB, $53, $D6, $4A, $DB, $83
	db $FB, $89, $D6, $20, $D5, $E6, $FB, $FF, $FF, $40, $FE, $88, $FF, $00, $BF, $80
	db $7E, $16, $71, $85, $4E, $80, $DF, $FF, $FF, $52, $77, $09, $ED, $87, $D7, $F0
	db $FF, $15, $FD, $40, $DF, $41, $FF, $FF, $FF, $8E, $7D, $C9, $FF, $1D, $F7, $B9
	db $EF, $8E, $7E, $4A, $FF, $61, $FF, $FF, $FF, $06, $FF, $11, $E3, $00, $F7, $42
	db $7F, $5A, $EF, $20, $F9, $56, $77, $BF, $FF, $84, $EA, $91, $DF, $38, $FF, $59
	db $FF, $02, $F7, $44, $FE, $4A, $FD, $DF
ENDC
