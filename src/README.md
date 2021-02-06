# Iridis Alpha: Introduction to the Source Code

Iridis Alpha consists of a number of sub-games in addition to the main game.

## What Each File Contains
### `iridisalpha.asm`
This file contains the source for the main game. 

### `charset.asm`
This file contains the character sets used in the game.

### 'charsetandspritedata.asm`
### 'sprites.asm`
These file contain the game's sprites and some additional character set data. As `charsetandspritedata.asm` needs to end up at adress $E000, and since it is not possible to load data directly to that address when loading a C64 binary from tape or image, our build process uses a tool called Exomizer to compress the data in `charsetandspritedata.asm` in `iridisalpha.prg` and then decompress it to $E000 when the program is loading.

### `madeinfrance.asm`
This is the self-contained pause-mode game, called 'Made in France' or 'MIF' for short. You can access it during game play by pressing 'F1'. This little game was originally released by Minter on Compunet, the source code for that release is available at https://github.com/mwenge/iridisalpha/tree/master/demos/mif.

<img src="https://user-images.githubusercontent.com/58846/103455890-eac78500-4ce8-11eb-9d92-867c0c3ea825.gif" width=500>

### `dna.asm`
This is a game within the pause-mode game. Originally released on Compunet, you can access it from with 'Made in France' by pressing '\*'. You exit it by pressing '\*' again. his little game was also originally released by Minter on Compunet, the source code for that release is available at https://github.com/mwenge/iridisalpha/tree/master/demos/dna.

<img src="https://user-images.githubusercontent.com/58846/103443219-cfab3580-4c54-11eb-8046-0f5f3bac9c79.gif" width=700>

## A Closer Look At `iridisalpha.asm`
While disassembly is still in progress, this section is a collection of random notes. 

### [GenPlan](https://github.com/mwenge/iridisalpha/blob/4250b80a10adb10fa21703395c681743314853c2/src/iridisalpha.asm#L6098): The algorithm for generating the planet surfaces

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

It uses the data in [`planet_data.asm`](https://github.com/mwenge/iridisalpha/blob/master/src/planet_data.asm) to paint the construct the surface of the upper and lower planets from character set data in `charset.asm`.
