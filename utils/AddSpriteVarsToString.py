import sys
import os
import re

o = open("../src/graphics/sprites.asm", 'r')
charmap = {l[17:20].strip().upper():l[22:].strip() 
             for l in o.readlines() 
             if "SPRITE" in l and l[22:].strip() != ""}

s = """
defaultLickerShipSpriteArray   .BYTE $F6,$F7,$F8,$F7,$F7,$F8,$F7,$F6
"""
ls = re.split("([, \n])", s)

r = [charmap[c]  if c in charmap else c for c in ls]
print(''.join(r))

