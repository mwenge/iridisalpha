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

;-------------------------------------------------------
; DisplayEnterBonusRoundScreen
;-------------------------------------------------------
DisplayEnterBonusRoundScreen   
        LDA #$00
        STA $D015    ;Sprite display Enable
        STA aAD23
        LDA #<EnterBonusPhaseInterruptHandler
        STA $0314    ;IRQ
        LDA #>EnterBonusPhaseInterruptHandler
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
bAB66   LDA txtStandByEnterBonusPhase,X
        AND #$3F
        STA SCREEN_RAM + $0167,X
        LDA #$01
        STA COLOR_RAM + $0167,X
        DEX 
        BNE bAB66
        CLI 

bAB77   LDA aAD23
        BEQ bAB77

        JMP EnterBonusPhase

txtStandByEnterBonusPhase   =*-$01
        .TEXT "STAND BY TO ENTER BONUS PHASE, HOTSHOT.."
fABA7   .BYTE $01,$01,$01,$01,$02,$02,$02,$02
        .BYTE $03,$03,$03,$03,$04,$04,$04,$04
        .BYTE $05,$05,$05,$05,$06,$06,$06,$06
        .BYTE $07,$07,$07,$07,$07,$07,$00
enterBPBackgroundColors   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00
aABE5   .BYTE $00
;-------------------------------------------------------
; EnterBonusPhaseInterruptHandler   
;-------------------------------------------------------
EnterBonusPhaseInterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
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
        LDA enterBPBackgroundColors,Y
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

bAC1E   JSR InitializeEnterBPData
        JSR PlayEnterBPSounds
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
;-------------------------------------------------------
; InitializeEnterBPData
;-------------------------------------------------------
InitializeEnterBPData   
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

aAC97   .BYTE $00

bAC98   LDX #$00
bAC9A   LDA fAC3F,X
        BEQ bACC4
        TAY 
        CPX #$1B
        BNE bACAE
        LDA aAD23
        BEQ bACAE
        LDA #$00
        STA enterBPBackgroundColors,Y
bACAE   INY 
        CPY #$1E
        BNE bACBA
        LDA #$00
        STA fAC3F,X
        BEQ bACC4
bACBA   LDA fAC5B,X
        STA enterBPBackgroundColors,Y
        TYA 
        STA fAC3F,X
bACC4   INX 
        CPX #$1C
        BNE bAC9A
        RTS 

aACCA   .BYTE $00
aACCB   .BYTE $40
;-------------------------------------------------------
; PlayEnterBPSounds
;-------------------------------------------------------
PlayEnterBPSounds   
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
;-------------------------------------------------------
; EnterBonusPhase
;-------------------------------------------------------
EnterBonusPhase   
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
bAD41   STA COLOR_RAM + $0167,X
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

        ; It's necessary to set this bit to allow access to the
        ; memory at $E000
        LDA #$34
        STA a01
        ; Copy in the charset for landscape. This is in charsetandspritedata.asm.
        LDX #$00
bAD5D   LDA $E000,X
        STA f2200,X
        LDA $E100,X
        STA f2300,X
        DEX 
        BNE bAD5D
        LDA #$36
        STA a01

        ; Copy in the sprite data.
        JSR SwapSpriteData
        CLI 

        JMP InitializeBonusPhase

aAD77   .BYTE $00
fAD78   .BYTE $00,$0B,$0C,$0F
;-------------------------------------------------------
; SwapSpriteData
;-------------------------------------------------------
SwapSpriteData   
        SEI 

        ; It's necessary to set this bit to allow access to the
        ; memory at $E000
        LDA #$34
        STA a01

        LDX #$00
bAD83   LDA $E200,X
        PHA 
        LDA a3000,X
        STA $E200,X
        PLA 
        STA a3000,X
        LDA $E300,X
        PHA 
        LDA f3100,X
        STA $E300,X
        PLA 
        STA f3100,X
        LDA $E400,X
        PHA 
        LDA f3200,X
        STA $E400,X
        PLA 
        STA f3200,X
        DEX 
        BNE bAD83

        LDA #$36
        STA a01
        CLI 
        RTS 

