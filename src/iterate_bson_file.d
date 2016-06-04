import std.stdio;
import std.file;
import std.format;

import bson_parser;
import bson_value;

class IterateBSONFile
{
    ulong file_size;
    File f;

    void open(string file_name)
    {
        file_size = getSize(file_name);
        f = File(file_name, "rb");
    }

    void close()
    {
        f.close();
        file_size = 0;
    }

    byte[][] iterate_binary(int document_number)
    {
        byte[][] output;

        byte[int.sizeof] length_buffer;
        byte[] buffer;
        int counter = 0;

        while(file_size > 0 && counter < document_number)
        {
            f.rawRead(length_buffer);
            int size = *cast(int*)length_buffer.ptr;

            if(size > 32767)
            {
                throw new Exception(format("document is too big (%d bytes)", size));
            }

            buffer.length = size + 1;
            f.rawRead(buffer);
            int total_size = 4 + size + 1;
            file_size = file_size - total_size;

            output ~= length_buffer ~ buffer;
            counter++;
        }

        return output;
    }

    BSONValue[] iterate_bson(int document_number)
    {
        byte[][] result = iterate_binary(document_number);
        BSONValue[] output;
        output.length = result.length;
        BSONParser parser = BSONParser();
        
        foreach(i, document; result)
        {
            output[i] = parser.parse_document(document);
        }

        return output;
    }
}

unittest
{
    // need python3 test/data/make_void_doc.py 100000 test/data/void_4.bson
    IterateBSONFile iterator = new IterateBSONFile();
    iterator.open("test/data/void_4.bson");

    byte[][] result;
    int counter = 0;
    do
    {
        result = iterator.iterate_binary(1000);
        counter += result.length;
    }
    while(result.length != 0);

    iterator.close();

    assert(counter == 100000);
}

unittest
{
    // need python3 test/data/make_int_doc.py 100000 test/data/int.bson
    IterateBSONFile iterator = new IterateBSONFile();
    iterator.open("test/data/int.bson");

    byte[][] result;
    int counter = 0;
    do
    {
        result = iterator.iterate_binary(1000);
        counter += result.length;
    }
    while(result.length != 0);

    iterator.close();

    assert(counter == 100000);
}

unittest
{
    // need python3 test/data/make_int_doc.py 100000 test/data/int.bson
    IterateBSONFile iterator = new IterateBSONFile();
    iterator.open("test/data/int_100.bson");

    BSONValue[] result;
    int counter = 0;
    do
    {
        result = iterator.iterate_bson(10);
        counter += result.length;
    }
    while(result.length != 0);

    iterator.close();

    assert(counter == 100);
}
