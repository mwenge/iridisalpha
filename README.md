# Iridis Alpha by Jeff Minter

<img src="http://www.llamasoftarchive.org/oldsite/llamasoft/screens/c64iridis.jpg" width=500>


This is the disassembled and [commented source code] for the 1986 Commodore 64 game Iridis Alpha by Jeff Minter. 

You can play Iridis Alpha in your browser at [https://iridisalpha.xyz]. (Ctrl key is 'Fire', Arrow Keys to move.)

## Also Contains:
* [DNA], a demo by Jeff Minter containing some preparatory work for the main game.
* [Torus], another demo by Jeff Minter containing some preparatory work for the main game.

## Requirements
* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://gridrunner.xyz]: https://mwenge.github.io/gridrunner.xyz
[commented source code]:https://github.com/mwenge/gridrunner/blob/master/src/gridrunner.asm
[DNA]:https://github.com/mwenge/iridisalpha/blob/master/dna
[Torus]:https://github.com/mwenge/iridisalpha/blob/master/torus

To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`iridisalpha.prg`) do:

```sh
$ make iridisalpha
```