;-------------------------------------------------------
; InitializeBonusPhase
;-------------------------------------------------------
InitializeBonusPhase   
        NOP 

        LDA bonusPhaseCounter
        BNE bADC1
        LDA #$00
        STA aAED0

bADC1   INC bonusPhaseCounter

        LDA #$00
        STA $D020    ;Border Color
        STA incrementLives
        STA bpGilbyXPosMSB
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
        STA bpGilbyXPos
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
        STA bpJoystickInput
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
        JMP BonusPhaseSetUpScreen

;-------------------------------------------------------
; ClearScreen
;-------------------------------------------------------
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

;------------------------------------------------------------------------
; BonusPhaseSetUpScreen   
;------------------------------------------------------------------------
BonusPhaseSetUpScreen   
        JSR BP_Init_ScreenLinePointerArray
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
        STA Sprite0Ptr,X
        DEX 
        BNE bAE71

        LDA #$0F
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control

        LDA #$EE
        STA Sprite1Ptr
        STA Sprite2Ptr
        STA Sprite3Ptr

        LDA $D016    ;VIC Control Register 2
        AND #$EF
        ORA #$10
        STA $D016    ;VIC Control Register 2
        LDA #$07
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA #$06
        STA $D023    ;Background Color 2, Multi-Color Register 1
        JSR BonusPhaseSetUpScrollingMap
        JMP BonusRoundControlLoop

;-------------------------------------------------------
; jAEA9
;-------------------------------------------------------
jAEA9   
        LDX aBED3
        LDA #$F8
        STA fBCB6,X
        DEC aBED3
        RTS 

aAEB6   =*+$01
;-------------------------------------------------------
; GetNextValueInSequence
;-------------------------------------------------------
GetNextValueInSequence   
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
bpGilbyXPos   .BYTE $A0
bpGilbyXPosMSB   .BYTE $00
aAED3   .BYTE $00
;-------------------------------------------------------
; BonusPhaseFillTopLineAfterScrollDown
;-------------------------------------------------------
BonusPhaseFillTopLineAfterScrollDown   
        LDX aAEBD
        LDY bonusPhaseMapOffset,X
        LDA bonusPhaseMapPtrLo,Y
        STA planetPtrLo2
        LDA bonusPhaseMapPtrHi,Y
        STA planetPtrHi2
        LDY #$00
        LDX #$00
bAEE8   LDA (planetPtrLo2),Y
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

;-------------------------------------------------------
; BonusRoundScrollDown
;-------------------------------------------------------
BonusRoundScrollDown   
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

;-------------------------------------------------------
; BP_UpdateGilbyPosition
;-------------------------------------------------------
BP_UpdateGilbyPosition   
        LDA bpGilbyXPos
        STA $D000    ;Sprite 0 X Pos
        LDA bpGilbyXPosMSB
        BEQ bAF99

        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA #$01
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        RTS 

bAF99   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        RTS 

;-------------------------------------------------------
; ChangeColorOfCharacters
;-------------------------------------------------------
ChangeColorOfCharacters   
        LDX #$00
bAFA4   STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA COLOR_RAM + $0300,X
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
BonusPhaseMapData   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
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
;-------------------------------------------------------
; BonusPhaseFillBottomLineAfterScrollUp
;-------------------------------------------------------
BonusPhaseFillBottomLineAfterScrollUp   
        LDX aAEBE
        LDY bonusPhaseMapOffset,X
        LDA bonusPhaseMapPtrLo,Y
        STA planetPtrLo2
        LDA bonusPhaseMapPtrHi,Y
        STA planetPtrHi2
        LDY #$00
        LDX #$00
bB2D5   LDA (planetPtrLo2),Y
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

