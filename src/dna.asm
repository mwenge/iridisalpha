; This is the reverse-engineered source code for the game 'Iridis Alpha'
; written by Jeff Minter in 1986.
;
; The code in this file was created by disassembling a binary of the game released into
; the public domain by Jeff Minter in 2019.
;
; The original code from which this source is derived is the copyright of Jeff Minter.
;
; The original home of this file is at: https://github.com/mwenge/iridisalpha
;
; To the extent to which any copyright may apply to the act of disassembling and reconstructing
; the code from its binary, the author disclaims copyright to this source code.  In place of
; a legal notice, here is a blessing:
;
;    May you do good and not evil.
;    May you find forgiveness for yourself and forgive others.
;    May you share freely, never taking more than you give.
;
; (Note: I ripped this part from the SQLite licence! :) )
;-------------------------------
; LaunchDNA
;-------------------------------
LaunchDNA   
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$00
        STA a1126
        JSR DNA_CopyInSpriteData
        JMP DNA_ClearScreenAndInit

;-------------------------------
; DNA_CopyInSpriteData
;-------------------------------
DNA_CopyInSpriteData   
        SEI 
        LDA #$34
        STA RAM_ACCESS_MODE
        LDX #$00
b0D47   LDA $E400,X
        PHA 
        LDA f3040,X
        STA $E400,X
        PLA 
        STA f3040,X
        DEX 
        BNE b0D47
        LDA #$36
        STA RAM_ACCESS_MODE
        RTS 

;-------------------------------
; DNA_ClearScreenAndInit
;-------------------------------
DNA_ClearScreenAndInit   
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
        JSR DNA_ClearScreenMain
        JMP DNA_Initialize

;-------------------------------
; DNA_ClearScreenMain
;-------------------------------
DNA_ClearScreenMain   
        LDX #$00
b0D9C   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0300,X
        LDA #$0E
        STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA $DB00,X
        DEX 
        BNE b0D9C
        RTS 

;-------------------------------
; DNA_Initialize
;-------------------------------
DNA_Initialize   
        JSR DNA_SetInterruptHandler
        JSR DNA_DrawTitleScreen
        JSR DNA_DrawStuff
        CLI 
b0DC6   LDA a1126
        BEQ b0DC6
        JSR DNA_CopyInSpriteData
        RTS 

;-------------------------------
; DNA_SetInterruptHandler
;-------------------------------
DNA_SetInterruptHandler   
        SEI 
        LDA #<DNA_InterruptHandler
        STA $0314    ;IRQ
        LDA #>DNA_InterruptHandler
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
; DNA_InterruptHandler
;-------------------------------
DNA_InterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b0E04
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

b0E04   JMP DNA_MainAnimationRoutine

a0E07   .BYTE $00

;-------------------------------
; DNA_MainAnimationRoutine
;-------------------------------
DNA_MainAnimationRoutine   
        LDX a0E07
        LDY a0F6D
        TYA 
        STA backingDataLoPtr
        CLC 
        ASL 
        TAY 
        LDA dnaAnimationData,X
        STA $CFFE,Y
        LDA f0F03,X
        STA $CFFF,Y
        STA $D005,Y  ;Sprite 2 Y Pos
        STA $D00F    ;Sprite 7 Y Pos
        STA $D00D    ;Sprite 6 Y Pos
        INC f1127,X
        LDA f1127,X
        STA $D00C    ;Sprite 6 X Pos
        LDA backingDataHiPtr
        AND #$01
        BEQ b0E3B
        INC f113F,X
b0E3B   LDA f113F,X
        STA $D00E    ;Sprite 7 X Pos
        TXA 
        PHA 
        CLC 
        ADC dnaCurrentPhase
        CMP #$27
        BMI b0E4E
        SEC 
        SBC #$27
b0E4E   TAX 
        LDA dnaAnimationData,X
        STA $D004,Y  ;Sprite 2 X Pos
        PLA 
        TAX 
        LDY a0F6D
        STX backingDataLoPtr
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
        LDX backingDataLoPtr
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
        JSR DNA_UpdateAnimationData
        JSR DNA_CheckKeyBoardInput
        DEC backingDataHiPtr
        JSR DNA_UpdateSpritePointers
        LDA #$01
        STA a0F6D
        LDA #$2E
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JMP $EA31

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
dnaAnimationData   .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
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
dnaCurrentPhase   .BYTE $05
;-------------------------------
; DNA_CopyDataRight
;-------------------------------
DNA_CopyDataRight   
        LDX #$27
b0F71   LDA f0EDA,X
        STA dnaAnimationData,X
        DEX 
        BNE b0F71
        RTS 

a0F7B   .BYTE $00
;-------------------------------
; DNA_UpdateAnimationData
;-------------------------------
DNA_UpdateAnimationData   
        DEC a0FC8
        BNE b0F8A
        LDA dnaCurrentSpeed
        STA a0FC8
        JSR DNA_CopyDataRight
