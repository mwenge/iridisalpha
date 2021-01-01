;
; **** ZP FIELDS **** 
;
f00 = $00
f33 = $33
f36 = $36
;
; **** ZP ABSOLUTE ADRESSES **** 
;
a00 = $00
a01 = $01
a14 = $14
a15 = $15
CharSetPtrLo = $FC
CharSetPtrHi = $FD
aFF = $FF
;
; **** ZP POINTERS **** 
;
p14 = $14
p2C = $2C
;
; **** FIELDS **** 
;
f0333 = $0333
f0522 = $0522
f0800 = $0800
f3540 = $3540
f9322 = $9322
;
; **** ABSOLUTE ADRESSES **** 
;
a0031 = $0031
a036D = $036D
a038C = $038C
a3A30 = $3A30
;
; **** POINTERS **** 
;
p05 = $0005
;
; **** EXTERNAL JUMPS **** 
;
CopyCharSetData = $0384
eA8BC = $A8BC

        * = $0801

;--------------------------------------------------------               
; Start executing at position $0811 (2065)
;--------------------------------------------------------               
        ; 10 SYS 2065
b0801
        .BYTE $0F,$08,$CF,$07,$9E,$32,$30,$36
        .BYTE $35,$20,$41,$42,$43,$00,$00

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

        JMP CopyCodeCharSetAndSpriteData

        ; The routine is a series of BASIC Statetments

        .BYTE $0F,$0F,$0F ;SLO $0F0F
        .BYTE $3A    ;NOP 
        .BYTE $97,$35 ;SAX f35,Y
        .BYTE $33,$32 ;RLA (p32),Y
        .BYTE $37,$37 ;RLA $37,X
        BIT a3A30
        .BYTE $97,$35 ;SAX f35,Y
        .BYTE $33,$32 ;RLA (p32),Y
        .BYTE $37,$36 ;RLA f36,X
        BIT @wa0031
        LSR $0A08
        BRK #$97
        AND f33,X
        .BYTE $32    ;JAM 
        SEC 
        BMI b086A
b083F   =*+$01
        BMI b087A
        .BYTE $97,$35 ;SAX f35,Y
        .BYTE $33,$32 ;RLA (p32),Y
        SEC 
        AND (p2C),Y
        BMI $0883
        STA f9322,Y
        .BYTE $22    ;JAM 
        BRK #$94
        PHP 
        .BYTE $14,$00 ;NOP f00,X
        STA f0522,Y
        ORA (p14),Y
        .BYTE $0F,$1D