;-------------------------------------------------------
; BonusRoundScrollUp
;-------------------------------------------------------
BonusRoundScrollUp   
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

;-------------------------------------------------------
; BonusRoundControlLoop
;-------------------------------------------------------
BonusRoundControlLoop   
        LDA aAED0
        AND #$07
        TAX 
        JSR BonusPhaseChangeColorScheme
        LDA aAED0
        AND #$0F
        TAX 
        LDA fB499,X
        STA aB4A9
        LDA #$01
        STA aB487
        LDX #$00
        LDA #$10
bB3A1   STA bonusPhaseMapOffset,X
        DEX 
        BNE bB3A1
        LDA #$19
        STA tempHiPtr
bB3AB   JSR GetNextValueInSequence
        AND #$07
        PHA 
        LDA aAED0
        AND #$FC
        BEQ bB3BF
        PLA 
        JSR GetNextValueInSequence
        AND #$1F
        PHA 
bB3BF   PLA 
        TAY 
        LDA #<pBD40
        STA tempHiPtr1
        LDA #>pBD40
        STA tempLoPtr
        TXA 
        PHA 
        CPY #$00
        BEQ bB3DF
bB3CF   LDA tempHiPtr1
        CLC 
        ADC #$0A
        STA tempHiPtr1
        LDA tempLoPtr
        ADC #$00
        STA tempLoPtr
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
bB3F0   LDA tempHiPtr1
        CLC 
        ADC #$50
        STA tempHiPtr1
        LDA tempLoPtr
        ADC #$00
        STA tempLoPtr
        DEX 
        BNE bB3F0
bB400   PLA 
        TAX 
bB402   LDA (tempHiPtr1),Y
        STA bonusPhaseMapOffset,X
        INY 
        INX 
        CPY #$0A
        BNE bB402
        DEC tempHiPtr
        BNE bB3AB
        LDX #$09
        LDA #$00
bB415   STA bonusPhaseMapOffset,X
        DEX 
        BPL bB415
        JSR BonusPhaseSetUpInterruptHandler
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
        JMP DisplayBonusBountyScreen

;-------------------------------------------------------
; BonusPhaseSetUpInterruptHandler
;-------------------------------------------------------
BonusPhaseSetUpInterruptHandler   
        SEI 
        LDA #<BonusPhaseInterruptHandler
        STA $0314    ;IRQ
        LDA #>BonusPhaseInterruptHandler
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

;-------------------------------------------------------
; BonusPhaseInterruptHandler
;-------------------------------------------------------
BonusPhaseInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
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
        STA $F0FF
        LDY #$14
bB4C1   DEY 
        BNE bB4C1
        INX 
        CPX #$08
        BNE bB4B9
        LDA #$E0
        STA aBFF7
        JSR BonusPhaseSetupIBallSprites
        JSR BonusPhase_HandleScroll
        JSR BP_CheckInput
        JSR BP_MaybeChangeColorScheme
        JSR BP_UpdateGilbyPosition
        JSR BP_RecalculateGilbyPosition
        JSR BP_sBA07
        JSR BP_sBA8A
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
        JSR BP_UpdateEnemySprites

jB515   
        JSR sBCF9
        JSR sC781
        JSR sBD26
        JSR sC70E
        JMP $EA31

;-------------------------------------------------------
; BonusPhase_HandleScroll
;-------------------------------------------------------
BonusPhase_HandleScroll   
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

bB542   JSR BonusRoundScrollDown
        JSR BonusPhaseFillTopLineAfterScrollDown

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
        JSR BonusRoundScrollUp
        JSR BonusPhaseFillBottomLineAfterScrollUp
        JMP jB548

aB570   .BYTE $04
bpJoystickInput   .BYTE $00
;-------------------------------------------------------
; BP_CheckInput
;-------------------------------------------------------
BP_CheckInput   
        LDA aBC90
        BEQ bB578
        RTS 

bB578   DEC aB570
        BEQ bB57E
        RTS 

