*=$18C8
; This is the reverse-engineered source code for the game 'Iridis Alpha'
; written by Jeff Minter in 1986.
;
; The code in this file was created by disassembling a binary of the game released into
; the public domain by Jeff Minter in 2019.
;
; The original code from which this source is derived is the copyright of Jeff Minter.
;
; The original home of this file is at: https://github.com/mwenge/iridisalpha
;
; To the extent to which any copyright may apply to the act of disassembling and reconstructing
; the code from its binary, the author disclaims copyright to this source code.  In place of
; a legal notice, here is a blessing:
;
;    May you do good and not evil.
;    May you find forgiveness for yourself and forgive others.
;    May you share freely, never taking more than you give.
;
; This file contains most of the data describing the behaviour of each attack wave.
; For the rest see level_data2.asm.
;
; From Minter's development diary:
; "ACONT 
; This is the bit that I knew would take me ages to write and get glitch
; free, and the bit that is absolutely necessary to the functioning of the game.
; The module ACONT is essentially an interpreter for my own 'wave language',
; allowing me to describe, exactly, an attack wave in about 50 bytes of data. The
; waves for the first part of IRIDIS are in good rollicking shoot-'em-up style,
; and there have to be plenty of them. There are five planets and each planet is
; to have twenty levels associated with it. It's impractical to write separate
; bits of code for each wave; even with 64K you can run outta memory pretty fast
; that way, and it's not really necessary coz a lot of stuff would be duplicated.
; Hence ACONT.
; 
; You pass the interpreter data, that describes exactly stuff like: what each
; alien looks like, how many frames of animation it uses, speed of that
; animation, colour, velocities in X— and Y— directions, accelerations in X and
; Y, whether the alien should 'home in' on a target, and if so, what to home in
; on; whether an alien is subject to gravity, and if so, how strong is the
; gravity; what the alien should do if it hits top of screen, the ground, one of
; your bullets, or you; whether the alien can fire bullets, and if so, how
; frequently, and what types; how many points you get if you shoot it, and how
; much damage it does if it hits you; and a whole bunch more stuff like that. As
; you can imagine it was a fairly heavy routine to write and get debugged, but
; that's done now; took me about three weeks in all I'd say."
; 
; This data is loaded to currentShipWaveDataLoPtr/currentShipWaveDataHiPtr when it is used in the
; game.

; Sprite names. See sprites.asm and enemy_sprites.asm
MAGIC_MUSHROOM = $2D
INV_MAGIC_MUSHROOM = $2E
FLYING_SAUCER = $A0
LICKERSHIP_SEED = $A5
LITTLE_EYEBALL = $2F

attackWaveData
default2ndStage
; Copied here from level_data2.asm. See default2ndStage there.
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
        .BYTE $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
planet4Level19Data
; Copied here from level_data2.asm. See planet4Level19Data there.
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
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0F
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level7Data2ndStage,>planet2Level7Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
planet2Level7Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $80
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level7Data,>planet2Level7Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
;f19B8
        .BYTE $01,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$03
        .BYTE $50,$18,$80,$80,$01,$01,$00,$00
planet4Level4Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $03
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,MAGIC_MUSHROOM+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level4Data2ndStage,>planet4Level4Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet4Level4Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level4Data,>planet4Level4Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level4Data,>planet4Level4Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00

LITTLE_DART=$31
planet4Level3Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $60
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level2Data2ndStage,>planet4Level2Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $02
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet4Level2Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level3Data,>planet4Level3Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level9Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE WINGBALL,WINGBALL+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $38,$3A
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $0C
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level9DataSecondStage,>planet1Level9DataSecondStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet1Level9DataSecondStage,>planet1Level9DataSecondStage
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet1Level9DataSecondStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $37,$38
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3A,$3B
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $04
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level9Data,>planet1Level9Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
secondExplosionAnimation
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $30,$31
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $04
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE $00,$00
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE $00,$00
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE $00,$00
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE $00,$00
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level3Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level3Data2ndStage,>planet3Level3Data2ndStage
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
planet3Level3Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FD
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level3Data3rdStage,>planet3Level3Data3rdStage
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level3Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $0C
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level3Data,>planet3Level3Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level8Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $60
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $20
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
planet2Level8Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data3rdStage,>planet2Level8Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $01
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $20
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet2Level8Data,>planet2Level8Data
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level8Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FE
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $20
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet2Level8Data,>planet2Level8Data
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level9Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $C1,$C8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $D4,$DC
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level9Data,>planet2Level9Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <gilbyTakingOffAsExplosion,>gilbyTakingOffAsExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
gilbyTakingOffAsExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $CC,$D0
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $DF,$E3
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $08
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <gilbyLookingLeft,>gilbyLookingLeft
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
gilbyLookingLeft
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $D1,$D2
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $D1,$D2
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level4Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $04
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $28,$1C
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $08
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet3Level5Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $27,$2A
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $27,$2A
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <stickyGlobeExplosion,>stickyGlobeExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level5Data,>planet3Level5Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
stickyGlobeExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $28,$29
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $28,$29
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level6Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $C1,$C8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $D4,$DC
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $04
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $F0,$1C
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F9
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $07
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level6Data,>planet3Level6Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level9Data,>planet2Level9Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
f1CF0
        .BYTE $0F,$E7,$E8,$00,$E7,$E8,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$FC,$23,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
