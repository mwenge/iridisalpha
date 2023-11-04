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
; See GetWaveDateForNewShip also.


attackWaveData
defaultExplosion
; Copied here from level_data2.asm. See defaultExplosion there.
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
        .BYTE <nullPtr,>nullPtr,$02,$08,$00,$04,$0C,$00
planet4Level19Additional
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LOZENGE,LOZENGE+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LOZENGE,LOZENGE+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level19Additional2ndWave,>planet4Level19Additional2ndWave
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet4Level19Additional2ndWave,>planet4Level19Additional2ndWave
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet4Level19Additional2ndWave,>planet4Level19Additional2ndWave
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level19Additional2ndWave
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SPINNING_RING1,SPINNING_RING4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SPINNING_RING1,SPINNING_RING4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet2Level7Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0F
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level7Data2ndStage,>planet2Level7Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level7Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $80
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level7Data,>planet2Level7Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
;f19B8
        .BYTE $01,$30,$31,$00,$30,$31,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$03
        .BYTE $50,$18,$80,$80,$01,$01,$00,$00
planet4Level4Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $03
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,MAGIC_MUSHROOM+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level4Data2ndStage,>planet4Level4Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level4Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level4Data,>planet4Level4Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level4Data,>planet4Level4Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

LITTLE_DART=$31
planet4Level3Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $60
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level2Data2ndStage,>planet4Level2Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $02
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level2Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level3Data,>planet4Level3Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level9Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE WINGBALL,WINGBALL+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE MONEY_BAG,MONEY_BAG2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $0C
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level9DataSecondStage,>planet1Level9DataSecondStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet1Level9DataSecondStage,>planet1Level9DataSecondStage
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level9DataSecondStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE WINGED_BALL3,WINGED_BALL3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE TITAN_ROCKET,TITAN_ROCKET + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $04
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level9Data,>planet1Level9Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
secondExplosionAnimation
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $04
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <nullPtr,>nullPtr
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level3Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level3Data2ndStage,>planet3Level3Data2ndStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level3Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FD
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level3Data3rdStage,>planet3Level3Data3rdStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level3Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $0C
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level3Data,>planet3Level3Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level8Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $60
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $20
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level8Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data3rdStage,>planet2Level8Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $01
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $20
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet2Level8Data,>planet2Level8Data
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level8Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FE
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $20
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet2Level8Data,>planet2Level8Data
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level9Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY1,LAND_GILBY7 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET1,LAND_GILBY_LOWERPLANET8 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level9Data,>planet2Level9Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <gilbyTakingOffAsExplosion,>gilbyTakingOffAsExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
gilbyTakingOffAsExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_TAKING_OFF1,GILBY_TAKING_OFF4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_TAKING_OFF_LOWERPLANET1,GILBY_TAKING_OFF_LOWERPLANET4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $08
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <gilbyLookingLeft,>gilbyLookingLeft
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
gilbyLookingLeft
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_LEFT,GILBY_AIRBORNE_LEFT + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_LEFT,GILBY_AIRBORNE_LEFT + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level4Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $04
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <gilbyLookingLeft,>gilbyLookingLeft
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $08
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level5Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALL_BALL1,SMALL_BALL3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALL_BALL1,SMALL_BALL3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <stickyGlobeExplosion,>stickyGlobeExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level5Data,>planet3Level5Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
stickyGlobeExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALL_BALL2,SMALL_BALL2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALL_BALL2,SMALL_BALL2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level6Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY1,LAND_GILBY7 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET1,LAND_GILBY_LOWERPLANET8 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $04
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet3Level6Additional,>planet3Level6Additional
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F9
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $07
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level6Data,>planet3Level6Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level9Data,>planet2Level9Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level6Additional
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0F
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLDOT,SMALLDOT+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLDOT,SMALLDOT+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level17Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level17Data2ndStage,>planet1Level17Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <gilbyLookingLeft,>gilbyLookingLeft
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $05
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level17Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $0C
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $04
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level17Data3rdStage,>planet1Level17Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level17Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level17Data,>planet1Level17Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level17Data,>planet1Level17Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level6Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level6Data2ndStage,>planet4Level6Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level6Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FB
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level6Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BIRD1,BIRD4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BIRD1,BIRD4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $03
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level6Data2ndStage,>planet1Level6Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings2ndType,>spinningRings2ndType
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level6Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BIRD1,BIRD4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BIRD1,BIRD4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $50
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level6Data,>planet1Level6Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet1Level6Data,>planet1Level6Data
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level6Data,>planet1Level6Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings2ndType,>spinningRings2ndType
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
spinningRings2ndType
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SPINNING_RING1,SPINNING_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SPINNING_RING1,SPINNING_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level10Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $80
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level10Data2ndStage,>planet1Level10Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level10Data,>planet1Level10Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level10Data2ndStage,>planet1Level10Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level10Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level2Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $50
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level2Data2ndStage,>planet3Level2Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $01
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $0C
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level2Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DART2,FLYING_DART3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DART2,FLYING_DART3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $08
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level2Data3rdStage,>planet3Level2Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level2Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DART3,FLYING_DART3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DART3,FLYING_DART3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $55
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level2Data,>planet3Level2Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $08
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $0C
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level8Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <bubbleExplosion,>bubbleExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
bubbleExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F0
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <bubbleExplosion2ndStage,>bubbleExplosion2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
bubbleExplosion2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $18
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $10
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level8Data2ndStage,>planet2Level8Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level5Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LOZENGE,LOZENGE + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LOZENGE,LOZENGE + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level5Data2ndStage,>planet4Level5Data2ndStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level5Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LOZENGE,LOZENGE + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LOZENGE,LOZENGE + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level5Data,>planet4Level5Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$83
*=$9B00
planet1Level15Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LLAMA,$00
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LLAMA,$00
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level15Data,>planet1Level15Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <teardropExplosion,>teardropExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
teardropExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <teardropExplosion,>teardropExplosion
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <spinningRings,>spinningRings
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $01
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level17Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CUMMING_COCK1,CUMMING_COCK4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <cummingCock,>cummingCock
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
cummingCock
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CUMMING_COCK1,CUMMING_COCK4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <cummingCock,>cummingCock
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level8Data2ndStage,>planet1Level8Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level8Data2ndStage,>planet1Level8Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level4Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $60
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $07
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level4Data2ndStage,>planet1Level4Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level4Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_FLOWCHART1,FLYING_FLOWCHART2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_FLOWCHART1,FLYING_FLOWCHART2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $70
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level4Data,>planet1Level4Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F9
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $07
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level5Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COMMA1,FLYING_COMMA2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COMMA1,FLYING_COMMA2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $05
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet5Level5Additional,>planet5Level5Additional
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level5Data2ndStage,>planet5Level5Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $07
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $03
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level5Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COMMA1,FLYING_COMMA2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COMMA1,FLYING_COMMA2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $05
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet5Level5Additional,>planet5Level5Additional
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level5Data,>planet5Level5Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $08
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FD
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level5Additional
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FE
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level10Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $0A
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level10Data2ndStage,>planet3Level10Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level10Data,>planet3Level10Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level10Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $18
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level10Data,>planet3Level10Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level10Data,>planet3Level10Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level10Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK_RIGHT1,FLYING_COCK_RIGHT2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK_RIGHT1,FLYING_COCK_RIGHT2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level10Data2ndStage,>planet4Level10Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $0A
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level10Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level10Data,>planet4Level10Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FE
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level10Data,>planet4Level10Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level6Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F4
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <fighterShipAsExplosion,>fighterShipAsExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
fighterShipAsExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $01
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet3Level10Data,>planet3Level10Data
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $02
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <nullPtr,>nullPtr
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level15Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinnerAsExplosion,>spinnerAsExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $28
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
spinnerAsExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $01
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level10Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE1 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE1 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <flowchartArrowAsExplosion,>flowchartArrowAsExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
flowchartArrowAsExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $21
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level10Data,>planet5Level10Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $60
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level13Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKER_SHIP1,LICKERSHIP2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV1,LICKERSHIP_INV2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <lickerShipAsExplosion,>lickerShipAsExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
lickerShipAsExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKER_SHIP1,LICKERSHIP3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV1,LICKERSHIP_INV3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level13Data3rdStage,>planet3Level13Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level13Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKER_SHIP1,LICKERSHIP2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV1,LICKERSHIP_INV2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $08
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level13Data,>planet3Level13Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level11Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $10
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet2Level11Data2ndStage,>planet2Level11Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level11Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level10Data,>planet4Level10Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <nullPtr,>nullPtr
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level19Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COMMA1,FLYING_COMMA2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COMMA1,FLYING_COMMA2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level19Data2ndStage,>planet3Level19Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $05
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level17Data,>planet4Level17Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet4Level17Data,>planet4Level17Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level19Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LLAMA,$00
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LLAMA,$00
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level19Data3rdStage,>planet3Level19Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level13Data,>planet1Level13Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level13Data,>planet1Level13Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level19Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOLAS1,BOLAS3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOLAS1,BOLAS3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level19Data,>planet3Level19Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level4Data,>planet1Level4Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level4Data,>planet1Level4Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level1Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $60
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level1Data2ndStage,>planet5Level1Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level1Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level1Data,>planet5Level1Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $80
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level1Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level1Data2ndStage,>planet4Level1Data2ndStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level1Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FA
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level1Data,>planet4Level1Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level1Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FC,$FF
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FC,$FF
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level1Data,>planet3Level1Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE $50,$18
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
pieceOfPlanetData=*+$01
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $01
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $53
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $41
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $56
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $2A
planet2Level1Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $55
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$04
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $08
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level1Data,>planet2Level1Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $10
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <pinAsExplosion,>pinAsExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
pinAsExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LITTLE_DART,LITTLE_DART+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $1C
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level1Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level1Data2ndStage,>planet1Level1Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $01
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level1Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level1Data,>planet1Level1Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

