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
;----------------------------------------------------------------
; LaunchDNA
;----------------------------------------------------------------
LaunchDNA   
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$00
        STA dnaPlayerPressedExit
        JSR DNA_SwapSpriteData
        JMP DNA_ClearScreenAndInit

startofBonusPhaseSprites = $E400
;----------------------------------------------------------------
; DNA_SwapSpriteData
;----------------------------------------------------------------
DNA_SwapSpriteData   
        SEI 
        LDA #$34
        STA RAM_ACCESS_MODE

        ; $E400 is the location of the IBALL sprites
        LDX #$00
b0D47   LDA startofBonusPhaseSprites,X
        PHA 
        LDA beginningOfGilbySprites,X
        STA startofBonusPhaseSprites,X
        PLA 
        STA beginningOfGilbySprites,X
        DEX 
        BNE b0D47
        LDA #$36
        STA RAM_ACCESS_MODE
        RTS 

;----------------------------------------------------------------
; DNA_ClearScreenAndInit
;----------------------------------------------------------------
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

;----------------------------------------------------------------
; DNA_ClearScreenMain
;----------------------------------------------------------------
DNA_ClearScreenMain   
        LDX #$00
b0D9C   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + LINE6_COL16,X
        STA SCREEN_RAM + LINE12_COL32,X
        STA SCREEN_RAM + LINE19_COL8,X
        LDA #$0E
        STA COLOR_RAM + LINE0_COL0,X
        STA COLOR_RAM + LINE6_COL16,X
        STA COLOR_RAM + LINE12_COL32,X
        STA $DB00,X
        DEX 
        BNE b0D9C
        RTS 

;----------------------------------------------------------------
; DNA_Initialize
;----------------------------------------------------------------
DNA_Initialize   
        JSR DNA_SetInterruptHandler
        JSR DNA_DrawTitleScreen
        JSR DNA_DrawStuff
        CLI 

        ; Loop until the player exits
b0DC6   LDA dnaPlayerPressedExit
        BEQ b0DC6

        ; Player exited, swap back in the game sprite data
        JSR DNA_SwapSpriteData
        RTS 

;----------------------------------------------------------------
; DNA_SetInterruptHandler
;----------------------------------------------------------------
DNA_SetInterruptHandler   
        SEI 
        LDA #<DNA_InterruptHandler
        STA $0314    ;IRQ
        LDA #>DNA_InterruptHandler
        STA $0315    ;IRQ
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
;----------------------------------------------------------------
; DNA_InterruptHandler
;----------------------------------------------------------------
DNA_InterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE DNA_RunMainAnimationRoutine
ReturnFromDNAInterruptHandler
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

DNA_RunMainAnimationRoutine   
        JMP DNA_MainAnimationRoutine

dnaCurrentSpritesXPosArrayIndex   .BYTE $00

;----------------------------------------------------------------
; DNA_MainAnimationRoutine
;----------------------------------------------------------------
DNA_MainAnimationRoutine   
        LDX dnaCurrentSpritesXPosArrayIndex
        LDY currentSpriteIndex
        TYA 
        STA currentShipWaveDataLoPtr
        CLC 
        ASL 
        TAY 

        LDA dnaSpritesPreviousXPosArray,X
        STA $CFFE,Y ; Sprite 'Y' X Pos
        LDA dnaSpritesXPositionsArray,X
        STA $CFFF,Y ; Sprite 'Y' X Pos
        STA $D005,Y  ;Sprite 2 Y Pos
        STA $D00F    ;Sprite 7 Y Pos
        STA $D00D    ;Sprite 6 Y Pos

        INC dnaStarfieldSprite1Array,X
        LDA dnaStarfieldSprite1Array,X
        STA $D00C    ;Sprite 6 X Pos

        LDA currentShipWaveDataHiPtr
        AND #$01
        BEQ b0E3B

        INC dnaStarfielSprite2Array,X
b0E3B   LDA dnaStarfielSprite2Array,X
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
        BNE b0E6F

        LDX #$00
b0E6F   STX dnaSpriteColor2ArrayIndex

        LDX dnaCurrentSpriteColorArrayIndex
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
        BNE b0E85
        LDX #$00
