#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516905 "LOficcer Buffer"
{

    fields
    {
        field(1;"Customer No";Code[20])
        {
        }
        field(2;"Loan Officer Name";Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Customer No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

