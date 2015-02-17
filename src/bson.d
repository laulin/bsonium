import std.stdio;
import std.string;
import std.conv;

struct bson_internal{
    string [] array;
    string [string] fields;
};

int parse_string(ref bson_internal self, string data){
    string key;
    int offset = parse_header(self, data, key);
    int str_len = *cast(int*) data[offset .. data.length].ptr;
    string str = data[offset + 4 .. offset + 4 + str_len];

    self.fields[key] = str;
    return offset + 4 + str_len;
}

unittest{
    bson_internal self;
    string data = "\x02hello\x00\x0e\x00\x00\x00mastring\x00cava?";

    int result = parse_string(self, data);
    assert(result == 7+4+14);
    assert(self.fields["hello"] == "mastring\x00cava?");
}

int parse_int64(ref bson_internal self, string data){
    string key;
    int offset = parse_header(self, data, key);
    long integer = *cast(long*) data[offset .. data.length].ptr;
    self.fields[key] = to!string(integer);
    return offset + 8;
}

unittest{
    bson_internal self;
    string data = "\x12hello\x00\x00\x00\x00\x00\x00\x00\x00\x00";

    int result = parse_int64(self, data);
    assert(result == 15);
    assert(self.fields["hello"] == "0");
}

int parse_header(ref bson_internal self, string data, ref string key){
    int end_key = cast(int) indexOf(data, "\x00");
    key = data[1..end_key];
    return end_key+1;
}

unittest{
    bson_internal self;
    string key;
    string data = "\x12hello\x00\x00\x00\x00\x00\x00\x00\x00\x00";

    int result = parse_header(self, data, key);
    assert(key == "hello");
    assert(result == 7);
    assert(data[result .. data.length] == "\x00\x00\x00\x00\x00\x00\x00\x00");
}

void parse_element(ref bson_internal self, string data){

    while(data.length > 0){
        switch(data[0]){
            case 0x02: // string
                int offset = parse_string(self, data);
                data = data[offset .. data.length];
                break;

            case 0x04: // array
                break;

            case 0x12: //int64
                int offset = parse_string(self, data);
                data = data[offset .. data.length];
                break;

            default:
                throw new Exception("invalid element id");
        }
    }

}

int parse_document(ref bson_internal self, string data){
    int length = *cast(int*) data.ptr;
    assert(length + 5 == data.length);

    string contain = data[4..data.length-1];

    parse_element(self, contain);

    ubyte end = data[data.length-1];

    assert(end == 0);
    return length + 5 == data.length;
}

unittest{
    bson_internal self;

    parse_document(self, "\x00\x00\x00\x00\x00");
}

string[string] parse(string data){
    bson_internal self;
    parse_document(self, data);

    return self.fields;
}


ubyte[] getFrame(File file)
{
    ubyte[4] start;
    int length = 0;
    ubyte [] document;
    ubyte[1] end;

    file.rawRead(start);
    length = *cast(int*) start.ptr;
    write(length);

    document.length = length;
    file.rawRead(document);
    file.rawRead(end);

    write(document);
    write(end);

    return start ~ document ~ end;
}

void splitBsonFile(string fileName)
{
    ubyte [][] output;
    auto file = File(fileName, "rb");

    while(file.eof() == false){
        try{
            getFrame(file);
        }
        catch(Exception e){
            break;
        }
    }

    file.close();
}

void main(string [] argv)
{
    parse("\x01\x00\x00\x00A\x00");
}