planet1Level17Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level17Data2ndStage,>planet1Level17Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <gilbyLookingLeft,>gilbyLookingLeft
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $05
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet1Level17Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $0C
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $04
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level17Data3rdStage,>planet1Level17Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level17Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level17Data,>planet1Level17Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level17Data,>planet1Level17Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level6Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level6Data2ndStage,>planet4Level6Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet4Level6Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FB
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level6Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $23,$27
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $23,$27
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $03
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level6Data2ndStage,>planet1Level6Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings2ndType,>spinningRings2ndType
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
planet1Level6Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $23,$27
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $23,$27
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $50
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level6Data,>planet1Level6Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet1Level6Data,>planet1Level6Data
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level6Data,>planet1Level6Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings2ndType,>spinningRings2ndType
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
spinningRings2ndType
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $E8,$EB
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $E8,$EB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level10Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $80
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level10Data2ndStage,>planet1Level10Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level10Data,>planet1Level10Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level10Data2ndStage,>planet1Level10Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet1Level10Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level2Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $50
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level2Data2ndStage,>planet3Level2Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $01
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $0C
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet3Level2Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $32,$34
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $32,$34
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $08
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level2Data3rdStage,>planet3Level2Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level2Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $33,$34
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $33,$34
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $55
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level2Data,>planet3Level2Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $08
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $0C
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level8Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <bubbleExplosion,>bubbleExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
bubbleExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F0
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <bubbleExplosion2ndStage,>bubbleExplosion2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
bubbleExplosion2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $18
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $10
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level5Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $2C,$2D
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2C,$2D
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level5Data2ndStage,>planet4Level5Data2ndStage
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet4Level5Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $2C,$2D
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2C,$2D
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level5Data,>planet4Level5Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $10
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00

        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$83
*= $9B00
planet1Level15Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FF,$00
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FF,$00
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level15Data,>planet1Level15Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <teardropExplosion,>teardropExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
teardropExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FC,$FF
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FC,$FF
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <teardropExplosion,>teardropExplosion
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $01
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level17Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B4,$B8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A7,$AB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <cummingCock,>cummingCock
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
cummingCock
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B4,$B8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A7,$AB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <cummingCock,>cummingCock
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level8Data2ndStage,>planet1Level8Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet1Level8Data2ndStage,>planet1Level8Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level4Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $AC,$AE
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $AC,$AE
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $60
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $07
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet1Level4Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $AE,$B0
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $AE,$B0
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $70
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level4Data,>planet1Level4Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F9
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $07
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet5Level5Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A3,$A5
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A3,$A5
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $05
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $40,$9C
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $30
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level5Data2ndStage,>planet5Level5Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $07
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $03
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet5Level5Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A3,$A5
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A3,$A5
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $05
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $40,$9C
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $30
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level5Data,>planet5Level5Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $08
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FD
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
f9C40
        .BYTE $07,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$03,LICKERSHIP_SEED,LICKERSHIP_SEED+$02,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$FE,$00,$01,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
