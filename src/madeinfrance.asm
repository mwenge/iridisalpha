
f40C8   .BYTE $00,$06,$02,$04,$05,$03,$07,$01
a40D0   .BYTE $00
a40D1   .BYTE $03
a40D2   .BYTE $00
;------------------------------------------------
; LaunchMIF
;------------------------------------------------
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
        STA a46AC
        LDA #$F0
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control

        ; Init_ScreenPointerArray
        LDA #>SCREEN_RAM
        STA screenPtrHi
        LDA #<SCREEN_RAM
        STA screenPtrLo
        LDX #$00
b4109   LDA screenPtrLo
        STA SCREEN_PTR_LO,X
        LDA screenPtrHi
        STA SCREEN_PTR_HI,X
        LDA screenPtrLo
        CLC 
        ADC #$28
        STA screenPtrLo
        LDA screenPtrHi
        ADC #$00
        STA screenPtrHi
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

a413B   .BYTE $00
a413C   .BYTE $00
a413D   .BYTE $00
a413E   .BYTE $00
f413F   .BYTE $02,$08,$07,$05,$0E,$04,$06,$00
a4147   .BYTE $03
a4148   .BYTE $03
;-------------------------------
; MIF_s4149
;-------------------------------
MIF_s4149   
        .BYTE $AE,$3D,$41,$AC,$3C,$41,$BD,$40
        .BYTE $03,$85 ;SLO ($85,X)
        .BYTE $02    ;JAM 
        LDA SCREEN_PTR_HI,X
        STA screenPtrHi
        LDA (screenPtrLo),Y
        RTS 

;-------------------------------
; MIF_s415C
;-------------------------------
MIF_s415C   
        JSR MIF_s4149
        LDA a413E
        STA (screenPtrLo),Y
        LDA screenPtrHi
        PHA 
        CLC 
        ADC #$D4
        STA screenPtrHi
        LDA a413B
        STA (screenPtrLo),Y
        PLA 
        STA screenPtrHi
f4174   RTS 

f4175   .BYTE $0A,$09,$08,$07,$06,$05
a417B   .BYTE $04
f417C   .BYTE $03
f417D   .BYTE $0C,$0C,$0C,$0C,$0C,$0C
a4183   .BYTE $0C
;-------------------------------
; MIF_SetUpInterruptHandler
;-------------------------------
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

;-------------------------------
; MIF_RunUntilPlayerUnpauses
;-------------------------------
MIF_RunUntilPlayerUnpauses   
        JSR MIF_s44AB
        JSR MIF_s4589
        JSR MIF_s46AF
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

b41D8   LDA a46AC
        BEQ b41BC
        JMP LaunchMIF

;-------------------------------
; MIF_InterruptHandler
;-------------------------------
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

b41ED   JSR MIF_s420B
        JSR MIF_s45EC
        JSR MIF_s473E
        JSR MIF_s439D
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$FE
        STA $D012    ;Raster Position
        JMP $EA31

a4209   .BYTE $01
a420A   .BYTE $00
;-------------------------------
; MIF_s420B
;-------------------------------
MIF_s420B   
        DEC a4148
        BEQ b4211
        RTS 

b4211   LDA a4147
        STA a4148
        LDA a4588
        BEQ b4224
        LDA #$00
        STA a4588
        JMP j42BD

b4224   LDA a417B
        STA a413C
        LDA a4183
        STA a413D
        JSR MIF_s42CC
        LDX #$06
b4235   LDA f4174,X
        STA f4175,X
        LDA f417C,X
        STA f417D,X
        DEX 
        BNE b4235
;-------------------------------
; j4244
;-------------------------------
j4244   
        LDA f4175
        CLC 
        ADC a4209
        STA f4175
        CMP #$FF
        BNE b425A
        LDA #$26
        STA f4175
        JMP j4263

b425A   CMP #$27
        BNE j4263
        LDA #$00
        STA f4175
;-------------------------------
; j4263
;-------------------------------
j4263   
        LDA f417D
        CLC 
        ADC a420A
        STA f417D
        CMP #$FF
        BNE b4279
        LDA #$16
        STA f417D
        JMP j4282

