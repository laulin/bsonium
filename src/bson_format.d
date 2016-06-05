import bson_value;

class BSONFormat
{
    BSONValue*[] arrays;
    int[] position;

    void on_int64(BSONValue* element)
    {

    }

    void on_string(BSONValue* element)
    {

    }

    void on_bin(BSONValue* element)
    {

    }

    void on_open_array(BSONValue* element)
    {

    }

    void on_close_array(BSONValue* element)
    {

    }

    void process_element(BSONValue* element)
    {
        switch(element.type())
        {
            case BSON_TYPE.INT64:
                on_int64(element);
                break;

            case BSON_TYPE.BINARY_GENERIC:
                on_bin(element);
                break;

            case BSON_TYPE.STRING:
                on_string(element);
                break;

            case BSON_TYPE.ARRAY:
                position ~= 0;
                arrays ~= element;
                on_open_array(element);
                break;

            default:
                throw new Exception("unknown BSON type");
        }
    }

    void process(BSONValue* value)
    {
        arrays = [value];
        position = [0];

        while(arrays.length > 0)
        {
            BSONValue[] doc = arrays[$-1].array();
            BSONValue* element =  &doc[position[$-1]];
            position[$-1]++;

            process_element(element);

            if (position[$-1] == arrays[$-1].array().length)
            {
                on_close_array(arrays[$-1]);
                arrays = arrays[0 .. $-1];
                position = position[0 .. $-1];
            }
        }
    }
}
