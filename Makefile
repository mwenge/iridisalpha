.PHONY: all clean run

D64_IMAGE = "bin/iridisalpha.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: clean d64_orig run_orig

iridisalpha.prg: src/iridisalpha.asm src/bonusphase_graphics.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/ia.prg -L bin/list-co1.txt -l bin/labels.txt src/iridisalpha.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/charsetandspritedata.prg src/bonusphase_graphics.asm
	exomizer sfx sys bin/ia.prg bin/charsetandspritedata.prg,0xe000 -n -o bin/iridisalpha.prg
	md5sum bin/ia.prg bin/ia-bench.prg
	md5sum bin/charsetandspritedata.prg bin/charsetandspritedata-bench.prg

iridisalpha-vsf.prg: src/iridisalpha.tas
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/iridisalpha-vsf.prg -L bin/list-co1.txt -l bin/labels.txt src/iridisalpha.tas

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
	-rm bin/charsetandspritedata.prg
	-rm bin/*.txt
