;
; **** ZP ABSOLUTE ADRESSES **** 
;
a40 = $40
a41 = $41
a42 = $42
aC5 = $C5
;
; **** FIELDS **** 
;
f0400 = $0400
f042B = $042B
f0448 = $0448
f0470 = $0470
f04A3 = $04A3
f04C0 = $04C0
f0500 = $0500
f0510 = $0510
f051B = $051B
f0538 = $0538
f0588 = $0588
f05B0 = $05B0
f0600 = $0600
f060B = $060B
f0628 = $0628
f065B = $065B
f06C8 = $06C8
f06F0 = $06F0
f0700 = $0700
f074B = $074B
f079B = $079B
fCFFE = $CFFE
fCFFF = $CFFF
fD800 = $D800
fD900 = $D900
fDA00 = $DA00
fDB00 = $DB00
;
; **** ABSOLUTE ADRESSES **** 
;
a0314 = $0314
a0315 = $0315
a044F = $044F
a0516 = $0516
a0517 = $0517
a05B2 = $05B2
a05B3 = $05B3
a0606 = $0606
a0607 = $0607
a06CF = $06CF
a07F8 = $07F8
a07F9 = $07F9
a07FA = $07FA
a07FB = $07FB
a07FC = $07FC
a07FD = $07FD
a07FE = $07FE
a07FF = $07FF
;
; **** EXTERNAL JUMPS **** 
;
eEA31 = $EA31

*=$0800

        .BYTE $00,$0B,$08,$0A,$00,$9E,$32,$30
        .BYTE $36,$34,$00,$00,$00,$08,$02,$00

;----------------------------------------------------------------
; DNA_ClearScreenAndInit
;----------------------------------------------------------------
DNA_ClearScreenAndInit   
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
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

;-------------------------------------------------------
; DNA_ClearScreenMain   
;-------------------------------------------------------
DNA_ClearScreenMain   
        LDX #$00
b0854   LDA #$20
        STA f0400,X
        STA f0500,X
        STA f0600,X
        STA f0700,X
        LDA #$0E
        STA fD800,X
        STA fD900,X
        STA fDA00,X
        STA fDB00,X
        DEX 
        BNE b0854
        RTS 
;-------------------------------------------------------
; DNA_Initialize   
;-------------------------------------------------------
DNA_Initialize   
        JSR DNA_SetInterruptHandler
        JSR DNA_DrawTitleScreen
        JSR DNA_DrawStuff
j087D   JMP j087D

;-------------------------------------------------------
; DNA_SetInterruptHandler   
;-------------------------------------------------------
DNA_SetInterruptHandler   
        SEI 
        LDA #<DNA_InterruptHandler
        STA a0314    ;IRQ
        LDA #>DNA_InterruptHandler
        STA a0315    ;IRQ
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
;-------------------------------------------------------
; DNA_InterruptHandler   
;-------------------------------------------------------
DNA_InterruptHandler   
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE DNA_RunMainAnimationRoutine
j08AF   PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

;-------------------------------------------------------
; DNA_RunMainAnimationRoutine   
;-------------------------------------------------------
DNA_RunMainAnimationRoutine   
        JMP DNA_MainAnimationRoutine

dnaCurrentSpritesXPosArrayIndex   .BYTE $00
;-------------------------------------------------------
; DNA_MainAnimationRoutine   
;-------------------------------------------------------
DNA_MainAnimationRoutine   
        LDX dnaCurrentSpritesXPosArrayIndex
        LDY a09DD
        TYA 
        STA a40
        CLC 
        ASL 
        TAY 

        LDA f098C,X
        STA fCFFE,Y
        LDA f09B4,X
        STA fCFFF,Y
        STA $D005,Y  ;Sprite 2 Y Pos
        STA $D00F    ;Sprite 7 Y Pos
        STA $D00D    ;Sprite 6 Y Pos

        INC f0B8F,X
        LDA f0B8F,X
        STA $D00C    ;Sprite 6 X Pos

        LDA a41
        AND #$01
        BEQ b08EC

        INC f0BA7,X
b08EC   LDA f0BA7,X
        STA $D00E    ;Sprite 7 X Pos
        TXA 
        PHA 
        CLC 
        ADC a09DE
        CMP #$27
        BMI b08FF
        SEC 
        SBC #$27
b08FF   TAX 
        LDA f098C,X
        STA $D004,Y  ;Sprite 2 X Pos
        PLA 
        TAX 
        LDY a09DD
        STX a40
        LDX a09DC
a0911   =*+$01
a0912   =*+$02
        LDA f09CD,X
        STA $D026,Y  ;Sprite Multi-Color Register 1
        INX 
