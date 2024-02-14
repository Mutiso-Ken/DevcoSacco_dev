#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516441 "Investor Interest Amounts"
{

    fields
    {
        field(10;"Investor No";Code[20])
        {
        }
        field(11;"Interest Code";Code[20])
        {
        }
        field(12;Month;Integer)
        {
        }
        field(13;Year;Integer)
        {
        }
        field(14;Day;Integer)
        {
        }
        field(15;"Principle Amount";Decimal)
        {
        }
        field(16;"Interest Amount";Decimal)
        {
        }
        field(17;Paid;Boolean)
        {
        }
        field(18;"Paying Document No";Code[20])
        {
        }
        field(19;"Paying Date";Date)
        {
        }
        field(20;"Date Name";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Investor No","Interest Code",Month,Year)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

