;
; **** ZP ABSOLUTE ADRESSES **** 
;
a1C = $1C
a1D = $1D
a1E = $1E
a1F = $1F
LastKeyPressed = $C5
aFA = $FA
;
; **** ZP POINTERS **** 
;
p1E = $1E
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
a05C4 = $05C4
a05CD = $05CD
a05D6 = $05D6
a05DF = $05DF
sourceOfSeedBytes = $E000
;
; **** EXTERNAL JUMPS **** 
;
eEA31 = $EA31

*=$0800

        .BYTE $00,$0B,$08,$0A,$00,$9E,$32,$30
        .BYTE $36,$34,$00,$00,$00,$00,$FF,$00
JumpToEnterMainLoop   
        JMP EnterMainLoop

titleMusicHiBytes   .BYTE $08,$08,$09,$09,$0A,$0B,$0B,$0C,$0D,$0E,$0E,$0F  ; 4
                    .BYTE $10,$11,$12,$13,$15,$16,$17,$19,$1A,$1C,$1D,$1F  ; 5
                    .BYTE $21,$23,$25,$27,$2A,$2C,$2F,$32,$35,$38,$3B,$3F  ; 6
                    .BYTE $43,$47,$4B,$4F,$54,$59,$5E,$64,$6A,$70,$77,$7E  ; 7
                    .BYTE $86,$8E,$96,$9F,$A8,$B3,$BD,$C8,$D4,$E1,$EE,$FD  ; 8

                    ;      C   C#  D   D#  E   F   F#  G   G#  A   A#  B
titleMusicLoBytes   .BYTE $61,$E1,$68,$F7,$8F,$30,$DA,$8F,$4E,$18,$EF,$D2  ; 4
                    .BYTE $C3,$C3,$D1,$EF,$1F,$60,$B5,$1E,$9C,$31,$DF,$A5  ; 5
                    .BYTE $87,$86,$A2,$DF,$3E,$C1,$6B,$3C,$39,$63,$BE,$4B  ; 6
                    .BYTE $0F,$0C,$45,$BF,$7D,$83,$D6,$79,$73,$C7,$7C,$97  ; 7
                    .BYTE $1E,$18,$8B,$7E,$FA,$06,$AC,$F3,$E6,$8F,$F8,$2E  ; 8

titleMusicNoteArray   .BYTE $00,$07,$0C,$07

voice3NoteDuration            .BYTE $01
voice2NoteDuration            .BYTE $01
voice1NoteDuration            .BYTE $01
numberOfNotesToPlayInTune     .BYTE $01
voice3IndexToMusicNoteArray   .BYTE $00
voice2IndexToMusicNoteArray   .BYTE $00
voice1IndexToMusicNoteArray   .BYTE $00
notesPlayedSinceLastKeyChange .BYTE $00
offsetForNextVoice3Note       .BYTE $00
offsetForNextVoice2Note       .BYTE $00
offsetForNextVoice1Note       .BYTE $00
;-------------------------------------------------------
; PlayTitleScreenMusic   
;-------------------------------------------------------
PlayTitleScreenMusic   
        LDA UnusedValue1
        STA UnusedValue2

MaybeStartNewTune   
        DEC numberOfNotesToPlayInTune
        BNE MaybePlayVoice1

        ; Set up a new tune.
        LDA #$C0
        STA numberOfNotesToPlayInTune

        LDX notesPlayedSinceLastKeyChange
        LDA titleMusicNoteArray,X
        STA offsetForNextVoice2Note

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
        ADC offsetForNextVoice2Note
        TAY 
        STY offsetForNextVoice3Note

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
        ADC offsetForNextVoice3Note

        ; Use this new value to change the key of the next four
        ; notes played by voice 1. 
        STA offsetForNextVoice1Note

        TAY 
        JSR PlayNoteVoice2
        INX 
        TXA 
        AND #$03
        STA voice2IndexToMusicNoteArray

