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

startOfIBallSprites = $E400
;----------------------------------------------------------------
; DNA_SwapSpriteData
;----------------------------------------------------------------
DNA_SwapSpriteData
        SEI
        LDA #$34
        STA RAM_ACCESS_MODE

        ; $E400 is the location of the IBALL sprites
        LDX #$00
SwapIBallLoop   
        LDA startOfIBallSprites,X
        PHA
        LDA beginningOfGilbySprites,X
        STA startOfIBallSprites,X
        PLA
        STA beginningOfGilbySprites,X
        DEX
        BNE SwapIBallLoop
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
ClearScreenMainLoop   
        LDA #$20
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
        BNE ClearScreenMainLoop
        RTS

;----------------------------------------------------------------
; DNA_Initialize
;----------------------------------------------------------------
DNA_Initialize
        JSR DNA_SetInterruptHandler
        JSR DNA_DrawTitleScreen
        JSR DNA_UpdateSettingsBasedOnFrequency
        CLI

        ; Loop until the player exits
LoopUntilExit   
        LDA dnaPlayerPressedExit
        BEQ LoopUntilExit

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

dnaCurrentSpritesPosArrayIndex   .BYTE $00

spriteIndexDoubled = $40
starField2UpdateInterval = $41
;----------------------------------------------------------------
; DNA_MainAnimationRoutine
;----------------------------------------------------------------
DNA_MainAnimationRoutine
        ; X is the current index into the X and Y Pos arrays for
        ; the sprites.
        LDX dnaCurrentSpritesPosArrayIndex
        
        ; Y will be the index into the two sprites painted during this
        ; raster line. So get the previous index and double it
        ; using an arithmetic-shift-left (ASL) and store it in Y.
        ; currentSpriteIndex loops between 1 and 3 so doubling it here
        ; gives 2, 4, and 6 respectively at each pass. This means that
        ; we handle sprites in pairs of 0-3, 1-4, and 2-5 one after the other.
        ; With 16 pixels between raster lines it ensures that we never attempt
        ; to paint the same sprite twice on the same raster line.
        ; Sprites 6 and 7 are reserved for the starfields.
        LDY currentSpriteIndex
        TYA
        STA spriteIndexDoubled
        CLC
        ASL
        TAY

        ; Update the position of the sprite on the left hand chain.
        LDA dnaSpritesXPositionsArray,X
        STA $CFFE,Y ; Left Sprite X Pos
        LDA dnaSpritesYPositionsArray,X
        STA $CFFF,Y ; Left Sprite Y Pos

        ; Update the Y Pos of the sprite on the right hand chain.
        STA $D005,Y  ; Right Sprite Y Pos

        ; Update the starfield array sprite positions for
        ; this raster line. First set the Y position
        ; using the same Y pos used for the IBall sprites.
        STA $D00F    ;Sprite 7 Y Pos
        STA $D00D    ;Sprite 6 Y Pos

        ; Always update the position of the foreground starfield.
        INC dnaForegroundStarfieldXPosArray,X
        LDA dnaForegroundStarfieldXPosArray,X
        STA $D00C    ;Sprite 6 X Pos

        ; Update the position of the background starfield every second
        ; pass.
        LDA starField2UpdateInterval
        AND #$01
        BEQ UpdateBackgroundStarFieldXPos

        INC dnaBackgroundStarfieldXPosArray,X
UpdateBackgroundStarFieldXPos   
        LDA dnaBackgroundStarfieldXPosArray,X
        STA $D00E    ;Sprite 7 X Pos

        ; Add in the phase to our index to the X position of the sprite on the
        ; right hand chain. If the result is greater than the number of values
        ; in the array subtract it out again.
        ; This means the phase acts as an offset into the X Position array picking
        ; up previous values of X Pos from the left hand chain.
        TXA
        PHA
        CLC
        ADC dnaCurrentPhase
        CMP #$27
        BMI UpdateXPosWithPhase

        ; Back out the addition if result greater than $27.
        SEC
        SBC #$27
