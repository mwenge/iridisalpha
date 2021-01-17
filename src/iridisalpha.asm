;
; **** ZP ABSOLUTE ADRESSES **** 
;
a01 = $01
screenPtrLo = $02
screenPtrHi = $03
a06 = $06
a10 = $10
a11 = $11
a12 = $12
a13 = $13
a14 = $14
a15 = $15
a16 = $16
a17 = $17
a18 = $18
a1C = $1C
a1F = $1F
a20 = $20
a21 = $21
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
a29 = $29
a2A = $2A
a30 = $30
a31 = $31
screenPtrLo2 = $35
screenPtrHi2 = $36
a37 = $37
a3A = $3A
a3B = $3B
a3E = $3E
a40 = $40
a41 = $41
a42 = $42
a43 = $43
a44 = $44
a45 = $45
a46 = $46
a47 = $47
a4A = $4A
a4E = $4E
a4F = $4F
a68 = $68
a77 = $77
a78 = $78
a79 = $79
aA8 = $A8
lastKeyPressed = $C5
aE8 = $E8
aF0 = $F0
aF1 = $F1
aF8 = $F8
aF9 = $F9
aFA = $FA
aFB = $FB
aFC = $FC
aFD = $FD
aFE = $FE
aFF = $FF
;
; **** ZP POINTERS **** 
;
p10 = $10
p12 = $12
p14 = $14
p16 = $16
p22 = $22
p30 = $30
p3A = $3A
p40 = $40
p43 = $43
p45 = $45
p46 = $46
p4E = $4E
p78 = $78
pAD = $AD
pBF = $BF
pD0 = $D0
pF0 = $F0
pFC = $FC
pFD = $FD
pFE = $FE
;
; **** FIELDS **** 
;
f0000 = $0000
SCREEN_PTR_LO = $0340
SCREEN_PTR_HI = $0360
;
; **** POINTERS **** 
;
p0A = $000A
p20 = $0020
p27 = $0027
p0029 = $0029
SCREEN_RAM = $0400
;
; **** EXTERNAL JUMPS **** 
;
e00FD = $00FD

.include "padding1.asm"

;        * = $0801
;        .BYTE $0C,$08,$0A,$00,$9E,$32,$30,$36,$34,$00

        * = $0810

;-------------------------------
; j0810
;-------------------------------
j0810   
        LDA #$00
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA a0864
        STA aAAE1
        LDA aAAD2
        BEQ b082F
        JMP j0D30

b082F   LDX #$F8
        JSR s15C6
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        JSR InitializeSpritesAndInterrupts
        JMP j08B8

        .BYTE $00,$06,$02,$04,$05,$03,$07,$01
        .BYTE $01,$07,$03,$05,$04,$02,$06
f0853   .BYTE $00
f0854   .BYTE $02,$08,$07,$05,$0E,$04,$06,$0B
        .BYTE $0B,$06,$04,$0E,$05,$07,$08,$02
a0864   .BYTE $02
;-------------------------------
; InitializeSpritesAndInterrupts
;-------------------------------
InitializeSpritesAndInterrupts   
        LDA #$00
        SEI 
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA a4001
        JSR ClearScreen2
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA $D016    ;VIC Control Register 2
        AND #$E7
        ORA #$08
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D027    ;Sprite 0 Color
        LDA #$FF
        STA $D015    ;Sprite display Enable
        LDA #$C0
        STA SCREEN_RAM + $03FF
        LDA #$80
        STA $D01B    ;Sprite to Background Display Priority
        LDA #<p08EE
        STA $0314    ;IRQ
        LDA #>p08EE
        STA $0315    ;IRQ
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$10
        STA $D012    ;Raster Position
        CLI 
        RTS 

;-------------------------------
; j08B8
;-------------------------------
j08B8   
        LDA #$0B
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JSR s0A71
        JSR s0CE6
b08CB   JSR s1651
        LDA a0864
        CMP #$04
        BEQ b08E2
        LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BNE b08CB
        LDA #$00
        STA aAAE0
        RTS 

b08E2   LDA #$FF
        STA aAAE0
b08E7   LDA lastKeyPressed
        CMP #$40
        BNE b08E7
        RTS 

p08EE   LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b090F
;-------------------------------
; j08F5
;-------------------------------
j08F5   
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

;-------------------------------
; ClearScreen2
;-------------------------------
ClearScreen2   
        LDX #$00
        LDA #$20
b08FF   STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02F8,X
        DEX 
        BNE b08FF
        RTS 

b090F   LDY a09EC
        CPY #$0C
        BNE b091E
        JSR s0B5A
        LDY #$10
        STY a09EC
b091E   LDA f0990,Y
        BNE b0947
        JSR s0A4A
        LDA #$00
        STA a09EC
        LDA #$10
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR s0AC6
        JSR s0B2D
        JSR s0BC1
        JSR s14FE
        JMP jEA31

b0947   STA $D00F    ;Sprite 7 Y Pos
        LDA f09AF,Y
        STA $D00E    ;Sprite 7 X Pos
        LDA f09CD,Y
        AND #$01
        STA a06
        BEQ b095D
        LDA #$80
        STA a06
b095D   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$7F
        ORA a06
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f0991,Y
        SEC 
        SBC #$01
        STA $D012    ;Raster Position
        LDA f09ED,Y
        TAX 
        LDA f0853,X
        STA $D02E    ;Sprite 7 Color
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        INC a09EC
        JMP j08F5

f0990   .BYTE $48
f0991   .BYTE $4E,$54,$5A
        .BYTE $60,$66,$6C,$72,$78,$7E,$84,$8A
        .BYTE $90,$96,$9C,$A2,$A8,$AE,$B4,$BA
        .BYTE $C0,$C6,$CC,$D2,$D8,$DE,$E4,$EA
        .BYTE $F0,$F6
f09AE   .BYTE $00
f09AF   .BYTE $3A,$1A,$C4,$1B,$94,$7B,$96,$5D
        .BYTE $4F,$B5,$18,$C7,$E1,$EB,$4A,$8F
        .BYTE $DA,$83,$6A,$B0,$FC,$68,$04,$10
        .BYTE $06,$A7,$B8,$19,$BB
f09CC   .BYTE $E4
f09CD   .BYTE $02,$02,$00,$03,$05,$02,$02,$01
        .BYTE $01,$01,$03,$01,$00,$01,$03,$01
        .BYTE $01,$04,$02,$01,$00,$01,$02,$01
        .BYTE $02,$01,$00,$01,$02,$02,$01
a09EC   .BYTE $00
f09ED   .BYTE $03,$06,$07,$02,$01,$05,$03,$08
        .BYTE $04,$03,$02,$08,$06,$04,$02,$04
        .BYTE $06,$01,$07,$07,$05,$03,$02,$05
        .BYTE $07,$03,$06,$08,$05,$03,$06,$08
        .BYTE $07,$06,$03,$05,$06,$08,$06,$04
f0A15   .BYTE $06,$01,$03,$02,$01,$01,$01,$01
        .BYTE $07,$02,$03,$02,$07,$02,$03,$02
        .BYTE $03,$02,$01,$03,$04,$01,$02,$01
        .BYTE $02,$03,$02,$01,$06,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01
f0A3F   .BYTE $07
f0A40   .BYTE $05,$0E,$00,$02
a0A44   .BYTE $08
a0A45   .BYTE $04,$01,$0F,$0C,$0B
;-------------------------------
; s0A4A
;-------------------------------
s0A4A   
        LDX #$1E
        LDA #$00
        STA a21
b0A50   DEC f0A15,X
        BNE b0A6D
        LDA a09EC,X
        STA f0A15,X
        LDA f09AE,X
        CLC 
        ADC a0A45
        STA f09AE,X
        LDA f09CC,X
        ADC #$00
        STA f09CC,X
b0A6D   DEX 
        BNE b0A50
        RTS 

;-------------------------------
; s0A71
;-------------------------------
s0A71   
        LDX #$28
        LDA #$00
        STA a0B2C
b0A78   LDA #$02
        STA fD877,X
        LDA #$08
        STA fD89F,X
        LDA #$07
        STA fD8C7,X
        LDA #$05
        STA fD8EF,X
        LDA #$0E
        STA fD917,X
        LDA #$04
        STA fD93F,X
        LDA #$06
        STA fD967,X
        LDA #$00
        STA SCREEN_RAM + $0077,X
        STA SCREEN_RAM + $009F,X
        STA SCREEN_RAM + $00C7,X
        STA SCREEN_RAM + $00EF,X
        STA SCREEN_RAM + $0117,X
        STA SCREEN_RAM + $013F,X
        STA SCREEN_RAM + $0167,X
        DEX 
        BNE b0A78
        LDX #$06
b0AB7   LDA f0853,X
        STA f0A3F,X
        DEX 
        BNE b0AB7
        LDA #$01
        STA a0B2C
        RTS 

;-------------------------------
; s0AC6
;-------------------------------
s0AC6   
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$80
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDX #$06
b0AD0   LDA f0B25,X
        STA SCREEN_RAM + $03F7,X
        TXA 
        ASL 
        TAY 
        LDA f0B19,X
        STA fCFFE,Y
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA f0B1F,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA #$40
        STA fCFFF,Y
        DEX 
        BNE b0AD0
        LDA #$3F
        STA $D01C    ;Sprites Multi-Color Mode Select
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        LDA #$FF
        STA $D00C    ;Sprite 6 X Pos
        LDA #$70
        STA $D00D    ;Sprite 6 Y Pos
        LDA #$0B
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$00
        STA $D026    ;Sprite Multi-Color Register 1
        LDA #$01
        STA $D02D    ;Sprite 6 Color
        LDA #$F5
        STA SCREEN_RAM + $03FE
f0B19   RTS 

        .BYTE $20,$50,$80,$B0,$E0
f0B1F   .BYTE $10,$00,$00,$00,$00,$00
f0B25   .BYTE $20,$F1,$F2,$F1,$F3,$F1,$F4
a0B2C   .BYTE $01
;-------------------------------
; s0B2D
;-------------------------------
s0B2D   
        LDA a0B2C
        BNE b0B34
b0B32   RTS 

a0B33   .BYTE $04
b0B34   DEC a0B33
        BNE b0B32
        LDA #$04
        STA a0B33
        LDX #$00
        LDA f0A3F
        PHA 
b0B44   LDA f0A40,X
        STA $D027,X  ;Sprite 0 Color
        STA f0A3F,X
        INX 
        CPX #$06
        BNE b0B44
        PLA 
        STA a0A44
        STA $D02C    ;Sprite 5 Color
        RTS 

;-------------------------------
; s0B5A
;-------------------------------
s0B5A   
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$01
        STA $D026    ;Sprite Multi-Color Register 1
        LDA #$00
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        LDA #$7F
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDX #$00
b0B73   TXA 
        ASL 
        TAY 
        LDA f0BB3,X
        ASL 
        STA $D000,Y  ;Sprite 0 X Pos
        BCC b0B8B
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA f0C0F,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JMP j0B94

b0B8B   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND f0C16,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
;-------------------------------
; j0B94
;-------------------------------
j0B94   
        LDA f0BAC,X
        STA $D001,Y  ;Sprite 0 Y Pos
        LDA a0C1D
        STA SCREEN_RAM + $03F8,X
        LDA f0854,X
        STA $D027,X  ;Sprite 0 Color
        INX 
        CPX #$07
        BNE b0B73
        RTS 

f0BAC   .BYTE $B2,$B6,$BB,$C1,$D0,$C8,$C1
f0BB3   .BYTE $54,$58,$5C,$60,$64,$68,$6C
f0BBA   .BYTE $FC,$FB,$FA,$F9,$08,$07,$06
;-------------------------------
; s0BC1
;-------------------------------
s0BC1   
        LDX #$00
b0BC3   LDA f0BAC,X
        SEC 
        SBC f0BBA,X
        STA f0BAC,X
        DEC f0BBA,X
        LDA f0BBA,X
        CMP #$F8
        BNE b0BE1
        LDA #$08
        STA f0BBA,X
        LDA #$D0
        STA f0BAC,X
b0BE1   INC f0BB3,X
        LDA f0BB3,X
        CMP #$C0
        BNE b0BF0
        LDA #$08
        STA f0BB3,X
b0BF0   INX 
        CPX #$07
        BNE b0BC3
        DEC a1650
        BNE b0C0E
        LDA #$04
        STA a1650
        INC a0C1D
        LDA a0C1D
        CMP #$C8
        BNE b0C0E
        LDA #$C1
        STA a0C1D
b0C0E   RTS 

f0C0F   .BYTE $01,$02,$04,$08,$10,$20,$40
f0C16   .TEXT $FE, $FD, $FB, $F7, $EF, $DF, $BF
a0C1D   .TEXT $C1, $C9, $D2, $C9, $C4, $C9, $D3, " ", $C1, $CC, $D0, $C8, $C1, ".....  HARD AND FAST ZAPPIN"
f0C45   .TEXT "GPRESS FIRE TO BEGIN PLAY.. ONCE STARTED"
f0C6D   .TEXT ",", $C6, "1 ", $C6, $CF, $D2, " ", $D0, $C1, $D5, $D3, $C5, " ", $CD, $CF, $C4, $C5, "     ", $D1, " ", $D4, $CF, " ", $D1, $D5, $C9, $D4, " ", $D4, $C8, $C5, " GAM"
f0C95   .TEXT "ECREATED BY JEFF MINTER...SPACE EASY/HAR"
f0CBD   .TEXT "DLAST GILBY HIT 0000000; MODE IS NOW EAS"
        .TEXT "Y"
;-------------------------------
; s0CE6
;-------------------------------
s0CE6   
        LDX #$28
b0CE8   LDA a0C1D,X
        AND #$3F
        STA SCREEN_RAM + $01DF,X
        LDA f0C45,X
        AND #$3F
        STA SCREEN_RAM + $022F,X
        LDA f0C6D,X
        AND #$3F
        STA SCREEN_RAM + $027F,X
        LDA f0C95,X
        AND #$3F
        STA SCREEN_RAM + $02CF,X
        LDA f0CBD,X
        AND #$3F
        STA SCREEN_RAM + $031F,X
        LDA #$0C
        STA fD9DF,X
        STA fDA2F,X
        STA fDA7F,X
        STA fDACF,X
        STA fDB1F,X
        DEX 
        BNE b0CE8
        LDX #$06
b0D26   LDA fC803,X
        STA SCREEN_RAM + $032F,X
        DEX 
        BPL b0D26
        RTS 

;-------------------------------
; j0D30
;-------------------------------
j0D30   
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$00
        STA a1126
        JSR s0D40
        JMP InitializeSpritesMain

;-------------------------------
; s0D40
;-------------------------------
s0D40   
        SEI 
        LDA #$34
        STA a01
        LDX #$00
b0D47   LDA fE400,X
        PHA 
        LDA f3040,X
        STA fE400,X
        PLA 
        STA f3040,X
        DEX 
        BNE b0D47
        LDA #$36
        STA a01
        RTS 

;-------------------------------
; InitializeSpritesMain
;-------------------------------
InitializeSpritesMain   
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$FF
        STA $D015    ;Sprite display Enable
        STA $D01B    ;Sprite to Background Display Priority
        LDA #$00
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        LDA #$3F
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDA #$01
        STA $D02D    ;Sprite 6 Color
        STA $D026    ;Sprite Multi-Color Register 1
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$0B
        STA $D02E    ;Sprite 7 Color
        JSR ClearScreenMain
        JMP j0DBC

;-------------------------------
; ClearScreenMain
;-------------------------------
ClearScreenMain   
        LDX #$00
b0D9C   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0300,X
        LDA #$0E
        STA fD800,X
        STA fD900,X
        STA fDA00,X
        STA fDB00,X
        DEX 
        BNE b0D9C
        RTS 

;-------------------------------
; j0DBC
;-------------------------------
j0DBC   
        JSR s0DCF
        JSR s1203
        JSR s104D
        CLI 
b0DC6   LDA a1126
        BEQ b0DC6
        JSR s0D40
        RTS 

;-------------------------------
; s0DCF
;-------------------------------
s0DCF   
        SEI 
        LDA #<InterruptHandler2
        STA $0314    ;IRQ
        LDA #>InterruptHandler2
        STA $0315    ;IRQ
        LDA #$00
        STA a0DF6
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$30
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        CLI 
        RTS 

a0DF6   .BYTE $00
;-------------------------------
; InterruptHandler2
;-------------------------------
InterruptHandler2   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b0E04
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

b0E04   JMP UpdateSpritePositions

a0E07   .BYTE $00

;-------------------------------
; UpdateSpritePositions
;-------------------------------
UpdateSpritePositions   
        LDX a0E07
        LDY a0F6D
        TYA 
        STA a40
        CLC 
        ASL 
        TAY 
        LDA f0EDB,X
        STA fCFFE,Y
        LDA f0F03,X
        STA fCFFF,Y
        STA $D005,Y  ;Sprite 2 Y Pos
        STA $D00F    ;Sprite 7 Y Pos
        STA $D00D    ;Sprite 6 Y Pos
        INC f1127,X
        LDA f1127,X
        STA $D00C    ;Sprite 6 X Pos
        LDA a41
        AND #$01
        BEQ b0E3B
        INC f113F,X
b0E3B   LDA f113F,X
        STA $D00E    ;Sprite 7 X Pos
        TXA 
        PHA 
        CLC 
        ADC a0F6E
        CMP #$27
        BMI b0E4E
        SEC 
        SBC #$27
b0E4E   TAX 
        LDA f0EDB,X
        STA $D004,Y  ;Sprite 2 X Pos
        PLA 
        TAX 
        LDY a0F6D
        STX a40
        LDX a0F6C
a0E60   =*+$01
a0E61   =*+$02
        LDA f0F1C,X
        STA $D026,Y  ;Sprite Multi-Color Register 1
        INX 
a0E67   =*+$01
a0E68   =*+$02
        LDA f0F1C,X
        CMP #$FF
        BNE b0E6F
        LDX #$00
b0E6F   STX a0F6C
        LDX a0F6B
a0E76   =*+$01
a0E77   =*+$02
        LDA f0F23,X
        STA $D029,Y  ;Sprite 2 Color
        INX 
a0E7D   =*+$01
a0E7E   =*+$02
        LDA f0F23,X
        CMP #$FF
        BNE b0E85
        LDX #$00
b0E85   STX a0F6B
        LDX a40
        INX 
        INY 
        CPY #$04
        BNE b0E92
        LDY #$01
b0E92   STY a0F6D
        STX a0E07
        LDA f0F03,X
        CMP #$FF
        BNE b0EC7
        LDX #$00
        STX a0E07
        JSR s0F7C
        JSR s100B
        DEC a41
        JSR s115B
        LDA #$01
        STA a0F6D
        LDA #$2E
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JMP jEA31

        LDX a0E07
b0EC7   LDA f0F03,X
        SEC 
        SBC #$02
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        .BYTE $4C,$FE
f0EDA   .BYTE $0D
f0EDB   .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
        .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
        .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f0F03   .BYTE $30,$38,$40,$48,$50,$58,$60,$68
        .BYTE $70,$78,$80,$88,$90,$98,$A0,$A8
        .BYTE $B0,$B8,$C0,$C8,$D0,$D8,$E0,$E8
        .BYTE $FF
f0F1C   .BYTE $02,$08,$07,$05,$04,$06,$FF
f0F23   .BYTE $0B,$0C,$0F,$01,$0F,$0C,$FF
f0F2A   .BYTE $40,$46,$4C,$53,$58,$5E,$63,$68
        .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
        .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
        .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
        .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
        .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
        .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
        .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
        .BYTE $FF
a0F6B   .BYTE $00
a0F6C   .BYTE $00
a0F6D   .BYTE $01
a0F6E   .BYTE $05
;-------------------------------
; s0F6F
;-------------------------------
s0F6F   
        LDX #$27
b0F71   LDA f0EDA,X
        STA f0EDB,X
        DEX 
        BNE b0F71
        RTS 

a0F7B   .BYTE $00
;-------------------------------
; s0F7C
;-------------------------------
s0F7C   
        DEC a0FC8
        BNE b0F8A
        LDA a0FC7
        STA a0FC8
        JSR s0F6F
p0F8C   =*+$02
b0F8A   JSR s11CF
        DEC a0FC5
        BNE b0FC3
        LDA a0FC6
        STA a0FC5
        LDX a0F7B
        LDA f0F2A,X
        STA a42
        LDY a11CD
        BEQ b0FA9
        CLC 
        ROR 
        STA a42
b0FA9   LDA a11CE
        CLC 
        ADC a42
        STA f0EDB
        TXA 
        CLC 
        ADC a0FC4
        TAX 
        CPX #$40
        BMI b0FC0
        SEC 
        SBC #$40
        TAX 
b0FC0   STX a0F7B
b0FC3   RTS 

a0FC4   .BYTE $02
a0FC5   .BYTE $01
a0FC6   .BYTE $05
a0FC7   .BYTE $01
a0FC8   .BYTE $01
a0FC9   .BYTE $11
a0FCA   .BYTE $00
f0FCB   .BYTE $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
        .BYTE $08,$07,$06,$05,$04,$03,$02,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
f0FEB   .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$02,$03,$04,$05,$06,$07,$08
        .BYTE $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
;-------------------------------
; s100B
;-------------------------------
s100B   
        LDA a0FCA
        CMP #$40
        BEQ b1018
        LDA lastKeyPressed
        STA a0FCA
        RTS 

b1018   LDA lastKeyPressed
        STA a0FCA
        CMP #$0C
        BNE b1027
        DEC a0FC9
        JMP s104D

b1027   CMP #$17
        BNE b1031
        INC a0FC9
        JMP s104D

b1031   CMP #$0A
        BNE b1043
        INC a0FC7
;-------------------------------
; j1038
;-------------------------------
j1038   
        LDA a0FC7
        AND #$0F
        STA a0FC8
        JMP j12CB

b1043   CMP #$0D
        BNE b107A
        DEC a0FC7
        JMP j1038

;-------------------------------
; s104D
;-------------------------------
s104D   
        LDA a0FC9
        AND #$1F
        TAX 
        LDA f0FCB,X
        STA a0FC6
        STA a0FC5
        LDA f0FEB,X
        STA a0FC4
        LDA a1125
        AND #$1F
        TAX 
        LDA f0FCB,X
        STA a11CA
        STA a11CB
        LDA f0FEB,X
        STA a11CC
        JMP j12CB

b107A   CMP #$3E
        BNE b108C
        INC a0F6E
        LDA a0F6E
        AND #$0F
        STA a0F6E
        JMP j12CB

b108C   CMP #$14
        BNE b1096
        DEC a1125
        JMP s104D

b1096   CMP #$1F
        BNE b10A0
        INC a1125
        JMP s104D

b10A0   CMP #$3C
        BNE b10B7
        LDA a1341
        EOR #$01
        STA a1341
        BEQ b10B4
        JSR s1203
        JMP j12CB

b10B4   JMP ClearScreenMain

b10B7   CMP #$04
        BNE b10C6
        LDA a11CD
        EOR #$01
        STA a11CD
        JMP j12CB

b10C6   CMP #$06
        BNE b10F2
        INC a1388
        LDA a1388
        CMP #$08
        BNE b10D9
        LDA #$00
        STA a1388
b10D9   TAX 
        LDA f1378,X
        STA a0E67
        STA a0E60
        LDA f1380,X
        STA a0E68
        STA a0E61
        LDA #$00
        STA a0F6C
        RTS 

b10F2   CMP #$03
        BNE b111D
        INC a1389
        LDA a1389
        CMP #$08
        BNE b1105
        LDA #$00
        STA a1389
b1105   TAX 
        LDA f1378,X
        STA a0E7D
        STA a0E76
        LDA f1380,X
        STA a0E7E
        STA a0E77
        LDA #$00
        STA a0F6B
b111D   CMP #$31
        BNE b1124
        INC a1126
b1124   RTS 

a1125   .BYTE $12
a1126   .BYTE $00
f1127   .BYTE $4E,$05,$66,$FD,$12,$28,$CC,$87
        .BYTE $37,$93,$F5,$3B,$09,$9D,$A8,$7D
        .BYTE $DD,$67,$20,$C4,$AA,$35,$02,$74
f113F   .BYTE $94,$E2,$33,$38,$C6,$DF,$23,$42
        .BYTE $71,$12,$29,$67,$7F,$EA,$A9,$34
        .BYTE $A5,$81,$01,$4C,$29,$36,$55
        .BYTE $98
a1157   .BYTE $00
a1158   .BYTE $01
a1159   .BYTE $04
a115A   .BYTE $01
;-------------------------------
; s115B
;-------------------------------
s115B   
        DEC a115A
        BNE b1181
        LDA #$05
        STA a115A
        LDX a11C9
        LDA f1342,X
        STA $D025    ;Sprite Multi-Color Register 0
        INX 
        LDA f1342,X
        BPL b1176
        LDX #$00
b1176   STX a11C9
        LDA #$C0
        STA SCREEN_RAM + $03FF
        STA SCREEN_RAM + $03FE
b1181   DEC a1158
        BNE b11C7
        LDA #$05
        STA a1158
        LDA a1157
        CLC 
        ADC #$C1
        STA SCREEN_RAM + $03F8
        STA SCREEN_RAM + $03F9
        STA SCREEN_RAM + $03FA
        LDA a1159
        CLC 
        ADC #$C1
        STA SCREEN_RAM + $03FB
        STA SCREEN_RAM + $03FC
        STA SCREEN_RAM + $03FD
        INC a1157
        LDA a1157
        CMP #$04
        BNE b11B8
        LDA #$00
        STA a1157
b11B8   DEC a1159
        LDA a1159
        CMP #$FF
        BNE b11C7
        LDA #$03
        STA a1159
b11C7   RTS 

a11C8   .BYTE $00
a11C9   .BYTE $00
a11CA   .BYTE $03
a11CB   .BYTE $03
a11CC   .BYTE $01
a11CD   .BYTE $01
a11CE   .BYTE $00
;-------------------------------
; s11CF
;-------------------------------
s11CF   
        LDA a11CD
        BNE b11DA
        LDA #$40
        STA a11CE
b11D9   RTS 

b11DA   DEC a11CB
        BNE b11D9
        LDA a11CA
        STA a11CB
        LDX a11C8
        LDA f0F2A,X
        CLC 
        ROR 
        CLC 
        ADC #$40
        STA a11CE
        TXA 
        CLC 
        ADC a11CC
        CMP #$40
        BMI b11FF
        SEC 
        SBC #$40
b11FF   STA a11C8
        RTS 

;-------------------------------
; s1203
;-------------------------------
s1203   
        LDX #$07
b1205   LDA f1263,X
        AND #$3F
        STA SCREEN_RAM + $0048,X
        LDA f126B,X
        AND #$3F
        STA SCREEN_RAM + $0070,X
        LDA f1273,X
        AND #$3F
        STA SCREEN_RAM + $00C0,X
        LDA f127B,X
        AND #$3F
        STA SCREEN_RAM + $0110,X
        LDA f1283,X
        AND #$3F
        STA SCREEN_RAM + $0138,X
        LDA f128B,X
        AND #$3F
        STA SCREEN_RAM + $0188,X
        LDA f1293,X
        AND #$3F
        STA SCREEN_RAM + $01B0,X
        LDA f129B,X
        AND #$3F
        STA SCREEN_RAM + $0200,X
        LDA f12A3,X
        AND #$3F
        STA SCREEN_RAM + $0228,X
        LDA f12AB,X
        AND #$3F
        STA SCREEN_RAM + $02C8,X
        LDA f12B3,X
        AND #$3F
        STA SCREEN_RAM + $02F0,X
        DEX 
        BNE b1205
        JMP j1439

f1263   .TEXT " SPEED:F"
f126B   .TEXT "  <A S> "
f1273   .TEXT " WAVE 1 "
f127B   .TEXT " FREQ: F"
f1283   .TEXT "  <Z X> "
f128B   .TEXT " WAVE 2 "
f1293   .TEXT " ON   F1"
f129B   .TEXT " FREQ: F"
f12A3   .TEXT "  <C V> "
f12AB   .TEXT " PHASE:F"
f12B3   .TEXT "   Q>>  "
f12BB   .TEXT "0123456789ABCDEF"
;-------------------------------
; j12CB
;-------------------------------
j12CB   
        LDA a1341
        BNE b12D6
        INC a1341
        JSR s1203
b12D6   LDA #$20
        STA SCREEN_RAM + $0116
        STA SCREEN_RAM + $0206
        LDA a0FC9
        AND #$10
        BEQ b12EA
        LDA #$31
        STA SCREEN_RAM + $0116
b12EA   LDA a0FC9
        AND #$0F
        TAX 
        LDA f12BB,X
        AND #$3F
        STA SCREEN_RAM + $0117
        LDA a1125
        AND #$10
        BEQ b1304
        LDA #$31
        STA SCREEN_RAM + $0206
b1304   LDA a1125
        AND #$0F
        TAX 
        LDA f12BB,X
        AND #$3F
        STA SCREEN_RAM + $0207
        LDX a0FC7
        LDA f12BB,X
        AND #$3F
        STA SCREEN_RAM + $004F
        LDX a0F6E
        LDA f12BB,X
        AND #$3F
        STA SCREEN_RAM + $02CF
        LDA a11CD
        BNE b1336
        LDA #$06
        STA SCREEN_RAM + $01B2
        STA SCREEN_RAM + $01B3
        RTS 

b1336   LDA #<p200E
        STA SCREEN_RAM + $01B2
        LDA #>p200E
        STA SCREEN_RAM + $01B3
        RTS 

a1341   .BYTE $01
f1342   .BYTE $06,$02,$04,$05,$03,$07,$01,$07
        .BYTE $03,$05,$04,$02,$06,$FF,$06,$05
        .BYTE $0E,$0D,$03,$FF,$09,$08,$07,$08
        .BYTE $09,$FF,$00,$00,$00,$02,$00,$00
        .BYTE $07,$FF,$01,$0F,$0D,$0C,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
        .BYTE $06,$0E,$0B,$02,$05,$FF
f1378   .BYTE $1C,$23,$42,$50,$56,$5C,$64,$72
f1380   .BYTE $0F,$0F,$13,$13,$13,$13,$13,$13
a1388   .BYTE $00
a1389   .BYTE $01
        .TEXT "    % % %  DNA  % % %   "
f13A2   .TEXT " CONCEIVED AND EXECUTED B"
f13BB   .TEXT "Y            Y A K       "
f13D4   .TEXT " SPACE: CANCEL SCREEN TEX"
f13ED   .TEXT "TF5 AND F7 CHANGE COLOURS"
f1406   .TEXT " LISTEN TO TALKING HEADS."
f141F   .TEXT ".BE NICE TO HAIRY ANIMALS "
;-------------------------------
; j1439
;-------------------------------
j1439   
        LDX #$19
b143B   LDA a1389,X
        AND #$3F
        STA SCREEN_RAM + $002B,X
        LDA f13A2,X
        AND #$3F
        STA SCREEN_RAM + $00A3,X
        LDA f13BB,X
        AND #$3F
        STA SCREEN_RAM + $011B,X
        LDA f13D4,X
        AND #$3F
        STA SCREEN_RAM + $020B,X
        LDA f13ED,X
        AND #$3F
        STA SCREEN_RAM + $025B,X
        LDA f1406,X
        AND #$3F
        STA SCREEN_RAM + $034B,X
        LDA f141F,X
        AND #$3F
        STA SCREEN_RAM + $039B,X
        DEX 
        BNE b143B
        RTS 

f1477   .BYTE $08,$08,$09,$09,$0A,$0B,$0B,$0C
        .BYTE $0D,$0E,$0E,$0F,$10,$11,$12,$13
        .BYTE $15,$16,$17,$19,$1A,$1C,$1D,$1F
        .BYTE $21,$23,$25,$27,$2A,$2C,$2F,$32
        .BYTE $35,$38,$3B,$3F,$43,$47,$4B,$4F
        .BYTE $54,$59,$5E,$64,$6A,$70,$77,$7E
        .BYTE $86,$8E,$96,$9F,$A8,$B3,$BD,$C8
        .BYTE $D4,$E1,$EE,$FD
f14B3   .BYTE $61,$E1,$68,$F7,$8F,$30,$DA,$8F
        .BYTE $4E,$18,$EF,$D2,$C3,$C3,$D1,$EF
        .BYTE $1F,$60,$B5,$1E,$9C,$31,$DF,$A5
        .BYTE $87,$86,$A2,$DF,$3E,$C1,$6B,$3C
        .BYTE $39,$63,$BE,$4B,$0F,$0C,$45,$BF
        .BYTE $7D,$83,$D6,$79,$73,$C7,$7C,$97
        .BYTE $1E,$18,$8B,$7E,$FA,$06,$AC,$F3
        .BYTE $E6,$8F,$F8,$2E
f14EF   .BYTE $00,$07,$0C,$07
a14F3   .BYTE $01
a14F4   .BYTE $01
a14F5   .BYTE $25
a14F6   .BYTE $85
a14F7   .BYTE $00
a14F8   .BYTE $01
a14F9   .BYTE $02
a14FA   .BYTE $02
a14FC   =*+$01
a14FD   =*+$02
a14FB   ASL a0E07
;-------------------------------
; s14FE
;-------------------------------
s14FE   
        DEC a164E
        BEQ b1504
        RTS 

b1504   LDA a164F
        STA a164E
        DEC a14F6
        BNE b152C
        LDA #$C0
        STA a14F6
        INC a0864
        LDX a14FA
        LDA f14EF,X
        STA a14FC
        INX 
        TXA 
        AND #$03
        STA a14FA
        BNE b152C
        JSR s1620
b152C   DEC a14F5
        BNE b154E
        LDA #$30
        STA a14F5
        LDX a14F9
        LDA f14EF,X
        CLC 
        ADC a14FC
        TAY 
        STY a14FB
        JSR s1590
        INX 
        TXA 
        AND #$03
        STA a14F9
b154E   DEC a14F4
        BNE b1570
        LDA #$0C
        STA a14F4
        LDX a14F8
        LDA f14EF,X
        CLC 
        ADC a14FB
        STA a14FD
        TAY 
        JSR s15A2
        INX 
        TXA 
        AND #$03
        STA a14F8
b1570   DEC a14F3
        BNE b158F
        LDA #$03
        STA a14F3
        LDX a14F7
        LDA f14EF,X
        CLC 
        ADC a14FD
        TAY 
        JSR s15B4
        INX 
        TXA 
        AND #$03
        STA a14F7
b158F   RTS 

;-------------------------------
; s1590
;-------------------------------
s1590   
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA f14B3,Y
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA f1477,Y
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        RTS 

;-------------------------------
; s15A2
;-------------------------------
s15A2   
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        LDA f14B3,Y
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA f1477,Y
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        RTS 

;-------------------------------
; s15B4
;-------------------------------
s15B4   
        LDA #$21
        STA $D412    ;Voice 3: Control Register
        LDA f14B3,Y
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA f1477,Y
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        RTS 

;-------------------------------
; s15C6
;-------------------------------
s15C6   
        LDA #$0F
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        STA $D418    ;Select Filter Mode and Volume
        LDA #$F5
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control
        RTS 

f15E0   .BYTE $00,$03,$06,$08,$00,$0C,$04,$08
        .BYTE $00,$07,$00,$05,$05,$00,$00,$05
        .BYTE $00,$06,$09,$05,$02,$04,$03,$04
        .BYTE $03,$07,$03,$00,$04,$08,$0C,$09
        .BYTE $07,$08,$04,$07,$00,$04,$07,$0E
        .BYTE $00,$00,$00,$07,$07,$04,$00,$0C
        .BYTE $04,$07,$00,$0C,$07,$08,$0A,$08
        .BYTE $0C,$00,$0C,$03,$0C,$03,$07,$00
;-------------------------------
; s1620
;-------------------------------
s1620   
        JSR s16A4
        AND #$0F
        BEQ b1630
        TAX 
        LDA #$00
b162A   CLC 
        ADC #$04
        DEX 
        BNE b162A
b1630   TAY 
        LDX #$00
