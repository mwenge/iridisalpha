;
; **** ZP FIELDS **** 
;
f08 = $08
f12 = $12
f13 = $13
f20 = $20
f61 = $61
fA0 = $A0
fEA = $EA
;
; **** ZP ABSOLUTE ADRESSES **** 
;
a01 = $01
a02 = $02
a03 = $03
a04 = $04
a05 = $05
a06 = $06
a0C = $0C
a0E = $0E
a0F = $0F
a12 = $12
a13 = $13
a14 = $14
a15 = $15
a16 = $16
a19 = $19
a1D = $1D
a20 = $20
a2D = $2D
a2E = $2E
a3B = $3B
a65 = $65
a74 = $74
aC5 = $C5
aFC = $FC
aFD = $FD
aFF = $FF
;
; **** ZP POINTERS **** 
;
p00 = $00
p01 = $01
p02 = $02
p04 = $04
p06 = $06
p0A = $0A
p0D = $0D
p0E = $0E
p11 = $11
p12 = $12
p13 = $13
p14 = $14
p19 = $19
p1D = $1D
p20 = $20
p27 = $27
p43 = $43
p68 = $68
p74 = $74
pA0 = $A0
pCB = $CB
pFC = $FC
;
; **** FIELDS **** 
;
f0101 = $0101
f0109 = $0109
f0120 = $0120
f0200 = $0200
f0303 = $0303
f0333 = $0333
f0340 = $0340
f0360 = $0360
f0404 = $0404
f0406 = $0406
f0407 = $0407
f0409 = $0409
f04FA = $04FA
f0500 = $0500
f0506 = $0506
f050B = $050B
f051D = $051D
f05F4 = $05F4
f0600 = $0600
f0605 = $0605
f0606 = $0606
f061D = $061D
f06EE = $06EE
f0700 = $0700
f0701 = $0701
f0707 = $0707
f0709 = $0709
f071D = $071D
f0800 = $0800
f1707 = $1707
f1807 = $1807
f1920 = $1920
f1D1D = $1D1D
f2000 = $2000
f207B = $207B
f20A9 = $20A9
f2820 = $2820
f3920 = $3920
f4B20 = $4B20
f5948 = $5948
f646F = $646F
f6C7E = $6C7E
f7001 = $7001
f70FB = $70FB
f71F5 = $71F5
f72EF = $72EF
f7401 = $7401
f74FB = $74FB
f75F5 = $75F5
f76EF = $76EF
f7AB5 = $7AB5
f7C7E = $7C7E
f7E01 = $7E01
f7EA0 = $7EA0
fA020 = $A020
fA07C = $A07C
fA0F8 = $A0F8
fC900 = $C900
fCD20 = $CD20
fD800 = $D800
fD8FA = $D8FA
fD920 = $D920
fD9F4 = $D9F4
fDAEE = $DAEE
fFC1D = $FC1D
fFC20 = $FC20
fFF00 = $FF00
;
; **** ABSOLUTE ADRESSES **** 
;
a0007 = $0007
a00C5 = $00C5
a0220 = $0220
a0314 = $0314
a0315 = $0315
a036D = $036D
a038C = $038C
a040F = $040F
a0604 = $0604
a1705 = $1705
a2004 = $2004
a2005 = $2005
a2013 = $2013
a202E = $202E
a21D0 = $21D0
a2C05 = $2C05
a2E27 = $2E27
a2E42 = $2E42
a5920 = $5920
a7E19 = $7E19
a7E20 = $7E20
aEF00 = $EF00
;
; **** POINTERS **** 
;
p0400 = $0400
p2017 = $2017
pA0A0 = $A0A0
;
; **** EXTERNAL JUMPS **** 
;
e00A9 = $00A9
e0102 = $0102
e0107 = $0107
e0201 = $0201
e0313 = $0313
e0384 = $0384
e0502 = $0502
e0504 = $0504
e0507 = $0507
e051A = $051A
e060F = $060F
e07A0 = $07A0
e1512 = $1512
e1720 = $1720
e1902 = $1902
e1D04 = $1D04
e1D05 = $1D05
e2020 = $2020
e2041 = $2041
e20A0 = $20A0
e4220 = $4220
e4927 = $4927
e494D = $494D
e4C41 = $4C41
e7820 = $7820
e7BA0 = $7BA0
e7E7C = $7E7C
eA0E1 = $A0E1
eA0F4 = $A0F4
eA8BC = $A8BC
eEA31 = $EA31
;
; **** PREDEFINED LABELS **** 
;
ROM_CHROUT = $FFD2

        * = $0801

;--------------------------------------------------------------
; Initialize the program from address $0816 (2070)
;--------------------------------------------------------------
s0803   .BYTE $11,$08,$00,$00,$9E,$32,$30,$37,$30,$20 ; SYS 2070
        .BYTE $4D,$4F,$52,$4F,$4E ; MORON (!?)

