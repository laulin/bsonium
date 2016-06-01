import std.exception;
import std.format;
import std.conv;

import bson_value;

struct BSONParser
{
    ulong position;
    ulong[] end_of_document;
    BSONValue[] documents;

    BSONValue parse_document(byte[] data)
    {
        BSONValue document = BSONValue("");

        int length = *cast(int*) data.ptr;
        long null_position = length + int.sizeof;
        enforce(data[null_position] == 0);

        parse_elements(data[int.sizeof .. int.sizeof + length], document);

        return document;
    }

    void parse_header(ref byte[] data, ref ubyte id, ref string key)
    {
        id = data[position];
        data = data[1..$];

        ulong end_of_key = 0;
        while(data[end_of_key] != 0)
        {
            end_of_key++;
        }

        key = to!string(cast(char[]) data[0 .. end_of_key]);
        data = data[end_of_key+1..$];
    }

    void parse_int64(ref byte[] data, string key, ref BSONValue parent)
    {
        long value = *cast(long*) data.ptr;
        data = data[long.sizeof .. $];
        parent.array() ~= BSONValue(key, value);
    }

    void parse_string(ref byte[] data, string key, ref BSONValue parent)
    {
        int size = *cast(int*) data.ptr;
        data = data[int.sizeof .. $];

        string value = to!string(cast(char*)data[0 .. size]);
        data = data[size+1 .. $];

        parent.array() ~= BSONValue(key, value);
    }

    void parse_binary_generic(ref byte[] data, string key, ref BSONValue parent)
    {
        int size = *cast(int*) data.ptr;
        data = data[int.sizeof .. $];

        byte subtype = *cast(byte*) data.ptr;
        enforce(subtype == 0);
        data = data[byte.sizeof .. $];

        byte[] value = data[0 .. size];
        data = data[size .. $];

        parent.array() ~= BSONValue(key, value);
    }

    void parse_array(ref byte[] data, string key, ref BSONValue parent)
    {
        BSONValue document = BSONValue(key);

        int length = *cast(int*) data.ptr;
        data = data[int.sizeof .. $];

        parse_elements(data[0 .. length], document);

        parent.array() ~= document;
        data = data[length + byte.sizeof .. $];
    }

    void parse_elements(byte[] data, ref BSONValue parent)
    {
        while(data.length > 0)
        {
            ubyte id;
            string key;

            parse_header(data, id, key);
            switch(id)
            {
                case BSON_TYPE.STRING: // string
                    parse_string(data, key, parent);
                    break;

                case BSON_TYPE.ARRAY: // array
                    parse_array(data, key, parent);
                    break;

                case BSON_TYPE.INT64: //int64
                    parse_int64(data, key, parent);
                    break;

                case BSON_TYPE.BINARY_GENERIC:
                    parse_binary_generic(data, key, parent);
                    break;

                default:
                    throw new Exception("invalid element id");
            }
        }
    }
}
