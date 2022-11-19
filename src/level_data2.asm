; Level data.
; $EFF0
; Copied to $1000 by SwapTitleScreenDataAndSpriteLevelData
nullPtr = $0000
secondExplosionAnimation = $1AC0
f1A98 = $1A98
f11B8 = $11B8
f1E58 = $1E58
LICKERSHIP = $F7
LICKERSHIP_INV = $FA

planet2Level5Data = $1000
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F6,$F7
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $F9,$FA
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
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level5Data2ndStage,>planet2Level5Data2ndStage
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet2Level5Data3rdStage,>planet2Level5Data3rdStage
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet2Level5Data2ndStage,>planet2Level5Data2ndStage
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
        .BYTE $04,$30,$00
planet2Level5Data2ndStage = $1028
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F7,$F8
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FA,$FB
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
        .BYTE <planet2Level5Data3rdStage,>planet2Level5Data3rdStage
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
planet2Level5Data3rdStage = $1050
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $05
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F8,$F9
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $FB,$FC
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
        .BYTE <default2ndStage,>default2ndStage
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
planet3Level7Data = $1078
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F6,$F9
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $07
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
        .BYTE $02
        ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
        ; sapping their energy if they're near them?
        .BYTE $00
        ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
        ; been shot? (Typical lickership behaviour) 
        .BYTE $00
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <planet3Level7Data2ndStage,>planet3Level7Data2ndStage
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
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet3Level7Data2ndStage = $10A0
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $08
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $F6,$F9
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $07
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
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet3Level7Data,>planet3Level7Data
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet3Level7Data,>planet3Level7Data
        ; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. 
        ; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. 
        .BYTE <planet3Level7Data,>planet3Level7Data
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
planet2Level6Data = $10C8
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $E8,$E9
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $E8,$E9
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
        .BYTE $07
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $24
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
        .BYTE <planet2Level6Data2ndStage,>planet2Level6Data2ndStage
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
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$20,$00
planet2Level6Data2ndStage = $10F0
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $04
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $E8,$E9
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $00
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $E8,$E9
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
        .BYTE $07
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
        .BYTE $23
        ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
        ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
        .BYTE <nullPtr,>nullPtr
        ; Byte 27 (Index $1A): Lo Ptr for another set of wave data.
        ; Byte 28 (Index $1B): Hi Ptr for another set of wave data.
        .BYTE <planet2Level6Data,>planet2Level6Data
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
        .BYTE $01
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
lickerShipWaveData = $1118
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0B
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE LICKERSHIP,LICKERSHIP+$02
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $04
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE LICKERSHIP_INV,LICKERSHIP_INV+$01
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
        .BYTE <default2ndStage,>default2ndStage
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
        .BYTE $02
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet1Level11Data = $1140
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0E
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $D1,$D4
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $06
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $E4,$E7
        ; Byte 7 (Index $06): Whether a specific attack behaviour is used.
        .BYTE $03
        ; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour
        ; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour
        .BYTE $68,$11
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
        .BYTE <default2ndStage,>default2ndStage
        ; Byte 33 (Index $20): Unused.
        .BYTE $00
        ; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. 
        .BYTE $00
        ; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. 
        .BYTE $04
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$10,$00
f1168 = $1168
        .BYTE $04,$E7,$E8,$00,$E7,$E8,$01,$90
        .BYTE $11,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$F8,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
f1190 = $1190
        .BYTE $04,$E7,$E8,$00,$E7,$E8,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$08,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
planet1Level12Data = $11B8
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $09
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $30,$31
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
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
        .BYTE $FC
        ; Byte 20 (Index $13): Y Pos movement pattern for attack ship.
        ; An index into yPosMovementPatternForShips1
        .BYTE $21
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
        .BYTE <f11B8,>f11B8
        ; Byte 29 (Index $1C): Lo Ptr for Explosion animation. 
        ; Byte 30 (Index $1D): Hi Ptr for Explosion animation. 
        .BYTE <planet1Level2Data2ndStage,>planet1Level2Data2ndStage
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
planet1Level2Data2ndStage = $11E0
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
        .BYTE $FB,$FC
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
        .BYTE $26
        ; Byte 21 (Index $14): X Pos Frame Rate for Attack ship.
        .BYTE $00
        ; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship.
        .BYTE $03
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
        .BYTE <planet1Level12Data3rdStage,>planet1Level12Data3rdStage
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
planet1Level12Data3rdStage = $1208
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $E8,$EC
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $01
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $E8,$EC
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
        .BYTE <default2ndStage,>default2ndStage
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
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
planet3Level9Data = $1230
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $06
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $31,$35
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $05
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $31,$35
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
        .BYTE <planet3Level9Data2ndStage,>planet3Level9Data2ndStage
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
        .BYTE $03
        ; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? 
        .BYTE $05
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $04,$18,$00
planet3Level9Data2ndStage = $1258
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $0C
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $23,$27
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $02
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
        .BYTE $18
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <planet3Level9Data,>planet3Level9Data
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
        .BYTE $03
        ; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  
        .BYTE $00
        ; Byte 38-40: (Index $25-$27) Unused bytes.
        .BYTE $00,$00,$00
