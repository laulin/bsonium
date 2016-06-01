import std.stdio;
import std.exception;
import std.format;
import std.conv;

enum BSON_TYPE {INT64=0x12, BINARY_GENERIC=0x05, STRING=0x02, ARRAY=0x04};

struct BSONValue
{
    BSON_TYPE _type;

    string _key;
    BSONValue[] _array;

    // terminal
    long int_64_value;
    string string_value;
    byte[] binary_value;

    this(string key, long value)
    {
        int_64_value = value;
        _key = key;
        _type = BSON_TYPE.INT64;
    }

    long int64()
    {
        enforce(_type == BSON_TYPE.INT64);
        return int_64_value;
    }

    this(string key, string value)
    {
        string_value = value;
        _key = key;
        _type = BSON_TYPE.STRING;
    }

    string str()
    {
        enforce(_type == BSON_TYPE.STRING);
        return string_value;
    }

    this(string key, byte[] value)
    {
        binary_value = value;
        _key = key;
        _type = BSON_TYPE.BINARY_GENERIC;
    }

    byte[] bin()
    {
        enforce(_type == BSON_TYPE.BINARY_GENERIC);
        return binary_value;
    }

    this(string key, BSONValue[] values)
    {
        _type = BSON_TYPE.ARRAY;
        _key = key;
        foreach(e; values)
        {
            _array ~= e;
        }
    }

    this(string key)
    {
        _key = key;
        _type = BSON_TYPE.ARRAY;
    }

    ref BSONValue[] array()
    {
        enforce(_type == BSON_TYPE.ARRAY);

        return _array;
    }

    BSON_TYPE type()
    {
        return _type;
    }

    string key()
    {
        return _key;
    }

}
