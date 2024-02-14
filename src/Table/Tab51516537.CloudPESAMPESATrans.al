#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516537 "CloudPESA MPESA Trans"
{

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = true;
        }
        field(2; "Transaction Date"; Date)
        {
            Editable = true;
        }
        field(3; "Account No"; Code[50])
        {
            Editable = true;
        }

        field(4; Description; Text[220])
        {
            Editable = true;
        }
        field(5; Amount; Decimal)
        {
            Editable = true;
        }
        field(6; Posted; Boolean)
        {
            Editable = true;
        }
        field(7; "Transaction Type"; Text[30])
        {
        }
        field(8; "Transaction Time"; Time)
        {
        }
        field(9; "Paybill Acc Balance"; Decimal)
        {
        }
        field(10; "Document Date"; Date)
        {
        }
        field(11; "Date Posted"; Date)
        {
        }
        field(12; "Time Posted"; Date)
        {
        }
        field(13; Changed; Boolean)
        {
        }
        field(14; "Date Changed"; Date)
        {
        }
        field(15; "Time Changed"; Date)
        {
        }
        field(16; "Changed By"; Code[30])
        {
        }
        field(17; "Approved By"; Code[30])
        {
        }
        field(18; "Key Word"; Text[30])
        {
        }
        field(19; Telephone; Text[30])
        {
            Editable = true;
        }
        field(20; "Account Name"; Text[250])
        {
            Editable = true;
        }
        field(21; "Needs Manual Posting"; Boolean)
        {
            Editable = true;
        }
        field(22; "Trans Date"; DateTime)
        {
        }
        field(23; "Destination Acc"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        //ERROR('You are permitted to edit this transaction');
    end;
}



