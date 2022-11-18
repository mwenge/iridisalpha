*=$18C8
; The wave data has the following structure:
; Byte 0 ($00): An index into colorsForAttackShips that applies a color value for the attack ship sprite.
; Byte 1 ($01): Sprite value for the attack ship for the upper planet.
; Byte 2 ($02): THe 'end' sprite value for the attack ship's animation for the upper planet.
; Byte 3 ($03): The animation frame rate for the attack ship.
; Byte 4 ($04): Sprite value for the attack ship for the lower planet.
; Byte 5 ($05): THe 'end' sprite value for the attack ship's animation for the lower planet.
; Byte 6 ($06): Determines if the inital Y Position of the ship is random or uses a default.
; Byte 7 ($07): Determines if the inital Y Position of the ship is random or uses a default.
; Byte 8 ($08): Default initiation Y position for the enemy. 
; Byte 9 ($09):  Lo Ptr for an animation effect? (Doesn't seem to be used?) 
; Byte 10 ($0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
; Byte 11 ($0B): some kind of rate limiting for attack wave 
; Byte 12 ($0C): Lo Ptr for a stage in wave data (never used).
; Byte 13 ($0D): Hi Ptr for a stage in wave data (never used). 
; Byte 14 ($0E): Controls the rate at which new enemies are added? 
; Byte 15 ($0F): Update rate for attack wave 
; Byte 16 ($10): Lo Ptr to the wave data we switch to when the enemy is first hit. 
; Byte 17 ($11): Hi Ptr to the wave data we switch to when the enemy is first hit.
; Byte 18 ($12): X Pos movement for attack ship.
; Byte 19 ($13): Y Pos movement pattern for attack ship. An index into yPosMovementPatternForShips1
; Byte 20 ($14): X Pos Frame Rate for Attack ship.
; Byte 21 ($15): Y Pos Frame Rate for Attack ship.
; Byte 22 ($16): Stickiness factor, does the enemy stick to the player sapping their energy if they're near them?
; Byte 23 ($17): Does the enemy gravitate quickly toward the player when its been shot? (Typical lickership behaviour) 
; Byte 24 ($18): 
; Byte 25 ($19): Lo Ptr for another set of wave data. 
; Byte 26 ($1A): Hi Ptr for another set of wave data.
; Byte 27 ($1B): Lo Ptr for another set of wave data.
; Byte 28 ($1C): Hi Ptr for another set of wave data.
; Byte 29 ($1D): Lo Ptr for Explosion animation. 
; Byte 30 ($1E): Hi Ptr for Explosion animation. 
; Byte 31 ($1F): Lo Ptr for another set of wave data for this level. 
; Byte 32 ($20): Hi Ptr for another set of wave data for this level. 
; Byte 33 ($21): A flag that tells us whether to load the extra stage data for this enemy. 
; Byte 34: ($22): Points multiplier for hitting enemies in this level. 
; Byte 35: ($23) The amount of energy the enemy saps from gilby.
; Byte 36: ($24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
;
; Example:
;
; planet1Level1Data
;         .BYTE $06,FLYING_SAUCER,FLYING_SAUCER+$03,$03,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
;         .BYTE $00,$00,$00,$00,$00,$00,$00,$40
;         .BYTE <planet1Level1Data2ndStage,>planet1Level1Data2ndStage,$06,$01,$01,$01,$00,$00
;         .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
;         .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
;         .BYTE $00,$00,$02,$02,$00,$04,$18,$00
; planet1Level1Data2ndStage
;         .BYTE $11,FLYING_SAUCER,FLYING_SAUCER+$03,$01,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
;         .BYTE $00,$00,$00,$00,$00,$00,$00,$40
;         .BYTE <planet1Level1Data,>planet1Level1Data,$06,$FF,$01,$01,$00,$00
;         .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
;         .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
;         .BYTE $00,$00,$02,$02,$00,$00,$00,$00
;
; planet1Level3Data
;         .BYTE $05,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$04,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
;         .BYTE $00,$00,$00,$00,$00,$00,$00,$30
;         .BYTE <planet1Level3Data2ndStage,>planet1Level3Data2ndStage,$FA,$01,$01,$02,$00,$00
;         .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
;         .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
;         .BYTE $00,$00,$02,$01,$00,$04,$20,$00
; planet1Level3Data2ndStage
;         .BYTE $04,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$02,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
;         .BYTE $00,$00,$00,$00,$00,$00,$00,$20
;         .BYTE <planet1Level3Data3rdStage,>planet1Level3Data3rdStage,$01,$FF,$01,$01,$00,$00
;         .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
;         .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
;         .BYTE $00,$00,$01,$01,$00,$00,$00,$00
; planet1Level3Data3rdStage
;         .BYTE $06,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$06,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
;         .BYTE $00,$00,$00,$00,$00,$00,$00,$33
;         .BYTE <planet1Level3Data,>planet1Level3Data,$F8,$00,$01,$00,$00,$00
;         .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
;         .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
;         .BYTE $00,$00,$01,$01,$00,$00,$00,$00
;
; This data is loaded to currentShipWaveDataLoPtr/currentShipWaveDataHiPtr when it is used in the
; game.

; Sprite names. See sprites.asm and enemy_sprites.asm
MAGIC_MUSHROOM = $2D
INV_MAGIC_MUSHROOM = $2E
FLYING_SAUCER = $A0
LICKERSHIP_SEED = $A5

attackWaveData
default2ndStage
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
planet4Level19Data
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $00,$00,$02,$08,$00,$04,$0C,$00
f1918
        .BYTE $09,$2C,$2D,$00,$2C,$2D,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE $40,$19,$00,$23,$02,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1940,>f1940,<f1940,>f1940
        .BYTE $00,$00,$00,$02,$00,$00,$00,$00
f1940
        .BYTE $05,$E8,$EC,$01,$E8,$EC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE $00,$00,$80,$80,$01,$01,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet2Level7Data
        .BYTE $0F,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet2Level7Data2ndStage,>planet2Level7Data2ndStage,$04,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$02,$00,$04,$10,$00
planet2Level7Data2ndStage
        .BYTE $06,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$80
        .BYTE <planet2Level7Data,>planet2Level7Data,$FC,$00,$01,$03,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
;f19B8
        .BYTE $01,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$03
        .BYTE $50,$18,$80,$80,$01,$01,$00,$00
planet4Level4Data
        .BYTE $03,MAGIC_MUSHROOM,MAGIC_MUSHROOM+$01 ,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet4Level4Data2ndStage,>planet4Level4Data2ndStage,$00,$00,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$04,$00,$04,$18,$00
planet4Level4Data2ndStage
        .BYTE $06,MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$23,$02,$03,$01,$23
        .BYTE <nullPtr,>nullPtr,<planet4Level4Data,>planet4Level4Data
        .BYTE <planet4Level4Data,>planet4Level4Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$06,$00,$00,$00,$00
planet4Level3Data
        .BYTE $02,$31,$35,$03,$31,$35,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$60
        .BYTE <planet4Level2Data2ndStage,>planet4Level2Data2ndStage,$03,$00,$01,$03,$00,$02
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1878,>f1878,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$03,$00,$04,$20,$00
planet4Level2Data2ndStage
        .BYTE $0D,$31,$35,$01,$31,$35,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet4Level3Data,>planet4Level3Data,$80,$FF,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$08,$00,$00,$00,$00
planet1Level9Data
        .BYTE $06,$35,$37,$03,$38,$3A,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$0C
        .BYTE <planet1Level9DataSecondStage,>planet1Level9DataSecondStage,$FC,$23,$01,$03,$00,$00
        .BYTE <planet1Level9DataSecondStage,>planet1Level9DataSecondStage,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$04,$20,$00
planet1Level9DataSecondStage
        .BYTE $0B,$37,$38,$00,$3A,$3B,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$80,$00,$01,$04,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet1Level9Data,>planet1Level9Data
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$03,$00,$00,$00,$00
secondExplosionAnimation
        .BYTE $09,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$04
        .BYTE <spinningRings,>spinningRings,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet3Level3Data
        .BYTE $02,$3B,$3E,$04,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$03,$23,$01,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet3Level3Data2ndStage,>planet3Level3Data2ndStage
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$04,$00,$04,$10,$00
planet3Level3Data2ndStage
        .BYTE $02,$3B,$3E,$04,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FD,$23,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet3Level3Data3rdStage,>planet3Level3Data3rdStage
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$04,$00,$00,$00,$00
planet3Level3Data3rdStage
        .BYTE $0A,$3B,$3E,$0C,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet3Level3Data,>planet3Level3Data,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
planet2Level8Data
        .BYTE $0C,$3E,$40,$04,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$60
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage,$00,$00,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$20,$00,$04,$10,$00
planet2Level8Data2ndStage
        .BYTE $0C,$3E,$40,$04,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <planet2Level8Data3rdStage,>planet2Level8Data3rdStage,$01,$20,$01,$01,$00,$00
        .BYTE <planet2Level8Data,>planet2Level8Data,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$06,$00,$00,$00,$00
planet2Level8Data3rdStage
        .BYTE $0C,$3E,$40,$04,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage,$FE,$20,$01,$01,$00,$00
        .BYTE <planet2Level8Data,>planet2Level8Data,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$06,$00,$00,$00,$00
planet2Level9Data
        .BYTE $04,$C1,$C8,$03,$D4,$DC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet2Level9Data,>planet2Level9Data
        .BYTE <gilbyTakingOffAsExplosion,>gilbyTakingOffAsExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$04,$10,$00
gilbyTakingOffAsExplosion
        .BYTE $04,$CC,$D0,$02,$DF,$E3,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <gilbyLookingLeft,>gilbyLookingLeft,$00,$00,$00,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
gilbyLookingLeft
        .BYTE $02,$D1,$D2,$00,$D1,$D2,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$F8,$00,$01,$03,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$04,$00,$00,$00,$00
planet3Level4Data
        .BYTE $06,$D3,$D4,$00,$D3,$D4,$04,$28
        .BYTE $1C,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$08,$00,$01,$03,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$08,$00,$04,$18,$00
planet3Level5Data
        .BYTE $0B,$27,$2A,$02,$27,$2A,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <stickyGlobeExplosion,>stickyGlobeExplosion,<planet3Level5Data,>planet3Level5Data
        .BYTE $00,$00,$02,$03,$00,$04,$20,$00
stickyGlobeExplosion
        .BYTE $02,$28,$29,$00,$28,$29,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <spinningRings,>spinningRings,$00,$23,$01,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
planet3Level6Data
        .BYTE $00,$C1,$C8,$01,$D4,$DC,$04,$F0
        .BYTE $1C,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$F9,$23,$01,$07,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet3Level6Data,>planet3Level6Data
        .BYTE <planet2Level9Data,>planet2Level9Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$04,$00,$04,$10,$00
f1CF0
        .BYTE $0F,$E7,$E8,$00,$E7,$E8,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$FC,$23,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
planet1Level17Data
        .BYTE $0A,$3B,$3E,$02,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet1Level17Data2ndStage,>planet1Level17Data2ndStage,$80,$80,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <gilbyLookingLeft,>gilbyLookingLeft,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$05,$0C,$00,$04,$20,$00
planet1Level17Data2ndStage
        .BYTE $0D,$3B,$3E,$0C,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$04
        .BYTE <planet1Level17Data3rdStage,>planet1Level17Data3rdStage,$00,$00,$01,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$05,$00,$00,$00,$00
planet1Level17Data3rdStage
        .BYTE $06,$3B,$3E,$04,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <planet1Level17Data,>planet1Level17Data,$80,$80,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<planet1Level17Data,>planet1Level17Data
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$05,$00,$00,$00,$00
planet4Level6Data
        .BYTE $06,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet4Level6Data2ndStage,>planet4Level6Data2ndStage,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$04,$00,$04,$20,$00
planet4Level6Data2ndStage
        .BYTE $0E,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <default2ndStage,>default2ndStage,$FB,$22,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
planet1Level6Data
        .BYTE $0A,$23,$27,$03,$23,$27,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$03
        .BYTE <planet1Level6Data2ndStage,>planet1Level6Data2ndStage,$00,$00,$01,$01,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings2ndType,>spinningRings2ndType,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$04,$00,$04,$10,$00
planet1Level6Data2ndStage
        .BYTE $0A,$23,$27,$03,$23,$27,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$50
        .BYTE <planet1Level6Data,>planet1Level6Data,$80,$80,$01,$01,$00,$00
        .BYTE <planet1Level6Data,>planet1Level6Data,<planet1Level6Data,>planet1Level6Data
        .BYTE <spinningRings2ndType,>spinningRings2ndType,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$04,$00,$00,$00,$00
spinningRings2ndType
        .BYTE $00,$E8,$EB,$01,$E8,$EB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <spinningRings,>spinningRings,$80,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
planet1Level10Data
        .BYTE $08,$30,$31,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$80
        .BYTE <planet1Level10Data2ndStage,>planet1Level10Data2ndStage,$00,$25,$00,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet1Level10Data,>planet1Level10Data
        .BYTE <planet1Level10Data2ndStage,>planet1Level10Data2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$06,$00,$04,$18,$00
planet1Level10Data2ndStage
        .BYTE $02,$30,$31,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <default2ndStage,>default2ndStage,$00,$23,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$04,$00,$00,$00,$00
planet3Level2Data
        .BYTE $0D,$31,$32,$00,$31,$32,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$50
        .BYTE <planet3Level2Data2ndStage,>planet3Level2Data2ndStage,$F8,$01,$01,$0C,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$05,$00,$04,$18,$00
planet3Level2Data2ndStage
        .BYTE $0D,$32,$34,$03,$32,$34,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <planet3Level2Data3rdStage,>planet3Level2Data3rdStage,$80,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$03,$00,$00,$00,$00
planet3Level2Data3rdStage
        .BYTE $0D,$33,$34,$00,$33,$34,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$55
        .BYTE <planet3Level2Data,>planet3Level2Data,$08,$FF,$01,$0C,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$05,$00,$00,$00,$00
planet3Level8Data
        .BYTE $0C,$3E,$40,$03,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <bubbleExplosion,>bubbleExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$04,$10,$00
bubbleExplosion
        .BYTE $0C,$3E,$40,$01,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$F0,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <bubbleExplosion2ndStage,>bubbleExplosion2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
bubbleExplosion2ndStage
        .BYTE $0C,$3E,$40,$01,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage,$10,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$01,$00,$00,$00,$00
planet4Level5Data
        .BYTE $09,$2C,$2D,$00,$2C,$2D,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$23,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1FC0,>f1FC0
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$04,$00,$04,$18,$00
f1FC0
        .BYTE $05,$2C,$2D,$00,$2C,$2D,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$25,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet4Level5Data,>planet4Level5Data
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00

        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$83
*= $9B00
planet1Level15Data
        .BYTE $08,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <planet1Level15Data,>planet1Level15Data,$00,$00,$01,$01,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <teardropExplosion,>teardropExplosion,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$03,$03,$00,$04,$20,$00
teardropExplosion
        .BYTE $11,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$24,$02,$01,$80,$23
        .BYTE <nullPtr,>nullPtr,<teardropExplosion,>teardropExplosion
        .BYTE <default2ndStage,>default2ndStage,<spinningRings,>spinningRings
        .BYTE $00,$00,$00,$00,$01,$00,$00,$00
planet4Level17Data
        .BYTE $00,$B4,$B8,$06,$A7,$AB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <cummingCock,>cummingCock,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$04,$20,$00
cummingCock
        .BYTE $0A,$B4,$B8,$06,$A7,$AB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$23,$02,$01,$80,$23
        .BYTE <nullPtr,>nullPtr,<cummingCock,>cummingCock
        .BYTE <f1398,>f1398,<f1398,>f1398
        .BYTE $00,$00,$04,$03,$00,$00,$00,$00
planet1Level4Data
        .BYTE $11,$AC,$AE,$03,$AC,$AE,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$60
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage,$07,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage,<planet1Level4Data2ndStage,>planet1Level4Data2ndStage
        .BYTE $00,$00,$04,$02,$00,$04,$20,$00
planet1Level4Data2ndStage
        .BYTE $11,$AE,$B0,$03,$AE,$B0,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$70
        .BYTE <planet1Level4Data,>planet1Level4Data,$F9,$80,$01,$80,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$07,$00,$00,$00,$00
planet5Level5Data
        .BYTE $04,$A3,$A5,$05,$A3,$A5,$05,$40
        .BYTE $9C,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet5Level5Data2ndStage,>planet5Level5Data2ndStage,$07,$03,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$02,$00,$04,$20,$00
planet5Level5Data2ndStage
        .BYTE $04,$A3,$A5,$05,$A3,$A5,$05,$40
        .BYTE $9C,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet5Level5Data,>planet5Level5Data,$08,$FD,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$02,$00,$00,$00,$00
f9C40
        .BYTE $07,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$03,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$FE,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
planet3Level10Data
        .BYTE $06,FLYING_SAUCER,FLYING_SAUCER+$03,$03,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$0A
        .BYTE <planet3Level10Data2ndStage,>planet3Level10Data2ndStage,$00,$00,$01,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<planet3Level10Data,>planet3Level10Data
        .BYTE $00,$00,$03,$03,$00,$04,$20,$00
planet3Level10Data2ndStage
        .BYTE $06,FLYING_SAUCER,FLYING_SAUCER+$03,$03,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <planet3Level10Data,>planet3Level10Data,$80,$80,$80,$80,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<planet3Level10Data,>planet3Level10Data
        .BYTE $00,$00,$03,$03,$00,$00,$00,$00
planet4Level10Data
        .BYTE $11,$B2,$B4,$05,$B2,$B4,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <planet4Level10Data2ndStage,>planet4Level10Data2ndStage,$0A,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$04,$20,$00
planet4Level10Data2ndStage
        .BYTE $11,$B0,$B2,$05,$B0,$B2,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet4Level10Data,>planet4Level10Data,$FE,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet4Level10Data,>planet4Level10Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$02,$00,$00,$00,$00
planet5Level6Data
        .BYTE $0B,$AB,$AC,$00,$AB,$AC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$F4,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fighterShipAsExplosion,>fighterShipAsExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$05,$00,$04,$20,$00
fighterShipAsExplosion
        .BYTE $10,$AB,$AC,$00,$AB,$AC,$01,$68
        .BYTE $9C,$00,$00,$00,$00,$00,$00,$10
        .BYTE <nullPtr,>nullPtr,$02,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet4Level15Data
        .BYTE $10,$A7,$AB,$02,$A7,$AB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$02,$03,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinnerAsExplosion,>spinnerAsExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$03,$00,$04,$28,$00
spinnerAsExplosion
        .BYTE $01,$A7,$AB,$01,$A7,$AB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,$80,$00,$80,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$06,$00,$00,$00,$00
planet2Level10Data
        .BYTE $11,$AC,$AD,$00,$AC,$AD,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$06,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <flowchartArrowAsExplosion,>flowchartArrowAsExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$06,$00,$04,$18,$00
flowchartArrowAsExplosion
        .BYTE $06,$AC,$AE,$01,$AC,$AE,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$21,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1500,>f1500
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $60,$00,$00,$06,$00,$00,$00,$00
planet3Level13Data
        .BYTE $06,$F6,$F8,$05,$F9,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipAsExplosion,>lickerShipAsExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$05,$00,$04,$18,$00
lickerShipAsExplosion
        .BYTE $0A,$F6,$F9,$03,$F9,$FC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet3Level13Data3rdStage,>planet3Level13Data3rdStage,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
planet3Level13Data3rdStage
        .BYTE $10,$F6,$F8,$01,$F9,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <planet3Level13Data,>planet3Level13Data,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$03,$00,$00,$00,$00
planet2Level11Data
        .BYTE $00,FLYING_SAUCER,FLYING_SAUCER+$03,$01,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$01,$02,$10,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f9E98,>f9E98
        .BYTE $00,$00,$00,$00,$00,$04,$10,$00
f9E98
        .BYTE $11,FLYING_SAUCER,FLYING_SAUCER+$03,$01,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet4Level10Data,>planet4Level10Data,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet3Level19Data
        .BYTE $0E,$A3,$A5,$04,$A3,$A5,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet3Level19Data2ndStage,>planet3Level19Data2ndStage,$05,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet4Level17Data,>planet4Level17Data,<planet4Level17Data,>planet4Level17Data
        .BYTE $00,$00,$00,$04,$00,$04,$20,$00
planet3Level19Data2ndStage
        .BYTE $08,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet3Level19Data3rdStage,>planet3Level19Data3rdStage,$00,$23,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f13E8,>f13E8,<f13E8,>f13E8
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
planet3Level19Data3rdStage
        .BYTE $11,$A7,$AA,$01,$A7,$AA,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet3Level19Data,>planet3Level19Data,$80,$80,$80,$80,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet1Level4Data,>planet1Level4Data,<planet1Level4Data,>planet1Level4Data
        .BYTE $00,$00,$03,$06,$00,$00,$00,$00
planet5Level1Data
        .BYTE $11,$AB,$AC,$00,$AB,$AC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$60
        .BYTE <planet5Level1Data2ndStage,>planet5Level1Data2ndStage,$FC,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$01,$00,$04,$18,$00
planet5Level1Data2ndStage
        .BYTE $06,$AB,$AC,$00,$AB,$AC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <planet5Level1Data,>planet5Level1Data,$06,$80,$01,$80,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$01,$00,$00,$00,$00
planet4Level1Data
        .BYTE $04,MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$23,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f9FB0,>f9FB0
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$02,$00,$04,$20,$00
f9FB0
        .BYTE $04,MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FA,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet4Level1Data,>planet4Level1Data
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$02,$00,$00,$00,$00
planet3Level1Data
        .BYTE $10,$FC,$FF,$02,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet3Level1Data,>planet3Level1Data,$00,$00,$02,$02,$01,$01
        .BYTE $00,$00,$00,$00,$50,$18,$C8
pieceOfPlanetData
        .BYTE $18
        .BYTE $00,$00,$01,$01,$53,$41,$56,$2A
planet2Level1Data
        .BYTE $55,$31,$35,$01,$31,$35,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <planet2Level1Data,>planet2Level1Data,$00,$00,$01,$02,$01,$10
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <pinAsExplosion,>pinAsExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$02,$00,$04,$18,$00
pinAsExplosion
        .BYTE $11,$31,$32,$00,$31,$32,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$1C
        .BYTE <spinningRings,>spinningRings,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
planet1Level1Data
        .BYTE $06,FLYING_SAUCER,FLYING_SAUCER+$03,$03,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet1Level1Data2ndStage,>planet1Level1Data2ndStage,$06,$01,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$02,$00,$04,$18,$00
planet1Level1Data2ndStage
        .BYTE $11,FLYING_SAUCER,FLYING_SAUCER+$03,$01,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <planet1Level1Data,>planet1Level1Data,$06,$FF,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$02,$00,$00,$00,$00
planet1Level7Data
        .BYTE $09,$BE,$BF,$00,$BE,$BF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$50
        .BYTE <plnet1Level7Data2ndStage,>plnet1Level7Data2ndStage,$07,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <plnet1Level7Data2ndStage,>plnet1Level7Data2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$03,$00,$04,$28,$00
plnet1Level7Data2ndStage
        .BYTE $09,$BE,$BF,$00,$BE,$BF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet1Level7Data3rdStage,>planet1Level7Data3rdStage,$05,$80,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet1Level7Data3rdStage,>planet1Level7Data3rdStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
planet1Level7Data3rdStage
        .BYTE $11,$BE,$C0,$02,$BE,$C0,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet1Level7Data,>planet1Level7Data,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <barExplosion,>barExplosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$04,$00,$00,$00,$00
barExplosion
        .BYTE $09,$BF,$C0,$00,$BF,$C0,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<spinningRings,>spinningRings
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
copticExplosion
        .BYTE $10,$B8,$B9,$00,$B8,$B9,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<spinningRings,>spinningRings
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet1Level20Data
        .BYTE $07,$B9,$BA,$00,$B9,$BA,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$24,$01,$02,$00,$23
        .BYTE <copticExplosion,>copticExplosion,<nullPtr,>nullPtr
        .BYTE <planet1Level20Data,>planet1Level20Data,<planet1Level20Data,>planet1Level20Data
        .BYTE $00,$00,$01,$01,$00,$04,$40,$00
planet2Level20Data
        .BYTE $06,$BA,$BB,$00,$BA,$BB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$24,$01,$02,$00,$23
        .BYTE <copticExplosion,>copticExplosion,<nullPtr,>nullPtr
        .BYTE <planet2Level20Data,>planet2Level20Data,<planet2Level20Data,>planet2Level20Data
        .BYTE $00,$00,$01,$01,$00,$04,$40,$00
planet3Level20Data 
        .BYTE $11,$BB,$BC,$00,$BB,$BC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$06,$24,$01,$02,$00,$23
        .BYTE <copticExplosion,>copticExplosion,<nullPtr,>nullPtr
        .BYTE <planet3Level20Data,>planet3Level20Data,<planet3Level20Data,>planet3Level20Data
        .BYTE $00,$00,$01,$01,$00,$04,$40,$00
planet4Level20Data
        .BYTE $10,$BC,$BD,$00,$BC,$BD,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FA,$24,$01,$02,$00,$23
        .BYTE <copticExplosion,>copticExplosion,<nullPtr,>nullPtr
        .BYTE <planet4Level20Data,>planet4Level20Data,<planet4Level20Data,>planet4Level20Data
        .BYTE $00,$00,$01,$01,$05,$05,$05,$05
planet5Level20Data
        .BYTE $02,$BD,$BE,$00,$BD,$BE,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$0C,$24,$01,$02,$00,$23
        .BYTE <copticExplosion,>copticExplosion,<nullPtr,>nullPtr
        .BYTE <planet5Level20Data,>planet5Level20Data,<planet5Level20Data,>planet5Level20Data
        .BYTE $00,$00,$01,$01,$00,$04,$40,$00
planet5Level2Data
        .BYTE $11,MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$25,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet5Level2Data,>planet5Level2Data
        .BYTE <planet5Level2Explosion,>planet5Level2Explosion,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$04,$18,$00
planet5Level2Explosion
        .BYTE $06,MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$23,$01,$01,$80,$23
        .BYTE <nullPtr,>nullPtr,<planet5Level2Data,>planet5Level2Data
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$02,$00,$00,$00,$00
planet3Level14Data
        .BYTE $08,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$F0
        .BYTE <f11B8,>f11B8,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA2A8,>fA2A8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$04,$20,$00
fA2A8
        .BYTE $07,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$04
        .BYTE <planet3Level14Data,>planet3Level14Data,$00,$00,$01,$00,$80,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA2A8,>fA2A8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
planet1Level3Data
        .BYTE $05,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$04,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet1Level3Data2ndStage,>planet1Level3Data2ndStage,$FA,$01,$01,$02,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$01,$00,$04,$20,$00
planet1Level3Data2ndStage
        .BYTE $04,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$02,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet1Level3Data3rdStage,>planet1Level3Data3rdStage,$01,$FF,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$01,$01,$00,$00,$00,$00
planet1Level3Data3rdStage
        .BYTE $06,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$06,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$33
        .BYTE <planet1Level3Data,>planet1Level3Data,$F8,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$01,$01,$00,$00,$00,$00
fA348
        .BYTE $03,$A7,$AB,$03,$A7,$AB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet2Level18Data,>planet2Level18Data,$80,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$02,$00,$00,$00,$00
planet2Level18Data
        .BYTE $10,$A7,$AB,$02,$A7,$AB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <fA348,>fA348,$00,$00,$01,$01,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$06,$00,$04,$20,$00
planet2Level19Data
        .BYTE $0E,$C1,$C8,$04,$D4,$DC,$0C,$C0
        .BYTE $A3,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$05,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet2Level19Data,>planet2Level19Data
        .BYTE <fA3E8,>fA3E8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$02,$00,$04,$38,$00
fA3C0
        .BYTE $0A,$C1,$C8,$04,$D4,$DC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FB,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<fA3C0,>fA3C0
        .BYTE <fA3E8,>fA3E8,<planet2Level19Data,>planet2Level19Data
        .BYTE $00,$00,$04,$02,$00,$00,$00,$00
fA3E8
        .BYTE $10,$C1,$C8,$01,$D4,$DC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <spinningRings,>spinningRings,$00,$23,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
planet2Level12Data
        .BYTE $0C,$3E,$40,$01,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$03,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet2Level1Data,>planet2Level1Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$30,$00,$04,$30,$00
planet3Level15Data
        .BYTE $10,$3B,$3E,$01,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA460,>fA460,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$02,$00,$04,$28,$00
fA460
        .BYTE $06,$3B,$3E,$07,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<spinningRings,>spinningRings
        .BYTE <nullPtr,>nullPtr,<fA460,>fA460
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
planet3Level18Data
        .BYTE $06,FLYING_SAUCER,FLYING_SAUCER+$03,$01,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA4B0,>fA4B0,<fA4B0,>fA4B0
        .BYTE $00,$00,$04,$02,$00,$04,$20,$00
fA4B0
        .BYTE $06,FLYING_SAUCER,FLYING_SAUCER+$03,$01,FLYING_SAUCER,FLYING_SAUCER+$03,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$22,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<spinningRings,>spinningRings
        .BYTE <fA4B0,>fA4B0,<fA4B0,>fA4B0
        .BYTE $00,$00,$00,$05,$00,$00,$00,$00
planet4Level12Data
        .BYTE $00,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA500,>fA500,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$04,$30,$00
fA500
        .BYTE $10,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <f1878,>f1878,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<f1878,>f1878
        .BYTE <fA500,>fA500,<fA500,>fA500
        .BYTE $00,$00,$00,$02,$00,$00,$00,$00
planet2Level13Data
        .BYTE $08,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA550,>fA550,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$01,$00,$04,$40,$00
fA550
        .BYTE $07,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <spinningRings,>spinningRings,$00,$00,$01,$01,$80,$80
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
planet2Level2Data
        .BYTE $04,$B0,$B2,$05,$B0,$B2,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$E9,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$04,$18,$00
planet2Level3Data
        .BYTE $06,$B2,$B4,$05,$B2,$B4,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$17,$00,$01,$03,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$04,$18,$00
planet2Level14Data
        .BYTE $04,$B0,$B2,$05,$B0,$B2,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$E9,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA618,>fA618,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$04,$18,$00
planet2Level17Data
        .BYTE $06,$B2,$B4,$05,$B2,$B4,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$17,$00,$01,$03,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA640,>fA640,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$04,$18,$00
fA618
        .BYTE $11,$B0,$B2,$01,$B0,$B2,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <spinningRings,>spinningRings,$E7,$00,$01,$02,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
fA640
        .BYTE $11,$B0,$B2,$01,$B0,$B2,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <spinningRings,>spinningRings,$19,$00,$01,$02,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
planet4Level18Data
        .BYTE $10,$B4,$B8,$05,$F9,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$24,$02,$03,$01,$23
        .BYTE <nullPtr,>nullPtr,<planet4Level18Data,>planet4Level18Data
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$02,$00,$04,$20,$00
planet5Level7Data
        .BYTE $10,$AE,$B0,$01,$AE,$B0,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FE,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA6B8,>fA6B8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$03,$00,$04,$20,$00
fA6B8
        .BYTE $10,$AC,$AE,$01,$AC,$AE,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$02,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet5Level7Data,>planet5Level7Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$03,$00,$00,$00,$00
planet1Level16Data
        .BYTE $05,$2A,$2B,$00,$2A,$2B,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$02,$00,$01,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet4Level19Data,>planet4Level19Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$06,$00,$04,$18,$00
planet1Level2Data
        .BYTE $06,$3B,$3E,$01,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$24,$02,$01,$01,$23
        .BYTE <nullPtr,>nullPtr,<planet1Level2Data,>planet1Level2Data
        .BYTE <spinningRings,>spinningRings,<planet1Level2Data,>planet1Level2Data
        .BYTE $00,$00,$01,$01,$00,$04,$20,$00
planet4Level16Data
        .BYTE $07,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$F8,$00,$01,$04,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA758,>fA758,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$04,$30,$00
fA758
        .BYTE $10,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$01,$00,$00,$00,$00
planet5Level13Data
        .BYTE $11,$3E,$40,$01,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA7A8,>fA7A8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$20,$00,$04,$C0,$00
fA7A8
        .BYTE $06,$3E,$40,$01,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$03
        .BYTE <planet5Level13Data,>planet5Level13Data,$00,$00,$01,$00,$80,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet5Level13Data,>planet5Level13Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$01,$00,$00,$00,$00
planet4Level11Data
        .BYTE $0E,MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$E0
        .BYTE <fA7F8,>fA7F8,$00,$00,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA7F8,>fA7F8,<fA7F8,>fA7F8
        .BYTE $00,$00,$02,$02,$00,$04,$20,$00
fA7F8
        .BYTE $10,MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM,$00,$2E,$2F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$14
        .BYTE <spinningRings,>spinningRings,$00,$24,$02,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
planet5Level14Data
        .BYTE $08,$30,$31,$00,$30,$31,$06,$48
        .BYTE $A8,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$03,$01,$00,$04,$60,$00
fA848
        .BYTE $09,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$03,$01,$00,$00,$00,$00
planet5Level15Data
        .BYTE $10,$3B,$3E,$04,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA898,>fA898,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$06,$10,$00,$04,$10,$00
fA898
        .BYTE $00,$3B,$3E,$01,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$01,$02,$80,$23
        .BYTE <nullPtr,>nullPtr,<spinningRings,>spinningRings
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet2Level15Data
        .BYTE $08,$BE,$BF,$00,$BE,$BF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$03,$22,$01,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet2Level15Data,>planet2Level15Data
        .BYTE <fA8E8,>fA8E8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$02,$00,$04,$20,$00
fA8E8
        .BYTE $08,$BE,$BF,$00,$BE,$BF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <spinningRings,>spinningRings,$00,$24,$02,$02,$01,$23
        .BYTE $00,$00,$00,$00,$00,$00,$C8
fA907   .BYTE $18
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet3Level16Data
        .BYTE $10,$B8,$B9,$00,$B8,$B9,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$C0
        .BYTE <planet2Level5Data,>planet2Level5Data,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet3Level16Data,>planet3Level16Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$04,$10,$00
planet1Level18Data
        .BYTE $05,$D3,$D4,$00,$D3,$D4,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$06,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA970,>fA970,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$03,$00,$04,$20,$00
fA970
        .BYTE $10,$D3,$D4,$00,$D3,$D4,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet2Level19Data,>planet2Level19Data,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <fA970,>fA970,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
planet1Level19Data
        .BYTE $04,$AB,$AC,$00,$AB,$AC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet1Level19Data,>planet1Level19Data,$00,$00,$02,$02,$80,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet5Level6Data,>planet5Level6Data,<planet5Level6Data,>planet5Level6Data
        .BYTE $00,$00,$00,$04,$00,$04,$20,$00
planet5Level8Data
        .BYTE $10,$21,$22,$01,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet5Level8Data,>planet5Level8Data
        .BYTE <f1800,>f1800,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$04,$30,$00
planet4Level13Data
        .BYTE $0D,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$03,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$F9,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet5Level5Data,>planet5Level5Data,<planet5Level5Data,>planet5Level5Data
        .BYTE $00,$00,$00,$0C,$00,$04,$40,$00
planet5Level17Data
        .BYTE $10,$3E,$40,$02,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$02,$22,$01,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet5Level17Data,>planet5Level17Data
        .BYTE <planet3Level8Data,>planet3Level8Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$04,$30,$00
planet2Level16Data
        .BYTE $10,$35,$37,$04,$38,$3A,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet1Level9Data,>planet1Level9Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$04,$30,$00
planet5Level18Data
        .BYTE $10,$27,$2A,$01,$27,$2A,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet5Level18Data,>planet5Level18Data,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1878,>f1878,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$04,$40,$00
planet3Level17Data
        .BYTE $08,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$03,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet5Level14Data,>planet5Level14Data,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0C,$00,$04,$30,$00
fAAB0
        .BYTE $10,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
