; Level data.
; $EFF0
; Copied to $1000 by SwapTitleScreenDataAndSpriteLevelData
nullPtr = $0000
secondExplosionAnimation = $1AC0
f1A98 = $1A98
f11B8 = $11B8
f1E58 = $1E58

planet2Level5Data = $1000
        .BYTE $05,$F6,$F7,$00,$F9,$FA,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$06,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1028,>f1028
        .BYTE <f1050,>f1050,<f1028,>f1028
        .BYTE $00,$00,$02,$01,$00,$04,$30,$00
f1028 = $1028
        .BYTE $05,$F7,$F8,$00,$FA,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$0A
        .BYTE <planet2Level5Data,>planet2Level5Data,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1050,>f1050,<f18C8,>f18C8
        .BYTE $00,$00,$00,$0C,$00,$00,$00,$00
f1050 = $1050
        .BYTE $05,$F8,$F9,$00,$FB,$FC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f18C8,>f18C8,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet3Level7Data = $1078
        .BYTE $07,$F6,$F9,$07,$F9,$FC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$03,$23,$01,$02,$00,$00
        .BYTE <f10A0,>f10A0,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<f18C8,>f18C8
        .BYTE $00,$00,$01,$02,$00,$04,$20,$00
f10A0 = $10A0
        .BYTE $08,$F6,$F9,$07,$F9,$FC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$02,$03,$01,$23
        .BYTE <nullPtr,>nullPtr,<planet3Level7Data,>planet3Level7Data
        .BYTE <planet3Level7Data,>planet3Level7Data,<planet3Level7Data,>planet3Level7Data
        .BYTE $00,$00,$00,$05,$00,$00,$00,$00
planet2Level6Data = $10C8
        .BYTE $04,$E8,$E9,$00,$E8,$E9,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$07,$24,$01,$01,$00,$00
        .BYTE <f10F0,>f10F0,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$01,$02,$00,$04,$20,$00
f10F0 = $10F0
        .BYTE $04,$E8,$E9,$00,$E8,$E9,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$07,$00,$01,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet2Level6Data,>planet2Level6Data
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$01,$02,$00,$00,$00,$00
lickerShipWaveData = $1118
        .BYTE $0B,$F7,$F9,$04,$FA,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <f18C8,>f18C8,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$00,$02,$00,$00,$00,$00
planet1Level11Data = $1140
        .BYTE $0E,$D1,$D4,$06,$E4,$E7,$03,$68
        .BYTE $11,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$02,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<f18C8,>f18C8
        .BYTE $00,$00,$04,$05,$00,$04,$10,$00
f1168 = $1168
        .BYTE $04,$E7,$E8,$00,$E7,$E8,$01,$90
        .BYTE $11,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$F8,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<f18C8,>f18C8
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
f1190 = $1190
        .BYTE $04,$E7,$E8,$00,$E7,$E8,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <nullPtr,>nullPtr,$08,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<f18C8,>f18C8
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
planet1Level12Data = $11B8
        .BYTE $09,$30,$31,$02,$F9,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$21,$01,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<f11B8,>f11B8
        .BYTE <f11E0,>f11E0,<f18C8,>f18C8
        .BYTE $00,$00,$03,$02,$00,$04,$20,$00
f11E0 = $11E0
        .BYTE $07,$30,$31,$00,$FB,$FC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$26,$00,$03,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1208,>f1208
        .BYTE <nullPtr,>nullPtr,<spinningRings,>spinningRings
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f1208 = $1208
        .BYTE $06,$E8,$EC,$01,$E8,$EC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <f18C8,>f18C8,$00,$00,$02,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$05,$00,$00,$00,$00
planet3Level9Data = $1230
        .BYTE $06,$31,$35,$05,$31,$35,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$0C
        .BYTE <f1258,>f1258,$00,$00,$01,$02,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<f18C8,>f18C8
        .BYTE $00,$00,$03,$05,$00,$04,$18,$00
f1258 = $1258
        .BYTE $0C,$23,$27,$02,$23,$27,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <planet3Level9Data,>planet3Level9Data,$80,$80,$80,$80,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f18C8,>f18C8,<f18C8,>f18C8
        .BYTE $00,$00,$00,$03,$00,$00,$00,$00
f1280 = $1280
        .BYTE $00,$3B,$3E,$03,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$E0
        .BYTE <f12A8,>f12A8,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f12A8,>f12A8,<f18C8,>f18C8
        .BYTE $00,$00,$02,$01,$00,$04,$08,$00
f12A8 = $12A8
        .BYTE $02,$3B,$3E,$01,$3B,$3E,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$08
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,$00,$00,$01,$01,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f18C8,>f18C8,<f18C8,>f18C8
        .BYTE $00,$00,$01,$20,$00,$00,$00,$00
