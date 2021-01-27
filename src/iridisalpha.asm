;
; **** ZP ABSOLUTE ADRESSES **** 
;
a01 = $01
screenPtrLo = $02
screenPtrHi = $03
a06 = $06
a10 = $10
a11 = $11
a12 = $12
a13 = $13
a14 = $14
a15 = $15
a16 = $16
a17 = $17
a18 = $18
a1C = $1C
a1F = $1F
a20 = $20
a21 = $21
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
a29 = $29
a2A = $2A
a30 = $30
a31 = $31
screenPtrLo2 = $35
screenPtrHi2 = $36
a37 = $37
a3A = $3A
a3B = $3B
a3E = $3E
a40 = $40
a41 = $41
a42 = $42
a43 = $43
a44 = $44
a45 = $45
a46 = $46
a47 = $47
a4A = $4A
a4E = $4E
a4F = $4F
a68 = $68
a77 = $77
a78 = $78
a79 = $79
aA8 = $A8
lastKeyPressed = $C5
aE8 = $E8
aF0 = $F0
aF1 = $F1
aF8 = $F8
aF9 = $F9
aFA = $FA
aFB = $FB
aFC = $FC
aFD = $FD
aFE = $FE
aFF = $FF
;
; **** ZP POINTERS **** 
;
p10 = $10
p12 = $12
p14 = $14
p16 = $16
p22 = $22
p30 = $30
p3A = $3A
p40 = $40
p43 = $43
p45 = $45
p46 = $46
p4E = $4E
p78 = $78
pAD = $AD
pBF = $BF
pD0 = $D0
pF0 = $F0
pFC = $FC
pFD = $FD
pFE = $FE
;
; **** FIELDS **** 
;
f0000 = $0000
SCREEN_PTR_LO = $0340
SCREEN_PTR_HI = $0360
;
; **** POINTERS **** 
;
p0A = $000A
p20 = $0020
p27 = $0027
p0029 = $0029
SCREEN_RAM = $0400
COLOR_RAM = $D800
Sprite0Ptr = $07F8
Sprite1Ptr = $07F9
Sprite2Ptr = $07FA
Sprite3Ptr = $07FB
Sprite4Ptr = $07FC
Sprite5Ptr = $07FD
Sprite6Ptr = $07FE
Sprite7Ptr = $07FF

;
; **** EXTERNAL JUMPS **** 
;
e00FD = $00FD


* = $0801
;------------------------------------------------------------------
; SYS 16384 ($4000)
; This launches the program from address $4000, i.e. MainControlLoop.
;------------------------------------------------------------------
; $9E = SYS
; $31,$36,$33,$38,$34,$00 = 16384 ($4000 in hex)
.BYTE $0C,$08,$0A,$00,$9E,$31,$36,$33,$38,$34,$00

;-------------------------------
; LaunchCurrentProgram
;-------------------------------
*=$0810
LaunchCurrentProgram   
        LDA #$00
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA f7PressedOrTimedOutToAttractMode
        STA aAAE1
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
f0853   .BYTE $00
f0854   .BYTE $02,$08,$07,$05,$0E,$04,$06,$0B
        .BYTE $0B,$06,$04,$0E,$05,$07,$08,$02
f7PressedOrTimedOutToAttractMode   .BYTE $02

;-------------------------------
; InitializeSpritesAndInterruptsForTitleScreen
;-------------------------------
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
        STA Sprite7Ptr
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

;-------------------------------
; EnterTitleScreenLoop
;-------------------------------
EnterTitleScreenLoop   
        LDA #$0B
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$FE
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JSR IA_UpdateScreenColors
        JSR IA_DrawTitleScreen

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

;-------------------------------
; TitleScreenInterruptHandler
;-------------------------------
TitleScreenInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE TitleScreenAnimation

;-------------------------------
; ReturnFromTitleScreenInterruptHandler
;-------------------------------
ReturnFromTitleScreenInterruptHandler   
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

;-------------------------------
; IA_ClearScreen
;-------------------------------
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

;-------------------------------
; TitleScreenAnimation
;-------------------------------
TitleScreenAnimation
        LDY a09EC
        CPY #$0C
        BNE b091E
        JSR s0B5A
        LDY #$10
        STY a09EC
b091E   LDA f0990,Y
        BNE b0947
        JSR s0A4A
        LDA #$00
        STA a09EC
        LDA #$10
        STA $D012    ;Raster Position
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR UpdateGilbysInTitleAnimation
        JSR UpdateGilbyColorsInTitleScreenAnimation
        JSR s0BC1
        JSR PlayTitleScreenMusic
        JMP $EA31

b0947   STA $D00F    ;Sprite 7 Y Pos
        LDA f09AF,Y
        STA $D00E    ;Sprite 7 X Pos
        LDA f09CD,Y
        AND #$01
        STA a06
        BEQ b095D
        LDA #$80
        STA a06
b095D   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$7F
        ORA a06
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f0991,Y
        SEC 
        SBC #$01
        STA $D012    ;Raster Position
        LDA f09ED,Y
        TAX 
        LDA f0853,X

        STA $D02E    ;Sprite 7 Color
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        INC a09EC

        JMP ReturnFromTitleScreenInterruptHandler

; Data for the title screen animation sequence
f0990   .BYTE $48
f0991   .BYTE $4E,$54,$5A
        .BYTE $60,$66,$6C,$72,$78,$7E,$84,$8A
        .BYTE $90,$96,$9C,$A2,$A8,$AE,$B4,$BA
        .BYTE $C0,$C6,$CC,$D2,$D8,$DE,$E4,$EA
        .BYTE $F0,$F6
f09AE   .BYTE $00
f09AF   .BYTE $3A,$1A,$C4,$1B,$94,$7B,$96,$5D
        .BYTE $4F,$B5,$18,$C7,$E1,$EB,$4A,$8F
        .BYTE $DA,$83,$6A,$B0,$FC,$68,$04,$10
        .BYTE $06,$A7,$B8,$19,$BB
f09CC   .BYTE $E4
f09CD   .BYTE $02,$02,$00,$03,$05,$02,$02,$01
        .BYTE $01,$01,$03,$01,$00,$01,$03,$01
        .BYTE $01,$04,$02,$01,$00,$01,$02,$01
        .BYTE $02,$01,$00,$01,$02,$02,$01
a09EC   .BYTE $00
f09ED   .BYTE $03,$06,$07,$02,$01,$05,$03,$08
        .BYTE $04,$03,$02,$08,$06,$04,$02,$04
        .BYTE $06,$01,$07,$07,$05,$03,$02,$05
        .BYTE $07,$03,$06,$08,$05,$03,$06,$08
        .BYTE $07,$06,$03,$05,$06,$08,$06,$04
f0A15   .BYTE $06,$01,$03,$02,$01,$01,$01,$01
        .BYTE $07,$02,$03,$02,$07,$02,$03,$02
        .BYTE $03,$02,$01,$03,$04,$01,$02,$01
        .BYTE $02,$03,$02,$01,$06,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01
f0A3F   .BYTE $07
f0A40   .BYTE $05,$0E,$00,$02
a0A44   .BYTE $08
a0A45   .BYTE $04,$01,$0F,$0C,$0B
;-------------------------------
; s0A4A
;-------------------------------
s0A4A   
        LDX #$1E
        LDA #$00
        STA a21
b0A50   DEC f0A15,X
        BNE b0A6D
        LDA a09EC,X
        STA f0A15,X
        LDA f09AE,X
        CLC 
        ADC a0A45
        STA f09AE,X
        LDA f09CC,X
        ADC #$00
        STA f09CC,X
b0A6D   DEX 
        BNE b0A50
        RTS 

;-------------------------------
; IA_UpdateScreenColors
;-------------------------------
IA_UpdateScreenColors   
        LDX #$28
        LDA #$00
        STA a0B2C
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
        LDA #$00
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
b0AB7   LDA f0853,X
        STA f0A3F,X
        DEX 
        BNE b0AB7
        LDA #$01
        STA a0B2C
        RTS 

;-------------------------------
; UpdateGilbysInTitleAnimation
;-------------------------------
UpdateGilbysInTitleAnimation   
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$80
        STA $D010    ;Sprites 0-7 MSB of X coordinate

        LDX #$06
b0AD0   LDA f0B25,X
        STA SCREEN_RAM + $03F7,X
        TXA 
        ASL 
        TAY 
        LDA f0B19,X
        STA $CFFE,Y
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA f0B1F,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
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
f0B19   RTS 

        .BYTE $20,$50,$80,$B0,$E0
f0B1F   .BYTE $10,$00,$00,$00,$00,$00
f0B25   .BYTE $20,$F1,$F2,$F1,$F3,$F1,$F4
a0B2C   .BYTE $01
;-------------------------------
; UpdateGilbyColorsInTitleScreenAnimation
;-------------------------------
UpdateGilbyColorsInTitleScreenAnimation   
        LDA a0B2C
        BNE b0B34
b0B32   RTS 

a0B33   .BYTE $04
b0B34   DEC a0B33
        BNE b0B32
        LDA #$04
        STA a0B33
        LDX #$00
        LDA f0A3F
        PHA 
b0B44   LDA f0A40,X
        STA $D027,X  ;Sprite 0 Color
        STA f0A3F,X
        INX 
        CPX #$06
        BNE b0B44
        PLA 
        STA a0A44
        STA $D02C    ;Sprite 5 Color
        RTS 

;-------------------------------
; s0B5A
;-------------------------------
s0B5A   
        LDA #$02
        STA $D025    ;Sprite Multi-Color Register 0
        LDA #$01
        STA $D026    ;Sprite Multi-Color Register 1
        LDA #$00
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        LDA #$7F
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDX #$00
b0B73   TXA 
        ASL 
        TAY 
        LDA f0BB3,X
        ASL 
        STA $D000,Y  ;Sprite 0 X Pos
        BCC b0B8B
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        ORA f0C0F,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        JMP j0B94

b0B8B   LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND f0C16,X
        STA $D010    ;Sprites 0-7 MSB of X coordinate
;-------------------------------
; j0B94
;-------------------------------
j0B94   
        LDA f0BAC,X
        STA $D001,Y  ;Sprite 0 Y Pos
        LDA a0C1D
        STA Sprite0Ptr,X
        LDA f0854,X
        STA $D027,X  ;Sprite 0 Color
        INX 
        CPX #$07
        BNE b0B73
        RTS 

f0BAC   .BYTE $B2,$B6,$BB,$C1,$D0,$C8,$C1
f0BB3   .BYTE $54,$58,$5C,$60,$64,$68,$6C
f0BBA   .BYTE $FC,$FB,$FA,$F9,$08,$07,$06
;-------------------------------
; s0BC1
;-------------------------------
s0BC1   
        LDX #$00
b0BC3   LDA f0BAC,X
        SEC 
        SBC f0BBA,X
        STA f0BAC,X
        DEC f0BBA,X
        LDA f0BBA,X
        CMP #$F8
        BNE b0BE1
        LDA #$08
        STA f0BBA,X
        LDA #$D0
        STA f0BAC,X
b0BE1   INC f0BB3,X
        LDA f0BB3,X
        CMP #$C0
        BNE b0BF0
        LDA #$08
        STA f0BB3,X
b0BF0   INX 
        CPX #$07
        BNE b0BC3

        DEC a1650
        BNE b0C0E
        LDA #$04
        STA a1650
        INC a0C1D
        LDA a0C1D
        CMP #$C8
        BNE b0C0E
        LDA #$C1
        STA a0C1D
b0C0E   RTS 

f0C0F   .BYTE $01,$02,$04,$08,$10,$20,$40
f0C16   .TEXT $FE, $FD, $FB, $F7, $EF, $DF, $BF
a0C1D   .TEXT $C1, $C9, $D2, $C9, $C4, $C9, $D3, " ", $C1, $CC, $D0, $C8, $C1, ".....  HARD AND FAST ZAPPIN"
f0C45   .TEXT "GPRESS FIRE TO BEGIN PLAY.. ONCE STARTED"
f0C6D   .TEXT ",", $C6, "1 ", $C6, $CF, $D2, " ", $D0, $C1, $D5, $D3, $C5, " ", $CD, $CF, $C4, $C5, "     ", $D1, " ", $D4, $CF, " ", $D1, $D5, $C9, $D4, " ", $D4, $C8, $C5, " GAM"
f0C95   .TEXT "ECREATED BY JEFF MINTER...SPACE EASY/HAR"
f0CBD   .TEXT "DLAST GILBY HIT 0000000; MODE IS NOW EAS"
        .TEXT "Y"
;-------------------------------
; IA_DrawTitleScreen
;-------------------------------
IA_DrawTitleScreen   
        LDX #$28
b0CE8   LDA a0C1D,X
        AND #$3F
        STA SCREEN_RAM + $01DF,X
        LDA f0C45,X
        AND #$3F
        STA SCREEN_RAM + $022F,X
        LDA f0C6D,X
        AND #$3F
        STA SCREEN_RAM + $027F,X
        LDA f0C95,X
        AND #$3F
        STA SCREEN_RAM + $02CF,X
        LDA f0CBD,X
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

;-------------------------------
; The DNA pause mode mini game. Accessed by pressing *
; from within the Made in France pause mode mini game.
;-------------------------------
.include "dna.asm"

; Data seeding generated music in title screen
titleMusicHiBytes  .BYTE $08,$08,$09,$09,$0A,$0B,$0B,$0C
                   .BYTE $0D,$0E,$0E,$0F,$10,$11,$12,$13
                   .BYTE $15,$16,$17,$19,$1A,$1C,$1D,$1F
                   .BYTE $21,$23,$25,$27,$2A,$2C,$2F,$32
                   .BYTE $35,$38,$3B,$3F,$43,$47,$4B,$4F
                   .BYTE $54,$59,$5E,$64,$6A,$70,$77,$7E
                   .BYTE $86,$8E,$96,$9F,$A8,$B3,$BD,$C8
                   .BYTE $D4,$E1,$EE,$FD
titleMusicLowBytes .BYTE $61,$E1,$68,$F7,$8F,$30,$DA,$8F
                   .BYTE $4E,$18,$EF,$D2,$C3,$C3,$D1,$EF
                   .BYTE $1F,$60,$B5,$1E,$9C,$31,$DF,$A5
                   .BYTE $87,$86,$A2,$DF,$3E,$C1,$6B,$3C
                   .BYTE $39,$63,$BE,$4B,$0F,$0C,$45,$BF
                   .BYTE $7D,$83,$D6,$79,$73,$C7,$7C,$97
                   .BYTE $1E,$18,$8B,$7E,$FA,$06,$AC,$F3
                   .BYTE $E6,$8F,$F8,$2E
f14EF   .BYTE $00,$07,$0C,$07
a14F3   .BYTE $01
a14F4   .BYTE $01
a14F5   .BYTE $25
a14F6   .BYTE $85
a14F7   .BYTE $00
a14F8   .BYTE $01
a14F9   .BYTE $02
a14FA   .BYTE $02
a14FC   =*+$01
a14FD   =*+$02
a14FB   ASL a0E07
;-------------------------------
; PlayTitleScreenMusic
;-------------------------------
PlayTitleScreenMusic   
        DEC a164E
        BEQ b1504
        RTS 

b1504   LDA a164F
        STA a164E
        DEC a14F6
        BNE b152C
        LDA #$C0
        STA a14F6
        INC f7PressedOrTimedOutToAttractMode
        LDX a14FA
        LDA f14EF,X
        STA a14FC
        INX 
        TXA 
        AND #$03
        STA a14FA
        BNE b152C
        JSR UpdateMusicCounters
b152C   DEC a14F5
        BNE b154E
        LDA #$30
        STA a14F5
        LDX a14F9
        LDA f14EF,X
        CLC 
        ADC a14FC
        TAY 
        STY a14FB
        JSR PlayNoteVoice1
        INX 
        TXA 
        AND #$03
        STA a14F9
b154E   DEC a14F4
        BNE b1570
        LDA #$0C
        STA a14F4
        LDX a14F8
        LDA f14EF,X
        CLC 
        ADC a14FB
        STA a14FD
        TAY 
        JSR PlayNoteVoice2
        INX 
        TXA 
        AND #$03
        STA a14F8
b1570   DEC a14F3
        BNE b158F
        LDA #$03
        STA a14F3
        LDX a14F7
        LDA f14EF,X
        CLC 
        ADC a14FD
        TAY 
        JSR PlayNoteVoice3
        INX 
        TXA 
        AND #$03
        STA a14F7
b158F   RTS 

;-------------------------------
; PlayNoteVoice1
;-------------------------------
PlayNoteVoice1   
        LDA #$21
        STA $D404    ;Voice 1: Control Register
        LDA titleMusicLowBytes,Y
        STA $D400    ;Voice 1: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D401    ;Voice 1: Frequency Control - High-Byte
        RTS 

;-------------------------------
; PlayNoteVoice2
;-------------------------------
PlayNoteVoice2   
        LDA #$21
        STA $D40B    ;Voice 2: Control Register
        LDA titleMusicLowBytes,Y
        STA $D407    ;Voice 2: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D408    ;Voice 2: Frequency Control - High-Byte
        RTS 

;-------------------------------
; PlayNoteVoice3
;-------------------------------
PlayNoteVoice3   
        LDA #$21
        STA $D412    ;Voice 3: Control Register
        LDA titleMusicLowBytes,Y
        STA $D40E    ;Voice 3: Frequency Control - Low-Byte
        LDA titleMusicHiBytes,Y
        STA $D40F    ;Voice 3: Frequency Control - High-Byte
        RTS 

;-------------------------------
; IA_SetupSound
;-------------------------------
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

f15E0   .BYTE $00,$03,$06,$08,$00,$0C,$04,$08
        .BYTE $00,$07,$00,$05,$05,$00,$00,$05
        .BYTE $00,$06,$09,$05,$02,$04,$03,$04
        .BYTE $03,$07,$03,$00,$04,$08,$0C,$09
        .BYTE $07,$08,$04,$07,$00,$04,$07,$0E
        .BYTE $00,$00,$00,$07,$07,$04,$00,$0C
        .BYTE $04,$07,$00,$0C,$07,$08,$0A,$08
        .BYTE $0C,$00,$0C,$03,$0C,$03,$07,$00
;-------------------------------
; UpdateMusicCounters
;-------------------------------
UpdateMusicCounters   
        JSR s16A4
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
b1633   LDA f15E0,Y
        STA f14EF,X
        INY 
        INX 
        CPX #$04
        BNE b1633
        JSR s16A4
        AND #$03
        CLC 
        ADC #$01
        STA a164E
        STA a164F
        RTS 

a164E   .BYTE $01
a164F   .BYTE $01
a1650   .BYTE $04
;-------------------------------
; TitleScreenCheckInput
;-------------------------------
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
        JMP j1688

        ;Update difficulty hard.
b167B   LDX #$03
b167D   LDA txtHard,X
        AND #$3F
        STA SCREEN_RAM + $0344,X
        DEX 
        BPL b167D

j1688   
        ; Wait to release key.
        LDA lastKeyPressed
        CMP #$40
        BNE j1688
b168E   RTS 
       
        ;F7 pressed?
b168F   CMP #$03
        BNE b168E
        LDA #$04
        STA f7PressedOrTimedOutToAttractMode
        STA aAAE1
        RTS 

txtEasy   .TEXT "EASY"
txtHard   .TEXT "UGH!"
a16A5   =*+$01
;-------------------------------
; s16A4
;-------------------------------
s16A4   
        LDA a9A00
        INC a16A5
        RTS 


.include "paddingstart.asm"
*=$2000
.include "charset.asm"
.include "sprites.asm"

