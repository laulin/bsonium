import sys
import struct
import random

def make_document(size):
    return struct.pack("=I{}sb".format(size), size, b"\xFF"*size, 0)

if __name__ == "__main__":
    document_number = int(sys.argv[1])
    file_name = sys.argv[2]

    with open(file_name, "wb") as f:
        for i in range(document_number):
            f.write(make_document(4))
