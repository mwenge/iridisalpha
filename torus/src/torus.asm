;
; **** ZP FIELDS **** 
;
f00 = $00
f04 = $04
f08 = $08
f0D = $0D
f0E = $0E
f17 = $17
f1E = $1E
f20 = $20
f28 = $28
f35 = $35
f36 = $36
f38 = $38
f43 = $43
f4E = $4E
f53 = $53
f54 = $54
f55 = $55
f56 = $56
f59 = $59
f5E = $5E
f71 = $71
f75 = $75
f78 = $78
f7A = $7A
f85 = $85
f90 = $90
f95 = $95
f97 = $97
fA1 = $A1
fAA = $AA
fD0 = $D0
fDE = $DE
fEA = $EA
;
; **** ZP ABSOLUTE ADRESSES **** 
;
a00 = $00
a01 = $01
a04 = $04
a05 = $05
a06 = $06
a07 = $07
a09 = $09
a0C = $0C
a14 = $14
a15 = $15
a18 = $18
a20 = $20
a2B = $2B
a31 = $31
a46 = $46
a4C = $4C
a4F = $4F
a52 = $52
a53 = $53
a55 = $55
a59 = $59
a60 = $60
a66 = $66
a7C = $7C
a87 = $87
aA1 = $A1
aA2 = $A2
aC0 = $C0
aC4 = $C4
LastKeyPressed = $C5
aC6 = $C6
aiDC = $DC
aDE = $DE
aE1 = $E1
aE6 = $E6
aEE = $EE
aFA = $FA
CharSetPtrLo = $FC
CharSetPtrHi = $FD
aFE = $FE
ZeroesToCopy = $FF
;
; **** ZP POINTERS **** 
;
p00 = $00
p01 = $01
p02 = $02
p03 = $03
p04 = $04
p05 = $05
p08 = $08
p09 = $09
p20 = $20
p2B = $2B
p2C = $2C
p32 = $32
p42 = $42
p43 = $43
p4B = $4B
p4E = $4E
p54 = $54
p55 = $55
p85 = $85
pA1 = $A1
pE1 = $E1
;
; **** FIELDS **** 
;
f0055 = $0055
f00FE = $00FE
f0333 = $0333
f0400 = $0400
f0428 = $0428
f042E = $042E
f04A0 = $04A0
f04C6 = $04C6
f0500 = $0500
f05B8 = $05B8
f0600 = $0600
f0608 = $0608
f0658 = $0658
f06D0 = $06D0
f0700 = $0700
f0718 = $0718
f0720 = $0720
f07F8 = $07F8
f0800 = $0800
f1809 = $1809
f180C = $180C
f1C1A = $1C1A
f2053 = $2053
f211F = $211F
f2441 = $2441
f2B04 = $2B04
f2D33 = $2D33
f3053 = $3053
f367F = $367F
f3C7E = $3C7E
f4241 = $4241
f4554 = $4554
f5258 = $5258
f5541 = $5541
f5565 = $5565
f5920 = $5920
f596A = $596A
f5D47 = $5D47
f5E55 = $5E55
f6565 = $6565
f6863 = $6863
f6CC6 = $6CC6
f7855 = $7855
f7B7D = $7B7D
f7E00 = $7E00
fA055 = $A055
fBD0D = $BD0D
fBE63 = $BE63
fC0C0 = $C0C0
fD555 = $D555
fD683 = $D683
fD800 = $D800
fD900 = $D900
fDA00 = $DA00
fDB00 = $DB00
fDBFE = $DBFE
fE161 = $E161
fE600 = $E600
fFE06 = $FE06
fFEE0 = $FEE0
fFEE6 = $FEE6
fFF2B = $FF2B
fFFFF = $FFFF
;
; **** ABSOLUTE ADRESSES **** 
;
a0003 = $0003
a0314 = $0314
a0315 = $0315
a036D = $036D
a038C = $038C
a05C4 = $05C4
a05CD = $05CD
a05D6 = $05D6
a05DF = $05DF
a0604 = $0604
a070A = $070A
a1712 = $1712
a204F = $204F
a2C58 = $2C58
a322F = $322F
a340D = $340D
a3434 = $3434
a3933 = $3933
a3A30 = $3A30
a4043 = $4043
a5555 = $5555
a6368 = $6368
a7571 = $7571
a780F = $780F
a8F42 = $8F42
aA000 = $A000
aBE0F = $BE0F
aC6C6 = $C6C6
aCCD8 = $CCD8
aD535 = $D535
aE024 = $E024
aF6DE = $F6DE
;
; **** POINTERS **** 
;
p0A = $000A
;
; **** EXTERNAL JUMPS **** 
;
CopyCharSetData = $0384
e2020 = $2020
e2A20 = $2A20
e2B05 = $2B05
e2E45 = $2E45
e4046 = $4046
e454B = $454B
e4D20 = $4D20
e4E4F = $4E4F
e4F46 = $4F46
e4F4D = $4F4D
e5246 = $5246
e5320 = $5320
e534F = $534F
e5420 = $5420
e5941 = $5941
eA8BC = $A8BC
eC6FC = $C6FC
eEA31 = $EA31

        * = $0801