difficultySelected   =*+$01
;-------------------------------
; MainControlLoop
; Execution starts here
;-------------------------------
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
        STA inGameMode
        LDA #$02
        STA gilbiesLeft
        LDA #$7F
        STA $DC0D    ;CIA1: CIA Interrupt Control Register
        LDA #$00
        STA mifDNAPauseModeActive
        STA a6D51

        ; Display the title screen. We'll stay in here, until the
        ; player presses fire or we time out and go into attract mode.
        JSR EnterMainTitleScreen

        JSR DetectGameOrAttractMode
        LDA #$36
        STA a01
        LDA difficultySelected
        STA difficultySetting
        LDA #$01
        STA a4E19
        STA a4E1A
        LDA #$00
        STA bonusBountiesEarned
        STA a10
        STA bonusAwarded
        STA a14
        STA a18
        STA a1C
        STA a53B7
        STA a53B8
        STA a40D2
        STA a5509
        STA aAAD0
        STA a4F57
        LDA #$80
        STA a11
        LDA #$84
        STA a13
        LDA #$88
        STA a15
        LDA #<p0F8C
        STA a17
        LDA #>p0F8C
        STA $D418    ;Select Filter Mode and Volume
        JSR ZeroiseScreen
        JMP PrepareToLaunchIridisAlpha

;-------------------------------
; ZeroiseScreen
;-------------------------------
ZeroiseScreen   
        LDA #$00
        TAX 
b4084   STA f2200,X
        STA f2300,X
        STA f2600,X
        STA f2700,X
        DEX 
        BNE b4084
        RTS 

;-------------------------------
; PrepareToLaunchIridisAlpha
;-------------------------------
PrepareToLaunchIridisAlpha   
        LDX #$05
b4096   LDA #$08
        STA f5EF0,X
        DEX 
        BNE b4096
        LDX #$06
b40A0   LDA #$30
        STA currentBonusBountyPtr,X
        DEX 
        BPL b40A0
        JSR CopyInSpriteData
        JSR PrepareSpriteData
        LDA #$00
        STA a78B1
        LDA #$00
        STA a78B3
        LDA #$08
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDA #$09
        STA $D023    ;Background Color 2, Multi-Color Register 1
        JSR PrepareScreen
        JMP InitializeSprites


f40C8   .BYTE $00,$06,$02,$04,$05,$03,$07,$01
pauseModeSelected   .BYTE $00
reasonGilbyDied   .BYTE $03
a40D2   .BYTE $00
;-------------------------------
; 'Made In France' - a pause mode mini game.
; Accessed by pressing F1 during play.
;-------------------------------
.include "madeinfrance.asm"

p4788   .BYTE $A0,$50,$A7,$08,$A2,$D0,$9B,$A0
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
a4850   .BYTE $01
f4851   .BYTE $01,$02,$04,$08,$0A,$0C,$0E,$10
        .BYTE $10,$10,$10,$10,$10,$10,$10,$14
f4861   .BYTE $FF,$FE,$FC,$F9,$F7,$F5,$F3,$F1
        .BYTE $F0,$F0,$F0,$F0,$F0,$F0
f486F   .BYTE $F0,$EC,$78,$78,$78,$78,$00,$00
        .BYTE $78,$78
f4879   .BYTE $50,$50,$A0,$A0,$A0,$A0,$00,$00
        .BYTE $A0,$A0
f4883   .BYTE $A0,$A0,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f488D   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f4897   .BYTE $00,$00,$02,$02,$02,$02,$00,$00
        .BYTE $02,$02
f48A1   .BYTE $02,$02,$00,$00,$00,$00,$FF,$FF
        .BYTE $00,$00
f48AB   .BYTE $00
f48AC   .BYTE $00,$00,$00,$00,$00,$00
f48B2   .BYTE $00,$00,$00
f48B5   .BYTE $00
f48B6   .BYTE $00,$00,$00,$00,$00,$00
f48BC   .BYTE $00,$00,$00
f48BF   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f48C9   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
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
b499D   LDA f4879,X
        BEQ b49B5
        LDA a78C7
        BNE b49B2
        INX 
        CPX #$06
        BEQ b49B2
        CPX #$0C
        BEQ b49B2
        BNE b499D
b49B2   LDA #$00
        RTS 

b49B5   LDA #$FF
b49B7   RTS 

a49B8   .BYTE $A0
a49B9   .BYTE $A0
a49BA   .BYTE $58
a49BB   .BYTE $1E
f49BC   .BYTE $28,$00,$00,$00
f49C0   .BYTE $00
f49C1   .BYTE $18,$00,$00,$00
f49C5   .BYTE $00
f49C6   .BYTE $06,$02,$06,$0A
f49CA   .BYTE $08
f49CB   .BYTE $09,$0E,$0A,$0B,$01
a49D0   .BYTE $04
a49D1   .BYTE $04
a49D2   .BYTE $00
a49D3   .BYTE $00
;-------------------------------
; s49D4
;-------------------------------
s49D4   
        LDA a78C7
        BNE b49F5
        LDA a40D2
        BEQ b49E1
        JMP j5841

b49E1   JSR s4BBF
        JSR s4F5B
        JSR s502A
        JSR UpdateEnergyStorage
        JSR s552A
        DEC a49F6
        BEQ b49F7
b49F5   RTS 

a49F6   .BYTE $14
b49F7   LDA #$20
        STA a49F6
        LDX #$02
        JSR b499D
        BEQ b4A1F
        LDA a49D0
        CMP a49D2
        BEQ b4A1F
        LDA a49B8
        STA f486F,X
        LDA a49B9
        STA f4879,X
        TXA 
        TAY 
        JSR s4A42
        INC a49D2
b4A1F   LDX #$08
        JSR b499D
        BEQ b49B7
        LDA a49D1
        CMP a49D3
        BEQ b49B7
        LDA a49BA
        STA f486F,X
        LDA a49BB
        STA f4879,X
        TXA 
        CLC 
        ADC #$02
        TAY 
        INC a49D3
;-------------------------------
; s4A42
;-------------------------------
s4A42   
        LDA f486F,X
        STA a40
        LDA f4879,X
        STA a41
        LDA #$00
        STA a4E18
        STA f48C9,X
        STY a48D5
;-------------------------------
; s4A57
;-------------------------------
s4A57   
        LDY #$00
        LDA (p40),Y
        STA f67F0,X
        LDY #$06
        LDA (p40),Y
        STA f48A1,X
        LDY #$0B
        LDA (p40),Y
        STA f488D,X
        LDA #$00
        STA f4883,X
        LDY #$0F
        LDA (p40),Y
        STA f4897,X
        LDY #$01
        LDA (p40),Y
        STA f67D6,X
        TXA 
        TAY 
        LDX f4B7B,Y
        LDY #$01
        LDA (p40),Y
        STA f7E49,X
        LDY #$02
        LDA (p40),Y
        STA f7E51,X
        LDY #$03
        LDA (p40),Y
        STA f7E59,X
        STA f7E61,X
        TXA 
        AND #$04
        BEQ b4AB9
        INY 
        LDA (p40),Y
        STA f7E49,X
        INY 
        LDA (p40),Y
        STA f7E51,X
        TXA 
        TAY 
        LDA f4B87,X
        TAY 
        LDA f7E49,X
        STA f67D6,Y
b4AB9   LDY #$12
        LDA (p40),Y
        CMP #$80
        BEQ b4AC4
        STA f7E39,X
b4AC4   INY 
        LDA (p40),Y
        CMP #$80
        BEQ b4AFA
        AND #$F0
        CMP #$20
        BEQ b4AD6
        LDA (p40),Y
        JMP j4AF7

b4AD6   TXA 
        STX a5529
        AND #$04
        BNE b4AEC
        LDA (p40),Y
        AND #$0F
        TAX 
        LDA f4861,X
        LDX a5529
        JMP j4AF7

b4AEC   LDA (p40),Y
        AND #$0F
        TAX 
        LDA f4851,X
        LDX a5529
;-------------------------------
; j4AF7
;-------------------------------
j4AF7   
        STA f7E41,X
b4AFA   INY 
        LDA (p40),Y
        CMP #$80
        BEQ b4B07
        STA f7D1F,X
        STA f7D27,X
b4B07   INY 
        LDA (p40),Y
        CMP #$80
        BEQ b4B14
        STA f7D2F,X
        STA f7D37,X
b4B14   LDA #$01
        LDA a4E18
        BEQ b4B1C
        RTS 

b4B1C   LDY a48D5
        LDA f4B87,X
        TAX 
        LDA f6B45,X
        STA f67E2,Y
        JSR GetSomeSequenceData
        AND #$7F
        CLC 
        ADC #$20
        STA f67C8,Y
        TYA 
        AND #$08
        BNE b4B5A
        JSR GetSomeSequenceData
        AND #$3F
        CLC 
        ADC #$40
        STA f67FC,Y
        STY a45
        LDY #$06
        LDA (p40),Y
        BNE b4B59
        LDY #$08
        LDA (p40),Y
        BEQ b4B59
        LDA #$6C
        LDY a45
        STA f67FC,Y
b4B59   RTS 

b4B5A   JSR GetSomeSequenceData
        AND #$3F
        CLC 
        ADC #$98
        STA f67FC,Y
        STY a45
        LDY #$06
        LDA (p40),Y
        BNE b4B7A
        LDY #$08
        LDA (p40),Y
        BEQ b4B7A
        LDA #$90
        LDY a45
        STA f67FC,Y
b4B7A   RTS 

f4B7B   .BYTE $00,$00,$00,$01,$02,$03,$00,$00
        .BYTE $04,$05,$06,$07
f4B87   .BYTE $02,$03,$04,$05,$08,$09,$0A,$0B
f4B8F   .BYTE $00,$00,$02,$03,$04,$05,$00,$00
        .BYTE $0A,$0B,$0C,$0D
f4B9B   .BYTE $02,$03,$04,$05,$0A,$0B,$0C,$0D
f4BA3   .BYTE $00,$00,$00,$01,$02,$03,$00,$00
        .BYTE $00,$00,$04,$05,$06,$07
f4BB1   .BYTE $00,$00,$02,$03,$04,$05,$00,$00
        .BYTE $00,$00,$08,$09,$0A,$0B
;-------------------------------
; s4BBF
;-------------------------------
s4BBF   
        LDY #$00
        LDA pauseModeSelected
        BEQ b4BC7
        RTS 

b4BC7   LDX f4B87,Y
        LDA f4879,X
        BEQ b4BD6
        STY a42
        JSR s4BEC
        LDY a42
b4BD6   INY 
        CPY #$08
        BNE b4BC7
        LDA a4850
        BEQ b4BEB
        LDA #$00
        STA a49D2
        STA a49D3
        STA a4850
b4BEB   RTS 

;-------------------------------
; s4BEC
;-------------------------------
s4BEC   
        STA a41
        LDA f486F,X
        STA a40
        LDA a4850
        BEQ b4C03
        LDA #$18
        STA a41
        LDA #$C8
        STA a40
        JMP j4DF0

b4C03   LDA f48BF,X
        BNE b4C0B
        JMP j4CBB

b4C0B   LDA #$00
        STA f48BF,X
        LDA #<p48E9
        STA a79AE
        LDA #>p48E9
        STA a79AF
        JSR Reseta79A4
        LDA #$1C
        STA a48D7
        TXA 
        PHA 
        AND #$08
        BNE b4C5C
        LDA a78C7
        BNE b4C42
        LDA inAttractMode
        BNE b4C42
        INC currentTopWorldProgress
        LDA currentTopWorldProgress
        CMP a4E19
        BNE b4C42
        LDA #$00
        STA currentTopWorldProgress
b4C42   LDY #$22
        LDA (p40),Y
        JSR s5735
        CLC 
        ADC a5321
        STA a5321
        LDA a5322
        ADC a5752
        STA a5322
        JMP j4C8D

b4C5C   LDA a78C7
        BNE b4C76
        LDA inAttractMode
        BNE b4C76
        INC currentBottomWorldProgress
        LDA currentBottomWorldProgress
        CMP a4E1A
        BNE b4C76
        LDA #$00
        STA currentBottomWorldProgress
b4C76   LDY #$22
        LDA (p40),Y
        JSR s5735
        CLC 
        ADC a5323
        STA a5323
        LDA a5324
        ADC a5752
        STA a5324
;-------------------------------
; j4C8D
;-------------------------------
j4C8D   
        JSR DrawWorldProgressPointers
        PLA 
        TAX 
        LDY #$22
        LDA (p40),Y
        BEQ b4CB1
        LDA inAttractMode
        BNE b4CB1
        TXA 
        AND #$08
        BNE b4CAB
        JSR DecreaseEnergyTopOnly
        JSR RunSomeAttractModeGamePlay
        JMP b4CB1

b4CAB   JSR s56BD
        JSR DecreaseEnergyBottomOnly
b4CB1   LDY #$1D
        LDA (p40),Y
        BEQ j4CBB
        DEY 
        JMP j4DDD

;-------------------------------
; j4CBB
;-------------------------------
j4CBB   
        LDA f48C9,X
        BEQ b4CDC
        LDA #$00
        STA f48C9,X
        LDY #$1F
        LDA (p40),Y
        BEQ b4CDC
        LDY #$0E
        LDA (p40),Y
        BEQ b4CE2
        TXA 
        AND #$08
        BNE b4CDF
        DEC a49D2
        JMP b4CE2

b4CDC   JMP SetUpAttractMode

b4CDF   DEC a49D3
b4CE2   LDY #$24
        LDA (p40),Y
        BNE b4CEB
        JMP j4D36

b4CEB   LDA a7176
        AND #$10
        BEQ b4CDC
        LDA inGameMode
        BNE b4CDC
        LDA a4F57
        BNE b4D0D
        JSR s7C8B
        LDA #<p6362
        STA a79AC
        LDA #>p6362
        STA a79AD
        LDA #$08
        BNE b4D1C
b4D0D   JSR s7C8B
        LDA #<p6335
        STA a79AC
        LDA #>p6335
        STA a79AD
        LDA #$00
b4D1C   STA a4F57
        LDA #$00
        STA a7C8A
        LDA #$08
        STA upperPlanetEntropyStatus
        STA lowerPlanetEntropyStatus
        LDA #$05
        STA a6D85
        LDA #$04
        STA a6D86
;-------------------------------
; j4D36
;-------------------------------
j4D36   
        LDY #$23
        LDA (p40),Y
        BEQ b4D7F
        LDA #<p4961
        STA a79AC
        LDA #>p4961
        STA a79AD
        JSR s7C8B
        LDA #$0E
        STA a6D85
        LDA #$02
        STA a6D86
        LDA a6E12
        EOR #$FF
        CLC 
        ADC #$01
        STA a6E12
        LDA a4F57
        BEQ b4D72
        LDA a53B8
        BNE b4D7F
        LDA (p40),Y
        JSR s57DE
        STA a53B8
        BNE b4D7F
b4D72   LDA a53B7
        BNE b4D7F
        LDA (p40),Y
        JSR s57DE
        STA a53B7
b4D7F   LDY #$1E
        JMP j4DDD

;-------------------------------
; SetUpAttractMode
;-------------------------------
SetUpAttractMode   
        LDA f48AB,X
        BEQ b4D98
        LDA #$00
        STA f48AB,X
        LDY #$19
        LDA (p40),Y
        BEQ b4D98
        DEY 
        JMP j4DDD

b4D98   LDA f48B5,X
        BEQ b4DAC
        LDA #$00
        STA f48B5,X
        LDY #$1B
        LDA (p40),Y
        BEQ b4DAC
        DEY 
        JMP j4DDD

b4DAC   LDA a7176
        AND #$10
        BNE b4DBD
        LDY #$21
        LDA (p40),Y
        BEQ b4DBD
        DEY 
        JMP j4DDD

b4DBD   LDA f4897,X
        BEQ b4E1B
        DEC f4897,X
        BNE b4E1B
        LDY #$0E
        LDA (p40),Y
        BEQ b4DDB
        TXA 
        AND #$08
        BNE b4DD8
        DEC a49D2
        JMP b4DDB

b4DD8   DEC a49D3
b4DDB   LDY #$10
;-------------------------------
; j4DDD
;-------------------------------
j4DDD   
        LDA (p40),Y
        PHA 
        INY 
        LDA (p40),Y
        BEQ b4DFE
        STA f4879,X
        STA a41
        PLA 
        STA a40
        STA f486F,X
;-------------------------------
; j4DF0
;-------------------------------
j4DF0   
        LDA #$FF
        STA a4E18
        JSR s4A57
        LDA #$00
        STA a4E18
        RTS 

b4DFE   LDA #$F0
        STA f67D6,X
        PHA 
        LDA #$00
        STA f4879,X
        LDY f4B7B,X
        PLA 
        STA f7E49,Y
        LDA #$F1
        STA f7E51,Y
        PLA 
        RTS 

a4E17   .BYTE $00
a4E18   .BYTE $00
a4E19   .BYTE $01
a4E1A   .BYTE $01
b4E1B   LDY #$0A
        LDA (p40),Y
        BEQ b4E73
        DEC f488D,X
        BNE b4E73
        STA a44
        DEY 
        LDA (p40),Y
        STA a43
        LDY #$0B
        LDA (p40),Y
        STA f488D,X
        LDY f4883,X
        LDA f4B7B,X
        TAX 
        LDA (p43),Y
        CMP #$80
        BEQ b4E6A
        LDA (p43),Y
        STA f7E39,X
        INY 
        LDA (p43),Y
        STA f7E41,X
        INY 
        LDA (p43),Y
        STA f7D1F,X
        STA f7D27,X
        INY 
        LDA (p43),Y
        STA f7D2F,X
        STA f7D37,X
        INY 
        LDA f4B87,X
        TAX 
        TYA 
        STA f4883,X
        JMP b4E73

b4E6A   LDY #$0C
        LDA f4B87,X
        TAX 
        JMP j4DDD

b4E73   LDY #$17
        LDA (p40),Y
        BEQ b4EC7
        CLC 
        ADC a760C
        STA a4E17
        LDA f4B7B,X
        TAX 
        LDA f7D37,X
        CMP #$01
        BNE b4EC3
        LDA (p40),Y
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
b4EA6   LDA f4B9B,X
        TAX 
        LDA f67FC,X
        PHA 
        LDA f4BA3,X
        TAX 
        PLA 
        CMP a4E17
        BEQ b4EC3
        BMI b4EC0
        DEC f7E41,X
        DEC f7E41,X
b4EC0   INC f7E41,X
b4EC3   LDA f4B87,X
        TAX 
b4EC7   LDY #$16
        LDA (p40),Y
        BEQ b4F05
        CLC 
        ADC #$58
        STA a4E17
        LDA f4B7B,X
        TAX 
        LDA f7D27,X
        CMP #$01
        BNE b4F01
        LDA f4B9B,X
        TAX 
        CLC 
        LDA f67E2,X
        BEQ b4EE9
        SEC 
b4EE9   LDA f67C8,X
        ROR 
        PHA 
        LDA f4BA3,X
        TAX 
        PLA 
        CMP a4E17
        BMI b4EFE
        DEC f7E39,X
        DEC f7E39,X
b4EFE   INC f7E39,X
b4F01   LDA f4B87,X
        TAX 
b4F05   LDY #$06
        LDA (p40),Y
        BEQ b4F55
        DEC f48A1,X
        BNE b4F55
        LDA (p40),Y
        STA f48A1,X
        TXA 
        PHA 
        LDY f4B8F,X
        LDA f67C8,Y
        PHA 
        LDA f67E2,Y
        PHA 
        LDA f67FC,Y
        PHA 
        TXA 
        AND #$08
        BNE b4F4C
        LDX #$02
b4F2D   JSR b499D
        BEQ b4F50
        LDY f4B8F,X
        PLA 
        STA f67FC,Y
        PLA 
        BEQ b4F3F
        LDA f6B45,X
b4F3F   STA f67E2,Y
        PLA 
        STA f67C8,Y
        PLA 
        LDY #$07
        JMP j4DDD

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
;-------------------------------
; s4F5B
;-------------------------------
s4F5B   
        LDA a4F57
        TAY 
        AND #$08
        BEQ b4F65
        DEY 
        DEY 
b4F65   LDA f67E2,Y
        BMI b4F89
        LDY a4F57
        LDA f67E2,Y
        CLC 
        BEQ b4F74
        SEC 
