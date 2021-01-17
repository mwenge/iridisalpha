.PHONY: all clean run

D64_IMAGE = "bin/iridisalpha.d64"
D64_ORIG_IMAGE = "orig/iridisalpha.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: clean d64_orig run_orig

iridisalpha.prg: src/iridisalpha.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/iridisalpha.prg -L bin/list-co1.txt -l bin/labels.txt src/iridisalpha.asm
	md5sum bin/iridisalpha.prg bin/iridisalpha-vsf.prg

iridisalpha-vsf.prg: src/iridisalpha.tas
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/iridisalpha-vsf.prg -L bin/list-co1.txt -l bin/labels.txt src/iridisalpha.tas

d64: iridisalpha.prg
	$(C1541) -format "iridisalpha,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/iridisalpha.prg "iridisalpha"
	$(C1541) $(D64_IMAGE) -list

d64_orig:
	$(C1541) -format "iridisalpha,rq" d64 $(D64_ORIG_IMAGE)
	$(C1541) $(D64_ORIG_IMAGE) -write orig/iridisalpha.prg "iridisalpha"
	$(C1541) $(D64_ORIG_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

run_orig: d64
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/iridisalpha.prg
	-rm bin/*.txt
