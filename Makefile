.PHONY: all clean run

D64_IMAGE = "bin/iridisalpha.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: clean d64_orig run_orig

iridisalpha.prg: src/iridisalpha.asm src/bonusphase_graphics.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/ia.prg -L bin/list-co1.txt -l bin/labels.txt src/iridisalpha.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/bonusphase_graphics.prg src/bonusphase_graphics.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/enemy_sprites.prg src/enemy_sprites.asm
	exomizer sfx sys bin/ia.prg bin/bonusphase_graphics.prg,0xe000 bin/enemy_sprites.prg,0xe830 -n -o bin/iridisalpha.prg
	md5sum bin/ia.prg bin/ia-bench.prg
	md5sum bin/bonusphase_graphics.prg bin/bonusphase_graphics-bench.prg
	md5sum bin/enemy_sprites.prg bin/enemy_sprites-bench.prg

d64: iridisalpha.prg
	$(C1541) -format "iridisalpha,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/iridisalpha.prg "iridisalpha"
	$(C1541) $(D64_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE)
	-rm bin/iridisalpha.prg
	-rm bin/ia.prg
	-rm bin/bonusphase_graphics.prg
	-rm bin/*.txt
