
;-----------------------------------------------------------------------------------------
; LaunchMIF
;-----------------------------------------------------------------------------------------
LaunchMIF
        SEI 
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$15
        STA $D018    ;VIC Memory Control Register
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$00
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        STA mifGameOver
        LDA #$F0
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control

        ; Init_ScreenPointerArray
        LDA #>SCREEN_RAM
        STA planetPtrHi
        LDA #<SCREEN_RAM
        STA planetPtrLo
        LDX #$00
b4109   LDA planetPtrLo
        STA screenLinePtrLo,X
        LDA planetPtrHi
        STA screenLinePtrHi,X
        LDA planetPtrLo
        CLC 
        ADC #$28
        STA planetPtrLo
        LDA planetPtrHi
        ADC #$00
        STA planetPtrHi
        INX 
        CPX #$1A
        BNE b4109

        ;Clear screen
        LDX #$00
        LDA #$20
b4129   STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02F8,X
        DEX 
        BNE b4129

        JMP MIF_RunUntilPlayerUnpauses

mifCurrentCharColor .BYTE $00
mifCurrentXPos      .BYTE $00
mifCurrentYPos      .BYTE $00
mifCurrentChar      .BYTE $00
mifSnakeColorArray  .BYTE $02,$08,$07,$05,$0E,$04,$06,$00
mifSnakeSpeed       .BYTE $03
a4148               .BYTE $03
;------------------------------------------------------------------------
; MIF_PutCharAtCurrPosInAccumulator
;------------------------------------------------------------------------
MIF_PutCharAtCurrPosInAccumulator   
        LDX mifCurrentYPos
        LDY mifCurrentXPos
        LDA screenLinePtrLo,X
        STA planetPtrLo
        LDA screenLinePtrHi,X
        STA planetPtrHi
        LDA (planetPtrLo),Y
        RTS 

;------------------------------------------------------------------------
; MIF_DrawCurrentCharAtCurrentPos
;------------------------------------------------------------------------
MIF_DrawCurrentCharAtCurrentPos   
        JSR MIF_PutCharAtCurrPosInAccumulator
        LDA mifCurrentChar
        STA (planetPtrLo),Y
        LDA planetPtrHi
        PHA 
        CLC 
        ; Move to Hi ptr to Color Ram so we can paint the
        ; character's color
        ADC #$D4
        STA planetPtrHi
        LDA mifCurrentCharColor
        STA (planetPtrLo),Y
        PLA 
        STA planetPtrHi
f4174   RTS 

mifSnakeCurrentXPos   .BYTE $0A,$09,$08,$07,$06,$05
a417B   .BYTE $04
f417C   .BYTE $03
mifSnakeCurrentYPos   .BYTE $0C,$0C,$0C,$0C,$0C,$0C
a4183   .BYTE $0C
;------------------------------------------------------------------------
; MIF_SetUpInterruptHandler
;------------------------------------------------------------------------
MIF_SetUpInterruptHandler   
        LDA #<MIF_InterruptHandler
        STA $0314    ;IRQ
        LDA #>MIF_InterruptHandler
        STA $0315    ;IRQ
        LDA $D011    ;VIC Control Register 1
        AND #$7F
        STA $D011    ;VIC Control Register 1
        LDA #$FE
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        CLI 
        RTS 

;------------------------------------------------------------------------
; MIF_RunUntilPlayerUnpauses
;------------------------------------------------------------------------
MIF_RunUntilPlayerUnpauses   
        JSR MIF_InitializeProgressBar
        JSR MIF_DrawCountdownBarAndCredit
        JSR MIF_UpdateProgressBar
        JSR MIF_SetUpInterruptHandler
b41B1   LDA lastKeyPressed
        CMP #$40 ; 'No key pressed'
        BNE b41B1

        LDA #$00
        STA $D015    ;Sprite display Enable

b41BC   LDA lastKeyPressed
        CMP #$04 ; F1
        BNE b41C3
        ;F1 was pressed, so exit MIF back to game.
        RTS 

b41C3   CMP #$31; '*' Pressed
        BNE b41D8

