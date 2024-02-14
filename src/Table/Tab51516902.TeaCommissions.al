#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516902 "Tea Commissions"
{

    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;"Lower Bound";Decimal)
        {
        }
        field(3;"Upper Bound";Decimal)
        {
        }
        field(4;Charge;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

