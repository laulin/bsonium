import bsonium;
import std.stdio;

// --- cast & constructor ---

unittest
{
    //make int64
    auto x = BSONValue(666);
    assert(x.int64() == 666);
}

unittest
{
    //make string
    auto x = BSONValue("666");
    assert(x.str() == "666");
}

unittest
{
    //make binary
    byte[] source = [1,2,3];
    auto x = BSONValue(source);
    assert(x.bin() == source);
}

unittest
{
    //make array
    string[] source = ["1","2","3"];
    auto x = BSONValue(source);
    assert(x.array() == [BSONValue("1"), BSONValue("2"), BSONValue("3")]);
}

unittest
{
    //make DOCUMENT
    string[string] source = ["1" : "2"];
    auto x = BSONValue(source);
    assert(x.document() == ["1" : BSONValue("2")]);
}

// --- type() function ---

unittest
{
    //check int64 type
    auto x = BSONValue(666);
    assert(x.type() == BSON_TYPE.INT64);
}

unittest
{
    //check string type
    auto x = BSONValue("666");
    assert(x.type() == BSON_TYPE.STRING);
}

unittest
{
    //check bin type
    byte[] source = [1,2,3];
    auto x = BSONValue(source);
    assert(x.type() == BSON_TYPE.BINARY_GENERIC);
}

unittest
{
    //make array
    string[] source = ["1","2","3"];
    auto x = BSONValue(source);
    assert(x.type() == BSON_TYPE.ARRAY);
}

unittest
{
    //make DOCUMENT
    string[string] source = ["1" : "2"];
    auto x = BSONValue(source);
    assert(x.type() == BSON_TYPE.DOCUMENT);
}
