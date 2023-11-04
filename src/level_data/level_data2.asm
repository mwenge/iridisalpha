; Level data.
; $EFF0
; Copied to $1000 by SwapTitleScreenDataAndSpriteLevelData
.include "../constants.asm"
nullPtr = $0000
planet1Level9DataSecondStage = $1A98
secondExplosionAnimation = $1AC0
planet1Level10Data = $1E58
planet4Level19Additional = $1918

planet2Level5Data = $1000
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKER_SHIP1,LICKERSHIP2
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV1,LICKERSHIP_INV2
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level5Data2ndStage,>planet2Level5Data2ndStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level5Data3rdStage,>planet2Level5Data3rdStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet2Level5Data2ndStage,>planet2Level5Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet2Level5Data2ndStage = $1028
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP2,LICKERSHIP2 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV2,LICKERSHIP_INV2 + $01
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
        .BYTE $0A
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
        .BYTE <planet2Level5Data3rdStage,>planet2Level5Data3rdStage
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
        .BYTE $0C
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet2Level5Data3rdStage = $1050
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP3,LICKERSHIP3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV3,LICKERSHIP_INV3 + $01
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
        .BYTE <defaultExplosion,>defaultExplosion
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
planet3Level7Data = $1078
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKER_SHIP1,LICKERSHIP3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $07
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
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
        .BYTE $02
        ; Byte 22 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $00
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet3Level7Data2ndStage,>planet3Level7Data2ndStage
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $01
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level7Data2ndStage = $10A0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKER_SHIP1,LICKERSHIP3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $07
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
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
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level7Data,>planet3Level7Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level7Data,>planet3Level7Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet3Level7Data,>planet3Level7Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level6Data = $10C8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SPINNING_RING1,SPINNING_RING1 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SPINNING_RING1,SPINNING_RING1 + $01
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
        .BYTE $07
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
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
        .BYTE <planet2Level6Data2ndStage,>planet2Level6Data2ndStage
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $01
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level6Data2ndStage = $10F0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SPINNING_RING1,SPINNING_RING1 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SPINNING_RING1,SPINNING_RING1 + $01
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
        .BYTE $07
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
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level6Data,>planet2Level6Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $01
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
lickerShipWaveData = $1118
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP,LICKERSHIP+$02
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV,LICKERSHIP_INV+$01
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
        .BYTE <defaultExplosion,>defaultExplosion
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
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
planet1Level11Data = $1140
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_LEFT,GILBY_AIRBORNE_RIGHT + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_LOWERPLANET_RIGHT,GILBY_AIRBORNED_LOWERPLANET_LEFT + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $03
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <smallDotWaveData,>smallDotWaveData
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
        .BYTE $02
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
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $04
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
smallDotWaveData = $1168
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
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
        .BYTE $01
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <smallDot2WaveData,>smallDot2WaveData
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
        .BYTE $F8
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
        .BYTE <lickerShipWaveData,>lickerShipWaveData
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
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
smallDot2WaveData = $1190
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
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
        .BYTE $08
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
        .BYTE <lickerShipWaveData,>lickerShipWaveData
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
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level12Data = $11B8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE CAMEL,CAMEL + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
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
        .BYTE $21
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
        .BYTE <planet1Level12Data,>planet1Level12Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level2Data2ndStage,>planet1Level2Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $03
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet1Level2Data2ndStage = $11E0
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
        .BYTE LICKERSHIP_INV3,LICKERSHIP_INV3 + $01
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
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $26
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 21 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
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
        .BYTE <planet1Level12Data3rdStage,>planet1Level12Data3rdStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <spinningRings,>spinningRings
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
planet1Level12Data3rdStage = $1208
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
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
        .BYTE $00
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <defaultExplosion,>defaultExplosion
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
        .BYTE <nullPtr,>nullPtr
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
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level9Data = $1230
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE FLYING_DART1,FLYING_DART4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE FLYING_DART1,FLYING_DART4 + $01
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
        .BYTE $0C
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level9Data2ndStage,>planet3Level9Data2ndStage
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $03
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level9Data2ndStage = $1258
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BIRD1,BIRD4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $18
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level9Data,>planet3Level9Data
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
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level9Data = $1280
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BOUNCY_RING,BOUNCY_RING3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $E0
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level9Data2ndStage,>planet5Level9Data2ndStage
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
        .BYTE <planet5Level9Data2ndStage,>planet5Level9Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $02
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $08
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level9Data2ndStage = $12A8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $08
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $01
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $20
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

