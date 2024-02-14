#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516830 "Property Sizes"
{

    fields
    {
        field(10;"Code";Code[20])
        {
        }
        field(11;Description;Code[10])
        {
        }
        field(12;Acreage;Decimal)
        {
            DecimalPlaces = 3:3;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

