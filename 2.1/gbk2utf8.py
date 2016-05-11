import sys

a = open(sys.argv[1])
b = open(sys.argv[1]+".utf8", "w", encoding="utf8")
b.write(a.read())