;--------------------------------------------------------               
; Start executing at position $0811 (2065)
;--------------------------------------------------------               
        ; 10 SYS 2065
b0801
        .BYTE $0F,$08,$CF,$07,$9E,$32,$30,$36,$35,$20
        .BYTE $41,$42,$43,$00,$00

;--------------------------------------------------------               
; Execution starts here
; e0810 (SYS 2064)
;--------------------------------------------------------

; After the first pass around, JMP EnterMainLoop lives here. See below.
RestartExecution
        BRK ; JMP EnterMainLoop

;$8011 - This is where exeuction starts the first time round.
        NOP 
        NOP 
f0813   NOP 
        NOP 
        NOP 
        LDA #$36
        STA a01

; CopyCodeCharsetAndSpriteData seems to be an obfuscation procedure. It copies
; some code around and rewrites the code here to the following, then
; invokes exeuction at $0801 by calling a BRK $00 address.
; * = $0801
;         ; 10 SYS 2064 - this branches exeuction $0810
;         .BYTE $0B,$08,$0A,$00,$9E,$32,$30,$36,$34,$00
;         .BYTE $00,$00,$08,$02,$00
; 
; ;--------------------------------------------------------               
; ; Execute
; ; RestartExecution (SYS 2064)
; ;--------------------------------------------------------
; By copying this to $0810 in CopyCodeCharSetAndSpriteData, we enter the main animation loop 
; when execution restarts from $0801.
;       JMP EnterMainLoop

        JMP CopyCodeCharSetAndSpriteData

        ; Redundant data.
        .BYTE $2B,$2B ;ANC #$2B
        .BYTE $2B,$11 ;ANC #$11
        .BYTE $12    ;JAM 
        .BYTE $13,$15 ;SLO (p15),Y
        ASL f17,X
        ORA f1C1A,Y
        ORA f211F,X
        .BYTE $23,$25 ;RLA ($25,X)
        .BYTE $27,$2A ;RLA $2A
        BIT a322F
        AND f38,X
        .BYTE $3B,$3F,$43 ;RLA $433F,Y
        .BYTE $47,$4B ;SRE a4B
        .BYTE $4F,$54,$59,$5E ;SRE $5954

;------------------------------------------------------------
; Sound Data
;------------------------------------------------------------
SoundData
        .BYTE $61,$E1,$68                 ; $0839:                     
        .BYTE $F7,$8F,$30,$DA,$8F,$4E,$18,$EF                 ; $0841:                     
        .BYTE $D2,$C3,$C3,$D1,$EF,$1F,$60,$B5                 ; $0849:                     
        .BYTE $1E,$9C,$31,$DF,$A5,$87,$86,$A2                 ; $0851:                     
        .BYTE $DF,$3E,$C1,$6B,$3C,$39,$63,$BE                 ; $0859:                     
        .BYTE $4B,$0F,$0C,$45,$BF,$7D,$83,$D6                 ; $0861:                     

 f0869  .BYTE $00
 a086A  .BYTE $0C
 a086B  .BYTE $07
 a086C  .BYTE $07
 a086D  .BYTE $03
 a086E  .BYTE $0C
 a086F  .BYTE $30
 a0870  .BYTE $90
 a0871  .BYTE $01
 a0872  .BYTE $01
 a0873  .BYTE $02
 a0874  .BYTE $00
 a0875  .BYTE $13
 a0876  .BYTE $07
 a0877  .BYTE $13

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s0878   DEC a0870
        BNE b0895
        JSR s0946
        LDA #$C0
        STA a0870
        LDX a0874
        LDA f0869,X
        STA a0876
        INX 
        TXA 
        AND #$03
        STA a0874
b0895   DEC a086F
        BNE b08B7
        LDA #$30
        STA a086F
        LDX a0873
        LDA f0869,X
        CLC 
        ADC a0876
        TAY 
        STY a0875
        JSR s08F9
        INX 
        TXA 
        AND #$03
        STA a0873
b08B7   DEC a086E
        BNE b08D9
        LDA #$0C
        STA a086E
        LDX a0872
        LDA f0869,X
        CLC 
        ADC a0875
        STA a0877
        TAY 
        JSR s090B
        INX 
        TXA 
        AND #$03
        STA a0872
b08D9   DEC a086D
        BNE b08F8
        LDA #$03
        STA a086D
        LDX a0871
        LDA f0869,X
        CLC 
        ADC a0877
        TAY 
        JSR s091D
        INX 
        TXA 
        AND #$03
        STA a0871