b0E85   STX dnaCurrentSpriteColorArrayIndex

        LDX currentShipWaveDataLoPtr
        INX 
        INY 
        CPY #$04
        BNE b0E92

        ; Check if we should move back to the start of the raster positions
        ; array (end of the array denoted by a sentinel value of $FF).
        LDY #$01
b0E92   STY currentSpriteIndex
        STX dnaCurrentSpritesXPosArrayIndex
        LDA dnaSpritesXPositionsArray,X
        CMP #$FF
        BNE b0EC7

        ; We've reached the end of the raster positions array (i.e. we've done
        ; a full paint of the screen) so do some book-keeping, check for input,
        ; update the sprite pointers (to achieve the blinking animation effect).
        LDX #$00
        STX dnaCurrentSpritesXPosArrayIndex
        JSR DNA_UpdateHeadOfPreviousXPosData
        JSR DNA_CheckKeyBoardInput
        DEC currentShipWaveDataHiPtr
        JSR DNA_UpdateSpritePointers
        LDA #$01
        STA currentSpriteIndex

        LDA #$2E
        STA $D012    ;Raster Position

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JMP $EA31
        LDX dnaCurrentSpritesXPosArrayIndex

        ; Update the 'Raster Position' to the next position on the screen
        ; that we want to interrupt at.
b0EC7   LDA dnaSpritesXPositionsArray,X
        SEC 
        SBC #$02
        STA $D012    ;Raster Position

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        JMP ReturnFromDNAInterruptHandler

dnaSpritesPreviousXPosArrayIndexMinusOne   =*-$01
dnaSpritesPreviousXPosArray     .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
                                .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
                                .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
                                .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                .BYTE $00,$00,$00,$00,$00,$00,$00,$00
dnaSpritesXPositionsArray       .BYTE $30,$38,$40,$48,$50,$58,$60,$68
                                .BYTE $70,$78,$80,$88,$90,$98,$A0,$A8
                                .BYTE $B0,$B8,$C0,$C8,$D0,$D8,$E0,$E8
                                .BYTE $FF
dnaSpriteColor2Array            .BYTE RED,ORANGE,YELLOW,GREEN,PURPLE,BLUE,END_SENTINEL
dnaSpriteColorArray             .BYTE GRAY1,GRAY2,GRAY3,WHITE,GRAY3,GRAY2,END_SENTINEL
dnaXPosDataHeadArray            .BYTE $40,$46,$4C,$53,$58,$5E,$63,$68
                                .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
                                .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
                                .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
                                .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
                                .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
                                .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
                                .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
                                .BYTE $FF
dnaCurrentSpriteColorArrayIndex .BYTE $00
dnaSpriteColor2ArrayIndex       .BYTE $00
currentSpriteIndex              .BYTE $01
dnaCurrentPhase                 .BYTE $05

;----------------------------------------------------------------
; DNA_PropagatePreviousXPosToTheRight
;----------------------------------------------------------------
DNA_PropagatePreviousXPosToTheRight   
        LDX #$27
b0F71   LDA dnaSpritesPreviousXPosArrayIndexMinusOne,X
        STA dnaSpritesPreviousXPosArray,X
        DEX 
        BNE b0F71
        RTS 

a0F7B   .BYTE $00
;----------------------------------------------------------------
; DNA_UpdateHeadOfPreviousXPosData
;----------------------------------------------------------------
DNA_UpdateHeadOfPreviousXPosData   
        DEC actualSpeed
        BNE b0F8A
        LDA dnaCurrentSpeed
        STA actualSpeed
        JSR DNA_PropagatePreviousXPosToTheRight

b0F8A   JSR DNA_CalculateValueForHeadOfPreviousXPosData
        DEC timeToNextUpdateCounter
        BNE b0FC3
        LDA initialTimeToNextUpdate
        STA timeToNextUpdateCounter
        LDX a0F7B
        LDA dnaXPosDataHeadArray,X
        STA tempVarStorage
        LDY dnaWave2Enabled
        BEQ b0FA9
        CLC 
        ROR 
        STA tempVarStorage