planet3Level12Data = $12D0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
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
        .BYTE <planet3Level12Data,>planet3Level12Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level12Data2ndStage,>planet3Level12Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $01
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $28
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level12Data2ndStage = $12F8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
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
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
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
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
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
        .BYTE $0F
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level2Data = $1320
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_RIGHT + $01
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
        .BYTE $0C
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
        .BYTE <planet4Leve2Data2ndStage,>planet4Leve2Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $04
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Leve2Data2ndStage = $1348
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY8,LAND_GILBY11 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET9,LAND_GILBY_LOWERPLANET11 + $01
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
        .BYTE $80
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <spinningRings,>spinningRings
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level12Data3rdStage,>planet1Level12Data3rdStage
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
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level8Data = $1370
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
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
        .BYTE <planet1Level8Data2ndStage,>planet1Level8Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level8Data2ndStage,>planet1Level8Data2ndStage
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $02
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level8Data2ndStage = $1398
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
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
        .BYTE $22
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
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
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level14Data = $13C0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $03
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet1Level8Data,>planet1Level8Data
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
        .BYTE $FA
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
        .BYTE <planet1Level8Data,>planet1Level8Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level8Data,>planet1Level8Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level13Data = $13E8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,$40
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,$40
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
        .BYTE <planet1Level13Data,>planet1Level13Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level13Data2ndStage,>planet1Level13Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet1Level13Data2ndStage,>planet1Level13Data2ndStage
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
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level13Data2ndStage = $1410
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
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
        .BYTE $18
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level10Data,>planet1Level10Data
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level7Data = $1438
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $E0
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level14Data,>planet1Level14Data
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
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $08
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level12Data = $1460
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BALLOON,BALLOON1 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET8,LAND_GILBY_LOWERPLANET9 + $01
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
        .BYTE $18
        ; Byte 23 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour)
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet1Level5Data,>planet1Level5Data
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet5Level12Data,>planet5Level12Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $88
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $14
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $04
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $08
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
f1488 = $1488
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $21,$22
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $DB,$DC
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
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level12Data,>planet5Level12Data
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
planet4Level14Data = $14B0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
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
        .BYTE <planet4Level14Data2ndStage,>planet4Level14Data2ndStage
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
        .BYTE $10
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level14Data2ndStage = $14D8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALLBALL_AGAIN,SMALLBALL_AGAIN + $01
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
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level14Data,>planet4Level14Data
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
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $05
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $06
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level10Data = $1500
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
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
        .BYTE $20
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
        .BYTE <defaultExplosion,>defaultExplosion
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $03
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet2Level4Data = $1528
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
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
        .BYTE $02
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $06
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
f1550 = $1550
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $FC,$FF
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
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
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet2Level4Data,>planet2Level4Data
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
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $02
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
planet5Level3Data = $1578
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY1,LAND_GILBY6 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET1,LAND_GILBY_LOWERPLANET8 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $01
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet5Level3Additional,>planet5Level3Additional
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
        .BYTE $FD
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
        .BYTE <planet5Level3Data,>planet5Level3Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level3Data2ndStage,>planet5Level3Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $02
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $30
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level3Data2ndStage = $15A0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $02
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LAND_GILBY1,LAND_GILBY6 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LAND_GILBY_LOWERPLANET1,LAND_GILBY_LOWERPLANET8 + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $01
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet5Level3Additional,>planet5Level3Additional
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
        .BYTE $03
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
        .BYTE <planet5Level3Data2ndStage,>planet5Level3Data2ndStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet5Level3Data,>planet5Level3Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $02
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
planet5Level3Additional = $15C8
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added? 
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave 
        .BYTE $C0
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <defaultExplosion,>defaultExplosion
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
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
unusedLlamaWaveData = $15F0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
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
        .BYTE <llamaExplosionData,>llamaExplosionData
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
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $10
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
llamaExplosionData = $1618
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
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
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level13Data2ndStage,>planet1Level13Data2ndStage
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level11Data = $1640
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
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
        .BYTE $21
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
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
        .BYTE <planet3Level11Data,>planet3Level11Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet3Level11Data2ndStage,>planet3Level11Data2ndStage
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
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet3Level11Data2ndStage = $1668
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $10
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP3,LICKERSHIP3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV3,LICKERSHIP_INV3 + $01
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
        .BYTE <planet1Level9DataSecondStage,>planet1Level9DataSecondStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $00
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $01
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <nullPtr,>nullPtr
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
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level11Data = $1690
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BIRD1,BIRD4 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $0C
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level11Data,>planet5Level11Data
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
        .BYTE <planet5Level11Data2ndStage,>planet5Level11Data2ndStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $03
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $18
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level11Data2ndStage = $16B8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BIRD1,BIRD1 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BIRD1,BIRD1 + $01
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
        .BYTE <planet5Level11Data3rdStage,>planet5Level11Data3rdStage
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
planet5Level11Data3rdStage = $16E0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
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
        .BYTE $30
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
planet5Level4Data = $1708
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level5Data2ndStage,>planet5Level5Data2ndStage
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
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $02
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $02
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet5Level5Data2ndStage = $1730
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0A
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE TEARDROP_EXPLOSION1,TEARDROP_EXPLOSION3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $20
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet5Level4Data,>planet5Level4Data
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
        .BYTE $02
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
planet4Level8Data = $1758
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $00
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
        .BYTE <planet4Level8Data,>planet4Level8Data
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <planet4Level8Data2ndStage,>planet4Level8Data2ndStage
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
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level8Data2ndStage = $1780
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
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
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level12Data3rdStage,>planet1Level12Data3rdStage
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $03
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $03
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level9Data = $17A8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,$40
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,$40
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
        .BYTE $80
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $25
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $80
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
        .BYTE <planet4Level9Data2ndStage,>planet4Level9Data2ndStage
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
        .BYTE $04
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $01
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet4Level9Data2ndStage = $17D0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BUBBLE,BUBBLE + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BUBBLE,BUBBLE + $01
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
        .BYTE $05
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet4Level9Data,>planet4Level9Data
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
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <lickerShipWaveData,>lickerShipWaveData
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $04
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


        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00