b41C7   LDA lastKeyPressed
        CMP #$40 ; 'No key pressed'
        BNE b41C7

        ; Launch DNA mode
        LDA #$01
        STA mifDNAPauseModeActive
        JSR EnterMainTitleScreen
        JMP LaunchMIF

b41D8   LDA mifGameOver
        BEQ b41BC
        JMP LaunchMIF

;------------------------------------------------------------------------
; MIF_InterruptHandler
;------------------------------------------------------------------------
MIF_InterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b41ED
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

b41ED   JSR UpdateSnakePositionAndCheckInput
        JSR MIF_UpdateCountdownBar
        JSR MIF_PlaySound
        JSR MIF_UpdateTarget
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$FE
        STA $D012    ;Raster Position
        JMP $EA31

a4209   .BYTE $01
a420A   .BYTE $00
;------------------------------------------------------------------------
; UpdateSnakePositionAndCheckInput
;------------------------------------------------------------------------
UpdateSnakePositionAndCheckInput   
        DEC a4148
        BEQ b4211
        RTS 

b4211   LDA mifSnakeSpeed
        STA a4148
        LDA a4588
        BEQ b4224

        LDA #$00
        STA a4588
        JMP j42BD

b4224   LDA a417B
        STA mifCurrentXPos
        LDA a4183
        STA mifCurrentYPos
        JSR MIF_ClearCharAtCurrentPosIfIsSnakeSegment

        LDX #$06
b4235   LDA f4174,X
        STA mifSnakeCurrentXPos,X
        LDA f417C,X
        STA mifSnakeCurrentYPos,X
        DEX 
        BNE b4235

j4244   
        LDA mifSnakeCurrentXPos
        CLC 
        ADC a4209
        STA mifSnakeCurrentXPos
        CMP #$FF
        BNE b425A
        LDA #$26
        STA mifSnakeCurrentXPos
        JMP j4263

b425A   CMP #$27
        BNE j4263
        LDA #$00
        STA mifSnakeCurrentXPos

j4263   
        LDA mifSnakeCurrentYPos
        CLC 
        ADC a420A
        STA mifSnakeCurrentYPos
        CMP #$FF
        BNE b4279
        LDA #$16
        STA mifSnakeCurrentYPos
        JMP j4282

b4279   CMP #$17
        BNE j4282
        LDA #$00
        STA mifSnakeCurrentYPos

j4282   
        JSR MIF_CheckInputForAddingDeflectors
        LDA mifSnakeCurrentXPos
        STA mifCurrentXPos
        LDA mifSnakeCurrentYPos
        STA mifCurrentYPos
        JSR MIF_PutCharAtCurrPosInAccumulator
        JSR MIF_CheckSnakeCollisionWithDeflectors

        ; Draw the rest of the snake
        LDX #$00
b4299   LDA mifSnakeCurrentXPos,X
        STA mifCurrentXPos
        LDA mifSnakeCurrentYPos,X
        STA mifCurrentYPos
        LDA #$A0
        STA mifCurrentChar
        LDA mifSnakeColorArray,X
        STA mifCurrentCharColor
        TXA 
        PHA 
        JSR MIF_DrawCurrentCharAtCurrentPos
        PLA 
        TAX 
        INX 
        CPX #$07
        BNE b4299

b42BC   RTS 

j42BD   
        LDA mifSnakeCurrentXPos
        STA mifCurrentXPos
        LDA mifSnakeCurrentYPos
        STA mifCurrentYPos
        JMP j4282

;------------------------------------------------------------------------
; MIF_ClearCharAtCurrentPosIfIsSnakeSegment
;------------------------------------------------------------------------
MIF_ClearCharAtCurrentPosIfIsSnakeSegment   
        JSR MIF_PutCharAtCurrPosInAccumulator
        CMP #$A0
        BNE b42BC
        LDA #$20
        STA (planetPtrLo),Y
b42D7   RTS 

mifPreviousKeyPress   .BYTE $40 

;------------------------------------------------------------------------
; MIF_CheckInputForAddingDeflectors
;------------------------------------------------------------------------
MIF_CheckInputForAddingDeflectors   
        LDA lastKeyPressed
        CMP mifPreviousKeyPress
        BNE b42E1
        RTS 