b0FA9   LDA newHeadOfXPosData
        CLC 
        ADC tempVarStorage
        STA dnaSpritesPreviousXPosArray
        TXA 
        CLC 
        ADC incrementToXPosition
        TAX 
        CPX #$40
        BMI b0FC0
        SEC 
        SBC #$40
        TAX 
b0FC0   STX a0F7B
b0FC3   RTS 

incrementToXPosition          .BYTE $02
timeToNextUpdateCounter       .BYTE $01
initialTimeToNextUpdate       .BYTE $05
dnaCurrentSpeed               .BYTE $01
actualSpeed                   .BYTE $01
dnaWave1Frequency             .BYTE $11
dnaLastRecordedKey            .BYTE $00
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
DNA_CheckKeyBoardInput   
        LDA dnaLastRecordedKey
        CMP #$40 ; No key pressed
        BEQ b1018

        ; No key was pressed. Update last recorded key and return.
        LDA lastKeyPressed
        STA dnaLastRecordedKey
        RTS 

b1018   LDA lastKeyPressed
        STA dnaLastRecordedKey
        CMP #$0C ; 'Z'
        BNE b1027
        ; Z pressed: decrease wave frequency.
        DEC dnaWave1Frequency
        JMP DNA_DrawStuff
        ; Returns

b1027   CMP #$17 ; 'X'
        BNE b1031
        ; X pressed: increase wave frequency.
        INC dnaWave1Frequency
        JMP DNA_DrawStuff
        ; Returns

b1031   CMP #$0A ; 'A'
        BNE b1043
        ; A pressed. Increase speed.
        INC dnaCurrentSpeed

UpdateSpeedAndDisplayUpdatedSettings   
        LDA dnaCurrentSpeed
        AND #$0F
        STA actualSpeed
        JMP DNA_UpdateDisplayedSettings
        ; Returns

b1043   CMP #$0D ; 'S'
        BNE DNA_ContinueCheckKeyboardInput
        ; Returns

        ; S pressed. Decrease speed.
        DEC dnaCurrentSpeed
        JMP UpdateSpeedAndDisplayUpdatedSettings
        ; Returns

;----------------------------------------------------------------
; DNA_DrawStuff
;----------------------------------------------------------------
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
        ; Returns

;---------------------------------------------------------------------------------
; DNA_ContinueCheckKeyboardInput
;---------------------------------------------------------------------------------

DNA_ContinueCheckKeyboardInput
        CMP #$3E ; Q
        BNE b108C
        ; 'Q' pressed. Increase phase.
        INC dnaCurrentPhase
        LDA dnaCurrentPhase
        AND #$0F
        STA dnaCurrentPhase
        JMP DNA_UpdateDisplayedSettings
        ; Returns

b108C   CMP #$14 ; C
        BNE b1096
        ; 'C' pressed. Increase wave 2 frequency.
        DEC dnaWave2Frequency
        JMP DNA_DrawStuff
        ; Returns

b1096   CMP #$1F ; V
        BNE b10A0
        ; 'V' pressed. Decrease wave 2 frequency.
        INC dnaWave2Frequency
        JMP DNA_DrawStuff
        ; Returns

b10A0   CMP #$3C ; Space
        BNE b10B7
        ; Space pressed. Toggle text display.
        LDA dnaTextDisplayed
        EOR #$01
        STA dnaTextDisplayed
        BEQ b10B4
        JSR DNA_DrawTitleScreen
        JMP DNA_UpdateDisplayedSettings
        ; Returns

b10B4   JMP DNA_ClearScreenMain
        ; Returns

b10B7   CMP #$04 ; F1/F2
        BNE b10C6
        ; F1/F2 pressed. Toggle wave 2
        LDA dnaWave2Enabled
        EOR #$01
        STA dnaWave2Enabled
        JMP DNA_UpdateDisplayedSettings
        ; Returns

b10C6   CMP #$06 ; F5
        BNE b10F2

        ; F5 pressed. Update color scheme of wave 1.
        INC dnaCurrentColorScheme
        LDA dnaCurrentColorScheme
        CMP #$08
        BNE b10D9
        LDA #$00
        STA dnaCurrentColorScheme