b1633   LDA f15E0,Y
        STA f14EF,X
        INY 
        INX 
        CPX #$04
        BNE b1633
        JSR s16A4
        AND #$03
        CLC 
        ADC #$01
        STA a164E
        STA a164F
        RTS 

a164E   .BYTE $01
a164F   .BYTE $01
a1650   .BYTE $04
;-------------------------------
; s1651
;-------------------------------
s1651   
        LDA lastKeyPressed
        CMP #$40
        BNE b1658
        RTS 

b1658   LDY #$00
        STY a0864
        CMP #$3C
        BNE b168F
        LDA a4001
        EOR #$01
        STA a4001
        BNE b167B
        LDX #$03
b166D   LDA f169C,X
        AND #$3F
        STA SCREEN_RAM + $0344,X
        DEX 
        BPL b166D
        JMP j1688

b167B   LDX #$03
b167D   LDA f16A0,X
        AND #$3F
        STA SCREEN_RAM + $0344,X
        DEX 
        BPL b167D
;-------------------------------
; j1688
;-------------------------------
j1688   
        LDA lastKeyPressed
        CMP #$40
        BNE j1688
b168E   RTS 

b168F   CMP #$03
        BNE b168E
        LDA #$04
        STA a0864
        STA aAAE1
        RTS 

f169C   .TEXT "EASY"
f16A0   .TEXT "UGH!"
a16A5   =*+$01
;-------------------------------
; s16A4
;-------------------------------
s16A4   
        LDA a9A00
        INC a16A5
        RTS 


.include "paddingstart.asm"
.include "charset.asm"
.include "sprites.asm"

a4001   =*+$01
;-------------------------------
; j4000
;-------------------------------
j4000   
        LDA #$00
        SEI 
p4003   LDA #<p6B3E
        STA $0318    ;NMI
        LDA #>p6B3E
        STA $0319    ;NMI
        LDA #$80
        STA $0291
        LDX #$F8
        TXS 
        LDA #$01
        STA a797D
        LDA #$02
        STA a59BA
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$00
        STA aAAD2
        STA a6D51
        JSR s63C2
        JSR s7EA8
        LDA #$36
        STA a01
        LDA a4001
        STA a6B51
        LDA #$01
        STA a4E19
        STA a4E1A
        LDA #$00
        STA a654F
        STA a10
        STA a6929
        STA a14
        STA a18
        STA a1C
        STA a53B7
        STA a53B8
        STA a40D2
        STA a5509
        STA aAAD0
        STA a4F57
        LDA #$80
        STA a11
        LDA #$84
        STA a13
        LDA #$88
        STA a15
        LDA #<p0F8C
        STA a17
        LDA #>p0F8C
        STA $D418    ;Select Filter Mode and Volume
        JSR s4081
        JMP j4094

;-------------------------------
; s4081
;-------------------------------
s4081   
        LDA #$00
        TAX 
b4084   STA f2200,X
        STA f2300,X
        STA f2600,X
        STA f2700,X
        DEX 
        BNE b4084
        RTS 

;-------------------------------
; j4094
;-------------------------------
j4094   
        LDX #$05
b4096   LDA #$08
        STA f5EF0,X
        DEX 
        BNE b4096
        LDX #$06
b40A0   LDA #$30
        STA fAAC1,X
        DEX 
        BPL b40A0
        JSR s73BC
        JSR s680E
        LDA #$00
        STA a78B1
        LDA #$00
        STA a78B3
        LDA #$08
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA #$09
        STA $D023    ;Background Color 2, Multi-Color Register 1
        JSR s683E
        JMP j68E0

f40C8   .BYTE $00,$06,$02,$04,$05,$03,$07,$01
a40D0   .BYTE $00
a40D1   .BYTE $03
a40D2   .BYTE $00
;------------------------------------------------
; InitScreenPtrClearScreen
;------------------------------------------------
InitScreenPtrClearScreen
        SEI 
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$15
        STA $D018    ;VIC Memory Control Register
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$00
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        STA a46AC
        LDA #$F0
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control

        ; Init_ScreenPointerArray
        LDA #>SCREEN_RAM
        STA screenPtrHi
        LDA #<SCREEN_RAM
        STA screenPtrLo
        LDX #$00
b4109   LDA screenPtrLo
        STA SCREEN_PTR_LO,X
        LDA screenPtrHi
        STA SCREEN_PTR_HI,X
        LDA screenPtrLo
        CLC 
        ADC #$28
        STA screenPtrLo
        LDA screenPtrHi
        ADC #$00
        STA screenPtrHi
        INX 
        CPX #$1A
        BNE b4109

        ;Clear screen
        LDX #$00
        LDA #$20
b4129   STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02F8,X
        DEX 
        BNE b4129

        JMP j41A5

a413B   .BYTE $00
a413C   .BYTE $00
a413D   .BYTE $00
a413E   .BYTE $00
f413F   .BYTE $02,$08,$07,$05,$0E,$04,$06,$00
a4147   .BYTE $03
a4148   .BYTE $03
;-------------------------------
; s4149
;-------------------------------
s4149   
        .BYTE $AE,$3D,$41,$AC,$3C,$41,$BD,$40
        .BYTE $03,$85 ;SLO ($85,X)
        .BYTE $02    ;JAM 
        LDA SCREEN_PTR_HI,X
        STA screenPtrHi
        LDA (screenPtrLo),Y
        RTS 

;-------------------------------
; s415C
;-------------------------------
s415C   
        JSR s4149
        LDA a413E
        STA (screenPtrLo),Y
        LDA screenPtrHi
        PHA 
        CLC 
        ADC #$D4
        STA screenPtrHi
        LDA a413B
        STA (screenPtrLo),Y
        PLA 
        STA screenPtrHi
f4174   RTS 

f4175   .BYTE $0A,$09,$08,$07,$06,$05
a417B   .BYTE $04
f417C   .BYTE $03
f417D   .BYTE $0C,$0C,$0C,$0C,$0C,$0C
a4183   .BYTE $0C
;-------------------------------
; s4184
;-------------------------------
s4184   
        LDA #<InterruptHandler
        STA $0314    ;IRQ
        LDA #>InterruptHandler
        STA $0315    ;IRQ
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$FE
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        CLI 
        RTS 

;-------------------------------
; j41A5
;-------------------------------
;-------------------------------
; j41A5
;-------------------------------
j41A5   
        JSR s44AB
        JSR s4589
        JSR s46AF
        JSR s4184
b41B1   LDA lastKeyPressed
        CMP #$40
        BNE b41B1
        LDA #$00
        STA $D015    ;Sprite display Enable
b41BC   LDA lastKeyPressed
        CMP #$04 ; F1
        BNE b41C3
        RTS 

b41C3   CMP #$31
        BNE b41D8
b41C7   LDA lastKeyPressed
        CMP #$40
        BNE b41C7
        LDA #$01
        STA aAAD2
        JSR s63C2
        JMP InitScreenPtrClearScreen

b41D8   LDA a46AC
        BEQ b41BC
        JMP InitScreenPtrClearScreen

;-------------------------------
; InterruptHandler
;-------------------------------
InterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b41ED
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

b41ED   JSR s420B
        JSR s45EC
        JSR s473E
        JSR s439D
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$FE
        STA $D012    ;Raster Position
        JMP jEA31

a4209   .BYTE $01
a420A   .BYTE $00
;-------------------------------
; s420B
;-------------------------------
s420B   
        DEC a4148
        BEQ b4211
        RTS 

b4211   LDA a4147
        STA a4148
        LDA a4588
        BEQ b4224
        LDA #$00
        STA a4588
        JMP j42BD

b4224   LDA a417B
        STA a413C
        LDA a4183
        STA a413D
        JSR s42CC
        LDX #$06
b4235   LDA f4174,X
        STA f4175,X
        LDA f417C,X
        STA f417D,X
        DEX 
        BNE b4235
;-------------------------------
; j4244
;-------------------------------
j4244   
        LDA f4175
        CLC 
        ADC a4209
        STA f4175
        CMP #$FF
        BNE b425A
        LDA #$26
        STA f4175
        JMP j4263

b425A   CMP #$27
        BNE j4263
        LDA #$00
        STA f4175
;-------------------------------
; j4263
;-------------------------------
j4263   
        LDA f417D
        CLC 
        ADC a420A
        STA f417D
        CMP #$FF
        BNE b4279
        LDA #$16
        STA f417D
        JMP j4282

b4279   CMP #$17
        BNE j4282
        LDA #$00
        STA f417D
;-------------------------------
; j4282
;-------------------------------
j4282   
        JSR s42D9
        LDA f4175
        STA a413C
        LDA f417D
        STA a413D
        JSR s4149
        JSR s432A
        LDX #$00
b4299   LDA f4175,X
        STA a413C
        LDA f417D,X
        STA a413D
        LDA #$A0
        STA a413E
        LDA f413F,X
        STA a413B
        TXA 
        PHA 
        JSR s415C
        PLA 
        TAX 
        INX 
        CPX #$07
        BNE b4299
b42BC   RTS 

;-------------------------------
; j42BD
;-------------------------------
j42BD   
        LDA f4175
        STA a413C
        LDA f417D
        STA a413D
        JMP j4282

;-------------------------------
; s42CC
;-------------------------------
s42CC   
        JSR s4149
        CMP #$A0
        BNE b42BC
        LDA #$20
        STA (screenPtrLo),Y
b42D7   RTS 

a42D8   RTI 

;-------------------------------
; s42D9
;-------------------------------
s42D9   
        LDA lastKeyPressed
        CMP a42D8
        BNE b42E1
        RTS 

b42E1   STA a42D8
        CMP #$40
        BEQ b42D7
        PHA 
        LDA f4175
        STA a413C
        LDA f417D
        STA a413D
        PLA 
        CMP #$27
        BNE b4307
        LDA #$4E
        STA a413E
;-------------------------------
; j42FF
;-------------------------------
j42FF   
        LDA #$01
        STA a413B
        JMP s415C

b4307   CMP #$24
        BNE b4313
        LDA #$4D
        STA a413E
        JMP j42FF

b4313   CMP #$3C
        BNE b4321
        DEC a4147
        BNE b4321
        LDA #$04
        STA a4147
b4321   RTS 

        .BYTE $01,$00,$FF,$00,$01,$00,$FF,$00
;-------------------------------
; s432A
;-------------------------------
s432A   
        CMP #$4D
        BNE b434F
        LDA #$4E
        STA (screenPtrLo),Y
        LDA a4209
        PHA 
        LDA a420A
        STA a4209
        PLA 
        STA a420A
        PLA 
        PLA 
        LDA #$01
        STA a4588
;-------------------------------
; j4347
;-------------------------------
j4347   
        LDA #$04
        STA a4738
        JMP j4244

b434F   CMP #$4E
        BNE b4379
        LDA #$4D
        STA (screenPtrLo),Y
        LDA a4209
        EOR #$FF
        CLC 
        ADC #$01
        PHA 
        LDA a420A
        EOR #$FF
        CLC 
        ADC #$01
        STA a4209
        PLA 
        STA a420A
        PLA 
        PLA 
        LDA #$01
        STA a4588
        JMP j4347

b4379   CMP #$51
        BNE b439B
        LDA #$20
        STA a4739
        LDA #$20
        STA (screenPtrLo),Y
        LDA #$01
        STA a44A9
        INC a439C
        JSR s4512
        JSR s4589
        RTS 

a4396   =*+$01
;-------------------------------
; s4395
;-------------------------------
s4395   
        LDA aEF00
        INC a4396
b439B   RTS 

a439C   .BYTE $00
;-------------------------------
; s439D
;-------------------------------
s439D   
        LDA a439C
        BNE b43BD
        JSR s4395
        AND #$1F
        CLC 
        ADC #$03
        STA a43E4
        JSR s4395
        AND #$0F
        CLC 
        ADC #$03
        STA a43E5
        LDA #$01
        STA a439C
b43BD   CMP #$01
        BNE b43E7
        LDA #$51
        STA a413E
        INC a43E6
        LDA a43E6
        AND #$07
        TAX 
        LDA f413F,X
        STA a413B
        LDA a43E4
        STA a413C
        LDA a43E5
        STA a413D
        JMP s415C

a43E4   .BYTE $00
a43E5   .BYTE $00
a43E6   .BYTE $00
b43E7   LDA #$A0
        STA a413E
        LDA a44A9
        STA a44AA
        LDA #$00
        STA a43E6
b43F7   JSR s441A
        INC a43E6
        LDA a43E6
        CMP #$08
        BEQ b4409
        DEC a44AA
        BNE b43F7
b4409   INC a44A9
        LDA a44A9
        CMP #$30
        BEQ b4414
        RTS 

b4414   LDA #$00
        STA a439C
        RTS 

;-------------------------------
; s441A
;-------------------------------
s441A   
        LDX a43E6
        LDA f413F,X
        STA a413B
        LDA a43E4
        SEC 
        SBC a44AA
        STA a413C
        LDA a43E5
        SEC 
        SBC a44AA
        STA a413D
        JSR s4492
        LDA a413C
        CLC 
        ADC a44AA
        STA a413C
        JSR s4492
        LDA a413C
        CLC 
        ADC a44AA
        STA a413C
        JSR s4492
        LDA a413D
        CLC 
        ADC a44AA
        STA a413D
        JSR s4492
        LDA a413D
        CLC 
        ADC a44AA
        STA a413D
        JSR s4492
        LDA a413C
        SEC 
        SBC a44AA
        STA a413C
        JSR s4492
        LDA a413C
        SEC 
        SBC a44AA
        STA a413C
        JSR s4492
        LDA a413D
        SEC 
        SBC a44AA
        STA a413D
;-------------------------------
; s4492
;-------------------------------
s4492   
        LDA a413C
        BMI b449B
        CMP #$27
        BMI b449C
b449B   RTS 

b449C   LDA a413D
        BMI b449B
        CMP #$16
        BMI b44A6
        RTS 

b44A6   JMP s415C

a44A9   .BYTE $00
a44AA   .BYTE $00
;-------------------------------
; s44AB
;-------------------------------
s44AB   
        LDA #$00
        STA a413C
        LDA #>p2017
        STA a413E
        LDA #<p2017
        STA a413D
b44BA   LDX a413C
        LDA f44E0,X
        STA a413B
        JSR s415C
        INC a413D
        JSR s415C
        DEC a413D
        INC a413C
        LDA a413C
        CMP #$28
        BNE b44BA
        LDA #$00
        STA a44DF
        RTS 

a44DF   .BYTE $00
f44E0   .BYTE $02,$02,$02,$02,$02,$02,$08,$08
        .BYTE $08,$08,$08,$08,$07,$07,$07,$07
        .BYTE $07,$05,$05,$05,$05,$05,$05,$0B
        .BYTE $0B,$0B,$0B,$0B,$04,$04,$04,$04
        .BYTE $04,$04,$06,$06,$06,$06,$06,$06
a4508   .BYTE $00
f4509   .BYTE $20,$65,$74,$75,$61,$F6,$EA,$E7
        .BYTE $A0
;-------------------------------
; s4512
;-------------------------------
s4512   
        LDA a4630
        ROR 
        ROR 
        AND #$03
        TAX 
        INX 
        LDA #$00
        STA a4508
b4520   LDA #$05
        SEC 
        SBC a4147
        CLC 
        ADC a4508
        STA a4508
        DEX 
        BNE b4520
b4530   JSR s453C
        DEC a4508
        BNE b4530
        JSR s46AF
        RTS 

;-------------------------------
; s453C
;-------------------------------
s453C   
        LDA #$18
        STA a413D
        LDA a44DF
        STA a413C
        JSR s4149
        LDX #$00
;-------------------------------
; j454C
;-------------------------------
j454C   
        CMP f4509,X
        BEQ b4555
        INX 
        JMP j454C

b4555   CMP #$A0
        BEQ b456C
        INX 
        LDA f4509,X
        STA a413E
;-------------------------------
; j4560
;-------------------------------
j4560   
        LDX a413C
        LDA f44E0,X
        STA a413B
        JMP s415C

b456C   INC a413C
        INC a44DF
        LDA a44DF
        CMP #$27
        BNE b4580
        DEC a44DF
        INC a46AC
        RTS 

b4580   LDA #$20
        STA a413E
        JMP j4560

a4588   .BYTE $00
;-------------------------------
; s4589
;-------------------------------
s4589   
        LDA #>p27
        STA a413D
        LDA #<p27
        STA a413C
b4593   LDX a413D
        LDA f45BB,X
        CMP #$A0
        BEQ b459F
        AND #$3F
b459F   STA a413E
        LDA f45D3,X
        STA a413B
        JSR s415C
        INC a413D
        LDA a413D
        CMP #$18
        BNE b4593
        LDA #$00
        STA a4630
b45BA   RTS 

f45BB   .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $A0,$A0,$A0,$A0,$20,$CD,$C9,$C6
        .BYTE $20,$20,$42,$59,$20,$D9,$C1,$CB
f45D3   .BYTE $02,$02,$02,$02,$01,$01,$01,$01
        .BYTE $06,$06,$06,$06,$00,$02,$01,$06
        .BYTE $00,$00,$04,$04,$00,$07,$07,$07
a45EB   .BYTE $10
;-------------------------------
; s45EC
;-------------------------------
s45EC   
        DEC a45EB
        BNE b45BA
        LDA #$10
        STA a45EB
        LDA a4630
        STA a413D
        LDA #$27
        STA a413C
        JSR s4149
        LDX #$00
b4606   CMP f4631,X
        BEQ b460E
        INX 
        BNE b4606
b460E   CMP #$20
        BEQ b4625
        INX 
        LDA f4631,X
        STA a413E
        LDX a4630
        LDA f45D3,X
        STA a413B
        JMP s415C

b4625   INC a4630
        LDA a4630
        CMP #$0C
        BEQ b463A
        RTS 

a4630   .BYTE $00
f4631   .BYTE $A0,$E3,$F7,$F8,$62,$79,$6F,$64
        .BYTE $20
b463A   LDA #$00
        STA a413C
        STA a413D
        LDA #$CF
        STA a413E
        LDA #$00
        STA a46AB
        JSR s4665
        LDA #$20
        STA a413E
        LDA #$00
        STA a413C
        STA a413D
        JSR s4665
        LDA #$01
        STA a46AC
        RTS 

;-------------------------------
; s4665
;-------------------------------
s4665   
        LDA a413E
        CMP #$20
        BEQ b4684
        INC a46AB
        LDA a46AB
        CMP #$06
        BNE b467B
        LDA #$00
        STA a46AB
b467B   LDX a46AB
        LDA f413F,X
        STA a413B
b4684   JSR s415C
        LDY #$02
b4689   LDX #$A0
b468B   DEX 
        BNE b468B
        DEY 
        BNE b4689
        INC a413C
        LDA a413C
        CMP #$27
        BNE s4665
        LDA #$00
        STA a413C
        INC a413D
        LDA a413D
        CMP #$17
        BNE s4665
        RTS 

a46AB   .BYTE $00
a46AC   .BYTE $00
a46AD   .BYTE $00
a46AE   .BYTE $00
;-------------------------------
; s46AF
;-------------------------------
s46AF   
        LDA #>p2017
        STA a413E
        LDA #<p2017
        STA a413D
        LDA a46AD
        STA a413C
        JSR s415C
        LDA a44DF
        CMP a46AD
        BEQ b4710
        BPL b46EC
;-------------------------------
; j46CC
;-------------------------------
j46CC   
        LDA a46AD
        STA a413C
        LDA #$17
        STA a413D
        LDX a46AD
        LDA f44E0,X
        STA a413B
        LDX a46AE
        LDA f472F,X
        STA a413E
        JMP s415C

b46EC   LDA a44DF
        STA a413C
        LDA #$18
        STA a413D
        JSR s4149
        LDX #$00
b46FC   CMP f4509,X
        BEQ b4704
        INX 
        BNE b46FC
b4704   STX a46AE
        LDA a44DF
        STA a46AD
        JMP j46CC

b4710   LDA a44DF
        STA a413C
        LDA #$18
        STA a413D
        JSR s4149
        LDX #$00
b4720   CMP f4509,X
        BEQ b4728
        INX 
        BNE b4720
b4728   TXA 
        CMP a46AE
        BPL b4704
        RTS 

f472F   .BYTE $65,$65,$54,$47,$42,$5D,$48,$59
        .BYTE $67
a4738   .BYTE $00
a4739   .BYTE $00
f473A   .BYTE $C0,$40,$E0,$10
;-------------------------------
; s473E
;-------------------------------
s473E   
        LDA a4738
        BEQ b475A
        TAX 
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA f473A,X
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        DEC a4738
        BNE b475A
        LDA #$80
        STA $D404    ;Voice 1: Control Register
b4759   RTS 

b475A   LDA a4739
        BEQ b4759
        LDA #$00
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA #$20
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA a4739
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        DEC a4739
        BNE b4759
        LDA #$80
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        RTS 

p4788   .BYTE $A0,$50,$A7,$08,$A2,$D0,$9B,$A0
        .BYTE $18,$00,$1D,$E0,$A0,$A0,$13,$70
        .BYTE $1A,$70,$1E,$58,$11,$40,$11,$B8
        .BYTE $13,$E8,$13,$C0,$9B,$00,$A6,$E0
        .BYTE $1D,$18,$A9,$48,$A9,$98,$A1,$68
        .BYTE $A0,$00,$A5,$78,$A5,$A0,$15,$28
        .BYTE $10,$00,$10,$C8,$19,$68,$1B,$60
        .BYTE $1B,$D8,$9D,$A8,$9E,$70,$A4,$10
        .BYTE $A5,$28,$A5,$C8,$A8,$C0,$AA,$38
        .BYTE $A5,$F0,$A3,$70,$A3,$98,$A1,$90
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
a4850   .BYTE $01
f4851   .BYTE $01,$02,$04,$08,$0A,$0C,$0E,$10
        .BYTE $10,$10,$10,$10,$10,$10,$10,$14
f4861   .BYTE $FF,$FE,$FC,$F9,$F7,$F5,$F3,$F1
        .BYTE $F0,$F0,$F0,$F0,$F0,$F0
f486F   .BYTE $F0,$EC,$78,$78,$78,$78,$00,$00
        .BYTE $78,$78
f4879   .BYTE $50,$50,$A0,$A0,$A0,$A0,$00,$00
        .BYTE $A0,$A0
f4883   .BYTE $A0,$A0,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f488D   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f4897   .BYTE $00,$00,$02,$02,$02,$02,$00,$00
        .BYTE $02,$02
f48A1   .BYTE $02,$02,$00,$00,$00,$00,$FF,$FF
        .BYTE $00,$00
f48AB   .BYTE $00
f48AC   .BYTE $00,$00,$00,$00,$00,$00
f48B2   .BYTE $00,$00,$00
f48B5   .BYTE $00
f48B6   .BYTE $00,$00,$00,$00,$00,$00
f48BC   .BYTE $00,$00,$00
f48BF   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f48C9   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00
a48D5   .BYTE $04
a48D6   .BYTE $00
a48D7   .BYTE $00,$01,$00,$01,$00,$00,$01,$00
        .BYTE $01,$FF,$00,$02,$00,$FF,$FF,$01
        .BYTE $02,$80
p48E9   .BYTE $00,$00,$0F,$0C,$00,$00,$00,$0F
        .BYTE $13,$00,$00,$00,$00,$0D,$00,$00
        .BYTE $00,$00,$14,$00,$00,$00,$10,$08
        .BYTE $00,$00,$00,$10,$0F,$00,$00,$00
        .BYTE $11,$0B,$00,$00,$00,$11,$12,$02
        .BYTE $0F,$02,$02,$0F,$00,$08,$02,$02
        .BYTE $08,$01,$00,$81,$08,$00,$00,$00
        .BYTE $00,$81,$0B,$00,$00,$00,$28,$08
        .BYTE $00,$00,$00,$80,$12,$02,$08,$02
        .BYTE $03,$08,$01,$00,$81,$05,$00,$00
        .BYTE $00,$00,$21,$12,$00,$00,$00,$20
        .BYTE $0F,$02,$08,$02,$03,$08,$00,$0F
        .BYTE $02,$04,$0F,$01,$00,$81,$08,$00
        .BYTE $00,$00,$00,$80,$0B,$00,$00,$00
        .BYTE $80,$12,$00,$00,$80,$CA,$7B,$00
p4961   .BYTE $00,$00,$0F,$05,$00,$00,$00,$00
        .BYTE $06,$00,$00,$00,$40,$01,$00,$00
        .BYTE $00,$81,$04,$02,$01,$01,$0C,$01
        .BYTE $01,$00,$81,$04,$00,$00,$00,$00
        .BYTE $20,$01,$00,$00,$00,$11,$04,$02
        .BYTE $01,$02,$04,$01,$01,$00,$81,$08
        .BYTE $00,$00,$00,$00,$10,$04,$00,$00
        .BYTE $80,$CA,$7B,$00
b499D   LDA f4879,X
        BEQ b49B5
        LDA a78C7
        BNE b49B2
        INX 
        CPX #$06
        BEQ b49B2
        CPX #$0C
        BEQ b49B2
        BNE b499D
b49B2   LDA #$00
        RTS 

b49B5   LDA #$FF
b49B7   RTS 

a49B8   .BYTE $A0
a49B9   .BYTE $A0
a49BA   .BYTE $58
a49BB   .BYTE $1E
f49BC   .BYTE $28,$00,$00,$00
f49C0   .BYTE $00
f49C1   .BYTE $18,$00,$00,$00
f49C5   .BYTE $00
f49C6   .BYTE $06,$02,$06,$0A
f49CA   .BYTE $08
f49CB   .BYTE $09,$0E,$0A,$0B,$01
a49D0   .BYTE $04
a49D1   .BYTE $04
a49D2   .BYTE $00
a49D3   .BYTE $00
;-------------------------------
; s49D4
;-------------------------------
s49D4   
        LDA a78C7
        BNE b49F5
        LDA a40D2
        BEQ b49E1
        JMP j5841

b49E1   JSR s4BBF
        JSR s4F5B
        JSR s502A
        JSR s53B9
        JSR s552A
        DEC a49F6
        BEQ b49F7
b49F5   RTS 

a49F6   .BYTE $14
b49F7   LDA #$20
        STA a49F6
        LDX #$02
        JSR b499D
        BEQ b4A1F
        LDA a49D0
        CMP a49D2
        BEQ b4A1F
        LDA a49B8
        STA f486F,X
        LDA a49B9
        STA f4879,X
        TXA 
        TAY 
        JSR s4A42
        INC a49D2
b4A1F   LDX #$08
        JSR b499D
        BEQ b49B7
        LDA a49D1
        CMP a49D3
        BEQ b49B7
        LDA a49BA
        STA f486F,X
        LDA a49BB
        STA f4879,X
        TXA 
        CLC 
        ADC #$02
        TAY 
        INC a49D3
;-------------------------------
; s4A42
;-------------------------------
s4A42   
        LDA f486F,X
        STA a40
        LDA f4879,X
        STA a41
        LDA #$00
        STA a4E18
        STA f48C9,X
        STY a48D5
;-------------------------------
; s4A57
;-------------------------------
s4A57   
        LDY #$00
        LDA (p40),Y
        STA f67F0,X
        LDY #$06
        LDA (p40),Y
        STA f48A1,X
        LDY #$0B
        LDA (p40),Y
        STA f488D,X
        LDA #$00
        STA f4883,X
        LDY #$0F
        LDA (p40),Y
        STA f4897,X
        LDY #$01
        LDA (p40),Y
        STA f67D6,X
        TXA 
        TAY 
        LDX f4B7B,Y
        LDY #$01
        LDA (p40),Y
        STA f7E49,X
        LDY #$02
        LDA (p40),Y
        STA f7E51,X
        LDY #$03
        LDA (p40),Y
        STA f7E59,X
        STA f7E61,X
        TXA 
        AND #$04
        BEQ b4AB9
        INY 
        LDA (p40),Y
        STA f7E49,X
        INY 
        LDA (p40),Y
        STA f7E51,X
        TXA 
        TAY 
        LDA f4B87,X
        TAY 
        LDA f7E49,X
        STA f67D6,Y
b4AB9   LDY #$12
        LDA (p40),Y
        CMP #$80
        BEQ b4AC4
        STA f7E39,X
b4AC4   INY 
        LDA (p40),Y
        CMP #$80
        BEQ b4AFA
        AND #$F0
        CMP #$20
        BEQ b4AD6
        LDA (p40),Y
        JMP j4AF7

b4AD6   TXA 
        STX a5529
        AND #$04
        BNE b4AEC
        LDA (p40),Y
        AND #$0F
        TAX 
        LDA f4861,X
        LDX a5529
        JMP j4AF7

b4AEC   LDA (p40),Y
        AND #$0F
        TAX 
        LDA f4851,X
        LDX a5529
;-------------------------------
; j4AF7
;-------------------------------
j4AF7   
        STA f7E41,X
b4AFA   INY 
        LDA (p40),Y
        CMP #$80
        BEQ b4B07
        STA f7D1F,X
        STA f7D27,X
b4B07   INY 
        LDA (p40),Y
        CMP #$80
        BEQ b4B14
        STA f7D2F,X
        STA f7D37,X
b4B14   LDA #$01
        LDA a4E18
        BEQ b4B1C
        RTS 

b4B1C   LDY a48D5
        LDA f4B87,X
        TAX 
        LDA f6B45,X
        STA f67E2,Y
        JSR s7316
        AND #$7F
        CLC 
        ADC #$20
        STA f67C8,Y
        TYA 
        AND #$08
        BNE b4B5A
        JSR s7316
        AND #$3F
        CLC 
        ADC #$40
        STA f67FC,Y
        STY a45
        LDY #$06
        LDA (p40),Y
        BNE b4B59
        LDY #$08
        LDA (p40),Y
        BEQ b4B59
        LDA #$6C
        LDY a45
        STA f67FC,Y
b4B59   RTS 

b4B5A   JSR s7316
        AND #$3F
        CLC 
        ADC #$98
        STA f67FC,Y
        STY a45
        LDY #$06
        LDA (p40),Y
        BNE b4B7A
        LDY #$08
        LDA (p40),Y
        BEQ b4B7A
        LDA #$90
        LDY a45
        STA f67FC,Y
b4B7A   RTS 

f4B7B   .BYTE $00,$00,$00,$01,$02,$03,$00,$00
        .BYTE $04,$05,$06,$07
f4B87   .BYTE $02,$03,$04,$05,$08,$09,$0A,$0B
f4B8F   .BYTE $00,$00,$02,$03,$04,$05,$00,$00
        .BYTE $0A,$0B,$0C,$0D
f4B9B   .BYTE $02,$03,$04,$05,$0A,$0B,$0C,$0D
f4BA3   .BYTE $00,$00,$00,$01,$02,$03,$00,$00
        .BYTE $00,$00,$04,$05,$06,$07
f4BB1   .BYTE $00,$00,$02,$03,$04,$05,$00,$00
        .BYTE $00,$00,$08,$09,$0A,$0B
;-------------------------------
; s4BBF
;-------------------------------
s4BBF   
        LDY #$00
        LDA a40D0
        BEQ b4BC7
        RTS 

b4BC7   LDX f4B87,Y
        LDA f4879,X
        BEQ b4BD6
        STY a42
        JSR s4BEC
        LDY a42
b4BD6   INY 
        CPY #$08
        BNE b4BC7
        LDA a4850
        BEQ b4BEB
        LDA #$00
        STA a49D2
        STA a49D3
        STA a4850
b4BEB   RTS 

;-------------------------------
; s4BEC
;-------------------------------
s4BEC   
        STA a41
        LDA f486F,X
        STA a40
        LDA a4850
        BEQ b4C03
        LDA #>p18C8
        STA a41
        LDA #<p18C8
        STA a40
        JMP j4DF0

b4C03   LDA f48BF,X
        BNE b4C0B
        JMP j4CBB

b4C0B   LDA #$00
        STA f48BF,X
        LDA #<p48E9
        STA a79AE
        LDA #>p48E9
        STA a79AF
        JSR s7C91
        LDA #$1C
        STA a48D7
        TXA 
        PHA 
        AND #$08
        BNE b4C5C
        LDA a78C7
        BNE b4C42
        LDA a7EE1
        BNE b4C42
        INC a78B0
        LDA a78B0
        CMP a4E19
        BNE b4C42
        LDA #$00
        STA a78B0
b4C42   LDY #$22
        LDA (p40),Y
        JSR s5735
        CLC 
        ADC a5321
        STA a5321
        LDA a5322
        ADC a5752
        STA a5322
        JMP j4C8D

b4C5C   LDA a78C7
        BNE b4C76
        LDA a7EE1
        BNE b4C76
        INC a78B2
        LDA a78B2
        CMP a4E1A
        BNE b4C76
        LDA #$00
        STA a78B2
b4C76   LDY #$22
        LDA (p40),Y
        JSR s5735
        CLC 
        ADC a5323
        STA a5323
        LDA a5324
        ADC a5752
        STA a5324
;-------------------------------
; j4C8D
;-------------------------------
j4C8D   
        JSR s5238
        PLA 
        TAX 
        LDY #$22
        LDA (p40),Y
        BEQ b4CB1
        LDA a7EE1
        BNE b4CB1
        TXA 
        AND #$08
        BNE b4CAB
        JSR s5562
        JSR s5678
        JMP b4CB1

b4CAB   JSR s56BD
        JSR s5575
b4CB1   LDY #$1D
        LDA (p40),Y
        BEQ j4CBB
        DEY 
        JMP j4DDD

;-------------------------------
; j4CBB
;-------------------------------
j4CBB   
        LDA f48C9,X
        BEQ b4CDC
        LDA #$00
        STA f48C9,X
        LDY #$1F
        LDA (p40),Y
        BEQ b4CDC
        LDY #$0E
        LDA (p40),Y
        BEQ b4CE2
        TXA 
        AND #$08
        BNE b4CDF
        DEC a49D2
        JMP b4CE2

b4CDC   JMP j4D84

b4CDF   DEC a49D3
b4CE2   LDY #$24
        LDA (p40),Y
        BNE b4CEB
        JMP j4D36

b4CEB   LDA a7176
        AND #$10
        BEQ b4CDC
        LDA a797D
        BNE b4CDC
        LDA a4F57
        BNE b4D0D
        JSR s7C8B
        LDA #<p6362
        STA a79AC
        LDA #>p6362
        STA a79AD
        LDA #$08
        BNE b4D1C
b4D0D   JSR s7C8B
        LDA #<p6335
        STA a79AC
        LDA #>p6335
        STA a79AD
        LDA #$00
b4D1C   STA a4F57
        LDA #$00
        STA a7C8A
        LDA #$08
        STA a5E76
        STA a5E77
        LDA #$05
        STA a6D85
        LDA #$04
        STA a6D86
;-------------------------------
; j4D36
;-------------------------------
j4D36   
        LDY #$23
        LDA (p40),Y
        BEQ b4D7F
        LDA #<p4961
        STA a79AC
        LDA #>p4961
        STA a79AD
        JSR s7C8B
        LDA #$0E
        STA a6D85
        LDA #$02
        STA a6D86
        LDA a6E12
        EOR #$FF
        CLC 
        ADC #$01
        STA a6E12
        LDA a4F57
        BEQ b4D72
        LDA a53B8
        BNE b4D7F
        LDA (p40),Y
        JSR s57DE
        STA a53B8
        BNE b4D7F
b4D72   LDA a53B7
        BNE b4D7F
        LDA (p40),Y
        JSR s57DE
        STA a53B7
b4D7F   LDY #$1E
        JMP j4DDD

;-------------------------------
; j4D84
;-------------------------------
j4D84   
        LDA f48AB,X
        BEQ b4D98
        LDA #$00
        STA f48AB,X
        LDY #$19
        LDA (p40),Y
        BEQ b4D98
        DEY 
        JMP j4DDD

b4D98   LDA f48B5,X
        BEQ b4DAC
        LDA #$00
        STA f48B5,X
        LDY #$1B
        LDA (p40),Y
        BEQ b4DAC
        DEY 
        JMP j4DDD

b4DAC   LDA a7176
        AND #$10
        BNE b4DBD
        LDY #$21
        LDA (p40),Y
        BEQ b4DBD
        DEY 
        JMP j4DDD