planet3Level10Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $0A
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level10Data2ndStage,>planet3Level10Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level10Data,>planet3Level10Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet3Level10Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $18
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level10Data,>planet3Level10Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level10Data,>planet3Level10Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level10Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B2,$B4
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B2,$B4
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level10Data2ndStage,>planet4Level10Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $0A
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet4Level10Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B0,$B2
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B0,$B2
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $30
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level10Data,>planet4Level10Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FE
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level10Data,>planet4Level10Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet5Level6Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F4
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <fighterShipAsExplosion,>fighterShipAsExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
fighterShipAsExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $01
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $68,$9C
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $02
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level15Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A7,$AB
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A7,$AB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinnerAsExplosion,>spinnerAsExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$28,$00
spinnerAsExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $01
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A7,$AB
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A7,$AB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level10Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $AC,$AD
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $AC,$AD
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <flowchartArrowAsExplosion,>flowchartArrowAsExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
flowchartArrowAsExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $AC,$AE
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $AC,$AE
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $21
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level10Data,>planet5Level10Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $60
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level13Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F6,$F8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $F9,$FB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <lickerShipAsExplosion,>lickerShipAsExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
lickerShipAsExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F6,$F9
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $F9,$FC
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level13Data3rdStage,>planet3Level13Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level13Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F6,$F8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $F9,$FB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $08
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level13Data,>planet3Level13Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level11Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $10
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet2Level11Data2ndStage,>planet2Level11Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
planet2Level11Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $30
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level10Data,>planet4Level10Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level19Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A3,$A5
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A3,$A5
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level19Data2ndStage,>planet3Level19Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $05
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level17Data,>planet4Level17Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet4Level17Data,>planet4Level17Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet3Level19Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FF,$00
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FF,$00
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level19Data3rdStage,>planet3Level19Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level13Data,>planet1Level13Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet1Level13Data,>planet1Level13Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level19Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A7,$AA
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A7,$AA
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level19Data,>planet3Level19Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level4Data,>planet1Level4Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet1Level4Data,>planet1Level4Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet5Level1Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $60
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level1Data2ndStage,>planet5Level1Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet5Level1Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level1Data,>planet5Level1Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level1Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level1Data2ndStage,>planet4Level1Data2ndStage
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet4Level1Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FA
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level1Data,>planet4Level1Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level1Data
        .BYTE $10,$FC,$FF,$02,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <planet3Level1Data,>planet3Level1Data,$00,$00,$02,$02,$01,$01
        .BYTE $00,$00,$00,$00,$50,$18,$C8
pieceOfPlanetData
        .BYTE $18
        .BYTE $00,$00,$01,$01,$53,$41,$56,$2A
planet2Level1Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $55
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $08
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level1Data,>planet2Level1Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $10
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <pinAsExplosion,>pinAsExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
pinAsExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $1C
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level1Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level1Data2ndStage,>planet1Level1Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $01
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet1Level1Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $40
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level1Data,>planet1Level1Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00

FLAG_BAR=$BE
planet1Level7Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $50
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level7Data2ndStage,>planet1Level7Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $07
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level7Data2ndStage,>planet1Level7Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$28,$00
planet1Level7Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level7Data3rdStage,>planet1Level7Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $05
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level7Data3rdStage,>planet1Level7Data3rdStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level7Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level7Data,>planet1Level7Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <barExplosion,>barExplosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
barExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR+$01,FLAG_BAR+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR+$01,FLAG_BAR+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00

STRANGE_SYMBOL=$B8
copticExplosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level20Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B9,$BA
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B9,$BA
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level20Data,>planet1Level20Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet1Level20Data,>planet1Level20Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$40,$00
planet2Level20Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $BA,$BB
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $BA,$BB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level20Data,>planet2Level20Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet2Level20Data,>planet2Level20Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$40,$00
planet3Level20Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $BB,$BC
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $BB,$BC
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level20Data,>planet3Level20Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level20Data,>planet3Level20Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$40,$00
planet4Level20Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $BC,$BD
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $BC,$BD
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FA
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level20Data,>planet4Level20Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet4Level20Data,>planet4Level20Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $05
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $05,$05,$05
planet5Level20Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $BD,$BE
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $BD,$BE
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $0C
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level20Data,>planet5Level20Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet5Level20Data,>planet5Level20Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$40,$00
planet5Level2Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level2Data,>planet5Level2Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level2Explosion,>planet5Level2Explosion
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet5Level2Explosion
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level2Data,>planet5Level2Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level14Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $30,$31
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $F0
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level12Data,>planet1Level12Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level14Data2ndStage,>planet3Level14Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet3Level14Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $30,$31
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $04
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level14Data,>planet3Level14Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level14Data2ndStage,>planet3Level14Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level3Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $30
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level3Data2ndStage,>planet1Level3Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FA
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $01
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet1Level3Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level3Data3rdStage,>planet1Level3Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $01
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level3Data3rdStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $33
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level3Data,>planet1Level3Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level18Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $03
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A7,$AB
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A7,$AB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $30
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level18Data,>planet2Level18Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level18Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $A7,$AB
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $A7,$AB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $08
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level18Data2ndStage,>planet2Level18Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet2Level19Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $C1,$C8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $D4,$DC
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $0C
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $C0,$A3
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $05
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level19Data,>planet2Level19Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level19Data2ndStage,>planet2Level19Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$38,$00
fA3C0
        .BYTE $0A,$C1,$C8,$04,$D4,$DC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FB,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<fA3C0,>fA3C0
        .BYTE <planet2Level19Data2ndStage,>planet2Level19Data2ndStage,<planet2Level19Data,>planet2Level19Data
        .BYTE $00,$00,$04,$02,$00,$00,$00,$00