j0810   .BYTE $00,$00,$00
s0813   .BYTE $00
s0814   BRK #$00
s0817   =*+$01

;--------------------------------------------------------------
;Load Program ($0816)
;--------------------------------------------------------------
        LDA #$36
        STA a01
        JMP j141B

        ORA f1D1D,X
a0820   STA $D405    ;Voice 1: Attack / Decay Cycle Control
        STA $D40C    ;Voice 2: Attack / Decay Cycle Control
        STA $D413    ;Voice 3: Attack / Decay Cycle Control
        STA a0DBD
        LDA #$F0
        STA $D406    ;Voice 1: Sustain / Release Cycle Control
        STA $D40D    ;Voice 2: Sustain / Release Cycle Control
        STA $D414    ;Voice 3: Sustain / Release Cycle Control
        LDA #>p0400
        STA a03
        LDA #<p0400
        STA a02
        LDX #$00
b0841   LDA a02
        STA f0340,X
        LDA a03
        STA f0360,X
        LDA a02
        CLC 
        ADC #$28
        STA a02
        LDA a03
s0854   ADC #$00
s0857   =*+$01
        STA a03
        INX 
        CPX #$1A
        BNE b0841
        LDX #$00
        LDA #$20
b0861   STA p0400,X
        STA f0500,X
        STA f0600,X
        STA f0700,X
        DEX 
        BNE b0861
        JMP j08DD

a0874   =*+$01
a0873   BRK #$04
a0876   =*+$01
f0877   =*+$02
a0875   ORA $0802,X
        .BYTE $07,$05 ;SLO a05
        ASL a0604
        BRK #$03
a0880   =*+$01
a087F   .BYTE $03,$AE ;SLO ($AE,X)
s0881   ADC f08,X
        LDY a0874
        LDA f0340,X
        STA a02
        LDA f0360,X
        STA a03
        LDA (p02),Y
        RTS 

s0894   =*+$01
        JSR s0881
        LDA a0876
        STA (p02),Y
        LDA a03
        PHA 
        CLC 
        ADC #$D4
        STA a03
        LDA a0873
        STA (p02),Y
        PLA 
        STA a03
        RTS 

f08AC   ASL 
f08AD   ORA #$08
        .BYTE $07,$06 ;SLO a06
        ORA a04
f08B4   =*+$01
a08B3   .BYTE $03,$0C ;SLO (p0C,X)
f08B5   .BYTE $07,$1D ;SLO a1D
        LDA #<p08F1
a08BB   =*+$02
        STA a0314    ;IRQ
s08BC   LDA #>p08F1
        STA a0315    ;IRQ
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

        JSR s0BBC
j08DD   =*+$02
        JSR s0C9A
        JSR s0DC0
        JSR s08BC
b08E4   LDA a0DBD
        BEQ b08E4
        JMP j0810

        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
p08F1   BNE b08F9
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

b08F9   JSR s091C
        JSR s0CFD
        JSR s0E4F
        JSR s0AAE
        LDA #$01
s0908   =*+$01
f0909   =*+$02
f0907   STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
s090D   LDA #$FE
        STA $D012    ;Raster Position
s0913   =*+$01
s0914   =*+$02
        JMP eEA31

        ORA (p00,X)
        DEC a0880
a091B   =*+$01
a091A   BEQ b091D
s091C   RTS 

b091D   LDA a087F
a0920   STA a0880
        LDA a0C99
        BEQ b0930
        LDA #$00
        STA a0C99
        JMP j09CE

b0930   LDA a08B3
        STA a0874
        LDA a08BB
        STA a0875
        JSR s09DD
        LDX #$06
b0941   LDA f08AC,X
        STA f08AD,X
s0948   =*+$01
        LDA f08B4,X
        STA f08B5,X
        DEX 
        BNE b0941
        LDA f08AD
        CLC 
j0955   =*+$01
        ADC a091A
        STA f08AD
        CMP #$FF
        BNE b0966
        LDA #$26
        STA f08AD
        JMP j0974

b0966   CMP #$27
        BNE b096F
        LDA #$00
        STA f08AD
b096F   LDA f08B5
        CLC 
j0974   =*+$01
        ADC a091B
        STA f08B5
        CMP #$FF
        BNE b0985
        LDA #$16
        STA f08B5
        JMP j0993

b0985   CMP #$17
        BNE b098E
        LDA #$00
        STA f08B5
b098E   JSR s09EA
j0993   =*+$02
        LDA f08AD
        STA a0874
        LDA f08B5
        STA a0875
        JSR s0881
        JSR s0A3B
        LDX #$00
b09A5   LDA f08AD,X
        STA a0874
        LDA f08B5,X
        STA a0875
        LDA #$A0
        STA a0876
        LDA f0877,X
        STA a0873
        TXA 
        PHA 
        JSR s0894
        PLA 
        TAX 
        INX 
        CPX #$07
        BNE b09A5
b09C8   RTS 

        LDA f08AD
