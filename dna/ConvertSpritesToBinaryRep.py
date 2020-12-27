f = open("src/sprites.asm", 'r')
o = open("src/sprites-bin.asm", 'w')

sc = 0
ls = []
while True:
    line = f.readline().strip()
    if not line:
        break
    ls += [line]
    if len(ls) < 8:
        continue

    h = ("0" + format(sc, 'x'))[-2:]
    o.write("; SPRITE $" + h + '\n')
    sc += 1

    bins = []
    hbs = []
    for l in ls:
        hbs += l[23:55].split(',')
        bs = l[23:55].replace("$","").split(',')
        bins += [(bin(int(b, 16))[2:].zfill(8)) for b in bs]

        while len(bins) >=3:
            sl = bins[:3]
            slb = hbs[:3]
            del bins[:3]
            del hbs[:3]
            sl = [s for l in sl for s in l]

            xs = map(lambda x: x.replace("0", " ").replace("1","*"), sl)
            o.write("; " + ",".join(slb) + " " + "".join(sl) + " " +  "".join(xs) + '\n') 
    ls = []

