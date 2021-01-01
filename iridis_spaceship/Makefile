.PHONY: all clean run

D64_IMAGE = "bin/iridis_spaceship.d64"
D64_ORIG_IMAGE = "orig/iridis_spaceship.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: d64_orig run_orig

iridis_spaceship.prg: src/iridis_spaceship.asm
	64tass -Wall --cbm-prg -o bin/iridis_spaceship.prg -L bin/list-co1.txt -l bin/labels.txt src/iridis_spaceship.asm
	md5sum bin/iridis_spaceship.prg orig/iridis_spaceship.prg

d64: iridis_spaceship.prg
	$(C1541) -format "iridis_spaceship,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/iridis_spaceship.prg "iridis_spaceship"
	$(C1541) $(D64_IMAGE) -list

d64_orig:
	$(C1541) -format "iridis_spaceship,rq" d64 $(D64_ORIG_IMAGE)
	$(C1541) $(D64_ORIG_IMAGE) -write orig/iridis_spaceship.prg "iridis_spaceship"
	$(C1541) $(D64_ORIG_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

run_orig: d64_orig
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/iridis_spaceship.prg
	-rm bin/*.txt