b4DBD   LDA f4897,X
        BEQ b4E1B
        DEC f4897,X
        BNE b4E1B
        LDY #$0E
        LDA (p40),Y
        BEQ b4DDB
        TXA 
        AND #$08
        BNE b4DD8
        DEC a49D2
        JMP b4DDB

b4DD8   DEC a49D3
b4DDB   LDY #$10
;-------------------------------
; j4DDD
;-------------------------------
j4DDD   
        LDA (p40),Y
        PHA 
        INY 
        LDA (p40),Y
        BEQ b4DFE
        STA f4879,X
        STA a41
        PLA 
        STA a40
        STA f486F,X
;-------------------------------
; j4DF0
;-------------------------------
j4DF0   
        LDA #$FF
        STA a4E18
        JSR s4A57
        LDA #$00
        STA a4E18
        RTS 

b4DFE   LDA #$F0
        STA f67D6,X
        PHA 
        LDA #$00
        STA f4879,X
        LDY f4B7B,X
        PLA 
        STA f7E49,Y
        LDA #$F1
        STA f7E51,Y
        PLA 
        RTS 

a4E17   .BYTE $00
a4E18   .BYTE $00
a4E19   .BYTE $01
a4E1A   .BYTE $01
b4E1B   LDY #$0A
        LDA (p40),Y
        BEQ b4E73
        DEC f488D,X
        BNE b4E73
        STA a44
        DEY 
        LDA (p40),Y
        STA a43
        LDY #$0B
        LDA (p40),Y
        STA f488D,X
        LDY f4883,X
        LDA f4B7B,X
        TAX 
        LDA (p43),Y
        CMP #$80
        BEQ b4E6A
        LDA (p43),Y
        STA f7E39,X
        INY 
        LDA (p43),Y
        STA f7E41,X
        INY 
        LDA (p43),Y
        STA f7D1F,X
        STA f7D27,X
        INY 
        LDA (p43),Y
        STA f7D2F,X
        STA f7D37,X
        INY 
        LDA f4B87,X
        TAX 
        TYA 
        STA f4883,X
        JMP b4E73

b4E6A   LDY #$0C
        LDA f4B87,X
        TAX 
        JMP j4DDD

b4E73   LDY #$17
        LDA (p40),Y
        BEQ b4EC7
        CLC 
        ADC a760C
        STA a4E17
        LDA f4B7B,X
        TAX 
        LDA f7D37,X
        CMP #$01
        BNE b4EC3
        LDA (p40),Y
        CMP #$23
        BNE b4E96
        LDA #$77
        STA a4E17
b4E96   TXA 
        AND #$04
        BEQ b4EA6
        LDA #$FF
        SEC 
        SBC a4E17
        ADC #$07
        STA a4E17
b4EA6   LDA f4B9B,X
        TAX 
        LDA f67FC,X
        PHA 
        LDA f4BA3,X
        TAX 
        PLA 
        CMP a4E17
        BEQ b4EC3
        BMI b4EC0
        DEC f7E41,X
        DEC f7E41,X
b4EC0   INC f7E41,X
b4EC3   LDA f4B87,X
        TAX 
b4EC7   LDY #$16
        LDA (p40),Y
        BEQ b4F05
        CLC 
        ADC #$58
        STA a4E17
        LDA f4B7B,X
        TAX 
        LDA f7D27,X
        CMP #$01
        BNE b4F01
        LDA f4B9B,X
        TAX 
        CLC 
        LDA f67E2,X
        BEQ b4EE9
        SEC 
b4EE9   LDA f67C8,X
        ROR 
        PHA 
        LDA f4BA3,X
        TAX 
        PLA 
        CMP a4E17
        BMI b4EFE
        DEC f7E39,X
        DEC f7E39,X
b4EFE   INC f7E39,X
b4F01   LDA f4B87,X
        TAX 
b4F05   LDY #$06
        LDA (p40),Y
        BEQ b4F55
        DEC f48A1,X
        BNE b4F55
        LDA (p40),Y
        STA f48A1,X
        TXA 
        PHA 
        LDY f4B8F,X
        LDA f67C8,Y
        PHA 
        LDA f67E2,Y
        PHA 
        LDA f67FC,Y
        PHA 
        TXA 
        AND #$08
        BNE b4F4C
        LDX #$02
b4F2D   JSR b499D
        BEQ b4F50
        LDY f4B8F,X
        PLA 
        STA f67FC,Y
        PLA 
        BEQ b4F3F
        LDA f6B45,X
b4F3F   STA f67E2,Y
        PLA 
        STA f67C8,Y
        PLA 
        LDY #$07
        JMP j4DDD

b4F4C   LDX #$08
        BNE b4F2D
b4F50   PLA 
        PLA 
        PLA 
        PLA 
        TAX 
b4F55   RTS 

b4F56   RTS 

a4F57   .BYTE $00
a4F58   .BYTE $00
a4F59   .BYTE $00,$00
;-------------------------------
; s4F5B
;-------------------------------
s4F5B   
        LDA a4F57
        TAY 
        AND #$08
        BEQ b4F65
        DEY 
        DEY 
b4F65   LDA f67E2,Y
        BMI b4F89
        LDY a4F57
        LDA f67E2,Y
        CLC 
        BEQ b4F74
        SEC 
b4F74   LDA f67C8,Y
        ROR 
        STA a4F58
        LDA f67FC,Y
        STA a4F59
        LDA #$00
        STA a48D6
        JSR s4FA4
b4F89   LDA f67E3,Y
        BMI b4F56
        CLC 
        BEQ b4F92
        SEC 
b4F92   LDA f67C9,Y
        ROR 
        STA a4F58
        LDA f67FD,Y
        STA a4F59
        LDA #$01
        STA a48D6
;-------------------------------
; s4FA4
;-------------------------------
s4FA4   
        TYA 
        TAX 
        INX 
        INX 
;-------------------------------
; j4FA8
;-------------------------------
j4FA8   
        STX a43
        LDA f4BB1,X
        TAX 
        LDA f4879,X
        BNE b4FB6
        JMP j501B

b4FB6   LDX a43
        CLC 
        LDA f67E2,X
        BEQ b4FBF
        SEC 
b4FBF   LDA f67C8,X
        ROR 
        SEC 
        SBC a4F58
        BPL b4FCB
        EOR #$FF
b4FCB   CMP #$08
        BMI b4FD2
        JMP j501B

b4FD2   LDA f67FC,X
        SEC 
        SBC a4F59
        BPL b4FDD
        EOR #$FF
b4FDD   CMP #$10
        BMI b4FE4
        JMP j501B

b4FE4   LDA f4BB1,X
        TAX 
        LDA f486F,X
        STA a40
        LDA f4879,X
        STA a41
        STY a42
        LDY #$1D
        LDA (p40),Y
        LDY a42
        CMP #$00
        BEQ j501B
        LDA #$FF
        STA f48BF,X
        TYA 
        PHA 
        CLC 
        ADC a48D6
        TAY 
        LDX a43
        TYA 
        AND #$08
        BEQ b5013
        DEY 
        DEY 
b5013   LDA #$FF
        STA f67E2,Y
        PLA 
        TAY 
        RTS 

;-------------------------------
; j501B
;-------------------------------
j501B   
        LDX a43
        INX 
        CPX #$06
        BEQ b5029
        CPX #$0E
        BEQ b5029
        JMP j4FA8

b5029   RTS 

;-------------------------------
; s502A
;-------------------------------
s502A   
        LDY #$00
        LDA a78C7
        BNE b5029
        LDA a7EE1
        BNE b5029
        LDA a4F57
        BEQ b503C
        INY 
b503C   LDX a4F57
        INX 
        INX 
;-------------------------------
; j5041
;-------------------------------
j5041   
        CLC 
        LDA f67E2,X
        BEQ b5048
        SEC 
b5048   LDA f67C8,X
        ROR 
        SEC 
        SBC #$58
        BPL b5053
        EOR #$FF
b5053   CMP #$08
        BMI b505A
        JMP j5079

b505A   LDA f67FC,X
        SEC 
        SBC a760C,Y
        BPL b5065
        EOR #$FF
b5065   CMP #$08
        BMI b506C
        JMP j5079

b506C   STX a43
        LDA f4BB1,X
        TAX 
        LDA #$FF
        STA f48C9,X
        LDX a43
;-------------------------------
; j5079
;-------------------------------
j5079   
        INX 
        CPX #$06
        BEQ b5085
        CPX #$0E
        BEQ b5085
        JMP j5041

b5085   RTS 

        .BYTE $88,$8A,$20,$90,$92,$91,$93,$20
        .BYTE $20,$AE,$B0,$AF,$B1,$30,$30,$30
        .BYTE $30,$30,$30,$30,$20,$20,$B2,$B4
        .BYTE $30,$30,$20,$9A,$9C,$20,$98,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20,$20
        .BYTE $89,$8B,$20,$80,$80,$80,$80,$80
        .BYTE $80,$80,$80,$20,$20,$20,$20,$20
        .BYTE $20,$20,$94,$96,$95,$97,$20,$20
        .BYTE $20,$20,$20,$9B,$9D,$20,$9A,$9C
        .BYTE $9E,$A0,$A2,$A4,$A6,$A8,$AA,$AC
        .BYTE $8C,$8E,$20,$80,$80,$80,$80,$80
        .BYTE $80,$80,$80,$20,$20,$80,$80,$80
        .BYTE $80,$80,$80,$80,$80,$80,$80,$80
        .BYTE $80,$80,$80,$9A,$9C,$20,$9B,$9D
        .BYTE $9F,$A1,$A3,$A5,$A7,$A9,$AB,$AD
        .BYTE $8D,$8F,$20,$90,$92,$91,$93,$20
        .BYTE $20,$AE,$B0,$AF,$B1,$30,$30,$30
        .BYTE $30,$30,$30,$30,$20,$20,$B2,$B4
        .BYTE $30,$30,$20,$9B,$9D,$20,$99,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20
f5125   .BYTE $20,$09,$09,$00,$01,$01,$01,$01
        .BYTE $00,$00,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$00,$00,$01
        .BYTE $01,$01,$01,$00,$07,$07,$00,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$09,$09,$00,$02,$07,$07,$05
        .BYTE $05,$07,$07,$02,$00,$00,$00,$00
        .BYTE $00,$00,$00,$01,$01,$01,$01,$00
        .BYTE $00,$00,$00,$00,$07,$07,$00,$07
        .BYTE $07,$04,$04,$0E,$0E,$08,$08,$0A
        .BYTE $0A,$06,$06,$00,$02,$07,$07,$05
        .BYTE $05,$07,$07,$02,$00,$00,$02,$02
        .BYTE $08,$08,$07,$07,$05,$05,$0E,$0E
        .BYTE $04,$04,$06,$06,$07,$07,$00,$07
        .BYTE $07,$04,$04,$0E,$0E,$08,$08,$0A
        .BYTE $0A,$06,$06,$00,$01,$01,$01,$01
        .BYTE $00,$00,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$00,$00,$01
        .BYTE $01,$01,$01,$00,$07,$07,$00,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01
f51C6   .BYTE $92,$90,$94,$96,$98
;-------------------------------
; s51CB
;-------------------------------
s51CB   
        LDX a78B0
        LDA f51C6,X
        STA a73AD
        LDA #$00
        STA a73AC
        LDX a78B2
        LDA f51C6,X
        STA a73AF
        LDA #$00
        STA a73AE
        JSR s52CE
        LDA a5279
        BNE b51F7
        LDA #$08
        STA a5E76
        STA a5E77
b51F7   LDA a78B0
        STA a78B1
        LDA a78B2
        STA a78B3
        JSR s5715
        LDX #$08
b5208   LDA #$ED
        STA f7E48,X
        LDA #$F0
        STA f7E50,X
        LDA f5270,X
        STA f9FF7,X
        DEX 
        BNE b5208
        STX a5279
        JSR s7C8B
        JSR s7C91
        LDA #<p5D33
        STA a79AE
        LDA #>p5D33
        STA a79AF
        LDA #<p5D7E
        STA a79AC
        LDA #>p5D7E
        STA a79AD
;-------------------------------
; s5238
;-------------------------------
s5238   
        LDX #$0A
        LDA #$20
b523C   STA SCREEN_RAM + $0365,X
        STA SCREEN_RAM + $03DD,X
        DEX 
        BNE b523C
        LDX a78B0
        LDY f527F,X
        LDA #$98
        STA SCREEN_RAM + $0365,Y
        LDX a78B2
        LDY f527F,X
        LDA #$99
        STA SCREEN_RAM + $03DD,Y
        RTS 

        .BYTE $02,$02,$02,$03,$04,$05,$06,$07
        .BYTE $08,$30,$30,$30,$20,$18,$10,$0C
        .BYTE $0A,$06,$04,$02
f5270   .BYTE $01,$00,$00,$01,$01,$00,$04,$20
        .BYTE $00
a5279   .BYTE $00,$08,$08
a527C   .BYTE $00
a527D   .BYTE $00
a527E   .BYTE $01
f527F   .BYTE $01,$03,$05,$07,$09
;-------------------------------
; s5284
;-------------------------------
s5284   
        LDA a760C
        CMP #$50
        BMI b52A7
        LDA #$01
        STA a52CD
b5290   RTS 

b5291   LDA a527E
        BEQ b5290
        LDX #$A0
b5298   LDA f5125,X
        STA fDB47,X
        DEX 
        BNE b5298
        LDA #$00
        STA a527E
b52A6   RTS 

b52A7   LDA a527E
        BNE b52A6
        LDA #$02
        STA a52CD
        RTS 

b52B2   LDX #$A0
        LDA #$0B
b52B6   STA fDB47,X
        DEX 
        BNE b52B6
        LDA #$01
        STA a527E
        RTS 

;-------------------------------
; s52C2
;-------------------------------
s52C2   
        LDY #$00
        STY a52CD
        CMP #$01
        BEQ b5291
        BNE b52B2
a52CD   .BYTE $00
;-------------------------------
; s52CE
;-------------------------------
s52CE   
        LDA #$07
        STA a47
        LDA #$63
        STA a46
        LDX a78B0
        JSR s52E3
        LDA #$B3
        STA a46
        LDX a78B2
;-------------------------------
; s52E3
;-------------------------------
s52E3   
        TXA 
        ASL 
        ASL 
        CLC 
        ADC #$9A
        LDY #$00
        STA (p46),Y
        LDY #$28
        CLC 
        ADC #$01
        STA (p46),Y
        LDY #$01
        CLC 
        ADC #$01
        STA (p46),Y
        LDY #$29
        CLC 
        ADC #$01
        STA (p46),Y
        LDA #$DB
        STA a47
        LDA f531C,X
        LDY #$00
        STA (p46),Y
        INY 
        STA (p46),Y
        LDY #$28
        STA (p46),Y
        INY 
        STA (p46),Y
        LDA #$07
        STA a47
        RTS 

f531C   .BYTE $07,$04,$0E,$08,$0A
a5321   .BYTE $00
a5322   .BYTE $00
a5323   .BYTE $00
a5324   .BYTE $00
;-------------------------------
; s5325
;-------------------------------
s5325   
        LDA a5322
        BNE b532F
        LDA a5321
        BEQ b5350
b532F   LDX #$06
b5331   INC SCREEN_RAM + $0354,X
        LDA SCREEN_RAM + $0354,X
        CMP #$3A
        BNE b5343
        LDA #$30
        STA SCREEN_RAM + $0354,X
        DEX 
        BNE b5331
b5343   DEC a5321
        LDA a5321
        CMP #$FF
        BNE b5350
        DEC a5322
b5350   LDA a5324
        BNE b535A
        LDA a5323
        BEQ b537B
b535A   LDX #$06
b535C   INC SCREEN_RAM + $03CC,X
        LDA SCREEN_RAM + $03CC,X
        CMP #$3A
        BNE b536E
        LDA #$30
        STA SCREEN_RAM + $03CC,X
        DEX 
        BNE b535C
b536E   DEC a5323
        LDA a5323
        CMP #$FF
        BNE b537B
        DEC a5324
b537B   RTS 

;-------------------------------
; s537C
;-------------------------------
s537C   
        LDX #$03
        STX a53B4
        STX a53B5
b5384   LDA #$80
        STA SCREEN_RAM + $0373,X
        STA SCREEN_RAM + $039B,X
        LDA #$20
        STA SCREEN_RAM + $0377,X
        STA SCREEN_RAM + $039F,X
        DEX 
        CPX #$FF
        BNE b5384
        STA SCREEN_RAM + $037B
        STA SCREEN_RAM + $03A3
        LDA #$00
        STA a53B6
        LDX #$0E
        LDA #$20
b53A8   STA SCREEN_RAM + $03A4,X
        DEX 
        BNE b53A8
        LDA #$87
        STA SCREEN_RAM + $03A5
b53B3   RTS 

a53B4   .BYTE $03
a53B5   .BYTE $03
a53B6   .BYTE $00
a53B7   .BYTE $00
a53B8   .BYTE $00
;-------------------------------
; s53B9
;-------------------------------
s53B9   
        DEC a543D
        BNE b53B3
        LDA #$04
        STA a543D
        LDA a53B7
        BEQ b53FB
        DEC a53B7
        LDX a53B7
        LDA f542C,X
        LDY #$04
b53D3   STA fDB4A,Y
        DEY 
        BNE b53D3
        LDX a53B4
        INC SCREEN_RAM + $0373,X
        LDA SCREEN_RAM + $0373,X
        CMP #$88
        BNE b53FB
        LDA #$20
        STA SCREEN_RAM + $0373,X
        DEX 
        STX a53B4
        CPX #$FF
        BNE b53FB
b53F3   LDA #$00
        STA a40D1
        JMP j57F6

b53FB   LDA a53B8
        BEQ b542B
        DEC a53B8
        LDX a53B8
        LDA f542C,X
        LDY #$04
b540B   STA fDBC2,Y
        DEY 
        BNE b540B
        LDX a53B5
        INC SCREEN_RAM + $039B,X
        LDA SCREEN_RAM + $039B,X
        CMP #$88
        BNE b542B
        LDA #$20
        STA SCREEN_RAM + $039B,X
        DEX 
        STX a53B5
        CPX #$FF
        BEQ b53F3
b542B   RTS 

f542C   .BYTE $01,$06,$02,$04,$05,$03,$07,$01
        .BYTE $00,$06,$02,$04,$05,$03,$07,$01
        .BYTE $06
a543D   .BYTE $01
;-------------------------------
; s543E
;-------------------------------
s543E   
        STX a5529
        LDX a53B4
        INC SCREEN_RAM + $0373,X
        LDA SCREEN_RAM + $0373,X
        CMP #$88
        BNE b547B
        LDA #$20
        STA SCREEN_RAM + $0373,X
        DEX 
        STX a53B4
        CPX #$FF
        BNE b547B
b545B   JMP b53F3

;-------------------------------
; j545E
;-------------------------------
j545E   
        STX a5529
        LDX a53B5
        INC SCREEN_RAM + $039B,X
        LDA SCREEN_RAM + $039B,X
        CMP #$88
        BNE b547B
        LDA #$20
        STA SCREEN_RAM + $039B,X
        DEX 
        STX a53B5
        CMP #$FF
        BEQ b545B
b547B   LDX a5529
        RTS 

b547F   LDA #$01
        STA a40D1
        JMP j57F6

;-------------------------------
; s5487
;-------------------------------
s5487   
        STX a5529
        LDX a53B4
        DEC SCREEN_RAM + $0373,X
        LDA SCREEN_RAM + $0373,X
        CMP #$7F
        BNE b547B
        LDA #$80
        STA SCREEN_RAM + $0373,X
        INX 
        STX a53B4
        CPX #$08
        BEQ b547F
        LDA #$87
        STA SCREEN_RAM + $0373,X
        BNE b547B
;-------------------------------
; j54AB
;-------------------------------
j54AB   
        STX a5529
        LDX a53B5
        DEC SCREEN_RAM + $039B,X
        LDA SCREEN_RAM + $039B,X
        CMP #$7F
        BNE b547B
        LDA #$80
        STA SCREEN_RAM + $039B,X
        INX 
        STX a53B5
        CPX #$08
        BEQ b547F
        LDA #$87
        STA SCREEN_RAM + $039B,X
        BNE b547B
;-------------------------------
; s54CF
;-------------------------------
s54CF   
        LDX a53B6
        CPX #$FF
        BNE b54DF
        INX 
        STX a53B6
        LDA #$87
        STA SCREEN_RAM + $03A5
b54DF   DEC SCREEN_RAM + $03A5,X
        LDA SCREEN_RAM + $03A5,X
        CMP #$7F
        BNE b5508
        LDA #$80
        STA SCREEN_RAM + $03A5,X
        INX 
        CPX #$0E
        BEQ b54FC
;-------------------------------
; j54F3
;-------------------------------
j54F3   
        LDA #$87
        STA SCREEN_RAM + $03A5,X
        STX a53B6
        RTS 

b54FC   LDA a797D
        BEQ b5505
        DEX 
        JMP j54F3

b5505   INC a5509
b5508   RTS 

a5509   .BYTE $00
;-------------------------------
; s550A
;-------------------------------
s550A   
        LDX a53B6
        CPX #$FF
        BEQ b5528
        INC SCREEN_RAM + $03A5,X
        LDA SCREEN_RAM + $03A5,X
        CMP #$88
        BNE b5508
        LDA #$20
        STA SCREEN_RAM + $03A5,X
        DEX 
        STX a53B6
        CPX #$FF
        BNE b5508
b5528   RTS 

a5529   .BYTE $00
;-------------------------------
; s552A
;-------------------------------
s552A   
        LDA a6E2C
        BNE b5530
b552F   RTS 

b5530   LDA a7177
        BNE b552F
        LDA a53B4
        CMP #$04
        BPL b5547
        JSR s550A
        BEQ b554D
        JSR s5487
        JMP b554D

b5547   JSR s54CF
        JSR s543E
b554D   LDA a53B5
        CMP #$04
        BPL b555C
        JSR s550A
        BEQ b552F
        JMP j54AB

b555C   JSR s54CF
        JMP j545E

;-------------------------------
; s5562
;-------------------------------
s5562   
        LDY #$23
        LDA (p40),Y
        BEQ b5572
        STA a4A
b556A   JSR s5487
        DEC a4A
        BNE b556A
        RTS 

b5572   JMP s5487

;-------------------------------
; s5575
;-------------------------------
s5575   
        LDY #$23
        LDA (p40),Y
        BEQ b5585
        STA a4A
b557D   JSR j54AB
        DEC a4A
        BNE b557D
        RTS 

b5585   JMP j54AB

a5588   .BYTE $01
a5589   .BYTE $09
;-------------------------------
; s558A
;-------------------------------
s558A   
        LDA #$01
        STA a4850
        LDA a5588
        BNE b55BD
        LDA #$30
        STA SCREEN_RAM + $0360
        STA SCREEN_RAM + $0361
        LDX a5589
        BEQ b55B6
b55A1   INC SCREEN_RAM + $0361
        LDA SCREEN_RAM + $0361
        CMP #$3A
        BNE b55B3
        LDA #$30
        STA SCREEN_RAM + $0361
        INC SCREEN_RAM + $0360
b55B3   DEX 
        BNE b55A1
b55B6   LDA a78B1
        PHA 
        JMP j55E3

b55BD   LDA #$30
        STA SCREEN_RAM + $03D8
        STA SCREEN_RAM + $03D9
        LDX a5589
        BEQ b55DF
b55CA   INC SCREEN_RAM + $03D9
        LDA SCREEN_RAM + $03D9
        CMP #$3A
        BNE b55DC
        LDA #$30
        STA SCREEN_RAM + $03D9
        INC SCREEN_RAM + $03D8
b55DC   DEX 
        BNE b55CA
b55DF   LDA a78B3
        PHA 
;-------------------------------
; j55E3
;-------------------------------
j55E3   
        LDA #<p4788
        STA a4E
        LDA #>p4788
        STA a4F
        PLA 
        TAX 
        BEQ b55FF
b55EF   LDA a4E
        CLC 
        ADC #$28
        STA a4E
        LDA a4F
        ADC #$00
        STA a4F
        DEX 
        BNE b55EF
b55FF   LDA a5589
        ASL 
        TAY 
        LDA (p4E),Y
        PHA 
        INY 
        LDA (p4E),Y
        PHA 
        LDA a5588
        BNE b5644
        PLA 
        STA a49B8
        STA a4E
        PLA 
        STA a49B9
        STA a4F
        LDY #$26
        LDX a78B1
        LDA f49BC,X
        BEQ b5628
        BNE b562A
b5628   LDA (p4E),Y
b562A   STA f49BC,X
        LDA a5EFC
        BNE b5638
        LDA f49BC,X
        STA a5EFC
b5638   DEY 
        LDA (p4E),Y
        STA a49D0
        LDA #$00
        STA a527C
        RTS 

b5644   PLA 
        STA a49BA
        STA a4E
        PLA 
        STA a49BB
        STA a4F
        LDY #$26
        LDX a78B3
        LDA f49C1,X
        BEQ b565C
        BNE b565E
b565C   LDA (p4E),Y
b565E   STA f49C1,X
        LDA a5EFD
        BNE b566C
        LDA f49C1,X
        STA a5EFD
b566C   DEY 
        LDA (p4E),Y
        STA a49D1
        LDA #$00
        STA a527D
        RTS 

;-------------------------------
; s5678
;-------------------------------
s5678   
        STX a5529
        LDX a78B1
        DEC f49BC,X
        LDA a5EFC
        BNE b568C
        LDA f49BC,X
        STA a5EFC
b568C   LDA f49BC,X
        BNE b56B9
        INC f49C6,X
        LDA f49C6,X
        CMP #$14
        BNE b569E
        DEC f49C6,X
b569E   LDA #$04
        STA a6D85
        LDA #$03
        STA a6D86
        LDA f49C6,X
        STA a5589
        LDA #$00
        STA a5588
        JSR s5753
        JSR s558A
b56B9   LDX a5529
        RTS 

;-------------------------------
; s56BD
;-------------------------------
s56BD   
        STX a5529
        LDX a78B3
        DEC f49C1,X
        LDA a5EFD
        BNE b56D1
        LDA f49C1,X
        STA a5EFD
b56D1   LDA f49C1,X
        BNE b56B9
        INC f49CB,X
        LDA f49CB,X
        CMP #$14
        BNE b56E3
        DEC f49CB,X
b56E3   LDA #$04
        STA a6D85
        LDA #$03
        STA a6D86
        LDA f49CB,X
        STA a5589
        LDA #$01
        STA a5588
        JSR s5753
        JSR s558A
        JMP b56B9

;-------------------------------
; s5701
;-------------------------------
s5701   
        LDX #$05
        LDA #$00
b5705   STA a49BB,X
        STA f49C5,X
        STA f49CA,X
        STA f49C0,X
        DEX 
        BNE b5705
        RTS 

;-------------------------------
; s5715
;-------------------------------
s5715   
        LDX a78B0
        LDA f49C6,X
        STA a5589
        LDA #$00
        STA a5588
        JSR s558A
        INC a5588
        LDX a78B2
        LDA f49CB,X
        STA a5589
        JMP s558A

;-------------------------------
; s5735
;-------------------------------
s5735   
        LDX a5E54
        BNE b573C
        TXA 
        RTS 

b573C   CPX #$01
        BEQ b5744
        ASL 
        DEX 
        BNE b573C
b5744   CLC 
        ASL 
        PHA 
        PHP 
        LDA #$00
        PLP 
        ADC #$00
        STA a5752
        PLA 
b5751   RTS 

a5752   .BYTE $00
;-------------------------------
; s5753
;-------------------------------
s5753   
        LDX #$09
        LDA a7EE1
        BNE b5751
        LDA #$13
b575C   CMP f49C6,X
        BNE b5767
        DEX 
        BPL b575C
        INC a6929
b5767   LDA a654F
        BNE b5751
        LDX a78B1
        LDY a4E19
        LDX #$00
b5774   LDA f49C5,Y
        CMP f57A6,X
        BMI b578E
        INX 
        DEY 
        BNE b5774
        LDX a4E19
        CPX a4E1A
        BEQ b5791
        INX 
        CPX a4E1A
        BEQ b5791
b578E   JMP j57AB

b5791   LDA a4E19
        CMP #$05
        BEQ b578E
        INC a4E19
        INC a60EF
        LDA #$00
        STA a797D
        JMP j57AB

f57A6   .BYTE $03,$06,$09,$0C,$0F
;-------------------------------
; j57AB
;-------------------------------
j57AB   
        LDY a4E1A
        LDX #$00
b57B0   LDA f49CA,Y
        CMP f57A6,X
        BMI b57CA
        INX 
        DEY 
        BNE b57B0
        LDX a4E1A
        CPX a4E19
        BEQ b57CB
        INX 
        CPX a4E19
        BEQ b57CB
b57CA   RTS 

b57CB   LDA a4E1A
        CMP #$05
        BEQ b57CA
        INC a4E1A
        INC a60EF
        LDA #$00
        STA a797D
        RTS 

;-------------------------------
; s57DE
;-------------------------------
s57DE   
        STY a57EC
        LDY a654F
        CLC 
        ADC f57ED,Y
        LDY a57EC
        RTS 

a57EC   .BYTE $23
f57ED   .BYTE $00,$0A,$14,$1E,$28,$32,$3C,$46
        .BYTE $50
;-------------------------------
; j57F6
;-------------------------------
j57F6   
        LDA #$01
        STA a40D2
        LDA a59B9
        BNE b5833
        LDA a7EE1
        BNE b5833
        LDX #$00
b5807   LDA #<pFC
        STA a583F
        LDA #>pFC
        STA a5840
        STA f583C,X
        INX 
        CPX #$03
        BNE b5807
        LDA #$01
        STA a6D85
        LDA #$03
        STA a6D86
        LDA #<p58EA
        STA a79AE
        LDA #>p58EA
        STA a79AF
        JSR s7C91
        LDX #$23
        RTS 

b5833   RTS 

f5834   .BYTE $01,$07,$03,$05,$04
f5839   .BYTE $02,$06,$00
f583C   .BYTE $50
a583D   .BYTE $A0
a583E   .BYTE $40
a583F   .BYTE $FE
a5840   .BYTE $08
;-------------------------------
; j5841
;-------------------------------
j5841   
        LDA a6D85
        BEQ b5847
        RTS 

b5847   LDA #$F0
        STA SCREEN_RAM + $03F8
        INC f583C
        INC a583D
        INC a583D
        LDA a583E
        CLC 
        ADC #$04
        STA a583E
        LDX #$00
b5860   LDA a583F
        STA f67D6,X
        STA f67DC,X
        LDY a5840
        LDA f5834,Y
        STA f67F0,X
        STA f67F6,X
        LDA a760C
        STA f67FC,X
        EOR #$FF
        CLC 
        ADC #$0C
        STA f6804,X
        LDA #$00
        STA f67E2,X
        STA f67EA,X
        CPX #$03
        BPL b58A9
        LDA #$B0
        CLC 
        ADC f583C,X
        STA f67C8,X
        STA f67D0,X
        BCC b58A6
        LDA f6B45,X
        STA f67E2,X
        STA f67EA,X
b58A6   JMP j58B5

b58A9   LDA #$B0
        SEC 
        SBC f5839,X
        STA f67C8,X
        STA f67D0,X
;-------------------------------
; j58B5
;-------------------------------
j58B5   
        INX 
        CPX #$06
        BNE b5860
        INC a583F
        LDA a583F
        CMP #$FF
        BNE b58C9
        LDA #$FC
        STA a583F
b58C9   DEC a58E9
        BNE b58E8
        LDA #$0A
        STA a58E9
        INC a5840
        LDA a5840
        STA a6D85
        LDY #$02
        STY a6D86
        CMP #$08
        BNE b58E8
        JMP j596C

b58E8   RTS 

a58E9   .BYTE $0A
p58EA   .BYTE $00,$00,$0F,$0C,$00,$00,$00,$0F
        .BYTE $13,$00,$00,$00,$00,$0D,$00,$00
        .BYTE $00,$00,$14,$00,$00,$00,$80,$08
        .BYTE $00,$00,$00,$40,$0F,$00,$00,$00
        .BYTE $81,$0B,$00,$00,$00,$81,$12,$02
        .BYTE $08,$01,$0C,$08,$00,$0F,$01,$0C
        .BYTE $0F,$01,$00,$81,$1C,$00,$00,$00
        .BYTE $00,$20,$08,$00,$00,$00,$20,$0F
        .BYTE $00,$00,$00,$81,$0B,$00,$00,$00
        .BYTE $21,$12,$02,$08,$02,$01,$08,$00
        .BYTE $0F,$02,$45,$0F,$01,$00,$81,$1F
        .BYTE $00,$00,$00,$00,$10,$08,$02,$08
        .BYTE $02,$01,$08,$00,$0F,$02,$01,$0F
        .BYTE $00,$18,$02,$01,$18,$01,$00,$81
        .BYTE $0F,$00,$00,$00,$00,$80,$0B,$00
        .BYTE $00,$00,$80,$12,$00,$00,$80,$CA
        .BYTE $7B,$00
;-------------------------------
; j596C
;-------------------------------
j596C   
        LDX #$00
b596E   LDA #$C0
        STA f67D6,X
        STA f67DC,X
        INX 
        CPX #$06
        BNE b596E
        LDA #$01
        STA a59B9
        JSR s6907
        LDA a78B1
        STA a78B0
        LDA a78B3
        STA a78B2
        JSR s51CB
        LDA #$01
        STA a78C7
        STA a78C6
        LDA #<p5C0D
        STA a79AC
        LDA #>p5C0D
        STA a79AD
        LDA #<p5C35
        STA a79AE
        LDA #>p5C35
        STA a79AF
        LDA #$00
        STA $D015    ;Sprite display Enable
        JSR s7C8B
        JMP s7C91

a59B9   .BYTE $00
a59BA   .BYTE $02
;-------------------------------
; j59BB
;-------------------------------
j59BB   
        LDY a5AB8
        LDA f5CA7,Y
        STA $D021    ;Background Color 0
        INY 
        LDA f5CA7,Y
        BEQ b59D8
        STY a5AB8
        LDA $D012    ;Raster Position
        CLC 
        ADC #$01
        STA $D012    ;Raster Position
        BNE b5A03
b59D8   LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2
        JSR s79B0
        LDX #$1F
        LDA a5CC7
        PHA 
b59E9   LDA f5CA7,X
        STA f5CA8,X
        DEX 
        BPL b59E9
        PLA 
        STA f5CA7
        LDA #$40
        STA $D012    ;Raster Position
        LDA #$00
        STA a5AB8
        STA $D020    ;Border Color
b5A03   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

;-------------------------------
; s5A11
;-------------------------------
s5A11   
        JSR s5A96
        DEC a59BA
        BPL b5A1E
        BEQ b5A1E
        JMP j63D6

b5A1E   JSR s7316
        AND #$07
        TAY 
        JSR s5A49
        LDX #$14
b5A29   LDA a5AB8,X
        AND #$3F
        STA SCREEN_RAM + $00F8,X
        DEX 
        BNE b5A29
        JSR s64E9
        LDA a59BA
        CLC 
        ADC #$31
        STA SCREEN_RAM + $0109
        JSR s7316
        AND #$07
        CLC 
        ADC #$08
        TAY 
;-------------------------------
; s5A49
;-------------------------------
s5A49   
        LDA #<p5ACD
        STA a45
        LDA #>p5ACD
        STA a46
        STY a47
        CPY #$00
        BEQ b5A67
b5A57   LDA a45
        CLC 
        ADC #$14
        STA a45
        LDA a46
        ADC #$00
        STA a46
        DEY 
        BNE b5A57
b5A67   LDA a47
        AND #$08
        BNE b5A7A
b5A6D   LDA (p45),Y
        AND #$3F
        STA SCREEN_RAM + $00A9,Y
        INY 
        CPY #$14
        BNE b5A6D
        RTS 

b5A7A   LDA (p45),Y
        AND #$3F
        STA SCREEN_RAM + $0149,Y
        INY 
        CPY #$14
        BNE b5A7A
        LDA #$30
        STA a45