FLAG_BAR=$BE
planet1Level7Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $50
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level7Data2ndStage,>planet1Level7Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $07
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level7Data2ndStage,>planet1Level7Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $28
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level7Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level7Data3rdStage,>planet1Level7Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $05
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $80
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level7Data3rdStage,>planet1Level7Data3rdStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level7Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level7Data,>planet1Level7Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <barExplosion,>barExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
barExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR+$01,FLAG_BAR+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR+$01,FLAG_BAR+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

copticExplosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <spinningRings,>spinningRings
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level20Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE COPTIC_CROSS,COPTIC_CROSS + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE COPTIC_CROSS,COPTIC_CROSS + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level20Data,>planet1Level20Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level20Data,>planet1Level20Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $40
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level20Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE EYE_OF_HORUS,EYE_OF_HORUS + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE EYE_OF_HORUS,EYE_OF_HORUS + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level20Data,>planet2Level20Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet2Level20Data,>planet2Level20Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $40
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level20Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE PSI,PSI + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE PSI,PSI + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level20Data,>planet3Level20Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level20Data,>planet3Level20Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $40
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level20Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BULLHEAD,BULLHEAD + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BULLHEAD,BULLHEAD + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FA
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level20Data,>planet4Level20Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet4Level20Data,>planet4Level20Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $05
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $05
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $05
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $05
planet5Level20Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE ATARI_ST,ATARI_ST + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE ATARI_ST,ATARI_ST + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $0C
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <copticExplosion,>copticExplosion
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level20Data,>planet5Level20Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet5Level20Data,>planet5Level20Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $40
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level2Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level2Data,>planet5Level2Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level2Explosion,>planet5Level2Explosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level2Explosion
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level2Data,>planet5Level2Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level14Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $F0
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level12Data,>planet1Level12Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level14Data2ndStage,>planet3Level14Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level14Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $04
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level14Data,>planet3Level14Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level14Data2ndStage,>planet3Level14Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level3Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level3Data2ndStage,>planet1Level3Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FA
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $01
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level3Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level3Data3rdStage,>planet1Level3Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $01
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $FF
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level3Data3rdStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $33
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level3Data,>planet1Level3Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level18Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $03
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level18Data,>planet2Level18Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level18Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOLAS1,BOLAS4 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $08
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level18Data2ndStage,>planet2Level18Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level19Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY1,LAND_GILBY7 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET1,LAND_GILBY_LOWERPLANET8 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $0C
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <landGilbyAsEnemy,>landGilbyAsEnemy
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $05
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level19Data,>planet2Level19Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level19Data2ndStage,>planet2Level19Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $38
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
landGilbyAsEnemy
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY1,LAND_GILBY8
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET1,LAND_GILBY_LOWERPLANET9
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FB
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <landGilbyAsEnemy,>landGilbyAsEnemy
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level19Data2ndStage,>planet2Level19Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet2Level19Data,>planet2Level19Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level19Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY1,LAND_GILBY7 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET1,LAND_GILBY_LOWERPLANET8 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $18
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level12Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level1Data,>planet2Level1Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE CAMEL
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level15Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level15Data2ndStage,>planet3Level15Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $28
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level15Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $07
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level15Data2ndStage,>planet3Level15Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level18Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $04
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level18Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_SAUCER1,FLYING_SAUCER1+$03
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level18Data2ndStage,>planet3Level18Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level12Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level12Data2ndStage,>planet4Level12Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level12Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $08
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level12Data2ndStage,>planet4Level12Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet4Level12Data2ndStage,>planet4Level12Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level13Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LLAMA,$00
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LLAMA,$00
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level13Data2ndStage,>planet2Level13Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $40
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level13Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LLAMA,$00
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LLAMA,$00
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $80
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level2Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $E9
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level3Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK_RIGHT1,FLYING_COCK_RIGHT2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK_RIGHT1,FLYING_COCK_RIGHT2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $17
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level14Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $E9
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level14Data2ndStage,>planet2Level14Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level17Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK_RIGHT1,FLYING_COCK_RIGHT2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK_RIGHT1,FLYING_COCK_RIGHT2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $17
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level17Data2ndStage,>planet2Level17Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level14Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $18
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $E7
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level17Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_COCK1,FLYING_COCK2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $18
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $19
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level18Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CUMMING_COCK1,CUMMING_COCK4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV1,LICKERSHIP_INV2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level18Data,>planet4Level18Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level7Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_FLOWCHART1,FLYING_FLOWCHART2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_FLOWCHART1,FLYING_FLOWCHART2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FE
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level7Data2ndStage,>planet5Level7Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level7Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_TRIANGLE1,FLYING_TRIANGLE2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $02
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level7Data,>planet5Level7Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level16Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE QBERT_SQUARES,QBERT_SQUARES + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE QBERT_SQUARES,QBERT_SQUARES + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level19Data,>planet4Level19Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level2Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet1Level2Data,>planet1Level2Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level2Data,>planet1Level2Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level16Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F8
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $04
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level16Data2ndStage,>planet4Level16Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level16Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level13Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level13Data2ndStage,>planet5Level13Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $20
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $C0
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level13Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $03
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level13Data,>planet5Level13Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level13Data,>planet5Level13Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $01
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level11Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $E0
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level11Data2ndStage,>planet4Level11Data2ndStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet4Level11Data2ndStage,>planet4Level11Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet4Level11Data2ndStage,>planet4Level11Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $02
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level11Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE INV_MAGIC_MUSHROOM,INV_MAGIC_MUSHROOM + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $14
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level14Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $06
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <llamaWaveData,>llamaWaveData
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $60
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
llamaWaveData
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LLAMA,$00
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LLAMA,$00
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $03
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level15Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level15Data2ndStage,>planet5Level15Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $06
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level15Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <spinningRings,>spinningRings
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <nullPtr,>nullPtr
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level15Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level15Data,>planet2Level15Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet2Level15Data2ndStage,>planet2Level15Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $03
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level15Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLAG_BAR,FLAG_BAR+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) 
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave 
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used). 
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        ; fA907 used to live here (at $18).
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

        ; fA910
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00