MaybePlayVoice3   
        DEC voice3NoteDuration
        BNE ReturnFromTitleMusic

        LDA #$03
        STA voice3NoteDuration

        ; Play the note currently pointed to by 
        ; voice3IndexToMusicNoteArray in titleMusicNoteArray.
        LDX voice3IndexToMusicNoteArray
        LDA titleMusicNoteArray,X
        CLC 
        ADC offsetForNextVoice1Note
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

ReturnFromTitleMusic   
        RTS 

;-------------------------------------------------------
; PlayNoteVoice1   
;-------------------------------------------------------
PlayNoteVoice1   
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA titleMusicLoBytes,Y
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
        LDA titleMusicLoBytes,Y
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        RTS 

;-------------------------------------------------------
; PlayNoteVoice3   
;-------------------------------------------------------
PlayNoteVoice3   
        LDA #$21
        STA $D412    ;Voice 3: Control Register
        LDA titleMusicLoBytes,Y
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

        .BYTE $00,$03,$06,$08,$00,$0C,$04,$08
        .BYTE $00,$07,$00,$05,$05,$00,$00,$05
        .BYTE $00,$06,$09,$05,$02,$04,$03,$04
        .BYTE $03,$07,$03,$00,$04,$08,$0C,$09
        .BYTE $07,$08,$04,$07,$00,$04,$07,$0E
        .BYTE $00,$00,$00,$07,$07,$04,$00,$0C
        .BYTE $04,$07,$00,$0C,$07,$08,$0A,$08
        .BYTE $0C,$00,$0C,$03,$0C,$03,$07,$00

;-------------------------------------------------------
; SelectNewNotesToPlay   
;-------------------------------------------------------
SelectNewNotesToPlay   
        LDY initialCounterBetweenXPosUpdats
        LDA titleMusicSeedArray,Y
        STA titleMusicNoteArray
        LDY initialCounterBetweenYPosUpdates
        LDA titleMusicSeedArray,Y
        STA titleMusicNoteArray + $01
        LDY oscillator3Value
        LDA titleMusicSeedArray,Y
        STA titleMusicNoteArray + $02
        LDY oscillator4Value
        LDA titleMusicSeedArray,Y
        STA titleMusicNoteArray + $03
        RTS 

UnusedValue2   .BYTE $01
UnusedValue1   .BYTE $01
a09DB   =*+$01
        LDA sourceOfSeedBytes
        INC a09DB
        RTS 

titleMusicSeedArray .BYTE $00,$03,$04,$07,$09,$0A,$0C,$07
                    .BYTE $07,$04,$9C,$0C,$00,$00,$03
;-------------------------------------------------------
; ClearOscillatorBackgroundData   
;-------------------------------------------------------
ClearOscillatorBackgroundData   
        LDX #$7F
        LDA #$00
b09F4   STA backgroundOscillatorData,X
        DEX 
        BPL b09F4
        RTS 

f09FB   .BYTE $00,$02,$04,$06,$20,$22,$24,$26
        .BYTE $40,$42,$44,$46,$60,$62,$64,$66
f0A0B   .BYTE $00,$00,$00,$00,$08,$08,$08,$08
        .BYTE $10,$10,$10,$10,$18,$18,$18,$18
f0A1B   .BYTE $C0,$30,$0C,$03,$C0,$30,$0C,$03
        .BYTE $C0,$30,$0C,$03,$C0,$30,$0C,$03
;-------------------------------------------------------
; UpdateBackgroundOscillator   
;-------------------------------------------------------
UpdateBackgroundOscillator   
        LDA f09FB,Y
        CLC 
        ADC f0A0B,X
        TAY 
        LDA backgroundOscillatorData,Y
        ORA f0A1B,X
        STA backgroundOscillatorData,Y
        STA backgroundOscillatorData + $01,Y
        RTS 

;-------------------------------------------------------
; j0A40   
;-------------------------------------------------------
j0A40   
        LDX #$0F
b0A42   LDY f0A99,X
        TXA 
        CLC 
        ADC #$80
        STA (p1E),Y
        LDA a1F
        PHA 
        CLC 
        ADC #$D4
        STA a1F
        LDA a0AC2
        STA (p1E),Y
        PLA 
        STA a1F
        DEX 
        BPL b0A42
        RTS 