b5A8A   LDX #$40
b5A8C   DEY 
        BNE b5A8C
        DEX 
        BNE b5A8C
        DEC a45
        BNE b5A8A
;-------------------------------
; s5A96
;-------------------------------
s5A96   
        LDX #$00
b5A98   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0248,X
        LDA #$01
        STA fD800,X
        STA fD900,X
        STA fDA00,X
        STA fDA48,X
        DEX 
        BNE b5A98
        RTS 

a5AB8   .TEXT $00, "  GILBIES LEFT: 0.. "
p5ACD   .TEXT "TAKE OUT THAT BRIDGE% % I BET THAT HURT!"
        .TEXT "GOT YOU, SPACE CADET%% SUPPERS READY! %%"
        .TEXT "ZAPPED AGAIN........ONE DESTRUCTED DROID"
        .TEXT "YOU BLEW THAT ONE!..ARE YOU NERVOUS??..."
        .TEXT "GO GIVE THEM HELL!!!GO FORTH AND KILL!!!"
        .TEXT "HAPPY HUNTING, ACE!!SEEK AND ANNIHILATE!"
        .TEXT "YAK SEZ GO ZAP 'EM!!FLY FAST AND MEAN..."
        .TEXT "LASERBLAZE THE SCUM!HEAVY METAL THUNDER"
        .BYTE $21
p5C0D   .BYTE $00,$00,$0F,$05,$00,$00,$00,$00
        .BYTE $06,$00,$00,$00,$20,$01,$00,$00
        .BYTE $00,$21,$04,$02,$01,$02,$43,$01
        .BYTE $01,$00,$81,$F0,$00,$00,$00,$00
        .BYTE $20,$04,$00,$00,$80,$CA,$7B,$00
p5C35   .BYTE $00,$00,$0F,$18,$00,$00,$00,$0F
        .BYTE $0C,$00,$00,$00,$0F,$13,$00,$00
        .BYTE $00,$00,$0D,$00,$00,$00,$00,$14
        .BYTE $01,$00,$00,$10,$08,$00,$00,$00
        .BYTE $10,$0F,$00,$00,$00,$21,$0B,$00
        .BYTE $00,$00,$21,$12,$02,$08,$01,$04
        .BYTE $08,$00,$0F,$01,$04,$0F,$01,$00
        .BYTE $81,$05,$00,$00,$00,$00,$10,$08
        .BYTE $00,$00,$00,$10,$0F,$00,$00,$00
        .BYTE $11,$0B,$00,$00,$00,$11,$12,$02
        .BYTE $08,$02,$02,$08,$00,$0F,$02,$02
        .BYTE $0F,$01,$00,$81,$08,$00,$00,$18
        .BYTE $05,$01,$4E,$5C,$00,$00,$10,$0B
        .BYTE $00,$00,$00,$10,$12,$00,$00,$80
        .BYTE $CA,$7B
f5CA7   .BYTE $08
f5CA8   .BYTE $07,$05,$0E,$04,$06,$0F,$0F,$0C
        .BYTE $0F,$0C,$0C,$0B,$0C,$0B,$0B,$80
        .BYTE $0B,$80,$80,$0B,$80,$0B,$0B,$0C
        .BYTE $0B,$0C,$0C,$0F,$0C,$0F,$0F
a5CC7   .BYTE $02,$00
;-------------------------------
; j5CC9
;-------------------------------
j5CC9   
        LDX #$00
b5CCB   LDA a760C
        STA f67FC,X
        EOR #$FF
        CLC 
        ADC #$08
        STA f6804,X
        LDA a6C25
        STA f67D6,X
        CLC 
        ADC #$13
        STA f67DC,X
        LDA f67A5,X
        STA f67F0,X
        STA f67F6,X
        LDA a6E12
        BMI b5D0B
        LDA f5D27,X
        STA f67C8,X
        LDA #$00
        STA f67E2,X
        LDA f5D2D,X
        STA f67D0,X
        LDA #$00
        STA f67EA,X
        BEQ b5D21
b5D0B   LDA f5D2D,X
        STA f67C8,X
        LDA #$00
        STA f67E2,X
        LDA f5D27,X
        STA f67D0,X
        LDA #$00
        STA f67EA,X
b5D21   INX 
        CPX #$06
        BNE b5CCB
        RTS 

f5D27   .BYTE $B8,$C0,$C8,$D0,$D8,$E0
f5D2D   .BYTE $A8,$A0,$98,$90,$88,$80
p5D33   BRK #$00
        .BYTE $0F,$0C,$00,$00,$00,$0F,$13,$00
        .BYTE $00,$00,$0F,$18,$00,$00,$00,$00
        .BYTE $0D,$00,$00,$00,$00,$14,$00,$00
        .BYTE $00,$03,$08,$00,$00,$00,$03,$0F
        .BYTE $00,$00,$00,$21,$0B,$00,$00,$00
        .BYTE $08,$0E,$00,$00,$00,$00,$07,$00
        .BYTE $00,$00,$21,$12,$01,$18,$05,$00
        .BYTE $65,$5D,$00,$00,$20,$0B,$00,$00
        .BYTE $00,$20,$12,$00,$00,$80,$CA,$7B
        .BYTE $00
p5D7E   .BYTE $00,$00,$0F,$05,$00,$00,$00,$00
        .BYTE $06,$00,$00,$00,$00,$01,$00,$00
        .BYTE $00,$11,$04,$02,$01,$01,$64,$01
        .BYTE $01,$00,$81,$08,$00,$00,$01,$01
        .BYTE $18,$01,$01,$18,$05,$01,$8D,$5D
        .BYTE $00,$00,$10,$04,$00,$00,$80,$CA
        .BYTE $7B,$00
p5DB0   .BYTE $00,$00,$0F,$0C,$00,$00,$00,$0F
        .BYTE $13,$00,$00,$00,$00,$0D,$00,$00
        .BYTE $00,$00,$14,$00,$00,$00,$10,$08
        .BYTE $00,$00,$00,$15,$12,$00,$00,$00
        .BYTE $20,$0B,$00,$00,$00,$0F,$18,$00
        .BYTE $00,$00,$40,$0F,$02,$0F,$02,$28
        .BYTE $0F,$01,$00,$81,$08,$00,$00,$18
        .BYTE $05,$05,$D8,$5D,$00,$00,$80,$0B
        .BYTE $00,$00,$00,$80,$12,$00,$00,$00
        .BYTE $0F,$18,$00,$00,$80,$CA,$7B,$00
;-------------------------------
; s5E00
;-------------------------------
s5E00   
        LDA #$23
        STA SCREEN_RAM + $0387
        LDA #$01
        STA aDB87
        LDA a6E12
        BPL b5E14
        EOR #$FF
        CLC 
        ADC #$01
b5E14   TAX 
        LDA f5E2C,X
        TAY 
        LDA f5E4A,Y
        CLC 
        ADC #$30
        STA SCREEN_RAM + $0388
        LDA f5E4F,Y
        STA aDB88
        STY a5E54
        RTS 

f5E2C   .BYTE $00,$00,$01,$01,$01,$01,$02,$02
        .BYTE $02,$02,$02,$02,$02,$02,$03,$03
        .BYTE $04,$04,$03,$02,$02,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01
f5E4A   .BYTE $00,$01,$02,$04,$08
f5E4F   .BYTE $06,$04,$05,$07,$01
a5E54   .BYTE $01
;-------------------------------
; s5E55
;-------------------------------
s5E55   
        LDA a797D
        BEQ b5E5D
        JMP j5EF6

b5E5D   LDA a4F57
        BEQ b5E69
        LDA #$08
        STA a5E77
        BNE b5E6E
b5E69   LDA #$08
        STA a5E76
b5E6E   DEC a5E75
        BEQ b5E79
        BNE b5EB8
a5E75   .BYTE $A3
a5E76   .BYTE $08
a5E77   .BYTE $08
a5E78   .BYTE $23
b5E79   DEC a5E78
        BNE b5EB8
        LDA #$10
        STA a5E78
        LDA #$00
        STA a7C8A
        LDA a4F57
        BEQ b5EA6
        DEC a5E76
        BNE b5E95
        INC a7C8A
b5E95   LDA a5E76
        CMP #$FF
        BNE b5EB8
;-------------------------------
; j5E9C
;-------------------------------
j5E9C   
        LDA #$02
        STA a40D1
        JMP j57F6

        BNE b5EB8
b5EA6   DEC a5E77
        BNE b5EAE
        INC a7C8A
b5EAE   LDA a5E77
        CMP #$FF
        BNE b5EB8
        JMP j5E9C

b5EB8   LDA #$08
        SEC 
        SBC a5E76
        TAY 
        LDA f5834,Y
        STA aDB48
        STA aDB49
        STA aDB70
        STA aDB71
        LDA #$08
        SEC 
        SBC a5E77
        TAY 
        LDA f5834,Y
        STA aDB98
        STA aDB99
        STA aDBC0
        STA aDBC1
        JMP j5EF6

        .BYTE $C0,$C0,$C0,$C0,$C0,$00,$00,$00
        .BYTE $00
f5EF0   .BYTE $00,$08,$08,$08,$08,$08
;-------------------------------
; j5EF6
;-------------------------------
j5EF6   
        RTS 

        .BYTE $00,$02,$04,$06,$08
a5EFC   .BYTE $00
a5EFD   .BYTE $00
a5EFE   .BYTE $30
a5EFF   .BYTE $30
;-------------------------------
; s5F00
;-------------------------------
s5F00   
        LDA #$30
        STA a5EFE
        STA a5EFF
        LDA a5EFC
        BEQ b5F21
b5F0D   JSR s5F67
        DEC a5EFC
        BNE b5F0D
        LDA a5EFE
        STA SCREEN_RAM + $034F
        LDA a5EFF
        STA SCREEN_RAM + $0350
b5F21   LDA a6E12
        BNE b5F28
        LDA #$01
b5F28   PHA 
        TAY 
        LDA f67A5,Y
        STA aDB4F
        STA aDB50
        LDA a797D
        BEQ b5F3A
        PLA 
        RTS 

b5F3A   LDA #$30
        STA a5EFE
        STA a5EFF
        LDA a5EFD
        BEQ b5F5B
b5F47   JSR s5F67
        DEC a5EFD
        BNE b5F47
        LDA a5EFE
        STA SCREEN_RAM + $03C7
        LDA a5EFF
        STA SCREEN_RAM + $03C8
b5F5B   PLA 
        TAY 
        LDA f67A5,Y
        STA aDBC7
        STA aDBC8
        RTS 

;-------------------------------
; s5F67
;-------------------------------
s5F67   
        INC a5EFF
        LDA a5EFF
        CMP #$3A
        BNE b5F77
        LDA #$01
        STA a5EFF
b5F76   RTS 

b5F77   CMP #$07
        BNE b5F76
        LDA #$30
        STA a5EFF
        INC a5EFE
        LDA a5EFE
        CMP #$3A
        BNE b5F76
        LDA #$01
        STA a5EFE
f5F8F   RTS 

        .BYTE $88,$8A,$20,$90,$92,$91,$93,$31
        .BYTE $38,$AE,$B0,$AF,$B1,$30,$30,$30
        .BYTE $30,$30,$30,$30,$20,$20,$B2,$B4
        .BYTE $30,$30,$20,$9A,$9C,$20,$98,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20,$20
        .BYTE $89,$8B,$20,$80,$80,$80,$80,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20,$20
        .BYTE $20,$20,$94,$96,$95,$97,$20,$23
        .BYTE $31,$20,$20,$9B,$9D,$20,$9A,$9C
        .BYTE $9E,$A0,$A2,$A4,$A6,$A8,$AA,$AC
        .BYTE $8C,$8E,$20,$80,$80,$80,$80,$20
        .BYTE $20,$20,$20,$20,$20,$87,$20,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20,$20
        .BYTE $20,$20,$20,$9A,$9C,$20,$9B,$9D
        .BYTE $9F
p6001   .BYTE $A1,$A3,$A5,$A7,$A9,$AB,$AD,$8D
        .BYTE $8F,$20,$90,$92,$91,$93,$20,$20
        .BYTE $AE,$B0,$AF,$B1,$30,$30,$30,$30
        .BYTE $30,$30,$30,$20,$20,$B2,$B4,$30
        .BYTE $30,$20,$9B,$9D,$20,$99,$20,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20
;-------------------------------
; s6030
;-------------------------------
s6030   
        LDX #$A0
b6032   LDA SCREEN_RAM + $0347,X
        STA f5F8F,X
        DEX 
        BNE b6032
        RTS 

;-------------------------------
; s603C
;-------------------------------
s603C   
        LDX #$A0
b603E   LDA f5F8F,X
        STA SCREEN_RAM + $0347,X
        DEX 
        BNE b603E
b6047   RTS 

;-------------------------------
; s6048
;-------------------------------
s6048   
        LDA a797D
        BEQ b6047
        LDX #$28
b604F   LDA f60C6,X
        AND #$3F
        STA SCREEN_RAM + $02F7,X
        LDA #$01
        STA fDAF7,X
        DEX 
        BNE b604F
        LDX #$28
b6061   LDA f609E,X
        CLC 
        ADC #$40
        STA SCREEN_RAM + $0257,X
        DEX 
        BNE b6061
        LDX #$10
b606F   LDY f607E,X
        LDA f608E,X
        CLC 
        ADC #$40
        STA SCREEN_RAM + $01E4,Y
        DEX 
        BNE b606F
f607E   RTS 

        .BYTE $00,$01,$02,$03,$28,$29,$2A,$2B
        .BYTE $50,$51,$52,$53,$78,$79,$7A
f608E   .BYTE $7B,$30,$32,$38,$3A,$31,$33,$39
        .BYTE $3B,$34,$36,$3C,$3E,$35,$37,$3D
f609E   .BYTE $3F,$01,$03 ;RLA p0301,X
        .BYTE $01,$03,$01,$03,$01,$03,$01,$03
        .BYTE $01,$03,$01,$03,$01,$03,$01,$03
        .BYTE $01,$03,$01,$03,$01,$03,$01,$03
        .BYTE $01,$03,$01,$03,$1D,$1F,$00,$02
        .BYTE $00,$02,$00,$02,$00
f60C6   .BYTE $02    ;JAM 
        .TEXT "  WARP GATE       GILBY   CORE  NOT-CORE"
a60EF   .BYTE $00
;-------------------------------
; s60F0
;-------------------------------
s60F0   
        JSR s5A96
        LDX a654F
        BEQ b6105
b60F8   LDA #$1C
        STA SCREEN_RAM - $01,X
        LDA #$07
        STA fD7FF,X
        DEX 
        BNE b60F8
b6105   LDY #$00
        STY $D020    ;Border Color
        STY $D021    ;Background Color 0
b610D   LDX #$0A
b610F   LDA f61C3,X
        STA aFF
        LDA f61CD,X
        STA aFE
        LDA #$2D
        STA (pFE),Y
        LDA aFF
        CLC 
        ADC #$D4
        STA aFF
        LDA #$0B
        STA (pFE),Y
        DEX 
        BNE b610F
        INY 
        CPY #$14
        BNE b610D
        LDX #$00
b6132   LDY f49C6,X
        JSR s6196
        LDY f49CB,X
        JSR s61B4
        INX 
        CPX #$05
        BNE b6132
        JSR s6247
        LDX #$27
b6148   LDA f616D,X
        AND #$3F
        STA SCREEN_RAM + $02F8,X
        LDA #$07
        STA fDAF8,X
        DEX 
        BPL b6148
        LDX #$06
b615A   LDA fAAC1,X
        STA SCREEN_RAM + $0319,X
        DEX 
        BNE b615A
        LDA a59BA
        CLC 
        ADC #$31
        STA SCREEN_RAM + $0305
        RTS 

f616D   .TEXT "GILBIES LEFT 0: BONUS BOUNTY NOW 0000000"
b6195   RTS 

;-------------------------------
; s6196
;-------------------------------
s6196   
        LDA f61C4,X
        CLC 
        ADC #$D4
        STA aFF
        LDA f61CE,X
        STA aFE
;-------------------------------
; j61A3
;-------------------------------
j61A3   
        CPY #$00
        BEQ b6195
        LDA #$02
b61A9   STA (pFE),Y
        CPY #$00
        BEQ b6195
        DEY 
        LDA #$05
        BNE b61A9
;-------------------------------
; s61B4
;-------------------------------
s61B4   
        LDA f61C9,X
        CLC 
        ADC #$D4
        STA aFF
        LDA f61D3,X
        STA aFE
f61C3   =*+$02
        JMP j61A3

f61C4   .BYTE $04,$04,$04,$04,$04
f61C9   .BYTE $05,$05,$05,$05
f61CD   .BYTE $05
f61CE   .BYTE $F0,$CB,$A6,$81,$5C
f61D3   .BYTE $18,$43,$6E,$99,$C4
f61D8   .BYTE $04,$04 ;NOP $04
        .BYTE $04,$04,$04,$05,$05,$05,$05,$05
f61E2   .BYTE $A0,$7B,$56,$31,$0C,$40,$6B,$96
        .BYTE $C1,$EC
;-------------------------------
; s61EC
;-------------------------------
s61EC   
        LDA #$00
        STA $D015    ;Sprite display Enable
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA lastKeyPressed
        JSR s60F0
        LDX #$28
b61FE   LDA f62E4,X
        AND #$3F
        STA SCREEN_RAM + $0257,X
        LDA #$01
        STA fDA57,X
        DEX 
        BNE b61FE
        CLI 
        LDA #$05
        STA aFF
        LDX #$00
        LDY #$00
b6217   DEY 
        BNE b6217
        DEX 
        BNE b6217
        DEC aFF
        BNE b6217
        LDX #$28
b6223   LDA f630C,X
        AND #$3F
        STA SCREEN_RAM + $02A7,X
        LDA #$07
        STA fDAA7,X
        DEX 
        BNE b6223
b6233   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ b6233
b623A   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BNE b623A
        LDA #$00
        STA a60EF
        RTS 

;-------------------------------
; s6247
;-------------------------------
s6247   
        LDX #$00
b6249   LDA f61E2,X
        STA aFE
        LDA f61D8,X
        STA aFF
        LDA f62BB,X
        STA aFD
        TXA 
        PHA 
        LDX #$00
b625C   LDY f62AF,X
        LDA f62B3,X
        CLC 
        ADC aFD
        STA (pFE),Y
        INX 
        CPX #$04
        BNE b625C
        LDX #$0B
        PLA 
        STA aFD
        LDY aFD
        CPY #$05
        BMI b6287
        LDA aFD
        SEC 
        SBC #$05
        STA aFC
        LDY a4E1A
        DEY 
        CPY aFC
        JMP j628D

b6287   LDY a4E19
        DEY 
        CPY aFD
;-------------------------------
; j628D
;-------------------------------
j628D   
        BMI b6291
        LDX #$01
b6291   TXA 
        PHA 
        LDX #$00
        LDA aFF
        CLC 
        ADC #$D4
        STA aFF
        PLA 
b629D   LDY f62AF,X
        STA (pFE),Y
        INX 
        CPX #$04
        BNE b629D
        LDX aFD
        INX 
        CPX #$0A
        BNE b6249
        RTS 

f62AF   .BYTE $00,$01,$28,$29
f62B3   .BYTE $9A,$9C,$9B,$9D,$9A,$9C,$9B,$9D
f62BB   .BYTE $00,$04,$08,$0C,$10,$00,$04,$08
        .BYTE $0C,$10
p62C5   LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b62D2
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

b62D2   JSR s79B0
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$20
        STA $D012    ;Raster Position
f62E4   =*+$02
        JMP jEA31

        .TEXT "IRIDIS ALPHA: PROGRESS STATUS DISPLAY %"
f630C   .TEXT "%PRESS THE FIRE BUTTON WHEN YOU ARE READ"
        .TEXT "Y"
p6335   .BYTE $00
        BRK #$20
        .BYTE $04,$00,$00,$00,$03,$02,$00,$00
        .BYTE $00,$21,$04,$00,$00,$00,$60,$01
        .BYTE $02,$01,$01,$10,$01,$01,$00,$81
        .BYTE $08,$00,$00,$02,$05,$01,$44,$63
        .BYTE $00,$00,$20,$04,$00,$00,$80,$CA
        .BYTE $7B,$00
p6362   .BYTE $00,$00,$20,$04,$00,$00,$00,$03
        .BYTE $02,$00,$00,$00,$21,$04,$00,$00
        .BYTE $00,$A0,$01,$02,$01,$02,$10,$01
        .BYTE $01,$00,$81,$08,$00,$00,$02,$05
        .BYTE $01,$71,$63,$00,$00,$20,$04,$00
        .BYTE $00,$80,$CA,$7B,$00
;-------------------------------
; s638F
;-------------------------------
s638F   
        SEI 
        LDA #$34
        STA a01
        LDA #<j0810
        STA aFC
        LDA #>j0810
        STA aFD
        LDA #>pE800
        STA aFF
        LDA #<pE800
        STA aFE
b63A4   LDY #$00
b63A6   LDA (pFC),Y
        PHA 
        LDA (pFE),Y
        STA (pFC),Y
        PLA 
        STA (pFE),Y
        DEY 
        BNE b63A6
        INC aFD
        INC aFF
        LDA aFF
        CMP #$F9
        BNE b63A4
        LDA #$36
        STA a01
        RTS 

;-------------------------------
; s63C2
;-------------------------------
s63C2   
        JSR s638F
        JSR j0810
        SEI 
        LDA #<p62C5
        STA $0314    ;IRQ
        LDA #>p62C5
        STA $0315    ;IRQ
        JMP s638F

;-------------------------------
; j63D6
;-------------------------------
j63D6   
        SEI 
        LDA #<p62C5
        STA $0314    ;IRQ
        LDA #>p62C5
        STA $0315    ;IRQ
        CLI 
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        JSR s60F0
        LDA #$00
        STA a654F
        STA a4E19
        STA a4E1A
        LDX #$0A
b63FA   LDA f6425,X
        AND #$3F
        STA SCREEN_RAM + $00BD,X
        LDA f6430,X
        AND #$3F
        STA SCREEN_RAM + $010D,X
        LDA f643B,X
        AND #$3F
        STA SCREEN_RAM + $015D,X
        LDA #$01
        STA fD8BD,X
        STA fD90D,X
        LDA #$04
        STA fD95D,X
        DEX 
        BPL b63FA
        JMP j6446

f6425   .TEXT "GAME OVER.."
f6430   .TEXT "FINAL SCORE"
f643B   .TEXT "  0000000  "
;-------------------------------
; j6446
;-------------------------------
j6446   
        LDA #$5E
        STA aFE
        LDA #$05
        STA aFF
        LDA #<SCREEN_RAM + $0354
        STA aFC
        LDA #>SCREEN_RAM + $0354
        STA aFD
        JSR s6480
        LDA #$CC
        STA aFC
        JSR s6480
        LDA #$18
        STA aFC
        JSR s6480
        LDY #$C6
        LDX #$49
        LDA #<s60F0
        STA aC819
        LDA #>s60F0
        STA aC81A
        LDA #<f49C6
        STA aF0
        LDA #>f49C6
        STA aF1
        JMP jC800

;-------------------------------
; s6480
;-------------------------------
s6480   
        LDY #$07
b6482   LDA (pFC),Y
        SEC 
        SBC #$30
        BEQ b648D
        TAX 
        JSR s649E
b648D   LDA #$A0
        STA aFB
        LDX #$00
b6493   DEX 
        BNE b6493
        DEC aFB
        BNE b6493
        DEY 
        BNE b6482
        RTS 

;-------------------------------
; s649E
;-------------------------------
s649E   
        TYA 
        PHA 
b64A0   LDA (pFE),Y
        CLC 
        ADC #$01
        CMP #$3A
        BEQ b64AD
        STA (pFE),Y
        BNE b64B4
b64AD   LDA #$30
        STA (pFE),Y
        DEY 
        BNE b64A0
b64B4   PLA 
        TAY 
        LDA (pFC),Y
        SEC 
        SBC #$01
        STA (pFC),Y
        DEX 
        BNE s649E
        RTS 

f64C1   .TEXT "DEPLETED..OVERLOAD..ENTROPY...HIT SOMMAT"
;-------------------------------
; s64E9
;-------------------------------
s64E9   
        LDA #$00
        LDY a40D1
        BEQ b64F6
b64F0   CLC 
        ADC #$0A
        DEY 
        BNE b64F0
b64F6   TAX 
b64F7   LDA f64C1,X
        AND #$3F
        STA SCREEN_RAM + $02B7,Y
        LDA #$02
        STA fDAB7,Y
        INY 
        INX 
        CPY #$0A
        BNE b64F7
        RTS 

;-------------------------------
; s650B
;-------------------------------
s650B   
        JMP j6554

f650E   .BYTE $40,$46,$4C,$52,$58,$5E,$63,$68
        .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
        .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
        .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
        .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
        .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
        .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
        .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
        .BYTE $FF
a654F   .BYTE $00
a6550   .BYTE $00
a6551   .BYTE $00
a6552   .BYTE $00
a6553   .BYTE $00
;-------------------------------
; j6554
;-------------------------------
j6554   
        SEI 
        INC a654F
        LDA a654F
        AND #$07
        STA a654F
        LDA #$00
        STA a6929
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA #<p65D0
        STA $0314    ;IRQ
        LDA #>p65D0
        STA $0315    ;IRQ
        JSR s5A96
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$F0
        STA $D012    ;Raster Position
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        CLI 
        LDA #$FF
        STA $D015    ;Sprite display Enable
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDX #$07
b6595   LDA #$C1
        STA SCREEN_RAM + $03F8,X
        LDA f65EC,X
        STA $D027,X  ;Sprite 0 Color
        DEX 
        BPL b6595
        LDX #$0A
b65A5   LDA f6789,X
        AND #$3F
        STA SCREEN_RAM + $019F,X
        LDA #$07
        STA fD99F,X
        DEX 
        BPL b65A5
        LDX #$03
b65B7   INC fAAC0,X
        LDA fAAC0,X
        CMP #$3A
        BNE b65C9
        LDA #$30
        STA fAAC0,X
        DEX 
        BNE b65B7
b65C9   LDA lastKeyPressed
        CMP #$3C
        BNE b65C9
        RTS 

p65D0   LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b65F4
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

a65DD   .BYTE $04
a65DE   .BYTE $04
a65DF   .BYTE $02
a65E0   .BYTE $02
a65E1   .BYTE $00
a65E2   .BYTE $00
a65E3   .BYTE $00
a65E4   .BYTE $03
a65E5   .BYTE $03
a65E6   .BYTE $06
a65E7   .BYTE $06
a65E8   .BYTE $01
a65E9   .BYTE $01
a65EA   .BYTE $00
a65EB   .BYTE $00
f65EC   .BYTE $02,$0A,$08,$07,$05,$0E,$04,$06
b65F4   LDY #$00
        LDA #$F0
        STA $D012    ;Raster Position
        DEC a65DD
        BNE b6610
        LDA a65DE
        STA a65DD
        LDA a673D
        CLC 
        ADC a65E2
        STA a65E2
b6610   DEC a65E0
        BNE b6625
        LDA a65DF
        STA a65E0
        LDA a65E3
        CLC 
        ADC a673E
        STA a65E3
b6625   DEC a65E4
        BNE b6633
        LDA a65E5
        STA a65E4
        INC a65EA
b6633   DEC a65E6
        BNE b6641
        LDA a65E7
        STA a65E6
        INC a65EB
b6641   LDA a65E2
        PHA 
        LDA a65E3
        PHA 
        LDA a65EA
        PHA 
        LDA a65EB
        PHA 
b6651   LDA a65E2
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6550
        LDA a65E3
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6551
        LDA a65EA
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6552
        LDA a65EB
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6553
        JSR s6717
        LDA a65EB
        CLC 
        ADC #$08
        STA a65EB
        LDA a65EA
        CLC 
        ADC #$08
        STA a65EA
        LDA a65E3
        CLC 
        ADC #$08
        STA a65E3
        LDA a65E2
        CLC 
        ADC #$08
        STA a65E2
        INY 
        INY 
        CPY #$10
        BNE b6651
        PLA 
        STA a65EB
        PLA 
        STA a65EA
        PLA 
        STA a65E3
        PLA 
        STA a65E2
        DEC a65E1
        BNE b6709
        JSR s7316
        AND #$07
        CLC 
        ADC #$04
        TAX 
        LDA f673F,X
        STA a65DE
        LDA f674F,X
        STA a673D
        JSR s7316
        AND #$07
        CLC 
        ADC #$04
        TAX 
        LDA f673F,X
        STA a65DF
        LDA f674F,X
        STA a673E
        JSR s7316
        AND #$07
        CLC 
        ADC #$01
        STA a65E4
        STA a65E5
        JSR s7316
        AND #$07
        CLC 
        ADC #$01
        STA a65E6
        STA a65E7
b6709   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR s79B0
        JMP jEA31

;-------------------------------
; s6717
;-------------------------------
s6717   
        LDA a6550
        LDX a65E8
        BEQ b6725
        JSR s675F
        JMP j672B

b6725   CLC 
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos
;-------------------------------
; j672B
;-------------------------------
j672B   
        LDA a6551
        LDX a65E9
        BEQ b6736
        JMP j6774

b6736   CLC 
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

a673D   .BYTE $01
a673E   .BYTE $01
f673F   .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $02,$03,$04,$05,$06,$07,$08,$09
f674F   .BYTE $08,$07,$06,$05,$04,$03,$02,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
;-------------------------------
; s675F
;-------------------------------
s675F   
        LDA a6550
        CLC 
        ROR 
        STA aFA
        LDA a6552
        CLC 
        ROR 
        CLC 
        ADC aFA
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos
        RTS 

;-------------------------------
; j6774
;-------------------------------
j6774   
        LDA a6551
        CLC 
        ROR 
        STA aFA
        LDA a6553
        CLC 
        ROR 
        CLC 
        ADC aFA
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

f6789   .BYTE $42,$4F,$4E,$55,$53,$20,$31,$30
        .BYTE $30,$30,$30
a6794   .BYTE $BC
f6795   .BYTE $00,$06,$02,$04,$05,$03,$07,$01
        .BYTE $01,$07,$03,$05,$04,$02,$06,$00
f67A5   .BYTE $02,$08,$07,$05,$0E,$04,$06,$0B
        .BYTE $0B,$06,$04,$0E,$05,$07,$08,$02
f67B5   .BYTE $00,$01,$02,$03,$04,$05,$06,$07
        .BYTE $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
a67C5   .BYTE $04
a67C6   .BYTE $05
f67C7   .BYTE $00
f67C8   .BYTE $A8
f67C9   .BYTE $A0,$98,$90,$88,$80
f67CE   .BYTE $00
f67CF   .BYTE $00
f67D0   .BYTE $B8
f67D1   .BYTE $C0,$C8,$D0,$D8
f67D5   .BYTE $E0
f67D6   .BYTE $D3
f67D7   .BYTE $D3
f67D8   .BYTE $D3,$D3,$D3
f67DB   .BYTE $D3
f67DC   .BYTE $E6
f67DD   .BYTE $E6
f67DE   .BYTE $E6,$E6,$E6
f67E1   .BYTE $E6
f67E2   .BYTE $00
f67E3   .BYTE $00,$00,$00,$00,$00
f67E8   .BYTE $FF
f67E9   .BYTE $FF
f67EA   .BYTE $00
f67EB   .BYTE $00,$00,$00,$00
f67EF   .BYTE $00
f67F0   .BYTE $02,$08,$07,$05,$0E
f67F5   .BYTE $04
f67F6   .BYTE $02,$08,$07,$05,$0E
f67FB   .BYTE $04
f67FC   .BYTE $3D
f67FD   .BYTE $3D,$3D,$3D,$3D,$3D
f6802   .BYTE $00
f6803   .BYTE $00
f6804   .BYTE $CA
f6805   .BYTE $CA,$CA,$CA,$CA,$CA
a680A   .BYTE $09
a680B   .BYTE $0E
a680C   .BYTE $09
a680D   .BYTE $0E
;-------------------------------
; s680E
;-------------------------------
s680E   
        LDA #$00
        LDY #$40
b6812   STA f2FFF,Y
        DEY 
        BNE b6812
;-------------------------------
; j6818
;-------------------------------
j6818   
        LDX a6E12
        BPL b6822
        TXA 
        EOR #$FF
        TAX 
        INX 
b6822   LDA f6E13,X
        STA a3000
        STA a3003
        STA a3012
        STA a3015
        STA a3024
        STA a3027
        STA a3036
        STA a3039
        RTS 

;-------------------------------
; s683E
;-------------------------------
s683E   
        LDA #$00
        SEI 
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        JSR s6B5F
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        JSR s784E
        JSR s537C
        LDA $D016    ;VIC Control Register 2
        AND #$F7
        ORA #$10
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D027    ;Sprite 0 Color
        JSR s5701
;-------------------------------
; s6867
;-------------------------------
s6867   
        LDA #$FF
        SEI 
        STA $D015    ;Sprite display Enable
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDA #$C0
        STA SCREEN_RAM + $03FF
        LDA #$00
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        STA a40D2
        STA a59B9
        LDA a78B1
        STA a78B0
        LDA a78B3
        STA a78B2
        LDA #$80
        STA $D01B    ;Sprite to Background Display Priority
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA #$B0
        STA $D000    ;Sprite 0 X Pos
        JSR s71C2
        JSR s78FC
        SEI 
        LDA #<p6B52
        STA $0314    ;IRQ
        LDA #>p6B52
        STA $0315    ;IRQ
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$10
        STA $D012    ;Raster Position
        JSR s6048
        LDX #$28
        LDA a797D
        BNE b68DF
b68D2   LDA #$00
        STA SCREEN_RAM + $01B7,X
        LDA #$04
        STA fD9B7,X
        DEX 
        BNE b68D2
b68DF   RTS 

;-------------------------------
; j68E0
;-------------------------------
j68E0   
        LDA #$0B
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA #$7F
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDA #$08
        STA $D027    ;Sprite 0 Color
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$01
        STA $D026    ;Sprite Multi-Color Register 1
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JSR s6907
p6904   JMP j692A

;-------------------------------
; s6907
;-------------------------------
s6907   
        LDA #$D3
        STA a6C25
        STA SCREEN_RAM + $03F8
        LDA #$02
        STA a7178
        LDA #$40
        STA $D001    ;Sprite 0 Y Pos
        LDA #$04
        STA a7177
        LDA #$EA
        STA a6E12
        LDA #$00
        STA a7140
        RTS 

a6929   .BYTE $00
;-------------------------------
; j692A
;-------------------------------
j692A   
        LDA a7EE1
        BEQ b6932
        JSR s7EC3
b6932   LDA #$00
        JSR s51CB
        LDA #$01
        STA a78C7
        STA a78C6
        LDA #$FF
        STA a7176
;-------------------------------
; j6944
;-------------------------------
j6944   
        CLI 
        NOP 
        NOP 
        NOP 
        LDA a7EE1
        BEQ b6971
        CMP #$01
        BNE b6971
        LDA #$01
        STA aCC88
        LDA $D016    ;VIC Control Register 2
        AND #$E8
        ORA #$08
        STA $D016    ;VIC Control Register 2
        SEI 
        LDA #$00
        STA $D015    ;Sprite display Enable
        LDA #<f49C6
        STA aF0
        LDA #>f49C6
        STA aF1
        JMP jC9C9

b6971   LDA a6929
        BEQ b6982
        JSR s650B
        JSR s6030
        JSR s5701
        JMP j69B5

b6982   LDA a59B9
        BEQ b698A
        JMP j6A10

b698A   LDA a60EF
        BEQ b69A6
        SEI 
        LDA $D016    ;VIC Control Register 2
        AND #$E7
        ORA #$08
        STA $D016    ;VIC Control Register 2
        JSR s6030
        JSR s61EC
        INC a5279
        JMP j6A79

b69A6   LDA a5509
        BEQ b6A02
        SEI 
        JSR s6030
        JSR s5A96
        JSR sAB00
;-------------------------------
; j69B5
;-------------------------------
j69B5   
        JSR s4081
        JSR s603C
        JSR s537C
        JSR s6907
        LDX #$00
        TXA 
