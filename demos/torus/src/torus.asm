;
; **** ZP ABSOLUTE ADRESSES **** 
;
LastKeyPressed = $C5
spritePosOffsetTemp = $FA
;
ReEnterInterrupt = $EA31
;
; **** FIELDS **** 
;
SCREEN_RAM = $0400
COLOR_RAM = $D800
;
; **** ABSOLUTE ADRESSES **** 
;
a0314 = $0314
a0315 = $0315

BLACK        = $00
WHITE        = $01
RED          = $02
CYAN         = $03
PURPLE       = $04
GREEN        = $05
BLUE         = $06
YELLOW       = $07
ORANGE       = $08
BROWN        = $09
LTRED        = $0A
GRAY1        = $0B
GRAY2        = $0C
LTGREEN      = $0D
LTBLUE       = $0E
GRAY3        = $0F

sourceOfSeedBytes = $E024

        * = $0800

        .BYTE $00,$0B,$08,$0A,$00,$9E,$32,$30
        .BYTE $36,$34,$00,$00,$00,$00,$FF,$00
;-------------------------------------------------------
; JumpToEnterMainLoop   
;-------------------------------------------------------
JumpToEnterMainLoop   
        JMP EnterMainLoop

                    ;      C   C#  D   D#  E   F   F#  G   G#  A   A#  B
titleMusicHiBytes   .BYTE $08,$08,$09,$09,$0A,$0B,$0B,$0C,$0D,$0E,$0E,$0F  ; 4
                    .BYTE $10,$11,$12,$13,$15,$16,$17,$19,$1A,$1C,$1D,$1F  ; 5
                    .BYTE $21,$23,$25,$27,$2A,$2C,$2F,$32,$35,$38,$3B,$3F  ; 6
                    .BYTE $43,$47,$4B,$4F,$54,$59,$5E                      ; 7

                    ;      C   C#  D   D#  E   F   F#  G   G#  A   A#  B
titleMusicLoBytes   .BYTE $61,$E1,$68,$F7,$8F,$30,$DA,$8F,$4E,$18,$EF,$D2  ; 4
                    .BYTE $C3,$C3,$D1,$EF,$1F,$60,$B5,$1E,$9C,$31,$DF,$A5  ; 5
                    .BYTE $87,$86,$A2,$DF,$3E,$C1,$6B,$3C,$39,$63,$BE,$4B  ; 6
                    .BYTE $0F,$0C,$45,$BF,$7D,$83,$D6                      ; 7

 titleMusicNoteArray  .BYTE $00,$0C,$07,$07

 voice3NoteDuration            .BYTE $03
 voice2NoteDuration            .BYTE $0C
 voice1NoteDuration            .BYTE $30
 numberOfNotesToPlayInTune     .BYTE $90
 voice3IndexToMusicNoteArray   .BYTE $01
 voice2IndexToMusicNoteArray   .BYTE $01
 voice1IndexToMusicNoteArray   .BYTE $02
 notesPlayedSinceLastKeyChange .BYTE $00
 offsetForNextVoice2Note       .BYTE $13
 offsetForNextVoice1Note       .BYTE $07
 offsetForNextVoice3Note       .BYTE $13

;---------------------------------------------------------------
; PlayTitleScreenMusic
;---------------------------------------------------------------
PlayTitleScreenMusic   
        DEC numberOfNotesToPlayInTune
        BNE MaybePlayVoice1

        JSR MusicSeedArray

        ; Set up a new tune.
        LDA #$C0
        STA numberOfNotesToPlayInTune

        LDX notesPlayedSinceLastKeyChange
        LDA titleMusicNoteArray,X
        STA offsetForNextVoice1Note

        ; We'll only select a new tune when we've reached the
        ; beginning of a new 16 bar structure.
        INX 
        TXA 
        AND #$03
        STA notesPlayedSinceLastKeyChange

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

        JSR PlayVoice1

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
        JSR PlayVoice2
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
        JSR PlayVoice3

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

;------------------------------------------------------------
; PlayVoice1
;------------------------------------------------------------
PlayVoice1   
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA titleMusicLoBytes,Y
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        RTS 

;------------------------------------------------------------
; PlayVoice2
;------------------------------------------------------------
PlayVoice2   
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        LDA titleMusicLoBytes,Y
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        RTS 

;------------------------------------------------------------
; PlayVoice3
;------------------------------------------------------------
PlayVoice3   
        LDA #$21
        STA $D412    ;Voice 3: Control Register
        LDA titleMusicLoBytes,Y
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        RTS 

