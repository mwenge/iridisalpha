# Iridis Alpha by Jeff Minter
<img src="https://www.c64-wiki.com/images/a/a2/Iridisalphacover.jpg" height=300><img src="https://user-images.githubusercontent.com/58846/103442991-ae494a00-4c52-11eb-9432-0f6ed61d3a5a.gif" height=300>


This is the disassembled and [commented source code] for the 1986 Commodore 64 game Iridis Alpha by Jeff Minter. 

You can play Iridis Alpha in your browser at https://iridisalpha.xyz. (Ctrl key is 'Fire', Arrow Keys to move.)

## Current Status
The game compiles and plays. Character set and sprite data has been separated out and commented. Because there is so much character and sprite data, and because Iridis Alpha contains two sub games, it was necessary to use a compressor ([Exomizser]) to produce the final binary. 

Labelling the game logic is still in progress.

## Also Contains:
* [DNA], a demo by Jeff Minter containing some preparatory work for the main game.
* [Torus], another demo by Jeff Minter containing some preparatory work for the main game.
* [Torus2], another iteration on Torus.
* [Iridis Spaceship], a non-interactive demo of the spaceship sprites.
* [Made in France], Iridis Alpha's pause-mode mini game.

## Requirements
* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]
* [Exomizer][Exomizer]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://gridrunner.xyz]: https://mwenge.github.io/gridrunner.xyz
[commented source code]:https://github.com/mwenge/gridrunner/blob/master/src/iridisalpha.asm
[DNA]:https://github.com/mwenge/iridisalpha/blob/master/dna
[Torus]:https://github.com/mwenge/iridisalpha/blob/master/torus
[Torus2]:https://github.com/mwenge/iridisalpha/blob/master/torus2
[Iridis Spaceship]:https://github.com/mwenge/iridisalpha/blob/master/iridis_spaceship
[Made in France]:https://github.com/mwenge/iridisalpha/blob/master/mif
[Exomizer]:https://bitbucket.org/magli143/exomizer/wiki/Home

To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`iridisalpha.prg`) do:

```sh
$ make iridisalpha.prg
```