;-------------------------------------------------------
; DrawWithoutText   
;-------------------------------------------------------
DrawWithoutText   
        LDA #$00
        STA a1C
        STA a1D

b0A65   LDX a1C
        LDA f0AB0,X
        STA a1E
        LDA f0AA9,X
        STA a1F

j0A71   JSR s0AC3
        INC a1D
        LDA a1D
        CMP #$0A
        BEQ b0A8C
        LDA a1E
        CLC 
        ADC #$04
        STA a1E
        LDA a1F
        ADC #$00
        STA a1F
        JMP j0A71

b0A8C   LDA #$00
        STA a1D
        INC a1C
        LDA a1C
        CMP #$06
        BNE b0A65
        RTS 

f0A99   .BYTE $00,$01,$02,$03,$28,$29,$2A,$2B
        .BYTE $50,$51,$52,$53,$78,$79,$7A,$7B
f0AA9   .BYTE $04,$04,$05,$05,$06,$07,$07
f0AB0   .BYTE $00,$A0,$40,$E0,$80,$20,$C0
f0AB7   .BYTE $01,$0F,$0C,$0F,$0B,$0B,$0F,$0C
        .BYTE $0F,$01
a0AC1   .BYTE $00
a0AC2   .BYTE $00
;-------------------------------------------------------
; s0AC3   
;-------------------------------------------------------
s0AC3   
        TXA 
        PHA 
        LDX a0AC1
        LDA f0AB7,X
        STA a0AC2
        INX 
        CPX #$0A
        BNE b0AD5
        LDX #$00
b0AD5   STX a0AC1
        PLA 
        TAX 
        JMP j0A40
        ; Returns

spritePositionArray   
        .BYTE $40,$46,$4C,$52,$58,$5E,$63,$68
        .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
        .BYTE $7F,$7F,$7E,$7D,$7B,$78,$75,$71
        .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
        .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
        .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
        .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
        .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
        .BYTE $FF
textDisplayEnabled   .BYTE $01
shouldReset   .BYTE $00
currSpriteXPos   .BYTE $46
currSpriteYPos   .BYTE $75
offsetForSpriteXPos   .BYTE $58
offsetForSpriteYPos   .BYTE $33
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

        ; Clear Screen
        LDX #$00
ClearScreenLoop   
        LDA #$20
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
        BNE ClearScreenLoop

        LDA textDisplayEnabled
        BEQ b0B93
        JSR WriteTextToScreen
        JMP UpdateSPriteColors
        ; Returns

b0B93   
        JSR DrawWithoutText

UpdateSPriteColors   
        LDX #$07
UpdateSpriteColorLoop   
        LDA #$98
        STA SCREEN_RAM + $03F8,X
        LDA spriteColors,X
        STA $D027,X  ;Sprite 0 Color
        DEX 
        BPL UpdateSpriteColorLoop

j0BA6   JSR GetKeyPressed
        LDA shouldReset
        BEQ b0BB7

b0BAE   LDA LastKeyPressed
        CMP #$40
        BNE b0BAE
        JMP JumpToEnterMainLoop

b0BB7   JMP j0BA6

;-------------------------------------------------------
; MainInterruptHandler   
;-------------------------------------------------------
MainInterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE HandleInterrupt
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

counterBetweenXPosUpdates               .BYTE $04
initialCounterBetweenXPosUpdats         .BYTE $04
initialCounterBetweenYPosUpdates        .BYTE $02
counterBetweenYPosUpdates               .BYTE $02
noOfSpritesToUpdate                     .BYTE $9C
indexForXposInSpritePositionArray       .BYTE $09
indexForYPosInSpritePositionArray       .BYTE $12
oscillator3WorkingValue                 .BYTE $03
oscillator3Value                        .BYTE $03
oscillator4WorkingValue                 .BYTE $06
oscillator4Value                        .BYTE $06,$01,$01
indexForXPosOFfsetinSpritePositionArray .BYTE $0C
indexForYPosOffsetInSpritePositionArray .BYTE $06
spriteColors                            .BYTE $02,$0A,$08,$07,$05,$0E,$04,$06
;-------------------------------------------------------
; HandleInterrupt   
;-------------------------------------------------------
HandleInterrupt   
        LDY #$00
        JSR ClearOscillatorBackgroundData
        LDA #$F0
        STA $D012    ;Raster Position
        DEC counterBetweenXPosUpdates
        BNE MaybeUpdateYPos

        LDA initialCounterBetweenXPosUpdats
        STA counterBetweenXPosUpdates

        LDA incrementForXPos
        CLC 
        ADC indexForXposInSpritePositionArray
        STA indexForXposInSpritePositionArray

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
        INC indexForXPosOFfsetinSpritePositionArray

