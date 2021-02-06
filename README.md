# Iridis Alpha (1986) by Jeff Minter
<img src="https://www.c64-wiki.com/images/a/a2/Iridisalphacover.jpg" height=300><img src="https://user-images.githubusercontent.com/58846/106015821-c330c600-60b6-11eb-9e5c-321c1320b7b3.gif" height=300>


This is the reverse-engineered and [commented source code] for the 1986 Commodore 64 game Iridis Alpha by Jeff Minter. Following the build instructions below you can compile and run Iridis Alpha from scratch yourself on a Linux or Windows desktop. Iridis Alpha was written in 6502 assembler so might be a challenge to read and understand, even for someone who is already familiar with low-level languages such as C. The objective of providing the commented code here is to allow an interested reader to understand the techniques Minter used when coding the game and gain some insight into the methods and techniques used to create a then state-of-the-art Commodore 64 game. The place to start is the [overview of the code in the src directory](https://github.com/mwenge/iridisalpha/tree/master/src).

If you just want to play the game, you can do so in your browser at https://iridisalpha.xyz. (Ctrl key is 'Fire', Arrow Keys to move.) You might find [the game's original manual](https://github.com/mwenge/iridisalpha/tree/master/src/OriginalGameManual.md) a useful read to try and figure out what on earth is going on!

## Current Status
The game compiles and plays. The routines in [the main game](https://github.com/mwenge/iridisalpha/tree/master/src/iridisalpha.asm) are all labelled. Character set data, sprite data, and mini-games have been separated out but noall of them are commented yet. Because there is so much character and sprite data, and because Iridis Alpha contains two sub games, it was necessary to use a compressor ([Exomizer]) to produce the final binary. Interesting findings, some analysis of the game logic and an overview of the code's structure [can be found here](https://github.com/mwenge/iridisalpha/tree/master/src).


## Build Requirements
* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]
* [Exomizer][Exomizer]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://gridrunner.xyz]: https://mwenge.github.io/gridrunner.xyz
[commented source code]:https://github.com/mwenge/iridisalpha/blob/master/src/
[DNA]:https://github.com/mwenge/iridisalpha/blob/master/demos/dna
[Torus]:https://github.com/mwenge/iridisalpha/blob/master/demos/torus
[Torus2]:https://github.com/mwenge/iridisalpha/blob/master/demos/torus2
[Iridis Spaceship]:https://github.com/mwenge/iridisalpha/blob/master/demos/iridis_spaceship
[Made in France]:https://github.com/mwenge/iridisalpha/blob/master/demos/mif
[Exomizer]:https://bitbucket.org/magli143/exomizer/wiki/Home

## Build Instructions
To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`iridisalpha.prg`) do:

```sh
$ make iridisalpha.prg
```

## Iridis Alpha's Side Projects
During the development of Iridis Alpha Jeff Minter released a number of demos and mini-games to friends on Compunet. These are collected in the [demos folder](https://github.com/mwenge/iridisalpha/tree/master/demos). They are:

* [DNA], a demo by Jeff Minter containing some preparatory work for the main game.
* [Torus], another demo by Jeff Minter containing some preparatory work for the main game.
* [Torus2], another iteration on Torus.
* [Iridis Spaceship], a non-interactive demo of the spaceship sprites.
* [Made in France], Iridis Alpha's pause-mode mini game.
