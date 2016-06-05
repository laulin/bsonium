 import std.stdio;

import bson_parser;
import bson_value;

unittest
{
    BSONParser parser;
    BSONValue doc = parser.parse_document([0,0,0,0,0,0]);
    assert(doc.type() == BSON_TYPE.ARRAY);
}

unittest
{
    BSONParser parser;
    BSONValue doc = parser.parse_document([0,0,0,0,0,0]);
    assert(doc.array() == []);
}

unittest
{
    BSONParser parser;
    ubyte id;
    string key;
    byte[] data = [66, 'c', 'a', 0, 123];
    parser.parse_header(data, id, key);

    assert(id == 66);
    assert(key == "ca");
    assert(data == [123]);
}

unittest
{
    BSONParser parser;
    byte[] data = [11,0,0,0,  cast(byte)BSON_TYPE.INT64, 'c', 0,   1,0,0,0,0,0,0,0,   0];

    BSONValue doc = parser.parse_document(data);
    assert(doc.array() == [BSONValue("c", 1)]);
}


unittest
{
    BSONParser parser;
    byte[] data = [9,0,0,0,  cast(byte)BSON_TYPE.STRING, 'c', 0,   1,0,0,0, 'a',0,   0];

    BSONValue doc = parser.parse_document(data);
    assert(doc.array() == [BSONValue("c", "a")]);
}

unittest
{
    BSONParser parser;
    parser.set_string_as_binary(true);

    byte[] data = [9,0,0,0,  cast(byte)BSON_TYPE.STRING, 'c', 0,   1,0,0,0, 'a',0,   0];

    BSONValue doc = parser.parse_document(data);

    assert(doc.array() == [BSONValue("c",  cast(byte[])['a', 0])]);
}

unittest
{
    BSONParser parser;
    byte[] data = [9,0,0,0,  cast(byte)BSON_TYPE.BINARY_GENERIC, 'b', 0,   1,0,0,0,  0,  66,   0];

    BSONValue doc = parser.parse_document(data);
    byte[] raw_data = [66];
    assert(doc.array() == [BSONValue("b", raw_data)]);
}

unittest
{
    BSONParser parser;
    byte[] data = [8,0,0,0,  cast(byte)BSON_TYPE.ARRAY, 'z', 0, 0,0,0,0, 0,  0];

    BSONValue doc = parser.parse_document(data);
    assert(doc.array()[0] == BSONValue("z"));
}

unittest
{
    BSONParser parser;
    byte[] data = [19,0,0,0,  cast(byte)BSON_TYPE.ARRAY, 'z', 0, 11,0,0,0,   cast(byte)BSON_TYPE.INT64, 'c', 0,   1,0,0,0,0,0,0,0,  0,  0];

    BSONValue doc = parser.parse_document(data);
    assert(doc.array()[0].array() == [BSONValue("c", 1)]);
}