b08F8   RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s08F9   LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA SoundData,Y
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA f0813,Y
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s090B   LDA #$21
        STA $D40B    ;Voice 2: Control Register
        LDA SoundData,Y
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA f0813,Y
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s091D   LDA #$21
        STA $D412    ;Voice 3: Control Register
        LDA SoundData,Y
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA f0813,Y
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s092F   LDA #$0F
        STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        LDA #$F5
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control
        RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s0946   LDX a0E76
        LDA f096B,X
        STA f0869
        LDX a0E77
        LDA f096B,X
        STA a086A
        LDX a0A67
        LDA f096B,X
        STA a086B
        LDX a0A69
        LDA f096B,X
        STA a086C
        RTS 

f096B   BRK #$03
        .BYTE $07,$09 ;SLO a09
        ORA a0C
        .BYTE $07,$03 ;SLO a03
        BRK #$03
        .BYTE $07,$09 ;SLO a09
        ORA a0C
        .BYTE $07,$03 ;SLO a03
f097B   RTI 

        LSR a4C
        .BYTE $52    ;JAM 
        CLI 
        LSR f6863,X
        ADC a7571
        SEI 
        .BYTE $7B,$7D,$7E ;RRA $7E7D,Y
        .BYTE $7F,$80,$7F ;RRA $7F80,X
        ROR f7B7D,X
        SEI 
        ADC f71,X
        ADC a6368
        LSR f5258,X
        JMP e4046

        AND f2D33,Y
        .BYTE $27,$21 ;RLA $21
        .BYTE $1C,$17,$12 ;NOP $1217,X
        ASL a070A
        .BYTE $04,$02 ;NOP a02
        ORA (p00,X)
        BRK #$00
        ORA (p02,X)
        .BYTE $04,$07 ;NOP a07
        ASL 
        ASL a1712
        .BYTE $1C,$21,$27 ;NOP $2721,X
        AND a3933
a09BC   =*+$01
a09BD   =*+$02
        .BYTE $FF,$01,$00 ;ISC $0001,X
a09BE   SEI 
a09C0   =*+$01
a09BF   .BYTE $63,$0E ;RRA (p0E,X)
a09C1   PLA 

;------------------------------------------------------
; The main loop
;------------------------------------------------------

EnterMainLoop
        SEI 
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        JSR s092F
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$00
        STA a09BD
        LDA #<p0A52
        STA a0314    ;IRQ
        LDA #>p0A52
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
        STA f0400,X
        STA f0500,X
        STA f0600,X
        STA f0700,X
        LDA #$0B
        STA fD800,X
        STA fD900,X
        STA fDA00,X
        STA fDB00,X
        DEX 
        BNE b0A07
        LDA a09BC
        BEQ b0A2E
        JSR s0C28
b0A2E   LDX #$07
b0A30   LDA #$90
        STA f07F8,X
        LDA f0A6E,X
        STA $D027,X  ;Sprite 0 Color
        DEX 
        BPL b0A30

MainLoop
        JSR s0DEA
        LDA a09BD
        BEQ b0A4F
b0A46   LDA LastKeyPressed
        CMP #$40
        BNE b0A46
        JMP RestartExecution

b0A4F   JMP MainLoop

p0A52   LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE b0A76
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

        ; Data
 a0A5F  .BYTE $02
 a0A60  .BYTE $02
 a0A61  .BYTE $01
 a0A62  .BYTE $01
 a0A63  .BYTE $8F
 a0A64  .BYTE $DD
 a0A65  .BYTE $A2
 a0A66  .BYTE $05
 a0A67  .BYTE $06
 a0A68  .BYTE $01
 a0A69  .BYTE $02
        .BYTE $01
 a0A6B  .BYTE $01
 a0A6C  .BYTE $BF
 a0A6D  .BYTE $A1
 f0A6E  .BYTE $02
        .BYTE $0A,$08,$07,$05,$0E,$04,$06


b0A76   LDY #$00
        LDA #$F0
        STA $D012    ;Raster Position
        DEC a0A5F
        BNE b0A92
        LDA a0A60
        STA a0A5F
        LDA a0BDC
        CLC 
        ADC a0A64
        STA a0A64
b0A92   DEC a0A62
        BNE b0AA7
        LDA a0A61
        STA a0A62
        LDA a0A65
        CLC 
        ADC a0BDD
        STA a0A65
b0AA7   DEC a0A66
        BNE b0AB5
        LDA a0A67
        STA a0A66
        INC a0A6C
b0AB5   DEC a0A68
        BNE b0AC3
        LDA a0A69
        STA a0A68
        INC a0A6D
b0AC3   LDA a0A64
        PHA 
        LDA a0A65
        PHA 
        LDA a0A6C
        PHA 
        LDA a0A6D
        PHA 
