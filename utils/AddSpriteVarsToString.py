import sys
import os
import re

o = open("../src/graphics/sprites.asm", 'r')
charmap = {l[17:20].strip().upper():l[22:].strip() 
             for l in o.readlines() 
             if "SPRITE" in l and l[22:].strip() != ""}

s = """
upperPlanetAttackShipSpritesLoadedFromBackingData .BYTE $ED,$ED,$ED,$ED
lowerPlanetAttackShipSpritesLoadedFromBackingData .BYTE $ED,$ED,$ED,$ED
upperPlanetAttackShipSpriteAnimationEnd           .BYTE $F0,$F0,$F0,$F0
lowerPlanetAttackShipSpriteAnimationEnd           .BYTE $F0,$F0,$F0,$F0
"""
ls = re.split("([, \n])", s)

r = [charmap[c]  if c in charmap else c for c in ls]
print(''.join(r))

