#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516309 "Supervisors Approval Levels"
{

    fields
    {
        field(1;SupervisorID;Code[50])
        {
            Caption = 'User ID';
            NotBlank = true;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
               // UserMgt.LookupUserID(SupervisorID);
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
               //  UserMgt.ValidateUserID(SupervisorID);
            end;
        }
        field(2;"Maximum Approval Amount";Decimal)
        {
        }
        field(3;"Transaction Type";Option)
        {
            OptionMembers = "Cash Deposits","Cheque Deposits",Withdrawals;
        }
        field(4;"E-mail Address";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;SupervisorID,"Transaction Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserMgt: Codeunit "User Setup Management";
}