MaybeResetOsc4WorkingValue   
        DEC oscillator4WorkingValue
        BNE InitializeSpriteAnimation
        LDA oscillator4Value
        STA oscillator4WorkingValue
        INC indexForYPosOffsetInSpritePositionArray

InitializeSpriteAnimation   
        LDA indexForXposInSpritePositionArray
        PHA 
        LDA indexForYPosInSpritePositionArray
        PHA 
        LDA indexForXPosOFfsetinSpritePositionArray
        PHA 
        LDA indexForYPosOffsetInSpritePositionArray
        PHA 

SpriteAnimationLoop   
        LDA indexForXposInSpritePositionArray
        AND #$3F
        TAX 
        LDA spritePositionArray,X
        STA currSpriteXPos

        LDA indexForYPosInSpritePositionArray
        AND #$3F
        TAX 
        LDA spritePositionArray,X
        STA currSpriteYPos

        LDA indexForXPosOFfsetinSpritePositionArray
        AND #$3F
        TAX 
        LDA spritePositionArray,X
        STA offsetForSpriteXPos

        LDA indexForYPosOffsetInSpritePositionArray
        AND #$3F
        TAX 
        LDA spritePositionArray,X
        STA offsetForSpriteYPos
        JSR UpdateSpritePosition
        LDA indexForYPosOffsetInSpritePositionArray
        CLC 
        ADC #$08
        STA indexForYPosOffsetInSpritePositionArray
        LDA indexForXPosOFfsetinSpritePositionArray
        CLC 
        ADC #$08
        STA indexForXPosOFfsetinSpritePositionArray
        LDA indexForYPosInSpritePositionArray
        CLC 
        ADC #$08
        STA indexForYPosInSpritePositionArray
        LDA indexForXposInSpritePositionArray
        CLC 
        ADC #$08
        STA indexForXposInSpritePositionArray
        INY 
        INY 
        CPY #$10
        BNE SpriteAnimationLoop
        PLA 
        STA indexForYPosOffsetInSpritePositionArray
        PLA 
        STA indexForXPosOFfsetinSpritePositionArray
        PLA 
        STA indexForYPosInSpritePositionArray
        PLA 
        STA indexForXposInSpritePositionArray
        DEC noOfSpritesToUpdate
        BNE UpdateDisplayAndPlayMusic

        LDA #$C0
        STA noOfSpritesToUpdate
        LDA autoOn
        BNE UpdateDisplayAndPlayMusic

        JSR PutProceduralBytesInAccumulator
        AND #$07
        CLC 
        ADC #$04
        TAX 
        STX oscillator1Value
        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenXPosUpdats
        LDA positionIncrementARray,X
        STA incrementForXPos
        JSR PutProceduralBytesInAccumulator
        AND #$07
        CLC 
        ADC #$04
        TAX 
        STX oscillator2Value
        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenYPosUpdates
        LDA positionIncrementARray,X
        STA incrementForYPos
        JSR PutProceduralBytesInAccumulator
        AND #$07
        CLC 
        ADC #$01
        STA oscillator3WorkingValue
        STA oscillator3Value
        JSR PutProceduralBytesInAccumulator
        AND #$07
        CLC 
        ADC #$01
        STA oscillator4WorkingValue
        STA oscillator4Value

UpdateDisplayAndPlayMusic   
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR UpdateHeadsUpDisplay
        JSR PlayTitleScreenMusic
        INC $D025    ;Sprite Multi-Color Register 0
        JMP eEA31