planet2Level19Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $C1,$C8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $D4,$DC
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $18
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level12Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level1Data,>planet2Level1Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $30
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$30,$00
planet3Level15Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level15Data2ndStage,>planet3Level15Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$28,$00
planet3Level15Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $07
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level15Data2ndStage,>planet3Level15Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level18Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet3Level18Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level12Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level12Data2ndStage,>planet4Level12Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$30,$00
planet4Level12Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $08
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level12Data2ndStage,>planet4Level12Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet4Level12Data2ndStage,>planet4Level12Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level13Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FF,$00
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FF,$00
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level13Data2ndStage,>planet2Level13Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$40,$00
planet2Level13Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FF,$00
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FF,$00
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $80
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level2Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B0,$B2
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B0,$B2
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $E9
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet2Level3Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B2,$B4
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B2,$B4
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $17
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet2Level14Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B0,$B2
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B0,$B2
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $E9
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level14Data2ndStage,>planet2Level14Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet2Level17Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B2,$B4
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B2,$B4
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $17
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level17Data2ndStage,>planet2Level17Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet2Level14Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B0,$B2
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B0,$B2
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $18
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $E7
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level17Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B0,$B2
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $B0,$B2
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $18
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $19
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level18Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $B4,$B8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $F9,$FB
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level18Data,>planet4Level18Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet5Level7Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $AE,$B0
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $AE,$B0
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FE
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level7Data2ndStage,>planet5Level7Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet5Level7Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $AC,$AE
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $AC,$AE
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $02
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level7Data,>planet5Level7Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level16Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $2A,$2B
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2A,$2B
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level19Data,>planet4Level19Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $06
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet1Level2Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level2Data,>planet1Level2Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet1Level2Data,>planet1Level2Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet4Level16Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $30,$31
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $04
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level16Data2ndStage,>planet4Level16Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$30,$00
planet4Level16Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $30,$31
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet5Level13Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level13Data2ndStage,>planet5Level13Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $20
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$C0,$00
planet5Level13Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $03
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level13Data,>planet5Level13Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level13Data,>planet5Level13Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet4Level11Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $E0
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level11Data2ndStage,>planet4Level11Data2ndStage
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level11Data2ndStage,>planet4Level11Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet4Level11Data2ndStage,>planet4Level11Data2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet4Level11Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $2E,$2F
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $14
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet5Level14Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $30,$31
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $06
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $48,$A8
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$60,$00
fA848
        .BYTE $09,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$04,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$03,$01,$00,$00,$00,$00
planet5Level15Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level15Data2ndStage,>planet5Level15Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $06
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $10
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
planet5Level15Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $3B,$3E
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet2Level15Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level15Data,>planet2Level15Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level15Data2ndStage,>planet2Level15Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet2Level15Data2ndStage
        .BYTE $08,FLAG_BAR,FLAG_BAR+$01,$00,FLAG_BAR,FLAG_BAR+$01,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <spinningRings,>spinningRings,$00,$24,$02,$02,$01,$23
        .BYTE $00,$00,$00,$00,$00,$00,$C8
fA907   .BYTE $18
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet3Level16Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $C0
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level5Data,>planet2Level5Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level16Data,>planet3Level16Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $10
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00

planet1Level18Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level18Data2ndStage,>planet1Level18Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet1Level18Data2ndStage
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level19Data,>planet2Level19Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level18Data2ndStage,>planet1Level18Data2ndStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00

STARSHIP=$AB
planet1Level19Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level19Data,>planet1Level19Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level6Data,>planet5Level6Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet5Level6Data,>planet5Level6Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00

BALLOON=$21
planet5Level8Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BALLOON,BALLOON+$01
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $3B,$3E
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level8Data,>planet5Level8Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level5Data,>planet1Level5Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $10
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$30,$00
planet4Level13Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_SEED,LICKERSHIP_SEED+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $F9
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level5Data,>planet5Level5Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet5Level5Data,>planet5Level5Data
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$40,$00

BUBBLE=$3E
planet5Level17Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $02
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level17Data,>planet5Level17Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level8Data,>planet3Level8Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$30,$00

WINGBALL=$35
planet2Level16Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE WINGBALL,WINGBALL+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $38,$3A
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level9Data,>planet1Level9Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $10
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$30,$00

LITTLE_OTHER_EYEBALL=$27
planet5Level18Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_OTHER_EYEBALL,LITTLE_OTHER_EYEBALL+$03
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $27,$2A
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $30
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level18Data,>planet5Level18Data
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$40,$00
planet3Level17Data
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FF,$00
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FF,$00
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $00,$00
        ; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE $00,$00
        ; Byte 12 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE $00,$00
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 19 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet5Level14Data,>planet5Level14Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $0C
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$30,$00
fAAB0
        .BYTE $10,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10

; vim: tabstop=2 shiftwidth=2 expandtab
