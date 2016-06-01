import bson_value;
import std.stdio;

// --- cast & constructor ---

unittest
{
    //make int64
    auto x = BSONValue("x", 666);
    assert(x.int64() == 666);
}

unittest
{
    //make string
    auto x = BSONValue("x", "666");
    assert(x.str() == "666");
}

unittest
{
    //make binary
    byte[] source = [1,2,3];
    auto x = BSONValue("x", source);
    assert(x.bin() == source);
}

unittest
{
    //make array
    BSONValue[] source = [BSONValue("y1",1),BSONValue("y2",2),BSONValue("y3",3)];
    auto x = BSONValue("x", source);
    assert(x.array() == [BSONValue("y1",1),BSONValue("y2",2),BSONValue("y3",3)]);
}


// --- type() function ---

unittest
{
    //check int64 type
    auto x = BSONValue("x", 666);
    assert(x.type() == BSON_TYPE.INT64);
}

unittest
{
    //check string type
    auto x = BSONValue("x", "666");
    assert(x.type() == BSON_TYPE.STRING);
}

unittest
{
    //check bin type
    byte[] source = [1,2,3];
    auto x = BSONValue("x", source);
    assert(x.type() == BSON_TYPE.BINARY_GENERIC);
}

unittest
{
    //make array
    BSONValue[] source = [BSONValue("y1",1),BSONValue("y2",2),BSONValue("y3",3)];
    auto x = BSONValue("x", source);
    assert(x.type() == BSON_TYPE.ARRAY);
}

unittest
{
    //make DOCUMENT by default
    auto x = BSONValue("x");
    assert(x.type() == BSON_TYPE.ARRAY);
}
