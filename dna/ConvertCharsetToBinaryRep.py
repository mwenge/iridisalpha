f = open("src/charset.asm", 'r')
o = open("src/charset-bin.asm", 'w')

c = 0
while True:
    l = f.readline()
    if not l:
        break
    bs = l[33:65].replace("$","").split(',')
    bins = [(bin(int(b, 16))[2:].zfill(8)) for b in bs]
    o.write(l)
    h = ("0" + format(c, 'x'))[-2:]
    o.write((" " * 40) + "; CHARACTER $" + h + '\n')
    c += 1
    for b in bins:
        o.write((" " * 40) + "; " + b + "   " + b.replace("0", " ").replace("1","*") + '\n')
    o.write('\n')
