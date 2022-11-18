import sys
ls = sys.stdin.readlines()
for l in ls:
    o = int(l[1:].strip(),16)
    n = "f" + hex(o + 0x0008)[2:].upper()
    print(n)
