.PHONY: all clean run

D64_IMAGE = "bin/dna.d64"
D64_ORIG_IMAGE = "orig/dna.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: clean d64_orig run_orig

dna.prg: src/dna.asm
	64tass -Wall --cbm-prg -o bin/dna.prg -L bin/list-co1.txt -l bin/labels.txt src/dna.asm
	md5sum bin/dna.prg orig/dna.prg

d64: dna.prg
	$(C1541) -format "dna,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/dna.prg "dna"
	$(C1541) $(D64_IMAGE) -list

d64_orig:
	$(C1541) -format "dna,rq" d64 $(D64_ORIG_IMAGE)
	$(C1541) $(D64_ORIG_IMAGE) -write orig/dna.prg "dna"
	$(C1541) $(D64_ORIG_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

run_orig: d64
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/dna.prg
	-rm bin/*.txt
