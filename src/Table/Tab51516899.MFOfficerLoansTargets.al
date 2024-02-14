#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51516899 "MF Officer Loans Targets"
{
    // DrillDownPageID = UnknownPage39003962;
    // LookupPageID = UnknownPage39003962;

    fields
    {
        field(1;"Account No.";Code[10])
        {
            // TableRelation = "Loan Officers Details"."Account No." where (Status=const(Approved));

            trigger OnValidate()
            begin

                // BloanOfficer.Reset;
                // BloanOfficer.SetRange(BloanOfficer."Account No.","Account No.");
                // if BloanOfficer.Find('-') then
                // "Account Name":=BloanOfficer."Account Name";
            end;
        }
        field(2;"Account Name";Text[30])
        {
            Editable = false;
        }
        field(3;"Target Type";Option)
        {
            OptionCaption = ' ,Income,Savings Portfolio,Loan Portfolio,Disbursement,Membership,No. of Loans';
            OptionMembers = " ",Income,"Savings Portfolio","Loan Portfolio",Disbursement,Membership,"No. of Loans";
        }
        field(4;January;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(5;February;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");

                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(6;March;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(7;April;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(8;May;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(9;June;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(10;July;Decimal)
        {

            trigger OnValidate()
            begin
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(11;August;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(12;September;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(13;October;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(14;November;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Year);
                TestField("Target Type");
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(15;December;Decimal)
        {

            trigger OnValidate()
            begin
                Totals:=January+February+March+April+May+June+July+August+September+October+November+December;
            end;
        }
        field(16;Totals;Decimal)
        {
            Editable = false;
        }
        field(17;Year;Integer)
        {
        }
        field(18;Date;Date)
        {
            Editable = false;
        }
        field(19;UserID;Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(20;"Date Modified";Date)
        {
            Editable = false;
        }
        field(21;"Previous Year actual";Decimal)
        {
        }
        field(22;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));

            trigger OnValidate()
            begin
                ///ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(23;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(24;"Targets No. of Loans";Integer)
        {
            Editable = false;
        }
        field(25;"Actuals No. of Loans";Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Account No.","Target Type",Year)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
      //  BloanOfficer: Record "Loan Officers Details";
}