j09CE   =*+$02
        STA a0874
        LDA f08B5
        STA a0875
        JMP j0993

        JSR s0881
        CMP #$A0
s09DD   BNE b09C8
        LDA #$20
        STA (p02),Y
b09E3   RTS 

        RTI 

        LDA aC5
a09E9   =*+$02
        CMP a09E9
s09EA   BNE b09ED
        RTS 

b09ED   STA a09E9
        CMP #$40
        BEQ b09E3
        PHA 
        LDA f08AD
        STA a0874
        LDA f08B5
        STA a0875
        PLA 
        CMP #$27
        BNE b0A13
        LDA #$4E
        STA a0876
        LDA #$01
        STA a0873
j0A10   JMP s0894

b0A13   CMP #$24
        BNE b0A1F
        LDA #$4D
        STA a0876
        JMP j0A10

b0A1F   CMP #$3C
        BNE b0A2D
        DEC a087F
        BNE b0A2D
        LDA #$04
        STA a087F
b0A2D   RTS 

        ORA (p00,X)
        .BYTE $FF,$00,$01 ;ISC $0100,X
        BRK #$FF
        BRK #$C9
        EOR a21D0
s0A3B   =*+$01
        LDA #$4E
        STA (p02),Y
        LDA a091A
        PHA 
        LDA a091B
        STA a091A
        PLA 
        STA a091B
        PLA 
        PLA 
        LDA #$01
        STA a0C99
        LDA #$04
        STA a0E49
j0A58   JMP j0955

        CMP #$4E
        BNE b0A85
        LDA #$4D
        STA (p02),Y
        LDA a091A
        EOR #$FF
        CLC 
        ADC #$01
        PHA 
        LDA a091B
        EOR #$FF
        CLC 
        ADC #$01
        STA a091A
        PLA 
        STA a091B
        PLA 
        PLA 
        LDA #$01
        STA a0C99
        JMP j0A58

b0A85   CMP #$51
        BNE b0AA7
        LDA #$20
        STA a0E4A
        LDA #$20
        STA (p02),Y
        LDA #$01
        STA a0BBA
        INC a0AAD
        JSR s0C23
        JSR s0C9A
        RTS 

        LDA aEF00
s0AA6   =*+$02
        INC b0AA7
b0AA7   RTS 

        BRK #$AD
        LDA $D00A    ;Sprite 5 X Pos
s0AAE   =*+$01
a0AAD   .BYTE $1B,$20,$A6 ;SLO $A620,Y
        ASL 
        AND #$1F
        CLC 
        ADC #$03
        STA a0AF5
        JSR s0AA6
        AND #$0F
        CLC 
        ADC #$03
        STA a0AF6
        LDA #$01
        STA a0AAD
        CMP #$01
        BNE b0AF3
        LDA #$51
        STA a0876
        INC a0AF7
        LDA a0AF7
        AND #$07
        TAX 
        LDA f0877,X
        STA a0873
        LDA a0AF5
        STA a0874
        LDA a0AF6
        STA a0875
        JMP s0894

        BRK #$00
b0AF3   =*+$01
        BRK #$A9
a0AF5   =*+$01
        LDY #$8D
a0AF7   =*+$01
a0AF6   ROR f08,X
        LDA a0BBA
        STA a0BBB
        LDA #$00
        STA a0AF7
b0B03   JSR s0B2B
        INC a0AF7
        LDA a0AF7
        CMP #$08
        BEQ b0B15
        DEC a0BBB
        BNE b0B03
b0B15   INC a0BBA
        LDA a0BBA
        CMP #$30
        BEQ b0B20
        RTS 

b0B20   LDA #$00
        STA a0AAD
        RTS 

        LDX a0AF7
s0B2B   =*+$02
        LDA f0877,X
        STA a0873
        LDA a0AF5
        SEC 
        SBC a0BBB
        STA a0874
        LDA a0AF6
        SEC 
        SBC a0BBB
        STA a0875
        JSR s0BA3
        LDA a0874
        CLC 
        ADC a0BBB
        STA a0874
        JSR s0BA3
        LDA a0874
        CLC 
        ADC a0BBB
        STA a0874
        JSR s0BA3
        LDA a0875
        CLC 
        ADC a0BBB
        STA a0875
        JSR s0BA3
        LDA a0875
        CLC 
        ADC a0BBB
        STA a0875
        JSR s0BA3
        LDA a0874
        SEC 
        SBC a0BBB
        STA a0874
        JSR s0BA3
        LDA a0874
        SEC 
        SBC a0BBB
        STA a0874
        JSR s0BA3
        LDA a0875
        SEC 
        SBC a0BBB
        STA a0875
        LDA a0874
        BMI b0BA7
s0BA3   CMP #$27
        BMI b0BA8
b0BA7   RTS 

b0BA8   LDA a0875
        BMI b0BA7
        CMP #$16
        BMI b0BB2
        RTS 

b0BB2   JMP s0894

        BRK #$00
        LDA #$00