p0F8C   =*+$02
b0F8A   JSR DNA_CalcAnimationShift
        DEC a0FC5
        BNE b0FC3
        LDA a0FC6
        STA a0FC5
        LDX a0F7B
        LDA f0F2A,X
        STA a42
        LDY dnaWave2Enabled
        BEQ b0FA9
        CLC 
        ROR 
        STA a42
b0FA9   LDA a11CE
        CLC 
        ADC a42
        STA dnaAnimationData
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
dnaCurrentSpeed   .BYTE $01
a0FC8   .BYTE $01
dnaWave1Frequency   .BYTE $11
dnaLastRecordedKey   .BYTE $00
f0FCB   .BYTE $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
        .BYTE $08,$07,$06,$05,$04,$03,$02,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
f0FEB   .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$02,$03,$04,$05,$06,$07,$08
        .BYTE $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
;-------------------------------
; DNA_CheckKeyBoardInput
;-------------------------------
DNA_CheckKeyBoardInput   
        LDA dnaLastRecordedKey
        CMP #$40
        BEQ b1018
        LDA lastKeyPressed
        STA dnaLastRecordedKey
        RTS 

b1018   LDA lastKeyPressed
        STA dnaLastRecordedKey
        CMP #$0C
        BNE b1027
        DEC dnaWave1Frequency
        JMP DNA_DrawStuff

b1027   CMP #$17
        BNE b1031
        INC dnaWave1Frequency
        JMP DNA_DrawStuff

b1031   CMP #$0A
        BNE b1043
        INC dnaCurrentSpeed

j1038   
        LDA dnaCurrentSpeed
        AND #$0F
        STA a0FC8
        JMP DNA_DrawBackground

b1043   CMP #$0D
        BNE b107A
        DEC dnaCurrentSpeed
        JMP j1038

;-------------------------------
; DNA_DrawStuff
;-------------------------------
DNA_DrawStuff   
        LDA dnaWave1Frequency
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
        JMP DNA_DrawBackground

b107A   CMP #$3E
        BNE b108C
        INC dnaCurrentPhase
        LDA dnaCurrentPhase
        AND #$0F
        STA dnaCurrentPhase
        JMP DNA_DrawBackground

b108C   CMP #$14
        BNE b1096
        DEC a1125
        JMP DNA_DrawStuff

b1096   CMP #$1F
        BNE b10A0
        INC a1125
        JMP DNA_DrawStuff

b10A0   CMP #$3C
        BNE b10B7
        LDA dnaTextDisplayed
        EOR #$01
        STA dnaTextDisplayed
        BEQ b10B4
        JSR DNA_DrawTitleScreen
        JMP DNA_DrawBackground

b10B4   JMP DNA_ClearScreenMain

b10B7   CMP #$04
        BNE b10C6
        LDA dnaWave2Enabled
        EOR #$01
        STA dnaWave2Enabled
        JMP DNA_DrawBackground

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
; DNA_UpdateSpritePointers
;-------------------------------
DNA_UpdateSpritePointers   
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
        STA Sprite7PtrStarField
        STA Sprite6Ptr
b1181   DEC a1158
        BNE b11C7
        LDA #$05
        STA a1158
        LDA a1157
        CLC 
        ADC #$C1
        STA Sprite0Ptr
        STA Sprite1Ptr
        STA Sprite2Ptr
        LDA a1159
        CLC 
        ADC #$C1
        STA Sprite3Ptr
        STA Sprite4Ptr
        STA Sprite5Ptr
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
dnaWave2Enabled   .BYTE $01
a11CE   .BYTE $00
;-------------------------------
; DNA_CalcAnimationShift
;-------------------------------
DNA_CalcAnimationShift   
        LDA dnaWave2Enabled
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
; DNA_DrawTitleScreen
;-------------------------------
DNA_DrawTitleScreen   
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
        JMP DNA_DrawCreditsText

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
; DNA_DrawBackground
;-------------------------------
DNA_DrawBackground   
        LDA dnaTextDisplayed
        BNE b12D6
        INC dnaTextDisplayed
        JSR DNA_DrawTitleScreen
b12D6   LDA #$20
        STA SCREEN_RAM + $0116
        STA SCREEN_RAM + $0206
        LDA dnaWave1Frequency
        AND #$10
        BEQ b12EA
        LDA #$31
        STA SCREEN_RAM + $0116
b12EA   LDA dnaWave1Frequency
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
        LDX dnaCurrentSpeed
        LDA f12BB,X
        AND #$3F
        STA SCREEN_RAM + $004F
        LDX dnaCurrentPhase
        LDA f12BB,X
        AND #$3F
        STA SCREEN_RAM + $02CF
        LDA dnaWave2Enabled
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

dnaTextDisplayed   .BYTE $01
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
; DNA_DrawCreditsText
;-------------------------------
DNA_DrawCreditsText   
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