;------------------------------------------------------------
; SetUpMainSound
;------------------------------------------------------------
SetUpMainSound   
        LDA #$0F
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        LDA #$F5
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control
        RTS 

;------------------------------------------------------------
; MusicSeedArray
;------------------------------------------------------------
MusicSeedArray   
        LDX oscillator1Value
        LDA titleMusicSeedArray,X
        STA titleMusicNoteArray
        LDX oscillator2Value
        LDA titleMusicSeedArray,X
        STA titleMusicNoteArray + $01
        LDX oscillator3Value
        LDA titleMusicSeedArray,X
        STA titleMusicNoteArray + $02
        LDX oscillator4Value
        LDA titleMusicSeedArray,X
        STA titleMusicNoteArray + $03
        RTS 


titleMusicSeedArray .BYTE $00,$03,$07,$09
                    .BYTE $05,$0C,$07,$03
                    .BYTE $00,$03,$07,$09
                    .BYTE $05,$0C,$07,$03

spritePositionArray   .BYTE $40,$46,$4C,$52,$58,$5E,$63,$68
                      .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
                      .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
                      .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
                      .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
                      .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
                      .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
                      .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
                      .BYTE $FF
textDisplayEnabled  .BYTE $01
shouldReset         .BYTE $00
currSpriteXPos      .BYTE $5E
currSpriteYPos      .BYTE $2D
offsetForSPriteXPos .BYTE $68
offsetForSpriteYPos .BYTE $75

;-------------------------------------------------------
; EnterMainLoop   
;-------------------------------------------------------
EnterMainLoop   
        SEI 
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        JSR SetUpMainSound
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$00
        STA shouldReset
        LDA #<MainInterruptHandler
        STA a0314    ;IRQ
        LDA #>MainInterruptHandler
        STA a0315    ;IRQ
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$F0
        STA $D012    ;Raster Position
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$01
        STA $D025    ;Sprite Multi-Color Register 0
        STA $D026    ;Sprite Multi-Color Register 1
        CLI 
        LDA #$FF
        STA $D015    ;Sprite display Enable
        STA $D01C    ;Sprites Multi-Color Mode Select

        LDX #$00
b0A07   LDA #$20
        STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0300,X
        LDA #$0B
        STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA COLOR_RAM + $0300,X
        DEX 
        BNE b0A07

        LDA textDisplayEnabled
        BEQ b0A2E
        JSR WriteMainTextToScreen
b0A2E   LDX #$07
b0A30   LDA #$90
        STA SCREEN_RAM + $03F8,X
        LDA spriteColors,X
        STA $D027,X  ;Sprite 0 Color
        DEX 
        BPL b0A30

MainLoop   
        JSR GetKeyPressed
        LDA shouldReset
        BEQ b0A4F

b0A46   LDA LastKeyPressed
        CMP #$40
        BNE b0A46
        JMP JumpToEnterMainLoop

b0A4F   JMP MainLoop

;-------------------------------------------------------
; MainInterruptHandler   
;-------------------------------------------------------
MainInterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE RunMainInterruptHandler
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

counterBetweeXPosUpdates                  .BYTE $01
initialCounterBetweenXPosUpdates          .BYTE $02
initialCounterBetweenYPosUpdates          .BYTE $01
counterBetweenYPosUpdates                 .BYTE $01
noOfSpritesToUpdate                       .BYTE $2E
indexForXPosInSpritePositionArray         .BYTE $0D
indexForYPosInSpritePositionArray         .BYTE $C5
oscillator3WorkingValue                   .BYTE $04
oscillator3Value                          .BYTE $06
oscillator4WorkingValue                   .BYTE $02
oscillator4Value                          .BYTE $02,$01,$01
indexForXPosOffetsetInSpritePositionArray .BYTE $CF
inxedForYPosOffsetInSpritePositionArray   .BYTE $D2
spriteColors                              .BYTE RED,LTRED,ORANGE,YELLOW,GREEN,LTBLUE,PURPLE,BLUE


