import bsonium;

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

// --- opIndex() ---

unittest
{
    //opIndex on array
    string[] source = ["1","2","3"];
    auto x = BSONValue(source);
    assert(x[0] == BSONValue("1"));
}


unittest
{
    //opIndex on document
    string[string] source = ["1":"2"];
    auto x = BSONValue(source);
    assert(x["1"] == BSONValue("2"));
}

// --- opIndexAssign ---


unittest
{
    //opIndex on document
    string[string] source = ["1":"2"];
    auto x = BSONValue(source);
    x["4"] = BSONValue(2);
    assert(x["4"] == BSONValue(2));
}
