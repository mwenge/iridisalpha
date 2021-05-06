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
attackWaveDataLoPtr                     = $40
attackWaveDataHiPtr                     = $41
tempVarStorage                          = $42
tempLoPtr3                              = $43
tempHiPtr3                              = $44
tmpPtrLo                                = $45
tmpPtrHi                                = $46
tmpPtrZp47                              = $47
energyChangeCounter                     = $4A
gameDataPtrLo                           = $4E
gameDataPtrHi                           = $4F
lastKeyPressed                          = $C5
currentLevelInTopPlanetsLoPtr           = $F0
currentLevelInTopPlanetsHiPtr           = $F1
aF8                                     = $F8
aF9                                     = $F9
aFA                                     = $FA
aFB                                     = $FB
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

BLACK                                   = $00
WHITE                                   = $01
RED                                     = $02
CYAN                                    = $03
PURPLE                                  = $04
GREEN                                   = $05
BLUE                                    = $06
YELLOW                                  = $07
ORANGE                                  = $08
BROWN                                   = $09
LTRED                                   = $0A
GRAY1                                   = $0B
GRAY2                                   = $0C
LTGREEN                                 = $0D
LTBLUE                                  = $0E
GRAY3                                   = $0F


* = $0801
;-----------------------------------------------------------------------------------------------------
; SYS 16384 ($4000)
; This launches the program from address $4000, i.e. MainControlLoop.
;-----------------------------------------------------------------------------------------------------
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
        JSR IA_SetupSound
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
        JSR IA_ClearScreen

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
        CMP #$40
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
; IA_ClearScreen
;------------------------------------------------------------------
IA_ClearScreen   
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
        JSR UpdateGilbyColorsInTitleScreenAnimation
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
gilbyColorsArray                       .BYTE $07,$05,$0E,$00,$02,$08
starFieldOffset                        .BYTE $04
                                       .BYTE $01,$0F,$0C,$0B

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
b0A78   LDA #$02
        STA COLOR_RAM + $0077,X
        LDA #$08
        STA COLOR_RAM + $009F,X
        LDA #$07
        STA COLOR_RAM + $00C7,X
        LDA #$05
        STA COLOR_RAM + $00EF,X
        LDA #$0E
        STA COLOR_RAM + $0117,X
        LDA #$04
        STA COLOR_RAM + $013F,X
        LDA #$06
        STA COLOR_RAM + $0167,X
        LDA #$00; Stripe character
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
; UpdateGilbyColorsInTitleScreenAnimation
;------------------------------------------------------------------
UpdateGilbyColorsInTitleScreenAnimation   
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
        JMP j0B94

b0B8B   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND titleScreenGilbiesMSBXPosOffset,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate

j0B94   
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

titleScreenGilbiesMSBXPosArray     .BYTE $01,$02,$04,$08,$10,$20,$40
titleScreenGilbiesMSBXPosOffset    .TEXT $FE,$FD,$FB,$F7,$EF,$DF,$BF
                                    ; IRIDIS ALPHA
currentTitleScreenGilbySpriteValue .TEXT $C1,$C9,$D2,$C9,$C4,$C9,$D3, " ",$C1,$CC,$D0,$C8,$C1
                                   .TEXT ".....  HARD AND FAST ZAPPIN"
titleScreenTextLine2               .TEXT "GPRESS FIRE TO BEGIN PLAY.. ONCE STARTED"
                                    ; F1 FOR PAUSE
titleScreenTextLine3               .TEXT ",",$C6, "1 ",$C6,$CF,$D2, " ",$D0,$C1,$D5,$D3,$C5, " "
                                    ; MODE. Q TO QU
                                   .TEXT $CD,$CF,$C4,$C5, "     ",$D1, " ",$D4,$CF, " ",$D1,$D5
                                    ; IT THE
                                   .TEXT $C9,$D4, " ",$D4,$C8,$C5, " GAM"
titleScreenTextLine4               .TEXT "ECREATED BY JEFF MINTER...SPACE EASY/HAR"
titleScreenTextLine5               .TEXT "DLAST GILBY HIT 0000000; MODE IS NOW EASY"
;------------------------------------------------------------------
; DrawTitleScreenText
;------------------------------------------------------------------
DrawTitleScreenText   
        LDX #$28
b0CE8   LDA currentTitleScreenGilbySpriteValue,X
        AND #$3F
        STA SCREEN_RAM + $01DF,X
        LDA titleScreenTextLine2,X
        AND #$3F
        STA SCREEN_RAM + $022F,X
        LDA titleScreenTextLine3,X
        AND #$3F
        STA SCREEN_RAM + $027F,X
        LDA titleScreenTextLine4,X
        AND #$3F
        STA SCREEN_RAM + $02CF,X
        LDA titleScreenTextLine5,X
        AND #$3F
        STA SCREEN_RAM + $031F,X

        LDA #$0C
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


; Data seeding generated music in title screen
titleMusicHiBytes   .BYTE $08,$08,$09,$09,$0A,$0B,$0B,$0C
                    .BYTE $0D,$0E,$0E,$0F,$10,$11,$12,$13
                    .BYTE $15,$16,$17,$19,$1A,$1C,$1D,$1F
                    .BYTE $21,$23,$25,$27,$2A,$2C,$2F,$32
                    .BYTE $35,$38,$3B,$3F,$43,$47,$4B,$4F
                    .BYTE $54,$59,$5E,$64,$6A,$70,$77,$7E
                    .BYTE $86,$8E,$96,$9F,$A8,$B3,$BD,$C8
                    .BYTE $D4,$E1,$EE,$FD
titleMusicLowBytes  .BYTE $61,$E1,$68,$F7,$8F,$30,$DA,$8F
                    .BYTE $4E,$18,$EF,$D2,$C3,$C3,$D1,$EF
                    .BYTE $1F,$60,$B5,$1E,$9C,$31,$DF,$A5
                    .BYTE $87,$86,$A2,$DF,$3E,$C1,$6B,$3C
                    .BYTE $39,$63,$BE,$4B,$0F,$0C,$45,$BF
                    .BYTE $7D,$83,$D6,$79,$73,$C7,$7C,$97
                    .BYTE $1E,$18,$8B,$7E,$FA,$06,$AC,$F3
                    .BYTE $E6,$8F,$F8,$2E
titleMusicNoteArray .BYTE $00,$07,$0C,$07
titleMusicNote3     .BYTE $01
titleMusicNote4     .BYTE $01
titleMusicNote5     .BYTE $25
titleMusicNote6     .BYTE $85
titleMusicNote7     .BYTE $00
titleMusicNote8     .BYTE $01
titleMusicNote9     .BYTE $02
titleMusicNoteA     .BYTE $02
titleMusicNoteB     .BYTE $0E
titleMusicNoteC     .BYTE $07
titleMusicNoteD     .BYTE $0E
;------------------------------------------------------------------
; PlayTitleScreenMusic
;------------------------------------------------------------------
PlayTitleScreenMusic   
        DEC MusicCounterOne
        BEQ b1504
        RTS 

b1504   LDA MusicCounterTwo
        STA MusicCounterOne
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
        JSR UpdateMusicCounters
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
b154E   DEC titleMusicNote4
        BNE b1570
        LDA #$0C
        STA titleMusicNote4
        LDX titleMusicNote8
        LDA titleMusicNoteArray,X
        CLC 
        ADC titleMusicNoteB
        STA titleMusicNoteD
        TAY 
        JSR PlayNoteVoice2
        INX 
        TXA 
        AND #$03
        STA titleMusicNote8
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
; IA_SetupSound
;------------------------------------------------------------------
IA_SetupSound   
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

titleMusicSeedArray .BYTE $00,$03,$06,$08,$00,$0C,$04,$08
                    .BYTE $00,$07,$00,$05,$05,$00,$00,$05
                    .BYTE $00,$06,$09,$05,$02,$04,$03,$04
                    .BYTE $03,$07,$03,$00,$04,$08,$0C,$09
                    .BYTE $07,$08,$04,$07,$00,$04,$07,$0E
                    .BYTE $00,$00,$00,$07,$07,$04,$00,$0C
                    .BYTE $04,$07,$00,$0C,$07,$08,$0A,$08
                    .BYTE $0C,$00,$0C,$03,$0C,$03,$07,$00
;------------------------------------------------------------------
; UpdateMusicCounters
;------------------------------------------------------------------
UpdateMusicCounters   
        JSR PutRandomByteInAccumulator
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
        STA MusicCounterOne
        STA MusicCounterTwo
        RTS 

MusicCounterOne               .BYTE $01
MusicCounterTwo               .BYTE $01
titleScreenSpriteCycleCounter .BYTE $04
;------------------------------------------------------------------
; TitleScreenCheckInput
;------------------------------------------------------------------
TitleScreenCheckInput   
        LDA lastKeyPressed
        CMP #$40
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
        CMP #$40
        BNE LoopUntilKeyReleased
b168E   RTS 
       
        ;F7 pressed?
b168F   CMP #$03
        BNE b168E
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
a16A5   =*+$01
        LDA sourceOfRandomBytes
        INC a16A5
        RTS 


.include "backingdata.asm"

*=$2000
.include "charset.asm"
.include "sprites.asm"

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
        STA energyLabelColorIndexTopPlanet
        STA energyLabelColorIndexBottomPlanet
        STA gilbyHasJustDied
        STA bonusPhaseEarned
        STA bonusPhaseCounter
        STA a4F57

        ; Point at the planet data for the first planet.
        ; The planet data starts at $8000. Each planet
        ; has 4 lines or layers.
        LDA #$80
        STA planetTextureTopLayerPtrHi
        LDA #$84
        STA planetTextureSecondFromTopLayerPtrHi
        LDA #$88
        STA planetTextureSecondFromBottomLayerPtrHi
        LDA #$8C
        STA planetTextureBottomLayerPtrHi

        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        JSR ClearPlanetTextureCharsets
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

someGameData .BYTE $A0,$50,$A7,$08,$A2,$D0,$9B,$A0
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
hasEnteredNewLevel           .BYTE $01
yPosMovementPatternForShips1 .BYTE $01,$02,$04,$08,$0A,$0C,$0E,$10
                             .BYTE $10,$10,$10,$10,$10,$10,$10,$14
yPosMovementPatternForShips2 .BYTE $FF,$FE,$FC,$F9,$F7,$F5,$F3,$F1
                             .BYTE $F0,$F0,$F0,$F0,$F0,$F0

; Pointers to:
; a50F0
; a50EC
; aA078
attackWaveDataLoPtrArray .BYTE $F0,$EC,$78,$78,$78,$78,$00,$00
                      .BYTE $78,$78
attackWaveDataHiPtrArray .BYTE $50,$50,$A0,$A0,$A0,$A0,$00,$00
                      .BYTE $A0,$A0

; This is level data, one entry for each level per planet
f4883   .BYTE $A0,$A0,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f488D   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f4897   .BYTE $00,$00,$02,$02,$02,$02,$00,$00
        .BYTE $02,$02
f48A1   .BYTE $02,$02,$00,$00,$00,$00,$FF,$FF
        .BYTE $00,$00

upperPlanetAttackShipYPosUpdated   .BYTE $00,$00,$00,$00,$00,$00,$00
f48B2   .BYTE $00,$00,$00

upperPlanetAttackShipYPosUpdated2   .BYTE $00,$00,$00,$00,$00,$00,$00
f48BC   .BYTE $00,$00,$00
f48BF   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
shipsThatHaveCollidedWithGilby   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
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

;------------------------------------------------------------------
; Put00orFFinAccumulator
;------------------------------------------------------------------
Put00orFFinAccumulator
        LDA attackWaveDataHiPtrArray,X
        BEQ b49B5
        LDA levelEntrySequenceActive
        BNE b49B2
        INX 
        CPX #$06
        BEQ b49B2
        CPX #$0C
        BEQ b49B2
        BNE Put00orFFinAccumulator

b49B2   LDA #$00
        RTS 

b49B5   LDA #$FF
b49B7   RTS 