UpdateXPosWithPhase   
        TAX
        LDA dnaSpritesXPositionsArray,X
        STA $D004,Y  ;Sprite 2 X Pos

        ; Restore the values of X and Y.
        PLA
        TAX
        LDY currentSpriteIndex
        STX spriteIndexDoubled

        ; Update the colors of the sprites.
        ; First, the left sprite.
        LDX dnaSpriteOriginalLeftColorArrayIndex
dnaLeftSpriteColorLoByte   =*+$01
dnaLeftSpriteColorHiByte   =*+$02
        LDA dnaSpriteOriginalLeftColorArray,X
        STA $D026,Y  ; Left Sprite Color

        ; Increment the color array index and reset
        ; it to 00 if we've reached the end of dnaSpriteColorArray (denoted
        ; by an $FF (END_SENTINEL) sentinel).
        INX
dnaLeftSpriteSentinelCheckLoByte   =*+$01
dnaLeftSpriteSentinelCheckHiByte   =*+$02
        LDA dnaSpriteOriginalLeftColorArray,X
        CMP #END_SENTINEL
        BNE DontResetColor2Index

        LDX #$00
DontResetColor2Index   
        STX dnaSpriteOriginalLeftColorArrayIndex

        ; Update the colors of the sprites.
        ; Next, the right sprite.
        LDX dnaCurrentSpriteColorArrayIndex
dnaRightSpriteColorLoByte   =*+$01
dnaRightSpriteColorHiByte   =*+$02
        LDA dnaSpriteOriginalRightColorArray,X
        STA $D029,Y  ; Right Sprite Color

        ; Increment the color array index and reset
        ; it to 00 if we've reached the end of dnaSpriteColorArray (denoted
        ; by an $FF (END_SENTINEL) sentinel).
        INX
dnaRightSpriteSentinelCheckLoByte   =*+$01
dnaRightSpriteSentinelCheckHiByte   =*+$02
        LDA dnaSpriteOriginalRightColorArray,X
        CMP #END_SENTINEL
        BNE DontResetColorArrayIndex

        LDX #$00
DontResetColorArrayIndex   
        STX dnaCurrentSpriteColorArrayIndex

        ; Check if we should loop the sprite index back around to 01
        ; again.
        LDX spriteIndexDoubled
        INX
        INY
        CPY #$04
        BNE DontResetSpriteIndex

        ; Check if we should move back to the start of the raster positions
        ; array (end of the array denoted by a sentinel value of $FF).
        LDY #$01
DontResetSpriteIndex   
        STY currentSpriteIndex
        STX dnaCurrentSpritesPosArrayIndex
        LDA dnaSpritesYPositionsArray,X
        CMP #END_SENTINEL
        BNE UpdateRasterPosition

        ; We've reached the end of the raster positions array (i.e. we've done
        ; a full paint of the screen) so do some book-keeping, check for input,
        ; update the sprite pointers (to achieve the blinking animation effect).
        LDX #$00
        STX dnaCurrentSpritesPosArrayIndex
        JSR UpdateXPosArrays
        JSR DNA_CheckKeyBoardInput
        DEC starField2UpdateInterval
        JSR DNA_UpdateSpritePointers
        LDA #$01
        STA currentSpriteIndex

        LDA #$2E
        STA $D012    ;Raster Position

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JMP $EA31

        LDX dnaCurrentSpritesPosArrayIndex

        ; Update the 'Raster Position' to the next position on the screen
        ; that we want to interrupt at.
UpdateRasterPosition   
        LDA dnaSpritesYPositionsArray,X
        SEC
        SBC #$02
        STA $D012    ;Raster Position

        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        JMP ReturnFromDNAInterruptHandler

dnaSpritesXPositionsArray       .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
                                .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
                                .BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
                                .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                .BYTE $00,$00,$00,$00,$00,$00,$00,$00

