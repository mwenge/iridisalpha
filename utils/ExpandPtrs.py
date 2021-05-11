import sys
import os

if len(sys.argv) < 2:
    print("No filename given")
    exit()

fn = sys.argv[1]
if not os.path.isfile(fn):
    print(fn + " does not exist")
    exit()

f = open(fn, 'r')
ls = f.readlines()
f.close()


o = open(fn, 'w')

for l,i in enumerate(ls):
    if "WriteToScreen" not in l:
        continue
    p1 = ls[i-1]
    p2 = ls[i-2]
    if "$" not in p1 or "$" not in p2:
        continue
    b1 = p1.split('#')
    b2 = p2.split('#')
    l1 = b1[0] + "#>" + b1[1] + b2[1]
    l2 = b2[0] + "#<" + b1[1] + b2[1]
    ls[i-1] = l1
    ls[i-2] = l2

for l in ls: o.write(l)
