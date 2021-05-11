import sys
import os
import re


s = """
             .BYTE $9F,$D8,$1E,$A8,$1A,$E8,$1C,$50
             .BYTE $1C,$78,$1C,$C8,$10,$78,$1F,$20
             .BYTE $12,$30,$9C,$68,$16,$40,$12,$D0
             .BYTE $9D,$F8,$A2,$80,$A4,$38,$A9,$20
             .BYTE $AA,$88,$A4,$88,$9E,$C0,$A1,$B8

             .BYTE $9F,$88,$13,$20,$1A,$20,$19,$D0
             .BYTE $1F,$98,$1D,$90,$14,$38,$17,$58
             .BYTE $17,$A8,$9C,$B8,$A7,$D0,$A4,$D8
             .BYTE $A9,$E8,$14,$B0,$9D,$58,$A7,$30
             .BYTE $9B,$50,$A6,$68,$18,$F0,$A1,$E0

             .BYTE $9F,$38,$A2,$30,$15,$78,$17,$08
             .BYTE $9B,$F0,$9D,$08,$A6,$90,$A9,$C0
             .BYTE $12,$80,$15,$00,$16,$90,$14,$60
             .BYTE $A7,$80,$A8,$20,$A8,$70,$A2,$D0
             .BYTE $AA,$10,$AA,$60,$A8,$20,$A2,$08
"""
ls = re.split("([, \n])", s)
indices = [i for i,l in enumerate(ls) if "$" in l]

for x, i in enumerate(indices):
    cb = ls[i][1:]

    if x % 2 != 0:
        ls[i] = "<" + ls[i-2][1:] 
    else:
        nb = ls[i+2][1:]
        print(nb)
        ls[i] = ">f" + cb + nb

print(''.join(ls))

