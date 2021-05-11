import sys
import os
import re


s1 = """
dnaColorSchemeLoPtr   .BYTE $1C,$23,$42,$50,$56,$5C,$64,$72
"""
s2 = """
dnaColorSchemeHiPtr   .BYTE $0F,$0F,$13,$13,$13,$13,$13,$13
"""
ls1 = re.split("([, \n])", s1)
ls2 = re.split("([, \n])", s2)

for i, l in enumerate(ls1):
    if "$" not in l:
        continue
    b = l[1:]
    ls1[i] = "<a" + ls2[i][1:] + b
    ls2[i] = ">a" + ls2[i][1:] + b

for ls in [ls1,ls2]:
    print(''.join(ls))