b69C4   STA f2200,X
        STA f2300,X
        STA f2600,X
        STA f2700,X
        DEX 
        BNE b69C4
        JSR s6030
        LDA #$01
        STA a78C7
        STA a78C6
        LDA aAAD1
        BEQ b69F0
        INC a59BA
        LDA a59BA
        CMP #$04
        BNE b69F0
        DEC a59BA
b69F0   LDA #$00
        STA a5509
        LDA $D011    ;VIC Control Register 1
        AND #$F0
        ORA #$0B
        STA $D011    ;VIC Control Register 1
        JMP j6A79

b6A02   JSR s5F00
        JSR s5E55
        JSR s5E00
        LDA a59B9
        BEQ b6A1C
;-------------------------------
; j6A10
;-------------------------------
j6A10   
        JSR s537C
        JSR s6030
        JSR s5A11
        JMP j6A79

b6A1C   LDA a52CD
        BEQ b6A24
        JSR s52C2
b6A24   LDA a78B4
        BEQ b6A31
        LDA #$00
        STA a78B4
        JMP j4000

b6A31   JSR s5325
        LDA a40D2
        BNE b6A3E
        LDA a40D0
        BNE b6A41
b6A3E   JMP j6944

b6A41   LDA lastKeyPressed
        CMP #$40
        BNE b6A41
        LDA #$00
        STA $D015    ;Sprite display Enable
        LDA #$80
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA $D016    ;VIC Control Register 2
        AND #$C0
        ORA #$08
        STA $D016    ;VIC Control Register 2
        JSR s6030
        JSR InitScreenPtrClearScreen
        LDA #$00
        STA a40D0
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$01
        STA $D026    ;Sprite Multi-Color Register 1
        INC a5279
;-------------------------------
; j6A79
;-------------------------------
j6A79   
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$01
        STA a52CD
        LDA #$FF
        STA $D015    ;Sprite display Enable
        LDA #$80
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA a6AC5
        STA SCREEN_RAM + $03F8
        JSR s5A96
        JSR s6867
        LDA a78B1
        STA a78B0
        LDA a78B3
        STA a78B2
        JSR s51CB
        JSR s603C
        LDX #$03
b6AB3   LDA f7E49,X
        STA f67D8,X
        LDA f7E4D,X
        STA f67DE,X
        DEX 
        BNE b6AB3
        JMP j6944

a6AC5   .BYTE $D3
;-------------------------------
; s6AC6
;-------------------------------
s6AC6   
        LDX #$0C
        LDY #$06
b6ACA   LDA f67C7,Y
        STA $D000,X  ;Sprite 0 X Pos
        LDA p6B3E,Y
        AND $D010    ;Sprites 0-7 MSB of X coordinate
        STA a20
        LDA f67E1,Y
        AND f6B44,Y
        ORA a20
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f67FB,Y
        STA $D001,X  ;Sprite 0 Y Pos
        STX a42
        LDX f67EF,Y
        LDA f67B5,X
        STA $D027,Y  ;Sprite 0 Color
        LDA f67D5,Y
        STA SCREEN_RAM + $03F8,Y
        LDX a42
        DEX 
        DEX 
        DEY 
        BNE b6ACA
        RTS 

;-------------------------------
; s6B02
;-------------------------------
s6B02   
        LDX #$0C
        LDY #$06
b6B06   LDA f67CF,Y
        STA $D000,X  ;Sprite 0 X Pos
        LDA p6B3E,Y
        AND $D010    ;Sprites 0-7 MSB of X coordinate
        STA a20
        LDA f67E9,Y
        AND f6B44,Y
        ORA a20
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f6803,Y
        STA $D001,X  ;Sprite 0 Y Pos
        STX a42
        LDX f67F5,Y
        LDA f67B5,X
        STA $D027,Y  ;Sprite 0 Color
        LDA f67DB,Y
        STA SCREEN_RAM + $03F8,Y
        LDX a42
        DEX 
        DEX 
        DEY 
        BNE b6B06
        RTS 

p6B3E   RTI 

        .BYTE $FD,$FB,$F7,$EF,$DF
f6B44   .BYTE $BF
f6B45   .BYTE $02
f6B46   .BYTE $04,$08,$10,$20,$40,$02,$04,$08
        .BYTE $10,$20,$40
a6B51   .BYTE $00
p6B52   .BYTE $AD,$19,$D0,$29,$01,$D0,$66
;-------------------------------
; j6B59
;-------------------------------
j6B59   
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

;-------------------------------
; s6B5F
;-------------------------------
s6B5F   
        LDX #$00
        LDA #$20
b6B63   STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02F8,X
        DEX 
        BNE b6B63
        RTS 

;-------------------------------
; s6B73
;-------------------------------
s6B73   
        LDA a7C8A
        BEQ b6BA3
        LDA a7C89
        BNE b6B90
        DEC a7C88
        BNE b6BBE
        LDA #$01
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$01
        STA a7C89
b6B8F   RTS 

b6B90   DEC a7C89
        BNE b6B8F
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$02
        STA a7C88
        RTS 

b6BA3   LDA a6D85
        BEQ b6BBE
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
        DEC a6D86
        BNE b6BBE
        LDA #$00
        STA a6D85
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
b6BBE   RTS 

        LDY a6D84
        LDA a59B9
        BEQ b6BCA
        JMP j59BB

b6BCA   LDA a60EF
        BEQ b6BD2
        JMP p62C5

b6BD2   LDA f6D52,Y
        BEQ b6BDA
        JMP j6C6E

b6BDA   LDA #$00
        STA a6D84
        LDA #$5C
        STA $D012    ;Raster Position
        LDA $D016    ;VIC Control Register 2
        AND #$E0
        ORA #$08
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        BNE b6C26
;-------------------------------
; s6BF8
;-------------------------------
s6BF8   
        LDA a40D2
        BNE b6C24
        LDA a6C25
        STA SCREEN_RAM + $03F8
        STA a6AC5
        LDA a760C
        STA $D001    ;Sprite 0 Y Pos
        LDX a53B4
        LDA f40C8,X
        LDX a53B7
        BEQ b6C1A
        LDA a6E2B
b6C1A   LDY a4F57
        BEQ b6C21
        LDA #$0B
b6C21   STA $D027    ;Sprite 0 Color
b6C24   RTS 

a6C25   .BYTE $D3
b6C26   LDX a680A
        LDA f67B5,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDX a680B
        LDA f67B5,X
        STA $D023    ;Background Color 2, Multi-Color Register 1
        LDA $D01F    ;Sprite to Background Collision Detect
        STA a6D51
        JSR s7861
        JSR s6DC1
        JSR s75A8
        JSR s49D4
        JSR s6E2D
        JSR s7610
        JSR s7179
        JSR s78C8
        JSR s79B0
        JSR s6B73
        JSR s6BF8
        JSR s7C97
        JSR s778C
        JSR s6AC6
        JSR s5284
        JMP jEA31

;-------------------------------
; j6C6E
;-------------------------------
j6C6E   
        STA $D00F    ;Sprite 7 Y Pos
        LDA f6D62,Y
        STA $D00E    ;Sprite 7 X Pos
        LDA f6D71,Y
        CLC 
        ROR 
        ROR 
        STA a06
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$7F
        ORA a06
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f6D53,Y
        BNE b6C91
        JMP b6BDA

b6C91   SEC 
        SBC #$02
        STA $D012    ;Raster Position
        LDA f6D87,Y
        TAX 
        LDA f6DBA,X
        STA $D02E    ;Sprite 7 Color
        CPY a6D4F
        BNE b6CB5
        LDA $D016    ;VIC Control Register 2
        AND #$F0
        ORA a6E11
        ORA #$10
        STA $D016    ;VIC Control Register 2
        BNE b6CD3
b6CB5   CPY #$06
        BNE b6CD3
        LDA a797D
        BEQ b6CD6
        LDA #$90
        STA $D001    ;Sprite 0 Y Pos
        LDX #$30
b6CC5   DEX 
        BNE b6CC5
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2
        JMP j6D36

b6CD3   JMP j6D41

b6CD6   JSR s6B02
        LDA #$07
        SEC 
        SBC a6E11
        STA a20
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        ORA a20
        STA $D016    ;VIC Control Register 2
        LDA a40D2
        BNE b6D07
        LDA #$FF
        SEC 
        SBC a760C
        ADC #$07
        STA $D001    ;Sprite 0 Y Pos
        STA a760D
        LDA a6C25
        CLC 
        ADC #$13
        STA SCREEN_RAM + $03F8
b6D07   LDX a680C
        LDA f67B5,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDX a680D
        LDA f67B5,X
        STA $D023    ;Background Color 2, Multi-Color Register 1
        LDA a40D2
        BNE j6D36
        LDX a53B5
        LDA f40C8,X
        LDX a53B8
        BEQ b6D2C
        LDA a6E2B
b6D2C   LDY a4F57
        BNE b6D33
        LDA #$0B
b6D33   STA $D027    ;Sprite 0 Color
;-------------------------------
; j6D36
;-------------------------------
j6D36   
        LDY #$0A
        STY a6D84
        LDA a6D51,Y
        STA $D012    ;Raster Position
;-------------------------------
; j6D41
;-------------------------------
j6D41   
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        INC a6D84
        JMP j6B59

a6D4F   .BYTE $00,$0D
a6D51   .BYTE $00
f6D52   .BYTE $60
f6D53   .BYTE $66,$6C,$72,$78,$7E,$84,$8A,$90
        .BYTE $96,$9C,$A2,$A8,$AE,$B4
f6D61   .BYTE $00
f6D62   .BYTE $44,$CD,$9F,$F7,$EF,$7F,$79,$2D
        .BYTE $9D,$D5,$01,$79,$96,$FB
f6D70   .BYTE $C0
f6D71   .BYTE $01,$00,$01,$00,$01,$01,$00,$01
        .BYTE $00,$00,$00,$01,$00,$01,$00,$00
        .BYTE $01,$01,$00
a6D84   .BYTE $00
a6D85   .BYTE $00
a6D86   .BYTE $00
f6D87   .BYTE $02,$03,$04,$03,$02,$03,$04,$03
        .BYTE $02,$03,$04,$03,$02,$02,$03,$04
        .BYTE $03,$02,$03,$04,$03,$02,$01,$02
        .BYTE $03
f6DA0   .BYTE $04,$02,$03,$04,$03,$02,$03,$04
        .BYTE $03,$02,$03,$04,$03,$02,$02,$03
        .BYTE $04,$03,$02,$03,$04,$03,$02,$01
        .BYTE $02,$03
f6DBA   .BYTE $04,$01,$0F,$0C,$0B,$08,$06
;-------------------------------
; s6DC1
;-------------------------------
s6DC1   
        LDX #$0F
        LDA #$00
        STA a21
        LDA a6E12
        BPL b6DD0
        LDA #$FF
        STA a21
b6DD0   DEC f6DA0,X
        BNE b6E0B
        LDA a6D86,X
        STA f6DA0,X
        LDA f6D61,X
        CPX #$08
        BMI b6DF4
        SEC 
        SBC a6E12
        STA f6D61,X
        LDA f6D70,X
        SBC a21
        STA f6D70,X
        JMP j6E03

b6DF4   CLC 
        ADC a6E12
        STA f6D61,X
        LDA f6D70,X
        ADC a21
        STA f6D70,X
;-------------------------------
; j6E03
;-------------------------------
j6E03   
        LDA f6D70,X
        AND #$01
        STA f6D70,X
b6E0B   DEX 
        BNE b6DD0
        JMP j7217

a6E11   .BYTE $02
a6E12   .BYTE $EA
f6E13   .BYTE $C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0
        .BYTE $F0,$F0,$F0,$F0,$F8,$F8,$F8,$F8
        .BYTE $FC,$FC,$FC,$FC,$FE,$FE,$FE,$FF
a6E2B   .BYTE $01
a6E2C   .BYTE $01
;-------------------------------
; s6E2D
;-------------------------------
s6E2D   
        LDA a6D51
        BEQ b6E88
        AND #$01
        BEQ b6E88
        LDA a527E
        BNE b6E88
        LDA a78C7
        BNE b6E88
        LDA a59B9
        BNE b6E88
        LDA a40D2
        BNE b6E88
        LDA a7EE1
        BNE b6E88
        LDA SCREEN_RAM + $01A4
        CMP #$77
        BEQ b6E67
        CMP #$7D
        BEQ b6E67
        LDA a6B51
        BEQ b6E88
        LDA #$03
        STA a40D1
        JMP j57F6

b6E67   JSR s51CB
        LDA #$01
        STA a78C6
        STA a78C7
        LDA #$06
        STA a6D85
        LDA #$04
        STA a6D86
        LDY #$14
        LDA a6E12
        BPL b6E85
        LDY #$EC
b6E85   STY a6E12
b6E88   DEC a6E2B
        BEQ b6E8E
b6E8D   RTS 

b6E8E   LDA $DC00    ;CIA1: Data Port Register A
        STA a7176
        AND #$1F
        CMP #$1F
        BEQ b6EA4
        LDA a7EE1
        BEQ b6EA4
        LDA #$02
        STA a7EE1
b6EA4   JSR s7EE4
        LDA a7EE1
        BEQ b6EAF
        DEC a7EE1
b6EAF   LDA #<screenPtrLo
        STA a6E2B
        LDA #>screenPtrLo
        STA a6E2C
        LDA SCREEN_RAM + $01A4
        CMP #$41
        BEQ b6EC4
        CMP #$43
        BNE b6EC9
b6EC4   LDA #$01
        STA a6E2C
b6EC9   LDA a4F57
        BEQ b6EF6
        LDA a7176
        AND #$10
        STA a42
        LDA a7176
        AND #$03
        STA a43
        CMP #$03
        BEQ b6EE4
        EOR #$03
        STA a43
b6EE4   LDA a7176
        AND #$0C
        CMP #$0C
        BEQ b6EEF
        EOR #$0C
b6EEF   ORA a43
        ORA a42
        STA a7176
b6EF6   LDA a78C7
        BNE b6E8D
        LDA a7177
        BEQ b6F03
        JMP j6F99

b6F03   JSR s7671
        LDA a7176
        AND #$04
        BNE b6F2E
        LDA #$01
        STA a7177
        LDA #$01
        STA a6E12
        LDA #$04
        STA a75A5
        STA a75A6
        LDA #$00
        STA a75A4
        STA a75A7
        LDA #$07
        STA a75A3
        BNE b6F54
b6F2E   LDA a7176
        AND #$08
        BNE b6F54
        LDA #$04
        STA a75A5
        STA a75A6
        LDA #$06
        STA a75A4
        STA a75A7
        LDA #$0D
        STA a75A3
        LDA #$FF
        STA a6E12
        LDA #$01
        STA a7177
b6F54   LDA a7176
        AND #$01
        BNE b6F98
        LDA a6E2C
        BEQ b6F63
        JMP j701E

b6F63   LDA a760C
        CMP #$6D
        BNE b6F98
        LDA #<p7B61
        STA a79AC
        LDA #>p7B61
        STA a79AD
        LDA #$FA
        STA a760B
        DEC a760C
        LDA #$11
        STA a75A4
        STA a75A7
        LDA #$16
        STA a75A3
        LDA #$01
        STA a7178
        LDA #$0A
        STA a75A5
        LDA #$02
        STA a7177
b6F98   RTS 

;-------------------------------
; j6F99
;-------------------------------
j6F99   
        CMP #$01
        BEQ b6FA0
        JMP j703B

b6FA0   JSR s7671
        LDA a7176
        AND #$04
        BNE b6FEB
        LDA a6E12
        BPL b6FDA
        INC a75A5
        INC a6E12
        BNE b6FD7
b6FB7   LDA #$00
        STA a7177
        STA a6E12
        STA a7178
        LDA #$06
        STA a75A5
        STA a75A6
        LDA #$0D
        STA a75A7
        STA a75A4
        LDA #$11
        STA a75A3
b6FD7   JMP j700F

b6FDA   INC a6E12
        DEC a75A5
        BNE b6FD7
        INC a75A5
        DEC a6E12
        JMP j700F

b6FEB   LDA a7176
        AND #$08
        BNE j700F
        LDA a6E12
        BMI b7001
        INC a75A5
        DEC a6E12
        BEQ b6FB7
        BNE j700F
b7001   DEC a6E12
        DEC a75A5
        BNE b6FD7
        INC a6E12
        INC a75A5
;-------------------------------
; j700F
;-------------------------------
j700F   
        LDA a7176
        AND #$01
        BNE b703A
        LDA a6E2C
        BNE j701E
        JMP b6F63

;-------------------------------
; j701E
;-------------------------------
j701E   
        LDA a760C
        CMP #$6D
        BNE b703A
        LDA #$FA
        STA a760B
        LDA #<p7B34
        STA a79AC
        LDA #>p7B34
        STA a79AD
        JSR s7C8B
        DEC a760C
b703A   RTS 

;-------------------------------
; j703B
;-------------------------------
j703B   
        CMP #$02
        BNE b707E
        JSR s7671
        LDA a7178
        CMP #$02
        BNE b703A
        LDA a7176
        AND #$04
        BEQ b7099
        LDA a7176
        AND #$08
        BEQ b70A7
        LDA a760B
        CMP #$02
        BNE b703A
;-------------------------------
; j705E
;-------------------------------
j705E   
        LDA #$15
        STA a75A4
        STA a75A7
        LDA #$1A
        STA a75A3
        LDA #$01
        STA a7178
        LDA #$06
        STA a75A5
        STA a75A6
        LDA #$03
        STA a7177
b707D   RTS 

b707E   CMP #$03
        BNE b70B5
        JSR s7671
        LDA a760C
        CMP #$6D
        BNE b707D
        LDA #<p7B07
        STA a79AC
        LDA #>p7B07
        STA a79AD
        JMP b6FB7

b7099   JSR s70AF
        LDA #$D1
        STA a6C25
;-------------------------------
; s70A1
;-------------------------------
s70A1   
        LDA #$04
        STA a7177
        RTS 

b70A7   LDA #$D3
        STA a6C25
        JSR s70A1
;-------------------------------
; s70AF
;-------------------------------
s70AF   
        LDA #$00
        STA a7140
        RTS 

b70B5   JSR s7671
        LDA a7176
        AND #$04
        BNE b70FC
        LDA a6C25
        CMP #$D3
        BNE b70E0
        LDA #$01
        STA a7178
        LDA #$01
        STA a75A5
        STA a75A6
        LDA #$1A
        STA a75A4
        STA a75A7
        LDA #$1F
        STA a75A3
b70E0   INC a6E12
        LDA a797D
        BEQ b70EF
        LDA a6E12
        CMP #$0C
        BEQ b70F6
b70EF   LDA a6E12
        CMP #$18
        BNE b70F9
b70F6   DEC a6E12
b70F9   JMP j7173

b70FC   LDA a7176
        AND #$08
        BNE b7142
        LDA a6C25
        CMP #$D1
        BNE b7124
        LDA #$01
        STA a7178
        LDA #$01
        STA a75A5
        STA a75A6
        LDA #$1F
        STA a75A4
        STA a75A7
        LDA #$24
        STA a75A3
b7124   DEC a6E12
        LDA a797D
        BEQ b7133
        LDA a6E12
        CMP #$F4
        BEQ b713A
b7133   LDA a6E12
        CMP #$E6
        BNE j7173
b713A   INC a6E12
        JMP j7173

a7140   .BYTE $00
b7141   RTS 

b7142   LDA a6E12
        BEQ b715A
        LDA a6E12
        BMI b7152
        DEC a6E12
        DEC a6E12
b7152   INC a6E12
        LDA a6E12
        BNE j7173
b715A   LDA a7176
        AND #$10
        BEQ b7141
        LDA a6E2C
        BEQ b7141
        LDA #$01
        STA a7140
        LDA #$CF
        STA a6C25
        JMP j705E

;-------------------------------
; j7173
;-------------------------------
j7173   
        JMP j6818

a7176   .BYTE $09
a7177   .BYTE $04
a7178   .BYTE $02
;-------------------------------
; s7179
;-------------------------------
s7179   
        LDA a7177
        CMP #$04
        BEQ b7181
b7180   RTS 

b7181   LDA a7176
        AND #$01
        BNE b71A4
        DEC a760C
        DEC a760C
        LDA a760C
        AND #$FE
        CMP #$30
        BNE b719D
        INC a760C
        INC a760C
b719D   LDA a760C
        STA $D001    ;Sprite 0 Y Pos
        RTS 

b71A4   LDA a7176
        AND #$02
        BNE b7180
        INC a760C
        INC a760C
        LDA a760C
        AND #$F0
        CMP #$70
        BNE b719D
        DEC a760C
        DEC a760C
        BNE b719D
;-------------------------------
; s71C2
;-------------------------------
s71C2   
        LDY #$00
        LDA a797D
        BEQ b71E6
        LDX #$27
b71CB   LDA (p10),Y
        STA SCREEN_RAM + $0118,Y
        LDA (p12),Y
        STA SCREEN_RAM + $0140,Y
        LDA (p14),Y
        STA SCREEN_RAM + $0168,Y
        LDA (p16),Y
        STA SCREEN_RAM + $0190,Y
        INY 
        DEX 
        CPY #$28
        BNE b71CB
        RTS 

b71E6   LDX #$27
b71E8   LDA (p10),Y
        STA SCREEN_RAM + $0118,Y
        ORA #$C0
        STA SCREEN_RAM + $0258,X
        LDA (p12),Y
        STA SCREEN_RAM + $0140,Y
        ORA #$C0
        STA SCREEN_RAM + $0230,X
        LDA (p14),Y
        STA SCREEN_RAM + $0168,Y
        ORA #$C0
        STA SCREEN_RAM + $0208,X
        LDA (p16),Y
        STA SCREEN_RAM + $0190,Y
        ORA #$C0
        STA SCREEN_RAM + $01E0,X
        INY 
        DEX 
        CPY #$28
        BNE b71E8
        RTS 

;-------------------------------
; j7217
;-------------------------------
j7217   
        INC a6794
        LDA a6794
        AND #$0F
        TAX 
        LDA f6795,X
        STA a67C5
        LDA f67A5,X
        STA a67C6
        LDA a6E12
        BMI b7234
        JMP j72C0

b7234   LDA a6E11
        CLC 
        ADC a6E12
        STA a6E11
        AND #$F8
        BNE b7243
        RTS 

b7243   LDA a6E11
        EOR #$FF
        CLC 
        AND #$F8
        ROR 
        ROR 
        ROR 
        STA aFD
        INC aFD
        LDA a10
        CLC 
        ADC aFD
        STA a10
        STA a12
        STA a14
        STA a16
        LDA a11
        ADC #$00
;-------------------------------
; j7263
;-------------------------------
j7263   
        STA a11
        CLC 
        ADC #$04
        STA a13
        CLC 
        ADC #$04
        STA a15
        CLC 
        ADC #$04
        STA a17
        LDA a6E11
        AND #$07
        STA a6E11
        LDA a11
        CMP #$7F
        BNE b7294
        LDA a10
        SEC 
        SBC #$28
        STA a10
        STA a12
        STA a14
        STA a16
        LDA #$83
        JMP j7263

b7294   CMP #$83
        BNE b72BD
        LDA a10
        CMP #$D8
        BEQ b72AD
        CMP #$D9
        BEQ b72AD
        CMP #$DA
        BEQ b72AD
        CMP #$DB
        BEQ b72AD
        JMP b72BD

b72AD   CLC 
        ADC #$28
        STA a10
        STA a12
        STA a14
        STA a16
        LDA #$80
        JMP j7263

b72BD   JMP s71C2

;-------------------------------
; j72C0
;-------------------------------
j72C0   
        LDA a6E11
        CLC 
        ADC a6E12
        STA a6E11
        AND #$F8
        BNE b72CF
        RTS 

b72CF   CLC 
        ROR 
        ROR 
        ROR 
        STA aFD
        LDA a10
        SEC 
        SBC aFD
        STA a10
        STA a12
        STA a14
        STA a16
        LDA a11
        SBC #$00
        JMP j7263

;-------------------------------
; s72E9
;-------------------------------
s72E9   
        LDA #<p8C00
        STA screenPtrLo
        LDA #>p8C00
        STA screenPtrHi
        LDA a24
        BEQ b72F9
        INC screenPtrHi
        INC screenPtrHi
b72F9   LDA screenPtrLo
        CLC 
        ADC a25
        STA screenPtrLo
        LDA screenPtrHi
        ADC #$00
        STA screenPtrHi
        LDA screenPtrLo
        CLC 
        ADC a25
        STA screenPtrLo
        LDA screenPtrHi
        ADC #$00
        STA screenPtrHi
        LDY #$00
        RTS 

a7317   =*+$01
;-------------------------------
; s7316
;-------------------------------
s7316   
        LDA a9ABB
        INC a7317
        RTS 

;-------------------------------
; s731D
;-------------------------------
s731D   
        LDX #$28
b731F   STA fD917,X
        STA fD93F,X
        STA fD967,X
        STA fD98F,X
        DEX 
        BNE b731F
        RTS 

;-------------------------------
; s732F
;-------------------------------
s732F   
        LDX #$28
b7331   STA fD9DF,X
        STA fDA07,X
        STA fDA2F,X
        STA fDA57,X
        DEX 
        BNE b7331
        RTS 

;-------------------------------
; s7341
;-------------------------------
s7341   
        LDA a73AE
        STA a22
        LDA a73AF
        STA a23
        JSR s735E
        LDA a26
        STA f2600,X
        INC a23
        JSR s735E
        LDA a26
        STA f2700,X
        RTS 

;-------------------------------
; s735E
;-------------------------------
s735E   
        LDA (p22),Y
        PHA 
        AND #$03
        TAX 
        LDA f73B0,X
        STA a26
        PLA 
        ROR 
        ROR 
        PHA 
        AND #$03
        TAX 
        LDA f73B4,X
        ORA a26
        STA a26
        PLA 
        ROR 
        ROR 
        AND #$03
        TAX 
        LDA f73B8,X
        ORA a26
        STA a26
        LDA (p22),Y
        ROL 
        ROL 
        ROL 
        AND #$03
        ORA a26
        STA a26
        TYA 
        PHA 
        AND #$07
        TAY 
        PLA 
        PHA 
        AND #$F8
        STA a24
        LDA f73A4,Y
        CLC 
        ADC a24
        TAX 
        PLA 
        TAY 
        RTS 

f73A4   .BYTE $07,$06,$05,$04,$03,$02,$01,$00
a73AC   .BYTE $00
a73AD   .BYTE $92
a73AE   .BYTE $00
a73AF   .BYTE $92
f73B0   .BYTE $00,$40,$80,$C0
f73B4   .BYTE $00,$10,$20,$30
f73B8   .BYTE $00,$04,$08,$0C
;-------------------------------
; s73BC
;-------------------------------
s73BC   
        LDA #<p8000
        STA a22
        LDA #>p8000
        STA a23
        LDY #$00
b73C6   LDA #$60
b73C8   STA (p22),Y
        DEY 
        BNE b73C8
        INC a23
        LDA a23
        CMP #$90
        BNE b73C6
        LDA #$8C
        STA a23
b73D9   LDA #$40
        STA (p22),Y
        LDA #$42
        INY 
        STA (p22),Y
        DEY 
        LDA a22
        CLC 
        ADC #$02
        STA a22
        LDA a23
        ADC #$00
        STA a23
        CMP #$90
        BNE b73D9
        JSR s7316
        AND #$7F
        CLC 
        ADC #$7F
        STA a25
        LDA #$00
        STA a24
        JSR s72E9
        JSR s7316
        AND #$7F
        CLC 
        ADC #$20
        STA a22
        LDY #$00
        LDA #$5C
        STA (screenPtrLo),Y
        LDA #$5E
        INY 
        STA (screenPtrLo),Y
b741A   INC a25
        BNE b7420
        INC a24
b7420   JSR s72E9
        LDY #$00
        LDA #$41
        STA (screenPtrLo),Y
        LDA #$43
        INY 
        STA (screenPtrLo),Y
        DEC a22
        BNE b741A
        INY 
        LDA #$5D
        STA (screenPtrLo),Y
        LDA #$5F
        INY 
        STA (screenPtrLo),Y
        JSR s7519
        RTS 

f7440   .BYTE $65,$67,$69,$6B,$FF,$64,$66,$68
        .BYTE $6A,$FE
f744A   .BYTE $41,$43,$51,$53,$41,$43,$FF,$60
        .BYTE $60,$50,$52,$60,$60,$FF,$49,$4B
        .BYTE $4D,$4F,$6D,$6F,$FF,$48,$4A,$4C
        .BYTE $4E,$6C,$6E,$FE
f7466   .BYTE $59,$5B,$FF,$58,$5A,$FF,$55,$57
        .BYTE $FF,$54,$56,$FE
f7472   .BYTE $75,$77,$7D,$7F,$FF,$74,$76,$7C
        .BYTE $7E,$FF,$71,$73,$79,$7B,$FF,$70
        .BYTE $72,$78,$7A,$FE,$A2,$00
;-------------------------------
; j7488
;-------------------------------
j7488   
        LDA f74A0,X
        CMP #$FF
        BNE b7495
        JSR s74A6
        JMP j7488

b7495   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j7488

f74A0   .TEXT "EG", $FF, "DF", $FE
;-------------------------------
; s74A6
;-------------------------------
s74A6   
        LDA screenPtrHi
        SEC 
        SBC #$04
        STA screenPtrHi
        LDY #$00
        INX 
b74B0   RTS 

        LDX #$00
;-------------------------------
; j74B3
;-------------------------------
j74B3   
        LDA f7440,X
        CMP #$FF
        BNE b74C0
        JSR s74A6
        JMP j74B3

b74C0   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j74B3

        LDX #$00
;-------------------------------
; j74CD
;-------------------------------
j74CD   
        LDA f744A,X
        CMP #$FF
        BNE b74DA
        JSR s74A6
        JMP j74CD

b74DA   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j74CD

        LDX #$00
;-------------------------------
; j74E7
;-------------------------------
j74E7   
        LDA f7466,X
        CMP #$FF
        BNE b74F4
        JSR s74A6
        JMP j74E7

b74F4   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j74E7

;-------------------------------
; s74FF
;-------------------------------
s74FF   
        LDX #$00
;-------------------------------
; j7501
;-------------------------------
j7501   
        LDA f7472,X
        CMP #$FF
        BNE b750E
        JSR s74A6
        JMP j7501

b750E   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j7501

;-------------------------------
; s7519
;-------------------------------
s7519   
        LDA #<p2000
        STA a24
        LDA #>p2000
        STA a25
;-------------------------------
; j7521
;-------------------------------
j7521   
        JSR s7561
        JSR s7316
        AND #$0F
        CLC 
        ADC #$0C
        CLC 
        ADC a25
        STA a25
        LDA a24
        ADC #$00
        STA a24
        LDA a25
        AND #$F0
        CMP #$C0
        BEQ b7546
        CMP #$D0
        BEQ b7546
        JMP j7521

b7546   LDA a24
        BEQ j7521
        LDA #$F1
        STA a25
        JSR s72E9
        JSR s74FF
        DEC a24
        LDA #$05
        STA a25
        JSR s72E9
        JSR s74FF
        RTS 

;-------------------------------
; s7561
;-------------------------------
s7561   
        JSR s72E9
        JSR s7316
        AND #$03
        TAX 
        LDA f7577,X
        STA a2A
        LDA f757B,X
        STA a29
        JMP (p0029)

f7577   .BYTE $74,$74,$74,$74
f757B   .BYTE $86,$B1,$CB,$E5
f757F   .BYTE $C1,$C2,$C3,$C4,$C5,$C6,$C7,$C6
        .BYTE $C5,$C4,$C3,$C2,$C1,$C8,$C9,$CA
        .BYTE $CB,$CB,$CC,$CD,$CE,$CF,$CE,$CD
        .BYTE $CC,$CB,$D3,$D2,$CF,$D0,$D1,$D1
        .BYTE $D0,$CF,$D2,$D3
a75A3   .BYTE $11
a75A4   .BYTE $0D
a75A5   .BYTE $06
a75A6   .BYTE $06
a75A7   .BYTE $0D
;-------------------------------
; s75A8
;-------------------------------
s75A8   
        LDA a40D2
        BNE b75BF
        LDA a40D0
        BNE b75BF
        LDA a78C7
        BEQ b75BA
        JMP j5CC9

b75BA   DEC a75A6
        BEQ b75C0
b75BF   RTS 

b75C0   LDA a75A5
        STA a75A6
        LDA a7178
        BEQ b75CF
        CMP #$02
        BEQ b75BF
b75CF   INC a75A7
        LDA a75A7
        CMP a75A3
        BNE b7601
        LDA a7178
        BEQ b75E3
        INC a7178
        RTS 

b75E3   LDA a75A4
        STA a75A7
        LDA a7177
        CMP #$01
        BNE b7601
        LDA a760C
        CMP #$6D
        BNE b7601
        LDA #<p7B07
        STA a79AC
        LDA #>p7B07
        STA a79AD
b7601   LDX a75A7
        LDA f757F,X
        STA a6C25
        RTS 

a760B   .BYTE $01
a760C   .BYTE $3F
a760D   .BYTE $CA
a760E   .BYTE $01
a760F   .BYTE $03
;-------------------------------
; s7610
;-------------------------------
s7610   
        LDA a78C7
        BNE b761A
        DEC a760E
        BEQ b761B
b761A   RTS 

b761B   LDA #$02
        STA a760E
        LDA a7140
        BEQ b761A
        LDA a760C
        CMP #$6D
        BEQ b761A
        DEC a760F
        BEQ b764A
;-------------------------------
; j7631
;-------------------------------
j7631   
        CLC 
        ADC a760B
        STA a760C
        AND #$F0
        CMP #$70
        BNE b7643
        LDA #$6D
        STA a760C
b7643   LDA a760C
        STA $D001    ;Sprite 0 Y Pos
        RTS 

b764A   LDA #$03
        STA a760F
        INC a760B
        LDA a760B
        CMP #$08
        BEQ b765F
        LDA a760C
        JMP j7631

b765F   DEC a760B
        LDA a760C
        JMP j7631

f7668   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
a7670   .BYTE $01
;-------------------------------
; s7671
;-------------------------------
s7671   
        LDA a7176
        AND #$10
        BEQ b767E
        LDA #$01
        STA a7670
b767D   RTS 

b767E   LDX #$00
        LDA f67E2,X
        BMI b76A8
        LDX #$06
        LDA f67E2,X
        BMI b76A8
        LDX #$01
        DEC a7670
        BNE b767D
        LDA #$06
        STA a7670
        LDA f67E2,X
        BPL b76A0
        JSR b76A8
b76A0   LDX #$07
        LDA f67E2,X
        BMI b76A8
        RTS 

b76A8   LDA #$B5
        STA f67C8,X
        LDA #$00
        STA f67E2,X
        LDA a760C
        CLC 
        ADC #$04
        STA f67FC,X
        LDA #$E7
        STA f67D6,X
        LDA a6E12
        EOR #$FF
        STA f7668,X
        INC f7668,X
        LDA #$FA
        STA f7784,X
        LDA a48D7
        BNE b76DF
        LDA #<p7BD4
        STA a79AE
        LDA #>p7BD4
        STA a79AF
b76DF   LDA a7177
        CMP #$04
        BNE b7717
        LDA a48D7
        BNE b76F8
        JSR s7C91
        LDA #<p7C24
        STA a79AE
        LDA #>p7C24
        STA a79AF
b76F8   LDA a760C
        CLC 
        ADC #$06
        STA f67FC,X
        LDA #$B1
        STA f67C8,X
        LDA #$EC
        STA f67D6,X
        LDA a6C25
        CMP #$D1
        BNE b7718
        LDA #$F5
        STA f7668,X
b7717   RTS 

b7718   CMP #$D3
        BNE b7722
        LDA #$0B
        STA f7668,X
        RTS 

b7722   LDA #$FF
        STA f67E2,X
        JMP j77FF

;-------------------------------
; s772A
;-------------------------------
s772A   
        LDA #$00
        STA a20
        STA a1F
        LDA a40D0
        BEQ b7736
        RTS 

b7736   LDA f7668,X
        BEQ b776F
        BPL b7741
        LDA #$FF
        STA a1F
