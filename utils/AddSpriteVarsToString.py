import sys
import os
import re

o = open("../src/sprites.asm", 'r')
charmap = {l[17:20].strip().upper():l[22:].strip() 
             for l in o.readlines() 
             if "SPRITE" in l and l[22:].strip() != ""}

s = """
gilbySprites .BYTE $C1,$C2,$C3,$C4,$C5,$C6,$C7,$C6
             .BYTE $C5,$C4,$C3,$C2,$C1,$C8,$C9,$CA
             .BYTE $CB,$CB,$CC,$CD,$CE,$CF,$CE,$CD
             .BYTE $CC,$CB,$D3,$D2,$CF,$D0,$D1,$D1
             .BYTE $D0,$CF,$D2,$D3
"""
ls = re.split("([, \n])", s)

r = [charmap[c]  if c in charmap else c for c in ls]
print(''.join(r))