a0918   =*+$01
a0919   =*+$02
        LDA f09CD,X
        CMP #$FF
        BNE b0920
        LDX #$00
b0920   STX a09DC
        LDX a09DB
a0927   =*+$01
a0928   =*+$02
        LDA f09D4,X
        STA $D029,Y  ;Sprite 2 Color
        INX 
a092E   =*+$01
a092F   =*+$02
        LDA f09D4,X
        CMP #$FF
        BNE b0936
        LDX #$00
b0936   STX a09DB
        LDX a40
        INX 
        INY 
        CPY #$04
        BNE b0943
        LDY #$01
b0943   STY a09DD
        STX dnaCurrentSpritesXPosArrayIndex
        LDA f09B4,X
        CMP #$FF
        BNE b0978
        LDX #$00
        STX dnaCurrentSpritesXPosArrayIndex
        JSR s09EC
        JSR s0A7B
        DEC a41
        JSR s0BC3
        LDA #$01
        STA a09DD
        LDA #$2E
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JMP eEA31

        LDX dnaCurrentSpritesXPosArrayIndex
b0978   LDA f09B4,X
        SEC 
        SBC #$02
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
f098B   =*+$02
        JMP j08AF

f098C   .BYTE $C0,$BF,$BD,$B8,$B1,$A8,$9E,$92
        .BYTE $86,$79,$6D,$61,$57,$4E,$47,$42
        .BYTE $40,$40,$42,$47,$4E,$57,$61,$6D
        .BYTE $79,$86,$92,$9E,$A8,$B1,$B8,$BD
        .BYTE $BF,$BF,$BD,$B8,$B1,$A8,$9E,$92
f09B4   .BYTE $30,$38,$40,$48,$50,$58,$60,$68
        .BYTE $70,$78,$80,$88,$90,$98,$A0,$A8
        .BYTE $B0,$B8,$C0,$C8,$D0,$D8,$E0,$E8
        .BYTE $FF
f09CD   .BYTE $02,$08,$07,$05,$04,$06,$FF
f09D4   .BYTE $0B,$0C,$0F,$01,$0F,$0C,$FF
a09DB   .BYTE $00
a09DC   .BYTE $01
a09DD   .BYTE $01
a09DE   .BYTE $08
s09DF   LDX #$27
b09E1   LDA f098B,X
        STA f098C,X
        DEX 
        BNE b09E1
        RTS 

a09EB   .BYTE $11
s09EC   DEC a0A38
        BNE b09FA
        LDA a0A37
        STA a0A38
        JSR s09DF
b09FA   JSR s0C45
        DEC a0A35
        BNE b0A33
        LDA a0A36
        STA a0A35
        LDX a09EB
        LDA f1000,X
        STA a42
        LDY a0C43
        BEQ b0A19
        CLC 
        ROR 
        STA a42
b0A19   LDA a0C44
        CLC 
        ADC a42
        STA f098C
        TXA 
        CLC 
        ADC a0A34
        TAX 
        CPX #$40
        BMI b0A30
        SEC 
        SBC #$40
        TAX 
b0A30   STX a09EB
b0A33   RTS 

a0A34   .BYTE $01
a0A35   .BYTE $01
a0A36   .BYTE $01
a0A37   .BYTE $02
a0A38   .BYTE $02
a0A39   .BYTE $0F
a0A3A   .BYTE $40
f0A3B   .BYTE $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
        .BYTE $08,$07,$06,$05,$04,$03,$02,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
f0A5B   .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$02,$03,$04,$05,$06,$07,$08
        .BYTE $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
s0A7B   LDA a0A3A
        CMP #$40
        BEQ b0A88
        LDA aC5
        STA a0A3A
        RTS 

b0A88   LDA aC5
        STA a0A3A
        CMP #$0C
        BNE b0A97
        DEC a0A39
        JMP j0ABD

b0A97   CMP #$17
        BNE b0AA1
        INC a0A39
        JMP j0ABD

b0AA1   CMP #$0A
        BNE b0AB3
        INC a0A37
j0AA8   LDA a0A37
        AND #$0F
        STA a0A38
        JMP DNA_DrawStuff

b0AB3   CMP #$0D
        BNE b0AEA
        DEC a0A37
        JMP j0AA8

j0ABD   LDA a0A39
        AND #$1F
        TAX 
        LDA f0A3B,X
        STA a0A36
        STA a0A35
        LDA f0A5B,X
        STA a0A34
        LDA a0B8E
        AND #$1F
        TAX 
        LDA f0A3B,X
        STA a0C40
        STA a0C41
        LDA f0A5B,X
        STA a0C42
        JMP DNA_DrawStuff