previousAttackWaveLoPtr                                         .BYTE $A0
previousAttackWaveHiPtr                                         .BYTE $A0
previousAttackWaveLoPtr2                                         .BYTE $58
previousAttackWaveHiPtr2                                         .BYTE $1E
enemiesKilledTopPlanetsSinceLastUpdate        .BYTE $28,$00,$00,$00
enemiesKilledTopPlanetsSinceLastUpdatePtr     .BYTE $00
enemiesKilledBottomsPlanetsSinceLastUpdate    .BYTE $18,$00,$00,$00
enemiesKilledBottomsPlanetsSinceLastUpdatePtr .BYTE $00
currentLevelInTopPlanets                      .BYTE $06,$02,$06,$0A
currentLevelInTopPlanetsPtr                   .BYTE $08
currentLevelInBottomPlanets                   .BYTE $09,$0E,$0A,$0B,$01
a49D0                                         .BYTE $04
a49D1                                         .BYTE $04
a49D2                                         .BYTE $00
a49D3                                         .BYTE $00

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
        BEQ ProcessAttackWaveData
b49F5   RTS 

gameSequenceCounter   .BYTE $14

;---------------------------------------------------------------------------------
; ProcessAttackWaveData   
;---------------------------------------------------------------------------------
ProcessAttackWaveData   
        LDA #$20
        STA gameSequenceCounter
        LDX #$02
        JSR Put00orFFinAccumulator
        BEQ b4A1F

        LDA a49D0
        CMP a49D2
        BEQ b4A1F
        LDA previousAttackWaveLoPtr
        STA attackWaveDataLoPtrArray,X
        LDA previousAttackWaveHiPtr
        STA attackWaveDataHiPtrArray,X
        TXA 
        TAY 
        JSR UpdateBackingDataPtr
        INC a49D2

b4A1F   LDX #$08
        JSR Put00orFFinAccumulator
        BEQ b49B7 ; Returns early

        LDA a49D1
        CMP a49D3
        BEQ b49B7 ; Returns early

        LDA previousAttackWaveLoPtr2
        STA attackWaveDataLoPtrArray,X
        LDA previousAttackWaveHiPtr2
        STA attackWaveDataHiPtrArray,X
        TXA 
        CLC 
        ADC #$02
        TAY 
        INC a49D3
        ; Falls through

;------------------------------------------------------------------
; UpdateBackingDataPtr
;------------------------------------------------------------------
UpdateBackingDataPtr   
        LDA attackWaveDataLoPtrArray,X
        STA attackWaveDataLoPtr
        LDA attackWaveDataHiPtrArray,X
        STA attackWaveDataHiPtr
        LDA #$00
        STA updatingWaveData
        STA shipsThatHaveCollidedWithGilby,X
        STY a48D5
        ; Falls through