f1280 = $1280
        .BYTE $00,$3B,$3E,$03,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$E0
        .BYTE <f12A8,>f12A8,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f12A8,>f12A8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$01,$00,$04,$08,$00
f12A8 = $12A8
        .BYTE $02,$3B,$3E,$01,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,$00,$00,$01,$01,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$20,$00,$00,$00,$00
f12D0 = $12D0
        .BYTE $00,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$23,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<f12D0,>f12D0
        .BYTE <f12F8,>f12F8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$02,$00,$04,$28,$00
f12F8 = $12F8
        .BYTE $0B,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$25,$01,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<secondExplosionAnimation,>secondExplosionAnimation
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$0F,$00,$00,$00,$00
f1320 = $1320
        .BYTE $0E,$D3,$D4,$00,$D3,$D4,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$0C,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1348,>f1348,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$04,$01,$00,$04,$10,$00
f1348 = $1348
        .BYTE $0E,$C8,$CC,$03,$DC,$DF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$80
        .BYTE <spinningRings,>spinningRings,$00,$25,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <planet1Level12Data3rdStage,>planet1Level12Data3rdStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$01,$00,$00,$00,$00
f1370 = $1370
        .BYTE $11,$FC,$FF,$03,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$05,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1398,>f1398,<f1398,>f1398
        .BYTE $00,$00,$02,$02,$00,$04,$20,$00
f1398 = $1398
        .BYTE $10,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <spinningRings,>spinningRings,$00,$22,$01,$01,$80,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
f13C0 = $13C0
        .BYTE $06,$FC,$FF,$05,$FC,$FF,$03,$70
        .BYTE $13,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FA,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1370,>f1370,<f1370,>f1370
        .BYTE $00,$00,$00,$08,$00,$04,$10,$00
f13E8 = $13E8
        .BYTE $0B,$3E,$40,$04,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$24,$02,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<f13E8,>f13E8
        .BYTE <f1410,>f1410,<f1410,>f1410
        .BYTE $00,$00,$04,$02,$00,$04,$20,$00
f1410 = $1410
        .BYTE $11,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <f1E58,>f1E58,$00,$24,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$05,$00,$00,$00,$00
f1438 = $1438
        .BYTE $05,$FC,$FF,$06,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$E0
        .BYTE <f13C0,>f13C0,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$04,$08,$00
f1460 = $1460
        .BYTE $07,$21,$23,$03,$DB,$DD,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$23,$02,$02,$18,$23
        .BYTE <f1800,>f1800,<f1460,>f1460
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $88,$14,$00,$04,$00,$04,$08,$00
f1488 = $1488
        .BYTE $0B,$21,$22,$00,$DB,$DC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f1460,>f1460,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f14B0 = $14B0
        .BYTE $11,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$80,$80,$80,$80,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f14D8,>f14D8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$04,$18,$00
f14D8 = $14D8
        .BYTE $00,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f14B0,>f14B0,$00,$24,$02,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$05,$06,$00,$00,$00,$00
f1500 = $1500
        .BYTE $08,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$20,$00,$01,$00,$00
        .BYTE <default2ndStage,>default2ndStage,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$03,$03,$00,$04,$18,$00
f1528 = $1528
        .BYTE $05,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$00,$02,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$06,$03,$00,$04,$18,$00
f1550 = $1550
        .BYTE $11,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f1528,>f1528,$00,$00,$01,$01,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$02,$02,$00,$00,$00,$00
f1578 = $1578
        .BYTE $02,$C1,$C7,$04,$D4,$DC,$01,$C8
        .BYTE $15,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FD,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1578,>f1578
        .BYTE <f15A0,>f15A0,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$01,$00,$04,$30,$00