b4279   CMP #$17
        BNE j4282
        LDA #$00
        STA f417D
;-------------------------------
; j4282
;-------------------------------
j4282   
        JSR MIF_s42D9
        LDA f4175
        STA a413C
        LDA f417D
        STA a413D
        JSR MIF_s4149
        JSR MIF_s432A
        LDX #$00
b4299   LDA f4175,X
        STA a413C
        LDA f417D,X
        STA a413D
        LDA #$A0
        STA a413E
        LDA f413F,X
        STA a413B
        TXA 
        PHA 
        JSR MIF_s415C
        PLA 
        TAX 
        INX 
        CPX #$07
        BNE b4299
b42BC   RTS 

;-------------------------------
; j42BD
;-------------------------------
j42BD   
        LDA f4175
        STA a413C
        LDA f417D
        STA a413D
        JMP j4282

;-------------------------------
; MIF_s42CC
;-------------------------------
MIF_s42CC   
        JSR MIF_s4149
        CMP #$A0
        BNE b42BC
        LDA #$20
        STA (screenPtrLo),Y
b42D7   RTS 

a42D8   RTI 

;-------------------------------
; MIF_s42D9
;-------------------------------
MIF_s42D9   
        LDA lastKeyPressed
        CMP a42D8
        BNE b42E1
        RTS 

b42E1   STA a42D8
        CMP #$40
        BEQ b42D7
        PHA 
        LDA f4175
        STA a413C
        LDA f417D
        STA a413D
        PLA 
        CMP #$27
        BNE b4307
        LDA #$4E
        STA a413E
;-------------------------------
; j42FF
;-------------------------------
j42FF   
        LDA #$01
        STA a413B
        JMP MIF_s415C

b4307   CMP #$24
        BNE b4313
        LDA #$4D
        STA a413E
        JMP j42FF

b4313   CMP #$3C
        BNE b4321
        DEC a4147
        BNE b4321
        LDA #$04
        STA a4147
b4321   RTS 

        .BYTE $01,$00,$FF,$00,$01,$00,$FF,$00
;-------------------------------
; MIF_s432A
;-------------------------------
MIF_s432A   
        CMP #$4D
        BNE b434F
        LDA #$4E
        STA (screenPtrLo),Y
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
;-------------------------------
; j4347
;-------------------------------
j4347   
        LDA #$04
        STA a4738
        JMP j4244

b434F   CMP #$4E
        BNE b4379
        LDA #$4D
        STA (screenPtrLo),Y
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
        STA (screenPtrLo),Y
        LDA #$01
        STA a44A9
        INC a439C
        JSR MIF_s4512
        JSR MIF_s4589
        RTS 

a4396   =*+$01
;-------------------------------
; MIF_s4395
;-------------------------------
MIF_s4395   
        LDA $EF00
        INC a4396
b439B   RTS 

a439C   .BYTE $00
;-------------------------------
; MIF_s439D
;-------------------------------
MIF_s439D   
        LDA a439C
        BNE b43BD
        JSR MIF_s4395
        AND #$1F
        CLC 
        ADC #$03
        STA a43E4
        JSR MIF_s4395
        AND #$0F
        CLC 
        ADC #$03
        STA a43E5
        LDA #$01
        STA a439C
b43BD   CMP #$01
        BNE b43E7
        LDA #$51
        STA a413E
        INC a43E6
        LDA a43E6
        AND #$07
        TAX 
        LDA f413F,X
        STA a413B
        LDA a43E4
        STA a413C
        LDA a43E5
        STA a413D
        JMP MIF_s415C

a43E4   .BYTE $00
a43E5   .BYTE $00
a43E6   .BYTE $00
b43E7   LDA #$A0
        STA a413E
        LDA a44A9
        STA a44AA
        LDA #$00
        STA a43E6
b43F7   JSR MIF_s441A
        INC a43E6
        LDA a43E6
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