b086A = *+$11
b087A = *+$21
        .TEXT "A 'LITTLE SOMETHING' FROM IRIDIS-ALPHA"

        .BYTE $13,$22,$3B                                                       ; ";              ; 0X882
        .BYTE $00                                                               ;                  ; 0X883
        .BYTE $BC,$08,$1E                                                       ; LOG             ; 0X886
        .BYTE $00                                                               ;                  ; 0X887
        .BYTE $97,$35,$33,$32,$36,$34,$2C,$30,$3A                               ; POKE 53264,0:    ; 0X890
        .BYTE $97,$35,$33,$32,$38,$37,$2C,$38,$3A                               ; POKE 53287,8:    ; 0X899
        .BYTE $97,$35,$33,$32,$38,$35,$2C,$32,$3A                               ; POKE 53285,2:    ; 0X8A2
        .BYTE $97,$35,$33,$32,$38,$36,$2C,$31                                   ; POKE 53286,1     ; 0X8AA
        .BYTE $00,$D4,$08,$28                                                   ; (               ; 0X8AE
        .BYTE $00                                                               ;                  ; 0X8AF
        .BYTE $97,$32,$30,$34,$30,$2C,$32,$31,$31,$3A                           ; POKE 2040,211:   ; 0X8B9
        .BYTE $97,$35,$33,$32,$34,$39,$2C,$36,$30                               ; POKE 53249,60    ; 0X8C2
        .BYTE $00,$F5,$08,$32                                                   ; 2               ; 0X8C6
        .BYTE $00                                                               ;                  ; 0X8C7
        .BYTE $81,$58                                                           ; FOR X            ; 0X8C9
        .BYTE $B2,$30                                                           ; = 0              ; 0X8CB
        .BYTE $A4,$32,$33,$30,$3A                                               ; TO 230:          ; 0X8D0
        .BYTE $97,$35,$33,$32,$34,$38,$2C,$58,$3A                               ; POKE 53248,X:    ; 0X8D9
        .BYTE $81,$44                                                           ; FOR D            ; 0X8DB
        .BYTE $B2,$31                                                           ; = 1              ; 0X8DD
        .BYTE $A4,$35,$3A                                                       ; TO 5:            ; 0X8E0
        .BYTE $82,$3A                                                           ; NEXT :           ; 0X8E2
        .BYTE $82                                                               ; NEXT             ; 0X8E3
        .BYTE $00,$19,$09,$3C                                                   ; 	<              ; 0X8E7
        .BYTE $00                                                               ;                  ; 0X8E8
        .BYTE $81,$58                                                           ; FOR X            ; 0X8EA
        .BYTE $B2,$32,$33,$31                                                   ; = 231            ; 0X8EE
        .BYTE $A4,$32,$34,$30,$3A                                               ; TO 240:          ; 0X8F3
        .BYTE $97,$35,$33,$32,$34,$38,$2C,$58,$3A                               ; POKE 53248,X:    ; 0X8FC
        .BYTE $81,$44                                                           ; FOR D            ; 0X8FE
        .BYTE $B2,$31                                                           ; = 1              ; 0X900
        .BYTE $A4,$35,$30,$3A                                                   ; TO 50:           ; 0X904
        .BYTE $82,$3A                                                           ; NEXT :           ; 0X906
        .BYTE $82                                                               ; NEXT             ; 0X907
        .BYTE $00,$3E,$09,$46                                                   ; >	F              ; 0X90B
        .BYTE $00                                                               ;                  ; 0X90C
        .BYTE $8C,$3A                                                           ; RESTORE :        ; 0X90E
        .BYTE $81,$58                                                           ; FOR X            ; 0X910
        .BYTE $B2,$30                                                           ; = 0              ; 0X912
        .BYTE $A4,$32,$3A                                                       ; TO 2:            ; 0X915
        .BYTE $87,$41,$3A                                                       ; READ A:          ; 0X918
        .BYTE $97,$32,$30,$34,$30,$2C,$41,$3A                                   ; POKE 2040,A:     ; 0X920
        .BYTE $81,$44                                                           ; FOR D            ; 0X922
        .BYTE $B2,$31                                                           ; = 1              ; 0X924
        .BYTE $A4,$31,$35,$30,$3A                                               ; TO 150:          ; 0X929
        .BYTE $82,$3A                                                           ; NEXT :           ; 0X92B
        .BYTE $82                                                               ; NEXT             ; 0X92C
        .BYTE $00,$57,$09,$50                                                   ; W	P              ; 0X930
        .BYTE $00                                                               ;                  ; 0X931
        .BYTE $83,$32,$31,$31,$2C,$32,$31,$30,$2C,$32,$30,$37,$2C,$32,$30,$38,$2C,$32,$30,$39  ; DATA 211,210,207,208,209 ; 0X945
        .BYTE $00,$7E,$09,$55                                                   ; ~	U              ; 0X949
        .BYTE $00                                                               ;                  ; 0X94A
        .BYTE $81,$47                                                           ; FOR G            ; 0X94C
        .BYTE $B2,$32,$30,$37                                                   ; = 207            ; 0X950
        .BYTE $A4,$32,$30,$33                                                   ; TO 203           ; 0X954
        .BYTE $A9                                                               ; STEP             ; 0X955
        .BYTE $AB,$31,$3A                                                       ; - 1:             ; 0X958
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A                                   ; POKE 2040,G:     ; 0X960
        .BYTE $81,$44                                                           ; FOR D            ; 0X962
        .BYTE $B2,$31                                                           ; = 1              ; 0X964
        .BYTE $A4,$32,$35,$30,$3A                                               ; TO 250:          ; 0X969
        .BYTE $82,$3A                                                           ; NEXT :           ; 0X96B
        .BYTE $82                                                               ; NEXT             ; 0X96C
        .BYTE $00                                                               ;                  ; 0X96D
        .BYTE $A0,$09,$5A                                                       ; CLOSE 	Z         ; 0X970
        .BYTE $00                                                               ;                  ; 0X971
        .BYTE $81,$59                                                           ; FOR Y            ; 0X973
        .BYTE $B2,$36,$30                                                       ; = 60             ; 0X976
        .BYTE $A4,$31,$30,$30,$3A                                               ; TO 100:          ; 0X97B
        .BYTE $97,$35,$33,$32,$34,$39,$2C,$59,$3A                               ; POKE 53249,Y:    ; 0X984
        .BYTE $81,$44                                                           ; FOR D            ; 0X986
        .BYTE $B2,$31                                                           ; = 1              ; 0X988
        .BYTE $A4,$35,$3A                                                       ; TO 5:            ; 0X98B
        .BYTE $82,$3A                                                           ; NEXT :           ; 0X98D
        .BYTE $82                                                               ; NEXT             ; 0X98E
        .BYTE $00                                                               ;                  ; 0X98F
        .BYTE $BA,$09,$64                                                       ; SQR 	d           ; 0X992
        .BYTE $00                                                               ;                  ; 0X993
        .BYTE $81,$59                                                           ; FOR Y            ; 0X995
        .BYTE $B2,$31,$30,$30                                                   ; = 100            ; 0X999
        .BYTE $A4,$31,$35,$30,$3A                                               ; TO 150:          ; 0X99E
        .BYTE $97,$35,$33,$32,$34,$39,$2C,$59,$3A                               ; POKE 53249,Y:    ; 0X9A7
        .BYTE $82                                                               ; NEXT             ; 0X9A8
        .BYTE $00,$D6,$09,$6E                                                   ; n                ; 0X9AC
        .BYTE $00                                                               ;                  ; 0X9AD
        .BYTE $81,$59                                                           ; FOR Y            ; 0X9AF
        .BYTE $B2,$31,$35,$30                                                   ; = 150            ; 0X9B3
        .BYTE $A4,$31,$39,$36                                                   ; TO 196           ; 0X9B7
        .BYTE $A9,$32,$3A                                                       ; STEP 2:          ; 0X9BA
        .BYTE $97,$35,$33,$32,$34,$39,$2C,$59,$3A                               ; POKE 53249,Y:    ; 0X9C3
        .BYTE $82                                                               ; NEXT             ; 0X9C4
        .BYTE $00,$03,$0A,$78                                                   ; 
        x              ; 0X9C8
        .BYTE $00                                                               ;                  ; 0X9C9
        .BYTE $81,$43                                                           ; FOR C            ; 0X9CB
        .BYTE $B2,$30                                                           ; = 0              ; 0X9CD
        .BYTE $A4,$32,$3A                                                       ; TO 2:            ; 0X9D0
        .BYTE $81,$47                                                           ; FOR G            ; 0X9D2
        .BYTE $B2,$32,$30,$30                                                   ; = 200            ; 0X9D6
        .BYTE $A4,$32,$30,$33,$3A                                               ; TO 203:          ; 0X9DB
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A                                   ; POKE 2040,G:     ; 0X9E3
        .BYTE $81,$44                                                           ; FOR D            ; 0X9E5
        .BYTE $B2,$31                                                           ; = 1              ; 0X9E7
        .BYTE $A4,$31,$30,$30,$3A                                               ; TO 100:          ; 0X9EC
        .BYTE $82,$3A                                                           ; NEXT :           ; 0X9EE
        .BYTE $82,$3A                                                           ; NEXT :           ; 0X9F0
        .BYTE $82                                                               ; NEXT             ; 0X9F1
        .BYTE $00,$35,$0A                                                       ; 5                ; 0X9F4
        .BYTE $82                                                               ; NEXT             ; 0X9F5
        .BYTE $00,$47                                                           ; G                ; 0X9F7
        .BYTE $B2,$31,$39,$33,$3A                                               ; = 193:           ; 0X9FC
        .BYTE $81,$58                                                           ; FOR X            ; 0X9FE
        .BYTE $B2,$32,$34,$30                                                   ; = 240            ; 0XA02
        .BYTE $A4,$34,$31                                                       ; TO 41            ; 0XA05
        .BYTE $A9                                                               ; STEP             ; 0XA06
        .BYTE $AB,$31,$3A                                                       ; - 1:             ; 0XA09
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A,$47                               ; POKE 2040,G:G    ; 0XA12
        .BYTE $B2,$47                                                           ; = G              ; 0XA14
        .BYTE $AA,$31,$3A                                                       ; + 1:             ; 0XA17
        .BYTE $8B,$47                                                           ; IF G             ; 0XA19
        .BYTE $B1,$31,$39,$39                                                   ; > 199            ; 0XA1D
        .BYTE $A7,$47                                                           ; THEN G           ; 0XA1F
        .BYTE $B2,$31,$39,$33                                                   ; = 193            ; 0XA23
        .BYTE $00,$4E,$0A                                                       ; N                ; 0XA26
        .BYTE $8C                                                               ; RESTORE          ; 0XA27
        .BYTE $00                                                               ;                  ; 0XA28
        .BYTE $97,$35,$33,$32,$34,$38,$2C,$58,$3A                               ; POKE 53248,X:    ; 0XA31
        .BYTE $81,$44                                                           ; FOR D            ; 0XA33
        .BYTE $B2,$31                                                           ; = 1              ; 0XA35
        .BYTE $A4,$31,$30,$3A                                                   ; TO 10:           ; 0XA39
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XA3B
        .BYTE $82                                                               ; NEXT             ; 0XA3C
        .BYTE $00,$7B,$0A                                                       ; {                ; 0XA3F
        .BYTE $96                                                               ; DEF              ; 0XA40
        .BYTE $00                                                               ;                  ; 0XA41
        .BYTE $81,$43                                                           ; FOR C            ; 0XA43
        .BYTE $B2,$30                                                           ; = 0              ; 0XA45
        .BYTE $A4,$32,$3A                                                       ; TO 2:            ; 0XA48
        .BYTE $81,$47                                                           ; FOR G            ; 0XA4A
        .BYTE $B2,$32,$30,$30                                                   ; = 200            ; 0XA4E
        .BYTE $A4,$32,$30,$33,$3A                                               ; TO 203:          ; 0XA53
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A                                   ; POKE 2040,G:     ; 0XA5B
        .BYTE $81,$44                                                           ; FOR D            ; 0XA5D
        .BYTE $B2,$31                                                           ; = 1              ; 0XA5F
        .BYTE $A4,$32,$30,$30,$3A                                               ; TO 200:          ; 0XA64
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XA66
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XA68
        .BYTE $82                                                               ; NEXT             ; 0XA69
        .BYTE $00                                                               ;                  ; 0XA6A
        .BYTE $A2,$0A                                                           ; NEW              ; 0XA6C
        .BYTE $A0                                                               ; CLOSE            ; 0XA6D
        .BYTE $00,$47                                                           ; G                ; 0XA6F
        .BYTE $B2,$31,$39,$39,$3A                                               ; = 199:           ; 0XA74
        .BYTE $81,$58                                                           ; FOR X            ; 0XA76
        .BYTE $B2,$34,$31                                                       ; = 41             ; 0XA79
        .BYTE $A4,$32,$34,$30,$3A,$47                                           ; TO 240:G         ; 0XA7F
        .BYTE $B2,$47                                                           ; = G              ; 0XA81
        .BYTE $AB,$31,$3A                                                       ; - 1:             ; 0XA84
        .BYTE $8B,$47                                                           ; IF G             ; 0XA86
        .BYTE $B3,$31,$39,$33                                                   ; < 193            ; 0XA8A
        .BYTE $A7,$47                                                           ; THEN G           ; 0XA8C
        .BYTE $B2,$31,$39,$39                                                   ; = 199            ; 0XA90
        .BYTE $00                                                               ;                  ; 0XA91
        .BYTE $C3,$0A                                                           ; LEN              ; 0XA93
        .BYTE $AA                                                               ; +                ; 0XA94
        .BYTE $00                                                               ;                  ; 0XA95
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A                                   ; POKE 2040,G:     ; 0XA9D
        .BYTE $97,$35,$33,$32,$34,$38,$2C,$58,$3A                               ; POKE 53248,X:    ; 0XAA6
        .BYTE $81,$44                                                           ; FOR D            ; 0XAA8
        .BYTE $B2,$31                                                           ; = 1              ; 0XAAA
        .BYTE $A4,$32,$30,$3A                                                   ; TO 20:           ; 0XAAE
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XAB0
        .BYTE $82                                                               ; NEXT             ; 0XAB1
        .BYTE $00,$F1,$0A                                                       ;                  ; 0XAB4
        .BYTE $B4                                                               ; SGN              ; 0XAB5
        .BYTE $00                                                               ;                  ; 0XAB6
        .BYTE $81,$47                                                           ; FOR G            ; 0XAB8
        .BYTE $B2,$32,$30,$30                                                   ; = 200            ; 0XABC
        .BYTE $A4,$32,$30,$33,$3A                                               ; TO 203:          ; 0XAC1
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A                                   ; POKE 2040,G:     ; 0XAC9
        .BYTE $81,$44                                                           ; FOR D            ; 0XACB
        .BYTE $B2,$31                                                           ; = 1              ; 0XACD
        .BYTE $A4,$32,$30,$30,$3A                                               ; TO 200:          ; 0XAD2
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XAD4
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XAD6
        .BYTE $97,$32,$30,$34,$30,$2C,$32,$30,$30                               ; POKE 2040,200    ; 0XADF
        .BYTE $00,$0E,$0B                                                       ;                 ; 0XAE2
        .BYTE $BE                                                               ; COS              ; 0XAE3
        .BYTE $00                                                               ;                  ; 0XAE4
        .BYTE $81,$59                                                           ; FOR Y            ; 0XAE6
        .BYTE $B2,$31,$39,$36                                                   ; = 196            ; 0XAEA
        .BYTE $A4,$31,$30,$30                                                   ; TO 100           ; 0XAEE
        .BYTE $A9                                                               ; STEP             ; 0XAEF
        .BYTE $AB,$31,$3A                                                       ; - 1:             ; 0XAF2
        .BYTE $97,$35,$33,$32,$34,$39,$2C,$59,$3A                               ; POKE 53249,Y:    ; 0XAFB
        .BYTE $82                                                               ; NEXT             ; 0XAFC
        .BYTE $00,$32,$0B                                                       ; 2                ; 0XAFF
        .BYTE $C8                                                               ; LEFT             ; 0XB00
        .BYTE $00                                                               ;                  ; 0XB01
        .BYTE $81,$47                                                           ; FOR G            ; 0XB03
        .BYTE $B2,$32,$30,$33                                                   ; = 203            ; 0XB07
        .BYTE $A4,$32,$30,$37,$3A                                               ; TO 207:          ; 0XB0C
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A                                   ; POKE 2040,G:     ; 0XB14
        .BYTE $81,$44                                                           ; FOR D            ; 0XB16
        .BYTE $B2,$30                                                           ; = 0              ; 0XB18
        .BYTE $A4,$32,$35,$30,$3A                                               ; TO 250:          ; 0XB1D
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XB1F
        .BYTE $82                                                               ; NEXT             ; 0XB20
        .BYTE $00,$4E,$0B,$D2                                                   ; N                ; 0XB24
        .BYTE $00                                                               ;                  ; 0XB25
        .BYTE $81,$59                                                           ; FOR Y            ; 0XB27
        .BYTE $B2,$31,$30,$30                                                   ; = 100            ; 0XB2B
        .BYTE $A4,$36,$30                                                       ; TO 60            ; 0XB2E
        .BYTE $A9                                                               ; STEP             ; 0XB2F
        .BYTE $AB,$31,$3A                                                       ; - 1:             ; 0XB32
        .BYTE $97,$35,$33,$32,$34,$39,$2C,$59,$3A                               ; POKE 53249,Y:    ; 0XB3B
        .BYTE $82                                                               ; NEXT             ; 0XB3C
        .BYTE $00,$71,$0B,$DC                                                   ; q                ; 0XB40
        .BYTE $00                                                               ;                  ; 0XB41
        .BYTE $81,$43                                                           ; FOR C            ; 0XB43
        .BYTE $B2,$30                                                           ; = 0              ; 0XB45
        .BYTE $A4,$31,$3A                                                       ; TO 1:            ; 0XB48
        .BYTE $87,$47,$3A                                                       ; READ G:          ; 0XB4B
        .BYTE $97,$32,$30,$34,$30,$2C,$47,$3A                                   ; POKE 2040,G:     ; 0XB53
        .BYTE $81,$44                                                           ; FOR D            ; 0XB55
        .BYTE $B2,$30                                                           ; = 0              ; 0XB57
        .BYTE $A4,$32,$30,$30,$3A                                               ; TO 200:          ; 0XB5C
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XB5E
        .BYTE $82                                                               ; NEXT             ; 0XB5F
        .BYTE $00                                                               ;                  ; 0XB60
        .BYTE $8C,$0B,$E6                                                       ; RESTORE          ; 0XB63
        .BYTE $00                                                               ;                  ; 0XB64
        .BYTE $81,$58                                                           ; FOR X            ; 0XB66
        .BYTE $B2,$32,$34,$30                                                   ; = 240            ; 0XB6A
        .BYTE $A4,$30                                                           ; TO 0             ; 0XB6C
        .BYTE $A9                                                               ; STEP             ; 0XB6D
        .BYTE $AB,$32,$3A                                                       ; - 2:             ; 0XB70
        .BYTE $97,$35,$33,$32,$34,$38,$2C,$58,$3A                               ; POKE 53248,X:    ; 0XB79
        .BYTE $82                                                               ; NEXT             ; 0XB7A
        .BYTE $00                                                               ;                  ; 0XB7B
        .BYTE $9F,$0B,$F0                                                       ; OPEN             ; 0XB7E
        .BYTE $00                                                               ;                  ; 0XB7F
        .BYTE $81,$44                                                           ; FOR D            ; 0XB81
        .BYTE $B2,$31                                                           ; = 1              ; 0XB83
        .BYTE $A4,$31,$30,$04,$0F,$3A                                           ; TO 10:         ; 0XB89
        .BYTE $82,$3A                                                           ; NEXT :           ; 0XB8B
        .BYTE $8A                                                               ; RUN              ; 0XB8C
        .BYTE $00

        .BYTE $FF,$0F,$00,$FF
        .BYTE $0F,$00,$FF,$0F,$00,$FF,$0F,$00
        .BYTE $FF,$0F,$00,$FF,$0F,$00,$FF,$0F
        .BYTE $00,$FF,$0F,$00,$FF,$0F,$00,$FF
        .BYTE $0F,$00,$FF,$0F,$00,$FF,$0F,$00
        .BYTE $FF,$0F,$00,$FF,$0F,$00,$FF,$0F
        .BYTE $00,$FF,$0F,$00,$FF,$0F,$00,$FF
        .BYTE $0F,$00,$FF,$0F,$00,$FF,$0F,$00
        .BYTE $76,$0F

        ;Start Of CharSet Data
        .BYTE $FF,$00,$FF,$00,$00,$FF,$00,$FF   ;.BYTE $FF,$00,$FF,$00,$00,$FF,$00,$FF
                                                ; CHARACTER $00
                                                ; 11111111   ********
                                                ; 00000000           
                                                ; 11111111   ********
                                                ; 00000000           
                                                ; 00000000           
                                                ; 11111111   ********
                                                ; 00000000           
                                                ; 11111111   ********

        .BYTE $3C,$66,$C6,$DE,$C6,$04,$0F       ;.BYTE $3C,$66,$C6,$DE,$C6,$C6,$C6,$C6
                                                ; CHARACTER $01
                                                ; 00111100     ****  
                                                ; 01100110    **  ** 
                                                ; 11000110   **   ** 
                                                ; 11011110   ** **** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 

        .BYTE $FC,$C6,$C6,$DC,$C6,$C6,$C6,$DC   ;.BYTE $FC,$C6,$C6,$DC,$C6,$C6,$C6,$DC
                                                ; CHARACTER $02
                                                ; 11111100   ******  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11011100   ** ***  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11011100   ** ***  

        .BYTE $3C,$66,$C0,$04,$0F,$C6,$7C       ;.BYTE $3C,$66,$C0,$C0,$C0,$C0,$C6,$7C
                                                ; CHARACTER $03
                                                ; 00111100     ****  
                                                ; 01100110    **  ** 
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000110   **   ** 
                                                ; 01111100    *****  

        .BYTE $F8,$CC,$C6,$04,$0F,$CC,$D8       ;.BYTE $F8,$CC,$C6,$C6,$C6,$C6,$CC,$D8
                                                ; CHARACTER $04
                                                ; 11111000   *****   
                                                ; 11001100   **  **  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11001100   **  **  
                                                ; 11011000   ** **   

        .BYTE $FE,$C0,$C0,$D8,$C0,$C0,$C0,$DE   ;.BYTE $FE,$C0,$C0,$D8,$C0,$C0,$C0,$DE
                                                ; CHARACTER $05
                                                ; 11111110   ******* 
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11011000   ** **   
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11011110   ** **** 

        .BYTE $FE,$C0,$C0,$D8,$C0,$04,$0F       ;.BYTE $FE,$C0,$C0,$D8,$C0,$C0,$C0,$C0
                                                ; CHARACTER $06
                                                ; 11111110   ******* 
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11011000   ** **   
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      

        .BYTE $3C,$66,$C0,$C0,$DE,$C6,$C6,$7C   ;.BYTE $3C,$66,$C0,$C0,$DE,$C6,$C6,$7C
                                                ; CHARACTER $07
                                                ; 00111100     ****  
                                                ; 01100110    **  ** 
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11011110   ** **** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 01111100    *****  

        .BYTE $C6,$C6,$C6,$DE,$C6,$04,$0F       ;.BYTE $C6,$C6,$C6,$DE,$C6,$C6,$C6,$C6
                                                ; CHARACTER $08
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11011110   ** **** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 

        .BYTE $3C,$18,$06,$0F,$3C               ;.BYTE $3C,$18,$18,$18,$18,$18,$18,$3C
                                                ; CHARACTER $09
                                                ; 00111100     ****  
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00111100     ****  

        .BYTE $3C,$18,$05,$0F,$30,$60           ;.BYTE $3C,$18,$18,$18,$18,$18,$30,$60
                                                ; CHARACTER $0a
                                                ; 00111100     ****  
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00110000     **    
                                                ; 01100000    **     

        .BYTE $C6,$C6,$CC,$D8,$CC,$C6,$C6,$C6   ;.BYTE $C6,$C6,$CC,$D8,$CC,$C6,$C6,$C6
                                                ; CHARACTER $0b
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11001100   **  **  
                                                ; 11011000   ** **   
                                                ; 11001100   **  **  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 

        .BYTE $C0,$07,$0F,$DE                   ;.BYTE $C0,$C0,$C0,$C0,$C0,$C0,$C0,$DE
                                                ; CHARACTER $0c
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11011110   ** **** 

        .BYTE $FE,$DB,$04,$0F,$C3,$C3,$C3       ;.BYTE $FE,$DB,$DB,$DB,$DB,$C3,$C3,$C3
                                                ; CHARACTER $0d
                                                ; 11111110   ******* 
                                                ; 11011011   ** ** **
                                                ; 11011011   ** ** **
                                                ; 11011011   ** ** **
                                                ; 11011011   ** ** **
                                                ; 11000011   **    **
                                                ; 11000011   **    **
                                                ; 11000011   **    **

        .BYTE $FC,$C6,$07,$0F                   ;.BYTE $FC,$C6,$C6,$C6,$C6,$C6,$C6,$C6
                                                ; CHARACTER $0e
                                                ; 11111100   ******  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 

        .BYTE $7C,$C6,$06,$0F,$5C               ;.BYTE $7C,$C6,$C6,$C6,$C6,$C6,$C6,$5C
                                                ; CHARACTER $0f
                                                ; 01111100    *****  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 01011100    * ***  

        .BYTE $FC,$C6,$C6,$DC,$C0,$04,$0F       ;.BYTE $FC,$C6,$C6,$DC,$C0,$C0,$C0,$C0
                                                ; CHARACTER $10
                                                ; 11111100   ******  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11011100   ** ***  
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      

        .BYTE $7C,$C6,$C6,$C6,$E6,$F6,$DE,$4C   ;.BYTE $7C,$C6,$C6,$C6,$E6,$F6,$DE,$4C
                                                ; CHARACTER $11
                                                ; 01111100    *****  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11100110   ***  ** 
                                                ; 11110110   **** ** 
                                                ; 11011110   ** **** 
                                                ; 01001100    *  **  

        .BYTE $FC,$C6,$C6,$DC,$CC,$C6,$C6,$C6   ;.BYTE $FC,$C6,$C6,$DC,$CC,$C6,$C6,$C6
                                                ; CHARACTER $12
                                                ; 11111100   ******  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11011100   ** ***  
                                                ; 11001100   **  **  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 

        .BYTE $7C,$C6,$60,$30,$18,$0C,$C6,$7C   ;.BYTE $7C,$C6,$60,$30,$18,$0C,$C6,$7C
                                                ; CHARACTER $13
                                                ; 01111100    *****  
                                                ; 11000110   **   ** 
                                                ; 01100000    **     
                                                ; 00110000     **    
                                                ; 00011000      **   
                                                ; 00001100       **  
                                                ; 11000110   **   ** 
                                                ; 01111100    *****  

        .BYTE $7E,$18,$07,$0F                   ;.BYTE $7E,$18,$18,$18,$18,$18,$18,$18
                                                ; CHARACTER $14
                                                ; 01111110    ****** 
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   

        .BYTE $C6,$07,$0F,$FC                   ;.BYTE $C6,$C6,$C6,$C6,$C6,$C6,$C6,$FC
                                                ; CHARACTER $15
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11111100   ******  

        .BYTE $C6,$06,$0F,$6C,$38               ;.BYTE $C6,$C6,$C6,$C6,$C6,$C6,$6C,$38
                                                ; CHARACTER $16
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 01101100    ** **  
                                                ; 00111000     ***   

        .BYTE $C3,$C3,$C3,$DB,$04,$0F,$FE       ;.BYTE $C3,$C3,$C3,$DB,$DB,$DB,$DB,$FE
                                                ; CHARACTER $17
                                                ; 11000011   **    **
                                                ; 11000011   **    **
                                                ; 11000011   **    **
                                                ; 11011011   ** ** **
                                                ; 11011011   ** ** **
                                                ; 11011011   ** ** **
                                                ; 11011011   ** ** **
                                                ; 11111110   ******* 

        .BYTE $C6,$6C,$38,$04,$0F,$6C,$C6,$04,$0F  ;.BYTE $C6,$6C,$38,$38,$38,$38,$6C,$C6
                                                ; CHARACTER $18
                                                ; 11000110   **   ** 
                                                ; 01101100    ** **  
                                                ; 00111000     ***   
                                                ; 00111000     ***   
                                                ; 00111000     ***   
                                                ; 00111000     ***   
                                                ; 01101100    ** **  
                                                ; 11000110   **   ** 

        .BYTE $7E,$06,$06,$C6,$7C               ;.BYTE $C6,$C6,$C6,$7E,$06,$06,$C6,$7C
                                                ; CHARACTER $19
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 01111110    ****** 
                                                ; 00000110        ** 
                                                ; 00000110        ** 
                                                ; 11000110   **   ** 
                                                ; 01111100    *****  

        .BYTE $FE,$0C,$18,$30,$60,$C0,$E6,$3C   ;.BYTE $FE,$0C,$18,$30,$60,$C0,$E6,$3C
                                                ; CHARACTER $1a
                                                ; 11111110   ******* 
                                                ; 00001100       **  
                                                ; 00011000      **   
                                                ; 00110000     **    
                                                ; 01100000    **     
                                                ; 11000000   **      
                                                ; 11100110   ***  ** 
                                                ; 00111100     ****  

        .BYTE $00,$78,$60,$04,$0F,$78,$00       ;.BYTE $00,$78,$60,$60,$60,$60,$78,$00
                                                ; CHARACTER $1b
                                                ; 00000000           
                                                ; 01111000    ****   
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 01111000    ****   
                                                ; 00000000           

        .BYTE $66,$C3,$7E,$5A,$7E,$7E,$3C,$00   ;.BYTE $66,$C3,$7E,$5A,$7E,$7E,$3C,$00
                                                ; CHARACTER $1c
                                                ; 01100110    **  ** 
                                                ; 11000011   **    **
                                                ; 01111110    ****** 
                                                ; 01011010    * ** * 
                                                ; 01111110    ****** 
                                                ; 01111110    ****** 
                                                ; 00111100     ****  
                                                ; 00000000           

        .BYTE $00,$78,$18,$04,$0F,$78,$00       ;.BYTE $00,$78,$18,$18,$18,$18,$78,$00
                                                ; CHARACTER $1d
                                                ; 00000000           
                                                ; 01111000    ****   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 01111000    ****   
                                                ; 00000000           

        .BYTE $00,$18,$3C,$7E,$00,$05,$0F       ;.BYTE $00,$18,$3C,$7E,$00,$00,$00,$00
                                                ; CHARACTER $1e
                                                ; 00000000           
                                                ; 00011000      **   
                                                ; 00111100     ****  
                                                ; 01111110    ****** 
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           

        .BYTE $10,$30,$70,$70,$30,$10,$00,$09,$0F  ;.BYTE $00,$10,$30,$70,$70,$30,$10,$00
                                                ; CHARACTER $1f
                                                ; 00000000           
                                                ; 00010000      *    
                                                ; 00110000     **    
                                                ; 01110000    ***    
                                                ; 01110000    ***    
                                                ; 00110000     **    
                                                ; 00010000      *    
                                                ; 00000000           

        .BYTE $68,$05,$0F                       ;.BYTE $00,$00,$00,$00,$00,$00,$00,$00
                                                ; CHARACTER $20
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           

        .BYTE $00,$68,$68                       ;.BYTE $68,$68,$68,$68,$68,$00,$68,$68
                                                ; CHARACTER $21
                                                ; 01101000    ** *   
                                                ; 01101000    ** *   
                                                ; 01101000    ** *   
                                                ; 01101000    ** *   
                                                ; 01101000    ** *   
                                                ; 00000000           
                                                ; 01101000    ** *   
                                                ; 01101000    ** *   

        .BYTE $36,$36,$00,$07,$0F               ;.BYTE $36,$36,$00,$00,$00,$00,$00,$00
                                                ; CHARACTER $22
                                                ; 00110110     ** ** 
                                                ; 00110110     ** ** 
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           

        .BYTE $66,$66,$18,$18,$66,$66,$00       ;.BYTE $00,$66,$66,$18,$18,$66,$66,$00
                                                ; CHARACTER $23
                                                ; 00000000           
                                                ; 01100110    **  ** 
                                                ; 01100110    **  ** 
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 01100110    **  ** 
                                                ; 01100110    **  ** 
                                                ; 00000000           

        .BYTE $7E,$2C,$42,$8F,$C7,$EB,$C7,$7E   ;.BYTE $7E,$2C,$42,$8F,$C7,$EB,$C7,$7E
                                                ; CHARACTER $24
                                                ; 01111110    ****** 
                                                ; 00101100     * **  
                                                ; 01000010    *    * 
                                                ; 10001111   *   ****
                                                ; 11000111   **   ***
                                                ; 11101011   *** * **
                                                ; 11000111   **   ***
                                                ; 01111110    ****** 

        .BYTE $60,$E0,$6C,$7E,$7F,$36,$66,$EE   ;.BYTE $60,$E0,$6C,$7E,$7F,$36,$66,$EE
                                                ; CHARACTER $25
                                                ; 01100000    **     
                                                ; 11100000   ***     
                                                ; 01101100    ** **  
                                                ; 01111110    ****** 
                                                ; 01111111    *******
                                                ; 00110110     ** ** 
                                                ; 01100110    **  ** 
                                                ; 11101110   *** *** 

        .BYTE $18,$18,$7E,$FF,$FF,$66,$66,$66   ;.BYTE $18,$18,$7E,$FF,$FF,$66,$66,$66
                                                ; CHARACTER $26
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 01111110    ****** 
                                                ; 11111111   ********
                                                ; 11111111   ********
                                                ; 01100110    **  ** 
                                                ; 01100110    **  ** 
                                                ; 01100110    **  ** 

        .BYTE $0C,$18,$00,$06,$0F               ;.BYTE $0C,$18,$00,$00,$00,$00,$00,$00
                                                ; CHARACTER $27
                                                ; 00001100       **  
                                                ; 00011000      **   
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           

        .BYTE $18,$30,$60,$04,$0F,$30,$18       ;.BYTE $18,$30,$60,$60,$60,$60,$30,$18
                                                ; CHARACTER $28
                                                ; 00011000      **   
                                                ; 00110000     **    
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 00110000     **    
                                                ; 00011000      **   

        .BYTE $30,$18,$0C,$04,$0F,$18,$30       ;.BYTE $30,$18,$0C,$0C,$0C,$0C,$18,$30
                                                ; CHARACTER $29
                                                ; 00110000     **    
                                                ; 00011000      **   
                                                ; 00001100       **  
                                                ; 00001100       **  
                                                ; 00001100       **  
                                                ; 00001100       **  
                                                ; 00011000      **   
                                                ; 00110000     **    

        .BYTE $00,$18,$00,$DB,$DB,$00,$18,$00   ;.BYTE $00,$18,$00,$DB,$DB,$00,$18,$00
                                                ; CHARACTER $2a
                                                ; 00000000           
                                                ; 00011000      **   
                                                ; 00000000           
                                                ; 11011011   ** ** **
                                                ; 11011011   ** ** **
                                                ; 00000000           
                                                ; 00011000      **   
                                                ; 00000000           

        .BYTE $18,$18,$18,$FF,$FF,$18,$18,$18   ;.BYTE $18,$18,$18,$FF,$FF,$18,$18,$18
                                                ; CHARACTER $2b
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 11111111   ********
                                                ; 11111111   ********
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00011000      **   

        .BYTE $00,$06,$0F,$30,$60               ;.BYTE $00,$00,$00,$00,$00,$00,$30,$60
                                                ; CHARACTER $2c
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00110000     **    
                                                ; 01100000    **     

        .BYTE $00,$24,$66,$FF,$FF,$66,$24,$00,$07,$0F  ;.BYTE $00,$24,$66,$FF,$FF,$66,$24,$00
                                                ; CHARACTER $2d
                                                ; 00000000           
                                                ; 00100100     *  *  
                                                ; 01100110    **  ** 
                                                ; 11111111   ********
                                                ; 11111111   ********
                                                ; 01100110    **  ** 
                                                ; 00100100     *  *  
                                                ; 00000000           

        .BYTE $60,$60                           ;.BYTE $00,$00,$00,$00,$00,$00,$60,$60
                                                ; CHARACTER $2e
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 01100000    **     
                                                ; 01100000    **     

        .BYTE $03,$0E,$18,$30,$60,$60,$C0,$C0   ;.BYTE $03,$0E,$18,$30,$60,$60,$C0,$C0
                                                ; CHARACTER $2f
                                                ; 00000011         **
                                                ; 00001110       *** 
                                                ; 00011000      **   
                                                ; 00110000     **    
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 11000000   **      
                                                ; 11000000   **      

        .BYTE $FE,$FE,$00,$CE,$DE,$F6,$E6,$FE   ;.BYTE $FE,$FE,$00,$CE,$DE,$F6,$E6,$FE
                                                ; CHARACTER $30
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 11001110   **  *** 
                                                ; 11011110   ** **** 
                                                ; 11110110   **** ** 
                                                ; 11100110   ***  ** 
                                                ; 11111110   ******* 

        .BYTE $78,$78,$00,$38,$05,$0F           ;.BYTE $78,$78,$00,$38,$38,$38,$38,$38
                                                ; CHARACTER $31
                                                ; 01111000    ****   
                                                ; 01111000    ****   
                                                ; 00000000           
                                                ; 00111000     ***   
                                                ; 00111000     ***   
                                                ; 00111000     ***   
                                                ; 00111000     ***   
                                                ; 00111000     ***   

        .BYTE $FE,$FE,$00,$06,$06,$FE,$E0,$FE   ;.BYTE $FE,$FE,$00,$06,$06,$FE,$E0,$FE
                                                ; CHARACTER $32
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 00000110        ** 
                                                ; 00000110        ** 
                                                ; 11111110   ******* 
                                                ; 11100000   ***     
                                                ; 11111110   ******* 

        .BYTE $FE,$FE,$00,$06,$06,$3E,$06,$FE   ;.BYTE $FE,$FE,$00,$06,$06,$3E,$06,$FE
                                                ; CHARACTER $33
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 00000110        ** 
                                                ; 00000110        ** 
                                                ; 00111110     ***** 
                                                ; 00000110        ** 
                                                ; 11111110   ******* 

        .BYTE $E0,$E0,$00,$E0,$EC,$FE,$0C,$0C   ;.BYTE $E0,$E0,$00,$E0,$EC,$FE,$0C,$0C
                                                ; CHARACTER $34
                                                ; 11100000   ***     
                                                ; 11100000   ***     
                                                ; 00000000           
                                                ; 11100000   ***     
                                                ; 11101100   *** **  
                                                ; 11111110   ******* 
                                                ; 00001100       **  
                                                ; 00001100       **  

        .BYTE $FE,$FE,$00,$E0,$E0,$FE,$06,$FE   ;.BYTE $FE,$FE,$00,$E0,$E0,$FE,$06,$FE
                                                ; CHARACTER $35
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 11100000   ***     
                                                ; 11100000   ***     
                                                ; 11111110   ******* 
                                                ; 00000110        ** 
                                                ; 11111110   ******* 

        .BYTE $FE,$FE,$00,$E0,$E0,$FE,$E6,$FE   ;.BYTE $FE,$FE,$00,$E0,$E0,$FE,$E6,$FE
                                                ; CHARACTER $36
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 11100000   ***     
                                                ; 11100000   ***     
                                                ; 11111110   ******* 
                                                ; 11100110   ***  ** 
                                                ; 11111110   ******* 

        .BYTE $FE,$FE,$00,$06,$05,$0F           ;.BYTE $FE,$FE,$00,$06,$06,$06,$06,$06
                                                ; CHARACTER $37
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 00000110        ** 
                                                ; 00000110        ** 
                                                ; 00000110        ** 
                                                ; 00000110        ** 
                                                ; 00000110        ** 

        .BYTE $FE,$FE,$00,$E6,$E6,$FE,$E6,$FE   ;.BYTE $FE,$FE,$00,$E6,$E6,$FE,$E6,$FE
                                                ; CHARACTER $38
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 11100110   ***  ** 
                                                ; 11100110   ***  ** 
                                                ; 11111110   ******* 
                                                ; 11100110   ***  ** 
                                                ; 11111110   ******* 

        .BYTE $FE,$FE,$00,$E6,$E6,$FE,$06,$FE   ;.BYTE $FE,$FE,$00,$E6,$E6,$FE,$06,$FE
                                                ; CHARACTER $39
                                                ; 11111110   ******* 
                                                ; 11111110   ******* 
                                                ; 00000000           
                                                ; 11100110   ***  ** 
                                                ; 11100110   ***  ** 
                                                ; 11111110   ******* 
                                                ; 00000110        ** 
                                                ; 11111110   ******* 

        .BYTE $00,$60,$60,$00,$00,$60,$60,$00   ;.BYTE $00,$60,$60,$00,$00,$60,$60,$00
                                                ; CHARACTER $3a
                                                ; 00000000           
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 00000000           
                                                ; 00000000           
                                                ; 01100000    **     
                                                ; 01100000    **     
                                                ; 00000000           

        .BYTE $00,$30,$30,$00,$00,$30,$30,$60   ;.BYTE $00,$30,$30,$00,$00,$30,$30,$60
                                                ; CHARACTER $3b
                                                ; 00000000           
                                                ; 00110000     **    
                                                ; 00110000     **    
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00110000     **    
                                                ; 00110000     **    
                                                ; 01100000    **     

        .BYTE $00,$06,$1A,$EA,$EA,$1A,$06,$00   ;.BYTE $00,$06,$1A,$EA,$EA,$1A,$06,$00
                                                ; CHARACTER $3c
                                                ; 00000000           
                                                ; 00000110        ** 
                                                ; 00011010      ** * 
                                                ; 11101010   *** * * 
                                                ; 11101010   *** * * 
                                                ; 00011010      ** * 
                                                ; 00000110        ** 
                                                ; 00000000           

        .BYTE $00,$00,$7E,$00,$7E,$00,$04,$0F   ;.BYTE $00,$00,$7E,$00,$7E,$00,$00,$00
                                                ; CHARACTER $3d
                                                ; 00000000           
                                                ; 00000000           
                                                ; 01111110    ****** 
                                                ; 00000000           
                                                ; 01111110    ****** 
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           

        .BYTE $60,$58,$57,$57,$58,$60,$00       ;.BYTE $00,$60,$58,$57,$57,$58,$60,$00
                                                ; CHARACTER $3e
                                                ; 00000000           
                                                ; 01100000    **     
                                                ; 01011000    * **   
                                                ; 01010111    * * ***
                                                ; 01010111    * * ***
                                                ; 01011000    * **   
                                                ; 01100000    **     
                                                ; 00000000           

        .BYTE $3C,$66,$06,$0C,$18,$18  ;.BYTE $3C,$66,$06,$0C,$18,$18,$00,$00
                                                ; CHARACTER $3f
                                                ; 00111100     ****  
                                                ; 01100110    **  ** 
                                                ; 00000110        ** 
                                                ; 00001100       **  
                                                ; 00011000      **   
                                                ; 00011000      **   
                                                ; 00000000           
                                                ; 00000000           

        ;End of Charsets
        .BYTE $00,$FF,$0F,$00,$FF,$0F           ; $0D81:   
        .BYTE $00,$FF,$0F,$00,$FF,$0F,$00,$FF           ; $0D89:   
        .BYTE $0F,$00,$FF,$0F,$00,$FF,$0F,$00           ; $0D91:   
        .BYTE $FF,$0F,$00,$FF,$0F,$00,$FF,$0F           ; $0D99:   
        .BYTE $00,$FF,$0F,$00,$FF,$0F,$00,$FF           ; $0DA1:   
        .BYTE $0F,$00,$FF,$0F,$00,$10,$0F

        ;Start of Sprite Data
        ; SPRITE $00
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $F0,$00,$00 111100000000000000000000 ****                    
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $F0,$00,$00,$F0,$00,$0E,$0F,$F0
        .BYTE $00,$00,$F0,$00,$0E,$0F,$F0,$00
        .BYTE $00,$F0,$00,$0E,$0F,$F0,$00,$00
        .BYTE $F0,$00,$0A,$0F
        ; SPRITE $01
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $03,$EA,$80 000000111110101010000000       ***** * * *       
        ; $00,$EA,$80 000000001110101010000000         *** * * *       
        ; $03,$EA,$80 000000111110101010000000       ***** * * *       
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $04,$AA,$14 000001001010101000010100      *  * * * *    * *  
        ; $10,$28,$03 000100000010100000000011    *      * *         **
        ; $C0,$00,$01 110000000000000000000001 **                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$00 010000000000000000000000  *                      
        .BYTE $28,$00,$00,$AA,$00,$00,$82,$00
        .BYTE $02,$28,$80,$00,$BA,$00,$00,$EA
        .BYTE $00,$03,$EA,$80,$00,$EA,$80,$03
        .BYTE $EA,$80,$01,$AA,$40,$04,$AA,$14
        .BYTE $10,$28,$03,$C0,$00,$01,$40,$00
        .BYTE $01,$40,$00,$01,$40,$00,$01,$40
        .BYTE $00,$01,$40,$00,$01,$40,$00,$01
        .BYTE $40,$00,$00,$FF
        ; SPRITE $02
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $03,$FA,$80 000000111111101010000000       ******* * *       
        ; $03,$3A,$80 000000110011101010000000       **  *** * *       
        ; $03,$FA,$80 000000111111101010000000       ******* * *       
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $01,$AA,$57 000000011010101001010111        ** * * *  * * ***
        ; $01,$28,$01 000000010010100000000001        *  * *          *
        ; $04,$00,$04 000001000000000000000100      *               *  
        ; $04,$00,$10 000001000000000000010000      *             *    
        ; $30,$00,$40 001100000000000001000000   **             *      
        ; $10,$01,$00 000100000000000100000000    *           *        
        ; $10,$00,$00 000100000000000000000000    *                    
        ; $10,$00,$00 000100000000000000000000    *                    
        ; $10,$00,$00 000100000000000000000000    *                    
        ; $10,$00,$00 000100000000000000000000    *                    
        ; $10,$00,$00 000100000000000000000000    *                    
        .BYTE $00,$28,$00,$00,$AA,$00,$00,$82
        .BYTE $00,$02,$28,$80,$00,$BA,$00,$00
        .BYTE $EA,$00,$03,$FA,$80,$03,$3A,$80
        .BYTE $03,$FA,$80,$00,$AA,$00,$01,$AA
        .BYTE $57,$01,$28,$01,$04,$00,$04,$04
        .BYTE $00,$10,$30,$00,$40,$10,$01,$00
        .BYTE $10,$00,$00,$10,$00,$00,$10,$00
        .BYTE $00,$10,$00,$00,$10,$00,$00,$FF
        ; SPRITE $03
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$FE,$80 000000101111111010000000       * ******* *       
        ; $02,$CE,$80 000000101100111010000000       * **  *** *       
        ; $02,$FE,$80 000000101111111010000000       * ******* *       
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $01,$28,$10 000000010010100000010000        *  * *      *    
        ; $01,$00,$0C 000000010000000000001100        *            **  
        ; $01,$00,$10 000000010000000000010000        *           *    
        ; $0C,$00,$10 000011000000000000010000     **             *    
        ; $04,$00,$40 000001000000000001000000      *           *      
        ; $04,$00,$40 000001000000000001000000      *           *      
        ; $04,$01,$00 000001000000000100000000      *         *        
        ; $04,$01,$00 000001000000000100000000      *         *        
        ; $04,$00,$00 000001000000000000000000      *                  
        ; $04,$00,$00 000001000000000000000000      *                  
        .BYTE $00,$28,$00,$00,$AA,$00,$00,$82
        .BYTE $00,$02,$28,$80,$00,$BA,$00,$00
        .BYTE $EA,$00,$02,$FE,$80,$02,$CE,$80
        .BYTE $02,$FE,$80,$00,$AA,$00,$01,$AA
        .BYTE $40,$01,$28,$10,$01,$00,$0C,$01
        .BYTE $00,$10,$0C,$00,$10,$04,$00,$40
        .BYTE $04,$00,$40,$04,$01,$00,$04,$01
        .BYTE $00,$04,$00,$00,$04,$00,$00,$FF
        ; SPRITE $04
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$BF,$80 000000101011111110000000       * * *******       
        ; $02,$B3,$80 000000101011001110000000       * * **  ***       
        ; $02,$BF,$80 000000101011111110000000       * * *******       
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $01,$28,$40 000000010010100001000000        *  * *    *      
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $03,$00,$C0 000000110000000011000000       **        **      
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $01,$00,$40 000000010000000001000000        *         *      
        .BYTE $00,$28,$00,$00,$AA,$00,$00,$82
        .BYTE $00,$02,$28,$80,$00,$BA,$00,$00
        .BYTE $EA,$00,$02,$BF,$80,$02,$B3,$80
        .BYTE $02,$BF,$80,$00,$AA,$00,$01,$AA
        .BYTE $40,$01,$28,$40,$01,$00,$40,$01
        .BYTE $00,$40,$03,$00,$C0,$01,$00,$40
        .BYTE $01,$00,$40,$01,$00,$40,$01,$00
        .BYTE $40,$01,$00,$40,$01,$00,$40,$FF
        ; SPRITE $05
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AF,$C0 000000101010111111000000       * * * ******      
        ; $02,$AC,$C0 000000101010110011000000       * * * **  **      
        ; $02,$AF,$C0 000000101010111111000000       * * * ******      
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $04,$28,$40 000001000010100001000000      *    * *    *      
        ; $30,$00,$40 001100000000000001000000   **             *      
        ; $04,$00,$40 000001000000000001000000      *           *      
        ; $04,$00,$30 000001000000000000110000      *            **    
        ; $01,$00,$10 000000010000000000010000        *           *    
        ; $01,$00,$10 000000010000000000010000        *           *    
        ; $00,$40,$10 000000000100000000010000          *         *    
        ; $00,$40,$10 000000000100000000010000          *         *    
        ; $00,$00,$10 000000000000000000010000                    *    
        ; $00,$00,$10 000000000000000000010000                    *    
        .BYTE $00,$28,$00,$00,$AA,$00,$00,$82
        .BYTE $00,$02,$28,$80,$00,$BA,$00,$00
        .BYTE $EA,$00,$02,$AF,$C0,$02,$AC,$C0
        .BYTE $02,$AF,$C0,$00,$AA,$00,$01,$AA
        .BYTE $40,$04,$28,$40,$30,$00,$40,$04
        .BYTE $00,$40,$04,$00,$30,$01,$00,$10
        .BYTE $01,$00,$10,$00,$40,$10,$00,$40
        .BYTE $10,$00,$00,$10,$00,$00,$10,$FF
        ; SPRITE $06
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AB,$C0 000000101010101111000000       * * * * ****      
        ; $02,$AB,$00 000000101010101100000000       * * * * **        
        ; $02,$AB,$C0 000000101010101111000000       * * * * ****      
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $D5,$AA,$40 110101011010101001000000 ** * * ** * * *  *      
        ; $40,$28,$40 010000000010100001000000  *        * *    *      
        ; $10,$00,$10 000100000000000000010000    *               *    
        ; $04,$00,$10 000001000000000000010000      *             *    
        ; $01,$00,$0C 000000010000000000001100        *            **  
        ; $00,$00,$04 000000000000000000000100                      *  
        ; $00,$00,$04 000000000000000000000100                      *  
        ; $00,$00,$04 000000000000000000000100                      *  
        ; $00,$00,$04 000000000000000000000100                      *  
        ; $00,$00,$04 000000000000000000000100                      *  
        ; $00,$00,$04 000000000000000000000100                      *  
        .BYTE $00,$28,$00,$00,$AA,$00,$00,$82
        .BYTE $00,$02,$28,$80,$00,$BA,$00,$00
        .BYTE $EA,$00,$02,$AB,$C0,$02,$AB,$00
        .BYTE $02,$AB,$C0,$00,$AA,$00,$D5,$AA
        .BYTE $40,$40,$28,$40,$10,$00,$10,$04
        .BYTE $00,$10,$01,$00,$0C,$00,$00,$04
        .BYTE $00,$00,$04,$00,$00,$04,$00,$00
        .BYTE $04,$00,$00,$04,$00,$00,$04,$FF
        ; SPRITE $07
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $14,$AA,$10 000101001010101000010000    * *  * * * *    *    
        ; $C0,$28,$04 110000000010100000000100 **        * *        *  
        ; $40,$00,$03 010000000000000000000011  *                    **
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $00,$00,$01 000000000000000000000001                        *
        .BYTE $00,$04,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$28,$80,$00,$BA
        .BYTE $00,$00,$EA,$00,$02,$AA,$80,$02
        .BYTE $AA,$80,$02,$AA,$80,$01,$AA,$40
        .BYTE $14,$AA,$10,$C0,$28,$04,$40,$00
        .BYTE $03,$40,$00,$01,$40,$00,$01,$40
        .BYTE $00,$01,$40,$00,$01,$40,$00,$01
        .BYTE $40,$00,$01,$00,$00,$01,$FF
        ; SPRITE $08
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $04,$AA,$10 000001001010101000010000      *  * * * *    *    
        ; $10,$28,$04 000100000010100000000100    *      * *        *  
        ; $C0,$00,$03 110000000000000000000011 **                    **
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        .BYTE $00,$04,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$28,$80,$00,$BA
        .BYTE $00,$00,$EA,$00,$02,$AA,$80,$02
        .BYTE $AA,$80,$02,$AA,$80,$01,$AA,$40
        .BYTE $04,$AA,$10,$10,$28,$04,$C0,$00
        .BYTE $03,$40,$00,$01,$40,$00,$01,$40
        .BYTE $00,$01,$40,$00,$01,$40,$00,$01
        .BYTE $40,$00,$01,$40,$00,$01,$FF
        ; SPRITE $09
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$00,$80 000000100000000010000000       *         *       
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $14,$AA,$14 000101001010101000010100    * *  * * * *    * *  
        ; $C0,$28,$03 110000000010100000000011 **        * *         **
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        .BYTE $00,$04,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$00,$80,$00,$28
        .BYTE $00,$00,$BA,$00,$00,$EA,$00,$02
        .BYTE $AA,$80,$02,$AA,$80,$02,$AA,$80
        .BYTE $01,$AA,$40,$14,$AA,$14,$C0,$28
        .BYTE $03,$40,$00,$01,$40,$00,$01,$40
        .BYTE $00,$01,$40,$00,$01,$40,$00,$01
        .BYTE $40,$00,$01,$40,$00,$01,$FF
        ; SPRITE $0a
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$00,$80 000000100000000010000000       *         *       
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $D0,$AA,$07 110100001010101000000111 ** *    * * * *      ***
        ; $45,$AA,$91 010001011010101010010001  *   * ** * * * *  *   *
        ; $40,$28,$01 010000000010100000000001  *        * *          *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        .BYTE $00,$0A,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$00,$80,$00,$28
        .BYTE $00,$00,$BA,$00,$00,$EA,$00,$02
        .BYTE $AA,$80,$02,$AA,$80,$02,$AA,$80
        .BYTE $D0,$AA,$07,$45,$AA,$91,$40,$28
        .BYTE $01,$40,$00,$01,$40,$00,$01,$40
        .BYTE $00,$01,$40,$00,$01,$40,$00,$01
        .BYTE $FF
        ; SPRITE $0b
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $14,$AA,$14 000101001010101000010100    * *  * * * *    * *  
        ; $C0,$28,$03 110000000010100000000011 **        * *         **
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        .BYTE $00,$07,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$28,$80,$00,$BA
        .BYTE $00,$00,$EA,$00,$02,$AA,$80,$02
        .BYTE $AA,$80,$02,$AA,$80,$01,$AA,$40
        .BYTE $14,$AA,$14,$C0,$28,$03,$40,$00
        .BYTE $01,$40,$00,$01,$40,$00,$01,$40
        .BYTE $00,$01,$40,$00,$01,$40,$00,$01
        .BYTE $40,$00,$01,$FF
        ; SPRITE $0c
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $05,$AA,$50 000001011010101001010000      * ** * * *  * *    
        ; $D0,$AA,$07 110100001010101000000111 ** *    * * * *      ***
        ; $40,$28,$01 010000000010100000000001  *        * *          *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $40,$00,$01 010000000000000000000001  *                     *
        ; $10,$00,$04 000100000000000000000100    *                 *  
        ; $10,$00,$04 000100000000000000000100    *                 *  
        ; $10,$00,$04 000100000000000000000100    *                 *  
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$04,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$28,$80,$00,$BA
        .BYTE $00,$00,$EA,$00,$02,$AA,$80,$02
        .BYTE $AA,$80,$02,$AA,$80,$05,$AA,$50
        .BYTE $D0,$AA,$07,$40,$28,$01,$40,$00
        .BYTE $01,$40,$00,$01,$10,$00,$04,$10
        .BYTE $00,$04,$10,$00,$04,$00,$09,$0F
        .BYTE $FF
        ; SPRITE $0d
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $35,$AA,$5C 001101011010101001011100   ** * ** * * *  * ***  
        ; $10,$AA,$04 000100001010101000000100    *    * * * *      *  
        ; $04,$28,$10 000001000010100000010000      *    * *      *    
        ; $01,$00,$40 000000010000000001000000        *         *      
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$04,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$28,$80,$00,$BA
        .BYTE $00,$00,$EA,$00,$02,$AA,$80,$02
        .BYTE $AA,$80,$02,$AA,$80,$35,$AA,$5C
        .BYTE $10,$AA,$04,$04,$28,$10,$01,$00
        .BYTE $40,$00,$15,$0F,$FF
        ; SPRITE $0e
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $0D,$AA,$70 000011011010101001110000     ** ** * * *  ***    
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$04,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$28,$80,$00,$BA
        .BYTE $00,$00,$EA,$00,$02,$AA,$80,$02
        .BYTE $AA,$80,$02,$AA,$80,$0D,$AA,$70
        .BYTE $00,$AA,$00,$00,$28,$00,$19,$0F
        .BYTE $FF
        ; SPRITE $0f
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$82,$00 000000001000001000000000         *     *         
        ; $02,$28,$80 000000100010100010000000       *   * *   *       
        ; $00,$BA,$00 000000001011101000000000         * *** *         
        ; $00,$EA,$00 000000001110101000000000         *** * *         
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $02,$AA,$80 000000101010101010000000       * * * * * *       
        ; $01,$AA,$40 000000011010101001000000        ** * * *  *      
        ; $00,$AA,$00 000000001010101000000000         * * * *         
        ; $00,$28,$00 000000000010100000000000           * *           
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$04,$0F,$28,$00,$00,$AA,$00
        .BYTE $00,$82,$00,$02,$28,$80,$00,$BA
        .BYTE $00,$00,$EA,$00,$02,$AA,$80,$02
        .BYTE $AA,$80,$02,$AA,$80,$01,$AA,$40
        .BYTE $00,$AA,$00,$00,$28,$00,$19,$0F
        .BYTE $FF
        ; SPRITE $10
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$A8,$00 000000001010100000000000         * * *           
        ; $02,$A0,$00 000000101010000000000000       * * *             
        ; $02,$8A,$00 000000101000101000000000       * *   * *         
        ; $02,$2E,$80 000000100010111010000000       *   * *** *       
        ; $02,$3A,$80 000000100011101010000000       *   *** * *       
        ; $00,$EA,$A0 000000001110101010100000         *** * * * *     
        ; $00,$EA,$A0 000000001110101010100000         *** * * * *     
        ; $00,$EA,$A0 000000001110101010100000         *** * * * *     
        ; $00,$6A,$90 000000000110101010010000          ** * * *  *    
        ; $00,$2A,$80 000000000010101010000000           * * * *       
        ; $00,$0A,$00 000000000000101000000000             * *         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$07,$0F,$A8,$00,$02,$A0,$00
        .BYTE $02,$8A,$00,$02,$2E,$80,$02,$3A
        .BYTE $80,$00,$EA,$A0,$00,$EA,$A0,$00
        .BYTE $EA,$A0,$00,$6A,$90,$00,$2A,$80
        .BYTE $00,$0A,$00,$19,$0F,$FF
        ; SPRITE $11
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$10,$00 000000000001000000000000            *            
        ; $00,$60,$00 000000000110000000000000          **             
        ; $01,$A2,$80 000000011010001010000000        ** *   * *       
        ; $06,$8B,$A0 000001101000101110100000      ** *   * *** *     
        ; $1A,$8E,$A0 000110101000111010100000    ** * *   *** * *     
        ; $6A,$3A,$A8 011010100011101010101000  ** * *   *** * * * *   
        ; $BF,$FA,$A8 101111111111101010101000 * *********** * * * *   
        ; $6A,$3A,$A8 011010100011101010101000  ** * *   *** * * * *   
        ; $1A,$9A,$A4 000110101001101010100100    ** * *  ** * * *  *  
        ; $06,$8A,$A0 000001101000101010100000      ** *   * * * *     
        ; $01,$A2,$80 000000011010001010000000        ** *   * *       
        ; $00,$60,$00 000000000110000000000000          **             
        ; $00,$10,$00 000000000001000000000000            *            
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$07,$0F,$10,$00,$00,$60,$00
        .BYTE $01,$A2,$80,$06,$8B,$A0,$1A,$8E
        .BYTE $A0,$6A,$3A,$A8,$BF,$FA,$A8,$6A
        .BYTE $3A,$A8,$1A,$9A,$A4,$06,$8A,$A0
        .BYTE $01,$A2,$80,$00,$60,$00,$00,$10
        .BYTE $00,$13,$0F,$FF
        ; SPRITE $12
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$2A,$00 000000000010101000000000           * * *         
        ; $00,$0A,$80 000000000000101010000000             * * *       
        ; $00,$A2,$80 000000001010001010000000         * *   * *       
        ; $02,$E8,$80 000000101110100010000000       * *** *   *       
        ; $03,$A8,$80 000000111010100010000000       *** * *   *       
        ; $0A,$AB,$00 000010101010101100000000     * * * * * **        
        ; $0A,$AB,$00 000010101010101100000000     * * * * * **        
        ; $0A,$AB,$00 000010101010101100000000     * * * * * **        
        ; $06,$A9,$00 000001101010100100000000      ** * * *  *        
        ; $02,$A8,$00 000000101010100000000000       * * * *           
        ; $00,$A0,$00 000000001010000000000000         * *             
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$07,$0F,$2A,$00,$00,$0A,$80
        .BYTE $00,$A2,$80,$02,$E8,$80,$03,$A8
        .BYTE $80,$0A,$AB,$00,$0A,$AB,$00,$0A
        .BYTE $AB,$00,$06,$A9,$00,$02,$A8,$00
        .BYTE $00,$A0,$00,$19,$0F,$FF
        ; SPRITE $13
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$04,$00 000000000000010000000000              *          
        ; $00,$09,$00 000000000000100100000000             *  *        
        ; $02,$8A,$40 000000101000101001000000       * *   * *  *      
        ; $0B,$A2,$90 000010111010001010010000     * *** *   * *  *    
        ; $0E,$A2,$A4 000011101010001010100100     *** * *   * * *  *  
        ; $2A,$AC,$A9 001010101010110010101001   * * * * * **  * * *  *
        ; $2A,$AF,$FE 001010101010111111111110   * * * * * *********** 
        ; $2A,$AC,$A9 001010101010110010101001   * * * * * **  * * *  *
        ; $1A,$A2,$A4 000110101010001010100100    ** * * *   * * *  *  
        ; $0A,$A2,$90 000010101010001010010000     * * * *   * *  *    
        ; $02,$8A,$40 000000101000101001000000       * *   * *  *      
        ; $00,$09,$00 000000000000100100000000             *  *        
        ; $00,$04,$00 000000000000010000000000              *          
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        ; $00,$00,$00 000000000000000000000000                         
        .BYTE $00,$07,$0F,$04,$00,$00,$09,$00
        .BYTE $02,$8A,$40,$0B,$A2,$90,$0E,$A2
        .BYTE $A4,$2A,$AC,$A9,$2A,$AF,$FE,$2A
        .BYTE $AC,$A9,$1A,$A2,$A4,$0A,$A2,$90
        .BYTE $02,$8A,$40,$00,$09,$00,$00,$04
        .BYTE $00,$13,$0F,$FF

        .BYTE $00,$3F,$0F           ; $11D1:   
        .BYTE $77,$78                                   ; $11D9:   
; End of sprites and charset

CopyCodeCharSetAndSpriteData
        SEI 
        LDX #<p05
        LDY #>p05
        STX a14
        STY a15

; CharSetPtrLo/CharSetPtrHi set to $1252 the end of the charset and sprite data
        LDX #$DA
        LDY #$11
        STX CharSetPtrLo
        STY CharSetPtrHi
        LDY #$00

; Copy 123 bytes of code from $1273 to $0333
        LDX #$7B
b11F0   LDA f11FB,X
        STA f0333,X
        DEX 
        BNE b11F0
f11FB   =*+$02
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
        ; POKE 53272,24
        .BYTE $33,$08,$05,$00,$97,$35,$33,$32,$37,$32,$2C,$32,$34
        ; POKE 53269,1
        .BYTE $3A,$97,$35,$33,$32,$36,$39,$2C,$31
        ; POKE 53271,0
        .BYTE $3A,$97,$35,$33,$32,$37,$31,$2C,$30


; Copy the charset and sprite data to banks $2000 and $3000. Sprites
; are copied to $3000.
; - The sprite and charset data is read from the end instead of the front.
; - When a sequence such as $00,$05,$1E is encountered it is treated as a tag length
;   value (TLV) where $1E is the tag, $00 is the character to output and $05 is the
;   number of instances to output. So $00,$05,$1E translates to $00,$00,$00,$00,$00. 
; 
b121B
        DEY
        CPY #$FF
        BNE b1222
        DEC CharSetPtrHi
b1222   LDA (CharSetPtrLo),Y
        STA aFF
        DEY 
        CPY #$FF
        BNE b122D
        DEC CharSetPtrHi

; CopyCharSetData
b122D   LDA (CharSetPtrLo),Y
        CMP #$0F
        BEQ b1262
b1233   STA f3540,X
        DEX 
        CPX #$FF
        BNE b1241
        DEC a036D
        DEC a038C
b1241   DEC aFF
        BNE b1233
b1245   DEY 
        CPY #$FF
        BNE b124C
        DEC CharSetPtrHi
b124C   LDA (CharSetPtrLo),Y
        CMP #$0F
        BEQ b121B
        STA f3540,X
        DEX 
        CPX #$FF
        BNE b1245
        DEC a036D
        DEC a038C
        BNE b1245
b1262   LDX #$1F
b1264   LDA f0333,X
        STA f0800,X
        DEX 
        BNE b1264
        LDA #$0F
        LDA #$37
        STA a01
        CLI 
        JMP eA8BC

        .BYTE $E1