b7741   LDA f67E2,X
        BEQ b7748
        INC a20
b7748   LDA f67C8,X
        CLC 
        ADC f7668,X
        STA f67C8,X
        LDA a20
        ADC a1F
        STA a20
        LDA a20
        AND #$01
        BEQ b7761
        LDA f6B45,X
b7761   STA f67E2,X
        BEQ b7770
        LDA f67C8,X
        AND #$F0
        CMP #$30
        BEQ b7777
b776F   RTS 

b7770   LDA f67C8,X
        AND #$F0
        BNE b776F
b7777   LDA #$FF
        STA f67E2,X
        PLA 
        PLA 
        JSR j77FF
        JMP j77AE

f7784   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
;-------------------------------
; s778C
;-------------------------------
s778C   
        LDX #$00
        LDA a40D2
        BEQ b7794
b7793   RTS 

b7794   LDA a78C7
        BNE b7793
        LDA f67E2,X
        CMP #$FF
        BEQ b77A9
        JSR s77C7
        JSR s772A
        JMP j77AE

b77A9   LDA #$F0
        STA f67D6,X
;-------------------------------
; j77AE
;-------------------------------
j77AE   
        INX 
        CPX #$08
        BEQ b77BC
        CPX #$02
        BNE b7794
        LDX #$06
        JMP b7794

b77BC   JMP j780F

f77BF   .BYTE $03,$03,$03,$03,$03,$03,$03,$03
;-------------------------------
; s77C7
;-------------------------------
s77C7   
        LDA f67D6,X
        CMP #$EC
        BEQ b780E
        LDA f67FC,X
        CLC 
        ADC f7784,X
        STA f67FC,X
        DEC f77BF,X
        BNE b77E5
        LDA #$03
        STA f77BF,X
        INC f7784,X
b77E5   LDA f67FC,X
        AND #$F8
        CMP #$78
        BEQ b77F2
        CMP #$88
        BNE b780E
b77F2   LDA #$FF
        STA f67E2,X
        JSR j77FF
        PLA 
        PLA 
        JMP j77AE

;-------------------------------
; j77FF
;-------------------------------
j77FF   
        LDA #$F0
        STA f67D6,X
        LDA #$FF
        STA f67C8,X
        LDA #$00
        STA f67FC,X
b780E   RTS 

;-------------------------------
; j780F
;-------------------------------
j780F   
        LDX #$00
b7811   LDA #$FF
        SEC 
        SBC f6802,X
        ADC #$17
        STA f6804,X
        LDA f67CE,X
        EOR #$FF
        STA a1F
        LDA f67E8,X
        BEQ b782A
        LDA #$01
b782A   EOR #$FF
        STA a20
        INC a20
        LDA #$6F
        CLC 
        ADC a1F
        STA f67D0,X
        LDA a20
        ADC #$00
        AND #$01
        STA a20
        BEQ b7845
        LDA f6B45,X
b7845   STA f67EA,X
        INX 
        CPX #$02
        BNE b7811
        RTS 

;-------------------------------
; s784E
;-------------------------------
s784E   
        LDX #$A0
b7850   LDA b5085,X
        STA SCREEN_RAM + $0347,X
        LDA f5125,X
        STA fDB47,X
        DEX 
        BNE b7850
        RTS 

a7860   .BYTE $00
;-------------------------------
; s7861
;-------------------------------
s7861   
        LDA lastKeyPressed
        CMP #$40
        BNE b786D
        LDA #$00
        STA a7860
b786C   RTS 

b786D   LDY a7860
        BNE b786C
        LDY a7EE1
        BEQ b787C
        LDY #$02
        STY a7EE1
b787C   LDY a59B9
        BNE b786C
        LDY a40D2
        BNE b786C
        CMP #$3E
        BNE b788E
        INC a78B4
        RTS 

b788E   CMP #$04
        BNE b7899
        INC a7860
        INC a40D0
b7898   RTS 

b7899   CMP #$3C
        BNE b78A1
        INC a60EF
        RTS 

b78A1   CMP #$19
        BNE b7898
        LDA aC822
        CMP #$1C
        BNE b7898
        INC a6929
        RTS 

a78B0   .BYTE $00
a78B1   .BYTE $00
a78B2   .BYTE $00
a78B3   .BYTE $00
a78B4   .BYTE $00
f78B5   .BYTE $09,$0B,$07,$0E,$0D
f78BA   .BYTE $0E,$10,$01,$07,$10
f78BF   .BYTE $0D,$09,$0A,$0C,$0A,$01,$01
a78C6   .BYTE $A5
a78C7   .BYTE $01
;-------------------------------
; s78C8
;-------------------------------
s78C8   
        LDA a78C7
        BNE b78CE
b78CD   RTS 

b78CE   LDX a78C6
        LDY a9A00,X
        LDA a73AC
        STA a22
        LDA a73AD
        STA a23
        LDA (p22),Y
        STA f2200,Y
        INC a23
        LDA (p22),Y
        STA f2300,Y
        JSR s7341
        INC a78C6
        LDA a78C6
        CMP #$01
        BNE b78CD
        LDA #$00
        STA a78C7
;-------------------------------
; s78FC
;-------------------------------
s78FC   
        LDX a78B0
        LDA f78B5,X
        STA a680A
        LDA f78BA,X
        STA a680B
        LDA f78BF,X
        JSR s731D
        LDX a78B2
        LDA f78B5,X
        STA a680C
        LDA f78BA,X
        STA a680D
        LDA f78BF,X
        JSR s732F
        LDA #$01
        STA a6D85
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$03
        STA a6D86
        LDX #$06
        LDA #$EC
b7939   STA f67D5,X
        STA f67DB,X
        DEX 
        BNE b7939
        LDA #$FF
        STA f67E2
        STA f67E3
        STA f67E8
        STA f67E9
        JSR s7C91
        LDA #<p5DB0
        STA a79AE
        LDA #>p5DB0
        STA a79AF
        LDA #$30
        STA a48D7
        LDA a797D
        BEQ b797C
        LDX a78B0
        LDA f78B5,X
        STA a680C
        LDA f78BA,X
        STA a680D
        LDA f78BF,X
        JSR s732F
b797C   RTS 

a797D   .BYTE $01
f797E   .BYTE $00,$94,$00,$00,$11,$0F,$00,$00
        .BYTE $03,$00,$00,$21,$0F,$00,$08,$03
        .BYTE $00,$00,$21,$0F,$00,$00,$00,$00
        .BYTE $02,$00,$00,$00,$00,$00,$00,$00
f799E   .BYTE $92
f799F   .BYTE $5D,$85,$5C
f79A2   .BYTE $02,$00
a79A4   .BYTE $00,$00
a79A6   .BYTE $02
f79A7   .BYTE $18
a79A8   .BYTE $05
a79A9   .BYTE $00
a79AA   .BYTE $65
a79AB   .BYTE $5D
a79AC   .BYTE $97
a79AD   .BYTE $5D
a79AE   .BYTE $65
a79AF   .BYTE $5D
;-------------------------------
; s79B0
;-------------------------------
s79B0   
        LDA #$00
        STA a79A6
        LDA a48D7
        BEQ b79BD
        DEC a48D7
b79BD   LDA a79AC
        STA a30
        LDA a79AD
        STA a31
        JSR s79D9
        LDA #$02
        STA a79A6
        LDA a79AE
        STA a30
        LDA a79AF
        STA a31
;-------------------------------
; s79D9
;-------------------------------
s79D9   
        LDY #$00
b79DB   LDA (p30),Y
        STA f79A7,Y
        INY 
        CPY #$05
        BNE b79DB
        LDA a79A8
        BNE b7A28
        LDA a79A9
        LDX a79AA
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
;-------------------------------
; j79F6
;-------------------------------
j79F6   
        JSR s7A11
        LDA a79AB
        BEQ s79D9
        CMP #$01
        BNE b7A03
        RTS 

b7A03   LDX a79A6
        LDA a30
        STA f799E,X
        LDA a31
        STA f799F,X
        RTS 

;-------------------------------
; s7A11
;-------------------------------
s7A11   
        LDA a30
        CLC 
        ADC #$05
        STA a30
        LDX a79A6
        STA a79AC,X
        LDA a31
        ADC #$00
        STA a31
        STA a79AD,X
        RTS 

b7A28   AND #$80
        BEQ b7A2F
        JMP j7AC8

b7A2F   LDA a79A8
        CMP #$01
        BNE b7A4C
        LDX f79A7
        LDA f797E,X
        CLC 
        ADC a79A9
        LDX a79AA
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP j79F6

b7A4C   CMP #$02
        BNE b7A66
        LDX f79A7
        LDA f797E,X
        SEC 
        SBC a79A9
;-------------------------------
; j7A5A
;-------------------------------
j7A5A   
        LDX a79AA
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP j79F6

b7A66   CMP #$03
        BNE b7A7A
        LDX f79A7
        LDY a79A9
        LDA f797E,X
        CLC 
        ADC f797E,Y
        JMP j7A5A

b7A7A   CMP #$04
        BNE b7A8E
        LDX f79A7
        LDY a79A9
        LDA f797E,X
        SEC 
        SBC f797E,Y
        JMP j7A5A

b7A8E   CMP #$05
        BNE b7AB7
        LDX f79A7
        LDA f797E,X
        SEC 
        SBC a79A9
;-------------------------------
; j7A9C
;-------------------------------
j7A9C   
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        BEQ b7AB4
        LDA a79AA
        LDX a79A6
        STA a79AC,X
        LDA a79AB
        STA a79AD,X
        RTS 

b7AB4   JMP s7A11

b7AB7   CMP #$06
        BNE j7AC8
        LDX f79A7
        LDA f797E,X
        CLC 
        ADC a79A9
        JMP j7A9C

;-------------------------------
; j7AC8
;-------------------------------
j7AC8   
        LDA a79A8
        CMP #$80
        BNE b7ADF
        LDX a79A6
        LDA a79A9
        STA a79AC,X
        LDA a79AA
        STA a79AD,X
        RTS 

b7ADF   CMP #$81
        BNE b7B06
        LDX a79A6
        LDA f79A2,X
        BNE b7AF1
        LDA a79A9
        STA f79A2,X
b7AF1   DEC f79A2,X
        BEQ b7B03
        LDA f799E,X
        STA a30
        LDA f799F,X
        STA a31
        JMP s79D9

b7B03   JMP s7A11

b7B06   RTS 

p7B07   .BYTE $00,$00,$00,$04,$00,$00,$00,$00
        .BYTE $05,$00,$00,$00,$60,$06,$00,$00
        .BYTE $00,$40,$01,$00,$00,$00,$81,$04
        .BYTE $01,$00,$00,$20,$04,$01,$00,$00
        .BYTE $10,$01,$01,$00,$00,$20,$01,$01
        .BYTE $00,$80,$CA,$7B,$00
p7B34   .BYTE $00,$00,$00,$04,$01,$00,$00,$0F
        .BYTE $05,$00,$00,$00,$F9,$06,$00,$00
        .BYTE $00,$C0,$01,$00,$00,$00,$21,$04
        .BYTE $01,$00,$00,$10,$04,$02,$01,$01
        .BYTE $41,$01,$01,$00,$81,$30,$00,$00
        .BYTE $00,$80,$CA,$7B,$00
p7B61   .BYTE $00,$00,$00,$04,$00,$00,$00,$00
        .BYTE $05,$00,$00,$00,$F9,$06,$00,$00
        .BYTE $00,$20,$01,$00,$00,$00,$81,$04
        .BYTE $01,$00,$00,$10,$01,$01,$00,$00
        .BYTE $10,$01,$00,$00,$00,$20,$04,$00
        .BYTE $00,$00,$06,$1F,$00,$01,$01,$20
        .BYTE $01,$02,$01,$02,$06,$01,$01,$00
        .BYTE $81,$06,$00,$00,$1F,$05,$01,$8E
        .BYTE $7B,$00,$80,$CA,$7B,$00,$00,$00
        .BYTE $00,$04,$00,$00,$00,$AD,$05,$00
        .BYTE $00,$00,$C0,$01,$00,$00,$00,$5D
        .BYTE $06,$00,$00,$00,$81,$04,$01,$00
        .BYTE $00,$80,$04,$01,$00,$80,$CA,$7B
        .BYTE $00,$00,$00,$0F,$18,$01,$00,$80
        .BYTE $CA,$7B,$00
p7BD4   .BYTE $00,$00,$10,$08,$00,$00,$00,$0F
        .BYTE $18,$01,$00,$00,$00,$0C,$00,$00
        .BYTE $00,$F0,$0D,$00,$00,$00,$00,$13
        .BYTE $00,$00,$00,$F0,$14,$00,$00,$00
        .BYTE $C0,$0F,$00,$00,$00,$21,$0B,$00
        .BYTE $00,$00,$21,$12,$01,$00,$00,$10
        .BYTE $0F,$00,$0F,$02,$01,$0F,$00,$08
        .BYTE $02,$01,$08,$01,$08,$05,$00,$06
        .BYTE $7C,$00,$00,$10,$0B,$00,$00,$00
        .BYTE $20,$12,$02,$00,$80,$CA,$7B,$00
p7C24   .BYTE $00,$00,$00,$0C,$00,$00,$00,$F0
        .BYTE $0D,$00,$00,$00,$00,$13,$00,$00
        .BYTE $00,$F0,$14,$00,$00,$00,$0F,$18
        .BYTE $01,$00,$00,$20,$08,$00,$00,$00
        .BYTE $C0,$0F,$00,$00,$00,$81,$0B,$00
        .BYTE $00,$00,$81,$12,$02,$08,$02,$02
        .BYTE $08,$00,$0F,$01,$01,$0F,$01,$00
        .BYTE $81,$02,$00,$00,$00,$00,$11,$0B
        .BYTE $00,$00,$00,$15,$12,$02,$08,$02
        .BYTE $04,$08,$00,$0F,$01,$02,$0F,$01
        .BYTE $00,$81,$10,$00,$00,$00,$00,$80
        .BYTE $0B,$00,$00,$00,$80,$12,$00,$00
        .BYTE $80,$CA,$7B,$00
a7C88   .BYTE $02
a7C89   .BYTE $01
a7C8A   .BYTE $00
;-------------------------------
; s7C8B
;-------------------------------
s7C8B   
        LDA #$00
        STA f79A2
        RTS 

;-------------------------------
; s7C91
;-------------------------------
s7C91   
        LDA #$00
        STA a79A4
b7C96   RTS 

;-------------------------------
; s7C97
;-------------------------------
s7C97   
        LDX #$04
        LDA a40D2
        BNE b7C96
        LDA a78C7
        BNE b7C96
b7CA3   LDA f67E3,X
        BMI b7CC2
        LDA f67C9,X
        LDY a6E12
        BMI b7CF0
        CLC 
        ADC a6E12
        STA f67C9,X
        BCC b7CC2
;-------------------------------
; j7CB9
;-------------------------------
j7CB9   
        LDA f67E3,X
        EOR f6B46,X
        STA f67E3,X
b7CC2   LDA f67EB,X
        BMI b7CE1
        LDA f67D1,X
        LDY a6E12
        BMI b7D07
        SEC 
        SBC a6E12
        STA f67D1,X
        BCS b7CE1
;-------------------------------
; j7CD8
;-------------------------------
j7CD8   
        LDA f67EB,X
        EOR f6B46,X
        STA f67EB,X
b7CE1   LDA a40D0
        BNE b7CE9
        JSR s7D3F
b7CE9   JSR s7E69
        DEX 
        BNE b7CA3
        RTS 

b7CF0   PHA 
        TYA 
        EOR #$FF
        STA a7D1E
        INC a7D1E
        PLA 
        SEC 
        SBC a7D1E
        STA f67C9,X
        BCS b7CC2
        JMP j7CB9

b7D07   PHA 
        TYA 
        EOR #$FF
        STA a7D1E
        INC a7D1E
        PLA 
        CLC 
        ADC a7D1E
        STA f67D1,X
        BCC b7CE1
        JMP j7CD8

a7D1E   .BYTE $10
f7D1F   .BYTE $01,$01,$01
f7D22   .BYTE $01,$01,$01,$01
f7D26   .BYTE $01
f7D27   .BYTE $01,$01,$01
f7D2A   .BYTE $01,$01,$01,$01
f7D2E   .BYTE $01
f7D2F   .BYTE $01,$01,$01
f7D32   .BYTE $01,$01,$01,$01
f7D36   .BYTE $01
f7D37   .BYTE $01,$01,$01
f7D3A   .BYTE $01,$01,$01,$01,$01
;-------------------------------
; s7D3F
;-------------------------------
s7D3F   
        DEC f7D36,X
        BNE b7D79
        LDA f7D2E,X
        STA f7D36,X
        LDA f7E40,X
        CLC 
        ADC f67FD,X
        STA f67FD,X
        AND #$F0
        CMP #$70
        BEQ b7D6A
        CMP #$00
        BNE b7D79
        LDA #$10
        STA f67FD,X
        LDA #$01
        STA f48AC,X
        BNE b7D74
b7D6A   LDA #$6D
        STA f67FD,X
        LDA #$01
        STA f48B6,X
b7D74   LDA #$00
        STA f7E40,X
b7D79   DEC f7D3A,X
        BNE b7DB4
        LDA f7D32,X
        STA f7D3A,X
        LDA f7E44,X
        CLC 
        ADC f6805,X
        STA f6805,X
        AND #$F0
        BEQ b7DA5
        LDA f6805,X
        CMP #$99
        BPL b7DB4
        LDA #$99
        STA f6805,X
        LDA #$01
        STA f48BC,X
        BNE b7DAF
b7DA5   LDA #$FF
        STA f6805,X
        LDA #$01
        STA f48B2,X
b7DAF   LDA #$00
        STA f7E44,X
b7DB4   DEC f7D26,X
        BNE b7DF6
        LDA a7D1E,X
        STA f7D26,X
        LDA f7E38,X
        BMI b7DD9
        CLC 
        ADC f67C9,X
        STA f67C9,X
        BCC b7DF6
        LDA f67E3,X
        EOR f6B46,X
        STA f67E3,X
        JMP b7DF6

b7DD9   EOR #$FF
        STA a7D1E
        INC a7D1E
        LDA f67C9,X
        SEC 
        SBC a7D1E
        STA f67C9,X
        BCS b7DF6
        LDA f67E3,X
        EOR f6B46,X
        STA f67E3,X
b7DF6   DEC f7D2A,X
        BNE f7E38
        LDA f7D22,X
        STA f7D2A,X
        LDA f7E3C,X
        BMI b7E1B
        CLC 
        ADC f67D1,X
        STA f67D1,X
        BCC f7E38
        LDA f67EB,X
        EOR f6B46,X
        STA f67EB,X
        JMP f7E38

b7E1B   EOR #$FF
        STA a7D1E
        INC a7D1E
        LDA f67D1,X
        SEC 
        SBC a7D1E
        STA f67D1,X
        BCS f7E38
        LDA f67EB,X
        EOR f6B46,X
        STA f67EB,X
f7E38   RTS 

f7E39   .BYTE $06,$06,$06
f7E3C   .BYTE $06,$06,$06,$06
f7E40   .BYTE $06
f7E41   .BYTE $FF,$FF,$FF
f7E44   .BYTE $FF,$00,$00,$01
f7E48   .BYTE $01
f7E49   .BYTE $ED,$ED,$ED
f7E4C   .BYTE $ED
f7E4D   .BYTE $ED,$ED,$ED
f7E50   .BYTE $ED
f7E51   .BYTE $F0,$F0,$F0
f7E54   .BYTE $F0,$F0,$F0,$F0
f7E58   .BYTE $F0
f7E59   .BYTE $01,$01,$01
f7E5C   .BYTE $01,$01,$01,$01
f7E60   .BYTE $01
f7E61   .BYTE $03,$03,$03
f7E64   .BYTE $03,$03,$03,$03,$03
;-------------------------------
; s7E69
;-------------------------------
s7E69   
        LDA a40D0
        BEQ b7E6F
        RTS 

b7E6F   DEC f7E58,X
        BNE b7E8B
        LDA f7E60,X
        STA f7E58,X
        INC f67D7,X
        LDA f67D7,X
        CMP f7E50,X
        BNE b7E8B
        LDA f7E48,X
        STA f67D7,X
b7E8B   DEC f7E5C,X
        BNE b7EA7
        LDA f7E64,X
        STA f7E5C,X
        INC f67DD,X
        LDA f67DD,X
        CMP f7E54,X
        BNE b7EA7
        LDA f7E4C,X
        STA f67DD,X
b7EA7   RTS 

;-------------------------------
; s7EA8
;-------------------------------
s7EA8   
        LDA aAAE0
        BNE b7EB8
        LDA #$01
        STA a797D
        LDA #$00
        STA a7EE1
        RTS 

b7EB8   LDA #$00
        STA a797D
        LDA #$FF
        STA a7EE1
        RTS 

;-------------------------------
; s7EC3
;-------------------------------
s7EC3   
        LDX #$09
b7EC5   JSR s7316
        AND #$0F
        STA f49C6,X
        DEX 
        BPL b7EC5
        JSR s7316
        AND #$03
        STA a78B0
        JSR s7316
        AND #$03
        STA a78B2
        RTS 

a7EE1   .BYTE $AD
a7EE2   .BYTE $09
a7EE3   .BYTE $09
;-------------------------------
; s7EE4
;-------------------------------
s7EE4   
        LDA a7EE1
        BNE b7EEA
        RTS 

b7EEA   DEC a7EE2
        BNE b7F01
        JSR s7316
        AND #$1F
        ORA #$01
        STA a7EE2
        LDA a7EE3
        EOR #$0F
        STA a7EE3
b7F01   LDA a7EE3
        STA a7176
        RTS 

.include "padding2.asm"

fAAC0   .BYTE $F0
fAAC1   .BYTE $30,$30,$30,$30,$30,$30,$30,$00
        .BYTE $00,$00,$00,$00,$00,$C8,$18
aAAD0   .BYTE $00
aAAD1   .BYTE $00
aAAD2   .BYTE $00,$0C,$00,$00,$00,$00,$0A,$F6
        .BYTE $F9,$04,$F9,$FC,$00,$00
aAAE0   .BYTE $FF
aAAE1   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$02,$02,$01,$01,$00
        .BYTE $00,$00,$00,$00,$10,$00,$10,$00
        .BYTE $00,$00,$10,$00,$04,$40
        .BYTE $00
;-------------------------------
; sAB00
;-------------------------------
sAB00   
        LDA #$00
        STA $D015    ;Sprite display Enable
        STA aAD23
        LDA #<pABE6
        STA $0314    ;IRQ
        LDA #>pABE6
        STA $0315    ;IRQ
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$30
        STA $D012    ;Raster Position
        LDA $D016    ;VIC Control Register 2
        AND #$E0
        ORA #$08
        STA $D016    ;VIC Control Register 2
        LDA #$00
        STA aABE5
        STA $D020    ;Border Color
        LDA #$0F
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        LDA #$FE
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control
        LDX #$0E
bAB49   LDA #$00
        STA fAC3E,X
        DEX 
        BNE bAB49
        STA aAC97
        LDA #$08
        STA aACCA
        LDA #$80
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDX #$28
bAB66   LDA fAB7E,X
        AND #$3F
        STA SCREEN_RAM + $0167,X
        LDA #$01
        STA fD967,X
        DEX 
        BNE bAB66
        CLI 
bAB77   LDA aAD23
        BEQ bAB77
fAB7E   =*+$02
        JMP SetupScreenAndInitializeGame

        .BYTE $53,$54,$41,$4E,$44,$20,$42,$59
        .BYTE $20,$54,$4F,$20,$45,$4E,$54,$45
        .BYTE $52,$20,$42,$4F,$4E,$55,$53,$20
        .BYTE $50,$48,$41,$53,$45,$2C,$20,$48
        .BYTE $4F,$54,$53,$48,$4F,$54,$2E,$2E
fABA7   .BYTE $01,$01,$01,$01,$02,$02,$02,$02
        .BYTE $03,$03,$03,$03,$04,$04,$04,$04
        .BYTE $05,$05,$05,$05,$06,$06,$06,$06
        .BYTE $07,$07,$07,$07,$07,$07,$00
fABC6   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00
aABE5   .BYTE $00
pABE6   LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE bABF3
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

bABF3   LDY #$03
bABF5   DEY 
        BNE bABF5
        LDY aABE5
        LDA fABC6,Y
        STA $D021    ;Background Color 0
        LDA fABA7,Y
        BEQ bAC1E
        CLC 
        ADC $D012    ;Raster Position
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        INC aABE5
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

bAC1E   JSR sAC77
        JSR sACCC
        LDA #$30
        STA $D012    ;Raster Position
        LDA #$00
        STA $D021    ;Background Color 0
        STA aABE5
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
fAC3E   RTI 

fAC3F   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00
fAC5B   .BYTE $02,$08,$07,$05,$0E,$04,$06,$07
        .BYTE $00,$03,$00,$05,$00,$04,$00,$02
        .BYTE $00,$06,$00,$06,$00,$06,$04,$0E
        .BYTE $05,$07,$08,$02
;-------------------------------
; sAC77
;-------------------------------
sAC77   
        LDY aAC97
        CPY #$1C
        BNE bAC88
        LDA aAD23
        BNE bAC98
        LDY #$00
        STY aAC97
bAC88   LDA fAC3F,Y
        BNE bAC98
        LDA #$01
        STA fAC3F,Y
        INC aAC97
        BNE bAC98
bAC98   =*+$01
aAC97   BRK #$A2
bAC9A   =*+$01
        BRK #$BD
        .BYTE $3F,$AC,$F0 ;RLA $F0AC,X
        AND aA8
        CPX #$1B
        BNE bACAE
        LDA aAD23
        BEQ bACAE
        LDA #$00
        STA fABC6,Y
bACAE   INY 
        CPY #$1E
        BNE bACBA
        LDA #$00
        STA fAC3F,X
        BEQ bACC4
bACBA   LDA fAC5B,X
        STA fABC6,Y
        TYA 
        STA fAC3F,X
bACC4   INX 
        CPX #$1C
        BNE bAC9A
        RTS 

aACCA   .BYTE $00
aACCB   .BYTE $40
;-------------------------------
; sACCC
;-------------------------------
sACCC   
        LDA aAD23
        BEQ bACD2
        RTS 

bACD2   LDA aACCB
        BEQ bACFB
        LDA #$11
        STA $D404    ;Voice 1: Control Register
        STA $D412    ;Voice 3: Control Register
        STA $D40B    ;Voice 2: Control Register
        LDA aACCB
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        ASL 
        AND #$3F
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        ASL 
        AND #$3F
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        DEC aACCB
        DEC aACCB
bACFA   RTS 

bACFB   LDA #$50
        STA aACCB
        DEC aACCA
        BNE bACFA
        LDA #$01
        STA aAD23
        LDX #$03
bAD0C   LDY aAD23,X
        LDA #$03
        STA $D401,Y  ;Voice 1: Frequency Control - High-Byte
        LDA #$20
        STA $D404,Y  ;Voice 1: Control Register
        LDA fAD26,X
        STA $D400,Y  ;Voice 1: Frequency Control - Low-Byte
        DEX 
        BNE bAD0C
        RTS 

aAD23   .BYTE $00,$00,$07
fAD26   .BYTE $0E,$00,$06,$0C
;-------------------------------
; SetupScreenAndInitializeGame
;-------------------------------
SetupScreenAndInitializeGame   
        LDA #$03
        STA aAD77
bAD2F   LDX #$C3
        LDY #$00
bAD33   DEY 
        BNE bAD33
        DEX 
        BNE bAD33
        LDY aAD77
        LDA fAD78,Y
        LDX #$28
bAD41   STA fD967,X
        DEX 
        BNE bAD41
        DEC aAD77
        BPL bAD2F

        LDX #$28
        LDA #$20
bAD50   STA SCREEN_RAM + $0167,X
        DEX 
        BNE bAD50

        SEI 
        LDA #$34
        STA a01

        ; Copy Charset and Sprties
        LDX #$00
bAD5D   LDA fE000,X
        STA f2200,X
        LDA fE100,X
        STA f2300,X
        DEX 
        BNE bAD5D

        LDA #$36
        STA a01
        JSR sAD7C
        CLI 

        JMP InitializeGame

aAD77   .BYTE $00
fAD78   .BYTE $00,$0B,$0C,$0F
;-------------------------------
; sAD7C
;-------------------------------
sAD7C   
        SEI 
        LDA #$34
        STA a01
        LDX #$00
bAD83   LDA fE200,X
        PHA 
        LDA a3000,X
        STA fE200,X
        PLA 
        STA a3000,X
        LDA fE300,X
        PHA 
        LDA f3100,X
        STA fE300,X
        PLA 
        STA f3100,X
        LDA fE400,X
        PHA 
        LDA f3200,X
        STA fE400,X
        PLA 
        STA f3200,X
        DEX 
        BNE bAD83
        LDA #$36
        STA a01
        CLI 
        RTS 

;-------------------------------
; InitializeGame
;-------------------------------
InitializeGame   
        NOP 
        LDA aAAD0
        BNE bADC1
        LDA #$00
        STA aAED0
bADC1   INC aAAD0
        LDA #$00
        STA $D020    ;Border Color
        STA aAAD1
        STA aAED2
        STA aAED3
        STA aC707
        STA $D021    ;Background Color 0
        LDX #$02
bADDA   STA fBB1E,X
        DEX 
        BPL bADDA
        JSR sC358
        LDA aAED0
        STA aAEB6
        LDA #$A0
        STA aAED1
        LDA #$C0
        STA aB682
        LDA #$01
        STA aC24E
        LDA #$00
        STA aAEBD
        STA aAEC0
        STA aC1DC
        LDA #$F6
        STA aAEBE
        LDA #$FF
        STA aB571
        LDA #$07
        STA aBED3
        TAX 
        LDA #$F6
bAE15   STA fBCB6,X
        DEX 
        BPL bAE15
        LDA #$B0
        STA aBC90
        LDA #$01
        STA aB487
        JSR ClearScreen
        JMP SetUpScreen

;-------------------------------
; ClearScreen
;-------------------------------
ClearScreen   
        LDX #$00
        LDA #$20
bAE2F   STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02F8,X
        DEX 
        BNE bAE2F
        RTS 

;------------------------------------------------
; SetUpScreen   
;------------------------------------------------
SetUpScreen   
        JSR Init_ScreenPointerArray
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$FF
        STA $D015    ;Sprite display Enable
        LDA #$0B
        STA $D027    ;Sprite 0 Color
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$01
        STA $D026    ;Sprite Multi-Color Register 1
        LDA #$0F
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDA #$00
        STA $D01B    ;Sprite to Background Display Priority
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$80
        STA $D001    ;Sprite 0 Y Pos
        LDX #$07
bAE71   LDA #$F0
        STA SCREEN_RAM + $03F8,X
        DEX 
        BNE bAE71

        LDA #$0F
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        LDA #$EE
        STA SCREEN_RAM + $03F9
        STA SCREEN_RAM + $03FA
        STA SCREEN_RAM + $03FB
        LDA $D016    ;VIC Control Register 2
        AND #$EF
        ORA #$10
        STA $D016    ;VIC Control Register 2
        LDA #$07
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA #$06
        STA $D023    ;Background Color 2, Multi-Color Register 1
        JSR sB642
        JMP jB383

;-------------------------------
; jAEA9
;-------------------------------
jAEA9   
        LDX aBED3
        LDA #$F8
        STA fBCB6,X
        DEC aBED3
        RTS 

aAEB6   =*+$01
;-------------------------------
; sAEB5
;-------------------------------
sAEB5   
        LDA a9A00
        INC aAEB6
        RTS 

aAEBC   .BYTE $00
aAEBD   .BYTE $0A
aAEBE   .BYTE $00
aAEBF   .BYTE $00
aAEC0   .BYTE $00
fAEC1   .BYTE $0B,$0C,$0F,$01,$0F,$0C,$0B
fAEC8   .BYTE $F6,$F7,$F8,$F7,$F7,$F8,$F7,$F6
aAED0   .BYTE $00
aAED1   .BYTE $A0
aAED2   .BYTE $00
aAED3   .BYTE $00
;-------------------------------
; sAED4
;-------------------------------
sAED4   
        LDX aAEBD
        LDY fB813,X
        LDA fB683,Y
        STA screenPtrLo2
        LDA fB74B,Y
        STA screenPtrHi2
        LDY #$00
        LDX #$00
bAEE8   LDA (screenPtrLo2),Y
        STY a37
        ASL 
        CLC 
        ADC aAEBC
        TAY 
        LDA fAFB4,Y
        STA SCREEN_RAM,X
        LDA fAFE6,Y
        STA SCREEN_RAM + $0001,X
        LDY a37
        INX 
        INX 
        INY 
        CPY #$14
        BNE bAEE8
        LDA aAEBC
        BNE bAF12
        INC aAEBD
        INC aAEBE
bAF12   RTS 

;-------------------------------
; sAF13
;-------------------------------
sAF13   
        LDX #$28
bAF15   LDA SCREEN_RAM + $02A7,X
        STA SCREEN_RAM + $02CF,X
        LDA SCREEN_RAM + $027F,X
        STA SCREEN_RAM + $02A7,X
        LDA SCREEN_RAM + $0257,X
        STA SCREEN_RAM + $027F,X
        LDA SCREEN_RAM + $022F,X
        STA SCREEN_RAM + $0257,X
        LDA SCREEN_RAM + $0207,X
        STA SCREEN_RAM + $022F,X
        LDA SCREEN_RAM + $01DF,X
        STA SCREEN_RAM + $0207,X
        LDA SCREEN_RAM + $01B7,X
        STA SCREEN_RAM + $01DF,X
        LDA SCREEN_RAM + $018F,X
        STA SCREEN_RAM + $01B7,X
        LDA SCREEN_RAM + $0167,X
        STA SCREEN_RAM + $018F,X
        LDA SCREEN_RAM + $013F,X
        STA SCREEN_RAM + $0167,X
        LDA SCREEN_RAM + $0117,X
        STA SCREEN_RAM + $013F,X
        LDA SCREEN_RAM + $00EF,X
        STA SCREEN_RAM + $0117,X
        LDA SCREEN_RAM + $00C7,X
        STA SCREEN_RAM + $00EF,X
        LDA SCREEN_RAM + $009F,X
        STA SCREEN_RAM + $00C7,X
        LDA SCREEN_RAM + $0077,X
        STA SCREEN_RAM + $009F,X
        LDA SCREEN_RAM + $004F,X
        STA SCREEN_RAM + $0077,X
        LDA SCREEN_RAM + $0027,X
        STA SCREEN_RAM + $004F,X
        LDA SCREEN_RAM - $01,X
        STA SCREEN_RAM + $0027,X
        DEX 
        BNE bAF15
        RTS 

;-------------------------------
; sAF85
;-------------------------------
sAF85   
        LDA aAED1
        STA $D000    ;Sprite 0 X Pos
        LDA aAED2
        BEQ bAF99
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA #$01
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        RTS 

bAF99   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        RTS 

;-------------------------------
; sAFA2
;-------------------------------
sAFA2   
        LDX #$00
bAFA4   STA fD800,X
        STA fD900,X
        STA fDA00,X
        STA fDB00,X
        DEX 
        BNE bAFA4
        RTS 

fAFB4   .BYTE $40,$41,$44,$47,$48,$49,$4F,$4D
        .BYTE $50,$51,$54,$56,$5B,$59,$5C,$5D
        .BYTE $60,$61,$64,$65,$68,$69,$47,$47
        .BYTE $4E,$4E,$57,$57,$5D,$5D,$20,$20
        .BYTE $5D,$45,$4B,$47,$4C,$5D,$4E,$52
        .BYTE $7C,$7D,$6C,$6D,$70,$71,$74,$75
        .BYTE $78,$79
fAFE6   .BYTE $42,$43,$46,$47,$4A,$48,$4E,$4F
        .BYTE $51,$53,$56,$57,$5A,$5B,$5E,$5C
        .BYTE $61,$63,$66,$67,$6A,$6B,$47,$47
        .BYTE $4E,$4E,$57,$57,$5D,$5D,$20,$20
        .BYTE $45,$47,$57,$4B,$4E,$4C,$52,$57
        .BYTE $7E,$7F,$6E,$6F,$72,$73,$76,$77
        .BYTE $7A,$7B,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF
