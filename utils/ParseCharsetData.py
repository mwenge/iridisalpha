f = open("../src/compressed-charset.asm", 'r')
o = open("../src/decompressed-charset.asm", 'w')

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

def writeChar(cur, cur_raw, char_count, cur_byte):
    raw_bytes = ".BYTE " + ','.join(cur_raw)

    buf = []
    for i in range(0, len(cur_raw)):
        cbi = cur_byte + i
        if cbi in labels:
            if buf:
                writeBytes(buf)
            o.write('\n' + labels[cbi] + '\n')
            buf = []

        buf.append(cur_raw[i])
        if len(buf) % 8 == 0:
            writeBytes(buf)
            buf = []
    writeBytes(buf)

    o.write(" " * (38 - len(raw_bytes)) + "  ;.BYTE " + ','.join(cur[:8]) + '\n')

    h = ("0" + format(char_count, 'x'))[-2:]
    o.write((" " * 48) + "; CHARACTER $" + h + '\n')

    hex_chars = list(map(lambda x: x.replace("$",""), cur[:8]))
    print(hex_chars)
    bins = [(bin(int(b, 16))[2:].zfill(8)) for b in hex_chars]
    for b in bins:
        o.write((" " * 48) + "; " + b + "   " + b.replace("0", " ").replace("1","*") + '\n')

    del cur[:8]

cur = []
cur_raw = []
tag = "$A1B"
char_count = 0
index = 2
while (index < len(bytes)):
    i = index - 2

    if len(cur) >= 8:
        writeChar(cur, cur_raw, char_count, i - 8)
        char_count += 1
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

cur += bytes[-2:]
cur_raw += bytes[-2:]
writeChar(cur, cur_raw, char_count, i - 8)