b42E1   STA mifPreviousKeyPress
        CMP #$40
        BEQ b42D7
        PHA 
        LDA mifSnakeCurrentXPos
        STA mifCurrentXPos
        LDA mifSnakeCurrentYPos
        STA mifCurrentYPos
        PLA 
        CMP #$27
        BNE b4307
        ; 'N' pressed, make left-facing reflector current character
        LDA #$4E
        STA mifCurrentChar

j42FF   
        LDA #$01
        STA mifCurrentCharColor
        JMP MIF_DrawCurrentCharAtCurrentPos
        ; Returns

b4307   CMP #$24
        BNE b4313

        ; 'M' pressed, make right-facing reflector current character
        LDA #$4D
        STA mifCurrentChar
        JMP j42FF

b4313   CMP #$3C
        BNE b4321

        ; Space pressed. Update speed.
        DEC mifSnakeSpeed
        BNE b4321
        LDA #$04
        STA mifSnakeSpeed
b4321   RTS 

        .BYTE $01,$00,$FF,$00,$01,$00,$FF,$00
;------------------------------------------------------------------------
; MIF_CheckSnakeCollisionWithDeflectors
;------------------------------------------------------------------------
MIF_CheckSnakeCollisionWithDeflectors   
        CMP #$4D
        BNE b434F
        LDA #$4E
        STA (planetPtrLo),Y
        LDA a4209
        PHA 
        LDA a420A
        STA a4209
        PLA 
        STA a420A
        PLA 
        PLA 
        LDA #$01
        STA a4588

j4347   
        LDA #$04
        STA a4738
        JMP j4244

b434F   CMP #$4E
        BNE b4379
        LDA #$4D
        STA (planetPtrLo),Y
        LDA a4209
        EOR #$FF
        CLC 
        ADC #$01
        PHA 
        LDA a420A
        EOR #$FF
        CLC 
        ADC #$01
        STA a4209
        PLA 
        STA a420A
        PLA 
        PLA 
        LDA #$01
        STA a4588
        JMP j4347

b4379   CMP #$51
        BNE b439B
        LDA #$20
        STA a4739
        LDA #$20
        STA (planetPtrLo),Y
        LDA #$01
        STA a44A9
        INC a439C
        JSR MIF_s4512
        JSR MIF_DrawCountdownBarAndCredit
        RTS 

a4396   =*+$01
;------------------------------------------------------------------------
; MIF_PutRandomValueInAccumulator
;------------------------------------------------------------------------
MIF_PutRandomValueInAccumulator   
        LDA $EF00
        INC a4396
b439B   RTS 

a439C   .BYTE $00
;------------------------------------------------------------------------
; MIF_UpdateTarget
;------------------------------------------------------------------------
MIF_UpdateTarget   
        LDA a439C
        BNE b43BD

        JSR MIF_PutRandomValueInAccumulator
        AND #$1F
        CLC 
        ADC #$03
        STA mifRandomXPos

        JSR MIF_PutRandomValueInAccumulator
        AND #$0F
        CLC 
        ADC #$03
        STA mifRandomYPos

        LDA #$01
        STA a439C

b43BD   CMP #$01
        BNE b43E7

        ; Place the target
        LDA #$51
        STA mifCurrentChar
        INC mifTargetCurrentColor
        LDA mifTargetCurrentColor
        AND #$07
        TAX 
        LDA mifSnakeColorArray,X
        STA mifCurrentCharColor
        LDA mifRandomXPos
        STA mifCurrentXPos
        LDA mifRandomYPos
        STA mifCurrentYPos
        JMP MIF_DrawCurrentCharAtCurrentPos
        ; Returns

mifRandomXPos   .BYTE $00
mifRandomYPos   .BYTE $00
mifTargetCurrentColor   .BYTE $00

b43E7   LDA #$A0
        STA mifCurrentChar
        LDA a44A9
        STA a44AA
        LDA #$00
        STA mifTargetCurrentColor

b43F7   JSR MIF_UpdateSnakePositionOnScreen
        INC mifTargetCurrentColor
        LDA mifTargetCurrentColor
        CMP #$08
        BEQ b4409
        DEC a44AA
        BNE b43F7

b4409   INC a44A9
        LDA a44A9
        CMP #$30
        BEQ b4414
        RTS 

