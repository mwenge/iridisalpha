# Iridis Alpha: Introduction to the Source Code

Iridis Alpha consists of a number of sub-games in addition to the main game.

`iridisalpha.asm
This file contains the source for the main game. 

`charset.asm
This file contains the character sets used in the game.

'charsetandspritedata.asm
'sprites.asm
These file contain the game's sprites and some additional character set data. As `charsetandspritedata.asm` needs to end up at adress $E000, and since it is not possible to load data directly to that address when loading a C64 binary from tape or image, our build process uses a tool called Exomizer to compress the data in `charsetandspritedata.asm` in `iridisalpha.prg` and then decompress it to $E000 when the program is loading.

`madeinfrance.asm
This is the self-contained pause-mode game, called 'Made in France' or 'MIF' for short. You can access it during game play by pressing 'F1'.

`dna.asm
This is a game within the pause-mode game. Originally released on Compunet, you can access it from with 'Made in France' by pressing '*'. You exit it by pressing '*' again.

## Some notes on  `iridisalpha.asm

