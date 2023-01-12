; This is the reverse-engineered source code for the demo 'DNA'
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
;
; **** ZP ABSOLUTE ADRESSES ****
;
currentShipWaveDataLoPtr = $40
currentShipWaveDataHiPtr = $41
tempVarStorage = $42
lastKeyPressed = $C5
;
; **** FIELDS ****
;
SCREEN_RAM = $0400
fCFFE = $CFFE
fCFFF = $CFFF
COLOR_RAM = $D800
;
; **** ABSOLUTE ADRESSES ****
;
a0314 = $0314
a0315 = $0315
a044F = $044F
a0516 = $0516
a0517 = $0517
a05B2 = $05B2
a05B3 = $05B3
a0606 = $0606
a0607 = $0607
a06CF = $06CF
Sprite0Ptr = $07F8
Sprite1Ptr = $07F9
SPrite2Ptr = $07FA
Sprite3Ptr = $07FB
Sprite4Ptr = $07FC
Sprite5Ptr = $07FD
a07FE = $07FE
a07FF = $07FF
;
; **** EXTERNAL JUMPS ****
;
eEA31 = $EA31

*=$0800

        .BYTE $00,$0B,$08,$0A,$00,$9E,$32,$30
        .BYTE $36,$34,$00,$00,$00,$08,$02,$00

;----------------------------------------------------------------
; DNA_ClearScreenAndInit
;----------------------------------------------------------------
DNA_ClearScreenAndInit
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
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

;-------------------------------------------------------
; DNA_ClearScreenMain
;-------------------------------------------------------
DNA_ClearScreenMain
        LDX #$00
b0854   LDA #$20
        STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0300,X
        LDA #$0E
        STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA COLOR_RAM + $0300,X
        DEX
        BNE b0854
        RTS
;-------------------------------------------------------
; DNA_Initialize
;-------------------------------------------------------
DNA_Initialize
        JSR DNA_SetInterruptHandler
        JSR DNA_DrawTitleScreen
        JSR DNA_UpdateDisplayedSettings
j087D   JMP j087D

;-------------------------------------------------------
; DNA_SetInterruptHandler
;-------------------------------------------------------
DNA_SetInterruptHandler
        SEI
        LDA #<DNA_InterruptHandler
        STA a0314    ;IRQ
        LDA #>DNA_InterruptHandler
        STA a0315    ;IRQ
        LDA #$00
        STA DNA_UnusedVariable
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

DNA_UnusedVariable   .BYTE $00
;-------------------------------------------------------
; DNA_InterruptHandler
;-------------------------------------------------------
DNA_InterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE DNA_RunMainAnimationRoutine
ReturnFromDNAInterruptHandler   PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;-------------------------------------------------------
; DNA_RunMainAnimationRoutine
;-------------------------------------------------------
DNA_RunMainAnimationRoutine
        JMP DNA_MainAnimationRoutine

dnaCurrentSpritesXPosArrayIndex   .BYTE $00
;-------------------------------------------------------
; DNA_MainAnimationRoutine
;-------------------------------------------------------
DNA_MainAnimationRoutine
        LDX dnaCurrentSpritesXPosArrayIndex
        LDY currentSpriteIndex
        TYA
        STA currentShipWaveDataLoPtr
        CLC
        ASL
        TAY

        LDA dnaSpritesPreviousXPosArray,X
        STA fCFFE,Y
        LDA dnaSPritesXPositionsArray,X
        STA fCFFF,Y
        STA $D005,Y  ;Sprite 2 Y Pos
        STA $D00F    ;Sprite 7 Y Pos
        STA $D00D    ;Sprite 6 Y Pos

        INC dnaStarfieldSprite1Array,X
        LDA dnaStarfieldSprite1Array,X
        STA $D00C    ;Sprite 6 X Pos

        LDA currentShipWaveDataHiPtr
        AND #$01
        BEQ b08EC

        INC dnaStarfieldSPrite2Array,X
b08EC   LDA dnaStarfieldSPrite2Array,X
        STA $D00E    ;Sprite 7 X Pos

        TXA
        PHA
        CLC
        ADC dnaCurrentPhase
        CMP #$27
        BMI b08FF

        SEC
        SBC #$27