b4F74   LDA f67C8,Y
        ROR 
        STA a4F58
        LDA f67FC,Y
        STA a4F59
        LDA #$00
        STA a48D6
        JSR s4FA4
b4F89   LDA f67E3,Y
        BMI b4F56
        CLC 
        BEQ b4F92
        SEC 
b4F92   LDA f67C9,Y
        ROR 
        STA a4F58
        LDA f67FD,Y
        STA a4F59
        LDA #$01
        STA a48D6
;-------------------------------
; s4FA4
;-------------------------------
s4FA4   
        TYA 
        TAX 
        INX 
        INX 
;-------------------------------
; j4FA8
;-------------------------------
j4FA8   
        STX a43
        LDA f4BB1,X
        TAX 
        LDA f4879,X
        BNE b4FB6
        JMP j501B

b4FB6   LDX a43
        CLC 
        LDA f67E2,X
        BEQ b4FBF
        SEC 
b4FBF   LDA f67C8,X
        ROR 
        SEC 
        SBC a4F58
        BPL b4FCB
        EOR #$FF
b4FCB   CMP #$08
        BMI b4FD2
        JMP j501B

b4FD2   LDA f67FC,X
        SEC 
        SBC a4F59
        BPL b4FDD
        EOR #$FF
b4FDD   CMP #$10
        BMI b4FE4
        JMP j501B

b4FE4   LDA f4BB1,X
        TAX 
        LDA f486F,X
        STA a40
        LDA f4879,X
        STA a41
        STY a42
        LDY #$1D
        LDA (p40),Y
        LDY a42
        CMP #$00
        BEQ j501B
        LDA #$FF
        STA f48BF,X
        TYA 
        PHA 
        CLC 
        ADC a48D6
        TAY 
        LDX a43
        TYA 
        AND #$08
        BEQ b5013
        DEY 
        DEY 
b5013   LDA #$FF
        STA f67E2,Y
        PLA 
        TAY 
        RTS 

;-------------------------------
; j501B
;-------------------------------
j501B   
        LDX a43
        INX 
        CPX #$06
        BEQ b5029
        CPX #$0E
        BEQ b5029
        JMP j4FA8

b5029   RTS 

;-------------------------------
; s502A
;-------------------------------
s502A   
        LDY #$00
        LDA a78C7
        BNE b5029
        LDA inAttractMode
        BNE b5029
        LDA a4F57
        BEQ b503C
        INY 
b503C   LDX a4F57
        INX 
        INX 
;-------------------------------
; j5041
;-------------------------------
j5041   
        CLC 
        LDA f67E2,X
        BEQ b5048
        SEC 
b5048   LDA f67C8,X
        ROR 
        SEC 
        SBC #$58
        BPL b5053
        EOR #$FF
b5053   CMP #$08
        BMI b505A
        JMP j5079

b505A   LDA f67FC,X
        SEC 
        SBC a760C,Y
        BPL b5065
        EOR #$FF
b5065   CMP #$08
        BMI b506C
        JMP j5079

b506C   STX a43
        LDA f4BB1,X
        TAX 
        LDA #$FF
        STA f48C9,X
        LDX a43
;-------------------------------
; j5079
;-------------------------------
j5079   
        INX 
        CPX #$06
        BEQ controlPanelData
        CPX #$0E
        BEQ controlPanelData
        JMP j5041

controlPanelData   RTS 

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
controlPanelColors   .BYTE $20,$09,$09,$00,$01,$01,$01,$01
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
f51C6   .BYTE $92,$90,$94,$96,$98
;-------------------------------
; UpdateWorldProgress
;-------------------------------
UpdateWorldProgress   
        LDX currentTopWorldProgress
        LDA f51C6,X
        STA a73AD
        LDA #$00
        STA a73AC
        LDX currentBottomWorldProgress
        LDA f51C6,X
        STA a73AF
        LDA #$00
        STA a73AE
        JSR InitializeSomeGameStorage
        LDA a5279
        BNE b51F7
        LDA #$08
        STA upperPlanetEntropyStatus
        STA lowerPlanetEntropyStatus
b51F7   LDA currentTopWorldProgress
        STA a78B1
        LDA currentBottomWorldProgress
        STA a78B3
        JSR s5715
        LDX #$08
b5208   LDA #$ED
        STA f7E48,X
        LDA #$F0
        STA f7E50,X
        LDA f5270,X
        STA f9FF7,X
        DEX 
        BNE b5208
        STX a5279
        JSR s7C8B
        JSR Reseta79A4
        LDA #<p5D33
        STA a79AE
        LDA #>p5D33
        STA a79AF
        LDA #<p5D7E
        STA a79AC
        LDA #>p5D7E
        STA a79AD
        ;Fall through

;-------------------------------
; DrawWorldProgressPointers
;-------------------------------
DrawWorldProgressPointers   
        LDX #$0A
        LDA #$20
b523C   STA SCREEN_RAM + $0365,X
        STA SCREEN_RAM + $03DD,X
        DEX 
        BNE b523C

        LDX currentTopWorldProgress
        LDY f527F,X
        LDA #$98 ; Top world progress pointer
        STA SCREEN_RAM + $0365,Y
        LDX currentBottomWorldProgress
        LDY f527F,X
        LDA #$99 ; Bottom world progress pointer
        STA SCREEN_RAM + $03DD,Y
        RTS 

        .BYTE $02,$02,$02,$03,$04,$05,$06,$07
        .BYTE $08,$30,$30,$30,$20,$18,$10,$0C
        .BYTE $0A,$06,$04,$02
f5270   .BYTE $01,$00,$00,$01,$01,$00,$04,$20
        .BYTE $00
a5279   .BYTE $00,$08,$08
a527C   .BYTE $00
a527D   .BYTE $00
controlPanelIsGrey   .BYTE $01
f527F   .BYTE $01,$03,$05,$07,$09
;-------------------------------
; s5284
;-------------------------------
s5284   
        LDA a760C
        CMP #$50
        BMI b52A7
        LDA #$01
        STA a52CD
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
        STA a52CD
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

;-------------------------------
; UpdateControlPanelColor
;-------------------------------
UpdateControlPanelColor   
        LDY #$00
        STY a52CD
        CMP #$01
        BEQ RestoreControlPanelColors
        BNE ResetControlPanelToGrey

a52CD   .BYTE $00
;-------------------------------
; InitializeSomeGameStorage
;-------------------------------
InitializeSomeGameStorage   
        LDA #$07
        STA a47
        LDA #$63
        STA a46
        LDX currentTopWorldProgress
        JSR InitSomeGameStorage
        LDA #$B3
        STA a46
        LDX currentBottomWorldProgress
;-------------------------------
; InitSomeGameStorage
;-------------------------------
InitSomeGameStorage   
        TXA 
        ASL 
        ASL 
        CLC 
        ADC #$9A
        LDY #$00
        STA (p46),Y
        LDY #$28
        CLC 
        ADC #$01
        STA (p46),Y
        LDY #$01
        CLC 
        ADC #$01
        STA (p46),Y
        LDY #$29
        CLC 
        ADC #$01
        STA (p46),Y
        LDA #$DB
        STA a47
        LDA f531C,X
        LDY #$00
        STA (p46),Y
        INY 
        STA (p46),Y
        LDY #$28
        STA (p46),Y
        INY 
        STA (p46),Y
        LDA #$07
        STA a47
        RTS 

f531C   .BYTE $07,$04,$0E,$08,$0A
a5321   .BYTE $00
a5322   .BYTE $00
a5323   .BYTE $00
a5324   .BYTE $00
;-------------------------------
; UpdateScores
;-------------------------------
UpdateScores   
        LDA a5322
        BNE b532F
        LDA a5321
        BEQ b5350
b532F   LDX #$06
b5331   INC SCREEN_RAM + $0354,X
        LDA SCREEN_RAM + $0354,X
        CMP #$3A
        BNE b5343
        LDA #$30
        STA SCREEN_RAM + $0354,X
        DEX 
        BNE b5331
b5343   DEC a5321
        LDA a5321
        CMP #$FF
        BNE b5350
        DEC a5322
b5350   LDA a5324
        BNE b535A
        LDA a5323
        BEQ b537B
b535A   LDX #$06
b535C   INC SCREEN_RAM + $03CC,X
        LDA SCREEN_RAM + $03CC,X
        CMP #$3A
        BNE b536E
        LDA #$30
        STA SCREEN_RAM + $03CC,X
        DEX 
        BNE b535C
b536E   DEC a5323
        LDA a5323
        CMP #$FF
        BNE b537B
        DEC a5324
b537B   RTS 

;-------------------------------
; DrawEnergyBars
;-------------------------------
DrawEnergyBars   
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

currEnergyTop   .BYTE $03
currEnergyBottom   .BYTE $03
currCoreEnergyLevel   .BYTE $00
a53B7   .BYTE $00
a53B8   .BYTE $00
;-------------------------------
; UpdateEnergyStorage
;-------------------------------
UpdateEnergyStorage   
        DEC a543D
        BNE b53B3
        LDA #$04
        STA a543D

        LDA a53B7
        BEQ b53FB

        ;Color the 'Energy' label.
        DEC a53B7
        LDX a53B7
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

b53F3   LDA #$00
        STA reasonGilbyDied ; Energy Depleted
        JMP GilbyDied

b53FB   LDA a53B8
        BEQ b542B
        DEC a53B8
        LDX a53B8
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
        BEQ b53F3
b542B   RTS 

energyLabelColors   .BYTE $01,$06,$02,$04,$05,$03,$07,$01
        .BYTE $00,$06,$02,$04,$05,$03,$07,$01
        .BYTE $06
a543D   .BYTE $01
;-------------------------------
; IncreaseEnergyTop
;-------------------------------
IncreaseEnergyTop   
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
b545B   JMP b53F3

;-------------------------------
; IncreaseEnergyBottom
;-------------------------------
IncreaseEnergyBottom   
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

;-------------------------------
; DecreaseEnergyTop
;-------------------------------
DecreaseEnergyTop   
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

;-------------------------------
; DecreaseEnergyBottom
;-------------------------------
DecreaseEnergyBottom   
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

;-------------------------------
; DecreaseCoreEnergyLevel
;-------------------------------
DecreaseCoreEnergyLevel   
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

b54FC   LDA inGameMode
        BEQ b5505
        DEX 
        JMP j54F3

b5505   INC a5509
b5508   RTS 

a5509   .BYTE $00
;-------------------------------
; IncreaseCoreEnergyLevel
;-------------------------------
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
;-------------------------------
; s552A
;-------------------------------
s552A   
        LDA a6E2C
        BNE b5530
b552F   RTS 

b5530   LDA a7177
        BNE b552F
        LDA currEnergyTop
        CMP #$04
        BPL b5547
        JSR IncreaseCoreEnergyLevel
        BEQ b554D
        JSR DecreaseEnergyTop
        JMP b554D

b5547   JSR DecreaseCoreEnergyLevel
        JSR IncreaseEnergyTop
b554D   LDA currEnergyBottom
        CMP #$04
        BPL b555C
        JSR IncreaseCoreEnergyLevel
        BEQ b552F
        JMP DecreaseEnergyBottom

b555C   JSR DecreaseCoreEnergyLevel
        JMP IncreaseEnergyBottom

;-------------------------------
; DecreaseEnergyTopOnly
;-------------------------------
DecreaseEnergyTopOnly   
        LDY #$23
        LDA (p40),Y
        BEQ b5572
        STA a4A
b556A   JSR DecreaseEnergyTop
        DEC a4A
        BNE b556A
        RTS 

b5572   JMP DecreaseEnergyTop
        ;Returns

;-------------------------------
; DecreaseEnergyBottomOnly
;-------------------------------
DecreaseEnergyBottomOnly   
        LDY #$23
        LDA (p40),Y
        BEQ b5585
        STA a4A
b557D   JSR DecreaseEnergyBottom
        DEC a4A
        BNE b557D
        RTS 

b5585   JMP DecreaseEnergyBottom
        ;Returns

currentLevelTopWorld   .BYTE $01
currentLevelBottomWorld   .BYTE $09
;-------------------------------
; UpdateLevelText
;-------------------------------
UpdateLevelText   
        LDA #$01
        STA a4850
        LDA currentLevelTopWorld
        BNE b55BD
        LDA #$30
        STA SCREEN_RAM + $0360
        STA SCREEN_RAM + $0361
        LDX currentLevelBottomWorld
        BEQ b55B6
b55A1   INC SCREEN_RAM + $0361
        LDA SCREEN_RAM + $0361
        CMP #$3A
        BNE b55B3
        LDA #$30
        STA SCREEN_RAM + $0361
        INC SCREEN_RAM + $0360
b55B3   DEX 
        BNE b55A1
b55B6   LDA a78B1
        PHA 
        JMP UpdateSomeGameInfo

b55BD   LDA #$30
        STA SCREEN_RAM + $03D8
        STA SCREEN_RAM + $03D9
        LDX currentLevelBottomWorld
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
b55DF   LDA a78B3
        PHA 
;-------------------------------
; UpdateSomeGameInfo
;-------------------------------
UpdateSomeGameInfo   
        LDA #<p4788
        STA a4E
        LDA #>p4788
        STA a4F
        PLA 
        TAX 
        BEQ b55FF
b55EF   LDA a4E
        CLC 
        ADC #$28
        STA a4E
        LDA a4F
        ADC #$00
        STA a4F
        DEX 
        BNE b55EF
b55FF   LDA currentLevelBottomWorld
        ASL 
        TAY 
        LDA (p4E),Y
        PHA 
        INY 
        LDA (p4E),Y
        PHA 
        LDA currentLevelTopWorld
        BNE b5644
        PLA 
        STA a49B8
        STA a4E
        PLA 
        STA a49B9
        STA a4F
        LDY #$26
        LDX a78B1
        LDA f49BC,X
        BEQ b5628
        BNE b562A
b5628   LDA (p4E),Y
b562A   STA f49BC,X
        LDA a5EFC
        BNE b5638
        LDA f49BC,X
        STA a5EFC
b5638   DEY 
        LDA (p4E),Y
        STA a49D0
        LDA #$00
        STA a527C
        RTS 

b5644   PLA 
        STA a49BA
        STA a4E
        PLA 
        STA a49BB
        STA a4F
        LDY #$26
        LDX a78B3
        LDA f49C1,X
        BEQ b565C
        BNE b565E
b565C   LDA (p4E),Y
b565E   STA f49C1,X
        LDA a5EFD
        BNE b566C
        LDA f49C1,X
        STA a5EFD
b566C   DEY 
        LDA (p4E),Y
        STA a49D1
        LDA #$00
        STA a527D
        RTS 

;-------------------------------
; RunSomeAttractModeGamePlay
;-------------------------------
RunSomeAttractModeGamePlay   
        STX a5529
        LDX a78B1
        DEC f49BC,X
        LDA a5EFC
        BNE b568C
        LDA f49BC,X
        STA a5EFC
b568C   LDA f49BC,X
        BNE b56B9
        INC f49C6,X
        LDA f49C6,X
        CMP #$14
        BNE b569E
        DEC f49C6,X
b569E   LDA #$04
        STA a6D85
        LDA #$03
        STA a6D86
        LDA f49C6,X
        STA currentLevelBottomWorld
        LDA #$00
        STA currentLevelTopWorld
        JSR RunAttractModeGamePlay
        JSR UpdateLevelText
b56B9   LDX a5529
        RTS 

;-------------------------------
; s56BD
;-------------------------------
s56BD   
        STX a5529
        LDX a78B3
        DEC f49C1,X
        LDA a5EFD
        BNE b56D1
        LDA f49C1,X
        STA a5EFD
b56D1   LDA f49C1,X
        BNE b56B9
        INC f49CB,X
        LDA f49CB,X
        CMP #$14
        BNE b56E3
        DEC f49CB,X
b56E3   LDA #$04
        STA a6D85
        LDA #$03
        STA a6D86
        LDA f49CB,X
        STA currentLevelBottomWorld
        LDA #$01
        STA currentLevelTopWorld
        JSR RunAttractModeGamePlay
        JSR UpdateLevelText
        JMP b56B9

;-------------------------------
; InitializeBonusPhaseVars
;-------------------------------
InitializeBonusPhaseVars   
        LDX #$05
        LDA #$00
b5705   STA a49BB,X
        STA f49C5,X
        STA f49CA,X
        STA f49C0,X
        DEX 
        BNE b5705
        RTS 

;-------------------------------
; s5715
;-------------------------------
s5715   
        LDX currentTopWorldProgress
        LDA f49C6,X
        STA currentLevelBottomWorld
        LDA #$00
        STA currentLevelTopWorld
        JSR UpdateLevelText
        INC currentLevelTopWorld
        LDX currentBottomWorldProgress
        LDA f49CB,X
        STA currentLevelBottomWorld
        JMP UpdateLevelText

;-------------------------------
; s5735
;-------------------------------
s5735   
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
        STA a5752
        PLA 
b5751   RTS 

a5752   .BYTE $00
;-------------------------------
; RunAttractModeGamePlay
;-------------------------------
RunAttractModeGamePlay   
        LDX #$09
        LDA inAttractMode
        BNE b5751
        LDA #$13
b575C   CMP f49C6,X
        BNE b5767
        DEX 
        BPL b575C
        INC bonusAwarded
b5767   LDA bonusBountiesEarned
        BNE b5751
        LDX a78B1
        LDY a4E19
        LDX #$00
b5774   LDA f49C5,Y
        CMP f57A6,X
        BMI b578E
        INX 
        DEY 
        BNE b5774
        LDX a4E19
        CPX a4E1A
        BEQ b5791
        INX 
        CPX a4E1A
        BEQ b5791
b578E   JMP j57AB

b5791   LDA a4E19
        CMP #$05
        BEQ b578E
        INC a4E19
        INC progressDisplaySelected
        LDA #$00
        STA inGameMode
        JMP j57AB

f57A6   .BYTE $03,$06,$09,$0C,$0F
;-------------------------------
; j57AB
;-------------------------------
j57AB   
        LDY a4E1A
        LDX #$00
b57B0   LDA f49CA,Y
        CMP f57A6,X
        BMI b57CA
        INX 
        DEY 
        BNE b57B0
        LDX a4E1A
        CPX a4E19
        BEQ b57CB
        INX 
        CPX a4E19
        BEQ b57CB
b57CA   RTS 

b57CB   LDA a4E1A
        CMP #$05
        BEQ b57CA
        INC a4E1A
        INC progressDisplaySelected
        LDA #$00
        STA inGameMode
        RTS 

;-------------------------------
; s57DE
;-------------------------------
s57DE   
        STY a57EC
        LDY bonusBountiesEarned
        CLC 
        ADC f57ED,Y
        LDY a57EC
        RTS 

a57EC   .BYTE $23
f57ED   .BYTE $00,$0A,$14,$1E,$28,$32,$3C,$46
        .BYTE $50
;-------------------------------
; GilbyDied
;-------------------------------
GilbyDied   
        LDA #$01
        STA a40D2
        LDA a59B9
        BNE b5833
        LDA inAttractMode
        BNE b5833

        LDX #$00
b5807   LDA #<pFC
        STA a583F
        LDA #>pFC
        STA a5840
        STA f583C,X
        INX 
        CPX #$03
        BNE b5807

        LDA #$01
        STA a6D85
        LDA #$03
        STA a6D86
        LDA #<p58EA
        STA a79AE
        LDA #>p58EA
        STA a79AF
        JSR Reseta79A4
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
;-------------------------------
; j5841
;-------------------------------
j5841   
        LDA a6D85
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
        STA f67D6,X
        STA f67DC,X
        LDY a5840
        LDA mapPlaneEntropyToColor,Y
        STA f67F0,X
        STA f67F6,X
        LDA a760C
        STA f67FC,X
        EOR #$FF
        CLC 
        ADC #$0C
        STA f6804,X
        LDA #$00
        STA f67E2,X
        STA f67EA,X
        CPX #$03
        BPL b58A9
        LDA #$B0
        CLC 
        ADC f583C,X
        STA f67C8,X
        STA f67D0,X
        BCC b58A6
        LDA f6B45,X
        STA f67E2,X
        STA f67EA,X
