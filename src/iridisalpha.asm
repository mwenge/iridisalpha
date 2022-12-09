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
mutatedCharToDraw                       = $26
structureRoutineLoPtr                   = $29
structureRoutineHiPtr                   = $2A
soundTmpLoPtr                           = $30
soundTmpHiPtr                           = $31
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
randomStructureRoutineAddress           = $0029
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

BLACK                                = $00
WHITE                                = $01
RED                                  = $02
CYAN                                 = $03
PURPLE                               = $04
GREEN                                = $05
BLUE                                 = $06
YELLOW                               = $07
ORANGE                               = $08
BROWN                                = $09
LTRED                                = $0A
GRAY1                                = $0B
GRAY2                                = $0C
LTGREEN                              = $0D
LTBLUE                               = $0E
GRAY3                                = $0F

; Some common sprite names
.include "graphics/sprite_names.asm"

*=$0801
;------------------------------------------------------------------
; SYS 16384 ($4000)
; This launches the program from address $4000, i.e. MainControlLoop.
;------------------------------------------------------------------
; $9E = SYS
; $31,$36,$33,$38,$34,$00 = 16384 ($4000 in hex)
.BYTE $0C,$08,$0A,$00,$9E,$31,$36,$33,$38,$34,$00

;------------------------------------------------------------------
; LaunchCurrentProgram
;------------------------------------------------------------------
*=$0810
LaunchCurrentProgram
        LDA #$00
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA f7PressedOrTimedOutToAttractMode
        STA unusedVariable2
        LDA mifDNAPauseModeActive
        BEQ b082F
        JMP LaunchDNA

b082F   LDX #$F8
        JSR SetUpMainSound
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        JSR InitializeSpritesAndInterruptsForTitleScreen
        JMP EnterTitleScreenLoop

                                 .BYTE $00,$06,$02,$04,$05,$03,$07,$01
                                 .BYTE $01,$07,$03,$05,$04,$02,$06
titleScreenStarfieldColorsArray  .BYTE $00
titleScreenGilbiesColorArray     .BYTE $02,$08,$07,$05,$0E,$04,$06,$0B
                                 .BYTE $0B,$06,$04,$0E,$05,$07,$08,$02
f7PressedOrTimedOutToAttractMode .BYTE $02

;------------------------------------------------------------------
; InitializeSpritesAndInterruptsForTitleScreen
;------------------------------------------------------------------
InitializeSpritesAndInterruptsForTitleScreen
        LDA #$00
        SEI
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA difficultySelected
        JSR ClearEntireScreen

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
        STA Sprite7PtrStarField
        LDA #$80
        STA $D01B    ;Sprite to Background Display Priority
        LDA #<TitleScreenInterruptHandler
        STA $0314    ;IRQ
        LDA #>TitleScreenInterruptHandler
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

;------------------------------------------------------------------
; EnterTitleScreenLoop
;------------------------------------------------------------------
EnterTitleScreenLoop
        LDA #$0B
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

;------------------------------------------------------------------
; TitleScreenInterruptHandler
;------------------------------------------------------------------
TitleScreenInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE TitleScreenAnimation

;------------------------------------------------------------------
; ReturnFromTitleScreenInterruptHandler
;------------------------------------------------------------------
ReturnFromTitleScreenInterruptHandler
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;------------------------------------------------------------------
; ClearEntireScreen
;------------------------------------------------------------------
ClearEntireScreen
        LDX #$00
        LDA #$20
b08FF   STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02F8,X
        DEX
        BNE b08FF
        RTS

;------------------------------------------------------------------
; TitleScreenAnimation
;------------------------------------------------------------------
TitleScreenAnimation
        LDY titleScreenStarFieldAnimationCounter
        CPY #$0C
        BNE b091E

        JSR TitleScreenPaintSprites
        LDY #$10
        STY titleScreenStarFieldAnimationCounter

b091E   LDA titleScreenStarFieldYPosArrayPtr,Y
        BNE b0947

        JSR TitleScreenMutateStarfieldAnimationData
        LDA #$00
        STA titleScreenStarFieldAnimationCounter
        LDA #$10
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR UpdateGilbysInTitleAnimation
        JSR CheckJoystickInputsInTitleScreenAnimation
        JSR TitleScreenUpdateSpritePositions
        JSR PlayTitleScreenMusic
        JMP $EA31

        ; Animate the star field in the title screen
b0947   STA $D00F    ;Sprite 7 Y Pos
        LDA titleScreenStarFieldXPosArray,Y
        STA $D00E    ;Sprite 7 X Pos
        LDA titleScreenStarFielMSBXPosArray,Y
        AND #$01
        STA spriteMSBXPosOffset
        BEQ b095D

        LDA #$80
        STA spriteMSBXPosOffset
b095D   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$7F
        ORA spriteMSBXPosOffset
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA titleScreenStarFieldYPosArray,Y
        SEC
        SBC #$01
        STA $D012    ;Raster Position

        LDA titleScreenStarFieldColorsArrayLookUp,Y
        TAX
        LDA titleScreenStarfieldColorsArray,X
        STA $D02E    ;Sprite 7 Color
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        INC titleScreenStarFieldAnimationCounter

        JMP ReturnFromTitleScreenInterruptHandler

; Data for the title screen animation sequence
titleScreenStarFieldYPosArrayPtr       .BYTE $48
titleScreenStarFieldYPosArray          .BYTE $4E,$54,$5A
                                       .BYTE $60,$66,$6C,$72,$78,$7E,$84,$8A
                                       .BYTE $90,$96,$9C,$A2,$A8,$AE,$B4,$BA
                                       .BYTE $C0,$C6,$CC,$D2,$D8,$DE,$E4,$EA
                                       .BYTE $F0,$F6
titleScreenStarFieldXPosArrayPtr       .BYTE $00
titleScreenStarFieldXPosArray          .BYTE $3A,$1A,$C4,$1B,$94,$7B,$96,$5D
                                       .BYTE $4F,$B5,$18,$C7,$E1,$EB,$4A,$8F
                                       .BYTE $DA,$83,$6A,$B0,$FC,$68,$04,$10
                                       .BYTE $06,$A7,$B8,$19,$BB
titleScreenStarfieldMSBXPosArrayPtr    .BYTE $E4
titleScreenStarFielMSBXPosArray        .BYTE $02,$02,$00,$03,$05,$02,$02,$01
                                       .BYTE $01,$01,$03,$01,$00,$01,$03,$01
                                       .BYTE $01,$04,$02,$01,$00,$01,$02,$01
                                       .BYTE $02,$01,$00,$01,$02,$02,$01
titleScreenStarFieldAnimationCounter   .BYTE $00
titleScreenStarFieldColorsArrayLookUp  .BYTE $03,$06,$07,$02,$01,$05,$03,$08
                                       .BYTE $04,$03,$02,$08,$06,$04,$02,$04
                                       .BYTE $06,$01,$07,$07,$05,$03,$02,$05
                                       .BYTE $07,$03,$06,$08,$05,$03,$06,$08
                                       .BYTE $07,$06,$03,$05,$06,$08,$06,$04
titleScreenStarfieldAnimationSeedArray .BYTE $06,$01,$03,$02,$01,$01,$01,$01
                                       .BYTE $07,$02,$03,$02,$07,$02,$03,$02
                                       .BYTE $03,$02,$01,$03,$04,$01,$02,$01
                                       .BYTE $02,$03,$02,$01,$06,$01,$01,$01
                                       .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                                       .BYTE $01,$01
gilbyColorsArray                       .BYTE YELLOW,GREEN,LTBLUE,BLACK,RED,ORANGE
starFieldOffset                        .BYTE $04,$01,$0F,$0C,$0B

;------------------------------------------------------------------
; TitleScreenMutateStarfieldAnimationData
;------------------------------------------------------------------
TitleScreenMutateStarfieldAnimationData
        LDX #$1E
        LDA #$00
        STA starFieldAnimationRate
b0A50   DEC titleScreenStarfieldAnimationSeedArray,X
        BNE b0A6D
        LDA titleScreenStarFieldAnimationCounter,X
        STA titleScreenStarfieldAnimationSeedArray,X
        LDA titleScreenStarFieldXPosArrayPtr,X
        CLC
        ADC starFieldOffset
        STA titleScreenStarFieldXPosArrayPtr,X
        LDA titleScreenStarfieldMSBXPosArrayPtr,X
        ADC #$00
        STA titleScreenStarfieldMSBXPosArrayPtr,X
b0A6D   DEX
        BNE b0A50
        RTS

;------------------------------------------------------------------
; DrawStripesBehindTitle
;------------------------------------------------------------------
DrawStripesBehindTitle
        LDX #$28
        LDA #$00
        STA shouldUpdateTitleScreenColors
b0A78   LDA #RED
        STA COLOR_RAM + $0077,X
        LDA #ORANGE
        STA COLOR_RAM + $009F,X
        LDA #YELLOW
        STA COLOR_RAM + $00C7,X
        LDA #GREEN
        STA COLOR_RAM + $00EF,X
        LDA #LTBLUE
        STA COLOR_RAM + $0117,X
        LDA #PURPLE
        STA COLOR_RAM + $013F,X
        LDA #BLUE
        STA COLOR_RAM + $0167,X
        LDA #$00 ; Stripe character
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
b0AB7   LDA titleScreenStarfieldColorsArray,X
        STA gilbyColorsArray,X
        DEX
        BNE b0AB7
        LDA #$01
        STA shouldUpdateTitleScreenColors
        RTS

;------------------------------------------------------------------
; UpdateGilbysInTitleAnimation
;------------------------------------------------------------------
UpdateGilbysInTitleAnimation
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$80
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        LDX #$06
b0AD0   LDA titleScreenBottomRightCharArray,X
        STA SCREEN_RAM + $03F7,X
        TXA
        ASL
        TAY

        ; Update the Y Position of the sprite
        LDA titleAnimationSpriteYPosSequence - $01,X
        STA $CFFE,Y

        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA titleScreenGilbiesMSBXPosAnimationSequence,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        ; Update the X position of hte sprite
        LDA #$40
        STA $CFFF,Y
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
        STA Sprite6Ptr
        RTS

titleAnimationSpriteYPosSequence           .BYTE $20,$50,$80,$B0,$E0
titleScreenGilbiesMSBXPosAnimationSequence .BYTE $10,$00,$00,$00,$00,$00
titleScreenBottomRightCharArray            .BYTE $20,$F1,$F2,$F1,$F3,$F1,$F4
shouldUpdateTitleScreenColors              .BYTE $01
;------------------------------------------------------------------
; CheckJoystickInputsInTitleScreenAnimation
;------------------------------------------------------------------
CheckJoystickInputsInTitleScreenAnimation
        LDA shouldUpdateTitleScreenColors
        BNE b0B34
b0B32   RTS

gilbyColorsTitleCounter   .BYTE $04

b0B34   DEC gilbyColorsTitleCounter
        BNE b0B32
        LDA #$04
        STA gilbyColorsTitleCounter
        LDX #$00
        LDA gilbyColorsArray
        PHA
b0B44   LDA gilbyColorsArray + $01,X
        STA $D027,X  ;Sprite 0 Color
        STA gilbyColorsArray,X
        INX
        CPX #$06
        BNE b0B44
        PLA
        STA gilbyColorsArray + $05
        STA $D02C    ;Sprite 5 Color
        RTS

;------------------------------------------------------------------
; TitleScreenPaintSprites
;------------------------------------------------------------------
TitleScreenPaintSprites
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
b0B73   TXA
        ASL
        TAY
        LDA titleScreenGilbiesXPosArray,X
        ASL
        STA $D000,Y  ;Sprite 0 X Pos
        BCC b0B8B
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA titleScreenGilbiesMSBXPosArray,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JMP UpdateYPosJumpingGilbies

b0B8B   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND titleScreenGilbiesMSBXPosOffset,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate

UpdateYPosJumpingGilbies
        LDA titleScreenGilbiesYPosARray,X
        STA $D001,Y  ;Sprite 0 Y Pos
        LDA currentTitleScreenGilbySpriteValue
        STA Sprite0Ptr,X
        LDA titleScreenGilbiesColorArray,X
        STA $D027,X  ;Sprite 0 Color
        INX
        CPX #$07
        BNE b0B73
        RTS

titleScreenGilbiesYPosARray       .BYTE $B2,$B6,$BB,$C1,$D0,$C8,$C1
titleScreenGilbiesXPosArray       .BYTE $54,$58,$5C,$60,$64,$68,$6C
titleScreenGilbiesYPosOffsetArray .BYTE $FC,$FB,$FA,$F9,$08,$07,$06
;------------------------------------------------------------------
; TitleScreenUpdateSpritePositions
;------------------------------------------------------------------
TitleScreenUpdateSpritePositions
        LDX #$00
b0BC3   LDA titleScreenGilbiesYPosARray,X
        SEC
        SBC titleScreenGilbiesYPosOffsetArray,X
        STA titleScreenGilbiesYPosARray,X
        DEC titleScreenGilbiesYPosOffsetArray,X
        LDA titleScreenGilbiesYPosOffsetArray,X
        CMP #$F8
        BNE b0BE1
        LDA #$08
        STA titleScreenGilbiesYPosOffsetArray,X
        LDA #$D0
        STA titleScreenGilbiesYPosARray,X
b0BE1   INC titleScreenGilbiesXPosArray,X
        LDA titleScreenGilbiesXPosArray,X
        CMP #$C0
        BNE b0BF0
        LDA #$08
        STA titleScreenGilbiesXPosArray,X
b0BF0   INX
        CPX #$07
        BNE b0BC3

        DEC titleScreenSpriteCycleCounter
        BNE b0C0E

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
        CMP #$C8
        BNE b0C0E
        LDA #$C1
        STA currentTitleScreenGilbySpriteValue

b0C0E   RTS

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
;------------------------------------------------------------------
; DrawTitleScreenText
;------------------------------------------------------------------
DrawTitleScreenText
        LDX #$28
b0CE8   LDA titleScreenTextLine1 - $01,X
        AND #$3F
        STA SCREEN_RAM + $01DF,X
        LDA titleScreenTextLine2 - $01,X
        AND #$3F
        STA SCREEN_RAM + $022F,X
        LDA titleScreenTextLine3 - $01,X
        AND #$3F
        STA SCREEN_RAM + $027F,X
        LDA titleScreenTextLine4 - $01,X
        AND #$3F
        STA SCREEN_RAM + $02CF,X
        LDA titleScreenTextLine5 - $01,X
        AND #$3F
        STA SCREEN_RAM + $031F,X

        LDA #GRAY2
        STA COLOR_RAM + $01DF,X
        STA COLOR_RAM + $022F,X
        STA COLOR_RAM + $027F,X
        STA COLOR_RAM + $02CF,X
        STA COLOR_RAM + $031F,X
        DEX
        BNE b0CE8
        LDX #$06
b0D26   LDA lastBlastScore,X
        STA SCREEN_RAM + $032F,X
        DEX
        BPL b0D26
        RTS

;------------------------------------------------------------------
; The DNA pause mode mini game. Accessed by pressing *
; from within the Made in France pause mode mini game.
;------------------------------------------------------------------
.include "dna.asm"


; This is the frequency table containing all the 'notes' from 
; octaves 4 to 8. It's very similar to:
;  http://codebase.c64.org/doku.php?id=base:ntsc_frequency_table
; The 16 bit value you get from feeding the lo and hi bytes into 
; the SID registers (see PlayNoteVoice1 and PlayNoteVoice2) plays
; the appropriate note. Each 16 bit value is based off a choice of
; based frequency. This is usually 440hz, but not here. 

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

; This seeds the title music. Playing around with these first four bytes
; alters the first few seconds of the title music. THe routine for the
; title music uses these 4 bytes to determine the notes to play.
; This arrays is periodically replenished from titleMusicSeedArray by
; UpdateMusicCountersAndTitleMusicSeedArray.
titleMusicNoteArray .BYTE $00,$07,$0C,$07

; These variables are used to choose a value from titleMusicNoteArray, 
; mutate it, and then use that as an index into titleMusicHiBytes/titleMusicLowBytes
; which gives PlayNoteVoice1/2/3 a note to play.
titleMusicNote3                           .BYTE $01
intervalForTitleMusicVoice2               .BYTE $01
titleMusicNote5                           .BYTE $25
titleMusicNote6                           .BYTE $85
titleMusicNote7                           .BYTE $00
titleMusicOffsetToMusicNoteArrayForVoice2 .BYTE $01
titleMusicNote9                           .BYTE $02
titleMusicNoteA                           .BYTE $02
titleMusicNoteB                           .BYTE $0E
titleMusicNoteC                           .BYTE $07
titleMusicNoteD                           .BYTE $0E
;------------------------------------------------------------------
; PlayTitleScreenMusic
;------------------------------------------------------------------
PlayTitleScreenMusic
        DEC musicCounterOne
        BEQ b1504
        RTS

b1504   LDA musicCounterTwo
        STA musicCounterOne
        DEC titleMusicNote6
        BNE b152C
        LDA #$C0
        STA titleMusicNote6
        INC f7PressedOrTimedOutToAttractMode
        LDX titleMusicNoteA
        LDA titleMusicNoteArray,X
        STA titleMusicNoteC
        INX
        TXA
        AND #$03
        STA titleMusicNoteA
        BNE b152C
        JSR UpdateMusicCountersAndTitleMusicSeedArray
b152C   DEC titleMusicNote5
        BNE b154E
        LDA #$30
        STA titleMusicNote5
        LDX titleMusicNote9
        LDA titleMusicNoteArray,X
        CLC
        ADC titleMusicNoteC
        TAY
        STY titleMusicNoteB
        JSR PlayNoteVoice1
        INX
        TXA
        AND #$03
        STA titleMusicNote9
b154E   DEC intervalForTitleMusicVoice2
        BNE b1570
        LDA #$0C
        STA intervalForTitleMusicVoice2
        LDX titleMusicOffsetToMusicNoteArrayForVoice2
        LDA titleMusicNoteArray,X
        CLC
        ADC titleMusicNoteB
        STA titleMusicNoteD
        TAY
        JSR PlayNoteVoice2
        INX
        TXA
        AND #$03
        STA titleMusicOffsetToMusicNoteArrayForVoice2
b1570   DEC titleMusicNote3
        BNE b158F
        LDA #$03
        STA titleMusicNote3
        LDX titleMusicNote7
        LDA titleMusicNoteArray,X
        CLC
        ADC titleMusicNoteD
        TAY
        JSR PlayNoteVoice3
        INX
        TXA
        AND #$03
        STA titleMusicNote7
b158F   RTS

;------------------------------------------------------------------
; PlayNoteVoice1
;------------------------------------------------------------------
PlayNoteVoice1
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA titleMusicLowBytes,Y
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        RTS

;------------------------------------------------------------------
; PlayNoteVoice2
;------------------------------------------------------------------
PlayNoteVoice2
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        LDA titleMusicLowBytes,Y
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        RTS

;------------------------------------------------------------------
; PlayNoteVoice3
;------------------------------------------------------------------
PlayNoteVoice3
        LDA #$21
        STA $D412    ;Voice 3: Control Register
        LDA titleMusicLowBytes,Y
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        RTS

;------------------------------------------------------------------
; SetUpMainSound
;------------------------------------------------------------------
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
titleMusicSeedArray .BYTE $00,$03,$06,$08,$00,$0C,$04,$08
                    .BYTE $00,$07,$00,$05,$05,$00,$00,$05
                    .BYTE $00,$06,$09,$05,$02,$04,$03,$04
                    .BYTE $03,$07,$03,$00,$04,$08,$0C,$09
                    .BYTE $07,$08,$04,$07,$00,$04,$07,$0E
                    .BYTE $00,$00,$00,$07,$07,$04,$00,$0C
                    .BYTE $04,$07,$00,$0C,$07,$08,$0A,$08
                    .BYTE $0C,$00,$0C,$03,$0C,$03,$07,$00
;------------------------------------------------------------------
; UpdateMusicCountersAndTitleMusicSeedArray
;------------------------------------------------------------------
UpdateMusicCountersAndTitleMusicSeedArray
        JSR PutRandomByteInAccumulator
        AND #$0F
        BEQ b1630
        TAX
        LDA #$00
b162A   CLC
        ADC #$04
        DEX
        BNE b162A

        ; Fill titleMusicNoteArray with the next four bytes from
        ; titleMusicSeedArray.
b1630   TAY
        LDX #$00
b1633   LDA titleMusicSeedArray,Y
        STA titleMusicNoteArray,X
        INY
        INX
        CPX #$04
        BNE b1633

        JSR PutRandomByteInAccumulator
        AND #$03
        CLC
        ADC #$01
        STA musicCounterOne
        STA musicCounterTwo
        RTS

musicCounterOne               .BYTE $01
musicCounterTwo               .BYTE $01
titleScreenSpriteCycleCounter .BYTE $04
;------------------------------------------------------------------
; TitleScreenCheckInput
;------------------------------------------------------------------
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
        STA SCREEN_RAM + $0344,X
        DEX
        BPL b166D
        JMP LoopUntilKeyReleased

        ;Update difficulty hard.
