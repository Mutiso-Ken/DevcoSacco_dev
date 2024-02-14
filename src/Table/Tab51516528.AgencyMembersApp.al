#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516528 "Agency Members App"
{

    fields
    {
        field(1;"No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Account No";Code[30])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                if Accounts.Get("Account No") then begin
                "Account Name":=Accounts.Name;
                "ID No":=Accounts."ID No.";
                Telephone:=Accounts."Phone No.";
                "Bosa Number":=Accounts."BOSA Account No";


                end;
            end;
        }
        field(3;"Account Name";Text[50])
        {
        }
        field(4;Telephone;Code[20])
        {
        }
        field(5;"ID No";Code[20])
        {
        }
        field(6;Status;Option)
        {
            OptionCaption = 'Application, Pending Approval,Approved,Rejected';
            OptionMembers = Application," Pending Approval",Approved,Rejected;
        }
        field(7;"Date Applied";Date)
        {
        }
        field(8;"Time Applied";Time)
        {
        }
        field(9;"Created By";Code[100])
        {
        }
        field(10;Sent;Boolean)
        {
        }
        field(11;"No. Series";Code[20])
        {
        }
        field(12;SentToServer;Boolean)
        {
        }
        field(13;"Bosa Number";Code[50])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        SaccoNoSeries: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Accounts: Record Vendor;
}