b58A6   JMP j58B5

b58A9   LDA #$B0
        SEC 
        SBC f5839,X
        STA f67C8,X
        STA f67D0,X
;-------------------------------
; j58B5
;-------------------------------
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
        STA a6D85
        LDY #$02
        STY a6D86
        CMP #$08
        BNE b58E8
        JMP j596C

b58E8   RTS 

a58E9   .BYTE $0A
p58EA   .BYTE $00,$00,$0F,$0C,$00,$00,$00,$0F
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
;-------------------------------
; j596C
;-------------------------------
j596C   
        LDX #$00
b596E   LDA #$C0
        STA f67D6,X
        STA f67DC,X
        INX 
        CPX #$06
        BNE b596E
        LDA #$01
        STA a59B9
        JSR SetUpGilbySprite
        LDA a78B1
        STA currentTopWorldProgress
        LDA a78B3
        STA currentBottomWorldProgress
        JSR UpdateWorldProgress
        LDA #$01
        STA a78C7
        STA a78C6
        LDA #<p5C0D
        STA a79AC
        LDA #>p5C0D
        STA a79AD
        LDA #<p5C35
        STA a79AE
        LDA #>p5C35
        STA a79AF
        LDA #$00
        STA $D015    ;Sprite display Enable
        JSR s7C8B
        JMP Reseta79A4

a59B9   .BYTE $00
gilbiesLeft   .BYTE $02
;-------------------------------
; j59BB
;-------------------------------
j59BB   
        LDY txtGilbiesLeft
        LDA f5CA7,Y
        STA $D021    ;Background Color 0
        INY 
        LDA f5CA7,Y
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
        JSR s79B0
        LDX #$1F
        LDA a5CC7
        PHA 
b59E9   LDA f5CA7,X
        STA f5CA8,X
        DEX 
        BPL b59E9
        PLA 
        STA f5CA7
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

;-------------------------------
; PlayerKilled
;-------------------------------
PlayerKilled   
        JSR ClearScreen3
        DEC gilbiesLeft
        BPL b5A1E
        BEQ b5A1E
        JMP DisplayGameOver

b5A1E   JSR GetSomeSequenceData
        AND #$07
        TAY 
        JSR DrawRestartLevelText
        LDX #$14
b5A29   LDA txtGilbiesLeft,X
        AND #$3F
        STA SCREEN_RAM + $00F8,X
        DEX 
        BNE b5A29
        JSR DrawReasonGilbyDied

        ; Show remanining gilbies
        LDA gilbiesLeft
        CLC 
        ADC #$31
        STA SCREEN_RAM + $0109
        JSR GetSomeSequenceData
        AND #$07
        CLC 
        ADC #$08
        TAY 
        ;Fall through

;-------------------------------
; DrawRestartLevelText
;-------------------------------
DrawRestartLevelText   
        LDA #<txtRestartLevelMsg
        STA a45
        LDA #>txtRestartLevelMsg
        STA a46
        STY a47
        CPY #$00
        BEQ b5A67
b5A57   LDA a45
        CLC 
        ADC #$14
        STA a45
        LDA a46
        ADC #$00
        STA a46
        DEY 
        BNE b5A57
b5A67   LDA a47
        AND #$08
        BNE b5A7A
b5A6D   LDA (p45),Y
        AND #$3F
        STA SCREEN_RAM + $00A9,Y
        INY 
        CPY #$14
        BNE b5A6D
        RTS 

b5A7A   LDA (p45),Y
        AND #$3F
        STA SCREEN_RAM + $0149,Y
        INY 
        CPY #$14
        BNE b5A7A
        LDA #$30
        STA a45
b5A8A   LDX #$40
b5A8C   DEY 
        BNE b5A8C
        DEX 
        BNE b5A8C
        DEC a45
        BNE b5A8A

;-------------------------------
; ClearScreen3
;-------------------------------
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

txtGilbiesLeft   .TEXT $00, "  GILBIES LEFT: 0.. "
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
f5CA7   .BYTE $08
f5CA8   .BYTE $07,$05,$0E,$04,$06,$0F,$0F,$0C
        .BYTE $0F,$0C,$0C,$0B,$0C,$0B,$0B,$80
        .BYTE $0B,$80,$80,$0B,$80,$0B,$0B,$0C
        .BYTE $0B,$0C,$0C,$0F,$0C,$0F,$0F
a5CC7   .BYTE $02,$00
;-------------------------------
; j5CC9
;-------------------------------
j5CC9   
        LDX #$00
b5CCB   LDA a760C
        STA f67FC,X
        EOR #$FF
        CLC 
        ADC #$08
        STA f6804,X
        LDA currentGilbySprite
        STA f67D6,X
        CLC 
        ADC #$13
        STA f67DC,X
        LDA f67A5,X
        STA f67F0,X
        STA f67F6,X
        LDA a6E12
        BMI b5D0B
        LDA f5D27,X
        STA f67C8,X
        LDA #$00
        STA f67E2,X
        LDA f5D2D,X
        STA f67D0,X
        LDA #$00
        STA f67EA,X
        BEQ b5D21
b5D0B   LDA f5D2D,X
        STA f67C8,X
        LDA #$00
        STA f67E2,X
        LDA f5D27,X
        STA f67D0,X
        LDA #$00
        STA f67EA,X
b5D21   INX 
        CPX #$06
        BNE b5CCB
        RTS 

f5D27   .BYTE $B8,$C0,$C8,$D0,$D8,$E0
f5D2D   .BYTE $A8,$A0,$98,$90,$88,$80
p5D33   BRK #$00
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
;-------------------------------
; UpdateDisplayedScoringRate
;-------------------------------
UpdateDisplayedScoringRate   
        LDA #$23
        STA SCREEN_RAM + $0387
        LDA #$01
        STA COLOR_RAM + $0387
        LDA a6E12
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
;-------------------------------
; UpdatePlanetEntropyStatus
;-------------------------------
UpdatePlanetEntropyStatus   
        LDA inGameMode
        BEQ b5E5D
        JMP j5EF6

b5E5D   LDA a4F57
        BEQ b5E69
        LDA #$08
        STA lowerPlanetEntropyStatus
        BNE b5E6E
b5E69   LDA #$08
        STA upperPlanetEntropyStatus
b5E6E   DEC a5E75
        BEQ b5E79
        BNE b5EB8

a5E75   .BYTE $A3
upperPlanetEntropyStatus   .BYTE $08
lowerPlanetEntropyStatus   .BYTE $08
a5E78   .BYTE $23

b5E79   DEC a5E78
        BNE b5EB8
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
        BNE b5EB8

EntropyKillsGilby   
        LDA #$02
        STA reasonGilbyDied ; Entropy
        JMP GilbyDied

        BNE b5EB8
b5EA6   DEC lowerPlanetEntropyStatus
        BNE b5EAE
        INC a7C8A
b5EAE   LDA lowerPlanetEntropyStatus
        CMP #$FF
        BNE b5EB8
        JMP EntropyKillsGilby

        ; This is the planet entropy status for the upper and
        ; lower plants, on the bottom left hand side of the screen.
b5EB8   LDA #$08
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
        JMP j5EF6

        .BYTE $C0,$C0,$C0,$C0,$C0,$00,$00,$00
        .BYTE $00
f5EF0   .BYTE $00,$08,$08,$08,$08,$08

j5EF6   
        RTS 

        .BYTE $00,$02,$04,$06,$08
a5EFC   .BYTE $00
a5EFD   .BYTE $00
a5EFE   .BYTE $30
a5EFF   .BYTE $30
;-------------------------------
; UpdateEnemiesLeft
;-------------------------------
UpdateEnemiesLeft   
        LDA #$30
        STA a5EFE
        STA a5EFF
        LDA a5EFC
        BEQ b5F21

b5F0D   JSR UpdateEnemiesLeftStorage
        DEC a5EFC
        BNE b5F0D
        LDA a5EFE
        STA SCREEN_RAM + $034F
        LDA a5EFF
        STA SCREEN_RAM + $0350
b5F21   LDA a6E12
        BNE b5F28

        LDA #$01
b5F28   PHA 
        TAY 
        LDA f67A5,Y
        STA COLOR_RAM + $034F
        STA COLOR_RAM + $0350
        LDA inGameMode
        BEQ b5F3A
        PLA 
        RTS 

b5F3A   LDA #$30
        STA a5EFE
        STA a5EFF
        LDA a5EFD
        BEQ b5F5B
b5F47   JSR UpdateEnemiesLeftStorage
        DEC a5EFD
        BNE b5F47
        LDA a5EFE
        STA SCREEN_RAM + $03C7
        LDA a5EFF
        STA SCREEN_RAM + $03C8
b5F5B   PLA 
        TAY 
        LDA f67A5,Y
        STA COLOR_RAM + $03C7
        STA COLOR_RAM + $03C8
        RTS 

;-------------------------------
; UpdateEnemiesLeftStorage
;-------------------------------
UpdateEnemiesLeftStorage   
        INC a5EFF
        LDA a5EFF
        CMP #$3A
        BNE b5F77
        LDA #$01
        STA a5EFF
b5F76   RTS 

b5F77   CMP #$07
        BNE b5F76
        LDA #$30
        STA a5EFF
        INC a5EFE
        LDA a5EFE
        CMP #$3A
        BNE b5F76
        LDA #$01
        STA a5EFE
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
        .BYTE $9F
p6001   .BYTE $A1,$A3,$A5,$A7,$A9,$AB,$AD,$8D
        .BYTE $8F,$20,$90,$92,$91,$93,$20,$20
        .BYTE $AE,$B0,$AF,$B1,$30,$30,$30,$30
        .BYTE $30,$30,$30,$20,$20,$B2,$B4,$30
        .BYTE $30,$20,$9B,$9D,$20,$99,$20,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20
;-------------------------------
; StoreStatusBarDetail
;-------------------------------
StoreStatusBarDetail   
        LDX #$A0
b6032   LDA SCREEN_RAM + $0347,X
        STA statusBarDetailStorage,X
        DEX 
        BNE b6032
        RTS 

;-------------------------------
; DrawStatusBarDetail
;-------------------------------
DrawStatusBarDetail   
        LDX #$A0
b603E   LDA statusBarDetailStorage,X
        STA SCREEN_RAM + $0347,X
        DEX 
        BNE b603E
b6047   RTS 

;-------------------------------
; DrawGameStatusBars
;-------------------------------
DrawGameStatusBars   
        LDA inGameMode
        BEQ b6047
        LDX #$28
b604F   LDA f60C6,X
        AND #$3F
        STA SCREEN_RAM + $02F7,X
        LDA #$01
        STA COLOR_RAM + $02F7,X
        DEX 
        BNE b604F
        LDX #$28
b6061   LDA f609E,X
        CLC 
        ADC #$40
        STA SCREEN_RAM + $0257,X
        DEX 
        BNE b6061
        LDX #$10
b606F   LDY f607E,X
        LDA f608E,X
        CLC 
        ADC #$40
        STA SCREEN_RAM + $01E4,Y
        DEX 
        BNE b606F
f607E   RTS 

        .BYTE $00,$01,$02,$03,$28,$29,$2A,$2B
        .BYTE $50,$51,$52,$53,$78,$79,$7A
f608E   .BYTE $7B,$30,$32,$38,$3A,$31,$33,$39
        .BYTE $3B,$34,$36,$3C,$3E,$35,$37,$3D
f609E   .BYTE $3F,$01,$03 ;RLA p0301,X
        .BYTE $01,$03,$01,$03,$01,$03,$01,$03
        .BYTE $01,$03,$01,$03,$01,$03,$01,$03
        .BYTE $01,$03,$01,$03,$01,$03,$01,$03
        .BYTE $01,$03,$01,$03,$1D,$1F,$00,$02
        .BYTE $00,$02,$00,$02,$00
f60C6   .BYTE $02    ;JAM 
        .TEXT "  WARP GATE       GILBY   CORE  NOT-CORE"
progressDisplaySelected   .BYTE $00
;-------------------------------
; DrawProgressDisplayScreen
;-------------------------------
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
b610F   LDA progressMapScreenPtrArrayHi,X
        STA aFF
        LDA progressMapScreenPtrArrayLo,X
        STA aFE
        LDA #$2D ; Progress chart tick
        STA (pFE),Y
        LDA aFF
        CLC 
        ADC #$D4
        STA aFF
        LDA #$0B
        STA (pFE),Y
        DEX 
        BNE b610F
        INY 
        CPY #$14
        BNE b610D

        LDX #$00
b6132   LDY f49C6,X
        JSR s6196
        LDY f49CB,X
        JSR s61B4
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

;-------------------------------
; s6196
;-------------------------------
s6196   
        LDA f61C4,X
        CLC 
        ADC #$D4
        STA aFF
        LDA f61CE,X
        STA aFE
;-------------------------------
; j61A3
;-------------------------------
j61A3   
        CPY #$00
        BEQ b6195
        LDA #$02
b61A9   STA (pFE),Y
        CPY #$00
        BEQ b6195
        DEY 
        LDA #$05
        BNE b61A9
;-------------------------------
; s61B4
;-------------------------------
s61B4   
        LDA f61C9,X
        CLC 
        ADC #$D4
        STA aFF
        LDA f61D3,X
        STA aFE
        JMP j61A3

; This is an array of pointers to the screen. For example the
; first one is $04F0. It is used to draw the progress map in the
; progress display screen.
progressMapScreenPtrArrayHi   =*-$01
f61C4                       .BYTE $04,$04,$04,$04,$04
f61C9                       .BYTE $05,$05,$05,$05
progressMapScreenPtrArrayLo .BYTE $05
f61CE                       .BYTE $F0,$CB,$A6,$81,$5C
f61D3                       .BYTE $18,$43,$6E,$99,$C4
f61D8                       .BYTE $04,$04 ;NOP $04
                            .BYTE $04,$04,$04,$05,$05,$05,$05,$05
f61E2                       .BYTE $A0,$7B,$56,$31,$0C,$40,$6B,$96
                            .BYTE $C1,$EC
;-------------------------------
; ShowProgressScreen
;-------------------------------
ShowProgressScreen   
        LDA #$00
        STA $D015    ;Sprite display Enable
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        STA lastKeyPressed
        JSR DrawProgressDisplayScreen

        LDX #$28
b61FE   LDA txtProgressStatusLine1,X
        AND #$3F
        STA SCREEN_RAM + $0257,X
        LDA #$01
        STA COLOR_RAM + $0257,X
        DEX 
        BNE b61FE

        CLI 
        LDA #$05
        STA aFF
        LDX #$00
        LDY #$00
b6217   DEY 
        BNE b6217
        DEX 
        BNE b6217
        DEC aFF
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

;-------------------------------
; DrawPlanetIconsOnProgressDisplay
;-------------------------------
DrawPlanetIconsOnProgressDisplay   
        LDX #$00
b6249   LDA f61E2,X
        STA aFE
        LDA f61D8,X
        STA aFF
        LDA f62BB,X
        STA aFD
        TXA 
        PHA 

        ; The array is seeded with the 4 characters for the first
        ; planet icon, simply incrementing from there gives the values
        ; for the characters for the subsequent icons.
        LDX #$00
b625C   LDY f62AF,X
        LDA progressDisplayPlanetIconSeedArray,X
        CLC 
        ADC aFD
        STA (pFE),Y
        INX 
        CPX #$04
        BNE b625C
        LDX #$0B
        PLA 
        STA aFD
        LDY aFD
        CPY #$05
        BMI b6287
        LDA aFD
        SEC 
        SBC #$05
        STA aFC
        LDY a4E1A
        DEY 
        CPY aFC
        JMP j628D

b6287   LDY a4E19
        DEY 
        CPY aFD

j628D   
        BMI b6291
        LDX #$01
b6291   TXA 
        PHA 
        LDX #$00
        LDA aFF
        CLC 
        ADC #$D4
        STA aFF
        PLA 
b629D   LDY f62AF,X
        STA (pFE),Y
        INX 
        CPX #$04
        BNE b629D
        LDX aFD
        INX 
        CPX #$0A
        BNE b6249
        RTS 

f62AF   .BYTE $00,$01,$28,$29
progressDisplayPlanetIconSeedArray   .BYTE $9A,$9C,$9B,$9D,$9A,$9C,$9B,$9D
f62BB   .BYTE $00,$04,$08,$0C,$10,$00,$04,$08
        .BYTE $0C,$10
;-------------------------------
; GameSwitchAndGameOverInterruptHandler   
;-------------------------------
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

b62D2   JSR s79B0
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        LDA #$20
        STA $D012    ;Raster Position
        JMP $EA31

txtProgressStatusLine1   =*-$01
                       .TEXT "IRIDIS ALPHA: PROGRESS STATUS DISPLAY %"
txtProgressStatusLine2 .TEXT "%PRESS THE FIRE BUTTON WHEN YOU ARE READY"

p6335   .BYTE $00
        BRK #$20
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
;-------------------------------
; SwapRoutines
;-------------------------------
SwapRoutines   
        SEI 
        LDA #$34
        STA a01
        LDA #<LaunchCurrentProgram
        STA aFC
        LDA #>LaunchCurrentProgram
        STA aFD
        LDA #>$E800
        STA aFF
        LDA #<$E800
        STA aFE

b63A4   LDY #$00
b63A6   LDA (pFC),Y
        PHA 
        LDA (pFE),Y
        STA (pFC),Y
        PLA 
        STA (pFE),Y
        DEY 
        BNE b63A6
        INC aFD
        INC aFF
        LDA aFF
        CMP #$F9
        BNE b63A4

        LDA #$36
        STA a01
        RTS 

;-------------------------------
; EnterMainTitleScreen ($63C5)
;-------------------------------
EnterMainTitleScreen   
        JSR SwapRoutines
        JSR LaunchCurrentProgram
        SEI 
        LDA #<GameSwitchAndGameOverInterruptHandler
        STA $0314    ;IRQ
        LDA #>GameSwitchAndGameOverInterruptHandler
        STA $0315    ;IRQ
        JMP SwapRoutines

;-------------------------------
; DisplayGameOver
;-------------------------------
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
        STA a4E19
        STA a4E1A
        LDX #$0A
b63FA   LDA f6425,X
        AND #$3F
        STA SCREEN_RAM + $00BD,X
        LDA f6430,X
        AND #$3F
        STA SCREEN_RAM + $010D,X
        LDA f643B,X
        AND #$3F
        STA SCREEN_RAM + $015D,X
        LDA #$01
        STA COLOR_RAM + $00BD,X
        STA COLOR_RAM + $010D,X
        LDA #$04
        STA COLOR_RAM + $015D,X
        DEX 
        BPL b63FA
        JMP j6446

f6425   .TEXT "GAME OVER.."
f6430   .TEXT "FINAL SCORE"
f643B   .TEXT "  0000000  "
;-------------------------------
; j6446
;-------------------------------
j6446   
        LDA #$5E
        STA aFE
        LDA #$05
        STA aFF
        LDA #<SCREEN_RAM + $0354
        STA aFC
        LDA #>SCREEN_RAM + $0354
        STA aFD
        JSR s6480
        LDA #$CC
        STA aFC
        JSR s6480
        LDA #$18
        STA aFC
        JSR s6480
        LDY #$C6
        LDX #$49
        LDA #<DrawProgressDisplayScreen
        STA aC819
        LDA #>DrawProgressDisplayScreen
        STA aC81A
        LDA #<f49C6
        STA aF0
        LDA #>f49C6
        STA aF1
        JMP jC800

;-------------------------------
; s6480
;-------------------------------
s6480   
        LDY #$07
b6482   LDA (pFC),Y
        SEC 
        SBC #$30
        BEQ b648D
        TAX 
        JSR s649E
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

;-------------------------------
; s649E
;-------------------------------
s649E   
        TYA 
        PHA 
b64A0   LDA (pFE),Y
        CLC 
        ADC #$01
        CMP #$3A
        BEQ b64AD
        STA (pFE),Y
        BNE b64B4