b10D9   TAX 
        LDA dnaColorSchemeLoPtr,X
        STA dnaColorScheme2LoByte
        STA dnaColorScheme1LoByte
        LDA dnaColorSchemeHiPtr,X
        STA dnaColorScheme2HiByte
        STA dnaColorScheme1HiByte
        LDA #$00
        STA dnaSpriteColor2ArrayIndex
        RTS 

b10F2   CMP #$03 ; F7
        BNE b111D
        ;F7 pressed - change colors
        INC dnaCurrentColorScheme2
        LDA dnaCurrentColorScheme2
        CMP #$08
        BNE b1105

        LDA #$00
        STA dnaCurrentColorScheme2
b1105   TAX 
        LDA dnaColorSchemeLoPtr,X
        STA dnaColorScheme4LoByte
        STA dnaColorScheme3LoByte
        LDA dnaColorSchemeHiPtr,X
        STA dnaColorScheme4HiByte
        STA dnaColorScheme3HiByte
        LDA #$00
        STA dnaCurrentSpriteColorArrayIndex

b111D   CMP #$31 ; *
        BNE b1124
        ; * Pressed. Exit DNA.
        INC dnaPlayerPressedExit

b1124   RTS 

dnaWave2Frequency           .BYTE $12
dnaPlayerPressedExit        .BYTE $00
dnaStarfieldSprite1Array    .BYTE $4E,$05,$66,$FD,$12,$28,$CC,$87
                            .BYTE $37,$93,$F5,$3B,$09,$9D,$A8,$7D
                            .BYTE $DD,$67,$20,$C4,$AA,$35,$02,$74
dnaStarfielSprite2Array     .BYTE $94,$E2,$33,$38,$C6,$DF,$23,$42
                            .BYTE $71,$12,$29,$67,$7F,$EA,$A9,$34
                            .BYTE $A5,$81,$01,$4C,$29,$36,$55
                            .BYTE $98
currentColorIBallSprite     .BYTE $00
dnaIBallBlinkInterval       .BYTE $01
currentMonochromIBallSprite .BYTE $04
dnaColorUpdateInterval      .BYTE $01

;----------------------------------------------------------------
; DNA_UpdateSpritePointers
;----------------------------------------------------------------
DNA_UpdateSpritePointers   
        DEC dnaColorUpdateInterval
        BNE b1181

        LDA #$05
        STA dnaColorUpdateInterval
        LDX indexToSpriteColor1Array
        LDA dnaSpriteColor1Array,X
        STA $D025    ;Sprite Multi-Color Register 0
        INX 
        LDA dnaSpriteColor1Array,X
        BPL b1176

        LDX #$00
b1176   STX indexToSpriteColor1Array
        LDA #$C0
        STA Sprite7PtrStarField
        STA Sprite6Ptr
b1181   DEC dnaIBallBlinkInterval
        BNE b11C7

        LDA #$05
        STA dnaIBallBlinkInterval

        LDA currentColorIBallSprite
        CLC 
        ADC #$C1
        STA Sprite0Ptr
        STA Sprite1Ptr
        STA Sprite2Ptr

        LDA currentMonochromIBallSprite
        CLC 
        ADC #$C1
        STA Sprite3Ptr
        STA Sprite4Ptr
        STA Sprite5Ptr

        INC currentColorIBallSprite
        LDA currentColorIBallSprite
        CMP #$04
        BNE b11B8
        LDA #$00
        STA currentColorIBallSprite

b11B8   DEC currentMonochromIBallSprite
        LDA currentMonochromIBallSprite
        CMP #$FF
        BNE b11C7
        LDA #$03
        STA currentMonochromIBallSprite
b11C7   RTS 

indexToXPosDataHeadArray               .BYTE $00
indexToSpriteColor1Array               .BYTE $00
initialTimeToNextUpdateForPreviousHead .BYTE $03
timeToNextUpdateCounterForPreviousHead .BYTE $03
incrementToXPositionForPreviousHead    .BYTE $01
dnaWave2Enabled                        .BYTE $01
newHeadOfXPosData                      .BYTE $00
;----------------------------------------------------------------
; DNA_CalculateValueForHeadOfPreviousXPosData
;----------------------------------------------------------------
DNA_CalculateValueForHeadOfPreviousXPosData   
        LDA dnaWave2Enabled
        BNE b11DA
        LDA #$40
        STA newHeadOfXPosData
