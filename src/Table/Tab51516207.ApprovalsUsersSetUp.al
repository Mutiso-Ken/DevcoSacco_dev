#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516207 "Approvals Users Set Up"
{

    fields
    {
        field(1;"Approval Type";Option)
        {
            OptionMembers = Loans,"Bridging Loans","Personal Loans",Refunds,"Funeral Expenses","Withdrawals - Resignation","Withdrawals - Death","Branch Loans",Journals,"File Movement","Appeal Loans";
        }
        field(2;Stage;Integer)
        {
           // TableRelation = Table51516199.Field2 where (Field1=field("Approval Type"));
        }
        field(3;"User ID";Code[20])
        {
            TableRelation = User."User Name";
        }
        field(4;Approver;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Approval Type",Stage,"User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