b167B   LDX #$03
b167D   LDA txtHard,X
        AND #$3F
        STA SCREEN_RAM + $0344,X
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
;------------------------------------------------------------------
; PutRandomByteInAccumulator
;------------------------------------------------------------------
PutRandomByteInAccumulator
srcOfRandomBytes   =*+$01
        LDA sourceOfRandomBytes
        INC srcOfRandomBytes
        RTS


*=$2000
.include "graphics/charset.asm"
.include "graphics/sprites.asm"

difficultySelected   =*+$01
;------------------------------------------------------------------
; MainControlLoop
; Execution starts here
;------------------------------------------------------------------
MainControlLoop
        LDA #$00
        SEI
p4003   LDA #<MainControlLoopInterruptHandler
        STA $0318    ;NMI
        LDA #>MainControlLoopInterruptHandler
        STA $0319    ;NMI
        LDA #$80
        STA $0291
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
        STA amountToDecreaseEnergyByTopPlanet
        STA amountToDecreaseEnergyByBottomPlanet
        STA gilbyHasJustDied
        STA bonusPhaseEarned
        STA bonusPhaseCounter
        STA valueIsAlwaysZero

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
        JSR InitializeActiveShipArray
        JMP PrepareToLaunchIridisAlpha

;------------------------------------------------------------------
; ClearPlanetTextureCharsets
;------------------------------------------------------------------
ClearPlanetTextureCharsets
        LDA #$00
        TAX
b4084   STA planetTextureCharset1,X
        STA planetTextureCharset2,X
        STA planetTextureCharset3,X
        STA planetTextureCharset4,X
        DEX
        BNE b4084
        RTS

;------------------------------------------------------------------
; PrepareToLaunchIridisAlpha
;------------------------------------------------------------------
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
        LDA #$08
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA #$09
        STA $D023    ;Background Color 2, Multi-Color Register 1
        JSR PrepareScreen
        JMP InitializeSprites


energyLevelToGilbyColorMap .BYTE $00,$06,$02,$04,$05,$03,$07,$01
pauseModeSelected          .BYTE $00
reasonGilbyDied            .BYTE $03
gilbyHasJustDied           .BYTE $00

;------------------------------------------------------------------
; 'Made In France' - a pause mode mini game.
; Accessed by pressing F1 during play.
;------------------------------------------------------------------
.include "madeinfrance.asm"

;------------------------------------------------------------------
; The data for drawing the planets.
;------------------------------------------------------------------
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

nullPtr = $0000
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
anotherUpdateRateForAttackShips      .BYTE $02,$02,$00,$00,$00,$00,$FF,$FF
                                     .BYTE $00,$00

upperPlanetAttackShipYPosUpdated     .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00

upperPlanetAttackShipYPosUpdated2    .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00
shipsThatHaveBeenHitByABullet        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00
shipHasAlreadyBeenHitByGilby         .BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                     .BYTE $00,$00,$00,$00
previousAttaWaveHiPtrTempStorage     .BYTE $04
nextShipOffset                       .BYTE $00
soundEffectInProgress                .BYTE $00,$01,$00,$01,$00,$00,$01,$00
                                     .BYTE $01,$FF,$00,$02,$00,$FF,$FF,$01
                                     .BYTE $02,$80

newPlanetSound              .BYTE $00,$00,$0F,$0C,$00
                            .BYTE $00,$00,$0F,$13,$00
                            .BYTE $00,$00,$00,$0D,$00
                            .BYTE $00,$00,$00,$14,$00
                            .BYTE $00,$00,$10,$08,$00
                            .BYTE $00,$00,$10,$0F,$00
                            .BYTE $00,$00,$11,$0B,$00
                            .BYTE $00,$00,$11,$12,$02
                            .BYTE $0F,$02,$02,$0F,$00
                            .BYTE $08,$02,$02,$08,$01
                            .BYTE $00,$81,$08,$00,$00
                            .BYTE $00,$00,$81,$0B,$00
                            .BYTE $00,$00,$28,$08,$00
                            .BYTE $00,$00,$80,$12,$02
                            .BYTE $08,$02,$03,$08,$01
                            .BYTE $00,$81,$05,$00,$00
                            .BYTE $00,$00,$21,$12,$00
                            .BYTE $00,$00,$20,$0F,$02
                            .BYTE $08,$02,$03,$08,$00
                            .BYTE $0F,$02,$04,$0F,$01
                            .BYTE $00,$81,$08,$00,$00
                            .BYTE $00,$00,$80,$0B,$00
                            .BYTE $00,$00,$80,$12,$00
                            .BYTE $00,$80,<f7BCA,>f7BCA,$00
shipCollidedWithGilbySound  .BYTE $00,$00,$0F,$05,$00
                            .BYTE $00,$00,$00,$06,$00
                            .BYTE $00,$00,$40,$01,$00
                            .BYTE $00,$00,$81,$04,$02
                            .BYTE $01,$01,$0C,$01,$01
                            .BYTE $00,$81,$04,$00,$00
                            .BYTE $00,$00,$20,$01,$00
                            .BYTE $00,$00,$11,$04,$02
                            .BYTE $01,$02,$04,$01,$01
                            .BYTE $00,$81,$08,$00,$00
                            .BYTE $00,$00,$10,$04,$00
                            .BYTE $00,$80,<f7BCA,>f7BCA,$00

;------------------------------------------------------------------
; SetXToIndexOfShipThatNeedsReplacing
;
; Searches activeShipsWaveDataHiPtrArray for an entry with zeroized ptrs
; indicating that the ship has been killed and needs to be replaced.
; Stores the index of the ships that needs replacing in the X register.
;------------------------------------------------------------------
SetXToIndexOfShipThatNeedsReplacing
        LDA activeShipsWaveDataHiPtrArray,X
        BEQ b49B5
        LDA levelEntrySequenceActive
        BNE b49B2
        INX

        ; Have we tried all the top planet ships without finding one
        ; that is dead (i.e. pointer set to zeros) and needs replacing?
        CPX #$06
        BEQ b49B2
        ; Have we tried all the bottom planet ships without finding one
        ; that is dead (i.e. pointer set to zeros) and needs replacing?
        CPX #$0C
        BEQ b49B2

        ; Keep checking.
        BNE SetXToIndexOfShipThatNeedsReplacing

b49B2   LDA #$00
        RTS

b49B5   LDA #$FF

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

;------------------------------------------------------------------
; PerformMainGameProcessing
;------------------------------------------------------------------
PerformMainGameProcessing
        LDA levelEntrySequenceActive
        BNE b49F5
        LDA gilbyHasJustDied
        BEQ b49E1

        JMP ProcessGilbyExplosion
        ;Returns

b49E1   JSR PerformMainAttackWaveProcessing
        JSR UpdateAttackShipsPosition
        JSR DetectAttackShipCollisionWithGilby
        JSR DecreaseEnergyStorage
        JSR UpdateCoreEnergyValues
        DEC gameSequenceCounter
        BEQ GetNewWaveDataForAnyDeadShips
b49F5   RTS

gameSequenceCounter   .BYTE $14

;------------------------------------------------------------------
; GetNewWaveDataForAnyDeadShips
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; UpdateCurrentShipWaveDataPtrs
;------------------------------------------------------------------
UpdateCurrentShipWaveDataPtrs
        LDA activeShipsWaveDataLoPtrArray,X
        STA currentShipWaveDataLoPtr
        LDA activeShipsWaveDataHiPtrArray,X
        STA currentShipWaveDataHiPtr
        LDA #$00
        STA updatingWaveData
        STA shipHasAlreadyBeenHitByGilby,X
        STY previousAttaWaveHiPtrTempStorage
        ; Falls through