a0BBA   =*+$01
a0BBB   =*+$02
        STA a0874
s0BBC   LDA #>p2017
        STA a0876
        LDA #<p2017
        STA a0875
b0BC6   LDX a0874
        LDA f0BF1,X
        STA a0873
        JSR s0894
        INC a0875
        JSR s0894
        DEC a0875
        INC a0874
        LDA a0874
        CMP #$28
        BNE b0BC6
        LDA #$00
        STA a0BF0
        RTS 

        BRK #$02
        ASL a1D
        PHP 
f0BF1   =*+$01
a0BF0   ASL a1D
        .BYTE $07,$05 ;SLO a05
        ORA f0605,X
        ORA f050B,X
        ORA a0604,X
        ORA f0606,X
f0C02   =*+$02
        ORA f2000,X
        ADC a74
        ADC f61,X
a0C07   INC fEA,X
        .BYTE $E7,$A0 ;ISC aA0
        LDA a0D41
        ROR 
        ROR 
a0C10   AND #$03
        TAX 
        INX 
        LDA #$00
        STA a0C19
f0C1A   =*+$01
a0C19   LDA #$05
        SEC 
        SBC a087F
        CLC 
        ADC a0C19
s0C23   STA a0C19
        DEX 
        BNE a0C19
b0C29   JSR s0C4D
        DEC a0C19
        BNE b0C29
        JSR s0DC0
        RTS 

        LDA #$18
        STA a0875
        LDA a0BF0
        STA a0874
        JSR s0881
        LDX #$00
        CMP f0C1A,X
        BEQ b0C4E
        INX 
s0C4D   =*+$02
        JMP j0C5D

b0C4E   CMP #$A0
s0C50   BEQ b0C65
        INX 
        LDA f0C1A,X
        STA a0876
        LDX a0874
j0C5D   =*+$01
        LDA f0BF1,X
        STA a0873
        JMP s0894

b0C65   INC a0874
        INC a0BF0
        LDA a0BF0
b0C6E   CMP #$27
j0C71   =*+$01
        BNE b0C79
        DEC a0BF0
        INC a0DBD
        RTS 

b0C79   LDA #$20
        STA a0876
        JMP j0C71

        BRK #$A9
        BRK #$8D
        ADC f08,X
        LDA #$27
        STA a0874
b0C8C   LDX a0875
        LDA f0CCC,X
        CMP #$A0
        BEQ b0C98
        AND #$3F
a0C99   =*+$01
s0C9A   =*+$02
b0C98   STA a0876
        LDA f0CE4,X
f0CA0   =*+$02
        STA a0873
        JSR s0894
        INC a0875
b0CA8   =*+$01
        LDA a0875
        CMP #$18
        BNE b0C8C
        LDA #$00
        STA a0D41
        RTS 

        LDY #$0C
        ORA fCD20,X
        CMP #$C6
        JSR e4220
        EOR fD920,Y
        CMP (pCB,X)
        .BYTE $02    ;JAM 
        .BYTE $04,$1D ;NOP a1D
        ORA (p04,X)
        ORA f0406,X
f0CCC   =*+$01
        ORA f0200,X
        ORA (p06,X)
        BRK #$00
        .BYTE $04,$04 ;NOP a04
        BRK #$07
        .BYTE $07,$07 ;SLO $07
        BPL b0CA8
        .BYTE $FC,$0C,$D0 ;NOP $D00C,X
        CMP #$A9
        BPL b0C6E
        .BYTE $FC,$0C,$AD ;NOP $AD0C,X
f0CE4   EOR (p0D,X)
        STA a0875
        LDA #$27
        STA a0874
        JSR s0881
        LDX #$00
b0CF3   CMP f0D42,X
        BEQ b0CFB
        INX 
        BNE b0CF3
b0CFB   CMP #$20
s0CFD   BEQ b0D12
        INX 
        LDA f0D42,X
        STA a0876
        LDX a0D41
        LDA f0CE4,X
f0D0D   =*+$01
        STA a0873
        JMP s0894

b0D12   INC a0D41
        LDA a0D41
        CMP #$0C
        BEQ b0D27
        RTS 

        BRK #$A0
        .BYTE $E3,$F7 ;ISC ($F7,X)
        SED 
        .BYTE $62    ;JAM 
        ADC f646F,Y
b0D27   =*+$01
        JSR @we00A9
        STA a0874
        STA a0875
        LDA #$CF
        STA a0876
        LDA #$00
        STA a0DBC
        JSR s0D76
        LDA #$20
        STA a0876
f0D42   =*+$01
a0D41   LDA #$00
        STA a0874
        STA a0875
        JSR s0D76
        LDA #$01
        STA a0DBD
        RTS 

b0D52   LDA a0876
        CMP #$20
        BEQ b0D71
        INC a0DBC
        LDA a0DBC
        CMP #$06
        BNE b0D68
        LDA #$00
        STA a0DBC