b4414   LDA #$00
        STA a439C
        RTS 

;------------------------------------------------------------------------
; MIF_UpdateSnakePositionOnScreen
;------------------------------------------------------------------------
MIF_UpdateSnakePositionOnScreen   
        LDX mifTargetCurrentColor
        LDA mifSnakeColorArray,X
        STA mifCurrentCharColor
        LDA mifRandomXPos
        SEC 
        SBC a44AA
        STA mifCurrentXPos
        LDA mifRandomYPos
        SEC 
        SBC a44AA
        STA mifCurrentYPos
        JSR MIF_DrawCharacterIfItsStillOnScreen
        LDA mifCurrentXPos
        CLC 
        ADC a44AA
        STA mifCurrentXPos
        JSR MIF_DrawCharacterIfItsStillOnScreen
        LDA mifCurrentXPos
        CLC 
        ADC a44AA
        STA mifCurrentXPos
        JSR MIF_DrawCharacterIfItsStillOnScreen
        LDA mifCurrentYPos
        CLC 
        ADC a44AA
        STA mifCurrentYPos
        JSR MIF_DrawCharacterIfItsStillOnScreen
        LDA mifCurrentYPos
        CLC 
        ADC a44AA
        STA mifCurrentYPos
        JSR MIF_DrawCharacterIfItsStillOnScreen
        LDA mifCurrentXPos
        SEC 
        SBC a44AA
        STA mifCurrentXPos
        JSR MIF_DrawCharacterIfItsStillOnScreen
        LDA mifCurrentXPos
        SEC 
        SBC a44AA
        STA mifCurrentXPos
        JSR MIF_DrawCharacterIfItsStillOnScreen
        LDA mifCurrentYPos
        SEC 
        SBC a44AA
        STA mifCurrentYPos

;------------------------------------------------------------------------
; MIF_DrawCharacterIfItsStillOnScreen
;------------------------------------------------------------------------
MIF_DrawCharacterIfItsStillOnScreen   
        LDA mifCurrentXPos
        BMI b449B
        CMP #$27
        BMI b449C
b449B   RTS 

b449C   LDA mifCurrentYPos
        BMI b449B
        CMP #$16
        BMI b44A6
        RTS 

b44A6   JMP MIF_DrawCurrentCharAtCurrentPos

a44A9   .BYTE $00
a44AA   .BYTE $00
;------------------------------------------------------------------------
; MIF_InitializeProgressBar
;------------------------------------------------------------------------
MIF_InitializeProgressBar   
        LDA #$00
        STA mifCurrentXPos

        LDA #$20
        STA mifCurrentChar

        LDA #$17
        STA mifCurrentYPos
        
b44BA   LDX mifCurrentXPos
        LDA mifProgressBarColors,X
        STA mifCurrentCharColor
        JSR MIF_DrawCurrentCharAtCurrentPos
        INC mifCurrentYPos
        JSR MIF_DrawCurrentCharAtCurrentPos
        DEC mifCurrentYPos
        INC mifCurrentXPos
        LDA mifCurrentXPos
        CMP #$28
        BNE b44BA

        LDA #$00
        STA a44DF
        RTS 

a44DF   .BYTE $00
mifProgressBarColors   .BYTE $02,$02,$02,$02,$02,$02,$08,$08
        .BYTE $08,$08,$08,$08,$07,$07,$07,$07
        .BYTE $07,$05,$05,$05,$05,$05,$05,$0B
        .BYTE $0B,$0B,$0B,$0B,$04,$04,$04,$04
        .BYTE $04,$04,$06,$06,$06,$06,$06,$06
a4508   .BYTE $00
f4509   .BYTE $20,$65,$74,$75,$61,$F6,$EA,$E7
        .BYTE $A0
;------------------------------------------------------------------------
; MIF_s4512
;------------------------------------------------------------------------
MIF_s4512   
        LDA mifCurrentYPosInCountdownBar
        ROR 
        ROR 
        AND #$03
        TAX 
        INX 

        LDA #$00
        STA a4508

b4520   LDA #$05
        SEC 
        SBC mifSnakeSpeed
        CLC 
        ADC a4508
        STA a4508
        DEX 
        BNE b4520

