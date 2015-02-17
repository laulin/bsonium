// compile with "dmd bson_field.d -unittest -main"
import std.stdio;

enum BsonFieldType : int {utf8=2, array=4, int64=18}

struct BsonField
{
    private:
        BsonFieldType type;
        string key;
        string data;

    public:
        this(BsonFieldType type, string key, string data)
        {
            this.type = type;
            this.key = key;
            this.data = data;
        }

        BsonFieldType get_type(){
            return this.type;
        }

        unittest{
            BsonField field = BsonField(BsonFieldType.utf8, "key", "data");
            assert(field.get_type(), "utf8");
        }

}