b08FF   TAX
        LDA dnaSpritesPreviousXPosArray,X
        STA $D004,Y  ;Sprite 2 X Pos
        PLA
        TAX
        LDY currentSpriteIndex
        STX currentShipWaveDataLoPtr

        LDX dnaSpriteColor2ArrayIndex
dnaColorScheme1LoByte   =*+$01
dnaColorScheme1HiByte   =*+$02
        LDA dnaSpriteColor2Array,X
        STA $D026,Y  ;Sprite Multi-Color Register 1
        INX
dnaColorScheme2LoByte   =*+$01
dnaColorScheme2HiByte   =*+$02
        LDA dnaSpriteColor2Array,X
        CMP #$FF
        BNE b0920

        LDX #$00
b0920   STX dnaSpriteColor2ArrayIndex

        LDX dnaCurrentSPriteColorARrayIndex
dnaColorScheme3LoByte   =*+$01
dnaColorScheme3HiByte   =*+$02
        LDA dnaSpriteColorArray,X
        STA $D029,Y  ;Sprite 2 Color

        ; Increment the color array index and reset
        ; it to 00 if we've reached the end of dnaSpriteColorArray (denoted
        ; by an $FF sentinel).
        INX
dnaColorScheme4LoByte   =*+$01
dnaColorScheme4HiByte   =*+$02
        LDA dnaSpriteColorArray,X
        CMP #$FF
        BNE b0936
        LDX #$00
b0936   STX dnaCurrentSPriteColorARrayIndex

        LDX currentShipWaveDataLoPtr
        INX
        INY
        CPY #$04
        BNE b0943

        ; Check if we should move back to the start of the raster positions
        ; array (end of the array denoted by a sentinel value of $FF).
        LDY #$01
b0943   STY currentSpriteIndex
        STX dnaCurrentSpritesXPosArrayIndex
        LDA dnaSPritesXPositionsArray,X
        CMP #$FF
        BNE b0978

        ; We've reached the end of the raster positions array (i.e. we've done
        ; a full paint of the screen) so do some book-keeping, check for input,
        ; update the sprite pointers (to achieve the blinking animation effect).
        LDX #$00
        STX dnaCurrentSpritesXPosArrayIndex
        JSR DNA_UpdateHeadOfPreviousXPosData
        JSR DNA_CheckKeyboardInput
        DEC currentShipWaveDataHiPtr
        JSR DNA_UpdateSPritePointers
        LDA #$01
        STA currentSpriteIndex

        LDA #$2E
        STA $D012    ;Raster Position

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JMP eEA31

        LDX dnaCurrentSpritesXPosArrayIndex

        ; Update the 'Raster Position' to the next position on the screen
        ; that we want to interrupt at.
b0978   LDA dnaSPritesXPositionsArray,X
        SEC
        SBC #$02
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JMP ReturnFromDNAInterruptHandler

dnaSpritesPreviousXPosArray   .BYTE $C0,$BF,$BD,$B8,$B1,$A8,$9E,$92
                              .BYTE $86,$79,$6D,$61,$57,$4E,$47,$42
                              .BYTE $40,$40,$42,$47,$4E,$57,$61,$6D
                              .BYTE $79,$86,$92,$9E,$A8,$B1,$B8,$BD
                              .BYTE $BF,$BF,$BD,$B8,$B1,$A8,$9E,$92
dnaSPritesXPositionsArray   .BYTE $30,$38,$40,$48,$50,$58,$60,$68
                            .BYTE $70,$78,$80,$88,$90,$98,$A0,$A8
                            .BYTE $B0,$B8,$C0,$C8,$D0,$D8,$E0,$E8
                            .BYTE $FF
dnaSpriteColor2Array            .BYTE $02,$08,$07,$05,$04,$06,$FF
dnaSpriteColorArray             .BYTE $0B,$0C,$0F,$01,$0F,$0C,$FF
dnaCurrentSPriteColorARrayIndex .BYTE $00
dnaSpriteColor2ArrayIndex       .BYTE $01
currentSpriteIndex              .BYTE $01
dnaCurrentPhase                 .BYTE $08
;-------------------------------------------------------
; DNA_PropagatePreviousXPosToTheRight   
;-------------------------------------------------------
DNA_PropagatePreviousXPosToTheRight   
        LDX #$27