planet3Level16Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STRANGE_SYMBOL,STRANGE_SYMBOL+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $C0
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level5Data,>planet2Level5Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level16Data,>planet3Level16Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet1Level18Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $06
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level18Data2ndStage,>planet1Level18Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level18Data2ndStage
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level19Data,>planet2Level19Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level18Data2ndStage,>planet1Level18Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet1Level19Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE STARSHIP,STARSHIP+$01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level19Data,>planet1Level19Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $80
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level6Data,>planet5Level6Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet5Level6Data,>planet5Level6Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet5Level8Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BALLOON,BALLOON+$01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $04
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level8Data,>planet5Level8Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level5Data,>planet1Level5Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level13Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0D
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DOT1,FLYING_DOT1+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $F9
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level5Data,>planet5Level5Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet5Level5Data,>planet5Level5Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $40
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet5Level17Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE+$02
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $02
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $22
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level17Data,>planet5Level17Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level8Data,>planet3Level8Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

WINGBALL=$35
planet2Level16Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE WINGBALL,WINGBALL+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE MONEY_BAG,MONEY_BAG2 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level9Data,>planet1Level9Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

LITTLE_OTHER_EYEBALL=$27
planet5Level18Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LITTLE_OTHER_EYEBALL,LITTLE_OTHER_EYEBALL+$03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALL_BALL1,SMALL_BALL3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level18Data,>planet5Level18Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $01
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $40
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level17Data
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LLAMA,$00
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LLAMA,$00
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $00
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <nullPtr,>nullPtr
        ; Byte 9 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?)
        ; Byte 10 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?
        .BYTE <nullPtr,>nullPtr
        ; Byte 11 (Index $0B): some kind of rate limiting for attack wave
        .BYTE $00
        ; Byte 12 (Index $0C): Lo Ptr for a stage in wave data (never used).
        ; Byte 13 (Index $0D): Hi Ptr for a stage in wave data (never used).
        .BYTE <nullPtr,>nullPtr
        ; Byte 14 (Index $0E): Unused, see GetNewShipDataFromDataStore
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $03
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $00
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $01
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $01
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level14Data,>planet5Level14Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Unused, see GetNewShipDataFromDataStore.
        .BYTE $00
        ; Byte 34 (Index $22)): Does destroying this enemy increase the gilby's energy?.
        .BYTE $00
        ; Byte 35: (Index $23): Does colliding with this enemy decrease the gilby's energy?
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
fAAB0
        .BYTE $10,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$10

; vim: tabstop=2 shiftwidth=2 expandtab


