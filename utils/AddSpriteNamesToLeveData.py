import sys
import os
import re
from sprites import sprites


s = """
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
"""
lines = sys.stdin.readlines()
sprite = False
for line in lines:
    if any([b in line for b in ["Byte 3", "Byte 6"]]):
        sprite = True
        print(line.rstrip())
        continue
    if sprite and ".BYTE" in line:
        l = line.strip()
        b1 = l[6:9]
        if b1 in sprites:
            line = line.replace(b1, sprites[b1])

        b2 = l[10:13]
        if b2 in sprites:
            i = int(b2[1:],16) - 1
            b2a = "$" + str(hex(i))[2:].zfill(2).upper()
            line = line.replace(b2, sprites[b2a] + " + $01")
        sprite = False
    print(line.rstrip())