b09E1   LDA dnaSpritesPreviousXPosArray - $01,X
        STA dnaSpritesPreviousXPosArray,X
        DEX
        BNE b09E1
        RTS

previousXValue   .BYTE $11
;-------------------------------------------------------
; DNA_UpdateHeadOfPreviousXPosData   
;-------------------------------------------------------
DNA_UpdateHeadOfPreviousXPosData   
        DEC actualSPeed
        BNE b09FA
        LDA dnaCurrentSpeed
        STA actualSPeed
        JSR DNA_PropagatePreviousXPosToTheRight

b09FA   JSR DNA_CalculateValueForHeadOfPreviousXPosData
        DEC timeToNextUpdateCounter
        BNE b0A33
        LDA initialTimeToNextUpdate
        STA timeToNextUpdateCounter
        LDX previousXValue
        LDA dnaXpoDataHeadArray,X
        STA tempVarStorage
        LDY dnaWave2Enabled
        BEQ b0A19
        CLC
        ROR
        STA tempVarStorage
b0A19   LDA newHeadOfXPosData
        CLC
        ADC tempVarStorage
        STA dnaSpritesPreviousXPosArray
        TXA
        CLC
        ADC incrementToXPosition
        TAX
        CPX #$40
        BMI b0A30
        SEC
        SBC #$40
        TAX
b0A30   STX previousXValue
b0A33   RTS

incrementToXPosition          .BYTE $01
timeToNextUpdateCounter       .BYTE $01
initialTimeToNextUpdate       .BYTE $01
dnaCurrentSpeed               .BYTE $02
actualSPeed                   .BYTE $02
dnaWave1Frequency             .BYTE $0F
dnaLastRecordedKey            .BYTE $40
timesToNextUpdateForFrequency .BYTE $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
                              .BYTE $08,$07,$06,$05,$04,$03,$02,$01
                              .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                              .BYTE $01,$01,$01,$01,$01,$01,$01,$01
xPosOffsetsForFrequency       .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                              .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                              .BYTE $01,$02,$03,$04,$05,$06,$07,$08
                              .BYTE $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
;----------------------------------------------------------------
; DNA_CheckKeyBoardInput
; We only act on a keypress the first time we see it. This means
; we only act on input when the previous key press was `$C0` and
; the current key press is potentially something else.
;----------------------------------------------------------------
DNA_CheckKeyboardInput   
        LDA dnaLastRecordedKey
        CMP #$40
        BEQ b0A88
        LDA lastKeyPressed
        STA dnaLastRecordedKey
        RTS

b0A88   LDA lastKeyPressed
        STA dnaLastRecordedKey
        CMP #$0C
        BNE b0A97
        ; Z pressed: decrease wave frequency.
        DEC dnaWave1Frequency
        JMP DNA_DrawStuff

b0A97   CMP #$17
        BNE b0AA1
        ; X pressed: increase wave frequency.
        INC dnaWave1Frequency
        JMP DNA_DrawStuff

b0AA1   CMP #$0A
        BNE b0AB3
        ; A pressed. Increase speed.
        INC dnaCurrentSpeed

UpdateSpeedAndDisplayUpdatedSettings   
        LDA dnaCurrentSpeed
        AND #$0F
        STA actualSPeed
        JMP DNA_UpdateDisplayedSettings
        ; Returns

b0AB3   CMP #$0D
        BNE DNA_ContinueCHeckKeyBoardInput

        ; S pressed. Decrease speed.
        DEC dnaCurrentSpeed
        JMP UpdateSpeedAndDisplayUpdatedSettings
        ; Returns

;-------------------------------------------------------
; DNA_DrawStuff   
;-------------------------------------------------------
DNA_DrawStuff   
        LDA dnaWave1Frequency
        AND #$1F
        TAX
        LDA timesToNextUpdateForFrequency,X
        STA initialTimeToNextUpdate
        STA timeToNextUpdateCounter
        LDA xPosOffsetsForFrequency,X
        STA incrementToXPosition
        LDA dnaWave2Frequency
        AND #$1F
        TAX
        LDA timesToNextUpdateForFrequency,X
        STA initialTimeToNextUpdateForPreviousHead
        STA timeToNextUpdateCounterForPreviousHead
        LDA xPosOffsetsForFrequency,X
        STA incrementToXPositionForPreviousHead
        JMP DNA_UpdateDisplayedSettings

