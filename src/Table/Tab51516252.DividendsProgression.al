#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516252 "Dividends Progression"
{

    fields
    {
        field(1; "Member No"; Code[20])
        {
        }
        field(2; Date; Date)
        {
        }

        field(3; "Qualifying Current Shares"; Decimal)
        {
        }
        field(4; "Gross Current Shares"; Decimal)
        {
        }
        field(5; "WTax-Current Shares"; Decimal)
        {
        }
        field(6; "Net Current Shares"; Decimal)
        {
        }
        field(7; "Qualifying FOSA Shares"; Decimal)
        {
        }
        field(8; "Gross FOSA Shares"; Decimal)
        {
        }
        field(9; "WTax-FOSA Shares"; Decimal)
        {
        }
        field(10; "Net FOSA Shares"; Decimal)
        {
        }
        field(11; "Qualifying Computer Shares"; Decimal)
        {
        }
        field(12; "Gross Computer Shares"; Decimal)
        {
        }
        field(13; "WTax-Computer Shares"; Decimal)
        {
        }
        field(14; "Net Computer Shares"; Decimal)
        {
        }
        field(15; "Qualifying Van Shares"; Decimal)
        {
        }
        field(16; "Gross Van Shares"; Decimal)
        {
        }
        field(17; "WTax-Van Shares"; Decimal)
        {
        }
        field(18; "Net Van Shares"; Decimal)
        {
        }
        field(19; "Qualifying Preferential Shares"; Decimal)
        {
        }
        field(20; "Gross Preferential Shares"; Decimal)
        {
        }
        field(21; "WTax-Preferential Shares"; Decimal)
        {
        }
        field(22; "Net Preferential Shares"; Decimal)
        {
        }
        field(23; "Qualifying Lift Shares"; Decimal)
        {
        }
        field(24; "Gross Lift Shares"; Decimal)
        {
        }
        field(25; "WTax-Lift Shares"; Decimal)
        {
        }
        field(26; "Net Lift Shares"; Decimal)
        {
        }
        field(27; "Qualifying Tambaa Shares"; Decimal)
        {
        }
        field(28; "Gross Tambaa Shares"; Decimal)
        {
        }
        field(29; "WTax-Tambaa Shares"; Decimal)
        {
        }
        field(30; "Net Tambaa Shares"; Decimal)
        {
        }
        field(31; "Qualifying Pepea Shares"; Decimal)
        {
        }
        field(32; "Gross Pepea Shares"; Decimal)
        {
        }
        field(33; "WTax-Pepea Shares"; Decimal)
        {
        }
        field(34; "Net Pepea Shares"; Decimal)
        {
        }
        field(35; "Qualifying Housing Shares"; Decimal)
        {
        }
        field(36; "Gross Housing Shares"; Decimal)
        {
        }
        field(37; "WTax-Housing Shares"; Decimal)
        {
        }
        field(38; "Net Housing Shares"; Decimal)
        {
        }
        field(39; "Last Date Modified"; Date)
        {
        }
        field(40; "Dividend Year"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Member No", Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

