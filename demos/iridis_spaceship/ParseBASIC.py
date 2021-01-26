tokens = {
"$80": "END",
"$81": "FOR",
"$82": "NEXT",
"$83": "DATA",
"$84": "INPUT#",
"$85": "INPUT",
"$86": "DIM",
"$87": "READ",
"$88": "LET",
"$89": "GOTO",
"$8A": "RUN",
"$8B": "IF",
"$8C": "RESTORE",
"$8D": "GOSUB",
"$8E": "RETURN",
"$8F": "REM",
"$90": "STOP",
"$91": "ON",
"$92": "WAIT",
"$93": "LOAD",
"$94": "SAVE",
"$95": "VERIFY",
"$96": "DEF",
"$97": "POKE",
"$98": "PRINT#",
"$99": "PRINT?",
"$9A": "CONT",
"$9B": "LIST",
"$9C": "CLR",
"$9D": "CMD",
"$9E": "SYS",
"$9F": "OPEN",
"$A0": "CLOSE",
"$A1": "GET",
"$A2": "NEW",
"$A3": "TAB(",
"$A4": "TO",
"$A5": "FN",
"$A6": "SPC(",
"$A7": "THEN",
"$A8": "NOT",
"$A9": "STEP",
"$AA": "+",
"$AB": "-",
"$AC": "*",
"$AD": "/",
"$AE": "^",
"$AF": "AND",
"$B0": "OR",
"$B1": ">",
"$B2": "=",
"$B3": "<",
"$B4": "SGN",
"$B5": "INT",
"$B6": "ABS",
"$B7": "USR",
"$B8": "FRE",
"$B9": "POS",
"$BA": "SQR",
"$BB": "RND",
"$BC": "LOG",
"$BD": "EXP",
"$BE": "COS",
"$BF": "SIN",
"$C0": "TAN",
"$C1": "ATN",
"$C2": "PEEK",
"$C3": "LEN",
"$C4": "STR",
"$C5": "VAL",
"$C6": "ASC",
"$C7": "CHR",
"$C8": "LEFT",
"$C9": "RIGHT",
"$CA": "MID",
"$CB": "GO",
"$FF": "(pi)"
}

f = open("src/basic.asm", 'r')
o = open("src/decompressed-basic.asm", 'w')

bytes = [b for l in f.readlines() for b in l[33:65].strip().split(',') if b != ""]

s = 0x87E

bbuf = []
cbuf = "" 
for b in bytes:
    s += 1
    bbuf.append(b)

    if b == '$00':
        bl = ".BYTE " + ",".join(bbuf[:-1]) 
        cl = bl + (" " * (70 - len(bl))) +  "  ; " + cbuf.strip() 
        o.write(cl + (" " * (90 - len(cl))) + " ; " + str(hex(s)).upper() + '\n')
        bbuf = [b]
        cbuf = ""
        continue

    i = int("0x" + b[1:], 16)
    char = chr(i)
    if char.isascii():
        cbuf += char
        continue

    if b in tokens:
        bl = ".BYTE " + ",".join(bbuf[:-1]) 
        cl = bl + (" " * (70 - len(bl))) +  "  ; " + cbuf.strip() 
        o.write(cl + (" " * (90 - len(cl))) + " ; " + str(hex(s)).upper() + '\n')
        cbuf = tokens[b] + " "
        bbuf = [b]
        continue

