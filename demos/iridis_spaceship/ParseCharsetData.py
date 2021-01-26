f = open("src/charset.asm", 'r')
o = open("src/decompressed-charset.asm", 'w')

bytes = []
while True:
    l = f.readline()
    if not l:
        break
    bytes += list(filter(None, l[33:65].strip().split(',')))

print(bytes)

def addSequence(cur, i):
    v = bytes[i-2]
    c = int(bytes[i-1][-2:], 16)
    cur += [v] * c

def writeChar(cur, cur_raw, char_count):
    raw_bytes = ".BYTE " + ','.join(cur_raw)
    o.write(raw_bytes)
    o.write(" " * (38 - len(raw_bytes)) + "  ;.BYTE " + ','.join(cur[:8]) + '\n')

    h = ("0" + format(char_count, 'x'))[-2:]
    o.write((" " * 40) + "; CHARACTER $" + h + '\n')

    hex_chars = list(map(lambda x: x.replace("$",""), cur[:8]))
    print(hex_chars)
    bins = [(bin(int(b, 16))[2:].zfill(8)) for b in hex_chars]
    for b in bins:
        o.write((" " * 40) + "; " + b + "   " + b.replace("0", " ").replace("1","*") + '\n')
    o.write('\n')

    del cur[:8]

cur = []
cur_raw = []
tag = "$0F"
char_count = 0
index = 2
while (index < len(bytes)):
    i = index - 2

    if len(cur) >= 8:
        writeChar(cur, cur_raw, char_count)
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

    