;-------------------------------------------------------
; PutProceduralBytesInAccumulator   
;-------------------------------------------------------
PutProceduralBytesInAccumulator   
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
        BEQ UpdateSPriteYPos
        JMP AdjustSpriteYPos

UpdateSPriteYPos   
        CLC 
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        JSR UpdateBackground
        RTS 

incrementForXPos   .BYTE $01
incrementForYPos   .BYTE $01
intervalBetweenPosUpdatesArray .BYTE $01,$01,$01,$01,$01,$01,$01,$01
                               .BYTE $02,$03,$04,$05,$06,$07,$08,$09
positionIncrementARray         .BYTE $08,$07,$06,$05,$04,$03,$02,$01
                               .BYTE $01,$01,$01,$01,$01,$01,$01,$01
;-------------------------------------------------------
; AdjustSpriteXPos   
;-------------------------------------------------------
AdjustSpriteXPos   
        LDA currSpriteXPos
        CLC 
        ROR 
        STA aFA
        LDA offsetForSpriteXPos
        CLC 
        ROR 
        CLC 
        ADC aFA
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
        STA aFA
        LDA offsetForSpriteYPos
        CLC 
        ROR 
        CLC 
        ADC aFA
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        JSR UpdateBackground
        RTS 
;-------------------------------------------------------
; WriteTextToScreen   
;-------------------------------------------------------
WriteTextToScreen   
        LDX #$27
b0D9B   LDA f0DD7,X
        AND #$3F
        STA SCREEN_RAM + $0028,X
        LDA f0DFF,X
        AND #$3F
        STA SCREEN_RAM + $00A0,X
        LDA f0E27,X
        AND #$3F
        STA SCREEN_RAM + $01B8,X
        LDA f0E4F,X
        AND #$3F
        STA SCREEN_RAM + $0208,X
        LDA f0EC7,X
        AND #$3F
        STA SCREEN_RAM + $0258,X
        LDA f0E9F,X
        AND #$3F
        STA SCREEN_RAM + $0320,X
        LDA f0E77,X
        AND #$3F
        STA SCREEN_RAM + $02D0,X
        DEX 
        BPL b0D9B
        RTS 

f0DD7   .TEXT "\ NOW EVEN FREAKIER: TAURUS/TORUS TWO  \"
f0DFF   .TEXT "TUNED UP AND WITH AN EXTRA DISPLAY......"
f0E27   .TEXT "AUTO: OSC 1,0: OSC 2,0: OSC 3,0: OSC 4,0"
f0E4F   .TEXT "SPACE=AUTO ON/OFF  KEYS Z,X,C,V FOR OSCS"
f0E77   .TEXT "DEMO BY YAK.... CROSSEYED AND PAINLESS.."
f0E9F   .TEXT "I WONDER IF GOATS LIKE FRACTALS, TOO?..."
f0EC7   .TEXT "PRESS F1 TO SEE THE NEW WEIRD DISPLAY..."

;-------------------------------------------------------
; UpdateHeadsUpDisplay   
;-------------------------------------------------------
UpdateHeadsUpDisplay   
        LDX oscillator1Value
        LDA textDisplayEnabled
        BNE b0EF8
        RTS 

b0EF8   LDA f0F4B,X
        AND #$3F
        STA a05C4
        LDX oscillator2Value
        LDA f0F4B,X
        AND #$3F
        STA a05CD
        LDX oscillator3Value
        LDA f0F4B,X
        AND #$3F
        STA a05D6
        LDX oscillator4Value
        LDA f0F4B,X
        AND #$3F
        STA a05DF
        LDA autoOn
        BNE b0F34
        LDX #$03
b0F28   LDA f0F43,X
        AND #$3F
        STA SCREEN_RAM + $01B8,X
        DEX 
        BPL b0F28
        RTS 

b0F34   LDX #$03
b0F36   LDA f0F47,X
        AND #$3F
        STA SCREEN_RAM + $01B8,X
        DEX 
        BPL b0F36
        RTS 

