.PHONY: all clean run

D64_IMAGE = "bin/torus.d64"
D64_ORIG_IMAGE = "orig/torus.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: clean d64_orig run_orig

sources: src/torus.asm
	64tass -Wall --cbm-prg -o bin/torus.prg -L bin/list-co1.txt -l bin/labels.txt src/torus.asm

check: sources
	echo "006ba0a6f5ecddb4950ae339e477168c  bin/torus.prg" | md5sum -c

torus.prg: check

d64: torus.prg
	$(C1541) -format "torus,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/torus.prg "torus"
	$(C1541) $(D64_IMAGE) -list

d64_orig:
	$(C1541) -format "torus,rq" d64 $(D64_ORIG_IMAGE)
	$(C1541) $(D64_ORIG_IMAGE) -write orig/torus.prg "torus"
	$(C1541) $(D64_ORIG_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

run_orig: d64
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/torus.prg
	-rm bin/*.txt