b0AEA   CMP #$3E
        BNE b0AFC
        INC a09DE
        LDA a09DE
        AND #$0F
        STA a09DE
        JMP DNA_DrawStuff

b0AFC   CMP #$14
        BNE b0B06
        DEC a0B8E
        JMP j0ABD

b0B06   CMP #$1F
        BNE b0B10
        INC a0B8E
        JMP j0ABD

b0B10   CMP #$3C
        BNE b0B27
        LDA a0DB7
        EOR #$01
        STA a0DB7
        BEQ b0B24
        JSR DNA_DrawTitleScreen
        JMP DNA_DrawStuff

b0B24   JMP DNA_ClearScreenMain

b0B27   CMP #$04
        BNE b0B36
        LDA a0C43
        EOR #$01
        STA a0C43
        JMP DNA_DrawStuff

b0B36   CMP #$06
        BNE b0B62
        INC a0DFE
        LDA a0DFE
        CMP #$08
        BNE b0B49
        LDA #$00
        STA a0DFE
b0B49   TAX 
        LDA f0DEE,X
        STA a0918
        STA a0911
        LDA f0DF6,X
        STA a0919
        STA a0912
        LDA #$00
        STA a09DC
        RTS 

b0B62   CMP #$03
        BNE b0B8D
        INC a0DFF
        LDA a0DFF
        CMP #$08
        BNE b0B75
        LDA #$00
        STA a0DFF
b0B75   TAX 
        LDA f0DEE,X
        STA a092E
        STA a0927
        LDA f0DF6,X
        STA a092F
        STA a0928
        LDA #$00
        STA a09DB
b0B8D   RTS 

a0B8E   .BYTE $11
f0B8F   .BYTE $A4,$5B,$BC,$53,$68,$7E,$22,$DD
        .BYTE $8D,$E9,$4B,$92,$5F,$F3,$FE,$D3
        .BYTE $33,$BD,$76,$1A,$00,$8B,$58,$CA
f0BA7   .BYTE $3F,$8D,$DE,$E3,$71,$8A,$CE,$ED
        .BYTE $1C,$BD,$D4,$13,$2A,$95,$54,$DF
        .BYTE $50,$2C,$AC,$F7,$D4,$E0,$FF,$42
a0BBF   .BYTE $01
a0BC0   .BYTE $01
a0BC1   .BYTE $0C
a0BC2   .BYTE $05
s0BC3   DEC a0BC2
        BNE b0BF7
        LDA #$05
        STA a0BC2
        LDX a0C3F
        LDA f0DB8,X
        STA $D025    ;Sprite Multi-Color Register 0
        INX 
        LDA f0DB8,X
        BPL b0BDE
        LDX #$00
b0BDE   STX a0C3F
        LDA a41
        AND #$01
        CLC 
        ADC #$C0
        STA a07FF
        LDA a41
        AND #$01
        EOR #$01
        CLC 
        ADC #$C0
        STA a07FE
b0BF7   DEC a0BC0
        BNE b0C3D
        LDA #$02
        STA a0BC0
        LDA a0BBF
        CLC 
        ADC #$C2
        STA a07F8
        STA a07F9
        STA a07FA
        LDA a0BC1
        CLC 
        ADC #$C2
        STA a07FB
        STA a07FC
        STA a07FD
        INC a0BBF
        LDA a0BBF
        CMP #$0E
        BNE b0C2E
        LDA #$00
        STA a0BBF
b0C2E   DEC a0BC1
        LDA a0BC1
        CMP #$FF
        BNE b0C3D
        LDA #$0D
        STA a0BC1
b0C3D   RTS 

a0C3E   .BYTE $39
a0C3F   .BYTE $03
a0C40   .BYTE $01
a0C41   .BYTE $01
a0C42   .BYTE $02
a0C43   .BYTE $00
a0C44   .BYTE $40
s0C45   LDA a0C43
        BNE b0C50
        LDA #$40
        STA a0C44
b0C4F   RTS 

b0C50   DEC a0C41
        BNE b0C4F
        LDA a0C40
        STA a0C41
        LDX a0C3E
        LDA f1000,X
        CLC 
        ROR 
        CLC 
        ADC #$40
        STA a0C44
        TXA 
        CLC 
        ADC a0C42
        CMP #$40
        BMI b0C75
        SEC 
        SBC #$40
b0C75   STA a0C3E
        RTS 

