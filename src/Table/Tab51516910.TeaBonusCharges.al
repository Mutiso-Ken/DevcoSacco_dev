#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516910 "Tea Bonus Charges"
{

    fields
    {
        field(1;"Charge Code";Integer)
        {
        }
        field(2;"Lower Band";Decimal)
        {
        }
        field(3;"Upper Band";Decimal)
        {
        }
        field(4;Charge;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Charge Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