b0AD3   LDA a0A64
        AND #$3F
        TAX 
        LDA f097B,X
        STA a09BE
        LDA a0A65
        AND #$3F
        TAX 
        LDA f097B,X
        STA a09BF
        LDA a0A6C
        AND #$3F
        TAX 
        LDA f097B,X
        STA a09C0
        LDA a0A6D
        AND #$3F
        TAX 
        LDA f097B,X
        STA a09C1
        JSR s0BB6
        LDA a0A6D
        CLC 
        ADC #$08
        STA a0A6D
        LDA a0A6C
        CLC 
        ADC #$08
        STA a0A6C
        LDA a0A65
        CLC 
        ADC #$08
        STA a0A65
        LDA a0A64
        CLC 
        ADC #$08
        STA a0A64
        INY 
        INY 
        CPY #$10
        BNE b0AD3
        PLA 
        STA a0A6D
        PLA 
        STA a0A6C
        PLA 
        STA a0A65
        PLA 
        STA a0A64
        DEC a0A63
        BNE b0B9B
        LDA #$C0
        STA a0A63
        LDA a0DD1
        BNE b0B9B
        JSR s0BAF
        AND #$07
        CLC 
        ADC #$04
        TAX 
        STX a0E76
        LDA f0BDE,X
        STA a0A60
        LDA f0BEE,X
        STA a0BDC
        JSR s0BAF
        AND #$07
        CLC 
        ADC #$04
        TAX 
        STX a0E77
        LDA f0BDE,X
        STA a0A61
        LDA f0BEE,X
        STA a0BDD
        JSR s0BAF
        AND #$07
        CLC 
        ADC #$01
        STA a0A66
        STA a0A67
        JSR s0BAF
        AND #$07
        CLC 
        ADC #$01
        STA a0A68
        STA a0A69
b0B9B   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR s0D7E
        JSR s0878
        INC $D025    ;Sprite Multi-Color Register 0
        JMP eEA31

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
a0BB0   =*+$01
s0BAF   LDA aE024
        INC a0BB0
        RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s0BB6   LDA a09BE
        LDX a0A67
        BEQ b0BC4
        JSR s0BFE
        JMP j0BCA

b0BC4   CLC 
        ADC #$68
        STA $D000,Y  ;Sprite 0 X Pos
j0BCA   LDA a09BF
        LDX a0A69
        BEQ b0BD5
        JMP j0C13

b0BD5   CLC 
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

a0BDC
        .BYTE $01
a0BDD
        .BYTE $03
        ; 16 byte data field
f0BDE
        .BYTE $01,$08,$2B                 ; $0BD9:                     
        .BYTE $02,$03,$04,$05,$06,$07,$08,$09                 ; $0BE1:                     
        .BYTE $08,$07,$06,$05,$04

        ; 16 byte data field
f0BEE
        .BYTE $03,$02,$01                 ; $0BE9:                     
        .BYTE $09,$2B,$AD
        .BYTE $BE,$09,$18,$6A,$85                 ; $0BF1:                     
        .BYTE $FA,$AD,$C0,$09,$18

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
s0BFE   ROR 
        CLC 
        ADC aFA
        ADC #$68
        STA $D000,Y  ;Sprite 0 X Pos
        RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
        LDA a09BF
        CLC 
        ROR 
        STA aFA
        LDA a09C1
        CLC 
j0C13   ROR 
        CLC 
        ADC aFA
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
        LDX #$27
b0C1F   LDA f0C66,X
        AND #$3F
        STA f0428,X

s0C28   =*+$01
        LDA f0C8E,X
        AND #$3F
        STA f04A0,X
        LDA f0CB6,X
        AND #$3F
        STA f05B8,X
        LDA f0CDE,X
        AND #$3F
        STA f0608,X
        LDA f0D56,X
        AND #$3F
        STA f0658,X
        LDA f0D2E,X
        AND #$3F
        STA f0720,X
        LDA f0D06,X
        AND #$3F
        STA f06D0,X
        DEX 
        BPL b0C1F
        RTS 

        .TEXT " ", $05, "+*  *  * "
f0C66   .TEXT " TAURUS:TORUS  *  *  * ", $05, "+ANOTHER FROM TH"
f0C8E   .TEXT "E DNA STABLE.", $04, "+   BY YAKAUTO: OSC 1,0: O"
f0CB6   .TEXT "SC 2,0: OSC 3,0: OSC 4,0SPACE=AUTO ON/OF"
f0CDE   .TEXT "F  KEYS Z,X,C,V FOR OSCSFRACTAL "
a0CFE   .TEXT "SOUND"
a0D03   .TEXT " ST"
f0D06   .TEXT "RUCTURE DEMO FROM IRIDISSEE JUNE BYTE FO"
f0D2E   .TEXT "R MORE ON FRACTAL MUSIC.TEXT DISPLAY ON/"
f0D56   .TEXT "OFF PRESS THE F1 KEY.", $04, "+"

;------------------------------------------------------------
; SubRoutine
;------------------------------------------------------------
        .BYTE $AE ;ANC #$AE
        ROR f0E,X
        LDA a09BC
        BNE b0D76
        RTS 

b0D76   LDA f0DDA,X
        AND #$3F
        STA a05C4
s0D7E   LDX a0E77
        LDA f0DDA,X
        AND #$3F
        STA a05CD
        LDX a0A67
        LDA f0DDA,X
        AND #$3F
        STA a05D6
        LDX a0A69
        LDA f0DDA,X
        AND #$3F
        STA a05DF
        LDA a0DD1
        BNE b0DB2
        LDX #$03