pB02C   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$0D,$0D,$0E,$0E
        .BYTE $0E,$0E,$0E,$00,$00,$0B,$0B,$00
        .BYTE $00,$0D,$0D,$0D,$0D,$0D,$0E,$0E
        .BYTE $10,$0B,$0B,$0B,$0B,$0B,$0B,$0B
        .BYTE $0B,$11,$10,$0B,$0B,$0B,$0B,$0B
        .BYTE $0B,$0B,$0B,$11,$0E,$10,$0B,$0B
        .BYTE $0B,$0B,$0B,$0B,$11,$0D,$0E,$10
        .BYTE $0B,$0B,$0B,$0B,$0B,$0B,$11,$0D
        .BYTE $0E,$0E,$10,$0B,$0B,$0B,$0B,$11
        .BYTE $0D,$0D,$0E,$0E,$10,$0B,$0B,$0B
        .BYTE $0B,$11,$0D,$0D,$0E,$0E,$0E,$00
        .BYTE $00,$00,$00,$0D,$0D,$0D,$0E,$0E
        .BYTE $0E,$00,$00,$00,$00,$0D,$0D,$0D
        .BYTE $0E,$0E,$0E,$00,$0A,$0A,$00,$0D
        .BYTE $0D,$0D,$0E,$0E,$0E,$00,$0A,$0A
        .BYTE $00,$0D,$0D,$0D,$0E,$0E,$0E,$00
        .BYTE $09,$09,$00,$0D,$0D,$0D,$0E,$0E
        .BYTE $0E,$00,$09,$09,$00,$0D,$0D,$0D
        .BYTE $0E,$0E,$12,$0C,$0C,$0C,$0C,$13
        .BYTE $0D,$0D,$0E,$0E,$12,$0C,$0C,$0C
        .BYTE $0C,$13,$0D,$0D,$0E,$07,$00,$00
        .BYTE $15,$15,$00,$00,$05,$0D,$0E,$07
        .BYTE $00,$00,$15,$15,$00,$00,$05,$0D
        .BYTE $07,$0F,$00,$00,$15,$15,$00,$00
        .BYTE $0F,$05,$07,$0F,$00,$00,$15,$15
        .BYTE $00,$00,$0F,$05,$17,$17,$00,$00
        .BYTE $18,$17,$00,$00,$18,$18,$17,$17
        .BYTE $00,$00,$18,$17,$00,$00,$18,$18
        .BYTE $0F,$0F,$0F,$00,$00,$00,$00,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$00,$00,$00
        .BYTE $00,$0F,$0F,$0F,$00,$00,$09,$09
        .BYTE $00,$00,$09,$09,$00,$00,$00,$00
        .BYTE $09,$09,$00,$00,$09,$09,$00,$00
        .BYTE $00,$00,$0A,$0A,$00,$00,$0A,$0A
        .BYTE $00,$00,$00,$00,$0A,$0A,$00,$00
        .BYTE $0A,$0A,$00,$00,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$00,$00,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .BYTE $14,$14,$14,$14,$14,$14,$14,$14
        .BYTE $14,$14,$14,$14,$14,$14,$14,$14
        .BYTE $14,$14,$14,$14,$0F,$0E,$0E,$0E
        .BYTE $0E,$0E,$0E,$0E,$0E,$0E,$0D,$0D
        .BYTE $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0F
        .BYTE $0B,$0B,$0B,$00,$0B,$0B,$0B,$0B
        .BYTE $0B,$0F,$0F,$0B,$0B,$0B,$0B,$0B
        .BYTE $00,$0B,$0B,$0B,$15,$15,$15,$15
        .BYTE $15,$15,$15,$15,$15,$15,$15,$15
        .BYTE $15,$15,$15,$15,$15,$15,$15,$15
        .BYTE $00,$00,$00,$0F,$0F,$0F,$00,$00
        .BYTE $00,$0F,$0F,$00,$00,$00,$0F,$0F
        .BYTE $0F,$00,$00,$00,$00,$10,$0B,$11
        .BYTE $00,$00,$10,$0B,$11,$00,$00,$10
        .BYTE $0B,$11,$00,$00,$10,$0B,$11,$00
        .BYTE $00,$0E,$00,$0D,$00,$00,$0E,$00
        .BYTE $0D,$00,$00,$0E,$00,$0D,$00,$00
        .BYTE $0E,$00,$0D,$00,$00,$12,$0C,$13
        .BYTE $00,$00,$12,$0C,$13,$00,$00,$12
        .BYTE $0C,$13,$00,$00,$12,$0C,$13,$00
        .BYTE $0F,$0E,$00,$00,$00,$00,$0D,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0E,$0B,$0B
        .BYTE $0B,$0B,$0D,$0F,$0F,$0E,$0B,$0B
        .BYTE $0B,$0B,$0D,$0F,$0F,$0F,$0F,$0F
        .BYTE $0F,$0E,$00,$00,$00,$00,$0D,$0F
        .BYTE $0F,$0E,$00,$00,$00,$00,$0D,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0E,$00,$00
        .BYTE $00,$00,$0D,$0F,$15,$15,$00,$00
        .BYTE $16,$16,$00,$00,$15,$15,$00,$00
        .BYTE $16,$16,$00,$00,$15,$15,$00,$00
        .BYTE $00,$00,$16,$16,$00,$00,$15,$15
        .BYTE $00,$00,$16,$16,$00,$00,$15,$15
        .BYTE $00,$00,$16,$16,$0B,$0B,$0B,$0B
        .BYTE $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
        .BYTE $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$09,$09,$09,$09
        .BYTE $09,$09,$09,$09,$09,$15,$15,$09
        .BYTE $09,$09,$09,$09,$09,$09,$09,$09
        .BYTE $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
        .BYTE $0A,$15,$15,$0A,$0A,$0A,$0A,$0A
        .BYTE $0A,$0A,$0A,$0A,$FF
;-------------------------------
; sB2C1
;-------------------------------
sB2C1   
        LDX aAEBE
        LDY fB813,X
        LDA fB683,Y
        STA screenPtrLo2
        LDA fB74B,Y
        STA screenPtrHi2
        LDY #$00
        LDX #$00
bB2D5   LDA (screenPtrLo2),Y
        STY a37
        ASL 
        CLC 
        ADC aAEBC
        TAY 
        LDA fAFB4,Y
        STA SCREEN_RAM + $02D0,X
        LDA fAFE6,Y
        STA SCREEN_RAM + $02D1,X
        LDY a37
        INX 
        INX 
        INY 
        CPY #$14
        BNE bB2D5
        LDA aAEBC
        BEQ bB310
        DEC aAEBE
        DEC aAEBD
        LDA aAEBE
        CMP #$FF
        BNE bB310
        LDA #>p0A
        STA aAEBE
        LDA #<p0A
        STA aAEBD
bB310   RTS 

;-------------------------------
; sB311
;-------------------------------
sB311   
        LDX #$28
bB313   LDA SCREEN_RAM + $0027,X
        STA SCREEN_RAM - $01,X
        LDA SCREEN_RAM + $004F,X
        STA SCREEN_RAM + $0027,X
        LDA SCREEN_RAM + $0077,X
        STA SCREEN_RAM + $004F,X
        LDA SCREEN_RAM + $009F,X
        STA SCREEN_RAM + $0077,X
        LDA SCREEN_RAM + $00C7,X
        STA SCREEN_RAM + $009F,X
        LDA SCREEN_RAM + $00EF,X
        STA SCREEN_RAM + $00C7,X
        LDA SCREEN_RAM + $0117,X
        STA SCREEN_RAM + $00EF,X
        LDA SCREEN_RAM + $013F,X
        STA SCREEN_RAM + $0117,X
        LDA SCREEN_RAM + $0167,X
        STA SCREEN_RAM + $013F,X
        LDA SCREEN_RAM + $018F,X
        STA SCREEN_RAM + $0167,X
        LDA SCREEN_RAM + $01B7,X
        STA SCREEN_RAM + $018F,X
        LDA SCREEN_RAM + $01DF,X
        STA SCREEN_RAM + $01B7,X
        LDA SCREEN_RAM + $0207,X
        STA SCREEN_RAM + $01DF,X
        LDA SCREEN_RAM + $022F,X
        STA SCREEN_RAM + $0207,X
        LDA SCREEN_RAM + $0257,X
        STA SCREEN_RAM + $022F,X
        LDA SCREEN_RAM + $027F,X
        STA SCREEN_RAM + $0257,X
        LDA SCREEN_RAM + $02A7,X
        STA SCREEN_RAM + $027F,X
        LDA SCREEN_RAM + $02CF,X
        STA SCREEN_RAM + $02A7,X
        DEX 
        BNE bB313
        RTS 

;-------------------------------
; jB383
;-------------------------------
jB383   
        LDA aAED0
        AND #$07
        TAX 
        JSR sB925
        LDA aAED0
        AND #$0F
        TAX 
        LDA fB499,X
        STA aB4A9
        LDA #$01
        STA aB487
        LDX #$00
        LDA #$10
bB3A1   STA fB813,X
        DEX 
        BNE bB3A1
        LDA #$19
        STA aFF
bB3AB   JSR sAEB5
        AND #$07
        PHA 
        LDA aAED0
        AND #$FC
        BEQ bB3BF
        PLA 
        JSR sAEB5
        AND #$1F
        PHA 
bB3BF   PLA 
        TAY 
        LDA #<pBD40
        STA aFD
        LDA #>pBD40
        STA aFE
        TXA 
        PHA 
        CPY #$00
        BEQ bB3DF
bB3CF   LDA aFD
        CLC 
        ADC #$0A
        STA aFD
        LDA aFE
        ADC #$00
        STA aFE
        DEY 
        BNE bB3CF
bB3DF   LDY #$00
        LDA aAED0
        AND #$FC
        BNE bB400
        LDA aAED0
        AND #$03
        BEQ bB400
        TAX 
bB3F0   LDA aFD
        CLC 
        ADC #$50
        STA aFD
        LDA aFE
        ADC #$00
        STA aFE
        DEX 
        BNE bB3F0
bB400   PLA 
        TAX 
bB402   LDA (pFD),Y
        STA fB813,X
        INY 
        INX 
        CPY #$0A
        BNE bB402
        DEC aFF
        BNE bB3AB
        LDX #$09
        LDA #$00
bB415   STA fB813,X
        DEX 
        BPL bB415
        JSR sB458
        LDA #$00
        STA aAEBF
        LDA #$40
        STA lastKeyPressed
bB427   NOP 
        NOP 
        NOP 
        LDA lastKeyPressed
        CMP #$40
        BEQ bB448
        LDA aBC90
        BNE bB448
        LDA aAEBF
        EOR #$01
        STA aAEBF
        LDA #$00
        STA aB487
bB442   LDA lastKeyPressed
        CMP #$40
        BNE bB442
bB448   LDA aBED3
        BPL bB450
        JMP jBF27

bB450   LDA aAEC0
        BEQ bB427
        JMP jC041

;-------------------------------
; sB458
;-------------------------------
sB458   
        SEI 
        LDA #<pB47A
        STA $0314    ;IRQ
        LDA #>pB47A
        STA $0315    ;IRQ
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$D0
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        CLI 
        RTS 

pB47A   LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE bB4AA
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

aB487   .BYTE $00
aB488   .BYTE $00
fB489   .BYTE $02,$08,$07,$05,$0E,$04,$06,$00
fB491   .BYTE $00,$0B,$0C,$0F,$0F,$0C,$0B,$00
fB499   .BYTE $A0,$80,$60,$50,$48,$40,$30,$28
        .BYTE $20,$18,$10,$0C,$08,$04,$02,$01
aB4A9   .BYTE $00
bB4AA   NOP 
        NOP 
        NOP 
        LDA $D011    ;VIC Control Register 1
        ORA #$60
        AND #$77
        STA $D011    ;VIC Control Register 1
        LDX #$00
bB4B9   LDA fB489,X
        STA ROM_PLOT
        LDY #$14
bB4C1   DEY 
        BNE bB4C1
        INX 
        CPX #$08
        BNE bB4B9
        LDA #$E0
        STA aBFF7
        JSR sBCC6
        JSR sB524
        JSR sB572
        JSR sB913
        JSR sAF85
        JSR sB971
        JSR sBA07
        JSR sBA8A
        JSR sC1DE
        LDA aB488
        ORA #$10
        STA $D011    ;VIC Control Register 1
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$B8
        STA $D012    ;Raster Position
        LDA aAEBF
        BEQ bB50F
        DEC aC425
        JSR sC512
        INC aC425
        JMP jB515

bB50F   JSR sC3C0
        JSR sBBC8
;-------------------------------
; jB515
;-------------------------------
jB515   
        JSR sBCF9
        JSR sC781
        JSR sBD26
        JSR sC70E
        JMP jEA31

;-------------------------------
; sB524
;-------------------------------
sB524   
        LDA aB487
        BMI bB559
        LDA aB488
        CLC 
        ADC aB487
        STA aB488
        AND #$08
        BNE bB542
bB537   LDX #$42
bB539   LDY #$10
bB53B   DEY 
        BNE bB53B
        DEX 
        BNE bB539
        RTS 

bB542   JSR sAF13
        JSR sAED4
;-------------------------------
; jB548
;-------------------------------
jB548   
        LDA aB488
        AND #$07
        STA aB488
        LDA aAEBC
        EOR #$01
        STA aAEBC
        RTS 

bB559   LDA aB488
        CLC 
        ADC aB487
        STA aB488
        AND #$F0
        BEQ bB537
        JSR sB311
        JSR sB2C1
        JMP jB548

aB570   .BYTE $04
aB571   .BYTE $00
;-------------------------------
; sB572
;-------------------------------
sB572   
        LDA aBC90
        BEQ bB578
        RTS 

bB578   DEC aB570
        BEQ bB57E
        RTS 

bB57E   LDA $DC00    ;CIA1: Data Port Register A
        STA aB571
        LDY #$02
        STY aB570
        JSR sBB40
        LDA aB571
        AND #$0F
        CMP #$0F
        BEQ bB5AF
        LDA #$10
        STA aBA06
        LDX #$08
        LDA aB571
        AND #$0F
bB5A1   CMP fB671,X
        BEQ bB5A9
        DEX 
        BNE bB5A1
bB5A9   LDA fB679,X
        STA aB682
bB5AF   LDA aB571
        AND #$01
        BNE bB5CF
        LDA aB487
        PHA 
        SEC 
        SBC #$02
        STA aB487
        CMP #$F8
        BEQ bB5C8
        CMP #$F7
        BNE bB5EF
bB5C8   PLA 
        STA aB487
        JMP jB5F0

bB5CF   LDA aB571
        AND #$02
        BNE jB5F0
        LDA aB487
        PHA 
        CLC 
        ADC #$02
        STA aB487
        CMP #$08
        BEQ bB5E8
        CMP #$09
        BNE bB5EF
bB5E8   PLA 
        STA aB487
        JMP jB5F0

bB5EF   PLA 
;-------------------------------
; jB5F0
;-------------------------------
jB5F0   
        LDA aB571
        AND #$04
        BNE bB610
        LDA aAED3
        PHA 
        CLC 
        ADC #$02
        STA aAED3
        CMP #$08
        BEQ bB609
        CMP #$09
        BNE bB630
bB609   PLA 
        STA aAED3
        JMP jB631

bB610   LDA aB571
        AND #$08
        BNE jB631
        LDA aAED3
        PHA 
        SEC 
        SBC #$02
        STA aAED3
        CMP #$F8
        BEQ bB629
        CMP #$F7
        BNE bB630
bB629   PLA 
        STA aAED3
        JMP jB631

bB630   PLA 
;-------------------------------
; jB631
;-------------------------------
jB631   
        LDA aB571
        LDA #$10
        BNE bB641
        LDA #$00
        STA aB487
        STA aAED3
        RTS 

bB641   RTS 

;-------------------------------
; sB642
;-------------------------------
sB642   
        LDA #<pB02C
        STA screenPtrLo2
        LDA #>pB02C
        STA screenPtrHi2
        LDX #$00
bB64C   LDA screenPtrLo2
        STA fB683,X
        LDA screenPtrHi2
        STA fB74B,X
        LDA screenPtrLo2
        CLC 
        ADC #$14
        STA screenPtrLo2
        LDA screenPtrHi2
        ADC #$00
        STA screenPtrHi2
        INX 
        CPX #$C8
        BNE bB64C
        LDX #$00
        TXA 
bB66B   STA fB813,X
        DEX 
        BNE bB66B
fB671   RTS 

        .BYTE $0E,$06,$07,$05,$0D,$09,$0B
fB679   .BYTE $0A,$C0,$C1,$C2,$C3,$C4,$C5,$C6
        .BYTE $C7
aB682   .BYTE $C0
fB683   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
fB74B   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
fB813   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
;-------------------------------
; sB913
;-------------------------------
sB913   
        LDA lastKeyPressed
        CMP #$40
        BNE bB91A
        RTS 

bB91A   LDX #$04
bB91C   CMP fB93F,X
        BEQ sB925
        DEX 
        BNE bB91C
        RTS 

;-------------------------------
; sB925
;-------------------------------
sB925   
        LDA fB944,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        STA aB95C
        LDA fB94C,X
        STA $D023    ;Background Color 2, Multi-Color Register 1
        STA aB95D
        LDA fB954,X
        ORA #$08
        JSR sAFA2
fB93F   RTS 

        .BYTE $04,$05,$06,$03
fB944   .BYTE $07,$0B,$00,$05,$11,$08,$03,$00
fB94C   .BYTE $06,$0C,$10,$0D,$0C,$0A,$0E,$06
fB954   .BYTE $02,$01,$02,$04,$01,$02,$06,$05
aB95C   .BYTE $00
aB95D   .BYTE $00
fB95E   BRK #$01
        .BYTE $02,$03,$04,$05,$06,$07,$08,$09
        .BYTE $0A,$0B,$0C,$0D,$0E,$0F
aB96E   .BYTE $00
aB96F   .BYTE $00
aB970   .BYTE $00
;-------------------------------
; sB971
;-------------------------------
sB971   
        LDA aAED1
        LDY #$00
        STY a3E
        LDY aAED3
        BPL bB981
        LDY #$FF
        STY a3E
bB981   CLC 
        ADC aAED3
        STA aAED1
        LDA aAED2
        ADC a3E
        STA aAED2
        ROR 
        LDA aAED1
        ROR 
        AND #$F0
        BNE bB9A9
        LDA #<p20
        STA aAED1
        LDA #>p20
        STA aAED2
bB9A3   LDA #$00
        STA aAED3
bB9A8   RTS 

bB9A9   CMP #$A0
        BNE bB9A8
        LDA #$40
        STA aAED1
        LDA #$01
        STA aAED2
        BNE bB9A3

;-------------------------------
; Init_ScreenPointerArray
;-------------------------------
Init_ScreenPointerArray
        LDA #>SCREEN_RAM
        STA screenPtrHi2
        LDA #<SCREEN_RAM
        STA screenPtrLo2
        TAX 
bB9C2   LDA screenPtrLo2
        STA SCREEN_PTR_LO,X
        LDA screenPtrHi2
        STA SCREEN_PTR_HI,X
        LDA screenPtrLo2
        CLC 
        ADC #$28
        STA screenPtrLo2
        LDA screenPtrHi2
        ADC #$00
        STA screenPtrHi2
        INX 
        CPX #$1E
        BNE bB9C2
        RTS 

aB9DF   .BYTE $00
aB9E0   .BYTE $00
;-------------------------------
; sB9E1
;-------------------------------
sB9E1   
        LDA aB9DF
        SEC 
        SBC #$06
        CLC 
        ROR 
        CLC 
        ROR 
        TAY 
        LDA aB9E0
        SEC 
        SBC #$26
        CLC 
        ROR 
        CLC 
        ROR 
        CLC 
        ROR 
        TAX 
        LDA SCREEN_PTR_LO,X
        STA a3A
        LDA SCREEN_PTR_HI,X
        STA a3B
        LDA (p3A),Y
bBA05   RTS 

aBA06   .BYTE $04
;-------------------------------
; sBA07
;-------------------------------
sBA07   
        LDA aBC90
        BEQ bBA1D
        DEC aBC90
        BNE bBA1C
        LDA #$00
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control
bBA1C   RTS 

bBA1D   DEC aBA06
        BEQ bBA23
        RTS 

bBA23   LDA #$03
        STA aBA06
        LDA aAED3
        BEQ bBA38
        BMI bBA35
        DEC aAED3
        DEC aAED3
bBA35   INC aAED3
bBA38   LDA aB487
        BEQ bBA05
        BMI bBA45
        DEC aB487
        DEC aB487
bBA45   INC aB487
bBA48   RTS 

fBA49   .BYTE $00,$00,$00,$00,$00,$00,$00,$0F
        .BYTE $00,$0F,$00,$00,$00,$00,$01,$00
        .BYTE $01,$00,$00,$00,$00,$00,$00,$10
        .BYTE $00,$00,$10,$00,$00,$F0,$00,$00
        .BYTE $F0,$00,$00,$00,$21,$21,$21,$21
        .BYTE $00,$00,$00,$00,$23,$23,$23,$23
        .BYTE $24,$24,$24,$24,$25,$25,$25,$25
        .BYTE $26,$26,$26,$26,$22,$22,$22
        .BYTE $22
aBA89   .BYTE $04
;-------------------------------
; sBA8A
;-------------------------------
sBA8A   
        DEC aBA89
        BNE bBA48
        LDA #$03
        STA aBA89
        LDA aBC90
        BNE bBA48
        LDA #$70
        STA aB9E0
        LDA aAED2
        ROR 
        LDA aAED1
        ROR 
        STA aB9DF
        JSR sB9E1
        CMP #$20
        BNE bBAB3
        JMP jBE80

bBAB3   AND #$3F
        TAY 
        LDA fBA49,Y
        PHA 
        AND #$F0
        CMP #$20
        BNE bBAC4
        PLA 
        JMP jBE80

bBAC4   PLA 
        AND #$0F
        BEQ bBADB
        AND #$08
        BNE bBAD3
        INC aB487
        INC aB487
bBAD3   DEC aB487
        LDA #$10
        STA aBA06
bBADB   LDA fBA49,Y
        AND #$F0
        BEQ bBAF4
        AND #$80
        BNE bBAEC
        INC aAED3
        INC aAED3
bBAEC   DEC aAED3
        LDA #$10
        STA aBA06
bBAF4   LDA aB487
        CMP #$08
        BNE bBB00
        DEC aB487
        BNE bBB07
bBB00   CMP #$F8
        BNE bBB07
        INC aB487
bBB07   LDA aAED3
        CMP #$08
        BNE bBB12
        DEC aAED3
bBB11   RTS 

bBB12   CMP #$F8
        BNE bBB11
        INC aAED3
        RTS 

aBB1A   .BYTE $04
fBB1B   .BYTE $00,$00
fBB1D   .BYTE $00
fBB1E   .BYTE $00,$00
fBB20   .BYTE $00,$00,$00
fBB23   .BYTE $00
fBB24   .BYTE $00,$00
fBB26   .BYTE $00,$00,$00
fBB29   .BYTE $00,$00,$00,$00
fBB2D   .BYTE $00,$00,$06,$06,$02,$02,$04,$04
        .BYTE $05,$05,$03,$03,$07,$07,$01
fBB3C   .BYTE $01,$02,$04,$08
;-------------------------------
; sBB40
;-------------------------------
sBB40   
        AND #$0F
        CMP #$0F
        BNE bBB4B
bBB46   PLA 
        PLA 
        JMP jB631

bBB4B   DEC aBB1A
        BNE bBB46
        LDA #$04
        STA aBB1A
        LDX #$03
bBB57   LDA fBB1D,X
        BEQ bBB61
        DEX 
        BNE bBB57
        BEQ bBB46
bBB61   LDA #$10
        STA $D404    ;Voice 1: Control Register
        LDA aAED1
        STA aBB1A,X
        LDA #$40
        STA aBD3F
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        LDA #$10
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        LDA #$20
        STA $D412    ;Voice 3: Control Register
        LDA #$15
        STA $D404    ;Voice 1: Control Register
        LDA aAED2
        STA fBB23,X
        LDA #$70
        STA fBB1D,X
        LDA #$10
        STA fBB20,X
        LDA aB571
        AND #$01
        BNE bBBA1
        LDA #$FD
        STA fBB29,X
        BNE bBBAD
bBBA1   LDA aB571
        AND #$02
        BNE bBBAD
        LDA #$03
        STA fBB29,X
bBBAD   LDA aB571
        AND #$04
        BNE bBBBB
        LDA #$FD
        STA fBB26,X
        BNE bBBC7
bBBBB   LDA aB571
        AND #$08
        BNE bBBC7
        LDA #$03
        STA fBB26,X
bBBC7   RTS 

;-------------------------------
; sBBC8
;-------------------------------
sBBC8   
        LDX #$03
bBBCA   LDA fBB1D,X
        BNE bBBD7
        LDA #$F0
        STA SCREEN_RAM + $03F8,X
        JMP jBBDF

bBBD7   JSR sBBE3
        LDA #$FC
        STA SCREEN_RAM + $03F8,X
;-------------------------------
; jBBDF
;-------------------------------
jBBDF   
        DEX 
        BNE bBBCA
        RTS 

;-------------------------------
; sBBE3
;-------------------------------
sBBE3   
        LDA fBB23,X
        ROR 
        LDA aBB1A,X
        ROR 
        STA aB9DF
        LDA fBB1D,X
        STA aB9E0
        LDA fBB26,X
        STA aBC8E
        LDA fBB29,X
        STA aBC8F
        TXA 
        PHA 
        JSR sB9E1
        AND #$3F
        TAY 
        PLA 
        TAX 
        LDA fBA49,Y
        PHA 
        AND #$0F
        BEQ bBC28
        CMP #$0F
        BNE bBC22
        INC aBC8F
        INC aBC8F
        INC aBC8F
        INC aBC8F
bBC22   DEC aBC8F
        DEC aBC8F
bBC28   PLA 
        AND #$F0
        BEQ bBC43
        CMP #$F0
        BEQ bBC3D
        INC aBC8E
        INC aBC8E
        INC aBC8E
        INC aBC8E
bBC3D   DEC aBC8E
        DEC aBC8E
bBC43   LDA #$00
        STA a3E
        LDA aBC8E
        BPL bBC50
        LDA #$FF
        STA a3E
bBC50   LDA aBB1A,X
        CLC 
        ADC aBC8E
        STA aBB1A,X
        LDA fBB23,X
        ADC a3E
        STA fBB23,X
        LDA fBB1D,X
        CLC 
        ADC aBC8F
        STA fBB1D,X
        TXA 
        ASL 
        TAY 
        LDA fBB1D,X
        STA $D001,Y  ;Sprite 0 Y Pos
        LDA aBB1A,X
        STA $D000,Y  ;Sprite 0 X Pos
        LDA fBB23,X
        BNE bBC91
        LDA fBB3C,X
        EOR #$FF
        AND $D010    ;Sprites 0-7 MSB of X coordinate
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JMP jBC9A

aBC8E   .BYTE $00
aBC8F   .BYTE $00
aBC90   .BYTE $00
bBC91   LDA fBB3C,X
        ORA $D010    ;Sprites 0-7 MSB of X coordinate
        STA $D010    ;Sprites 0-7 MSB of X coordinate
;-------------------------------
; jBC9A
;-------------------------------
jBC9A   
        LDY fBB20,X
        ASL 
        LDA fBB2D,Y
        STA $D027,X  ;Sprite 0 Color
        DEC fBB20,X
        BEQ bBCAA
        RTS 

bBCAA   LDA #$00
        STA fBB1D,X
        STA fBB26,X
        STA fBB29,X
        RTS 

fBCB6   .BYTE $F6,$F6,$F6,$F6,$F6,$F6,$F6,$F6
fBCBE   .BYTE $02,$08,$07,$04,$0E,$04,$06,$02
;-------------------------------
; sBCC6
;-------------------------------
sBCC6   
        LDA #$FF
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDX #$00
        STX $D010    ;Sprites 0-7 MSB of X coordinate
bBCD0   TXA 
        ASL 
        TAY 
        LDA aBFF7
        STA $D001,Y  ;Sprite 0 Y Pos
        LDA fBCF1,X
        STA $D000,Y  ;Sprite 0 X Pos
        LDA fBCB6,X
        STA SCREEN_RAM + $03F8,X
        LDA fBCBE,X
        STA $D027,X  ;Sprite 0 Color
        INX 
        CPX #$08
        BNE bBCD0
        RTS 

fBCF1   .BYTE $50,$68,$80,$98,$B0,$C8,$E0,$F8
;-------------------------------
; sBCF9
;-------------------------------
sBCF9   
        LDA #$70
        STA $D001    ;Sprite 0 Y Pos
        LDA aAED1
        STA $D000    ;Sprite 0 X Pos
        LDA aB682
        STA SCREEN_RAM + $03F8
        LDA #$08
        STA $D027    ;Sprite 0 Color
        LDA aAED2
        BNE bBD1D
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        RTS 

bBD1D   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA #$01
        STA $D010    ;Sprites 0-7 MSB of X coordinate
bBD25   RTS 

;-------------------------------
; sBD26
;-------------------------------
sBD26   
        LDA aBD3F
        BEQ bBD25
        LDA aBD3F
        SEC 
        SBC #$04
        STA aBD3F
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        BNE bBD3E
        LDA #$14
        STA $D404    ;Voice 1: Control Register
bBD3E   RTS 

aBD3F   .BYTE $00
pBD40   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$15,$16,$17,$00,$00
        .BYTE $15,$16,$17,$00,$00,$14,$14,$14
        .BYTE $14,$14,$14,$14,$14,$00,$11,$11
        .BYTE $11,$11,$11,$11,$11,$11,$11,$11
        .BYTE $13,$13,$13,$13,$13,$13,$13,$13
        .BYTE $13,$13,$12,$12,$12,$12,$12,$12
        .BYTE $12,$12,$12,$00,$14,$14,$00,$15
        .BYTE $16,$17,$00,$00,$14,$14,$15,$16
        .BYTE $16,$16,$16,$16,$16,$16,$16,$17
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$00,$00,$01,$01,$01,$01
        .BYTE $00,$00,$01,$01,$01,$01,$00,$00
        .BYTE $0B,$0B,$0B,$0C,$0C,$0C,$00,$00
        .BYTE $00,$02,$03,$04,$05
fBDBD   .BYTE $06,$07,$08,$09,$0A,$02,$03,$04
        .BYTE $05,$05,$05,$05,$0B,$0B,$0B,$00
        .BYTE $00,$01,$01,$00,$00,$01,$01,$00
        .BYTE $00,$00,$00,$0E,$0D,$00,$00,$0E
        .BYTE $0D,$00,$00,$00,$02,$03,$04,$05
        .BYTE $08,$09,$0A,$0B,$00,$00,$00,$00
        .BYTE $1A,$1A,$1A,$18,$18,$18,$18,$00
        .BYTE $00,$00,$1A,$1A,$1A,$19,$19,$19
        .BYTE $19,$00,$00,$18,$18,$00,$00,$00
        .BYTE $00,$19,$19,$00,$00,$1B,$1B,$00
        .BYTE $00,$15,$16,$17,$00,$15,$16,$17
        .BYTE $1D,$1D,$15,$16,$17,$1D,$1D,$14
        .BYTE $14,$1E,$1E,$00,$00,$15,$16,$17
        .BYTE $00,$00,$0B,$0B,$0B,$15,$16,$17
        .BYTE $15,$16,$17,$00,$00,$1D,$1D,$1D
        .BYTE $1D,$1E,$1E,$1E,$1E,$00,$00,$20
        .BYTE $1F,$20,$1F,$00,$00,$11,$11,$00
        .BYTE $00,$20,$1F,$20,$1F,$20,$1F,$20
        .BYTE $1F,$00,$1E,$1E,$1E,$20,$1F,$1D
        .BYTE $1D,$1D,$00,$00,$0C,$0C,$0C,$15
        .BYTE $16,$17,$00,$00,$00,$00,$02,$03
        .BYTE $04,$05,$08,$09,$0A,$0B,$00,$00
        .BYTE $00,$06,$06,$06,$11,$11,$11,$00
        .BYTE $00,$00,$00,$0F,$0F,$15,$16,$17
        .BYTE $15,$16,$17
;-------------------------------
; jBE80
;-------------------------------
jBE80   
        CMP #$20
        BNE bBEAC
        LDA aAED3
        BEQ bBE91
        BMI bBE8F
        LDA #$F9
        BNE bBE91
bBE8F   LDA #$07
bBE91   STA aAED3
        LDA aB487
        BEQ bBEA1
        BMI bBE9F
        LDA #$F9
        BNE bBEA1
bBE9F   LDA #$07
bBEA1   STA aB487
        LDY #$6E
        LDX #$C7
        JSR sBF0C
        RTS 

bBEAC   CMP #$21
        BNE bBED4
        LDA aAED3
        EOR #$FF
        CLC 
        ADC #$01
        STA aAED3
        LDA aB487
        EOR #$FF
        CLC 
        ADC #$01
        STA aB487
        LDA #$03
        STA aBA89
        LDY #$74
        LDX #$C7
        JMP sBF0C

        RTS 

aBED3   .BYTE $07
bBED4   CMP #$22
        BNE bBEDE
        LDA #$01
        STA aAEC0
bBEDD   RTS 

bBEDE   CMP #$23
        BNE bBEE9
        LDA #$07
        STA aB487
        BNE sBF0C
bBEE9   CMP #$24
        BNE bBEF4
        LDA #$F9
        STA aB487
        BNE sBF0C
bBEF4   CMP #$25
        BNE bBEFF
        LDA #$07
        STA aAED3
        BNE sBF0C
bBEFF   CMP #$26
        BNE bBEDD
        LDA #$F9
        STA aAED3
        LDY #$7A
        LDX #$C7
;-------------------------------
; sBF0C
;-------------------------------
sBF0C   
        LDA #$01
        STA aC707
        STY a78
        STX a79
        LDY #$00
bBF17   LDA (p78),Y
        STA fC708,Y
        INY 
        CPY #$06
        BNE bBF17
        LDA #$20
        STA $D40B    ;Voice 2: Control Register
        RTS 

;-------------------------------
; jBF27
;-------------------------------
jBF27   
        SEI 
        LDA #<pBFB8
        STA $0314    ;IRQ
        LDA #>pBFB8
        STA $0315    ;IRQ
        LDA #$FF
        STA $D01B    ;Sprite to Background Display Priority
        LDA $D016    ;VIC Control Register 2
        AND #$EF
        STA $D016    ;VIC Control Register 2
        LDX #$07
bBF41   LDA fAEC8,X
        STA fBCB6,X
        DEX 
        BPL bBF41
        JSR ClearScreen
        LDY #$27
bBF4F   LDX #$06
bBF51   LDA fBFAA,X
        STA aFD
        LDA fBFB1,X
        STA aFE
        LDA fC019,Y
        AND #$3F
        STA (pFD),Y
        LDA aFE
        CLC 
        ADC #$D4
        STA aFE
        LDA fAEC1,X
        STA (pFD),Y
        DEX 
        BPL bBF51
        DEY 
        BPL bBF4F
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        CLI 
        LDX #$10
        STX aFF
        LDY #$00
bBF86   LDX #$30
bBF88   LDA j4000,X
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        DEY 
        BNE bBF88
        DEX 
        BNE bBF88
        DEC aFF
        BNE bBF86
        JMP sAD7C

fBFA1   .BYTE $30,$4C,$68,$84,$A0,$BC,$D8,$00
aBFA9   .BYTE $00
fBFAA   .BYTE $A0,$C8,$F0,$18,$40,$68,$90
fBFB1   .BYTE $04,$04,$04,$05,$05,$05,$05
pBFB8   LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE bBFC2
        JMP jBFF1

