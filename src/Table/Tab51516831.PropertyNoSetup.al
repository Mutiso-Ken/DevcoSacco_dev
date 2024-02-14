#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516831 "Property No Setup"
{

    fields
    {
        field(10;"Project Code";Code[20])
        {
            TableRelation = "Fixed Asset"."No." where ("Project Asset"=const(true));
        }
        field(11;"Property Type";Code[20])
        {
            TableRelation = "Property Sizes".Code;
        }
        field(12;NoPart;Code[10])
        {
        }
        field(13;"Starting Date";Date)
        {
        }
        field(14;"Starting No";Code[5])
        {
        }
        field(15;"Last No Used";Code[5])
        {
        }
        field(16;"Increment By";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Project Code","Property Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

