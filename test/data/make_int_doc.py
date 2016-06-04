import sys
import struct
import random

def make_document(value):
    key = b"index"
    int_field = struct.pack("=b{}sbq".format(len(key)), 0x12, key, 0, value)
    return struct.pack("=I{}sb".format(len(int_field)), len(int_field), int_field, 0)

if __name__ == "__main__":
    document_number = int(sys.argv[1])
    file_name = sys.argv[2]

    with open(file_name, "wb") as f:
        for i in range(document_number):
            f.write(make_document(i))