b11D9   RTS 

b11DA   DEC timeToNextUpdateCounterForPreviousHead
        BNE b11D9
        LDA initialTimeToNextUpdateForPreviousHead
        STA timeToNextUpdateCounterForPreviousHead
        LDX indexToXPosDataHeadArray
        LDA dnaXPosDataHeadArray,X
        CLC 
        ROR 
        CLC 
        ADC #$40
        STA newHeadOfXPosData
        TXA 
        CLC 
        ADC incrementToXPositionForPreviousHead
        CMP #$40
        BMI b11FF
        SEC 
        SBC #$40
b11FF   STA indexToXPosDataHeadArray
        RTS 

;----------------------------------------------------------------
; DNA_DrawTitleScreen
;----------------------------------------------------------------
DNA_DrawTitleScreen   
        LDX #$07
b1205   LDA sideBarTxt1,X
        AND #$3F
        STA SCREEN_RAM + LINE1_COL32,X
        LDA sideBarTxt2,X
        AND #$3F
        STA SCREEN_RAM + LINE2_COL32,X
        LDA sideBarText3,X
        AND #$3F
        STA SCREEN_RAM + LINE4_COL32,X
        LDA sideBarTxt4,X
        AND #$3F
        STA SCREEN_RAM + LINE6_COL32,X
        LDA sideBarText5,X
        AND #$3F
        STA SCREEN_RAM + LINE7_COL32,X
        LDA sideBarTxt6,X
        AND #$3F
        STA SCREEN_RAM + LINE9_COL32,X
        LDA sideBarTxt7,X
        AND #$3F
        STA SCREEN_RAM + LINE10_COL32,X
        LDA sideBarTxt8,X
        AND #$3F
        STA SCREEN_RAM + LINE12_COL32,X
        LDA sideBarTxt9,X
        AND #$3F
        STA SCREEN_RAM + LINE13_COL32,X
        LDA sideBarTxt10,X
        AND #$3F
        STA SCREEN_RAM + LINE17_COL32,X
        LDA sideBarTxt11,X
        AND #$3F
        STA SCREEN_RAM + LINE18_COL32,X
        DEX 
        BNE b1205
        JMP DNA_DrawCreditsText

sideBarTxt1  .TEXT " SPEED:F"
sideBarTxt2  .TEXT "  <A S> "
sideBarText3 .TEXT " WAVE 1 "
sideBarTxt4  .TEXT " FREQ: F"
sideBarText5 .TEXT "  <Z X> "
sideBarTxt6  .TEXT " WAVE 2 "
sideBarTxt7  .TEXT " ON   F1"
sideBarTxt8  .TEXT " FREQ: F"
sideBarTxt9  .TEXT "  <C V> "
sideBarTxt10 .TEXT " PHASE:F"
sideBarTxt11 .TEXT "   Q>>  "
sideBarTxt12 .TEXT "0123456789ABCDEF"
;----------------------------------------------------------------
; DNA_UpdateDisplayedSettings
;----------------------------------------------------------------
DNA_UpdateDisplayedSettings   
        LDA dnaTextDisplayed
        BNE b12D6
        INC dnaTextDisplayed
        JSR DNA_DrawTitleScreen

b12D6   LDA #$20
        STA SCREEN_RAM + LINE6_COL38
        STA SCREEN_RAM + LINE12_COL38

        LDA dnaWave1Frequency
        AND #$10
        BEQ b12EA
        LDA #$31
        STA SCREEN_RAM + LINE6_COL38

b12EA   LDA dnaWave1Frequency
        AND #$0F
        TAX 
        LDA sideBarTxt12,X
        AND #$3F
        STA SCREEN_RAM + LINE6_COL39

        LDA dnaWave2Frequency
        AND #$10
        BEQ b1304
        LDA #$31
        STA SCREEN_RAM + LINE12_COL38