f12D0 = $12D0
        .BYTE $00,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$23,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<f12D0,>f12D0
        .BYTE <f12F8,>f12F8,<f18C8,>f18C8
        .BYTE $00,$00,$01,$02,$00,$04,$28,$00
f12F8 = $12F8
        .BYTE $0B,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$25,$01,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<secondExplosionAnimation,>secondExplosionAnimation
        .BYTE <f18C8,>f18C8,<f18C8,>f18C8
        .BYTE $00,$00,$00,$0F,$00,$00,$00,$00
f1320 = $1320
        .BYTE $0E,$D3,$D4,$00,$D3,$D4,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$0C,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1348,>f1348,<f18C8,>f18C8
        .BYTE $00,$00,$04,$01,$00,$04,$10,$00
f1348 = $1348
        .BYTE $0E,$C8,$CC,$03,$DC,$DF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$80
        .BYTE <spinningRings,>spinningRings,$00,$25,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1208,>f1208,<f18C8,>f18C8
        .BYTE $00,$00,$00,$01,$00,$00,$00,$00
f1370 = $1370
        .BYTE $11,$FC,$FF,$03,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$05,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1398,>f1398,<f1398,>f1398
        .BYTE $00,$00,$02,$02,$00,$04,$20,$00
f1398 = $1398
        .BYTE $10,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <spinningRings,>spinningRings,$00,$22,$01,$01,$80,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
f13C0 = $13C0
        .BYTE $06,$FC,$FF,$05,$FC,$FF,$03,$70
        .BYTE $13,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FA,$00,$01,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1370,>f1370,<f1370,>f1370
        .BYTE $00,$00,$00,$08,$00,$04,$10,$00
f13E8 = $13E8
        .BYTE $0B,$3E,$40,$04,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$24,$02,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<f13E8,>f13E8
        .BYTE <f1410,>f1410,<f1410,>f1410
        .BYTE $00,$00,$04,$02,$00,$04,$20,$00
f1410 = $1410
        .BYTE $11,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$18
        .BYTE <f1E58,>f1E58,$00,$24,$00,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$05,$00,$00,$00,$00
f1438 = $1438
        .BYTE $05,$FC,$FF,$06,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$E0
        .BYTE <f13C0,>f13C0,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f18C8,>f18C8,<f18C8,>f18C8
        .BYTE $00,$00,$00,$08,$00,$04,$08,$00
f1460 = $1460
        .BYTE $07,$21,$23,$03,$DB,$DD,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$23,$02,$02,$18,$23
        .BYTE <f1800,>f1800,<f1460,>f1460
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $88,$14,$00,$04,$00,$04,$08,$00
f1488 = $1488
        .BYTE $0B,$21,$22,$00,$DB,$DC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f1460,>f1460,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f14B0 = $14B0
        .BYTE $11,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$80,$80,$80,$80,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f14D8,>f14D8,<f18C8,>f18C8
        .BYTE $00,$00,$00,$10,$00,$04,$18,$00
f14D8 = $14D8
        .BYTE $00,$2F,$30,$00,$2F,$30,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f14B0,>f14B0,$00,$24,$02,$02,$01,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<f18C8,>f18C8
        .BYTE $00,$00,$05,$06,$00,$00,$00,$00
f1500 = $1500
        .BYTE $08,$30,$31,$00,$30,$31,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$20,$00,$01,$00,$00
        .BYTE <f18C8,>f18C8,<nullPtr,>nullPtr
        .BYTE <lickerShipWaveData,>lickerShipWaveData,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$03,$03,$00,$04,$18,$00
f1528 = $1528
        .BYTE $05,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$00,$02,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<f18C8,>f18C8
        .BYTE $00,$00,$06,$03,$00,$04,$18,$00
f1550 = $1550
        .BYTE $11,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f1528,>f1528,$00,$00,$01,$01,$01,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <secondExplosionAnimation,>secondExplosionAnimation,<f18C8,>f18C8
        .BYTE $00,$00,$02,$02,$00,$00,$00,$00
f1578 = $1578
        .BYTE $02,$C1,$C7,$04,$D4,$DC,$01,$C8
        .BYTE $15,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FD,$24,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1578,>f1578
        .BYTE <f15A0,>f15A0,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$01,$00,$04,$30,$00
f15A0 = $15A0
        .BYTE $02,$C1,$C7,$04,$D4,$DC,$01,$C8
        .BYTE $15,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$03,$23,$01,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f15A0,>f15A0
        .BYTE <f1578,>f1578,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$01,$00,$00,$00,$00
f15C8 = $15C8
        .BYTE $11,$FC,$FF,$01,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$C0
        .BYTE <f18C8,>f18C8,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f18C8,>f18C8,<f18C8,>f18C8
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
f15F0 = $15F0
        .BYTE $00,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1618,>f1618,<f18C8,>f18C8
        .BYTE $00,$00,$00,$08,$00,$04,$10,$00