b64AD   LDA #$30
        STA (pFE),Y
        DEY 
        BNE b64A0
b64B4   PLA 
        TAY 
        LDA (pFC),Y
        SEC 
        SBC #$01
        STA (pFC),Y
        DEX 
        BNE s649E
        RTS 

txtReasonGilbyDied   .TEXT "DEPLETED..OVERLOAD..ENTROPY...HIT SOMMAT"
;-------------------------------
; DrawReasonGilbyDied
;-------------------------------
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

;-------------------------------
; JumpDisplayNewBonus
;-------------------------------
JumpDisplayNewBonus   
        JMP DisplayNewBonus

f650E   .BYTE $40,$46,$4C,$52,$58,$5E,$63,$68
        .BYTE $6D,$71,$75,$78,$7B,$7D,$7E,$7F
        .BYTE $80,$7F,$7E,$7D,$7B,$78,$75,$71
        .BYTE $6D,$68,$63,$5E,$58,$52,$4C,$46
        .BYTE $40,$39,$33,$2D,$27,$21,$1C,$17
        .BYTE $12,$0E,$0A,$07,$04,$02,$01,$00
        .BYTE $00,$00,$01,$02,$04,$07,$0A,$0E
        .BYTE $12,$17,$1C,$21,$27,$2D,$33,$39
        .BYTE $FF
bonusBountiesEarned   .BYTE $00
a6550   .BYTE $00
a6551   .BYTE $00
a6552   .BYTE $00
a6553   .BYTE $00
;-------------------------------
; DisplayNewBonus
;-------------------------------
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

;-------------------------------
; NewBonusGilbyAnimation
;-------------------------------
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

a65DD   .BYTE $04
a65DE   .BYTE $04
a65DF   .BYTE $02
a65E0   .BYTE $02
a65E1   .BYTE $00
a65E2   .BYTE $00
a65E3   .BYTE $00
a65E4   .BYTE $03
a65E5   .BYTE $03
a65E6   .BYTE $06
a65E7   .BYTE $06
a65E8   .BYTE $01
a65E9   .BYTE $01
a65EA   .BYTE $00
a65EB   .BYTE $00
NewBonusGilbyColors   .BYTE $02,$0A,$08,$07,$05,$0E,$04,$06

AnimateGilbiesForNewBonus
        LDY #$00
        LDA #$F0
        STA $D012    ;Raster Position
        DEC a65DD
        BNE b6610
        LDA a65DE
        STA a65DD
        LDA a673D
        CLC 
        ADC a65E2
        STA a65E2
b6610   DEC a65E0
        BNE b6625
        LDA a65DF
        STA a65E0
        LDA a65E3
        CLC 
        ADC a673E
        STA a65E3
b6625   DEC a65E4
        BNE b6633
        LDA a65E5
        STA a65E4
        INC a65EA
b6633   DEC a65E6
        BNE b6641
        LDA a65E7
        STA a65E6
        INC a65EB
b6641   LDA a65E2
        PHA 
        LDA a65E3
        PHA 
        LDA a65EA
        PHA 
        LDA a65EB
        PHA 
b6651   LDA a65E2
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6550
        LDA a65E3
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6551
        LDA a65EA
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6552
        LDA a65EB
        AND #$3F
        TAX 
        LDA f650E,X
        STA a6553
        JSR BonusBountyPerformAnimation
        LDA a65EB
        CLC 
        ADC #$08
        STA a65EB
        LDA a65EA
        CLC 
        ADC #$08
        STA a65EA
        LDA a65E3
        CLC 
        ADC #$08
        STA a65E3
        LDA a65E2
        CLC 
        ADC #$08
        STA a65E2
        INY 
        INY 
        CPY #$10
        BNE b6651
        PLA 
        STA a65EB
        PLA 
        STA a65EA
        PLA 
        STA a65E3
        PLA 
        STA a65E2
        DEC a65E1
        BNE b6709
        JSR GetSomeSequenceData
        AND #$07
        CLC 
        ADC #$04
        TAX 
        LDA f673F,X
        STA a65DE
        LDA f674F,X
        STA a673D
        JSR GetSomeSequenceData
        AND #$07
        CLC 
        ADC #$04
        TAX 
        LDA f673F,X
        STA a65DF
        LDA f674F,X
        STA a673E
        JSR GetSomeSequenceData
        AND #$07
        CLC 
        ADC #$01
        STA a65E4
        STA a65E5
        JSR GetSomeSequenceData
        AND #$07
        CLC 
        ADC #$01
        STA a65E6
        STA a65E7
b6709   LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        JSR s79B0
        JMP $EA31

;-------------------------------
; BonusBountyPerformAnimation
;-------------------------------
BonusBountyPerformAnimation   
        LDA a6550
        LDX a65E8
        BEQ b6725
        JSR BonusBountyAnimateGilby
        JMP j672B

b6725   CLC 
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos

j672B   
        LDA a6551
        LDX a65E9
        BEQ b6736
        JMP BonusBountyAnimateGilby2

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
;-------------------------------
; BonusBountyAnimateGilby
;-------------------------------
BonusBountyAnimateGilby   
        LDA a6550
        CLC 
        ROR 
        STA aFA
        LDA a6552
        CLC 
        ROR 
        CLC 
        ADC aFA
        ADC #$70
        STA $D000,Y  ;Sprite 0 X Pos
        RTS 

;-------------------------------
; BonusBountyAnimateGilby2
;-------------------------------
BonusBountyAnimateGilby2   
        LDA a6551
        CLC 
        ROR 
        STA aFA
        LDA a6553
        CLC 
        ROR 
        CLC 
        ADC aFA
        ADC #$40
        STA $D001,Y  ;Sprite 0 Y Pos
        RTS 

txtBonus10000   .TEXT "BONUS 10000"
a6794   .BYTE $BC
f6795   .BYTE $00,$06,$02,$04,$05,$03,$07,$01
        .BYTE $01,$07,$03,$05,$04,$02,$06,$00
f67A5   .BYTE $02,$08,$07,$05,$0E,$04,$06,$0B
        .BYTE $0B,$06,$04,$0E,$05,$07,$08,$02
backgroundColorsForWorlds   .BYTE $00,$01,$02,$03,$04,$05,$06,$07
        .BYTE $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
a67C5   .BYTE $04
a67C6   .BYTE $05
f67C7   .BYTE $00
f67C8   .BYTE $A8
f67C9   .BYTE $A0,$98,$90,$88,$80
f67CE   .BYTE $00
f67CF   .BYTE $00
f67D0   .BYTE $B8
f67D1   .BYTE $C0,$C8,$D0,$D8
f67D5   .BYTE $E0
f67D6   .BYTE $D3
f67D7   .BYTE $D3
f67D8   .BYTE $D3,$D3,$D3
f67DB   .BYTE $D3
f67DC   .BYTE $E6
f67DD   .BYTE $E6
f67DE   .BYTE $E6,$E6,$E6
f67E1   .BYTE $E6
f67E2   .BYTE $00
f67E3   .BYTE $00,$00,$00,$00,$00
f67E8   .BYTE $FF
f67E9   .BYTE $FF
f67EA   .BYTE $00
f67EB   .BYTE $00,$00,$00,$00
f67EF   .BYTE $00
f67F0   .BYTE $02,$08,$07,$05,$0E
f67F5   .BYTE $04
f67F6   .BYTE $02,$08,$07,$05,$0E
f67FB   .BYTE $04
f67FC   .BYTE $3D
f67FD   .BYTE $3D,$3D,$3D,$3D,$3D
f6802   .BYTE $00
f6803   .BYTE $00
f6804   .BYTE $CA
f6805   .BYTE $CA,$CA,$CA,$CA,$CA
currentPlanetBackgroundClr1   .BYTE $09
currentPlanetBackgroundClr2   .BYTE $0E
currentWorldBackgroundColor1   .BYTE $09
currentWorldBackgroundColor2   .BYTE $0E
;-------------------------------
; PrepareSpriteData
;-------------------------------
PrepareSpriteData   
        LDA #$00
        LDY #$40
b6812   STA f2FFF,Y
        DEY 
        BNE b6812

;-------------------------------
; FixUpSpriteData
;-------------------------------
FixUpSpriteData   
        LDX a6E12
        BPL b6822
        TXA 
        EOR #$FF
        TAX 
        INX 
b6822   LDA f6E13,X
        STA a3000
        STA a3003
        STA a3012
        STA a3015
        STA a3024
        STA a3027
        STA a3036
        STA a3039
        RTS 

;-------------------------------
; PrepareScreen
;-------------------------------
PrepareScreen   
        LDA #$00
        SEI 
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0
        JSR ClearGameViewPort
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        JSR DrawControlPanel
        JSR DrawEnergyBars
        LDA $D016    ;VIC Control Register 2
        AND #$F7
        ORA #$10
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D027    ;Sprite 0 Color
        JSR InitializeBonusPhaseVars
        ;Fall through

;-------------------------------
; SetupSpritesAndSound
;-------------------------------
SetupSpritesAndSound   
        LDA #$FF
        SEI 
        STA $D015    ;Sprite display Enable
        STA $D01C    ;Sprites Multi-Color Mode Select
        LDA #$C0
        STA Sprite7Ptr
        LDA #$00
        STA $D017    ;Sprites Expand 2x Vertical (Y)
        STA $D01D    ;Sprites Expand 2x Horizontal (X)
        STA a40D2
        STA a59B9
        LDA a78B1
        STA currentTopWorldProgress
        LDA a78B3
        STA currentBottomWorldProgress
        LDA #$80
        STA $D01B    ;Sprite to Background Display Priority
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA #$B0
        STA $D000    ;Sprite 0 X Pos
        JSR DrawWorlds
        JSR SetUpWorlds
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
        JSR DrawGameStatusBars
        LDX #$28
        LDA inGameMode
        BNE b68DF

b68D2   LDA #$00
        STA SCREEN_RAM + $01B7,X
        LDA #$04
        STA COLOR_RAM + $01B7,X
        DEX 
        BNE b68D2

b68DF   RTS 

;-------------------------------
; InitializeSprites
;-------------------------------
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

;-------------------------------
; SetUpGilbySprite
;-------------------------------
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
        STA a6E12
        LDA #$00
        STA a7140
        RTS 

bonusAwarded   .BYTE $00
;-------------------------------
; PrepareToRunGame
;-------------------------------
PrepareToRunGame   
        LDA inAttractMode
        BEQ b6932
        JSR GetSomeGameModeData
b6932   LDA #$00
        JSR UpdateWorldProgress
        LDA #$01
        STA a78C7
        STA a78C6
        LDA #$FF
        STA a7176
        ;Fall through

;-------------------------------
; BeginRunningGame
;-------------------------------
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
        LDA #<f49C6
        STA aF0
        LDA #>f49C6
        STA aF1
        JMP DrawHiScoreScreen

StartTheGame
        LDA bonusAwarded
        BEQ b6982
        JSR JumpDisplayNewBonus
        JSR StoreStatusBarDetail
        JSR InitializeBonusPhaseVars
        JMP ResumeGame

b6982   LDA a59B9
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
        INC a5279
        JMP SetUpGameScreen

GoToBonusPhase
        LDA a5509
        BEQ b6A02
        SEI 
        JSR StoreStatusBarDetail
        JSR ClearScreen3
        JSR DisplayEnterBonusRoundScreen

;-------------------------------
; ResumeGame
;-------------------------------
ResumeGame   
        JSR ZeroiseScreen
        JSR DrawStatusBarDetail
        JSR DrawEnergyBars
        JSR SetUpGilbySprite

        ; Clear charset data
        LDX #$00
        TXA 
b69C4   STA f2200,X
        STA f2300,X
        STA f2600,X
        STA f2700,X
        DEX 
        BNE b69C4

        JSR StoreStatusBarDetail
        LDA #$01
        STA a78C7
        STA a78C6
        LDA aAAD1
        BEQ b69F0
        INC gilbiesLeft
        LDA gilbiesLeft
        CMP #$04
        BNE b69F0
        DEC gilbiesLeft

b69F0   LDA #$00
        STA a5509
        LDA $D011    ;VIC Control Register 1
        AND #$F0
        ORA #$0B
        STA $D011    ;VIC Control Register 1
        JMP SetUpGameScreen

b6A02   JSR UpdateEnemiesLeft
        JSR UpdatePlanetEntropyStatus
        JSR UpdateDisplayedScoringRate
        LDA a59B9
        BEQ b6A1C

;-------------------------------
; EnterMainControlLoop
;-------------------------------
EnterMainControlLoop   
        JSR DrawEnergyBars
        JSR StoreStatusBarDetail
        JSR PlayerKilled
        JMP SetUpGameScreen

b6A1C   LDA a52CD
        BEQ b6A24
        JSR UpdateControlPanelColor
b6A24   LDA a78B4
        BEQ b6A31
        LDA #$00
        STA a78B4
        JMP MainControlLoop

b6A31   JSR UpdateScores
        LDA a40D2
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
        INC a5279

;-------------------------------
; SetUpGameScreen
;-------------------------------
SetUpGameScreen   
        LDA #$18
        STA $D018    ;VIC Memory Control Register
        LDA #$01
        STA a52CD
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
        LDA a78B1
        STA currentTopWorldProgress
        LDA a78B3
        STA currentBottomWorldProgress
        JSR UpdateWorldProgress
        JSR DrawStatusBarDetail
        LDX #$03
b6AB3   LDA f7E49,X
        STA f67D8,X
        LDA f7E4D,X
        STA f67DE,X
        DEX 
        BNE b6AB3
        JMP BeginRunningGame

previousGilbySprite   .BYTE $D3
;-------------------------------
; UpdateAttackShipsPosition
;-------------------------------
UpdateAttackShipsPosition   
        LDX #$0C
        LDY #$06
b6ACA   LDA f67C7,Y
        STA $D000,X  ;Sprite 0 X Pos
        LDA MainControlLoopInterruptHandler,Y
        AND $D010    ;Sprites 0-7 MSB of X coordinate
        STA a20
        LDA f67E1,Y
        AND f6B44,Y
        ORA a20
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f67FB,Y
        STA $D001,X  ;Sprite 0 Y Pos
        STX a42
        LDX f67EF,Y
        LDA backgroundColorsForWorlds,X
        STA $D027,Y  ;Sprite 0 Color
        LDA f67D5,Y
        STA Sprite0Ptr,Y
        LDX a42
        DEX 
        DEX 
        DEY 
        BNE b6ACA
        RTS 

;-------------------------------
; UpdateAttackShipsPosition2
;-------------------------------
UpdateAttackShipsPosition2   
        LDX #$0C
        LDY #$06
b6B06   LDA f67CF,Y
        STA $D000,X  ;Sprite 0 X Pos
        LDA MainControlLoopInterruptHandler,Y
        AND $D010    ;Sprites 0-7 MSB of X coordinate
        STA a20
        LDA f67E9,Y
        AND f6B44,Y
        ORA a20
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f6803,Y
        STA $D001,X  ;Sprite 0 Y Pos
        STX a42
        LDX f67F5,Y
        LDA backgroundColorsForWorlds,X
        STA $D027,Y  ;Sprite 0 Color
        LDA f67DB,Y
        STA Sprite0Ptr,Y
        LDX a42
        DEX 
        DEX 
        DEY 
        BNE b6B06
        RTS 

MainControlLoopInterruptHandler
        RTI 

        .BYTE $FD,$FB,$F7,$EF,$DF
f6B44   .BYTE $BF
f6B45   .BYTE $02
f6B46   .BYTE $04,$08,$10,$20,$40,$02,$04,$08
        .BYTE $10,$20,$40
difficultySetting   .BYTE $00

;-------------------------------
; MainGameInterruptHandler
;-------------------------------
MainGameInterruptHandler
        LDA $D019    ;VIC Interrupt Request Register (IRR)
        AND #$01
        BNE SpriteBackgroundCollisionDetected; Collision detected
;-------------------------------
; j6B59
;-------------------------------
j6B59   
        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        RTI 

;-------------------------------
; ClearGameViewPort
;-------------------------------
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

;-------------------------------
; FlashBorderAndBackground
;-------------------------------
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

b6BA3   LDA a6D85
        BEQ b6BBE
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
        DEC a6D86
        BNE b6BBE
        LDA #$00
        STA a6D85
        STA $D021    ;Background Color 0
        STA $D020    ;Border Color
b6BBE   RTS 

SpriteBackgroundCollisionDetected
        LDY a6D84
        LDA a59B9
        BEQ b6BCA
        JMP j59BB

b6BCA   LDA progressDisplaySelected
        BEQ b6BD2
        JMP GameSwitchAndGameOverInterruptHandler

b6BD2   LDA f6D52,Y
        BEQ b6BDA
        JMP j6C6E

b6BDA   LDA #$00
        STA a6D84
        LDA #$5C
        STA $D012    ;Raster Position
        LDA $D016    ;VIC Control Register 2
        AND #$E0
        ORA #$08
        STA $D016    ;VIC Control Register 2
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        BNE b6C26

UpdateGilbyPositionAndColor   
        LDA a40D2
        BNE b6C24
        LDA currentGilbySprite
        STA Sprite0Ptr
        STA previousGilbySprite
        LDA a760C
        STA $D001    ;Sprite 0 Y Pos
        LDX currEnergyTop
        LDA f40C8,X
        LDX a53B7
        BEQ b6C1A
        LDA a6E2B
b6C1A   LDY a4F57
        BEQ b6C21
        LDA #$0B
b6C21   STA $D027    ;Sprite 0 Color
b6C24   RTS 

currentGilbySprite   .BYTE $D3
b6C26   LDX currentPlanetBackgroundClr1
        LDA backgroundColorsForWorlds,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDX currentPlanetBackgroundClr2
        LDA backgroundColorsForWorlds,X
        STA $D023    ;Background Color 2, Multi-Color Register 1

        LDA $D01F    ;Sprite to Background Collision Detect
        STA a6D51

        JSR CheckKeyboardInGame
        JSR s6DC1
        JSR s75A8
        JSR s49D4
        JSR s6E2D
        JSR s7610
        JSR s7179
        JSR s78C8
        JSR s79B0
        JSR FlashBorderAndBackground
        JSR UpdateGilbyPositionAndColor
        JSR s7C97
        JSR s778C
        JSR UpdateAttackShipsPosition
        JSR s5284
        JMP $EA31

;-------------------------------
; j6C6E
;-------------------------------
j6C6E   
        STA $D00F    ;Sprite 7 Y Pos
        LDA f6D62,Y
        STA $D00E    ;Sprite 7 X Pos
        LDA f6D71,Y
        CLC 
        ROR 
        ROR 
        STA a06
        LDA $D010    ;Sprites 0-7 MSB of X coordinate
        AND #$7F
        ORA a06
        STA $D010    ;Sprites 0-7 MSB of X coordinate
        LDA f6D53,Y
        BNE b6C91
        JMP b6BDA

b6C91   SEC 
        SBC #$02
        STA $D012    ;Raster Position
        LDA f6D87,Y
        TAX 
        LDA f6DBA,X
        STA $D02E    ;Sprite 7 Color
        CPY a6D4F
        BNE b6CB5
        LDA $D016    ;VIC Control Register 2
        AND #$F0
        ORA a6E11
        ORA #$10
        STA $D016    ;VIC Control Register 2
        BNE b6CD3
b6CB5   CPY #$06
        BNE b6CD3
        LDA inGameMode
        BEQ b6CD6
        LDA #$90
        STA $D001    ;Sprite 0 Y Pos
        LDX #$30
b6CC5   DEX 
        BNE b6CC5
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        STA $D016    ;VIC Control Register 2
        JMP j6D36

b6CD3   JMP j6D41

b6CD6   JSR UpdateAttackShipsPosition2
        LDA #$07
        SEC 
        SBC a6E11
        STA a20
        LDA $D016    ;VIC Control Register 2
        AND #$F8
        ORA a20
        STA $D016    ;VIC Control Register 2
        LDA a40D2
        BNE b6D07
        LDA #$FF
        SEC 
        SBC a760C
        ADC #$07
        STA $D001    ;Sprite 0 Y Pos
        STA a760D
        LDA currentGilbySprite
        CLC 
        ADC #$13
        STA Sprite0Ptr