b1304   LDA dnaWave2Frequency
        AND #$0F
        TAX 
        LDA sideBarTxt12,X
        AND #$3F
        STA SCREEN_RAM + LINE12_COL39

        LDX dnaCurrentSpeed
        LDA sideBarTxt12,X
        AND #$3F
        STA SCREEN_RAM + LINE1_COL39

        LDX dnaCurrentPhase
        LDA sideBarTxt12,X
        AND #$3F
        STA SCREEN_RAM + LINE17_COL39

        LDA dnaWave2Enabled
        BNE b1336
        LDA #$06
        STA SCREEN_RAM + LINE10_COL34
        STA SCREEN_RAM + LINE10_COL35

        RTS 

b1336   LDA #<p200E
        STA SCREEN_RAM + LINE10_COL34
        LDA #>p200E
        STA SCREEN_RAM + LINE10_COL35
        RTS 

END_SENTINEL = $FF
dnaTextDisplayed     .BYTE $01
dnaSpriteColor1Array .BYTE BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE,YELLOW
                     .BYTE CYAN,GREEN,PURPLE,RED,BLUE,END_SENTINEL
dnaSprite3ColorArray .BYTE BLUE,GREEN,LTBLUE,LTGREEN,CYAN,END_SENTINEL
dnsSprite4ColorArray .BYTE BROWN,ORANGE,YELLOW,ORANGE,BROWN,END_SENTINEL
dnaSprite5ColorArray .BYTE BLACK,BLACK,BLACK,RED,BLACK,BLACK,YELLOW,END_SENTINEL
dnaSPrite6ColorArray .BYTE WHITE,GRAY3,LTGREEN,GRAY2,BLACK,BLACK
                     .BYTE BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,END_SENTINEL
dnaSPrite7ColorArray .BYTE BLUE,LTBLUE,GRAY1,RED,GREEN,END_SENTINEL

dnaColorSchemeLoPtr .BYTE <dnaSpriteColor2Array,<dnaSpriteColorArray,<dnaSpriteColor1Array
                    .BYTE <dnaSprite3ColorArray,<dnsSprite4ColorArray,<dnaSprite5ColorArray
                    .BYTE <dnaSPrite6ColorArray,<dnaSPrite7ColorArray
dnaColorSchemeHiPtr .BYTE >dnaSpriteColor2Array,>dnaSpriteColorArray,>dnaSpriteColor1Array
                    .BYTE >dnaSprite3ColorArray,>dnsSprite4ColorArray,>dnaSprite5ColorArray
                    .BYTE >dnaSPrite6ColorArray,>dnaSPrite7ColorArray


dnaCurrentColorScheme   .BYTE $00
dnaCurrentColorScheme2   .BYTE $01
titleTextLine1   .TEXT "    % % %  DNA  % % %   "
titleTextLine2   .TEXT " CONCEIVED AND EXECUTED B"
titleTextLine3   .TEXT "Y            Y A K       "
titleTextLine4   .TEXT " SPACE: CANCEL SCREEN TEX"
titleTextLine5   .TEXT "TF5 AND F7 CHANGE COLOURS"
titleTextLine6   .TEXT " LISTEN TO TALKING HEADS."
titleTextLine7   .TEXT ".BE NICE TO HAIRY ANIMALS "
;----------------------------------------------------------------
; DNA_DrawCreditsText
;----------------------------------------------------------------
DNA_DrawCreditsText   
        LDX #$19
b143B   LDA titleTextLine1 - $01,X
        AND #$3F
        STA SCREEN_RAM + LINE1_COL3,X
        LDA titleTextLine2,X
        AND #$3F
        STA SCREEN_RAM + LINE4_COL3,X
        LDA titleTextLine3,X
        AND #$3F
        STA SCREEN_RAM + LINE7_COL3,X
        LDA titleTextLine4,X
        AND #$3F
        STA SCREEN_RAM + LINE13_COL3,X
        LDA titleTextLine5,X
        AND #$3F
        STA SCREEN_RAM + LINE15_COL3,X
        LDA titleTextLine6,X
        AND #$3F
        STA SCREEN_RAM + LINE21_COL3,X
        LDA titleTextLine7,X
        AND #$3F
        STA SCREEN_RAM + LINE23_COL3,X
        DEX 
        BNE b143B
        RTS 