autoOn   .BYTE $00
f0F43   .BYTE $41,$55,$54,$4F
f0F47   .BYTE $4B,$45,$59,$53
f0F4B   .BYTE $30,$31,$32,$33,$34,$35,$36,$37
        .BYTE $38,$39,$41,$42,$43,$44,$45,$46
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

        LDA autoOn
        EOR #$01
        STA autoOn
        JMP ContinueCheckingForKeyPresses

MaybeZKeyPressed   
        CMP #$0C
        BNE MaybeXKeyPressed

        LDA oscillator1Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator1Value
        TAX 
        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenXPosUpdats
        LDA positionIncrementARray,X
        STA incrementForXPos
        JMP ContinueCheckingForKeyPresses

MaybeXKeyPressed   
        CMP #$17
        BNE MaybeCKeyPressed

        LDA oscillator2Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator2Value
        TAX 
        LDA intervalBetweenPosUpdatesArray,X
        STA initialCounterBetweenYPosUpdates
        LDA positionIncrementARray,X
        STA incrementForYPos
        JMP ContinueCheckingForKeyPresses

MaybeCKeyPressed   
        CMP #$14
        BNE MaybeVKeyPressed

        LDA oscillator3Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator3Value
        JMP ContinueCheckingForKeyPresses

MaybeVKeyPressed   
        CMP #$1F
        BNE MaybF1Pressed

        LDA oscillator4Value
        CLC 
        ADC #$01
        AND #$0F
        STA oscillator4Value

ContinueCheckingForKeyPresses   
        LDA LastKeyPressed
        CMP #$40
        BNE ContinueCheckingForKeyPresses
        RTS 

MaybF1Pressed   
        CMP #$04
        BNE ReturnFromKeyPRessed

        LDA textDisplayEnabled
        EOR #$01
        STA textDisplayEnabled
        INC shouldReset

ReturnFromKeyPRessed   RTS 

oscillator1Value   .BYTE $01
oscillator2Value   .BYTE $01
;-------------------------------------------------------
; UpdateBackground   
;-------------------------------------------------------
UpdateBackground   
        TYA 
        PHA 
        LDA $D000,Y  ;Sprite 0 X Pos
        SEC 
        SBC #$68
        CLC 
        ROR 
        CLC 
        ROR 
        CLC 
        ROR 
        PHA 
        LDA $D001,Y  ;Sprite 0 Y Pos
        SEC 
        SBC #$40
        CLC 
        ROR 
        CLC 
        ROR 
        CLC 
        ROR 
        TAY 
        PLA 
        TAX 
        JSR UpdateBackgroundOscillator
        PLA 
        TAY 
        RTS 


