#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516252 "Dividends Progression"
{

    fields
    {
        field(1;"Member No";Code[20])
        {
        }
        field(2;Date;Date)
        {
        }
        field(3;"Gross Dividends";Decimal)
        {
        }
        field(4;"Witholding Tax";Decimal)
        {
        }
        field(5;"Net Dividends";Decimal)
        {
        }
        field(6;"Qualifying Shares";Decimal)
        {
        }
        field(7;Shares;Decimal)
        {
        }
        field(8;"Current Shares";Decimal)
        {
        }
        field(9;GrossINT;Decimal)
        {
        }
        field(10;GRossSCap;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Member No",Date)
        {
            Clustered = true;
            SumIndexFields = "Gross Dividends","Net Dividends",Shares,"Qualifying Shares","Witholding Tax";
        }
    }

    fieldgroups
    {
    }
}

