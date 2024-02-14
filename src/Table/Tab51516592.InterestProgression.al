#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516592 "Interest Progression"
{

    fields
    {
        field(1;"Account No";Code[20])
        {
        }
        field(2;Date;Date)
        {
        }
        field(3;"Gross Interest";Decimal)
        {
        }
        field(4;"Witholding Tax";Decimal)
        {
        }
        field(5;"Net Interest";Decimal)
        {
        }
        field(6;"Qualifying Savings";Decimal)
        {
        }
        field(7;"Account Balance";Decimal)
        {
        }
        field(8;"Last Date Modified";Date)
        {
        }
        field(9;Processed;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Account No",Date)
        {
            Clustered = true;
            SumIndexFields = "Gross Interest","Net Interest","Account Balance","Qualifying Savings","Witholding Tax";
        }
    }

    fieldgroups
    {
    }
}