b4530   JSR MIF_s453C
        DEC a4508
        BNE b4530

        JSR MIF_UpdateProgressBar
        RTS 

;------------------------------------------------------------------------
; MIF_s453C
;------------------------------------------------------------------------
MIF_s453C   
        LDA #$18
        STA mifCurrentYPos
        LDA a44DF
        STA mifCurrentXPos
        JSR MIF_PutCharAtCurrPosInAccumulator

        LDX #$00
j454C   
        CMP f4509,X
        BEQ b4555
        INX 
        JMP j454C

b4555   CMP #$A0
        BEQ b456C
        INX 
        LDA f4509,X
        STA mifCurrentChar

j4560   
        LDX mifCurrentXPos
        LDA mifProgressBarColors,X
        STA mifCurrentCharColor
        JMP MIF_DrawCurrentCharAtCurrentPos

b456C   INC mifCurrentXPos
        INC a44DF
        LDA a44DF
        CMP #$27
        BNE b4580
        DEC a44DF
        INC mifGameOver
        RTS 

b4580   LDA #$20
        STA mifCurrentChar
        JMP j4560

a4588   .BYTE $00
;------------------------------------------------------------------------
; MIF_DrawCountdownBarAndCredit
;------------------------------------------------------------------------
MIF_DrawCountdownBarAndCredit   
        LDA #$00
        STA mifCurrentYPos
        LDA #$27
        STA mifCurrentXPos
b4593   LDX mifCurrentYPos
        LDA mifCountdownBarAndCredit,X
        CMP #$A0
        BEQ b459F
        AND #$3F
b459F   STA mifCurrentChar
        LDA mifSidebarColorArray,X
        STA mifCurrentCharColor
        JSR MIF_DrawCurrentCharAtCurrentPos
        INC mifCurrentYPos
        LDA mifCurrentYPos
        CMP #$18
        BNE b4593

        LDA #$00
        STA mifCurrentYPosInCountdownBar
b45BA   RTS 

mifCountdownBarAndCredit      .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
                              .BYTE $A0,$A0,$A0,$A0,$20
                              ; MIF
                              .BYTE $CD,$C9,$C6
                              ; BY YAK
                              .BYTE $20,$20,$42,$59,$20,$D9,$C1,$CB
mifSidebarColorArray          .BYTE $02,$02,$02,$02,$01,$01,$01,$01
                              .BYTE $06,$06,$06,$06,$00,$02,$01,$06
                              .BYTE $00,$00,$04,$04,$00,$07,$07,$07
mifCountdownBarUpdateInterval .BYTE $10
;------------------------------------------------------------------------
; MIF_UpdateCountdownBar
;------------------------------------------------------------------------
MIF_UpdateCountdownBar   
        DEC mifCountdownBarUpdateInterval
        BNE b45BA ; Returns early

        LDA #$10
        STA mifCountdownBarUpdateInterval
        LDA mifCurrentYPosInCountdownBar
        STA mifCurrentYPos
        LDA #$27
        STA mifCurrentXPos
        JSR MIF_PutCharAtCurrPosInAccumulator

        ; Increment the displayed countdown bar by one tick
        LDX #$00
b4606   CMP mifCountdownBarCharArray,X
        BEQ b460E
        INX 
        BNE b4606

b460E   CMP #$20
        BEQ b4625

        INX 
        LDA mifCountdownBarCharArray,X
        STA mifCurrentChar
        LDX mifCurrentYPosInCountdownBar
        LDA mifSidebarColorArray,X
        STA mifCurrentCharColor
        JMP MIF_DrawCurrentCharAtCurrentPos

b4625   INC mifCurrentYPosInCountdownBar
        LDA mifCurrentYPosInCountdownBar
        CMP #$0C
        BEQ MIF_CountdownOver
        RTS 

mifCurrentYPosInCountdownBar   .BYTE $00
mifCountdownBarCharArray   .BYTE $A0,$E3,$F7,$F8,$62,$79,$6F,$64,$20

