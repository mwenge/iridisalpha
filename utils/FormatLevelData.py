import sys
import os
import re

comments = [
(0,1,"; Byte 1 (Index $00): An index into colorsForAttackShips that applies a\n" +
     "; color value for the ship sprite."),
(1,2,"; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.\n" +
     "; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation\n" +
     "; for the upper planet."),
(3,1,"; Byte 4 (Index $03): The animation frame rate for the attack ship."),
(4,2,"; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.\n" +
     "; Byte 6 (Index $05): The 'end' sprite value for the ship's lower planet animation."),
(6,1,"; Byte 7 (Index $06): Whether a specific attack behaviour is used."),
(7,2,"; Byte 8 (Index $07): Lo Ptr for an unused attack behaviour\n" + 
     "; Byte 9 (Index $08): Hi Ptr for an unused attack behaviour"),
(9,2,"; Byte 10 (Index $09): Lo Ptr for an animation effect? (Doesn't seem to be used?) \n" +
     "; Byte 11 (Index $0A): Hi Ptr for an animation effect (Doesn't seem to be used?)?"),
(11,1,"; Byte 12 (Index $0B): some kind of rate limiting for attack wave "),
(12,2,"; Byte 13 (Index $0C): Lo Ptr for a stage in wave data (never used).\n" +
      "; Byte 14 (Index $0D): Hi Ptr for a stage in wave data (never used). "),
(14,1,"; Byte 15 (Index $0E): Controls the rate at which new enemies are added? "),
(15,1,"; Byte 16 (Index $0F): Update rate for attack wave "),
(16,2,"; Byte 17 (Index $10): Lo Ptr to the wave data we switch to when first hit. \n" +
      "; Byte 18 (Index $11): Hi Ptr to the wave data we switch to when first hit."),
(18,1,"; Byte 19 (Index $12): X Pos movement for attack ship."),
(19,1,"; Byte 20 (Index $13): Y Pos movement pattern for attack ship.\n" +
      "; An index into yPosMovementPatternForShips1"),
(20,1,"; Byte 21 (Index $14): X Pos Frame Rate for Attack ship."),
(21,1,"; Byte 22 (Index $15): Y Pos Frame Rate for Attack ship."),
(22,1,"; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player\n" +
      "; sapping their energy if they're near them?"),
(23,1,"; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its\n" +
      "; been shot? (Typical lickership behaviour) "),
(24,2,"; Byte 25 (Index $18): Lo Ptr for another set of wave data. \n" +
      "; Byte 26 (Index $19): Hi Ptr for another set of wave data."),
(26,2,"; Byte 27 (Index $1A): Lo Ptr for another set of wave data.\n" +
      "; Byte 28 (Index $1B): Hi Ptr for another set of wave data."),
(28,2,"; Byte 29 (Index $1C): Lo Ptr for Explosion animation. \n" +
      "; Byte 30 (Index $1D): Hi Ptr for Explosion animation. "),
(30,2,"; Byte 31 (Index $1E): Lo Ptr for another set of wave data for this level. \n" +
      "; Byte 32 (Index $1F): Hi Ptr for another set of wave data for this level. "),
(32,1,"; Byte 33 (Index $20): Unused."),
(33,1,"; Byte 34 (Index $21): Whether to load the extra stage data for this enemy. "),
(34,1,"; Byte 35 (Index $22)): Points multiplier for hitting enemies in this level. "),
(35,1,"; Byte 36: (Index $23): Does hitting this enemy increase the gilby's energy? "),
(36,1,"; Byte 37: (Index $24) Is the ship a spinning ring, i.e. does it allow the gilby to warp?  "),
(37,3,"; Byte 38-40: (Index $25-$27) Unused bytes."),
]

s = """
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
"""
s = ''.join(sys.stdin.readlines())
bs = [b.strip() for b in re.split("[ ,\n]", s) if b and "BYTE" not in b]
seps = ["f9C40","fA3C0","fA848","f1168", "f1190","f1488","f1550","f15C8", "f15F0", "f1618",
        "f1CF0","f1918", "f1940","planet","second","gilby","sticky","spinning","bubble","teardrop","cumming"
        ,"spinner","fighter","flowchart","licker","pin","piece", "bar", "coptic","default"]
for i,b in enumerate(bs):
    if not any([b.startswith(k) for k in seps]):
        continue
    name = b
    fields = bs[i+1:i+41]
    print(name)
    for i,l,c in comments:
       print('\n'.join([" " * 8 + cl for cl in c.split('\n')]))
       print((" " * 8) + ".BYTE " + ','.join([fields[i+o] for o in range(0,l)]))