;-------------------------------
; MIF_s441A
;-------------------------------
MIF_s441A   
        LDX a43E6
        LDA f413F,X
        STA a413B
        LDA a43E4
        SEC 
        SBC a44AA
        STA a413C
        LDA a43E5
        SEC 
        SBC a44AA
        STA a413D
        JSR MIF_s4492
        LDA a413C
        CLC 
        ADC a44AA
        STA a413C
        JSR MIF_s4492
        LDA a413C
        CLC 
        ADC a44AA
        STA a413C
        JSR MIF_s4492
        LDA a413D
        CLC 
        ADC a44AA
        STA a413D
        JSR MIF_s4492
        LDA a413D
        CLC 
        ADC a44AA
        STA a413D
        JSR MIF_s4492
        LDA a413C
        SEC 
        SBC a44AA
        STA a413C
        JSR MIF_s4492
        LDA a413C
        SEC 
        SBC a44AA
        STA a413C
        JSR MIF_s4492
        LDA a413D
        SEC 
        SBC a44AA
        STA a413D
;-------------------------------
; MIF_s4492
;-------------------------------
MIF_s4492   
        LDA a413C
        BMI b449B
        CMP #$27
        BMI b449C
b449B   RTS 

b449C   LDA a413D
        BMI b449B
        CMP #$16
        BMI b44A6
        RTS 

b44A6   JMP MIF_s415C

a44A9   .BYTE $00
a44AA   .BYTE $00
;-------------------------------
; MIF_s44AB
;-------------------------------
MIF_s44AB   
        LDA #$00
        STA a413C
        LDA #>p2017
        STA a413E
        LDA #<p2017
        STA a413D
b44BA   LDX a413C
        LDA f44E0,X
        STA a413B
        JSR MIF_s415C
        INC a413D
        JSR MIF_s415C
        DEC a413D
        INC a413C
        LDA a413C
        CMP #$28
        BNE b44BA
        LDA #$00
        STA a44DF
        RTS 

a44DF   .BYTE $00
f44E0   .BYTE $02,$02,$02,$02,$02,$02,$08,$08
        .BYTE $08,$08,$08,$08,$07,$07,$07,$07
        .BYTE $07,$05,$05,$05,$05,$05,$05,$0B
        .BYTE $0B,$0B,$0B,$0B,$04,$04,$04,$04
        .BYTE $04,$04,$06,$06,$06,$06,$06,$06
a4508   .BYTE $00
f4509   .BYTE $20,$65,$74,$75,$61,$F6,$EA,$E7
        .BYTE $A0
;-------------------------------
; MIF_s4512
;-------------------------------
MIF_s4512   
        LDA a4630
        ROR 
        ROR 
        AND #$03
        TAX 
        INX 
        LDA #$00
        STA a4508
b4520   LDA #$05
        SEC 
        SBC a4147
        CLC 
        ADC a4508
        STA a4508
        DEX 
        BNE b4520
b4530   JSR MIF_s453C
        DEC a4508
        BNE b4530
        JSR MIF_s46AF
        RTS 

;-------------------------------
; MIF_s453C
;-------------------------------
MIF_s453C   
        LDA #$18
        STA a413D
        LDA a44DF
        STA a413C
        JSR MIF_s4149
        LDX #$00
;-------------------------------
; j454C
;-------------------------------
j454C   
        CMP f4509,X
        BEQ b4555
        INX 
        JMP j454C

b4555   CMP #$A0
        BEQ b456C
        INX 
        LDA f4509,X
        STA a413E
;-------------------------------
; j4560
;-------------------------------
j4560   
        LDX a413C
        LDA f44E0,X
        STA a413B
        JMP MIF_s415C

b456C   INC a413C
        INC a44DF
        LDA a44DF
        CMP #$27
        BNE b4580
        DEC a44DF
        INC a46AC
        RTS 

b4580   LDA #$20
        STA a413E
        JMP j4560

a4588   .BYTE $00
;-------------------------------
; MIF_s4589
;-------------------------------
MIF_s4589   
        LDA #>p27
        STA a413D
        LDA #<p27
        STA a413C
