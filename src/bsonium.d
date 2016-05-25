import std.stdio;
import std.exception;
import std.format;

enum BSON_TYPE {DOCUMENT=0x00, INT64=0x12, BINARY_GENERIC=0x05, STRING=0x02, ARRAY=0x04};

struct BSONValue
{
    BSON_TYPE _type;

    // containers
    BSONValue[string] _document;
    BSONValue[] _array;

    // terminal
    long int_64_value;
    string string_value;
    byte[] binary_value;

    this(long value)
    {
        int_64_value = value;
        _type = BSON_TYPE.INT64;
    }

    long int64()
    {
        enforce(_type == BSON_TYPE.INT64);
        return int_64_value;
    }

    this(string value)
    {
        string_value = value;
        _type = BSON_TYPE.STRING;
    }

    string str()
    {
        enforce(_type == BSON_TYPE.STRING);
        return string_value;
    }

    this(byte[] value)
    {
        binary_value = value;
        _type = BSON_TYPE.BINARY_GENERIC;
    }

    byte[] bin()
    {
        enforce(_type == BSON_TYPE.BINARY_GENERIC);
        return binary_value;
    }

    this(T)(T[] values)
    {
        _type = BSON_TYPE.ARRAY;

        foreach(e; values)
        {
            _array ~= BSONValue(e);
        }
    }

    ref BSONValue[] array()
    {
        enforce(_type == BSON_TYPE.ARRAY);

        return _array;
    }

    this(T)(T[string] values)
    {
        _type = BSON_TYPE.DOCUMENT;

        foreach(k, v; values)
        {
            _document[k] = BSONValue(v);
        }
    }

    ref BSONValue[string] document()
    {
        enforce(_type == BSON_TYPE.DOCUMENT);

        return _document;
    }

    BSON_TYPE type()
    {
        return _type;
    }

}

void main(string[] argv)
{

}