bBFC2   LDY aBFA9
        LDA fBFA1,Y
        CLC 
        ADC #$08
        STA aBFF7
        JSR sBCC6
        INC aBFA9
        LDY aBFA9
        LDA fBFA1,Y
        BNE bBFE6
        JSR sBFF9
        LDA #$00
        STA aBFA9
        LDA #$20
bBFE6   STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
;-------------------------------
; jBFF1
;-------------------------------
jBFF1   
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

aBFF7   .BYTE $00
aBFF8   .BYTE $05
;-------------------------------
; sBFF9
;-------------------------------
sBFF9   
        DEC aBFF8
        BEQ bBFFF
        RTS 

bBFFF   LDA fA907,X
        PHP 
        STA aBFF8
bC006   INC fBCB6,X
        LDA fBCB6,X
        CMP #$F9
        BNE bC015
        LDA #$F6
        STA fBCB6,X
bC015   DEX 
        BPL bC006
        RTS 

fC019   .TEXT " % % \ \  SORRY!!   NO BONUS!!  \ \ % % "
;-------------------------------
; jC041
;-------------------------------
jC041   
        SEI 
        LDA #<pC137
        STA $0314    ;IRQ
        LDA #>pC137
        STA $0315    ;IRQ
        LDA #$00
        STA aC136
        INC aAED0
        INC aAAD1
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA $D011    ;VIC Control Register 1
        AND #$F8
        STA $D011    ;VIC Control Register 1
        LDA $D016    ;VIC Control Register 2
        AND #$EF
        STA $D016    ;VIC Control Register 2
        LDA #$FF
        STA $D01B    ;Sprite to Background Display Priority
        LDA #$F0
        STA SCREEN_RAM + $03FE
        STA SCREEN_RAM + $03FF
        JSR ClearScreen
        LDY #$27
bC07C   LDX #$06
bC07E   LDA fBFAA,X
        STA aFD
        LDA fBFB1,X
        STA aFE
        LDA fC1B4,Y
        AND #$3F
        STA (pFD),Y
        LDA aFE
        CLC 
        ADC #$D4
        STA aFE
        LDA fB489,X
        STA (pFD),Y
        DEX 
        BPL bC07E
        LDA #$20
        STA $D40B    ;Voice 2: Control Register
        LDA fC0ED,Y
        AND #$3F
        STA SCREEN_RAM + $02D0,Y
        LDA #$01
        STA fDAD0,Y
        DEY 
        BPL bC07C
        LDX #$06
bC0B5   LDA fAAC1,X
        STA SCREEN_RAM + $02E6,X
        DEX 
        BPL bC0B5
        CLI 
        JSR sC1F7
        JSR sC24F
        LDA #$10
        STA aFF
        LDA #$15
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
bC0CE   LDX #$60
bC0D0   DEX 
        STY $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA aFF
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        TXA 
        BNE bC0D0
        DEY 
        BNE bC0CE
        DEC aFF
        BNE bC0CE
        JMP sAD7C

fC0E6   .BYTE $EF,$CF,$AF,$8F,$6F,$4F
aC0EC   .BYTE $C8
fC0ED   .TEXT "CURRENT BONUS BOUNTY: 0000000 % % % % % "
;-------------------------------
; sC115
;-------------------------------
sC115   
        LDX #$05
bC117   TXA 
        ASL 
        TAY 
        LDA aC135
        STA $D001,Y  ;Sprite 0 Y Pos
        LDA fC0E6,X
        STA $D000,Y  ;Sprite 0 X Pos
        LDA #$00
        STA $D027,X  ;Sprite 0 Color
        LDA aC0EC
        STA SCREEN_RAM + $03F8,X
        DEX 
        BPL bC117
        RTS 

aC135   .BYTE $00
aC136   .BYTE $00
pC137   .BYTE $AD,$19
        BNE bC164
        ORA (pD0,X)
        .BYTE $03,$4C ;SLO ($4C,X)
        SBC (pBF),Y
        LDY aC136
        LDA fBFA1,Y
        CLC 
        ADC #$08
        STA aC135
        JSR sC115
        INC aC136
        LDY aC136
        LDA fBFA1,Y
        BNE bC167
        LDA #$00
        STA aC136
        TAY 
        JSR sC17B
bC164   LDA fBFA1,Y
bC167   STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

aC178   .BYTE $01
aC179   .BYTE $0A
aC17A   .BYTE $05
;-------------------------------
; sC17B
;-------------------------------
sC17B   
        DEC aC17A
        BEQ bC181
        RTS 

bC181   LDA #$05
        STA aC17A
        LDA aC179
        BEQ bC18F
        DEC aC179
bC18E   RTS 

bC18F   INC aC0EC
        LDA aC0EC
        CMP #$CC
        BNE bC18E
        LDA #$C8
        STA aC0EC
        DEC aC178
        BPL bC18E
        JSR sAEB5
        AND #$03
        STA aC178
        JSR sAEB5
        AND #$3F
        STA aC179
        RTS 

fC1B4   .TEXT "CONGOATULATIONS... STAND BY TO COP BONUS"
aC1DC   .BYTE $FF
aC1DD   .BYTE $20
;-------------------------------
; sC1DE
;-------------------------------
sC1DE   
        DEC aC1DD
        BEQ bC1E4
bC1E3   RTS 

bC1E4   LDA #$20
        STA aC1DD
        DEC aC1DC
        LDA aC1DC
        CMP #$01
        BNE bC1E3
        INC aC1DC
        RTS 

;-------------------------------
; sC1F7
;-------------------------------
sC1F7   
        LDX #$0A
bC1F9   LDA fC243,X
        AND #$3F
        STA SCREEN_RAM + $023E,X
        LDA #$07
        STA fDA3E,X
        DEX 
        BPL bC1F9
bC209   JSR sAEB5
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        LDA #$11
        STA $D412    ;Voice 3: Control Register
        LDY #$01
        LDX #$06
        JSR sC229
        LDX #$10
bC21D   DEY 
        BNE bC21D
        DEX 
        BNE bC21D
        DEC aC1DC
        BNE bC209
        RTS 

;-------------------------------
; sC229
;-------------------------------
sC229   
        TXA 
        PHA 
bC22B   INC SCREEN_RAM + $02E5,X
        LDA SCREEN_RAM + $02E5,X
        CMP #$3A
        BNE bC23D
        LDA #$30
        STA SCREEN_RAM + $02E5,X
        DEX 
        BNE bC22B
bC23D   PLA 
        TAX 
        DEY 
        BNE sC229
        RTS 

fC243   .TEXT "TIMER BONUS"
aC24E   .TEXT $10
;-------------------------------
; sC24F
;-------------------------------
sC24F   
        LDX #$0A
bC251   LDA fC763,X
        AND #$3F
        STA SCREEN_RAM + $023E,X
        LDA #$04
        STA fDA3E,X
        DEX 
        BPL bC251
        LDA aC24E
        BEQ bC285
        LDA #$21
        STA $D412    ;Voice 3: Control Register
bC26B   JSR sAEB5
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        LDX #$06
        LDY #$01
        JSR sC229
        LDX #$40
bC27A   DEY 
        BNE bC27A
        DEX 
        BNE bC27A
        DEC aC24E
        BNE bC26B
bC285   LDA #$28
        LDX #$06
bC289   LDA SCREEN_RAM + $02E6,X
        STA fAAC1,X
        DEX 
        BPL bC289
        RTS 

fC293   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
fC2D3   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
fC313   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
aC353   .BYTE $00
aC354   .BYTE $00
aC355   .BYTE $00
aC356   .BYTE $00
aC357   .BYTE $01
;-------------------------------
; sC358
;-------------------------------
sC358   
        DEC aC357
        BEQ bC35E
        RTS 

bC35E   LDA aC356
        BEQ bC367
        INC aC357
        RTS 

bC367   INC aC356
        JSR sAEB5
        STA aC353
        LDA #>p40
        STA aC355
        LDA #<p40
        STA aC354
        JSR sC380
        JMP jC397

;-------------------------------
; sC380
;-------------------------------
sC380   
        JSR sAEB5
        AND #$07
        CLC 
        ADC #$03
        STA aC3BD
        JSR sAEB5
        AND #$07
        CLC 
        ADC #$03
        STA aC3BE
        RTS 

;-------------------------------
; jC397
;-------------------------------
jC397   
        LDX #$3F
bC399   LDA #$00
        STA fC313,X
        LDA aC353
        STA fC293,X
        LDA aC354
        STA fC2D3,X
        DEX 
        BPL bC399
        LDA #$01
        STA aC3BF
        LDA #$06
        STA aC5FE
        LDA #$01
        STA aC356
bC3BC   RTS 

aC3BD   .BYTE $00
aC3BE   .BYTE $00
aC3BF   .BYTE $40
;-------------------------------
; sC3C0
;-------------------------------
sC3C0   
        JSR sC5FF
        LDA aBC90
        BNE bC3D5
        LDA aC3BF
        BEQ bC3D2
        DEC aC3BF
        BNE bC3D5
bC3D2   JSR sC68E
bC3D5   LDA aC356
        BEQ bC3BC
        CMP #$01
        BNE bC426
        JSR sC4F0
        INC aC356
        LDA #$00
        STA aC423
        STA aC424
        STA aC41D
        STA aC41E
        LDA #$0A
        STA aC425
        JSR sAEB5
        AND #$03
        ADC #$02
        STA aC41F
        STA aC420
        JSR sAEB5
        AND #$03
        ADC #$02
        STA aC421
        STA aC422
;-------------------------------
; sC411
;-------------------------------
sC411   
        JSR sAEB5
        AND #$7F
        ADC #$10
        STA aC41C
        RTS 

aC41C   .BYTE $00
aC41D   .BYTE $00
aC41E   .BYTE $00
aC41F   .BYTE $00
aC420   .BYTE $00
aC421   .BYTE $00
aC422   .BYTE $00
aC423   .BYTE $00
aC424   .BYTE $00
aC425   .BYTE $00
bC426   DEC aC41C
        BNE bC44A
        JSR sC380
        JSR sC411
        JSR sAEB5
        AND #$07
        SBC #$04
        STA aC424
        JSR sAEB5
        AND #$08
        SBC #$04
        STA aC423
        LDA #$01
        STA aC5FE
bC44A   LDA aC676
        BEQ bC452
        DEC aC676
bC452   DEC aC420
        BNE bC460
        LDA aC41F
        STA aC420
        JSR sC5A5
bC460   DEC aC422
        BNE bC46E
        LDA aC421
        STA aC422
        JSR sC57D
bC46E   LDA aC676
        BEQ bC476
        JSR sC677
bC476   LDA aC423
        BMI bC48F
        CLC 
        ADC aC353
        STA aC353
        LDA #$00
        ADC aC355
        AND #$01
        STA aC355
        JMP jC4B2

bC48F   EOR #$FF
        STA a77
        INC a77
        LDA aC353
        SEC 
        SBC a77
        STA aC353
        LDA aC355
        SBC #$00
        CMP #$FF
        BNE bC4AF
        LDA #$00
        STA aC423
        STA aC353
bC4AF   STA aC355
;-------------------------------
; jC4B2
;-------------------------------
jC4B2   
        LDA aC354
        CLC 
        ADC aC424
        STA aC354
        AND #$F0
        CMP #$20
        BNE bC4D4
        LDA aC424
        EOR #$FF
        STA aC424
        INC aC424
        LDA #$30
        STA aC354
        BNE bC4E8
bC4D4   CMP #$B0
        BNE bC4E8
        LDA aC424
        EOR #$FF
        STA aC424
        INC aC424
        LDA #$AF
        STA aC354
bC4E8   LDA aC676
        BEQ sC4F0
        JSR sC677
;-------------------------------
; sC4F0
;-------------------------------
sC4F0   
        LDX aC425
        LDA aC353
        STA fC293,X
        LDA aC354
        STA fC2D3,X
        LDA aC355
        STA fC313,X
        INX 
        TXA 
        PHA 
        JSR sC512
        PLA 
        AND #$3F
        STA aC425
        RTS 

;-------------------------------
; sC512
;-------------------------------
sC512   
        LDX #$00
bC514   TXA 
        ASL 
        TAY 
        LDA #$00
        STA $D02B,X  ;Sprite 4 Color
        LDA aC676
        BEQ bC526
        LDA #$06
        STA $D02B,X  ;Sprite 4 Color
bC526   LDA aC578
        STA SCREEN_RAM + $03FC,X
        TXA 
        PHA 
        LDA aC425
        SEC 
        SBC fC574,X
        AND #$3F
        TAX 
        LDA fC293,X
        STA $D008,Y  ;Sprite 4 X Pos
        LDA fC2D3,X
        STA $D009,Y  ;Sprite 4 Y Pos
        LDA fC313,X
        STA a77
        PLA 
        TAX 
        LDA a77
        BEQ bC560
        LDA fC56C,X
        ORA $D010    ;Sprites 0-7 MSB of X coordinate
        STA $D010    ;Sprites 0-7 MSB of X coordinate
;-------------------------------
; jC558
;-------------------------------
jC558   
        INX 
        CPX #$04
        BNE bC514
        JMP jC5DC

bC560   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND fC570,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JMP jC558

fC56C   .BYTE $10,$20,$40,$80
fC570   .BYTE $EF,$DF,$BF,$7F
fC574   .BYTE $00,$03,$06,$09
aC578   .BYTE $C8,$02,$06,$07,$04
;-------------------------------
; sC57D
;-------------------------------
sC57D   
        LDA #$70
        CMP aC354
        BMI bC591
        LDA aC424
        CMP aC3BE
        BNE bC58D
bC58C   RTS 

bC58D   INC aC424
        RTS 

bC591   LDA aC3BE
        EOR #$FF
        STA a77
        INC a77
        LDA a77
        CMP aC424
        BEQ bC58C
        DEC aC424
bC5A4   RTS 

;-------------------------------
; sC5A5
;-------------------------------
sC5A5   
        LDA aC355
        ROR 
        LDA aC353
        ROR 
        STA a77
        LDA aAED2
        ROR 
        LDA aAED1
        ROR 
        CMP a77
        BMI bC5C7
        LDA aC3BD
        CMP aC423
        BEQ bC5A4
        INC aC423
bC5C6   RTS 

bC5C7   LDA aC3BD
        EOR #$FF
        STA a77
        INC a77
        LDA a77
        CMP aC423
        BEQ bC5C6
        DEC aC423
bC5DA   RTS 

aC5DB   .BYTE $05
;-------------------------------
; jC5DC
;-------------------------------
jC5DC   
        DEC aC5DB
        BNE bC5DA
        LDA #$05
        STA aC5DB
        LDA aC5FE
        BEQ bC5DA
        INC aC578
        LDA aC578
        CMP #$CC
        BNE bC5DA
        LDA #$C8
        STA aC578
        DEC aC5FE
        RTS 

aC5FE   .BYTE $00
;-------------------------------
; sC5FF
;-------------------------------
sC5FF   
        LDX #$02
bC601   LDA fBB1E,X
        BEQ bC609
        JSR sC60D
bC609   DEX 
        BPL bC601
bC60C   RTS 

;-------------------------------
; sC60D
;-------------------------------
sC60D   
        SEC 
        SBC aC354
        BPL bC618
        EOR #$FF
        CLC 
        ADC #$01
bC618   CMP #$10
        BPL bC60C
        LDA fBB24,X
        ROR 
        LDA fBB1B,X
        ROR 
        STA a77
        LDA aC355
        ROR 
        LDA aC353
        ROR 
        SEC 
        SBC a77
        BPL bC638
        EOR #$FF
        CLC 
        ADC #$01
bC638   CMP #$10
        BPL bC60C
        LDA #$00
        STA fBB1E,X
        LDA aB4A9
        STA aC676
        LDA #$04
        STA aC5FE
        LDA #<p6001
        STA aC707
        LDA #>p6001
        STA fC708
        STA aC709
        LDA #<p6904
        STA aC70A
        LDA #>p6904
        STA aC70B
        LDA #<p4003
        STA aC70C
        LDA #>p4003
        STA aC70D
        INC aC24E
        BNE bC675
        DEC aC24E
bC675   RTS 

aC676   .BYTE $00
;-------------------------------
; sC677
;-------------------------------
sC677   
        LDA aC423
        EOR #$FF
        STA aC423
        INC aC423
        LDA aC424
        EOR #$FF
        STA aC424
        INC aC424
bC68D   RTS 

;-------------------------------
; sC68E
;-------------------------------
sC68E   
        LDA aC676
        BNE bC68D
        LDA aC355
        ROR 
        LDA aC353
        ROR 
        STA a77
        LDA aAED2
        ROR 
        LDA aAED1
        ROR 
        SEC 
        SBC a77
        BPL bC6AF
        EOR #$FF
        CLC 
        ADC #$01
bC6AF   CMP #$0C
        BPL bC68D
        LDA aC354
        SEC 
        SBC #$70
        BPL bC6C0
        EOR #$FF
        CLC 
        ADC #$01
bC6C0   CMP #$0C
        BPL bC68D
        LDA aAED3
        PHA 
        LDA aC423
        STA aAED3
        PLA 
        STA aC423
        LDA aB487
        PHA 
        LDA aC424
        STA aB487
        PLA 
        STA aC424
        LDA #$10
        STA aC3BF
        LDA #$01
        STA aC707
        LDA #$01
        STA aC70A
        LDA #$10
        STA fC708
        STA aC709
        LDA #$00
        STA aC70B
        STA aC70D
        LDA #$FF
        STA aC70C
        JMP jAEA9

aC707   .BYTE $00
fC708   .BYTE $00
aC709   .BYTE $00
aC70A   .BYTE $00
aC70B   .BYTE $00
aC70C   .BYTE $00
aC70D   .BYTE $00
;-------------------------------
; sC70E
;-------------------------------
sC70E   
        LDA aC707
        BNE bC719
        LDA #$20
        STA $D40B    ;Voice 2: Control Register
bC718   RTS 

bC719   CMP #$01
        BNE bC718
        LDA aC709
        CLC 
        ADC aC70C
        STA aC709
        CMP aC70B
        BEQ bC73B
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        LDY #$21
        AND #$01
        BNE bC737
        LDY #$81
bC737   STY $D40B    ;Voice 2: Control Register
        RTS 

bC73B   DEC aC70A
        BEQ bC758
        LDA fC708
        CLC 
        ADC aC70D
        STA fC708
        STA aC709
        LDA aC70B
        CLC 
        ADC aC70D
        STA aC70B
        RTS 

bC758   LDA #$00
        STA aC707
        LDA #$20
        STA $D40B    ;Voice 2: Control Register
        RTS 

fC763   .TEXT "IBALL BONUS"
        .BYTE $80,$80,$01,$10,$F0,$00,$11,$11
        .BYTE $01,$1D,$01,$00,$30,$30,$01,$40
        .BYTE $02,$00
aC780   .BYTE $05
;-------------------------------
; sC781
;-------------------------------
sC781   
        DEC aC780
        BNE bC7A3
        INC aB970
        LDA aB970
        AND #$07
        STA aB970
        TAX 
        LDA fB489,X
        STA aB96E
        LDA fB491,X
        STA aB96F
        LDA #$03
        STA aC780
bC7A3   LDX aB95C
        LDA fB95E,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDX aB95D
        LDA fB95E,X
        STA $D023    ;Background Color 2, Multi-Color Register 1
        RTS 

        .BYTE $29,$D0,$18,$20,$0A,$C1,$90,$13
        .BYTE $A4,$23,$D0,$1A,$20,$7C,$CD,$20
        .BYTE $F5,$C2,$AA,$BD,$17,$CE,$D0,$06
        .BYTE $20,$EA,$C0,$4C,$9C,$C0,$A4,$22
        .BYTE $C0,$02,$D0,$3B,$F0,$02,$84,$22
        .BYTE $88,$38,$20,$7C,$CD,$AA,$E5,$24
        .BYTE $C8,$20,$7C,$CD,$E5,$25,$90,$27
        .BYTE $88,$20,$7C,$CD,$85,$0B,$A5,$AE
        .BYTE $E5,$0B,$C8,$20,$7C,$CD,$85,$0B
        .BYTE $A5,$AF
fC802   =*+$02
;-------------------------------
; jC800
;-------------------------------
jC800   
        JMP jC9C0

fC803   .TEXT "0000000...."
fC80E   .TEXT $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
;-------------------------------
; sC818
;-------------------------------
sC818   
        .TEXT "L"
aC819   .TEXT $F0
aC81A   .TEXT "`"
pC81B   .TEXT "0068000"
aC822   .TEXT "YAK ", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0065535RATT", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "00491"
        .TEXT "52WULF", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0032768INCA", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "003"
        .TEXT "0000MAT ", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0025000PSY ", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0"
        .TEXT "020000TAK ", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0016384GOAT", $00, $00, $00, $00, $00, $00, $00, $00, $00
        .TEXT $00, "0010000PINK", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0009000FLYD", $00, $00, $00, $00, $00, $00, $00
        .TEXT $00, $00, $00, "0008192LED ", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0007000ZEP ", $00, $00, $00, $00, $00
        .TEXT $00, $00, $00, $00, $00, "0006000MACH", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0005000SCUM", $00, $00, $00
        .TEXT $00, $00, $00, $00, $00, $00, $00, "0004096TREV", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0003000MARK", $00
        .TEXT $00, $00, $00, $00, $00, $00, $00, $00, $00, "0002000MAH ", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "0001000INT"
        .TEXT "I", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
pC995   .TEXT "0000900GIJO", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
pC9AA   .TEXT "0000800LAMA", $00, $00, $00, $00, $00, $00, $00, $00, $00
        .BYTE $00,$FF
;-------------------------------
; jC9C0
;-------------------------------
jC9C0   
        STX aFD
        LDA #$00
        STA aCC88
        STY aFC
;-------------------------------
; jC9C9
;-------------------------------
jC9C9   
        SEI 
        LDA #<pCD4C
        STA $0314    ;IRQ
        LDA #>pCD4C
        STA $0315    ;IRQ
        CLI 
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        JSR sCEB9
        LDA aCC88
        BEQ bC9E8
        JMP jCA9D

bC9E8   LDY #$07
bC9EA   LDA (pFE),Y
        STA fC802,Y
        DEY 
        BNE bC9EA
        LDY #$09
bC9F4   LDA (pFC),Y
        STA fC80E,Y
        DEY 
        BPL bC9F4
        LDY #$00
        LDA #<pC81B
        STA aFE
        LDA #>pC81B
        STA aFF
        LDX #$00
        LDA #$14
        STA aFB
bCA0C   LDA (pFE),Y
        CMP fC803,X
        BEQ bCA18
        BPL bCA1E
        JMP jCA3C

bCA18   INY 
        INX 
        CPY #$07
        BNE bCA0C
bCA1E   LDA aFE
        CLC 
        ADC #$15
        STA aFE
        LDA aFF
        ADC #$00
        STA aFF
        LDY #$00
        LDX #$00
        DEC aFB
        BNE bCA18
        LDA #$00
        STA aCA3B
        JMP jCA9D

aCA3B   .BYTE $00
;-------------------------------
; jCA3C
;-------------------------------
jCA3C   
        LDA #$01
        STA aFA
        LDA aFB
        CMP #$01
        BNE bCA51
        LDA #<pC9AA
        STA aFC
        LDA #>pC9AA
        STA aFD
        JMP jCA88

bCA51   LDA #<pC995
        STA aFC
        LDA #>pC995
        STA aFD
;-------------------------------
; jCA59
;-------------------------------
jCA59   
        LDY #$00
bCA5B   LDA (pFC),Y
        STA aF9
        TYA 
        PHA 
        CLC 
        ADC #$15
        TAY 
        LDA aF9
        STA (pFC),Y
        PLA 
        TAY 
        INY 
        CPY #$15
        BNE bCA5B
        INC aFA
        LDA aFA
        CMP aFB
        BEQ jCA88
        LDA aFC
        SEC 
        SBC #$15
        STA aFC
        LDA aFD
        SBC #$00
        STA aFD
        JMP jCA59

;-------------------------------
; jCA88
;-------------------------------
jCA88   
        LDA #$01
        STA aCA3B
        LDY #$14
bCA8F   LDA fC803,Y
        STA (pFC),Y
        DEY 
        BPL bCA8F
        LDA aFC
        PHA 
        LDA aFD
        PHA 
;-------------------------------
; jCA9D
;-------------------------------
jCA9D   
        LDX #$00
bCA9F   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0247,X
        LDA #$01
        STA fD800,X
        STA fD900,X
        STA fDA00,X
        STA fDA47,X
        DEX 
        BNE bCA9F
        LDX #$27
bCAC0   LDA fCDF2,X
        AND #$3F
        STA SCREEN_RAM + $0028,X
        LDA fCE6A,X
        AND #$3F
        STA SCREEN_RAM + $0258,X
        DEX 
        BPL bCAC0
        LDX #$06
bCAD5   LDA fC803,X
        STA SCREEN_RAM + $0279,X
        DEX 
        BPL bCAD5
        LDA #<pC81B
        STA aFE
        LDA #>pC81B
        STA aFF
        LDY #$00
bCAE8   LDA fCB30,Y
        STA aFC
        LDA fCB44,Y
        STA aFD
        TYA 
        PHA 
        LDY #$00
bCAF6   LDA (pFE),Y
        AND #$3F
        STA (pFC),Y
        INY 
        CPY #$07
        BNE bCAF6
        LDA aFC
        CLC 
        ADC #$03
        STA aFC
        LDA aFD
        ADC #$00
        STA aFD
bCB0E   LDA (pFE),Y
        AND #$3F
        STA (pFC),Y
        INY 
        CPY #$0B
        BNE bCB0E
        PLA 
        TAY 
        LDA aFE
        CLC 
        ADC #$15
        STA aFE
        LDA aFF
        ADC #$00
        STA aFF
        INY 
        CPY #$14
        BNE bCAE8
        JMP jCB58

fCB30   .BYTE $A1,$C9,$F1,$19,$41,$69,$91,$B9
        .BYTE $E1,$09,$B5,$DD,$05,$2D,$55,$7D
        .BYTE $A5,$CD,$F5,$1D
fCB44   .BYTE $04,$04,$04,$05,$05,$05,$05,$05
        .BYTE $05,$06,$04,$04,$05,$05,$05,$05
        .BYTE $05,$05,$05,$06
;-------------------------------
; jCB58
;-------------------------------
jCB58   
        LDA aCA3B
        BNE bCB60
        JMP jCC04

bCB60   PLA 
        STA aFD
        PLA 
        STA aFC
        LDX #$27
bCB68   LDA fCE1A,X
        AND #$3F
        STA SCREEN_RAM + $02D0,X
        DEX 
        BPL bCB68
        LDA #$14
        SEC 
        SBC aFB
        TAX 
        LDA fCB30,X
        STA aFE
        LDA fCB44,X
        STA aFF
        LDY #$0A
        .BYTE $20
fCB86   .BYTE $94,$CB,$C8,$C0,$0E,$D0,$F8,$4C
        .BYTE $04,$CC,$59,$41,$4B,$20
;-------------------------------
; jCB94
;-------------------------------
jCB94   
        LDA fCB86,Y
        AND #$3F
        STA (pFE),Y
        STA aF8
        TYA 
        PHA 
        SEC 
        SBC #$03
        TAY 
        LDA aF8
        STA (pFC),Y
        PLA 
        TAY 
        LDA $DC00    ;CIA1: Data Port Register A
        STA aFA
        AND #$04
        BNE bCBC4
        LDA fCB86,Y
        SEC 
        SBC #$01
        CMP #$FF
        BNE bCBBC
bCBBC   STA fCB86,Y
        LDA #$3F
        JMP jCBD9

bCBC4   LDA aFA
        AND #$08
        BNE bCBE9
        LDA fCB86,Y
        CLC 
        ADC #$01
        CMP #$40
        BNE bCBD6
        LDA #$00
bCBD6   STA fCB86,Y
;-------------------------------
; jCBD9
;-------------------------------
jCBD9   
        LDA #$50
        STA aF9
        LDX #$00
bCBDF   DEX 
        BNE bCBDF
        DEC aF9
        BNE bCBDF
        JMP jCB94

bCBE9   LDA aFA
        AND #$10
        BNE jCB94
bCBEF   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ bCBEF
        LDA #$C0
        STA aF9
        LDX #$00
bCBFC   DEX 
        BNE bCBFC
        DEC aF9
        BNE bCBFC
        RTS 

;-------------------------------
; jCC04
;-------------------------------
jCC04   
        LDA #$01
        STA aCC88
        LDA #$00
        STA aCA3B
        LDX #$27
bCC10   LDA fCE42,X
        AND #$3F
        STA SCREEN_RAM + $02D0,X
        DEX 
        BPL bCC10
;-------------------------------
; jCC1B
;-------------------------------
jCC1B   
        LDX aCC87
        LDA fCB30,X
        STA aFE
        LDA fCB44,X
        STA aFF
        LDY #$10
        LDA #$25
        STA (pFE),Y
bCC2E   JSR sCE95
        AND #$13
        CMP #$13
        BNE bCC43
        LDA lastKeyPressed
        CMP #$3C
        BNE bCC2E
        JSR sCC96
        JMP jC9C9

bCC43   STA aFA
        AND #$01
        BNE bCC67
        DEC aCC87
        BPL bCC53
        LDA #$13
        STA aCC87
bCC53   LDA #$50
        STA aF9
        LDX #$00
bCC59   DEX 
        BNE bCC59
        DEC aF9
        BNE bCC59
        LDA #$20
        STA (pFE),Y
bCC64   JMP jCC1B

bCC67   LDA aFA
        AND #$02
        BNE bCC7E
        INC aCC87
        LDA aCC87
        CMP #$14
        BNE bCC53
        LDA #$00
        STA aCC87
        BEQ bCC53
bCC7E   LDA aFA
        AND #$10
        BNE bCC64
        JMP jCC89

aCC87   .BYTE $00
aCC88   .BYTE $01
;-------------------------------
; jCC89
;-------------------------------
jCC89   
        LDX #$F8
        TXS 
bCC8C   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ bCC8C
        JMP j4000

;-------------------------------
; sCC96
;-------------------------------
sCC96   
        LDX aCC87
        LDA #<pC81B
        STA aFC
        LDA #>pC81B
        STA aFD
        CPX #$00
        BEQ bCCB5
bCCA5   LDA aFC
        CLC 
        ADC #$15
        STA aFC
        LDA aFD
        ADC #$00
        STA aFD
        DEX 
        BNE bCCA5
bCCB5   LDY #$0B
bCCB7   LDA (pFC),Y
        STA aF8
        TYA 
        PHA 
        SEC 
        SBC #$0B
        TAY 
        LDA aF8
        STA (pF0),Y
        PLA 
        TAY 
        INY 
        CPY #$15
        BNE bCCB7
        LDA aFC
        PHA 
        LDA aFD
        PHA 
        DEC aCD4B
        JSR sC818
        PLA 
        STA aFD
        PLA 
        STA aFC
        LDX #$27
bCCE0   LDA fCCED,X
        AND #$3F
        STA SCREEN_RAM + $02F8,X
        DEX 
        BPL bCCE0
        BMI bCD15
fCCED   .BYTE $47,$41,$4D,$45,$20,$43,$4F,$4D
        .BYTE $50,$4C,$45,$54,$49,$4F,$4E,$20
        .BYTE $43,$48,$41,$52,$54,$20,$46,$4F
        .BYTE $52,$20,$5A,$41,$52,$44,$2C,$20
        .BYTE $54,$48,$45,$20,$48,$45,$52,$4F
bCD15   LDY #$07
        LDX #$00
bCD19   LDA (pFC),Y
        AND #$3F
        STA SCREEN_RAM + $0312,X
        INY 
        INX 
        CPX #$04
        BNE bCD19
        LDY #$06
bCD28   LDA (pFC),Y
        STA SCREEN_RAM + $00E7,Y
        LDA #$04
        STA fD8E7,Y
        DEY 
        BPL bCD28
bCD35   LDA lastKeyPressed
        CMP #$3C
        BEQ bCD35
bCD3B   LDA lastKeyPressed
        CMP #$3C
        BNE bCD3B
bCD41   LDA lastKeyPressed
        CMP #$3C
        BEQ bCD41
        INC aCD4B
        RTS 

pCD4C   =*+$01
aCD4B   ORA (pAD,X)
        ORA f29D0,Y
        ORA (pD0,X)
        ASL a68
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$F0
        STA $D012    ;Raster Position
        LDA aCD4B
        BNE bCD6E
        JMP jEA31

bCD6E   LDX #$00
        LDY aCDD0
bCD73   LDA fCDD2,Y
        STA fD8A0,X
        STA fD8F0,X
        STA fD940,X
        STA fD990,X
        STA fD9E0,X
        INX 
        INY 
        CPY #$28
        BNE bCD8D
        LDY #$00
bCD8D   CPX #$28
        BNE bCD73
        LDY aCDD1
        LDX #$00
bCD96   LDA fCDE2,Y
        STA fD8C8,X
        STA fD918,X
        STA fD968,X
        STA fD9B8,X
        STA fDA08,X
        INX 
        INY 
        CPY #$28
        BNE bCDB0
        LDY #$00
bCDB0   CPX #$28
        BNE bCD96
        INC aCDD0
        DEC aCDD1
        BPL bCDC1
        LDA #$27
        STA aCDD1
bCDC1   LDA aCDD0
        CMP #$28
        BNE bCDCD
        LDA #$00
        STA aCDD0
bCDCD   JMP jEA31

aCDD0   .BYTE $1C
aCDD1   .BYTE $0C
fCDD2   .BYTE $0B,$0B,$0B,$0B,$0C,$0C,$0C,$0C
        .BYTE $0F,$0F,$0F,$0F,$01,$01,$01,$01
fCDE2   .BYTE $02,$02,$08,$08,$08,$07,$07,$07
        .BYTE $05,$05,$05,$0E,$0E,$0E,$07,$07
fCDF2   .BYTE $59,$41,$4B,$27,$53,$20,$47,$52
        .BYTE $45,$41,$54,$20,$47,$49,$4C,$42
        .BYTE $49,$45,$53,$20,$4F,$46,$20,$4F
        .BYTE $55,$52,$20,$54,$49,$4D,$45,$2E
        .BYTE $2E,$2E,$2E,$2E,$20,$25,$20,$25
fCE1A   .BYTE $4C,$45,$46,$54,$20,$41,$4E,$44
        .BYTE $20,$52,$49,$47,$48,$54,$20,$54
        .BYTE $4F,$20,$53,$45,$4C,$45,$43,$54
        .BYTE $2C,$20,$46,$49,$52,$45,$20,$54
        .BYTE $4F,$20,$45,$4E,$54,$45,$52,$2E
fCE42   .BYTE $55,$50,$20,$41,$4E,$44,$20,$44
        .BYTE $4F,$57,$4E,$2C,$20,$53,$50,$41
        .BYTE $43,$45,$20,$46,$4F,$52,$20,$52
        .BYTE $45,$43,$4F,$52,$44,$2C,$20,$46
        .BYTE $49,$52,$45,$20,$51,$55,$49,$54
fCE6A   .BYTE $54,$48,$45,$20,$53,$43,$4F,$52
        .BYTE $45,$20,$46,$4F,$52,$20,$54,$48
        .BYTE $45,$20,$4C,$41,$53,$54,$20,$42
        .BYTE $4C,$41,$53,$54,$20,$57,$41,$53
        .BYTE $20,$30,$30,$30,$30,$30,$30,$30

aCE92   .BYTE $00
aCE93   .BYTE $00
aCE94   .BYTE $00
;-------------------------------
; sCE95
;-------------------------------
sCE95   
        DEC aCE92
        BEQ bCEAC
bCE9A   LDA $DC00    ;CIA1: Data Port Register A
        AND #$0F
        CMP #$0F
        BEQ bCEA8
        LDA #$04
        STA aCE94
bCEA8   LDA $DC00    ;CIA1: Data Port Register A
        RTS 

bCEAC   DEC aCE93
        BNE bCE9A
        DEC aCE94
        BNE bCE9A
        JMP jCC89

;-------------------------------
; sCEB9
;-------------------------------
sCEB9   
        STA $D020    ;Border Color
        LDA #$80
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA #$04
        STA aCE94
        RTS 

.include "paddingfinal.asm"
