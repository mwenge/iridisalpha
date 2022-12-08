# Iridis Alpha: Introduction to the Source Code

<!-- vim-markdown-toc GFM -->

  * [What Each File Contains](#what-each-file-contains)
    * [`iridisalpha.asm`](#iridisalphaasm)
    * [`bonusphase.asm`](#bonusphaseasm)
    * [`charset.asm`](#charsetasm)
    * [`bonusphase_graphics.asm`](#bonusphase_graphicsasm)
    * [`sprites.asm`](#spritesasm)
    * [`madeinfrance.asm`](#madeinfranceasm)
    * [`dna.asm`](#dnaasm)
* [A Closer Look At `iridisalpha.asm`](#a-closer-look-at-iridisalphaasm)
  * [The Difficulty Cliff](#the-difficulty-cliff)
  * [Bug: Ships from the last level in the previous game show up when you start a new game](#bug-ships-from-the-last-level-in-the-previous-game-show-up-when-you-start-a-new-game)
  * [GenPlan: The algorithm for generating the planet surfaces](#genplan-the-algorithm-for-generating-the-planet-surfaces)
  * [A Cheat for Awarding Yourself 10000 Bonus Points](#a-cheat-for-awarding-yourself-10000-bonus-points)
  * [Bug: Pressing F1 during Attract Mode Allows You to Resume the Game at a Random Level](#bug-pressing-f1-during-attract-mode-allows-you-to-resume-the-game-at-a-random-level)

<!-- vim-markdown-toc -->
This source code is derived from [the binary](https://github.com/mwenge/iridisalpha/blob/master/orig/iridisalpha.prg) stored in the `orig` folder. This binary is the one [distributed by Minter in 2019](http://minotaurproject.co.uk/yakimg/Llamasoft_C64.zip) along with the rest of his Vic 20 and C64 games.

It's important to note that this is not a byte-for-byte identical disassembly of the [original binary](https://github.com/mwenge/iridisalpha/blob/master/orig/iridisalpha.prg). This is because `iridisalpha.prg` uses a compressor/decompressor to load itself into memory. So it is only possible to derive the original source from a snapshot of the game while it is running. I reverse-engineered the source code from a Vice snapshot. The hard part of doing it this way is figuring out the correct entry point to launch the game from, which in this case turned out to be address `$4000`. This was also the point at which I figured out I needed to use Exomizer to compress some of the game data myself, so that I could get the game to load and run.

If you're new to assembly, you should take a look at the [common patterns] in Iridis Alpha's codebase. These are shared by
other Minter games too and the discussion tries to shed light on some of the things that would not be obvious to a beginner
in the way assembly code is written. There are also some notes in there intended to help understand C64 internals, such as
characters, sprites and interupts.

Before diving into the code, let's take a quick look at how I've broken out the source.

## What Each File Contains
### `iridisalpha.asm`
This file contains the source for the main game. All of the other `asm` files in this directory are included from this file, with the exception of `characterandspritedata.asm` which is compiled separately and compressed into the final `prg` file.


### `bonusphase.asm`
This file contains the source for the game's 'Bonus Phase', which is in fact a complete mini-game in it's own right. 

<img src="https://www.c64-wiki.com/images/d/dc/Iridisalphabonus2.gif" width="300">

### `charset.asm`
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
### `bonusphase_graphics.asm`
### `sprites.asm`
These files contain the game's sprites and some additional character set data. As `bonusphase_graphics.asm` needs to end up at adress $E000, and since it is not possible to load data directly to that address when loading a C64 binary from tape or image, our build process uses a tool called Exomizer to compress the data in `bonusphase_graphics.asm` in `iridisalpha.prg` and then decompress it to $E000 when the program is loading.

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

### `madeinfrance.asm`
This is the self-contained pause-mode game, called 'Made in France' or 'MIF' for short. You can access it during game play by pressing 'F1'. This little game was originally released by Minter on Compunet, the source code for that release is available at https://github.com/mwenge/iridisalpha/tree/master/demos/mif.

<img src="https://user-images.githubusercontent.com/58846/103455890-eac78500-4ce8-11eb-9d92-867c0c3ea825.gif" width=300>

### `dna.asm`
This is a game within the pause-mode game. Originally released on Compunet, you can access it from with 'Made in France' by pressing '\*'. You exit it by pressing '\*' again. his little game was also originally released by Minter on Compunet, the source code for that release is available at https://github.com/mwenge/iridisalpha/tree/master/demos/dna.

<img src="https://user-images.githubusercontent.com/58846/103443219-cfab3580-4c54-11eb-8046-0f5f3bac9c79.gif" width=300>

# A Closer Look At `iridisalpha.asm`
While disassembly is still in progress, this section is a collection of random notes. 

## The Difficulty Cliff
When I first played this game as a kid I struggled with the sudden jump in difficulty you encounter 3 levels into the game.

After blithely blasting through the initial waves of enemies you suddenly encounter floating dots. You shoot them, they
turn into an oval face with a tongue sticking out, gravitate towards you immediately and in a near instant sap all your
energy and kill you. The notorious 'licker ships'.

Anecdotally, this difficulty cliff turned out to be a real problem for casual players. Many could never make it beyond
this level - there was no obvious way of struggling past it with just 3 lives. If you experimented long enough you would
eventually discover the optimal strategy was to fly to the left, turn briefly, shoot and continue running. You needed to
pick them off one at a time and make sure they were far enough away from you so that they wouldn't immediately dash towards
you and pick you off.

There's no question in my mind that this jump in difficulty was way too sudden and while disassembling the game I was very
curious to understand how it was configured and if it would be easy to dial it back in some way.

The enemy ship behaviour for every level is defined by the data structures in `level_data.asm`. It's a 40 byte structure
with a whole bunch of flags that specify a variety of different behaviours for each enemy type. Here's the full list:

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/level_data.asm#L2-L39

It turns out the fields that control the horrible behaviour of the licker ships are these two:

https://github.com/mwenge/iridisalpha/blob/47bbf493f4016aeb81f65d2f02e994f4bef60735/src/level_data.asm#L25-L26

When we look at the data for level 3 on planet 1 we see that there's quite a bit to unpick here:

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/level_data.asm#L761-L781

The initial configuration of the licker ship enemy is defined in `planet1Level3Data`. This controls the behaviour
of the ships until you first shoot them. So you can see the sprite defined for the ship is `LICKERSHIP_SEED` in this
initial state, i.e. the floating dot I described earlier. In the second last line we can see a reference to 
`lickerShipWaveData`. These are references to a different set of wave data invoked when the enemy is struck by
a bullet from your gilby for the first time. What happens is the game switches to using the configuration in 
`lickerShipWaveData` when you first it hit with a bullet. In the earlier levels this will be just a spinning ring,
but in this level it turns the harmless floating dots into the intensely frustrating licker ships.

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/level_data.asm#L761-L767

This is what the licker ship data looks like:

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/level_data2.asm#L60-L66

This is the configuration data that controls the behaviour and appearance of the licker ships. The bit that 
defines their behaviour is in the last two bytes of the third line:

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/level_data2.asm#L63

By setting these to `$01` we're defining two sets of behaviour. The first is to gravitate immediately towards the
player and the second is to stick to the player as much as possible, sapping their energy.

This is the place in the code where these settings are inspected to determine the behaviour:

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/iridisalpha.asm#L2048-L2052

There is one other piece of configured behaviour of the licker ships that makes them so difficult to get past, one
I only noticed when writing this: hitting the licker ships results in no increase in energy!

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/level_data.asm#L38

The 3rd byte in this line is set to `$00`:

https://github.com/mwenge/iridisalpha/blob/1d8c2f1f4c266d7372a3b41cfaf3ee376f2f8d17/src/level_data2.asm#L66

So the licker ship data has this flag set to `$00`, so not only do the ships immediately jump on you and start sapping
your energy, killing any of them during this level results in getting no energy back! 

This is clearly stacking the odds way too high against the casual player way too soon in the game in my opinion. So
to give the novice player (and me) a chance of progressing and exploring the game I've added a build option that
applies the following patch to the game:

https://github.com/mwenge/iridisalpha/blob/36bcacfbd5de7bb363623d8ec5182a4e6db41b20/src/level_data2-easymode.diff#L1-L17

This toggles off the behaviour of immediately gravitating to the player's ship and allows the player to accumulate
energy when killing the licker ships. For me, this provides a nice balance between incrementing the difficulty a bit
and giving the player the chance to actually make some progress. To try out the easy mode, do:

```
make runeasy
```

You can try it out here:

https://lvllvl.com/c64/?gid=37124df5a665dacc3f8f3d7c868cbda2

## Bug: Ships from the last level in the previous game show up when you start a new game

When you start a new game, enemies from the previous game show up in the first wave. For most people starting out this
will take the form of a few residual 'licker ships' zapping them just as they're getting started.

This bug happens because the 'wave' data isn't cleared down when a new game starts. So whatever is in there from the previous
game gets used until they're flushed out by being killed and replaced with the level's proper enemy data.

This isn't a problem for the first game after Iridis Alpha is loaded because the first level's data is hardcoded in there:

https://github.com/mwenge/iridisalpha/blob/3763f48e81772c7d99b86e9d54aa8a2f2784e982/src/iridisalpha.asm#L1166-L1187

The fix is simple enough, we initialize the active wave data stored in `activeShipsWaveDataLoPtrArray` and `activeShipsWaveDataHiPtrArray`
with the first level's data whenever we start a new game. 

https://github.com/mwenge/iridisalpha/blob/3763f48e81772c7d99b86e9d54aa8a2f2784e982/src/iridisalpha.asm#L1005-L1011

https://github.com/mwenge/iridisalpha/blob/3763f48e81772c7d99b86e9d54aa8a2f2784e982/src/iridisalpha.asm#L8881-L8894

You can try out the bugfixed version of Iridis Alpha by doing the following:

```sh
git checkout bugfixes
make runcustom
```

## [GenPlan](https://github.com/mwenge/iridisalpha/blob/4250b80a10adb10fa21703395c681743314853c2/src/iridisalpha.asm#L6098): The algorithm for generating the planet surfaces

This is the [routine](https://github.com/mwenge/iridisalpha/blob/4250b80a10adb10fa21703395c681743314853c2/src/iridisalpha.asm#L6098) Minter devoted some time to in his development diary.


https://github.com/mwenge/iridisalpha/blob/d581c8da64a77a0cf4aa3fca9737883158868382/src/iridisalpha.asm#L6607-L6643

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

## Bug: Pressing F1 during Attract Mode Allows You to Resume the Game at a Random Level

After a minute or two in the title screen, the game enters 'Attract Mode' and plays a random level on autopilot for a few seconds. If you press F1 during this play you enter the 'Made in France' pause-mode mini game. If you press F1 again you can now start playing the level 'Attract Mode' selected at random.

This is because the `CheckKeyboardInGame` routine doesn't try to prevent you from entering 'Pause Mode' while Attract Mode is running:

https://github.com/mwenge/iridisalpha/blob/8c28bb4a3de73ab5a8277125c3842846e9634e77/src/iridisalpha.asm#L7372-L7423

Here's the cheat in action:

<img src="https://user-images.githubusercontent.com/58846/107146381-c2fabb00-693f-11eb-8e0d-e3a4856b5964.gif" width="500">

[`iridisalpha.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/iridisalpha.asm
[`madeinfrance.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/madeinfrance.asm
[`dna.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/dna.asm
[`charset.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/charset.asm
[`sprites.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/sprites.asm
[`bonusphase_graphics.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/bonusphase_graphics.asm
[`bonusphase.asm`]: https://github.com/mwenge/iridisalpha/blob/master/src/bonusphase.asm
[common patterns]: https://github.com/mwenge/iridisalpha/blob/master/src/PATTERNS.md