bB57E   LDA $DC00    ;CIA1: Data Port Register A
        STA bpJoystickInput
        LDY #$02
        STY aB570
        JSR sBB40

        LDA bpJoystickInput
        AND #$0F
        CMP #$0F
        BEQ bB5AF

        ; No input?
        LDA #$10
        STA aBA06
        LDX #$08
        LDA bpJoystickInput
        AND #$0F
bB5A1   CMP fB671,X
        BEQ bB5A9
        DEX 
        BNE bB5A1
bB5A9   LDA fB679,X
        STA aB682

bB5AF   LDA bpJoystickInput
        AND #$01
        BNE bB5CF

        ; Joystick pushed up.
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

bB5CF   LDA bpJoystickInput
        AND #$02
        BNE jB5F0

        ; Joystick pushed down.
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

jB5F0   
        LDA bpJoystickInput
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

bB610   LDA bpJoystickInput
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
;-------------------------------------------------------
; jB631
;-------------------------------------------------------
jB631   
        LDA bpJoystickInput
        LDA #$10
        BNE bB641
        LDA #$00
        STA aB487
        STA aAED3
        RTS 

bB641   RTS 

;-------------------------------------------------------
; BonusPhaseSetUpScrollingMap
;-------------------------------------------------------
BonusPhaseSetUpScrollingMap   
        LDA #<BonusPhaseMapData
        STA planetPtrLo2
        LDA #>BonusPhaseMapData
        STA planetPtrHi2

        LDX #$00
bB64C   LDA planetPtrLo2
        STA bonusPhaseMapPtrLo,X
        LDA planetPtrHi2
        STA bonusPhaseMapPtrHi,X
        LDA planetPtrLo2
        CLC 
        ADC #$14
        STA planetPtrLo2
        LDA planetPtrHi2
        ADC #$00
        STA planetPtrHi2
        INX 
        CPX #$C8
        BNE bB64C

        LDX #$00
        TXA 
bB66B   STA bonusPhaseMapOffset,X
        DEX 
        BNE bB66B

fB671   RTS 

                    .BYTE $0E,$06,$07,$05,$0D,$09,$0B
fB679               .BYTE $0A,$C0,$C1,$C2,$C3,$C4,$C5,$C6
                    .BYTE $C7
aB682               .BYTE $C0
bonusPhaseMapPtrLo  .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
bonusPhaseMapPtrHi  .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
bonusPhaseMapOffset .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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

;-------------------------------------------------------
; BP_MaybeChangeColorScheme
;-------------------------------------------------------
BP_MaybeChangeColorScheme   
        LDA lastKeyPressed
        CMP #$40
        BNE bB91A
        RTS 

        ; F1/F3/F4/F7 selects a new color scheme!
bB91A   LDX #$04
bB91C   CMP fB93F,X
        BEQ BonusPhaseChangeColorScheme
        DEX 
        BNE bB91C
        RTS 

;-------------------------------------------------------
; BonusPhaseChangeColorScheme
;-------------------------------------------------------
BonusPhaseChangeColorScheme   
        LDA fB944,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        STA aB95C
        LDA fB94C,X
        STA $D023    ;Background Color 2, Multi-Color Register 1
        STA aB95D
        LDA fB954,X
        ORA #$08
        JSR ChangeColorOfCharacters
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
;-------------------------------------------------------
; BP_RecalculateGilbyPosition
;-------------------------------------------------------
BP_RecalculateGilbyPosition   
        LDA bpGilbyXPos
        LDY #$00
        STY a3E
        LDY aAED3
        BPL bB981

        LDY #$FF
        STY a3E
bB981   CLC 
        ADC aAED3
        STA bpGilbyXPos

        LDA bpGilbyXPosMSB
        ADC a3E
        STA bpGilbyXPosMSB

        ROR 
        LDA bpGilbyXPos
        ROR 
        AND #$F0
        BNE bB9A9

        LDA #<p20
        STA bpGilbyXPos
        LDA #>p20
        STA bpGilbyXPosMSB