b0D68   LDX a0DBC
        LDA f0877,X
        STA a0873
b0D71   JSR s0894
        LDY #$02
s0D76   LDX #$A0
b0D78   DEX 
        BNE b0D78
        DEY 
        BNE s0D76
        INC a0874
        LDA a0874
        CMP #$27
        BNE b0D52
        LDA #$00
        STA a0874
        INC a0875
        LDA a0875
        CMP #$17
        BNE b0D52
        RTS 

        BRK #$04
        ORA f20A9,X
        STA a0876
        LDA #$17
        STA a0875
        LDA a0DBE
        STA a0874
        JSR s0894
        LDA a0BF0
        CMP a0DBE
        BEQ b0DFC
        BPL b0DD8
        LDA a0DBE
a0DBC   =*+$01
a0DBD   =*+$02
        STA a0874
a0DBF   =*+$01
a0DBE   LDA #$17
s0DC0   STA a0875
        LDX a0DBE
        LDA f0BF1,X
        STA a0873
        LDX a0DBF
        LDA f0E40,X
        STA a0876
        JMP s0894

b0DD8   LDA a0BF0
j0DDD   =*+$02
        STA a0874
        LDA #$18
        STA a0875
        JSR s0881
        LDX #$00
b0DE8   CMP f0C1A,X
        BEQ b0DF0
        INX 
        BNE b0DE8
b0DF0   STX a0DBF
        LDA a0BF0
        STA a0DBE
        JMP j0DDD

b0DFC   LDA a0BF0
        STA a0874
        LDA #$18
f0E05   =*+$01
        STA a0875
s0E09   =*+$02
        JSR s0881
        LDX #$00
b0E0C   CMP f0C1A,X
        BEQ b0E14
        INX 
        BNE b0E0C
b0E14   TXA 
        CMP a0DBF
        BPL b0DF0
        RTS 

        ADC a65
        .BYTE $54,$47 ;NOP $47,X
        .BYTE $42    ;JAM 
        EOR f5948,X
        .BYTE $67,$00 ;RRA a00
        BRK #$C0
        RTI 

        CPX #$10
        LDA a0E49
        BEQ b0E46
        TAX 
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA f0E4B,X
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        DEC a0E49
        BNE b0E46
f0E40   LDA #$80
        STA $D404    ;Voice 1: Control Register
b0E45   RTS 