b4593   LDX a413D
        LDA f45BB,X
        CMP #$A0
        BEQ b459F
        AND #$3F
b459F   STA a413E
        LDA f45D3,X
        STA a413B
        JSR MIF_s415C
        INC a413D
        LDA a413D
        CMP #$18
        BNE b4593
        LDA #$00
        STA a4630
b45BA   RTS 

f45BB   .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $A0,$A0,$A0,$A0,$20,$CD,$C9,$C6
        .BYTE $20,$20,$42,$59,$20,$D9,$C1,$CB
f45D3   .BYTE $02,$02,$02,$02,$01,$01,$01,$01
        .BYTE $06,$06,$06,$06,$00,$02,$01,$06
        .BYTE $00,$00,$04,$04,$00,$07,$07,$07
a45EB   .BYTE $10
;-------------------------------
; MIF_s45EC
;-------------------------------
MIF_s45EC   
        DEC a45EB
        BNE b45BA
        LDA #$10
        STA a45EB
        LDA a4630
        STA a413D
        LDA #$27
        STA a413C
        JSR MIF_s4149
        LDX #$00
b4606   CMP f4631,X
        BEQ b460E
        INX 
        BNE b4606
b460E   CMP #$20
        BEQ b4625
        INX 
        LDA f4631,X
        STA a413E
        LDX a4630
        LDA f45D3,X
        STA a413B
        JMP MIF_s415C

b4625   INC a4630
        LDA a4630
        CMP #$0C
        BEQ b463A
        RTS 

a4630   .BYTE $00
f4631   .BYTE $A0,$E3,$F7,$F8,$62,$79,$6F,$64
        .BYTE $20
b463A   LDA #$00
        STA a413C
        STA a413D
        LDA #$CF
        STA a413E
        LDA #$00
        STA a46AB
        JSR MIF_s4665
        LDA #$20
        STA a413E
        LDA #$00
        STA a413C
        STA a413D
        JSR MIF_s4665
        LDA #$01
        STA a46AC
        RTS 

;-------------------------------
; MIF_s4665
;-------------------------------
MIF_s4665   
        LDA a413E
        CMP #$20
        BEQ b4684
        INC a46AB
        LDA a46AB
        CMP #$06
        BNE b467B
        LDA #$00
        STA a46AB
b467B   LDX a46AB
        LDA f413F,X
        STA a413B
b4684   JSR MIF_s415C
        LDY #$02
b4689   LDX #$A0
b468B   DEX 
        BNE b468B
        DEY 
        BNE b4689
        INC a413C
        LDA a413C
        CMP #$27
        BNE MIF_s4665
        LDA #$00
        STA a413C
        INC a413D
        LDA a413D
        CMP #$17
        BNE MIF_s4665
        RTS 

a46AB   .BYTE $00
a46AC   .BYTE $00
a46AD   .BYTE $00
a46AE   .BYTE $00
;-------------------------------
; MIF_s46AF
;-------------------------------
MIF_s46AF   
        LDA #>p2017
        STA a413E
        LDA #<p2017
        STA a413D
        LDA a46AD
        STA a413C
        JSR MIF_s415C
        LDA a44DF
        CMP a46AD
        BEQ b4710
        BPL b46EC
;-------------------------------
; j46CC
;-------------------------------
j46CC   
        LDA a46AD
        STA a413C
        LDA #$17
        STA a413D
        LDX a46AD
        LDA f44E0,X
        STA a413B
        LDX a46AE
        LDA f472F,X
        STA a413E
        JMP MIF_s415C

b46EC   LDA a44DF
        STA a413C
        LDA #$18
        STA a413D
        JSR MIF_s4149
        LDX #$00
b46FC   CMP f4509,X
        BEQ b4704
        INX 
        BNE b46FC
b4704   STX a46AE
        LDA a44DF
        STA a46AD
        JMP j46CC

b4710   LDA a44DF
        STA a413C
        LDA #$18
        STA a413D
        JSR MIF_s4149
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
;-------------------------------
; MIF_s473E
;-------------------------------
MIF_s473E   
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