dnaSpritesYPositionsArray       .BYTE $30,$38,$40,$48,$50,$58,$60,$68
                                .BYTE $70,$78,$80,$88,$90,$98,$A0,$A8
                                .BYTE $B0,$B8,$C0,$C8,$D0,$D8,$E0,$E8
                                .BYTE END_SENTINEL

dnaSpriteOriginalLeftColorArray   .BYTE RED,ORANGE,YELLOW,GREEN,PURPLE,BLUE,END_SENTINEL
dnaSpriteOriginalRightColorArray  .BYTE GRAY1,GRAY2,GRAY3,WHITE,GRAY3,GRAY2,END_SENTINEL
newXPosOffsetsArray             .BYTE $40,$46,$4C,$53,$58,$5E,$63,$68
                                .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
                                .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
                                .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
                                .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
                                .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
                                .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
                                .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
                                .BYTE END_SENTINEL
dnaCurrentSpriteColorArrayIndex .BYTE $00
dnaSpriteOriginalLeftColorArrayIndex       .BYTE $00
currentSpriteIndex              .BYTE $01
dnaCurrentPhase                 .BYTE $05

;----------------------------------------------------------------
; DNA_PropagatePreviousXPosToTheRight
;----------------------------------------------------------------
DNA_PropagatePreviousXPosToTheRight
        LDX #$27
PropagateToRightLoop   
        LDA dnaSpritesXPositionsArray - $01,X
        STA dnaSpritesXPositionsArray,X
        DEX
        BNE PropagateToRightLoop
        RTS

indexToNextXPosForHead .BYTE $00
newXPosForWave1   = $42
;----------------------------------------------------------------
; UpdateXPosArrays
;----------------------------------------------------------------
UpdateXPosArrays
        DEC actualSpeed
        BNE CalculateNewXPosForHead

        ; The speed setting determines how quickly
        ; the X pos values are propagated down the chains.
        LDA dnaCurrentSpeed
        STA actualSpeed
        JSR DNA_PropagatePreviousXPosToTheRight

CalculateNewXPosForHead   
        ; Get a new value for notionalNewXPosForWave2.
        JSR CalculateNotionalValueOfNewXPosForWave2

        DEC timeToNextUpdateCounterForWave1
        BNE ReturnFromUpdatingHead

        LDA initialTimeToNextUpdateForWave1
        STA timeToNextUpdateCounterForWave1

        ; Get newXPosForWave1, this will be
        ; added to notionalNewXPosForWave2. Both are
        ; sourced from the same array newXPosOffsetsArray.
        LDX indexToNextXPosForHead
        LDA newXPosOffsetsArray,X
        STA newXPosForWave1

        LDY dnaWave2Enabled
        BEQ UpdateHeadOfWave

        ; Halve the offset we will use if the right
        ; hand chain is enabled.
        CLC
        ROR 
        STA newXPosForWave1
UpdateHeadOfWave   
        ; Finally add out new X Pos value, add an
        ; offset to it and store it at the head of
        ; dnaSpritesXPositionsArray.
        LDA notionalNewXPosForWave2
        CLC
        ADC newXPosForWave1
        STA dnaSpritesXPositionsArray

        ; Get a new value for indexToNextXPosForHead
        ; for the next time around. Ensure it
        ; loops to start of array if greater than $40.
        TXA
        CLC
        ADC xPosOffsetForWave1
        TAX
        CPX #XPOS_OFFSETS_ARRAY_SIZE
        BMI UpdateNextXPos

        SEC
        SBC #XPOS_OFFSETS_ARRAY_SIZE
        TAX
UpdateNextXPos   
        STX indexToNextXPosForHead
ReturnFromUpdatingHead   
        RTS

xPosOffsetForWave1          .BYTE $02
timeToNextUpdateCounterForWave1       .BYTE $01
initialTimeToNextUpdateForWave1       .BYTE $05
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
        JMP DNA_UpdateSettingsBasedOnFrequency
        ; Returns

