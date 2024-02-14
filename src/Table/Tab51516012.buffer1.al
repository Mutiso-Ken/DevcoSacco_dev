#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516012 "buffer1"
{

    fields
    {
        field(1;No;Code[30])
        {
        }
        field(2;Details;Decimal)
        {
        }
        field(3;Fosa;Code[60])
        {
        }
        field(4;Detail1;Text[30])
        {
        }
        field(5;Detail2;Text[30])
        {
        }
        field(6;Details3;Text[30])
        {
        }
    }

    keys
    {
        key(Key1;No,Fosa)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