;------------------------------------------------------------------
; GetWaveDateForNewShip
; Loads the wave data for the current wave from level_data.asm and level_data2.asm.
; currentShipWaveDataLoPtr is a reference to one of the data chunks in those
; files.
;------------------------------------------------------------------
GetWaveDateForNewShip
        ; X is the index of the ship in activeShipsWaveDataLoPtrArray
        LDY #$00
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipsColorArray + $01,X

        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        STA anotherUpdateRateForAttackShips,X

        LDY #$0B
        LDA (currentShipWaveDataLoPtr),Y
        STA someKindOfRateLimitingForAttackWaves,X

        LDA #$00
        STA indexForYPosMovementForUpperPlanetAttackShips,X

        LDY #$0F
        LDA (currentShipWaveDataLoPtr),Y
        STA updateRateForAttackShips,X

        ; Load the sprite value.
        LDY #$01
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipsSpriteValueArray + $01,X

        ; Store the sprite value in the storage used to reload the game
        ; from pause mode or a restart.
        TXA
        TAY
        LDX orderForUpdatingPositionOfAttackShips,Y
        ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
        LDY #$01
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,X

        ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
        ; for the upper planet.
        LDY #$02
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpriteAnimationEnd,X

        ; Byte 4 (Index $03): The animation frame rate for the attack ship.
        LDY #$03
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipAnimationFrameRate,X
        STA upperPlanetAttackShipInitialFrameRate,X

        ; Check if the level is a multiple of 3, if it's not
        ; we'll fall through and load some alternative sprites.
        TXA
        AND #$04
        BEQ b4AB9

        INY
        ; Y is now 4
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,X

        INY
        ; Y is now 5
        LDA (currentShipWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpriteAnimationEnd,X

        TXA
        TAY
        LDA indexForActiveShipsWaveData,X
        TAY
        LDA upperPlanetAttackShipSpritesLoadedFromBackingData,X
        STA upperPlanetAttackShipsSpriteValueArray + $01,Y

        ; Load the x-pos movement for the attack ship.
b4AB9   LDY #$12
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        BEQ b4AC4
        STA xPosMovementForUpperPlanetAttackShip,X

b4AC4   INY
        ; Y is now 19 ($13). This has the Y-Pos movement for the
        ; attack ship.
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        BEQ b4AFA
        AND #$F0
        CMP #$20
        BEQ b4AD6
        ; Y is still 19 ($13).
        LDA (currentShipWaveDataLoPtr),Y
        JMP LoadYPosForAttackShip

b4AD6   TXA
        STX temporaryStorageForXRegister
        AND #$04
        BNE b4AEC
        ; Y is still 19 ($13).
        LDA (currentShipWaveDataLoPtr),Y
        AND #$0F
        TAX
        LDA yPosMovementPatternForShips2,X
        LDX temporaryStorageForXRegister
        JMP LoadYPosForAttackShip

        ; Y is still 19 ($13).
b4AEC   LDA (currentShipWaveDataLoPtr),Y
        AND #$0F
        TAX
        LDA yPosMovementPatternForShips1,X
        LDX temporaryStorageForXRegister

LoadYPosForAttackShip
        STA yPosMovementForUpperPlanetAttackShips,X

b4AFA   INY
        ; Y is now 20 ($14)
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        BEQ b4B07
        STA upperPlanetInitialXPosFrameRateForAttackShip,X
        STA upperPlanetXPosFrameRateForAttackShip,X

b4B07   INY
        ; Y is now 21 ($15)
        LDA (currentShipWaveDataLoPtr),Y
        CMP #$80
        BEQ b4B14
        STA upperPlanetInitialYPosFrameRateForAttackShips,X
        STA upperPlanetYPosFrameRateForAttackShips,X

b4B14   LDA #$01
        LDA updatingWaveData
        BEQ b4B1C
        RTS

        ; Set the initial Y Position of the new attack ships.
        ; This is random.
b4B1C   LDY previousAttaWaveHiPtrTempStorage
        LDA indexForActiveShipsWaveData,X
        TAX
        LDA attackShipsMSBXPosOffsetArray + $01,X
        STA upperPlanetAttackShipsMSBXPosArray + $01,Y
        JSR PutRandomByteInAccumulatorRegister
        AND #$7F
        CLC
        ADC #$20
        STA upperPlanetAttackShipsXPosArray + $01,Y
        TYA
        AND #$08
        BNE b4B5A
        JSR PutRandomByteInAccumulatorRegister
        AND #$3F
        CLC
        ADC #$40
        STA upperPlanetAttackShipsYPosArray + $01,Y

        STY tmpPtrLo
        ; Byte 6 ($06): Determines if the inital Y Position of the ship is random or uses a default.
        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        BNE b4B59
        ; Byte 8 ($08): Default initiation Y position for the enemy. 
        LDY #$08
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4B59
        LDA #$6C
        LDY tmpPtrLo
        STA upperPlanetAttackShipsYPosArray + $01,Y
b4B59   RTS

b4B5A   JSR PutRandomByteInAccumulatorRegister
        AND #$3F
        CLC
        ADC #$98
        STA upperPlanetAttackShipsYPosArray + $01,Y

        STY tmpPtrLo
        ; Byte 6 ($06): Determines if the inital Y Position of the ship is random or uses a default.
        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        BNE b4B7A
        ; Byte 8 ($08): Default initiation Y position for the enemy. 
        LDY #$08
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4B7A

        LDA #$90
        LDY tmpPtrLo
        STA upperPlanetAttackShipsYPosArray + $01,Y

b4B7A   RTS

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
;------------------------------------------------------------------
; PerformMainAttackWaveProcessing
;------------------------------------------------------------------
PerformMainAttackWaveProcessing
        LDY #$00
        LDA pauseModeSelected
        BEQ b4BC7
        RTS

        ; This loop updates the state of each of the 8 attack ships
        ; that are active at any one time tracked by activeShipsWaveDataLoPtrArray. It's 4 for the
        ; top planet, and 4 for the bottom planet. 
b4BC7   LDX indexForActiveShipsWaveData,Y
        LDA activeShipsWaveDataHiPtrArray,X
        ; When there is no ship (anymore) for an entry its pointer will be zeroes.
        BEQ b4BD6
        STY tempVarStorage
        JSR ProcessAttackWaveDataForActiveShip
        LDY tempVarStorage
b4BD6   INY
        CPY #$08
        BNE b4BC7

        LDA hasEnteredNewLevel
        BEQ b4BEB
        LDA #$00
        STA currentStepsBetweenTopPlanetAttackWaves
        STA currentStepsBetweenBottomPlanetAttackWaves
        STA hasEnteredNewLevel
b4BEB   RTS

;------------------------------------------------------------------
; ProcessAttackWaveDataForActiveShip
;------------------------------------------------------------------
ProcessAttackWaveDataForActiveShip
        ; X is the current value in indexForActiveShipsWaveData
        STA currentShipWaveDataHiPtr
        LDA activeShipsWaveDataLoPtrArray,X
        STA currentShipWaveDataLoPtr
        LDA hasEnteredNewLevel
        BEQ b4C03

        ; We've entered a new level.
        ; Get the wave data from the wave data store and return
        LDA #>attackWaveData
        STA currentShipWaveDataHiPtr
        LDA #<attackWaveData
        STA currentShipWaveDataLoPtr
        JMP GetWaveDataForShipForNewLevel
        ; Returns


b4C03   LDA shipsThatHaveBeenHitByABullet,X
        BNE UpdateScoresAfterHittingShipWithBullet
        JMP CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
        ; Returns

;------------------------------------------------------------------
; UpdateScoresAfterHittingShipWithBullet
;------------------------------------------------------------------
UpdateScoresAfterHittingShipWithBullet
        LDA #$00
        STA shipsThatHaveBeenHitByABullet,X

        LDA #<newPlanetSound
        STA secondarySoundEffectLoPtr
        LDA #>newPlanetSound
        STA secondarySoundEffectHiPtr
        JSR ResetSoundDataPtr2
        LDA #$1C
        STA soundEffectInProgress

        ; Did the bullet hit a ship on the top planet or bottom planet?
        TXA
        PHA
        AND #$08
        BNE BulletHitShipOnBottomPlanet

        ; Bullet hit a ship on the top planet.
        LDA levelEntrySequenceActive
        BNE b4C42
        LDA attractModeCountdown
        BNE b4C42
        INC currentTopPlanetIndex
        LDA currentTopPlanetIndex
        CMP currentTopPlanet
        BNE b4C42

        LDA #$00
        STA currentTopPlanetIndex
        ; Get the points multiplier for hitting enemies in this level
        ; from the wave data.
b4C42   LDY #$22
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
        LDA levelEntrySequenceActive
        BNE b4C76
        LDA attractModeCountdown
        BNE b4C76
        INC currentBottomPlanetIndex
        LDA currentBottomPlanetIndex
        CMP currentBottomPlanet
        BNE b4C76

        LDA #$00
        STA currentBottomPlanetIndex
        ; Get the points multiplier for hitting enemies in this level
        ; from the wave data.
b4C76   LDY #$22
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
        LDY #$22
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4CB1
        LDA attractModeCountdown
        BNE b4CB1
        TXA
        AND #$08
        BNE b4CAB
        JSR IncreaseEnergyTopOnly
        JSR UpdateTopPlanetProgressData
        JMP b4CB1

b4CAB   JSR UpdateBottomPlanetProgressData
        JSR IncreaseEnergyBottomOnly

        ; Load the explosion animation, if there is one. For most
        ; enemies this is the spinning rings defined by spinningRings.
b4CB1   LDY #$1D
        LDA (currentShipWaveDataLoPtr),Y
        BEQ CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
        DEY
        JMP UpdateWaveDataForCurrentEnemy
        ;Returns

;------------------------------------------------------------------
; CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
;------------------------------------------------------------------
CheckForCollisionsBeforeUpdatingCurrentShipsWaveData
        ; X is the current value in indexForActiveShipsWaveData
        ; We're checking if this is the first time the ship has been hit by the gilby.
        ; If so, there may be a new state for the enemy to turn into, e.g. a licker ship
        ; seed turning into a licker ship.
        LDA shipHasAlreadyBeenHitByGilby,X
        BEQ JumpToGetNewShipDataFromDataStore
        LDA #$00
        STA shipHasAlreadyBeenHitByGilby,X
        ; Check if there is another set of wave data to get for this wave when it is first hit.
        LDY #$1F
        LDA (currentShipWaveDataLoPtr),Y
        BEQ JumpToGetNewShipDataFromDataStore
        ; Byte 15 (Index $0E): Controls the rate at which new enemies are added?
        ; Is there a rate at which new enemies are added?
        LDY #$0E
        LDA (currentShipWaveDataLoPtr),Y
        BEQ CheckCollisionType
        TXA
        AND #$08 ; Is X pointing to lower planet ships?
        BNE DecrementStepsThenCheckCollisionsForBottomPlanet
        ; X is pointing to a top planet ship.
        DEC currentStepsBetweenTopPlanetAttackWaves
        JMP CheckCollisionType
        ; Returns

;------------------------------------------------------------------
; JumpToGetNewShipDataFromDataStore
;------------------------------------------------------------------
JumpToGetNewShipDataFromDataStore
        JMP GetNewShipDataFromDataStore
        ; Returns

;------------------------------------------------------------------
; DecrementStepsThenCheckCollisionsForBottomPlanet
;------------------------------------------------------------------
DecrementStepsThenCheckCollisionsForBottomPlanet
        DEC currentStepsBetweenBottomPlanetAttackWaves
        ; Falls through
;------------------------------------------------------------------
; CheckCollisionType
;------------------------------------------------------------------
CheckCollisionType
        ; Does an exploded version of the enemy allow us to warp to the
        ; other planet?
        LDY #$24
        LDA (currentShipWaveDataLoPtr),Y
        BNE MaybeTransferToOtherPlanet
        JMP UpdateEnergyLevelsAfterCollision
        ;Returns

;------------------------------------------------------------------
; MaybeTransferToOtherPlanet
;------------------------------------------------------------------
MaybeTransferToOtherPlanet
        LDA joystickInput
        AND #$10
        BEQ JumpToGetNewShipDataFromDataStore

        ; Fire not pressed while passing through explosion ring so can
        ; transfer to other planet
        LDA lowerPlanetActivated
        BNE JumpToGetNewShipDataFromDataStore
        LDA valueIsAlwaysZero
        BNE b4D0D
        JSR ResetSoundDataPtr1
        LDA #<transferToOtherPlanetSoundEffect1
        STA currentSoundEffectLoPtr
        LDA #>transferToOtherPlanetSoundEffect1
        STA currentSoundEffectHiPtr
        LDA #$08
        BNE b4D1C
b4D0D   JSR ResetSoundDataPtr1
        LDA #<transferToOtherPlanetSoundEffect2
        STA currentSoundEffectLoPtr
        LDA #>transferToOtherPlanetSoundEffect2
        STA currentSoundEffectHiPtr

        LDA #$00
b4D1C   STA valueIsAlwaysZero
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

;------------------------------------------------------------------
; UpdateEnergyLevelsAfterCollision
;------------------------------------------------------------------
UpdateEnergyLevelsAfterCollision
        ; Check if the enemy saps energy from the gilby?
        LDY #$23
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4D7F

        LDA #<shipCollidedWithGilbySound
        STA currentSoundEffectLoPtr
        LDA #>shipCollidedWithGilbySound
        STA currentSoundEffectHiPtr
        JSR ResetSoundDataPtr1
        LDA #$0E
        STA gilbyExploding
        LDA #$02
        STA starFieldInitialStateArray - $01
        LDA currentGilbySpeed
        EOR #$FF
        CLC
        ADC #$01
        STA currentGilbySpeed
        LDA valueIsAlwaysZero
        BEQ b4D72
        LDA amountToDecreaseEnergyByBottomPlanet
        BNE b4D7F
        ; Y is still $23.
        LDA (currentShipWaveDataLoPtr),Y
        JSR AugmentAmountToDecreaseEnergyByBountiesEarned
        STA amountToDecreaseEnergyByBottomPlanet
        BNE b4D7F
b4D72   LDA amountToDecreaseEnergyByTopPlanet
        BNE b4D7F
        ; Y is still $23.
        LDA (currentShipWaveDataLoPtr),Y
        JSR AugmentAmountToDecreaseEnergyByBountiesEarned
        STA amountToDecreaseEnergyByTopPlanet
b4D7F   LDY #$1E
        JMP UpdateWaveDataForCurrentEnemy
        ; Returns

;------------------------------------------------------------------
; GetNewShipDataFromDataStore
;------------------------------------------------------------------
GetNewShipDataFromDataStore
        LDA upperPlanetAttackShipYPosUpdated,X
        BEQ b4D98
        LDA #$00
        STA upperPlanetAttackShipYPosUpdated,X
        ; The 2nd stage of wave data for this enemy.
        LDY #$19
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4D98
        DEY
        JMP UpdateWaveDataForCurrentEnemy

b4D98   LDA upperPlanetAttackShipYPosUpdated2,X
        BEQ b4DAC
        LDA #$00
        STA upperPlanetAttackShipYPosUpdated2,X
        ; The 3rd stage of wave data for this enemy.
        LDY #$1B
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4DAC
        DEY
        JMP UpdateWaveDataForCurrentEnemy

b4DAC   LDA joystickInput
        AND #$10
        BNE b4DBD
        ; Check if we should load extra stage data for this enemy.
        ; FIXME: It it appears this is never set. If it was set it would
        ; incorrectly expect their to be a hi/lo ptr in $20 and $21, when
        ; there isn't.
        LDY #$21
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4DBD
        DEY
        JMP UpdateWaveDataForCurrentEnemy
        ; Returns

b4DBD   LDA updateRateForAttackShips,X
        BEQ UpdateAttackShipDataForNewShip
        DEC updateRateForAttackShips,X
        BNE UpdateAttackShipDataForNewShip
        ; Controls the rate at which new enemies are added.
        ; This is only set when the current ship data is defaultExplosion
        LDY #$0E
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4DDB
        TXA
        AND #$08
        BNE b4DD8
        DEC currentStepsBetweenTopPlanetAttackWaves
        JMP b4DDB

b4DD8   DEC currentStepsBetweenBottomPlanetAttackWaves
b4DDB   LDY #$10

;------------------------------------------------------------------
; UpdateWaveDataForCurrentEnemy
;------------------------------------------------------------------
UpdateWaveDataForCurrentEnemy
        ; Y has been set to $10 above, so we're pulling in the pointer
        ; to the second tranche of wave data for this level. 
        ; Or Y has been set by the caller.
        LDA (currentShipWaveDataLoPtr),Y
        PHA
        INY
        LDA (currentShipWaveDataLoPtr),Y
        BEQ ClearDeadShipFromLevelData
        STA activeShipsWaveDataHiPtrArray,X
        STA currentShipWaveDataHiPtr
        PLA
        STA currentShipWaveDataLoPtr
        STA activeShipsWaveDataLoPtrArray,X
        ; Falls through

;------------------------------------------------------------------
; GetWaveDataForShipForNewLevel
;------------------------------------------------------------------
GetWaveDataForShipForNewLevel
        LDA #$FF
        STA updatingWaveData
        JSR GetWaveDateForNewShip
        LDA #$00
        STA updatingWaveData
        RTS

;------------------------------------------------------------------
; ClearDeadShipFromLevelData
;------------------------------------------------------------------
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

positionRelativeToGilby               .BYTE $00
updatingWaveData    .BYTE $00
currentTopPlanet    .BYTE $01
currentBottomPlanet .BYTE $01

;------------------------------------------------------------------
; UpdateAttackShipDataForNewShip
;------------------------------------------------------------------
UpdateAttackShipDataForNewShip
        ; Check if the wave supports some kind of animation effect
        ; stored as a hi/lo ptr at position $09 and $0A in its data.
        ; FIXME: Is this actually used? Can't find the appropriate
        ; bytes set in any of the level data.
        LDY #$0A
        LDA (currentShipWaveDataLoPtr),Y
        BEQ MaybeQuicklyGravitatesToGilby
        DEC someKindOfRateLimitingForAttackWaves,X
        BNE MaybeQuicklyGravitatesToGilby
        STA tempHiPtr3
        DEY
        ; Y is now $09.
        LDA (currentShipWaveDataLoPtr),Y
        STA tempLoPtr3
        ; $0B in the wave data defines some kind of rate limiting.
        LDY #$0B
        LDA (currentShipWaveDataLoPtr),Y
        STA someKindOfRateLimitingForAttackWaves,X
        LDY indexForYPosMovementForUpperPlanetAttackShips,X
        LDA orderForUpdatingPositionOfAttackShips,X
        TAX
        LDA (tempLoPtr3),Y
        CMP #$80
        BEQ b4E6A
        LDA (tempLoPtr3),Y
        STA xPosMovementForUpperPlanetAttackShip,X
        INY
        LDA (tempLoPtr3),Y
        STA yPosMovementForUpperPlanetAttackShips,X
        INY
        LDA (tempLoPtr3),Y
        STA upperPlanetInitialXPosFrameRateForAttackShip,X
        STA upperPlanetXPosFrameRateForAttackShip,X
        INY
        LDA (tempLoPtr3),Y
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
b4E6A   LDY #$0C
        LDA indexForActiveShipsWaveData,X
        TAX
        JMP UpdateWaveDataForCurrentEnemy

MaybeQuicklyGravitatesToGilby
        ; Does the enemy gravitate quickly towards the gilby when it is shot?
        LDY #$17
        LDA (currentShipWaveDataLoPtr),Y
        BEQ MaybeStickyAttackShipBehaviour

        ; After being destroyed the enemy gravitates quickly towards the gilby.
        ; There are two types of behaviour $01 or $23.
        CLC
        ADC gilbyVerticalPosition
        STA positionRelativeToGilby
        LDA orderForUpdatingPositionOfAttackShips,X
        TAX
        LDA upperPlanetYPosFrameRateForAttackShips,X
        CMP #$01
        BNE b4EC3
        ; Y is still $17.
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
        CMP positionRelativeToGilby
        BEQ b4EC3
        BMI b4EC0
        DEC yPosMovementForUpperPlanetAttackShips,X
        DEC yPosMovementForUpperPlanetAttackShips,X
b4EC0   INC yPosMovementForUpperPlanetAttackShips,X
b4EC3   LDA indexForActiveShipsWaveData,X
        TAX

MaybeStickyAttackShipBehaviour   
        ; Does the enemy have the stickiness behaviour?
        LDY #$16
        LDA (currentShipWaveDataLoPtr),Y
        BEQ NormalAttackShipBehaviour

        ; The enemy is sticky, so make it stick to the gilby.
        CLC
        ADC #$58
        STA positionRelativeToGilby
        LDA orderForUpdatingPositionOfAttackShips,X
        TAX
        LDA upperPlanetXPosFrameRateForAttackShip,X
        CMP #$01
        BNE b4F01
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
        BMI b4EFE
        DEC xPosMovementForUpperPlanetAttackShip,X
        DEC xPosMovementForUpperPlanetAttackShip,X
b4EFE   INC xPosMovementForUpperPlanetAttackShip,X
b4F01   LDA indexForActiveShipsWaveData,X
        TAX

NormalAttackShipBehaviour   
        ; In all the wave data this bit is never set, so the behaviour
        ; here isn't used.
        ; FIXME: understand the intended behaviour here.
        LDY #$06
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b4F55

        DEC anotherUpdateRateForAttackShips,X
        BNE b4F55
        LDA (currentShipWaveDataLoPtr),Y
        STA anotherUpdateRateForAttackShips,X
        TXA
        PHA
        LDY indexIntoUpperPlanetAttackShipXPosAndYPosArray,X
        LDA upperPlanetAttackShipsXPosArray + $01,Y
        PHA
        LDA upperPlanetAttackShipsMSBXPosArray + $01,Y
        PHA
        LDA upperPlanetAttackShipsYPosArray + $01,Y
        PHA
        TXA
        AND #$08
        BNE b4F4C
        LDX #$02
b4F2D   JSR SetXToIndexOfShipThatNeedsReplacing
        BEQ b4F50
        LDY indexIntoUpperPlanetAttackShipXPosAndYPosArray,X
        PLA
        STA upperPlanetAttackShipsYPosArray + $01,Y
        PLA
        BEQ b4F3F
        LDA attackShipsMSBXPosOffsetArray + $01,X
b4F3F   STA upperPlanetAttackShipsMSBXPosArray + $01,Y
        PLA
        STA upperPlanetAttackShipsXPosArray + $01,Y
        PLA
        LDY #$07
        JMP UpdateWaveDataForCurrentEnemy

b4F4C   LDX #$08
        BNE b4F2D
b4F50   PLA
        PLA
        PLA
        PLA
        TAX
b4F55   RTS

b4F56   RTS

valueIsAlwaysZero     .BYTE $00
currentAttackShipXPos .BYTE $00
currentAttackShipYPos .BYTE $00,$00
;------------------------------------------------------------------
; UpdateAttackShipsPosition
;------------------------------------------------------------------
UpdateAttackShipsPosition
        LDA valueIsAlwaysZero
        TAY
        AND #$08
        BEQ b4F65
        DEY
        DEY
b4F65   LDA upperPlanetAttackShipsMSBXPosArray + $01,Y
        BMI b4F89
        LDY valueIsAlwaysZero
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
        BMI b4F56
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

;------------------------------------------------------------------
; UpdateAttackShipsMSBXPosition
;------------------------------------------------------------------
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
        ; Load the explosion animation for the enemy.
        LDY #$1D
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
        BEQ b5029
        CPX #$0E
        BEQ b5029
        JMP UpdateAttackShipsMSBXPositionLoop

b5029   RTS

;------------------------------------------------------------------
; DetectAttackShipCollisionWithGilby
;------------------------------------------------------------------
DetectAttackShipCollisionWithGilby
        LDY #$00
        LDA levelEntrySequenceActive
        BNE b5029
        LDA attractModeCountdown
        BNE b5029
        LDA valueIsAlwaysZero
        BEQ b503C
        INY
b503C   LDX valueIsAlwaysZero
        INX
        INX

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
        SBC gilbyVerticalPosition,Y
        BPL b5065
        EOR #$FF
b5065   CMP #$08
        BMI b506C
        JMP GoToNextShip

b506C   STX tempLoPtr3
        LDA indexIntoAttackWaveDataHiPtrArray,X
        TAX
        LDA #$FF
        STA shipHasAlreadyBeenHitByGilby,X
        LDX tempLoPtr3

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
;------------------------------------------------------------------
; PerformPlanetWarp
;------------------------------------------------------------------
PerformPlanetWarp
        LDX currentTopPlanetIndex
        LDA planetCharsetDataHiPtrArray,X
        STA currentTopPlanetDataHiPtr
        LDA #$00
        STA currentTopPlanetDataLoPtr

        LDX currentBottomPlanetIndex
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

b51F7   LDA currentTopPlanetIndex
        STA oldTopPlanetIndex
        LDA currentBottomPlanetIndex
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
        JSR ResetSoundDataPtr1
        JSR ResetSoundDataPtr2

        LDA #<planetWarpSoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>planetWarpSoundEffect
        STA secondarySoundEffectHiPtr
        LDA #<planetWarpSoundEffect2
        STA currentSoundEffectLoPtr
        LDA #>planetWarpSoundEffect2
        STA currentSoundEffectHiPtr
        ;Fall through

;------------------------------------------------------------------
; DrawPlanetProgressPointers
;------------------------------------------------------------------
DrawPlanetProgressPointers
        LDX #$0A
        LDA #$20
b523C   STA SCREEN_RAM + $0365,X
        STA SCREEN_RAM + $03DD,X
        DEX
        BNE b523C

        LDX currentTopPlanetIndex
        LDY planetProgressPointersOffsets,X
        LDA #$98 ; Top world progress pointer
        STA SCREEN_RAM + $0365,Y
        LDX currentBottomPlanetIndex
        LDY planetProgressPointersOffsets,X
        LDA #$99 ; Bottom world progress pointer
        STA SCREEN_RAM + $03DD,Y
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

;------------------------------------------------------------------
; UpdateControlPanelColors
;------------------------------------------------------------------
UpdateControlPanelColors
        LDA gilbyVerticalPosition
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
        STA COLOR_RAM + $0347,X
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
b52B6   STA COLOR_RAM + $0347,X
        DEX
        BNE b52B6
        LDA #$01
        STA controlPanelIsGrey
        RTS

;------------------------------------------------------------------
; UpdateControlPanelColor
;------------------------------------------------------------------
UpdateControlPanelColor
        LDY #$00
        STY controlPanelColorDoesntNeedUpdating
        CMP #$01
        BEQ RestoreControlPanelColors
        BNE ResetControlPanelToGrey

controlPanelColorDoesntNeedUpdating   .BYTE $00

screenTmpPtrLo = $46
screenTmpPtrHi = $47
;------------------------------------------------------------------
; WriteInitialWarpStateToScreen
; Writes storage for top and bottom planets to $0763 and $07B3
;------------------------------------------------------------------
WriteInitialWarpStateToScreen
        LDA #>SCREEN_RAM + $0363
        STA screenTmpPtrHi ; Actually the hi ptr here
        LDA #<SCREEN_RAM + $0363
        STA screenTmpPtrLo ; Actually the lo ptr here

        ; For the top planet
        LDX currentTopPlanetIndex
        JSR UpdateWarpStateOnScreen

        ; For the bottom planet
        LDA #<SCREEN_RAM + $03B3
        STA screenTmpPtrLo
        LDX currentBottomPlanetIndex

;------------------------------------------------------------------
; UpdateWarpStateOnScreen
;------------------------------------------------------------------
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
        LDA #>SCREEN_RAM + $0300
        STA screenTmpPtrHi
        RTS

warpEffectForPlanet           .BYTE $07,$04,$0E,$08,$0A

pointsEarnedTopPlanetByte1    .BYTE $00
pointsEarnedTopPlanetByte2    .BYTE $00
pointsEarnedBottomPlanetByte1 .BYTE $00
pointsEarnedBottomPlanetByte2 .BYTE $00
;------------------------------------------------------------------
; UpdateScores
;------------------------------------------------------------------
UpdateScores
        LDA pointsEarnedTopPlanetByte2
        BNE b532F
        LDA pointsEarnedTopPlanetByte1
        BEQ b5350

        ; Update the top planet score
b532F   LDX #$06
b5331   INC SCREEN_RAM + $0354,X
        LDA SCREEN_RAM + $0354,X
        CMP #$3A
        BNE b5343
        LDA #$30
        STA SCREEN_RAM + $0354,X
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
b535C   INC SCREEN_RAM + $03CC,X
        LDA SCREEN_RAM + $03CC,X
        CMP #$3A
        BNE b536E
        LDA #$30
        STA SCREEN_RAM + $03CC,X
        DEX
        BNE b535C
b536E   DEC pointsEarnedBottomPlanetByte1
        LDA pointsEarnedBottomPlanetByte1
        CMP #$FF
        BNE b537B
        DEC pointsEarnedBottomPlanetByte2
b537B   RTS

;------------------------------------------------------------------
; InitializeEnergyBars
;------------------------------------------------------------------
InitializeEnergyBars
        LDX #$03
        STX currEnergyTop
        STX currEnergyBottom
b5384   LDA #$80 ; Char for energy bars
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
        STA currCoreEnergyLevel
        LDX #$0E
        LDA #$20
b53A8   STA SCREEN_RAM + $03A4,X
        DEX
        BNE b53A8
        LDA #$87
        STA SCREEN_RAM + $03A5
b53B3   RTS

currEnergyTop                        .BYTE $03
currEnergyBottom                     .BYTE $03
currCoreEnergyLevel                  .BYTE $00
amountToDecreaseEnergyByTopPlanet    .BYTE $00
amountToDecreaseEnergyByBottomPlanet .BYTE $00
;------------------------------------------------------------------
; DecreaseEnergyStorage
;------------------------------------------------------------------
DecreaseEnergyStorage
        DEC updateEnergyStorageInterval
        BNE b53B3
        LDA #$04
        STA updateEnergyStorageInterval

        LDA amountToDecreaseEnergyByTopPlanet
        BEQ UpdateEnergyStorageBottomPlanet

        ;Color the 'Energy' label.
        DEC amountToDecreaseEnergyByTopPlanet
        LDX amountToDecreaseEnergyByTopPlanet
        LDA energyLabelColors,X
        LDY #$04
b53D3   STA COLOR_RAM + $034A,Y
        DEY
        BNE b53D3

        LDX currEnergyTop
        INC SCREEN_RAM + $0373,X
        LDA SCREEN_RAM + $0373,X
        CMP #$88
        BNE UpdateEnergyStorageBottomPlanet
        LDA #$20
        STA SCREEN_RAM + $0373,X
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
        LDA amountToDecreaseEnergyByBottomPlanet
        BEQ b542B

        DEC amountToDecreaseEnergyByBottomPlanet
        LDX amountToDecreaseEnergyByBottomPlanet

        LDA energyLabelColors,X
        LDY #$04
b540B   STA COLOR_RAM + $03C2,Y
        DEY
        BNE b540B

        LDX currEnergyBottom
        INC SCREEN_RAM + $039B,X
        LDA SCREEN_RAM + $039B,X
        CMP #$88
        BNE b542B
        LDA #$20
        STA SCREEN_RAM + $039B,X
        DEX
        STX currEnergyBottom
        CPX #$FF
        BEQ GilbyDiedBecauseEnergyDepleted
b542B   RTS

energyLabelColors           .BYTE WHITE,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
                            .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
                            .BYTE BLUE
updateEnergyStorageInterval .BYTE $01

;------------------------------------------------------------------
; DepleteEnergyTop
;------------------------------------------------------------------
DepleteEnergyTop
        STX temporaryStorageForXRegister
        LDX currEnergyTop
        INC SCREEN_RAM + $0373,X
        LDA SCREEN_RAM + $0373,X
        CMP #$88
        BNE b547B
        LDA #$20
        STA SCREEN_RAM + $0373,X
        DEX
        STX currEnergyTop
        CPX #$FF
        BNE b547B
b545B   JMP GilbyDiedBecauseEnergyDepleted

;------------------------------------------------------------------
; DepleteEnergyBottom
;------------------------------------------------------------------
DepleteEnergyBottom
        STX temporaryStorageForXRegister
        LDX currEnergyBottom
        INC SCREEN_RAM + $039B,X
        LDA SCREEN_RAM + $039B,X
        CMP #$88
        BNE b547B
        LDA #$20
        STA SCREEN_RAM + $039B,X
        DEX
        STX currEnergyBottom
        CMP #$FF
        BEQ b545B
b547B   LDX temporaryStorageForXRegister
        RTS

;------------------------------------------------------------------
; GilbyDiesFromExcessEnergy
;------------------------------------------------------------------
GilbyDiesFromExcessEnergy
        LDA #$01
        STA reasonGilbyDied ; Overload (too much energy)
        JMP GilbyDied

;------------------------------------------------------------------
; IncreaseEnergyTop
;------------------------------------------------------------------
IncreaseEnergyTop
        STX temporaryStorageForXRegister
        LDX currEnergyTop
        DEC SCREEN_RAM + $0373,X
        LDA SCREEN_RAM + $0373,X
        CMP #$7F
        BNE b547B
        LDA #$80
        STA SCREEN_RAM + $0373,X
        INX
        STX currEnergyTop
        CPX #$08
        BEQ GilbyDiesFromExcessEnergy
        LDA #$87
        STA SCREEN_RAM + $0373,X
        BNE b547B

;------------------------------------------------------------------
; IncreaseEnergyBottom
;------------------------------------------------------------------
IncreaseEnergyBottom
        STX temporaryStorageForXRegister
        LDX currEnergyBottom
        DEC SCREEN_RAM + $039B,X
        LDA SCREEN_RAM + $039B,X
        CMP #$7F
        BNE b547B
        LDA #$80
        STA SCREEN_RAM + $039B,X
        INX
        STX currEnergyBottom
        CPX #$08
        BEQ GilbyDiesFromExcessEnergy
        LDA #$87
        STA SCREEN_RAM + $039B,X
        BNE b547B

;------------------------------------------------------------------
; UpdateCoreEnergyLevel
;------------------------------------------------------------------
UpdateCoreEnergyLevel
        LDX currCoreEnergyLevel
        CPX #$FF
        BNE b54DF
        INX
        STX currCoreEnergyLevel
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

j54F3
        LDA #$87
        STA SCREEN_RAM + $03A5,X
        STX currCoreEnergyLevel
        RTS

b54FC   LDA lowerPlanetActivated
        BEQ b5505
        DEX
        JMP j54F3

b5505   INC bonusPhaseEarned
b5508   RTS

bonusPhaseEarned   .BYTE $00
;------------------------------------------------------------------
; IncreaseCoreEnergyLevel
;------------------------------------------------------------------
IncreaseCoreEnergyLevel
        LDX currCoreEnergyLevel
        CPX #$FF
        BEQ b5528
        INC SCREEN_RAM + $03A5,X
        LDA SCREEN_RAM + $03A5,X
        CMP #$88
        BNE b5508
        LDA #$20
        STA SCREEN_RAM + $03A5,X
        DEX
        STX currCoreEnergyLevel
        CPX #$FF
        BNE b5508
b5528   RTS

temporaryStorageForXRegister   .BYTE $00

;------------------------------------------------------------------
; UpdateCoreEnergyValues
;------------------------------------------------------------------
UpdateCoreEnergyValues
        LDA gilbyIsOverLand
        BNE b5530
b552F   RTS

b5530   LDA previousJoystickAction
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

;------------------------------------------------------------------
; IncreaseEnergyTopOnly
;------------------------------------------------------------------
IncreaseEnergyTopOnly
        LDY #$23
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b5572
        STA energyChangeCounter
b556A   JSR IncreaseEnergyTop
        DEC energyChangeCounter
        BNE b556A
        RTS

b5572   JMP IncreaseEnergyTop
        ;Returns

;------------------------------------------------------------------
; IncreaseEnergyBottomOnly
;------------------------------------------------------------------
IncreaseEnergyBottomOnly
        LDY #$23
        LDA (currentShipWaveDataLoPtr),Y
        BEQ b5585
        STA energyChangeCounter
b557D   JSR IncreaseEnergyBottom
        DEC energyChangeCounter
        BNE b557D
        RTS

b5585   JMP IncreaseEnergyBottom
        ;Returns

updateLevelForBottomPlanet  .BYTE $01
currentLevelInCurrentPlanet .BYTE $09
;------------------------------------------------------------------
; UpdateLevelText
;------------------------------------------------------------------
UpdateLevelText
        LDA #$01
        STA hasEnteredNewLevel
        LDA updateLevelForBottomPlanet
        BNE b55BD

        LDA #$30
        STA SCREEN_RAM + $0360
        STA SCREEN_RAM + $0361
        LDX currentLevelInCurrentPlanet
        BEQ b55B6

        ; Update the current level (top planet)
b55A1   INC SCREEN_RAM + $0361
        LDA SCREEN_RAM + $0361
        CMP #$3A
        BNE b55B3
        LDA #$30
        STA SCREEN_RAM + $0361
        INC SCREEN_RAM + $0360
b55B3   DEX
        BNE b55A1

b55B6   LDA oldTopPlanetIndex
        PHA
        JMP UpdateLevelData


        ; Update the current level (bottom planet)
b55BD   LDA #$30
        STA SCREEN_RAM + $03D8
        STA SCREEN_RAM + $03D9
        LDX currentLevelInCurrentPlanet
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
b55DF   LDA oldBottomPlanetIndex
        PHA

;------------------------------------------------------------------
; UpdateLevelData
;------------------------------------------------------------------
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

        ; Byte 39: (Index $26) Number of ships in wave.
        ; Y is $26
b5628   LDA (levelDataPtrLo),Y
b562A   STA enemiesKilledTopPlanetsSinceLastUpdate,X
        LDA enemiesKilledTopPlanetSinceLastUpdate
        BNE b5638
        LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        STA enemiesKilledTopPlanetSinceLastUpdate
b5638   DEY
        ; Byte 38: (Index $25) Number of waves in data.
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

;------------------------------------------------------------------
; UpdateTopPlanetProgressData
;------------------------------------------------------------------
UpdateTopPlanetProgressData
        STX temporaryStorageForXRegister
        LDX oldTopPlanetIndex
        DEC enemiesKilledTopPlanetsSinceLastUpdate,X
        LDA enemiesKilledTopPlanetSinceLastUpdate
        BNE b568C
        LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        STA enemiesKilledTopPlanetSinceLastUpdate
b568C   LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        BNE b56B9
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
b56B9   LDX temporaryStorageForXRegister
        RTS

;------------------------------------------------------------------
; UpdateBottomPlanetProgressData
;------------------------------------------------------------------
UpdateBottomPlanetProgressData
        STX temporaryStorageForXRegister
        LDX oldBottomPlanetIndex
        DEC enemiesKilledBottomPlanetsSinceLastUpdate,X
        LDA enemiesKilledBottomPlanetSinceLastUpdate
        BNE b56D1
        LDA enemiesKilledBottomPlanetsSinceLastUpdate,X
        STA enemiesKilledBottomPlanetSinceLastUpdate
b56D1   LDA enemiesKilledBottomPlanetsSinceLastUpdate,X
        BNE b56B9
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
        JMP b56B9

;------------------------------------------------------------------
; InitializePlanetProgressArrays
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; MapPlanetProgressToLevelText
;------------------------------------------------------------------
MapPlanetProgressToLevelText
        LDX currentTopPlanetIndex
        LDA currentLevelInTopPlanets,X
        STA currentLevelInCurrentPlanet
        LDA #$00
        STA updateLevelForBottomPlanet
        JSR UpdateLevelText
        INC updateLevelForBottomPlanet
        LDX currentBottomPlanetIndex
        LDA currentLevelInBottomPlanets,X
        STA currentLevelInCurrentPlanet
        JMP UpdateLevelText

;------------------------------------------------------------------
; CalculatePointsForByte2
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; CheckProgressInPlanet
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; CheckProgressInBottomPlanet
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; AugmentAmountToDecreaseEnergyByBountiesEarned
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; GilbyDied
;------------------------------------------------------------------
GilbyDied
        LDA #$01
        STA gilbyHasJustDied
        LDA levelRestartInProgress
        BNE b5833
        LDA attractModeCountdown
        BNE b5833

        LDX #$00
b5807   LDA #$FC
        STA explosionSprite
        LDA #$00
        STA gilbyExplosionColorIndex
        STA explosionXPosOffset1,X
        INX
        CPX #$03
        BNE b5807

        LDA #$01
        STA gilbyExploding
        LDA #$03
        STA starFieldInitialStateArray - $01
        LDA #<gilbyDiedSoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>gilbyDiedSoundEffect
        STA secondarySoundEffectHiPtr
        JSR ResetSoundDataPtr2
        LDX #$23
        RTS

b5833   RTS

mapPlanetEntropyToColor  .BYTE WHITE,YELLOW,CYAN,GREEN,PURPLE
explosionXPosOffSet      .BYTE $02,$06,$00
explosionXPosOffset1     .BYTE $50,$A0,$40
explosionSprite          .BYTE $FE
gilbyExplosionColorIndex .BYTE $08
;------------------------------------------------------------------
; ProcessGilbyExplosion
;------------------------------------------------------------------
ProcessGilbyExplosion
        LDA gilbyExploding
        BEQ b5847
        RTS

b5847   LDA #$F0
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
        LDA gilbyVerticalPosition
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
        CMP #$FF
        BNE b58C9
        LDA #$FC
        STA explosionSprite
b58C9   DEC explosionInProgress
        BNE b58E8
        LDA #$0A
        STA explosionInProgress
        INC gilbyExplosionColorIndex
        LDA gilbyExplosionColorIndex
        STA gilbyExploding
        LDY #$02
        STY starFieldInitialStateArray - $01
        CMP #$08
        BNE b58E8
        JMP SetUpLevelRestart

b58E8   RTS

explosionInProgress    .BYTE $0A
gilbyDiedSoundEffect   .BYTE $00,$00,$0F,$0C,$00
                       .BYTE $00,$00,$0F,$13,$00
                       .BYTE $00,$00,$00,$0D,$00
                       .BYTE $00,$00,$00,$14,$00
                       .BYTE $00,$00,$80,$08,$00
                       .BYTE $00,$00,$40,$0F,$00
                       .BYTE $00,$00,$81,$0B,$00
                       .BYTE $00,$00,$81,$12,$02
                       .BYTE $08,$01,$0C,$08,$00
                       .BYTE $0F,$01,$0C,$0F,$01
                       .BYTE $00,$81,$1C,$00,$00
                       .BYTE $00,$00,$20,$08,$00
                       .BYTE $00,$00,$20,$0F,$00
                       .BYTE $00,$00,$81,$0B,$00
                       .BYTE $00,$00,$21,$12,$02
                       .BYTE $08,$02,$01,$08,$00
                       .BYTE $0F,$02,$45,$0F,$01
                       .BYTE $00,$81,$1F,$00,$00
                       .BYTE $00,$00,$10,$08,$02
                       .BYTE $08,$02,$01,$08,$00
                       .BYTE $0F,$02,$01,$0F,$00
                       .BYTE $18,$02,$01,$18,$01
                       .BYTE $00,$81,$0F,$00,$00
                       .BYTE $00,$00,$80,$0B,$00
                       .BYTE $00,$00,$80,$12,$00
                       .BYTE $00,$80,<f7BCA,>f7BCA,$00

;------------------------------------------------------------------
; SetUpLevelRestart
;------------------------------------------------------------------
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
        STA currentTopPlanetIndex
        LDA oldBottomPlanetIndex
        STA currentBottomPlanetIndex
        JSR PerformPlanetWarp
        LDA #$01
        STA levelEntrySequenceActive
        STA entryLevelSequenceCounter
        LDA #<levelRestartSoundEffect1
        STA currentSoundEffectLoPtr
        LDA #>levelRestartSoundEffect1
        STA currentSoundEffectHiPtr
        LDA #<levelRestartSoundEffect2
        STA secondarySoundEffectLoPtr
        LDA #>levelRestartSoundEffect2
        STA secondarySoundEffectHiPtr
        LDA #$00
        STA $D015    ;Sprite display Enable
        JSR ResetSoundDataPtr1
        JMP ResetSoundDataPtr2
        ; Returns

levelRestartInProgress .BYTE $00
gilbiesLeft            .BYTE $02

;------------------------------------------------------------------
; FlashBackgroundAndBorder
;------------------------------------------------------------------
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

b5A03   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;------------------------------------------------------------------
; PlayerKilled
;------------------------------------------------------------------
PlayerKilled
        JSR ClearScreen3
        DEC gilbiesLeft
        BPL b5A1E
        BEQ b5A1E
        JMP DisplayGameOver

        ; Get a random number between 0 and 7
b5A1E   JSR PutRandomByteInAccumulatorRegister
        AND #$07 ; Make it a number between 0 and 7
        TAY
        JSR DrawRestartLevelText

        ;Draw the gilbies left text
        LDX #$14
b5A29   LDA txtGilbiesLeft,X
        AND #$3F
        STA SCREEN_RAM + $00F8,X
        DEX
        BNE b5A29

        JSR DrawReasonGilbyDied

        ; Show remaining gilbies
        LDA gilbiesLeft
        CLC
        ADC #$31
        STA SCREEN_RAM + $0109

        ; Get a random number between 0 and 7
        JSR PutRandomByteInAccumulatorRegister
        AND #$07 ; Make it a number between 0 and 7
        CLC
        ADC #$08 ; Selects the 'encouragement text' in the second half of txtRestartLevelMsg
        TAY
        ;Fall through

;------------------------------------------------------------------
; DrawRestartLevelText
;------------------------------------------------------------------
DrawRestartLevelText
        LDA #<txtRestartLevelMsg
        STA tmpPtrLo
        LDA #>txtRestartLevelMsg
        STA tmpPtrHi
        STY tmpPtrZp47 ; Random byte picked by PutRandomByteInAccumulatorRegister
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

b5A67   LDA tmpPtrZp47 ; Random byte picked by PutRandomByteInAccumulatorRegister
        AND #$08
        BNE b5A7A

b5A6D   LDA (tmpPtrLo),Y
        AND #$3F
        STA SCREEN_RAM + $00A9,Y
        INY
        CPY #$14
        BNE b5A6D
        RTS  ; Returns early

b5A7A   LDA (tmpPtrLo),Y
        AND #$3F
        STA SCREEN_RAM + $0149,Y
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

;------------------------------------------------------------------
; ClearScreen3
;------------------------------------------------------------------
ClearScreen3
        LDX #$00
b5A98   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0248,X
        LDA #WHITE
        STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA COLOR_RAM + $0248,X
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
levelRestartSoundEffect1 .BYTE $00,$00,$0F,$05,$00
                         .BYTE $00,$00,$00,$06,$00
                         .BYTE $00,$00,$20,$01,$00
                         .BYTE $00,$00,$21,$04,$02
                         .BYTE $01,$02,$43,$01,$01
                         .BYTE $00,$81,$F0,$00,$00
                         .BYTE $00,$00,$20,$04,$00
                         .BYTE $00,$80,<f7BCA,>f7BCA,$00
levelRestartSoundEffect2 .BYTE $00,$00,$0F,$18,$00
                         .BYTE $00,$00,$0F,$0C,$00
                         .BYTE $00,$00,$0F,$13,$00
                         .BYTE $00,$00,$00,$0D,$00
                         .BYTE $00,$00,$00,$14,$01
                         .BYTE $00,$00,$10,$08,$00
                         .BYTE $00,$00,$10,$0F,$00
                         .BYTE $00,$00,$21,$0B,$00
                         .BYTE $00,$00,$21,$12,$02
                         .BYTE $08,$01,$04,$08,$00
                         .BYTE $0F,$01,$04,$0F,$01
                         .BYTE $00,$81,$05,$00,$00
                         .BYTE $00,$00,$10,$08,$00
                         .BYTE $00,$00,$10,$0F,$00
                         .BYTE $00,$00,$11,$0B,$00
                         .BYTE $00,$00,$11,$12,$02
f5C85                    .BYTE $08,$02,$02,$08,$00
                         .BYTE $0F,$02,$02,$0F,$01
                         .BYTE $00,$81,$08,$00,$00
                         .BYTE $18,$05,$01,$4E,$5C
                         .BYTE $00,$00,$10,$0B,$00
                         .BYTE $00,$00,$10,$12,$00
                         .BYTE $00,$80,<f7BCA,>f7BCA

colorsForFlashBackgroundAndBorderEffect
        .BYTE ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE,GRAY3,GRAY3,GRAY2
        .BYTE GRAY3,GRAY2,GRAY2,GRAY1,GRAY2,GRAY1,GRAY1,$80
        .BYTE GRAY1,$80,$80,GRAY1,$80,GRAY1,GRAY1,GRAY2
        .BYTE GRAY1,GRAY2,GRAY2,GRAY3,GRAY2,GRAY3,GRAY3

initialColorForFlashEffect   .BYTE $02,$00

;------------------------------------------------------------------
; DrawLevelEntryAndWarpGilbyAnimation
; This is the multi-coloured level entry effect where 7 gilbys
; spread across the screen.
;------------------------------------------------------------------
DrawLevelEntryAndWarpGilbyAnimation
        LDX #$00
b5CCB   LDA gilbyVerticalPosition
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
planetWarpSoundEffect  .BYTE $00,$00,$0F,$0C,$00
                       .BYTE $00,$00,$0F,$13,$00
                       .BYTE $00,$00,$0F,$18,$00
                       .BYTE $00,$00,$00,$0D,$00
                       .BYTE $00,$00,$00,$14,$00
                       .BYTE $00,$00,$03,$08,$00
                       .BYTE $00,$00,$03,$0F,$00
                       .BYTE $00,$00,$21,$0B,$00
                       .BYTE $00,$00,$08,$0E,$00
                       .BYTE $00,$00,$00,$07,$00
f5D65                  .BYTE $00,$00,$21,$12,$01
                       .BYTE $18,$05,$00,<f5D65,>f5D65
                       .BYTE $00,$00,$20,$0B,$00
                       .BYTE $00,$00,$20,$12,$00
                       .BYTE $00,$80,<f7BCA,>f7BCA,$00
planetWarpSoundEffect2 .BYTE $00,$00,$0F,$05,$00
                       .BYTE $00,$00,$00,$06,$00
                       .BYTE $00,$00,$00,$01,$00
f5D8D                  .BYTE $00,$00,$11,$04,$02
f5D92                  .BYTE $01,$01,$64,$01,$01
f5D97                  .BYTE $00,$81,$08,$00,$00
                       .BYTE $01,$01,$18,$01,$01
                       .BYTE $18,$05,$01,<f5D8D,>f5D8D
                       .BYTE $00,$00,$10,$04,$00
                       .BYTE $00,$80,<f7BCA,>f7BCA,$00
levelEntrySoundEffect  .BYTE $00,$00,$0F,$0C,$00
                       .BYTE $00,$00,$0F,$13,$00
                       .BYTE $00,$00,$00,$0D,$00
                       .BYTE $00,$00,$00,$14,$00
                       .BYTE $00,$00,$10,$08,$00
                       .BYTE $00,$00,$15,$12,$00
                       .BYTE $00,$00,$20,$0B,$00
                       .BYTE $00,$00,$0F,$18,$00
f5DD8                  .BYTE $00,$00,$40,$0F,$02
                       .BYTE $0F,$02,$28,$0F,$01
                       .BYTE $00,$81,$08,$00,$00
                       .BYTE $18,$05,$05,<f5DD8,>f5DD8
                       .BYTE $00,$00,$80,$0B,$00
                       .BYTE $00,$00,$80,$12,$00
                       .BYTE $00,$00,$0F,$18,$00
                       .BYTE $00,$80,<f7BCA,>f7BCA,$00
;------------------------------------------------------------------
; UpdateDisplayedScoringRate
;------------------------------------------------------------------
UpdateDisplayedScoringRate
        LDA #$23
        STA SCREEN_RAM + $0387
        LDA #WHITE
        STA COLOR_RAM + $0387
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
        STA SCREEN_RAM + $0388
        LDA scoreColors,Y
        STA COLOR_RAM + $0388
        STY lastRegisteredScoringRate
        RTS

scoreToScoringRateMap .BYTE $00,$00,$01,$01,$01,$01,$02,$02
                      .BYTE $02,$02,$02,$02,$02,$02,$03,$03
                      .BYTE $04,$04,$03,$02,$02,$01,$01,$01
                      .BYTE $01,$01,$01,$01,$01,$01
scoringRateToScoreMap .BYTE $00,$01,$02,$04,$08
scoreColors           .BYTE BLUE,PURPLE,GREEN,YELLOW,WHITE

lastRegisteredScoringRate   .BYTE $01
;------------------------------------------------------------------
; UpdatePlanetEntropyStatus
;------------------------------------------------------------------
UpdatePlanetEntropyStatus
        LDA lowerPlanetActivated
        BEQ b5E5D
        JMP ReturnFromSub

b5E5D   LDA valueIsAlwaysZero
        BEQ b5E69
        LDA #$08
        STA lowerPlanetEntropyStatus
        BNE b5E6E
b5E69   LDA #$08
        STA upperPlanetEntropyStatus
b5E6E   DEC entropyUpdateRate
        BEQ MaybeUpdateDisplayedEntropy
        BNE UpdateDisplayedEntropyStatus

entropyUpdateRate        .BYTE $A3
upperPlanetEntropyStatus .BYTE $08
lowerPlanetEntropyStatus .BYTE $08
entroyDisplayUpdateRate  .BYTE $23

;------------------------------------------------------------------
; MaybeUpdateDisplayedEntropy
;------------------------------------------------------------------
MaybeUpdateDisplayedEntropy
        DEC entroyDisplayUpdateRate
        BNE UpdateDisplayedEntropyStatus
        LDA #$10
        STA entroyDisplayUpdateRate
        LDA #$00
        STA currentEntropy
        LDA valueIsAlwaysZero
        BEQ b5EA6
        DEC upperPlanetEntropyStatus
        BNE b5E95
        INC currentEntropy
b5E95   LDA upperPlanetEntropyStatus
        CMP #$FF
        BNE UpdateDisplayedEntropyStatus

EntropyKillsGilby
        LDA #$02
        STA reasonGilbyDied ; Entropy
        JMP GilbyDied
        ; Returns

        BNE UpdateDisplayedEntropyStatus
b5EA6   DEC lowerPlanetEntropyStatus
        BNE b5EAE
        INC currentEntropy
b5EAE   LDA lowerPlanetEntropyStatus
        CMP #$FF
        BNE UpdateDisplayedEntropyStatus
        JMP EntropyKillsGilby

;------------------------------------------------------------------
; UpdateDisplayedEntropyStatus
; This is the planet entropy status for the upper and
; lower plants, on the bottom left hand side of the screen.
;------------------------------------------------------------------
UpdateDisplayedEntropyStatus
        LDA #$08
        SEC
        SBC upperPlanetEntropyStatus
        TAY
        LDA mapPlanetEntropyToColor,Y
        STA COLOR_RAM + $0348
        STA COLOR_RAM + $0349
        STA COLOR_RAM + $0370
        STA COLOR_RAM + $0371
        LDA #$08
        SEC
        SBC lowerPlanetEntropyStatus
        TAY
        LDA mapPlanetEntropyToColor,Y
        STA COLOR_RAM + $0398
        STA COLOR_RAM + $0399
        STA COLOR_RAM + $03C0
        STA COLOR_RAM + $03C1
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

;------------------------------------------------------------------
; UpdateEnemiesLeft
;------------------------------------------------------------------
UpdateEnemiesLeft
        LDA #$30
        STA txtEnemiesLeftCol1
        STA txtEnemiesLeftCol2
        LDA enemiesKilledTopPlanetSinceLastUpdate
        BEQ b5F21

b5F0D   JSR UpdateEnemiesLeftStorage
        DEC enemiesKilledTopPlanetSinceLastUpdate
        BNE b5F0D
        LDA txtEnemiesLeftCol1
        STA SCREEN_RAM + $034F
        LDA txtEnemiesLeftCol2
        STA SCREEN_RAM + $0350

b5F21   LDA currentGilbySpeed
        BNE b5F28

        LDA #$01
b5F28   PHA
        TAY
        LDA colorSequenceArray,Y
        STA COLOR_RAM + $034F
        STA COLOR_RAM + $0350

        LDA lowerPlanetActivated
        BEQ b5F3A

        ; No lower planet, so return early.
        PLA
        RTS

b5F3A   LDA #$30
        STA txtEnemiesLeftCol1
        STA txtEnemiesLeftCol2
        LDA enemiesKilledBottomPlanetSinceLastUpdate
        BEQ b5F5B
b5F47   JSR UpdateEnemiesLeftStorage
        DEC enemiesKilledBottomPlanetSinceLastUpdate
        BNE b5F47
        LDA txtEnemiesLeftCol1
        STA SCREEN_RAM + $03C7
        LDA txtEnemiesLeftCol2
        STA SCREEN_RAM + $03C8
b5F5B   PLA
        TAY
        LDA colorSequenceArray,Y
        STA COLOR_RAM + $03C7
        STA COLOR_RAM + $03C8
        RTS

;------------------------------------------------------------------
; UpdateEnemiesLeftStorage
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; StoreStatusBarDetail
;------------------------------------------------------------------
StoreStatusBarDetail
        LDX #$A0
b6032   LDA SCREEN_RAM + $0347,X
        STA statusBarDetailStorage,X
        DEX
        BNE b6032
        RTS

;------------------------------------------------------------------
; DrawStatusBarDetail
;------------------------------------------------------------------
DrawStatusBarDetail
        LDX #$A0
b603E   LDA statusBarDetailStorage,X
        STA SCREEN_RAM + $0347,X
        DEX
        BNE b603E
b6047   RTS

;------------------------------------------------------------------
; DrawLowerPlanetWhileInactive
; Draws the lower planet for the early levels when it isn't
; active yet.
;------------------------------------------------------------------
DrawLowerPlanetWhileInactive
        LDA lowerPlanetActivated
        BEQ b6047

        LDX #$28
b604F   LDA textForInactiveLowerPlanet - $01,X
        AND #$3F
        STA SCREEN_RAM + $02F7,X
        LDA #WHITE
        STA COLOR_RAM + $02F7,X
        DEX
        BNE b604F

        LDX #$28
b6061   LDA surfaceDataInactiveLowerPlanet,X
        CLC
        ADC #$40
        STA SCREEN_RAM + $0257,X
        DEX
        BNE b6061

        LDX #$10
b606F   LDY xPosSecondLevelSurfaceInactivePlanet,X
        LDA secondLevelSurfaceDataInactivePlanet,X
        CLC
        ADC #$40
        STA SCREEN_RAM + $01E4,Y
        DEX
        BNE b606F
        RTS

xPosSecondLevelSurfaceInactivePlanet =*-$01
                                     .BYTE $00,$01,$02,$03,$28,$29,$2A,$2B
                                     .BYTE $50,$51,$52,$53,$78,$79,$7A
secondLevelSurfaceDataInactivePlanet .BYTE $7B,$30,$32,$38,$3A,$31,$33,$39
                                     .BYTE $3B,$34,$36,$3C,$3E,$35,$37,$3D
surfaceDataInactiveLowerPlanet       .BYTE $3F,$01,$03
                                     .BYTE $01,$03,$01,$03,$01,$03,$01,$03
                                     .BYTE $01,$03,$01,$03,$01,$03,$01,$03
                                     .BYTE $01,$03,$01,$03,$01,$03,$01,$03
                                     .BYTE $01,$03,$01,$03,$1D,$1F,$00,$02
                                     .BYTE $00,$02,$00,$02,$00,$02
textForInactiveLowerPlanet           .TEXT "  WARP GATE       GILBY   CORE  NOT-CORE"
progressDisplaySelected              .BYTE $00
;------------------------------------------------------------------
; DrawProgressDisplayScreen
;------------------------------------------------------------------
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

b6105   LDY #$00
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
        STA SCREEN_RAM + $02F8,X
        LDA #YELLOW
        STA COLOR_RAM + $02F8,X
        DEX
        BPL b6148

        LDX #$06
b615A   LDA currentBonusBountyPtr,X
        STA SCREEN_RAM + $0319,X
        DEX
        BNE b615A
        LDA gilbiesLeft
        CLC
        ADC #$31
        STA SCREEN_RAM + $0305
        RTS

txtGilbiesLeftBonusBounty   .TEXT "GILBIES LEFT 0: BONUS BOUNTY NOW 0000000"

b6195   RTS

;------------------------------------------------------------------
; DrawProgressForTopPlanets
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; DrawProgressForBottomPlanets
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; ShowProgressScreen
;------------------------------------------------------------------
ShowProgressScreen
        LDA #$00
        STA $D015    ;Sprite display Enable
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA lastKeyPressed
        JSR DrawProgressDisplayScreen

        LDX #$28
b61FE   LDA txtProgressStatusLine1 - $01,X
        AND #$3F
        STA SCREEN_RAM + $0257,X
        LDA #WHITE
        STA COLOR_RAM + $0257,X
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
        STA SCREEN_RAM + $02A7,X
        LDA #YELLOW
        STA COLOR_RAM + $02A7,X
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

;------------------------------------------------------------------
; DrawPlanetIconsOnProgressDisplay
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; GameSwitchAndGameOverInterruptHandler
;------------------------------------------------------------------
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
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$20
        STA $D012    ;Raster Position
        JMP $EA31

txtProgressStatusLine1 .TEXT "IRIDIS ALPHA: PROGRESS STATUS DISPLAY %"
txtProgressStatusLine2 .TEXT "%PRESS THE FIRE BUTTON WHEN YOU ARE READY"

transferToOtherPlanetSoundEffect2 .BYTE $00,$00,$20,$04,$00
                                  .BYTE $00,$00,$03,$02,$00
                                  .BYTE $00,$00,$21,$04,$00
f6344                             .BYTE $00,$00,$60,$01,$02
                                  .BYTE $01,$01,$10,$01,$01
                                  .BYTE $00,$81,$08,$00,$00
                                  .BYTE $02,$05,$01,<f6344,>f6344
                                  .BYTE $00,$00,$20,$04,$00
                                  .BYTE $00,$80,<f7BCA,>f7BCA,$00
transferToOtherPlanetSoundEffect1 .BYTE $00,$00,$20,$04,$00
                                  .BYTE $00,$00,$03,$02,$00
                                  .BYTE $00,$00,$21,$04,$00
f6371                             .BYTE $00,$00,$A0,$01,$02
                                  .BYTE $01,$02,$10,$01,$01
                                  .BYTE $00,$81,$08,$00,$00
                                  .BYTE $02,$05,$01,<f6371,>f6371
                                  .BYTE $00,$00,$20,$04,$00
                                  .BYTE $00,$80,<f7BCA,>f7BCA,$00
enemySprites2 = $E800
;------------------------------------------------------------------
; SwapTitleScreenDataAndSpriteLevelData
; Swap data in $E800 (some enemy sprites and level data) to
; $810, where the title screen data and logic normally lives.
; In other words, swap a big chunk of sprite and level data
; into the position in memory where the title screen logic lives.
; At 'Game Over' this will get swapped back.
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; EnterMainTitleScreen ($63C5)
;------------------------------------------------------------------
EnterMainTitleScreen
        JSR SwapTitleScreenDataAndSpriteLevelData
        JSR LaunchCurrentProgram
        SEI
        LDA #<GameSwitchAndGameOverInterruptHandler
        STA $0314    ;IRQ
        LDA #>GameSwitchAndGameOverInterruptHandler
        STA $0315    ;IRQ
        JMP SwapTitleScreenDataAndSpriteLevelData
        ; Returns

;------------------------------------------------------------------
; DisplayGameOver
;------------------------------------------------------------------
DisplayGameOver
        SEI
        LDA #<GameSwitchAndGameOverInterruptHandler
        STA $0314    ;IRQ
        LDA #>GameSwitchAndGameOverInterruptHandler
        STA $0315    ;IRQ
        CLI
        LDA #$00
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
        STA SCREEN_RAM + $00BD,X
        LDA txtFinalScore,X
        AND #$3F
        STA SCREEN_RAM + $010D,X
        LDA txtFinalScoreValue,X
        AND #$3F
        STA SCREEN_RAM + $015D,X
        LDA #WHITE
        STA COLOR_RAM + $00BD,X
        STA COLOR_RAM + $010D,X
        LDA #PURPLE
        STA COLOR_RAM + $015D,X
        DEX
        BPL b63FA

        JMP AnimateFinalScoreTally
        ;Returns

txtGameOver        .TEXT "GAME OVER.."
txtFinalScore      .TEXT "FINAL SCORE"
txtFinalScoreValue .TEXT "  0000000  "
;------------------------------------------------------------------
; AnimateFinalScoreTally
;------------------------------------------------------------------
AnimateFinalScoreTally
        LDA #$5E
        STA tempLoPtr
        LDA #$05
        STA tempHiPtr
        LDA #<SCREEN_RAM + $0354
        STA tempLoPtr1
        LDA #>SCREEN_RAM + $0354
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
;------------------------------------------------------------------
; IncrementFinalScoreTally
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; UpdateFinalScoreTally
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; DrawReasonGilbyDied
;------------------------------------------------------------------
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
        STA SCREEN_RAM + $02B7,Y
        LDA #RED
        STA COLOR_RAM + $02B7,Y
        INY
        INX
        CPY #$0A
        BNE b64F7
        RTS

;------------------------------------------------------------------
; JumpDisplayNewBonus
;------------------------------------------------------------------
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
bonusGilbyXPos2           .BYTE $00
bonusGilbyYPos2           .BYTE $00
;------------------------------------------------------------------
; DisplayNewBonus
;------------------------------------------------------------------
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
        LDA #$00
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
        LDA NewBonusGilbyColors,X
        STA $D027,X  ;Sprite 0 Color
        DEX
        BPL b6595

        LDX #$0A
b65A5   LDA txtBonus10000,X
        AND #$3F
        STA SCREEN_RAM + $019F,X
        LDA #YELLOW
        STA COLOR_RAM + $019F,X
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

;------------------------------------------------------------------
; NewBonusGilbyAnimation
;------------------------------------------------------------------
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

bonusGilbyAnimation   .BYTE $04,$04,$02,$02,$00,$00,$00,$03
                      .BYTE $03,$06,$06,$01,$01,$00,$00
NewBonusGilbyColors   .BYTE $02,$0A,$08,$07,$05,$0E,$04,$06

;------------------------------------------------------------------
; AnimateGilbiesForNewBonus
;------------------------------------------------------------------
AnimateGilbiesForNewBonus
        LDY #$00
        LDA #$F0
        STA $D012    ;Raster Position
        DEC bonusGilbyAnimation
        BNE b6610
        LDA bonusGilbyAnimation + $01
        STA bonusGilbyAnimation
        LDA bonusBountyOffset2
        CLC
        ADC bonusGilbyAnimation + $05
        STA bonusGilbyAnimation + $05
b6610   DEC bonusGilbyAnimation + $03
        BNE b6625
        LDA bonusGilbyAnimation + $02
        STA bonusGilbyAnimation + $03
        LDA bonusGilbyAnimation + $06
        CLC
        ADC bounsBountyOffset
        STA bonusGilbyAnimation + $06
b6625   DEC bonusGilbyAnimation + $07
        BNE b6633
        LDA bonusGilbyAnimation + $08
        STA bonusGilbyAnimation + $07
        INC bonusGilbyAnimation + $0D
b6633   DEC bonusGilbyAnimation + $09
        BNE b6641
        LDA bonusGilbyAnimation + $0A
        STA bonusGilbyAnimation + $09
        INC bonusGilbyAnimation + $0E
b6641   LDA bonusGilbyAnimation + $05
        PHA
        LDA bonusGilbyAnimation + $06
        PHA
        LDA bonusGilbyAnimation + $0D
        PHA
        LDA bonusGilbyAnimation + $0E
        PHA
b6651   LDA bonusGilbyAnimation + $05
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyXPos1
        LDA bonusGilbyAnimation + $06
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyYPos1
        LDA bonusGilbyAnimation + $0D
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyXPos2
        LDA bonusGilbyAnimation + $0E
        AND #$3F
        TAX
        LDA bonusGilbiesPositionArray,X
        STA bonusGilbyYPos2

        JSR BonusBountyPerformAnimation

        LDA bonusGilbyAnimation + $0E
        CLC
        ADC #$08
        STA bonusGilbyAnimation + $0E
        LDA bonusGilbyAnimation + $0D
        CLC
        ADC #$08
        STA bonusGilbyAnimation + $0D
        LDA bonusGilbyAnimation + $06
        CLC
        ADC #$08
        STA bonusGilbyAnimation + $06
        LDA bonusGilbyAnimation + $05
        CLC
        ADC #$08
        STA bonusGilbyAnimation + $05
        INY
        INY
        CPY #$10
        BNE b6651
        PLA
        STA bonusGilbyAnimation + $0E
        PLA
        STA bonusGilbyAnimation + $0D
        PLA
        STA bonusGilbyAnimation + $06
        PLA
        STA bonusGilbyAnimation + $05
        DEC bonusGilbyAnimation + $04
        BNE b6709
        JSR PutRandomByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$04
        TAX
        LDA bonusBountyAnimationArray2,X
        STA bonusGilbyAnimation + $01
        LDA bonusBountyAnimationArray,X
        STA bonusBountyOffset2
        JSR PutRandomByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$04
        TAX
        LDA bonusBountyAnimationArray2,X
        STA bonusGilbyAnimation + $02
        LDA bonusBountyAnimationArray,X
        STA bounsBountyOffset
        JSR PutRandomByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$01
        STA bonusGilbyAnimation + $07
        STA bonusGilbyAnimation + $08
        JSR PutRandomByteInAccumulatorRegister
        AND #$07
        CLC
        ADC #$01
        STA bonusGilbyAnimation + $09
        STA bonusGilbyAnimation + $0A
b6709   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR PlaySoundEffects
        JMP $EA31

;------------------------------------------------------------------
; BonusBountyPerformAnimation
;------------------------------------------------------------------
BonusBountyPerformAnimation
        LDA bonusGilbyXPos1
        LDX bonusGilbyAnimation + $0B
        BEQ b6725
        JSR BonusBountyAnimateGilbyXPos
        JMP BonusBountySkipUpdatingXPos

b6725   CLC
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos

BonusBountySkipUpdatingXPos
        LDA bonusGilbyYPos1
        LDX bonusGilbyAnimation + $0C
        BEQ b6736
        JMP BonusBountyAnimateGilbyYPos

b6736   CLC
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS

bonusBountyOffset2         .BYTE $01
bounsBountyOffset          .BYTE $01
bonusBountyAnimationArray2 .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                           .BYTE $02,$03,$04,$05,$06,$07,$08,$09
bonusBountyAnimationArray  .BYTE $08,$07,$06,$05,$04,$03,$02,$01
                           .BYTE $01,$01,$01,$01,$01,$01,$01,$01
bonusBountyGilbyXPosOffset = $FA
;------------------------------------------------------------------
; BonusBountyAnimateGilbyXPos
;------------------------------------------------------------------
BonusBountyAnimateGilbyXPos
        LDA bonusGilbyXPos1
        CLC
        ROR
        STA bonusBountyGilbyXPosOffset
        LDA bonusGilbyXPos2
        CLC
        ROR
        CLC
        ADC bonusBountyGilbyXPosOffset
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos
        RTS

;------------------------------------------------------------------
; BonusBountyAnimateGilbyYPos
;------------------------------------------------------------------
BonusBountyAnimateGilbyYPos
        LDA bonusGilbyYPos1
        CLC
        ROR
        STA bonusBountyGilbyXPosOffset
        LDA bonusGilbyYPos2
        CLC
        ROR
        CLC
        ADC bonusBountyGilbyXPosOffset
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
;------------------------------------------------------------------
; InitializeStarfieldSprite
;------------------------------------------------------------------
InitializeStarfieldSprite
        LDA #$00
        LDY #$40
b6812   STA starFieldSprite - $01,Y
        DEY
        BNE b6812

;------------------------------------------------------------------
; DrawParallaxOfStarfieldInGilbyDirection
;------------------------------------------------------------------
DrawParallaxOfStarfieldInGilbyDirection
        LDX currentGilbySpeed
        BPL b6822
        TXA
        EOR #$FF
        TAX
        INX
b6822   LDA starfieldSpriteAnimationData,X
        STA starFieldSprite
        STA starFieldSprite + $03
        STA starFieldSprite + $12
        STA starFieldSprite + $15
        STA starFieldSprite + $24
        STA starFieldSprite + $27
        STA starFieldSprite + $36
        STA starFieldSprite + $39
        RTS

;------------------------------------------------------------------
; PrepareScreen
;------------------------------------------------------------------
PrepareScreen
        LDA #$00
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

;------------------------------------------------------------------
; SetupSpritesAndSound
;------------------------------------------------------------------
SetupSpritesAndSound
        LDA #$FF
        SEI
        STA $D015    ;Sprite display Enable
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDA #$C0 ; Star field sprite at $3000
        STA Sprite7PtrStarField
        LDA #$00
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        STA gilbyHasJustDied
        STA levelRestartInProgress
        LDA oldTopPlanetIndex
        STA currentTopPlanetIndex
        LDA oldBottomPlanetIndex
        STA currentBottomPlanetIndex
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
        BNE b68DF

b68D2   LDA #$00
        STA SCREEN_RAM + $01B7,X
        LDA #PURPLE
        STA COLOR_RAM + $01B7,X
        DEX
        BNE b68D2

b68DF   RTS

;------------------------------------------------------------------
; InitializeSprites
;------------------------------------------------------------------
InitializeSprites
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
        JSR SetUpGilbySprite
p6904   JMP PrepareToRunGame

;------------------------------------------------------------------
; SetUpGilbySprite
;------------------------------------------------------------------
SetUpGilbySprite
        LDA #GILBY_AIRBORNE_RIGHT
        STA currentGilbySprite
        STA Sprite0Ptr
        LDA #$02
        STA gilbyAnimationTYpe
        LDA #$40
        STA $D001    ;Sprite 0 Y Pos
        LDA #ALREADY_AIRBORNE
        STA previousJoystickAction
        LDA #$EA
        STA currentGilbySpeed
        LDA #$00
        STA gilbyIsLanding
        RTS

bonusAwarded   .BYTE $00
;------------------------------------------------------------------
; PrepareToRunGame
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; BeginRunningGame
;------------------------------------------------------------------
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
        BEQ GoToBonusPhase
        SEI
        LDA $D016    ;VIC Control Register 2
        AND #$E7
        ORA #$08
        STA $D016    ;VIC Control Register 2
        JSR StoreStatusBarDetail
        JSR ShowProgressScreen
        INC shouldResetPlanetEntropy
        JMP SetUpGameScreen

GoToBonusPhase
        LDA bonusPhaseEarned
        BEQ b6A02
        SEI
        JSR StoreStatusBarDetail
        JSR ClearScreen3
        JSR DisplayEnterBonusRoundScreen

;------------------------------------------------------------------
; ResumeGame
;------------------------------------------------------------------
ResumeGame
        JSR ClearPlanetTextureCharsets
        JSR DrawStatusBarDetail
        JSR InitializeEnergyBars
        JSR SetUpGilbySprite

        ; Clear charset data
        LDX #$00
        TXA
b69C4   STA planetTextureCharset1,X
        STA planetTextureCharset2,X
        STA planetTextureCharset3,X
        STA planetTextureCharset4,X
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

b6A02   JSR UpdateEnemiesLeft
        JSR UpdatePlanetEntropyStatus
        JSR UpdateDisplayedScoringRate
        LDA levelRestartInProgress
        BEQ b6A1C

;------------------------------------------------------------------
; EnterMainControlLoop
;------------------------------------------------------------------
EnterMainControlLoop
        JSR InitializeEnergyBars
        JSR StoreStatusBarDetail
        JSR PlayerKilled
        JMP SetUpGameScreen

b6A1C   LDA controlPanelColorDoesntNeedUpdating
        BEQ b6A24
        JSR UpdateControlPanelColor
b6A24   LDA qPressedToQuitGame
        BEQ b6A31

        ; Player has pressed Q to quit game.
        LDA #$00
        STA qPressedToQuitGame
        JMP MainControlLoop

b6A31   JSR UpdateScores
        LDA gilbyHasJustDied
        BNE b6A3E

        LDA pauseModeSelected
        BNE EnterPauseMode

b6A3E   JMP BeginRunningGame

EnterPauseMode
        ; Wait for the player to release the key
        LDA lastKeyPressed
        CMP #$40 ; $40 means no key was pressed
        BNE EnterPauseMode

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

;------------------------------------------------------------------
; SetUpGameScreen
;------------------------------------------------------------------
SetUpGameScreen
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$01
        STA controlPanelColorDoesntNeedUpdating
        LDA #$FF
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
        STA currentTopPlanetIndex
        LDA oldBottomPlanetIndex
        STA currentBottomPlanetIndex
        JSR PerformPlanetWarp
        JSR DrawStatusBarDetail
        LDX #$03
b6AB3   LDA upperPlanetAttackShipSpritesLoadedFromBackingData,X
        STA upperPlanetAttackShip3SpriteValue,X
        LDA lowerPlanetAttackShipSpritesLoadedFromBackingData,X
        STA lowerPlanetAttackShip3SpriteValue,X
        DEX
        BNE b6AB3
        JMP BeginRunningGame

previousGilbySprite   .BYTE $D3
;------------------------------------------------------------------
; DrawUpperPlanetAttackShips
;------------------------------------------------------------------
DrawUpperPlanetAttackShips
        LDX #$0C
        LDY #$06
b6ACA   LDA upperPlanetAttackShipsXPosArray,Y
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
        BNE b6ACA
        RTS

;------------------------------------------------------------------
; DrawLowerPlanetAttackShips
;------------------------------------------------------------------
DrawLowerPlanetAttackShips
        LDX #$0C
        LDY #$06
b6B06   LDA lowerPlanetAttackShip1XPos,Y
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
        LDA backgroundColorsForPlanets,X
        STA $D027,Y  ;Sprite 0 Color

        LDA lowerPlanetAttackShipsSpriteValueArray,Y
        STA Sprite0Ptr,Y
        LDX tempVarStorage

        DEX
        DEX
        DEY
        BNE b6B06
        RTS

;------------------------------------------------------------------
; MainControlLoopInterruptHandler
;------------------------------------------------------------------
MainControlLoopInterruptHandler
        RTI

attackShipsXPosArray          .BYTE $FD,$FB,$F7,$EF,$DF,$BF
attackShipsMSBXPosOffsetArray =*-$01
gilbyBulletMSBXPosOffset      .BYTE $02
attackShip2MSBXPosOffsetArray .BYTE $04,$08,$10,$20,$40,$02,$04,$08
                              .BYTE $10,$20,$40
difficultySetting             .BYTE $00

;------------------------------------------------------------------
; MainGameInterruptHandler
;------------------------------------------------------------------
MainGameInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE RasterPositionMatchesRequestedInterrupt ; Collision detected

;------------------------------------------------------------------
; ReturnFromInterrupt
;------------------------------------------------------------------
ReturnFromInterrupt
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

;------------------------------------------------------------------
; ClearGameViewPort
;------------------------------------------------------------------
ClearGameViewPort
        LDX #$00
        LDA #$20
b6B63   STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02F8,X
        DEX
        BNE b6B63
        RTS

;------------------------------------------------------------------
; FlashBorderAndBackground
;------------------------------------------------------------------
FlashBorderAndBackground
        LDA currentEntropy
        BEQ b6BA3
        LDA borderFlashControl1
        BNE b6B90
        DEC borderFlashControl2
        BNE b6BBE
        LDA #$01
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$01
        STA borderFlashControl1
b6B8F   RTS

b6B90   DEC borderFlashControl1
        BNE b6B8F
        LDA #$00
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
        LDA #$00
        STA gilbyExploding
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
b6BBE   RTS

;------------------------------------------------------------------
; RasterPositionMatchesRequestedInterrupt
;------------------------------------------------------------------
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
        JMP AnimateStarFieldAndDrawLowerPlanet
        ; Returns from Interrupt

;------------------------------------------------------------------
; ResetRasterAndPerformMainGameUpdate
;------------------------------------------------------------------
ResetRasterAndPerformMainGameUpdate
        LDA #$00
        STA currentIndexInRasterInterruptArrays
        LDA #$5C
        STA $D012    ;Raster Position
        LDA $D016    ;VIC Control Register 2
        AND #$E0
        ORA #$08
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        BNE PerformMainGameUpdate

;------------------------------------------------------------------
; UpdateGilbyPositionAndColor
;------------------------------------------------------------------
UpdateGilbyPositionAndColor
        LDA gilbyHasJustDied
        BNE b6C24
        LDA currentGilbySprite
        STA Sprite0Ptr
        STA previousGilbySprite
        LDA gilbyVerticalPosition
        STA $D001    ;Sprite 0 Y Pos
        LDX currEnergyTop
        LDA energyLevelToGilbyColorMap,X
        LDX amountToDecreaseEnergyByTopPlanet
        BEQ b6C1A
        LDA processJoystickFrameRate
b6C1A   LDY valueIsAlwaysZero
        BEQ b6C21
        LDA #$0B
b6C21   STA $D027    ;Sprite 0 Color
b6C24   RTS

currentGilbySprite   .BYTE GILBY_AIRBORNE_RIGHT

;------------------------------------------------------------------
; PerformMainGameUpdate
;------------------------------------------------------------------
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
        JSR AnimateGilbySpriteMovement
        JSR PerformMainGameProcessing
        JSR CheckForLandscapeCollisionAndWarpThenProcessJoystickInput
        JSR PerformGilbyLandingOrJumpingAnimation
        JSR AlsoPerformGilbyLandingOrJumpingAnimation
        JSR MaybeDrawLevelEntrySequence
        JSR PlaySoundEffects
        JSR FlashBorderAndBackground
        JSR UpdateGilbyPositionAndColor
        JSR UpdateAndAnimateAttackShips
        JSR UpdateBulletPositions
        JSR DrawUpperPlanetAttackShips
        JSR UpdateControlPanelColors
        JMP $EA31 ; jump into KERNAL's standard interrupt service routine to handle keyboard scan, cursor display etc.
        ;Returns From Interrupt

;------------------------------------------------------------------
; AnimateStarFieldAndDrawLowerPlanet
; Sprite 7 is used to draw the parallax starfield background.
;------------------------------------------------------------------
AnimateStarFieldAndDrawLowerPlanet

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

;------------------------------------------------------------------
; DrawLowerPlanet
;------------------------------------------------------------------
DrawLowerPlanet
        JSR DrawLowerPlanetAttackShips
        LDA #$07
        SEC
        SBC planetScrollSpeed
        STA currentMSBXPosOffset
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        ORA currentMSBXPosOffset
        STA $D016    ;VIC Control Register 2

        LDA gilbyHasJustDied
        BNE b6D07

        ; Draw the lower planet gilby
        LDA #$FF
        SEC
        SBC gilbyVerticalPosition
        ADC #$07
        STA $D001    ;Sprite 0 Y Pos
        STA unusedLandingVariable
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
        LDX amountToDecreaseEnergyByBottomPlanet
        BEQ b6D2C

        LDA processJoystickFrameRate
b6D2C   LDY valueIsAlwaysZero
        BNE b6D33

        LDA #$0B
b6D33   STA $D027    ;Sprite 0 Color (lower planet gilby)

;------------------------------------------------------------------
; UpdateRasterPositionAndReturn
;------------------------------------------------------------------
UpdateRasterPositionAndReturn
        LDY #$0A
        STY currentIndexInRasterInterruptArrays
        LDA spriteCollidedWithBackground,Y
        STA $D012    ;Raster Position

;------------------------------------------------------------------
; UpdateInterruptRegisterAndReturn
;------------------------------------------------------------------
UpdateInterruptRegisterAndReturn
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

;------------------------------------------------------------------
; ScrollStarfieldAndThenPlanets
;------------------------------------------------------------------
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
starfieldSpriteAnimationData .BYTE $C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0
                             .BYTE $F0,$F0,$F0,$F0,$F8,$F8,$F8,$F8
                             .BYTE $FC,$FC,$FC,$FC,$FE,$FE,$FE,$FF
processJoystickFrameRate     .BYTE $01
gilbyIsOverLand              .BYTE $01

;------------------------------------------------------------------
; CheckForLandscapeCollisionAndWarpThenProcessJoystickInput
;------------------------------------------------------------------
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
        LDA SCREEN_RAM + $01A4
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

;------------------------------------------------------------------
; WarpToNextPlanet
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; CheckJoystickInput
;------------------------------------------------------------------
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
        LDA SCREEN_RAM + $01A4
        CMP #$41
        BEQ b6EC4
        CMP #$43
        BNE b6EC9

b6EC4   LDA #$01
        STA gilbyIsOverLand

b6EC9   LDA valueIsAlwaysZero
        BEQ b6EF6

        ; Reverses the joystick input if valueIsAlwaysZero is set.
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

b6EF6   LDA levelEntrySequenceActive
        BNE b6E8D

        LDA previousJoystickAction
        BEQ b6F03
        JMP ActionIfPreviousActionWasHorizontal

b6F03
        JSR ProcessFireButtonPressed

        ;Check if joystick pushed to left.
        LDA joystickInput
        AND #$04
        BNE b6F2E

        ; Joystick pushed to left
        LDA #HORIZONTAL_MOVEMENT
        STA previousJoystickAction
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
        AND #$08
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
        STA previousJoystickAction

        ;Check if joystick pushed down.
b6F54   LDA joystickInput
        AND #$01
        BNE b6F98

        ; Joystick pushed up
        LDA gilbyIsOverLand
        BEQ JoystickPushedUpWhileLandGilbyAirborneOverSea
        JMP JoystickPushedUpWhileOnLand

;------------------------------------------------------------------
; JoystickPushedUpWhileLandGilbyAirborneOverSea
;------------------------------------------------------------------
JoystickPushedUpWhileLandGilbyAirborneOverSea
        ; Joystick pushed up
        LDA gilbyVerticalPosition
        CMP #$6D
        BNE b6F98

        ; Gilby is on the ground
        LDA #<pushedUpWhileOverSea
        STA currentSoundEffectLoPtr
        LDA #>pushedUpWhileOverSea
        STA currentSoundEffectHiPtr
        LDA #$FA
        STA gilbyLandingJumpingAnimationYPosOffset
        DEC gilbyVerticalPosition
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
        STA previousJoystickAction
b6F98   RTS

;------------------------------------------------------------------
; ActionIfPreviousActionWasHorizontal
;------------------------------------------------------------------
ActionIfPreviousActionWasHorizontal
        CMP #HORIZONTAL_MOVEMENT ; Looking at previousJoystickAction
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
        STA previousJoystickAction
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

;------------------------------------------------------------------
; JoystickPushedUpWhileOnLand
;------------------------------------------------------------------
JoystickPushedUpWhileOnLand
        LDA gilbyVerticalPosition
        CMP #$6D
        BNE b703A
        LDA #$FA
        STA gilbyLandingJumpingAnimationYPosOffset
        LDA #<soundGilbyJumpOnLand
        STA currentSoundEffectLoPtr
        LDA #>soundGilbyJumpOnLand
        STA currentSoundEffectHiPtr
        JSR ResetSoundDataPtr1
        DEC gilbyVerticalPosition
b703A   RTS

;------------------------------------------------------------------
; MaybePreviousActionWasToLaunchIntoAir
;------------------------------------------------------------------
MaybePreviousActionWasToLaunchIntoAir
        CMP #LAUNCHED_INTO_AIR ; Looks at previousJoystickAction
        BNE MaybePreviousActionWasSomething

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

;------------------------------------------------------------------
; LandGilby
;------------------------------------------------------------------
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
        STA previousJoystickAction
b707D   RTS

;------------------------------------------------------------------
; MaybePreviousActionWasSomething
;------------------------------------------------------------------
MaybePreviousActionWasSomething
        CMP #LANDED ; Looks at previousJoystickAction
        BNE RightJoystickPressedWithPreviousAction
        JSR ProcessFireButtonPressed
        LDA gilbyVerticalPosition
        CMP #$6D
        BNE b707D
        LDA #<gilbyWalkingSound
        STA currentSoundEffectLoPtr
        LDA #>gilbyWalkingSound
        STA currentSoundEffectHiPtr
        JMP b6FB7

b7099   JSR ResetGilbyIsLanding
        LDA #GILBY_AIRBORNE_LEFT
        STA currentGilbySprite

;------------------------------------------------------------------
; UpdatePreviousJoystickAction
;------------------------------------------------------------------
UpdatePreviousJoystickAction
        LDA #ALREADY_AIRBORNE
        STA previousJoystickAction
        RTS

;------------------------------------------------------------------
; UpdateGilbySpriteToAirborne
;------------------------------------------------------------------
UpdateGilbySpriteToAirborne
        LDA #GILBY_AIRBORNE_RIGHT
        STA currentGilbySprite
        JSR UpdatePreviousJoystickAction

;------------------------------------------------------------------
; ResetGilbyIsLanding
;------------------------------------------------------------------
ResetGilbyIsLanding
        LDA #$00
        STA gilbyIsLanding
        RTS

;------------------------------------------------------------------
; RightJoystickPressedWithPreviousAction
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; LeftJoystickPressedWithPreviousAction
;------------------------------------------------------------------
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

gilbyIsLanding   .BYTE $00


;------------------------------------------------------------------
; DecelerateGilbyAndPossiblySetUpToLand
;------------------------------------------------------------------
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
        STA gilbyIsLanding
        LDA #GILBY_TAKING_OFF4
        STA currentGilbySprite
        JMP LandGilby
        ; Returns

AnimateGilbyMovement
        JMP DrawParallaxOfStarfieldInGilbyDirection
        ; Returns

joystickInput          .BYTE $09
previousJoystickAction .BYTE $04
gilbyAnimationTYpe     .BYTE $02

HORIZONTAL_MOVEMENT = $01
LAUNCHED_INTO_AIR   = $02
LANDED              = $03
ALREADY_AIRBORNE    = $04


;------------------------------------------------------------------
; AlsoPerformGilbyLandingOrJumpingAnimation
;------------------------------------------------------------------
AlsoPerformGilbyLandingOrJumpingAnimation
        LDA previousJoystickAction
        CMP #ALREADY_AIRBORNE
        BEQ b7181
b7180   RTS

b7181   LDA joystickInput
        AND #$01
        BNE b71A4
        DEC gilbyVerticalPosition
        DEC gilbyVerticalPosition
        LDA gilbyVerticalPosition
        AND #$FE
        CMP #$30
        BNE b719D
        INC gilbyVerticalPosition
        INC gilbyVerticalPosition
b719D   LDA gilbyVerticalPosition
        STA $D001    ;Sprite 0 Y Pos
        RTS

b71A4   LDA joystickInput
        AND #$02
        BNE b7180
        INC gilbyVerticalPosition
        INC gilbyVerticalPosition
        LDA gilbyVerticalPosition
        AND #$F0
        CMP #$70
        BNE b719D
        DEC gilbyVerticalPosition
        DEC gilbyVerticalPosition
        BNE b719D
        ;Fall through?

;------------------------------------------------------------------
; DrawPlanetSurfaces
;------------------------------------------------------------------
DrawPlanetSurfaces
        LDY #$00
        LDA lowerPlanetActivated
        BEQ b71E6

        ; Only need to draw the upper planet
        LDX #$27
b71CB   LDA (planetTextureTopLayerPtr),Y
        STA SCREEN_RAM + $0118,Y
        LDA (planetTextureSecondFromTopLayerPtr),Y
        STA SCREEN_RAM + $0140,Y
        LDA (planetTextureSecondFromBottomLayerPtr),Y
        STA SCREEN_RAM + $0168,Y
        LDA (planetTextureBottomLayerPtr),Y
        STA SCREEN_RAM + $0190,Y
        INY
        DEX
        CPY #$28
        BNE b71CB
        RTS

        ;Draw the upper and lower planets. The lower
        ; planet is a mirror image of the top.
b71E6   LDX #$27
b71E8   LDA (planetTextureTopLayerPtr),Y
        STA SCREEN_RAM + $0118,Y
        ORA #$C0
        STA SCREEN_RAM + $0258,X
        LDA (planetTextureSecondFromTopLayerPtr),Y
        STA SCREEN_RAM + $0140,Y
        ORA #$C0
        STA SCREEN_RAM + $0230,X
        LDA (planetTextureSecondFromBottomLayerPtr),Y
        STA SCREEN_RAM + $0168,Y
        ORA #$C0
        STA SCREEN_RAM + $0208,X
        LDA (planetTextureBottomLayerPtr),Y
        STA SCREEN_RAM + $0190,Y
        ORA #$C0
        STA SCREEN_RAM + $01E0,X
        INY
        DEX
        CPY #$28
        BNE b71E8
        RTS

;------------------------------------------------------------------
; ScrollPlanets
;------------------------------------------------------------------
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
        BMI b7234
        JMP ScrollPlanetLeft

b7234   LDA planetScrollSpeed
        CLC
        ADC currentGilbySpeed
        STA planetScrollSpeed
        AND #$F8
        BNE b7243
        RTS

b7243   LDA planetScrollSpeed
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
;------------------------------------------------------------------
; DrawPlanetScroll
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; ScrollPlanetLeft
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; StoreRandomPositionInPlanetInPlanetPtr
;------------------------------------------------------------------
StoreRandomPositionInPlanetInPlanetPtr
        LDA #<planetOneBottomLayer
        STA planetPtrLo
        LDA #>planetOneBottomLayer
        STA planetPtrHi
        LDA charSetDataPtrLo
        BEQ b72F9
        INC planetPtrHi
        INC planetPtrHi
b72F9   LDA planetPtrLo
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

randomIntToIncrement   =*+$01
;------------------------------------------------------------------
; PutRandomByteInAccumulatorRegister
;------------------------------------------------------------------
PutRandomByteInAccumulatorRegister
        LDA randomPlanetData
        INC randomIntToIncrement
        RTS

;------------------------------------------------------------------
; UpdateTopPlanetSurfaceColor
;------------------------------------------------------------------
UpdateTopPlanetSurfaceColor
        LDX #$28
b731F   STA COLOR_RAM + $0117,X
        STA COLOR_RAM + $013F,X
        STA COLOR_RAM + $0167,X
        STA COLOR_RAM + $018F,X
        DEX
        BNE b731F
        RTS

;------------------------------------------------------------------
; UpdateBottomPlanetSurfaceColor
;------------------------------------------------------------------
UpdateBottomPlanetSurfaceColor
        LDX #$28
b7331   STA COLOR_RAM + $01DF,X
        STA COLOR_RAM + $0207,X
        STA COLOR_RAM + $022F,X
        STA COLOR_RAM + $0257,X
        DEX
        BNE b7331
        RTS

;------------------------------------------------------------------
; AnimateEntryLevelSequence
;------------------------------------------------------------------
AnimateEntryLevelSequence
        LDA currentBottomPlanetDataLoPtr
        STA planetSurfaceDataPtrLo
        LDA currentBottomPlanetDataHiPtr
        STA planetSurfaceDataPtrHi
        JSR MutateSomeMoreOfThePlanetCharsetForEntrySequence
        LDA mutatedCharToDraw
        STA planetTextureCharset3,X
        INC planetSurfaceDataPtrHi
        JSR MutateSomeMoreOfThePlanetCharsetForEntrySequence
        LDA mutatedCharToDraw
        STA planetTextureCharset4,X
        RTS

;------------------------------------------------------------------
; MutateSomeMoreOfThePlanetCharsetForEntrySequence
;------------------------------------------------------------------
MutateSomeMoreOfThePlanetCharsetForEntrySequence
        LDA (planetSurfaceDataPtrLo),Y
        PHA
        AND #$03
        TAX
        LDA bitfield1ForMaterializingPlanet,X
        STA mutatedCharToDraw
        PLA
        ROR
        ROR
        PHA
        AND #$03
        TAX
        LDA bitfield2ForMaterializingPlanet,X
        ORA mutatedCharToDraw
        STA mutatedCharToDraw
        PLA
        ROR
        ROR
        AND #$03
        TAX
        LDA bitfield3ForMaterializingPlanet,X
        ORA mutatedCharToDraw
        STA mutatedCharToDraw
        LDA (planetSurfaceDataPtrLo),Y
        ROL
        ROL
        ROL
        AND #$03
        ORA mutatedCharToDraw
        STA mutatedCharToDraw
        TYA
        PHA
        AND #$07
        TAY
        PLA
        PHA
        AND #$F8
        STA charSetDataPtrLo
        LDA bitsOfPlanetToShow,Y
        CLC
        ADC charSetDataPtrLo
        TAX
        PLA
        TAY
        RTS

bitsOfPlanetToShow              .BYTE $07,$06,$05,$04,$03,$02,$01,$00
currentTopPlanetDataLoPtr       .BYTE $00
currentTopPlanetDataHiPtr       .BYTE $92
currentBottomPlanetDataLoPtr    .BYTE $00
currentBottomPlanetDataHiPtr    .BYTE $92
bitfield1ForMaterializingPlanet .BYTE $00,$40,$80,$C0
bitfield2ForMaterializingPlanet .BYTE $00,$10,$20,$30
bitfield3ForMaterializingPlanet .BYTE $00,$04,$08,$0C

;------------------------------------------------------------------
; GeneratePlanetSurface
;
; This is the routine Minter called 'GenPlan'.
;
; From Jeff Minter's development diary:
; 17 February 1986
; "Redid the graphics completely, came up with some really nice looking
; metallic planet structures that I'll probably stick with. Started to
; write the GenPlan routine that'll generate random planets at will.
; Good to have a C64 that can generate planets in its spare time.
; Wrote pulsation routines for the colours; looks well good with some
; of the planet structures. The metallic look seems to be 'in' at the
; moment so this first planet will go down well. There will be five
; planet surface types in all, I reckon, probably do one with grass
; and sea a bit like 'Sheep in Space', cos I did like that one. It'll
; be nice to have completely different planet surfaces in top and bottom
; of the screen. The neat thing is that all the surfaces have the same
; basic structures, all I do is fit different graphics around each one."
;------------------------------------------------------------------

GeneratePlanetSurface
        LDA #<planetSurfaceData
        STA planetSurfaceDataPtrLo
        LDA #>planetSurfaceData
        STA planetSurfaceDataPtrHi

        ; Clear down the planet surface data from $8000 to $8FFF
        LDY #$00
b73C6   LDA #$60
b73C8   STA (planetSurfaceDataPtrLo),Y
        DEY
        BNE b73C8
        INC planetSurfaceDataPtrHi
        LDA planetSurfaceDataPtrHi
        CMP #$90
        BNE b73C6

        ; Fill $8C00 to $8CFF with a $40,$42 pattern. These are the
        ; character values that represent 'sea' on the planet.
        LDA #$8C
        STA planetSurfaceDataPtrHi
b73D9   LDA #$40
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
        BNE b73D9

        ; Pick a random point between $8C00 and $8FFF for
        ; the start of the land section.
        JSR PutRandomByteInAccumulatorRegister
        AND #$7F
        CLC
        ADC #$7F
        STA charSetDataPtrHi
        LDA #$00
        STA charSetDataPtrLo
        ; Use the two pointers above to pick a random position
        ; in the planet between $8C00 and $8FFF and store it in
        ; planetPtrLo/planetPtrHi
        JSR StoreRandomPositionInPlanetInPlanetPtr

        ; Randomly generate the length of the land section, but
        ; make it at least 32 bytes.
        JSR PutRandomByteInAccumulatorRegister
        AND #$7F
        CLC
        ADC #$20
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
        ; 256 bytes, depending on the randomly chosen length of the land
        ; chosen above and storedin planetSurfaceDataPtrLo.
b741A   INC charSetDataPtrHi
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
        BNE b741A

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
nextLargestStructure .BYTE $59,$5B,$FF,$58,$5A,$FF
                     .BYTE $55,$57,$FF
                     .BYTE $54,$56,$FE
warpGateData         .BYTE $75,$77,$7D,$7F,$FF
                     .BYTE $74,$76,$7C,$7E,$FF
                     .BYTE $71,$73,$79,$7B,$FF
                     .BYTE $70,$72,$78,$7A,$FE

;------------------------------------------------------------------
; DrawLittleStructure ($7486)
;------------------------------------------------------------------
DrawLittleStructure
        LDX #$00
DrawLSLoop
        LDA littleStructureData,X
        CMP #$FF
        BNE b7495
        JSR SwitchToNextLayerInPlanet
        JMP DrawLSLoop

b7495   CMP #$FE
        BEQ b74B0
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawLSLoop

littleStructureData .BYTE $45,$47,$FF
                    .BYTE $44,$46,$FE

;------------------------------------------------------------------
; SwitchToNextLayerInPlanet
;------------------------------------------------------------------
SwitchToNextLayerInPlanet
        LDA planetPtrHi
        SEC
        SBC #$04
        STA planetPtrHi
        LDY #$00
        INX
b74B0   RTS

;------------------------------------------------------------------
; DrawMediumStructure ($74B1)
;------------------------------------------------------------------
DrawMediumStructure
        LDX #$00

DrawMSLoop
        LDA mediumStructureData,X
        CMP #$FF
        BNE b74C0
        JSR SwitchToNextLayerInPlanet
        JMP DrawMSLoop

b74C0   CMP #$FE
        BEQ b74B0 ; Return
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawMSLoop

;------------------------------------------------------------------
; DrawLargestStructure ($74CB)
;------------------------------------------------------------------
DrawLargestStructure
        LDX #$00

DrawLargeStructureLoop
        LDA largestStructureData,X
        CMP #$FF
        BNE b74DA
        JSR SwitchToNextLayerInPlanet
        JMP DrawLargeStructureLoop

b74DA   CMP #$FE
        BEQ b74B0 ; Return
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawLargeStructureLoop

;------------------------------------------------------------------
; DrawNextLargestStructure ($74E5)
;------------------------------------------------------------------
DrawNextLargestStructure
        LDX #$00
DrawNSLoop
        LDA nextLargestStructure,X
        CMP #$FF
        BNE b74F4
        JSR SwitchToNextLayerInPlanet
        JMP DrawNSLoop

b74F4   CMP #$FE
        BEQ b74B0 ; Return
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawNSLoop

;------------------------------------------------------------------
; DrawWarpGate
;------------------------------------------------------------------
DrawWarpGate
        LDX #$00
DrawWGLoop
        LDA warpGateData,X
        CMP #$FF
        BNE b750E
        JSR SwitchToNextLayerInPlanet
        JMP DrawWGLoop

b750E   CMP #$FE
        BEQ b74B0
        STA (planetPtrLo),Y
        INY
        INX
        JMP DrawWGLoop

;------------------------------------------------------------------
; GeneratePlanetStructures
;------------------------------------------------------------------
GeneratePlanetStructures
        LDA #<characterSetData
        STA charSetDataPtrLo
        LDA #>characterSetData
        STA charSetDataPtrHi

        ; Draw randomly chosen structures across the surface
        ; of the planet.
GenerateStructuresLoop
        JSR DrawRandomlyChosenStructure
        JSR PutRandomByteInAccumulatorRegister
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
        BEQ b7546
        CMP #$D0
        BEQ b7546
        JMP GenerateStructuresLoop

        ; Draw the two warp gates
b7546   LDA charSetDataPtrLo
        BEQ GenerateStructuresLoop
        LDA #$F1
        STA charSetDataPtrHi
        JSR StoreRandomPositionInPlanetInPlanetPtr
        JSR DrawWarpGate
        DEC charSetDataPtrLo
        LDA #$05
        STA charSetDataPtrHi
        JSR StoreRandomPositionInPlanetInPlanetPtr
        JSR DrawWarpGate
        RTS

;------------------------------------------------------------------
; DrawRandomlyChosenStructure
;------------------------------------------------------------------
DrawRandomlyChosenStructure
        ; Pick a random positio to draw the structure
        JSR StoreRandomPositionInPlanetInPlanetPtr
        ;Pick a random number between 1 and 4
        JSR PutRandomByteInAccumulatorRegister
        AND #$03
        TAX

        ; Run the randomly chose subroutine, one of:
        ; DrawLittleStructure, DrawMediumStructure, DrawLargestStructure, DrawNextLargestStructure to draw a structure
        ; on the planet surface
        LDA structureSubRoutineArrayHiPtr,X
        STA structureRoutineHiPtr
        LDA structureSubRoutineArrayLoPtr,X
        STA structureRoutineLoPtr
        JMP (randomStructureRoutineAddress)

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
;------------------------------------------------------------------
; AnimateGilbySpriteMovement
;------------------------------------------------------------------
AnimateGilbySpriteMovement
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
        LDA previousJoystickAction
        CMP #HORIZONTAL_MOVEMENT
        BNE b7601
        LDA gilbyVerticalPosition
        CMP #$6D
        BNE b7601
        LDA #<gilbyWalkingSound
        STA currentSoundEffectLoPtr
        LDA #>gilbyWalkingSound
        STA currentSoundEffectHiPtr
b7601   LDX gilbySpriteIndex
        LDA gilbySprites,X
        STA currentGilbySprite
        RTS

gilbyLandingJumpingAnimationYPosOffset .BYTE $01
gilbyVerticalPosition                  .BYTE $3F
unusedLandingVariable                  .BYTE $CA
gilbyLandingFrameRate                  .BYTE $01
gilbyJumpingAndLandingFrameRate        .BYTE $03
;------------------------------------------------------------------
; PerformGilbyLandingOrJumpingAnimation
;------------------------------------------------------------------
PerformGilbyLandingOrJumpingAnimation
        LDA levelEntrySequenceActive
        BNE b761A
        DEC gilbyLandingFrameRate
        BEQ b761B
b761A   RTS

b761B   LDA #$02
        STA gilbyLandingFrameRate
        LDA gilbyIsLanding
        BEQ b761A
        LDA gilbyVerticalPosition
        CMP #$6D
        BEQ b761A
        DEC gilbyJumpingAndLandingFrameRate
        BEQ b764A

GilbyLandingLoop
        CLC
        ADC gilbyLandingJumpingAnimationYPosOffset
        STA gilbyVerticalPosition
        AND #$F0
        CMP #$70
        BNE b7643
        LDA #$6D
        STA gilbyVerticalPosition
b7643   LDA gilbyVerticalPosition
        STA $D001    ;Sprite 0 Y Pos
        RTS

b764A   LDA #$03
        STA gilbyJumpingAndLandingFrameRate
        INC gilbyLandingJumpingAnimationYPosOffset
        LDA gilbyLandingJumpingAnimationYPosOffset
        CMP #$08
        BEQ b765F
        LDA gilbyVerticalPosition
        JMP GilbyLandingLoop

b765F   DEC gilbyLandingJumpingAnimationYPosOffset
        LDA gilbyVerticalPosition
        JMP GilbyLandingLoop

bulletDirectionArray .BYTE $00,$00,$00,$00,$00,$00,$00,$00
bulletFrameRate      .BYTE $01
;------------------------------------------------------------------
; ProcessFireButtonPressed
;------------------------------------------------------------------
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
        LDA gilbyVerticalPosition
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

b76DF   LDA previousJoystickAction
        CMP #ALREADY_AIRBORNE
        BNE b7717

        ; The gilby is in the air
        LDA soundEffectInProgress
        BNE b76F8
        JSR ResetSoundDataPtr2
        LDA #<airborneBulletSoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>airborneBulletSoundEffect
        STA secondarySoundEffectHiPtr

b76F8   LDA gilbyVerticalPosition
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

;------------------------------------------------------------------
; CheckBulletPositions
;------------------------------------------------------------------
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
;------------------------------------------------------------------
; UpdateBulletPositions
;------------------------------------------------------------------
UpdateBulletPositions
        LDX #$00
        LDA gilbyHasJustDied
        BEQ b7794
b7793   RTS

b7794   LDA levelEntrySequenceActive
        BNE b7793
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        CMP #$FF
        BEQ b77A9
        JSR UpdateUpperPlanetBulletPosition
        JSR CheckBulletPositions
        JMP UpdateBulletSpriteAndReturnIfRequired

b77A9   LDA #$F0
        STA upperPlanetGilbyBulletSpriteValue,X
;------------------------------------------------------------------
; UpdateBulletSpriteAndReturnIfRequired
;------------------------------------------------------------------
UpdateBulletSpriteAndReturnIfRequired
        INX
        CPX #$08
        BEQ b77BC
        CPX #$02
        BNE b7794
        LDX #$06
        JMP b7794

b77BC   JMP UpdateBulletSpriteAndReturn

upperPlanetBulletYPosUpdateCounterArray   .BYTE $03,$03,$03,$03,$03,$03,$03,$03
;------------------------------------------------------------------
; UpdateUpperPlanetBulletPosition
;------------------------------------------------------------------
UpdateUpperPlanetBulletPosition
        LDA upperPlanetGilbyBulletSpriteValue,X
        CMP #$EC
        BEQ b780E
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
        BNE b780E
b77F2   LDA #$FF
        STA upperPlanetGilbyBulletMSBXPosValue,X
        JSR ResetUpperPlanetBullet
        PLA
        PLA
        JMP UpdateBulletSpriteAndReturnIfRequired

;------------------------------------------------------------------
; ResetUpperPlanetBullet
;------------------------------------------------------------------
ResetUpperPlanetBullet
        LDA #$F0
        STA upperPlanetGilbyBulletSpriteValue,X
        LDA #$FF
        STA upperPlanetGilbyBulletXPos,X
        LDA #$00
        STA upperPlanetGilbyBulletYPos,X
b780E   RTS

;------------------------------------------------------------------
; UpdateBulletSpriteAndReturn
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; DrawControlPanel
;------------------------------------------------------------------
DrawControlPanel
        LDX #$A0
b7850   LDA controlPanelData,X
        STA SCREEN_RAM + $0347,X
        LDA controlPanelColors - $01,X
        STA COLOR_RAM + $0347,X
        DEX
        BNE b7850
        RTS

f1WasPressed   .BYTE $00
;------------------------------------------------------------------
; CheckKeyboardInGame
;------------------------------------------------------------------
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

        CMP #$3E ; Q pressed, to quit game
        BNE CheckF1Pressed

        ; Q was pressed, get ready to quit game.
        INC qPressedToQuitGame
        RTS

CheckF1Pressed   
        CMP #$04 ; F1 Pressed
        BNE CheckSpacePressed
        INC f1WasPressed
        INC pauseModeSelected
ReturnFromKeyboardCheck   
        RTS

CheckSpacePressed   
        CMP #$3C ; Space pressed
        BNE CheckYPressed
        INC progressDisplaySelected
        RTS

        ; We can award ourselves a bonus bounty by
        ; pressing Y at any time, as long as '1C' is the
        ; first character in the hiscore table. Not sure
        ; what this hack is for, testing?
CheckYPressed   
        CMP #$19 ; Y Pressed
        BNE ReturnFromKeyboardCheck
        LDA canAwardBonus
        CMP #$1C
        BNE ReturnFromKeyboardCheck
        INC bonusAwarded
        RTS

currentTopPlanetIndex      .BYTE $00
oldTopPlanetIndex          .BYTE $00
currentBottomPlanetIndex   .BYTE $00
oldBottomPlanetIndex       .BYTE $00
qPressedToQuitGame         .BYTE $00
backgroundColor1ForPlanets .BYTE BROWN,GRAY1,YELLOW,LTBLUE,LTGREEN
backgroundColor2ForPlanets .BYTE LTBLUE,$10,WHITE,YELLOW,$10
surfaceColorsForPlanets    .BYTE LTGREEN,BROWN,LTRED,GRAY2,LTRED,WHITE,WHITE
entryLevelSequenceCounter  .BYTE $A5
levelEntrySequenceActive   .BYTE $01

;------------------------------------------------------------------
; MaybeDrawLevelEntrySequence
;------------------------------------------------------------------
MaybeDrawLevelEntrySequence
        LDA levelEntrySequenceActive
        BNE b78CE
b78CD   RTS

b78CE   LDX entryLevelSequenceCounter
        LDY sourceOfRandomBytes,X
        LDA currentTopPlanetDataLoPtr
        STA planetSurfaceDataPtrLo
        LDA currentTopPlanetDataHiPtr
        STA planetSurfaceDataPtrHi

        LDA (planetSurfaceDataPtrLo),Y
        STA planetTextureCharset1,Y

        INC planetSurfaceDataPtrHi
        LDA (planetSurfaceDataPtrLo),Y
        STA planetTextureCharset2,Y

        JSR AnimateEntryLevelSequence

        ; See if we should end the sequence
        INC entryLevelSequenceCounter
        LDA entryLevelSequenceCounter
        CMP #$01
        BNE b78CD

        ; The sequence is over
        LDA #$00
        STA levelEntrySequenceActive

;------------------------------------------------------------------
; SetUpPlanets
;------------------------------------------------------------------
SetUpPlanets
        LDX currentTopPlanetIndex
        LDA backgroundColor1ForPlanets,X
        STA currentPlanetBackgroundClr1
        LDA backgroundColor2ForPlanets,X
        STA currentPlanetBackgroundClr2

        LDA surfaceColorsForPlanets,X
        JSR UpdateTopPlanetSurfaceColor

        LDX currentBottomPlanetIndex
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
        JSR ResetSoundDataPtr2
        LDA #<levelEntrySoundEffect
        STA secondarySoundEffectLoPtr
        LDA #>levelEntrySoundEffect
        STA secondarySoundEffectHiPtr
        LDA #$30
        STA soundEffectInProgress
        LDA lowerPlanetActivated
        BEQ b797C
        LDX currentTopPlanetIndex
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
tmpSoundEffectLoPtr1                    .BYTE <f5D92
tmpSoundEffectHiPtr1                    .BYTE >f5D92
tmpSoundEffectLoPtr2                    .BYTE <f5C85
tmpSoundEffectHiPtr2                    .BYTE >f5C85
tmpSoundEffectLoHiPtr3                  .BYTE $02,$00
tempSoundEffectLoHiPtr4                 .BYTE $00,$00
indexToCurrentOrSecondarySoundEffectPtr .BYTE $02

; Five bytes loaded from the sound effect in 5 byte intervals.
soundEffectDataStructure
offsetIntoSoundEffectBuffer .BYTE $18
; $01 means _
; $02
; $03 
sequenceControlByte         .BYTE $05
dataforSoundEffectBuffer    .BYTE $00
nextEffectLoPtr             .BYTE <f5D65
nextEffectHiPtr             .BYTE >f5D65

currentSoundEffectLoPtr     .BYTE <f5D97
currentSoundEffectHiPtr     .BYTE >f5D97
secondarySoundEffectLoPtr   .BYTE <f5D65
secondarySoundEffectHiPtr   .BYTE >f5D65
;------------------------------------------------------------------
; PlaySoundEffects
;------------------------------------------------------------------
PlaySoundEffects
        LDA #$00
        STA indexToCurrentOrSecondarySoundEffectPtr
        LDA soundEffectInProgress
        BEQ DontDecrementSoundEffectProgressCounter
        DEC soundEffectInProgress
DontDecrementSoundEffectProgressCounter   
        LDA currentSoundEffectLoPtr
        STA soundTmpLoPtr
        LDA currentSoundEffectHiPtr
        STA soundTmpHiPtr
        JSR PlayFirstSoundEffect
        LDA #$02
        STA indexToCurrentOrSecondarySoundEffectPtr
        LDA secondarySoundEffectLoPtr
        STA soundTmpLoPtr
        LDA secondarySoundEffectHiPtr
        STA soundTmpHiPtr
        ;Falls through

;------------------------------------------------------------------
; PlayFirstSoundEffect
;------------------------------------------------------------------
PlayFirstSoundEffect
        LDY #$00
ClearSoundEffectDataStructureLoop   
        LDA (soundTmpLoPtr),Y
        STA soundEffectDataStructure,Y
        INY
        CPY #$05
        BNE ClearSoundEffectDataStructureLoop

        LDA sequenceControlByte
        BNE TrySequenceByteValueWithHighBitSet
        LDA dataforSoundEffectBuffer
        LDX nextEffectLoPtr
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte

PlayNextSound
        JSR PlaySecondSoundEffect
        LDA nextEffectHiPtr
        BEQ PlayFirstSoundEffect
        CMP #$01
        BNE StorePointersAndReturn
        RTS

StorePointersAndReturn   
        LDX indexToCurrentOrSecondarySoundEffectPtr
        LDA soundTmpLoPtr
        STA tmpSoundEffectLoPtr1,X
        LDA soundTmpHiPtr
        STA tmpSoundEffectHiPtr1,X
        RTS

;------------------------------------------------------------------
; PlaySecondSoundEffect
;------------------------------------------------------------------
PlaySecondSoundEffect
        LDA soundTmpLoPtr
        CLC
        ADC #$05
        STA soundTmpLoPtr
        LDX indexToCurrentOrSecondarySoundEffectPtr
        STA currentSoundEffectLoPtr,X
        LDA soundTmpHiPtr
        ADC #$00
        STA soundTmpHiPtr
        STA currentSoundEffectHiPtr,X
        RTS

TrySequenceByteValueWithHighBitSet   
        AND #$80
        BEQ TrySequenceByteValueOf1
        JMP TrySequenceByteValueOf80

TrySequenceByteValueOf1   
        LDA sequenceControlByte
        CMP #$01
        BNE TrySequenceByteValueOf2
        LDX offsetIntoSoundEffectBuffer
        LDA soundEffectBuffer,X
        CLC
        ADC dataforSoundEffectBuffer
        LDX nextEffectLoPtr
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP PlayNextSound

TrySequenceByteValueOf2   
        CMP #$02
        BNE TrySequenceByteValueOf3
        LDX offsetIntoSoundEffectBuffer
        LDA soundEffectBuffer,X
        SEC
        SBC dataforSoundEffectBuffer

PlaySecondSoundEffectLoop
        LDX nextEffectLoPtr
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP PlayNextSound

TrySequenceByteValueOf3   
        CMP #$03
        BNE TrySequenceByteValueOf4
        LDX offsetIntoSoundEffectBuffer
        LDY dataforSoundEffectBuffer
        LDA soundEffectBuffer,X
        CLC
        ADC soundEffectBuffer,Y
        JMP PlaySecondSoundEffectLoop

TrySequenceByteValueOf4   
        CMP #$04
        BNE TrySequenceByteValueOf5
        LDX offsetIntoSoundEffectBuffer
        LDY dataforSoundEffectBuffer
        LDA soundEffectBuffer,X
        SEC
        SBC soundEffectBuffer,Y
        JMP PlaySecondSoundEffectLoop

TrySequenceByteValueOf5   
        CMP #$05
        BNE TrySequenceByteValueOf6
        LDX offsetIntoSoundEffectBuffer
        LDA soundEffectBuffer,X
        SEC
        SBC dataforSoundEffectBuffer

StorePointersAndReturnIfZero
        STA soundEffectBuffer,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        BEQ JumpToPlaySecondSoundEffect
        LDA nextEffectLoPtr
        LDX indexToCurrentOrSecondarySoundEffectPtr
        STA currentSoundEffectLoPtr,X
        LDA nextEffectHiPtr
        STA currentSoundEffectHiPtr,X
        RTS

JumpToPlaySecondSoundEffect   
        JMP PlaySecondSoundEffect

TrySequenceByteValueOf6   
        CMP #$06
        BNE TrySequenceByteValueOf80
        LDX offsetIntoSoundEffectBuffer
        LDA soundEffectBuffer,X
        CLC
        ADC dataforSoundEffectBuffer
        JMP StorePointersAndReturnIfZero

TrySequenceByteValueOf80
        LDA sequenceControlByte
        CMP #$80
        BNE TrySequenceByteValueOf81
        LDX indexToCurrentOrSecondarySoundEffectPtr
        LDA dataforSoundEffectBuffer
        STA currentSoundEffectLoPtr,X
        LDA nextEffectLoPtr
        STA currentSoundEffectHiPtr,X
        RTS

TrySequenceByteValueOf81   
        CMP #$81
        BNE ReturnFromPlaySecondSoundEffect
        LDX indexToCurrentOrSecondarySoundEffectPtr
        LDA tmpSoundEffectLoHiPtr3,X
        BNE SoundEffectPresent
        LDA dataforSoundEffectBuffer
        STA tmpSoundEffectLoHiPtr3,X
SoundEffectPresent   
        DEC tmpSoundEffectLoHiPtr3,X
        BEQ JumpToPlaySecondSoundEffect_
        LDA tmpSoundEffectLoPtr1,X
        STA soundTmpLoPtr
        LDA tmpSoundEffectHiPtr1,X
        STA soundTmpHiPtr
        JMP PlayFirstSoundEffect

JumpToPlaySecondSoundEffect_   
        JMP PlaySecondSoundEffect

ReturnFromPlaySecondSoundEffect   
        RTS

gilbyWalkingSound         .BYTE $00,$00,$00,$04,$00
                          .BYTE $00,$00,$00,$05,$00
                          .BYTE $00,$00,$60,$06,$00
                          .BYTE $00,$00,$40,$01,$00
                          .BYTE $00,$00,$81,$04,$01
                          .BYTE $00,$00,$20,$04,$01
                          .BYTE $00,$00,$10,$01,$01
                          .BYTE $00,$00,$20,$01,$01
                          .BYTE $00,$80,<f7BCA,>f7BCA,$00
soundGilbyJumpOnLand      .BYTE $00,$00,$00,$04,$01
                          .BYTE $00,$00,$0F,$05,$00
                          .BYTE $00,$00,$F9,$06,$00
                          .BYTE $00,$00,$C0,$01,$00
                          .BYTE $00,$00,$21,$04,$01
                          .BYTE $00,$00,$10,$04,$02
                          .BYTE $01,$01,$41,$01,$01
                          .BYTE $00,$81,$30,$00,$00
                          .BYTE $00,$80,<f7BCA,>f7BCA,$00
pushedUpWhileOverSea      .BYTE $00,$00,$00,$04,$00
                          .BYTE $00,$00,$00,$05,$00
                          .BYTE $00,$00,$F9,$06,$00
                          .BYTE $00,$00,$20,$01,$00
                          .BYTE $00,$00,$81,$04,$01
                          .BYTE $00,$00,$10,$01,$01
                          .BYTE $00,$00,$10,$01,$00
                          .BYTE $00,$00,$20,$04,$00
                          .BYTE $00,$00,$06,$1F,$00
                          .BYTE $01,$01,$20,$01,$02
                          .BYTE $01,$02,$06,$01,$01
                          .BYTE $00,$81,$06,$00,$00
                          .BYTE $1F,$05,$01,$8E,$7B
                          .BYTE $00,$80,<f7BCA,>f7BCA,$00
                          .BYTE $00,$00,$00,$04,$00
                          .BYTE $00,$00,$AD,$05,$00
                          .BYTE $00,$00,$C0,$01,$00
                          .BYTE $00,$00,$5D,$06,$00
                          .BYTE $00,$00,$81,$04,$01
                          .BYTE $00,$00,$80,$04,$01
                          .BYTE $00,$80,<f7BCA,>f7BCA,$00
f7BCA                     .BYTE $00,$00,$0F,$18,$01
                          .BYTE $00,$80,<f7BCA,>f7BCA,$00
bulletSoundEffect         .BYTE $00,$00,$10,$08,$00
                          .BYTE $00,$00,$0F,$18,$01
                          .BYTE $00,$00,$00,$0C,$00
                          .BYTE $00,$00,$F0,$0D,$00
                          .BYTE $00,$00,$00,$13,$00
                          .BYTE $00,$00,$F0,$14,$00
                          .BYTE $00,$00,$C0,$0F,$00
                          .BYTE $00,$00,$21,$0B,$00
                          .BYTE $00,$00,$21,$12,$01
                          .BYTE $00,$00,$10,$0F,$00
                          .BYTE $0F,$02,$01,$0F,$00
                          .BYTE $08,$02,$01,$08,$01
                          .BYTE $08,$05,$00,$06,$7C
                          .BYTE $00,$00,$10,$0B,$00
                          .BYTE $00,$00,$20,$12,$02
                          .BYTE $00,$80,<f7BCA,>f7BCA,$00
airborneBulletSoundEffect .BYTE $00,$00,$00,$0C,$00
                          .BYTE $00,$00,$F0,$0D,$00
                          .BYTE $00,$00,$00,$13,$00
                          .BYTE $00,$00,$F0,$14,$00
                          .BYTE $00,$00,$0F,$18,$01
                          .BYTE $00,$00,$20,$08,$00
                          .BYTE $00,$00,$C0,$0F,$00
                          .BYTE $00,$00,$81,$0B,$00
                          .BYTE $00,$00,$81,$12,$02
                          .BYTE $08,$02,$02,$08,$00
                          .BYTE $0F,$01,$01,$0F,$01
                          .BYTE $00,$81,$02,$00,$00
                          .BYTE $00,$00,$11,$0B,$00
                          .BYTE $00,$00,$15,$12,$02
                          .BYTE $08,$02,$04,$08,$00
                          .BYTE $0F,$01,$02,$0F,$01
                          .BYTE $00,$81,$10,$00,$00
                          .BYTE $00,$00,$80,$0B,$00
                          .BYTE $00,$00,$80,$12,$00
                          .BYTE $00,$80,<f7BCA,>f7BCA,$00
borderFlashControl2       .BYTE $02
borderFlashControl1       .BYTE $01
currentEntropy            .BYTE $00

;------------------------------------------------------------------
; ResetSoundDataPtr1
;------------------------------------------------------------------
ResetSoundDataPtr1
        LDA #$00
        STA tmpSoundEffectLoHiPtr3
        RTS

;------------------------------------------------------------------
; ResetSoundDataPtr2
;------------------------------------------------------------------
ResetSoundDataPtr2
        LDA #$00
        STA tempSoundEffectLoHiPtr4
b7C96   RTS

;------------------------------------------------------------------
; UpdateAndAnimateAttackShips
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; UpdateAttackShipsXAndYPositions
;------------------------------------------------------------------
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
        STA upperPlanetAttackShipYPosUpdated + $01,X
        BNE b7D74
b7D6A   LDA #$6D
        STA upperPlanetAttackShip2YPos,X
        LDA #$01
        STA upperPlanetAttackShipYPosUpdated2 + $01,X
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
        STA upperPlanetAttackShipYPosUpdated2 +$07,X
        BNE b7DAF
b7DA5   LDA #$FF
        STA lowerPlanetAttackShip2YPos,X
        LDA #$01
        STA upperPlanetAttackShipYPosUpdated + $07,X
b7DAF   LDA #$00
        STA yPosMovementForLowerPlanetAttackShips - $01,X
b7DB4   DEC upperPlanetXPosFrameRateForAttackShip - $01,X
        BNE b7DF6
        LDA upperPlanetInitialXPosFrameRateForAttackShip - $01,X
        STA upperPlanetXPosFrameRateForAttackShip - $01,X
        LDA xPosMovementForUpperPlanetAttackShip - $01,X
        BMI b7DD9
        CLC
        ADC upperPlanetAttackShip2XPos,X
        STA upperPlanetAttackShip2XPos,X
        BCC b7DF6
        LDA upperPlanetAttackShip2MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA upperPlanetAttackShip2MSBXPosValue,X
        JMP b7DF6

b7DD9   EOR #$FF
        STA attackShipOffsetRate
        INC attackShipOffsetRate
        LDA upperPlanetAttackShip2XPos,X
        SEC
        SBC attackShipOffsetRate
        STA upperPlanetAttackShip2XPos,X
        BCS b7DF6
        LDA upperPlanetAttackShip2MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA upperPlanetAttackShip2MSBXPosValue,X
b7DF6   DEC lowerPlanetXPosFrameRateForAttackShip - $01,X
        BNE b7E38
        LDA lowerPlanetInitialXPosFrameRateForAttackShip - $01,X
        STA lowerPlanetXPosFrameRateForAttackShip - $01,X
        LDA xPosMovementForLowerPlanetAttackShip - $01,X
        BMI b7E1B
        CLC
        ADC lowerPlanetAttackShip3XPos,X
        STA lowerPlanetAttackShip3XPos,X
        BCC b7E38
        LDA lowerPlanetAttackSHip3MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA lowerPlanetAttackSHip3MSBXPosValue,X
        JMP b7E38

b7E1B   EOR #$FF
        STA attackShipOffsetRate
        INC attackShipOffsetRate
        LDA lowerPlanetAttackShip3XPos,X
        SEC
        SBC attackShipOffsetRate
        STA lowerPlanetAttackShip3XPos,X
        BCS b7E38
        LDA lowerPlanetAttackSHip3MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA lowerPlanetAttackSHip3MSBXPosValue,X
b7E38   RTS

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
lowerPlanetAttackShipInitialAnimationFrameRate    .BYTE $03,$03,$03,$03
;------------------------------------------------------------------
; AnimateAttackShipSprites
;------------------------------------------------------------------
AnimateAttackShipSprites
        LDA pauseModeSelected
        BEQ b7E6F
        RTS

b7E6F   DEC upperPlanetAttackShipAnimationFrameRate - $01,X
        BNE b7E8B
        LDA upperPlanetAttackShipInitialFrameRate - $01,X
        STA upperPlanetAttackShipAnimationFrameRate - $01,X
        INC upperPlanetAttackShip2SpriteValue,X
        LDA upperPlanetAttackShip2SpriteValue,X
        CMP upperPlanetAttackShipSpriteAnimationEnd - $01,X
        BNE b7E8B
        LDA upperPlanetAttackShipSpritesLoadedFromBackingData - $01,X
        STA upperPlanetAttackShip2SpriteValue,X

b7E8B   DEC lowerPlanetAttackShipAnimationFrameRate - $01,X
        BNE b7EA7
        LDA lowerPlanetAttackShipInitialAnimationFrameRate - $01,X
        STA lowerPlanetAttackShipAnimationFrameRate - $01,X
        INC lowerPlanetAttackShip2SpriteValue,X
        LDA lowerPlanetAttackShip2SpriteValue,X
        CMP lowerPlanetAttackShipSpriteAnimationEnd - $01,X
        BNE b7EA7
        LDA lowerPlanetAttackShipSpritesLoadedFromBackingData - $01,X
        STA lowerPlanetAttackShip2SpriteValue,X
b7EA7   RTS

;------------------------------------------------------------------
; DetectGameOrAttractMode
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; SelectRandomPlanetsForAttractMode
;------------------------------------------------------------------
SelectRandomPlanetsForAttractMode

        ; Select 9 random numbers between 0 and 15
        LDX #$09
b7EC5   JSR PutRandomByteInAccumulatorRegister
        AND #$0F
        STA currentLevelInTopPlanets,X
        DEX
        BPL b7EC5

        ; Select a random planet between 0 and 4
        JSR PutRandomByteInAccumulatorRegister
        AND #$03
        STA currentTopPlanetIndex

        ; Select a random planet between 0 and 4
        JSR PutRandomByteInAccumulatorRegister
        AND #$03
        STA currentBottomPlanetIndex
        RTS

; When attract mode is selected this gets set to $FF and gets 
; decremented every time a random joystick input is selected.
; When it reaches zero the main game loop will default to the
; high score screen.
attractModeCountdown       .BYTE $AD
randomJoystickInputCounter .BYTE $09
randomJoystickInput        .BYTE $09
;------------------------------------------------------------------
; GenerateJoystickInputForAttractMode
;------------------------------------------------------------------
GenerateJoystickInputForAttractMode
        LDA attractModeCountdown
        BNE b7EEA
        RTS

b7EEA   DEC randomJoystickInputCounter
        BNE b7F01
        JSR PutRandomByteInAccumulatorRegister
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
;------------------------------------------------------------------
; JumpToHiScoreScreen
;------------------------------------------------------------------
JumpToHiScoreScreen
        JMP InitAndDisplayHiScoreScreen

lastBlastScore         .TEXT "0000000...."
previousLastBlastScore .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;------------------------------------------------------------------
; JumpToDrawProgressDisplayScreen
;------------------------------------------------------------------
jumpToDrawProgressLoPtr   =*+$01
jumpToDrawProgressHiPtr   =*+$02
JumpToDrawProgressDisplayScreen   JMP DrawProgressDisplayScreen

;------------------------------------------------------------------
; The high score table.
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; InitAndDisplayHiScoreScreen
;------------------------------------------------------------------
InitAndDisplayHiScoreScreen
        STX tempHiPtr1
        LDA #$00
        STA hasDisplayedHiScoreScreen
        STY tempLoPtr1
        ; Fall through

;------------------------------------------------------------------
; DrawHiScoreScreen
;------------------------------------------------------------------
DrawHiScoreScreen
        SEI
        LDA #<HiScoreScreeInterruptHandler
        STA $0314    ;IRQ
        LDA #>HiScoreScreeInterruptHandler
        STA $0315    ;IRQ
        CLI
        LDA #$00
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
;------------------------------------------------------------------
; StoreLastBlastInTable
;------------------------------------------------------------------
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
        JMP StoreLastBlasScoreInTable

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
        BEQ StoreLastBlasScoreInTable
        LDA tempLoPtr1
        SEC
        SBC #$15
        STA tempLoPtr1
        LDA tempHiPtr1
        SBC #$00
        STA tempHiPtr1
        JMP StoreScoreLoop

;------------------------------------------------------------------
; StoreLastBlasScoreInTable
;------------------------------------------------------------------
StoreLastBlasScoreInTable
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
;------------------------------------------------------------------
; ClearScreenDrawHiScoreScreenText
;------------------------------------------------------------------
ClearScreenDrawHiScoreScreenText

        LDX #$00
bCA9F   LDA #$20
        STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0247,X
        LDA #WHITE
        STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA COLOR_RAM + $0247,X
        DEX
        BNE bCA9F

        LDX #$27
bCAC0   LDA txtHiScorLine1,X
        AND #$3F
        STA SCREEN_RAM + $0028,X
        LDA txtHiScorLine4,X
        AND #$3F
        STA SCREEN_RAM + $0258,X
        DEX
        BPL bCAC0

        LDX #$06
bCAD5   LDA lastBlastScore,X
        STA SCREEN_RAM + $0279,X
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
;------------------------------------------------------------------
; ClearScreenDrawHiScoreTextContinued
;------------------------------------------------------------------
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
        STA SCREEN_RAM + $02D0,X
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
;------------------------------------------------------------------
; GetHiScoreScreenInput
;------------------------------------------------------------------
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
        LDA $DC00    ;CIA1: Data Port Register A
        STA hiScoreJoystickInput
        AND #$04
        BNE bCBC4
        LDA hiScoreTableInputName - $0A,Y
        SEC
        SBC #$01
        CMP #$FF
        BNE bCBBC
bCBBC   STA hiScoreTableInputName - $0A,Y
        LDA #$3F
        JMP jCBD9

bCBC4   LDA hiScoreJoystickInput
        AND #$08
        BNE bCBE9
        LDA hiScoreTableInputName - $0A,Y
        CLC
        ADC #$01
        CMP #$40 ; $40 means no key was pressed
        BNE bCBD6
        LDA #$00
bCBD6   STA hiScoreTableInputName - $0A,Y

jCBD9
        LDA #$50
        STA tempLastBlastStorage
        LDX #$00
bCBDF   DEX
        BNE bCBDF
        DEC tempLastBlastStorage
        BNE bCBDF
        JMP GetHiScoreScreenInput

bCBE9   LDA hiScoreJoystickInput
        AND #$10
        BNE GetHiScoreScreenInput

bCBEF   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ bCBEF

        LDA #$C0
        STA tempLastBlastStorage

        LDX #$00
bCBFC   DEX
        BNE bCBFC
        DEC tempLastBlastStorage
        BNE bCBFC
        RTS

;------------------------------------------------------------------
; DisplayHiScoreScreen
;------------------------------------------------------------------
DisplayHiScoreScreen
        LDA #$01
        STA hasDisplayedHiScoreScreen
        LDA #$00
        STA storedLastBlastScore

        LDX #$27
bCC10   LDA txtHiScorLine3,X
        AND #$3F
        STA SCREEN_RAM + $02D0,X
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
;------------------------------------------------------------------
; ExitHiScoreScreen
;------------------------------------------------------------------
ExitHiScoreScreen
        LDX #$F8
        TXS
bCC8C   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ bCC8C
        JMP MainControlLoop

;------------------------------------------------------------------
; SetupHiScoreScreen
;------------------------------------------------------------------
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
        STA SCREEN_RAM + $02F8,X
        DEX
        BPL bCCE0
        BMI UpdateDisplayedHiScore


gameCompletionText   .TEXT "GAME COMPLETION CHART FOR ZARD, THE HERO"

;--------------------------------------------------------------------
; UpdateDisplayedHiScore   
;--------------------------------------------------------------------
UpdateDisplayedHiScore   
        LDY #$07
        LDX #$00
bCD19   LDA (tempLoPtr1),Y
        AND #$3F
        STA SCREEN_RAM + $0312,X
        INY
        INX
        CPX #$04
        BNE bCD19
        LDY #$06
bCD28   LDA (tempLoPtr1),Y
        STA SCREEN_RAM + $00E7,Y
        LDA #PURPLE
        STA COLOR_RAM + $00E7,Y
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
;------------------------------------------------------------------
; HiScoreScreeInterruptHandler
; Paints the color effects on the hi-score screen
;------------------------------------------------------------------
HiScoreScreeInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE bCD59
        PLA
        TAY
        PLA
        TAX
        PLA
        RTI

bCD59   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$F0
        STA $D012    ;Raster Position
        LDA hiScoreScreenUpdateRate
        BNE bCD6E
        JMP $EA31

bCD6E   LDX #$00
        LDY currHiScoreColorSeq1
bCD73   LDA hiScoreColorSequence,Y
        STA COLOR_RAM + $00A0,X
        STA COLOR_RAM + $00F0,X
        STA COLOR_RAM + $0140,X
        STA COLOR_RAM + $0190,X
        STA COLOR_RAM + $01E0,X
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
        STA COLOR_RAM + $00C8,X
        STA COLOR_RAM + $0118,X
        STA COLOR_RAM + $0168,X
        STA COLOR_RAM + $01B8,X
        STA COLOR_RAM + $0208,X
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
bCDCD   JMP $EA31

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
;------------------------------------------------------------------
; HiScoreCheckInput
;------------------------------------------------------------------
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

;------------------------------------------------------------------
; HiScoreStopSounds
;------------------------------------------------------------------
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
        LDA #>$4000
        STA $0319    ;NMI
        LDA #<$4000
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

;------------------------------------------------------------------
; InitializeActiveShipArray
;------------------------------------------------------------------
InitializeActiveShipArray
        LDX #$00
InitializeActiveShipLoop
        LDA <planet1Level1Data
        STA activeShipsWaveDataLoPtrArray,X
        LDA >planet1Level1Data
        STA activeShipsWaveDataHiPtrArray,X
        INX
        CPX #$10
        BNE InitializeActiveShipLoop
        RTS


; vim: tabstop=2 shiftwidth=2 expandtab