b6D07   LDX currentWorldBackgroundColor1
        LDA backgroundColorsForWorlds,X
        STA $D022    ;Background Color 1, Multi-Color Register 0
        LDX currentWorldBackgroundColor2
        LDA backgroundColorsForWorlds,X
        STA $D023    ;Background Color 2, Multi-Color Register 1
        LDA a40D2
        BNE j6D36
        LDX currEnergyBottom
        LDA f40C8,X
        LDX a53B8
        BEQ b6D2C
        LDA a6E2B
b6D2C   LDY a4F57
        BNE b6D33
        LDA #$0B
b6D33   STA $D027    ;Sprite 0 Color
;-------------------------------
; j6D36
;-------------------------------
j6D36   
        LDY #$0A
        STY a6D84
        LDA a6D51,Y
        STA $D012    ;Raster Position
;-------------------------------
; j6D41
;-------------------------------
j6D41   
        LDA #$01
        STA $D019    ;VIC Interrupt Request Register (IRR)
        STA $D01A    ;VIC Interrupt Mask Register (IMR)
        INC a6D84
        JMP j6B59

a6D4F   .BYTE $00,$0D
a6D51   .BYTE $00
f6D52   .BYTE $60
f6D53   .BYTE $66,$6C,$72,$78,$7E,$84,$8A,$90
        .BYTE $96,$9C,$A2,$A8,$AE,$B4
f6D61   .BYTE $00
f6D62   .BYTE $44,$CD,$9F,$F7,$EF,$7F,$79,$2D
        .BYTE $9D,$D5,$01,$79,$96,$FB
f6D70   .BYTE $C0
f6D71   .BYTE $01,$00,$01,$00,$01,$01,$00,$01
        .BYTE $00,$00,$00,$01,$00,$01,$00,$00
        .BYTE $01,$01,$00
a6D84   .BYTE $00
a6D85   .BYTE $00
a6D86   .BYTE $00
f6D87   .BYTE $02,$03,$04,$03,$02,$03,$04,$03
        .BYTE $02,$03,$04,$03,$02,$02,$03,$04
        .BYTE $03,$02,$03,$04,$03,$02,$01,$02
        .BYTE $03
f6DA0   .BYTE $04,$02,$03,$04,$03,$02,$03,$04
        .BYTE $03,$02,$03,$04,$03,$02,$02,$03
        .BYTE $04,$03,$02,$03,$04,$03,$02,$01
        .BYTE $02,$03
f6DBA   .BYTE $04,$01,$0F,$0C,$0B,$08,$06
;-------------------------------
; s6DC1
;-------------------------------
s6DC1   
        LDX #$0F
        LDA #$00
        STA a21
        LDA a6E12
        BPL b6DD0
        LDA #$FF
        STA a21
b6DD0   DEC f6DA0,X
        BNE b6E0B
        LDA a6D86,X
        STA f6DA0,X
        LDA f6D61,X
        CPX #$08
        BMI b6DF4
        SEC 
        SBC a6E12
        STA f6D61,X
        LDA f6D70,X
        SBC a21
        STA f6D70,X
        JMP j6E03

b6DF4   CLC 
        ADC a6E12
        STA f6D61,X
        LDA f6D70,X
        ADC a21
        STA f6D70,X

j6E03   
        LDA f6D70,X
        AND #$01
        STA f6D70,X
b6E0B   DEX 
        BNE b6DD0
        JMP j7217

a6E11   .BYTE $02
a6E12   .BYTE $EA
f6E13   .BYTE $C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0
        .BYTE $F0,$F0,$F0,$F0,$F8,$F8,$F8,$F8
        .BYTE $FC,$FC,$FC,$FC,$FE,$FE,$FE,$FF
a6E2B   .BYTE $01
a6E2C   .BYTE $01
;-------------------------------
; s6E2D
;-------------------------------
s6E2D   
        ; Find reasons for gilby not to die because he hit something.
        LDA a6D51
        BEQ b6E88
        AND #$01
        BEQ b6E88
        LDA controlPanelIsGrey
        BNE b6E88
        LDA a78C7
        BNE b6E88
        LDA a59B9
        BNE b6E88
        LDA a40D2
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

b6E67   JSR UpdateWorldProgress
        LDA #$01
        STA a78C6
        STA a78C7
        LDA #$06
        STA a6D85
        LDA #$04
        STA a6D86
        LDY #$14
        LDA a6E12
        BPL b6E85
        LDY #$EC
b6E85   STY a6E12

b6E88   DEC a6E2B
        BEQ b6E8E
b6E8D   RTS 

b6E8E   LDA $DC00    ;CIA1: Data Port Register A
        STA a7176
        AND #$1F
        CMP #$1F
        BEQ b6EA4
        LDA inAttractMode
        BEQ b6EA4
        LDA #$02
        STA inAttractMode
b6EA4   JSR s7EE4
        LDA inAttractMode
        BEQ b6EAF
        DEC inAttractMode
b6EAF   LDA #<screenPtrLo
        STA a6E2B
        LDA #>screenPtrLo
        STA a6E2C
        LDA SCREEN_RAM + $01A4
        CMP #$41
        BEQ b6EC4
        CMP #$43
        BNE b6EC9
b6EC4   LDA #$01
        STA a6E2C
b6EC9   LDA a4F57
        BEQ b6EF6
        LDA a7176
        AND #$10
        STA a42
        LDA a7176
        AND #$03
        STA a43
        CMP #$03
        BEQ b6EE4
        EOR #$03
        STA a43
b6EE4   LDA a7176
        AND #$0C
        CMP #$0C
        BEQ b6EEF
        EOR #$0C
b6EEF   ORA a43
        ORA a42
        STA a7176
b6EF6   LDA a78C7
        BNE b6E8D
        LDA a7177
        BEQ b6F03
        JMP j6F99

b6F03   JSR s7671
        LDA a7176
        AND #$04
        BNE b6F2E
        LDA #$01
        STA a7177
        LDA #$01
        STA a6E12
        LDA #$04
        STA a75A5
        STA a75A6
        LDA #$00
        STA a75A4
        STA a75A7
        LDA #$07
        STA a75A3
        BNE b6F54
b6F2E   LDA a7176
        AND #$08
        BNE b6F54
        LDA #$04
        STA a75A5
        STA a75A6
        LDA #$06
        STA a75A4
        STA a75A7
        LDA #$0D
        STA a75A3
        LDA #$FF
        STA a6E12
        LDA #$01
        STA a7177
b6F54   LDA a7176
        AND #$01
        BNE b6F98
        LDA a6E2C
        BEQ b6F63
        JMP j701E

b6F63   LDA a760C
        CMP #$6D
        BNE b6F98
        LDA #<p7B61
        STA a79AC
        LDA #>p7B61
        STA a79AD
        LDA #$FA
        STA a760B
        DEC a760C
        LDA #$11
        STA a75A4
        STA a75A7
        LDA #$16
        STA a75A3
        LDA #$01
        STA a7178
        LDA #$0A
        STA a75A5
        LDA #$02
        STA a7177
b6F98   RTS 

;-------------------------------
; j6F99
;-------------------------------
j6F99   
        CMP #$01
        BEQ b6FA0
        JMP j703B

b6FA0   JSR s7671
        LDA a7176
        AND #$04
        BNE b6FEB
        LDA a6E12
        BPL b6FDA
        INC a75A5
        INC a6E12
        BNE b6FD7
b6FB7   LDA #$00
        STA a7177
        STA a6E12
        STA a7178
        LDA #$06
        STA a75A5
        STA a75A6
        LDA #$0D
        STA a75A7
        STA a75A4
        LDA #$11
        STA a75A3
b6FD7   JMP j700F

b6FDA   INC a6E12
        DEC a75A5
        BNE b6FD7
        INC a75A5
        DEC a6E12
        JMP j700F

b6FEB   LDA a7176
        AND #$08
        BNE j700F
        LDA a6E12
        BMI b7001
        INC a75A5
        DEC a6E12
        BEQ b6FB7
        BNE j700F
b7001   DEC a6E12
        DEC a75A5
        BNE b6FD7
        INC a6E12
        INC a75A5
;-------------------------------
; j700F
;-------------------------------
j700F   
        LDA a7176
        AND #$01
        BNE b703A
        LDA a6E2C
        BNE j701E
        JMP b6F63

;-------------------------------
; j701E
;-------------------------------
j701E   
        LDA a760C
        CMP #$6D
        BNE b703A
        LDA #$FA
        STA a760B
        LDA #<p7B34
        STA a79AC
        LDA #>p7B34
        STA a79AD
        JSR s7C8B
        DEC a760C
b703A   RTS 

;-------------------------------
; j703B
;-------------------------------
j703B   
        CMP #$02
        BNE b707E
        JSR s7671
        LDA a7178
        CMP #$02
        BNE b703A
        LDA a7176
        AND #$04
        BEQ b7099
        LDA a7176
        AND #$08
        BEQ b70A7
        LDA a760B
        CMP #$02
        BNE b703A
;-------------------------------
; j705E
;-------------------------------
j705E   
        LDA #$15
        STA a75A4
        STA a75A7
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
        JSR s7671
        LDA a760C
        CMP #$6D
        BNE b707D
        LDA #<p7B07
        STA a79AC
        LDA #>p7B07
        STA a79AD
        JMP b6FB7

b7099   JSR s70AF
        LDA #$D1
        STA currentGilbySprite
;-------------------------------
; s70A1
;-------------------------------
s70A1   
        LDA #$04
        STA a7177
        RTS 

b70A7   LDA #$D3
        STA currentGilbySprite
        JSR s70A1
;-------------------------------
; s70AF
;-------------------------------
s70AF   
        LDA #$00
        STA a7140
        RTS 

b70B5   JSR s7671
        LDA a7176
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
        STA a75A7
        LDA #$1F
        STA a75A3
b70E0   INC a6E12
        LDA inGameMode
        BEQ b70EF
        LDA a6E12
        CMP #$0C
        BEQ b70F6
b70EF   LDA a6E12
        CMP #$18
        BNE b70F9
b70F6   DEC a6E12
b70F9   JMP j7173

b70FC   LDA a7176
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
        STA a75A7
        LDA #$24
        STA a75A3
b7124   DEC a6E12
        LDA inGameMode
        BEQ b7133
        LDA a6E12
        CMP #$F4
        BEQ b713A
b7133   LDA a6E12
        CMP #$E6
        BNE j7173
b713A   INC a6E12
        JMP j7173

a7140   .BYTE $00
b7141   RTS 

b7142   LDA a6E12
        BEQ b715A
        LDA a6E12
        BMI b7152
        DEC a6E12
        DEC a6E12
b7152   INC a6E12
        LDA a6E12
        BNE j7173
b715A   LDA a7176
        AND #$10
        BEQ b7141
        LDA a6E2C
        BEQ b7141
        LDA #$01
        STA a7140
        LDA #$CF
        STA currentGilbySprite
        JMP j705E

;-------------------------------
; j7173
;-------------------------------
j7173   
        JMP FixUpSpriteData

a7176   .BYTE $09
a7177   .BYTE $04
a7178   .BYTE $02
;-------------------------------
; s7179
;-------------------------------
s7179   
        LDA a7177
        CMP #$04
        BEQ b7181
b7180   RTS 

b7181   LDA a7176
        AND #$01
        BNE b71A4
        DEC a760C
        DEC a760C
        LDA a760C
        AND #$FE
        CMP #$30
        BNE b719D
        INC a760C
        INC a760C
b719D   LDA a760C
        STA $D001    ;Sprite 0 Y Pos
        RTS 

b71A4   LDA a7176
        AND #$02
        BNE b7180
        INC a760C
        INC a760C
        LDA a760C
        AND #$F0
        CMP #$70
        BNE b719D
        DEC a760C
        DEC a760C
        BNE b719D
        ;Fall through?

;-------------------------------
; DrawWorlds
;-------------------------------
DrawWorlds   
        LDY #$00
        LDA inGameMode
        BEQ b71E6
        LDX #$27
b71CB   LDA (p10),Y
        STA SCREEN_RAM + $0118,Y
        LDA (p12),Y
        STA SCREEN_RAM + $0140,Y
        LDA (p14),Y
        STA SCREEN_RAM + $0168,Y
        LDA (p16),Y
        STA SCREEN_RAM + $0190,Y
        INY 
        DEX 
        CPY #$28
        BNE b71CB
        RTS 

b71E6   LDX #$27
b71E8   LDA (p10),Y
        STA SCREEN_RAM + $0118,Y
        ORA #$C0
        STA SCREEN_RAM + $0258,X
        LDA (p12),Y
        STA SCREEN_RAM + $0140,Y
        ORA #$C0
        STA SCREEN_RAM + $0230,X
        LDA (p14),Y
        STA SCREEN_RAM + $0168,Y
        ORA #$C0
        STA SCREEN_RAM + $0208,X
        LDA (p16),Y
        STA SCREEN_RAM + $0190,Y
        ORA #$C0
        STA SCREEN_RAM + $01E0,X
        INY 
        DEX 
        CPY #$28
        BNE b71E8
        RTS 

;-------------------------------
; j7217
;-------------------------------
j7217   
        INC a6794
        LDA a6794
        AND #$0F
        TAX 
        LDA f6795,X
        STA a67C5
        LDA f67A5,X
        STA a67C6
        LDA a6E12
        BMI b7234
        JMP j72C0

b7234   LDA a6E11
        CLC 
        ADC a6E12
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
        STA aFD
        INC aFD
        LDA a10
        CLC 
        ADC aFD
        STA a10
        STA a12
        STA a14
        STA a16
        LDA a11
        ADC #$00
;-------------------------------
; j7263
;-------------------------------
j7263   
        STA a11
        CLC 
        ADC #$04
        STA a13
        CLC 
        ADC #$04
        STA a15
        CLC 
        ADC #$04
        STA a17
        LDA a6E11
        AND #$07
        STA a6E11
        LDA a11
        CMP #$7F
        BNE b7294
        LDA a10
        SEC 
        SBC #$28
        STA a10
        STA a12
        STA a14
        STA a16
        LDA #$83
        JMP j7263

b7294   CMP #$83
        BNE b72BD
        LDA a10
        CMP #$D8
        BEQ b72AD
        CMP #$D9
        BEQ b72AD
        CMP #$DA
        BEQ b72AD
        CMP #$DB
        BEQ b72AD
        JMP b72BD

b72AD   CLC 
        ADC #$28
        STA a10
        STA a12
        STA a14
        STA a16
        LDA #$80
        JMP j7263

b72BD   JMP DrawWorlds

;-------------------------------
; j72C0
;-------------------------------
j72C0   
        LDA a6E11
        CLC 
        ADC a6E12
        STA a6E11
        AND #$F8
        BNE b72CF
        RTS 

b72CF   CLC 
        ROR 
        ROR 
        ROR 
        STA aFD
        LDA a10
        SEC 
        SBC aFD
        STA a10
        STA a12
        STA a14
        STA a16
        LDA a11
        SBC #$00
        JMP j7263

;-------------------------------
; s72E9
;-------------------------------
s72E9   
        LDA #<p8C00
        STA screenPtrLo
        LDA #>p8C00
        STA screenPtrHi
        LDA a24
        BEQ b72F9
        INC screenPtrHi
        INC screenPtrHi
b72F9   LDA screenPtrLo
        CLC 
        ADC a25
        STA screenPtrLo
        LDA screenPtrHi
        ADC #$00
        STA screenPtrHi
        LDA screenPtrLo
        CLC 
        ADC a25
        STA screenPtrLo
        LDA screenPtrHi
        ADC #$00
        STA screenPtrHi
        LDY #$00
        RTS 

a7317   =*+$01
;-------------------------------
; GetSomeSequenceData
;-------------------------------
GetSomeSequenceData   
        LDA a9ABB
        INC a7317
        RTS 

;-------------------------------
; UpdateTopWorldSurfaceColor
;-------------------------------
UpdateTopWorldSurfaceColor   
        LDX #$28
b731F   STA COLOR_RAM + $0117,X
        STA COLOR_RAM + $013F,X
        STA COLOR_RAM + $0167,X
        STA COLOR_RAM + $018F,X
        DEX 
        BNE b731F
        RTS 

;-------------------------------
; UpdateBottomWorldSurfaceColor
;-------------------------------
UpdateBottomWorldSurfaceColor   
        LDX #$28
b7331   STA COLOR_RAM + $01DF,X
        STA COLOR_RAM + $0207,X
        STA COLOR_RAM + $022F,X
        STA COLOR_RAM + $0257,X
        DEX 
        BNE b7331
        RTS 

;-------------------------------
; s7341
;-------------------------------
s7341   
        LDA a73AE
        STA a22
        LDA a73AF
        STA a23
        JSR s735E
        LDA a26
        STA f2600,X
        INC a23
        JSR s735E
        LDA a26
        STA f2700,X
        RTS 

;-------------------------------
; s735E
;-------------------------------
s735E   
        LDA (p22),Y
        PHA 
        AND #$03
        TAX 
        LDA f73B0,X
        STA a26
        PLA 
        ROR 
        ROR 
        PHA 
        AND #$03
        TAX 
        LDA f73B4,X
        ORA a26
        STA a26
        PLA 
        ROR 
        ROR 
        AND #$03
        TAX 
        LDA f73B8,X
        ORA a26
        STA a26
        LDA (p22),Y
        ROL 
        ROL 
        ROL 
        AND #$03
        ORA a26
        STA a26
        TYA 
        PHA 
        AND #$07
        TAY 
        PLA 
        PHA 
        AND #$F8
        STA a24
        LDA f73A4,Y
        CLC 
        ADC a24
        TAX 
        PLA 
        TAY 
        RTS 

f73A4   .BYTE $07,$06,$05,$04,$03,$02,$01,$00
a73AC   .BYTE $00
a73AD   .BYTE $92
a73AE   .BYTE $00
a73AF   .BYTE $92
f73B0   .BYTE $00,$40,$80,$C0
f73B4   .BYTE $00,$10,$20,$30
f73B8   .BYTE $00,$04,$08,$0C
;-------------------------------
; CopyInSpriteData
;-------------------------------
CopyInSpriteData   
        LDA #<p8000
        STA a22
        LDA #>p8000
        STA a23

        LDY #$00
b73C6   LDA #$60
b73C8   STA (p22),Y
        DEY 
        BNE b73C8
        INC a23
        LDA a23
        CMP #$90
        BNE b73C6

        LDA #$8C
        STA a23
b73D9   LDA #$40
        STA (p22),Y
        LDA #$42
        INY 
        STA (p22),Y
        DEY 
        LDA a22
        CLC 
        ADC #$02
        STA a22
        LDA a23
        ADC #$00
        STA a23
        CMP #$90
        BNE b73D9

        JSR GetSomeSequenceData
        AND #$7F
        CLC 
        ADC #$7F
        STA a25
        LDA #$00
        STA a24
        JSR s72E9
        JSR GetSomeSequenceData
        AND #$7F
        CLC 
        ADC #$20
        STA a22
        LDY #$00
        LDA #$5C
        STA (screenPtrLo),Y
        LDA #$5E
        INY 
        STA (screenPtrLo),Y
b741A   INC a25
        BNE b7420
        INC a24
b7420   JSR s72E9
        LDY #$00
        LDA #$41
        STA (screenPtrLo),Y
        LDA #$43
        INY 
        STA (screenPtrLo),Y
        DEC a22
        BNE b741A
        INY 
        LDA #$5D
        STA (screenPtrLo),Y
        LDA #$5F
        INY 
        STA (screenPtrLo),Y
        JSR s7519
        RTS 

f7440   .BYTE $65,$67,$69,$6B,$FF,$64,$66,$68
        .BYTE $6A,$FE