b0DA6   LDA f0DD2,X
        AND #$3F
        STA f05B8,X
b0DAE   DEX 
        BPL b0DA6
        RTS 

b0DB2   LDX #$03
b0DB4   LDA f0DD6,X
        AND #$3F
        STA f05B8,X
        DEX 
a0DBD   BPL b0DB4
        RTS 

        BRK
        .TEXT "AUTOKEYS01234567"
f0DD2   =*+$01
f0DD6   =*+$05
a0DD1   .TEXT "89ABCDEF"

f0DDA   =*+$01
        LDA LastKeyPressed
        CMP #$40
        BNE b0DE0
        RTS 

b0DE0   CMP #$3C
        BNE b0DEF
        LDA a0DD1
        EOR #$01
s0DEA   =*+$01
        STA a0DD1
        JMP j0E5F

b0DEF   CMP #$0C
        BNE b0E0E
        LDA a0E76
        CLC 
        ADC #$01
        AND #$0F
        STA a0E76
        TAX 
        LDA f0BDE,X
        STA a0A60
        LDA f0BEE,X
        STA a0BDC
        JMP j0E5F

b0E0E   CMP #$17
        BNE b0E2D
        LDA a0E77
        CLC 
        ADC #$01
        AND #$0F
        STA a0E77
        TAX 
        LDA f0BDE,X
        STA a0A61
        LDA f0BEE,X
        STA a0BDD
        JMP j0E5F

b0E2D   CMP #$14
        BNE b0E3F
        LDA a0A67
        CLC 
        ADC #$01
        AND #$0F
        STA a0A67
        JMP j0E5F

b0E3F   CMP #$1F
        BNE b0E55
        LDA a0A69
        CLC 
        ADC #$01
        AND #$0F
        STA a0A69
b0E4E   LDA LastKeyPressed
        CMP #$40
        BNE b0E4E
        RTS 

b0E55   CMP #$04
        BNE b0E64
        LDA a09BC
        EOR #$01

j0E5F   =*+$01
        STA a09BC
        INC a09BD
b0E64   RTS 

        PHP 
        ORA aC4
        ORA #$EE
        CMP a09
        RTS 