bB9A3   LDA #$00
        STA aAED3
bB9A8   RTS 

bB9A9   CMP #$A0
        BNE bB9A8
        LDA #$40
        STA bpGilbyXPos
        LDA #$01
        STA bpGilbyXPosMSB
        BNE bB9A3

;-------------------------------------------------------
; BP_Init_ScreenLinePointerArray
;-------------------------------------------------------
BP_Init_ScreenLinePointerArray
        LDA #>SCREEN_RAM
        STA planetPtrHi2
        LDA #<SCREEN_RAM
        STA planetPtrLo2
        TAX 
bB9C2   LDA planetPtrLo2
        STA screenLinePtrLo,X
        LDA planetPtrHi2
        STA screenLinePtrHi,X
        LDA planetPtrLo2
        CLC 
        ADC #$28
        STA planetPtrLo2
        LDA planetPtrHi2
        ADC #$00
        STA planetPtrHi2
        INX 
        CPX #$1E
        BNE bB9C2
        RTS 

bpCurrentSpritePositionLoPtr   .BYTE $00
bpCurrentSpritePositionHiPtr   .BYTE $00
;-------------------------------------------------------
; BP_sB9E1
;-------------------------------------------------------
BP_sB9E1   
        LDA bpCurrentSpritePositionLoPtr
        SEC 
        SBC #$06
        CLC 
        ROR 
        CLC 
        ROR 
        TAY 

        LDA bpCurrentSpritePositionHiPtr
        SEC 
        SBC #$26
        CLC 
        ROR 
        CLC 
        ROR 
        CLC 
        ROR 
        TAX 

        LDA screenLinePtrLo,X
        STA a3A
        LDA screenLinePtrHi,X
        STA a3B
        LDA (p3A),Y
bBA05   RTS 

aBA06   .BYTE $04
;-------------------------------------------------------
; BP_sBA07
;-------------------------------------------------------
BP_sBA07   
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
;-------------------------------------------------------
; BP_sBA8A
;-------------------------------------------------------
BP_sBA8A   
        DEC aBA89
        BNE bBA48

        LDA #$03
        STA aBA89
        LDA aBC90
        BNE bBA48

        LDA #$70
        STA bpCurrentSpritePositionHiPtr
        LDA bpGilbyXPosMSB
        ROR 
        LDA bpGilbyXPos
        ROR 
        STA bpCurrentSpritePositionLoPtr
        JSR BP_sB9E1
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
;-------------------------------------------------------
; sBB40
;-------------------------------------------------------
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
        LDA bpGilbyXPos
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
        LDA bpGilbyXPosMSB
        STA fBB23,X
        LDA #$70
        STA fBB1D,X
        LDA #$10
        STA fBB20,X
        LDA bpJoystickInput
        AND #$01
        BNE bBBA1
        LDA #$FD
        STA fBB29,X
        BNE bBBAD
bBBA1   LDA bpJoystickInput
        AND #$02
        BNE bBBAD
        LDA #$03
        STA fBB29,X
bBBAD   LDA bpJoystickInput
        AND #$04
        BNE bBBBB
        LDA #$FD
        STA fBB26,X
        BNE bBBC7
bBBBB   LDA bpJoystickInput
        AND #$08
        BNE bBBC7
        LDA #$03
        STA fBB26,X
bBBC7   RTS 

;-------------------------------------------------------
; BP_UpdateEnemySprites
;-------------------------------------------------------
BP_UpdateEnemySprites   
        LDX #$03
bBBCA   LDA fBB1D,X
        BNE bBBD7
        LDA #$F0
        STA Sprite0Ptr,X
        JMP jBBDF

bBBD7   JSR BP_UpdateEnemySpritePosition
        LDA #$FC
        STA Sprite0Ptr,X

jBBDF   
        DEX 
        BNE bBBCA
        RTS 