MIF_CountdownOver
        ; Countdown has run out
        LDA #$00
        STA mifCurrentXPos
        STA mifCurrentYPos
        LDA #$CF
        STA mifCurrentChar
        LDA #$00
        STA a46AB
        JSR MIF_ClearDownScreenBeforeRestart
        LDA #$20
        STA mifCurrentChar
        LDA #$00
        STA mifCurrentXPos
        STA mifCurrentYPos
        JSR MIF_ClearDownScreenBeforeRestart
        LDA #$01
        STA mifGameOver
        RTS 

;------------------------------------------------------------------------
; MIF_ClearDownScreenBeforeRestart
;------------------------------------------------------------------------
MIF_ClearDownScreenBeforeRestart   
        LDA mifCurrentChar
        CMP #$20
        BEQ b4684 ; This will clear the coloured lozenge pattern

        ; We're painting the coloured lozenge pattern
        INC a46AB
        LDA a46AB
        CMP #$06
        BNE b467B
        LDA #$00
        STA a46AB
b467B   LDX a46AB
        LDA mifSnakeColorArray,X
        STA mifCurrentCharColor

b4684   JSR MIF_DrawCurrentCharAtCurrentPos
        LDY #$02
b4689   LDX #$A0
b468B   DEX 
        BNE b468B
        DEY 
        BNE b4689

        INC mifCurrentXPos
        LDA mifCurrentXPos
        CMP #$27 ; keep incrementing for all columns
        BNE MIF_ClearDownScreenBeforeRestart
        LDA #$00
        STA mifCurrentXPos
        INC mifCurrentYPos
        LDA mifCurrentYPos
        CMP #$17 ; Keep incrementing for all lines
        BNE MIF_ClearDownScreenBeforeRestart
        RTS 

a46AB   .BYTE $00
mifGameOver   .BYTE $00
mifCurrentProgressIndex   .BYTE $00
a46AE   .BYTE $00
;------------------------------------------------------------------------
; MIF_UpdateProgressBar
;------------------------------------------------------------------------
MIF_UpdateProgressBar   
        LDA #$20
        STA mifCurrentChar
        LDA #$17
        STA mifCurrentYPos
        LDA mifCurrentProgressIndex
        STA mifCurrentXPos
        JSR MIF_DrawCurrentCharAtCurrentPos
        LDA a44DF
        CMP mifCurrentProgressIndex
        BEQ b4710
        BPL b46EC

j46CC   
        LDA mifCurrentProgressIndex
        STA mifCurrentXPos
        LDA #$17
        STA mifCurrentYPos
        LDX mifCurrentProgressIndex
        LDA mifProgressBarColors,X
        STA mifCurrentCharColor
        LDX a46AE
        LDA f472F,X
        STA mifCurrentChar
        JMP MIF_DrawCurrentCharAtCurrentPos

b46EC   LDA a44DF
        STA mifCurrentXPos
        LDA #$18
        STA mifCurrentYPos
        JSR MIF_PutCharAtCurrPosInAccumulator

        LDX #$00
b46FC   CMP f4509,X
        BEQ b4704
        INX 
        BNE b46FC

b4704   STX a46AE
        LDA a44DF
        STA mifCurrentProgressIndex
        JMP j46CC

b4710   LDA a44DF
        STA mifCurrentXPos
        LDA #$18
        STA mifCurrentYPos
        JSR MIF_PutCharAtCurrPosInAccumulator

        LDX #$00
b4720   CMP f4509,X
        BEQ b4728
        INX 
        BNE b4720

b4728   TXA 
        CMP a46AE
        BPL b4704
        RTS 

f472F   .BYTE $65,$65,$54,$47,$42,$5D,$48,$59
        .BYTE $67
a4738   .BYTE $00
a4739   .BYTE $00
f473A   .BYTE $C0,$40,$E0,$10
;------------------------------------------------------------------------
; MIF_PlaySound
;------------------------------------------------------------------------
MIF_PlaySound   
        LDA a4738
        BEQ b475A
        TAX 
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA f473A,X
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        DEC a4738
        BNE b475A
        LDA #$80
        STA $D404    ;Voice 1: Control Register
b4759   RTS 

b475A   LDA a4739
        BEQ b4759
        LDA #$00
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA #$20
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA a4739
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        DEC a4739
        BNE b4759
        LDA #$80
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        RTS 
