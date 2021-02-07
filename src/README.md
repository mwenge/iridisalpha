# Iridis Alpha: Introduction to the Source Code

This source code is derived from [the binary](https://github.com/mwenge/iridisalpha/blob/master/orig/iridisalpha.prg) stored in the `orig` folder. This binary is the one [distributed by Minter in 2019](http://minotaurproject.co.uk/yakimg/Llamasoft_C64.zip) along with the rest of his Vic 20 and C64 games.

It's important to note that this is not a byte-for-byte identical disassembly of the [original binary](https://github.com/mwenge/iridisalpha/blob/master/orig/iridisalpha.prg). This is because `iridisalpha.prg` uses a compressor/decompressor to load itself into memory. So it is only possible to derive the original source from a snapshot of the game while it is running. I reverse-engineered the source code from a Vice snapshot. The hard part of doing it this way is figuring out the correct entry point to launch the game from, which in this case turned out to be address `$4000`. This was also the point at which I figured out I needed to use Exomizer to compress some of the game data myself, so that I could get the game to load and run.

Before diving into the code, let's take a quick look at how I've broken out the source.

## What Each File Contains
### [`iridisalpha.asm`]
This file contains the source for the main game. All of the other `asm` files in this directory are included from this file, with the exception of `characterandspritedata.asm` which is compiled separately and compressed into the final `prg` file.


### [`bonusphase.asm`]
This file contains the source for the game's 'Bonus Phase', which is in fact a complete mini-game in it's own right. 

<img src="https://www.c64-wiki.com/images/d/dc/Iridisalphabonus2.gif" width="300">

### [`charset.asm`]
This file contains the character sets used in the game, including most of the characters used to construct the planet surfaces

Here's what the start of the file looks like, defining the characterset (font) used for A, B and C.
```asm
p200E
        .BYTE $C6,$C6   ;.BYTE $3C,$66,$C6,$DE,$C6,$C6,$C6,$C6
                                                ; CHARACTER $01
                                                ; 00111100     ****  
                                                ; 01100110    **  ** 
                                                ; 11000110   **   ** 
                                                ; 11011110   ** **** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
        .BYTE $FC,$C6,$C6,$DC,$C6,$C6,$C6
p2017
        .BYTE $DC   ;.BYTE $FC,$C6,$C6,$DC,$C6,$C6,$C6,$DC
                                                ; CHARACTER $02
                                                ; 11111100   ******  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11011100   ** ***  
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11000110   **   ** 
                                                ; 11011100   ** ***  
        .BYTE $3C,$66,$C0,$C0,$C0,$C0,$C6,$7C   ;.BYTE $3C,$66,$C0,$C0,$C0,$C0,$C6,$7C
                                                ; CHARACTER $03
                                                ; 00111100     ****  
                                                ; 01100110    **  ** 
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000000   **      
                                                ; 11000110   **   ** 
                                                ; 01111100    *****  
```
### [`charsetandspritedata.asm`]
### [`sprites.asm`]
These files contain the game's sprites and some additional character set data. As `charsetandspritedata.asm` needs to end up at adress $E000, and since it is not possible to load data directly to that address when loading a C64 binary from tape or image, our build process uses a tool called Exomizer to compress the data in `charsetandspritedata.asm` in `iridisalpha.prg` and then decompress it to $E000 when the program is loading.

The source includes a pseudo bitmap of the sprites that helps you related the data to what will ultimately be painted on screen. Here's the sprite definition of the gilby flying left from [`sprites.asm`]:

```asm
        ; SPRITE $D3
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
        .BYTE $00,$00,$00,$00,$00,$00,$00,$04
        .BYTE $00,$00,$09,$00,$02,$8A,$40,$0B
        .BYTE $A2,$90,$0E,$A2,$A4,$2A,$AC,$A9
        .BYTE $2A,$AF,$FE,$2A,$AC,$A9,$1A,$A2
        .BYTE $A4,$0A,$A2,$90,$02,$8A,$40,$00
        .BYTE $09,$00,$00,$04,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
```

### [`madeinfrance.asm`]
This is the self-contained pause-mode game, called 'Made in France' or 'MIF' for short. You can access it during game play by pressing 'F1'. This little game was originally released by Minter on Compunet, the source code for that release is available at https://github.com/mwenge/iridisalpha/tree/master/demos/mif.

<img src="https://user-images.githubusercontent.com/58846/103455890-eac78500-4ce8-11eb-9d92-867c0c3ea825.gif" width=300>

### [`dna.asm`]
This is a game within the pause-mode game. Originally released on Compunet, you can access it from with 'Made in France' by pressing '\*'. You exit it by pressing '\*' again. his little game was also originally released by Minter on Compunet, the source code for that release is available at https://github.com/mwenge/iridisalpha/tree/master/demos/dna.

<img src="https://user-images.githubusercontent.com/58846/103443219-cfab3580-4c54-11eb-8046-0f5f3bac9c79.gif" width=300>

# A Closer Look At [`iridisalpha.asm`]
While disassembly is still in progress, this section is a collection of random notes. 

## [GenPlan](https://github.com/mwenge/iridisalpha/blob/4250b80a10adb10fa21703395c681743314853c2/src/iridisalpha.asm#L6098): The algorithm for generating the planet surfaces

This is the [routine](https://github.com/mwenge/iridisalpha/blob/4250b80a10adb10fa21703395c681743314853c2/src/iridisalpha.asm#L6098) Minter devoted some time to in his development diary.


```asm
;-------------------------------
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
;-------------------------------

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
```

There are five different planets in the game, each with their own unique set of textures, surfaces and structures. However the algorithm for generating the planets is the same: the difference lies solely in the character set data used to construct them.

The generated planet data gets written to positions $8C00 to $8FFF in memory. The first step is to fill this with 'sea':

```asm
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
```

The values $40 and $42 here refer to the character set bytes $40 and $42 in the current location of the character set, which for Iridis Alphas starts at $2000. When the first level starts, the values at this position are as follows (from `charset.asm`):
```asm
f2200
        .BYTE $00,$00,$20,$00,$8A,$AA,$00,$AA   ;.BYTE $00,$00,$20,$00,$8A,$AA,$00,$AA
                                                ; CHARACTER $40
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00100000     *     
                                                ; 00000000           
                                                ; 10001010   *   * * 
                                                ; 10101010   * * * * 
                                                ; 00000000           
                                                ; 10101010   * * * * 
        .BYTE $00,$00,$00,$00,$8A,$AA,$AA,$00   ;.BYTE $00,$00,$00,$00,$8A,$AA,$AA,$00
                                                ; CHARACTER $42
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 00000000           
                                                ; 10001010   *   * * 
                                                ; 10101010   * * * * 
                                                ; 10101010   * * * * 
                                                ; 00000000           
```

Together these create the 'sea' effect that forms the basis of most of the planet's surface.

The next step is to pick a random location on the surface for the 'land':

```asm
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
```

Now, draw the land from the randomly chosen position for up to 256 bytes:

```asm
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

```

## A Cheat for Awarding Yourself 10000 Bonus Points

In the CheckKeyboardInGame Routine, we find the following:
```asm

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
```

In the above the `canAwardBonus` byte is the first letter in the name of the player with the top score in the Hi-Score table. By default this is 'YAK':
```asm
hiScoreTablePtr           .TEXT "0068000"
canAwardBonus             .TEXT "YAK "
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
```

But if we change 'Y' to $1C like so, we can activate the hack:

```asm
hiScoreTablePtr           .TEXT "0068000"
canAwardBonus             .TEXT $1C,"AK "
```

(Note that $1C is charset code for a bull's head symbol in Iridis Alpha, so it is also possible to enter this as the initial of a high scorer name if we get a score that puts us to the top of the table:

```asm
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
```
)

Here's the hack in action, we can press Y at any time to give ourselves a bonus of 10000:

<img src="https://user-images.githubusercontent.com/58846/107145337-a909aa00-6938-11eb-9f5e-08438dcba5a0.gif" width="500">

I'm guessing this was used for testing the animation routine and left in as an Easter egg.

[`iridisalpha.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/iridisalpha.asm
[`madeinfrance.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/madeinfrance.asm
[`dna.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/dna.asm
[`charset.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/charset.asm
[`sprites.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/sprites.asm
[`charsetandspritedata.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/charsetandspritedata.asm
[`bonusphase.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/bonusphase.asm