;-------------------------------------------------------
; DNA_ContinueCHeckKeyBoardInput   
;-------------------------------------------------------
DNA_ContinueCHeckKeyBoardInput   
        CMP #$3E
        BNE b0AFC
        INC dnaCurrentPhase
        LDA dnaCurrentPhase
        AND #$0F
        STA dnaCurrentPhase
        JMP DNA_UpdateDisplayedSettings

b0AFC   CMP #$14
        BNE b0B06
        DEC dnaWave2Frequency
        JMP DNA_DrawStuff

b0B06   CMP #$1F
        BNE b0B10
        INC dnaWave2Frequency
        JMP DNA_DrawStuff

b0B10   CMP #$3C
        BNE b0B27
        LDA dnaTextDisplayed
        EOR #$01
        STA dnaTextDisplayed
        BEQ b0B24
        JSR DNA_DrawTitleScreen
        JMP DNA_UpdateDisplayedSettings

b0B24   JMP DNA_ClearScreenMain

b0B27   CMP #$04
        BNE b0B36
        LDA dnaWave2Enabled
        EOR #$01
        STA dnaWave2Enabled
        JMP DNA_UpdateDisplayedSettings

b0B36   CMP #$06
        BNE b0B62
        INC dnaCurrentColorScheme
        LDA dnaCurrentColorScheme
        CMP #$08
        BNE b0B49
        LDA #$00
        STA dnaCurrentColorScheme
b0B49   TAX
        LDA dnaColorSchemeLoPtr,X
        STA dnaColorScheme2LoByte
        STA dnaColorScheme1LoByte
        LDA dnaColorSchemeHiPtr,X
        STA dnaColorScheme2HiByte
        STA dnaColorScheme1HiByte
        LDA #$00
        STA dnaSpriteColor2ArrayIndex
        RTS

b0B62   CMP #$03
        BNE b0B8D
        INC dnaCurrentColorScheme2
        LDA dnaCurrentColorScheme2
        CMP #$08
        BNE b0B75
        LDA #$00
        STA dnaCurrentColorScheme2
b0B75   TAX
        LDA dnaColorSchemeLoPtr,X
        STA dnaColorScheme4LoByte
        STA dnaColorScheme3LoByte
        LDA dnaColorSchemeHiPtr,X
        STA dnaColorScheme4HiByte
        STA dnaColorScheme3HiByte
        LDA #$00
        STA dnaCurrentSPriteColorARrayIndex
b0B8D   RTS

dnaWave2Frequency   .BYTE $11
dnaStarfieldSprite1Array   .BYTE $A4,$5B,$BC,$53,$68,$7E,$22,$DD
        .BYTE $8D,$E9,$4B,$92,$5F,$F3,$FE,$D3
        .BYTE $33,$BD,$76,$1A,$00,$8B,$58,$CA
dnaStarfieldSPrite2Array   .BYTE $3F,$8D,$DE,$E3,$71,$8A,$CE,$ED
        .BYTE $1C,$BD,$D4,$13,$2A,$95,$54,$DF
        .BYTE $50,$2C,$AC,$F7,$D4,$E0,$FF,$42
currentColorIBallSprite   .BYTE $01
dnaIBallBlinkInterval   .BYTE $01
currentMonochromIBAllSprite   .BYTE $0C
dnaColorUpdateInterval   .BYTE $05

;-------------------------------------------------------
; DNA_UpdateSPritePointers   
;-------------------------------------------------------
DNA_UpdateSPritePointers   
        DEC dnaColorUpdateInterval
        BNE b0BF7
        LDA #$05
        STA dnaColorUpdateInterval
        LDX indexToSpriteColor1Array
        LDA dnaSpriteColor1Array,X
        STA $D025    ;Sprite Multi-Color Register 0
        INX
        LDA dnaSpriteColor1Array,X
        BPL b0BDE

        LDX #$00
b0BDE   STX indexToSpriteColor1Array
        LDA currentShipWaveDataHiPtr
        AND #$01
        CLC
        ADC #$C0
        STA a07FF
        LDA currentShipWaveDataHiPtr
        AND #$01
        EOR #$01
        CLC
        ADC #$C0
        STA a07FE