;-------------------------------------------------------
; RunMainInterruptHandler   
;-------------------------------------------------------
RunMainInterruptHandler   
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
        LDA spritePositionArray,X
        STA currSpriteXPos

        LDA indexForYPosInSpritePositionArray
        AND #$3F
        TAX 
        LDA spritePositionArray,X
        STA currSpriteYPos

        LDA indexForXPosOffetsetInSpritePositionArray
        AND #$3F
        TAX 
        LDA spritePositionArray,X
        STA offsetForSPriteXPos

        LDA inxedForYPosOffsetInSpritePositionArray
        AND #$3F
        TAX 
        LDA spritePositionArray,X
        STA offsetForSpriteYPos

        JSR UpdateSpritePosition

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

        LDA #$C0
        STA noOfSpritesToUpdate
        LDA autoOn
        BNE AnimationFrameFinished

        ; Auto is on so generate procedural/random values for oscillators.
GenerateValuesForOscillators
        JSR PutProceduralByteInAccumulator
        AND #$07
        CLC 
        ADC #$04
        TAX 
        STX oscillator1Value

        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenXPosUpdates

        LDA positionIncrementArray,X
        STA incrementForXPos

        JSR PutProceduralByteInAccumulator
        AND #$07
        CLC 
        ADC #$04
        TAX 
        STX oscillator2Value

        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenYPosUpdates

        LDA positionIncrementArray,X
        STA incrementForYPos

        JSR PutProceduralByteInAccumulator
        AND #$07
        CLC 
        ADC #$01
        STA oscillator3WorkingValue
        STA oscillator3Value

        JSR PutProceduralByteInAccumulator
        AND #$07
        CLC 
        ADC #$01
        STA oscillator4WorkingValue
        STA oscillator4Value

AnimationFrameFinished   
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR UpdateHeadsUpDisplay
        JSR PlayTitleScreenMusic
        INC $D025    ;Sprite Multi-Color Register 0
        JMP ReEnterInterrupt

;-------------------------------------------------------
; PutProceduralByteInAccumulator   
;-------------------------------------------------------
PutProceduralByteInAccumulator   
srcOfProceduralBytes   =*+$01
        LDA sourceOfSeedBytes
        INC srcOfProceduralBytes
        RTS 

;-------------------------------------------------------
; UpdateSpritePosition   
;-------------------------------------------------------
UpdateSpritePosition   
        LDA currSpriteXPos
        LDX oscillator3Value
        BEQ UpdateSpriteXPos

        JSR AdjustSpriteXPos
        JMP MaybeUpdateSpriteYPos

UpdateSpriteXPos   
        CLC 
        ADC #$68
        STA $D000,Y  ;Sprite 0 X Pos

MaybeUpdateSpriteYPos   
        LDA currSpriteYPos
        LDX oscillator4Value
        BEQ UpdateSpriteYPos

        JMP AdjustSpriteYPos

UpdateSpriteYPos   
        CLC 
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

incrementForXPos               .BYTE $01
incrementForYPos               .BYTE $03
intervalBetweenPosUpdatesArray .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                               .BYTE $02,$03,$04,$05,$06,$07,$08,$09
positionIncrementArray         .BYTE $08,$07,$06,$05,$04,$03,$02,$01
                               .BYTE $01,$01,$01,$01,$01,$01,$01,$01
;-------------------------------------------------------
; AdjustSpriteXPos   
;-------------------------------------------------------
AdjustSpriteXPos   
        LDA currSpriteXPos
        CLC 
        ROR 
        STA spritePosOffsetTemp
        LDA offsetForSPriteXPos
        CLC 
        ROR 
        CLC 
        ADC spritePosOffsetTemp
        ADC #$68
        STA $D000,Y  ;Sprite 0 X Pos
        RTS 

;-------------------------------------------------------
; AdjustSpriteYPos   
;-------------------------------------------------------
AdjustSpriteYPos   
        LDA currSpriteYPos
        CLC 
        ROR 
        STA spritePosOffsetTemp
        LDA offsetForSpriteYPos
        CLC 
        ROR 
        CLC 
        ADC spritePosOffsetTemp
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

;-------------------------------------------------------
; WriteMainTextToScreen   
;-------------------------------------------------------
WriteMainTextToScreen   
        LDX #$27
b0C2A   LDA f0C66,X
        AND #$3F
        STA SCREEN_RAM + $0028,X
        LDA f0C8E,X
        AND #$3F
        STA SCREEN_RAM + $00A0,X
        LDA f0CB6,X
        AND #$3F
        STA SCREEN_RAM + $01B8,X
        LDA f0CDE,X
        AND #$3F
        STA SCREEN_RAM + $0208,X
        LDA f0D56,X
        AND #$3F
        STA SCREEN_RAM + $0258,X
        LDA f0D2E,X
        AND #$3F
        STA SCREEN_RAM + $0320,X
        LDA f0D06,X
        AND #$3F
        STA SCREEN_RAM + $02D0,X
        DEX 
        BPL b0C2A
        RTS 