;----------------------------------------------------------------------
;Start of Charset Data
;----------------------------------------------------------------------
        .BYTE $0B,$0A,$00,$FF                                 ; $0E6D:                     
        .BYTE $2B,$00,$FF,$2B,$00
        a0E76
        .BYTE $FF
        a0E77
        .BYTE $2B,$00                 ; $0E71:                     
        .BYTE $FF,$2B,$00,$FF,$2B,$00,$FF,$2B                 ; $0E79:                     
        .BYTE $00,$FF,$2B,$00,$FF,$2B,$00,$FF                 ; $0E81:                     
        .BYTE $2B,$00,$FF,$2B,$00,$FF,$2B,$00                 ; $0E89:                     
        .BYTE $E3,$2B,$55,$00,$F1,$2B,$55,$00                 ; $0E91:                     
        .BYTE $FF,$2B,$00,$FF,$2B,$00,$FF,$2B                 ; $0E99:                     
        .BYTE $00,$FF,$2B,$00,$B9,$2B                         ; $0EA1:                     
                                                              ; $0EA7
                                                              ;First char
        .BYTE $FF,$00                                                                    
        .BYTE $FF,$00,$00,$FF,$00,$FF                         ; $0EA9:                     
        .BYTE $3C,$66                                                                   
        .BYTE $C6,$DE,$C6,$04,$2B,$FC,$C6,$C6                 ; $0EB1:                     
        .BYTE $DC,$C6,$C6,$C6,$DC,$3C,$66,$C0                 ; $0EB9:                     
        .BYTE $04,$2B,$C6,$7C,$F8,$CC,$C6,$04                 ; $0EC1:                     
        .BYTE $2B,$CC,$D8,$FE,$C0,$C0,$D8,$C0                 ; $0EC9:                     
        .BYTE $C0,$C0,$DE,$FE,$C0,$C0,$D8,$C0                 ; $0ED1:                     
        .BYTE $04,$2B,$3C,$66,$C0,$C0,$DE,$C6                 ; $0ED9:                     
        .BYTE $C6,$7C,$C6,$C6,$C6,$DE,$C6,$04                 ; $0EE1:                     
        .BYTE $2B,$3C,$18,$06,$2B,$3C,$3C,$18                 ; $0EE9:                     
        .BYTE $05,$2B,$30,$60,$C6,$C6,$CC,$D8                 ; $0EF1:                     
        .BYTE $CC,$C6,$C6,$C6,$C0,$07,$2B,$DE                 ; $0EF9:                     
        .BYTE $FE,$DB,$04,$2B,$C3,$C3,$C3,$FC                 ; $0F01:                     
        .BYTE $C6,$07,$2B,$7C,$C6,$06,$2B,$5C                 ; $0F09:                     
        .BYTE $FC,$C6,$C6,$DC,$C0,$04,$2B,$7C                 ; $0F11:                     
        .BYTE $C6,$C6,$C6,$E6,$F6,$DE,$4C,$FC                 ; $0F19:                     
        .BYTE $C6,$C6,$DC,$CC,$C6,$C6,$C6,$7C                 ; $0F21:                     
        .BYTE $C6,$60,$30,$18,$0C,$C6,$7C,$7E                 ; $0F29:                     
        .BYTE $18,$07,$2B,$C6,$07,$2B,$FC,$C6                 ; $0F31:                     
        .BYTE $06,$2B,$6C,$38,$C3,$C3,$C3,$DB                 ; $0F39:                     
        .BYTE $04,$2B,$FE,$C6,$6C,$38,$04,$2B                 ; $0F41:                     
        .BYTE $6C,$C6,$04,$2B,$7E,$06,$06,$C6                 ; $0F49:                     
        .BYTE $7C,$FE,$0C,$18,$30,$60,$C0,$E6                 ; $0F51:                     
        .BYTE $3C,$00,$78,$60,$04,$2B,$78,$00                 ; $0F59:                     
        .BYTE $66,$C3,$7E,$5A,$7E,$7E,$3C,$00                 ; $0F61:                     
        .BYTE $00,$78,$18,$04,$2B,$78,$00,$00                 ; $0F69:                     
        .BYTE $18,$3C,$7E,$00,$05,$2B,$10,$30                 ; $0F71:                     
        .BYTE $70,$70,$30,$10,$00,$09,$2B,$68                 ; $0F79:                     
        .BYTE $05,$2B,$00,$68,$68,$36,$36,$00                 ; $0F81:                     
        .BYTE $07,$2B,$66,$66,$18,$18,$66,$66                 ; $0F89:                     
        .BYTE $00,$7E,$2C,$42,$8F,$C7,$EB,$C7                 ; $0F91:                     
        .BYTE $7E,$60,$E0,$6C,$7E,$7F,$36,$66                 ; $0F99:                     
        .BYTE $EE,$18,$18,$7E,$FF,$FF,$66,$66                 ; $0FA1:                     
        .BYTE $66,$0C,$18,$00,$06,$2B,$18,$30                 ; $0FA9:                     
        .BYTE $60,$04,$2B,$30,$18,$30,$18,$0C                 ; $0FB1:                     
        .BYTE $04,$2B,$18,$30,$00,$18,$00,$DB                 ; $0FB9:                     
        .BYTE $DB,$00,$18,$00,$18,$18,$18,$FF                 ; $0FC1:                     
        .BYTE $FF,$18,$18,$18,$00,$06,$2B,$30                 ; $0FC9:                     
        .BYTE $60,$00,$24,$66,$FF,$FF,$66,$24                 ; $0FD1:                     
        .BYTE $00,$07,$2B,$60,$60,$03,$0E,$18                 ; $0FD9:                     
        .BYTE $30,$60,$60,$C0,$C0,$FE,$FE,$00                 ; $0FE1:                     
        .BYTE $CE,$DE,$F6,$E6,$FE,$78,$78,$00                 ; $0FE9:                     
        .BYTE $38,$05,$2B,$FE,$FE,$00,$06,$06                 ; $0FF1:                     
        .BYTE $FE,$E0,$FE,$FE,$FE,$00,$06,$06                 ; $0FF9:                     
        .BYTE $3E,$06,$FE,$E0,$E0,$00,$E0,$EC                 ; $1001:                     
        .BYTE $FE,$0C,$0C,$FE,$FE,$00,$E0,$E0                 ; $1009:                     
        .BYTE $FE,$06,$FE,$FE,$FE,$00,$E0,$E0                 ; $1011:                     
        .BYTE $FE,$E6,$FE,$FE,$FE,$00,$06,$05                 ; $1019:                     
        .BYTE $2B,$FE,$FE,$00,$E6,$E6,$FE,$E6                 ; $1021:                     
        .BYTE $FE,$FE,$FE,$00,$E6,$E6,$FE,$06                 ; $1029:                     
        .BYTE $FE,$00,$60,$60,$00,$00,$60,$60                 ; $1031:                     
        .BYTE $00,$00,$30,$30,$00,$00,$30,$30                 ; $1039:                     
        .BYTE $60,$00,$06,$1A,$EA,$EA,$1A,$06                 ; $1041:                     
        .BYTE $00,$00,$00,$7E,$00,$7E,$00,$04                 ; $1049:                     
        .BYTE $2B,$60,$58,$57,$57,$58,$60,$00                 ; $1051:                     
        .BYTE $3C,$66,$06,$0C,$18,$18,$00,$04                 ; $1059:                     
        .BYTE $2B,$20,$00,$88,$00,$22,$00,$55                 ; $1061:                     
        .BYTE $55,$7A,$7A,$7A,$50,$55,$55,$00                 ; $1069:                     
        .BYTE $00,$20,$00,$88,$00,$22,$00,$55                 ; $1071:                     
        .BYTE $55,$A1,$A1,$A1,$01,$55,$55,$55                 ; $1079:                     
        .BYTE $7A,$0C,$2B,$40,$55,$55,$55,$A1                 ; $1081:                     
        .BYTE $0C,$2B,$01,$55,$55,$00,$0D,$FD                 ; $1089:                     
        .BYTE $0D,$BD,$0D,$0F,$BE,$0F,$FD,$0D                 ; $1091:                     
        .BYTE $0D,$BD,$0D,$00,$04,$2B,$40,$50                 ; $1099:                     
        .BYTE $54,$E1,$A1,$A1,$A1,$E1,$54,$50                 ; $10A1:                     
        .BYTE $40,$00,$04,$2B,$23,$0D,$35,$D5                 ; $10A9:                     
        .BYTE $55,$5E,$7A,$5E,$55,$D5,$35,$0D                 ; $10B1:                     
        .BYTE $03,$03,$03,$00,$48,$50,$54,$55                 ; $10B9:                     
        .BYTE $55,$85,$A1,$85,$55,$55,$54,$50                 ; $10C1:                     
        .BYTE $40,$40,$40,$03,$03,$03,$0B,$03                 ; $10C9:                     
        .BYTE $04,$2B,$55,$55,$5E,$7A,$55,$04                 ; $10D1:                     
        .BYTE $2B,$40,$40,$40,$60,$40,$04,$2B                 ; $10D9:                     
        .BYTE $55,$55,$85,$A1,$55,$04,$2B,$00                 ; $10E1:                     
        .BYTE $00,$02,$0D,$34,$34,$34,$0D,$03                 ; $10E9:                     
        .BYTE $03,$0D,$34,$34,$34,$0D,$03,$00                 ; $10F1:                     
        .BYTE $00,$20,$34,$0D,$0D,$0D,$34,$50                 ; $10F9:                     
        .BYTE $50,$34,$0D,$0D,$0D,$34,$50,$0A                 ; $1101:                     
        .BYTE $0A,$03,$0A,$0A,$03,$06,$16,$56                 ; $1109:                     
        .BYTE $56,$59,$59,$65,$65,$59,$55,$A0                 ; $1111:                     
        .BYTE $A0,$40,$A0,$A0,$40,$90,$94,$95                 ; $1119:                     
        .BYTE $95,$65,$59,$59,$65,$55,$55,$00                 ; $1121:                     
        .BYTE $00,$00,$88,$00,$21,$05,$15,$00                 ; $1129:                     
        .BYTE $40,$50,$56,$55,$04,$2B,$00,$01                 ; $1131:                     
        .BYTE $05,$95,$55,$04,$2B,$00,$00,$00                 ; $1139:                     
        .BYTE $22,$00,$48,$50,$54,$00,$20,$2B                 ; $1141:                     
        .BYTE $34,$D4,$34,$35,$35,$0D,$03,$0D                 ; $1149:                     
        .BYTE $55,$55,$7A,$7A,$7A,$50,$55,$55                 ; $1151:                     
        .BYTE $00,$00,$74,$D5,$55,$5D,$47,$5D                 ; $1159:                     
        .BYTE $55,$55,$AA,$AA,$AA,$00,$55,$55                 ; $1161:                     
        .BYTE $00,$00,$D4,$55,$55,$75,$0D,$4D                 ; $1169:                     
        .BYTE $55,$55,$AA,$AA,$AA,$00,$55,$55                 ; $1171:                     
        .BYTE $D0,$D4,$D0,$D0,$50,$40,$00,$40                 ; $1179:                     
        .BYTE $55,$55,$A1,$A1,$A1,$01,$55,$55                 ; $1181:                     
        .BYTE $00,$00,$03,$0D,$35,$56,$59,$6A                 ; $1189:                     
        .BYTE $59,$56,$35,$0D,$03,$00,$00,$03                 ; $1191:                     
        .BYTE $F8,$C0,$40,$43,$4D,$75,$55,$AA                 ; $1199:                     
        .BYTE $55,$75,$4D,$43,$40,$C0,$C0,$F0                 ; $11A1:                     
        .BYTE $55,$55,$78,$05,$2B,$55,$7A,$78                 ; $11A9:                     
        .BYTE $04,$2B,$55,$5E,$78,$55,$08,$2B                 ; $11B1:                     
        .BYTE $85,$E1,$04,$2B,$55,$A1,$55,$78                 ; $11B9:                     
        .BYTE $78,$5E,$55,$5E,$78,$7A,$78,$78                 ; $11C1:                     
        .BYTE $55,$AA,$5E,$04,$2B,$55,$55,$55                 ; $11C9:                     
        .BYTE $A1,$55,$85,$E1,$A1,$E1,$E1,$55                 ; $11D1:                     
        .BYTE $1E,$3A,$EA,$55,$AA,$55,$55,$55                 ; $11D9:                     
        .BYTE $78,$7B,$7A,$7B,$78,$55,$5E,$78                 ; $11E1:                     
        .BYTE $78,$78,$5E,$55,$78,$78,$55,$55                 ; $11E9:                     
        .BYTE $E1,$85,$15,$85,$E1,$55,$85,$E1                 ; $11F1:                     
        .BYTE $E1,$E1,$85,$55,$55,$55,$78,$78                 ; $11F9:                     
        .BYTE $7A,$55,$5E,$78,$7A,$78,$78,$55                 ; $1201:                     
        .BYTE $97,$A3,$AB,$57,$AA,$55,$55,$55                 ; $1209:                     
        .BYTE $A1,$55,$85,$E1,$A1,$E1,$E1,$55                 ; $1211:                     
        .BYTE $AA,$85,$04,$2B,$55,$0E,$00,$A0                 ; $1219:                     
        .BYTE $38,$00,$28,$E0,$14,$0A,$E0,$14                 ; $1221:                     
        .BYTE $0A,$E0,$55,$0A,$38,$55,$28,$0E                 ; $1229:                     
        .BYTE $55,$A0,$03,$96,$80,$07,$96,$90                 ; $1231:                     
        .BYTE $07,$96,$90,$15,$D6,$54,$15,$EA                 ; $1239:                     
        .BYTE $54,$55,$EA,$55,$55,$79,$55,$00                 ; $1241:                     
        .BYTE $38,$00,$00,$38,$00,$10,$2B                     ; $1249:                     
                                                              ; End of Charset and Sprite
        .BYTE $26                                                                        