;------------------------------------------------------------------
; UpdateWaveDataFromBackingStore
;------------------------------------------------------------------
UpdateWaveDataFromBackingStore   
        ; X is the index of the current level on the planet.
        LDY #$00
        LDA (attackWaveDataLoPtr),Y
        STA upperPlanetAttackShipsColorArray + $01,X

        LDY #$06
        LDA (attackWaveDataLoPtr),Y
        STA f48A1,X

        LDY #$0B
        LDA (attackWaveDataLoPtr),Y
        STA f488D,X

        LDA #$00
        STA f4883,X

        LDY #$0F
        LDA (attackWaveDataLoPtr),Y
        STA f4897,X

        ; Load the sprite value.
        LDY #$01
        LDA (attackWaveDataLoPtr),Y
        STA upperPlanetAttackShipsSpriteValueArray + $01,X

        ; Store the sprite value in the storage used to reload the game
        ; from pause mode or a restart.
        TXA 
        TAY 
        LDX orderForUpdatingPositionOfAttackShips,Y
        LDY #$01
        LDA (attackWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,X

        LDY #$02
        LDA (attackWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpriteAnimationEnd,X

        LDY #$03
        LDA (attackWaveDataLoPtr),Y
        STA upperPlanetAttackShipAnimationFrameRate,X
        STA upperPlanetAttackShipInitialFrameRate,X

        ; Check if the level is a multiple of 3, if it's not
        ; we'll fall through and load some alternative sprites.
        TXA 
        AND #$04
        BEQ b4AB9

        INY 
        ; Y is now 4
        LDA (attackWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,X

        INY 
        ; Y is now 5
        LDA (attackWaveDataLoPtr),Y
        STA upperPlanetAttackShipSpriteAnimationEnd,X

        TXA 
        TAY 
        LDA indexForWaveData,X
        TAY 
        LDA upperPlanetAttackShipSpritesLoadedFromBackingData,X
        STA upperPlanetAttackShipsSpriteValueArray + $01,Y

        ; Load the x-pos movement for the attack ship.
b4AB9   LDY #$12
        LDA (attackWaveDataLoPtr),Y
        CMP #$80
        BEQ b4AC4
        STA xPosMovementForUpperPlanetAttackShip,X

b4AC4   INY 
        ; Y is now 19 ($13). This has the Y-Pos movement for the
        ; attack ship.
        LDA (attackWaveDataLoPtr),Y
        CMP #$80
        BEQ b4AFA
        AND #$F0
        CMP #$20
        BEQ b4AD6
        LDA (attackWaveDataLoPtr),Y
        JMP LoadYPosForAttackShip

b4AD6   TXA 
        STX a5529
        AND #$04
        BNE b4AEC
        LDA (attackWaveDataLoPtr),Y
        AND #$0F
        TAX 
        LDA yPosMovementPatternForShips2,X
        LDX a5529
        JMP LoadYPosForAttackShip

b4AEC   LDA (attackWaveDataLoPtr),Y
        AND #$0F
        TAX 
        LDA yPosMovementPatternForShips1,X
        LDX a5529

LoadYPosForAttackShip   
        STA yPosMovementForUpperPlanetAttackShips,X

b4AFA   INY 
        ; Y is now 20 ($14)
        LDA (attackWaveDataLoPtr),Y
        CMP #$80
        BEQ b4B07
        STA upperPlanetInitialXPosFrameRateForAttackShip,X
        STA upperPlanetXPosFrameRateForAttackShip,X

b4B07   INY 
        ; Y is now 21 ($15)
        LDA (attackWaveDataLoPtr),Y
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
b4B1C   LDY a48D5
        LDA indexForWaveData,X
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
        LDY #$06
        LDA (attackWaveDataLoPtr),Y
        BNE b4B59
        LDY #$08
        LDA (attackWaveDataLoPtr),Y
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
        LDY #$06
        LDA (attackWaveDataLoPtr),Y
        BNE b4B7A
        LDY #$08
        LDA (attackWaveDataLoPtr),Y
        BEQ b4B7A

        LDA #$90
        LDY tmpPtrLo
        STA upperPlanetAttackShipsYPosArray + $01,Y

b4B7A   RTS 

orderForUpdatingPositionOfAttackShips          .BYTE $00,$00,$00,$01,$02,$03,$00,$00
                                               .BYTE $04,$05,$06,$07
indexForWaveData                               .BYTE $02,$03,$04,$05,$08,$09,$0A,$0B
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

b4BC7   LDX indexForWaveData,Y
        LDA attackWaveDataHiPtrArray,X
        BEQ b4BD6
        STY tempVarStorage
        JSR ProcessAttackWaves
        LDY tempVarStorage
b4BD6   INY 
        CPY #$08
        BNE b4BC7

        LDA hasEnteredNewLevel
        BEQ b4BEB
        LDA #$00
        STA a49D2
        STA a49D3
        STA hasEnteredNewLevel
b4BEB   RTS 

;------------------------------------------------------------------
; ProcessAttackWaves
;------------------------------------------------------------------
ProcessAttackWaves   
        ; X is the current value in indexForWaveData
        STA attackWaveDataHiPtr
        LDA attackWaveDataLoPtrArray,X
        STA attackWaveDataLoPtr
        LDA hasEnteredNewLevel
        BEQ b4C03

        ; We've entered a new level.
        ; Get the wave data from the wave data store and return
        LDA #>attackWaveData
        STA attackWaveDataHiPtr
        LDA #<attackWaveData
        STA attackWaveDataLoPtr
        JMP GetWaveDataForNewLevel
        ; Returns

        
b4C03   LDA f48BF,X
        BNE MoveToNewPlanet
        JMP CheckForCollisionsBeforeUpdatingWaveData
        ; Returns

;---------------------------------------------------------------------------------
; MoveToNewPlanet 
;---------------------------------------------------------------------------------
MoveToNewPlanet 
        LDA #$00
        STA f48BF,X
        LDA #<p48E9
        STA soundDataAE
        LDA #>p48E9
        STA soundDataAF
        JSR ResetSoundDataPtr2
        LDA #$1C
        STA a48D7
        TXA 
        PHA 
        AND #$08
        BNE b4C5C
        LDA levelEntrySequenceActive
        BNE b4C42
        LDA inAttractMode
        BNE b4C42
        INC currentTopPlanetIndex
        LDA currentTopPlanetIndex
        CMP currentTopPlanet
        BNE b4C42

        LDA #$00
        STA currentTopPlanetIndex
b4C42   LDY #$22
        LDA (attackWaveDataLoPtr),Y
        JSR CalculatePointsForByte2
        CLC 
        ADC pointsEarnedTopPlanetByte1
        STA pointsEarnedTopPlanetByte1
        LDA pointsEarnedTopPlanetByte2
        ADC pointsToAddToPointsEarnedByte2
        STA pointsEarnedTopPlanetByte2
        JMP j4C8D

b4C5C   LDA levelEntrySequenceActive
        BNE b4C76
        LDA inAttractMode
        BNE b4C76
        INC currentBottomPlanetIndex
        LDA currentBottomPlanetIndex
        CMP currentBottomPlanet
        BNE b4C76
        LDA #$00
        STA currentBottomPlanetIndex
b4C76   LDY #$22
        LDA (attackWaveDataLoPtr),Y
        JSR CalculatePointsForByte2
        CLC 
        ADC pointsEarnedBottomPlanetByte1
        STA pointsEarnedBottomPlanetByte1
        LDA pointsEarnedBottomPlanetByte2
        ADC pointsToAddToPointsEarnedByte2
        STA pointsEarnedBottomPlanetByte2

j4C8D   
        JSR DrawPlanetProgressPointers
        PLA 
        TAX 
        LDY #$22
        LDA (attackWaveDataLoPtr),Y
        BEQ b4CB1
        LDA inAttractMode
        BNE b4CB1
        TXA 
        AND #$08
        BNE b4CAB
        JSR IncreaseEnergyTopOnly
        JSR UpdateTopPlanetProgressData
        JMP b4CB1

b4CAB   JSR UpdateBottomPlanetProgressData
        JSR IncreaseEnergyBottomOnly

b4CB1   LDY #$1D
        LDA (attackWaveDataLoPtr),Y
        BEQ CheckForCollisionsBeforeUpdatingWaveData
        DEY 
        JMP UpdatePointersAndGetWaveDataForNewLevel
        ;Returns

;---------------------------------------------------------------------------------
; CheckForCollisionsBeforeUpdatingWaveData   
;---------------------------------------------------------------------------------
CheckForCollisionsBeforeUpdatingWaveData   
        LDA shipsThatHaveCollidedWithGilby,X
        BEQ UpdateWaves
        LDA #$00
        STA shipsThatHaveCollidedWithGilby,X
        LDY #$1F
        LDA (attackWaveDataLoPtr),Y
        BEQ UpdateWaves
        LDY #$0E
        LDA (attackWaveDataLoPtr),Y
        BEQ b4CE2
        TXA 
        AND #$08
        BNE b4CDF
        DEC a49D2
        JMP b4CE2

;---------------------------------------------------------------------------------
; UpdateWaves 
;---------------------------------------------------------------------------------
UpdateWaves 
        JMP UpdateFromBackingData
        ; Returns

;---------------------------------------------------------------------------------
; b4CDF   
;---------------------------------------------------------------------------------
b4CDF   
        DEC a49D3
        ; Falls through
;---------------------------------------------------------------------------------
; b4CE2   
;---------------------------------------------------------------------------------
b4CE2   
        LDY #$24
        LDA (attackWaveDataLoPtr),Y
        BNE b4CEB
        JMP UpdateEnergyLevelsAndStartNewLevel
        ;Returns

b4CEB   
        LDA joystickInput
        AND #$10
        BEQ UpdateWaves
        LDA lowerPlanetActivated
        BNE UpdateWaves
        LDA a4F57
        BNE b4D0D
        JSR ResetSoundDataPtr1
        LDA #<p6362
        STA soundDataAC
        LDA #>p6362
        STA soundDataAD
        LDA #$08
        BNE b4D1C
b4D0D   JSR ResetSoundDataPtr1
        LDA #<p6335
        STA soundDataAC
        LDA #>p6335
        STA soundDataAD

        LDA #$00
b4D1C   STA a4F57
        LDA #$00
        STA a7C8A
        LDA #$08
        STA upperPlanetEntropyStatus
        STA lowerPlanetEntropyStatus
        LDA #$05
        STA gilbyExploding
        LDA #$04
        STA starFieldInitialStateArray - $01
        ; Falls through

;---------------------------------------------------------------------------------
; UpdateEnergyLevelsAndStartNewLevel   
;---------------------------------------------------------------------------------
UpdateEnergyLevelsAndStartNewLevel   
        LDY #$23
        LDA (attackWaveDataLoPtr),Y
        BEQ b4D7F
        LDA #<p4961
        STA soundDataAC
        LDA #>p4961
        STA soundDataAD
        JSR ResetSoundDataPtr1
        LDA #$0E
        STA gilbyExploding
        LDA #$02
        STA starFieldInitialStateArray - $01
        LDA starFieldAnimationOffset
        EOR #$FF
        CLC 
        ADC #$01
        STA starFieldAnimationOffset
        LDA a4F57
        BEQ b4D72
        LDA energyLabelColorIndexBottomPlanet
        BNE b4D7F
        LDA (attackWaveDataLoPtr),Y
        JSR UpdateEnergyLabelColorIndexFromBounties
        STA energyLabelColorIndexBottomPlanet
        BNE b4D7F
b4D72   LDA energyLabelColorIndexTopPlanet
        BNE b4D7F
        LDA (attackWaveDataLoPtr),Y
        JSR UpdateEnergyLabelColorIndexFromBounties
        STA energyLabelColorIndexTopPlanet
b4D7F   LDY #$1E
        JMP UpdatePointersAndGetWaveDataForNewLevel
        ; Returns

;------------------------------------------------------------------
; UpdateFromBackingData
;------------------------------------------------------------------
UpdateFromBackingData   
        LDA upperPlanetAttackShipYPosUpdated,X
        BEQ b4D98
        LDA #$00
        STA upperPlanetAttackShipYPosUpdated,X
        LDY #$19
        LDA (attackWaveDataLoPtr),Y
        BEQ b4D98
        DEY 
        JMP UpdatePointersAndGetWaveDataForNewLevel

b4D98   LDA upperPlanetAttackShipYPosUpdated2,X
        BEQ b4DAC
        LDA #$00
        STA upperPlanetAttackShipYPosUpdated2,X
        LDY #$1B
        LDA (attackWaveDataLoPtr),Y
        BEQ b4DAC
        DEY 
        JMP UpdatePointersAndGetWaveDataForNewLevel

b4DAC   LDA joystickInput
        AND #$10
        BNE b4DBD
        LDY #$21
        LDA (attackWaveDataLoPtr),Y
        BEQ b4DBD
        DEY 
        JMP UpdatePointersAndGetWaveDataForNewLevel

b4DBD   LDA f4897,X
        BEQ UpdateAttackShipData
        DEC f4897,X
        BNE UpdateAttackShipData
        LDY #$0E
        LDA (attackWaveDataLoPtr),Y
        BEQ b4DDB
        TXA 
        AND #$08
        BNE b4DD8
        DEC a49D2
        JMP b4DDB

b4DD8   DEC a49D3
b4DDB   LDY #$10

;---------------------------------------------------------------------------------
; UpdatePointersAndGetWaveDataForNewLevel   
;---------------------------------------------------------------------------------
UpdatePointersAndGetWaveDataForNewLevel   
        LDA (attackWaveDataLoPtr),Y
        PHA 
        INY 
        LDA (attackWaveDataLoPtr),Y
        BEQ GetDefaultWaveData
        STA attackWaveDataHiPtrArray,X
        STA attackWaveDataHiPtr
        PLA 
        STA attackWaveDataLoPtr
        STA attackWaveDataLoPtrArray,X

;---------------------------------------------------------------------------------
; GetWaveDataForNewLevel   
;---------------------------------------------------------------------------------
GetWaveDataForNewLevel   
        LDA #$FF
        STA updatingWaveData
        JSR UpdateWaveDataFromBackingStore
        LDA #$00
        STA updatingWaveData
        RTS 

;---------------------------------------------------------------------------------
; GetDefaultWaveData   
;---------------------------------------------------------------------------------
GetDefaultWaveData   
        LDA #$F0
        STA upperPlanetAttackShipsSpriteValueArray + $01,X
        PHA 
        LDA #$00
        STA attackWaveDataHiPtrArray,X
        LDY orderForUpdatingPositionOfAttackShips,X
        PLA 
        STA upperPlanetAttackShipSpritesLoadedFromBackingData,Y
        LDA #$F1
        STA upperPlanetAttackShipSpriteAnimationEnd,Y
        PLA 
        RTS 

a4E17               .BYTE $00
updatingWaveData    .BYTE $00
currentTopPlanet    .BYTE $01
currentBottomPlanet .BYTE $01

;---------------------------------------------------------------------------------
; UpdateAttackShipData   
;---------------------------------------------------------------------------------
UpdateAttackShipData   
        LDY #$0A
        LDA (attackWaveDataLoPtr),Y
        BEQ b4E73
        DEC f488D,X
        BNE b4E73
        STA tempHiPtr3
        DEY 
        LDA (attackWaveDataLoPtr),Y
        STA tempLoPtr3
        LDY #$0B
        LDA (attackWaveDataLoPtr),Y
        STA f488D,X
        LDY f4883,X
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
        LDA indexForWaveData,X
        TAX 
        TYA 
        STA f4883,X
        JMP b4E73

b4E6A   LDY #$0C
        LDA indexForWaveData,X
        TAX 
        JMP UpdatePointersAndGetWaveDataForNewLevel

b4E73   LDY #$17
        LDA (attackWaveDataLoPtr),Y
        BEQ b4EC7
        CLC 
        ADC gilbyVerticalPosition
        STA a4E17
        LDA orderForUpdatingPositionOfAttackShips,X
        TAX 
        LDA upperPlanetYPosFrameRateForAttackShips,X
        CMP #$01
        BNE b4EC3
        LDA (attackWaveDataLoPtr),Y
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
b4EA6   LDA indexIntoUpperPlanetAttackShipsYPosArray,X
        TAX 
        LDA upperPlanetAttackShipsYPosArray + $01,X
        PHA 
        LDA indexIntoYPosMovementForUpperPlanetAttackShips,X
        TAX 
        PLA 
        CMP a4E17
        BEQ b4EC3
        BMI b4EC0
        DEC yPosMovementForUpperPlanetAttackShips,X
        DEC yPosMovementForUpperPlanetAttackShips,X
b4EC0   INC yPosMovementForUpperPlanetAttackShips,X
b4EC3   LDA indexForWaveData,X
        TAX 
b4EC7   LDY #$16
        LDA (attackWaveDataLoPtr),Y
        BEQ b4F05
        CLC 
        ADC #$58
        STA a4E17
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
        CMP a4E17
        BMI b4EFE
        DEC xPosMovementForUpperPlanetAttackShip,X
        DEC xPosMovementForUpperPlanetAttackShip,X
b4EFE   INC xPosMovementForUpperPlanetAttackShip,X
b4F01   LDA indexForWaveData,X
        TAX 
b4F05   LDY #$06
        LDA (attackWaveDataLoPtr),Y
        BEQ b4F55
        DEC f48A1,X
        BNE b4F55
        LDA (attackWaveDataLoPtr),Y
        STA f48A1,X
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
b4F2D   JSR Put00orFFinAccumulator
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
        JMP UpdatePointersAndGetWaveDataForNewLevel

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
;------------------------------------------------------------------
; UpdateAttackShipsPosition
;------------------------------------------------------------------
UpdateAttackShipsPosition   
        LDA a4F57
        TAY 
        AND #$08
        BEQ b4F65
        DEY 
        DEY 
b4F65   LDA upperPlanetAttackShipsMSBXPosArray + $01,Y
        BMI b4F89
        LDY a4F57
        LDA upperPlanetAttackShipsMSBXPosArray + $01,Y
        CLC 
        BEQ b4F74
        SEC 
b4F74   LDA upperPlanetAttackShipsXPosArray + $01,Y
        ROR 
        STA a4F58
        LDA upperPlanetAttackShipsYPosArray + $01,Y
        STA a4F59
        LDA #$00
        STA a48D6
        JSR UpdateAttackShipsMSBXPosition
b4F89   LDA upperPlanetAttackShipsMSBXPosArray + $02,Y
        BMI b4F56
        CLC 
        BEQ b4F92
        SEC 
b4F92   LDA upperPlanetAttackShipsXPosArray + $02,Y
        ROR 
        STA a4F58
        LDA upperPlanetAttackShipsYPosArray + $02,Y
        STA a4F59
        LDA #$01
        STA a48D6
        ; Falls through

;------------------------------------------------------------------
; UpdateAttackShipsMSBXPosition
;------------------------------------------------------------------
UpdateAttackShipsMSBXPosition   
        TYA 
        TAX 
        INX 
        INX 

j4FA8   
        STX tempLoPtr3
        LDA indexIntoAttackWaveDataHiPtrArray,X
        TAX 
        LDA attackWaveDataHiPtrArray,X
        BNE b4FB6
        JMP j501B

b4FB6   LDX tempLoPtr3
        CLC 
        LDA upperPlanetAttackShipsMSBXPosArray + $01,X
        BEQ b4FBF
        SEC 
b4FBF   LDA upperPlanetAttackShipsXPosArray + $01,X
        ROR 
        SEC 
        SBC a4F58
        BPL b4FCB
        EOR #$FF
b4FCB   CMP #$08
        BMI b4FD2
        JMP j501B

b4FD2   LDA upperPlanetAttackShipsYPosArray + $01,X
        SEC 
        SBC a4F59
        BPL b4FDD
        EOR #$FF
b4FDD   CMP #$10
        BMI b4FE4
        JMP j501B

b4FE4   LDA indexIntoAttackWaveDataHiPtrArray,X
        TAX 
        LDA attackWaveDataLoPtrArray,X
        STA attackWaveDataLoPtr
        LDA attackWaveDataHiPtrArray,X
        STA attackWaveDataHiPtr
        STY tempVarStorage
        LDY #$1D
        LDA (attackWaveDataLoPtr),Y
        LDY tempVarStorage
        CMP #$00
        BEQ j501B
        LDA #$FF
        STA f48BF,X
        TYA 
        PHA 
        CLC 
        ADC a48D6
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

j501B   
        LDX tempLoPtr3
        INX 
        CPX #$06
        BEQ b5029
        CPX #$0E
        BEQ b5029
        JMP j4FA8

b5029   RTS 

;------------------------------------------------------------------
; DetectAttackShipCollisionWithGilby
;------------------------------------------------------------------
DetectAttackShipCollisionWithGilby   
        LDY #$00
        LDA levelEntrySequenceActive
        BNE b5029
        LDA inAttractMode
        BNE b5029
        LDA a4F57
        BEQ b503C
        INY 
b503C   LDX a4F57
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
        STA shipsThatHaveCollidedWithGilby,X
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
                   .BYTE $20,$20,$20,$20,$20,$20,$20
controlPanelColors .BYTE $20,$09,$09,$00,$01,$01,$01,$01
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

; This is the hiptr (e.g. $9200, $9000) array into some planet data.
somePlanetDataHiPtrArray              .BYTE $92,$90,$94,$96,$98
;------------------------------------------------------------------
; UpdatePlanetProgress
;------------------------------------------------------------------
UpdatePlanetProgress   
        LDX currentTopPlanetIndex
        LDA somePlanetDataHiPtrArray,X
        STA currentTopPlanetDataHiPtr
        LDA #$00
        STA currentTopPlanetDataLoPtr
        LDX currentBottomPlanetIndex
        LDA somePlanetDataHiPtrArray,X
        STA currentBottomPlanetDataHiPtr
        LDA #$00
        STA currentBottomPlanetDataLoPtr
        JSR InitializeSomeGameStorage

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
b5208   LDA #$ED
        STA upperPlanetAttackShipSpritesLoadedFromBackingData - $01,X
        LDA #$F0
        STA upperPlanetAttackShipSpriteAnimationEnd - $01,X
        LDA f5270,X
        STA f9FF7,X
        DEX 
        BNE b5208

        STX shouldResetPlanetEntropy
        JSR ResetSoundDataPtr1
        JSR ResetSoundDataPtr2

        LDA #<p5D33
        STA soundDataAE
        LDA #>p5D33
        STA soundDataAF
        LDA #<p5D7E
        STA soundDataAC
        LDA #>p5D7E
        STA soundDataAD
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
f5270   .BYTE $01,$00,$00,$01,$01,$00,$04,$20
        .BYTE $00
shouldResetPlanetEntropy   .BYTE $00,$08,$08
unusedVariable1   .BYTE $00
unusedVariable3   .BYTE $00
controlPanelIsGrey   .BYTE $01
planetProgressPointersOffsets   .BYTE $01,$03,$05,$07,$09

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
b5298   LDA controlPanelColors,X
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
        LDA #$0B ; Gray
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

;------------------------------------------------------------------
; InitializeSomeGameStorage
; Writes storage for top and bottom planets to $0763 and $0783
;------------------------------------------------------------------
InitializeSomeGameStorage   
        LDA #$07
        STA tmpPtrZp47 ; Actually the hi ptr here
        LDA #$63
        STA tmpPtrHi ; Actually the lo ptr here

        ; For the top planet
        LDX currentTopPlanetIndex
        JSR InitSomeGameStorage

        ; For the bottom planet
        LDA #$B3
        STA tmpPtrHi
        LDX currentBottomPlanetIndex

;------------------------------------------------------------------
; InitSomeGameStorage
;------------------------------------------------------------------
InitSomeGameStorage   
        TXA 
        ASL 
        ASL 
        CLC 
        ADC #$9A
        LDY #$00
        STA (tmpPtrHi),Y
        LDY #$28
        CLC 
        ADC #$01
        STA (tmpPtrHi),Y
        LDY #$01
        CLC 
        ADC #$01
        STA (tmpPtrHi),Y
        LDY #$29
        CLC 
        ADC #$01
        STA (tmpPtrHi),Y
        LDA #$DB
        STA tmpPtrZp47
        LDA somethingStorageForPlanets,X
        LDY #$00
        STA (tmpPtrHi),Y
        INY 
        STA (tmpPtrHi),Y
        LDY #$28
        STA (tmpPtrHi),Y
        INY 
        STA (tmpPtrHi),Y
        LDA #$07
        STA tmpPtrZp47
        RTS 

somethingStorageForPlanets   .BYTE $07,$04,$0E,$08,$0A
pointsEarnedTopPlanetByte1   .BYTE $00
pointsEarnedTopPlanetByte2   .BYTE $00
pointsEarnedBottomPlanetByte1   .BYTE $00
pointsEarnedBottomPlanetByte2   .BYTE $00
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

currEnergyTop                     .BYTE $03
currEnergyBottom                  .BYTE $03
currCoreEnergyLevel               .BYTE $00
energyLabelColorIndexTopPlanet    .BYTE $00
energyLabelColorIndexBottomPlanet .BYTE $00
;------------------------------------------------------------------
; DecreaseEnergyStorage
;------------------------------------------------------------------
DecreaseEnergyStorage   
        DEC updateEnergyStorageInterval
        BNE b53B3
        LDA #$04
        STA updateEnergyStorageInterval

        LDA energyLabelColorIndexTopPlanet
        BEQ b53FB

        ;Color the 'Energy' label.
        DEC energyLabelColorIndexTopPlanet
        LDX energyLabelColorIndexTopPlanet
        LDA energyLabelColors,X
        LDY #$04
b53D3   STA COLOR_RAM + $034A,Y
        DEY 
        BNE b53D3

        LDX currEnergyTop
        INC SCREEN_RAM + $0373,X
        LDA SCREEN_RAM + $0373,X
        CMP #$88
        BNE b53FB
        LDA #$20
        STA SCREEN_RAM + $0373,X
        DEX 
        STX currEnergyTop
        CPX #$FF
        BNE b53FB

GilbyDiedBecauseEnergyDepleted
        LDA #$00
        STA reasonGilbyDied ; Energy Depleted
        JMP GilbyDied

b53FB   LDA energyLabelColorIndexBottomPlanet
        BEQ b542B

        DEC energyLabelColorIndexBottomPlanet
        LDX energyLabelColorIndexBottomPlanet

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

energyLabelColors           .BYTE $01,$06,$02,$04,$05,$03,$07,$01
                            .BYTE $00,$06,$02,$04,$05,$03,$07,$01
                            .BYTE $06
updateEnergyStorageInterval .BYTE $01

;------------------------------------------------------------------
; DepleteEnergyTop
;------------------------------------------------------------------
DepleteEnergyTop   
        STX a5529
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
        STX a5529
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
b547B   LDX a5529
        RTS 

b547F   LDA #$01
        STA reasonGilbyDied ; Overload (too much energy)
        JMP GilbyDied

;------------------------------------------------------------------
; IncreaseEnergyTop
;------------------------------------------------------------------
IncreaseEnergyTop   
        STX a5529
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
        BEQ b547F
        LDA #$87
        STA SCREEN_RAM + $0373,X
        BNE b547B

;------------------------------------------------------------------
; IncreaseEnergyBottom
;------------------------------------------------------------------
IncreaseEnergyBottom   
        STX a5529
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
        BEQ b547F
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

a5529   .BYTE $00

;------------------------------------------------------------------
; UpdateCoreEnergyValues
;------------------------------------------------------------------
UpdateCoreEnergyValues   
        LDA gilbyIsAirborne
        BNE b5530
b552F   RTS 

b5530   LDA a7177
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
        LDA (attackWaveDataLoPtr),Y
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
        LDA (attackWaveDataLoPtr),Y
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
        JMP UpdateSomeGameInfo


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
; UpdateSomeGameInfo
;------------------------------------------------------------------
UpdateSomeGameInfo   
        LDA #<someGameData
        STA gameDataPtrLo
        LDA #>someGameData
        STA gameDataPtrHi
        PLA 
        TAX 
        BEQ b55FF

b55EF   LDA gameDataPtrLo
        CLC 
        ADC #$28
        STA gameDataPtrLo
        LDA gameDataPtrHi
        ADC #$00
        STA gameDataPtrHi
        DEX 
        BNE b55EF

b55FF   LDA currentLevelInCurrentPlanet
        ASL 
        TAY 
        LDA (gameDataPtrLo),Y
        PHA 
        INY 
        LDA (gameDataPtrLo),Y
        PHA 
        LDA updateLevelForBottomPlanet
        BNE b5644
        PLA 
        STA previousAttackWaveLoPtr
        STA gameDataPtrLo
        PLA 
        STA previousAttackWaveHiPtr
        STA gameDataPtrHi
        LDY #$26
        LDX oldTopPlanetIndex
        LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        BEQ b5628
        BNE b562A

b5628   LDA (gameDataPtrLo),Y
b562A   STA enemiesKilledTopPlanetsSinceLastUpdate,X
        LDA enemiesKilledTopPlanetSinceLastUpdate
        BNE b5638
        LDA enemiesKilledTopPlanetsSinceLastUpdate,X
        STA enemiesKilledTopPlanetSinceLastUpdate
b5638   DEY 
        LDA (gameDataPtrLo),Y
        STA a49D0
        LDA #$00
        STA unusedVariable1
        RTS 

b5644   PLA 
        STA previousAttackWaveLoPtr2
        STA gameDataPtrLo
        PLA 
        STA previousAttackWaveHiPtr2
        STA gameDataPtrHi
        LDY #$26
        LDX oldBottomPlanetIndex
        LDA enemiesKilledBottomsPlanetsSinceLastUpdate,X
        BEQ b565C
        BNE b565E
b565C   LDA (gameDataPtrLo),Y
b565E   STA enemiesKilledBottomsPlanetsSinceLastUpdate,X
        LDA enemiesKilledBottomPlanetSinceLastUpdate
        BNE b566C
        LDA enemiesKilledBottomsPlanetsSinceLastUpdate,X
        STA enemiesKilledBottomPlanetSinceLastUpdate
b566C   DEY 
        LDA (gameDataPtrLo),Y
        STA a49D1
        LDA #$00
        STA unusedVariable3
        RTS 

;------------------------------------------------------------------
; UpdateTopPlanetProgressData
;------------------------------------------------------------------
UpdateTopPlanetProgressData   
        STX a5529
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
b56B9   LDX a5529
        RTS 

;------------------------------------------------------------------
; UpdateBottomPlanetProgressData
;------------------------------------------------------------------
UpdateBottomPlanetProgressData   
        STX a5529
        LDX oldBottomPlanetIndex
        DEC enemiesKilledBottomsPlanetsSinceLastUpdate,X
        LDA enemiesKilledBottomPlanetSinceLastUpdate
        BNE b56D1
        LDA enemiesKilledBottomsPlanetsSinceLastUpdate,X
        STA enemiesKilledBottomPlanetSinceLastUpdate
b56D1   LDA enemiesKilledBottomsPlanetsSinceLastUpdate,X
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
b5705   STA previousAttackWaveHiPtr2,X
        STA enemiesKilledBottomsPlanetsSinceLastUpdatePtr,X
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
        STA pointsToAddToPointsEarnedByte2
        PLA 
b5751   RTS 

pointsToAddToPointsEarnedByte2   .BYTE $00
;------------------------------------------------------------------
; CheckProgressInPlanet
;------------------------------------------------------------------
CheckProgressInPlanet   
        LDX #$09
        LDA inAttractMode
        BNE b5751
        LDA #$13
b575C   CMP currentLevelInTopPlanets,X
        BNE b5767
        DEX 
        BPL b575C
        INC bonusAwarded
b5767   LDA bonusBountiesEarned
        BNE b5751
        LDX oldTopPlanetIndex
        LDY currentTopPlanet
        LDX #$00
b5774   LDA enemiesKilledBottomsPlanetsSinceLastUpdatePtr,Y
        CMP f57A6,X
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

f57A6   .BYTE $03,$06,$09,$0C,$0F
;------------------------------------------------------------------
; CheckProgressInBottomPlanet
;------------------------------------------------------------------
CheckProgressInBottomPlanet   
        LDY currentBottomPlanet
        LDX #$00
b57B0   LDA currentLevelInTopPlanetsPtr,Y
        CMP f57A6,X
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
; UpdateEnergyLabelColorIndexFromBounties
;------------------------------------------------------------------
UpdateEnergyLabelColorIndexFromBounties   
        STY a57EC
        LDY bonusBountiesEarned
        CLC 
        ADC f57ED,Y
        LDY a57EC
        RTS 

a57EC   .BYTE $23
f57ED   .BYTE $00,$0A,$14,$1E,$28,$32,$3C,$46
        .BYTE $50
;------------------------------------------------------------------
; GilbyDied
;------------------------------------------------------------------
GilbyDied   
        LDA #$01
        STA gilbyHasJustDied
        LDA levelRestartInProgress
        BNE b5833
        LDA inAttractMode
        BNE b5833

        LDX #$00
b5807   LDA #$FC
        STA a583F
        LDA #$00
        STA a5840
        STA f583C,X
        INX 
        CPX #$03
        BNE b5807

        LDA #$01
        STA gilbyExploding
        LDA #$03
        STA starFieldInitialStateArray - $01
        LDA #<gilbyDiedSoundSequence
        STA soundDataAE
        LDA #>gilbyDiedSoundSequence
        STA soundDataAF
        JSR ResetSoundDataPtr2
        LDX #$23
        RTS 

b5833   RTS 

mapPlaneEntropyToColor   .BYTE $01,$07,$03,$05,$04
f5839   .BYTE $02,$06,$00
f583C   .BYTE $50
a583D   .BYTE $A0
a583E   .BYTE $40
a583F   .BYTE $FE
a5840   .BYTE $08
;------------------------------------------------------------------
; ProcessGilbyExplosion
;------------------------------------------------------------------
ProcessGilbyExplosion   
        LDA gilbyExploding
        BEQ b5847
        RTS 

b5847   LDA #$F0
        STA Sprite0Ptr
        INC f583C
        INC a583D
        INC a583D
        LDA a583E
        CLC 
        ADC #$04
        STA a583E

        LDX #$00
b5860   LDA a583F
        STA upperPlanetGilbyBulletSpriteValue,X
        STA lowerPlanetGilbyBulletSpriteValue,X
        LDY a5840
        LDA mapPlaneEntropyToColor,Y
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
        ADC f583C,X
        STA upperPlanetGilbyBulletXPos,X
        STA lowerPlanetAttackShip2XPos,X
        BCC b58A6
        LDA gilbyBulletMSBXPosOffset,X
        STA upperPlanetGilbyBulletMSBXPosValue,X
        STA lowerPlanetAttackShip2MSBXPosValue,X
b58A6   JMP j58B5

b58A9   LDA #$B0
        SEC 
        SBC f5839,X
        STA upperPlanetGilbyBulletXPos,X
        STA lowerPlanetAttackShip2XPos,X

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
        STA gilbyExploding
        LDY #$02
        STY starFieldInitialStateArray - $01
        CMP #$08
        BNE b58E8
        JMP SetUpLevelRestart

b58E8   RTS 

a58E9   .BYTE $0A
gilbyDiedSoundSequence   .BYTE $00,$00,$0F,$0C,$00,$00,$00,$0F
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

;---------------------------------------------------------------------------------
; SetUpLevelRestart   
;---------------------------------------------------------------------------------
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
        JSR UpdatePlanetProgress
        LDA #$01
        STA levelEntrySequenceActive
        STA entryLevelSequenceCounter
        LDA #<p5C0D
        STA soundDataAC
        LDA #>p5C0D
        STA soundDataAD
        LDA #<p5C35
        STA soundDataAE
        LDA #>p5C35
        STA soundDataAF
        LDA #$00
        STA $D015    ;Sprite display Enable
        JSR ResetSoundDataPtr1
        JMP ResetSoundDataPtr2
        ; Returns

levelRestartInProgress   .BYTE $00
gilbiesLeft   .BYTE $02

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
        ADC #$08; Selects the 'encouragement text' in the second half of txtRestartLevelMsg
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
        LDA #$01
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

colorsForFlashBackgroundAndBorderEffect
        .BYTE ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE,GRAY3,GRAY3,GRAY2
        .BYTE GRAY3,GRAY2,GRAY2,GRAY1,GRAY2,GRAY1,GRAY1,$80
        .BYTE GRAY1,$80,$80,GRAY1,$80,GRAY1,GRAY1,GRAY2
        .BYTE GRAY1,GRAY2,GRAY2,GRAY3,GRAY2,GRAY3,GRAY3

initialColorForFlashEffect   .BYTE $02,$00

;------------------------------------------------------------------
; DrawLevelEntryGilbyFlightAnimation
; This is the multi-coloured level entry effect where 7 gilbys
; spread across the screen.
;------------------------------------------------------------------
DrawLevelEntryGilbyFlightAnimation   
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
        LDA starFieldAnimationOffset
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

initialXPosArray1   .BYTE $B8,$C0,$C8,$D0,$D8,$E0
initialXPosArray2   .BYTE $A8,$A0,$98,$90,$88,$80
p5D33   .BYTE $00,$00
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
;------------------------------------------------------------------
; UpdateDisplayedScoringRate
;------------------------------------------------------------------
UpdateDisplayedScoringRate   
        LDA #$23
        STA SCREEN_RAM + $0387
        LDA #$01
        STA COLOR_RAM + $0387
        LDA starFieldAnimationOffset
        BPL b5E14
        EOR #$FF
        CLC 
        ADC #$01
b5E14   TAX 
        LDA scoreToScoringRateMap,X
        TAY 
        LDA f5E4A,Y
        CLC 
        ADC #$30
        STA SCREEN_RAM + $0388
        LDA f5E4F,Y
        STA COLOR_RAM + $0388
        STY a5E54
        RTS 

scoreToScoringRateMap   .BYTE $00,$00,$01,$01,$01,$01,$02,$02
        .BYTE $02,$02,$02,$02,$02,$02,$03,$03
        .BYTE $04,$04,$03,$02,$02,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01
f5E4A   .BYTE $00,$01,$02,$04,$08
f5E4F   .BYTE $06,$04,$05,$07,$01
a5E54   .BYTE $01
;------------------------------------------------------------------
; UpdatePlanetEntropyStatus
;------------------------------------------------------------------
UpdatePlanetEntropyStatus   
        LDA lowerPlanetActivated
        BEQ b5E5D
        JMP ReturnFromSub

b5E5D   LDA a4F57
        BEQ b5E69
        LDA #$08
        STA lowerPlanetEntropyStatus
        BNE b5E6E
b5E69   LDA #$08
        STA upperPlanetEntropyStatus
b5E6E   DEC a5E75
        BEQ MaybeUpdateDisplayedEntropy
        BNE UpdateDisplayedEntropyStatus

a5E75                    .BYTE $A3
upperPlanetEntropyStatus .BYTE $08
lowerPlanetEntropyStatus .BYTE $08
a5E78                    .BYTE $23

;---------------------------------------------------------------------------------
; MaybeUpdateDisplayedEntropy   
;---------------------------------------------------------------------------------
MaybeUpdateDisplayedEntropy   
        DEC a5E78
        BNE UpdateDisplayedEntropyStatus
        LDA #$10
        STA a5E78
        LDA #$00
        STA a7C8A
        LDA a4F57
        BEQ b5EA6
        DEC upperPlanetEntropyStatus
        BNE b5E95
        INC a7C8A
b5E95   LDA upperPlanetEntropyStatus
        CMP #$FF
        BNE UpdateDisplayedEntropyStatus

EntropyKillsGilby   
        LDA #$02
        STA reasonGilbyDied ; Entropy
        JMP GilbyDied

        BNE UpdateDisplayedEntropyStatus
b5EA6   DEC lowerPlanetEntropyStatus
        BNE b5EAE
        INC a7C8A
b5EAE   LDA lowerPlanetEntropyStatus
        CMP #$FF
        BNE UpdateDisplayedEntropyStatus
        JMP EntropyKillsGilby

;---------------------------------------------------------------------------------
; UpdateDisplayedEntropyStatus   
; This is the planet entropy status for the upper and
; lower plants, on the bottom left hand side of the screen.
;---------------------------------------------------------------------------------
UpdateDisplayedEntropyStatus   
        LDA #$08
        SEC 
        SBC upperPlanetEntropyStatus
        TAY 
        LDA mapPlaneEntropyToColor,Y
        STA COLOR_RAM + $0348
        STA COLOR_RAM + $0349
        STA COLOR_RAM + $0370
        STA COLOR_RAM + $0371
        LDA #$08
        SEC 
        SBC lowerPlanetEntropyStatus
        TAY 
        LDA mapPlaneEntropyToColor,Y
        STA COLOR_RAM + $0398
        STA COLOR_RAM + $0399
        STA COLOR_RAM + $03C0
        STA COLOR_RAM + $03C1
        JMP ReturnFromSub

                    .BYTE $C0,$C0,$C0,$C0,$C0,$00,$00,$00
                    .BYTE $00
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

b5F21   LDA starFieldAnimationOffset
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
b604F   LDA textForInactiveLowerPlanet,X
        AND #$3F
        STA SCREEN_RAM + $02F7,X
        LDA #$01
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
                                     .BYTE $00,$02,$00,$02,$00
textForInactiveLowerPlanet           .BYTE $02    ;JAM
                                     .TEXT "  WARP GATE       GILBY   CORE  NOT-CORE"
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
        LDA #$07
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
        LDA #$01
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
        LDA #$07
        STA COLOR_RAM + $02A7,X
        DEX 
        BNE b6223

b6233   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ b6233

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

p6335   .BYTE $00,$00,$20
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
;------------------------------------------------------------------
; SwapRoutines
;------------------------------------------------------------------
SwapRoutines   
        SEI 
        LDA #$34
        STA RAM_ACCESS_MODE
        LDA #<LaunchCurrentProgram
        STA tempLoPtr1
        LDA #>LaunchCurrentProgram
        STA tempHiPtr1
        LDA #>$E800
        STA tempHiPtr
        LDA #<$E800
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
        JSR SwapRoutines
        JSR LaunchCurrentProgram
        SEI 
        LDA #<GameSwitchAndGameOverInterruptHandler
        STA $0314    ;IRQ
        LDA #>GameSwitchAndGameOverInterruptHandler
        STA $0315    ;IRQ
        JMP SwapRoutines

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
        LDA #$01
        STA COLOR_RAM + $00BD,X
        STA COLOR_RAM + $010D,X
        LDA #$04
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
        STA aFB
        LDX #$00
b6493   DEX 
        BNE b6493
        DEC aFB
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
        LDA #$02
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
        LDA #$07
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

;---------------------------------------------------------------------------------
; AnimateGilbiesForNewBonus 
;---------------------------------------------------------------------------------
AnimateGilbiesForNewBonus 
        LDY #$00
        LDA #$F0
        STA $D012    ;Raster Position
        DEC bonusGilbyAnimation
        BNE b6610
        LDA bonusGilbyAnimation + $01
        STA bonusGilbyAnimation
        LDA a673D
        CLC 
        ADC bonusGilbyAnimation + $05
        STA bonusGilbyAnimation + $05
b6610   DEC bonusGilbyAnimation + $03
        BNE b6625
        LDA bonusGilbyAnimation + $02
        STA bonusGilbyAnimation + $03
        LDA bonusGilbyAnimation + $06
        CLC 
        ADC a673E
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
        LDA f673F,X
        STA bonusGilbyAnimation + $01
        LDA f674F,X
        STA a673D
        JSR PutRandomByteInAccumulatorRegister
        AND #$07
        CLC 
        ADC #$04
        TAX 
        LDA f673F,X
        STA bonusGilbyAnimation + $02
        LDA f674F,X
        STA a673E
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
        JMP j672B

b6725   CLC 
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos

j672B   
        LDA bonusGilbyYPos1
        LDX bonusGilbyAnimation + $0C
        BEQ b6736
        JMP BonusBountyAnimateGilbyYPos

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
;------------------------------------------------------------------
; BonusBountyAnimateGilbyXPos
;------------------------------------------------------------------
BonusBountyAnimateGilbyXPos   
        LDA bonusGilbyXPos1
        CLC 
        ROR 
        STA aFA
        LDA bonusGilbyXPos2
        CLC 
        ROR 
        CLC 
        ADC aFA
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
        STA aFA
        LDA bonusGilbyYPos2
        CLC 
        ROR 
        CLC 
        ADC aFA
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

txtBonus10000                      .TEXT "BONUS 10000"
a6794                              .BYTE $BC
unusedDataArray                              .BYTE $00,$06,$02,$04,$05,$03,$07,$01
                                   .BYTE $01,$07,$03,$05,$04,$02,$06,$00

colorSequenceArray         .BYTE RED,ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE,GRAY1
                           .BYTE GRAY1,BLUE,PURPLE,LTBLUE,GREEN,YELLOW,ORANGE,RED

backgroundColorsForPlanets .BYTE BLACK,WHITE,RED,CYAN,PURPLE,GREEN,BLUE,YELLOW
                           .BYTE ORANGE,BROWN,LTRED,GRAY1,GRAY2,LTGREEN,LTBLUE,GRAY3
a67C5                      .BYTE $04
a67C6                      .BYTE $05
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
; ManipulateStarfieldSprite
;------------------------------------------------------------------
ManipulateStarfieldSprite   
        LDX starFieldAnimationOffset
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
        LDA #$04
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
        LDA #$D3
        STA currentGilbySprite
        STA Sprite0Ptr
        LDA #$02
        STA a7178
        LDA #$40
        STA $D001    ;Sprite 0 Y Pos
        LDA #$04
        STA a7177
        LDA #$EA
        STA starFieldAnimationOffset
        LDA #$00
        STA a7140
        RTS 

bonusAwarded   .BYTE $00
;------------------------------------------------------------------
; PrepareToRunGame
;------------------------------------------------------------------
PrepareToRunGame   
        LDA inAttractMode
        BEQ b6932
        JSR SelectRandomPlanetsForAttractMode
b6932   LDA #$00
        JSR UpdatePlanetProgress
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
        LDA inAttractMode
        BEQ StartTheGame
        CMP #$01
        BNE StartTheGame

        LDA #$01
        STA aCC88
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
        CMP #$40
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
        JSR UpdatePlanetProgress
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
        LDA backgroundColorsForPlanets,X
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

;---------------------------------------------------------------------------------
; RasterPositionMatchesRequestedInterrupt 
;---------------------------------------------------------------------------------
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

;---------------------------------------------------------------------------------
; ResetRasterAndPerformMainGameUpdate   
;---------------------------------------------------------------------------------
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

;---------------------------------------------------------------------------------
; UpdateGilbyPositionAndColor   
;---------------------------------------------------------------------------------
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
        LDX energyLabelColorIndexTopPlanet
        BEQ b6C1A
        LDA defaultGilbyColor
b6C1A   LDY a4F57
        BEQ b6C21
        LDA #$0B
b6C21   STA $D027    ;Sprite 0 Color
b6C24   RTS 

currentGilbySprite   .BYTE $D3

;---------------------------------------------------------------------------------
; PerformMainGameUpdate   
;---------------------------------------------------------------------------------
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
        JSR ProcessJoystickInput
        JSR UpdateGilbyVerticalPosition
        JSR AlsoUpdateGilbyVerticalPosition
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
        ORA a6E11
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

;---------------------------------------------------------------------------------
; DrawLowerPlanet   
;---------------------------------------------------------------------------------
DrawLowerPlanet   
        JSR DrawLowerPlanetAttackShips
        LDA #$07
        SEC 
        SBC a6E11
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
        STA a760D
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
        LDX energyLabelColorIndexBottomPlanet
        BEQ b6D2C

        LDA defaultGilbyColor
b6D2C   LDY a4F57
        BNE b6D33

        LDA #$0B
b6D33   STA $D027    ;Sprite 0 Color (lower planet gilby)

;---------------------------------------------------------------------------------
; UpdateRasterPositionAndReturn   
;---------------------------------------------------------------------------------
UpdateRasterPositionAndReturn   
        LDY #$0A
        STY currentIndexInRasterInterruptArrays
        LDA spriteCollidedWithBackground,Y
        STA $D012    ;Raster Position

;---------------------------------------------------------------------------------
; UpdateInterruptRegisterAndReturn   
;---------------------------------------------------------------------------------
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
        LDA starFieldAnimationOffset
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
        SBC starFieldAnimationOffset
        STA starFieldXPosArray - $01,X
        LDA starFieldXPosMSBArray - $01,X
        SBC starFieldAnimationRate
        STA starFieldXPosMSBArray - $01,X
        JMP j6E03

b6DF4   CLC 
        ADC starFieldAnimationOffset
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

a6E11                        .BYTE $02
starFieldAnimationOffset     .BYTE $EA
starfieldSpriteAnimationData .BYTE $C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0
                             .BYTE $F0,$F0,$F0,$F0,$F8,$F8,$F8,$F8
                             .BYTE $FC,$FC,$FC,$FC,$FE,$FE,$FE,$FF
defaultGilbyColor            .BYTE $01
gilbyIsAirborne              .BYTE $01

;------------------------------------------------------------------
; ProcessJoystickInput
;------------------------------------------------------------------
ProcessJoystickInput   
        ; Find reasons for gilby not to die because he hit something.
        LDA spriteCollidedWithBackground
        BEQ b6E88
        AND #$01
        BEQ b6E88
        LDA controlPanelIsGrey
        BNE b6E88
        LDA levelEntrySequenceActive
        BNE b6E88
        LDA levelRestartInProgress
        BNE b6E88
        LDA gilbyHasJustDied
        BNE b6E88
        LDA inAttractMode
        BNE b6E88

        ; Not sure what planet features these are.
        LDA SCREEN_RAM + $01A4
        CMP #$77
        BEQ b6E67
        CMP #$7D
        BEQ b6E67
        LDA difficultySetting
        BEQ b6E88
        ;He hit something, and is dead.
        LDA #$03
        STA reasonGilbyDied ; Hit something
        JMP GilbyDied

b6E67   JSR UpdatePlanetProgress
        LDA #$01
        STA entryLevelSequenceCounter
        STA levelEntrySequenceActive
        LDA #$06
        STA gilbyExploding
        LDA #$04
        STA starFieldInitialStateArray - $01
        LDY #$14
        LDA starFieldAnimationOffset
        BPL b6E85
        LDY #$EC
b6E85   STY starFieldAnimationOffset

b6E88   DEC defaultGilbyColor
        BEQ b6E8E
b6E8D   RTS 

b6E8E   LDA $DC00    ;CIA1: Data Port Register A
        STA joystickInput
        AND #$1F
        CMP #$1F
        BEQ b6EA4

        ; Any joystick input aborts attract mode
        LDA inAttractMode
        BEQ b6EA4
        LDA #$02
        STA inAttractMode

b6EA4   JSR GenerateJoystickInputForAttractMode
        LDA inAttractMode
        BEQ b6EAF
        DEC inAttractMode
b6EAF   LDA #$02
        STA defaultGilbyColor
        LDA #$00
        STA gilbyIsAirborne

        ; Check whether the gilby is on land or not.
        LDA SCREEN_RAM + $01A4
        CMP #$41
        BEQ b6EC4
        CMP #$43
        BNE b6EC9

b6EC4   LDA #$01
        STA gilbyIsAirborne
b6EC9   LDA a4F57
        BEQ b6EF6

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

        LDA a7177
        BEQ b6F03
        JMP j6F99

b6F03   JSR ProcessFireButtonPressed

        ;Check if joystick pushed to left.
        LDA joystickInput
        AND #$04
        BNE b6F2E

        ; Joystick pushed to left
        LDA #$01
        STA a7177
        LDA #$01
        STA starFieldAnimationOffset
        LDA #$04
        STA a75A5
        STA a75A6
        LDA #$00
        STA a75A4
        STA gilbySpriteIndex ; Loads $C1 to sprite
        LDA #$07
        STA a75A3
        BNE b6F54

        ;Check if joystick pushed to right.
b6F2E   LDA joystickInput
        AND #$08
        BNE b6F54

        ; Joystick pushed to right
        LDA #$04
        STA a75A5
        STA a75A6
        LDA #$06
        STA a75A4
        STA gilbySpriteIndex
        LDA #$0D
        STA a75A3
        LDA #$FF
        STA starFieldAnimationOffset
        LDA #$01
        STA a7177

        ;Check if joystick pushed down.
b6F54   LDA joystickInput
        AND #$01
        BNE b6F98

        ; Joystick pushed down.
        LDA gilbyIsAirborne
        BEQ b6F63
        JMP j701E

        ; Joystick pushed up
b6F63   LDA gilbyVerticalPosition
        CMP #$6D
        BNE b6F98

        LDA #<p7B61
        STA soundDataAC
        LDA #>p7B61
        STA soundDataAD
        LDA #$FA
        STA a760B
        DEC gilbyVerticalPosition
        LDA #$11
        STA a75A4
        STA gilbySpriteIndex
        LDA #$16
        STA a75A3
        LDA #$01
        STA a7178
        LDA #$0A
        STA a75A5
        LDA #$02
        STA a7177
b6F98   RTS 

;---------------------------------------------------------------------------------
; j6F99   
;---------------------------------------------------------------------------------
j6F99   
        CMP #$01
        BEQ b6FA0
        JMP j703B

b6FA0   JSR ProcessFireButtonPressed
        LDA joystickInput
        AND #$04
        BNE b6FEB

        ; Joystick Left Pressed 
        LDA starFieldAnimationOffset
        BPL b6FDA
        INC a75A5
        INC starFieldAnimationOffset
        BNE b6FD7
b6FB7   LDA #$00
        STA a7177
        STA starFieldAnimationOffset
        STA a7178
        LDA #$06
        STA a75A5
        STA a75A6
        LDA #$0D
        STA gilbySpriteIndex
        STA a75A4
        LDA #$11
        STA a75A3
b6FD7   JMP j700F

b6FDA   INC starFieldAnimationOffset
        DEC a75A5
        BNE b6FD7
        INC a75A5
        DEC starFieldAnimationOffset
        JMP j700F

b6FEB   LDA joystickInput
        AND #$08
        BNE j700F

        ; Joystick right pressed
        LDA starFieldAnimationOffset
        BMI b7001
        INC a75A5
        DEC starFieldAnimationOffset
        BEQ b6FB7
        BNE j700F
b7001   DEC starFieldAnimationOffset
        DEC a75A5
        BNE b6FD7
        INC starFieldAnimationOffset
        INC a75A5

j700F   
        LDA joystickInput
        AND #$01
        BNE b703A

        ;Joystick up pressed
        LDA gilbyIsAirborne
        BNE j701E
        JMP b6F63

;---------------------------------------------------------------------------------
; j701E   
;---------------------------------------------------------------------------------
j701E   
        LDA gilbyVerticalPosition
        CMP #$6D
        BNE b703A
        LDA #$FA
        STA a760B
        LDA #<p7B34
        STA soundDataAC
        LDA #>p7B34
        STA soundDataAD
        JSR ResetSoundDataPtr1
        DEC gilbyVerticalPosition
b703A   RTS 

;---------------------------------------------------------------------------------
; j703B   
;---------------------------------------------------------------------------------
j703B   
        CMP #$02
        BNE b707E
        JSR ProcessFireButtonPressed
        LDA a7178
        CMP #$02
        BNE b703A
        LDA joystickInput
        AND #$04
        BEQ b7099
        LDA joystickInput
        AND #$08
        BEQ b70A7
        LDA a760B
        CMP #$02
        BNE b703A

j705E   
        LDA #$15
        STA a75A4
        STA gilbySpriteIndex
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
        JSR ProcessFireButtonPressed
        LDA gilbyVerticalPosition
        CMP #$6D
        BNE b707D
        LDA #<gilbyWalkingSound
        STA soundDataAC
        LDA #>gilbyWalkingSound
        STA soundDataAD
        JMP b6FB7

b7099   JSR s70AF
        LDA #$D1
        STA currentGilbySprite

;---------------------------------------------------------------------------------
; s70A1   
;---------------------------------------------------------------------------------
s70A1   
        LDA #$04
        STA a7177
        RTS 

;---------------------------------------------------------------------------------
; b70A7   
;---------------------------------------------------------------------------------
b70A7   
        LDA #$D3
        STA currentGilbySprite
        JSR s70A1

;---------------------------------------------------------------------------------
; s70AF   
;---------------------------------------------------------------------------------
s70AF   
        LDA #$00
        STA a7140
        RTS 

;---------------------------------------------------------------------------------
; b70B5   
;---------------------------------------------------------------------------------
b70B5   
        JSR ProcessFireButtonPressed
        LDA joystickInput
        AND #$04
        BNE b70FC
        LDA currentGilbySprite
        CMP #$D3
        BNE b70E0
        LDA #$01
        STA a7178
        LDA #$01
        STA a75A5
        STA a75A6
        LDA #$1A
        STA a75A4
        STA gilbySpriteIndex
        LDA #$1F
        STA a75A3
b70E0   INC starFieldAnimationOffset
        LDA lowerPlanetActivated
        BEQ b70EF
        LDA starFieldAnimationOffset
        CMP #$0C
        BEQ b70F6
b70EF   LDA starFieldAnimationOffset
        CMP #$18
        BNE b70F9
b70F6   DEC starFieldAnimationOffset
b70F9   JMP j7173

b70FC   LDA joystickInput
        AND #$08
        BNE b7142
        LDA currentGilbySprite
        CMP #$D1
        BNE b7124
        LDA #$01
        STA a7178
        LDA #$01
        STA a75A5
        STA a75A6
        LDA #$1F
        STA a75A4
        STA gilbySpriteIndex
        LDA #$24
        STA a75A3
b7124   DEC starFieldAnimationOffset
        LDA lowerPlanetActivated
        BEQ b7133
        LDA starFieldAnimationOffset
        CMP #$F4
        BEQ b713A
b7133   LDA starFieldAnimationOffset
        CMP #$E6
        BNE j7173
b713A   INC starFieldAnimationOffset
        JMP j7173

a7140   .BYTE $00
b7141   RTS 

b7142   LDA starFieldAnimationOffset
        BEQ b715A
        LDA starFieldAnimationOffset
        BMI b7152
        DEC starFieldAnimationOffset
        DEC starFieldAnimationOffset
b7152   INC starFieldAnimationOffset
        LDA starFieldAnimationOffset
        BNE j7173
b715A   LDA joystickInput
        AND #$10
        BEQ b7141
        LDA gilbyIsAirborne
        BEQ b7141
        LDA #$01
        STA a7140
        LDA #$CF
        STA currentGilbySprite
        JMP j705E

j7173   
        JMP ManipulateStarfieldSprite
        ; Returns

joystickInput .BYTE $09
a7177         .BYTE $04
a7178         .BYTE $02

;------------------------------------------------------------------
; AlsoUpdateGilbyVerticalPosition
;------------------------------------------------------------------
AlsoUpdateGilbyVerticalPosition   
        LDA a7177
        CMP #$04
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
        INC a6794
        LDA a6794
        AND #$0F
        TAX 
        LDA unusedDataArray,X
        STA a67C5
        LDA colorSequenceArray,X
        STA a67C6
        LDA starFieldAnimationOffset
        BMI b7234
        JMP ScrollPlanetLeft

b7234   LDA a6E11
        CLC 
        ADC starFieldAnimationOffset
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

        LDA a6E11
        AND #$07
        STA a6E11
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
        LDA a6E11
        CLC 
        ADC starFieldAnimationOffset
        STA a6E11
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
        LDA #<p8C00
        STA planetPtrLo
        LDA #>p8C00
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

a7317   =*+$01
;------------------------------------------------------------------
; PutRandomByteInAccumulatorRegister
;------------------------------------------------------------------
PutRandomByteInAccumulatorRegister   
        LDA a9ABB
        INC a7317
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
; Redid the graphics completely, came up with some really nice looking 
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
; basic structures, all I do is fit different graphics around each one. 
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
j7488   
        LDA littleStructureData,X
        CMP #$FF
        BNE b7495
        JSR SwitchToNextLayerInPlanet
        JMP j7488

b7495   CMP #$FE
        BEQ b74B0
        STA (planetPtrLo),Y
        INY 
        INX 
        JMP j7488

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

j74B3   
        LDA mediumStructureData,X
        CMP #$FF
        BNE b74C0
        JSR SwitchToNextLayerInPlanet
        JMP j74B3

b74C0   CMP #$FE
        BEQ b74B0 ; Return
        STA (planetPtrLo),Y
        INY 
        INX 
        JMP j74B3

;------------------------------------------------------------------
; DrawLargestStructure ($74CB) 
;------------------------------------------------------------------
DrawLargestStructure
        LDX #$00

j74CD   
        LDA largestStructureData,X
        CMP #$FF
        BNE b74DA
        JSR SwitchToNextLayerInPlanet
        JMP j74CD

b74DA   CMP #$FE
        BEQ b74B0 ; Return
        STA (planetPtrLo),Y
        INY 
        INX 
        JMP j74CD

;------------------------------------------------------------------
; DrawNextLargestStructure ($74E5) 
;------------------------------------------------------------------
DrawNextLargestStructure
        LDX #$00
j74E7   
        LDA nextLargestStructure,X
        CMP #$FF
        BNE b74F4
        JSR SwitchToNextLayerInPlanet
        JMP j74E7

b74F4   CMP #$FE
        BEQ b74B0 ; Return
        STA (planetPtrLo),Y
        INY 
        INX 
        JMP j74E7

;------------------------------------------------------------------
; DrawWarpGate
;------------------------------------------------------------------
DrawWarpGate   
        LDX #$00
j7501   
        LDA warpGateData,X
        CMP #$FF
        BNE b750E
        JSR SwitchToNextLayerInPlanet
        JMP j7501

b750E   CMP #$FE
        BEQ b74B0
        STA (planetPtrLo),Y
        INY 
        INX 
        JMP j7501

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
j7521   
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
        JMP j7521

        ; Draw the two warp gates
b7546   LDA charSetDataPtrLo
        BEQ j7521
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
        ; $7486, $74B1, $74CB, $74E5 to draw a structure
        ; on the planet surface
        LDA structureSubRoutineArrayHiPtr,X
        STA structureRoutineHiPtr
        LDA structureSubRoutineArrayLoPtr,X
        STA structureRoutineLoPtr
        JMP (randomStructureRoutineAddress)

;Jump table
structureSubRoutineArrayHiPtr   .BYTE $74,$74,$74,$74
structureSubRoutineArrayLoPtr   .BYTE $86,$B1,$CB,$E5

gilbySprites .BYTE $C1,$C2,$C3,$C4,$C5,$C6,$C7,$C6
             .BYTE $C5,$C4,$C3,$C2,$C1,$C8,$C9,$CA
             .BYTE $CB,$CB,$CC,$CD,$CE,$CF,$CE,$CD
             .BYTE $CC,$CB,$D3,$D2,$CF,$D0,$D1,$D1
             .BYTE $D0,$CF,$D2,$D3
a75A3        .BYTE $11
a75A4        .BYTE $0D
a75A5        .BYTE $06
a75A6        .BYTE $06
gilbySpriteIndex   .BYTE $0D
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
        JMP DrawLevelEntryGilbyFlightAnimation
        ; Returns

b75BA   DEC a75A6
        BEQ b75C0
b75BF   RTS 

b75C0   LDA a75A5
        STA a75A6
        LDA a7178
        BEQ b75CF
        CMP #$02
        BEQ b75BF
b75CF   INC gilbySpriteIndex
        LDA gilbySpriteIndex
        CMP a75A3
        BNE b7601
        LDA a7178
        BEQ b75E3
        INC a7178
        RTS 

b75E3   LDA a75A4
        STA gilbySpriteIndex
        LDA a7177
        CMP #$01
        BNE b7601
        LDA gilbyVerticalPosition
        CMP #$6D
        BNE b7601
        LDA #<gilbyWalkingSound
        STA soundDataAC
        LDA #>gilbyWalkingSound
        STA soundDataAD
b7601   LDX gilbySpriteIndex
        LDA gilbySprites,X
        STA currentGilbySprite
        RTS 

a760B   .BYTE $01
gilbyVerticalPosition   .BYTE $3F
a760D   .BYTE $CA
a760E   .BYTE $01
a760F   .BYTE $03
;------------------------------------------------------------------
; UpdateGilbyVerticalPosition
;------------------------------------------------------------------
UpdateGilbyVerticalPosition   
        LDA levelEntrySequenceActive
        BNE b761A
        DEC a760E
        BEQ b761B
b761A   RTS 

b761B   LDA #$02
        STA a760E
        LDA a7140
        BEQ b761A
        LDA gilbyVerticalPosition
        CMP #$6D
        BEQ b761A
        DEC a760F
        BEQ b764A

j7631   
        CLC 
        ADC a760B
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
        STA a760F
        INC a760B
        LDA a760B
        CMP #$08
        BEQ b765F
        LDA gilbyVerticalPosition
        JMP j7631

b765F   DEC a760B
        LDA gilbyVerticalPosition
        JMP j7631

bulletDirectionArray   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
a7670   .BYTE $01
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
        STA a7670
b767D   RTS 

        ;Fire has been pressed
b767E   LDX #$00
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        BMI b76A8
        LDX #$06
        LDA upperPlanetGilbyBulletMSBXPosValue,X
        BMI b76A8
        LDX #$01
        DEC a7670
        BNE b767D
        LDA #$06
        STA a7670
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
        LDA starFieldAnimationOffset
        EOR #$FF
        STA bulletDirectionArray,X
        INC bulletDirectionArray,X
        LDA #$FA
        STA upperPlanetGilbyBulletNextYPosArray,X

        LDA a48D7
        BNE b76DF

        LDA #<p7BD4
        STA soundDataAE
        LDA #>p7BD4
        STA soundDataAF

b76DF   LDA a7177
        CMP #$04
        BNE b7717

        ; The gilby is in the air
        LDA a48D7
        BNE b76F8
        JSR ResetSoundDataPtr2
        LDA #<p7C24
        STA soundDataAE
        LDA #>p7C24
        STA soundDataAF

b76F8   LDA gilbyVerticalPosition
        CLC 
        ADC #$06
        STA upperPlanetGilbyBulletYPos,X
        LDA #$B1
        STA upperPlanetGilbyBulletXPos,X
        LDA #$EC ; Gilby's in-flight bullet
        STA upperPlanetGilbyBulletSpriteValue,X

        LDA currentGilbySprite
        CMP #$D1 ; Left-facing in-flight gilby
        BNE b7718

        ; Gilby is left-facing.
        LDA #$F5
        STA bulletDirectionArray,X
b7717   RTS 

b7718   CMP #$D3 ; Right-facing gilby
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
        LDA controlPanelColors,X
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
        CMP #$40
        BNE b786D
        LDA #$00
        STA f1WasPressed
b786C   RTS 

b786D   LDY f1WasPressed
        BNE b786C
        LDY inAttractMode
        BEQ b787C
        LDY #$02
        STY inAttractMode
b787C   LDY levelRestartInProgress
        BNE b786C
        LDY gilbyHasJustDied
        BNE b786C

        CMP #$3E ; Q pressed, to quit game
        BNE b788E

        ; Q was pressed, get ready to quit game.
        INC qPressedToQuitGame
        RTS 

b788E   CMP #$04 ; F1 Pressed
        BNE b7899
        INC f1WasPressed
        INC pauseModeSelected
b7898   RTS 

b7899   CMP #$3C ; Space pressed
        BNE b78A1
        INC progressDisplaySelected
        RTS 

        ; We can award ourselves a bonus bounty by 
        ; pressing Y at any time, as long as '1C' is the
        ; first character in the hiscore table. Not sure
        ; what this hack is for, testing?
b78A1   CMP #$19 ; Y Pressed
        BNE b7898
        LDA canAwardBonus
        CMP #$1C
        BNE b7898
        INC bonusAwarded
        RTS 

currentTopPlanetIndex      .BYTE $00
oldTopPlanetIndex          .BYTE $00
currentBottomPlanetIndex   .BYTE $00
oldBottomPlanetIndex       .BYTE $00
qPressedToQuitGame         .BYTE $00
backgroundColor1ForPlanets .BYTE $09,$0B,$07,$0E,$0D
backgroundColor2ForPlanets .BYTE $0E,$10,$01,$07,$10
surfaceColorsForPlanets    .BYTE $0D,$09,$0A,$0C,$0A,$01,$01
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
        LDA #<p5DB0
        STA soundDataAE
        LDA #>p5DB0
        STA soundDataAF
        LDA #$30
        STA a48D7
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

lowerPlanetActivated   .BYTE $01
soundData7E   .BYTE $00,$94,$00,$00,$11,$0F,$00,$00
        .BYTE $03,$00,$00,$21,$0F,$00,$08,$03
        .BYTE $00,$00,$21,$0F,$00,$00,$00,$00
        .BYTE $02,$00,$00,$00,$00,$00,$00,$00
soundData9E   .BYTE $92
soundData9F   .BYTE $5D,$85,$5C
soundDataA2   .BYTE $02,$00
soundDataA4   .BYTE $00,$00
soundDataA6   .BYTE $02
soundDataA7   .BYTE $18
soundDataA8   .BYTE $05
soundDataA9   .BYTE $00
soundDataAA   .BYTE $65
soundDataAB   .BYTE $5D
soundDataAC   .BYTE $97
soundDataAD   .BYTE $5D
soundDataAE   .BYTE $65
soundDataAF   .BYTE $5D
;------------------------------------------------------------------
; PlaySoundEffects
;------------------------------------------------------------------
PlaySoundEffects   
        LDA #$00
        STA soundDataA6
        LDA a48D7
        BEQ b79BD
        DEC a48D7
b79BD   LDA soundDataAC
        STA soundTmpLoPtr
        LDA soundDataAD
        STA soundTmpHiPtr
        JSR PlaySound1
        LDA #$02
        STA soundDataA6
        LDA soundDataAE
        STA soundTmpLoPtr
        LDA soundDataAF
        STA soundTmpHiPtr
;------------------------------------------------------------------
; PlaySound1
;------------------------------------------------------------------
PlaySound1   
        LDY #$00
b79DB   LDA (soundTmpLoPtr),Y
        STA soundDataA7,Y
        INY 
        CPY #$05
        BNE b79DB
        LDA soundDataA8
        BNE b7A28
        LDA soundDataA9
        LDX soundDataAA
        STA soundData7E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte

j79F6   
        JSR PlaySound2
        LDA soundDataAB
        BEQ PlaySound1
        CMP #$01
        BNE b7A03
        RTS 

b7A03   LDX soundDataA6
        LDA soundTmpLoPtr
        STA soundData9E,X
        LDA soundTmpHiPtr
        STA soundData9F,X
        RTS 

;------------------------------------------------------------------
; PlaySound2
;------------------------------------------------------------------
PlaySound2   
        LDA soundTmpLoPtr
        CLC 
        ADC #$05
        STA soundTmpLoPtr
        LDX soundDataA6
        STA soundDataAC,X
        LDA soundTmpHiPtr
        ADC #$00
        STA soundTmpHiPtr
        STA soundDataAD,X
        RTS 

b7A28   AND #$80
        BEQ b7A2F
        JMP j7AC8

b7A2F   LDA soundDataA8
        CMP #$01
        BNE b7A4C
        LDX soundDataA7
        LDA soundData7E,X
        CLC 
        ADC soundDataA9
        LDX soundDataAA
        STA soundData7E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP j79F6

b7A4C   CMP #$02
        BNE b7A66
        LDX soundDataA7
        LDA soundData7E,X
        SEC 
        SBC soundDataA9

j7A5A   
        LDX soundDataAA
        STA soundData7E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP j79F6

b7A66   CMP #$03
        BNE b7A7A
        LDX soundDataA7
        LDY soundDataA9
        LDA soundData7E,X
        CLC 
        ADC soundData7E,Y
        JMP j7A5A

b7A7A   CMP #$04
        BNE b7A8E
        LDX soundDataA7
        LDY soundDataA9
        LDA soundData7E,X
        SEC 
        SBC soundData7E,Y
        JMP j7A5A

b7A8E   CMP #$05
        BNE b7AB7
        LDX soundDataA7
        LDA soundData7E,X
        SEC 
        SBC soundDataA9

j7A9C   
        STA soundData7E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        BEQ b7AB4
        LDA soundDataAA
        LDX soundDataA6
        STA soundDataAC,X
        LDA soundDataAB
        STA soundDataAD,X
        RTS 

b7AB4   JMP PlaySound2

b7AB7   CMP #$06
        BNE j7AC8
        LDX soundDataA7
        LDA soundData7E,X
        CLC 
        ADC soundDataA9
        JMP j7A9C

j7AC8   
        LDA soundDataA8
        CMP #$80
        BNE b7ADF
        LDX soundDataA6
        LDA soundDataA9
        STA soundDataAC,X
        LDA soundDataAA
        STA soundDataAD,X
        RTS 

b7ADF   CMP #$81
        BNE b7B06
        LDX soundDataA6
        LDA soundDataA2,X
        BNE b7AF1
        LDA soundDataA9
        STA soundDataA2,X
b7AF1   DEC soundDataA2,X
        BEQ b7B03
        LDA soundData9E,X
        STA soundTmpLoPtr
        LDA soundData9F,X
        STA soundTmpHiPtr
        JMP PlaySound1

b7B03   JMP PlaySound2

b7B06   RTS 

gilbyWalkingSound   .BYTE $00,$00,$00,$04,$00,$00,$00,$00
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

;------------------------------------------------------------------
; ResetSoundDataPtr1
;------------------------------------------------------------------
ResetSoundDataPtr1   
        LDA #$00
        STA soundDataA2
        RTS 

;------------------------------------------------------------------
; ResetSoundDataPtr2
;------------------------------------------------------------------
ResetSoundDataPtr2   
        LDA #$00
        STA soundDataA4
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
        LDY starFieldAnimationOffset
        BMI b7CF0
        CLC 
        ADC starFieldAnimationOffset
        STA upperPlanetAttackShip2XPos,X
        BCC b7CC2

j7CB9   
        LDA upperPlanetAttackShip2MSBXPosValue,X
        EOR attackShip2MSBXPosOffsetArray,X
        STA upperPlanetAttackShip2MSBXPosValue,X
b7CC2   LDA lowerPlanetAttackSHip3MSBXPosValue,X
        BMI b7CE1
        LDA lowerPlanetAttackShip3XPos,X
        LDY starFieldAnimationOffset
        BMI b7D07
        SEC 
        SBC starFieldAnimationOffset
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
        STA a7D1E
        INC a7D1E
        PLA 
        SEC 
        SBC a7D1E
        STA upperPlanetAttackShip2XPos,X
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
        STA lowerPlanetAttackShip3XPos,X
        BCC b7CE1
        JMP j7CD8

a7D1E                                         .BYTE $10
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
        STA f48BC,X
        BNE b7DAF
b7DA5   LDA #$FF
        STA lowerPlanetAttackShip2YPos,X
        LDA #$01
        STA f48B2,X
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
        STA a7D1E
        INC a7D1E
        LDA upperPlanetAttackShip2XPos,X
        SEC 
        SBC a7D1E
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
        STA a7D1E
        INC a7D1E
        LDA lowerPlanetAttackShip3XPos,X
        SEC 
        SBC a7D1E
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
upperPlanetAttackShipSpritesLoadedFromBackingData .BYTE $ED,$ED,$ED,$ED
lowerPlanetAttackShipSpritesLoadedFromBackingData .BYTE $ED,$ED,$ED,$ED
upperPlanetAttackShipSpriteAnimationEnd           .BYTE $F0,$F0,$F0,$F0
lowerPlanetAttackShipSpriteAnimationEnd           .BYTE $F0,$F0,$F0,$F0
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
        STA inAttractMode
        RTS 

b7EB8   LDA #$00
        STA lowerPlanetActivated
        LDA #$FF
        STA inAttractMode
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

inAttractMode   .BYTE $AD
randomJoystickInputCounter   .BYTE $09
randomJoystickInput   .BYTE $09
;------------------------------------------------------------------
; GenerateJoystickInputForAttractMode
;------------------------------------------------------------------
GenerateJoystickInputForAttractMode   
        LDA inAttractMode
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

.include "planet_data.asm"

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

lastBlastScore .TEXT "0000000...."
previousLastBlastScore          .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

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
        STA aCC88
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
        LDA aCC88
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
        LDX #$00
        LDA #$14
        STA aFB
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
        DEC aFB
        BNE bCA18
        LDA #$00
        STA aCA3B
        JMP ClearScreenDrawHiScoreScreenText

aCA3B   .BYTE $00
;------------------------------------------------------------------
; StoreLastBlastInTable
;------------------------------------------------------------------
StoreLastBlastInTable   
        LDA #$01
        STA aFA
        LDA aFB
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
        STA aF9
        TYA 
        PHA 
        CLC 
        ADC #$15
        TAY 
        LDA aF9
        STA (tempLoPtr1),Y
        PLA 
        TAY 
        INY 
        CPY #$15
        BNE bCA5B

        INC aFA
        LDA aFA
        CMP aFB
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
        STA aCA3B
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
        LDA #$01
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
        LDA aCA3B
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
        SBC aFB
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
;------------------------------------------------------------------
; GetHiScoreScreenInput
;------------------------------------------------------------------
GetHiScoreScreenInput   
        LDA hiScoreTableInputName - $0A,Y
        AND #$3F
        STA (tempLoPtr),Y
        STA aF8
        TYA 
        PHA 
        SEC 
        SBC #$03
        TAY 
        LDA aF8
        STA (tempLoPtr1),Y
        PLA 
        TAY 
        LDA $DC00    ;CIA1: Data Port Register A
        STA aFA
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

bCBC4   LDA aFA
        AND #$08
        BNE bCBE9
        LDA hiScoreTableInputName - $0A,Y
        CLC 
        ADC #$01
        CMP #$40
        BNE bCBD6
        LDA #$00
bCBD6   STA hiScoreTableInputName - $0A,Y

jCBD9   
        LDA #$50
        STA aF9
        LDX #$00
bCBDF   DEX 
        BNE bCBDF
        DEC aF9
        BNE bCBDF
        JMP GetHiScoreScreenInput

bCBE9   LDA aFA
        AND #$10
        BNE GetHiScoreScreenInput

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

;------------------------------------------------------------------
; DisplayHiScoreScreen
;------------------------------------------------------------------
DisplayHiScoreScreen   
        LDA #$01
        STA aCC88
        LDA #$00
        STA aCA3B

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

bCC43   STA aFA
        AND #$01
        BNE bCC67

        DEC currentEntryInHiScoreTable
        BPL bCC53

        LDA #$13
        STA currentEntryInHiScoreTable
bCC53   LDA #$50
        STA aF9
        LDX #$00
bCC59   DEX 
        BNE bCC59
        DEC aF9
        BNE bCC59

        LDA #$20
        STA (tempLoPtr),Y
bCC64   JMP DrawCamelAtPosition

bCC67   LDA aFA
        AND #$02
        BNE bCC7E

        INC currentEntryInHiScoreTable
        LDA currentEntryInHiScoreTable
        CMP #$14
        BNE bCC53

        LDA #$00
        STA currentEntryInHiScoreTable
        BEQ bCC53

bCC7E   LDA aFA
        AND #$10
        BNE bCC64

        JMP ExitHiScoreScreen

currentEntryInHiScoreTable   .BYTE $00
aCC88   .BYTE $01
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
        STA aF8
        TYA 
        PHA 
        SEC 
        SBC #$0B
        TAY 
        LDA aF8
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
        DEC aCD4B
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
        BMI bCD15


gameCompletionText   .TEXT "GAME COMPLETION CHART FOR ZARD, THE HERO"

bCD15   LDY #$07
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
        LDA #$04
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
        INC aCD4B
        RTS 

aCD4B   .BYTE $01
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
        LDA aCD4B
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
hiScoreColorSequence    .BYTE $0B,$0B,$0B,$0B,$0C,$0C,$0C,$0C
                        .BYTE $0F,$0F,$0F,$0F,$01,$01,$01,$01
hiScoreColorSequence2   .BYTE $02,$02,$08,$08,$08,$07,$07,$07
                        .BYTE $05,$05,$05,$0E,$0E,$0E,$07,$07
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