b0E46   LDA a0E4A
a0E4A   =*+$01
a0E49   BEQ b0E45
f0E4B   LDA #$00
s0E4F   =*+$02
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA #$20
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA a0E4A
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        DEC a0E4A
        BNE b0E45
        LDA #$80
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        RTS 

        .BYTE $00,$FF,$1D,$00,$FF                    ; $0E71:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0E79:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0E81:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0E89:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0E91:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0E99:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0EA1:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0EA9:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0EB1:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0EB9:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0EC1:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0EC9:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0ED1:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0ED9:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0EE1:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0EE9:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0EF1:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0EF9:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0F01:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0F09:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0F11:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0F19:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0F21:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0F29:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0F31:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0F39:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0F41:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0F49:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0F51:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0F59:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0F61:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0F69:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0F71:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$FF        ; $0F79:            
        .BYTE $1D,$00,$FF,$1D,$00,$FF,$1D,$00        ; $0F81:            
        .BYTE $FF,$1D,$00,$FF,$1D,$00,$FF,$1D        ; $0F89:            
        .BYTE $00,$FF,$1D,$00,$FF,$1D,$00,$C9        ; $0F91:            
        .BYTE $1D,$20,$28,$1D,$A0,$0C,$1D,$20        ; $0F99:            
        .BYTE $FC,$79,$7C,$A0,$1C,$1D,$7E,$20        ; $0FA1:            
        .BYTE $20,$20,$7C,$A0,$A0,$7E,$20,$A0        ; $0FA9:            
        .BYTE $FE,$7E,$7C,$A0,$1A,$1D,$7E,$6C        ; $0FB1:            
        .BYTE $A0,$A0,$A0,$7B,$20,$20,$20,$E1        ; $0FB9:            
        .BYTE $A0,$E7,$20,$07,$1D,$7C,$A0,$13        ; $0FC1:            
        .BYTE $1D,$7E,$6C,$A0,$05,$1D,$7B,$20        ; $0FC9:            
        .BYTE $6C,$A0,$A0,$7E,$20,$19,$1D,$A0        ; $0FD1:            
        .BYTE $7E,$20,$A0,$07,$1D,$F8,$A0,$A0        ; $0FD9:            
        .BYTE $7E,$20,$4D,$49,$46,$2D,$20,$54        ; $0FE1:            
        .BYTE $08,$05,$20,$10,$01,$15,$13,$05        ; $0FE9:            
        .BYTE $20,$0D,$0F,$04,$05,$20,$0F,$06        ; $0FF1:            
        .BYTE $20,$0D,$19,$7E,$79,$A0,$A0,$FC        ; $0FF9:            
        .BYTE $FB,$A0,$A0,$F9,$EF,$A0,$A0,$7E        ; $1001:            
        .BYTE $20,$20,$0E,$05,$17,$20,$07,$01        ; $1009:            
        .BYTE $0D,$05,$2C,$20,$27,$49,$52,$49        ; $1011:            
        .BYTE $44,$49,$53,$20,$41,$4C,$50,$48        ; $1019:            
        .BYTE $41,$27,$2E,$20,$7E,$20,$E1,$A0        ; $1021:            
        .BYTE $75,$20,$04,$1D,$76,$A0,$E1,$20        ; $1029:            
        .BYTE $1D,$1D,$FC,$20,$A0,$7B,$20,$04        ; $1031:            
        .BYTE $1D,$A0,$7E,$E1,$74,$20,$54,$08        ; $1039:            
        .BYTE $05,$20,$09,$04,$05,$01,$20,$09        ; $1041:            
        .BYTE $13,$20,$13,$09,$0D,$10,$0C,$05        ; $1049:            
        .BYTE $2E,$20,$48,$09,$14,$20,$04,$1D        ; $1051:            
        .BYTE $A0,$7E,$F5,$A0,$20,$04,$1D,$A0        ; $1059:            
        .BYTE $7E,$E1,$74,$20,$14,$08,$05,$20        ; $1061:            
        .BYTE $44,$4F,$54,$20,$17,$09,$14,$08        ; $1069:            
        .BYTE $20,$14,$08,$05,$20,$0C,$09,$07        ; $1071:            
        .BYTE $08,$14,$20,$04,$1D,$A0,$F6,$20        ; $1079:            
        .BYTE $F4,$A0,$20,$20,$20,$A0,$20,$20        ; $1081:            
        .BYTE $A0,$20,$20,$02,$05,$01,$0D,$20        ; $1089:            
        .BYTE $02,$05,$06,$0F,$12,$05,$20,$14        ; $1091:            
        .BYTE $08,$05,$20,$14,$09,$0D,$05,$12        ; $1099:            
        .BYTE $20,$05,$1D,$78,$78,$20,$20,$78        ; $10A1:            
        .BYTE $78,$20,$20,$78,$78,$20,$7C,$7E        ; $10A9:            
        .BYTE $20,$07,$05,$14,$13,$20,$14,$0F        ; $10B1:            
        .BYTE $20,$1A,$05,$12,$0F,$2E,$20,$54        ; $10B9:            
        .BYTE $08,$05,$20,$02,$05,$01,$0D,$20        ; $10C1:            
        .BYTE $09,$13,$04,$05,$06,$0C,$05,$03        ; $10C9:            
        .BYTE $14,$05,$04,$20,$02,$19,$20,$01        ; $10D1:            
        .BYTE $0E,$07,$0C,$05,$04,$20,$0D,$09        ; $10D9:            
        .BYTE $12,$12,$0F,$12,$13,$20,$17,$08        ; $10E1:            
        .BYTE $09,$03,$08,$20,$19,$0F,$15,$20        ; $10E9:            
        .BYTE $20,$20,$10,$0C,$01,$03,$05,$20        ; $10F1:            
        .BYTE $09,$0E,$20,$14,$08,$05,$20,$10        ; $10F9:            
        .BYTE $01,$14,$08,$20,$0F,$06,$20,$14        ; $1101:            
        .BYTE $08,$05,$20,$02,$05,$01,$0D,$20        ; $1109:            
        .BYTE $02,$19,$20,$10,$12,$05,$13,$13        ; $1111:            
        .BYTE $2D,$20,$09,$0E,$07,$20,$27,$4E        ; $1119:            
        .BYTE $27,$20,$0F,$12,$27,$4D,$27,$2E        ; $1121:            
        .BYTE $20,$54,$08,$05,$20,$02,$05,$01        ; $1129:            
        .BYTE $0D,$20,$12,$05,$06,$0C,$05,$03        ; $1131:            
        .BYTE $14,$13,$20,$0F,$06,$06,$20,$0F        ; $1139:            
        .BYTE $06,$20,$14,$08,$05,$13,$05,$3B        ; $1141:            
        .BYTE $20,$04,$05,$06,$0C,$05,$03,$14        ; $1149:            
        .BYTE $20,$09,$14,$20,$14,$0F,$20,$08        ; $1151:            
        .BYTE $09,$14,$20,$14,$08,$05,$20,$14        ; $1159:            
        .BYTE $01,$12,$07,$05,$14,$2E,$20,$04        ; $1161:            
        .BYTE $1D,$4E,$42,$2E,$20,$57,$08,$05        ; $1169:            
        .BYTE $0E,$05,$16,$05,$12,$20,$14,$08        ; $1171:            
        .BYTE $05,$20,$02,$05,$01,$0D,$20,$08        ; $1179:            
        .BYTE $09,$14,$13,$20,$01,$20,$0D,$09        ; $1181:            
        .BYTE $12,$12,$0F,$12,$20,$09,$14,$20        ; $1189:            
        .BYTE $20,$17,$09,$0C,$0C,$20,$06,$0C        ; $1191:            
        .BYTE $09,$10,$20,$14,$08,$01,$14,$20        ; $1199:            
        .BYTE $0D,$09,$12,$12,$0F,$12,$20,$02        ; $11A1:            
        .BYTE $19,$20,$39,$30,$20,$04,$05,$07        ; $11A9:            
        .BYTE $12,$05,$05,$13,$2E,$20,$54,$0F        ; $11B1:            
        .BYTE $20,$03,$08,$01,$0E,$07,$05,$20        ; $11B9:            
        .BYTE $02,$05,$01,$0D,$20,$13,$10,$05        ; $11C1:            
        .BYTE $05,$04,$2C,$20,$10,$12,$05,$13        ; $11C9:            
        .BYTE $13,$20,$53,$50,$41,$43,$45,$2E        ; $11D1:            
        .BYTE $20,$59,$0F,$15,$12,$20,$04,$1D        ; $11D9:            
        .BYTE $13,$03,$0F,$12,$05,$20,$09,$13        ; $11E1:            
        .BYTE $20,$13,$08,$0F,$17,$0E,$20,$02        ; $11E9:            
        .BYTE $19,$20,$14,$08,$05,$20,$02,$01        ; $11F1:            
        .BYTE $12,$20,$01,$14,$20,$14,$08,$05        ; $11F9:            
        .BYTE $20,$02,$01,$13,$05,$20,$0F,$06        ; $1201:            
        .BYTE $14,$08,$05,$20,$13,$03,$12,$05        ; $1209:            
        .BYTE $05,$0E,$2E,$20,$54,$08,$05,$20        ; $1211:            
        .BYTE $06,$01,$13,$14,$05,$12,$20,$14        ; $1219:            
        .BYTE $08,$05,$20,$02,$05,$01,$0D,$20        ; $1221:            
        .BYTE $01,$0E,$04,$20,$14,$08,$05,$20        ; $1229:            
        .BYTE $13,$0F,$0F,$0E,$05,$12,$20,$19        ; $1231:            
        .BYTE $0F,$15,$20,$08,$09,$14,$20,$14        ; $1239:            
        .BYTE $08,$05,$20,$14,$01,$12,$07,$05        ; $1241:            
        .BYTE $14,$20,$14,$08,$05,$20,$08,$09        ; $1249:            
        .BYTE $07,$08,$05,$12,$20,$14,$08,$05        ; $1251:            
        .BYTE $13,$03,$0F,$12,$05,$2E,$47,$01        ; $1259:            
        .BYTE $0D,$05,$20,$12,$05,$13,$14,$01        ; $1261:            
        .BYTE $12,$14,$13,$20,$17,$08,$05,$0E        ; $1269:            
        .BYTE $20,$14,$09,$0D,$05,$12,$20,$12        ; $1271:            
        .BYTE $15,$0E,$13,$20,$0F,$15,$14,$2E        ; $1279:            
        .BYTE $49,$0E,$04,$09,$03,$01,$14,$0F        ; $1281:            
        .BYTE $12,$20,$01,$02,$0F,$16,$05,$20        ; $1289:            
        .BYTE $13,$03,$0F,$12,$05,$20,$02,$01        ; $1291:            
        .BYTE $12,$20,$13,$08,$0F,$17,$13,$20        ; $1299:            
        .BYTE $14,$08,$05,$20,$08,$09,$07,$08        ; $12A1:            
        .BYTE $13,$03,$0F,$12,$05,$2E,$20,$59        ; $12A9:            
        .BYTE $20,$41,$20,$4B,$2E,$20,$50,$12        ; $12B1:            
        .BYTE $05,$13,$13,$20,$41,$0E,$19,$20        ; $12B9:            
        .BYTE $4B,$05,$19,$20,$54,$0F,$20,$50        ; $12C1:            
        .BYTE $0C,$01,$19,$20,$4D,$49,$46,$2E        ; $12C9:            
        .BYTE $A0,$18,$1D,$01,$01,$07,$06,$1D        ; $12D1:            
        .BYTE $01,$08,$1D,$07,$18,$1D,$02,$0C        ; $12D9:            
        .BYTE $1D,$09,$09,$09,$02,$19,$1D,$09        ; $12E1:            
        .BYTE $05,$1D,$07,$09,$07,$09,$04,$1D        ; $12E9:            
        .BYTE $07,$09,$1B,$1D,$07,$04,$1D,$09        ; $12F1:            
        .BYTE $06,$1D,$07,$07,$09,$09,$09,$07        ; $12F9:            
        .BYTE $19,$1D,$05,$05,$05,$09,$07,$1D        ; $1301:            
        .BYTE $07,$09,$04,$1D,$07,$19,$1D,$04        ; $1309:            
        .BYTE $04,$07,$09,$0B,$1D,$07,$01,$19        ; $1311:            
        .BYTE $1D,$06,$09,$0C,$1D,$07,$07,$01        ; $1319:            
        .BYTE $0A,$1D,$05,$0E,$1D,$01,$07,$09        ; $1321:            
        .BYTE $07,$09,$09,$09,$07,$04,$1D,$09        ; $1329:            
        .BYTE $09,$09,$07,$07,$07,$01,$11,$1D        ; $1331:            
        .BYTE $07,$09,$1D,$09,$07,$09,$09,$07        ; $1339:            
        .BYTE $04,$1D,$09,$04,$1D,$07,$01,$17        ; $1341:            
        .BYTE $1D,$07,$04,$1D,$09,$04,$1D,$07        ; $1349:            
        .BYTE $04,$1D,$09,$04,$1D,$07,$01,$04        ; $1351:            
        .BYTE $1D,$03,$03,$03,$01,$12,$1D,$07        ; $1359:            
        .BYTE $09,$09,$07,$09,$09,$07,$07,$07        ; $1361:            
        .BYTE $09,$07,$07,$09,$07,$07,$01,$18        ; $1369:            
        .BYTE $1D,$09,$07,$09,$09,$07,$07,$09        ; $1371:            
        .BYTE $09,$07,$09,$07,$1D,$01,$68,$1D        ; $1379:            
        .BYTE $09,$01,$04,$1D,$05,$05,$05,$01        ; $1381:            
        .BYTE $01,$01,$05,$05,$05,$01,$1A,$1D        ; $1389:            
        .BYTE $09,$01,$28,$1D,$03,$03,$03,$01        ; $1391:            

        JMP b091D

        ORA (p19,X)
        ORA f0506,X
        ORA f7E01,X
        ORA e0107,X
        EOR f071D,Y
        ORA (p06,X)
        ORA f1707,X
        ORA f0D0D,X
        ORA @wa0007
        .BYTE $FF,$1D,$00 ;ISC $001D,X
        .BYTE $FF,$1D,$00 ;ISC $001D,X
        ADC (p1D),Y
        LDA #$0E
        JSR ROM_CHROUT ;$FFD2 - output character                 
        LDA #$93
        JSR ROM_CHROUT ;$FFD2 - output character                 
        LDA #$90
        JSR ROM_CHROUT ;$FFD2 - output character                 
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDX #$00
b13D6   LDA f7001,X
        STA p0400,X
        LDA f70FB,X
        STA f04FA,X
        LDA f71F5,X
        STA f05F4,X
        LDA f72EF,X
        STA f06EE,X
        LDA f7401,X
        STA fD800,X
        LDA f74FB,X
        STA fD8FA,X
        LDA f75F5,X
        STA fD9F4,X