b1252   =*+$01
;-------------------------------------------------------------
; CopyCodeCharsetAndSpriteData
; Copy the code from $1405 below to $0333 then branch to $0384
;-------------------------------------------------------------
CopyCodeCharSetAndSpriteData   =*+$02
        ASL a780F
        LDX #<p0A
        LDY #>p0A
        STX a14
        STY a15

; CharSetPtrLo/CharSetPtrHi set to $1252 the end of the charset and sprite data
        LDX #$52
        LDY #$12
        STX CharSetPtrLo
        STY CharSetPtrHi
        LDY #$00

; Copy 123 bytes of code from $1273 to $0333
        LDX #$7B
b1268   LDA f1273,X
        STA f0333,X
        DEX 
        BNE b1268
f1273   =*+$02
        JMP CopyCharSetData

; This is the boot code executed by FinishLoadingCharsetData.
; It's copied to $0801 below. The bytes disassemble to:
; * = $0801
;         ; 10 SYS 2064
;         .BYTE $0B,$08,$0A,$00,$9E,$32,$30,$36,$34,$00
;         .BYTE $00,$00,$08,$02,$00
; 
; ;--------------------------------------------------------               
; ; Execute
; ; e0810 (SYS 2064)
; ;--------------------------------------------------------
;         LDA #$7F
;         STA $DC0D 
;         LDA #$00
;         STA $D020 
;         STA $D021 
;         LDA #$18
;         STA $D018  ; Sets character set to 2000?
;         LDA

      .BYTE $0B,$08,$0A,$00,$9E                 ; $1271:                     
      .BYTE $32,$30,$36,$34,$00,$00,$00,$00                 ; $1279:                     
      .BYTE $FF,$00,$4C,$C2,$09,$08,$08,$09                 ; $1281:                     
      .BYTE $09,$0A,$0B,$0B,$0C,$0D,$0E,$0E                 ; $1289:                     
      .BYTE $0F,$10

