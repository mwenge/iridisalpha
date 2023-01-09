.PHONY: all clean run

D64_IMAGE = "bin/iridisalpha.prg"
D64_IMAGE_EASY = "bin/iridisalpha-easy.prg"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean run

sources: src/iridisalpha.asm src/graphics/bonusphase_graphics.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/ia.prg -L bin/list-ia.txt -l bin/labels.txt src/iridisalpha.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/bonusphase_graphics.prg -L bin/list-bonusphase_graphics.txt \
		src/graphics/bonusphase_graphics.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/enemy_sprites.prg -L bin/list-enemy_sprites.txt src/graphics/enemy_sprites.asm

check: sources
	echo "44c76416f7a4d16fac31ff99ef2d2272  bin/ia.prg" | md5sum -c
	echo "46e893399dcf28100a9bbdeb343b7a78  bin/bonusphase_graphics.prg" | md5sum -c
	echo "fe2afb0a14755d7bbc46855aa589ebee  bin/enemy_sprites.prg" | md5sum -c

iridisalpha.prg: check
	exomizer sfx sys bin/ia.prg bin/bonusphase_graphics.prg,0xe000 bin/enemy_sprites.prg,0xe830 -n -o bin/iridisalpha.prg

custom: sources
	exomizer sfx sys bin/ia.prg bin/bonusphase_graphics.prg,0xe000 bin/enemy_sprites.prg,0xe830 -n -o bin/iridisalpha.prg

run: iridisalpha.prg
	$(X64) -verbose $(D64_IMAGE)

runcustom: custom
	$(X64) -verbose $(D64_IMAGE)

release: iridisalpha.prg
	wine utils/C64.exe -cd iridisalpha bin/iridisalpha.prg --joy keyboard:1

customrelease: custom
	wine utils/C64.exe -cd iridisalpha bin/iridisalpha.prg --joy keyboard:1

clean:
	-rm $(D64_IMAGE)
	-rm bin/iridisalpha.prg
	-rm bin/ia.prg
	-rm bin/bonusphase_graphics.prg
	-rm bin/*.txt