s1401   =*+$01
        LDA f76EF,X
        STA fDAEE,X
        INX 
        CPX #$FA
        BNE b13D6
b140B   LDA @wa00C5
        CMP #$40
        BEQ b140B
        LDA #$8E
        JSR ROM_CHROUT ;$FFD2 - output character                 
        JMP j0810

;---------------------------------------------------
;---------------------------------------------------

; Copy 123 bytes from $143B to $0333
j141B   =*+$01
p141A   ORA #$78
        LDX #<p00
        LDY #>p00
        STX a14
        STY a15
        LDX #<p141A
        LDY #>p141A
        STX aFC
        STY aFD
        LDY #$00
        LDX #$7B
b1430   LDA f143B,X
        STA f0333,X
        DEX 
        BNE b1430
f143B   =*+$02
        JMP e0384

        .BYTE $0C,$08,$00 ;NOP $0008
        BRK #$9E
        .BYTE $33,$31 ;RLA ($31),Y
        .BYTE $33,$32 ;RLA ($32),Y
        BMI b1447
b1447   BRK #$00
        BRK #$00
        SEI 
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$00
b145B   DEY 
        CPY #$FF
        BNE b1462
        DEC aFD
b1462   LDA (pFC),Y
        STA aFF
        DEY 
        CPY #$FF
        BNE b146D
        DEC aFD
b146D   LDA (pFC),Y
        CMP #$1D
        BEQ b14A2
b1473   STA f7AB5,X
        DEX 
        CPX #$FF
        BNE b1481
        DEC a036D
        DEC a038C
b1481   DEC aFF
        BNE b1473
b1485   DEY 
        CPY #$FF
        BNE b148C
        DEC aFD
b148C   LDA (pFC),Y
        CMP #$1D
        BEQ b145B
        STA f7AB5,X
        DEX 
        CPX #$FF
        BNE b1485
        DEC a036D
        DEC a038C
        BNE b1485
b14A2   LDX #$1F
b14A4   LDA f0333,X
        STA f0800,X
        DEX 
        BNE b14A4
        LDA #$1D
        LDA #$37
        STA a01
        CLI 
        JMP eA8BC

        .BYTE $01