f15A0 = $15A0
        .BYTE $02,$C1,$C7,$04,$D4,$DC,$01,$C8
        .BYTE $15,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$03,$23,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f15A0,>f15A0
        .BYTE <f1578,>f1578,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$01,$00,$00,$00,$00
f15C8 = $15C8
        .BYTE $11,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$C0
        .BYTE <default2ndStage,>default2ndStage,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <default2ndStage,>default2ndStage,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
f15F0 = $15F0
        .BYTE $00,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1618,>f1618,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$04,$10,$00
f1618 = $1618
        .BYTE $11,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f1410,>f1410,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
f1640 = $1640
        .BYTE $04,$F6,$F8,$05,$F9,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FD,$21,$02,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1640,>f1640
        .BYTE <f1668,>f1668,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$04,$20,$00
f1668 = $1668
        .BYTE $10,$F8,$F9,$00,$FB,$FC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f1A98,>f1A98,$00,$25,$01,$01,$01,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
f1690 = $1690
        .BYTE $06,$23,$27,$04,$23,$27,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$0C
        .BYTE <f1690,>f1690,$00,$00,$01,$02,$10,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f16B8,>f16B8,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$03,$02,$00,$04,$18,$00
f16B8 = $16B8
        .BYTE $11,$23,$24,$00,$23,$24,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f16E0,>f16E0,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
f16E0 = $16E0
        .BYTE $00,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <spinningRings,>spinningRings,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
f1708 = $1708
        .BYTE $0E,$FC,$FF,$04,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f1730,>f1730,$00,$00,$01,$00,$01,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$04,$20,$00
f1730 = $1730
        .BYTE $0A,$FC,$FF,$02,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <f1708,>f1708,$00,$00,$00,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$00,$00,$00
f1758 = $1758
        .BYTE $00,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1758,>f1758,<f1780,>f1780
        .BYTE $00,$00,$00,$00,$00,$04,$20,$00
f1780 = $1780
        .BYTE $11,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <planet1Level12Data3rdStage,>planet1Level12Data3rdStage,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<nullPtr,>nullPtr
        .BYTE $00,$00,$03,$03,$00,$00,$00,$00
f17A8 = $17A8
        .BYTE $11,$3E,$40,$04,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$80,$25,$80,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f17D0,>f17D0
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$04,$01,$00,$04,$20,$00
f17D0 = $17D0
        .BYTE $0B,$3E,$3F,$00,$3E,$3F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$05
        .BYTE <f17A8,>f17A8,$00,$00,$01,$00,$01,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$04,$01,$00,$00,$00,$00

        .BYTE $00,$00,$00,$00,$00,$00,$00,$00

f1800 = $1800
        .BYTE $11,$21,$22,$00,$23,$24,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$23,$02,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1828,>f1828
        .BYTE <f1878,>f1878,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$05,$00,$04,$20,$00
f1828 = $1828
        .BYTE $07,$22,$23,$00,$24,$25,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$04
        .BYTE <f1800,>f1800,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1878,>f1878,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
spinningRings = $1850
        .BYTE $11,$E8,$EC,$01,$E8,$EC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <default2ndStage,>default2ndStage,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$00,$00,$01,$00,$00,$00
f1878 = $1878
        .BYTE $03,$28,$29,$00,$28,$29,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f18A0,>f18A0,$01,$01,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f18A0,>f18A0,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$02,$00,$00,$00,$00
f18A0 = $18A0
        .BYTE $04,$29,$2A,$00,$29,$2A,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <f1878,>f1878,$04,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $00,$00,$01,$02,$00,$00,$00,$00
default2ndStage = $18C8
        ; Byte 1 (Index $00): An index into colorsForAttackShips that applies a
        ; color value for the ship sprite.
        .BYTE $07
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        .BYTE $ED,$F0
        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        .BYTE $03
        ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
        ; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        .BYTE $ED,$F0
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
        .BYTE $01
        ; Byte 16 (Index $0F): Update rate for attack wave 
        .BYTE $0D
        ; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. 
        ; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit.
        .BYTE <nullPtr,>nullPtr
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
planet4Level19Data = $18F0
        .BYTE $06,$2A,$2B,$00,$2B,$2C,$01,$18
        .BYTE $19,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$01,$00,$01,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet4Level19Data,>planet4Level19Data
        .BYTE <spinningRings,>spinningRings,<default2ndStage,>default2ndStage
        .BYTE $BD,$BD,$BD,$BD,$BD

; vim: tabstop=2 shiftwidth=2 expandtab
