# MIF (Made In France) by Jeff Minter

<img src="https://user-images.githubusercontent.com/58846/103455890-eac78500-4ce8-11eb-9d92-867c0c3ea825.gif" width=500>


This is the disassembled and [commented source code] for Iridis Alpha's pause-mode mini-game 'Made In France' by Jeff Minter. 

## Requirements

* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://gridrunner.xyz]: https://mwenge.github.io/gridrunner.xyz
[commented source code]:https://github.com/mwenge/iridisalpha/blob/master/mif/src/mif.asm
To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`mif.prg`) do:

```sh
$ make mif
```
