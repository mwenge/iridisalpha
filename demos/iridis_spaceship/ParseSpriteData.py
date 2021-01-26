f = open("src/sprites.asm", 'r')
o = open("src/decompressed-sprite.asm", 'w')

bytes = []
while True:
    l = f.readline()
    if not l:
        break
    bytes += list(filter(None, l[14:45].strip().split(',')))

print(bytes)

def addSequence(cur, i):
    v = bytes[i-2]
    c = int(bytes[i-1][-2:], 16)
    cur += [v] * c

def writeSprite(cur, cur_raw, sprite_count):
    h = ("0" + format(sprite_count, 'x'))[-2:]
    o.write((" " * 8) + "; SPRITE $" + h + '\n')

    for i in range(0,63,3):
        bs = cur[i:i+3]

        hex_chars = list(map(lambda x: x.replace("$",""), bs))
        bins = [(bin(int(b, 16))[2:].zfill(8)) for b in hex_chars]

        # * representation
        sl = [s for l in bins for s in l]
        xs = map(lambda x: x.replace("0", " ").replace("1","*"), sl)

        o.write((" " * 8) + "; " + ",".join(bs) + " " + "".join(bins) + " " +  "".join(xs) + '\n') 

    for i in range(0, len(cur_raw), 8):
        raw_bytes = (" " * 8) + ".BYTE " + ','.join(cur_raw[i:i+8])
        o.write(raw_bytes)
        o.write('\n')

    del cur[:64]

cur = []
cur_raw = []
tag = "$0F"
sprite_count = 0
index = 2
while (index < len(bytes) + 2):
    i = index - 2

    if len(cur) >= 64:
        writeSprite(cur, cur_raw, sprite_count)
        sprite_count += 1
        cur_raw = []
        
    cb = bytes[index]
    if cb == tag:
        addSequence(cur, index)
        index += 3
        cur_raw += bytes[i:i+3]
        continue

    b = bytes[i]
    cur_raw += [b]
    cur.append(b)
    index += 1

if len(cur) >= 64:
    writeSprite(cur, cur_raw, sprite_count)
    sprite_count += 1
    cur_raw = []
