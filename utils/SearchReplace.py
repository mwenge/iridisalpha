import sys
import os
import re

tokens = {
"f1000" : "planet2Level5Data",
"f1078" : "planet3Level7Data",
"f10C8" : "planet2Level6Data",
"f1140" : "planet1Level11Data",
"f11B8" : "planet1Level12Data",
"f1230" : "planet3Level9Data",
"f1280" : "planet5Level9Data",
"f12D0" : "planet3Level12Data",
"f1320" : "planet4Level2Data",
"f1370" : "planet1Level8Data",
"f13C0" : "planet1Level14Data",
"f13E8" : "planet1Level13Data",
"f1438" : "planet4Level7Data",
"f1460" : "planet5Level12Data",
"f14B0" : "planet4Level14Data",
"f1500" : "planet5Level10Data",
"f1528" : "planet2Level4Data",
"f1578" : "planet5Level3Data",
"f1640" : "planet3Level11Data",
"f1690" : "planet5Level11Data",
"f1708" : "planet5Level4Data",
"f1758" : "planet4Level8Data",
"f17A8" : "planet4Level9Data",
"f1800" : "planet1Level5Data",
"f1118" : "lickerShipWaveData",
}

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
for t,v in tokens.items():
    s = s.replace(t, v); 
print(s)


