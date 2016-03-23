import sys
import base64

#  Usage:  python XOR.py (encrypt|decrypt) inputFile key outputFile

def xor(data, key):
    for i in range(len(data)):
        data[i] ^= key[i % len(key)]
    return data

if sys.argv[1] == 'encrypt':
	data = bytearray(open(sys.argv[2],  'rb').read())
	key = bytearray(sys.argv[3])
	outdata = xor(data, key)
	out = base64.b64encode(outdata)
	outFile = open(sys.argv[4], 'wb')
	outFile.write(out)
	
if sys.argv[1] == 'decrypt':
	data = bytearray(base64.b64decode(open(sys.argv[2],  'rb').read()))
	key = bytearray(sys.argv[3])
	decode = xor(data, key)
	outFile = open(sys.argv[4], 'wb')
	outFile.write(decode)