;-------------------------------------------------------
; BP_UpdateEnemySpritePosition
;-------------------------------------------------------
BP_UpdateEnemySpritePosition   
        LDA fBB23,X
        ROR 
        LDA aBB1A,X
        ROR 
        STA bpCurrentSpritePositionLoPtr
        LDA fBB1D,X
        STA bpCurrentSpritePositionHiPtr
        LDA fBB26,X
        STA aBC8E
        LDA fBB29,X
        STA aBC8F
        TXA 
        PHA 
        JSR BP_sB9E1
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
;-------------------------------------------------------
; BonusPhaseSetupIBallSprites
;-------------------------------------------------------
BonusPhaseSetupIBallSprites   
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
        STA Sprite0Ptr,X
        LDA fBCBE,X
        STA $D027,X  ;Sprite 0 Color
        INX 
        CPX #$08
        BNE bBCD0
        RTS 

fBCF1   .BYTE $50,$68,$80,$98,$B0,$C8,$E0,$F8
;-------------------------------------------------------
; sBCF9
;-------------------------------------------------------
sBCF9   
        LDA #$70
        STA $D001    ;Sprite 0 Y Pos
        LDA bpGilbyXPos
        STA $D000    ;Sprite 0 X Pos
        LDA aB682
        STA Sprite0Ptr
        LDA #$08
        STA $D027    ;Sprite 0 Color
        LDA bpGilbyXPosMSB
        BNE bBD1D
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        RTS 

bBD1D   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA #$01
        STA $D010    ;Sprites 0-7 MSB of X coordinate
bBD25   RTS 

;-------------------------------------------------------
; sBD26
;-------------------------------------------------------
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
;-------------------------------------------------------
; jBE80
;-------------------------------------------------------
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
;-------------------------------------------------------
; sBF0C
;-------------------------------------------------------
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

;-------------------------------------------------------
; jBF27
;-------------------------------------------------------
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
        STA tempHiPtr1
        LDA fBFB1,X
        STA tempLoPtr
        LDA fC019,Y
        AND #$3F
        STA (tempHiPtr1),Y
        LDA tempLoPtr
        CLC 
        ADC #$D4
        STA tempLoPtr
        LDA fAEC1,X
        STA (tempHiPtr1),Y
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
        STX tempHiPtr
        LDY #$00
bBF86   LDX #$30
bBF88   LDA MainControlLoop,X
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        DEY 
        BNE bBF88
        DEX 
        BNE bBF88
        DEC tempHiPtr
        BNE bBF86
        JMP SwapSpriteData

fBFA1   .BYTE $30,$4C,$68,$84,$A0,$BC,$D8,$00
aBFA9   .BYTE $00
fBFAA   .BYTE $A0,$C8,$F0,$18,$40,$68,$90
fBFB1   .BYTE $04,$04,$04,$05,$05,$05,$05

pBFB8
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE bBFC2
        JMP jBFF1

bBFC2   LDY aBFA9
        LDA fBFA1,Y
        CLC 
        ADC #$08
        STA aBFF7
        JSR BonusPhaseSetupIBallSprites
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
;-------------------------------------------------------
; jBFF1
;-------------------------------------------------------
jBFF1   
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

aBFF7   .BYTE $00
aBFF8   .BYTE $05
;-------------------------------------------------------
; sBFF9
;-------------------------------------------------------
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
;-------------------------------------------------------
; DisplayBonusBountyScreen
;-------------------------------------------------------
DisplayBonusBountyScreen   
        SEI 
        LDA #<BonusBountyScreenInterruptHandler
        STA $0314    ;IRQ
        LDA #>BonusBountyScreenInterruptHandler
        STA $0315    ;IRQ
        LDA #$00
        STA aC136
        INC aAED0
        INC incrementLives
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
        STA Sprite6Ptr
        STA Sprite7PtrStarField
        JSR ClearScreen
        LDY #$27