b1027   CMP #$17 ; 'X'
        BNE b1031
        ; X pressed: increase wave frequency.
        INC dnaWave1Frequency
        JMP DNA_UpdateSettingsBasedOnFrequency
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
; DNA_UpdateSettingsBasedOnFrequency
;----------------------------------------------------------------
DNA_UpdateSettingsBasedOnFrequency
        LDA dnaWave1Frequency
        AND #$1F
        TAX
        LDA timesToNextUpdateForFrequency,X
        STA initialTimeToNextUpdateForWave1
        STA timeToNextUpdateCounterForWave1
        LDA xPosOffsetsForFrequency,X
        STA xPosOffsetForWave1

        LDA dnaWave2Frequency
        AND #$1F
        TAX
        LDA timesToNextUpdateForFrequency,X
        STA initialTimeToNextUpdateForWave2
        STA timeToNextUpdateCounterForWave2
        LDA xPosOffsetsForFrequency,X
        STA xPosOffsetForWave2
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
        JMP DNA_UpdateSettingsBasedOnFrequency
        ; Returns

b1096   CMP #$1F ; V
        BNE b10A0
        ; 'V' pressed. Decrease wave 2 frequency.
        INC dnaWave2Frequency
        JMP DNA_UpdateSettingsBasedOnFrequency
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
        INC dnaCurrentColorSchemeLeft
        LDA dnaCurrentColorSchemeLeft
        CMP #$08
        BNE b10D9
        LDA #$00
        STA dnaCurrentColorSchemeLeft
b10D9   TAX
        LDA dnaColorSchemeLoPtr,X
        STA dnaLeftSpriteSentinelCheckLoByte
        STA dnaLeftSpriteColorLoByte
        LDA dnaColorSchemeHiPtr,X
        STA dnaLeftSpriteSentinelCheckHiByte
        STA dnaLeftSpriteColorHiByte
        LDA #$00
        STA dnaSpriteOriginalLeftColorArrayIndex
        RTS

b10F2   CMP #$03 ; F7
        BNE b111D
        ;F7 pressed - change colors
        INC dnaCurrentColorSchemeRight
        LDA dnaCurrentColorSchemeRight
        CMP #$08
        BNE b1105

        LDA #$00
        STA dnaCurrentColorSchemeRight
b1105   TAX
        LDA dnaColorSchemeLoPtr,X
        STA dnaRightSpriteSentinelCheckLoByte
        STA dnaRightSpriteColorLoByte
        LDA dnaColorSchemeHiPtr,X
        STA dnaRightSpriteSentinelCheckHiByte
        STA dnaRightSpriteColorHiByte
        LDA #$00
        STA dnaCurrentSpriteColorArrayIndex

b111D   CMP #$31 ; *
        BNE b1124
        ; * Pressed. Exit DNA.
        INC dnaPlayerPressedExit

b1124   RTS

dnaWave2Frequency           .BYTE $12
dnaPlayerPressedExit        .BYTE $00
dnaForegroundStarfieldXPosArray    .BYTE $4E,$05,$66,$FD,$12,$28,$CC,$87
                                   .BYTE $37,$93,$F5,$3B,$09,$9D,$A8,$7D
                                   .BYTE $DD,$67,$20,$C4,$AA,$35,$02,$74
dnaBackgroundStarfieldXPosArray    .BYTE $94,$E2,$33,$38,$C6,$DF,$23,$42
                                   .BYTE $71,$12,$29,$67,$7F,$EA,$A9,$34
                                   .BYTE $A5,$81,$01,$4C,$29,$36,$55,$98
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
        LDA dnaSpriteColorArray1,X
        STA $D025    ;Sprite Multi-Color Register 0
        INX
        LDA dnaSpriteColorArray1,X
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
        CMP #END_SENTINEL
        BNE b11C7
        LDA #$03
        STA currentMonochromIBallSprite
b11C7   RTS