; Copy the charset and sprite data to banks $2000 and $3000. Sprites
; are copied to $3000.
; - The sprite and charset data is read from the end instead of the front.
; - When a sequence such as $00,$05,$1E is encountered it is treated as a tag length
;   value (TLV) where $1E is the tag, $00 is the character to output and $05 is the
;   number of instances to output. So $00,$05,$1E translates to $00,$00,$00,$00,$00. 
; 
b1293   DEY 
        CPY #$FF
        BNE b129A
        DEC CharSetPtrHi
b129A   LDA (CharSetPtrLo),Y
        STA ZeroesToCopy
        DEY 
        CPY #$FF
        BNE b12A5
        DEC CharSetPtrHi

; CopyCharSetData
b12A5   LDA (CharSetPtrLo),Y
        CMP #$2B
        BEQ FinishLoadingCharSetData
        ; Copies the zeros specified by a TLV sequence.
b12AB   STA f2441,X
        DEX 
        CPX #$FF
b12B2   =*+$01
        BNE b12B9
        DEC a036D
        DEC a038C
b12B9   DEC ZeroesToCopy
        BNE b12AB
b12BD   DEY 
        CPY #$FF
        BNE b12C4
        DEC CharSetPtrHi
b12C4   LDA (CharSetPtrLo),Y
        CMP #$2B
        BEQ b1293
        STA f2441,X
        DEX 
        CPX #$FF
        BNE b12BD
        DEC a036D
        DEC a038C
        BNE b12BD
FinishLoadingCharSetData
        LDX #$1F
b12DC   LDA f0333,X
        STA f0800,X
        DEX 
        BNE b12DC
        LDA #$2B
        LDA #$37
        STA a01
        CLI 
        JMP eA8BC