f0C66   .TEXT "     *  *  *  TAURUS:TORUS  *  *  *     "
f0C8E   .TEXT "ANOTHER FROM THE DNA STABLE....   BY YAK"
f0CB6   .TEXT "AUTO: OSC 1,0: OSC 2,0: OSC 3,0: OSC 4,0"
f0CDE   .TEXT "SPACE=AUTO ON/OFF  KEYS Z,X,C,V FOR OSCS"
f0D06   .TEXT "FRACTAL SOUND STRUCTURE DEMO FROM IRIDIS"
f0D2E   .TEXT "SEE JUNE BYTE FOR MORE ON FRACTAL MUSIC."
f0D56   .TEXT "TEXT DISPLAY ON/OFF PRESS THE F1 KEY...."

;-------------------------------------------------------
; UpdateHeadsUpDisplay   
;-------------------------------------------------------
UpdateHeadsUpDisplay   
        LDX oscillator1Value
        LDA textDisplayEnabled
        BNE b0D87
        RTS 

b0D87   LDA textCurrentValue,X
        AND #$3F
        STA SCREEN_RAM + $01C4
        LDX oscillator2Value
        LDA textCurrentValue,X
        AND #$3F
        STA SCREEN_RAM + $01CD
        LDX oscillator3Value
        LDA textCurrentValue,X
        AND #$3F
        STA SCREEN_RAM + $01D6
        LDX oscillator4Value
        LDA textCurrentValue,X
        AND #$3F
        STA SCREEN_RAM + $01DF
        LDA autoOn
        BNE b0DC3

        LDX #$03
b0DB7   LDA textAuto,X
        AND #$3F
        STA SCREEN_RAM + $01B8,X
        DEX 
        BPL b0DB7
        RTS 

b0DC3   LDX #$03
b0DC5   LDA textKeys,X
        AND #$3F
        STA SCREEN_RAM + $01B8,X
        DEX 
        BPL b0DC5
        RTS 

autoOn   .BYTE $00
textAuto         .TEXT "AUTO"
textKeys         .TEXT "KEYS"
textCurrentValue .TEXT "0123456789ABCDEF"
;-------------------------------------------------------
; GetKeyPressed   
;-------------------------------------------------------
GetKeyPressed   
        LDA LastKeyPressed
        CMP #$40
        BNE MaybeSpacePressed
        RTS 

MaybeSpacePressed   
        CMP #$3C
        BNE MaybeZKeyPressed

        ; Space pressed.
        LDA autoOn
        EOR #$01
        STA autoOn
        JMP ContinueCheckingForKeyPress

      
MaybeZKeyPressed   
        CMP #$0C
        BNE MaybeXKeyPressed

        ; Update Oscillator 1
        LDA oscillator1Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator1Value

        TAX 
        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenXPosUpdates
        LDA positionIncrementArray,X
        STA incrementForXPos
        JMP ContinueCheckingForKeyPress

MaybeXKeyPressed   
        CMP #$17
        BNE MaybeCKeyPressed

        ; Update Oscillator 2
        LDA oscillator2Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator2Value
        TAX 
        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenYPosUpdates
        LDA positionIncrementArray,X
        STA incrementForYPos
        JMP ContinueCheckingForKeyPress

MaybeCKeyPressed   
        CMP #$14
        BNE MaybeVKeyPressed

        ; Update Oscillator 3
        LDA oscillator3Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator3Value
        JMP ContinueCheckingForKeyPress

MaybeVKeyPressed   
        CMP #$1F
        BNE MaybeF1Pressed

        ; Update Oscillator 4
        LDA oscillator4Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator4Value

ContinueCheckingForKeyPress   
        LDA LastKeyPressed
        CMP #$40
        BNE ContinueCheckingForKeyPress
        RTS 

MaybeF1Pressed   
        CMP #$04
        BNE ReturnFromKeyPressed

        ; F1 Pressed, disable text
        LDA textDisplayEnabled
        EOR #$01
        STA textDisplayEnabled
        INC shouldReset

ReturnFromKeyPressed   
        RTS 

oscillator1Value   .BYTE $08
oscillator2Value   .BYTE $05
        .BYTE $C4,$09,$EE,$C5,$09,$60,$0B
        .BYTE $0A

        * = $2000

.include "charset.asm"
.include "sprites.asm"
