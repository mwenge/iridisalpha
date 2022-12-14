import sys
import os
import re

o = open("../src/graphics/sprites.asm", 'r')
charmap = {l[17:20].strip().upper():l[22:].strip() 
             for l in o.readlines() 
             if "SPRITE" in l and l[22:].strip() != ""}

s = """
starfieldSpriteAnimationData .BYTE $C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0
                             .BYTE $F0,$F0,$F0,$F0,$F8,$F8,$F8,$F8
                             .BYTE $FC,$FC,$FC,$FC,$FE,$FE,$FE,$FF
"""
ls = re.split("([, \n])", s)

r = [charmap[c]  if c in charmap else c for c in ls]
print(''.join(r))