bC07C   LDX #$06
bC07E   LDA fBFAA,X
        STA tempHiPtr1
        LDA fBFB1,X
        STA tempLoPtr
        LDA txtCongoatulations,Y
        AND #$3F
        STA (tempHiPtr1),Y
        LDA tempLoPtr
        CLC 
        ADC #$D4
        STA tempLoPtr
        LDA fB489,X
        STA (tempHiPtr1),Y
        DEX 
        BPL bC07E
        LDA #$20
        STA $D40B    ;Voice 2: Control Register
        LDA txtBonusBounty,Y
        AND #$3F
        STA SCREEN_RAM + $02D0,Y
        LDA #$01
        STA COLOR_RAM + $02D0,Y
        DEY 
        BPL bC07C
        LDX #$06
bC0B5   LDA currentBonusBountyPtr,X
        STA SCREEN_RAM + $02E6,X
        DEX 
        BPL bC0B5
        CLI 
        JSR BonusRoundDrawTimerBonus
        JSR BonusRoundDrawIBallBonus
        LDA #$10
        STA tempHiPtr
        LDA #$15
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
bC0CE   LDX #$60
bC0D0   DEX 
        STY $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA tempHiPtr
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        TXA 
        BNE bC0D0
        DEY 
        BNE bC0CE
        DEC tempHiPtr
        BNE bC0CE
        JMP SwapSpriteData

fC0E6   .BYTE $EF,$CF,$AF,$8F,$6F,$4F
aC0EC   .BYTE $C8
txtBonusBounty   .TEXT "CURRENT BONUS BOUNTY: 0000000 % % % % % "
;-------------------------------------------------------
; BonusBountyScreenAnimateBlinkingSprites
;-------------------------------------------------------
BonusBountyScreenAnimateBlinkingSprites   
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
        STA Sprite0Ptr,X
        DEX 
        BPL bC117
        RTS 

aC135   .BYTE $00
aC136   .BYTE $00
;-------------------------------------------------------
; BonusBountyScreenInterruptHandler
;-------------------------------------------------------
BonusBountyScreenInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE bC141
        JMP jBFF1

bC141   LDY aC136
        LDA fBFA1,Y
        CLC 
        ADC #$08
        STA aC135
        JSR BonusBountyScreenAnimateBlinkingSprites

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
;-------------------------------------------------------
; sC17B
;-------------------------------------------------------
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
        JSR GetNextValueInSequence
        AND #$03
        STA aC178
        JSR GetNextValueInSequence
        AND #$3F
        STA aC179
        RTS 

txtCongoatulations   .TEXT "CONGOATULATIONS... STAND BY TO COP BONUS"
aC1DC   .BYTE $FF
aC1DD   .BYTE $20
;-------------------------------------------------------
; sC1DE
;-------------------------------------------------------
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

;-------------------------------------------------------
; BonusRoundDrawTimerBonus
;-------------------------------------------------------
BonusRoundDrawTimerBonus   
        LDX #$0A
bC1F9   LDA txtTimeBonus,X
        AND #$3F
        STA SCREEN_RAM + $023E,X
        LDA #$07
        STA COLOR_RAM + $023E,X
        DEX 
        BPL bC1F9
bC209   JSR GetNextValueInSequence
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        LDA #$11
        STA $D412    ;Voice 3: Control Register
        LDY #$01
        LDX #$06
        JSR BP_IncrementBonusBountyScore
        LDX #$10
bC21D   DEY 
        BNE bC21D
        DEX 
        BNE bC21D
        DEC aC1DC
        BNE bC209
        RTS 

;-------------------------------------------------------
; BP_IncrementBonusBountyScore
;-------------------------------------------------------
BP_IncrementBonusBountyScore   
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
        BNE BP_IncrementBonusBountyScore
        RTS 

txtTimeBonus   .TEXT "TIMER BONUS"
aC24E   .TEXT $10
;-------------------------------------------------------
; BonusRoundDrawIBallBonus
;-------------------------------------------------------
BonusRoundDrawIBallBonus   
        LDX #$0A
