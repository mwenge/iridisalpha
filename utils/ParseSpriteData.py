f = open("../src/compressed-sprites.asm", 'r')
o = open("../src/decompressed-sprite.asm", 'w')

bytes = []
labels = {}
while True:
    l = f.readline()
    if not l:
        break
    label = l[:8].strip()
    if label:
        labels[len(bytes)] = label
    bytes += list(filter(None, l[14:45].strip().split(',')))

print(bytes)

def addSequence(cur, i):
    v = bytes[i-2]
    c = int(bytes[i-1][-2:], 16)
    cur += [v] * c

def writeBytes(buf):
    if not len(buf):
        return
    raw_bytes = (" " * 8) + ".BYTE " + ','.join(buf)
    o.write(raw_bytes)
    o.write('\n')

def writeSprite(cur, cur_raw, sprite_count, cur_byte):
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

    buf = []
    for i in range(0, len(cur_raw)):

        cbi = cur_byte + i
        if cbi in labels:
            if buf:
                writeBytes(buf)
            o.write(labels[cbi] + '\n')
            buf = []

        buf.append(cur_raw[i])
        if len(buf) % 8 == 0:
            writeBytes(buf)
            buf = []
    writeBytes(buf)

    del cur[:64]

cur = []
cur_raw = []
tag = "$1BA"
sprite_count = 0
index = 2
while (index < len(bytes) + 2):
    i = index - 2

    if len(cur) >= 64:
        writeSprite(cur, cur_raw, sprite_count, i - 64)
        sprite_count += 1
        cur_raw = []

    cb = ""
    if index < len(bytes):
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

if len(cur) >= 63:
    writeSprite(cur, cur_raw, sprite_count, i - 63)
    sprite_count += 1
    cur_raw = []
