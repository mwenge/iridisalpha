import sys
import os

o = open("src/sprites.asm", 'r')
charmap = {l[17:20].strip().upper():l[22:].strip() 
             for l in o.readlines() 
             if "SPRITE" in l and l[22:].strip() != ""}


if len(sys.argv) < 2:
    print("No filename given")
    exit()

fn = sys.argv[1]
if not os.path.isfile(fn):
    print(fn + " does not exist")
    exit()

f = open(fn, 'r')
ls = f.readlines()
f.close()


p = ""
o = open(fn, 'w')

for k in charmap: o.write(charmap[k] + " = " + k + "\n")

for l in ls:
    if "currentGilbySprite" not in l:
        o.write(p)
        p = l
        continue
    if "LDA" not in p or "$" not in p:
        o.write(p)
        p = l
        continue

    c = p[:16].rstrip()[-3:]
    if c not in charmap:
        o.write(p)
        p = l
        continue

    p = p[:16].rstrip()
    cn = charmap[c]
    p = p[:-3] + cn + '\n'
    o.write(p)
    p = l

o.write(p)