* = $2000
.include "charset.asm"

        .BYTE $00,$00,$20,$00,$88,$00,$22,$00
        .BYTE $55,$55,$7A,$7A,$7A,$50,$55,$55
        .BYTE $00,$00,$20,$00,$88,$00,$22,$00
        .BYTE $55,$55,$A1,$A1,$A1,$01,$55,$55
        .BYTE $55,$7A,$7A,$7A,$7A,$7A,$7A,$7A
        .BYTE $7A,$7A,$7A,$7A,$7A,$40,$55,$55
        .BYTE $55,$A1,$A1,$A1,$A1,$A1,$A1,$A1
        .BYTE $A1,$A1,$A1,$A1,$A1,$01,$55,$55
        .BYTE $00,$0D,$FD,$0D,$BD,$0D,$0F,$BE
        .BYTE $0F,$FD,$0D,$0D,$BD,$0D,$00,$00
        .BYTE $00,$00,$40,$50,$54,$E1,$A1,$A1
        .BYTE $A1,$E1,$54,$50,$40,$00,$00,$00
        .BYTE $00,$23,$0D,$35,$D5,$55,$5E,$7A
        .BYTE $5E,$55,$D5,$35,$0D,$03,$03,$03
        .BYTE $00,$48,$50,$54,$55,$55,$85,$A1
        .BYTE $85,$55,$55,$54,$50,$40,$40,$40
        .BYTE $03,$03,$03,$0B,$03,$03,$03,$03
        .BYTE $55,$55,$5E,$7A,$55,$55,$55,$55
        .BYTE $40,$40,$40,$60,$40,$40,$40,$40
        .BYTE $55,$55,$85,$A1,$55,$55,$55,$55
        .BYTE $00,$00,$02,$0D,$34,$34,$34,$0D
        .BYTE $03,$03,$0D,$34,$34,$34,$0D,$03
        .BYTE $00,$00,$20,$34,$0D,$0D,$0D,$34
        .BYTE $50,$50,$34,$0D,$0D,$0D,$34,$50
        .BYTE $0A,$0A,$03,$0A,$0A,$03,$06,$16
        .BYTE $56,$56,$59,$59,$65,$65,$59,$55
        .BYTE $A0,$A0,$40,$A0,$A0,$40,$90,$94
        .BYTE $95,$95,$65,$59,$59,$65,$55,$55
        .BYTE $00,$00,$00,$88,$00,$21,$05,$15
        .BYTE $00,$40,$50,$56,$55,$55,$55,$55
        .BYTE $00,$01,$05,$95,$55,$55,$55,$55
        .BYTE $00,$00,$00,$22,$00,$48,$50,$54
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $34,$D4,$34,$35,$35,$0D,$03,$0D
        .BYTE $55,$55,$7A,$7A,$7A,$50,$55,$55
        .BYTE $00,$00,$74,$D5,$55,$5D,$47,$5D
        .BYTE $55,$55,$AA,$AA,$AA,$00,$55,$55
        .BYTE $00,$00,$D4,$55,$55,$75,$0D,$4D
        .BYTE $55,$55,$AA,$AA,$AA,$00,$55,$55
        .BYTE $D0,$D4,$D0,$D0,$50,$40,$00,$40
        .BYTE $55,$55,$A1,$A1,$A1,$01,$55,$55
        .BYTE $00,$00,$03,$0D,$35,$56,$59,$6A
        .BYTE $59,$56,$35,$0D,$03,$00,$00,$03
        .BYTE $F8,$C0,$40,$43,$4D,$75,$55,$AA
        .BYTE $55,$75,$4D,$43,$40,$C0,$C0,$F0
        .BYTE $55,$55,$78,$78,$78,$78,$78,$55
        .BYTE $7A,$78,$78,$78,$78,$55,$5E,$78
        .BYTE $55,$55,$55,$55,$55,$55,$55,$55
        .BYTE $85,$E1,$E1,$E1,$E1,$55,$A1,$55
        .BYTE $78,$78,$5E,$55,$5E,$78,$7A,$78
        .BYTE $78,$55,$AA,$5E,$5E,$5E,$5E,$55
        .BYTE $55,$55,$A1,$55,$85,$E1,$A1,$E1
        .BYTE $E1,$55,$1E,$3A,$EA,$55,$AA,$55
        .BYTE $55,$55,$78,$7B,$7A,$7B,$78,$55
        .BYTE $5E,$78,$78,$78,$5E,$55,$78,$78
        .BYTE $55,$55,$E1,$85,$15,$85,$E1,$55
        .BYTE $85,$E1,$E1,$E1,$85,$55,$55,$55
        .BYTE $78,$78,$7A,$55,$5E,$78,$7A,$78
        .BYTE $78,$55,$97,$A3,$AB,$57,$AA,$55
        .BYTE $55,$55,$A1,$55,$85,$E1,$A1,$E1
        .BYTE $E1,$55,$AA,$85,$85,$85,$85,$55