bC251   LDA txtIBallBonus,X
        AND #$3F
        STA SCREEN_RAM + $023E,X
        LDA #$04
        STA COLOR_RAM + $023E,X
        DEX 
        BPL bC251
        LDA aC24E
        BEQ bC285
        LDA #$21
        STA $D412    ;Voice 3: Control Register
bC26B   JSR GetNextValueInSequence
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        LDX #$06
        LDY #$01
        JSR BP_IncrementBonusBountyScore
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
        STA currentBonusBountyPtr,X
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
;-------------------------------------------------------
; sC358
;-------------------------------------------------------
sC358   
        DEC aC357
        BEQ bC35E
        RTS 

bC35E   LDA aC356
        BEQ bC367
        INC aC357
        RTS 

bC367   INC aC356

        JSR GetNextValueInSequence
        STA aC353
        LDA #>backingDataLoPtr
        STA aC355
        LDA #<backingDataLoPtr
        STA aC354

        JSR sC380
        JMP jC397

;-------------------------------------------------------
; sC380
;-------------------------------------------------------
sC380   
        JSR GetNextValueInSequence
        AND #$07
        CLC 
        ADC #$03
        STA aC3BD
        JSR GetNextValueInSequence
        AND #$07
        CLC 
        ADC #$03
        STA aC3BE
        RTS 

;-------------------------------------------------------
; jC397
;-------------------------------------------------------
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
;-------------------------------------------------------
; sC3C0
;-------------------------------------------------------
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
        JSR GetNextValueInSequence
        AND #$03
        ADC #$02
        STA aC41F
        STA aC420
        JSR GetNextValueInSequence
        AND #$03
        ADC #$02
        STA aC421
        STA aC422
;-------------------------------------------------------
; sC411
;-------------------------------------------------------
sC411   
        JSR GetNextValueInSequence
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
        JSR GetNextValueInSequence
        AND #$07
        SBC #$04
        STA aC424
        JSR GetNextValueInSequence
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
;-------------------------------------------------------
; jC4B2
;-------------------------------------------------------
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
;-------------------------------------------------------
; sC4F0
;-------------------------------------------------------
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

;-------------------------------------------------------
; sC512
;-------------------------------------------------------
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
        STA Sprite4Ptr,X
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
;-------------------------------------------------------
; sC57D
;-------------------------------------------------------
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

;-------------------------------------------------------
; sC5A5
;-------------------------------------------------------
sC5A5   
        LDA aC355
        ROR 
        LDA aC353
        ROR 
        STA a77
        LDA bpGilbyXPosMSB
        ROR 
        LDA bpGilbyXPos
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
;-------------------------------------------------------
; jC5DC
;-------------------------------------------------------
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
;-------------------------------------------------------
; sC5FF
;-------------------------------------------------------
sC5FF   
        LDX #$02
bC601   LDA fBB1E,X
        BEQ bC609
        JSR sC60D
bC609   DEX 
        BPL bC601
bC60C   RTS 

;-------------------------------------------------------
; sC60D
;-------------------------------------------------------
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
;-------------------------------------------------------
; sC677
;-------------------------------------------------------
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

;-------------------------------------------------------
; sC68E
;-------------------------------------------------------
sC68E   
        LDA aC676
        BNE bC68D
        LDA aC355
        ROR 
        LDA aC353
        ROR 
        STA a77
        LDA bpGilbyXPosMSB
        ROR 
        LDA bpGilbyXPos
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
;-------------------------------------------------------
; sC70E
;-------------------------------------------------------
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

txtIBallBonus   .TEXT "IBALL BONUS"
        .BYTE $80,$80,$01,$10,$F0,$00,$11,$11
        .BYTE $01,$1D,$01,$00,$30,$30,$01,$40
        .BYTE $02,$00
aC780   .BYTE $05
;-------------------------------------------------------
; sC781
;-------------------------------------------------------
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
