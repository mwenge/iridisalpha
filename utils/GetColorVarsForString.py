import sys
import os
import re
"""
BLACK                                   = $00
WHITE                                   = $01
RED                                     = $02
CYAN                                    = $03
PURPLE                                  = $04
GREEN                                   = $05
BLUE                                    = $06
YELLOW                                  = $07
ORANGE                                  = $08
BROWN                                   = $09
LTRED                                   = $0A
GRAY1                                   = $0B
GRAY2                                   = $0C
LTGREEN                                 = $0D
LTBLUE                                  = $0E
GRAY3                                   = $0F
"""

colormap = {
    "$00": "BLACK",
    "$01": "WHITE",
    "$02": "RED",
    "$03": "CYAN",
    "$04": "PURPLE",
    "$05": "GREEN",
    "$06": "BLUE",
    "$07": "YELLOW",
    "$08": "ORANGE",
    "$09": "BROWN",
    "$0A": "LTRED",
    "$0B": "GRAY1",
    "$0C": "GRAY2",
    "$0D": "LTGREEN",
    "$0E": "LTBLUE",
    "$0F": "GRAY3",
    }

s = """
        .BYTE $06,$02,$04,$05,$03,$07,$01,$08
        .BYTE $09,$0A,$0B,$0C,$0D,$0E,$0F
"""
ls = re.split("([, #\n])", s)

r = [colormap[c]  if c in colormap else c for c in ls]
print(''.join(r))
