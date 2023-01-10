.PHONY: all clean run

D64_IMAGE = "bin/torus2.d64"
D64_ORIG_IMAGE = "orig/torus2.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: clean d64_orig run_orig

sources: src/torus2.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/torus2.prg -L bin/list-co1.txt -l bin/labels.txt src/torus2.asm

check: sources
	echo "c5e4ada291c3a70ce50b7766fc6a066c  bin/torus2.prg" | md5sum -c

torus2.prg: check

d64: torus2.prg
	$(C1541) -format "torus2,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/torus2.prg "torus2"
	$(C1541) $(D64_IMAGE) -list

d64_orig:
	$(C1541) -format "torus2,rq" d64 $(D64_ORIG_IMAGE)
	$(C1541) $(D64_ORIG_IMAGE) -write orig/torus2.prg "torus2"
	$(C1541) $(D64_ORIG_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

run_orig: d64
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/torus2.prg
	-rm bin/*.txt
