#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516306 "FD Interest Calculation Criter"
{

    fields
    {
        field(1;"Code";Code[30])
        {
        }
        field(2;"Minimum Amount";Decimal)
        {
            NotBlank = true;
        }
        field(3;"Maximum Amount";Decimal)
        {
            NotBlank = true;
        }
        field(4;"Interest Rate";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Code","Minimum Amount")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