DNA_DrawTitleScreen   LDX #$07
b0C7B   LDA f0CD9,X
        AND #$3F
        STA f0448,X
        LDA f0CE1,X
        AND #$3F
        STA f0470,X
        LDA f0CE9,X
        AND #$3F
        STA f04C0,X
        LDA f0CF1,X
        AND #$3F
        STA f0510,X
        LDA f0CF9,X
        AND #$3F
        STA f0538,X
        LDA f0D01,X
        AND #$3F
        STA f0588,X
        LDA f0D09,X
        AND #$3F
        STA f05B0,X
        LDA f0D11,X
        AND #$3F
        STA f0600,X
        LDA f0D19,X
        AND #$3F
        STA f0628,X
        LDA f0D21,X
        AND #$3F
        STA f06C8,X
        LDA f0D29,X
        AND #$3F
        STA f06F0,X
        DEX 
        BNE b0C7B
        JMP j0EAF

f0CD9   .TEXT " SPEED:F"
f0CE1   .TEXT "  <A S> "
f0CE9   .TEXT " WAVE 1 "
f0CF1   .TEXT " FREQ: F"
f0CF9   .TEXT "  <Z X> "
f0D01   .TEXT " WAVE 2 "
f0D09   .TEXT " ON   F1"
f0D11   .TEXT " FREQ: F"
f0D19   .TEXT "  <C V> "
f0D21   .TEXT " PHASE:F"
f0D29   .TEXT "   Q>>  "
f0D31   .TEXT "0123456789ABCDEF"

;-------------------------------------------------------
; DNA_DrawStuff   
;-------------------------------------------------------
DNA_DrawStuff   
        LDA a0DB7
        BNE b0D4C
        INC a0DB7
        JSR DNA_DrawTitleScreen
b0D4C   LDA #$20
        STA a0516
        STA a0606
        LDA a0A39
        AND #$10
        BEQ b0D60
        LDA #$31
        STA a0516
b0D60   LDA a0A39
        AND #$0F
        TAX 
        LDA f0D31,X
        AND #$3F
        STA a0517
        LDA a0B8E
        AND #$10
        BEQ b0D7A
        LDA #$31
        STA a0606
b0D7A   LDA a0B8E
        AND #$0F
        TAX 
        LDA f0D31,X
        AND #$3F
        STA a0607
        LDX a0A37
        LDA f0D31,X
        AND #$3F
        STA a044F
        LDX a09DE
        LDA f0D31,X
        AND #$3F
        STA a06CF
        LDA a0C43
        BNE b0DAC
        LDA #$06
        STA a05B2
        STA a05B3
        RTS 

p200E = $2000
b0DAC   LDA #<p200E
        STA a05B2
        LDA #>p200E
        STA a05B3
        RTS 

a0DB7   .BYTE $01
f0DB8   .BYTE $06,$02,$04,$05,$03,$07,$01,$07
        .BYTE $03,$05,$04,$02,$06,$FF,$06,$05
        .BYTE $0E,$0D,$03,$FF,$09,$08,$07,$08
        .BYTE $09,$FF,$00,$00,$00,$02,$00,$00
        .BYTE $07,$FF,$01,$0F,$0D,$0C,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
        .BYTE $06,$0E,$0B,$02,$05,$FF
f0DEE   .BYTE $CD,$D4,$B8,$C6,$CC,$D2,$DA,$E8
f0DF6   .BYTE $09,$09,$0D,$0D,$0D,$0D,$0D,$0D
a0DFE   .BYTE $00
a0DFF   .BYTE $01
        .TEXT "    % % %  DNA  % % %   "
f0E18   .TEXT " CONCEIVED AND EXECUTED B"
f0E31   .TEXT "Y          Y A K         "
f0E4A   .TEXT " SPACE: CANCEL SCREEN TEX"
f0E63   .TEXT "TF5 AND F7 CHANGE COLOURS"
f0E7C   .TEXT " LISTEN TO TALKING HEADS."
f0E95   .TEXT ".BE NICE TO HAIRY ANIMALS "
j0EAF   LDX #$19
b0EB1   LDA a0DFF,X
        AND #$3F
        STA f042B,X
        LDA f0E18,X
        AND #$3F
        STA f04A3,X
        LDA f0E31,X
        AND #$3F
        STA f051B,X
        LDA f0E4A,X
        AND #$3F
        STA f060B,X
        LDA f0E63,X
        AND #$3F
        STA f065B,X
        LDA f0E7C,X
        AND #$3F
        STA f074B,X
        LDA f0E95,X
        AND #$3F
        STA f079B,X
        DEX 
        BNE b0EB1
        RTS 

*=$1000
f1000   .BYTE $40,$46,$4C,$52,$58,$5E,$63,$68
        .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
        .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
        .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
        .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
        .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
        .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
        .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
        .BYTE $FF,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
*=$2000
.include "charset.asm"
*=$3000
.include "sprites.asm"
