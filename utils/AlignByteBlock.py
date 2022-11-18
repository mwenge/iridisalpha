import sys
import os
import re


s = """
        .BYTE $0E,$D1,$D4,$06,$E4,$E7,$03,$68
        .BYTE $11,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$02,$00,$01,$02,$00,$01
        .BYTE $00,$00,$00,$00,$C0,$1A,$C8,$18
        .BYTE $00,$00,$04,$05,$00,$04,$10,$00
        .BYTE $04,$E7,$E8,$00,$E7,$E8,$01
        .BYTE $90,$11,$00,$00,$00,$00,$00,$00
        .BYTE $20,$00,$00,$F8,$00,$01,$02,$00
        .BYTE $01,$00,$00,$00,$00,$18,$11,$C8
        .BYTE $18,$00,$00,$00,$03,$00,$00,$00
        .BYTE $00,$04,$E7,$E8,$00,$E7,$E8,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $20,$00,$00,$08,$00,$01,$02,$00
        .BYTE $01,$00,$00,$00,$00,$18,$11,$C8
        .BYTE $18,$00,$00,$00,$03,$00,$00,$00
        .BYTE $00,$09,$30,$31,$02,$F9,$FB,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$FC,$21,$01,$01,$00
        .BYTE $23,$00,$00,$B8,$11,$E0,$11,$C8
        .BYTE $18,$00,$00
        .BYTE $03,$02,$00,$04,$20,$00,$07,$30
        .BYTE $31,$00,$FB,$FC,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$26,$00,$03,$00,$23,$00,$00
        .BYTE $08,$12,$00,$00,$50,$18,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$06,$E8
        .BYTE $EC,$01,$E8,$EC,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$C8,$18
        .BYTE $00,$00,$02,$02
        .BYTE $01,$01,$00,$00,$00,$00,$00,$00
        .BYTE $C8,$18,$00,$00,$00,$05,$00,$00
        .BYTE $00,$00,$06,$31,$35,$05,$31,$35
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$0C,$58,$12,$00,$00,$01,$02
        .BYTE $01,$01,$00,$00,$00,$00,$C0,$1A
        .BYTE $C8,$18,$00,$00,$03,$05,$00,$04
        .BYTE $18,$00,$0C,$23,$27,$02,$23,$27
        .BYTE $00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE $30,$12,$80,$80,$80,$80,$00,$00
        .BYTE $00,$00,$00,$00,$C8,$18,$C8,$18
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
        .BYTE $00,$3B,$3E,$03,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$E0
        .BYTE $A8,$12,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$A8,$12,$C8,$18
        .BYTE $00
        .BYTE $00,$02,$01,$00,$04,$08,$00,$02
        .BYTE $3B,$3E,$01,$3B,$3E,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$08,$C0
        .BYTE $1A,$00,$00,$01,$01,$01,$01,$00
        .BYTE $00,$00,$00,$C8,$18,$C8,$18,$00
        .BYTE $00,$01,$20,$00,$00,$00,$00,$00
        .BYTE $2F,$30,$00,$2F,$30,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$23,$00,$01,$00,$23,$00
        .BYTE $00,$D0,$12,$F8,$12,$C8,$18,$00
        .BYTE $00,$01,$02,$00,$04,$28,$00,$0B
        .BYTE $2F,$30,$00,$2F,$30,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$25,$01,$02,$01,$23,$00
        .BYTE $00,$C0,$1A,$C8,$18,$C8,$18,$00
        .BYTE $00,$00,$0F,$00,$00,$00,$00,$0E
        .BYTE $D3,$D4,$00,$D3,$D4,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$0C,$00,$01,$02,$00,$01,$00
        .BYTE $00,$00,$00,$48,$13,$C8
        .BYTE $18,$00,$00,$04
        .BYTE $01,$00,$04,$10,$00,$0E,$C8,$CC
        .BYTE $03,$DC,$DF,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$80,$50,$18
        .BYTE $00,$25,$00,$01,$00,$23,$00,$00
        .BYTE $00,$00,$08,$12,$C8,$18,$00,$00
        .BYTE $00,$01,$00,$00,$00,$00,$11,$FC
        .BYTE $FF,$03,$FC,$FF,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $05,$00,$01,$02,$00,$01,$00,$00
        .BYTE $00,$00,$98,$13,$98,$13,$00,$00
        .BYTE $02,$02,$00,$04,$20,$00,$10,$FC
        .BYTE $FF,$01,$FC,$FF,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$20,$50,$18
        .BYTE $00,$22,$01,$01,$80,$23,$00,$00
        .BYTE $00,$00,$00,$00,$C8,$18,$00,$00
        .BYTE $00,$10,$00,$00,$00,$00,$06,$FC
        .BYTE $FF,$05,$FC,$FF,$03,$70,$13,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $FA,$00,$01,$01,$00,$01,$00,$00
        .BYTE $00,$00,$70,$13,$70,$13,$00,$00
        .BYTE $00,$08,$00,$04,$10,$00,$0B,$3E
        .BYTE $40,$04,$3E,$40,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$24,$02,$02,$01,$23,$00,$00
        .BYTE $E8,$13,$10,$14,$10,$14,$00,$00
        .BYTE $04,$02,$00,$04,$20,$00,$11,$FF
        .BYTE $00,$00,$FF,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$18,$58,$1E
        .BYTE $00,$24,$00,$01,$00,$23,$00,$00
        .BYTE $00,$00,$00,$00,$C8,$18,$00,$00
        .BYTE $00,$05,$00,$00,$00,$00,$05,$FC
        .BYTE $FF,$06,$FC,$FF,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$E0,$C0,$13
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$C8,$18,$C8,$18,$00,$00
        .BYTE $00,$08,$00,$04,$08,$00,$07,$21
        .BYTE $23,$03,$DB,$DD,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$23,$02,$02,$18,$23,$00,$18
        .BYTE $60,$14,$00,$00,$C8,$18,$88,$14
        .BYTE $00,$04,$00,$04,$08,$00,$0B,$21
        .BYTE $22,$00,$DB,$DC,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$30,$60,$14
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00
        .BYTE $00,$00,$11,$2F,$30,$00,$2F,$30
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$80,$80,$80,$80
        .BYTE $00,$00,$00,$00,$00,$00,$D8,$14
        .BYTE $C8,$18,$00,$00,$00,$10,$00,$04
        .BYTE $18,$00,$00,$2F,$30,$00,$2F,$30
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$30,$B0,$14,$00,$24,$02,$02
        .BYTE $01,$23,$00,$00,$00,$00,$C0,$1A
        .BYTE $C8,$18,$00,$00,$05,$06,$00,$00
        .BYTE $00,$00,$08,$30,$31,$00,$30,$31
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$20,$00,$01
        .BYTE $00,$00,$C8,$18,$00,$00,$18,$11
        .BYTE $18,$11,$00,$00,$03,$03,$00,$04
        .BYTE $18,$00,$05,$FC,$FF,$01,$FC,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$FC,$00,$02,$02
        .BYTE $00,$23,$00,$00,$00,$00,$C0,$1A
        .BYTE $C8,$18,$00,$00,$06,$03,$00,$04
        .BYTE $18,$00,$11,$FC,$FF,$01,$FC,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$30,$28,$15,$00,$00,$01,$01
        .BYTE $01,$01,$00,$00,$00,$00,$C0,$1A
        .BYTE $C8,$18,$00,$00,$02,$02,$00,$00
        .BYTE $00,$00,$02,$C1,$C7,$04,$D4,$DC
        .BYTE $01,$C8,$15,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$FD,$24,$01,$02
        .BYTE $00,$23,$00,$00,$78,$15,$A0,$15
        .BYTE $18,$11,$00,$00,$02,$01,$00,$04
        .BYTE $30,$00,$02,$C1,$C7,$04,$D4,$DC
        .BYTE $01,$C8,$15,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$03,$23,$01,$02
        .BYTE $00,$23,$00,$00,$A0,$15,$78,$15
        .BYTE $18,$11,$00,$00,$02,$01,$00,$00
        .BYTE $00,$00,$11,$FC,$FF,$01,$FC,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$C0,$C8,$18,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$C8,$18
        .BYTE $C8,$18,$00,$00,$00,$08,$00
        .BYTE $00,$00,$00,$00,$FF,$00,$00,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE $16,$C8,$18,$00,$00,$00,$08,$00
        .BYTE $04,$10,$00,$11,$FF,$00,$00,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$10,$10,$14,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$C8,$18,$00,$00,$00,$08,$00
        .BYTE $00,$00,$00,$04,$F6,$F8,$05,$F9
        .BYTE $FB,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$FD,$21,$02
        .BYTE $01,$00,$23,$00,$00,$40,$16,$68
        .BYTE $16,$C8,$18,$00,$00,$00,$08,$00
        .BYTE $04,$20,$00,$10,$F8,$F9,$00,$FB
        .BYTE $FC,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$10,$98,$1A,$00,$25,$01
        .BYTE $01,$01,$23,$00,$00,$00,$00,$00
        .BYTE $00,$C8,$18,$00,$00,$00,$08,$00
        .BYTE $00,$00,$00,$06,$23,$27,$04,$23
        .BYTE $27,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$0C,$90,$16,$00,$00,$01
        .BYTE $02,$10,$01,$00,$00,$00
        .BYTE $00,$B8,$16,$C8,$18,$00,$00,$03
        .BYTE $02,$00,$04,$18,$00,$11,$23,$24
        .BYTE $00,$23,$24,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$10,$E0,$16,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$C8,$18,$00,$00,$00
        .BYTE $10,$00,$00,$00,$00,$00,$FF,$00
        .BYTE $00,$FF,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
        .BYTE $00,$00,$30,$50,$18,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00
        .BYTE $00,$C8,$18,$00,$00,$00,$10,$00
        .BYTE $00,$00,$00,$0E,$FC,$FF,$04,$FC
        .BYTE $FF,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$10,$30,$17,$00,$00,$01
        .BYTE $00,$01,$00,$00,$00,$00,$00,$50
        .BYTE $18,$18,$11,$00,$00,$02,$02,$00
        .BYTE $04,$20,$00,$0A,$FC,$FF,$02,$FC
        .BYTE $FF,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$20,$08,$17,$00,$00,$00
        .BYTE $01,$00,$01,$00,$00,$00,$00,$50
        .BYTE $18,$18,$11,$00,$00,$02,$02,$00
        .BYTE $00,$00,$00,$00,$FF,$00,$00,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$58
        .BYTE $17,$80,$17,$00,$00,$00,$00,$00
        .BYTE $04,$20,$00,$11,$FF,$00,$00,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$30,$08,$12,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$50
        .BYTE $18,$00,$00,$00,$00,$03,$03,$00
        .BYTE $00,$00,$00,$11,$3E,$40,$04,$3E
        .BYTE $40,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$80,$25,$80
        .BYTE $02,$00,$23,$00,$00,$D0,$17,$50
        .BYTE $18,$18,$11,$00,$00,$04,$01,$00
        .BYTE $04,$20,$00,$0B,$3E,$3F,$00,$3E
        .BYTE $3F,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$05,$A8,$17,$00,$00,$01
        .BYTE $00,$01,$00,$00,$00,$00,$00,$50
        .BYTE $18,$18,$11,$00,$00,$04,$01,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$11,$21,$22,$00,$23
        .BYTE $24,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$FC,$23,$02
        .BYTE $02,$00,$23,$00,$00,$28,$18,$78
        .BYTE $18,$C8,$18,$00,$00,$00,$05,$00
        .BYTE $04,$20,$00,$07,$22,$23,$00,$24
        .BYTE $25,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$04,$00,$18,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$78
        .BYTE $18,$C8,$18,$00,$00,$00,$04,$00
        .BYTE $00,$00,$00,$11,$E8,$EC,$01,$E8
        .BYTE $EC,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$30,$C8,$18,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$C8,$18,$00,$00,$00,$00,$01
        .BYTE $00,$00,$00,$03,$28,$29,$00,$28
        .BYTE $29,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$10,$A0,$18,$01,$01,$01
        .BYTE $01,$00,$00,$00,$00,$00,$00,$A0
        .BYTE $18,$C8,$18,$00,$00,$01,$02,$00
        .BYTE $00,$00,$00,$04,$29,$2A,$00,$29
        .BYTE $2A,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$40,$78,$18,$04,$00,$01
        .BYTE $02,$00,$01,$00,$00,$00,$00,$50
        .BYTE $18,$C8,$18,$00,$00,$01,$02,$00
        .BYTE $00,$00,$00,$07,$ED,$F0,$03,$ED
        .BYTE $F0,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$01,$0D,$00,$00,$80,$80,$01
        .BYTE $01,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$06,$2A,$2B,$00,$2B
        .BYTE $2C,$01,$18,$19,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$01,$00,$01
        .BYTE $01,$00,$23,$00,$00,$F0,$18,$50
        .BYTE $18,$C8,$18,$BD,$BD,$BD,$BD,$BD
"""
ls = re.split("([, \n])", s)
bs = [b for b in ls if "$" in b]
print(bs)

o = []
for i, b in enumerate(bs):
    if i and i % 8 == 0:
        print(".BYTE " + ','.join(o))
        o = []
    o += [b]

print(".BYTE " + ','.join(o))


