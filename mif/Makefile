.PHONY: all clean run

D64_IMAGE = "bin/mif.d64"
D64_ORIG_IMAGE = "orig/mif.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: d64_orig run_orig

mif.prg: src/mif.asm
	64tass -Wall --cbm-prg -o bin/mif.prg -L bin/list-co1.txt -l bin/labels.txt src/mif.asm
	md5sum bin/mif.prg orig/mif.prg

d64: mif.prg
	$(C1541) -format "mif,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/mif.prg "mif"
	$(C1541) $(D64_IMAGE) -list

d64_orig:
	$(C1541) -format "mif,rq" d64 $(D64_ORIG_IMAGE)
	$(C1541) $(D64_ORIG_IMAGE) -write orig/mif.prg "mif"
	$(C1541) $(D64_ORIG_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

run_orig: d64_orig
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/mif.prg
	-rm bin/*.txt
