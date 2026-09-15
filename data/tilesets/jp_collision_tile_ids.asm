; Japanese Red Bank 00 collision-tile tables.
; Verified byte-for-byte in V1.0 and V1.1 at $01C4-$028B.

SECTION "JP Collision Tile IDs", ROM0[$01C4]

Underground_Coll::
	db $0b, $0c, $13, $15, $18, $ff

Overworld_Coll::
	db $00, $10, $1b, $20, $21, $23, $2c, $2d, $2e, $30, $31, $33, $39, $3c, $3e, $52, $54, $58, $5b, $ff

RedsHouse1_Coll::
RedsHouse2_Coll::
	db $01, $02, $03, $11, $12, $13, $14, $1c, $1a, $ff

Mart_Coll::
Pokecenter_Coll::
	db $11, $1a, $1c, $3c, $5e, $ff

Dojo_Coll::
Gym_Coll::
	db $11, $16, $19, $2b, $3c, $3d, $3f, $4a, $4c, $4d, $03, $ff

Forest_Coll::
	db $1e, $20, $2e, $30, $34, $37, $39, $3a, $40, $51, $52, $5a, $5c, $5e, $5f, $ff

House_Coll::
	db $01, $12, $14, $28, $32, $37, $44, $54, $5c, $ff

ForestGate_Coll::
Gate_Coll::
Museum_Coll::
	db $01, $12, $14, $1a, $1c, $37, $38, $3b, $3c, $5e, $ff

Ship_Coll::
	db $04, $0d, $17, $1d, $1e, $23, $34, $37, $39, $4a, $ff

ShipPort_Coll::
	db $0a, $1a, $32, $3b, $ff

Cemetery_Coll::
	db $01, $10, $13, $1b, $22, $42, $52, $ff

Interior_Coll::
	db $04, $0f, $15, $1f, $3b, $45, $47, $55, $56, $ff

Cavern_Coll::
	db $05, $15, $18, $1a, $20, $21, $22, $2a, $2d, $30, $ff

UnusedCollisionTable::
	db $ff ; unused empty table

Lobby_Coll::
	db $14, $17, $1a, $1c, $20, $38, $45, $ff

Mansion_Coll::
	db $01, $05, $11, $12, $14, $1a, $1c, $2c, $53, $ff

Lab_Coll::
	db $0c, $26, $16, $1e, $34, $37, $ff

Club_Coll::
	db $0f, $1a, $1f, $26, $28, $29, $2c, $2d, $2e, $2f, $41, $ff

Facility_Coll::
	db $01, $10, $11, $13, $1b, $20, $21, $22, $30, $31, $32, $42, $43, $48, $52, $55, $58, $5e, $ff

Plateau_Coll::
	db $1b, $23, $2c, $2d, $3b, $45, $ff