backgroundOscillatorData
        .BYTE $00,$00,$F0,$F0,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$03,$03,$00,$00,$00,$00
        .BYTE $00,$00,$30,$30,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$30,$30,$00,$00
        .BYTE $00,$00,$00,$00,$C0,$C0,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$0F,$0F,$00,$00
        .BYTE $A7,$36,$8D,$A8,$36,$AD,$35,$38
        .BYTE $F0,$34,$AD,$AA,$36,$C9,$01,$D0
        .BYTE $2D,$A9,$07,$20,$D0,$29,$4C,$BE
        .BYTE $24,$20,$BE,$28,$AC,$A2,$36,$B9
        .BYTE $BC,$36,$F0,$1A,$C9,$20,$F0,$16
        .BYTE $C9,$2C,$F0,$12,$C9,$29,$F0,$0E
        .BYTE $C9,$3B,$F0,$0A,$AE,$A2,$36,$E8
        .BYTE $8E,$A1,$36,$4C,$A3,$23,$AD,$AB
        .BYTE $36,$F0,$0F,$C9,$01,$F0,$06,$AD
        .BYTE $A8,$36,$8D,$A7,$36,$A9,$00,$8D
        .BYTE $A8,$36,$AE,$4B,$38,$F0,$46,$E0
        .BYTE $53,$D0,$24,$AE,$AA,$36,$CA,$F0
        .BYTE $1D,$AE,$3E,$38,$10,$18,$AD,$A7
        .BYTE $36,$F0,$13,$A2,$04,$20,$C9,$FF
        .BYTE $20,$78,$1F,$20,$A0,$2E,$CE,$A7
        .BYTE $36,$D0,$F5,$20,$CC,$FF,$60,$AD
        .BYTE $A7,$36,$0D,$A8,$36,$E0,$4E,$D0
        .BYTE $10,$AA,$D0,$10,$AD,$34,$38,$F0
        .BYTE $03,$4C,$6B,$32,$EE,$34,$38,$D0
        .BYTE $03,$AA,$D0,$F0,$60,$AD,$A8,$36
        .BYTE $F0,$05,$A9,$10,$8D,$AC,$36,$AD
        .BYTE $9D,$36,$C9,$01,$D0,$0D,$AD,$A7
        .BYTE $36,$8D,$54,$38,$AD,$A8,$36,$8D
        .BYTE $55,$38,$60,$AD,$35,$38,$C9,$3D
        .BYTE $F0,$03,$4C,$6F,$25,$AD,$AA,$36
        .BYTE $C9,$02,$F0,$22,$A6,$CC,$A5,$CD
        .BYTE $86,$FA,$85,$FB,$AD,$00,$FF,$48
        .BYTE $A9,$7F,$8D,$00,$FF,$A0,$06,$AD
        .BYTE $A7,$36,$91,$FA,$C8,$AD,$A8,$36
        .BYTE $91,$FA,$68,$8D,$00,$FF,$60,$AD
        .BYTE $AC,$36,$8D,$AF,$36,$A9,$00,$8D
        .BYTE $AD,$36,$AC,$38,$38,$D0,$05,$A2
        .BYTE $04,$4C,$34,$26,$AD,$FF,$37,$C9
        .BYTE $42,$D0,$18,$AD,$00,$38,$C9,$52
        .BYTE $D0,$05,$A2,$04,$4C,$34,$26,$C9
        .BYTE $49,$D0,$03,$4C,$31,$26,$A2,$0F
        .BYTE $4C,$34,$26,$AC,$38,$38,$B9,$BC
        .BYTE $36,$C9,$23,$D0,$0E,$AD,$A8,$36
        .BYTE $F0,$05,$A9,$03,$20,$D0,$29,$A2
        .BYTE $03,$D0,$79,$C9,$41,$D0,$12,$C8
        .BYTE $B9,$BC,$36,$F0,$08,$C9,$20,$F0
        .BYTE $04,$C9,$3B,$D0,$04,$A2,$06,$D0
        .BYTE $63,$AC,$38,$38,$C8,$B9,$BC,$36
        .BYTE $F0,$57,$C9,$20,$F0,$53,$C9,$3B
        .BYTE $F0,$4F,$C9,$2C,$D0,$26,$C8,$B9
        .BYTE $BC,$36,$F0,$45,$C9,$20,$F0,$41
        .BYTE $C9,$3B,$F0,$3D,$C9,$58,$D0,$04
        .BYTE $A2,$05,$D0,$2B,$C9,$59,$F0,$08

.include "sprites.asm"

        .BYTE $00,$00,$00,$00,$00,$00,$00,$26
        .BYTE $27,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$80
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FD,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$02
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FB,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$01,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$00,$00
        .BYTE $00
