#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516478 "Investment General Setup"
{

    fields
    {
        field(10;"Primary Key";Code[10])
        {
        }
        field(11;"Investor Application Nos.";Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(12;"Investor Account Nos.";Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(13;"Investor Posting Group";Code[20])
        {
            TableRelation = "Investor Posting Group"."Posting Code";
        }
        field(14;"Interest Posting Group";Code[20])
        {
            TableRelation = "Investor Posting Group"."Posting Code";
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