b0BF7   DEC dnaIBallBlinkInterval
        BNE b0C3D
        LDA #$02
        STA dnaIBallBlinkInterval
        LDA currentColorIBallSprite
        CLC
        ADC #$C2
        STA Sprite0Ptr
        STA Sprite1Ptr
        STA SPrite2Ptr
        LDA currentMonochromIBAllSprite
        CLC
        ADC #$C2
        STA Sprite3Ptr
        STA Sprite4Ptr
        STA Sprite5Ptr
        INC currentColorIBallSprite
        LDA currentColorIBallSprite
        CMP #$0E
        BNE b0C2E
        LDA #$00
        STA currentColorIBallSprite
b0C2E   DEC currentMonochromIBAllSprite
        LDA currentMonochromIBAllSprite
        CMP #$FF
        BNE b0C3D
        LDA #$0D
        STA currentMonochromIBAllSprite
b0C3D   RTS

indexToXPosDataHeadArray               .BYTE $39
indexToSpriteColor1Array               .BYTE $03
initialTimeToNextUpdateForPreviousHead .BYTE $01
timeToNextUpdateCounterForPreviousHead .BYTE $01
incrementToXPositionForPreviousHead    .BYTE $02
dnaWave2Enabled                        .BYTE $00
newHeadOfXPosData                      .BYTE $40
;-------------------------------------------------------
; DNA_CalculateValueForHeadOfPreviousXPosData   
;-------------------------------------------------------
DNA_CalculateValueForHeadOfPreviousXPosData   
        LDA dnaWave2Enabled
        BNE b0C50
        LDA #$40
        STA newHeadOfXPosData
b0C4F   RTS

b0C50   DEC timeToNextUpdateCounterForPreviousHead
        BNE b0C4F
        LDA initialTimeToNextUpdateForPreviousHead
        STA timeToNextUpdateCounterForPreviousHead
        LDX indexToXPosDataHeadArray
        LDA dnaXpoDataHeadArray,X
        CLC
        ROR
        CLC
        ADC #$40
        STA newHeadOfXPosData
        TXA
        CLC
        ADC incrementToXPositionForPreviousHead
        CMP #$40
        BMI b0C75
        SEC
        SBC #$40
b0C75   STA indexToXPosDataHeadArray
        RTS

;-------------------------------------------------------
; DNA_DrawTitleScreen   
;-------------------------------------------------------
DNA_DrawTitleScreen   
        LDX #$07
b0C7B   LDA f0CD9,X
        AND #$3F
        STA SCREEN_RAM + $0048,X
        LDA f0CE1,X
        AND #$3F
        STA SCREEN_RAM + $0070,X
        LDA f0CE9,X
        AND #$3F
        STA SCREEN_RAM + $00C0,X
        LDA f0CF1,X
        AND #$3F
        STA SCREEN_RAM + $0110,X
        LDA f0CF9,X
        AND #$3F
        STA SCREEN_RAM + $0138,X
        LDA f0D01,X
        AND #$3F
        STA SCREEN_RAM + $0188,X
        LDA f0D09,X
        AND #$3F
        STA SCREEN_RAM + $01B0,X
        LDA f0D11,X
        AND #$3F
        STA SCREEN_RAM + $0200,X
        LDA f0D19,X
        AND #$3F
        STA SCREEN_RAM + $0228,X
        LDA f0D21,X
        AND #$3F
        STA SCREEN_RAM + $02C8,X
        LDA f0D29,X
        AND #$3F
        STA SCREEN_RAM + $02F0,X
        DEX
        BNE b0C7B
        JMP DNA_DrawCreditsText

f0CD9   .TEXT " SPEED:F"
f0CE1   .TEXT "  <A S> "
f0CE9   .TEXT " WAVE 1 "
f0CF1   .TEXT " FREQ: F"
f0CF9   .TEXT "  <Z X> "
f0D01   .TEXT " WAVE 2 "
f0D09   .TEXT " ON   F1"
f0D11   .TEXT " FREQ: F"
f0D19   .TEXT "  <C V> "
f0D21   .TEXT " PHASE:F"
f0D29   .TEXT "   Q>>  "
f0D31   .TEXT "0123456789ABCDEF"