f744A   .BYTE $41,$43,$51,$53,$41,$43,$FF,$60
        .BYTE $60,$50,$52,$60,$60,$FF,$49,$4B
        .BYTE $4D,$4F,$6D,$6F,$FF,$48,$4A,$4C
        .BYTE $4E,$6C,$6E,$FE
f7466   .BYTE $59,$5B,$FF,$58,$5A,$FF,$55,$57
        .BYTE $FF,$54,$56,$FE
f7472   .BYTE $75,$77,$7D,$7F,$FF,$74,$76,$7C
        .BYTE $7E,$FF,$71,$73,$79,$7B,$FF,$70
        .BYTE $72,$78,$7A,$FE,$A2,$00
;-------------------------------
; j7488
;-------------------------------
j7488   
        LDA f74A0,X
        CMP #$FF
        BNE b7495
        JSR s74A6
        JMP j7488

b7495   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j7488

f74A0   .TEXT "EG", $FF, "DF", $FE
;-------------------------------
; s74A6
;-------------------------------
s74A6   
        LDA screenPtrHi
        SEC 
        SBC #$04
        STA screenPtrHi
        LDY #$00
        INX 
b74B0   RTS 

        LDX #$00
;-------------------------------
; j74B3
;-------------------------------
j74B3   
        LDA f7440,X
        CMP #$FF
        BNE b74C0
        JSR s74A6
        JMP j74B3

b74C0   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j74B3

        LDX #$00
;-------------------------------
; j74CD
;-------------------------------
j74CD   
        LDA f744A,X
        CMP #$FF
        BNE b74DA
        JSR s74A6
        JMP j74CD

b74DA   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j74CD

        LDX #$00
;-------------------------------
; j74E7
;-------------------------------
j74E7   
        LDA f7466,X
        CMP #$FF
        BNE b74F4
        JSR s74A6
        JMP j74E7

b74F4   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j74E7

;-------------------------------
; s74FF
;-------------------------------
s74FF   
        LDX #$00
;-------------------------------
; j7501
;-------------------------------
j7501   
        LDA f7472,X
        CMP #$FF
        BNE b750E
        JSR s74A6
        JMP j7501

b750E   CMP #$FE
        BEQ b74B0
        STA (screenPtrLo),Y
        INY 
        INX 
        JMP j7501

;-------------------------------
; s7519
;-------------------------------
s7519   
        LDA #<p2000
        STA a24
        LDA #>p2000
        STA a25
;-------------------------------
; j7521
;-------------------------------
j7521   
        JSR s7561
        JSR GetSomeSequenceData
        AND #$0F
        CLC 
        ADC #$0C
        CLC 
        ADC a25
        STA a25
        LDA a24
        ADC #$00
        STA a24
        LDA a25
        AND #$F0
        CMP #$C0
        BEQ b7546
        CMP #$D0
        BEQ b7546
        JMP j7521

b7546   LDA a24
        BEQ j7521
        LDA #$F1
        STA a25
        JSR s72E9
        JSR s74FF
        DEC a24
        LDA #$05
        STA a25
        JSR s72E9
        JSR s74FF
        RTS 

;-------------------------------
; s7561
;-------------------------------
s7561   
        JSR s72E9
        JSR GetSomeSequenceData
        AND #$03
        TAX 
        LDA f7577,X
        STA a2A
        LDA f757B,X
        STA a29
        JMP (p0029)

f7577   .BYTE $74,$74,$74,$74
f757B   .BYTE $86,$B1,$CB,$E5
f757F   .BYTE $C1,$C2,$C3,$C4,$C5,$C6,$C7,$C6
        .BYTE $C5,$C4,$C3,$C2,$C1,$C8,$C9,$CA
        .BYTE $CB,$CB,$CC,$CD,$CE,$CF,$CE,$CD
        .BYTE $CC,$CB,$D3,$D2,$CF,$D0,$D1,$D1
        .BYTE $D0,$CF,$D2,$D3
a75A3   .BYTE $11
a75A4   .BYTE $0D
a75A5   .BYTE $06
a75A6   .BYTE $06
a75A7   .BYTE $0D
;-------------------------------
; s75A8
;-------------------------------
s75A8   
        LDA a40D2
        BNE b75BF
        LDA pauseModeSelected
        BNE b75BF
        LDA a78C7
        BEQ b75BA
        JMP j5CC9

b75BA   DEC a75A6
        BEQ b75C0
b75BF   RTS 

b75C0   LDA a75A5
        STA a75A6
        LDA a7178
        BEQ b75CF
        CMP #$02
        BEQ b75BF
b75CF   INC a75A7
        LDA a75A7
        CMP a75A3
        BNE b7601
        LDA a7178
        BEQ b75E3
        INC a7178
        RTS 

b75E3   LDA a75A4
        STA a75A7
        LDA a7177
        CMP #$01
        BNE b7601
        LDA a760C
        CMP #$6D
        BNE b7601
        LDA #<p7B07
        STA a79AC
        LDA #>p7B07
        STA a79AD
b7601   LDX a75A7
        LDA f757F,X
        STA currentGilbySprite
        RTS 

a760B   .BYTE $01
a760C   .BYTE $3F
a760D   .BYTE $CA
a760E   .BYTE $01
a760F   .BYTE $03
;-------------------------------
; s7610
;-------------------------------
s7610   
        LDA a78C7
        BNE b761A
        DEC a760E
        BEQ b761B
b761A   RTS 

b761B   LDA #$02
        STA a760E
        LDA a7140
        BEQ b761A
        LDA a760C
        CMP #$6D
        BEQ b761A
        DEC a760F
        BEQ b764A
;-------------------------------
; j7631
;-------------------------------
j7631   
        CLC 
        ADC a760B
        STA a760C
        AND #$F0
        CMP #$70
        BNE b7643
        LDA #$6D
        STA a760C
b7643   LDA a760C
        STA $D001    ;Sprite 0 Y Pos
        RTS 

b764A   LDA #$03
        STA a760F
        INC a760B
        LDA a760B
        CMP #$08
        BEQ b765F
        LDA a760C
        JMP j7631

b765F   DEC a760B
        LDA a760C
        JMP j7631

f7668   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
a7670   .BYTE $01
;-------------------------------
; s7671
;-------------------------------
s7671   
        LDA a7176
        AND #$10
        BEQ b767E
        LDA #$01
        STA a7670
b767D   RTS 

b767E   LDX #$00
        LDA f67E2,X
        BMI b76A8
        LDX #$06
        LDA f67E2,X
        BMI b76A8
        LDX #$01
        DEC a7670
        BNE b767D
        LDA #$06
        STA a7670
        LDA f67E2,X
        BPL b76A0
        JSR b76A8
b76A0   LDX #$07
        LDA f67E2,X
        BMI b76A8
        RTS 

b76A8   LDA #$B5
        STA f67C8,X
        LDA #$00
        STA f67E2,X
        LDA a760C
        CLC 
        ADC #$04
        STA f67FC,X
        LDA #$E7
        STA f67D6,X
        LDA a6E12
        EOR #$FF
        STA f7668,X
        INC f7668,X
        LDA #$FA
        STA f7784,X
        LDA a48D7
        BNE b76DF
        LDA #<p7BD4
        STA a79AE
        LDA #>p7BD4
        STA a79AF
b76DF   LDA a7177
        CMP #$04
        BNE b7717
        LDA a48D7
        BNE b76F8
        JSR Reseta79A4
        LDA #<p7C24
        STA a79AE
        LDA #>p7C24
        STA a79AF
b76F8   LDA a760C
        CLC 
        ADC #$06
        STA f67FC,X
        LDA #$B1
        STA f67C8,X
        LDA #$EC
        STA f67D6,X
        LDA currentGilbySprite
        CMP #$D1
        BNE b7718
        LDA #$F5
        STA f7668,X
b7717   RTS 

b7718   CMP #$D3
        BNE b7722
        LDA #$0B
        STA f7668,X
        RTS 

b7722   LDA #$FF
        STA f67E2,X
        JMP j77FF

;-------------------------------
; s772A
;-------------------------------
s772A   
        LDA #$00
        STA a20
        STA a1F
        LDA pauseModeSelected
        BEQ b7736
        RTS 

b7736   LDA f7668,X
        BEQ b776F
        BPL b7741
        LDA #$FF
        STA a1F
b7741   LDA f67E2,X
        BEQ b7748
        INC a20
b7748   LDA f67C8,X
        CLC 
        ADC f7668,X
        STA f67C8,X
        LDA a20
        ADC a1F
        STA a20
        LDA a20
        AND #$01
        BEQ b7761
        LDA f6B45,X
b7761   STA f67E2,X
        BEQ b7770
        LDA f67C8,X
        AND #$F0
        CMP #$30
        BEQ b7777
b776F   RTS 

b7770   LDA f67C8,X
        AND #$F0
        BNE b776F
b7777   LDA #$FF
        STA f67E2,X
        PLA 
        PLA 
        JSR j77FF
        JMP j77AE

f7784   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
;-------------------------------
; s778C
;-------------------------------
s778C   
        LDX #$00
        LDA a40D2
        BEQ b7794
b7793   RTS 

b7794   LDA a78C7
        BNE b7793
        LDA f67E2,X
        CMP #$FF
        BEQ b77A9
        JSR s77C7
        JSR s772A
        JMP j77AE

b77A9   LDA #$F0
        STA f67D6,X
;-------------------------------
; j77AE
;-------------------------------
j77AE   
        INX 
        CPX #$08
        BEQ b77BC
        CPX #$02
        BNE b7794
        LDX #$06
        JMP b7794

b77BC   JMP j780F

f77BF   .BYTE $03,$03,$03,$03,$03,$03,$03,$03
;-------------------------------
; s77C7
;-------------------------------
s77C7   
        LDA f67D6,X
        CMP #$EC
        BEQ b780E
        LDA f67FC,X
        CLC 
        ADC f7784,X
        STA f67FC,X
        DEC f77BF,X
        BNE b77E5
        LDA #$03
        STA f77BF,X
        INC f7784,X
b77E5   LDA f67FC,X
        AND #$F8
        CMP #$78
        BEQ b77F2
        CMP #$88
        BNE b780E
b77F2   LDA #$FF
        STA f67E2,X
        JSR j77FF
        PLA 
        PLA 
        JMP j77AE

;-------------------------------
; j77FF
;-------------------------------
j77FF   
        LDA #$F0
        STA f67D6,X
        LDA #$FF
        STA f67C8,X
        LDA #$00
        STA f67FC,X
b780E   RTS 

;-------------------------------
; j780F
;-------------------------------
j780F   
        LDX #$00
b7811   LDA #$FF
        SEC 
        SBC f6802,X
        ADC #$17
        STA f6804,X
        LDA f67CE,X
        EOR #$FF
        STA a1F
        LDA f67E8,X
        BEQ b782A
        LDA #$01
b782A   EOR #$FF
        STA a20
        INC a20
        LDA #$6F
        CLC 
        ADC a1F
        STA f67D0,X
        LDA a20
        ADC #$00
        AND #$01
        STA a20
        BEQ b7845
        LDA f6B45,X
b7845   STA f67EA,X
        INX 
        CPX #$02
        BNE b7811
        RTS 

;-------------------------------
; DrawControlPanel
;-------------------------------
DrawControlPanel   
        LDX #$A0
b7850   LDA controlPanelData,X
        STA SCREEN_RAM + $0347,X
        LDA controlPanelColors,X
        STA COLOR_RAM + $0347,X
        DEX 
        BNE b7850
        RTS 

a7860   .BYTE $00
;-------------------------------
; CheckKeyboardInGame
;-------------------------------
CheckKeyboardInGame   
        LDA lastKeyPressed
        CMP #$40
        BNE b786D
        LDA #$00
        STA a7860
b786C   RTS 

b786D   LDY a7860
        BNE b786C
        LDY inAttractMode
        BEQ b787C
        LDY #$02
        STY inAttractMode
b787C   LDY a59B9
        BNE b786C
        LDY a40D2
        BNE b786C
        CMP #$3E
        BNE b788E
        INC a78B4
        RTS 

b788E   CMP #$04 ; F1 Pressed
        BNE b7899
        INC a7860
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

currentTopWorldProgress   .BYTE $00
a78B1   .BYTE $00
currentBottomWorldProgress   .BYTE $00
a78B3   .BYTE $00
a78B4   .BYTE $00
backgroundColor1ForWorlds   .BYTE $09,$0B,$07,$0E,$0D
backgroundColor2ForWorlds   .BYTE $0E,$10,$01,$07,$10
surfaceColorsForWorlds   .BYTE $0D,$09,$0A,$0C,$0A,$01,$01
a78C6   .BYTE $A5
a78C7   .BYTE $01
;-------------------------------
; s78C8
;-------------------------------
s78C8   
        LDA a78C7
        BNE b78CE
b78CD   RTS 

b78CE   LDX a78C6
        LDY a9A00,X
        LDA a73AC
        STA a22
        LDA a73AD
        STA a23
        LDA (p22),Y
        STA f2200,Y
        INC a23
        LDA (p22),Y
        STA f2300,Y
        JSR s7341
        INC a78C6
        LDA a78C6
        CMP #$01
        BNE b78CD
        LDA #$00
        STA a78C7
;-------------------------------
; SetUpWorlds
;-------------------------------
SetUpWorlds   
        LDX currentTopWorldProgress
        LDA backgroundColor1ForWorlds,X
        STA currentPlanetBackgroundClr1
        LDA backgroundColor2ForWorlds,X
        STA currentPlanetBackgroundClr2

        LDA surfaceColorsForWorlds,X
        JSR UpdateTopWorldSurfaceColor

        LDX currentBottomWorldProgress
        LDA backgroundColor1ForWorlds,X
        STA currentWorldBackgroundColor1

        LDA backgroundColor2ForWorlds,X
        STA currentWorldBackgroundColor2

        LDA surfaceColorsForWorlds,X
        JSR UpdateBottomWorldSurfaceColor

        LDA #$01
        STA a6D85
        LDA #$0F
        STA $D418    ;Select Filter Mode and Volume
        LDA #$03
        STA a6D86
        LDX #$06
        LDA #$EC
b7939   STA f67D5,X
        STA f67DB,X
        DEX 
        BNE b7939
        LDA #$FF
        STA f67E2
        STA f67E3
        STA f67E8
        STA f67E9
        JSR Reseta79A4
        LDA #<p5DB0
        STA a79AE
        LDA #>p5DB0
        STA a79AF
        LDA #$30
        STA a48D7
        LDA inGameMode
        BEQ b797C
        LDX currentTopWorldProgress
        LDA backgroundColor1ForWorlds,X
        STA currentWorldBackgroundColor1
        LDA backgroundColor2ForWorlds,X
        STA currentWorldBackgroundColor2
        LDA surfaceColorsForWorlds,X
        JSR UpdateBottomWorldSurfaceColor
b797C   RTS 

inGameMode   .BYTE $01
f797E   .BYTE $00,$94,$00,$00,$11,$0F,$00,$00
        .BYTE $03,$00,$00,$21,$0F,$00,$08,$03
        .BYTE $00,$00,$21,$0F,$00,$00,$00,$00
        .BYTE $02,$00,$00,$00,$00,$00,$00,$00
f799E   .BYTE $92
f799F   .BYTE $5D,$85,$5C
f79A2   .BYTE $02,$00
a79A4   .BYTE $00,$00
a79A6   .BYTE $02
f79A7   .BYTE $18
a79A8   .BYTE $05
a79A9   .BYTE $00
a79AA   .BYTE $65
a79AB   .BYTE $5D
a79AC   .BYTE $97
a79AD   .BYTE $5D
a79AE   .BYTE $65
a79AF   .BYTE $5D
;-------------------------------
; s79B0
;-------------------------------
s79B0   
        LDA #$00
        STA a79A6
        LDA a48D7
        BEQ b79BD
        DEC a48D7
b79BD   LDA a79AC
        STA a30
        LDA a79AD
        STA a31
        JSR s79D9
        LDA #$02
        STA a79A6
        LDA a79AE
        STA a30
        LDA a79AF
        STA a31
;-------------------------------
; s79D9
;-------------------------------
s79D9   
        LDY #$00
b79DB   LDA (p30),Y
        STA f79A7,Y
        INY 
        CPY #$05
        BNE b79DB
        LDA a79A8
        BNE b7A28
        LDA a79A9
        LDX a79AA
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
;-------------------------------
; j79F6
;-------------------------------
j79F6   
        JSR s7A11
        LDA a79AB
        BEQ s79D9
        CMP #$01
        BNE b7A03
        RTS 

b7A03   LDX a79A6
        LDA a30
        STA f799E,X
        LDA a31
        STA f799F,X
        RTS 

;-------------------------------
; s7A11
;-------------------------------
s7A11   
        LDA a30
        CLC 
        ADC #$05
        STA a30
        LDX a79A6
        STA a79AC,X
        LDA a31
        ADC #$00
        STA a31
        STA a79AD,X
        RTS 

b7A28   AND #$80
        BEQ b7A2F
        JMP j7AC8

b7A2F   LDA a79A8
        CMP #$01
        BNE b7A4C
        LDX f79A7
        LDA f797E,X
        CLC 
        ADC a79A9
        LDX a79AA
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP j79F6

b7A4C   CMP #$02
        BNE b7A66
        LDX f79A7
        LDA f797E,X
        SEC 
        SBC a79A9
;-------------------------------
; j7A5A
;-------------------------------
j7A5A   
        LDX a79AA
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        JMP j79F6

b7A66   CMP #$03
        BNE b7A7A
        LDX f79A7
        LDY a79A9
        LDA f797E,X
        CLC 
        ADC f797E,Y
        JMP j7A5A

b7A7A   CMP #$04
        BNE b7A8E
        LDX f79A7
        LDY a79A9
        LDA f797E,X
        SEC 
        SBC f797E,Y
        JMP j7A5A

b7A8E   CMP #$05
        BNE b7AB7
        LDX f79A7
        LDA f797E,X
        SEC 
        SBC a79A9
;-------------------------------
; j7A9C
;-------------------------------
j7A9C   
        STA f797E,X
        STA $D400,X  ;Voice 1: Frequency Control - Low-Byte
        BEQ b7AB4
        LDA a79AA
        LDX a79A6
        STA a79AC,X
        LDA a79AB
        STA a79AD,X
        RTS 

b7AB4   JMP s7A11

b7AB7   CMP #$06
        BNE j7AC8
        LDX f79A7
        LDA f797E,X
        CLC 
        ADC a79A9
        JMP j7A9C

;-------------------------------
; j7AC8
;-------------------------------
j7AC8   
        LDA a79A8
        CMP #$80
        BNE b7ADF
        LDX a79A6
        LDA a79A9
        STA a79AC,X
        LDA a79AA
        STA a79AD,X
        RTS 

b7ADF   CMP #$81
        BNE b7B06
        LDX a79A6
        LDA f79A2,X
        BNE b7AF1
        LDA a79A9
        STA f79A2,X
b7AF1   DEC f79A2,X
        BEQ b7B03
        LDA f799E,X
        STA a30
        LDA f799F,X
        STA a31
        JMP s79D9

b7B03   JMP s7A11

b7B06   RTS 

p7B07   .BYTE $00,$00,$00,$04,$00,$00,$00,$00
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
;-------------------------------
; s7C8B
;-------------------------------
s7C8B   
        LDA #$00
        STA f79A2
        RTS 

;-------------------------------
; Reseta79A4
;-------------------------------
Reseta79A4   
        LDA #$00
        STA a79A4
b7C96   RTS 

;-------------------------------
; s7C97
;-------------------------------
s7C97   
        LDX #$04
        LDA a40D2
        BNE b7C96
        LDA a78C7
        BNE b7C96
b7CA3   LDA f67E3,X
        BMI b7CC2
        LDA f67C9,X
        LDY a6E12
        BMI b7CF0
        CLC 
        ADC a6E12
        STA f67C9,X
        BCC b7CC2
;-------------------------------
; j7CB9
;-------------------------------
j7CB9   
        LDA f67E3,X
        EOR f6B46,X
        STA f67E3,X
