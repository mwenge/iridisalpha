import sys
import os

f = open("../src/iridisalpha.asm", 'r')
ia = f.read()
f.close()

f = open("../src/level_data.asm", 'r')
ld = f.read()
f.close()

ls = ["fA050", "fA708", "fA2D0", "f9BA0","f1800", "f1DE0", "fA0A0", "f1370",
"f1A70", "f1E58", "f1140", "f11B8", "f13E8", "f13C0", "f9B00", "fA6E0",
"f1D18", "fA948", "fA998", "fA168", "fA000", "fA578", "fA5A0", "f1528",
"f1000", "f10C8", "f1968", "f1B60", "f1BD8", "f9DA8", "f9E70", "fA410",
"fA528", "fA5C8", "fA8C0", "fAA38", "fA5F0", "fA370", "fA398", "fA190",
"f9FD8", "f1EA8", "f1AE8", "f1C50", "f1C78", "f1CC8", "f1078", "f1F20",
"f1230", "f9C68", "f1640", "f12D0", "f9DF8", "fA280", "fA438", "fA920",
"fAA88", "fA488", "f9EC0", "fA1B8", "f9F88", "f1320", "f1A20", "f19D0",
"f1F98", "f1D90", "f1438", "f1758", "f17A8", "f9CB8", "fA7D0", "fA4D8",
"fA9E8", "f14B0", "f9D58", "fA730", "f9B50", "fA668", "f18F0", "fA1E0",
"f9F38", "fA230", "f1578", "f1708", "f9BF0", "f9D08", "fA690", "fA9C0",
"f1280", "f1500", "f1690", "f1460", "fA780", "fA820", "fA870", "fA2D0",
"fAA10", "fAA60", "fA820", "fA208"]

for i, l in enumerate(ls):
    level = 20 if (i+1) % 20 == 0 else (i+1) % 20
    planet = int((i) / 20) + 1
    ia = ia.replace(l, "planet" + str(planet) + "Level" + str(level) + "Data") 
    ld = ld.replace(l, "planet" + str(planet) + "Level" + str(level) + "Data") 

f = open("../src/iridisalpha.asm", 'w')
f.write(ia)
f.close()

f = open("../src/level_data.asm", 'w')
f.write(ld)
f.close()