;-------------------------------------------------------
; DNA_UpdateDisplayedSettings
;-------------------------------------------------------
DNA_UpdateDisplayedSettings
        LDA dnaTextDisplayed
        BNE b0D4C
        INC dnaTextDisplayed
        JSR DNA_DrawTitleScreen
b0D4C   LDA #$20
        STA a0516
        STA a0606
        LDA dnaWave1Frequency
        AND #$10
        BEQ b0D60
        LDA #$31
        STA a0516
b0D60   LDA dnaWave1Frequency
        AND #$0F
        TAX
        LDA f0D31,X
        AND #$3F
        STA a0517
        LDA dnaWave2Frequency
        AND #$10
        BEQ b0D7A
        LDA #$31
        STA a0606
b0D7A   LDA dnaWave2Frequency
        AND #$0F
        TAX
        LDA f0D31,X
        AND #$3F
        STA a0607
        LDX dnaCurrentSpeed
        LDA f0D31,X
        AND #$3F
        STA a044F
        LDX dnaCurrentPhase
        LDA f0D31,X
        AND #$3F
        STA a06CF
        LDA dnaWave2Enabled
        BNE b0DAC
        LDA #$06
        STA a05B2
        STA a05B3
        RTS

p200E = $2000
b0DAC   LDA #<p200E
        STA a05B2
        LDA #>p200E
        STA a05B3
        RTS

dnaTextDisplayed       .BYTE $01
dnaSpriteColor1Array   .BYTE $06,$02,$04,$05,$03,$07,$01,$07
                       .BYTE $03,$05,$04,$02,$06,$FF,$06,$05
                       .BYTE $0E,$0D,$03,$FF,$09,$08,$07,$08
                       .BYTE $09,$FF,$00,$00,$00,$02,$00,$00
                       .BYTE $07,$FF,$01,$0F,$0D,$0C,$00,$00
                       .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
                       .BYTE $06,$0E,$0B,$02,$05,$FF
dnaColorSchemeLoPtr    .BYTE $CD,$D4,$B8,$C6,$CC,$D2,$DA,$E8
dnaColorSchemeHiPtr    .BYTE $09,$09,$0D,$0D,$0D,$0D,$0D,$0D
dnaCurrentColorScheme  .BYTE $00
dnaCurrentColorScheme2 .BYTE $01
        .TEXT "    % % %  DNA  % % %   "
f0E18   .TEXT " CONCEIVED AND EXECUTED B"
f0E31   .TEXT "Y          Y A K         "
f0E4A   .TEXT " SPACE: CANCEL SCREEN TEX"
f0E63   .TEXT "TF5 AND F7 CHANGE COLOURS"
f0E7C   .TEXT " LISTEN TO TALKING HEADS."
f0E95   .TEXT ".BE NICE TO HAIRY ANIMALS "

;-------------------------------------------------------
; DNA_DrawCreditsText   
;-------------------------------------------------------
DNA_DrawCreditsText   
        LDX #$19
b0EB1   LDA dnaCurrentColorScheme2,X
        AND #$3F
        STA SCREEN_RAM + $002B,X
        LDA f0E18,X
        AND #$3F
        STA SCREEN_RAM + $00A3,X
        LDA f0E31,X
        AND #$3F
        STA SCREEN_RAM + $011B,X
        LDA f0E4A,X
        AND #$3F
        STA SCREEN_RAM + $020B,X
        LDA f0E63,X
        AND #$3F
        STA SCREEN_RAM + $025B,X
        LDA f0E7C,X
        AND #$3F
        STA SCREEN_RAM + $034B,X
        LDA f0E95,X
        AND #$3F
        STA SCREEN_RAM + $039B,X
        DEX
        BNE b0EB1
        RTS

*=$1000
dnaXpoDataHeadArray   .BYTE $40,$46,$4C,$52,$58,$5E,$63,$68
                      .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
                      .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
                      .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
                      .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
                      .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
                      .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
                      .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
                      .BYTE $FF,$00,$00,$00,$00,$00,$00,$00
                      .BYTE $00,$00,$00,$00,$00,$00,$00,$00
*=$2000
.include "charset.asm"
*=$3000
.include "sprites.asm"
