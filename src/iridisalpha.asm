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

RAM_ACCESS_MODE                         = $01
planetPtrLo                             = $02
planetPtrHi                             = $03
spriteMSBXPosOffset                     = $06
planetTextureTopLayerPtr                = $10
planetTextureTopLayerPtrHi              = $11
planetTextureSecondFromTopLayerPtr      = $12
planetTextureSecondFromTopLayerPtrHi    = $13
planetTextureSecondFromBottomLayerPtr   = $14
planetTextureSecondFromBottomLayerPtrHi = $15
planetTextureBottomLayerPtr             = $16
planetTextureBottomLayerPtrHi           = $17
unusedVariable4                         = $18
unusedVariable5                         = $1C
bulletOffsetRate                        = $1F
currentMSBXPosOffset                    = $20
starFieldAnimationRate                  = $21
planetSurfaceDataPtrLo                  = $22
planetSurfaceDataPtrHi                  = $23
charSetDataPtrLo                        = $24
charSetDataPtrHi                        = $25
invertedCharToDraw                       = $26
structureRoutineLoPtr                   = $29
structureRoutineHiPtr                   = $2A
currentSoundEffectLoPtr                           = $30
currentSoundEffectHiPtr                           = $31
planetPtrLo2                            = $35
planetPtrHi2                            = $36
screenLintPtrTempLo                     = $3A
screenLintPtrTempHi                     = $3B
currentShipWaveDataLoPtr                = $40
currentShipWaveDataHiPtr                = $41
tempVarStorage                          = $42
tempLoPtr3                              = $43
tempHiPtr3                              = $44
tmpPtrLo                                = $45
tmpPtrHi                                = $46
tmpPtrZp47                              = $47
energyChangeCounter                     = $4A
levelDataPtrLo                          = $4E
levelDataPtrHi                          = $4F
lastKeyPressed                          = $C5
currentLevelInTopPlanetsLoPtr           = $F0
currentLevelInTopPlanetsHiPtr           = $F1
tempHiScoreInputStorage                 = $F8
tempLastBlastStorage                    = $F9
tempLoPtr1                              = $FC
tempHiPtr1                              = $FD
tempLoPtr                               = $FE
tempHiPtr                               = $FF
screenLinePtrLo                         = $0340
screenLinePtrHi                         = $0360
SCREEN_RAM                              = $0400
COLOR_RAM                               = $D800
Sprite0Ptr                              = $07F8
Sprite1Ptr                              = $07F9
Sprite2Ptr                              = $07FA
Sprite3Ptr                              = $07FB
Sprite4Ptr                              = $07FC
Sprite5Ptr                              = $07FD
Sprite6Ptr                              = $07FE
Sprite7PtrStarField                     = $07FF

.include "constants.asm"

*=$0801
;-------------------------------------------------------
; SYS 16384 ($4000)
; This launches the program from address $4000, i.e. MainControlLoop.
;-------------------------------------------------------
; $9E = SYS
; $31,$36,$33,$38,$34,$00 = 16384 ($4000 in hex)
.BYTE $0C,$08,$0A,$00,$9E,$31,$36,$33,$38,$34,$00

;-------------------------------------------------------
; LaunchCurrentProgram
;-------------------------------------------------------
*=$0810
LaunchCurrentProgram
        LDA #BLACK   ; $00
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA f7PressedOrTimedOutToAttractMode
        STA unusedVariable2

        LDA mifDNAPauseModeActive
        BEQ DNANotActive

        JMP LaunchDNA

DNANotActive   
        LDX #$F8
        JSR SetUpMainSound
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        JSR InitializeSpritesAndInterruptsForTitleScreen
        JMP EnterTitleScreenLoop

                                 .BYTE $00,$06,$02,$04,$05,$03,$07,$01
                                 .BYTE $01,$07,$03,$05,$04,$02,$06,$00
titleScreenColorsArray           .BYTE RED,ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE,GRAY1
                                 .BYTE GRAY1,BLUE,PURPLE,LTBLUE,GREEN,YELLOW,ORANGE,RED

f7PressedOrTimedOutToAttractMode .BYTE $02

;-------------------------------------------------------
; InitializeSpritesAndInterruptsForTitleScreen
;-------------------------------------------------------
InitializeSpritesAndInterruptsForTitleScreen

        ; Set the border and background to black.
        LDA #BLACK
        SEI
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA difficultySelected

        JSR ClearEntireScreen

        ; The '1' points screen memory to its default position
        ; in memory (i.e. SCREEN_RAM = $0400). The '8'
        ; selects $2000 as the location of the character set to
        ; use. $2000 = characterSetData
        LDA #$18
        STA $D018    ;VIC Memory Control Register

        ; Select 40 column display.
        LDA $D016    ;VIC Control Register 2
        AND #$E7
        ORA #$08
        STA $D016    ;VIC Control Register 2

        LDA #WHITE
        STA $D027    ;Sprite 0 Color

        LDA #$FF
        STA $D015    ;Sprite display Enable

        LDA #STARFIELD_SPRITE
        STA Sprite7PtrStarField

        ; Make sure all sprites appear in front of character
        ; data except for Sprite 7, which is the starfield.
        LDA #$80
        STA $D01B    ;Sprite to Background Display Priority

        ; Set up the our interrupt handler for the title
        ; screen. This will do all the animation and title
        ; music work.
        LDA #<TitleScreenInterruptHandler
        STA $0314    ;IRQ
        LDA #>TitleScreenInterruptHandler
        STA $0315    ;IRQ

        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        ; Set up the raster interrupt to happen when the
        ; raster reaches the position we specify in D012.
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1

        ; Set the position for triggering our interrupt.
        LDA #$10
        STA $D012    ;Raster Position
        CLI
        RTS

;-------------------------------------------------------
; EnterTitleScreenLoop
;-------------------------------------------------------
EnterTitleScreenLoop
        LDA #GRAY1
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JSR DrawStripesBehindTitle
        JSR DrawTitleScreenText

        ; Loop waiting for input
TitleScreenLoop
        JSR TitleScreenCheckInput
        LDA f7PressedOrTimedOutToAttractMode
        CMP #$04
        BEQ ExitTitleLoop

        ; Has user pressed fire?
        LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BNE TitleScreenLoop

        ; User has pressed fire, launch game.

        ;Turn off attract mode
        LDA #$00
        STA attractModeSelected
        RTS

ExitTitleLoop
        ;Turn on attract mode
        LDA #$FF
        STA attractModeSelected

        ;Wait for key to be released
b08E7   LDA lastKeyPressed
        CMP #$40 ; $40 means no key was pressed
        BNE b08E7
        RTS

;-------------------------------------------------------
; TitleScreenInterruptHandler
;-------------------------------------------------------
TitleScreenInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE TitleScreenAnimation

;-------------------------------------------------------
; ReturnFromTitleScreenInterruptHandler
;-------------------------------------------------------
ReturnFromTitleScreenInterruptHandler
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;-------------------------------------------------------
; ClearEntireScreen
;-------------------------------------------------------
ClearEntireScreen
        LDX #$00
        LDA #$20
b08FF   STA SCREEN_RAM,X
        STA SCREEN_RAM + LINE6_COL16,X
        STA SCREEN_RAM + LINE12_COL32,X
        STA SCREEN_RAM + LINE19_COL0,X
        DEX
        BNE b08FF
        RTS

;-------------------------------------------------------
; TitleScreenAnimation
; This handles all the activity in the title screen and is called
; roughly 60 times a second by the Raster Interrupt.
;-------------------------------------------------------
TitleScreenAnimation
        LDY titleScreenStarFieldAnimationCounter
        CPY #$0C
        BNE MaybeDoStarFieldOrTitleText

        JSR UpdateJumpingGilbyPositionsAndColors
        LDY #$10
        STY titleScreenStarFieldAnimationCounter

MaybeDoStarFieldOrTitleText   
        LDA titleScreenStarFieldYPosArray,Y
        BNE DoStarfieldAnimation

PaintTitleTextSprites
        JSR TitleScreenMutateStarfieldAnimationData

        LDA #$00
        STA titleScreenStarFieldAnimationCounter

        LDA #$10
        STA $D012    ;Raster Position

        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        JSR UpdateTitleTextSprites
        JSR MaybeUpdateSpriteColors
        JSR RecalculateJumpingGilbyPositions
        JSR PlayTitleScreenMusic
        JMP ReEnterInterrupt
        ; We're done, returns from function.

;-------------------------------------------------------
; DoStarfieldAnimation   
; Animate the star field in the title screen
;-------------------------------------------------------
DoStarfieldAnimation   
        ; A was loaded from titleScreenStarFieldYPosArray
        ; by the caller.
        STA $D00F    ;Sprite 7 Y Pos

        ; Set the X position of the star.
        LDA titleScreenStarFieldXPosArray + $01,Y
        STA $D00E    ;Sprite 7 X Pos

        ; Set the rest of the X position of the star
        ; if it's greater than 255.
        LDA titleScreenStarfieldMSBXPosArray + $01,Y
        AND #$01
        STA spriteMSBXPosOffset

        BEQ StarFieldSkipMSB

        LDA #$80
        STA spriteMSBXPosOffset
StarFieldSkipMSB   
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$7F
        ORA spriteMSBXPosOffset
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        ; Update the raster position for the next interrupt
        ; to the current line - 1. This will allow us to 
        ; draw the sprite multiple times on different lines.
        LDA titleScreenStarFieldYPosArray + $01,Y
        SEC
        SBC #$01
        STA $D012    ;Raster Position

        LDA titleScreenStarFieldColorsArrayLookUp,Y
        TAX
        LDA titleScreenColorsArray - $01,X
        STA $D02E    ;Sprite 7 Color

        LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2

        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        INC titleScreenStarFieldAnimationCounter

        JMP ReturnFromTitleScreenInterruptHandler

; Data for the title screen animation sequence
titleScreenStarFieldYPosArray           .BYTE $48,$4E,$54,$5A,$60,$66,$6C,$72
                                        .BYTE $78,$7E,$84,$8A,$90,$96,$9C,$A2
                                        .BYTE $A8,$AE,$B4,$BA,$C0,$C6,$CC,$D2
                                        .BYTE $D8,$DE,$E4,$EA,$F0,$F6
titleScreenStarFieldXPosArray           .BYTE $00,$3A,$1A,$C4,$1B,$94,$7B,$96
                                        .BYTE $5D,$4F,$B5,$18,$C7,$E1,$EB,$4A
                                        .BYTE $8F,$DA,$83,$6A,$B0,$FC,$68,$04
                                        .BYTE $10,$06,$A7,$B8,$19,$BB
titleScreenStarfieldMSBXPosArray        .BYTE $E4,$02,$02,$00,$03,$05,$02,$02
                                        .BYTE $01,$01,$01,$03,$01,$00,$01,$03
                                        .BYTE $01,$01,$04,$02,$01,$00,$01,$02
                                        .BYTE $01,$02,$01,$00,$01,$02,$02,$01
titleScreenStarFieldAnimationCounter    .BYTE $00
titleScreenStarFieldColorsArrayLookUp   .BYTE $03,$06,$07,$02,$01,$05,$03,$08
                                        .BYTE $04,$03,$02,$08,$06,$04,$02,$04
                                        .BYTE $06,$01,$07,$07,$05,$03,$02,$05
                                        .BYTE $07,$03,$06,$08,$05,$03,$06,$08
                                        .BYTE $07,$06,$03,$05,$06,$08,$06,$04
titleScreenStarfieldAnimationSeedArray  .BYTE $06,$01,$03,$02,$01,$01,$01,$01
                                        .BYTE $07,$02,$03,$02,$07,$02,$03,$02
                                        .BYTE $03,$02,$01,$03,$04,$01,$02,$01
                                        .BYTE $02,$03,$02,$01,$06,$01,$01,$01
                                        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                                        .BYTE $01,$01
gilbyColorsArray                        .BYTE YELLOW,GREEN,LTBLUE,BLACK,RED,ORANGE
starFieldOffset                         .BYTE $04,$01,$0F,$0C,$0B

;-------------------------------------------------------
; TitleScreenMutateStarfieldAnimationData
;-------------------------------------------------------
TitleScreenMutateStarfieldAnimationData
        LDX #$1E
        LDA #$00
        STA starFieldAnimationRate
b0A50   DEC titleScreenStarfieldAnimationSeedArray,X
        BNE b0A6D
        LDA titleScreenStarFieldColorsArrayLookUp - $01,X
        STA titleScreenStarfieldAnimationSeedArray,X
        LDA titleScreenStarFieldXPosArray,X
        CLC
        ADC starFieldOffset
        STA titleScreenStarFieldXPosArray,X
        LDA titleScreenStarfieldMSBXPosArray,X
        ADC #$00
        STA titleScreenStarfieldMSBXPosArray,X
b0A6D   DEX
        BNE b0A50
        RTS

;-------------------------------------------------------
; DrawStripesBehindTitle
;-------------------------------------------------------
DrawStripesBehindTitle
        LDX #$28
        LDA #$00
        STA shouldUpdateTitleScreenColors
DrawStripesLoop   
        LDA #RED
        STA COLOR_RAM + LINE2_COL39,X
        LDA #ORANGE
        STA COLOR_RAM + LINE3_COL39,X
        LDA #YELLOW
        STA COLOR_RAM + LINE4_COL39,X
        LDA #GREEN
        STA COLOR_RAM + LINE5_COL39,X
        LDA #LTBLUE
        STA COLOR_RAM + LINE6_COL39,X
        LDA #PURPLE
        STA COLOR_RAM + LINE7_COL39,X
        LDA #BLUE
        STA COLOR_RAM + LINE8_COL39,X
        LDA #$00 ; Stripe character
        STA SCREEN_RAM + LINE2_COL39,X
        STA SCREEN_RAM + LINE3_COL39,X
        STA SCREEN_RAM + LINE4_COL39,X
        STA SCREEN_RAM + LINE5_COL39,X
        STA SCREEN_RAM + LINE6_COL39,X
        STA SCREEN_RAM + LINE7_COL39,X
        STA SCREEN_RAM + LINE8_COL39,X
        DEX
        BNE DrawStripesLoop

        LDX #$06
b0AB7   LDA titleScreenColorsArray - $01,X
        STA gilbyColorsArray,X
        DEX
        BNE b0AB7

        LDA #$01
        STA shouldUpdateTitleScreenColors
        RTS

;-------------------------------------------------------
; UpdateTitleTextSprites
; Write the title text to the title screen using 6 sprites.
;-------------------------------------------------------
UpdateTitleTextSprites
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$80
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        LDX #$06
PaintSpriteLettersLoop   
        ; Assign the sprite.
        LDA titleTextSpriteArray,X
        STA Sprite0Ptr - $01,X

        ; Shift the value in X left 1 bit and assign to Y.
        ; So e.g. 6 becomes 12, 5 becomes 10, 4 becomes 8,
        ; 3 becomes 6 and so on. This allows us to use Y
        ; as an offset to the appropriate item in $D000-
        ; $D012 for updating the sprite's position.
        TXA
        ASL
        TAY

        ; Update the X Position of the sprite
        LDA titleTextXPosArray - $01,X
        STA $D000 - $02,Y

        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA titleTextMSBXPosArray,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        ; Update the Y position of the sprite
        LDA #$40
        STA $D000 - $01,Y
        DEX
        BNE PaintSpriteLettersLoop

        ; Write the 'Alpha' sprite to the right hand of
        ; the screen.
        LDA #$3F
        STA $D01C    ;Sprites Multi-Color Mode Select
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        STA $D017    ;Sprites Expand 2x Vertical (Y)

        ; Set its position.
        LDA #$FF
        STA $D00C    ;Sprite 6 X Pos
        LDA #$70
        STA $D00D    ;Sprite 6 Y Pos

        ; Set its color.
        LDA #$0B
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$00
        STA $D026    ;Sprite Multi-Color Register 1
        LDA #WHITE
        STA $D02D    ;Sprite 6 Color

        LDA #ALPHA
        STA Sprite6Ptr

        RTS

titleTextXPosArray            .BYTE $20,$50,$80,$B0,$E0
titleTextMSBXPosArray         .BYTE $10,$00,$00,$00,$00,$00
titleTextSpriteArray          .BYTE $20,BIG_I,BIG_R,BIG_I,BIG_D,BIG_I,BIG_S
shouldUpdateTitleScreenColors .BYTE $01
;-------------------------------------------------------
; MaybeUpdateSpriteColors
;-------------------------------------------------------
MaybeUpdateSpriteColors
        LDA shouldUpdateTitleScreenColors
        BNE UpdateTitleScreenSpriteColors

ReturnFromUpdateColors   
        RTS

updateTitleColorsInterval   .BYTE $04
;-------------------------------------------------------
; UpdateTitleScreenSpriteColors   
;-------------------------------------------------------
UpdateTitleScreenSpriteColors   
        DEC updateTitleColorsInterval
        BNE ReturnFromUpdateColors
        LDA #$04
        STA updateTitleColorsInterval

        LDX #$00
        LDA gilbyColorsArray
        PHA
UpdateSpriteColorsLoop   
        LDA gilbyColorsArray + $01,X
        STA $D027,X  ;Sprite 0 Color
        STA gilbyColorsArray,X
        INX
        CPX #$06
        BNE UpdateSpriteColorsLoop

        ; Make sure the 'Alpha' sprite stays white.
        PLA
        STA gilbyColorsArray + $05
        STA $D02C    ;Sprite 5 Color
        RTS

;-------------------------------------------------------
; UpdateJumpingGilbyPositionsAndColors
;-------------------------------------------------------
UpdateJumpingGilbyPositionsAndColors
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$01
        STA $D026    ;Sprite Multi-Color Register 1
        LDA #$00
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        LDA #$7F
        STA $D01C    ;Sprites Multi-Color Mode Select

        ; Loop through the gilby sprites in the title screen and
        ; update their position and color
        LDX #$00
UpdateJumpingGilbiesLoop   
        TXA
        ASL
        TAY
        LDA titleScreenGilbiesXPosArray,X
        ASL
        STA $D000,Y  ;Sprite 0 X Pos
        BCC SkipGilbyMSBXPos
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA titleScreenGilbiesMSBXPosArray,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JMP UpdateYPosJumpingGilbies

SkipGilbyMSBXPos   
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND titleScreenGilbiesMSBXPosOffset,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate

UpdateYPosJumpingGilbies
        LDA titleScreenGilbiesYPosARray,X
        STA $D001,Y  ;Sprite 0 Y Pos

        LDA currentTitleScreenGilbySpriteValue
        STA Sprite0Ptr,X

        ; Update Gilby color.
        LDA titleScreenColorsArray,X
        STA $D027,X  ;Sprite 0 Color

        INX
        CPX #$07
        BNE UpdateJumpingGilbiesLoop
        RTS

titleScreenGilbiesYPosARray       .BYTE $B2,$B6,$BB,$C1,$D0,$C8,$C1
titleScreenGilbiesXPosArray       .BYTE $54,$58,$5C,$60,$64,$68,$6C
titleScreenGilbiesYPosOffsetArray .BYTE $FC,$FB,$FA,$F9,$08,$07,$06
;-------------------------------------------------------
; RecalculateJumpingGilbyPositions
;-------------------------------------------------------
RecalculateJumpingGilbyPositions
        LDX #$00
TitleScreenUpdateSpritesLoop   
        LDA titleScreenGilbiesYPosARray,X
        SEC
        SBC titleScreenGilbiesYPosOffsetArray,X
        STA titleScreenGilbiesYPosARray,X
        DEC titleScreenGilbiesYPosOffsetArray,X
        LDA titleScreenGilbiesYPosOffsetArray,X
        CMP #$F8
        BNE DontResetTitleSpritesYPos
        LDA #$08
        STA titleScreenGilbiesYPosOffsetArray,X
        LDA #$D0
        STA titleScreenGilbiesYPosARray,X

DontResetTitleSpritesYPos
        INC titleScreenGilbiesXPosArray,X
        LDA titleScreenGilbiesXPosArray,X
        CMP #$C0
        BNE DontResetTitleSpritesXPos

        LDA #$08
        STA titleScreenGilbiesXPosArray,X

DontResetTitleSpritesXPos   
        INX
        CPX #$07
        BNE TitleScreenUpdateSpritesLoop

        DEC titleScreenSpriteCycleCounter
        BNE ReturnFromTitleScreenUpdateSprites

        LDA #$04
        STA titleScreenSpriteCycleCounter

        ; Cycle the title screen gilby sprite between $C1 and $C8.
        ; For some reason, we use the letter 'I' from the 'IRIDIS
        ; ALPHA' title screen text to double as the storage for
        ; this value.
        ; The effect of cycling the sprite this way is to create an
        ; animated effect as it bounces along the screen.
        INC currentTitleScreenGilbySpriteValue
        LDA currentTitleScreenGilbySpriteValue
        CMP #LAND_GILBY8
        BNE ReturnFromTitleScreenUpdateSprites
        LDA #LAND_GILBY1
        STA currentTitleScreenGilbySpriteValue

ReturnFromTitleScreenUpdateSprites   
        RTS

.enc "petscii"  ;define an ascii->petscii encoding
        .cdef "  ", $20  ;characters
        .cdef ",,", $2c  ;characters
        .cdef "--", $ad  ;characters
        .cdef "..", $ae  ;characters
        .cdef "AZ", $c1
        .cdef "az", $41
        .cdef "11", $31
.enc "none"

titleScreenGilbiesMSBXPosArray     .BYTE $01,$02,$04,$08,$10,$20,$40
titleScreenGilbiesMSBXPosOffset    .TEXT $FE,$FD,$FB,$F7,$EF,$DF,$BF
currentTitleScreenGilbySpriteValue .TEXT $C1

.enc "petscii" 
titleScreenTextLine1               .TEXT "IRIDIS ALPHA"
.enc "none"
                                   .TEXT ".....  HARD AND FAST ZAPPING"
titleScreenTextLine2               .TEXT "PRESS FIRE TO BEGIN PLAY.. ONCE STARTED,"
.enc "petscii" 
titleScreenTextLine3               .TEXT "F1 FOR PAUSE MODE     Q TO QUIT THE "
.enc "none"
                                   .TEXT "GAME"
titleScreenTextLine4               .TEXT "CREATED BY JEFF MINTER...SPACE EASY/HARD"
titleScreenTextLine5               .TEXT "LAST GILBY HIT 0000000; MODE IS NOW EASY"
;-------------------------------------------------------
; DrawTitleScreenText
;-------------------------------------------------------
DrawTitleScreenText
        LDX #$28
DrawTitleTextLoop   
        LDA titleScreenTextLine1 - $01,X
        AND #ASCII_BITMASK
        STA SCREEN_RAM + LINE11_COL39,X
        LDA titleScreenTextLine2 - $01,X
        AND #ASCII_BITMASK
        STA SCREEN_RAM + LINE13_COL39,X
        LDA titleScreenTextLine3 - $01,X
        AND #ASCII_BITMASK
        STA SCREEN_RAM + LINE15_COL39,X
        LDA titleScreenTextLine4 - $01,X
        AND #ASCII_BITMASK
        STA SCREEN_RAM + LINE17_COL39,X
        LDA titleScreenTextLine5 - $01,X
        AND #ASCII_BITMASK
        STA SCREEN_RAM + LINE19_COL39,X

        LDA #GRAY2
        STA COLOR_RAM + LINE11_COL39,X
        STA COLOR_RAM + LINE13_COL39,X
        STA COLOR_RAM + LINE15_COL39,X
        STA COLOR_RAM + LINE17_COL39,X
        STA COLOR_RAM + LINE19_COL39,X
        DEX
        BNE DrawTitleTextLoop

        LDX #$06
LoadLastScoreLoop   
        LDA lastBlastScore,X
        STA SCREEN_RAM + LINE20_COL15,X
        DEX
        BPL LoadLastScoreLoop
        RTS

;-------------------------------------------------------
; The DNA pause mode mini game. Accessed by pressing *
; from within the Made in France pause mode mini game.
;-------------------------------------------------------
.include "dna.asm"


; This is the frequency table containing all the 'notes' from 
; octaves 4 to 8. It's very similar to:
;  http://codebase.c64.org/doku.php?id=base:ntsc_frequency_table
; The 16 bit value you get from feeding the lo and hi bytes into 
; the SID registers (see PlayNoteVoice1 and PlayNoteVoice2) plays
; the appropriate note. Each 16 bit value is based off a choice of
; based frequency. This is usually 440hz, but not here. 
;
; In fact the values here are the standard ones given in the
; Commodor 64 Programmer's Reference Guide. The decimal values are 
; below in the table in Appendix D there: 
;   +-----------------------------+-----------------------------------------+
;   |        MUSICAL NOTE         |             OSCILLATOR FREQ             |
;   +-------------+---------------+-------------+-------------+-------------+
;   |     NOTE    |    OCTAVE     |   DECIMAL   |      HI     |     LOW     |
;   +-------------+---------------+-------------+-------------+-------------+
;   |      48     |      C-3      |     2145    |       8     |      97     |
;   |      49     |      C#-3     |     2273    |       8     |     225     |
;   |      50     |      D-3      |     2408    |       9     |     104     |
;   |      51     |      D#-3     |     2551    |       9     |     247     |
;   |      52     |      E-3      |     2703    |      10     |     143     |
;   |      53     |      F-3      |     2864    |      11     |      48     |
;   |      54     |      F#-3     |     3034    |      11     |     218     |
;   |      55     |      G-3      |     3215    |      12     |     143     |
;   |      56     |      G#-3     |     3406    |      13     |      78     |
;   |      57     |      A-3      |     3608    |      14     |      24     |
;   |      58     |      A#-3     |     3823    |      14     |     239     |
;   |      59     |      B-3      |     4050    |      15     |     210     |
;   |      64     |      C-4      |     4291    |      16     |     195     |
;   |      65     |      C#-4     |     4547    |      17     |     195     |
;   |      66     |      D-4      |     4817    |      18     |     209     |
;   |      67     |      D#-4     |     5103    |      19     |     239     |
;   |      68     |      E-4      |     5407    |      21     |      31     |
;   |      69     |      F-4      |     5728    |      22     |      96     |
;   |      70     |      F#-4     |     6069    |      23     |     181     |
;   |      71     |      G-4      |     6430    |      25     |      30     |
;   |      72     |      G#-4     |     6812    |      26     |     156     |
;   |      73     |      A-4      |     7217    |      28     |      49     |
;   |      74     |      A#-4     |     7647    |      29     |     223     |
;   |      75     |      B-4      |     8101    |      31     |     165     |
;   |      80     |      C-5      |     8583    |      33     |     135     |
;   |      81     |      C#-5     |     9094    |      35     |     134     |
;   |      82     |      D-5      |     9634    |      37     |     162     |
;   |      83     |      D#-5     |    10207    |      39     |     223     |
;   |      84     |      E-5      |    10814    |      42     |      62     |
;   |      85     |      F-5      |    11457    |      44     |     193     |
;   |      86     |      F#-5     |    12139    |      47     |     107     |
;   |      87     |      G-5      |    12860    |      50     |      60     |
;   |      88     |      G#-5     |    13625    |      53     |      57     |
;   |      89     |      A-5      |    14435    |      56     |      99     |
;   |      90     |      A#-5     |    15294    |      59     |     190     |
;   |      91     |      B-5      |    16203    |      63     |      75     |
;   |      96     |      C-6      |    17167    |      67     |      15     |
;   |      97     |      C#-6     |    18188    |      71     |      12     |
;   |      98     |      D-6      |    19269    |      75     |      69     |
;   |      99     |      D#-6     |    20415    |      79     |     191     |
;   |     100     |      E-6      |    21629    |      84     |     125     |
;   |     101     |      F-6      |    22915    |      89     |     131     |
;   |     102     |      F#-6     |    24278    |      94     |     214     |
;   |     103     |      G-6      |    25721    |     100     |     121     |
;   |     104     |      G#-6     |    27251    |     106     |     115     |
;   |     105     |      A-6      |    28871    |     112     |     199     |
;   |     106     |      A#-6     |    30588    |     119     |     124     |
;   |     107     |      B-6      |    32407    |     126     |     151     |
;   |     112     |      C-7      |    34334    |     134     |      30     |
;   |     113     |      C#-7     |    36376    |     142     |      24     |
;   |     114     |      D-7      |    38539    |     150     |     139     |
;   |     115     |      D#-7     |    40830    |     159     |     126     |
;   |     116     |      E-7      |    43258    |     168     |     250     |
;   |     117     |      F-7      |    45830    |     179     |       6     |
;   |     118     |      F#-7     |    48556    |     189     |     172     |
;   |     119     |      G-7      |    51443    |     200     |     243     |
;   |     120     |      G#-7     |    54502    |     212     |     230     |
;   |     121     |      A-7      |    57743    |     225     |     143     |
;   |     122     |      A#-7     |    61176    |     238     |     248     |
;   |     123     |      B-7      |    64814    |     253     |      46     |
;   +-------------+---------------+-------------+-------------+-------------+
                    ;      C   C#  D   D#  E   F   F#  G   G#  A   A#  B
titleMusicHiBytes   .BYTE $08,$08,$09,$09,$0A,$0B,$0B,$0C,$0D,$0E,$0E,$0F  ; 4
                    .BYTE $10,$11,$12,$13,$15,$16,$17,$19,$1A,$1C,$1D,$1F  ; 5
                    .BYTE $21,$23,$25,$27,$2A,$2C,$2F,$32,$35,$38,$3B,$3F  ; 6
                    .BYTE $43,$47,$4B,$4F,$54,$59,$5E,$64,$6A,$70,$77,$7E  ; 7
                    .BYTE $86,$8E,$96,$9F,$A8,$B3,$BD,$C8,$D4,$E1,$EE,$FD  ; 8

                    ;      C   C#  D   D#  E   F   F#  G   G#  A   A#  B
titleMusicLowBytes  .BYTE $61,$E1,$68,$F7,$8F,$30,$DA,$8F,$4E,$18,$EF,$D2  ; 4
                    .BYTE $C3,$C3,$D1,$EF,$1F,$60,$B5,$1E,$9C,$31,$DF,$A5  ; 5
                    .BYTE $87,$86,$A2,$DF,$3E,$C1,$6B,$3C,$39,$63,$BE,$4B  ; 6
                    .BYTE $0F,$0C,$45,$BF,$7D,$83,$D6,$79,$73,$C7,$7C,$97  ; 7
                    .BYTE $1E,$18,$8B,$7E,$FA,$06,$AC,$F3,$E6,$8F,$F8,$2E  ; 8

; This seeds the title music. Playing around with these first
; four bytes alters the first few seconds of the title music.
; The routine for the title music uses these 4 bytes to determine
; the notes to play.
; This array is periodically replenished from titleMusicSeedArray by
; SelectNewNotesToPlay.
titleMusicNoteArray .BYTE $00,$07,$0C,$07

; These variables are used to choose a value from titleMusicNoteArray, 
; mutate it, and then use that as an index into titleMusicHiBytes/titleMusicLowBytes
; which gives PlayNoteVoice1/2/3 a note to play.
voice3NoteDuration            .BYTE $01
voice2NoteDuration            .BYTE $01
voice1NoteDuration            .BYTE $25
numberOfNotesToPlayInTune     .BYTE $85
voice3IndexToMusicNoteArray   .BYTE $00
voice2IndexToMusicNoteArray   .BYTE $01
voice1IndexToMusicNoteArray   .BYTE $02
notesPlayedSinceLastKeyChange .BYTE $02
offsetForNextVoice2Note       .BYTE $0E
offsetForNextVoice1Note       .BYTE $07
offsetForNextVoice3Note       .BYTE $0E
;-------------------------------------------------------
; PlayTitleScreenMusic
;-------------------------------------------------------
PlayTitleScreenMusic
        DEC baseNoteDuration
        BEQ MaybeStartNewTune
        RTS

MaybeStartNewTune   
        LDA previousBaseNoteDuration
        STA baseNoteDuration

        DEC numberOfNotesToPlayInTune
        BNE MaybePlayVoice1

        ; Set up a new tune.
        LDA #$C0 ; 193
        STA numberOfNotesToPlayInTune

        ; This is what will eventually time us out of playing
        ; the title music and enter attract mode.
        INC f7PressedOrTimedOutToAttractMode

        LDX notesPlayedSinceLastKeyChange
        LDA titleMusicNoteArray,X
        STA offsetForNextVoice1Note

        ; We'll only select a new tune when we've reached the
        ; beginning of a new 16 bar structure.
        INX
        TXA
        AND #$03
        STA notesPlayedSinceLastKeyChange
        BNE MaybePlayVoice1

        JSR SelectNewNotesToPlay

MaybePlayVoice1   
        DEC voice1NoteDuration
        BNE MaybePlayVoice2

        LDA #$30
        STA voice1NoteDuration

        LDX voice1IndexToMusicNoteArray
        LDA titleMusicNoteArray,X
        CLC
        ADC offsetForNextVoice1Note
        TAY
        STY offsetForNextVoice2Note

        JSR PlayNoteVoice1

        INX
        TXA
        AND #$03
        STA voice1IndexToMusicNoteArray

MaybePlayVoice2   
        DEC voice2NoteDuration
        BNE MaybePlayVoice3

        LDA #$0C
        STA voice2NoteDuration
        LDX voice2IndexToMusicNoteArray
        LDA titleMusicNoteArray,X
        CLC
        ADC offsetForNextVoice2Note

        ; Use this new value to change the key of the next four
        ; notes played by voice 3. 
        STA offsetForNextVoice3Note

        TAY
        JSR PlayNoteVoice2
        INX
        TXA
        AND #$03
        STA voice2IndexToMusicNoteArray

MaybePlayVoice3   
        DEC voice3NoteDuration
        BNE ReturnFromTitleScreenMusic

        LDA #$03
        STA voice3NoteDuration

        ; Play the note currently pointed to by 
        ; voice3IndexToMusicNoteArray in titleMusicNoteArray.
        LDX voice3IndexToMusicNoteArray
        LDA titleMusicNoteArray,X
        CLC
        ADC offsetForNextVoice3Note
        TAY
        JSR PlayNoteVoice3

        ; Move voice3IndexToMusicNoteArray to the next
        ; position in titleMusicNoteArray.
        INX
        TXA
        ; Since it's only 4 bytes long ensure we wrap
        ; back to 0 if it's greater than 3.
        AND #$03
        STA voice3IndexToMusicNoteArray

ReturnFromTitleScreenMusic   
        RTS

;-------------------------------------------------------
; PlayNoteVoice1
;-------------------------------------------------------
PlayNoteVoice1
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA titleMusicLowBytes,Y
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        RTS

;-------------------------------------------------------
; PlayNoteVoice2
;-------------------------------------------------------
PlayNoteVoice2
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        LDA titleMusicLowBytes,Y
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        RTS

;----------------------------------------------------------
; PlayNoteVoice3
;----------------------------------------------------------
PlayNoteVoice3
        LDA #$21
        STA $D412    ;Voice 3: Control Register
        LDA titleMusicLowBytes,Y
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        RTS

;-------------------------------------------------------
; SetUpMainSound
;-------------------------------------------------------
SetUpMainSound
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

; This is used to replenish titleMusicNoteArray with seed valuse
; for the procedurally generated title screen music.
titleMusicSeedArray .BYTE $00,$03,$06,$08
                    .BYTE $00,$0C,$04,$08
                    .BYTE $00,$07,$00,$05
                    .BYTE $05,$00,$00,$05
                    .BYTE $00,$06,$09,$05
                    .BYTE $02,$04,$03,$04
                    .BYTE $03,$07,$03,$00
                    .BYTE $04,$08,$0C,$09
                    .BYTE $07,$08,$04,$07
                    .BYTE $00,$04,$07,$0E
                    .BYTE $00,$00,$00,$07
                    .BYTE $07,$04,$00,$0C
                    .BYTE $04,$07,$00,$0C
                    .BYTE $07,$08,$0A,$08
                    .BYTE $0C,$00,$0C,$03
                    .BYTE $0C,$03,$07,$00
;--------------------------------------------------------
; SelectNewNotesToPlay
;--------------------------------------------------------
SelectNewNotesToPlay
        ; Get a random value between 0 and 15.
        JSR PutProceduralByteInAccumulator
        AND #$0F
        ; Jump to InitializeSeedLoop if it's zero.
        BEQ InitializeSeedLoop

        ; Otherwise multiply it by 4. We do this so that
        ; the 4-byte sequence we choose always starts at
        ; a 4-byte offset in titleMusicSeedArray.
        TAX
        LDA #$00
MultiplyRandomNumBy4   
        CLC
        ADC #$04
        DEX
        BNE MultiplyRandomNumBy4

        ; Fill titleMusicNoteArray with the next four bytes from
        ; titleMusicSeedArray.

InitializeSeedLoop   
        ; Put our random number in Y and use it as index into
        ; the seed array.
        TAY
        ; Initialize X to 0, we will use this to iterate up to
        ; 4 bytes for pulling from titleMusicSeedArray.
        LDX #$00

        ; Pick the first 4 bytes in titleMusicSeedArray from our
        ; randomly chosen offset and put them in
        ; titleMusicNoteArray.
MusicSeedArrayLoop   
        LDA titleMusicSeedArray,Y
        STA titleMusicNoteArray,X
        INY
        INX
        CPX #$04
        BNE MusicSeedArrayLoop

        ; Get a rnadom number between 0 and 3, add 1 to it,
        ; and use that as the basic quanrity for note duration.
        JSR PutProceduralByteInAccumulator
        AND #$03
        CLC
        ADC #$01
        STA baseNoteDuration
        STA previousBaseNoteDuration
        RTS

baseNoteDuration              .BYTE $01
previousBaseNoteDuration      .BYTE $01

titleScreenSpriteCycleCounter .BYTE $04
;-------------------------------------------------------
; TitleScreenCheckInput
;-------------------------------------------------------
TitleScreenCheckInput
        LDA lastKeyPressed
        CMP #$40 ; $40 means no key was pressed
        BNE b1658
        RTS

b1658   LDY #$00
        STY f7PressedOrTimedOutToAttractMode
        CMP #$3C ; Space pressed?
        BNE b168F

        ; Space pressed.
        LDA difficultySelected
        EOR #$01
        STA difficultySelected
        BNE b167B ; Difficulty hard?

        ;Update difficulty easy.
        LDX #$03
b166D   LDA txtEasy,X
        AND #$3F
        STA SCREEN_RAM + LINE20_COL36,X
        DEX
        BPL b166D
        JMP LoopUntilKeyReleased

        ;Update difficulty hard.
b167B   LDX #$03
b167D   LDA txtHard,X
        AND #$3F
        STA SCREEN_RAM + LINE20_COL36,X
        DEX
        BPL b167D

LoopUntilKeyReleased
        ; Wait to release key.
        LDA lastKeyPressed
        CMP #$40 ; $40 means no key was pressed
        BNE LoopUntilKeyReleased
ReturnFromCheckInput   RTS


        ;F7 pressed?
b168F   CMP #$03
        BNE ReturnFromCheckInput
        LDA #$04
        STA f7PressedOrTimedOutToAttractMode
        STA unusedVariable2
        RTS

txtEasy   .TEXT "EASY"
txtHard   .TEXT "UGH!"
;-------------------------------------------------
; PutProceduralByteInAccumulator
; This function is self-modifying. Every time it
; is called it increments the address that
; sourceOfSeedBytes points to. Since sourceOfSeedBytes
; intially points to $9A00, it will point to $9A01
; after the first time it's called, $9A02 after the
; second time it's called - and so on.
;--------------------------------------------------
PutProceduralByteInAccumulator
srcOfProceduralBytes   =*+$01
        LDA sourceOfSeedBytes
        INC srcOfProceduralBytes
        RTS


*=$2000
.include "graphics/charset.asm"
.include "graphics/sprites.asm"

difficultySelected   =*+$01
;-------------------------------------------------------
; MainControlLoop
; Execution starts here
;-------------------------------------------------------
MainControlLoop
        LDA #$00
        SEI
p4003   LDA #<MainControlLoopInterruptHandler
        STA $318    ;NMI
        LDA #>MainControlLoopInterruptHandler
        STA $319    ;NMI
        LDA #$80
        STA LINE16_COL17
        LDX #$F8
        TXS
        LDA #$01
        STA lowerPlanetActivated
        LDA #$02
        STA gilbiesLeft
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$00
        STA mifDNAPauseModeActive
        STA spriteCollidedWithBackground

        ; Display the title screen. We'll stay in here, until the
        ; player presses fire or we time out and go into attract mode.
        JSR EnterMainTitleScreen

        JSR DetectGameOrAttractMode
        LDA #$36
        STA RAM_ACCESS_MODE
        LDA difficultySelected
        STA difficultySetting
        LDA #$01
        STA currentTopPlanet
        STA currentBottomPlanet
        LDA #$00
        STA bonusBountiesEarned
        STA planetTextureTopLayerPtr
        STA bonusAwarded
        STA planetTextureSecondFromBottomLayerPtr
        STA unusedVariable4
        STA unusedVariable5
        STA extraAmountToDecreaseEnergyByTopPlanet
        STA extraAmountToDecreaseEnergyByBottomPlanet
        STA gilbyHasJustDied
        STA bonusPhaseEarned
        STA bonusPhaseCounter
        STA setToZeroIfOnUpperPlanet

        ; Point at the planet data for the first planet.
        ; The planet data starts at $8000. Each planet
        ; has 4 lines or layers.
        LDA #>planetOneTopLayer
        STA planetTextureTopLayerPtrHi
        LDA #>planetOneSecondFromTopLayer
        STA planetTextureSecondFromTopLayerPtrHi
        LDA #>planetOneSecondFromBottomLayer
        STA planetTextureSecondFromBottomLayerPtrHi
        LDA #>planetOneBottomLayer
        STA planetTextureBottomLayerPtrHi

        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        JSR ClearPlanetTextureCharsets
        JMP PrepareToLaunchIridisAlpha

;-------------------------------------------------------
; ClearPlanetTextureCharsets
;-------------------------------------------------------
ClearPlanetTextureCharsets
        LDA #$00
        TAX
b4084   STA upperPlanetSurfaceCharset,X
        STA upperPlanetHUDCharset,X
        STA lowerPlanetSurfaceCharset,X
        STA lowerPlanetHUDCharset,X
        DEX
        BNE b4084
        RTS

;-------------------------------------------------------
; PrepareToLaunchIridisAlpha
;-------------------------------------------------------
PrepareToLaunchIridisAlpha

        LDX #$05
b4096   LDA #$08
        STA unusedVariableArray,X
        DEX
        BNE b4096

        LDX #$06
b40A0   LDA #$30
        STA currentBonusBountyPtr,X
        DEX
        BPL b40A0

        JSR GeneratePlanetSurface
        JSR InitializeStarfieldSprite
        LDA #$00
        STA oldTopPlanetIndex
        LDA #$00
        STA oldBottomPlanetIndex
        LDA #ORANGE
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA #BROWN
        STA $D023    ;Background Color 2, Multi-Color Register 1
        JSR PrepareScreen
        JMP InitializeSprites


energyLevelToGilbyColorMap .BYTE $00,$06,$02,$04,$05,$03,$07,$01
pauseModeSelected          .BYTE $00
reasonGilbyDied            .BYTE $03
gilbyHasJustDied           .BYTE $00

;-------------------------------------------------------
; 'Made In France' - a pause mode mini game.
; Accessed by pressing F1 during play.
;-------------------------------------------------------
.include "madeinfrance.asm"

;-------------------------------------------------------
; The data for drawing the planets.
;-------------------------------------------------------
planet2Level5Data         = $1000
planet3Level7Data         = $1078
planet2Level6Data         = $10C8
planet1Level11Data        = $1140
planet1Level12Data        = $11B8
planet3Level9Data         = $1230
planet5Level9Data         = $1280
planet3Level12Data        = $12D0
planet4Level2Data         = $1320
planet1Level8Data         = $1370
planet1Level14Data        = $13C0
planet1Level13Data        = $13E8
planet4Level7Data         = $1438
planet5Level12Data        = $1460
planet4Level14Data        = $14B0
planet5Level10Data        = $1500
planet2Level4Data         = $1528
planet5Level3Data         = $1578
planet3Level11Data        = $1640
planet5Level11Data        = $1690
planet5Level4Data         = $1708
planet4Level8Data         = $1758
planet4Level9Data         = $17A8
planet1Level5Data         = $1800
lickerShipWaveData        = $1118
planet1Level8Data2ndStage = $1398
spinningRings             = $1850
planet1Level5Data3rdStage = $1878


; A block of pointers for each planet, and a pointer for each of the
; fifteen levels in each planet.
levelDataPerPlanet
             .BYTE >planet1Level1Data,<planet1Level1Data,>planet1Level2Data,<planet1Level2Data
             .BYTE >planet1Level3Data,<planet1Level3Data,>planet1Level4Data,<planet1Level4Data
             .BYTE >planet1Level5Data,<planet1Level5Data,>planet1Level6Data,<planet1Level6Data
             .BYTE >planet1Level7Data,<planet1Level7Data,>planet1Level8Data,<planet1Level8Data
             .BYTE >planet1Level9Data,<planet1Level9Data,>planet1Level10Data,<planet1Level10Data
             .BYTE >planet1Level11Data,<planet1Level11Data,>planet1Level12Data,<planet1Level12Data
             .BYTE >planet1Level13Data,<planet1Level13Data,>planet1Level14Data,<planet1Level14Data
             .BYTE >planet1Level15Data,<planet1Level15Data,>planet1Level16Data,<planet1Level16Data
             .BYTE >planet1Level17Data,<planet1Level17Data,>planet1Level18Data,<planet1Level18Data
             .BYTE >planet1Level19Data,<planet1Level19Data,>planet1Level20Data,<planet1Level20Data


             .BYTE >planet2Level1Data,<planet2Level1Data,>planet2Level2Data,<planet2Level2Data
             .BYTE >planet2Level3Data,<planet2Level3Data,>planet2Level4Data,<planet2Level4Data
             .BYTE >planet2Level5Data,<planet2Level5Data,>planet2Level6Data,<planet2Level6Data
             .BYTE >planet2Level7Data,<planet2Level7Data,>planet2Level8Data,<planet2Level8Data
             .BYTE >planet2Level9Data,<planet2Level9Data,>planet2Level10Data,<planet2Level10Data
             .BYTE >planet2Level11Data,<planet2Level11Data,>planet2Level12Data,<planet2Level12Data
             .BYTE >planet2Level13Data,<planet2Level13Data,>planet2Level14Data,<planet2Level14Data
             .BYTE >planet2Level15Data,<planet2Level15Data,>planet2Level16Data,<planet2Level16Data
             .BYTE >planet2Level17Data,<planet2Level17Data,>planet2Level18Data,<planet2Level18Data
             .BYTE >planet2Level19Data,<planet2Level19Data,>planet2Level20Data,<planet2Level20Data

             .BYTE >planet3Level1Data,<planet3Level1Data,>planet3Level2Data,<planet3Level2Data
             .BYTE >planet3Level3Data,<planet3Level3Data,>planet3Level4Data,<planet3Level4Data
             .BYTE >planet3Level5Data,<planet3Level5Data,>planet3Level6Data,<planet3Level6Data
             .BYTE >planet3Level7Data,<planet3Level7Data,>planet3Level8Data,<planet3Level8Data
             .BYTE >planet3Level9Data,<planet3Level9Data,>planet3Level10Data,<planet3Level10Data
             .BYTE >planet3Level11Data,<planet3Level11Data,>planet3Level12Data,<planet3Level12Data
             .BYTE >planet3Level13Data,<planet3Level13Data,>planet3Level14Data,<planet3Level14Data
             .BYTE >planet3Level15Data,<planet3Level15Data,>planet3Level16Data,<planet3Level16Data
             .BYTE >planet3Level17Data,<planet3Level17Data,>planet3Level18Data,<planet3Level18Data
             .BYTE >planet3Level19Data,<planet3Level19Data,>planet3Level20Data,<planet3Level20Data

             .BYTE >planet4Level1Data,<planet4Level1Data,>planet4Level2Data,<planet4Level2Data
             .BYTE >planet4Level3Data,<planet4Level3Data,>planet4Level4Data,<planet4Level4Data
             .BYTE >planet4Level5Data,<planet4Level5Data,>planet4Level6Data,<planet4Level6Data
             .BYTE >planet4Level7Data,<planet4Level7Data,>planet4Level8Data,<planet4Level8Data
             .BYTE >planet4Level9Data,<planet4Level9Data,>planet4Level10Data,<planet4Level10Data
             .BYTE >planet4Level11Data,<planet4Level11Data,>planet4Level12Data,<planet4Level12Data
             .BYTE >planet4Level13Data,<planet4Level13Data,>planet4Level14Data,<planet4Level14Data
             .BYTE >planet4Level15Data,<planet4Level15Data,>planet4Level16Data,<planet4Level16Data
             .BYTE >planet4Level17Data,<planet4Level17Data,>planet4Level18Data,<planet4Level18Data
             .BYTE >planet4Level19Data,<planet4Level19Data,>planet4Level20Data,<planet4Level20Data

             .BYTE >planet5Level1Data,<planet5Level1Data,>planet5Level2Data,<planet5Level2Data
             .BYTE >planet5Level3Data,<planet5Level3Data,>planet5Level4Data,<planet5Level4Data
             .BYTE >planet5Level5Data,<planet5Level5Data,>planet5Level6Data,<planet5Level6Data
             .BYTE >planet5Level7Data,<planet5Level7Data,>planet5Level8Data,<planet5Level8Data
             .BYTE >planet5Level9Data,<planet5Level9Data,>planet5Level10Data,<planet5Level10Data
             .BYTE >planet5Level11Data,<planet5Level11Data,>planet5Level12Data,<planet5Level12Data
             .BYTE >planet5Level13Data,<planet5Level13Data,>planet5Level14Data,<planet5Level14Data
             .BYTE >planet5Level15Data,<planet5Level15Data,>planet1Level3Data,<planet1Level3Data
             .BYTE >planet5Level17Data,<planet5Level17Data,>planet5Level18Data,<planet5Level18Data
             .BYTE >planet5Level14Data,<planet5Level14Data,>planet5Level20Data,<planet5Level20Data

hasEnteredNewLevel           .BYTE $01
yPosMovementPatternForShips1 .BYTE $01,$02,$04,$08,$0A,$0C,$0E,$10
                             .BYTE $10,$10,$10,$10,$10,$10,$10,$14
yPosMovementPatternForShips2 .BYTE $FF,$FE,$FC,$F9,$F7,$F5,$F3,$F1
                             .BYTE $F0,$F0,$F0,$F0,$F0,$F0,$F0,$EC

nullPtr = LINE0_COL0
; This is a pointer table for the data for each of the 4 active ships on the
; top planet and the bottom planet. It gets updated as ships die and levels
; change.
activeShipsWaveDataLoPtrArray = *-$02
        ; Pointers to top planet ships.
        .BYTE <planet1Level1Data2ndStage,<planet1Level1Data2ndStage,<planet1Level1Data2ndStage,<planet1Level1Data2ndStage
        .BYTE <nullPtr,<nullPtr ; These two are always zero. This makes it easy
                                ; to use an 'AND #$08' on the index to check
                                ; if it is pointing to a top planet ship or a 
                                ; bottom planet one. Note that the array actually starts two bytes
                                ; ahead of the first value ('= *-$02' above). THis means the first 4 are
                                ; reference with index 2,3,4,5 rather than 0,1,2,3.
        ; Pointers to bottom planet ships.
        .BYTE <planet1Level1Data2ndStage,<planet1Level1Data2ndStage,<planet1Level1Data,<planet1Level1Data
activeShipsWaveDataHiPtrArray =*-$02
        ; Pointers to top planet ships.
        .BYTE >planet1Level1Data2ndStage,>planet1Level1Data2ndStage,>planet1Level1Data2ndStage,>planet1Level1Data2ndStage
        .BYTE >nullPtr,>nullPtr
        ; Pointers to bottom planet ships.
        .BYTE >planet1Level1Data2ndStage,>planet1Level1Data2ndStage,>planet1Level1Data,>planet1Level1Data

; This is level data, one entry for each level per planet
indexForYPosMovementForUpperPlanetAttackShips = *-$02
                                     .BYTE $00,$00,$00,$00,$00,$00,$00,$00
someKindOfRateLimitingForAttackWaves .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00
updateRateForAttackShips             .BYTE $00,$00,$02,$02,$02,$02,$00,$00
                                     .BYTE $02,$02
rateForSwitchingToAlternateEnemy      .BYTE $02,$02,$00,$00,$00,$00,$FF,$FF
                                     .BYTE $00,$00

hasReachedSecondWaveAttackShips     .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00

hasReachedThirdWaveAttackShips    .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00
shipsThatHaveBeenHitByABullet        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00
shipHasAlreadyBeenHitByGilby         .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00,$00,$00
previousAttackShipIndex     .BYTE $04
nextShipOffset                       .BYTE $00
soundEffectInProgress                .BYTE $00,$01,$00,$01,$00,$00,$01,$00
                                     .BYTE $01,$FF,$00,$02,$00,$FF,$FF,$01
                                     .BYTE $02,$80

newPlanetSound              .BYTE $00,PLAY_SOUND,$0F,VOICE2_ATK_DEC,$00
                            .BYTE $00,PLAY_SOUND,$0F,VOICE3_ATK_DEC,$00
                            .BYTE $00,PLAY_SOUND,$00,VOICE2_SUS_REL,$00
                            .BYTE $00,PLAY_SOUND,$00,VOICE3_SUS_REL,$00
                            .BYTE $00,PLAY_SOUND,$10,VOICE2_HI,$00
                            .BYTE $00,PLAY_SOUND,$10,VOICE3_HI,$00
                            .BYTE $00,PLAY_SOUND,$11,VOICE2_CTRL,$00
                            .BYTE $00,PLAY_SOUND,$11,VOICE3_CTRL,$02
                            .BYTE $0F,DEC_AND_PLAY_FROM_BUFFER,$02,VOICE3_HI,$00
                            .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$02,VOICE2_HI,$01
                            .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                            .BYTE $00,PLAY_SOUND,$81,VOICE2_CTRL,$00
                            .BYTE $00,PLAY_SOUND,$28,VOICE2_HI,$00
                            .BYTE $00,PLAY_SOUND,$80,VOICE3_CTRL,$02
                            .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$03,$08,$01
                            .BYTE $00,REPEAT_PREVIOUS,$05,$00,$00
                            .BYTE $00,PLAY_SOUND,$21,VOICE3_CTRL,$00
                            .BYTE $00,PLAY_SOUND,$20,VOICE3_HI,$02
                            .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$03,VOICE2_HI,$00
                            .BYTE $0F,DEC_AND_PLAY_FROM_BUFFER,$04,VOICE3_HI,$01
                            .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                            .BYTE $00,PLAY_SOUND,$80,VOICE2_CTRL,$00
                            .BYTE $00,PLAY_SOUND,$80,VOICE3_CTRL,$00
                            .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00
shipCollidedWithGilbySound  .BYTE $00,PLAY_SOUND,$0F,VOICE1_ATK_DEC,$00
                            .BYTE $00,PLAY_SOUND,$00,VOICE1_SUS_REL,$00
                            .BYTE $00,PLAY_SOUND,$40,VOICE1_HI,$00
                            .BYTE $00,PLAY_SOUND,$81,VOICE1_CTRL,$02
                            .BYTE $01,INC_AND_PLAY_FROM_BUFFER,$0C,VOICE1_HI,$01
                            .BYTE $00,REPEAT_PREVIOUS,$04,$00,$00
                            .BYTE $00,PLAY_SOUND,$20,VOICE1_HI,$00
                            .BYTE $00,PLAY_SOUND,$11,VOICE1_CTRL,$02
                            .BYTE $01,DEC_AND_PLAY_FROM_BUFFER,$04,VOICE1_HI,$01
                            .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                            .BYTE $00,PLAY_SOUND,$10,VOICE1_CTRL,$00
                            .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

;-------------------------------------------------------
; SetXToIndexOfShipThatNeedsReplacing
;
; Searches activeShipsWaveDataHiPtrArray for an entry with zeroized ptrs
; indicating that the ship has been killed and needs to be replaced.
; Stores the index of the ships that needs replacing in the X register.
;-------------------------------------------------------
SetXToIndexOfShipThatNeedsReplacing
        LDA activeShipsWaveDataHiPtrArray,X
        BEQ FoundOneSoReturn
        LDA levelEntrySequenceActive
        BNE ReturnFromSearchingForShips
        INX

        ; Have we tried all the top planet ships without finding one
        ; that is dead (i.e. pointer set to zeros) and needs replacing?
        CPX #$06
        BEQ ReturnFromSearchingForShips
        ; Have we tried all the bottom planet ships without finding one
        ; that is dead (i.e. pointer set to zeros) and needs replacing?
        CPX #$0C
        BEQ ReturnFromSearchingForShips

        ; Keep checking.
        BNE SetXToIndexOfShipThatNeedsReplacing

ReturnFromSearchingForShips   
        LDA #$00
        RTS

FoundOneSoReturn   
        LDA #$FF

ReturnEarly
        RTS

topPlanetLevelDataLoPtr                       .BYTE $A0
topPlanetLevelDataHiPtr                       .BYTE $A0
bottomPlanetLevelDataLoPtr                    .BYTE $58
bottomPlanetLevelDataHiPtr                    .BYTE $1E
enemiesKilledTopPlanetsSinceLastUpdate        .BYTE $28,$00,$00,$00
enemiesKilledTopPlanetsSinceLastUpdatePtr     .BYTE $00
enemiesKilledBottomPlanetsSinceLastUpdate     .BYTE $18,$00,$00,$00
enemiesKilledBottomPlanetsSinceLastUpdatePtr  .BYTE $00
currentLevelInTopPlanets                      .BYTE $06,$02,$06,$0A
currentLevelInTopPlanetsPtr                   .BYTE $08
currentLevelInBottomPlanets                   .BYTE $09,$0E,$0A,$0B,$01
topPlanetStepsBetweenAttackWaveUpdates        .BYTE $04
bottomPlanetStepsBetweenAttackWaveUpdates     .BYTE $04
currentStepsBetweenTopPlanetAttackWaves       .BYTE $00
currentStepsBetweenBottomPlanetAttackWaves    .BYTE $00

;-------------------------------------------------------
; PerformMainGameProcessing
;-------------------------------------------------------
PerformMainGameProcessing
        LDA levelEntrySequenceActive
        BNE MainGameProcReturnEarly
        LDA gilbyHasJustDied
        BEQ MainGameGilbyAlive

        JMP ProcessGilbyExplosion
        ;Returns

MainGameGilbyAlive   
        JSR PerformMainAttackWaveProcessing
        JSR UpdateAttackShipsPosition
        JSR DetectAttackShipCollisionWithGilby
        JSR DecreaseEnergyStorage
        JSR UpdateCoreEnergyValues
        DEC gameSequenceCounter
        BEQ GetNewWaveDataForAnyDeadShips
mainGameProcReturnEarly   
        RTS

gameSequenceCounter   .BYTE $14

;-------------------------------------------------------
; GetNewWaveDataForAnyDeadShips
;-------------------------------------------------------
GetNewWaveDataForAnyDeadShips
        LDA #$20
        STA gameSequenceCounter
        LDX #$02
        JSR SetXToIndexOfShipThatNeedsReplacing
        BEQ b4A1F ; Didn't find any dead ships to replace.

        LDA topPlanetStepsBetweenAttackWaveUpdates
        CMP currentStepsBetweenTopPlanetAttackWaves
        BEQ b4A1F ; Skips updating waves for top planet.

        LDA topPlanetLevelDataLoPtr
        STA activeShipsWaveDataLoPtrArray,X
        LDA topPlanetLevelDataHiPtr
        STA activeShipsWaveDataHiPtrArray,X
        TXA
        TAY
        JSR UpdateCurrentShipWaveDataPtrs
        INC currentStepsBetweenTopPlanetAttackWaves

b4A1F   LDX #$08
        JSR SetXToIndexOfShipThatNeedsReplacing
        BEQ ReturnEarly ; Skips updating waves for bottom planet.

        LDA bottomPlanetStepsBetweenAttackWaveUpdates
        CMP currentStepsBetweenBottomPlanetAttackWaves
        BEQ ReturnEarly ; Skips updating waves for bottom planet.

        LDA bottomPlanetLevelDataLoPtr
        STA activeShipsWaveDataLoPtrArray,X
        LDA bottomPlanetLevelDataHiPtr
        STA activeShipsWaveDataHiPtrArray,X
        TXA
        CLC
        ADC #$02
        TAY
        INC currentStepsBetweenBottomPlanetAttackWaves
        ; Falls through

;-------------------------------------------------------
; UpdateCurrentShipWaveDataPtrs
;-------------------------------------------------------
UpdateCurrentShipWaveDataPtrs
        LDA activeShipsWaveDataLoPtrArray,X
        STA currentShipWaveDataLoPtr
        LDA activeShipsWaveDataHiPtrArray,X
        STA currentShipWaveDataHiPtr
        LDA #$00
        STA updatingWaveData
        STA shipHasAlreadyBeenHitByGilby,X
        ; Y contains the index of the previous enemy ship.
        STY previousAttackShipIndex
        ; Falls through

;-------------------------------------------------------
; GetWaveDataForNewShip
; Loads the wave data for the current wave from level_data.asm and level_data2.asm.
; currentShipWaveDataLoPtr is a reference to one of the data chunks in those
; files.
;-------------------------------------------------------
GetWaveDataForNewShip
        ; X is the index of the ship in activeShipsWaveDataLoPtrArray
        LDY #$00
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipsColorArray + $01,X

        ; Byte 6 ($06): Usually an update rate for the attack ships.
        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        STA rateForSwitchingToAlternateEnemy,X

        ; Byte 11; Some kind of rate limit.
        LDY #11
        LDA (currentShipWaveDataLoPtr),Y
        STA someKindOfRateLimitingForAttackWaves,X

        LDA #$00
        STA indexForYPosMovementForUpperPlanetAttackShips,X

        ; Byte 15; Update Rate for Attack Waves
        LDY #15
        LDA (currentShipWaveDataLoPtr),Y
        STA updateRateForAttackShips,X

        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        LDY #$01
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipsSpriteValueArray + $01,X

        ; Store the sprite value in the storage used to reload the game
        ; from pause mode or a restart.
        TXA
        TAY
        LDX orderForUpdatingPositionOfAttackShips,Y
        ; Byte 1 (Index $01): Sprite value for the attack ship for the upper planet.
        LDY #$01
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,X

        ; Byte 2 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        LDY #$02
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpriteAnimationEnd,X

        ; Byte 3 (Index $03): The animation frame rate for the attack ship.
        LDY #$03
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipAnimationFrameRate,X
        STA upperPlanetAttackShipInitialFrameRate,X

        ; Check if we're on the upper planet.
        TXA
        AND #$04
        BEQ WaveDataOnUpperPlanet

        ; We're on the lower planet. 
        INY
        ; Y is now 4
        ; Byte 4 (Index $04): Sprite value for the attack ship for the lower planet.
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,X

        INY
        ; Y is now 5
        ; Byte 5 (Index $05): The 'end' sprite value for the ship's lower planet animation.
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpriteAnimationEnd,X

        TXA
        TAY
        LDA indexForActiveShipsWaveData,X
        TAY
        LDA upperPlanetAttackShipSpritesLoadedFromBackingData,X
        STA upperPlanetAttackShipsSpriteValueArray + $01,Y

WaveDataOnUpperPlanet   
        ; Y is now 18 ($12) - Byte 18 in the wave data
        ; which is the x-pos movement for the attack ship.
        LDY #18
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        ; Ignore if the upper bit is set.
        BEQ GetYPosMovement
        STA xPosMovementForUpperPlanetAttackShip,X

GetYPosMovement   
        INY
        ; Y is now 19 ($13) - Byte 19. This has the Y-Pos movement for the
        ; attack ship.
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        ; Ignore if the upper bit is set.
        BEQ GetXPosFrameRate
        AND #$F0
        CMP #$20
        BEQ b4AD6
        ; Y is still 19 ($13) - Byte 19.
        ; This has the Y-Pos movement for the attack ship.
        LDA (currentShipWaveDataLoPtr),Y
        JMP LoadYPosForAttackShip

b4AD6   TXA
        STX temporaryStorageForXRegister
        AND #$04
        BNE LowerBitOfYPosSet
        ; Y is still 19 ($13) - Byte 19.
        ; This has the Y-Pos movement for the attack ship.
        LDA (currentShipWaveDataLoPtr),Y
        AND #$0F
        TAX
        LDA yPosMovementPatternForShips2,X
        LDX temporaryStorageForXRegister
        JMP LoadYPosForAttackShip

        ; Y is still 19 ($13) - Byte 19.
        ; This has the Y-Pos movement for the attack ship.
LowerBitOfYPosSet   
        LDA (currentShipWaveDataLoPtr),Y
        AND #$0F
        TAX
        LDA yPosMovementPatternForShips1,X
        LDX temporaryStorageForXRegister

LoadYPosForAttackShip
        STA yPosMovementForUpperPlanetAttackShips,X

GetXPosFrameRate   
        INY
        ; Y is now 20 ($14) - Byte 20.
        ; X Pos Frame Rate for the Attack ship.
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        ; Ignore if the upper bit is set.
        BEQ GetYPosFrameRate

        STA upperPlanetInitialXPosFrameRateForAttackShip,X
        STA upperPlanetXPosFrameRateForAttackShip,X

GetYPosFrameRate   
        INY
        ; Y is now 21 ($15) - Byte 21.
        ; Y Pos Frame Rate for the Attack ship.
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        ; Ignore if the upper bit is set.
        BEQ MaybeSetInitialRandomPositionsOfEnemy

        STA upperPlanetInitialYPosFrameRateForAttackShips,X
        STA upperPlanetYPosFrameRateForAttackShips,X

MaybeSetInitialRandomPositionsOfEnemy   
        LDA #$01
        LDA updatingWaveData
        BEQ SetInitialRandomPositionsOfEnemy
        RTS

        ; Set the initial Y Position of the new attack ships.
        ; This is random.
previousAttackShipIndexTmp = tmpPtrLo
SetInitialRandomPositionsOfEnemy   
        LDY previousAttackShipIndex
        LDA indexForActiveShipsWaveData,X
        TAX
        LDA attackShipsMSBXPosOffsetArray + $01,X
        STA upperPlanetAttackShipsMSBXPosArray + $01,Y
        JSR PutProceduralByteInAccumulatorRegister
        AND #$7F
        CLC
        ADC #$20
        STA upperPlanetAttackShipsXPosArray + $01,Y

        ; Are we on the upper or lower planet?
        TYA
        AND #$08
        BNE SetInitialRandomPositionLowerPlanet

SetInitialRandomPositionUpperPlanet   
        JSR PutProceduralByteInAccumulatorRegister
        AND #$3F
        CLC
        ADC #$40
        STA upperPlanetAttackShipsYPosArray + $01,Y

        STY previousAttackShipIndexTmp
        ; Byte 6 ($06): Usually an update rate for the attack ships.
        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        BNE ReturnFromLoadingWaveDataEarly

        ; Byte 8 ($08): Default initiation Y position for the enemy. 
        LDY #$08
        LDA (currentShipWaveDataLoPtr),Y
        BEQ ReturnFromLoadingWaveDataEarly

        LDA #$6C
        LDY previousAttackShipIndexTmp
        STA upperPlanetAttackShipsYPosArray + $01,Y

ReturnFromLoadingWaveDataEarly   
        RTS

SetInitialRandomPositionLowerPlanet   
        JSR PutProceduralByteInAccumulatorRegister
        AND #$3F
        CLC
        ADC #$98
        STA upperPlanetAttackShipsYPosArray + $01,Y

        STY previousAttackShipIndexTmp
        ; Byte 6 ($06): Determines if the inital Y Position of the ship is random or uses a default.
        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        BNE ReturnFromLoadingWaveData

        ; Byte 8 ($08): A Hi-Ptr to wave data normally but treated here . 
        LDY #$08
        LDA (currentShipWaveDataLoPtr),Y
        BEQ ReturnFromLoadingWaveData

        ; Set Y Pos to $90 if we have wave data in Bytes 8-9.
        LDA #$90
        LDY previousAttackShipIndexTmp
        STA upperPlanetAttackShipsYPosArray + $01,Y

ReturnFromLoadingWaveData   
        RTS

orderForUpdatingPositionOfAttackShips          .BYTE $00,$00,$00,$01,$02,$03,$00,$00
                                               .BYTE $04,$05,$06,$07
indexForActiveShipsWaveData                    .BYTE $02,$03,$04,$05,$08,$09,$0A,$0B
indexIntoUpperPlanetAttackShipXPosAndYPosArray .BYTE $00,$00,$02,$03,$04,$05,$00,$00
                                               .BYTE $0A,$0B,$0C,$0D
indexIntoUpperPlanetAttackShipsYPosArray       .BYTE $02,$03,$04,$05,$0A,$0B,$0C,$0D
indexIntoYPosMovementForUpperPlanetAttackShips .BYTE $00,$00,$00,$01,$02,$03,$00,$00
                                               .BYTE $00,$00,$04,$05,$06,$07
indexIntoAttackWaveDataHiPtrArray              .BYTE $00,$00,$02,$03,$04,$05,$00,$00
                                               .BYTE $00,$00,$08,$09,$0A,$0B
;-------------------------------------------------------
; PerformMainAttackWaveProcessing
;-------------------------------------------------------
PerformMainAttackWaveProcessing
        LDY #$00
        LDA pauseModeSelected
        BEQ UpdateEnemyStateLoop
        RTS

        ; This loop updates the state of each of the 8 attack ships
        ; that are active at any one time tracked by activeShipsWaveDataLoPtrArray. It's 4 for the
        ; top planet, and 4 for the bottom planet. 
UpdateEnemyStateLoop   
        LDX indexForActiveShipsWaveData,Y
        LDA activeShipsWaveDataHiPtrArray,X
        ; When there is no ship (anymore) for an entry its pointer will be zeroes.
        BEQ NoShipToUpdate
        STY tempVarStorage
        JSR ProcessAttackWaveDataForActiveShip
        LDY tempVarStorage
NoShipToUpdate   
        INY
        CPY #$08
        BNE UpdateEnemyStateLoop

        LDA hasEnteredNewLevel
        BEQ ReturnFromMainWave
        LDA #$00
        STA currentStepsBetweenTopPlanetAttackWaves
        STA currentStepsBetweenBottomPlanetAttackWaves
        STA hasEnteredNewLevel
ReturnFromMainWave   
        RTS

;-------------------------------------------------------
; ProcessAttackWaveDataForActiveShip
;-------------------------------------------------------
ProcessAttackWaveDataForActiveShip
        ; X is the current value in indexForActiveShipsWaveData
        STA currentShipWaveDataHiPtr
        LDA activeShipsWaveDataLoPtrArray,X
        STA currentShipWaveDataLoPtr
        LDA hasEnteredNewLevel
        BEQ StillOnSameLevel

        ; We've entered a new level.
        ; Get the wave data from the wave data store and return
        LDA #>attackWaveData
        STA currentShipWaveDataHiPtr
        LDA #<attackWaveData
        STA currentShipWaveDataLoPtr
        JMP GetWaveDataForShipForNewLevel
        ; Returns


StillOnSameLevel   
        LDA shipsThatHaveBeenHitByABullet,X
        BNE UpdateScoresAfterHittingShipWithBullet
        JMP CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
        ; Returns

;-------------------------------------------------------
; UpdateScoresAfterHittingShipWithBullet
;-------------------------------------------------------
UpdateScoresAfterHittingShipWithBullet
        LDA #$00
        STA shipsThatHaveBeenHitByABullet,X

        LDA #<newPlanetSound
        STA secondarySoundEffectLoPtr
        LDA #>newPlanetSound
        STA secondarySoundEffectHiPtr
        JSR ResetRepetitionForSecondarySoundEffect
        LDA #$1C
        STA soundEffectInProgress

        ; Did the bullet hit a ship on the top planet or bottom planet?
        TXA
        PHA
        AND #$08
        BNE BulletHitShipOnBottomPlanet

        ; Bullet hit a ship on the top planet.

        ; Hitting the warp gate increments the planet for warp.
        LDA levelEntrySequenceActive
        BNE AddPointsForHittingEnemy
        LDA attractModeCountdown
        BNE AddPointsForHittingEnemy
        INC topPlanetPointerIndex
        LDA topPlanetPointerIndex
        CMP currentTopPlanet
        BNE AddPointsForHittingEnemy

        LDA #$00
        STA topPlanetPointerIndex
        ; Get the points multiplier for hitting enemies in this level
        ; from the wave data.
AddPointsForHittingEnemy   
        ; Byte 34
        LDY #34
        LDA (currentShipWaveDataLoPtr),Y
        JSR CalculatePointsForByte2
        CLC
        ADC pointsEarnedTopPlanetByte1
        STA pointsEarnedTopPlanetByte1
        LDA pointsEarnedTopPlanetByte2
        ADC pointsToAddToPointsEarnedByte2
        STA pointsEarnedTopPlanetByte2
        JMP ContinueCalculatingScoreFromHit

        ; Bullet hit a ship on the bottom planet.
BulletHitShipOnBottomPlanet
        ; Hitting the warp gate increments the planet for warp.
        LDA levelEntrySequenceActive
        BNE AddPointsForHittingEnemyLowerPlanet
        LDA attractModeCountdown
        BNE AddPointsForHittingEnemyLowerPlanet
        INC bottomPlanetPointerIndex
        LDA bottomPlanetPointerIndex
        CMP currentBottomPlanet
        BNE AddPointsForHittingEnemyLowerPlanet

        LDA #$00
        STA bottomPlanetPointerIndex
        ; Get the points multiplier for hitting enemies in this level
        ; from the wave data.
AddPointsForHittingEnemyLowerPlanet   
        ; Byte 34
        LDY #34
        LDA (currentShipWaveDataLoPtr),Y
        JSR CalculatePointsForByte2
        CLC
        ADC pointsEarnedBottomPlanetByte1
        STA pointsEarnedBottomPlanetByte1
        LDA pointsEarnedBottomPlanetByte2
        ADC pointsToAddToPointsEarnedByte2
        STA pointsEarnedBottomPlanetByte2

ContinueCalculatingScoreFromHit
        JSR DrawPlanetProgressPointers
        PLA
        TAX
        ; Get the points multiplier for hitting enemies in this level
        ; from the wave data.
        LDY #34
        LDA (currentShipWaveDataLoPtr),Y
        BEQ LoadExplosionAnimation
        LDA attractModeCountdown
        BNE LoadExplosionAnimation

        ; Are we on the bottom planet?
        TXA
        AND #$08
        BNE UpdateProgressBottomPlanet

        ; We're on the top planet.
        JSR IncreaseEnergyTopOnly
        JSR UpdateTopPlanetProgressData
        JMP LoadExplosionAnimation

UpdateProgressBottomPlanet   
        JSR UpdateBottomPlanetProgressData
        JSR IncreaseEnergyBottomOnly

        ; Byte 29: Load the explosion animation, if there is one. For most
        ; enemies this is the spinning rings defined by spinningRings.
LoadExplosionAnimation   
        LDY #29
        LDA (currentShipWaveDataLoPtr),Y
        BEQ CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
        ; There's a Hi Ptr for the explosion animation, so decrement
        ; Y to point it at the Lo Ptr and load the ptrs as the new
        ; wave data for the enemy.
        DEY
        JMP UpdateWaveDataPointersForCurrentEnemy
        ;Returns

;-------------------------------------------------------
; CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
;-------------------------------------------------------
CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
        ; X is the current value in indexForActiveShipsWaveData
        ; We're checking if this is the first time the ship has been hit by the gilby.
        ; If so, there may be a new state for the enemy to turn into, e.g. a licker ship
        ; seed turning into a licker ship.
        LDA shipHasAlreadyBeenHitByGilby,X
        BEQ JumpToGetNewShipDataFromDataStore

        LDA #$00
        STA shipHasAlreadyBeenHitByGilby,X

        ; Byte 31: Check if there is another set of wave data to get for this wave when it is first hit.
        LDY #31
        LDA (currentShipWaveDataLoPtr),Y
        BEQ JumpToGetNewShipDataFromDataStore

        ; Byte 14 (Index $0E): Controls the rate at which new enemies are added?
        ; Is there a rate at which new enemies are added?
        LDY #14
        LDA (currentShipWaveDataLoPtr),Y
        BEQ CheckCollisionType

        TXA
        AND #$08 ; Is X pointing to lower planet ships?
        BNE DecrementStepsThenCheckCollisionsForBottomPlanet

        ; X is pointing to a top planet ship.
        DEC currentStepsBetweenTopPlanetAttackWaves
        JMP CheckCollisionType
        ; Returns

;-------------------------------------------------------
; JumpToGetNewShipDataFromDataStore
;-------------------------------------------------------
JumpToGetNewShipDataFromDataStore
        JMP GetNewShipDataFromDataStore
        ; Returns

;-------------------------------------------------------
; DecrementStepsThenCheckCollisionsForBottomPlanet
;-------------------------------------------------------
DecrementStepsThenCheckCollisionsForBottomPlanet
        DEC currentStepsBetweenBottomPlanetAttackWaves
        ; Falls through
;-------------------------------------------------------
; CheckCollisionType
;-------------------------------------------------------
CheckCollisionType
        ; Byte 36: Does an exploded version of the enemy allow us to warp to the
        ; other planet?
        LDY #36
        LDA (currentShipWaveDataLoPtr),Y
        BNE MaybeTransferToOtherPlanet
        JMP UpdateEnergyLevelsAfterCollision
        ;Returns

;-------------------------------------------------------
; MaybeTransferToOtherPlanet
;-------------------------------------------------------
MaybeTransferToOtherPlanet
        LDA joystickInput
        AND #JOYSTICK_FIRE
        BEQ JumpToGetNewShipDataFromDataStore

        ; Fire not pressed while passing through explosion ring so can
        ; transfer to other planet
        LDA lowerPlanetActivated
        BNE JumpToGetNewShipDataFromDataStore

        LDA setToZeroIfOnUpperPlanet
        BNE TransferToTheUpperPlanet ; BNE, so branch if setToZeroIfOnUpperPlanet is not $00.

        ; Transfer to the lower planet.
        JSR ResetRepetitionForPrimarySoundEffect
        LDA #<transferToLowerPlanetSoundEffect
        STA primarySoundEffectLoPtr
        LDA #>transferToLowerPlanetSoundEffect
        STA primarySoundEffectHiPtr

        ; We're setting setToZeroIfOnUpperPlanet to $08 here to 
        ; indicate we're now on the lower planet.
        LDA #$08
        ; We always branch to InitializeStateAfterPlanetTransfer
        ; since A is always $08 here.
        BNE InitializeStateAfterPlanetTransfer

TransferToTheUpperPlanet   
        JSR ResetRepetitionForPrimarySoundEffect
        LDA #<transferToUpperPlanetSoundEffect
        STA primarySoundEffectLoPtr
        LDA #>transferToUpperPlanetSoundEffect
        STA primarySoundEffectHiPtr

        ; We're setting setToZeroIfOnUpperPlanet to $00 here to 
        ; indicate we're now on the upper planet.
        LDA #$00
InitializeStateAfterPlanetTransfer   
        STA setToZeroIfOnUpperPlanet
        LDA #$00
        STA currentEntropy
        LDA #$08
        STA upperPlanetEntropyStatus
        STA lowerPlanetEntropyStatus
        LDA #$05
        STA gilbyExploding
        LDA #$04
        STA starFieldInitialStateArray - $01
        ; Falls through

;-------------------------------------------------------
; UpdateEnergyLevelsAfterCollision
;-------------------------------------------------------
UpdateEnergyLevelsAfterCollision
        ; Byte 35: Check if the enemy saps energy from the gilby?
        LDY #35
        LDA (currentShipWaveDataLoPtr),Y
        BEQ NoMultiplierAppliedToCollision

        LDA #<shipCollidedWithGilbySound
        STA primarySoundEffectLoPtr
        LDA #>shipCollidedWithGilbySound
        STA primarySoundEffectHiPtr
        JSR ResetRepetitionForPrimarySoundEffect
        LDA #$0E
        STA gilbyExploding
        LDA #$02
        STA starFieldInitialStateArray - $01
        LDA currentGilbySpeed
        EOR #$FF
        CLC
        ADC #$01
        STA currentGilbySpeed

        LDA setToZeroIfOnUpperPlanet
        BEQ EnergyUpdateTopPlanet

        LDA extraAmountToDecreaseEnergyByBottomPlanet
        BNE NoMultiplierAppliedToCollision
        ; Y is still 35.
        LDA (currentShipWaveDataLoPtr),Y
        JSR AugmentAmountToDecreaseEnergyByBountiesEarned
        STA extraAmountToDecreaseEnergyByBottomPlanet
        BNE NoMultiplierAppliedToCollision

EnergyUpdateTopPlanet   
        LDA extraAmountToDecreaseEnergyByTopPlanet
        BNE NoMultiplierAppliedToCollision
        ; Y is still 35.
        LDA (currentShipWaveDataLoPtr),Y
        JSR AugmentAmountToDecreaseEnergyByBountiesEarned
        STA extraAmountToDecreaseEnergyByTopPlanet

NoMultiplierAppliedToCollision
        ; Byte 30: Hi/Lo Ptr for the Explosion Sprite
        LDY #30
        JMP UpdateWaveDataPointersForCurrentEnemy
        ; Returns

;-------------------------------------------------------
; GetNewShipDataFromDataStore
;-------------------------------------------------------
GetNewShipDataFromDataStore
        LDA hasReachedSecondWaveAttackShips,X
        BEQ No2ndWaveData

        LDA #$00
        STA hasReachedSecondWaveAttackShips,X

        ; Byte 25: The 2nd stage of wave data for this enemy.
        LDY #25
        LDA (currentShipWaveDataLoPtr),Y
        BEQ No2ndWaveData

        DEY
        JMP UpdateWaveDataPointersForCurrentEnemy

No2ndWaveData   
        LDA hasReachedThirdWaveAttackShips,X
        BEQ No3rdWaveData

        LDA #$00
        STA hasReachedThirdWaveAttackShips,X

        ; Byte 27: The 3rd stage of wave data for this enemy.
        LDY #27
        LDA (currentShipWaveDataLoPtr),Y
        BEQ No3rdWaveData

        DEY
        JMP UpdateWaveDataPointersForCurrentEnemy

No3rdWaveData   
        LDA joystickInput
        AND #$10
        BNE No4thWaveData

        ; Fire is pressed.

        ; Byte 33: Check if we should load extra stage data for this enemy.
        ; FIXME: When this is set it would incorrectly expect there
        ; to be a hi/lo ptr in $20 and $21, when there isn't.
        LDY #33
        LDA (currentShipWaveDataLoPtr),Y
        BEQ No4thWaveData
        DEY
        JMP UpdateWaveDataPointersForCurrentEnemy
        ; Returns

No4thWaveData   
        LDA updateRateForAttackShips,X
        BEQ UpdateAttackShipDataForNewShip
        DEC updateRateForAttackShips,X
        BNE UpdateAttackShipDataForNewShip
        ; Byte 14: Controls the rate at which new enemies are added.
        ; This is only set when the current ship data is defaultExplosion
        ; so in most cases we will go straight to SwitchToAlternatingWaveData.
        LDY #14
        LDA (currentShipWaveDataLoPtr),Y
        BEQ SwitchToAlternatingWaveData

        ; Are we on the top or bottom planet?
        TXA
        AND #$08
        BNE NewShipDataForBottomPlanet

        ; We're on the top planet.
        DEC currentStepsBetweenTopPlanetAttackWaves
        JMP SwitchToAlternatingWaveData

NewShipDataForBottomPlanet   
        DEC currentStepsBetweenBottomPlanetAttackWaves

SwitchToAlternatingWaveData   
        LDY #16

;-------------------------------------------------------
; UpdateWaveDataPointersForCurrentEnemy
;-------------------------------------------------------
UpdateWaveDataPointersForCurrentEnemy
        ; Byte 16  Y has been set to 16 above, so we're pulling in the pointer
        ; to the second tranche of wave data for this level. 
        ; Or Y has been set by the caller.
        LDA (currentShipWaveDataLoPtr),Y
        PHA
        INY
        ; Byte 17
        LDA (currentShipWaveDataLoPtr),Y

        ; If we have a nullPtr then there's no wave data to get
        ; so the enemy ship can be cleared out and we can return.
        BEQ ClearDeadShipFromLevelData

        STA activeShipsWaveDataHiPtrArray,X
        STA currentShipWaveDataHiPtr
        PLA
        STA currentShipWaveDataLoPtr
        STA activeShipsWaveDataLoPtrArray,X
        ; Falls through

;-------------------------------------------------------
; GetWaveDataForShipForNewLevel
;-------------------------------------------------------
GetWaveDataForShipForNewLevel
        LDA #$FF
        STA updatingWaveData
        JSR GetWaveDataForNewShip
        LDA #$00
        STA updatingWaveData
        RTS

;-------------------------------------------------------
; ClearDeadShipFromLevelData
;-------------------------------------------------------
ClearDeadShipFromLevelData
        LDA #$F0
        STA upperPlanetAttackShipsSpriteValueArray + $01,X
        PHA
        LDA #$00
        STA activeShipsWaveDataHiPtrArray,X
        LDY orderForUpdatingPositionOfAttackShips,X
        PLA
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,Y
        LDA #$F1
        STA upperPlanetAttackShipSpriteAnimationEnd,Y
        PLA
        RTS

positionRelativeToGilby .BYTE $00
updatingWaveData        .BYTE $00
currentTopPlanet        .BYTE $01
currentBottomPlanet     .BYTE $01

newMovementHiPtr = tempHiPtr3
newMovementLoPtr = tempLoPtr3

;-------------------------------------------------------
; UpdateAttackShipDataForNewShip
;-------------------------------------------------------
UpdateAttackShipDataForNewShip
        ; This section up to MaybeQuicklyGravitatesToGilby is unused
        ; because Bytes 9 and 10 are never actually set. This also means
        ; Byte 11 is never used because someKindOfRateLimitingForAttackWaves
        ; is only ever referenced here.
        ; It looks like Byte 11 contains a value X so that for every Xth ship
        ; we add here Bytes 9 and 10 are used to set its initial position on the
        ; screen and an initial frame rate for the enemy. For this to work Bytes 9
        ; and 10 would have to contain the Hi/Lo Ptr to an address to Bytes 18-21
        ; in this or another set of level data.

        ; Byte 10:
        LDY #10
        LDA (currentShipWaveDataLoPtr),Y
        BEQ MaybeQuicklyGravitatesToGilby

UnusedRoutine
        ; As above, this section is never reached because Byte 10 is never set.
        DEC someKindOfRateLimitingForAttackWaves,X
        BNE MaybeQuicklyGravitatesToGilby

        ; Store Bytes 10 and 11 in tempLoPtr3 and newMovementHiPtr respectively.
        STA newMovementHiPtr
        DEY
        ; Byte 9: Y is now $09.
        LDA (currentShipWaveDataLoPtr),Y
        STA newMovementLoPtr

        ; Byte 11 in the wave data defines some kind of rate limiting.
        LDY #11
        LDA (currentShipWaveDataLoPtr),Y
        STA someKindOfRateLimitingForAttackWaves,X

        ; newMovementLoPtr would have pointed to some section of Bytes 18-21
        ; in another set of leval data. So it would get loaded here to
        ; populate the behaviour for the attack wave.
        LDY indexForYPosMovementForUpperPlanetAttackShips,X
        LDA orderForUpdatingPositionOfAttackShips,X
        TAX
        LDA (newMovementLoPtr),Y
        CMP #$80
        BEQ SkipLoadingWaveData

        ; Load Byte 18, the X Pos movememnt.
        LDA (newMovementLoPtr),Y
        STA xPosMovementForUpperPlanetAttackShip,X
        
        ; Load Byte 19, the Y Pos movement.
        INY
        LDA (newMovementLoPtr),Y
        STA yPosMovementForUpperPlanetAttackShips,X

        ; Load Byte 20, the X Pos framerate.
        INY
        LDA (newMovementLoPtr),Y
        STA upperPlanetInitialXPosFrameRateForAttackShip,X
        STA upperPlanetXPosFrameRateForAttackShip,X

        ; Load Byte 21, the Y Pos framerate.
        INY
        LDA (newMovementLoPtr),Y
        STA upperPlanetInitialYPosFrameRateForAttackShips,X
        STA upperPlanetYPosFrameRateForAttackShips,X

        INY
        LDA indexForActiveShipsWaveData,X
        TAX
        TYA
        STA indexForYPosMovementForUpperPlanetAttackShips,X
        JMP MaybeQuicklyGravitatesToGilby

        ; Load the Lo Ptr for Wave data, but this is never used.
        ; We never here because $0A in the wave data is never set either.
SkipLoadingWaveData
        LDY #$0C
        LDA indexForActiveShipsWaveData,X
        TAX
        JMP UpdateWaveDataPointersForCurrentEnemy

MaybeQuicklyGravitatesToGilby
        ; Byte 23:  Does the enemy gravitate quickly towards the gilby when it is shot?
        LDY #23
        LDA (currentShipWaveDataLoPtr),Y
        BEQ MaybeStickyAttackShipBehaviour

        ; After being destroyed the enemy gravitates quickly towards the gilby.
        ; There are two types of behaviour $01 or $23.
        CLC
        ADC gilbyVerticalPositionUpperPlanet
        STA positionRelativeToGilby
        LDA orderForUpdatingPositionOfAttackShips,X
        TAX
        LDA upperPlanetYPosFrameRateForAttackShips,X
        CMP #$01
        BNE NoVerticalMovementRequired
        ; Y is still 23.
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$23
        BNE b4E96
        LDA #$77
        STA positionRelativeToGilby
b4E96   TXA
        AND #$04
        BEQ b4EA6
        LDA #$FF
        SEC
        SBC positionRelativeToGilby
        ADC #$07
        STA positionRelativeToGilby
b4EA6   LDA indexIntoUpperPlanetAttackShipsYPosArray,X
        TAX
        LDA upperPlanetAttackShipsYPosArray + $01,X
        PHA
        LDA indexIntoYPosMovementForUpperPlanetAttackShips,X
        TAX
        PLA
        ; Now decide whether to move up or down.
        CMP positionRelativeToGilby
        BEQ NoVerticalMovementRequired
        BMI MoveDownToGilby
MoveUpToGilby
        DEC yPosMovementForUpperPlanetAttackShips,X
        DEC yPosMovementForUpperPlanetAttackShips,X
MoveDownToGilby
        INC yPosMovementForUpperPlanetAttackShips,X
NoVerticalMovementRequired
        LDA indexForActiveShipsWaveData,X
        TAX

MaybeStickyAttackShipBehaviour   
        ; Byte 22: Does the enemy have the stickiness behaviour?
        LDY #22
        LDA (currentShipWaveDataLoPtr),Y
        BEQ MaybeSwitchToAlternateEnemyPattern

        ; The enemy is sticky, so make it stick to the gilby.
        CLC
        ADC #$58
        STA positionRelativeToGilby
        LDA orderForUpdatingPositionOfAttackShips,X
        TAX
        LDA upperPlanetXPosFrameRateForAttackShip,X
        CMP #$01
        BNE NoHorizontalMovementRequired
        LDA indexIntoUpperPlanetAttackShipsYPosArray,X
        TAX
        CLC
        LDA upperPlanetAttackShipsMSBXPosArray + $01,X
        BEQ b4EE9
        SEC
b4EE9   LDA upperPlanetAttackShipsXPosArray + $01,X
        ROR
        PHA
        LDA indexIntoYPosMovementForUpperPlanetAttackShips,X
        TAX
        PLA
        CMP positionRelativeToGilby
        BMI MoveRightToGilby
MoveLeftToGilby   
        DEC xPosMovementForUpperPlanetAttackShip,X
        DEC xPosMovementForUpperPlanetAttackShip,X
MoveRightToGilby   
        INC xPosMovementForUpperPlanetAttackShip,X
NoHorizontalMovementRequired   
        LDA indexForActiveShipsWaveData,X
        TAX

MaybeSwitchToAlternateEnemyPattern   
        ; Byte 6 ($06): Usually an update rate for the attack ships.
        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        BEQ EarlyReturnFromAttackShipBehaviour

        DEC rateForSwitchingToAlternateEnemy,X
        BNE EarlyReturnFromAttackShipBehaviour

        ; Byte 6 ($06): Usually an update rate for the attack ships.
        LDA (currentShipWaveDataLoPtr),Y
        STA rateForSwitchingToAlternateEnemy,X

        ; Push the current ship's position data onto the stack.
        TXA
        PHA
        LDY indexIntoUpperPlanetAttackShipXPosAndYPosArray,X
        LDA upperPlanetAttackShipsXPosArray + $01,Y
        PHA
        LDA upperPlanetAttackShipsMSBXPosArray + $01,Y
        PHA
        LDA upperPlanetAttackShipsYPosArray + $01,Y
        PHA

        ; Are we on the top or bottom planet?
        TXA
        AND #$08
        BNE LowerPlanetAttackShipBehaviour

        ; We're on the upper planet.
        LDX #$02
ProcessAttackShipBehaviour   
        JSR SetXToIndexOfShipThatNeedsReplacing
        BEQ ResetAndReturnFromAttackShipBehaviour

        ; Pop the current ship's position data from the stack and
        ; populate it into the new ship's position.
        LDY indexIntoUpperPlanetAttackShipXPosAndYPosArray,X
        PLA
        STA upperPlanetAttackShipsYPosArray + $01,Y
        PLA
        BEQ MSBXPosOffsetIzZero

        LDA attackShipsMSBXPosOffsetArray + $01,X
MSBXPosOffsetIzZero   
        STA upperPlanetAttackShipsMSBXPosArray + $01,Y
        PLA
        STA upperPlanetAttackShipsXPosArray + $01,Y
        PLA

        ; Byte 7 of Wave Data gets loaded now. Bytes 7 and 8
        ; contain the hi/lo ptrs to the alternate enemy data.
        LDY #$07
        JMP UpdateWaveDataPointersForCurrentEnemy

LowerPlanetAttackShipBehaviour   
        LDX #$08
        BNE ProcessAttackShipBehaviour

ResetAndReturnFromAttackShipBehaviour   
        PLA
        PLA
        PLA
        PLA
        TAX

EarlyReturnFromAttackShipBehaviour   
        RTS

EarlyReturnFromAttackShipsPosition   
        RTS

setToZeroIfOnUpperPlanet .BYTE $00
currentAttackShipXPos    .BYTE $00
currentAttackShipYPos    .BYTE $00,$00
;-------------------------------------------------------
; UpdateAttackShipsPosition
;-------------------------------------------------------
UpdateAttackShipsPosition
        LDA setToZeroIfOnUpperPlanet
        TAY
        AND #$08 ; Checks if we're on the lower planet.
        BEQ DontAdjustForLowerPlanet

        ; Decrement Y twice if setToZeroIfOnUpperPlanet has an $08.
        ; i.e. we are on the lower planet.
        DEY
        DEY

DontAdjustForLowerPlanet   
        LDA upperPlanetAttackShipsMSBXPosArray + $01,Y
        BMI b4F89
        LDY setToZeroIfOnUpperPlanet
        LDA upperPlanetAttackShipsMSBXPosArray + $01,Y
        CLC
        BEQ b4F74
        SEC
b4F74   LDA upperPlanetAttackShipsXPosArray + $01,Y
        ROR
        STA currentAttackShipXPos
        LDA upperPlanetAttackShipsYPosArray + $01,Y
        STA currentAttackShipYPos
        LDA #$00
        STA nextShipOffset
        JSR UpdateAttackShipsMSBXPosition
b4F89   LDA upperPlanetAttackShipsMSBXPosArray + $02,Y
        BMI EarlyReturnFromAttackShipsPosition
        CLC
        BEQ b4F92
        SEC
b4F92   LDA upperPlanetAttackShipsXPosArray + $02,Y
        ROR
        STA currentAttackShipXPos
        LDA upperPlanetAttackShipsYPosArray + $02,Y
        STA currentAttackShipYPos
        LDA #$01
        STA nextShipOffset
        ; Falls through

;-------------------------------------------------------
; UpdateAttackShipsMSBXPosition
;-------------------------------------------------------
UpdateAttackShipsMSBXPosition
        TYA
        TAX
        INX
        INX

UpdateAttackShipsMSBXPositionLoop
        STX tempLoPtr3
        LDA indexIntoAttackWaveDataHiPtrArray,X
        TAX
        LDA activeShipsWaveDataHiPtrArray,X
        BNE b4FB6
        JMP SkipRestofMXBPositionUpdates

b4FB6   LDX tempLoPtr3
        CLC
        LDA upperPlanetAttackShipsMSBXPosArray + $01,X
        BEQ b4FBF
        SEC
b4FBF   LDA upperPlanetAttackShipsXPosArray + $01,X
        ROR
        SEC
        SBC currentAttackShipXPos
        BPL b4FCB
        EOR #$FF
b4FCB   CMP #$08
        BMI b4FD2
        JMP SkipRestofMXBPositionUpdates

b4FD2   LDA upperPlanetAttackShipsYPosArray + $01,X
        SEC
        SBC currentAttackShipYPos
        BPL b4FDD
        EOR #$FF
b4FDD   CMP #$10
        BMI b4FE4
        JMP SkipRestofMXBPositionUpdates

b4FE4   LDA indexIntoAttackWaveDataHiPtrArray,X
        TAX
        LDA activeShipsWaveDataLoPtrArray,X
        STA currentShipWaveDataLoPtr
        LDA activeShipsWaveDataHiPtrArray,X
        STA currentShipWaveDataHiPtr
        STY tempVarStorage

        ; Byte 29: Load the explosion animation for the enemy.
        LDY #29
        LDA (currentShipWaveDataLoPtr),Y
        LDY tempVarStorage
        CMP #$00
        BEQ SkipRestofMXBPositionUpdates

        ; Bullet hit an attack ship
        LDA #$FF
        STA shipsThatHaveBeenHitByABullet,X
        TYA
        PHA
        CLC
        ADC nextShipOffset
        TAY
        LDX tempLoPtr3
        TYA
        AND #$08
        BEQ b5013
        DEY
        DEY
b5013   LDA #$FF
        STA upperPlanetAttackShipsMSBXPosArray + $01,Y
        PLA
        TAY
        RTS

SkipRestofMXBPositionUpdates
        LDX tempLoPtr3
        INX
        CPX #$06
        BEQ CollisionReturnEarly
        CPX #$0E
        BEQ CollisionReturnEarly
        JMP UpdateAttackShipsMSBXPositionLoop

CollisionReturnEarly   
        RTS

;-------------------------------------------------------
; DetectAttackShipCollisionWithGilby
;-------------------------------------------------------
DetectAttackShipCollisionWithGilby
        LDY #$00
        LDA levelEntrySequenceActive
        BNE CollisionReturnEarly
        LDA attractModeCountdown
        BNE CollisionReturnEarly

        LDA setToZeroIfOnUpperPlanet
        BEQ b503C

        ; Incrememnt Y if on lower planet.
        INY

b503C   LDX setToZeroIfOnUpperPlanet
        ; X is now $00 if on upper planet, $08 if on lower planet.
        INX
        INX
        ; X is now $02 if on upper planet, $10 if on lower planet.

CheckCollisionsLoop
        CLC
        LDA upperPlanetAttackShipsMSBXPosArray + $01,X
        BEQ b5048
        SEC
b5048   LDA upperPlanetAttackShipsXPosArray + $01,X
        ROR
        SEC
        SBC #$58
        BPL b5053
        EOR #$FF
b5053   CMP #$08
        BMI b505A
        JMP GoToNextShip

b505A   LDA upperPlanetAttackShipsYPosArray + $01,X
        SEC
        ; Y is set to $01 above if we are on the lower planet, so this
        ; will reference gilbyVerticalPositionLowerPlanet.
        SBC gilbyVerticalPositionUpperPlanet,Y
        BPL b5065
        EOR #$FF
b5065   CMP #$08
        BMI b506C
        JMP GoToNextShip

tempXStorage = tempLoPtr3
b506C   STX tempXStorage
        LDA indexIntoAttackWaveDataHiPtrArray,X
        TAX
        LDA #$FF
        STA shipHasAlreadyBeenHitByGilby,X
        LDX tempXStorage

GoToNextShip
        INX
        CPX #$06
        BEQ ExitRTS
        CPX #$0E
        BEQ ExitRTS
        JMP CheckCollisionsLoop

ExitRTS
        RTS

controlPanelData =*-$01
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
                   .BYTE $20,$20,$20,$20,$20,$20,$20,$20
controlPanelColors .BYTE BROWN,BROWN,BLACK,WHITE,WHITE,WHITE,WHITE
                   .BYTE BLACK,BLACK,WHITE,WHITE,WHITE,WHITE,WHITE,WHITE
                   .BYTE WHITE,WHITE,WHITE,WHITE,WHITE,BLACK,BLACK,WHITE
                   .BYTE WHITE,WHITE,WHITE,BLACK,YELLOW,YELLOW,BLACK,WHITE
                   .BYTE WHITE,WHITE,WHITE,WHITE,WHITE,WHITE,WHITE,WHITE
                   .BYTE WHITE,BROWN,BROWN,BLACK,RED,YELLOW,YELLOW,GREEN
                   .BYTE GREEN,YELLOW,YELLOW,RED,BLACK,BLACK,BLACK,BLACK
                   .BYTE BLACK,BLACK,BLACK,WHITE,WHITE,WHITE,WHITE,BLACK
                   .BYTE BLACK,BLACK,BLACK,BLACK,YELLOW,YELLOW,BLACK,YELLOW
                   .BYTE YELLOW,PURPLE,PURPLE,LTBLUE,LTBLUE,ORANGE,ORANGE,LTRED
                   .BYTE LTRED,BLUE,BLUE,BLACK,RED,YELLOW,YELLOW,GREEN
                   .BYTE GREEN,YELLOW,YELLOW,RED,BLACK,BLACK,RED,RED
                   .BYTE ORANGE,ORANGE,YELLOW,YELLOW,GREEN,GREEN,LTBLUE,LTBLUE
                   .BYTE PURPLE,PURPLE,BLUE,BLUE,YELLOW,YELLOW,BLACK,YELLOW
                   .BYTE YELLOW,PURPLE,PURPLE,LTBLUE,LTBLUE,ORANGE,ORANGE,LTRED
                   .BYTE LTRED,BLUE,BLUE,BLACK,WHITE,WHITE,WHITE,WHITE
                   .BYTE BLACK,BLACK,WHITE,WHITE,WHITE,WHITE,WHITE,WHITE
                   .BYTE WHITE,WHITE,WHITE,WHITE,WHITE,BLACK,BLACK,WHITE
                   .BYTE WHITE,WHITE,WHITE,BLACK,YELLOW,YELLOW,BLACK,WHITE
                   .BYTE WHITE,WHITE,WHITE,WHITE,WHITE,WHITE,WHITE,WHITE
                   .BYTE WHITE


; This is the hiptr (e.g. $9200, $9000) array into the character sets for each planet.
planetCharsetDataHiPtrArray   .BYTE >planet1Charset,>planet2Charset,>planet3Charset
                              .BYTE >planet4Charset,>planet5Charset
;-------------------------------------------------------
; PerformPlanetWarp
;-------------------------------------------------------
PerformPlanetWarp
        LDX topPlanetPointerIndex
        LDA planetCharsetDataHiPtrArray,X
        STA currentTopPlanetDataHiPtr
        LDA #$00
        STA currentTopPlanetDataLoPtr

        LDX bottomPlanetPointerIndex
        LDA planetCharsetDataHiPtrArray,X
        STA currentBottomPlanetDataHiPtr
        LDA #$00
        STA currentBottomPlanetDataLoPtr
        JSR WriteInitialWarpStateToScreen

        LDA shouldResetPlanetEntropy
        BNE b51F7

        LDA #$08
        STA upperPlanetEntropyStatus
        STA lowerPlanetEntropyStatus

b51F7   LDA topPlanetPointerIndex
        STA oldTopPlanetIndex
        LDA bottomPlanetPointerIndex
        STA oldBottomPlanetIndex
        JSR MapPlanetProgressToLevelText

        LDX #$08
b5208   LDA #EXPLOSION_START
        STA upperPlanetAttackShipSpritesLoadedFromBackingData - $01,X
        LDA #$F0
        STA upperPlanetAttackShipSpriteAnimationEnd - $01,X
        LDA dataToResetOnPlanet,X
        STA pieceOfPlanetData,X
        DEX
        BNE b5208

        STX shouldResetPlanetEntropy
        JSR ResetRepetitionForPrimarySoundEffect
        JSR ResetRepetitionForSecondarySoundEffect

        LDA #<planetWarpSoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>planetWarpSoundEffect
        STA secondarySoundEffectHiPtr
        LDA #<planetWarpSoundEffect2
        STA primarySoundEffectLoPtr
        LDA #>planetWarpSoundEffect2
        STA primarySoundEffectHiPtr
        ;Fall through

;-------------------------------------------------------
; DrawPlanetProgressPointers
;-------------------------------------------------------
DrawPlanetProgressPointers
        LDX #$0A
        LDA #$20
b523C   STA SCREEN_RAM + LINE21_COL29,X
        STA SCREEN_RAM + LINE24_COL29,X
        DEX
        BNE b523C

        LDX topPlanetPointerIndex
        LDY planetProgressPointersOffsets,X
        LDA #$98 ; Top world progress pointer
        STA SCREEN_RAM + LINE21_COL29,Y
        LDX bottomPlanetPointerIndex
        LDY planetProgressPointersOffsets,X
        LDA #$99 ; Bottom world progress pointer
        STA SCREEN_RAM + LINE24_COL29,Y
        RTS

                              .BYTE $02,$02,$02,$03,$04,$05,$06,$07
                              .BYTE $08,$30,$30,$30,$20,$18,$10,$0C
                              .BYTE $0A,$06,$04,$02

dataToResetOnPlanet           .BYTE $01,$00,$00,$01,$01,$00,$04,$20

                              .BYTE $00

shouldResetPlanetEntropy      .BYTE $00,$08,$08
unusedVariable1               .BYTE $00
unusedVariable3               .BYTE $00
controlPanelIsGrey            .BYTE $01
planetProgressPointersOffsets .BYTE $01,$03,$05,$07,$09

;-------------------------------------------------------
; UpdateControlPanelColors
;-------------------------------------------------------
UpdateControlPanelColors
        LDA gilbyVerticalPositionUpperPlanet
        CMP #$50
        BMI b52A7
        LDA #$01
        STA controlPanelColorDoesntNeedUpdating
b5290   RTS

RestoreControlPanelColors
        LDA controlPanelIsGrey
        BEQ b5290

        LDX #$A0
b5298   LDA controlPanelColors - $01,X
        STA COLOR_RAM + LINE20_COL39,X
        DEX
        BNE b5298

        LDA #$00
        STA controlPanelIsGrey
b52A6   RTS

b52A7   LDA controlPanelIsGrey
        BNE b52A6
        LDA #$02
        STA controlPanelColorDoesntNeedUpdating
        RTS

ResetControlPanelToGrey
        LDX #$A0
        LDA #GRAY1
b52B6   STA COLOR_RAM + LINE20_COL39,X
        DEX
        BNE b52B6
        LDA #$01
        STA controlPanelIsGrey
        RTS

;-------------------------------------------------------
; UpdateControlPanelColor
;-------------------------------------------------------
UpdateControlPanelColor
        LDY #$00
        STY controlPanelColorDoesntNeedUpdating
        CMP #$01
        BEQ RestoreControlPanelColors
        BNE ResetControlPanelToGrey

controlPanelColorDoesntNeedUpdating   .BYTE $00

screenTmpPtrLo = $46
screenTmpPtrHi = $47
;-------------------------------------------------------
; WriteInitialWarpStateToScreen
; Writes storage for top and bottom planets to $0763 and $07B3
;-------------------------------------------------------
WriteInitialWarpStateToScreen
        LDA #>SCREEN_RAM + LINE21_COL27
        STA screenTmpPtrHi ; Actually the hi ptr here
        LDA #<SCREEN_RAM + LINE21_COL27
        STA screenTmpPtrLo ; Actually the lo ptr here

        ; For the top planet
        LDX topPlanetPointerIndex
        JSR UpdateWarpStateOnScreen

        ; For the bottom planet
        LDA #<SCREEN_RAM + LINE23_COL27
        STA screenTmpPtrLo
        LDX bottomPlanetPointerIndex

;-------------------------------------------------------
; UpdateWarpStateOnScreen
;-------------------------------------------------------
UpdateWarpStateOnScreen
        TXA
        ASL
        ASL
        CLC
        ADC #$9A
        LDY #$00
        STA (screenTmpPtrLo),Y
        LDY #$28
        CLC
        ADC #$01
        STA (screenTmpPtrLo),Y
        LDY #$01
        CLC
        ADC #$01
        STA (screenTmpPtrLo),Y
        LDY #$29
        CLC
        ADC #$01
        STA (screenTmpPtrLo),Y
        LDA #$DB
        STA screenTmpPtrHi
        LDA warpEffectForPlanet,X
        LDY #$00
        STA (screenTmpPtrLo),Y
        INY
        STA (screenTmpPtrLo),Y
        LDY #$28
        STA (screenTmpPtrLo),Y
        INY
        STA (screenTmpPtrLo),Y
        LDA #>SCREEN_RAM + LINE19_COL8
        STA screenTmpPtrHi
        RTS

warpEffectForPlanet           .BYTE $07,$04,$0E,$08,$0A

pointsEarnedTopPlanetByte1    .BYTE $00
pointsEarnedTopPlanetByte2    .BYTE $00
pointsEarnedBottomPlanetByte1 .BYTE $00
pointsEarnedBottomPlanetByte2 .BYTE $00
;-------------------------------------------------------
; UpdateScores
;-------------------------------------------------------
UpdateScores
        LDA pointsEarnedTopPlanetByte2
        BNE b532F
        LDA pointsEarnedTopPlanetByte1
        BEQ b5350

        ; Update the top planet score
b532F   LDX #$06
b5331   INC SCREEN_RAM + LINE21_COL12,X
        LDA SCREEN_RAM + LINE21_COL12,X
        CMP #$3A
        BNE b5343
        LDA #$30
        STA SCREEN_RAM + LINE21_COL12,X
        DEX
        BNE b5331

b5343   DEC pointsEarnedTopPlanetByte1
        LDA pointsEarnedTopPlanetByte1
        CMP #$FF
        BNE b5350
        DEC pointsEarnedTopPlanetByte2

b5350   LDA pointsEarnedBottomPlanetByte2
        BNE b535A
        LDA pointsEarnedBottomPlanetByte1
        BEQ b537B

        ; Update the bottom planet score.
b535A   LDX #$06
b535C   INC SCREEN_RAM + LINE24_COL12,X
        LDA SCREEN_RAM + LINE24_COL12,X
        CMP #$3A
        BNE b536E
        LDA #$30
        STA SCREEN_RAM + LINE24_COL12,X
        DEX
        BNE b535C
b536E   DEC pointsEarnedBottomPlanetByte1
        LDA pointsEarnedBottomPlanetByte1
        CMP #$FF
        BNE b537B
        DEC pointsEarnedBottomPlanetByte2
b537B   RTS

;-------------------------------------------------------
; InitializeEnergyBars
;-------------------------------------------------------
InitializeEnergyBars
        LDX #$03
        STX currEnergyTop
        STX currEnergyBottom
b5384   LDA #$80 ; Char for energy bars
        STA SCREEN_RAM + LINE22_COL3,X
        STA SCREEN_RAM + LINE23_COL3,X
        LDA #$20
        STA SCREEN_RAM + LINE22_COL7,X
        STA SCREEN_RAM + LINE23_COL7,X
        DEX
        CPX #$FF
        BNE b5384

        STA SCREEN_RAM + LINE22_COL11
        STA SCREEN_RAM + LINE23_COL11
        LDA #$00
        STA currCoreEnergyLevel
        LDX #$0E
        LDA #$20
b53A8   STA SCREEN_RAM + LINE23_COL12,X
        DEX
        BNE b53A8
        LDA #$87
        STA SCREEN_RAM + LINE23_COL13
b53B3   RTS

currEnergyTop                        .BYTE $03
currEnergyBottom                     .BYTE $03
currCoreEnergyLevel                  .BYTE $00
extraAmountToDecreaseEnergyByTopPlanet    .BYTE $00
extraAmountToDecreaseEnergyByBottomPlanet .BYTE $00
;-------------------------------------------------------
; DecreaseEnergyStorage
;-------------------------------------------------------
DecreaseEnergyStorage
        DEC updateEnergyStorageInterval
        BNE b53B3
        LDA #$04
        STA updateEnergyStorageInterval

        LDA extraAmountToDecreaseEnergyByTopPlanet
        BEQ UpdateEnergyStorageBottomPlanet

        ;Color the 'Energy' label.
        DEC extraAmountToDecreaseEnergyByTopPlanet
        LDX extraAmountToDecreaseEnergyByTopPlanet
        LDA energyLabelColors,X
        LDY #$04
b53D3   STA COLOR_RAM + LINE21_COL2,Y
        DEY
        BNE b53D3

        LDX currEnergyTop
        INC SCREEN_RAM + LINE22_COL3,X
        LDA SCREEN_RAM + LINE22_COL3,X
        CMP #$88
        BNE UpdateEnergyStorageBottomPlanet
        LDA #$20
        STA SCREEN_RAM + LINE22_COL3,X
        DEX
        STX currEnergyTop
        CPX #$FF
        BNE UpdateEnergyStorageBottomPlanet

GilbyDiedBecauseEnergyDepleted
        LDA #$00
        STA reasonGilbyDied ; Energy Depleted
        JMP GilbyDied
        ; Returns

UpdateEnergyStorageBottomPlanet
        LDA extraAmountToDecreaseEnergyByBottomPlanet
        BEQ b542B

        DEC extraAmountToDecreaseEnergyByBottomPlanet
        LDX extraAmountToDecreaseEnergyByBottomPlanet

        LDA energyLabelColors,X
        LDY #$04
b540B   STA COLOR_RAM + LINE24_COL2,Y
        DEY
        BNE b540B

        LDX currEnergyBottom
        INC SCREEN_RAM + LINE23_COL3,X
        LDA SCREEN_RAM + LINE23_COL3,X
        CMP #$88
        BNE b542B
        LDA #$20
        STA SCREEN_RAM + LINE23_COL3,X
        DEX
        STX currEnergyBottom
        CPX #$FF
        BEQ GilbyDiedBecauseEnergyDepleted
b542B   RTS

energyLabelColors           .BYTE WHITE,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
                            .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
                            .BYTE BLUE
updateEnergyStorageInterval .BYTE $01

;-------------------------------------------------------
; DepleteEnergyTop
;-------------------------------------------------------
DepleteEnergyTop
        STX temporaryStorageForXRegister
        LDX currEnergyTop
        INC SCREEN_RAM + LINE22_COL3,X
        LDA SCREEN_RAM + LINE22_COL3,X
        CMP #$88
        BNE b547B
        LDA #$20
        STA SCREEN_RAM + LINE22_COL3,X
        DEX
        STX currEnergyTop
        CPX #$FF
        BNE b547B
b545B   JMP GilbyDiedBecauseEnergyDepleted

;-------------------------------------------------------
; DepleteEnergyBottom
;-------------------------------------------------------
DepleteEnergyBottom
        STX temporaryStorageForXRegister
        LDX currEnergyBottom
        INC SCREEN_RAM + LINE23_COL3,X
        LDA SCREEN_RAM + LINE23_COL3,X
        CMP #$88
        BNE b547B
        LDA #$20
        STA SCREEN_RAM + LINE23_COL3,X
        DEX
        STX currEnergyBottom
        CMP #$FF
        BEQ b545B
b547B   LDX temporaryStorageForXRegister
        RTS

;-------------------------------------------------------
; GilbyDiesFromExcessEnergy
;-------------------------------------------------------
GilbyDiesFromExcessEnergy
        LDA #$01
        STA reasonGilbyDied ; Overload (too much energy)
        JMP GilbyDied

;-------------------------------------------------------
; IncreaseEnergyTop
;-------------------------------------------------------
IncreaseEnergyTop
        STX temporaryStorageForXRegister
        LDX currEnergyTop
        DEC SCREEN_RAM + LINE22_COL3,X
        LDA SCREEN_RAM + LINE22_COL3,X
        CMP #$7F
        BNE b547B
        LDA #$80
        STA SCREEN_RAM + LINE22_COL3,X
        INX
        STX currEnergyTop
        CPX #$08
        BEQ GilbyDiesFromExcessEnergy
        LDA #$87
        STA SCREEN_RAM + LINE22_COL3,X
        BNE b547B

;-------------------------------------------------------
; IncreaseEnergyBottom
;-------------------------------------------------------
IncreaseEnergyBottom
        STX temporaryStorageForXRegister
        LDX currEnergyBottom
        DEC SCREEN_RAM + LINE23_COL3,X
        LDA SCREEN_RAM + LINE23_COL3,X
        CMP #$7F
        BNE b547B
        LDA #$80
        STA SCREEN_RAM + LINE23_COL3,X
        INX
        STX currEnergyBottom
        CPX #$08
        BEQ GilbyDiesFromExcessEnergy
        LDA #$87
        STA SCREEN_RAM + LINE23_COL3,X
        BNE b547B

;-------------------------------------------------------
; UpdateCoreEnergyLevel
;-------------------------------------------------------
UpdateCoreEnergyLevel
        LDX currCoreEnergyLevel
        CPX #$FF
        BNE UpdateCoreGraphic
        INX
        STX currCoreEnergyLevel
        LDA #$87
        STA SCREEN_RAM + LINE23_COL13
UpdateCoreGraphic   
        DEC SCREEN_RAM + LINE23_COL13,X
        LDA SCREEN_RAM + LINE23_COL13,X
        CMP #$7F
        BNE ReturnFromCoreEnergyLevel
        LDA #$80
        STA SCREEN_RAM + LINE23_COL13,X
        INX
        CPX #$0E
        BEQ MaybeEarnedBonusPhase

FinalizeLevelAndReturn
        LDA #$87
        STA SCREEN_RAM + LINE23_COL13,X
        STX currCoreEnergyLevel
        RTS

MaybeEarnedBonusPhase   
        LDA lowerPlanetActivated
        BEQ EarnedBonusPhase
        DEX
        JMP FinalizeLevelAndReturn

EarnedBonusPhase   
        INC bonusPhaseEarned
ReturnFromCoreEnergyLevel   
        RTS

bonusPhaseEarned   .BYTE $00
;-------------------------------------------------------
; IncreaseCoreEnergyLevel
;-------------------------------------------------------
IncreaseCoreEnergyLevel
        LDX currCoreEnergyLevel
        CPX #$FF
        BEQ b5528
        INC SCREEN_RAM + LINE23_COL13,X
        LDA SCREEN_RAM + LINE23_COL13,X
        CMP #$88
        BNE ReturnFromCoreEnergyLevel
        LDA #$20
        STA SCREEN_RAM + LINE23_COL13,X
        DEX
        STX currCoreEnergyLevel
        CPX #$FF
        BNE ReturnFromCoreEnergyLevel
b5528   RTS

temporaryStorageForXRegister   .BYTE $00

;-------------------------------------------------------
; UpdateCoreEnergyValues
;-------------------------------------------------------
UpdateCoreEnergyValues
        LDA gilbyIsOverLand
        BNE b5530
b552F   RTS

b5530   LDA gilbyCurrentState
        BNE b552F
        LDA currEnergyTop
        CMP #$04
        BPL b5547
        JSR IncreaseCoreEnergyLevel
        BEQ b554D
        JSR IncreaseEnergyTop
        JMP b554D

b5547   JSR UpdateCoreEnergyLevel
        JSR DepleteEnergyTop
b554D   LDA currEnergyBottom
        CMP #$04
        BPL b555C
        JSR IncreaseCoreEnergyLevel
        BEQ b552F
        JMP IncreaseEnergyBottom

b555C   JSR UpdateCoreEnergyLevel
        JMP DepleteEnergyBottom

;-------------------------------------------------------
; IncreaseEnergyTopOnly
;-------------------------------------------------------
IncreaseEnergyTopOnly
        ; Byte 35; Energy increase multiplier.
        LDY #35
        LDA (currentShipWaveDataLoPtr),Y
        BEQ NormalTopEnergyIncrease
        STA energyChangeCounter
EnergyTopIncreaseLoop
        JSR IncreaseEnergyTop
        DEC energyChangeCounter
        BNE EnergyTopIncreaseLoop
        RTS

NormalTopEnergyIncrease
        JMP IncreaseEnergyTop
        ;Returns

;-------------------------------------------------------
; IncreaseEnergyBottomOnly
;-------------------------------------------------------
IncreaseEnergyBottomOnly
        ; Byte 35; Energy increase multiplier.
        LDY #35
        LDA (currentShipWaveDataLoPtr),Y
        BEQ NormalBottomEnergyIncrease
        STA energyChangeCounter
EnergyBottomIncreaseLoop
        JSR IncreaseEnergyBottom
        DEC energyChangeCounter
        BNE EnergyBottomIncreaseLoop
        RTS

NormalBottomEnergyIncrease
        JMP IncreaseEnergyBottom
        ;Returns

updateLevelForBottomPlanet  .BYTE $01
currentLevelInCurrentPlanet .BYTE $09
;-------------------------------------------------------
; UpdateLevelText
;-------------------------------------------------------
UpdateLevelText
        LDA #$01
        STA hasEnteredNewLevel
        LDA updateLevelForBottomPlanet
        BNE b55BD

        LDA #$30
        STA SCREEN_RAM + LINE21_COL24
        STA SCREEN_RAM + LINE21_COL25
        LDX currentLevelInCurrentPlanet
        BEQ b55B6

        ; Update the current level (top planet)
b55A1   INC SCREEN_RAM + LINE21_COL25
        LDA SCREEN_RAM + LINE21_COL25
        CMP #$3A
        BNE b55B3
        LDA #$30
        STA SCREEN_RAM + LINE21_COL25
        INC SCREEN_RAM + LINE21_COL24
b55B3   DEX
        BNE b55A1

b55B6   LDA oldTopPlanetIndex
        PHA
        JMP UpdateLevelData


        ; Update the current level (bottom planet)
b55BD   LDA #$30
        STA SCREEN_RAM + LINE24_COL24
        STA SCREEN_RAM + LINE24_COL25
        LDX currentLevelInCurrentPlanet
        BEQ b55DF

b55CA   INC SCREEN_RAM + LINE24_COL25
        LDA SCREEN_RAM + LINE24_COL25
        CMP #$3A
        BNE b55DC
        LDA #$30
        STA SCREEN_RAM + LINE24_COL25
        INC SCREEN_RAM + LINE24_COL24
b55DC   DEX
        BNE b55CA
b55DF   LDA oldBottomPlanetIndex
        PHA

;-------------------------------------------------------
; UpdateLevelData
;-------------------------------------------------------
UpdateLevelData
        LDA #<levelDataPerPlanet
        STA levelDataPtrLo
        LDA #>levelDataPerPlanet
        STA levelDataPtrHi

        ; Get the current planet
        PLA
        TAX
        BEQ b55FF

        ; X is the current planet.
        ; Move the pointer to the location in levelDataPerPlanet for the
        ; current planet.
b55EF   LDA levelDataPtrLo
        CLC
        ADC #$28
        STA levelDataPtrLo
        LDA levelDataPtrHi
        ADC #$00
        STA levelDataPtrHi
        DEX
        BNE b55EF

        ; Use currentLevelInCurrentPlanet as an index into the section
        ; of levelDataPerPlanet for the level in the current planet. What we're
        ; retrieving here is a pointer to the data in planetData.
b55FF   LDA currentLevelInCurrentPlanet
        ASL
        TAY
        LDA (levelDataPtrLo),Y
        PHA
        INY
        LDA (levelDataPtrLo),Y
        PHA
        LDA updateLevelForBottomPlanet
        BNE b5644

        ; Update the level data for the top planet
        PLA
        STA topPlanetLevelDataLoPtr
        STA levelDataPtrLo
        PLA
        STA topPlanetLevelDataHiPtr
        STA levelDataPtrHi
        LDY #$26
        LDX oldTopPlanetIndex
        LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        BEQ b5628
        BNE b562A

        ; Byte 38: (Index $26) Number of ships in wave.
        ; Y is $26
b5628   LDA (levelDataPtrLo),Y
b562A   STA enemiesKilledTopPlanetsSinceLastUpdate,X
        LDA enemiesKilledTopPlanetSinceLastUpdate
        BNE b5638
        LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        STA enemiesKilledTopPlanetSinceLastUpdate
b5638   DEY
        ; Byte 37: (Index $25) Number of waves in data.
        LDA (levelDataPtrLo),Y
        STA topPlanetStepsBetweenAttackWaveUpdates
        LDA #$00
        STA unusedVariable1
        RTS

        ; Update the level data for the bottom planet.
b5644   PLA
        STA bottomPlanetLevelDataLoPtr
        STA levelDataPtrLo
        PLA
        STA bottomPlanetLevelDataHiPtr
        STA levelDataPtrHi
        LDY #$26
        LDX oldBottomPlanetIndex
        LDA enemiesKilledBottomPlanetsSinceLastUpdate,X
        BEQ b565C
        BNE b565E
b565C   LDA (levelDataPtrLo),Y
b565E   STA enemiesKilledBottomPlanetsSinceLastUpdate,X
        LDA enemiesKilledBottomPlanetSinceLastUpdate
        BNE b566C
        LDA enemiesKilledBottomPlanetsSinceLastUpdate,X
        STA enemiesKilledBottomPlanetSinceLastUpdate
b566C   DEY
        LDA (levelDataPtrLo),Y
        STA bottomPlanetStepsBetweenAttackWaveUpdates
        LDA #$00
        STA unusedVariable3
        RTS

;-------------------------------------------------------
; UpdateTopPlanetProgressData
;-------------------------------------------------------
UpdateTopPlanetProgressData
        STX temporaryStorageForXRegister
        LDX oldTopPlanetIndex
        DEC enemiesKilledTopPlanetsSinceLastUpdate,X
        LDA enemiesKilledTopPlanetSinceLastUpdate
        BNE b568C
        LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        STA enemiesKilledTopPlanetSinceLastUpdate
b568C   LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        BNE ReturnFromPlanetProgress
        INC currentLevelInTopPlanets,X
        LDA currentLevelInTopPlanets,X
        CMP #$14
        BNE b569E
        DEC currentLevelInTopPlanets,X
b569E   LDA #$04
        STA gilbyExploding
        LDA #$03
        STA starFieldInitialStateArray - $01
        LDA currentLevelInTopPlanets,X
        STA currentLevelInCurrentPlanet
        LDA #$00
        STA updateLevelForBottomPlanet
        JSR CheckProgressInPlanet
        JSR UpdateLevelText
ReturnFromPlanetProgress   
        LDX temporaryStorageForXRegister
        RTS

;-------------------------------------------------------
; UpdateBottomPlanetProgressData
;-------------------------------------------------------
UpdateBottomPlanetProgressData
        STX temporaryStorageForXRegister
        LDX oldBottomPlanetIndex
        DEC enemiesKilledBottomPlanetsSinceLastUpdate,X
        LDA enemiesKilledBottomPlanetSinceLastUpdate
        BNE b56D1
        LDA enemiesKilledBottomPlanetsSinceLastUpdate,X
        STA enemiesKilledBottomPlanetSinceLastUpdate
b56D1   LDA enemiesKilledBottomPlanetsSinceLastUpdate,X
        BNE ReturnFromPlanetProgress
        INC currentLevelInBottomPlanets,X
        LDA currentLevelInBottomPlanets,X
        CMP #$14
        BNE b56E3
        DEC currentLevelInBottomPlanets,X
b56E3   LDA #$04
        STA gilbyExploding
        LDA #$03
        STA starFieldInitialStateArray - $01
        LDA currentLevelInBottomPlanets,X
        STA currentLevelInCurrentPlanet
        LDA #$01
        STA updateLevelForBottomPlanet
        JSR CheckProgressInPlanet
        JSR UpdateLevelText
        JMP ReturnFromPlanetProgress

;-------------------------------------------------------
; InitializePlanetProgressArrays
;-------------------------------------------------------
InitializePlanetProgressArrays
        LDX #$05
        LDA #$00
b5705   STA bottomPlanetLevelDataHiPtr,X
        STA enemiesKilledBottomPlanetsSinceLastUpdatePtr,X
        STA currentLevelInTopPlanetsPtr,X
        STA enemiesKilledTopPlanetsSinceLastUpdatePtr,X
        DEX
        BNE b5705
        RTS

;-------------------------------------------------------
; MapPlanetProgressToLevelText
;-------------------------------------------------------
MapPlanetProgressToLevelText
        LDX topPlanetPointerIndex
        LDA currentLevelInTopPlanets,X
        STA currentLevelInCurrentPlanet
        LDA #$00
        STA updateLevelForBottomPlanet
        JSR UpdateLevelText
        INC updateLevelForBottomPlanet
        LDX bottomPlanetPointerIndex
        LDA currentLevelInBottomPlanets,X
        STA currentLevelInCurrentPlanet
        JMP UpdateLevelText

;-------------------------------------------------------
; CalculatePointsForByte2
;-------------------------------------------------------
CalculatePointsForByte2
        LDX lastRegisteredScoringRate
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
        STA pointsToAddToPointsEarnedByte2
        PLA
b5751   RTS

pointsToAddToPointsEarnedByte2   .BYTE $00
;-------------------------------------------------------
; CheckProgressInPlanet
;-------------------------------------------------------
CheckProgressInPlanet
        LDX #$09
        LDA attractModeCountdown
        BNE b5751
        LDA #$13
b575C   
        CMP currentLevelInTopPlanets,X
        BNE b5767
        DEX
        BPL b575C
        INC bonusAwarded
b5767   
        LDA bonusBountiesEarned
        BNE b5751
        LDX oldTopPlanetIndex
        LDY currentTopPlanet
        LDX #$00
b5774   
        LDA enemiesKilledBottomPlanetsSinceLastUpdatePtr,Y
        CMP everyThirdLevelInPlanet,X
        BMI b578E
        INX
        DEY
        BNE b5774
        LDX currentTopPlanet
        CPX currentBottomPlanet
        BEQ b5791
        INX
        CPX currentBottomPlanet
        BEQ b5791
b578E   JMP CheckProgressInBottomPlanet

b5791   LDA currentTopPlanet
        CMP #$05
        BEQ b578E
        INC currentTopPlanet
        INC progressDisplaySelected
        LDA #$00
        STA lowerPlanetActivated
        JMP CheckProgressInBottomPlanet

everyThirdLevelInPlanet   .BYTE $03,$06,$09,$0C,$0F
;-------------------------------------------------------
; CheckProgressInBottomPlanet
;-------------------------------------------------------
CheckProgressInBottomPlanet
        LDY currentBottomPlanet
        LDX #$00
b57B0   LDA currentLevelInTopPlanetsPtr,Y
        CMP everyThirdLevelInPlanet,X
        BMI b57CA
        INX
        DEY
        BNE b57B0
        LDX currentBottomPlanet
        CPX currentTopPlanet
        BEQ b57CB
        INX
        CPX currentTopPlanet
        BEQ b57CB
b57CA   RTS

b57CB   LDA currentBottomPlanet
        CMP #$05
        BEQ b57CA
        INC currentBottomPlanet
        INC progressDisplaySelected
        LDA #$00
        STA lowerPlanetActivated
        RTS

;-------------------------------------------------------
; AugmentAmountToDecreaseEnergyByBountiesEarned
;-------------------------------------------------------
AugmentAmountToDecreaseEnergyByBountiesEarned
        STY tempStorageForYRegister
        LDY bonusBountiesEarned
        CLC
        ADC amountToDecreaseEnergyByOffsetArray,Y
        LDY tempStorageForYRegister
        RTS

tempStorageForYRegister             .BYTE $23
amountToDecreaseEnergyByOffsetArray .BYTE $00,$0A,$14,$1E,$28,$32,$3C,$46
                                    .BYTE $50
;-------------------------------------------------------
; GilbyDied
;-------------------------------------------------------
GilbyDied
        LDA #$01
        STA gilbyHasJustDied
        LDA levelRestartInProgress
        BNE ReturnEarlyFromGilbyDied
        LDA attractModeCountdown
        BNE ReturnEarlyFromGilbyDied

        LDX #$00
InitializeGilbyExplosion   
        LDA #TEARDROP_EXPLOSION1
        STA explosionSprite
        LDA #$00
        STA gilbyExplosionColorIndex
        STA explosionXPosOffset1,X
        INX
        CPX #$03
        BNE InitializeGilbyExplosion

        LDA #$01
        STA gilbyExploding
        LDA #$03
        STA starFieldInitialStateArray - $01
        LDA #<gilbyDiedSoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>gilbyDiedSoundEffect
        STA secondarySoundEffectHiPtr
        JSR ResetRepetitionForSecondarySoundEffect
        LDX #$23
        RTS

ReturnEarlyFromGilbyDied   
        RTS

mapPlanetEntropyToColor  .BYTE WHITE,YELLOW,CYAN,GREEN,PURPLE
explosionXPosOffSet      .BYTE $02,$06,$00
explosionXPosOffset1     .BYTE $50,$A0,$40
explosionSprite          .BYTE $FE
gilbyExplosionColorIndex .BYTE $08
;-------------------------------------------------------
; ProcessGilbyExplosion
;-------------------------------------------------------
ProcessGilbyExplosion
        LDA gilbyExploding
        BEQ GilbyIsExploding
        RTS

GilbyIsExploding   
        LDA #$F0
        STA Sprite0Ptr
        INC explosionXPosOffset1
        INC explosionXPosOffset1 + $01
        INC explosionXPosOffset1 + $01
        LDA explosionXPosOffset1 + $02
        CLC
        ADC #$04
        STA explosionXPosOffset1 + $02

        LDX #$00
ExplosionLoop
        LDA explosionSprite
        STA upperPlanetGilbyBulletSpriteValue,X
        STA lowerPlanetGilbyBulletSpriteValue,X
        LDY gilbyExplosionColorIndex
        LDA mapPlanetEntropyToColor,Y
        STA upperPlanetGilbyBulletColor,X
        STA lowerPlanetGilbyBulletColor,X
        LDA gilbyVerticalPositionUpperPlanet
        STA upperPlanetGilbyBulletYPos,X
        EOR #$FF
        CLC
        ADC #$0C
        STA lowerPlanetGilbyBulletYPos,X
        LDA #$00
        STA upperPlanetGilbyBulletMSBXPosValue,X
        STA lowerPlanetAttackShip2MSBXPosValue,X
        CPX #$03
        BPL b58A9
        LDA #$B0
        CLC
        ADC explosionXPosOffset1,X
        STA upperPlanetGilbyBulletXPos,X
        STA lowerPlanetAttackShip2XPos,X
        BCC b58A6
        LDA gilbyBulletMSBXPosOffset,X
        STA upperPlanetGilbyBulletMSBXPosValue,X
        STA lowerPlanetAttackShip2MSBXPosValue,X
b58A6   JMP CheckAndLoop

b58A9   LDA #$B0
        SEC
        SBC explosionXPosOffSet,X
        STA upperPlanetGilbyBulletXPos,X
        STA lowerPlanetAttackShip2XPos,X

CheckAndLoop
        INX
        CPX #$06
        BNE ExplosionLoop

        INC explosionSprite
        LDA explosionSprite
        CMP #TEARDROP_EXPLOSION1 + $03
        BNE ExplosionSpriteStillAnimating

        LDA #TEARDROP_EXPLOSION1
        STA explosionSprite

ExplosionSpriteStillAnimating   
        DEC explosionInProgress
        BNE ReturnFromGilbyExplosion
        LDA #$0A
        STA explosionInProgress
        INC gilbyExplosionColorIndex
        LDA gilbyExplosionColorIndex
        STA gilbyExploding
        LDY #$02
        STY starFieldInitialStateArray - $01
        CMP #$08
        BNE ReturnFromGilbyExplosion
        JMP SetUpLevelRestart

ReturnFromGilbyExplosion   
        RTS

explosionInProgress    .BYTE $0A
gilbyDiedSoundEffect   .BYTE $00,PLAY_SOUND,$0F,VOICE2_ATK_DEC,$00
                       .BYTE $00,PLAY_SOUND,$0F,VOICE3_ATK_DEC,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE2_SUS_REL,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE3_SUS_REL,$00
                       .BYTE $00,PLAY_SOUND,$80,VOICE2_HI,$00
                       .BYTE $00,PLAY_SOUND,$40,VOICE3_HI,$00
                       .BYTE $00,PLAY_SOUND,$81,VOICE2_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$81,VOICE3_CTRL,$02
                       .BYTE $08,INC_AND_PLAY_FROM_BUFFER,$0C,VOICE2_HI,$00
                       .BYTE $0F,INC_AND_PLAY_FROM_BUFFER,$0C,VOICE3_HI,$01
                       .BYTE $00,REPEAT_PREVIOUS,$1C,$00,$00
                       .BYTE $00,PLAY_SOUND,$20,VOICE2_HI,$00
                       .BYTE $00,PLAY_SOUND,$20,VOICE3_HI,$00
                       .BYTE $00,PLAY_SOUND,$81,VOICE2_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$21,VOICE3_CTRL,$02
                       .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$01,VOICE2_HI,$00
                       .BYTE $0F,DEC_AND_PLAY_FROM_BUFFER,$45,VOICE3_HI,$01
                       .BYTE $00,REPEAT_PREVIOUS,$1F,$00,$00
                       .BYTE $00,PLAY_SOUND,$10,VOICE2_HI,$02
                       .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$01,VOICE2_HI,$00
                       .BYTE $0F,DEC_AND_PLAY_FROM_BUFFER,$01,VOICE3_HI,$00
                       .BYTE $18,DEC_AND_PLAY_FROM_BUFFER,$01,VOLUME,$01
                       .BYTE $00,REPEAT_PREVIOUS,$0F,$00,$00
                       .BYTE $00,PLAY_SOUND,$80,VOICE2_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$80,VOICE3_CTRL,$00
                       .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

;-------------------------------------------------------
; SetUpLevelRestart
;-------------------------------------------------------
SetUpLevelRestart
        LDX #$00
b596E   LDA #$C0 ; Starfield sprite
        STA upperPlanetGilbyBulletSpriteValue,X
        STA lowerPlanetGilbyBulletSpriteValue,X
        INX
        CPX #$06
        BNE b596E

        LDA #$01
        STA levelRestartInProgress

        JSR SetUpGilbySprite

        LDA oldTopPlanetIndex
        STA topPlanetPointerIndex

        LDA oldBottomPlanetIndex
        STA bottomPlanetPointerIndex

        JSR PerformPlanetWarp

        LDA #$01
        STA levelEntrySequenceActive
        STA entryLevelSequenceCounter

        LDA #<levelRestartSoundEffect1
        STA primarySoundEffectLoPtr

        LDA #>levelRestartSoundEffect1
        STA primarySoundEffectHiPtr

        LDA #<levelRestartSoundEffect2
        STA secondarySoundEffectLoPtr

        LDA #>levelRestartSoundEffect2
        STA secondarySoundEffectHiPtr

        LDA #NO_SPRITES
        STA $D015    ;Sprite display Enable
        JSR ResetRepetitionForPrimarySoundEffect
        JMP ResetRepetitionForSecondarySoundEffect
        ; Returns

levelRestartInProgress .BYTE $00
gilbiesLeft            .BYTE $02

;-------------------------------------------------------
; FlashBackgroundAndBorder
;-------------------------------------------------------
FlashBackgroundAndBorder
        LDY txtGilbiesLeft
        LDA colorsForFlashBackgroundAndBorderEffect,Y
        STA $D021    ;Background Color 0
        INY
        LDA colorsForFlashBackgroundAndBorderEffect,Y
        BEQ b59D8
        STY txtGilbiesLeft

        LDA $D012    ;Raster Position
        CLC
        ADC #$01
        STA $D012    ;Raster Position
        BNE b5A03

b59D8   LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2

        JSR PlaySoundEffects

        LDX #$1F
        LDA initialColorForFlashEffect
        PHA
b59E9   LDA colorsForFlashBackgroundAndBorderEffect,X
        STA colorsForFlashBackgroundAndBorderEffect + $01,X
        DEX
        BPL b59E9

        PLA
        STA colorsForFlashBackgroundAndBorderEffect
        LDA #$40
        STA $D012    ;Raster Position
        LDA #$00
        STA txtGilbiesLeft
        STA $D020    ;Border Color

        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
b5A03   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;-------------------------------------------------------
; PlayerKilled
;-------------------------------------------------------
PlayerKilled
        JSR ClearScreen3
        DEC gilbiesLeft
        BPL b5A1E
        BEQ b5A1E
        JMP DisplayGameOver

        ; Get a random number between 0 and 7
b5A1E   JSR PutProceduralByteInAccumulatorRegister
        AND #$07 ; Make it a number between 0 and 7
        TAY
        JSR DrawRestartLevelText

        ;Draw the gilbies left text
        LDX #$14
b5A29   LDA txtGilbiesLeft,X
        AND #$3F
        STA SCREEN_RAM + LINE6_COL8,X
        DEX
        BNE b5A29

        JSR DrawReasonGilbyDied

        ; Show remaining gilbies
        LDA gilbiesLeft
        CLC
        ADC #$31
        STA SCREEN_RAM + LINE6_COL25

        ; Get a random number between 0 and 7
        JSR PutProceduralByteInAccumulatorRegister
        AND #$07 ; Make it a number between 0 and 7
        CLC
        ADC #$08 ; Selects the 'encouragement text' in the second half of txtRestartLevelMsg
        TAY
        ;Fall through

;-------------------------------------------------------
; DrawRestartLevelText
;-------------------------------------------------------
DrawRestartLevelText
        LDA #<txtRestartLevelMsg
        STA tmpPtrLo
        LDA #>txtRestartLevelMsg
        STA tmpPtrHi
        STY tmpPtrZp47 ; Random byte picked by PutProceduralByteInAccumulatorRegister
        CPY #$00
        BEQ b5A67

        ; With a random number between 0 and 7 in tmpPtrZp47, switch
        ; the pointers to one of the 8 messages in txtRestartLevelMsg.
b5A57   LDA tmpPtrLo
        CLC
        ADC #$14 ; Each message is 20 bytes long
        STA tmpPtrLo
        LDA tmpPtrHi
        ADC #$00
        STA tmpPtrHi
        DEY
        BNE b5A57

b5A67   LDA tmpPtrZp47 ; Random byte picked by PutProceduralByteInAccumulatorRegister
        AND #$08
        BNE b5A7A

b5A6D   LDA (tmpPtrLo),Y
        AND #$3F
        STA SCREEN_RAM + LINE4_COL9,Y
        INY
        CPY #$14
        BNE b5A6D
        RTS  ; Returns early

b5A7A   LDA (tmpPtrLo),Y
        AND #$3F
        STA SCREEN_RAM + LINE8_COL9,Y
        INY
        CPY #$14
        BNE b5A7A

        LDA #$30
        STA tmpPtrLo
b5A8A   LDX #$40
b5A8C   DEY
        BNE b5A8C
        DEX
        BNE b5A8C
        DEC tmpPtrLo
        BNE b5A8A
        ;Fall through

;-------------------------------------------------------
; ClearScreen3
;-------------------------------------------------------
ClearScreen3
        LDX #$00
b5A98   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + LINE6_COL16,X
        STA SCREEN_RAM + LINE12_COL32,X
        STA SCREEN_RAM + LINE14_COL24,X
        LDA #WHITE
        STA COLOR_RAM + LINE0_COL0,X
        STA COLOR_RAM + LINE6_COL16,X
        STA COLOR_RAM + LINE12_COL32,X
        STA COLOR_RAM + LINE14_COL24,X
        DEX
        BNE b5A98
        RTS

txtGilbiesLeft     .TEXT $00, "  GILBIES LEFT: 0.. "
txtRestartLevelMsg .TEXT "TAKE OUT THAT BRIDGE% % I BET THAT HURT!"
                   .TEXT "GOT YOU, SPACE CADET%% SUPPERS READY! %%"
                   .TEXT "ZAPPED AGAIN........ONE DESTRUCTED DROID"
                   .TEXT "YOU BLEW THAT ONE!..ARE YOU NERVOUS??..."
                   .TEXT "GO GIVE THEM HELL!!!GO FORTH AND KILL!!!"
                   .TEXT "HAPPY HUNTING, ACE!!SEEK AND ANNIHILATE!"
                   .TEXT "YAK SEZ GO ZAP 'EM!!FLY FAST AND MEAN..."
                   .TEXT "LASERBLAZE THE SCUM!HEAVY METAL THUNDER"
                   .BYTE $21

levelRestartSoundEffect1 .BYTE $00,PLAY_SOUND,$0F,VOICE1_ATK_DEC,$00
                         .BYTE $00,PLAY_SOUND,$00,VOICE1_SUS_REL,$00
                         .BYTE $00,PLAY_SOUND,$20,VOICE1_HI,$00
                         .BYTE $00,PLAY_SOUND,$21,VOICE1_CTRL,$02
                         .BYTE $01,DEC_AND_PLAY_FROM_BUFFER,$43,VOICE1_HI,$01
                         .BYTE $00,REPEAT_PREVIOUS,$F0,$00,$00
                         .BYTE $00,PLAY_SOUND,$20,VOICE1_CTRL,$00
                         .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00
levelRestartSoundEffect2 .BYTE $00,PLAY_SOUND,$0F,VOLUME,$00
                         .BYTE $00,PLAY_SOUND,$0F,VOICE2_ATK_DEC,$00
                         .BYTE $00,PLAY_SOUND,$0F,VOICE3_ATK_DEC,$00
                         .BYTE $00,PLAY_SOUND,$00,VOICE2_SUS_REL,$00
                         .BYTE $00,PLAY_SOUND,$00,VOICE3_SUS_REL,$01
f5C4E                    .BYTE $00,PLAY_SOUND,$10,VOICE2_HI,$00
                         .BYTE $00,PLAY_SOUND,$10,VOICE3_HI,$00
                         .BYTE $00,PLAY_SOUND,$21,VOICE2_CTRL,$00
                         .BYTE $00,PLAY_SOUND,$21,VOICE3_CTRL,$02
                         .BYTE $08,INC_AND_PLAY_FROM_BUFFER,$04,VOICE2_HI,$00
                         .BYTE $0F,INC_AND_PLAY_FROM_BUFFER,$04,VOICE3_HI,$01
                         .BYTE $00,REPEAT_PREVIOUS,$05,$00,$00
                         .BYTE $00,PLAY_SOUND,$10,VOICE2_HI,$00
                         .BYTE $00,PLAY_SOUND,$10,VOICE3_HI,$00
                         .BYTE $00,PLAY_SOUND,$11,VOICE2_CTRL,$00
                         .BYTE $00,PLAY_SOUND,$11,VOICE3_CTRL,$02
f5C85                    .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$02,VOICE2_HI,$00
                         .BYTE $0F,DEC_AND_PLAY_FROM_BUFFER,$02,VOICE3_HI,$01
                         .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                         .BYTE VOLUME,PLAY_LOOP,$01,<f5C4E,>f5C4E
                         .BYTE $00,PLAY_SOUND,$10,VOICE2_CTRL,$00
                         .BYTE $00,PLAY_SOUND,$10,VOICE3_CTRL,$00
                         .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax

colorsForFlashBackgroundAndBorderEffect
        .BYTE ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE,GRAY3,GRAY3,GRAY2
        .BYTE GRAY3,GRAY2,GRAY2,GRAY1,GRAY2,GRAY1,GRAY1,$80
        .BYTE GRAY1,$80,$80,GRAY1,$80,GRAY1,GRAY1,GRAY2
        .BYTE GRAY1,GRAY2,GRAY2,GRAY3,GRAY2,GRAY3,GRAY3

initialColorForFlashEffect   .BYTE $02,$00

;-------------------------------------------------------
; DrawLevelEntryAndWarpGilbyAnimation
; This is the multi-coloured level entry effect where 7 gilbys
; spread across the screen.
;-------------------------------------------------------
DrawLevelEntryAndWarpGilbyAnimation
        LDX #$00
b5CCB   LDA gilbyVerticalPositionUpperPlanet
        STA upperPlanetAttackShipsYPosArray + $01,X
        EOR #$FF
        CLC
        ADC #$08
        STA lowerPlanetAttackShipsYPosArray + $01,X
        LDA currentGilbySprite
        STA upperPlanetAttackShipsSpriteValueArray + $01,X
        CLC
        ADC #$13
        STA lowerPlanetAttackShipsSpriteValueArray + $01,X
        LDA colorSequenceArray,X
        STA upperPlanetAttackShipsColorArray + $01,X
        STA lowerPlanetAttackShipsColorArray + $01,X
        LDA currentGilbySpeed
        BMI b5D0B

        LDA initialXPosArray1,X
        STA upperPlanetAttackShipsXPosArray + $01,X
        LDA #$00
        STA upperPlanetAttackShipsMSBXPosArray + $01,X
        LDA initialXPosArray2,X
        STA lowerPlanetAttackShipsXPosArray + $02,X
        LDA #$00
        STA lowerPlanetAttackShipsMSBXPosArray + $02,X
        BEQ b5D21

b5D0B   LDA initialXPosArray2,X
        STA upperPlanetAttackShipsXPosArray + $01,X
        LDA #$00
        STA upperPlanetAttackShipsMSBXPosArray + $01,X
        LDA initialXPosArray1,X
        STA lowerPlanetAttackShipsXPosArray + $02,X
        LDA #$00
        STA lowerPlanetAttackShipsMSBXPosArray + $02,X
b5D21   INX
        CPX #$06
        BNE b5CCB
        RTS

initialXPosArray1      .BYTE $B8,$C0,$C8,$D0,$D8,$E0
initialXPosArray2      .BYTE $A8,$A0,$98,$90,$88,$80

VOICE2_LO = $07
VOICE3_LO = $0E
planetWarpSoundEffect  .BYTE $00,PLAY_SOUND,$0F,VOICE2_ATK_DEC,$00
                       .BYTE $00,PLAY_SOUND,$0F,VOICE3_ATK_DEC,$00
                       .BYTE $00,PLAY_SOUND,$0F,VOLUME,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE2_SUS_REL,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE3_SUS_REL,$00
                       .BYTE $00,PLAY_SOUND,$03,VOICE2_HI,$00
                       .BYTE $00,PLAY_SOUND,$03,VOICE3_HI,$00
                       .BYTE $00,PLAY_SOUND,$21,VOICE2_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$08,VOICE3_LO,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE2_LO,$00
fPlanetWarpLoop        .BYTE $00,PLAY_SOUND,$21,VOICE3_CTRL,$01
                       .BYTE VOLUME,PLAY_LOOP,$00,<fPlanetWarpLoop,>fPlanetWarpLoop
                       .BYTE $00,PLAY_SOUND,$20,VOICE2_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$20,VOICE3_CTRL,$00
                       .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

planetWarpSoundEffect2 .BYTE $00,PLAY_SOUND,$0F,VOICE1_ATK_DEC,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE1_SUS_REL,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE1_HI,$00
f5D8D                  .BYTE $00,PLAY_SOUND,$11,VOICE1_CTRL,$02
f5D92                  .BYTE $01,INC_AND_PLAY_FROM_BUFFER,$64,VOICE1_HI,$01
f5D97                  .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                       .BYTE $01,INC_AND_PLAY_FROM_BUFFER,$18,VOICE1_HI,$01
                       .BYTE VOLUME,PLAY_LOOP,$01,<f5D8D,>f5D8D
                       .BYTE $00,PLAY_SOUND,$10,VOICE1_CTRL,$00
                       .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

levelEntrySoundEffect  .BYTE $00,PLAY_SOUND,$0F,VOICE2_ATK_DEC,$00
                       .BYTE $00,PLAY_SOUND,$0F,VOICE3_ATK_DEC,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE2_SUS_REL,$00
                       .BYTE $00,PLAY_SOUND,$00,VOICE3_SUS_REL,$00
                       .BYTE $00,PLAY_SOUND,$10,VOICE2_HI,$00
                       .BYTE $00,PLAY_SOUND,$15,VOICE3_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$20,VOICE2_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$0F,VOLUME,$00
f5DD8                  .BYTE $00,PLAY_SOUND,$40,VOICE3_HI,$02
                       .BYTE $0F,DEC_AND_PLAY_FROM_BUFFER,$28,VOICE3_HI,$01
                       .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                       .BYTE VOLUME,PLAY_LOOP,$05,<f5DD8,>f5DD8
                       .BYTE $00,PLAY_SOUND,$80,VOICE2_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$80,VOICE3_CTRL,$00
                       .BYTE $00,PLAY_SOUND,$0F,VOLUME,$00
                       .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00
;-------------------------------------------------------
; UpdateDisplayedScoringRate
;-------------------------------------------------------
UpdateDisplayedScoringRate
        LDA #$23
        STA SCREEN_RAM + LINE22_COL23
        LDA #WHITE
        STA COLOR_RAM + LINE22_COL23
        LDA currentGilbySpeed
        BPL b5E14
        EOR #$FF
        CLC
        ADC #$01
b5E14   TAX
        LDA scoreToScoringRateMap,X
        TAY
        LDA scoringRateToScoreMap,Y
        CLC
        ADC #$30
        STA SCREEN_RAM + LINE22_COL24
        LDA scoreColors,Y
        STA COLOR_RAM + LINE22_COL24
        STY lastRegisteredScoringRate
        RTS

scoreToScoringRateMap .BYTE $00,$00,$01,$01,$01,$01,$02,$02
                      .BYTE $02,$02,$02,$02,$02,$02,$03,$03
                      .BYTE $04,$04,$03,$02,$02,$01,$01,$01
                      .BYTE $01,$01,$01,$01,$01,$01
scoringRateToScoreMap .BYTE $00,$01,$02,$04,$08
scoreColors           .BYTE BLUE,PURPLE,GREEN,YELLOW,WHITE

lastRegisteredScoringRate   .BYTE $01
;-------------------------------------------------------
; InitializePlanetEntropyStatus
;-------------------------------------------------------
InitializePlanetEntropyStatus
        LDA lowerPlanetActivated
        BEQ b5E5D
        JMP ReturnFromSub

b5E5D   LDA setToZeroIfOnUpperPlanet
        BEQ UpperPlanetInitializePlanetEntropyStatus

        ; Initialize the entropy on the lower planet if that's
        ; where we are.
        LDA #$08
        STA lowerPlanetEntropyStatus
        BNE SkipToUpdateEntropy

UpperPlanetInitializePlanetEntropyStatus   
        LDA #$08
        STA upperPlanetEntropyStatus

SkipToUpdateEntropy   
        DEC entropyUpdateRate
        BEQ MaybeUpdateDisplayedEntropy
        BNE UpdateDisplayedEntropyStatus

entropyUpdateRate        .BYTE $A3
upperPlanetEntropyStatus .BYTE $08
lowerPlanetEntropyStatus .BYTE $08
entropyDisplayUpdateRate  .BYTE $23

;-------------------------------------------------------
; MaybeUpdateDisplayedEntropy
;-------------------------------------------------------
MaybeUpdateDisplayedEntropy
        DEC entropyDisplayUpdateRate
        BNE UpdateDisplayedEntropyStatus
        LDA #$10
        STA entropyDisplayUpdateRate
        LDA #$00
        STA currentEntropy

        ; We update the entropy of the planet we're not on. So if
        ; we're on the upper planet we update the entropy of the lower.
        LDA setToZeroIfOnUpperPlanet
        BEQ UpdateLowerPlanetEntropy

        DEC upperPlanetEntropyStatus
        BNE b5E95
        INC currentEntropy
b5E95   LDA upperPlanetEntropyStatus
        CMP #$FF ; Decremented past zero?
        BNE UpdateDisplayedEntropyStatus

EntropyKillsGilby
        LDA #$02
        STA reasonGilbyDied ; Entropy
        JMP GilbyDied
        ; Returns

        ; Not reached.
        BNE UpdateDisplayedEntropyStatus

UpdateLowerPlanetEntropy   
        DEC lowerPlanetEntropyStatus
        BNE b5EAE
        INC currentEntropy
b5EAE   LDA lowerPlanetEntropyStatus
        CMP #$FF
        BNE UpdateDisplayedEntropyStatus
        JMP EntropyKillsGilby

;-------------------------------------------------------
; UpdateDisplayedEntropyStatus
; This is the planet entropy status for the upper and
; lower plants, on the bottom left hand side of the screen.
;-------------------------------------------------------
UpdateDisplayedEntropyStatus
        LDA #$08
        SEC
        SBC upperPlanetEntropyStatus
        TAY
        LDA mapPlanetEntropyToColor,Y
        STA COLOR_RAM + LINE21_COL0
        STA COLOR_RAM + LINE21_COL1
        STA COLOR_RAM + LINE22_COL0
        STA COLOR_RAM + LINE22_COL1
        LDA #$08
        SEC
        SBC lowerPlanetEntropyStatus
        TAY
        LDA mapPlanetEntropyToColor,Y
        STA COLOR_RAM + LINE23_COL0
        STA COLOR_RAM + LINE23_COL1
        STA COLOR_RAM + LINE24_COL0
        STA COLOR_RAM + LINE24_COL1
        JMP ReturnFromSub

        .FILL 5,$C0
        .FILL 4,$00

unusedVariableArray .BYTE $00,$08,$08,$08,$08,$08

ReturnFromSub   RTS

                                         .BYTE $00,$02,$04,$06,$08
enemiesKilledTopPlanetSinceLastUpdate    .BYTE $00
enemiesKilledBottomPlanetSinceLastUpdate .BYTE $00
txtEnemiesLeftCol1                       .BYTE $30
txtEnemiesLeftCol2                       .BYTE $30

;-------------------------------------------------------
; UpdateEnemiesLeft
;-------------------------------------------------------
UpdateEnemiesLeft
        LDA #ZERO
        STA txtEnemiesLeftCol1
        STA txtEnemiesLeftCol2
        LDA enemiesKilledTopPlanetSinceLastUpdate
        BEQ UpdateSpeedometer

UpdateEnemiesLeftDisplayUpperPlanet   
        JSR UpdateEnemiesLeftStorage
        DEC enemiesKilledTopPlanetSinceLastUpdate
        BNE UpdateEnemiesLeftDisplayUpperPlanet
        LDA txtEnemiesLeftCol1
        STA SCREEN_RAM + LINE21_COL7
        LDA txtEnemiesLeftCol2
        STA SCREEN_RAM + LINE21_COL8

UpdateSpeedometer   
        LDA currentGilbySpeed
        BNE GilbyIsMoving

        LDA #$01
        ; Update speedomoter
GilbyIsMoving   
        ; Push the current speed onto the stack so we can use it
        ; when updating the lower planet.
        PHA
        TAY
        LDA colorSequenceArray,Y
        STA COLOR_RAM + LINE21_COL7
        STA COLOR_RAM + LINE21_COL8

        LDA lowerPlanetActivated
        BEQ UpdateEnemiesLeftTextLowerPlanet

        ; No lower planet, so return early.
        PLA
        RTS

UpdateEnemiesLeftTextLowerPlanet   
        LDA #ZERO
        STA txtEnemiesLeftCol1
        STA txtEnemiesLeftCol2
        LDA enemiesKilledBottomPlanetSinceLastUpdate
        BEQ UpdateSpeedometerLowerPlanet

UpdateEnemiesLeftDisplayLowerPlanet   
        JSR UpdateEnemiesLeftStorage
        DEC enemiesKilledBottomPlanetSinceLastUpdate
        BNE UpdateEnemiesLeftDisplayLowerPlanet
        LDA txtEnemiesLeftCol1
        STA SCREEN_RAM + LINE24_COL7
        LDA txtEnemiesLeftCol2
        STA SCREEN_RAM + LINE24_COL8

UpdateSpeedometerLowerPlanet   
        ; Pull the speed from the stack from when we checked it above.
        PLA
        TAY
        LDA colorSequenceArray,Y
        STA COLOR_RAM + LINE24_COL7
        STA COLOR_RAM + LINE24_COL8
        RTS

;-------------------------------------------------------
; UpdateEnemiesLeftStorage
;-------------------------------------------------------
UpdateEnemiesLeftStorage
        INC txtEnemiesLeftCol2
        LDA txtEnemiesLeftCol2
        CMP #$3A
        BNE b5F77
        LDA #$01
        STA txtEnemiesLeftCol2
b5F76   RTS

b5F77   CMP #$07
        BNE b5F76
        LDA #$30
        STA txtEnemiesLeftCol2
        INC txtEnemiesLeftCol1
        LDA txtEnemiesLeftCol1
        CMP #$3A
        BNE b5F76
        LDA #$01
        STA txtEnemiesLeftCol1
        RTS

statusBarDetailStorage =*-$01
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
        .BYTE $9F,$A1,$A3,$A5,$A7,$A9,$AB,$AD,$8D
        .BYTE $8F,$20,$90,$92,$91,$93,$20,$20
        .BYTE $AE,$B0,$AF,$B1,$30,$30,$30,$30
        .BYTE $30,$30,$30,$20,$20,$B2,$B4,$30
        .BYTE $30,$20,$9B,$9D,$20,$99,$20,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20
;-------------------------------------------------------
; StoreStatusBarDetail
;-------------------------------------------------------
StoreStatusBarDetail
        LDX #$A0
b6032   LDA SCREEN_RAM + LINE20_COL39,X
        STA statusBarDetailStorage,X
        DEX
        BNE b6032
        RTS

;-------------------------------------------------------
; DrawStatusBarDetail
;-------------------------------------------------------
DrawStatusBarDetail
        LDX #$A0
b603E   LDA statusBarDetailStorage,X
        STA SCREEN_RAM + LINE20_COL39,X
        DEX
        BNE b603E
b6047   RTS

;-----------------------------------------------------------
; DrawLowerPlanetWhileInactive
; Draws the lower planet for the early levels when it isn't
; active yet.
;-----------------------------------------------------------
DrawLowerPlanetWhileInactive
        LDA lowerPlanetActivated
        BEQ b6047

        LDX #$28
DrawLowerTextLoop   
        LDA textForInactiveLowerPlanet - $01,X
        AND #$3F
        STA SCREEN_RAM + LINE18_COL39,X
        LDA #WHITE
        STA COLOR_RAM + LINE18_COL39,X
        DEX
        BNE DrawLowerTextLoop

        LDX #$28
DrawInactiveSurfaceLoop   
        LDA surfaceDataInactiveLowerPlanet,X
        CLC
        ADC #$40
        STA SCREEN_RAM + LINE14_COL39,X
        DEX
        BNE DrawInactiveSurfaceLoop

        LDX #$10
DrawWarpGateInactive   
        LDY xPosSecondLevelSurfaceInactivePlanet,X
        LDA secondLevelSurfaceDataInactivePlanet,X
        CLC
        ADC #$40
        STA SCREEN_RAM + LINE12_COL4,Y
        DEX
        BNE DrawWarpGateInactive
        RTS

; The *-$01 is because the array index starts at 1 rather than 0.
xPosSecondLevelSurfaceInactivePlanet =*-$01
       .BYTE $00,$01,$02,$03,$28,$29,$2A,$2B
       .BYTE $50,$51,$52,$53,$78,$79,$7A,$7B
secondLevelSurfaceDataInactivePlanet =*-$01 
       .BYTE $30,$32,$38,$3A,$31,$33,$39,$3B
       .BYTE $34,$36,$3C,$3E,$35,$37,$3D,$3F
surfaceDataInactiveLowerPlanet =*-$01       
       .BYTE $01,$03,$01,$03,$01,$03,$01,$03
       .BYTE $01,$03,$01,$03,$01,$03,$01,$03
       .BYTE $01,$03,$01,$03,$01,$03,$01,$03
       .BYTE $01,$03,$01,$03,$01,$03,$1D,$1F
       .BYTE $00,$02,$00,$02,$00,$02,$00,$02

textForInactiveLowerPlanet
      .TEXT "  WARP GATE       GILBY   CORE  NOT-CORE"
progressDisplaySelected .BYTE $00
;-------------------------------------------------------
; DrawProgressDisplayScreen
;-------------------------------------------------------
DrawProgressDisplayScreen
        JSR ClearScreen3

        LDX bonusBountiesEarned
        BEQ b6105

        ;Display bonus bounties
b60F8   LDA #$1C
        STA SCREEN_RAM - $01,X
        LDA #$07
        STA $D7FF,X
        DEX
        BNE b60F8

b6105   LDY #BLACK
        STY $D020    ;Border Color
        STY $D021    ;Background Color 0

        ; Draw the progress map
b610D   LDX #$0A
b610F   LDA progressMapTopPlanetScreenPtrArrayHi - $01,X
        STA tempHiPtr
        LDA progressMapScreenTopPlanetPtrArrayLo - $01,X
        STA tempLoPtr
        LDA #$2D ; Progress chart tick
        STA (tempLoPtr),Y
        LDA tempHiPtr
        CLC
        ADC #$D4
        STA tempHiPtr
        LDA #$0B
        STA (tempLoPtr),Y
        DEX
        BNE b610F
        INY
        CPY #$14
        BNE b610D

        ; Draw for each planet
        LDX #$00
b6132   LDY currentLevelInTopPlanets,X
        JSR DrawProgressForTopPlanets
        LDY currentLevelInBottomPlanets,X
        JSR DrawProgressForBottomPlanets
        INX
        CPX #$05
        BNE b6132

        JSR DrawPlanetIconsOnProgressDisplay

        LDX #$27
b6148   LDA txtGilbiesLeftBonusBounty,X
        AND #$3F
        STA SCREEN_RAM + LINE19_COL0,X
        LDA #YELLOW
        STA COLOR_RAM + LINE19_COL0,X
        DEX
        BPL b6148

        LDX #$06
b615A   LDA currentBonusBountyPtr,X
        STA SCREEN_RAM + LINE19_COL33,X
        DEX
        BNE b615A
        LDA gilbiesLeft
        CLC
        ADC #$31
        STA SCREEN_RAM + LINE19_COL13
        RTS

txtGilbiesLeftBonusBounty   .TEXT "GILBIES LEFT 0: BONUS BOUNTY NOW 0000000"

b6195   RTS

;-------------------------------------------------------
; DrawProgressForTopPlanets
;-------------------------------------------------------
DrawProgressForTopPlanets
        LDA progressMapTopPlanetScreenPtrArrayHi,X
        CLC
        ADC #$D4
        STA tempHiPtr
        LDA progressMapScreenTopPlanetPtrArrayLo,X
        STA tempLoPtr

DrawProgressForThePlanet
        CPY #$00
        BEQ b6195
        LDA #$02
b61A9   STA (tempLoPtr),Y
        CPY #$00
        BEQ b6195
        DEY
        LDA #$05
        BNE b61A9

;-------------------------------------------------------
; DrawProgressForBottomPlanets
;-------------------------------------------------------
DrawProgressForBottomPlanets
        LDA progressMapBottomPlanetScreenPtrArrayHi,X
        CLC
        ADC #$D4
        STA tempHiPtr
        LDA progressMapScreenBottomPlanetPtrArrayLo,X
        STA tempLoPtr
        JMP DrawProgressForThePlanet

; This is an array of pointers to the screen. For example the
; first one is $04F0. It is used to draw the progress map in the
; progress display screen.
progressMapTopPlanetScreenPtrArrayHi    .BYTE $04,$04,$04,$04,$04
progressMapBottomPlanetScreenPtrArrayHi .BYTE $05,$05,$05,$05,$05
progressMapScreenTopPlanetPtrArrayLo    .BYTE $F0,$CB,$A6,$81,$5C
progressMapScreenBottomPlanetPtrArrayLo .BYTE $18,$43,$6E,$99,$C4

; As above, but for the planet icons.
planetIconsHiPtrArray                    .BYTE $04,$04
                                         .BYTE $04,$04,$04,$05,$05,$05,$05,$05
planetIconsLoPtrArray                    .BYTE $A0,$7B,$56,$31,$0C,$40,$6B,$96
                                         .BYTE $C1,$EC
;-------------------------------------------------------
; ShowProgressScreen
;-------------------------------------------------------
ShowProgressScreen
        LDA #BLACK
        STA $D015    ;Sprite display Enable
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA lastKeyPressed
        JSR DrawProgressDisplayScreen

        LDX #$28
b61FE   LDA txtProgressStatusLine1 - $01,X
        AND #$3F
        STA SCREEN_RAM + LINE14_COL39,X
        LDA #WHITE
        STA COLOR_RAM + LINE14_COL39,X
        DEX
        BNE b61FE

        CLI
        LDA #$05
        STA tempHiPtr
        LDX #$00
        LDY #$00
b6217   DEY
        BNE b6217
        DEX
        BNE b6217
        DEC tempHiPtr
        BNE b6217

        LDX #$28
b6223   LDA txtProgressStatusLine2,X
        AND #$3F
        STA SCREEN_RAM + LINE16_COL39,X
        LDA #YELLOW
        STA COLOR_RAM + LINE16_COL39,X
        DEX
        BNE b6223

        ; Wait for the player to press fire to dismiss the screen.
b6233   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ b6233

        ; Make them press fire twice!
b623A   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BNE b623A

        LDA #$00
        STA progressDisplaySelected
        RTS

;-------------------------------------------------------
; DrawPlanetIconsOnProgressDisplay
;-------------------------------------------------------
DrawPlanetIconsOnProgressDisplay
        LDX #$00
b6249   LDA planetIconsLoPtrArray,X
        STA tempLoPtr
        LDA planetIconsHiPtrArray,X
        STA tempHiPtr
        LDA offsetsIntoPlanetIconsPtrArray,X
        STA tempHiPtr1
        TXA
        PHA

        ; The array is seeded with the 4 characters for the first
        ; planet icon, simply incrementing from there gives the values
        ; for the characters for the subsequent icons.
        LDX #$00
b625C   LDY offsetIntoPlanetIconSeedArray,X
        LDA progressDisplayPlanetIconSeedArray,X
        CLC
        ADC tempHiPtr1
        STA (tempLoPtr),Y
        INX
        CPX #$04
        BNE b625C
        LDX #$0B
        PLA
        STA tempHiPtr1
        LDY tempHiPtr1
        CPY #$05
        BMI b6287
        LDA tempHiPtr1
        SEC
        SBC #$05
        STA tempLoPtr1
        LDY currentBottomPlanet
        DEY
        CPY tempLoPtr1
        JMP j628D

b6287   LDY currentTopPlanet
        DEY
        CPY tempHiPtr1

j628D
        BMI b6291
        LDX #$01
b6291   TXA
        PHA
        LDX #$00
        LDA tempHiPtr
        CLC
        ADC #$D4
        STA tempHiPtr
        PLA
b629D   LDY offsetIntoPlanetIconSeedArray,X
        STA (tempLoPtr),Y
        INX
        CPX #$04
        BNE b629D
        LDX tempHiPtr1
        INX
        CPX #$0A
        BNE b6249
        RTS

offsetIntoPlanetIconSeedArray      .BYTE $00,$01,$28,$29
progressDisplayPlanetIconSeedArray .BYTE $9A,$9C,$9B,$9D,$9A,$9C,$9B,$9D
offsetsIntoPlanetIconsPtrArray     .BYTE $00,$04,$08,$0C,$10,$00,$04,$08
                                   .BYTE $0C,$10
;-------------------------------------------------------
; GameSwitchAndGameOverInterruptHandler
;-------------------------------------------------------
GameSwitchAndGameOverInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b62D2
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

b62D2   JSR PlaySoundEffects
        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$20
        STA $D012    ;Raster Position
        JMP ReEnterInterrupt

txtProgressStatusLine1 .TEXT "IRIDIS ALPHA: PROGRESS STATUS DISPLAY %"
txtProgressStatusLine2 .TEXT "%PRESS THE FIRE BUTTON WHEN YOU ARE READY"

VOICE1_PLS_LO = $02
transferToUpperPlanetSoundEffect  .BYTE $00,PLAY_SOUND,$20,VOICE1_CTRL,$00
                                  .BYTE $00,PLAY_SOUND,$03,VOICE1_PLS_LO,$00
                                  .BYTE $00,PLAY_SOUND,$21,VOICE1_CTRL,$00
f6344                             .BYTE $00,PLAY_SOUND,$60,VOICE1_HI,$02
                                  .BYTE $01,INC_AND_PLAY_FROM_BUFFER,$10,VOICE1_HI,$01
                                  .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                                  .BYTE $02,PLAY_LOOP,$01,<f6344,>f6344
                                  .BYTE $00,PLAY_SOUND,$20,VOICE1_CTRL,$00
                                  .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00
transferToLowerPlanetSoundEffect
                                  .BYTE $00,PLAY_SOUND,$20,VOICE1_CTRL,$00
                                  .BYTE $00,PLAY_SOUND,$03,VOICE1_PLS_LO,$00
                                  .BYTE $00,PLAY_SOUND,$21,VOICE1_CTRL,$00
f6371                             .BYTE $00,PLAY_SOUND,$A0,VOICE1_HI,$02
                                  .BYTE $01,DEC_AND_PLAY_FROM_BUFFER,$10,VOICE1_HI,$01
                                  .BYTE $00,REPEAT_PREVIOUS,$08,$00,$00
                                  .BYTE $02,PLAY_LOOP,$01,<f6371,>f6371
                                  .BYTE $00,PLAY_SOUND,$20,VOICE1_CTRL,$00
                                  .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00
enemySprites2 = $E800
;-------------------------------------------------------
; SwapTitleScreenDataAndSpriteLevelData
; Swap data in $E800 (some enemy sprites and level data) to
; $810, where the title screen data and logic normally lives.
; In other words, swap a big chunk of sprite and level data
; into the position in memory where the title screen logic lives.
; At 'Game Over' this will get swapped back.
;-------------------------------------------------------
SwapTitleScreenDataAndSpriteLevelData
        SEI
        LDA #$34
        STA RAM_ACCESS_MODE
        LDA #<LaunchCurrentProgram
        STA tempLoPtr1
        LDA #>LaunchCurrentProgram
        STA tempHiPtr1
        LDA #>enemySprites2
        STA tempHiPtr
        LDA #<enemySprites2
        STA tempLoPtr

b63A4   LDY #$00
b63A6   LDA (tempLoPtr1),Y
        PHA
        LDA (tempLoPtr),Y
        STA (tempLoPtr1),Y
        PLA
        STA (tempLoPtr),Y
        DEY
        BNE b63A6
        INC tempHiPtr1
        INC tempHiPtr
        LDA tempHiPtr
        CMP #$F9
        BNE b63A4

        LDA #$36
        STA RAM_ACCESS_MODE
        RTS

;-------------------------------------------------------
; EnterMainTitleScreen ($63C5)
;-------------------------------------------------------
EnterMainTitleScreen
        JSR SwapTitleScreenDataAndSpriteLevelData
        JSR LaunchCurrentProgram
        SEI
        LDA #<GameSwitchAndGameOverInterruptHandler
        STA $314    ;IRQ
        LDA #>GameSwitchAndGameOverInterruptHandler
        STA $315    ;IRQ
        JMP SwapTitleScreenDataAndSpriteLevelData
        ; Returns

;-------------------------------------------------------
; DisplayGameOver
;-------------------------------------------------------
DisplayGameOver
        SEI
        LDA #<GameSwitchAndGameOverInterruptHandler
        STA $314    ;IRQ
        LDA #>GameSwitchAndGameOverInterruptHandler
        STA $315    ;IRQ
        CLI
        LDA #BLACK
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        JSR DrawProgressDisplayScreen
        LDA #$00
        STA bonusBountiesEarned
        STA currentTopPlanet
        STA currentBottomPlanet

        ;Draw the game over text and final score
        LDX #$0A
b63FA   LDA txtGameOver,X
        AND #$3F
        STA SCREEN_RAM + LINE4_COL29,X
        LDA txtFinalScore,X
        AND #$3F
        STA SCREEN_RAM + LINE6_COL29,X
        LDA txtFinalScoreValue,X
        AND #$3F
        STA SCREEN_RAM + LINE8_COL29,X
        LDA #WHITE
        STA COLOR_RAM + LINE4_COL29,X
        STA COLOR_RAM + LINE6_COL29,X
        LDA #PURPLE
        STA COLOR_RAM + LINE8_COL29,X
        DEX
        BPL b63FA

        JMP AnimateFinalScoreTally
        ;Returns

txtGameOver        .TEXT "GAME OVER.."
txtFinalScore      .TEXT "FINAL SCORE"
txtFinalScoreValue .TEXT "  0000000  "
;-------------------------------------------------------
; AnimateFinalScoreTally
;-------------------------------------------------------
AnimateFinalScoreTally
        LDA #$5E
        STA tempLoPtr
        LDA #$05
        STA tempHiPtr
        LDA #<SCREEN_RAM + LINE21_COL12
        STA tempLoPtr1
        LDA #>SCREEN_RAM + LINE21_COL12
        STA tempHiPtr1
        JSR IncrementFinalScoreTally
        LDA #$CC
        STA tempLoPtr1
        JSR IncrementFinalScoreTally
        LDA #$18
        STA tempLoPtr1
        JSR IncrementFinalScoreTally
        LDY #$C6
        LDX #$49
        LDA #<DrawProgressDisplayScreen
        STA jumpToDrawProgressLoPtr
        LDA #>DrawProgressDisplayScreen
        STA jumpToDrawProgressHiPtr
        LDA #<currentLevelInTopPlanets
        STA currentLevelInTopPlanetsLoPtr
        LDA #>currentLevelInTopPlanets
        STA currentLevelInTopPlanetsHiPtr
        JMP JumpToHiScoreScreen

finalScoreUpdateInterval = $FB
;-------------------------------------------------------
; IncrementFinalScoreTally
;-------------------------------------------------------
IncrementFinalScoreTally
        LDY #$07
b6482   LDA (tempLoPtr1),Y
        SEC
        SBC #$30
        BEQ b648D
        TAX
        JSR UpdateFinalScoreTally
b648D   LDA #$A0
        STA finalScoreUpdateInterval
        LDX #$00
b6493   DEX
        BNE b6493
        DEC finalScoreUpdateInterval
        BNE b6493
        DEY
        BNE b6482
        RTS

;-------------------------------------------------------
; UpdateFinalScoreTally
;-------------------------------------------------------
UpdateFinalScoreTally
        TYA
        PHA
b64A0   LDA (tempLoPtr),Y
        CLC
        ADC #$01
        CMP #$3A
        BEQ b64AD
        STA (tempLoPtr),Y
        BNE b64B4
b64AD   LDA #$30
        STA (tempLoPtr),Y
        DEY
        BNE b64A0
b64B4   PLA
        TAY
        LDA (tempLoPtr1),Y
        SEC
        SBC #$01
        STA (tempLoPtr1),Y
        DEX
        BNE UpdateFinalScoreTally
        RTS

txtReasonGilbyDied   .TEXT "DEPLETED..OVERLOAD..ENTROPY...HIT SOMMAT"
;-------------------------------------------------------
; DrawReasonGilbyDied
;-------------------------------------------------------
DrawReasonGilbyDied
        LDA #$00
        LDY reasonGilbyDied
        BEQ b64F6
b64F0   CLC
        ADC #$0A
        DEY
        BNE b64F0
b64F6   TAX
b64F7   LDA txtReasonGilbyDied,X
        AND #$3F
        STA SCREEN_RAM + LINE17_COL15,Y
        LDA #RED
        STA COLOR_RAM + LINE17_COL15,Y
        INY
        INX
        CPY #$0A
        BNE b64F7
        RTS

;-------------------------------------------------------
; JumpDisplayNewBonus
;-------------------------------------------------------
JumpDisplayNewBonus
        JMP DisplayNewBonus

bonusGilbiesPositionArray .BYTE $40,$46,$4C,$52,$58,$5E,$63,$68
                          .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
                          .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
                          .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
                          .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
                          .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
                          .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
                          .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
                          .BYTE $FF
bonusBountiesEarned       .BYTE $00
bonusGilbyXPos1           .BYTE $00
bonusGilbyYPos1           .BYTE $00
bonusGilbyXPosOffset           .BYTE $00
bonusGilbyYPosOffset           .BYTE $00
;-------------------------------------------------------
; DisplayNewBonus
;-------------------------------------------------------
DisplayNewBonus
        SEI
        INC bonusBountiesEarned
        LDA bonusBountiesEarned
        AND #$07
        STA bonusBountiesEarned
        LDA #$00
        STA bonusAwarded
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA #<NewBonusGilbyAnimation
        STA $0314    ;IRQ
        LDA #>NewBonusGilbyAnimation
        STA $0315    ;IRQ
        JSR ClearScreen3
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$F0
        STA $D012    ;Raster Position
        LDA #BLACK
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        CLI

        LDA #$FF
        STA $D015    ;Sprite display Enable
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDX #$07

        ; Display the animated gilbies
b6595   LDA #$C1
        STA Sprite0Ptr,X
        LDA newBonusGilbyColors,X
        STA $D027,X  ;Sprite 0 Color
        DEX
        BPL b6595

        LDX #$0A
b65A5   LDA txtBonus10000,X
        AND #$3F
        STA SCREEN_RAM + LINE10_COL15,X
        LDA #YELLOW
        STA COLOR_RAM + LINE10_COL15,X
        DEX
        BPL b65A5

        ; Increment the total bonus bounty by 10000
        LDX #$03
b65B7   INC currentBonusBounty,X
        LDA currentBonusBounty,X
        CMP #$3A
        BNE b65C9
        LDA #$30
        STA currentBonusBounty,X
        DEX
        BNE b65B7

b65C9   LDA lastKeyPressed
        CMP #$3C ; Space pressed
        BNE b65C9
        RTS

;-------------------------------------------------------
; NewBonusGilbyAnimation
;-------------------------------------------------------
NewBonusGilbyAnimation
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE AnimateGilbiesForNewBonus
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

counterBetweeXPosUpdates                  .BYTE $04
initialCounterBetweenXPosUpdates          .BYTE $04
initialCounterBetweenYPosUpdates          .BYTE $02
counterBetweenYPosUpdates                 .BYTE $02
noOfSpritesToUpdate                       .BYTE $00
indexForXPosInSpritePositionArray         .BYTE $00
indexForYPosInSpritePositionArray         .BYTE $00
oscillator3WorkingValue                   .BYTE $03
oscillator3Value                          .BYTE $03
oscillator4WorkingValue                   .BYTE $06
oscillator4Value                          .BYTE $06
oscillator5Value                          .BYTE $01
oscillator6Value                          .BYTE $01
indexForXPosOffetsetInSpritePositionArray .BYTE $00
inxedForYPosOffsetInSpritePositionArray   .BYTE $00
newBonusGilbyColors   .BYTE RED,LTRED,ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE

;--------------------------------------------------
; AnimateGilbiesForNewBonus
;--------------------------------------------------
AnimateGilbiesForNewBonus
        LDY #$00
        LDA #$F0
        STA $D012    ;Raster Position
        DEC counterBetweeXPosUpdates
        BNE MaybeUpdateYPos

        LDA initialCounterBetweenXPosUpdates
        STA counterBetweeXPosUpdates

        LDA incrementForXPos
        CLC
        ADC indexForXPosInSpritePositionArray
        STA indexForXPosInSpritePositionArray

MaybeUpdateYPos   
        DEC counterBetweenYPosUpdates
        BNE MaybeResetOsc3WorkingValue

        LDA initialCounterBetweenYPosUpdates
        STA counterBetweenYPosUpdates

        LDA indexForYPosInSpritePositionArray
        CLC
        ADC incrementForYPos
        STA indexForYPosInSpritePositionArray

MaybeResetOsc3WorkingValue   
        DEC oscillator3WorkingValue
        BNE MaybeResetOsc4WorkingValue

        LDA oscillator3Value
        STA oscillator3WorkingValue
        INC indexForXPosOffetsetInSpritePositionArray

MaybeResetOsc4WorkingValue   
        DEC oscillator4WorkingValue
        BNE InitializeSpriteAnimation

        LDA oscillator4Value
        STA oscillator4WorkingValue
        INC inxedForYPosOffsetInSpritePositionArray

InitializeSpriteAnimation   
        LDA indexForXPosInSpritePositionArray
        PHA
        LDA indexForYPosInSpritePositionArray
        PHA
        LDA indexForXPosOffetsetInSpritePositionArray
        PHA
        LDA inxedForYPosOffsetInSpritePositionArray
        PHA

SpriteAnimationLoop   
        LDA indexForXPosInSpritePositionArray
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyXPos1

        LDA indexForYPosInSpritePositionArray
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyYPos1

        LDA indexForXPosOffetsetInSpritePositionArray
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyXPosOffset

        LDA inxedForYPosOffsetInSpritePositionArray
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyYPosOffset

        JSR BonusBountyPerformAnimation

        LDA inxedForYPosOffsetInSpritePositionArray
        CLC
        ADC #$08
        STA inxedForYPosOffsetInSpritePositionArray

        LDA indexForXPosOffetsetInSpritePositionArray
        CLC
        ADC #$08
        STA indexForXPosOffetsetInSpritePositionArray

        LDA indexForYPosInSpritePositionArray
        CLC
        ADC #$08
        STA indexForYPosInSpritePositionArray

        LDA indexForXPosInSpritePositionArray
        CLC
        ADC #$08
        STA indexForXPosInSpritePositionArray

        INY
        INY
        CPY #$10
        BNE SpriteAnimationLoop

        PLA
        STA inxedForYPosOffsetInSpritePositionArray

        PLA
        STA indexForXPosOffetsetInSpritePositionArray

        PLA
        STA indexForYPosInSpritePositionArray

        PLA
        STA indexForXPosInSpritePositionArray

        DEC noOfSpritesToUpdate
        BNE AnimationFrameFinished

        JSR PutProceduralByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$04
        TAX

        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenXPosUpdates

        LDA positionIncrementArray,X
        STA incrementForXPos

        JSR PutProceduralByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$04
        TAX

        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenYPosUpdates

        LDA positionIncrementArray,X
        STA incrementForYPos

        JSR PutProceduralByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$01
        STA oscillator3WorkingValue
        STA oscillator3Value

        JSR PutProceduralByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$01
        STA oscillator4WorkingValue
        STA oscillator4Value

AnimationFrameFinished   
        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR PlaySoundEffects
        JMP ReEnterInterrupt

;-------------------------------------------------------
; BonusBountyPerformAnimation
;-------------------------------------------------------
BonusBountyPerformAnimation
        LDA bonusGilbyXPos1
        LDX oscillator5Value
        BEQ b6725
        JSR BonusBountyAnimateGilbyXPos
        JMP BonusBountySkipUpdatingXPos

b6725   CLC
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos

BonusBountySkipUpdatingXPos
        LDA bonusGilbyYPos1
        LDX oscillator6Value
        BEQ b6736
        JMP BonusBountyAnimateGilbyYPos

b6736   CLC
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS

incrementForXPos               .BYTE $01
incrementForYPos               .BYTE $01
intervalBetweenPosUpdatesArray .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                               .BYTE $02,$03,$04,$05,$06,$07,$08,$09
positionIncrementArray      .BYTE $08,$07,$06,$05,$04,$03,$02,$01
                               .BYTE $01,$01,$01,$01,$01,$01,$01,$01
bonusBountyOffsetTemp     = $FA
;-------------------------------------------------------
; BonusBountyAnimateGilbyXPos
;-------------------------------------------------------
BonusBountyAnimateGilbyXPos
        LDA bonusGilbyXPos1
        CLC
        ROR
        STA bonusBountyOffsetTemp
        LDA bonusGilbyXPosOffset
        CLC
        ROR
        CLC
        ADC bonusBountyOffsetTemp
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos
        RTS

;-------------------------------------------------------
; BonusBountyAnimateGilbyYPos
;-------------------------------------------------------
BonusBountyAnimateGilbyYPos
        LDA bonusGilbyYPos1
        CLC
        ROR
        STA bonusBountyOffsetTemp
        LDA bonusGilbyYPosOffset
        CLC
        ROR
        CLC
        ADC bonusBountyOffsetTemp
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS

txtBonus10000                      .TEXT "BONUS 10000"
planetScrollFrameRate              .BYTE $BC

colorSequenceArray2                .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
                                   .BYTE WHITE,YELLOW,CYAN,GREEN,PURPLE,RED,BLUE,BLACK

colorSequenceArray                 .BYTE RED,ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE,GRAY1
                                   .BYTE GRAY1,BLUE,PURPLE,LTBLUE,GREEN,YELLOW,ORANGE,RED

colorsForAttackShips
backgroundColorsForPlanets         .BYTE BLACK,WHITE,RED,CYAN,PURPLE,GREEN,BLUE,YELLOW
                                   .BYTE ORANGE,BROWN,LTRED,GRAY1,GRAY2,LTGREEN,LTBLUE,GRAY3
unusedByte1                        .BYTE $04
unusedByte2                        .BYTE $05
                                   .BYTE $00

upperPlanetAttackShipsXPosArray =*-$01
upperPlanetGilbyBulletXPos         .BYTE $A8
upperPlanetAttackShip2XPos         .BYTE $A0,$98,$90,$88,$80,$00

lowerPlanetAttackShipsXPosArray =*-$01
lowerPlanetAttackShip1XPos         .BYTE $00
lowerPlanetAttackShip2XPos         .BYTE $B8
lowerPlanetAttackShip3XPos         .BYTE $C0,$C8,$D0,$D8,$E0

upperPlanetAttackShipsSpriteValueArray  =*-$01
upperPlanetGilbyBulletSpriteValue  .BYTE $D3
upperPlanetAttackShip2SpriteValue  .BYTE $D3
upperPlanetAttackShip3SpriteValue  .BYTE $D3,$D3,$D3,$D3

lowerPlanetAttackShipsSpriteValueArray =*-$01
lowerPlanetGilbyBulletSpriteValue  .BYTE $E6
lowerPlanetAttackShip2SpriteValue  .BYTE $E6
lowerPlanetAttackShip3SpriteValue  .BYTE $E6,$E6,$E6,$E6

upperPlanetAttackShipsMSBXPosArray =*-$01
upperPlanetGilbyBulletMSBXPosValue .BYTE $00
upperPlanetAttackShip2MSBXPosValue .BYTE $00,$00,$00,$00,$00

                                   .BYTE $FF
lowerPlanetAttackShipsMSBXPosArray =*-$01
lowerPlanetGilbyBulletMSBXPosValue .BYTE $FF
lowerPlanetAttackShip2MSBXPosValue .BYTE $00
lowerPlanetAttackSHip3MSBXPosValue .BYTE $00,$00,$00,$00

upperPlanetAttackShipsColorArray   .BYTE $00
upperPlanetGilbyBulletColor        .BYTE $02,$08,$07,$05,$0E
lowerPlanetAttackShipsColorArray   .BYTE $04
lowerPlanetGilbyBulletColor        .BYTE $02,$08,$07,$05,$0E
                                   .BYTE $04

upperPlanetAttackShipsYPosArray =*-$01
upperPlanetGilbyBulletYPos         .BYTE $3D
upperPlanetAttackShip2YPos         .BYTE $3D,$3D,$3D,$3D,$3D
upperPlanetAttackShip3YPos         .BYTE $00,$00

lowerPlanetAttackShipsYPosArray =*-$01
lowerPlanetGilbyBulletYPos         .BYTE $CA
lowerPlanetAttackShip2YPos         .BYTE $CA,$CA,$CA,$CA,$CA

currentPlanetBackgroundClr1        .BYTE $09
currentPlanetBackgroundClr2        .BYTE $0E
currentPlanetBackgroundColor1      .BYTE $09
currentPlanetBackgroundColor2      .BYTE $0E
;-------------------------------------------------------
; InitializeStarfieldSprite
;-------------------------------------------------------
InitializeStarfieldSprite
        LDA #$00
        LDY #$40
b6812   STA starFieldSprite - $01,Y
        DEY
        BNE b6812

;-------------------------------------------------------
; DrawParallaxOfStarfieldInGilbyDirection
;-------------------------------------------------------
DrawParallaxOfStarfieldInGilbyDirection
        LDX currentGilbySpeed
        BPL GilbyHasSpeed
        TXA
        EOR #$FF
        TAX
        INX
GilbyHasSpeed   
        LDA starfieldSpriteAnimationData,X
        STA starFieldSprite
        STA starFieldSprite + $03
        STA starFieldSprite + $12
        STA starFieldSprite + $15
        STA starFieldSprite + $24
        STA starFieldSprite + $27
        STA starFieldSprite + $36
        STA starFieldSprite + $39
        RTS

;-------------------------------------------------------
; PrepareScreen
;-------------------------------------------------------
PrepareScreen
        LDA #BLACK
        SEI
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        JSR ClearGameViewPort
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        JSR DrawControlPanel
        JSR InitializeEnergyBars

        LDA $D016    ;VIC Control Register 2
        AND #$F7
        ORA #$10
        STA $D016    ;VIC Control Register 2

        LDA #$01
        STA $D027    ;Sprite 0 Color
        JSR InitializePlanetProgressArrays
        ;Fall through

;-------------------------------------------------------
; SetupSpritesAndSound
;-------------------------------------------------------
SetupSpritesAndSound
        LDA #$FF
        SEI
        STA $D015    ;Sprite display Enable
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDA #STARFIELD_SPRITE ; Star field sprite at $3000
        STA Sprite7PtrStarField
        LDA #$00
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        STA gilbyHasJustDied
        STA levelRestartInProgress
        LDA oldTopPlanetIndex
        STA topPlanetPointerIndex
        LDA oldBottomPlanetIndex
        STA bottomPlanetPointerIndex
        LDA #$80
        STA $D01B    ;Sprite to Background Display Priority
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA #$B0
        STA $D000    ;Sprite 0 X Pos
        JSR DrawPlanetSurfaces
        JSR SetUpPlanets
        SEI
        LDA #<MainGameInterruptHandler
        STA $0314    ;IRQ
        LDA #>MainGameInterruptHandler
        STA $0315    ;IRQ

        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$10
        STA $D012    ;Raster Position

        JSR DrawLowerPlanetWhileInactive
        LDX #$28
        LDA lowerPlanetActivated
        BNE ReturnFromSetUpSprites

ClearSurfaceLoop   
        LDA #$00
        STA SCREEN_RAM + LINE10_COL39,X
        LDA #PURPLE
        STA COLOR_RAM + LINE10_COL39,X
        DEX
        BNE ClearSurfaceLoop

ReturnFromSetUpSprites   
        RTS

;-------------------------------------------------------
; InitializeSprites
;-------------------------------------------------------
InitializeSprites
        LDA #GRAY1
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
        JSR SetUpGilbySprite
p6904   JMP PrepareToRunGame

;-------------------------------------------------------
; SetUpGilbySprite
;-------------------------------------------------------
SetUpGilbySprite
        LDA #GILBY_AIRBORNE_RIGHT
        STA currentGilbySprite
        STA Sprite0Ptr
        LDA #$02
        STA gilbyAnimationTYpe
        LDA #$40
        STA $D001    ;Sprite 0 Y Pos
        LDA #AIRBORNE
        STA gilbyCurrentState
        LDA #$EA
        STA currentGilbySpeed
        LDA #$00
        STA gilbyIsEarthbound
        RTS

bonusAwarded   .BYTE $00
;-------------------------------------------------------
; PrepareToRunGame
;-------------------------------------------------------
PrepareToRunGame
        LDA attractModeCountdown
        BEQ b6932
        JSR SelectRandomPlanetsForAttractMode
b6932   LDA #$00
        JSR PerformPlanetWarp
        LDA #$01
        STA levelEntrySequenceActive
        STA entryLevelSequenceCounter
        LDA #$FF
        STA joystickInput
        ;Fall through

;-------------------------------------------------------
; BeginRunningGame
;-------------------------------------------------------
BeginRunningGame
        CLI
        NOP
        NOP
        NOP

        ; Start the game if in attract mode or
        ; normal mode, otherwise show hiscore
        ; screen.
        LDA attractModeCountdown
        BEQ StartTheGame
        CMP #$01
        BNE StartTheGame

        LDA #$01
        STA hasDisplayedHiScoreScreen

        LDA $D016    ;VIC Control Register 2
        AND #$E8
        ORA #$08
        STA $D016    ;VIC Control Register 2

        SEI
        LDA #$00
        STA $D015    ;Sprite display Enable
        LDA #<currentLevelInTopPlanets
        STA currentLevelInTopPlanetsLoPtr
        LDA #>currentLevelInTopPlanets
        STA currentLevelInTopPlanetsHiPtr
        JMP DrawHiScoreScreen

StartTheGame
        LDA bonusAwarded
        BEQ b6982
        JSR JumpDisplayNewBonus
        JSR StoreStatusBarDetail
        JSR InitializePlanetProgressArrays
        JMP ResumeGame

b6982   LDA levelRestartInProgress
        BEQ b698A
        JMP EnterMainControlLoop

b698A   LDA progressDisplaySelected
        BEQ MaybeGoToBonusPhase
        SEI

        LDA $D016    ;VIC Control Register 2
        AND #$E7
        ORA #$08
        STA $D016    ;VIC Control Register 2

        JSR StoreStatusBarDetail
        JSR ShowProgressScreen
        INC shouldResetPlanetEntropy
        JMP SetUpGameScreen

MaybeGoToBonusPhase
        LDA bonusPhaseEarned
        BEQ ResumeMainGameAgain
        SEI
        JSR StoreStatusBarDetail
        JSR ClearScreen3
        JSR DisplayEnterBonusRoundScreen

;-------------------------------------------------------
; ResumeGame
;-------------------------------------------------------
ResumeGame
        JSR ClearPlanetTextureCharsets
        JSR DrawStatusBarDetail
        JSR InitializeEnergyBars
        JSR SetUpGilbySprite

        ; Clear charset data
        LDX #$00
        TXA
b69C4   STA upperPlanetSurfaceCharset,X
        STA upperPlanetHUDCharset,X
        STA lowerPlanetSurfaceCharset,X
        STA lowerPlanetHUDCharset,X
        DEX
        BNE b69C4

        JSR StoreStatusBarDetail
        LDA #$01
        STA levelEntrySequenceActive
        STA entryLevelSequenceCounter

        LDA incrementLives
        BEQ b69F0

        ; Increment lives if one earned in bonus phase.
        INC gilbiesLeft
        LDA gilbiesLeft
        CMP #$04
        BNE b69F0
        DEC gilbiesLeft

b69F0   LDA #$00
        STA bonusPhaseEarned

        LDA $D011    ;VIC Control Register 1
        AND #$F0
        ORA #$0B
        STA $D011    ;VIC Control Register 1

        JMP SetUpGameScreen

ResumeMainGameAgain   
        JSR UpdateEnemiesLeft
        JSR InitializePlanetEntropyStatus
        JSR UpdateDisplayedScoringRate
        LDA levelRestartInProgress
        BEQ LevelRestartNotInProgress

;-------------------------------------------------------
; EnterMainControlLoop
;-------------------------------------------------------
EnterMainControlLoop
        JSR InitializeEnergyBars
        JSR StoreStatusBarDetail
        JSR PlayerKilled
        JMP SetUpGameScreen

LevelRestartNotInProgress   
        LDA controlPanelColorDoesntNeedUpdating
        BEQ ControlPanelColorDoesNotNeedUpdating
        JSR UpdateControlPanelColor

ControlPanelColorDoesNotNeedUpdating   
        LDA qPressedToQuitGame
        BEQ GameNotQuit

        ; Player has pressed Q to quit game.
        LDA #$00
        STA qPressedToQuitGame
        JMP MainControlLoop

GameNotQuit   
        JSR UpdateScores
        LDA gilbyHasJustDied
        BNE GilbyHasNotDied

        LDA pauseModeSelected
        BNE EnterPauseMode

GilbyHasNotDied   
        JMP BeginRunningGame

EnterPauseMode
        ; Wait for the player to release the key
        LDA lastKeyPressed
        CMP #$40 ; $40 means no key was pressed
        BNE EnterPauseMode

        ; Start up the Made In France pause mode.
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

        JSR StoreStatusBarDetail
        JSR LaunchMIF

        ;We come back here when the player exits pause mode
        LDA #$00
        STA pauseModeSelected
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$01
        STA $D026    ;Sprite Multi-Color Register 1
        INC shouldResetPlanetEntropy

;-------------------------------------------------------
; SetUpGameScreen
;-------------------------------------------------------
SetUpGameScreen
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$01
        STA controlPanelColorDoesntNeedUpdating
        LDA #$FF     ; All sprites.
        STA $D015    ;Sprite display Enable
        LDA #$80
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA previousGilbySprite
        STA Sprite0Ptr
        JSR ClearScreen3
        JSR SetupSpritesAndSound
        LDA oldTopPlanetIndex
        STA topPlanetPointerIndex
        LDA oldBottomPlanetIndex
        STA bottomPlanetPointerIndex
        JSR PerformPlanetWarp
        JSR DrawStatusBarDetail

        LDX #$03
InitializeEnemySpritesLoop   
        LDA upperPlanetAttackShipSpritesLoadedFromBackingData,X
        STA upperPlanetAttackShip3SpriteValue,X
        LDA lowerPlanetAttackShipSpritesLoadedFromBackingData,X
        STA lowerPlanetAttackShip3SpriteValue,X
        DEX
        BNE InitializeEnemySpritesLoop

        JMP BeginRunningGame

previousGilbySprite   .BYTE $D3
;-------------------------------------------------------
; DrawUpperPlanetAttackShips
;-------------------------------------------------------
DrawUpperPlanetAttackShips
        LDX #$0C
        LDY #$06
UpperPlanetShipsLoop   
        LDA upperPlanetAttackShipsXPosArray,Y
        STA $D000,X  ;Sprite 0 X Pos

        LDA attackShipsXPosArray - $01,Y
        AND $D010    ;Sprites 0-7 MSB of X coordinate
        STA currentMSBXPosOffset

        LDA upperPlanetAttackShipsMSBXPosArray,Y
        AND attackShipsMSBXPosOffsetArray,Y
        ORA currentMSBXPosOffset
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        LDA upperPlanetAttackShipsYPosArray,Y
        STA $D001,X  ;Sprite 0 Y Pos
        STX tempVarStorage

        LDX upperPlanetAttackShipsColorArray,Y
        LDA colorsForAttackShips,X
        STA $D027,Y  ;Sprite 0 Color

        LDA upperPlanetAttackShipsSpriteValueArray,Y
        STA Sprite0Ptr,Y
        LDX tempVarStorage

        DEX
        DEX
        DEY
        BNE UpperPlanetShipsLoop
        RTS

;-------------------------------------------------------
; DrawLowerPlanetAttackShips
;-------------------------------------------------------
DrawLowerPlanetAttackShips
        LDX #$0C
        LDY #$06
LowerPlanetShipsLoop   
        LDA lowerPlanetAttackShipsXPosArray + $01,Y
        STA $D000,X  ;Sprite 0 X Pos

        LDA attackShipsXPosArray - $01,Y
        AND $D010    ;Sprites 0-7 MSB of X coordinate
        STA currentMSBXPosOffset

        ; The X-Pos of sprites is fiddly. The MSB manages
        ; which side of the 512 possible x positions they
        ; are on.
        LDA lowerPlanetGilbyBulletMSBXPosValue,Y
        AND attackShipsMSBXPosOffsetArray,Y
        ORA currentMSBXPosOffset
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        LDA lowerPlanetAttackShipsYPosArray,Y
        STA $D001,X  ;Sprite 0 Y Pos
        STX tempVarStorage

        LDX lowerPlanetAttackShipsColorArray,Y
        LDA colorsForAttackShips,X
        STA $D027,Y  ;Sprite 0 Color

        LDA lowerPlanetAttackShipsSpriteValueArray,Y
        STA Sprite0Ptr,Y
        LDX tempVarStorage

        DEX
        DEX
        DEY
        BNE LowerPlanetShipsLoop
        RTS

;-------------------------------------------------------
; MainControlLoopInterruptHandler
;-------------------------------------------------------
MainControlLoopInterruptHandler
        RTI

attackShipsXPosArray          .BYTE $FD,$FB,$F7,$EF,$DF,$BF
attackShipsMSBXPosOffsetArray =*-$01
gilbyBulletMSBXPosOffset      .BYTE $02
attackShip2MSBXPosOffsetArray .BYTE $04,$08,$10,$20,$40,$02,$04,$08
                              .BYTE $10,$20,$40
difficultySetting             .BYTE $00

;-------------------------------------------------------
; MainGameInterruptHandler
;-------------------------------------------------------
MainGameInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE RasterPositionMatchesRequestedInterrupt ; Collision detected

;-------------------------------------------------------
; ReturnFromInterrupt
;-------------------------------------------------------
ReturnFromInterrupt
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;-------------------------------------------------------
; ClearGameViewPort
;-------------------------------------------------------
ClearGameViewPort
        LDX #$00
        LDA #$20
b6B63   STA SCREEN_RAM,X
        STA SCREEN_RAM + LINE6_COL16,X
        STA SCREEN_RAM + LINE12_COL32,X
        STA SCREEN_RAM + LINE19_COL0,X
        DEX
        BNE b6B63
        RTS

;-------------------------------------------------------
; FlashBorderAndBackground
;-------------------------------------------------------
FlashBorderAndBackground
        LDA currentEntropy
        BEQ b6BA3
        LDA borderFlashControl1
        BNE b6B90
        DEC borderFlashControl2
        BNE b6BBE
        LDA #WHITE
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$01
        STA borderFlashControl1
b6B8F   RTS

b6B90   DEC borderFlashControl1
        BNE b6B8F
        LDA #BLACK
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$02
        STA borderFlashControl2
        RTS

b6BA3   LDA gilbyExploding
        BEQ b6BBE
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
        DEC starFieldInitialStateArray - $01
        BNE b6BBE
        LDA #BLACK
        STA gilbyExploding
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
b6BBE   RTS

;-------------------------------------------------------
; RasterPositionMatchesRequestedInterrupt
;-------------------------------------------------------
RasterPositionMatchesRequestedInterrupt
        LDY currentIndexInRasterInterruptArrays
        LDA levelRestartInProgress
        BEQ b6BCA
        JMP FlashBackgroundAndBorder

b6BCA   LDA progressDisplaySelected
        BEQ b6BD2
        ; Displaying the progress screen, so nothing to do on this interrupt.
        JMP GameSwitchAndGameOverInterruptHandler
        ; Returns from Interrupt


b6BD2   LDA nextRasterPositionArray - $01,Y ; Y is currentIndexInRasterInterruptArrays
        BEQ ResetRasterAndPerformMainGameUpdate
        ; Returns from Interrupt

        JMP AnimateStarFieldAndScrollPlanets
        ; Returns from Interrupt

;-------------------------------------------------------
; ResetRasterAndPerformMainGameUpdate
;-------------------------------------------------------
ResetRasterAndPerformMainGameUpdate
        LDA #$00
        STA currentIndexInRasterInterruptArrays
        LDA #$5C
        STA $D012    ;Raster Position

        LDA $D016    ;VIC Control Register 2
        AND #$E0
        ORA #$08
        STA $D016    ;VIC Control Register 2

        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        BNE PerformMainGameUpdate
        ; Returns from interrupt

;-------------------------------------------------------
; PaintGilbySprite
;-------------------------------------------------------
PaintGilbySprite
        LDA gilbyHasJustDied
        BNE b6C24
        LDA currentGilbySprite
        STA Sprite0Ptr
        STA previousGilbySprite
        LDA gilbyVerticalPositionUpperPlanet
        STA $D001    ;Sprite 0 Y Pos
        LDX currEnergyTop
        LDA energyLevelToGilbyColorMap,X
        LDX extraAmountToDecreaseEnergyByTopPlanet
        BEQ b6C1A
        LDA processJoystickFrameRate
b6C1A   LDY setToZeroIfOnUpperPlanet
        BEQ b6C21
        ; Set the color of the lower planet gilby to grey.
        LDA #GRAY1
b6C21   STA $D027    ;Sprite 0 Color
b6C24   RTS

currentGilbySprite   .BYTE GILBY_AIRBORNE_RIGHT

;-------------------------------------------------------
; PerformMainGameUpdate
;-------------------------------------------------------
PerformMainGameUpdate
        LDX currentPlanetBackgroundClr1
        LDA backgroundColorsForPlanets,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDX currentPlanetBackgroundClr2
        LDA backgroundColorsForPlanets,X
        STA $D023    ;Background Color 2, Multi-Color Register 1

        LDA $D01F    ;Sprite to Background Collision Detect
        STA spriteCollidedWithBackground

        JSR CheckKeyboardInGame
        JSR ScrollStarfieldAndThenPlanets
        JSR UpdateCurrentGilbySprite
        JSR PerformMainGameProcessing
        JSR CheckForLandscapeCollisionAndWarpThenProcessJoystickInput
        JSR CalculateGilbyVerticalPositionEarthBound
        JSR CalculateGilbyVerticalPositionAirborne
        JSR MaybeDrawLevelEntrySequence
        JSR PlaySoundEffects
        JSR FlashBorderAndBackground
        JSR PaintGilbySprite
        JSR UpdateAndAnimateAttackShips
        JSR UpdateBulletPositions
        JSR DrawUpperPlanetAttackShips
        JSR UpdateControlPanelColors
        ; Jump into KERNAL's standard interrupt service routine to 
        ; handle keyboard scan, cursor display etc.
        JMP ReEnterInterrupt 
        ;Returns From Interrupt

;-------------------------------------------------------
; AnimateStarFieldAndScrollPlanets
; Sprite 7 is used to draw the parallax starfield background.
;-------------------------------------------------------
AnimateStarFieldAndScrollPlanets

        ; Animate the Starfield
        STA $D00F    ;Sprite 7 Y Pos
        LDA starFieldXPosArray,Y
        STA $D00E    ;Sprite 7 X Pos
        LDA starFieldXPosMSBArray,Y
        CLC
        ROR
        ROR
        STA spriteMSBXPosOffset
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$7F
        ORA spriteMSBXPosOffset
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        ; Pull the next position at which to interrupt the raster
        ; from our array.
        LDA nextRasterPositionArray,Y
        BNE b6C91

        ; Reset the raster interrupt
        JMP ResetRasterAndPerformMainGameUpdate

b6C91   SEC
        SBC #$02
        STA $D012    ;Raster Position
        LDA starFieldInitialStateArray,Y
        TAX
        LDA starFieldColorsArray,X
        STA $D02E    ;Sprite 7 Color
        CPY zeroRasterPosition
        BNE b6CB5

        ; Scroll the planet
        LDA $D016    ;VIC Control Register 2
        AND #$F0
        ORA planetScrollSpeed
        ORA #$10
        STA $D016    ;VIC Control Register 2

        BNE b6CD3

b6CB5   CPY #$06
        BNE b6CD3
        LDA lowerPlanetActivated
        BEQ DrawLowerPlanet

        LDA #$90
        STA $D001    ;Sprite 0 Y Pos

        LDX #$30
b6CC5   DEX
        BNE b6CC5

        LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2

        JMP UpdateRasterPositionAndReturn
        ;Returns

b6CD3   JMP UpdateInterruptRegisterAndReturn
        ;Returns

;-------------------------------------------------------
; DrawLowerPlanet
;-------------------------------------------------------
DrawLowerPlanet
        JSR DrawLowerPlanetAttackShips

        LDA #$07
        SEC
        SBC planetScrollSpeed
        STA currentMSBXPosOffset

        ; Scrolling the screen
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        ORA currentMSBXPosOffset
        STA $D016    ;VIC Control Register 2

        LDA gilbyHasJustDied
        BNE b6D07

        ; Draw the lower planet gilby
        LDA #$FF
        SEC
        SBC gilbyVerticalPositionUpperPlanet
        ADC #$07
        STA $D001    ;Sprite 0 Y Pos
        STA gilbyVerticalPositionLowerPlanet
        LDA currentGilbySprite
        CLC
        ADC #$13 ; Converts the gilby sprite to the lower planet version
        STA Sprite0Ptr

b6D07   LDX currentPlanetBackgroundColor1
        LDA backgroundColorsForPlanets,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDX currentPlanetBackgroundColor2
        LDA backgroundColorsForPlanets,X
        STA $D023    ;Background Color 2, Multi-Color Register 1

        LDA gilbyHasJustDied
        BNE UpdateRasterPositionAndReturn

        ; Update the color of the lower planet gilby to match its energy level
        LDX currEnergyBottom
        LDA energyLevelToGilbyColorMap,X
        LDX extraAmountToDecreaseEnergyByBottomPlanet
        BEQ b6D2C

        LDA processJoystickFrameRate

b6D2C   LDY setToZeroIfOnUpperPlanet
        BNE b6D33

        ; Set the color of the lower planet gilby to grey.
        LDA #GRAY1
b6D33   STA $D027    ;Sprite 0 Color (lower planet gilby)

;-------------------------------------------------------
; UpdateRasterPositionAndReturn
;-------------------------------------------------------
UpdateRasterPositionAndReturn
        LDY #$0A
        STY currentIndexInRasterInterruptArrays
        LDA spriteCollidedWithBackground,Y
        STA $D012    ;Raster Position

;-------------------------------------------------------
; UpdateInterruptRegisterAndReturn
;-------------------------------------------------------
UpdateInterruptRegisterAndReturn
        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        INC currentIndexInRasterInterruptArrays
        JMP ReturnFromInterrupt


zeroRasterPosition                  .BYTE $00,$0D
spriteCollidedWithBackground        .BYTE $00,$60
nextRasterPositionArray             .BYTE $66,$6C,$72,$78,$7E,$84,$8A,$90
                                    .BYTE $96,$9C,$A2,$A8,$AE,$B4,$00
starFieldXPosArray                  .BYTE $44,$CD,$9F,$F7,$EF,$7F,$79,$2D
                                    .BYTE $9D,$D5,$01,$79,$96,$FB,$C0
starFieldXPosMSBArray               .BYTE $01,$00,$01,$00,$01,$01,$00,$01
                                    .BYTE $00,$00,$00,$01,$00,$01,$00,$00
                                    .BYTE $01,$01,$00
currentIndexInRasterInterruptArrays .BYTE $00
gilbyExploding                      .BYTE $00,$00
starFieldInitialStateArray          .BYTE $02,$03,$04,$03,$02,$03,$04,$03
                                    .BYTE $02,$03,$04,$03,$02,$02,$03,$04
                                    .BYTE $03,$02,$03,$04,$03,$02,$01,$02
                                    .BYTE $03
starFieldCurrentStateArray          .BYTE $04,$02,$03,$04,$03,$02,$03,$04
                                    .BYTE $03,$02,$03,$04,$03,$02,$02,$03
                                    .BYTE $04,$03,$02,$03,$04,$03,$02,$01
                                    .BYTE $02,$03
starFieldColorsArray                .BYTE $04,$01,$0F,$0C,$0B,$08,$06

;-------------------------------------------------------
; ScrollStarfieldAndThenPlanets
;-------------------------------------------------------
ScrollStarfieldAndThenPlanets
        LDX #$0F
        LDA #$00
        STA starFieldAnimationRate
        LDA currentGilbySpeed
        BPL StarFieldUpdateLoop

        LDA #$FF
        STA starFieldAnimationRate

StarFieldUpdateLoop
        DEC starFieldCurrentStateArray,X
        BNE b6E0B

        LDA starFieldInitialStateArray - $01,X
        STA starFieldCurrentStateArray,X
        LDA starFieldXPosArray - $01,X
        CPX #$08
        BMI b6DF4
        SEC
        SBC currentGilbySpeed
        STA starFieldXPosArray - $01,X
        LDA starFieldXPosMSBArray - $01,X
        SBC starFieldAnimationRate
        STA starFieldXPosMSBArray - $01,X
        JMP j6E03

b6DF4   CLC
        ADC currentGilbySpeed
        STA starFieldXPosArray - $01,X
        LDA starFieldXPosMSBArray - $01,X
        ADC starFieldAnimationRate
        STA starFieldXPosMSBArray - $01,X

j6E03
        LDA starFieldXPosMSBArray - $01,X
        AND #$01
        STA starFieldXPosMSBArray - $01,X

b6E0B   DEX
        BNE StarFieldUpdateLoop

        JMP ScrollPlanets

planetScrollSpeed            .BYTE $02
currentGilbySpeed            .BYTE $EA
; These bytes update the starFieldSprite on the fly in
; DrawParallaxOfStarfieldInGilbyDirection. This creates a parallax
; effect.
starfieldSpriteAnimationData .BYTE $C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0
                             .BYTE $F0,$F0,$F0,$F0,$F8,$F8,$F8,$F8
                             .BYTE $FC,$FC,$FC,$FC,$FE,$FE,$FE,$FF
processJoystickFrameRate     .BYTE $01
gilbyIsOverLand              .BYTE $01

;-------------------------------------------------------
; CheckForLandscapeCollisionAndWarpThenProcessJoystickInput
;-------------------------------------------------------
CheckForLandscapeCollisionAndWarpThenProcessJoystickInput
        ; Find reasons for gilby not to die because he hit something.
        LDA spriteCollidedWithBackground
        BEQ CheckJoystickInput
        AND #$01
        BEQ CheckJoystickInput
        LDA controlPanelIsGrey
        BNE CheckJoystickInput
        LDA levelEntrySequenceActive
        BNE CheckJoystickInput
        LDA levelRestartInProgress
        BNE CheckJoystickInput
        LDA gilbyHasJustDied
        BNE CheckJoystickInput
        LDA attractModeCountdown
        BNE CheckJoystickInput

        ; Check if we're flying through a warp gate.
        LDA SCREEN_RAM + LINE10_COL20
        CMP #$77
        BEQ WarpToNextPlanet
        CMP #$7D
        BEQ WarpToNextPlanet

        ; THe difference between 'Easy' and 'Hard' difficulty setting consists
        ; only in colliding with the landscape.
        LDA difficultySetting
        BEQ CheckJoystickInput

        ;He hit a part of hte landscape, and is dead.
        LDA #$03
        STA reasonGilbyDied ; Hit something
        JMP GilbyDied
        ; Returns

;-------------------------------------------------------
; WarpToNextPlanet
;-------------------------------------------------------
WarpToNextPlanet
        JSR PerformPlanetWarp
        LDA #$01
        STA entryLevelSequenceCounter
        STA levelEntrySequenceActive
        LDA #$06
        STA gilbyExploding
        LDA #$04
        STA starFieldInitialStateArray - $01
        LDY #$14
        LDA currentGilbySpeed
        BPL b6E85
        LDY #$EC
b6E85   STY currentGilbySpeed

;-------------------------------------------------------
; CheckJoystickInput
;-------------------------------------------------------
CheckJoystickInput
        DEC processJoystickFrameRate
        BEQ b6E8E
b6E8D   RTS

b6E8E   LDA $DC00    ;CIA1: Data Port Register A
        STA joystickInput
        AND #$1F
        CMP #$1F
        BEQ b6EA4

        ; Any joystick input aborts attract mode
        LDA attractModeCountdown
        BEQ b6EA4
        LDA #$02
        STA attractModeCountdown

b6EA4   JSR GenerateJoystickInputForAttractMode
        LDA attractModeCountdown
        BEQ b6EAF
        DEC attractModeCountdown
b6EAF   LDA #$02
        STA processJoystickFrameRate
        LDA #$00
        STA gilbyIsOverLand

        ; Check whether the gilby is on land or not.
        LDA SCREEN_RAM + LINE10_COL20
        CMP #$41
        BEQ b6EC4
        CMP #$43
        BNE b6EC9

b6EC4   LDA #$01
        STA gilbyIsOverLand

b6EC9   LDA setToZeroIfOnUpperPlanet
        BEQ JoystickNormalMode

        ; Reverses the joystick input if we're on the lower planet. 
        LDA joystickInput
        AND #$10
        STA tempVarStorage
        LDA joystickInput
        AND #$03
        STA tempLoPtr3
        CMP #$03
        BEQ b6EE4
        EOR #$03
        STA tempLoPtr3

b6EE4   LDA joystickInput
        AND #$0C
        CMP #$0C
        BEQ b6EEF
        EOR #$0C
b6EEF   ORA tempLoPtr3
        ORA tempVarStorage
        STA joystickInput

JoystickNormalMode   
        LDA levelEntrySequenceActive
        BNE b6E8D

        LDA gilbyCurrentState
        BEQ b6F03
        JMP ActionIfPreviousActionWasHorizontal

b6F03
        JSR ProcessFireButtonPressed

        ;Check if joystick pushed to left.
        LDA joystickInput
        AND #JOYSTICK_LEFT
        BNE b6F2E

        ; Joystick pushed to left
        LDA #HORIZONTAL_MOVEMENT
        STA gilbyCurrentState
        LDA #$01
        STA currentGilbySpeed
        LDA #$04
        STA gilbyInitialAnimationFrameRate
        STA gilbyAnimationFrameRate
        LDA #$00
        STA backupGilbySpriteIndex
        STA gilbySpriteIndex ; Loads $C1 to sprite
        LDA #$07
        STA spriteIndexToUseNextInGilbyAnimation
        BNE b6F54

        ;Check if joystick pushed to right.
b6F2E   LDA joystickInput
        AND #JOYSTICK_RIGHT
        BNE b6F54

        ; Joystick pushed to right
        LDA #$04
        STA gilbyInitialAnimationFrameRate
        STA gilbyAnimationFrameRate
        LDA #$06
        STA backupGilbySpriteIndex
        STA gilbySpriteIndex
        LDA #$0D
        STA spriteIndexToUseNextInGilbyAnimation
        LDA #$FF
        STA currentGilbySpeed
        LDA #HORIZONTAL_MOVEMENT
        STA gilbyCurrentState

        ;Check if joystick pushed down.
b6F54   LDA joystickInput
        AND #JOYSTICK_UP
        BNE b6F98

        ; Joystick pushed up
        LDA gilbyIsOverLand
        BEQ JoystickPushedUpWhileLandGilbyAirborneOverSea
        JMP JoystickPushedUpWhileOnLand

;-------------------------------------------------------
; JoystickPushedUpWhileLandGilbyAirborneOverSea
;-------------------------------------------------------
JoystickPushedUpWhileLandGilbyAirborneOverSea
        ; Joystick pushed up
        LDA gilbyVerticalPositionUpperPlanet
        CMP #$6D
        BNE b6F98

        ; Gilby is on the ground
        LDA #<pushedUpWhileOverSea
        STA primarySoundEffectLoPtr
        LDA #>pushedUpWhileOverSea
        STA primarySoundEffectHiPtr
        LDA #$FA
        STA gilbyLandingJumpingAnimationYPosOffset
        DEC gilbyVerticalPositionUpperPlanet
        LDA #$11
        STA backupGilbySpriteIndex
        STA gilbySpriteIndex
        LDA #$16
        STA spriteIndexToUseNextInGilbyAnimation
        LDA #$01
        STA gilbyAnimationTYpe
        LDA #$0A
        STA gilbyInitialAnimationFrameRate
        LDA #LAUNCHED_INTO_AIR
        STA gilbyCurrentState
b6F98   RTS

;-------------------------------------------------------
; ActionIfPreviousActionWasHorizontal
;-------------------------------------------------------
ActionIfPreviousActionWasHorizontal
        CMP #HORIZONTAL_MOVEMENT ; Looking at gilbyCurrentState
        BEQ b6FA0
        JMP MaybePreviousActionWasToLaunchIntoAir

b6FA0   JSR ProcessFireButtonPressed
        LDA joystickInput
        AND #$04
        BNE b6FEB

        ; Joystick Left Pressed
        LDA currentGilbySpeed
        BPL b6FDA
        INC gilbyInitialAnimationFrameRate
        INC currentGilbySpeed
        BNE b6FD7
b6FB7   LDA #$00
        STA gilbyCurrentState
        STA currentGilbySpeed
        STA gilbyAnimationTYpe
        LDA #$06
        STA gilbyInitialAnimationFrameRate
        STA gilbyAnimationFrameRate
        LDA #$0D
        STA gilbySpriteIndex
        STA backupGilbySpriteIndex
        LDA #$11
        STA spriteIndexToUseNextInGilbyAnimation
b6FD7   JMP j700F

b6FDA   INC currentGilbySpeed
        DEC gilbyInitialAnimationFrameRate
        BNE b6FD7
        INC gilbyInitialAnimationFrameRate
        DEC currentGilbySpeed
        JMP j700F

b6FEB   LDA joystickInput
        AND #$08
        BNE j700F

        ; Joystick right pressed
        LDA currentGilbySpeed
        BMI b7001
        INC gilbyInitialAnimationFrameRate
        DEC currentGilbySpeed
        BEQ b6FB7
        BNE j700F
b7001   DEC currentGilbySpeed
        DEC gilbyInitialAnimationFrameRate
        BNE b6FD7
        INC currentGilbySpeed
        INC gilbyInitialAnimationFrameRate

j700F
        LDA joystickInput
        AND #$01
        BNE b703A

        ;Joystick up pressed
        LDA gilbyIsOverLand
        BNE JoystickPushedUpWhileOnLand
        JMP JoystickPushedUpWhileLandGilbyAirborneOverSea

;-------------------------------------------------------
; JoystickPushedUpWhileOnLand
;-------------------------------------------------------
JoystickPushedUpWhileOnLand
        LDA gilbyVerticalPositionUpperPlanet
        CMP #$6D
        BNE b703A
        LDA #$FA
        STA gilbyLandingJumpingAnimationYPosOffset
        LDA #<soundGilbyJumpOnLand
        STA primarySoundEffectLoPtr
        LDA #>soundGilbyJumpOnLand
        STA primarySoundEffectHiPtr
        JSR ResetRepetitionForPrimarySoundEffect
        DEC gilbyVerticalPositionUpperPlanet
b703A   RTS

;-------------------------------------------------------
; MaybePreviousActionWasToLaunchIntoAir
;-------------------------------------------------------
MaybePreviousActionWasToLaunchIntoAir
        CMP #LAUNCHED_INTO_AIR ; Looks at gilbyCurrentState
        BNE MaybePreviousActionWasToLand

        JSR ProcessFireButtonPressed
        LDA gilbyAnimationTYpe
        CMP #$02
        BNE b703A
        LDA joystickInput
        AND #$04
        BEQ b7099
        LDA joystickInput
        AND #$08
        BEQ UpdateGilbySpriteToAirborne
        LDA gilbyLandingJumpingAnimationYPosOffset
        CMP #$02
        BNE b703A

;-------------------------------------------------------
; LandGilby
;-------------------------------------------------------
LandGilby
        LDA #$15
        STA backupGilbySpriteIndex
        STA gilbySpriteIndex
        LDA #$1A
        STA spriteIndexToUseNextInGilbyAnimation
        LDA #$01
        STA gilbyAnimationTYpe
        LDA #$06
        STA gilbyInitialAnimationFrameRate
        STA gilbyAnimationFrameRate
        LDA #LANDED
        STA gilbyCurrentState
b707D   RTS

;-------------------------------------------------------
; MaybePreviousActionWasToLand
;-------------------------------------------------------
MaybePreviousActionWasToLand
        CMP #LANDED ; Looks at gilbyCurrentState
        BNE RightJoystickPressedWithPreviousAction

        JSR ProcessFireButtonPressed
        LDA gilbyVerticalPositionUpperPlanet
        CMP #$6D
        BNE b707D
        LDA #<gilbyWalkingSound
        STA primarySoundEffectLoPtr
        LDA #>gilbyWalkingSound
        STA primarySoundEffectHiPtr
        JMP b6FB7

b7099   JSR ResetGilbyIsLanding
        LDA #GILBY_AIRBORNE_LEFT
        STA currentGilbySprite

;-------------------------------------------------------
; UpdatePreviousJoystickAction
;-------------------------------------------------------
UpdatePreviousJoystickAction
        LDA # AIRBORNE
        STA gilbyCurrentState
        RTS

;-------------------------------------------------------
; UpdateGilbySpriteToAirborne
;-------------------------------------------------------
UpdateGilbySpriteToAirborne
        LDA #GILBY_AIRBORNE_RIGHT
        STA currentGilbySprite
        JSR UpdatePreviousJoystickAction

;-------------------------------------------------------
; ResetGilbyIsLanding
;-------------------------------------------------------
ResetGilbyIsLanding
        LDA #$00
        STA gilbyIsEarthbound
        RTS

;-------------------------------------------------------
; RightJoystickPressedWithPreviousAction
;-------------------------------------------------------
RightJoystickPressedWithPreviousAction
        JSR ProcessFireButtonPressed
        LDA joystickInput
        AND #$04
        BNE LeftJoystickPressedWithPreviousAction

        ; Right Joystick pressed
        LDA currentGilbySprite
        CMP #GILBY_AIRBORNE_RIGHT
        BNE b70E0
        LDA #$01
        STA gilbyAnimationTYpe
        LDA #$01
        STA gilbyInitialAnimationFrameRate
        STA gilbyAnimationFrameRate
        LDA #$1A
        STA backupGilbySpriteIndex
        STA gilbySpriteIndex
        LDA #$1F
        STA spriteIndexToUseNextInGilbyAnimation
b70E0   INC currentGilbySpeed
        LDA lowerPlanetActivated
        BEQ b70EF
        LDA currentGilbySpeed
        CMP #$0C
        BEQ b70F6
b70EF   LDA currentGilbySpeed
        CMP #$18
        BNE b70F9
b70F6   DEC currentGilbySpeed
b70F9   JMP AnimateGilbyMovement

;-------------------------------------------------------
; LeftJoystickPressedWithPreviousAction
;-------------------------------------------------------
LeftJoystickPressedWithPreviousAction
        LDA joystickInput
        AND #$08
        BNE DecelerateGilbyAndPossiblySetUpToLand

        ; Left joystick Pressed
        LDA currentGilbySprite
        CMP #GILBY_AIRBORNE_LEFT
        BNE b7124
        LDA #$01
        STA gilbyAnimationTYpe
        LDA #$01
        STA gilbyInitialAnimationFrameRate
        STA gilbyAnimationFrameRate
        LDA #$1F
        STA backupGilbySpriteIndex
        STA gilbySpriteIndex
        LDA #$24
        STA spriteIndexToUseNextInGilbyAnimation
b7124   DEC currentGilbySpeed
        LDA lowerPlanetActivated
        BEQ b7133
        LDA currentGilbySpeed
        CMP #$F4
        BEQ b713A
b7133   LDA currentGilbySpeed
        CMP #$E6
        BNE AnimateGilbyMovement
b713A   INC currentGilbySpeed
        JMP AnimateGilbyMovement

gilbyIsEarthbound   .BYTE $00


;-------------------------------------------------------
; DecelerateGilbyAndPossiblySetUpToLand
;-------------------------------------------------------
b7141   RTS

DecelerateGilbyAndPossiblySetUpToLand
        LDA currentGilbySpeed
        BEQ b715A
        LDA currentGilbySpeed
        BMI b7152
        DEC currentGilbySpeed
        DEC currentGilbySpeed
b7152   INC currentGilbySpeed
        LDA currentGilbySpeed
        BNE AnimateGilbyMovement

        ; Gilby has come to a halt. Check if fire is pressed and whether he's over
        ; land - if both are the case, land the gilby.
b715A   LDA joystickInput
        AND #$10
        BEQ b7141 ; Fire pressed?
        LDA gilbyIsOverLand
        BEQ b7141
        LDA #$01
        STA gilbyIsEarthbound
        LDA #GILBY_TAKING_OFF4
        STA currentGilbySprite
        JMP LandGilby
        ; Returns

AnimateGilbyMovement
        JMP DrawParallaxOfStarfieldInGilbyDirection
        ; Returns

joystickInput          .BYTE $09
gilbyCurrentState .BYTE $04
gilbyAnimationTYpe     .BYTE $02

;-------------------------------------------------------
; CalculateGilbyVerticalPositionAirborne
;-------------------------------------------------------
CalculateGilbyVerticalPositionAirborne
        LDA gilbyCurrentState
        CMP #AIRBORNE
        BEQ MaybeJoystickPressedDown
ReturnEarlyFromVertPos   
        RTS

MaybeJoystickPressedDown   
        LDA joystickInput
        AND #$01
        BNE MaybeJoystickPressedUp
        DEC gilbyVerticalPositionUpperPlanet
        DEC gilbyVerticalPositionUpperPlanet
        LDA gilbyVerticalPositionUpperPlanet
        AND #$FE
        CMP #$30
        BNE UpdateGilbyVerticalPosition
        INC gilbyVerticalPositionUpperPlanet
        INC gilbyVerticalPositionUpperPlanet
UpdateGilbyVerticalPosition   
        LDA gilbyVerticalPositionUpperPlanet
        STA $D001    ;Sprite 0 Y Pos
        RTS

MaybeJoystickPressedUp   
        LDA joystickInput
        AND #$02
        BNE ReturnEarlyFromVertPos
        INC gilbyVerticalPositionUpperPlanet
        INC gilbyVerticalPositionUpperPlanet
        LDA gilbyVerticalPositionUpperPlanet
        AND #$F0
        CMP #$70
        BNE UpdateGilbyVerticalPosition
        DEC gilbyVerticalPositionUpperPlanet
        DEC gilbyVerticalPositionUpperPlanet
        BNE UpdateGilbyVerticalPosition
        ;Fall through?

;-------------------------------------------------------
; DrawPlanetSurfaces
;-------------------------------------------------------
DrawPlanetSurfaces
        LDY #$00
        LDA lowerPlanetActivated
        BEQ b71E6

        ; Only need to draw the upper planet
        LDX #$27
b71CB   LDA (planetTextureTopLayerPtr),Y
        STA SCREEN_RAM + LINE7_COL0,Y
        LDA (planetTextureSecondFromTopLayerPtr),Y
        STA SCREEN_RAM + LINE8_COL0,Y
        LDA (planetTextureSecondFromBottomLayerPtr),Y
        STA SCREEN_RAM + LINE9_COL0,Y
        LDA (planetTextureBottomLayerPtr),Y
        STA SCREEN_RAM + LINE10_COL0,Y
        INY
        DEX
        CPY #$28
        BNE b71CB
        RTS

        ;Draw the upper and lower planets. The lower
        ; planet is a mirror image of the top.
b71E6   LDX #$27
b71E8   LDA (planetTextureTopLayerPtr),Y
        STA SCREEN_RAM + LINE7_COL0,Y
        ORA #$C0
        STA SCREEN_RAM + LINE15_COL0,X
        LDA (planetTextureSecondFromTopLayerPtr),Y
        STA SCREEN_RAM + LINE8_COL0,Y
        ORA #$C0
        STA SCREEN_RAM + LINE14_COL0,X
        LDA (planetTextureSecondFromBottomLayerPtr),Y
        STA SCREEN_RAM + LINE9_COL0,Y
        ORA #$C0
        STA SCREEN_RAM + LINE13_COL0,X
        LDA (planetTextureBottomLayerPtr),Y
        STA SCREEN_RAM + LINE10_COL0,Y
        ORA #$C0
        STA SCREEN_RAM + LINE12_COL0,X
        INY
        DEX
        CPY #$28
        BNE b71E8
        RTS

;-------------------------------------------------------
; ScrollPlanets
;-------------------------------------------------------
ScrollPlanets
        INC planetScrollFrameRate
        LDA planetScrollFrameRate
        AND #$0F
        TAX
        LDA colorSequenceArray2,X
        STA unusedByte1
        LDA colorSequenceArray,X
        STA unusedByte2
        LDA currentGilbySpeed
        BMI MaybeGilbyStationary
        JMP ScrollPlanetLeft

MaybeGilbyStationary   
        LDA planetScrollSpeed
        CLC
        ADC currentGilbySpeed
        STA planetScrollSpeed
        AND #$F8
        BNE ScrollPlanetRight
        RTS

ScrollPlanetRight   
        LDA planetScrollSpeed
        EOR #$FF
        CLC
        AND #$F8
        ROR
        ROR
        ROR
        STA tempHiPtr1
        INC tempHiPtr1
        LDA planetTextureTopLayerPtr
        CLC
        ADC tempHiPtr1
        STA planetTextureTopLayerPtr
        STA planetTextureSecondFromTopLayerPtr
        STA planetTextureSecondFromBottomLayerPtr
        STA planetTextureBottomLayerPtr
        LDA planetTextureTopLayerPtrHi
        ADC #$00
;-------------------------------------------------------
; DrawPlanetScroll
;-------------------------------------------------------
DrawPlanetScroll
        ; Adjust the layer pointers to the approriate
        ; positions for this planet
        STA planetTextureTopLayerPtrHi
        CLC
        ADC #$04
        STA planetTextureSecondFromTopLayerPtrHi
        CLC
        ADC #$04
        STA planetTextureSecondFromBottomLayerPtrHi
        CLC
        ADC #$04
        STA planetTextureBottomLayerPtrHi

        LDA planetScrollSpeed
        AND #$07
        STA planetScrollSpeed
        LDA planetTextureTopLayerPtrHi
        CMP #$7F
        BNE b7294

        ; Planet needs to wrap around from the left.
        LDA planetTextureTopLayerPtr
        SEC
        SBC #$28
        STA planetTextureTopLayerPtr
        STA planetTextureSecondFromTopLayerPtr
        STA planetTextureSecondFromBottomLayerPtr
        STA planetTextureBottomLayerPtr
        LDA #$83
        JMP DrawPlanetScroll

b7294   CMP #$83
        BNE b72BD

        ; Planet data for the top layer ends at $83DB
        LDA planetTextureTopLayerPtr
        CMP #$D8
        BEQ b72AD
        CMP #$D9
        BEQ b72AD
        CMP #$DA
        BEQ b72AD
        CMP #$DB
        BEQ b72AD
        ;Planet doesn't need to wrap around
        JMP b72BD

        ; Planet needs to wrap around from the right.
b72AD   CLC
        ADC #$28
        STA planetTextureTopLayerPtr
        STA planetTextureSecondFromTopLayerPtr
        STA planetTextureSecondFromBottomLayerPtr
        STA planetTextureBottomLayerPtr
        LDA #$80
        JMP DrawPlanetScroll

b72BD   JMP DrawPlanetSurfaces

;-------------------------------------------------------
; ScrollPlanetLeft
;-------------------------------------------------------
ScrollPlanetLeft
        LDA planetScrollSpeed
        CLC
        ADC currentGilbySpeed
        STA planetScrollSpeed
        AND #$F8
        BNE b72CF
        RTS

b72CF   CLC
        ROR
        ROR
        ROR
        STA tempHiPtr1

        LDA planetTextureTopLayerPtr
        SEC
        SBC tempHiPtr1

        STA planetTextureTopLayerPtr
        STA planetTextureSecondFromTopLayerPtr
        STA planetTextureSecondFromBottomLayerPtr
        STA planetTextureBottomLayerPtr

        LDA planetTextureTopLayerPtrHi
        SBC #$00
        JMP DrawPlanetScroll

;-------------------------------------------------------
; StoreRandomPositionInPlanetInPlanetPtr
;-------------------------------------------------------
StoreRandomPositionInPlanetInPlanetPtr
        LDA #<planetOneBottomLayer
        STA planetPtrLo

        LDA #>planetOneBottomLayer
        STA planetPtrHi

        LDA charSetDataPtrLo
        BEQ LoPtrAlreadyZero

        INC planetPtrHi
        INC planetPtrHi

LoPtrAlreadyZero   
        LDA planetPtrLo
        CLC
        ADC charSetDataPtrHi
        STA planetPtrLo

        LDA planetPtrHi
        ADC #$00
        STA planetPtrHi

        LDA planetPtrLo
        CLC
        ADC charSetDataPtrHi
        STA planetPtrLo

        LDA planetPtrHi
        ADC #$00
        STA planetPtrHi

        LDY #$00
        RTS

;-------------------------------------------------------
; PutProceduralByteInAccumulatorRegister
;-------------------------------------------------------
PutProceduralByteInAccumulatorRegister
randomIntToIncrement   =*+$01
        LDA randomPlanetData
        INC randomIntToIncrement
        RTS

;-------------------------------------------------------
; UpdateTopPlanetSurfaceColor
;-------------------------------------------------------
UpdateTopPlanetSurfaceColor
        LDX #$28
b731F   STA COLOR_RAM + LINE6_COL39,X
        STA COLOR_RAM + LINE7_COL39,X
        STA COLOR_RAM + LINE8_COL39,X
        STA COLOR_RAM + LINE9_COL39,X
        DEX
        BNE b731F
        RTS

;-------------------------------------------------------
; UpdateBottomPlanetSurfaceColor
;-------------------------------------------------------
UpdateBottomPlanetSurfaceColor
        LDX #$28
b7331   STA COLOR_RAM + LINE11_COL39,X
        STA COLOR_RAM + LINE12_COL39,X
        STA COLOR_RAM + LINE13_COL39,X
        STA COLOR_RAM + LINE14_COL39,X
        DEX
        BNE b7331
        RTS

;-------------------------------------------------------
; InvertSurfaceDataForLowerPlanet
;-------------------------------------------------------
InvertSurfaceDataForLowerPlanet
        LDA currentBottomPlanetDataLoPtr
        STA planetSurfaceDataPtrLo
        LDA currentBottomPlanetDataHiPtr
        STA planetSurfaceDataPtrHi

        JSR InvertCharacter
        LDA invertedCharToDraw
        ; Note that 'X' was updated by InvertCharacter
        STA lowerPlanetSurfaceCharset,X
        INC planetSurfaceDataPtrHi

        JSR InvertCharacter
        LDA invertedCharToDraw
        ; Note that 'X' was updated by InvertCharacter
        STA lowerPlanetHUDCharset,X

        RTS

;-------------------------------------------------------
; InvertCharacter
; There are two parts to this routine:
; - Inverting the byte itself
; - Inverting its position in the 8-byte charset 
;   definition
;-------------------------------------------------------
InvertCharacter
        ; This part of the routine inverts the byte itself.

        ; The rightmost bit-pair.
        LDA (planetSurfaceDataPtrLo),Y
        PHA
        AND #$03
        TAX

        LDA bitfield1ForInvertingByte,X
        STA invertedCharToDraw

        ; The second-to-right bitpair. We're pulling the
        ; original byte back off the stack and shifting
        ; the secdond-to-right bitpair to the rightmost
        ; position.
        PLA
        ROR
        ROR
        PHA
        AND #$03
        TAX

        LDA bitfield2ForInvertingByte,X
        ORA invertedCharToDraw
        STA invertedCharToDraw

        ; The second-to-left bitpair.
        PLA
        ROR
        ROR
        AND #$03
        TAX

        LDA bitfield3ForInvertingByte,X
        ORA invertedCharToDraw
        STA invertedCharToDraw

        ; The left-most bitpair.
        LDA (planetSurfaceDataPtrLo),Y
        ROL
        ROL
        ROL
        AND #$03
        ORA invertedCharToDraw
        STA invertedCharToDraw

        ; Now that the byte has been inverted, invert the position in
        ; the 8 byte charset definition. For example, if the position is
        ; 0 then the inverted position is 7.

        ; Mask out everything but the last 3 bits in the current upper
        ; planet position. 
        TYA
        PHA
        AND #$07
        TAY
        PLA
        PHA
        AND #$F8
        STA charSetDataPtrLo

        ; Now add the inverted position to get the correct lower planet
        ; position in the 8-byte charset definition. charSetDataPtrLo is
        ; just temporary storage here. We store the final value for use
        ; by the calling routine in 'X' below.
        LDA positionInInvertedCharSet,Y
        CLC
        ADC charSetDataPtrLo

        ; By storing the updated position in the charset definition to 'X'
        ; here, we're changing the offset used in lowerPlanetSurfaceCharset
        ; in InvertSurfaceDataForLowerPlanet.
        TAX

        PLA
        TAY

        RTS

positionInInvertedCharSet              .BYTE $07,$06,$05,$04,$03,$02,$01,$00
currentTopPlanetDataLoPtr       .BYTE $00
currentTopPlanetDataHiPtr       .BYTE $92
currentBottomPlanetDataLoPtr    .BYTE $00
currentBottomPlanetDataHiPtr    .BYTE $92
bitfield1ForInvertingByte .BYTE $00,$40,$80,$C0
bitfield2ForInvertingByte .BYTE $00,$10,$20,$30
bitfield3ForInvertingByte .BYTE $00,$04,$08,$0C

;-------------------------------------------------------
; GeneratePlanetSurface
;
; This is the routine Minter called 'an'.
;
; From Jeff Minter's development diary:
; 17 February 1986
; "Redid the graphics completely, came up with some really nice looking
; metallic planet structures that I'll probably stick with. Started to
; write the an routine that'll generate random planets at will.
; Good to have a C64 that can generate planets in its spare time.
; Wrote pulsation routines for the colours; looks well good with some
; of the planet structures. The metallic look seems to be 'in' at the
; moment so this first planet will go down well. There will be five
; planet surface types in all, I reckon, probably do one with grass
; and sea a bit like 'Sheep in Space', cos I did like that one. It'll
; be nice to have completely different planet surfaces in top and bottom
; of the screen. The neat thing is that all the surfaces have the same
; basic structures, all I do is fit different graphics around each one."
;-------------------------------------------------------

GeneratePlanetSurface
        LDA #<planetSurfaceData
        STA planetSurfaceDataPtrLo
        LDA #>planetSurfaceData
        STA planetSurfaceDataPtrHi

        ; Clear down the planet surface data from $8000 to $8FFF.
        ; There are 4 layers:
        ; Top Layer:    $8000 to $83FF - 256 bytes 
        ; Second Layer: $8400 to $87FF - 256 bytes 
        ; Third Layer:  $8800 to $8BFF - 256 bytes 
        ; Bottom Layer: $8C00 to $8FFF - 256 bytes 
        LDY #$00
ClearPlanetHiPtrs   
        ; $60 is an empty character and gets written to the entire
        ; range from $8000 to $8FFF.
        LDA #$60
ClearPlanetLoPtrs   
        STA (planetSurfaceDataPtrLo),Y
        DEY
        BNE ClearPlanetLoPtrs
        INC planetSurfaceDataPtrHi
        LDA planetSurfaceDataPtrHi
        CMP (#>planetSurfaceData) + $10
        BNE ClearPlanetHiPtrs

        ; Fill $8C00 to $8FFF with a $40,$42 pattern. These are the
        ; character values that represent 'sea' on the planet.
        LDA #$8C
        STA planetSurfaceDataPtrHi
WriteSeaLoop   
        LDA #$40
        STA (planetSurfaceDataPtrLo),Y
        LDA #$42
        INY
        STA (planetSurfaceDataPtrLo),Y
        DEY
        ; Move the pointers forward by 2 bytes
        LDA planetSurfaceDataPtrLo
        CLC
        ADC #$02
        STA planetSurfaceDataPtrLo
        LDA planetSurfaceDataPtrHi
        ADC #$00
        STA planetSurfaceDataPtrHi
        ; Loop until $8FFF
        CMP #$90
        BNE WriteSeaLoop

        ; Pick a random point between $8C00 and $8FFF for
        ; the start of the land section.

        ; Get a random number between 0 and 256 and store
        ; in A.
        JSR PutProceduralByteInAccumulatorRegister
        ; Ensure the random number is between 128 and 256.
        AND #$7F ; e.g. $92 becomes $12.
        CLC      ; Clear the carry so addition doesn't overflow.
        ADC #$7F ; e.g. Adding $7F to $12 gives $91 (145).
        ; Store the result.
        STA charSetDataPtrHi

        LDA #$00
        STA charSetDataPtrLo

        ; Use the two pointers above to pick a random position
        ; in the planet between $8C00 and $8FFF and store it in
        ; planetPtrLo/planetPtrHi
        JSR StoreRandomPositionInPlanetInPlanetPtr

        ; Randomly generate the length of the land section, but
        ; make it at least 32 bytes and not more than 150.
        JSR PutProceduralByteInAccumulatorRegister
        AND #$7F ; Random number between 0 and 128
        CLC
        ADC #$20 ; Add 32
        STA planetSurfaceDataPtrLo

        ; Store $5C,$5E in the randomly chosen position. This is the
        ; left shore of the land.
        LDY #$00
        LDA #$5C
        STA (planetPtrLo),Y
        LDA #$5E
        INY
        STA (planetPtrLo),Y

        ; Draw the land from the randomly chosen position for up to
        ; 150 bytes, depending on the randomly chosen length of the land
        ; chosen above and storedin planetSurfaceDataPtrLo.
DrawLandMassLoop   
        INC charSetDataPtrHi
        BNE b7420

        INC charSetDataPtrLo
b7420   JSR StoreRandomPositionInPlanetInPlanetPtr
        LDY #$00
        LDA #$41
        STA (planetPtrLo),Y
        LDA #$43
        INY
        STA (planetPtrLo),Y
        DEC planetSurfaceDataPtrLo
        BNE DrawLandMassLoop

        ; Draw the right short of the land, represented by the chars in
        ; $5D/$5F.
        INY
        LDA #$5D
        STA (planetPtrLo),Y
        LDA #$5F
        INY
        STA (planetPtrLo),Y

        JSR GeneratePlanetStructures

        RTS

mediumStructureData  .BYTE $65,$67,$69,$6B,$FF
                     .BYTE $64,$66,$68,$6A,$FE
largestStructureData .BYTE $41,$43,$51,$53,$41,$43,$FF
                     .BYTE $60,$60,$50,$52,$60,$60,$FF
                     .BYTE $49,$4B,$4D,$4F,$6D,$6F,$FF
                     .BYTE $48,$4A,$4C,$4E,$6C,$6E,$FE
nextLargestStructure .BYTE $59,$5B,$FF
                     .BYTE $58,$5A,$FF
                     .BYTE $55,$57,$FF
                     .BYTE $54,$56,$FE
warpGateData         .BYTE $75,$77,$7D,$7F,$FF
                     .BYTE $74,$76,$7C,$7E,$FF
                     .BYTE $71,$73,$79,$7B,$FF
                     .BYTE $70,$72,$78,$7A,$FE

;-------------------------------------------------------
; DrawLittleStructure ($7486)
;-------------------------------------------------------
DrawLittleStructure
        ; Start iterating at 0.
        LDX #$00
DrawLSLoop
        ; Get the byte in littleStructureData pointed to
        ; by X.
        LDA littleStructureData,X
        ; If we reached the 'end of layer' sentinel, move
        ; our pointer planetPtrHi to the next layer. The
        ; BNE 'stays on the same layer' by jumping to
        ; LS_StayonSameLayer if the current byte
        ; is not $FF.
        CMP #$FF
        BNE LS_StayonSameLayer
        ; Switch to the next layer.
        JSR SwitchToNextLayerInPlanet
        ; SwitchToNextLayerInPlanet incremented X for us
        ; so continue looping.
        JMP DrawLSLoop

LS_StayonSameLayer   
        CMP #$FE
        ; If we read in an $FE, we're done drawing.
        BEQ ReturnFromDrawingStructure
        STA (planetPtrLo),Y
        ; Increment Y to the next position to write to.
        INY
        ; Increment X to get the next byte to read in.
        INX
        ; Continue looping.
        JMP DrawLSLoop

littleStructureData .BYTE $45,$47,$FF
                    .BYTE $44,$46,$FE

;-------------------------------------------------------
; SwitchToNextLayerInPlanet
;-------------------------------------------------------
SwitchToNextLayerInPlanet
        LDA planetPtrHi
        SEC
        SBC #$04
        STA planetPtrHi
        LDY #$00
        INX
ReturnFromDrawingStructure   
        RTS

;-------------------------------------------------------
; DrawMediumStructure ($74B1)
;-------------------------------------------------------
DrawMediumStructure
        LDX #$00

DrawMSLoop
        LDA mediumStructureData,X
        CMP #$FF
        BNE b74C0
        JSR SwitchToNextLayerInPlanet
        JMP DrawMSLoop

b74C0   CMP #$FE
        BEQ ReturnFromDrawingStructure ; Return
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawMSLoop

;-------------------------------------------------------
; DrawLargestStructure ($74CB)
;-------------------------------------------------------
DrawLargestStructure
        LDX #$00

DrawLargeStructureLoop
        LDA largestStructureData,X
        CMP #$FF
        BNE b74DA
        JSR SwitchToNextLayerInPlanet
        JMP DrawLargeStructureLoop

b74DA   CMP #$FE
        BEQ ReturnFromDrawingStructure ; Return
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawLargeStructureLoop

;-------------------------------------------------------
; DrawNextLargestStructure ($74E5)
;-------------------------------------------------------
DrawNextLargestStructure
        LDX #$00
DrawNSLoop
        LDA nextLargestStructure,X
        CMP #$FF
        BNE b74F4
        JSR SwitchToNextLayerInPlanet
        JMP DrawNSLoop

b74F4   CMP #$FE
        BEQ ReturnFromDrawingStructure ; Return
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawNSLoop

;-------------------------------------------------------
; DrawWarpGate
;-------------------------------------------------------
DrawWarpGate
        LDX #$00
DrawWGLoop
        LDA warpGateData,X
        CMP #$FF
        BNE b750E
        JSR SwitchToNextLayerInPlanet
        JMP DrawWGLoop

b750E   CMP #$FE
        BEQ ReturnFromDrawingStructure
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawWGLoop

;-----------------------------------------------------------
; GeneratePlanetStructures
;-----------------------------------------------------------
GeneratePlanetStructures
        LDA #<characterSetData
        STA charSetDataPtrLo
        LDA #>characterSetData
        STA charSetDataPtrHi

        ; Draw randomly chosen structures across the surface
        ; of the planet.
GenerateStructuresLoop
        JSR DrawRandomlyChosenStructure
        JSR PutProceduralByteInAccumulatorRegister

        ; The offset will be between 13 and 29
        AND #$0F
        CLC
        ADC #$0C
        CLC
        ADC charSetDataPtrHi
        STA charSetDataPtrHi

        LDA charSetDataPtrLo
        ADC #$00
        STA charSetDataPtrLo

        LDA charSetDataPtrHi
        AND #$F0
        CMP #$C0
        BEQ DrawWarpGates

        CMP #$D0
        BEQ DrawWarpGates

        JMP GenerateStructuresLoop

        ; Draw the two warp gates
DrawWarpGates   
        LDA charSetDataPtrLo
        BEQ GenerateStructuresLoop

        ; Draw a warp gate at the end of the map.
        LDA #$F1
        STA charSetDataPtrHi

        JSR StoreRandomPositionInPlanetInPlanetPtr
        JSR DrawWarpGate
        DEC charSetDataPtrLo

        ; Draw a warp gate at the start of the map.
        LDA #$05
        STA charSetDataPtrHi

        JSR StoreRandomPositionInPlanetInPlanetPtr
        JSR DrawWarpGate

        RTS

;---------------------------------------------------------------
; DrawRandomlyChosenStructure
;---------------------------------------------------------------
DrawRandomlyChosenStructure
        ; Pick a random positio to draw the structure
        JSR StoreRandomPositionInPlanetInPlanetPtr

        ; Run the randomly chose subroutine, one of:
        ; DrawLittleStructure, DrawMediumStructure,
        ; DrawLargestStructure, DrawNextLargestStructure
        ; to draw a structure on the planet surface

        ; Pick a random number between 0 and 3
        JSR PutProceduralByteInAccumulatorRegister
        ; AND'ing with $03 ensures the number is between
        ; 0 and 3.
        AND #$03
        ; Move the number to the X register.
        TAX
        ; Use the random number to pick and draw a structure.
        LDA structureSubRoutineArrayHiPtr,X
        STA structureRoutineHiPtr
        LDA structureSubRoutineArrayLoPtr,X
        STA structureRoutineLoPtr
        ; With the address of the routine we've chosen copied
        ; to structureRoutineLoPtr, we jump to that address and
        ; run the routine.
        JMP (structureRoutineLoPtr)
        ; The routine contains an 'RTS' so does the returning
        ; for us.

;Jump table
structureSubRoutineArrayHiPtr   .BYTE >DrawLittleStructure,>DrawMediumStructure
                                .BYTE >DrawLargestStructure,>DrawNextLargestStructure
structureSubRoutineArrayLoPtr   .BYTE <DrawLittleStructure,<DrawMediumStructure
                                .BYTE <DrawLargestStructure,<DrawNextLargestStructure

; This array is used to animate the movement of the gilby with the correct sequence of sprites.
; gilbySpriteIndex is the index into this array. spriteIndexToUseNextInGilbyAnimation and
; backupGilbySpriteIndex are also used to manage the value of gilbySpriteIndex.
gilbySprites .BYTE LAND_GILBY1,LAND_GILBY2,LAND_GILBY3,LAND_GILBY4,LAND_GILBY5,LAND_GILBY6,LAND_GILBY7,LAND_GILBY6
             .BYTE LAND_GILBY5,LAND_GILBY4,LAND_GILBY3,LAND_GILBY2,LAND_GILBY1,LAND_GILBY8,LAND_GILBY9,LAND_GILBY10
             .BYTE LAND_GILBY11,LAND_GILBY11,GILBY_TAKING_OFF1,GILBY_TAKING_OFF2,GILBY_TAKING_OFF3
             .BYTE GILBY_TAKING_OFF4,GILBY_TAKING_OFF3,GILBY_TAKING_OFF2
             .BYTE GILBY_TAKING_OFF1,LAND_GILBY11,GILBY_AIRBORNE_RIGHT,GILBY_AIRBORNE_TURNING
             .BYTE GILBY_TAKING_OFF4,GILBY_TAKING_OFF5,GILBY_AIRBORNE_LEFT,GILBY_AIRBORNE_LEFT
             .BYTE GILBY_TAKING_OFF5,GILBY_TAKING_OFF4,GILBY_AIRBORNE_TURNING,GILBY_AIRBORNE_RIGHT

spriteIndexToUseNextInGilbyAnimation .BYTE $11
backupGilbySpriteIndex               .BYTE $0D
gilbyInitialAnimationFrameRate       .BYTE $06
gilbyAnimationFrameRate              .BYTE $06
gilbySpriteIndex                     .BYTE $0D
;-------------------------------------------------------
; UpdateCurrentGilbySprite
;-------------------------------------------------------
UpdateCurrentGilbySprite
        LDA gilbyHasJustDied
        BNE b75BF
        LDA pauseModeSelected
        BNE b75BF
        LDA levelEntrySequenceActive
        BEQ b75BA
        JMP DrawLevelEntryAndWarpGilbyAnimation
        ; Returns

b75BA   DEC gilbyAnimationFrameRate
        BEQ b75C0
b75BF   RTS

b75C0   LDA gilbyInitialAnimationFrameRate
        STA gilbyAnimationFrameRate
        LDA gilbyAnimationTYpe
        BEQ b75CF
        CMP #$02
        BEQ b75BF
b75CF   INC gilbySpriteIndex
        LDA gilbySpriteIndex
        CMP spriteIndexToUseNextInGilbyAnimation
        BNE b7601
        LDA gilbyAnimationTYpe
        BEQ b75E3
        INC gilbyAnimationTYpe
        RTS

b75E3   LDA backupGilbySpriteIndex
        STA gilbySpriteIndex
        LDA gilbyCurrentState
        CMP #HORIZONTAL_MOVEMENT
        BNE b7601
        LDA gilbyVerticalPositionUpperPlanet
        CMP #$6D
        BNE b7601
        LDA #<gilbyWalkingSound
        STA primarySoundEffectLoPtr
        LDA #>gilbyWalkingSound
        STA primarySoundEffectHiPtr
b7601   LDX gilbySpriteIndex
        LDA gilbySprites,X
        STA currentGilbySprite
        RTS

gilbyLandingJumpingAnimationYPosOffset .BYTE $01
gilbyVerticalPositionUpperPlanet       .BYTE $3F
gilbyVerticalPositionLowerPlanet       .BYTE $CA
gilbyLandingFrameRate                  .BYTE $01
intervalsBetweenAcceleration        .BYTE $03

YPOS_PLANET_SURFACE = $6D
;-------------------------------------------------------
; CalculateGilbyVerticalPositionEarthBound
;-------------------------------------------------------
CalculateGilbyVerticalPositionEarthBound
        LDA levelEntrySequenceActive
        BNE ReturnEarlyEarthboundVertPos
        DEC gilbyLandingFrameRate
        BEQ MaybeGilbyIsOnLandAlready
ReturnEarlyEarthboundVertPos   
        RTS

MaybeGilbyIsOnLandAlready   
        LDA #$02
        STA gilbyLandingFrameRate
        LDA gilbyIsEarthbound
        BEQ ReturnEarlyEarthboundVertPos

        LDA gilbyVerticalPositionUpperPlanet
        CMP #YPOS_PLANET_SURFACE
        BEQ ReturnEarlyEarthboundVertPos

        DEC intervalsBetweenAcceleration
        BEQ AccelerateGilbyMovement

UpdateGilbyPosition
        CLC
        ADC gilbyLandingJumpingAnimationYPosOffset
        STA gilbyVerticalPositionUpperPlanet
        AND #$F0
        CMP #YPOS_PLANET_SURFACE + $03
        BNE StorePositionAndReturn

        LDA #YPOS_PLANET_SURFACE
        STA gilbyVerticalPositionUpperPlanet

StorePositionAndReturn   
        LDA gilbyVerticalPositionUpperPlanet
        STA $D001    ;Sprite 0 Y Pos
        RTS

AccelerateGilbyMovement   
        LDA #$03
        STA intervalsBetweenAcceleration

        INC gilbyLandingJumpingAnimationYPosOffset
        LDA gilbyLandingJumpingAnimationYPosOffset
        CMP #$08
        BEQ ReachedMaximumAcceleration

        LDA gilbyVerticalPositionUpperPlanet
        JMP UpdateGilbyPosition

ReachedMaximumAcceleration   
        DEC gilbyLandingJumpingAnimationYPosOffset
        LDA gilbyVerticalPositionUpperPlanet
        JMP UpdateGilbyPosition

bulletDirectionArray .BYTE $00,$00,$00,$00,$00,$00,$00,$00
bulletFrameRate      .BYTE $01
;-------------------------------------------------------
; ProcessFireButtonPressed
;-------------------------------------------------------
ProcessFireButtonPressed
        ; Check if fire pressed
        LDA joystickInput
        AND #$10
        BEQ b767E

        ; Fire not pressed
        LDA #$01
        STA bulletFrameRate
b767D   RTS

        ;Fire has been pressed
b767E   LDX #$00
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        BMI b76A8
        LDX #$06
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        BMI b76A8
        LDX #$01
        DEC bulletFrameRate
        BNE b767D
        LDA #$06
        STA bulletFrameRate
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        BPL b76A0
        JSR b76A8
b76A0   LDX #$07
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        BMI b76A8
        RTS

        ; X is always zero in here?
b76A8   LDA #$B5
        STA upperPlanetGilbyBulletXPos,X
        LDA #$00
        STA upperPlanetGilbyBulletMSBXPosValue,X
        LDA gilbyVerticalPositionUpperPlanet
        CLC
        ADC #$04
        STA upperPlanetGilbyBulletYPos,X
        LDA #$E7 ; Gilby's ground based bullet
        STA upperPlanetGilbyBulletSpriteValue,X
        LDA currentGilbySpeed
        EOR #$FF
        STA bulletDirectionArray,X
        INC bulletDirectionArray,X
        LDA #$FA
        STA upperPlanetGilbyBulletNextYPosArray,X

        LDA soundEffectInProgress
        BNE b76DF

        LDA #<bulletSoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>bulletSoundEffect
        STA secondarySoundEffectHiPtr

b76DF   LDA gilbyCurrentState
        CMP #AIRBORNE
        BNE b7717

        ; The gilby is in the air
        LDA soundEffectInProgress
        BNE b76F8
        JSR ResetRepetitionForSecondarySoundEffect
        LDA #<airborneBulletSoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>airborneBulletSoundEffect
        STA secondarySoundEffectHiPtr

b76F8   LDA gilbyVerticalPositionUpperPlanet
        CLC
        ADC #$06
        STA upperPlanetGilbyBulletYPos,X
        LDA #$B1
        STA upperPlanetGilbyBulletXPos,X
        LDA #$EC ; Gilby's in-flight bullet
        STA upperPlanetGilbyBulletSpriteValue,X

        LDA currentGilbySprite
        CMP #GILBY_AIRBORNE_LEFT
        BNE b7718

        ; Gilby is left-facing.
        LDA #$F5
        STA bulletDirectionArray,X
b7717   RTS

b7718   CMP #GILBY_AIRBORNE_RIGHT
        BNE b7722

        ; Gilby is right-facing.
        LDA #$0B
        STA bulletDirectionArray,X
        RTS

        ; Gilby is ground-based?
b7722   LDA #$FF
        STA upperPlanetGilbyBulletMSBXPosValue,X
        JMP ResetUpperPlanetBullet
        ;Returns

;-------------------------------------------------------
; CheckBulletPositions
;-------------------------------------------------------
CheckBulletPositions
        LDA #$00
        STA currentMSBXPosOffset
        STA bulletOffsetRate
        LDA pauseModeSelected
        BEQ b7736
        RTS

b7736   LDA bulletDirectionArray,X
        BEQ b776F
        BPL b7741
        LDA #$FF
        STA bulletOffsetRate
b7741   LDA upperPlanetGilbyBulletMSBXPosValue,X
        BEQ b7748
        INC currentMSBXPosOffset
b7748   LDA upperPlanetGilbyBulletXPos,X
        CLC
        ADC bulletDirectionArray,X
        STA upperPlanetGilbyBulletXPos,X
        LDA currentMSBXPosOffset
        ADC bulletOffsetRate
        STA currentMSBXPosOffset
        LDA currentMSBXPosOffset
        AND #$01
        BEQ b7761
        LDA gilbyBulletMSBXPosOffset,X
b7761   STA upperPlanetGilbyBulletMSBXPosValue,X
        BEQ b7770
        LDA upperPlanetGilbyBulletXPos,X
        AND #$F0
        CMP #$30
        BEQ b7777
b776F   RTS

b7770   LDA upperPlanetGilbyBulletXPos,X
        AND #$F0
        BNE b776F
b7777   LDA #$FF
        STA upperPlanetGilbyBulletMSBXPosValue,X
        PLA
        PLA
        JSR ResetUpperPlanetBullet
        JMP UpdateBulletSpriteAndReturnIfRequired

upperPlanetGilbyBulletNextYPosArray   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
;-------------------------------------------------------
; UpdateBulletPositions
;-------------------------------------------------------
UpdateBulletPositions
        LDX #$00
        LDA gilbyHasJustDied
        BEQ UpdateNextBullet
UpdateBulletReturnEarly   
        RTS

UpdateNextBullet   
        LDA levelEntrySequenceActive
        BNE UpdateBulletReturnEarly
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        CMP #$FF
        BEQ b77A9
        JSR UpdateUpperPlanetBulletPosition
        JSR CheckBulletPositions
        JMP UpdateBulletSpriteAndReturnIfRequired

b77A9   LDA #BLANK_SPRITE
        STA upperPlanetGilbyBulletSpriteValue,X
;-------------------------------------------------------
; UpdateBulletSpriteAndReturnIfRequired
;-------------------------------------------------------
UpdateBulletSpriteAndReturnIfRequired
        INX
        CPX #$08
        BEQ JumpToUpdateBulletSpriteAndReturn
        CPX #$02
        BNE UpdateNextBullet
        LDX #$06
        JMP UpdateNextBullet

JumpToUpdateBulletSpriteAndReturn   
        JMP UpdateBulletSpriteAndReturn

upperPlanetBulletYPosUpdateCounterArray   .BYTE $03,$03,$03,$03,$03,$03,$03,$03
;-------------------------------------------------------
; UpdateUpperPlanetBulletPosition
;-------------------------------------------------------
UpdateUpperPlanetBulletPosition
        LDA upperPlanetGilbyBulletSpriteValue,X
        CMP #LASER_BULLET
        BEQ ReturnEarlyFromBullet

        ; There's a bullet to update.
        LDA upperPlanetGilbyBulletYPos,X
        CLC
        ADC upperPlanetGilbyBulletNextYPosArray,X
        STA upperPlanetGilbyBulletYPos,X
        DEC upperPlanetBulletYPosUpdateCounterArray,X
        BNE b77E5
        LDA #$03
        STA upperPlanetBulletYPosUpdateCounterArray,X
        INC upperPlanetGilbyBulletNextYPosArray,X
b77E5   LDA upperPlanetGilbyBulletYPos,X
        AND #$F8
        CMP #$78
        BEQ b77F2
        CMP #$88
        BNE ReturnEarlyFromBullet
b77F2   LDA #$FF
        STA upperPlanetGilbyBulletMSBXPosValue,X
        JSR ResetUpperPlanetBullet
        PLA
        PLA
        JMP UpdateBulletSpriteAndReturnIfRequired

;-------------------------------------------------------
; ResetUpperPlanetBullet
;-------------------------------------------------------
ResetUpperPlanetBullet
        LDA #$F0
        STA upperPlanetGilbyBulletSpriteValue,X
        LDA #$FF
        STA upperPlanetGilbyBulletXPos,X
        LDA #$00
        STA upperPlanetGilbyBulletYPos,X
ReturnEarlyFromBullet   
        RTS

;-------------------------------------------------------
; UpdateBulletSpriteAndReturn
;-------------------------------------------------------
UpdateBulletSpriteAndReturn
        LDX #$00
b7811   LDA #$FF
        SEC
        SBC upperPlanetAttackShip3YPos,X
        ADC #$17
        STA lowerPlanetGilbyBulletYPos,X
        LDA lowerPlanetAttackShipsXPosArray,X
        EOR #$FF
        STA bulletOffsetRate
        LDA lowerPlanetAttackShipsMSBXPosArray,X
        BEQ b782A
        LDA #$01
b782A   EOR #$FF
        STA currentMSBXPosOffset
        INC currentMSBXPosOffset
        LDA #$6F
        CLC
        ADC bulletOffsetRate
        STA lowerPlanetAttackShip2XPos,X
        LDA currentMSBXPosOffset
        ADC #$00
        AND #$01
        STA currentMSBXPosOffset
        BEQ b7845
        LDA gilbyBulletMSBXPosOffset,X
b7845   STA lowerPlanetAttackShip2MSBXPosValue,X
        INX
        CPX #$02
        BNE b7811
        RTS

;-------------------------------------------------------
; DrawControlPanel
;-------------------------------------------------------
DrawControlPanel
        LDX #$A0
b7850   LDA controlPanelData,X
        STA SCREEN_RAM + LINE20_COL39,X
        LDA controlPanelColors - $01,X
        STA COLOR_RAM + LINE20_COL39,X
        DEX
        BNE b7850
        RTS

f1WasPressed   .BYTE $00
;-------------------------------------------------------
; CheckKeyboardInGame
;-------------------------------------------------------
CheckKeyboardInGame
        LDA lastKeyPressed
        CMP #$40 ; $40 means no key was pressed
        BNE KeyWasPressed
        LDA #$00
        STA f1WasPressed
ReturnEarlyFromKeyboardCheck   
        RTS

KeyWasPressed   
        LDY f1WasPressed
        BNE ReturnEarlyFromKeyboardCheck
        LDY attractModeCountdown
        BEQ b787C
        ; If a key is pressed during attract mode, accelerate the
        ; countdown so that it exits it nearly immediately.
        LDY #$02
        STY attractModeCountdown
b787C   LDY levelRestartInProgress
        BNE ReturnEarlyFromKeyboardCheck
        LDY gilbyHasJustDied
        BNE ReturnEarlyFromKeyboardCheck

        CMP #KEY_Q ; Q pressed, to quit game
        BNE CheckF1Pressed

        ; Q was pressed, get ready to quit game.
        INC qPressedToQuitGame
        RTS

CheckF1Pressed   
        CMP #KEY_F1_F2 ; F1 Pressed
        BNE CheckSpacePressed
        INC f1WasPressed
        INC pauseModeSelected
ReturnFromKeyboardCheck   
        RTS

CheckSpacePressed   
        CMP #KEY_SPACE ; Space pressed
        BNE CheckYPressed
        INC progressDisplaySelected
        RTS

        ; We can award ourselves a bonus bounty by
        ; pressing Y at any time, as long as '1C' is the
        ; first character in the hiscore table. Not sure
        ; what this hack is for, testing?
CheckYPressed   
        CMP #KEY_Y ; Y Pressed
        BNE ReturnFromKeyboardCheck
        LDA canAwardBonus
        CMP #$1C
        BNE ReturnFromKeyboardCheck
        INC bonusAwarded
        RTS

topPlanetPointerIndex      .BYTE $00
oldTopPlanetIndex          .BYTE $00
bottomPlanetPointerIndex   .BYTE $00
oldBottomPlanetIndex       .BYTE $00
qPressedToQuitGame         .BYTE $00
backgroundColor1ForPlanets .BYTE $09,$0B,$07,$0E,$0D
backgroundColor2ForPlanets .BYTE $0E,$10,$01,$07,$10
surfaceColorsForPlanets    .BYTE LTGREEN,BROWN,LTRED,GRAY2,LTRED,WHITE,WHITE
entryLevelSequenceCounter  .BYTE $A5
levelEntrySequenceActive   .BYTE $01

;-------------------------------------------------------
; MaybeDrawLevelEntrySequence
; The time used for animating the entry level sequence
; is also used to invert the charset for the lower planet
; surface byte by byte. The entryLevelSequenceCounter is
; 256 counts long - the same length as the surface. So each
; time we're called here we add another byte to the inverted
; surface.
;-------------------------------------------------------
MaybeDrawLevelEntrySequence
        LDA levelEntrySequenceActive
        BNE DrawLevelEntrySequence
ReturnFromEntrySequence   
        RTS

DrawLevelEntrySequence   
        LDX entryLevelSequenceCounter
        LDY sourceOfSeedBytes,X

        LDA currentTopPlanetDataLoPtr
        STA planetSurfaceDataPtrLo

        LDA currentTopPlanetDataHiPtr
        STA planetSurfaceDataPtrHi

        LDA (planetSurfaceDataPtrLo),Y
        STA upperPlanetSurfaceCharset,Y

        INC planetSurfaceDataPtrHi
        LDA (planetSurfaceDataPtrLo),Y
        STA upperPlanetHUDCharset,Y

        JSR InvertSurfaceDataForLowerPlanet

        ; See if we should end the sequence
        INC entryLevelSequenceCounter
        LDA entryLevelSequenceCounter
        CMP #$01
        BNE ReturnFromEntrySequence

        ; The sequence is over
        LDA #$00
        STA levelEntrySequenceActive

;-------------------------------------------------------
; SetUpPlanets
;-------------------------------------------------------
SetUpPlanets
        LDX topPlanetPointerIndex
        LDA backgroundColor1ForPlanets,X
        STA currentPlanetBackgroundClr1
        LDA backgroundColor2ForPlanets,X
        STA currentPlanetBackgroundClr2

        LDA surfaceColorsForPlanets,X
        JSR UpdateTopPlanetSurfaceColor

        LDX bottomPlanetPointerIndex
        LDA backgroundColor1ForPlanets,X
        STA currentPlanetBackgroundColor1

        LDA backgroundColor2ForPlanets,X
        STA currentPlanetBackgroundColor2

        LDA surfaceColorsForPlanets,X
        JSR UpdateBottomPlanetSurfaceColor

        LDA #$01
        STA gilbyExploding
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$03
        STA starFieldInitialStateArray - $01

        LDX #$06
        LDA #$EC
b7939   STA upperPlanetAttackShipsSpriteValueArray,X
        STA lowerPlanetAttackShipsSpriteValueArray,X
        DEX
        BNE b7939

        LDA #$FF
        STA upperPlanetGilbyBulletMSBXPosValue
        STA upperPlanetAttackShip2MSBXPosValue
        STA lowerPlanetAttackShipsMSBXPosArray
        STA lowerPlanetGilbyBulletMSBXPosValue

        JSR ResetRepetitionForSecondarySoundEffect
        LDA #<levelEntrySoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>levelEntrySoundEffect
        STA secondarySoundEffectHiPtr

        LDA #$30
        STA soundEffectInProgress
        LDA lowerPlanetActivated
        BEQ b797C

        LDX topPlanetPointerIndex
        LDA backgroundColor1ForPlanets,X
        STA currentPlanetBackgroundColor1
        LDA backgroundColor2ForPlanets,X
        STA currentPlanetBackgroundColor2
        LDA surfaceColorsForPlanets,X
        JSR UpdateBottomPlanetSurfaceColor
b797C   RTS

lowerPlanetActivated                    .BYTE $01
soundEffectBuffer                       .BYTE $00,$94,$00,$00,$11,$0F,$00,$00
                                        .BYTE $03,$00,$00,$21,$0F,$00,$08,$03
                                        .BYTE $00,$00,$21,$0F,$00,$00,$00,$00
                                        .BYTE $02,$00,$00,$00,$00,$00,$00,$00
storedPrimarySoundEffectLoPtr           .BYTE <f5D92
storedPrimarySoundEffectHiPtr           .BYTE >f5D92
storedSecondarySoundEffectLoPtr         .BYTE <f5C85
storedSecondarySoundEffectHiPtr         .BYTE >f5C85
repetitionsForPrimarySoundEffect        .BYTE $02,$00
repetitionsForSecondarySoundEffect      .BYTE $00,$00
indexToPrimaryOrSecondarySoundEffectPtr .BYTE $02

; Five bytes loaded from the sound effect in 5 byte intervals.
soundEffectDataStructure
soundEffectDataStructure_Byte1 .BYTE $18
soundEffectDataStructure_Byte2 .BYTE $05
soundEffectDataStructure_Byte3 .BYTE $00
soundEffectDataStructure_Byte4 .BYTE <fPlanetWarpLoop
soundEffectDataStructure_Byte5 .BYTE >fPlanetWarpLoop

primarySoundEffectLoPtr     .BYTE <f5D97
primarySoundEffectHiPtr     .BYTE >f5D97
secondarySoundEffectLoPtr   .BYTE <fPlanetWarpLoop
secondarySoundEffectHiPtr   .BYTE >fPlanetWarpLoop
;-------------------------------------------------------
; PlaySoundEffects
;-------------------------------------------------------
PlaySoundEffects
        LDA #$00
        STA indexToPrimaryOrSecondarySoundEffectPtr
        LDA soundEffectInProgress
        BEQ DontDecrementSoundEffectProgressCounter
        DEC soundEffectInProgress
DontDecrementSoundEffectProgressCounter   
        LDA primarySoundEffectLoPtr
        STA currentSoundEffectLoPtr
        LDA primarySoundEffectHiPtr
        STA currentSoundEffectHiPtr
        JSR PlayCurrentSoundEffect

        LDA #$02
        STA indexToPrimaryOrSecondarySoundEffectPtr
        LDA secondarySoundEffectLoPtr
        STA currentSoundEffectLoPtr
        LDA secondarySoundEffectHiPtr
        STA currentSoundEffectHiPtr
        ;Falls through and plays secondary sound effect.

;-------------------------------------------------------
; PlayCurrentSoundEffect
;-------------------------------------------------------
PlayCurrentSoundEffect
        LDY #$00
FillSoundEffectDataStructureLoop   
        LDA (currentSoundEffectLoPtr),Y
        STA soundEffectDataStructure,Y
        INY
        CPY #$05
        BNE FillSoundEffectDataStructureLoop

        LDA soundEffectDataStructure_Byte2
        BNE PlayNextSoundBasedOnSequenceByte

        ; Type 00 just plays what ever is in Byte 2 into
        ; the offset of D400 given by Byte 3.
        LDA soundEffectDataStructure_Byte3
        LDX soundEffectDataStructure_Byte4
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte

GetNextRecordAndMaybePlayIt
        JSR GetNextRecordInSoundEffect
        LDA soundEffectDataStructure_Byte5
        BEQ PlayCurrentSoundEffect
        CMP #$01
        BNE StorePointersAndReturn
        RTS

StorePointersAndReturn   
        LDX indexToPrimaryOrSecondarySoundEffectPtr
        LDA currentSoundEffectLoPtr
        STA storedPrimarySoundEffectLoPtr,X
        LDA currentSoundEffectHiPtr
        STA storedPrimarySoundEffectHiPtr,X
        RTS

;-------------------------------------------------------
; GetNextRecordInSoundEffect
;-------------------------------------------------------
GetNextRecordInSoundEffect
        LDA currentSoundEffectLoPtr
        CLC
        ADC #$05
        STA currentSoundEffectLoPtr
        LDX indexToPrimaryOrSecondarySoundEffectPtr
        STA primarySoundEffectLoPtr,X
        LDA currentSoundEffectHiPtr
        ADC #$00
        STA currentSoundEffectHiPtr
        STA primarySoundEffectHiPtr,X
        RTS

;-------------------------------------------------------
; PlayNextSoundBasedOnSequenceByte
;-------------------------------------------------------
PlayNextSoundBasedOnSequenceByte   
        AND #$80
        BEQ MaybeIncrementAndPlaySoundFromBuffer
        JMP MaybeSkipToLinkedRecord

MaybeIncrementAndPlaySoundFromBuffer   
        LDA soundEffectDataStructure_Byte2
        CMP #INC_AND_PLAY_FROM_BUFFER
        BNE MaybeDecrementAndPlaySoundFromBuffer

        ; Increment the value in the buffer and play it.
        LDX soundEffectDataStructure_Byte1
        LDA soundEffectBuffer,X
        CLC
        ADC soundEffectDataStructure_Byte3
        LDX soundEffectDataStructure_Byte4
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP GetNextRecordAndMaybePlayIt

MaybeDecrementAndPlaySoundFromBuffer   
        CMP #DEC_AND_PLAY_FROM_BUFFER
        BNE TrySequenceByteValueOf3

        ; Decrement the value in the buffer and play it.
        LDX soundEffectDataStructure_Byte1
        LDA soundEffectBuffer,X
        SEC
        SBC soundEffectDataStructure_Byte3

GetNextRecordInSoundEffectLoop
        LDX soundEffectDataStructure_Byte4
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP GetNextRecordAndMaybePlayIt

TrySequenceByteValueOf3   
        CMP #$03
        BNE TrySequenceByteValueOf4
        LDX soundEffectDataStructure_Byte1
        LDY soundEffectDataStructure_Byte3
        LDA soundEffectBuffer,X
        CLC
        ADC soundEffectBuffer,Y
        JMP GetNextRecordInSoundEffectLoop

TrySequenceByteValueOf4   
        CMP #$04
        BNE MaybeIsFadeOutLoop
        LDX soundEffectDataStructure_Byte1
        LDY soundEffectDataStructure_Byte3
        LDA soundEffectBuffer,X
        SEC
        SBC soundEffectBuffer,Y
        JMP GetNextRecordInSoundEffectLoop

MaybeIsFadeOutLoop   
        CMP #PLAY_LOOP
        BNE TrySequenceByteValueOf6

        ; The record is a fade out loop. Bytes 4 and 5
        ; (soundEffectDataStructure_Byte4 and soundEffectDataStructure_Byte5) contain
        ; the address of the record to loop back to.
        ; Byte 0 contains the offset to the volume switch
        ; (i.e. 18 for D418).
        ; Byte 2 (dataForSounEffectBuffer) contains the
        ; decrements to reduce the volume by. 
        LDX soundEffectDataStructure_Byte1
        LDA soundEffectBuffer,X
        SEC
        SBC soundEffectDataStructure_Byte3

StorePointersAndReturnIfZero
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        BEQ JumpToGetNextRecordInSoundEffect
        LDA soundEffectDataStructure_Byte4
        LDX indexToPrimaryOrSecondarySoundEffectPtr
        STA primarySoundEffectLoPtr,X
        LDA soundEffectDataStructure_Byte5
        STA primarySoundEffectHiPtr,X
        RTS

JumpToGetNextRecordInSoundEffect   
        JMP GetNextRecordInSoundEffect

TrySequenceByteValueOf6   
        CMP #$06
        BNE MaybeSkipToLinkedRecord
        LDX soundEffectDataStructure_Byte1
        LDA soundEffectBuffer,X
        CLC
        ADC soundEffectDataStructure_Byte3
        JMP StorePointersAndReturnIfZero

MaybeSkipToLinkedRecord
        LDA soundEffectDataStructure_Byte2
        CMP #$80
        BNE MaybePlayStoredSoundEffect

        ; Cease playing records and point to the
        ; record to play at the next interrupt.
        LDX indexToPrimaryOrSecondarySoundEffectPtr
        LDA soundEffectDataStructure_Byte3
        STA primarySoundEffectLoPtr,X
        LDA soundEffectDataStructure_Byte4
        STA primarySoundEffectHiPtr,X
        RTS

MaybePlayStoredSoundEffect   
        CMP #REPEAT_PREVIOUS
        BNE ReturnFromGetNextRecordInSoundEffect

        ; Play a sound effect record stored previously.
        LDX indexToPrimaryOrSecondarySoundEffectPtr
        LDA repetitionsForPrimarySoundEffect,X
        BNE SoundEffectPresent
        LDA soundEffectDataStructure_Byte3
        STA repetitionsForPrimarySoundEffect,X

SoundEffectPresent   
        DEC repetitionsForPrimarySoundEffect,X
        BEQ JumpToGetNextRecordInSoundEffect_
        LDA storedPrimarySoundEffectLoPtr,X
        STA currentSoundEffectLoPtr
        LDA storedPrimarySoundEffectHiPtr,X
        STA currentSoundEffectHiPtr
        JMP PlayCurrentSoundEffect

JumpToGetNextRecordInSoundEffect_   
        JMP GetNextRecordInSoundEffect

ReturnFromGetNextRecordInSoundEffect   
        RTS

PLAY_SOUND = $00
; 'Plays' the value in Byte 2 by writing it to the SID register given
; by the offset in Byte 3.
; Byte 0 - Unused
; Byte 1 - $00 (PLAY_SOUND)
; Byte 2 - Value to write to offset to $D400 given by Byte 3.
; Byte 3 - Offset to $D400 to write to.
; Byte 4 - '00' indicates the next record should be played immediately.
;          '01' indicates should play no more records.
;          Anything else indicates the next record should be stored and
;           no more should be played for now.

INC_AND_PLAY_FROM_BUFFER = $01
; Picks a value from soundEffectBuffer using Byte 0 as an index, increments
; it with Byte 2, and then 'plays' it to the register given by Byte 3.
; Byte 0 - Address of byte to pick from soundEffectBuffer
; Byte 1 - $01 (INC_AND_PLAY_FROM_BUFFER)
; Byte 2 - Amount to increment picked byte by.
; Byte 3 - Offset to $D400 to write to.
; Byte 4 - '00' indicates the next record should be played immediately.
;          '01' indicates should play no more records.
;          Anything else indicates the next record should be stored and
;           no more should be played for now.

DEC_AND_PLAY_FROM_BUFFER = $02
; Picks a value from soundEffectBuffer using Byte 0 as an index, decrements
; it with Byte 2, and then 'plays' it to the register given by Byte 3.
; Byte 0 - Address of byte to pick from soundEffectBuffer
; Byte 1 - $02 (DEC_AND_PLAY_FROM_BUFFER)
; Byte 2 - Amount to decrement picked byte by.
; Byte 3 - Offset to $D400 to write to.
; Byte 4 - '00' indicates the next record should be played immediately.
;          '01' indicates should play no more records.
;          Anything else indicates the next record should be stored and
;           no more should be played for now.

PLAY_LOOP = $05
; Plays a sequence of records in a loop. Will use Byte 0 to pick a
; value from soundEffectBuffer, decrement Byte 2 from it, play the
; result to the offset from D400 given by Byte 0, and continue
; looping from the address given by Bytes 4 and 5
; until the picked value in soundEffectBuffer reaches zero.
; Byte 0 - Address of byte to pick from soundEffectBuffer
; Byte 1 - $05 (PLAY_LOOP)
; Byte 2 - Amount to decrement picked byte by.
; Byte 3 - Lo Ptr of next record to play
; Byte 4 - Hi Ptr of next record to play

LINK = $80
; Stops playing records and just updates primarySoundEffectLoPtr/
; primarySoundEffectHiPtr with Byes 4 and 5 that point to the record
; to be played the next time around.
; Byte 0 - Unused
; Byte 1 - $80 (LINK)
; Byte 2 - Lo Ptr of next record to play
; Byte 3 - Hi Ptr of next record to play
; Byte 4 - '00' indicates the next record should be played immediately.
;          '01' indicates should play no more records.
;          Anything else indicates the next record should be stored and
;           no more should be played for now.

REPEAT_PREVIOUS = $81
; Repeats the previous record by the number of times given in Byte 2.
; Byte 0 - Unused
; Byte 1 - $81 (REPEAT_PREVIOUS)
; Byte 2 - Number of times to play previously stored record.
; Byte 3 - Unused
; Byte 4 - '00' indicates the next record should be played immediately.
;          '01' indicates should play no more records.
;          Anything else indicates the next record should be stored and
;           no more should be played for now.
VOICE1_HI = $01
VOICE1_CTRL = $04
VOICE1_ATK_DEC = $05
VOICE1_SUS_REL = $06
VOICE2_HI = $08
VOICE2_CTRL = $0B
VOLUME = $18
VOICE3_HI = $0F
VOICE2_ATK_DEC = $0C
VOICE2_SUS_REL = $0D
VOICE3_CTRL = $12
VOICE3_ATK_DEC = $13
VOICE3_SUS_REL = $14

gilbyWalkingSound         .BYTE $00,PLAY_SOUND,$00,VOICE1_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$00,VOICE1_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$60,VOICE1_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$40,VOICE1_HI,$00
                          .BYTE $00,PLAY_SOUND,$81,VOICE1_CTRL,$01
                          .BYTE $00,PLAY_SOUND,$20,VOICE1_CTRL,$01
                          .BYTE $00,PLAY_SOUND,$10,VOICE1_HI,$01
                          .BYTE $00,PLAY_SOUND,$20,VOICE1_HI,$01
                          .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00
soundGilbyJumpOnLand      .BYTE $00,PLAY_SOUND,$00,VOICE1_CTRL,$01
                          .BYTE $00,PLAY_SOUND,$0F,VOICE1_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$F9,VOICE1_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$C0,VOICE1_HI,$00
                          .BYTE $00,PLAY_SOUND,$21,VOICE1_CTRL,$01
                          .BYTE $00,PLAY_SOUND,$10,VOICE1_CTRL,$02
                          .BYTE $01,INC_AND_PLAY_FROM_BUFFER,$41,VOICE1_HI,$01
                          .BYTE $00,REPEAT_PREVIOUS,$30,$00,$00
                          .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

pushedUpWhileOverSea      .BYTE $00,PLAY_SOUND,$00,VOICE1_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$00,VOICE1_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$F9,VOICE1_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$20,VOICE1_HI,$00
                          .BYTE $00,PLAY_SOUND,$81,VOICE1_CTRL,$01
                          .BYTE $00,PLAY_SOUND,$10,VOICE1_HI,$01
                          .BYTE $00,PLAY_SOUND,$10,VOICE1_HI,$00
                          .BYTE $00,PLAY_SOUND,$20,VOICE1_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$06,$1F,$00
pushedUpOverSeaLoop       .BYTE $01,INC_AND_PLAY_FROM_BUFFER,$20,VOICE1_HI,$02
                          .BYTE $01,DEC_AND_PLAY_FROM_BUFFER,$06,VOICE1_HI,$01
                          .BYTE $00,REPEAT_PREVIOUS,$06,$00,$00
                          .BYTE $1F,PLAY_LOOP,$01,<pushedUpOverSeaLoop,>pushedUpOverSeaLoop
                          .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00
                          .BYTE $00,PLAY_SOUND,$00,VOICE1_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$AD,VOICE1_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$C0,VOICE1_HI,$00
                          .BYTE $00,PLAY_SOUND,$5D,VOICE1_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$81,VOICE1_CTRL,$01
                          .BYTE $00,PLAY_SOUND,$80,VOICE1_CTRL,$01
                          .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

setVolumeToMax            .BYTE $00,PLAY_SOUND,$0F,VOLUME,$01
                          .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

bulletSoundEffect         .BYTE $00,PLAY_SOUND,$10,VOICE2_HI,$00
                          .BYTE $00,PLAY_SOUND,$0F,VOLUME,$01
                          .BYTE $00,PLAY_SOUND,$00,VOICE2_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$F0,VOICE2_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$00,VOICE3_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$F0,VOICE3_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$C0,VOICE3_HI,$00
                          .BYTE $00,PLAY_SOUND,$21,VOICE2_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$21,VOICE3_CTRL,$01
                          .BYTE $00,PLAY_SOUND,$10,VOICE3_HI,$00
bulletEffectLoop          .BYTE $0F,DEC_AND_PLAY_FROM_BUFFER,$01,VOICE3_HI,$00
                          .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$01,VOICE2_HI,$01
                          .BYTE $08,PLAY_LOOP,$00,<bulletEffectLoop,>bulletEffectLoop
                          .BYTE $00,PLAY_SOUND,$10,VOICE2_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$20,VOICE3_CTRL,$02
                          .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

airborneBulletSoundEffect .BYTE $00,PLAY_SOUND,$00,VOICE2_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$F0,VOICE2_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$00,VOICE3_ATK_DEC,$00
                          .BYTE $00,PLAY_SOUND,$F0,VOICE3_SUS_REL,$00
                          .BYTE $00,PLAY_SOUND,$0F,VOLUME,$01
                          .BYTE $00,PLAY_SOUND,$20,VOICE2_HI,$00
                          .BYTE $00,PLAY_SOUND,$C0,VOICE3_HI,$00
                          .BYTE $00,PLAY_SOUND,$81,VOICE2_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$81,VOICE3_CTRL,$02
                          .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$02,VOICE2_HI,$00
                          .BYTE $0F,INC_AND_PLAY_FROM_BUFFER,$01,VOICE3_HI,$01
                          .BYTE $00,REPEAT_PREVIOUS,$02,$00,$00
                          .BYTE $00,PLAY_SOUND,$11,VOICE2_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$15,VOICE3_CTRL,$02
                          .BYTE $08,DEC_AND_PLAY_FROM_BUFFER,$04,VOICE2_HI,$00
                          .BYTE $0F,INC_AND_PLAY_FROM_BUFFER,$02,VOICE3_HI,$01
                          .BYTE $00,REPEAT_PREVIOUS,$10,$00,$00
                          .BYTE $00,PLAY_SOUND,$80,VOICE2_CTRL,$00
                          .BYTE $00,PLAY_SOUND,$80,VOICE3_CTRL,$00
                          .BYTE $00,LINK,<setVolumeToMax,>setVolumeToMax,$00

borderFlashControl2       .BYTE $02
borderFlashControl1       .BYTE $01
currentEntropy            .BYTE $00

;-------------------------------------------------------
; ResetRepetitionForPrimarySoundEffect
;-------------------------------------------------------
ResetRepetitionForPrimarySoundEffect
        LDA #$00
        STA repetitionsForPrimarySoundEffect
        RTS

;-------------------------------------------------------
; ResetRepetitionForSecondarySoundEffect
;-------------------------------------------------------
ResetRepetitionForSecondarySoundEffect
        LDA #$00
        STA repetitionsForSecondarySoundEffect
b7C96   RTS

;-------------------------------------------------------
; UpdateAndAnimateAttackShips
;-------------------------------------------------------
UpdateAndAnimateAttackShips
        LDX #$04
        LDA gilbyHasJustDied
        BNE b7C96
        LDA levelEntrySequenceActive
        BNE b7C96
b7CA3   LDA upperPlanetAttackShip2MSBXPosValue,X
        BMI b7CC2
        LDA upperPlanetAttackShip2XPos,X
        LDY currentGilbySpeed
        BMI b7CF0
        CLC
        ADC currentGilbySpeed
        STA upperPlanetAttackShip2XPos,X
        BCC b7CC2

j7CB9
        LDA upperPlanetAttackShip2MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA upperPlanetAttackShip2MSBXPosValue,X
b7CC2   LDA lowerPlanetAttackSHip3MSBXPosValue,X
        BMI b7CE1
        LDA lowerPlanetAttackShip3XPos,X
        LDY currentGilbySpeed
        BMI b7D07
        SEC
        SBC currentGilbySpeed
        STA lowerPlanetAttackShip3XPos,X
        BCS b7CE1

j7CD8
        LDA lowerPlanetAttackSHip3MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA lowerPlanetAttackSHip3MSBXPosValue,X
b7CE1   LDA pauseModeSelected
        BNE b7CE9
        JSR UpdateAttackShipsXAndYPositions
b7CE9   JSR AnimateAttackShipSprites
        DEX
        BNE b7CA3
        RTS

b7CF0   PHA
        TYA
        EOR #$FF
        STA attackShipOffsetRate
        INC attackShipOffsetRate
        PLA
        SEC
        SBC attackShipOffsetRate
        STA upperPlanetAttackShip2XPos,X
        BCS b7CC2
        JMP j7CB9

b7D07   PHA
        TYA
        EOR #$FF
        STA attackShipOffsetRate
        INC attackShipOffsetRate
        PLA
        CLC
        ADC attackShipOffsetRate
        STA lowerPlanetAttackShip3XPos,X
        BCC b7CE1
        JMP j7CD8

attackShipOffsetRate                          .BYTE $10
upperPlanetInitialXPosFrameRateForAttackShip  .BYTE $01,$01,$01,$01
lowerPlanetInitialXPosFrameRateForAttackShip  .BYTE $01,$01,$01,$01
upperPlanetXPosFrameRateForAttackShip         .BYTE $01,$01,$01,$01
lowerPlanetXPosFrameRateForAttackShip         .BYTE $01,$01,$01,$01
upperPlanetInitialYPosFrameRateForAttackShips .BYTE $01,$01,$01,$01
lowerPlanetInitialYPosFrameRateForAttackShips .BYTE $01,$01,$01,$01
upperPlanetYPosFrameRateForAttackShips        .BYTE $01,$01,$01,$01
lowerPlanetYPosFrameRateForAttackShips        .BYTE $01,$01,$01,$01

;-------------------------------------------------------
; UpdateAttackShipsXAndYPositions
;-------------------------------------------------------
UpdateAttackShipsXAndYPositions
        DEC upperPlanetYPosFrameRateForAttackShips - $01,X
        BNE b7D79
        LDA upperPlanetInitialYPosFrameRateForAttackShips - $01,X
        STA upperPlanetYPosFrameRateForAttackShips - $01,X
        LDA yPosMovementForUpperPlanetAttackShips - $01,X
        CLC
        ADC upperPlanetAttackShip2YPos,X
        STA upperPlanetAttackShip2YPos,X
        AND #$F0
        CMP #$70
        BEQ b7D6A
        CMP #$00
        BNE b7D79
        LDA #$10
        STA upperPlanetAttackShip2YPos,X
        LDA #$01
        STA hasReachedSecondWaveAttackShips + $01,X
        BNE b7D74
b7D6A   LDA #$6D
        STA upperPlanetAttackShip2YPos,X
        LDA #$01
        STA hasReachedThirdWaveAttackShips + $01,X
b7D74   LDA #$00
        STA yPosMovementForUpperPlanetAttackShips - $01,X
b7D79   DEC lowerPlanetYPosFrameRateForAttackShips - $01,X
        BNE b7DB4
        LDA lowerPlanetInitialYPosFrameRateForAttackShips - $01,X
        STA lowerPlanetYPosFrameRateForAttackShips - $01,X
        LDA yPosMovementForLowerPlanetAttackShips - $01,X
        CLC
        ADC lowerPlanetAttackShip2YPos,X
        STA lowerPlanetAttackShip2YPos,X
        AND #$F0
        BEQ b7DA5
        LDA lowerPlanetAttackShip2YPos,X
        CMP #$99
        BPL b7DB4
        LDA #$99
        STA lowerPlanetAttackShip2YPos,X
        LDA #$01
        STA hasReachedThirdWaveAttackShips +$07,X
        BNE b7DAF
b7DA5   LDA #$FF
        STA lowerPlanetAttackShip2YPos,X
        LDA #$01
        STA hasReachedSecondWaveAttackShips + $07,X
b7DAF   LDA #$00
        STA yPosMovementForLowerPlanetAttackShips - $01,X
b7DB4   DEC upperPlanetXPosFrameRateForAttackShip - $01,X
        BNE DecrementXPosFrameRateLowerPlanet

        LDA upperPlanetInitialXPosFrameRateForAttackShip - $01,X
        STA upperPlanetXPosFrameRateForAttackShip - $01,X

        LDA xPosMovementForUpperPlanetAttackShip - $01,X
        BMI UpperBitSetOnXPosMovement

        CLC
        ADC upperPlanetAttackShip2XPos,X
        STA upperPlanetAttackShip2XPos,X
        BCC DecrementXPosFrameRateLowerPlanet
        LDA upperPlanetAttackShip2MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA upperPlanetAttackShip2MSBXPosValue,X
        JMP DecrementXPosFrameRateLowerPlanet

UpperBitSetOnXPosMovement   
        ; This creates a decelerating effect on the attack ship's movement.
        ; Used by the licker ship wave in planet 1 for example.
        EOR #$FF
        STA attackShipOffsetRate
        INC attackShipOffsetRate
        LDA upperPlanetAttackShip2XPos,X
        SEC
        SBC attackShipOffsetRate
        STA upperPlanetAttackShip2XPos,X
        BCS DecrementXPosFrameRateLowerPlanet

        LDA upperPlanetAttackShip2MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA upperPlanetAttackShip2MSBXPosValue,X

DecrementXPosFrameRateLowerPlanet   
        DEC lowerPlanetXPosFrameRateForAttackShip - $01,X
        BNE ReturnFromUpdateXYPositions

        LDA lowerPlanetInitialXPosFrameRateForAttackShip - $01,X
        STA lowerPlanetXPosFrameRateForAttackShip - $01,X
        LDA xPosMovementForLowerPlanetAttackShip - $01,X
        BMI UpperBitSetOnXPosMovementLowerPlanet

        CLC
        ADC lowerPlanetAttackShip3XPos,X
        STA lowerPlanetAttackShip3XPos,X
        BCC ReturnFromUpdateXYPositions
        LDA lowerPlanetAttackSHip3MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA lowerPlanetAttackSHip3MSBXPosValue,X
        JMP ReturnFromUpdateXYPositions

UpperBitSetOnXPosMovementLowerPlanet   
        EOR #$FF
        STA attackShipOffsetRate
        INC attackShipOffsetRate
        LDA lowerPlanetAttackShip3XPos,X
        SEC
        SBC attackShipOffsetRate
        STA lowerPlanetAttackShip3XPos,X
        BCS ReturnFromUpdateXYPositions
        LDA lowerPlanetAttackSHip3MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA lowerPlanetAttackSHip3MSBXPosValue,X

ReturnFromUpdateXYPositions   
        RTS

xPosMovementForUpperPlanetAttackShip              .BYTE $06,$06,$06,$06
xPosMovementForLowerPlanetAttackShip              .BYTE $06,$06,$06,$06
yPosMovementForUpperPlanetAttackShips             .BYTE $FF,$FF,$FF,$FF
yPosMovementForLowerPlanetAttackShips             .BYTE $00,$00,$01,$01
upperPlanetAttackShipSpritesLoadedFromBackingData .BYTE EXPLOSION_START,EXPLOSION_START,EXPLOSION_START,EXPLOSION_START
lowerPlanetAttackShipSpritesLoadedFromBackingData .BYTE EXPLOSION_START,EXPLOSION_START,EXPLOSION_START,EXPLOSION_START
upperPlanetAttackShipSpriteAnimationEnd           .BYTE BLANK_SPRITE,BLANK_SPRITE,BLANK_SPRITE,BLANK_SPRITE
lowerPlanetAttackShipSpriteAnimationEnd           .BYTE BLANK_SPRITE,BLANK_SPRITE,BLANK_SPRITE,BLANK_SPRITE
upperPlanetAttackShipAnimationFrameRate           .BYTE $01,$01,$01,$01
lowerPlanetAttackShipAnimationFrameRate           .BYTE $01,$01,$01,$01
upperPlanetAttackShipInitialFrameRate             .BYTE $03,$03,$03,$03
lowerPlanetAttackShipInitialFrameRate             .BYTE $03,$03,$03,$03
;-------------------------------------------------------
; AnimateAttackShipSprites
;-------------------------------------------------------
AnimateAttackShipSprites
        LDA pauseModeSelected
        BEQ AnimateUpperPlanetAttackShips
        RTS

AnimateUpperPlanetAttackShips   
        DEC upperPlanetAttackShipAnimationFrameRate - $01,X
        BNE AnimateLowerPlanetAttackShips

        LDA upperPlanetAttackShipInitialFrameRate - $01,X
        STA upperPlanetAttackShipAnimationFrameRate - $01,X
        INC upperPlanetAttackShip2SpriteValue,X
        LDA upperPlanetAttackShip2SpriteValue,X

        ; Reached the end of the animation?
        CMP upperPlanetAttackShipSpriteAnimationEnd - $01,X
        BNE AnimateLowerPlanetAttackShips

        ; Reset the animation sprite back to the start.
        LDA upperPlanetAttackShipSpritesLoadedFromBackingData - $01,X
        STA upperPlanetAttackShip2SpriteValue,X

AnimateLowerPlanetAttackShips   
        DEC lowerPlanetAttackShipAnimationFrameRate - $01,X
        BNE DontAnimateLowerPlanetAttackShip

        LDA lowerPlanetAttackShipInitialFrameRate - $01,X
        STA lowerPlanetAttackShipAnimationFrameRate - $01,X
        INC lowerPlanetAttackShip2SpriteValue,X
        LDA lowerPlanetAttackShip2SpriteValue,X

        ; Reached the end of the animation?
        CMP lowerPlanetAttackShipSpriteAnimationEnd - $01,X
        BNE DontAnimateLowerPlanetAttackShip

        ; Reset the animation sprite back to the start.
        LDA lowerPlanetAttackShipSpritesLoadedFromBackingData - $01,X
        STA lowerPlanetAttackShip2SpriteValue,X
DontAnimateLowerPlanetAttackShip   
        RTS

;-------------------------------------------------------
; DetectGameOrAttractMode
;-------------------------------------------------------
DetectGameOrAttractMode
        LDA attractModeSelected
        BNE b7EB8
        LDA #$01
        STA lowerPlanetActivated
        LDA #$00
        STA attractModeCountdown
        RTS

b7EB8   LDA #$00
        STA lowerPlanetActivated
        LDA #$FF
        STA attractModeCountdown
        RTS

;-------------------------------------------------------
; SelectRandomPlanetsForAttractMode
;-------------------------------------------------------
SelectRandomPlanetsForAttractMode

        ; Select 9 random numbers between 0 and 15
        LDX #$09
b7EC5   JSR PutProceduralByteInAccumulatorRegister
        AND #$0F
        STA currentLevelInTopPlanets,X
        DEX
        BPL b7EC5

        ; Select a random planet between 0 and 3
        JSR PutProceduralByteInAccumulatorRegister
        AND #$03
        STA topPlanetPointerIndex

        ; Select a random planet between 0 and 3
        JSR PutProceduralByteInAccumulatorRegister
        AND #$03
        STA bottomPlanetPointerIndex
        RTS

; When attract mode is selected this gets set to $FF and gets 
; decremented every time a random joystick input is selected.
; When it reaches zero the main game loop will default to the
; high score screen.
attractModeCountdown       .BYTE $AD
randomJoystickInputCounter .BYTE $09
randomJoystickInput        .BYTE $09
;-------------------------------------------------------
; GenerateJoystickInputForAttractMode
;-------------------------------------------------------
GenerateJoystickInputForAttractMode
        LDA attractModeCountdown
        BNE b7EEA
        RTS

b7EEA   DEC randomJoystickInputCounter
        BNE b7F01
        JSR PutProceduralByteInAccumulatorRegister
        AND #$1F
        ORA #$01
        STA randomJoystickInputCounter
        LDA randomJoystickInput
        EOR #$0F
        STA randomJoystickInput
b7F01   LDA randomJoystickInput
        STA joystickInput
        RTS

.include "graphics/planet_surface.asm"
.include "graphics/planet_textures.asm"
.include "level_data/level_data.asm"

*=$AAC0
currentBonusBounty    .BYTE $F0
currentBonusBountyPtr .BYTE $30,$30,$30,$30,$30,$30,$30,$00
                      .BYTE $00,$00,$00,$00,$00,$C8,$18
bonusPhaseCounter     .BYTE $00
incrementLives        .BYTE $00
mifDNAPauseModeActive .BYTE $00,$0C,$00,$00,$00,$00,$0A,$F6
                      .BYTE $F9,$04,$F9,$FC,$00,$00
attractModeSelected   .BYTE $FF
unusedVariable2       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                      .BYTE $00,$00,$00,$02,$02,$01,$01,$00
                      .BYTE $00,$00,$00,$00,$10,$00,$10,$00
                      .BYTE $00,$00,$10,$00,$04,$40
                      .BYTE $00

.include "bonusphase.asm"

lastBlastScorePtr   =*+$02
;-------------------------------------------------------
; JumpToHiScoreScreen
;-------------------------------------------------------
JumpToHiScoreScreen
        JMP InitAndDisplayHiScoreScreen

lastBlastScore         .TEXT "0000000...."
previousLastBlastScore .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;-------------------------------------------------------
; JumpToDrawProgressDisplayScreen
;-------------------------------------------------------
jumpToDrawProgressLoPtr   =*+$01
jumpToDrawProgressHiPtr   =*+$02
JumpToDrawProgressDisplayScreen   JMP DrawProgressDisplayScreen

;-------------------------------------------------------
; The high score table.
;-------------------------------------------------------
hiScoreTablePtr           .TEXT "0068000"
canAwardBonus             .TEXT "YAK "
                          .FILL 10, $00
                          .TEXT  "0065535RATT"
                          .FILL 10, $00
                          .TEXT  "0049152WULF"
                          .FILL 10, $00
                          .TEXT "0032768INCA"
                          .FILL 10, $00
                          .TEXT "0030000MAT "
                          .FILL 10, $00
                          .TEXT "0025000PSY "
                          .FILL 10, $00
                          .TEXT "0020000TAK "
                          .FILL 10, $00
                          .TEXT "0016384GOAT"
                          .FILL 10, $00
                          .TEXT "0010000PINK"
                          .FILL 10, $00
                          .TEXT "0009000FLYD"
                          .FILL 10, $00
                          .TEXT "0008192LED "
                          .FILL 10, $00
                          .TEXT "0007000ZEP "
                          .FILL 10, $00
                          .TEXT "0006000MACH"
                          .FILL 10, $00
                          .TEXT "0005000SCUM"
                          .FILL 10, $00
                          .TEXT "0004096TREV"
                          .FILL 10, $00
                          .TEXT "0003000MARK"
                          .FILL 10, $00
                          .TEXT "0002000MAH "
                          .FILL 10, $00
                          .TEXT "0001000INTI"
                          .FILL 10, $00
ptrSecondLastScoreInTable .TEXT "0000900GIJO"
                          .FILL 10, $00
ptrLastScoreInTable       .TEXT "0000800LAMA"
                          .FILL 10, $00
                          .BYTE $FF

;-------------------------------------------------------
; InitAndDisplayHiScoreScreen
;-------------------------------------------------------
InitAndDisplayHiScoreScreen
        STX tempHiPtr1
        LDA #$00
        STA hasDisplayedHiScoreScreen
        STY tempLoPtr1
        ; Fall through

;-------------------------------------------------------
; DrawHiScoreScreen
;-------------------------------------------------------
DrawHiScoreScreen
        SEI
        LDA #<HiScoreScreenInterruptHandler
        STA $0314    ;IRQ
        LDA #>HiScoreScreenInterruptHandler
        STA $0315    ;IRQ
        CLI
        LDA #BLACK
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        JSR HiScoreStopSounds
        LDA hasDisplayedHiScoreScreen
        BEQ bC9E8
        JMP ClearScreenDrawHiScoreScreenText

bC9E8   LDY #$07
bC9EA   LDA (tempLoPtr),Y
        STA lastBlastScorePtr,Y
        DEY
        BNE bC9EA

        LDY #$09
bC9F4   LDA (tempLoPtr1),Y
        STA previousLastBlastScore,Y
        DEY
        BPL bC9F4

        LDY #$00
        LDA #<hiScoreTablePtr
        STA tempLoPtr
        LDA #>hiScoreTablePtr
        STA tempHiPtr

lastBlastScoreLength = $FB
        LDX #$00
        LDA #$14
        STA lastBlastScoreLength
bCA0C   LDA (tempLoPtr),Y
        CMP lastBlastScore,X
        BEQ bCA18
        BPL bCA1E
        JMP StoreLastBlastInTable

bCA18   INY
        INX
        CPY #$07
        BNE bCA0C
bCA1E   LDA tempLoPtr
        CLC
        ADC #$15
        STA tempLoPtr
        LDA tempHiPtr
        ADC #$00
        STA tempHiPtr
        LDY #$00
        LDX #$00
        DEC lastBlastScoreLength
        BNE bCA18

        LDA #$00
        STA storedLastBlastScore
        JMP ClearScreenDrawHiScoreScreenText

storedLastBlastScore   .BYTE $00
lastBlastCounter = $FA
;-------------------------------------------------------
; StoreLastBlastInTable
;-------------------------------------------------------
StoreLastBlastInTable
        LDA #$01
        STA lastBlastCounter
        LDA lastBlastScoreLength
        CMP #$01
        BNE bCA51
        LDA #<ptrLastScoreInTable
        STA tempLoPtr1
        LDA #>ptrLastScoreInTable
        STA tempHiPtr1
        JMP StoreLastBlastScoreInTable

bCA51   LDA #<ptrSecondLastScoreInTable
        STA tempLoPtr1
        LDA #>ptrSecondLastScoreInTable
        STA tempHiPtr1

StoreScoreLoop
        LDY #$00
bCA5B   LDA (tempLoPtr1),Y
        STA tempLastBlastStorage
        TYA
        PHA
        CLC
        ADC #$15
        TAY
        LDA tempLastBlastStorage
        STA (tempLoPtr1),Y
        PLA
        TAY
        INY
        CPY #$15
        BNE bCA5B

        INC lastBlastCounter
        LDA lastBlastCounter
        CMP lastBlastScoreLength
        BEQ StoreLastBlastScoreInTable
        LDA tempLoPtr1
        SEC
        SBC #$15
        STA tempLoPtr1
        LDA tempHiPtr1
        SBC #$00
        STA tempHiPtr1
        JMP StoreScoreLoop

;-------------------------------------------------------
; StoreLastBlastScoreInTable
;-------------------------------------------------------
StoreLastBlastScoreInTable
        LDA #$01
        STA storedLastBlastScore
        LDY #$14
bCA8F   LDA lastBlastScore,Y
        STA (tempLoPtr1),Y
        DEY
        BPL bCA8F
        LDA tempLoPtr1
        PHA
        LDA tempHiPtr1
        PHA
;-------------------------------------------------------
; ClearScreenDrawHiScoreScreenText
;-------------------------------------------------------
ClearScreenDrawHiScoreScreenText

        LDX #$00
bCA9F   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + LINE6_COL16,X
        STA SCREEN_RAM + LINE12_COL32,X
        STA SCREEN_RAM + LINE14_COL23,X
        LDA #WHITE
        STA COLOR_RAM + LINE0_COL0,X
        STA COLOR_RAM + LINE6_COL16,X
        STA COLOR_RAM + LINE12_COL32,X
        STA COLOR_RAM + LINE14_COL23,X
        DEX
        BNE bCA9F

        LDX #$27
bCAC0   LDA txtHiScorLine1,X
        AND #$3F
        STA SCREEN_RAM + LINE1_COL0,X
        LDA txtHiScorLine4,X
        AND #$3F
        STA SCREEN_RAM + LINE15_COL0,X
        DEX
        BPL bCAC0

        LDX #$06
bCAD5   LDA lastBlastScore,X
        STA SCREEN_RAM + LINE15_COL33,X
        DEX
        BPL bCAD5

        LDA #<hiScoreTablePtr
        STA tempLoPtr
        LDA #>hiScoreTablePtr
        STA tempHiPtr

        LDY #$00
bCAE8   LDA hiScoreTableCursorPosLoPtr,Y
        STA tempLoPtr1
        LDA hiScoreTableCursorPosHiPtr,Y
        STA tempHiPtr1
        TYA
        PHA
        LDY #$00
bCAF6   LDA (tempLoPtr),Y
        AND #$3F
        STA (tempLoPtr1),Y
        INY
        CPY #$07
        BNE bCAF6
        LDA tempLoPtr1
        CLC
        ADC #$03
        STA tempLoPtr1
        LDA tempHiPtr1
        ADC #$00
        STA tempHiPtr1
bCB0E   LDA (tempLoPtr),Y
        AND #$3F
        STA (tempLoPtr1),Y
        INY
        CPY #$0B
        BNE bCB0E
        PLA
        TAY
        LDA tempLoPtr
        CLC
        ADC #$15
        STA tempLoPtr
        LDA tempHiPtr
        ADC #$00
        STA tempHiPtr
        INY
        CPY #$14
        BNE bCAE8

        JMP ClearScreenDrawHiScoreTextContinued

; A jump table to positions in the screen for writing the scores.
hiScoreTableCursorPosLoPtr .BYTE $A1,$C9,$F1,$19,$41,$69,$91,$B9
                           .BYTE $E1,$09,$B5,$DD,$05,$2D,$55,$7D
                           .BYTE $A5,$CD,$F5,$1D
hiScoreTableCursorPosHiPtr .BYTE $04,$04,$04,$05,$05,$05,$05,$05
                           .BYTE $05,$06,$04,$04,$05,$05,$05,$05
                           .BYTE $05,$05,$05,$06
;-------------------------------------------------------
; ClearScreenDrawHiScoreTextContinued
;-------------------------------------------------------
ClearScreenDrawHiScoreTextContinued
        LDA storedLastBlastScore
        BNE bCB60
        JMP DisplayHiScoreScreen

bCB60   PLA
        STA tempHiPtr1
        PLA
        STA tempLoPtr1

        LDX #$27
bCB68   LDA txtHiScorLine2,X
        AND #$3F
        STA SCREEN_RAM + LINE18_COL0,X
        DEX
        BPL bCB68

        LDA #$14
        SEC
        SBC lastBlastScoreLength
        TAX
        LDA hiScoreTableCursorPosLoPtr,X
        STA tempLoPtr
        LDA hiScoreTableCursorPosHiPtr,X
        STA tempHiPtr

        LDY #$0A
bCB85   JSR GetHiScoreScreenInput
        INY
        CPY #$0E
        BNE bCB85

        JMP DisplayHiScoreScreen

hiScoreTableInputName .TEXT "YAK "
hiScoreJoystickInput = $FA
;-------------------------------------------------------
; GetHiScoreScreenInput
;-------------------------------------------------------
GetHiScoreScreenInput
        LDA hiScoreTableInputName - $0A,Y
        AND #$3F
        STA (tempLoPtr),Y
        STA tempHiScoreInputStorage
        TYA
        PHA
        SEC
        SBC #$03
        TAY
        LDA tempHiScoreInputStorage
        STA (tempLoPtr1),Y
        PLA
        TAY

        ; Get Joystick input.
        LDA $DC00    ;CIA1: Data Port Register A
        STA hiScoreJoystickInput

        ; Check joystick left
        AND #JOYSTICK_LEFT
        BNE CheckHiScoreJoystickRight

        LDA hiScoreTableInputName - $0A,Y
        SEC
        SBC #$01
        CMP #$FF
        BNE bCBBC
bCBBC   STA hiScoreTableInputName - $0A,Y
        LDA #$3F
        JMP HiScoreSpinBeforeNextInput

CheckHiScoreJoystickRight   
        LDA hiScoreJoystickInput
        AND #JOYSTICK_RIGHT
        BNE CheckHiScoreFire
        LDA hiScoreTableInputName - $0A,Y
        CLC
        ADC #$01
        CMP #NO_KEY_PRESSED ; $40 means no key was pressed
        BNE bCBD6
        LDA #$00
bCBD6   STA hiScoreTableInputName - $0A,Y

HiScoreSpinBeforeNextInput
        LDA #$50
        STA tempLastBlastStorage
        LDX #$00
bCBDF   DEX
        BNE bCBDF
        DEC tempLastBlastStorage
        BNE bCBDF
        JMP GetHiScoreScreenInput

CheckHiScoreFire   
        LDA hiScoreJoystickInput
        AND #JOYSTICK_FIRE
        BNE GetHiScoreScreenInput

bCBEF   LDA $DC00    ;CIA1: Data Port Register A
        AND #JOYSTICK_FIRE
        BEQ bCBEF

        LDA #$C0
        STA tempLastBlastStorage

        LDX #$00
bCBFC   DEX
        BNE bCBFC
        DEC tempLastBlastStorage
        BNE bCBFC
        RTS

;-------------------------------------------------------
; DisplayHiScoreScreen
;-------------------------------------------------------
DisplayHiScoreScreen
        LDA #$01
        STA hasDisplayedHiScoreScreen
        LDA #$00
        STA storedLastBlastScore

        LDX #$27
bCC10   LDA txtHiScorLine3,X
        AND #$3F
        STA SCREEN_RAM + LINE18_COL0,X
        DEX
        BPL bCC10

DrawCamelAtPosition
        LDX currentEntryInHiScoreTable
        LDA hiScoreTableCursorPosLoPtr,X
        STA tempLoPtr
        LDA hiScoreTableCursorPosHiPtr,X
        STA tempHiPtr
        LDY #$10
        LDA #$25 ; The camel character
        STA (tempLoPtr),Y

bCC2E   JSR HiScoreCheckInput
        AND #$13
        CMP #$13
        BNE bCC43
        LDA lastKeyPressed
        CMP #$3C
        BNE bCC2E

        JSR SetupHiScoreScreen
        JMP DrawHiScoreScreen

bCC43   STA hiScoreJoystickInput
        AND #$01
        BNE bCC67

        DEC currentEntryInHiScoreTable
        BPL bCC53

        LDA #$13
        STA currentEntryInHiScoreTable
bCC53   LDA #$50
        STA tempLastBlastStorage
        LDX #$00
bCC59   DEX
        BNE bCC59
        DEC tempLastBlastStorage
        BNE bCC59

        LDA #$20
        STA (tempLoPtr),Y
bCC64   JMP DrawCamelAtPosition

bCC67   LDA hiScoreJoystickInput
        AND #$02
        BNE bCC7E

        INC currentEntryInHiScoreTable
        LDA currentEntryInHiScoreTable
        CMP #$14
        BNE bCC53

        LDA #$00
        STA currentEntryInHiScoreTable
        BEQ bCC53

bCC7E   LDA hiScoreJoystickInput
        AND #$10
        BNE bCC64

        JMP ExitHiScoreScreen

currentEntryInHiScoreTable   .BYTE $00
hasDisplayedHiScoreScreen   .BYTE $01
;-------------------------------------------------------
; ExitHiScoreScreen
;-------------------------------------------------------
ExitHiScoreScreen
        LDX #$F8
        TXS
bCC8C   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ bCC8C
        JMP MainControlLoop

;-------------------------------------------------------
; SetupHiScoreScreen
;-------------------------------------------------------
SetupHiScoreScreen
        LDX currentEntryInHiScoreTable
        LDA #<hiScoreTablePtr
        STA tempLoPtr1
        LDA #>hiScoreTablePtr
        STA tempHiPtr1
        CPX #$00
        BEQ bCCB5

        ; Move the ptr to the position in the table given by currentEntryInHiScoreTable
bCCA5   LDA tempLoPtr1
        CLC
        ADC #$15
        STA tempLoPtr1
        LDA tempHiPtr1
        ADC #$00
        STA tempHiPtr1
        DEX
        BNE bCCA5

bCCB5   LDY #$0B
bCCB7   LDA (tempLoPtr1),Y
        STA tempHiScoreInputStorage
        TYA
        PHA
        SEC
        SBC #$0B
        TAY
        LDA tempHiScoreInputStorage
        STA (currentLevelInTopPlanetsLoPtr),Y
        PLA
        TAY
        INY
        CPY #$15
        BNE bCCB7
        LDA tempLoPtr1
        PHA
        LDA tempHiPtr1
        PHA
        DEC hiScoreScreenUpdateRate
        JSR JumpToDrawProgressDisplayScreen
        PLA
        STA tempHiPtr1
        PLA
        STA tempLoPtr1
        LDX #$27
bCCE0   LDA gameCompletionText,X
        AND #$3F
        STA SCREEN_RAM + LINE19_COL0,X
        DEX
        BPL bCCE0
        BMI UpdateDisplayedHiScore


gameCompletionText   .TEXT "GAME COMPLETION CHART FOR ZARD, THE HERO"

;---------------------------------------------------------
; UpdateDisplayedHiScore   
;---------------------------------------------------------
UpdateDisplayedHiScore   
        LDY #$07
        LDX #$00
bCD19   LDA (tempLoPtr1),Y
        AND #$3F
        STA SCREEN_RAM + LINE19_COL26,X
        INY
        INX
        CPX #$04
        BNE bCD19
        LDY #$06
bCD28   LDA (tempLoPtr1),Y
        STA SCREEN_RAM + LINE5_COL31,Y
        LDA #PURPLE
        STA COLOR_RAM + LINE5_COL31,Y
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
        INC hiScoreScreenUpdateRate
        RTS

hiScoreScreenUpdateRate   .BYTE $01
;-------------------------------------------------------
; HiScoreScreenInterruptHandler
; Paints the color effects on the hi-score screen
;-------------------------------------------------------
HiScoreScreenInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE bCD59
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

        ; Acknowledge the interrupt, so the CPU knows that
        ; we have handled it.
bCD59   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)

        LDA #$F0
        STA $D012    ;Raster Position

        LDA hiScoreScreenUpdateRate
        BNE bCD6E

        JMP ReEnterInterrupt

bCD6E   LDX #$00
        LDY currHiScoreColorSeq1
bCD73   LDA hiScoreColorSequence,Y
        STA COLOR_RAM + LINE4_COL0,X
        STA COLOR_RAM + LINE6_COL0,X
        STA COLOR_RAM + LINE8_COL0,X
        STA COLOR_RAM + LINE10_COL0,X
        STA COLOR_RAM + LINE12_COL0,X
        INX
        INY
        CPY #$28
        BNE bCD8D
        LDY #$00
bCD8D   CPX #$28
        BNE bCD73
        LDY currHiScoreColorSeq2
        LDX #$00
bCD96   LDA hiScoreColorSequence2,Y
        STA COLOR_RAM + LINE5_COL0,X
        STA COLOR_RAM + LINE7_COL0,X
        STA COLOR_RAM + LINE9_COL0,X
        STA COLOR_RAM + LINE11_COL0,X
        STA COLOR_RAM + LINE13_COL0,X
        INX
        INY
        CPY #$28
        BNE bCDB0
        LDY #$00
bCDB0   CPX #$28
        BNE bCD96
        INC currHiScoreColorSeq1
        DEC currHiScoreColorSeq2
        BPL bCDC1
        LDA #$27
        STA currHiScoreColorSeq2
bCDC1   LDA currHiScoreColorSeq1
        CMP #$28
        BNE bCDCD
        LDA #$00
        STA currHiScoreColorSeq1
bCDCD   JMP ReEnterInterrupt

currHiScoreColorSeq1    .BYTE $1C
currHiScoreColorSeq2    .BYTE $0C
hiScoreColorSequence    .BYTE GRAY1,GRAY1,GRAY1,GRAY1,GRAY2,GRAY2,GRAY2,GRAY2
                        .BYTE GRAY3,GRAY3,GRAY3,GRAY3,WHITE,WHITE,WHITE,WHITE
hiScoreColorSequence2   .BYTE RED,RED,ORANGE,ORANGE,ORANGE,YELLOW,YELLOW,YELLOW
                        .BYTE GREEN,GREEN,GREEN,LTBLUE,LTBLUE,LTBLUE,YELLOW,YELLOW

txtHiScorLine1          .TEXT "YAK'S GREAT GILBIES OF OUR TIME..... % %"
txtHiScorLine2          .TEXT "LEFT AND RIGHT TO SELECT, FIRE TO ENTER."
txtHiScorLine3          .TEXT "UP AND DOWN, SPACE FOR RECORD, FIRE QUIT"
txtHiScorLine4          .TEXT "THE SCORE FOR THE LAST BLAST WAS 0000000"
hiScoreInputRateControl .BYTE $00
hiScoreInputWait1       .BYTE $00
hiScoreInputWait2       .BYTE $00
;-------------------------------------------------------
; HiScoreCheckInput
;-------------------------------------------------------
HiScoreCheckInput
        DEC hiScoreInputRateControl
        BEQ bCEAC

HiScoreInputLoop
        LDA $DC00    ;CIA1: Data Port Register A
        AND #$0F
        CMP #$0F
        BEQ bCEA8
        LDA #$04
        STA hiScoreInputWait2
bCEA8   LDA $DC00    ;CIA1: Data Port Register A
        RTS

bCEAC   DEC hiScoreInputWait1
        BNE HiScoreInputLoop
        DEC hiScoreInputWait2
        BNE HiScoreInputLoop

        JMP ExitHiScoreScreen

;-------------------------------------------------------
; HiScoreStopSounds
;-------------------------------------------------------
HiScoreStopSounds
        STA $D020    ;Border Color
        LDA #$80
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA #$04
        STA hiScoreInputWait2
        RTS


pE800   SEI
        LDA #>MainControlLoop
        STA $0319    ;NMI
        LDA #<MainControlLoop
        STA $0318    ;NMI
        LDA #$10
        STA $DD04    ;CIA2: Timer A: Low-Byte
        LDA #$00
        STA $DD05    ;CIA2: Timer A: High-Byte
        LDA #$7F
        STA $DD0D    ;CIA2: CIA Interrupt Control Register
        LDA #$81
        STA $DD0D    ;CIA2: CIA Interrupt Control Register
        LDA #$19
        STA $DD0E    ;CIA2: CIA Control Register A
        CLI
        JMP $0835

; vim: tabstop=2 shiftwidth=2 expandtab smartindent

