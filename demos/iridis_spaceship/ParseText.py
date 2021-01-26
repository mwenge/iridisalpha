
input = "$0859:                     .BYTE $41,$20,$27,$4C,$49,$54,$54,$4C\n$0861:                     .BYTE $45,$20,$53,$4F,$4D,$45,$54,$48\n$0869:                     .BYTE $49,$4E,$47,$27,$20,$46,$52,$4F\n$0871:                     .BYTE $4D,$20,$49,$52,$49,$44,$49,$53\n$0879:                     .BYTE $2D,$41,$4C,$50,$48,$41\n"


bytes = [b for l in input.split('\n') for b in l[33:65].strip().split(',') if b != ""]
chars = [chr(int("0x" + b[-2:], 16)) for b in bytes]

n = 8
lines = [bytes[i:i + n] for i in range(0, len(bytes), n)]
comments = [chars[i:i + n] for i in range(0, len(chars), n)]

print(lines)
print(comments)

for i, l in enumerate(lines):
    print((" " * 8) + ";     " +  "   ".join(comments[i]))
    print((" " * 8) + ".BYTE " + (",".join(l)))

print((" " * 8) + ".TEXT \"" + "".join(chars) + "\"")