indexToXPosDataArrayForWave2    .BYTE $00
indexToSpriteColor1Array        .BYTE $00
initialTimeToNextUpdateForWave2 .BYTE $03
timeToNextUpdateCounterForWave2 .BYTE $03
xPosOffsetForWave2              .BYTE $01
dnaWave2Enabled                 .BYTE $01
notionalNewXPosForWave2         .BYTE $00
XPOS_OFFSETS_ARRAY_SIZE         = $40
;----------------------------------------------------------------
; CalculateNotionalValueOfNewXPosForWave2
; This routine calculates a new value for 
; notionalNewXPosForWave2.
;----------------------------------------------------------------
CalculateNotionalValueOfNewXPosForWave2
        LDA dnaWave2Enabled
        BNE NewXPosWhenWave2Enabled

        ; If wave 2 is not enabled simply set $40
        ; as the initial X Pos (it will be incremented
        ; later).
        LDA #XPOS_OFFSETS_ARRAY_SIZE
        STA notionalNewXPosForWave2
ReturnFromNewXPos   
        RTS

NewXPosWhenWave2Enabled   
        DEC timeToNextUpdateCounterForWave2
        BNE ReturnFromNewXPos

        LDA initialTimeToNextUpdateForWave2
        STA timeToNextUpdateCounterForWave2

        ; If the right hand chain is enabled, get 
        ; a value from newXPosOffsetsArray which has
        ; $40 (64) potential values. This logic uses
        ; indexToXPosDataArrayForWave2 to get a value
        ; from it, halves it (ROR), and adds $40.
        LDX indexToXPosDataArrayForWave2
        LDA newXPosOffsetsArray,X
        CLC
        ROR         ; Halve it.
        CLC
        ADC #XPOS_OFFSETS_ARRAY_SIZE    ; Add $40.
        STA notionalNewXPosForWave2

        ; Add xPosOffsetForWave2 to indexToXPosDataArrayForWave2.
        ; Ensure it loops to start of array if greater than $40. 
        TXA
        CLC
        ADC xPosOffsetForWave2
        CMP #XPOS_OFFSETS_ARRAY_SIZE
        BMI NoLoopingRequired

        SEC
        SBC #XPOS_OFFSETS_ARRAY_SIZE
NoLoopingRequired   
        STA indexToXPosDataArrayForWave2
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
dnaSpriteColorArray1 .BYTE BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE,YELLOW
                     .BYTE CYAN,GREEN,PURPLE,RED,BLUE,END_SENTINEL
dnaSpriteColorArray2 .BYTE BLUE,GREEN,LTBLUE,LTGREEN,CYAN,END_SENTINEL
dnsSpriteColorArray3 .BYTE BROWN,ORANGE,YELLOW,ORANGE,BROWN,END_SENTINEL
dnaSpriteColorArray4 .BYTE BLACK,BLACK,BLACK,RED,BLACK,BLACK,YELLOW,END_SENTINEL
dnaSpriteColorArray5 .BYTE WHITE,GRAY3,LTGREEN,GRAY2,BLACK,BLACK
                     .BYTE BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,BLACK,END_SENTINEL
dnaSpriteColorArray6 .BYTE BLUE,LTBLUE,GRAY1,RED,GREEN,END_SENTINEL

dnaColorSchemeLoPtr .BYTE <dnaSpriteOriginalLeftColorArray,<dnaSpriteOriginalRightColorArray,<dnaSpriteColorArray1
                    .BYTE <dnaSpriteColorArray2,<dnsSpriteColorArray3,<dnaSpriteColorArray4
                    .BYTE <dnaSpriteColorArray5,<dnaSpriteColorArray6
dnaColorSchemeHiPtr .BYTE >dnaSpriteOriginalLeftColorArray,>dnaSpriteOriginalRightColorArray,>dnaSpriteColorArray1
                    .BYTE >dnaSpriteColorArray2,>dnsSpriteColorArray3,>dnaSpriteColorArray4
                    .BYTE >dnaSpriteColorArray5,>dnaSpriteColorArray6


dnaCurrentColorSchemeLeft   .BYTE $00
dnaCurrentColorSchemeRight   .BYTE $01
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