b7CC2   LDA f67EB,X
        BMI b7CE1
        LDA f67D1,X
        LDY a6E12
        BMI b7D07
        SEC 
        SBC a6E12
        STA f67D1,X
        BCS b7CE1
;-------------------------------
; j7CD8
;-------------------------------
j7CD8   
        LDA f67EB,X
        EOR f6B46,X
        STA f67EB,X
b7CE1   LDA pauseModeSelected
        BNE b7CE9
        JSR s7D3F
b7CE9   JSR s7E69
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
        STA f67C9,X
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
        STA f67D1,X
        BCC b7CE1
        JMP j7CD8

a7D1E   .BYTE $10
f7D1F   .BYTE $01,$01,$01
f7D22   .BYTE $01,$01,$01,$01
f7D26   .BYTE $01
f7D27   .BYTE $01,$01,$01
f7D2A   .BYTE $01,$01,$01,$01
f7D2E   .BYTE $01
f7D2F   .BYTE $01,$01,$01
f7D32   .BYTE $01,$01,$01,$01
f7D36   .BYTE $01
f7D37   .BYTE $01,$01,$01
f7D3A   .BYTE $01,$01,$01,$01,$01
;-------------------------------
; s7D3F
;-------------------------------
s7D3F   
        DEC f7D36,X
        BNE b7D79
        LDA f7D2E,X
        STA f7D36,X
        LDA f7E40,X
        CLC 
        ADC f67FD,X
        STA f67FD,X
        AND #$F0
        CMP #$70
        BEQ b7D6A
        CMP #$00
        BNE b7D79
        LDA #$10
        STA f67FD,X
        LDA #$01
        STA f48AC,X
        BNE b7D74
b7D6A   LDA #$6D
        STA f67FD,X
        LDA #$01
        STA f48B6,X
b7D74   LDA #$00
        STA f7E40,X
b7D79   DEC f7D3A,X
        BNE b7DB4
        LDA f7D32,X
        STA f7D3A,X
        LDA f7E44,X
        CLC 
        ADC f6805,X
        STA f6805,X
        AND #$F0
        BEQ b7DA5
        LDA f6805,X
        CMP #$99
        BPL b7DB4
        LDA #$99
        STA f6805,X
        LDA #$01
        STA f48BC,X
        BNE b7DAF
b7DA5   LDA #$FF
        STA f6805,X
        LDA #$01
        STA f48B2,X
b7DAF   LDA #$00
        STA f7E44,X
b7DB4   DEC f7D26,X
        BNE b7DF6
        LDA a7D1E,X
        STA f7D26,X
        LDA f7E38,X
        BMI b7DD9
        CLC 
        ADC f67C9,X
        STA f67C9,X
        BCC b7DF6
        LDA f67E3,X
        EOR f6B46,X
        STA f67E3,X
        JMP b7DF6

b7DD9   EOR #$FF
        STA a7D1E
        INC a7D1E
        LDA f67C9,X
        SEC 
        SBC a7D1E
        STA f67C9,X
        BCS b7DF6
        LDA f67E3,X
        EOR f6B46,X
        STA f67E3,X
b7DF6   DEC f7D2A,X
        BNE f7E38
        LDA f7D22,X
        STA f7D2A,X
        LDA f7E3C,X
        BMI b7E1B
        CLC 
        ADC f67D1,X
        STA f67D1,X
        BCC f7E38
        LDA f67EB,X
        EOR f6B46,X
        STA f67EB,X
        JMP f7E38

b7E1B   EOR #$FF
        STA a7D1E
        INC a7D1E
        LDA f67D1,X
        SEC 
        SBC a7D1E
        STA f67D1,X
        BCS f7E38
        LDA f67EB,X
        EOR f6B46,X
        STA f67EB,X
f7E38   RTS 

f7E39   .BYTE $06,$06,$06
f7E3C   .BYTE $06,$06,$06,$06
f7E40   .BYTE $06
f7E41   .BYTE $FF,$FF,$FF
f7E44   .BYTE $FF,$00,$00,$01
f7E48   .BYTE $01
f7E49   .BYTE $ED,$ED,$ED
f7E4C   .BYTE $ED
f7E4D   .BYTE $ED,$ED,$ED
f7E50   .BYTE $ED
f7E51   .BYTE $F0,$F0,$F0
f7E54   .BYTE $F0,$F0,$F0,$F0
f7E58   .BYTE $F0
f7E59   .BYTE $01,$01,$01
f7E5C   .BYTE $01,$01,$01,$01
f7E60   .BYTE $01
f7E61   .BYTE $03,$03,$03
f7E64   .BYTE $03,$03,$03,$03,$03
;-------------------------------
; s7E69
;-------------------------------
s7E69   
        LDA pauseModeSelected
        BEQ b7E6F
        RTS 

b7E6F   DEC f7E58,X
        BNE b7E8B
        LDA f7E60,X
        STA f7E58,X
        INC f67D7,X
        LDA f67D7,X
        CMP f7E50,X
        BNE b7E8B
        LDA f7E48,X
        STA f67D7,X
b7E8B   DEC f7E5C,X
        BNE b7EA7
        LDA f7E64,X
        STA f7E5C,X
        INC f67DD,X
        LDA f67DD,X
        CMP f7E54,X
        BNE b7EA7
        LDA f7E4C,X
        STA f67DD,X
b7EA7   RTS 

;-------------------------------
; DetectGameOrAttractMode
;-------------------------------
DetectGameOrAttractMode   
        LDA attractModeSelected
        BNE b7EB8
        LDA #$01
        STA inGameMode
        LDA #$00
        STA inAttractMode
        RTS 

b7EB8   LDA #$00
        STA inGameMode
        LDA #$FF
        STA inAttractMode
        RTS 

;-------------------------------
; GetSomeGameModeData
;-------------------------------
GetSomeGameModeData   
        LDX #$09
b7EC5   JSR GetSomeSequenceData
        AND #$0F
        STA f49C6,X
        DEX 
        BPL b7EC5

        JSR GetSomeSequenceData
        AND #$03
        STA currentTopWorldProgress
        JSR GetSomeSequenceData
        AND #$03
        STA currentBottomWorldProgress
        RTS 

inAttractMode   .BYTE $AD
a7EE2   .BYTE $09
a7EE3   .BYTE $09
;-------------------------------
; s7EE4
;-------------------------------
s7EE4   
        LDA inAttractMode
        BNE b7EEA
        RTS 

b7EEA   DEC a7EE2
        BNE b7F01
        JSR GetSomeSequenceData
        AND #$1F
        ORA #$01
        STA a7EE2
        LDA a7EE3
        EOR #$0F
        STA a7EE3
b7F01   LDA a7EE3
        STA a7176
        RTS 

.include "padding.asm"

*=$AAC0
currentBonusBounty   .BYTE $F0
currentBonusBountyPtr   .BYTE $30,$30,$30,$30,$30,$30,$30,$00
        .BYTE $00,$00,$00,$00,$00,$C8,$18
aAAD0   .BYTE $00
aAAD1   .BYTE $00
mifDNAPauseModeActive   .BYTE $00,$0C,$00,$00,$00,$00,$0A,$F6
        .BYTE $F9,$04,$F9,$FC,$00,$00
attractModeSelected   .BYTE $FF
aAAE1   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$02,$02,$01,$01,$00
        .BYTE $00,$00,$00,$00,$10,$00,$10,$00
        .BYTE $00,$00,$10,$00,$04,$40
        .BYTE $00

.include "bonusphase.asm"

fC802   =*+$02
;-------------------------------
; jC800
;-------------------------------
jC800   
        JMP jC9C0

lastBlastScore   .TEXT "0000000...."
fC80E   .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;-------------------------------
; sC818
;-------------------------------
aC819   =*+$01
aC81A   =*+$02
sC818   JMP DrawProgressDisplayScreen

hiScoreTablePtr   .TEXT "0068000"
canAwardBonus   .TEXT "YAK "
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT  "0065535RATT"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT  "00491"
        .TEXT "52WULF"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0032768INCA"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "003"
        .TEXT "0000MAT "
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0025000PSY "
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0"
        .TEXT "020000TAK "
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0016384GOAT"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT $00
        .TEXT "0010000PINK"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0009000FLYD"
        .BYTE $00,$00,$00,$00,$00,$00,$00
        .TEXT $00,$00,$00
        .TEXT "0008192LED "
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0007000ZEP "
        .BYTE $00,$00,$00,$00,$00
        .TEXT $00,$00,$00,$00,$00
        .TEXT "0006000MACH"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0005000SCUM"
        .BYTE $00,$00,$00
        .TEXT $00,$00,$00,$00,$00,$00,$00
        .TEXT "0004096TREV"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0003000MARK"
        .BYTE $00
        .TEXT $00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0002000MAH "
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .TEXT "0001000INT"
        .TEXT "I"
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
ptrSecondLastScoreInTable   .TEXT "0000900GIJO", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ptrLastScoreInTable   .TEXT "0000800LAMA", $00, $00, $00, $00, $00, $00, $00, $00, $00
        .BYTE $00,$FF
;-------------------------------
; jC9C0
;-------------------------------
jC9C0   
        STX aFD
        LDA #$00
        STA aCC88
        STY aFC
;-------------------------------
; DrawHiScoreScreen
;-------------------------------
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
bC9EA   LDA (pFE),Y
        STA fC802,Y
        DEY 
        BNE bC9EA
        LDY #$09
bC9F4   LDA (pFC),Y
        STA fC80E,Y
        DEY 
        BPL bC9F4
        LDY #$00
        LDA #<hiScoreTablePtr
        STA aFE
        LDA #>hiScoreTablePtr
        STA aFF
        LDX #$00
        LDA #$14
        STA aFB
bCA0C   LDA (pFE),Y
        CMP lastBlastScore,X
        BEQ bCA18
        BPL bCA1E
        JMP StoreLastBlastInTable

bCA18   INY 
        INX 
        CPY #$07
        BNE bCA0C
bCA1E   LDA aFE
        CLC 
        ADC #$15
        STA aFE
        LDA aFF
        ADC #$00
        STA aFF
        LDY #$00
        LDX #$00
        DEC aFB
        BNE bCA18
        LDA #$00
        STA aCA3B
        JMP ClearScreenDrawHiScoreScreenText

aCA3B   .BYTE $00
;-------------------------------
; StoreLastBlastInTable
;-------------------------------
StoreLastBlastInTable   
        LDA #$01
        STA aFA
        LDA aFB
        CMP #$01
        BNE bCA51
        LDA #<ptrLastScoreInTable
        STA aFC
        LDA #>ptrLastScoreInTable
        STA aFD
        JMP StoreLastBlasScoreInTable

bCA51   LDA #<ptrSecondLastScoreInTable
        STA aFC
        LDA #>ptrSecondLastScoreInTable
        STA aFD

jCA59   
        LDY #$00
bCA5B   LDA (pFC),Y
        STA aF9
        TYA 
        PHA 
        CLC 
        ADC #$15
        TAY 
        LDA aF9
        STA (pFC),Y
        PLA 
        TAY 
        INY 
        CPY #$15
        BNE bCA5B

        INC aFA
        LDA aFA
        CMP aFB
        BEQ StoreLastBlasScoreInTable
        LDA aFC
        SEC 
        SBC #$15
        STA aFC
        LDA aFD
        SBC #$00
        STA aFD
        JMP jCA59

;-------------------------------
; StoreLastBlasScoreInTable
;-------------------------------
StoreLastBlasScoreInTable   
        LDA #$01
        STA aCA3B
        LDY #$14
bCA8F   LDA lastBlastScore,Y
        STA (pFC),Y
        DEY 
        BPL bCA8F
        LDA aFC
        PHA 
        LDA aFD
        PHA 
;-------------------------------
; ClearScreenDrawHiScoreScreenText
;-------------------------------
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
        STA aFE
        LDA #>hiScoreTablePtr
        STA aFF
        LDY #$00
bCAE8   LDA fCB30,Y
        STA aFC
        LDA fCB44,Y
        STA aFD
        TYA 
        PHA 
        LDY #$00
bCAF6   LDA (pFE),Y
        AND #$3F
        STA (pFC),Y
        INY 
        CPY #$07
        BNE bCAF6
        LDA aFC
        CLC 
        ADC #$03
        STA aFC
        LDA aFD
        ADC #$00
        STA aFD
bCB0E   LDA (pFE),Y
        AND #$3F
        STA (pFC),Y
        INY 
        CPY #$0B
        BNE bCB0E
        PLA 
        TAY 
        LDA aFE
        CLC 
        ADC #$15
        STA aFE
        LDA aFF
        ADC #$00
        STA aFF
        INY 
        CPY #$14
        BNE bCAE8
        JMP ClearScreenDrawHiScoreTextContinued

fCB30   .BYTE $A1,$C9,$F1,$19,$41,$69,$91,$B9
        .BYTE $E1,$09,$B5,$DD,$05,$2D,$55,$7D
        .BYTE $A5,$CD,$F5,$1D
fCB44   .BYTE $04,$04,$04,$05,$05,$05,$05,$05
        .BYTE $05,$06,$04,$04,$05,$05,$05,$05
        .BYTE $05,$05,$05,$06
;-------------------------------
; ClearScreenDrawHiScoreTextContinued
;-------------------------------
ClearScreenDrawHiScoreTextContinued   
        LDA aCA3B
        BNE bCB60
        JMP DisplayHiScoreScreen

bCB60   PLA 
        STA aFD
        PLA 
        STA aFC
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
        LDA fCB30,X
        STA aFE
        LDA fCB44,X
        STA aFF
        LDY #$0A
fCB86   =*+$01
bCB85   JSR HiScore_sCB94
        INY 
        CPY #$0E
        BNE bCB85
        JMP DisplayHiScoreScreen

        .BYTE $59,$41,$4B,$20
;-------------------------------
; HiScore_sCB94
;-------------------------------
HiScore_sCB94   
        LDA fCB86,Y
        AND #$3F
        STA (pFE),Y
        STA aF8
        TYA 
        PHA 
        SEC 
        SBC #$03
        TAY 
        LDA aF8
        STA (pFC),Y
        PLA 
        TAY 
        LDA $DC00    ;CIA1: Data Port Register A
        STA aFA
        AND #$04
        BNE bCBC4
        LDA fCB86,Y
        SEC 
        SBC #$01
        CMP #$FF
        BNE bCBBC
bCBBC   STA fCB86,Y
        LDA #$3F
        JMP jCBD9

bCBC4   LDA aFA
        AND #$08
        BNE bCBE9
        LDA fCB86,Y
        CLC 
        ADC #$01
        CMP #$40
        BNE bCBD6
        LDA #$00
bCBD6   STA fCB86,Y

jCBD9   
        LDA #$50
        STA aF9
        LDX #$00
bCBDF   DEX 
        BNE bCBDF
        DEC aF9
        BNE bCBDF
        JMP HiScore_sCB94

bCBE9   LDA aFA
        AND #$10
        BNE HiScore_sCB94
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

;-------------------------------
; DisplayHiScoreScreen
;-------------------------------
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

jCC1B   
        LDX aCC87
        LDA fCB30,X
        STA aFE
        LDA fCB44,X
        STA aFF
        LDY #$10
        LDA #$25
        STA (pFE),Y

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
        DEC aCC87
        BPL bCC53
        LDA #$13
        STA aCC87
bCC53   LDA #$50
        STA aF9
        LDX #$00
bCC59   DEX 
        BNE bCC59
        DEC aF9
        BNE bCC59
        LDA #$20
        STA (pFE),Y
bCC64   JMP jCC1B

bCC67   LDA aFA
        AND #$02
        BNE bCC7E
        INC aCC87
        LDA aCC87
        CMP #$14
        BNE bCC53
        LDA #$00
        STA aCC87
        BEQ bCC53
bCC7E   LDA aFA
        AND #$10
        BNE bCC64
        JMP ExitHiScoreScreen

aCC87   .BYTE $00
aCC88   .BYTE $01
;-------------------------------
; ExitHiScoreScreen
;-------------------------------
ExitHiScoreScreen   
        LDX #$F8
        TXS 
bCC8C   LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ bCC8C
        JMP MainControlLoop

;-------------------------------
; SetupHiScoreScreen
;-------------------------------
SetupHiScoreScreen   
        LDX aCC87
        LDA #<hiScoreTablePtr
        STA aFC
        LDA #>hiScoreTablePtr
        STA aFD
        CPX #$00
        BEQ bCCB5
bCCA5   LDA aFC
        CLC 
        ADC #$15
        STA aFC
        LDA aFD
        ADC #$00
        STA aFD
        DEX 
        BNE bCCA5
bCCB5   LDY #$0B
bCCB7   LDA (pFC),Y
        STA aF8
        TYA 
        PHA 
        SEC 
        SBC #$0B
        TAY 
        LDA aF8
        STA (pF0),Y
        PLA 
        TAY 
        INY 
        CPY #$15
        BNE bCCB7
        LDA aFC
        PHA 
        LDA aFD
        PHA 
        DEC aCD4B
        JSR sC818
        PLA 
        STA aFD
        PLA 
        STA aFC
        LDX #$27
bCCE0   LDA fCCED,X
        AND #$3F
        STA SCREEN_RAM + $02F8,X
        DEX 
        BPL bCCE0
        BMI bCD15

fCCED   .BYTE $47,$41,$4D,$45,$20,$43,$4F,$4D
        .BYTE $50,$4C,$45,$54,$49,$4F,$4E,$20
        .BYTE $43,$48,$41,$52,$54,$20,$46,$4F
        .BYTE $52,$20,$5A,$41,$52,$44,$2C,$20
        .BYTE $54,$48,$45,$20,$48,$45,$52,$4F

bCD15   LDY #$07
        LDX #$00
bCD19   LDA (pFC),Y
        AND #$3F
        STA SCREEN_RAM + $0312,X
        INY 
        INX 
        CPX #$04
        BNE bCD19
        LDY #$06
bCD28   LDA (pFC),Y
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
;-------------------------------
; HiScoreScreeInterruptHandler
; Paints the color effects on the hi-score screen
;-------------------------------
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

bCD59
        LDA #$01
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

currHiScoreColorSeq1  .BYTE $1C
currHiScoreColorSeq2  .BYTE $0C
hiScoreColorSequence  .BYTE $0B,$0B,$0B,$0B,$0C,$0C,$0C,$0C
                      .BYTE $0F,$0F,$0F,$0F,$01,$01,$01,$01
hiScoreColorSequence2 .BYTE $02,$02,$08,$08,$08,$07,$07,$07
                      .BYTE $05,$05,$05,$0E,$0E,$0E,$07,$07
txtHiScorLine1        .TEXT "YAK'S GREAT GILBIES OF OUR TIME..... % %"
txtHiScorLine2        .TEXT "LEFT AND RIGHT TO SELECT, FIRE TO ENTER."
txtHiScorLine3        .TEXT "UP AND DOWN, SPACE FOR RECORD, FIRE QUIT"
txtHiScorLine4        .TEXT "THE SCORE FOR THE LAST BLAST WAS 0000000"

aCE92   .BYTE $00
aCE93   .BYTE $00
aCE94   .BYTE $00
;-------------------------------
; HiScoreCheckInput
;-------------------------------
HiScoreCheckInput   
        DEC aCE92
        BEQ bCEAC
bCE9A   LDA $DC00    ;CIA1: Data Port Register A
        AND #$0F
        CMP #$0F
        BEQ bCEA8
        LDA #$04
        STA aCE94
bCEA8   LDA $DC00    ;CIA1: Data Port Register A
        RTS 

bCEAC   DEC aCE93
        BNE bCE9A
        DEC aCE94
        BNE bCE9A
        JMP ExitHiScoreScreen

;-------------------------------
; HiScoreStopSounds
;-------------------------------
HiScoreStopSounds   
        STA $D020    ;Border Color
        LDA #$80
        STA $D404    ;Voice 1: Control Register
        STA $D40B    ;Voice 2: Control Register
        STA $D412    ;Voice 3: Control Register
        LDA #$04
        STA aCE94
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