f1618 = $1618
        .BYTE $11,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f1410,>f1410,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
f1640 = $1640
        .BYTE $04,$F6,$F8,$05,$F9,$FB,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FD,$21,$02,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1640,>f1640
        .BYTE <f1668,>f1668,<f18C8,>f18C8
        .BYTE $00,$00,$00,$08,$00,$04,$20,$00
f1668 = $1668
        .BYTE $10,$F8,$F9,$00,$FB,$FC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f1A98,>f1A98,$00,$25,$01,$01,$01,$23
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$08,$00,$00,$00,$00
f1690 = $1690
        .BYTE $06,$23,$27,$04,$23,$27,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$0C
        .BYTE <f1690,>f1690,$00,$00,$01,$02,$10,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f16B8,>f16B8,<f18C8,>f18C8
        .BYTE $00,$00,$03,$02,$00,$04,$18,$00
f16B8 = $16B8
        .BYTE $11,$23,$24,$00,$23,$24,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f16E0,>f16E0,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
f16E0 = $16E0
        .BYTE $00,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <spinningRings,>spinningRings,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$10,$00,$00,$00,$00
f1708 = $1708
        .BYTE $0E,$FC,$FF,$04,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f1730,>f1730,$00,$00,$01,$00,$01,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$04,$20,$00
f1730 = $1730
        .BYTE $0A,$FC,$FF,$02,$FC,$FF,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$20
        .BYTE <f1708,>f1708,$00,$00,$00,$01,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$02,$02,$00,$00,$00,$00
f1758 = $1758
        .BYTE $00,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1758,>f1758,<f1780,>f1780
        .BYTE $00,$00,$00,$00,$00,$04,$20,$00
f1780 = $1780
        .BYTE $11,$FF,$00,$00,$FF,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f1208,>f1208,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<nullPtr,>nullPtr
        .BYTE $00,$00,$03,$03,$00,$00,$00,$00
f17A8 = $17A8
        .BYTE $11,$3E,$40,$04,$3E,$40,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$80,$25,$80,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f17D0,>f17D0
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$04,$01,$00,$04,$20,$00
f17D0 = $17D0
        .BYTE $0B,$3E,$3F,$00,$3E,$3F,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$05
        .BYTE <f17A8,>f17A8,$00,$00,$01,$00,$01,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<lickerShipWaveData,>lickerShipWaveData
        .BYTE $00,$00,$04,$01,$00,$00,$00,$00

        .BYTE $00,$00,$00,$00,$00,$00,$00,$00

f1800 = $1800
        .BYTE $11,$21,$22,$00,$23,$24,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$FC,$23,$02,$02,$00,$23
        .BYTE <nullPtr,>nullPtr,<f1828,>f1828
        .BYTE <f1878,>f1878,<f18C8,>f18C8
        .BYTE $00,$00,$00,$05,$00,$04,$20,$00
f1828 = $1828
        .BYTE $07,$22,$23,$00,$24,$25,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$04
        .BYTE <f1800,>f1800,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f1878,>f1878,<f18C8,>f18C8
        .BYTE $00,$00,$00,$04,$00,$00,$00,$00
spinningRings = $1850
        .BYTE $11,$E8,$EC,$01,$E8,$EC,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$30
        .BYTE <f18C8,>f18C8,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<f18C8,>f18C8
        .BYTE $00,$00,$00,$00,$01,$00,$00,$00
f1878 = $1878
        .BYTE $03,$28,$29,$00,$28,$29,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$10
        .BYTE <f18A0,>f18A0,$01,$01,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <f18A0,>f18A0,<f18C8,>f18C8
        .BYTE $00,$00,$01,$02,$00,$00,$00,$00
f18A0 = $18A0
        .BYTE $04,$29,$2A,$00,$29,$2A,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$40
        .BYTE <f1878,>f1878,$04,$00,$01,$02,$00,$01
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <spinningRings,>spinningRings,<f18C8,>f18C8
        .BYTE $00,$00,$01,$02,$00,$00,$00,$00
f18C8 = $18C8
        .BYTE $07,$ED,$F0,$03,$ED,$F0,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$01,$0D
        .BYTE <nullPtr,>nullPtr,$80,$80,$01,$01,$00,$00
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE <nullPtr,>nullPtr,<nullPtr,>nullPtr
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
planet4Level19Data = $18F0
        .BYTE $06,$2A,$2B,$00,$2B,$2C,$01,$18
        .BYTE $19,$00,$00,$00,$00,$00,$00,$00
        .BYTE <nullPtr,>nullPtr,$01,$00,$01,$01,$00,$23
        .BYTE <nullPtr,>nullPtr,<planet4Level19Data,>planet4Level19Data
        .BYTE <spinningRings,>spinningRings,<f18C8,>f18C8
        .BYTE $BD,$BD,$BD,$BD,$BD