planet1Level5Data = $1800
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BALLOON,BALLOON + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BIRD1,BIRD1 + $01
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
        .BYTE $FC
        ; Byte 19 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $23
        ; Byte 20 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $02
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
        .BYTE <planet1Level5Data2ndStage,>planet1Level5Data2ndStage
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
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
        .BYTE $05
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $20
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level5Data2ndStage = $1828
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE BALLOON1,BALLOON1 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE BIRD2,BIRD2 + $01
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
        .BYTE $04
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level5Data,>planet1Level5Data
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
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
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

spinningRings = $1850
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $11
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
        .BYTE $30
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <defaultExplosion,>defaultExplosion
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
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $00
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $00
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $01
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $00
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $00
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00
planet1Level5Data3rdStage = $1878
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $03
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
        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        .BYTE $00
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $10
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level5Data4thStage,>planet1Level5Data4thStage
        ; Byte 18 (Index $12): X Pos movement for attack ship.
        .BYTE $01
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
        .BYTE <planet1Level5Data4thStage,>planet1Level5Data4thStage
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $01
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
planet1Level5Data4thStage = $18A0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE SMALL_BALL3,SMALL_BALL3 + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE SMALL_BALL3,SMALL_BALL3 + $01
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
        .BYTE $40
        ; Byte 16 (Index $10): Lo Ptr to the wave data we switch to when first hit.
        ; Byte 17 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet1Level5Data3rdStage,>planet1Level5Data3rdStage
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
        .BYTE <defaultExplosion,>defaultExplosion
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $01
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
defaultExplosion = $18C8
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE EXPLOSION_START,EXPLOSION_START + $03
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE EXPLOSION_START,EXPLOSION_START + $03
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
        .BYTE $01
        ; Byte 15 (Index $0F): Update rate for attack wave
        .BYTE $0D
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


planet4Level19Data = $18F0
        ; Byte 0 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE QBERT_SQUARES,QBERT_SQUARES + $01
        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE QBERT,QBERT + $01
        ; Byte 6 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $01
        ; Byte 7 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 8 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE <planet4Level19Additional,>planet4Level19Additional
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
        .BYTE $01
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
        .BYTE $23
        ; Byte 24 (Index $18): Lo Ptr for another set of wave data.
        ; Byte 25 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 26 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 27 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet4Level19Data,>planet4Level19Data
        ; Byte 28 (Index $1C): Lo Ptr for Explosion animation.
        ; Byte 29 (Index $1D): Hi Ptr for Explosion animation.
        .BYTE <spinningRings,>spinningRings
        ; Byte 30 (Index $1E): Lo Ptr for another set of wave data for this level.
        ; Byte 31 (Index $1F): Hi Ptr for another set of wave data for this level.
        .BYTE <defaultExplosion,>defaultExplosion
        ; These bytes aren't actually copied in. They're already there at 
        ; planet4Level19Data
        ; Byte 32 (Index $20): Unused.
        .BYTE $00
        ; Byte 33 (Index $21): Whether to load the extra stage data for this enemy.
        .BYTE $00
        ; Byte 34 (Index $22)): Points multiplier for hitting enemies in this level.
        .BYTE $02
        ; Byte 35: (Index $23): Does hitting this enemy increase the gilby's energy?
        .BYTE $08
        ; Byte 36: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?
        .BYTE $00
        ; Byte 37: (Index $25) Number of waves in data.
        .BYTE $04
        ; Byte 38: (Index $26) Number of ships in wave.
        .BYTE $0C
        ; Byte 39: (Index $27) Unused bytes.
        .BYTE $00

; vim: tabstop=2 shiftwidth=2 expandtab
